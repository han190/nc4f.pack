submodule(nc4f_nc) nc4f_nc_dataset
implicit none (type, external)
contains

!> Open or create a dataset and return a `netcdf_type` handle.
module function open_dataset(filename, mode, inq_dims, inq_atts, error) result(nc)
  !> Path to the dataset file.
  character(len=*), intent(in) :: filename
  !> Mode to open the file in: 'r' for read, 'w' for write.
  character(len=*), intent(in), optional :: mode
  !> When true, inquire dimensions after opening the file.
  logical, intent(in), optional :: inq_dims
  !> When true, inquire global attributes after opening the file.
  logical, intent(in), optional :: inq_atts
  !> Optional error result. When absent, failures stop the program.
  type(error_type), intent(out), optional :: error
  !> Returned `netcdf_type` describing the opened dataset.
  type(netcdf_type) :: nc
  type(error_type) :: operation_error

  nc = open_dataset_(filename, mode, inq_dims, inq_atts, operation_error)
  if (present(error)) then
    error = operation_error
  else if (handle_error(operation_error)) then
    return
  end if
end function open_dataset

!> Open or create a dataset and construct the operation result.
function open_dataset_(filename, mode, inq_dims, inq_atts, error) result(nc)
  character(len=*), intent(in) :: filename
  character(len=*), intent(in), optional :: mode
  logical, intent(in), optional :: inq_dims
  logical, intent(in), optional :: inq_atts
  type(error_type), intent(out) :: error
  type(netcdf_type) :: nc
  character(len=MAX_CHAR_LEN) :: msg, open_mode
  integer(c_int) :: stat
  type(error_type) :: cleanup_error

  error = error_type()
  if (present(mode)) then
    open_mode = trim(mode)
  else
    open_mode = "r"
  end if

  select case (trim(open_mode))
  case ("r", "read")

    nc%filename = clip(filename)
    stat = nc_open(f2cstr(nc%filename), NC_NOWRITE, nc%id)
    write (msg, "('[open_dataset]', 1x, a)") nc%filename
    error = make_netcdf_error(stat, msg)
    if (is_failed(error)) return
    nc%mode = NC_NOWRITE
    if (optval(.false., inq_dims)) then
      nc%dims = inq_dims_nc(nc, error=error)
      if (is_failed(error)) then
        call close_dataset_(nc, cleanup_error)
        return
      end if
    end if
    if (optval(.false., inq_atts)) then
      nc%atts = get_atts_nc(nc, error=error)
      if (is_failed(error)) then
        call close_dataset_(nc, cleanup_error)
        return
      end if
    end if

  case ("w", "write")

    nc%filename = clip(filename)
    write (msg, "('[open_dataset]', 1x, a)") nc%filename
    stat = nc_create(f2cstr(nc%filename), NC_NETCDF4, nc%id)
    error = make_netcdf_error(stat, msg)
    if (is_failed(error)) return
    nc%mode = NC_NETCDF4
    if (allocated(nc%atts)) deallocate (nc%atts)
    if (allocated(nc%dims)) deallocate (nc%dims)

  case default
    write (msg, "('[open_dataset]', 1x, 'Invalid mode:', 1x, a)") trim(open_mode)
    error = error_type(NC_EINVAL, clip(msg))
    return
  end select
end function open_dataset_

elemental logical function optval(default, opt) result(val)
  logical, intent(in) :: default
  logical, intent(in), optional :: opt

  if (present(opt)) then
    val = opt
  else
    val = default
  end if
end function optval

!> Close a dataset and free associated allocatables.
module subroutine close_dataset(nc, error)
  !> `netcdf_type` representing the open dataset to close.
  type(netcdf_type), intent(inout) :: nc
  type(error_type), intent(out), optional :: error
  type(error_type) :: operation_error

  call close_dataset_(nc, operation_error)
  if (present(error)) then
    error = operation_error
  else if (handle_error(operation_error)) then
    return
  end if
end subroutine close_dataset

!> Close a dataset and construct the operation result.
subroutine close_dataset_(nc, error)
  type(netcdf_type), intent(inout) :: nc
  type(error_type), intent(out) :: error
  integer(c_int) :: stat

  error = error_type()
  stat = nc_close(nc%id)
  error = make_netcdf_error(stat, "[close_dataset]")
  if (is_failed(error)) return
  if (allocated(nc%atts)) deallocate (nc%atts)
  if (allocated(nc%dims)) deallocate (nc%dims)
end subroutine close_dataset_

!> Create a netCDF file from an array of `variable_type` objects.
module subroutine to_netcdf_vars(filename, vars, atts, error)
  !> Output filename to create.
  character(len=*), intent(in) :: filename
  !> Array of variables to write into the file.
  type(variable_type), intent(in) :: vars(:)
  !> Optional array of global attributes to attach to the dataset.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Optional error result. When absent, failures stop the program.
  type(error_type), intent(out), optional :: error
  type(error_type) :: operation_error

  call to_netcdf_vars_(filename, vars, atts, operation_error)
  if (present(error)) then
    error = operation_error
  else if (handle_error(operation_error)) then
    return
  end if
end subroutine to_netcdf_vars

!> Create a netCDF file from an array and construct the operation result.
subroutine to_netcdf_vars_(filename, vars, atts, error)
  character(len=*), intent(in) :: filename
  type(variable_type), intent(in) :: vars(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(error_type), intent(out) :: error
  type(netcdf_type) :: nc
  type(error_type) :: cleanup_error
  integer :: i

  error = error_type()
  nc = open_dataset_(filename, mode="w", error=error)
  if (is_failed(error)) return
  do i = 1, size(vars)
    call put_var_error(nc, vars(i), error)
    if (is_failed(error)) then
      call close_dataset_(nc, cleanup_error)
      return
    end if
  end do
  if (present(atts)) then
    nc%atts = atts
    call put_att_nc_error(nc, error)
    if (is_failed(error)) then
      call close_dataset_(nc, cleanup_error)
      return
    end if
  end if
  call close_dataset_(nc, error)
end subroutine to_netcdf_vars_

!> Create a netCDF file and write a single `variable_type` object.
module subroutine to_netcdf_var(filename, var, atts, error)
  !> Output filename to create.
  character(len=*), intent(in) :: filename
  !> Variable to write into the file.
  type(variable_type), intent(in) :: var
  !> Optional array of global attributes to attach to the dataset.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Optional error result. When absent, failures stop the program.
  type(error_type), intent(out), optional :: error
  type(error_type) :: operation_error

  call to_netcdf_var_(filename, var, atts, operation_error)
  if (present(error)) then
    error = operation_error
  else if (handle_error(operation_error)) then
    return
  end if
end subroutine to_netcdf_var

!> Create a netCDF file from one variable and construct the operation result.
subroutine to_netcdf_var_(filename, var, atts, error)
  character(len=*), intent(in) :: filename
  type(variable_type), intent(in) :: var
  type(attribute_type), intent(in), optional :: atts(:)
  type(error_type), intent(out) :: error
  type(netcdf_type) :: nc
  type(error_type) :: cleanup_error

  error = error_type()
  nc = open_dataset_(filename, mode="w", error=error)
  if (is_failed(error)) return
  call put_var_error(nc, var, error)
  if (is_failed(error)) then
    call close_dataset_(nc, cleanup_error)
    return
  end if
  if (present(atts)) then
    nc%atts = atts
    call put_att_nc_error(nc, error)
    if (is_failed(error)) then
      call close_dataset_(nc, cleanup_error)
      return
    end if
  end if
  call close_dataset_(nc, error)
end subroutine to_netcdf_var_

end submodule nc4f_nc_dataset
