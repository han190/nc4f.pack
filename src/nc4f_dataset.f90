submodule(nc4f) nc4f_dataset
implicit none (type, external)
contains

!> Open or create a dataset and return a `netcdf_type` handle.
module function open_dataset(filename, mode, inq_dims, inq_atts, exist) result(nc)
  !> Path to the dataset file.
  character(len=*), intent(in) :: filename
  !> Mode to open the file in: 'r' for read, 'w' for write.
  character(len=*), intent(in), optional :: mode
  !> When true, inquire dimensions after opening the file.
  logical, intent(in), optional :: inq_dims
  !> When true, inquire global attributes after opening the file.
  logical, intent(in), optional :: inq_atts
  !> Check if file exists (only valid when mode is 'r').
  logical, intent(out), optional :: exist
  !> Returned `netcdf_type` describing the opened dataset.
  type(netcdf_type) :: nc
  logical :: atts_exist
  character(len=MAX_CHAR_LEN) :: msg, open_mode
  integer(c_int) :: stat

  if (present(mode)) then
    open_mode = trim(mode)
  else
    open_mode = "r"
  end if

  select case (trim(open_mode))
  case ("r", "read")

    nc%filename = clip(filename)
    stat = nc_open(f2cstr(nc%filename), NC_NOWRITE, nc%id)
    if (present(exist)) then
      exist = stat == NC_NOERR
      if (.not. exist) return
    end if

    write (msg, "('[open_dataset]', 1x, a)") nc%filename
    call handle_error(stat, msg)
    nc%mode = NC_NOWRITE
    if (optval(.false., inq_dims)) nc%dims = inq_dims_nc(nc)
    if (optval(.false., inq_atts)) then
      nc%atts = get_atts_nc(nc, atts_exist)
      if (.not. atts_exist .and. allocated(nc%atts)) deallocate (nc%atts)
    end if

  case ("w", "write")

    nc%filename = clip(filename)
    write (msg, "('[open_dataset]', 1x, a)") nc%filename
    call handle_error(nc_create(f2cstr(nc%filename), NC_NETCDF4, nc%id), msg)
    nc%mode = NC_NETCDF4
    if (allocated(nc%atts)) deallocate (nc%atts)
    if (allocated(nc%dims)) deallocate (nc%dims)

  case default
    write (msg, "('[open_dataset]', 1x, 'Invalid mode:', 1x, a)") mode
    error stop trim(msg)
  end select
end function open_dataset

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
module subroutine close_dataset(nc)
  !> `netcdf_type` representing the open dataset to close.
  type(netcdf_type), intent(inout) :: nc
  call handle_error(nc_close(nc%id))
  if (allocated(nc%atts)) deallocate (nc%atts)
  if (allocated(nc%dims)) deallocate (nc%dims)
end subroutine close_dataset

!> Create a netCDF file from an array of `variable_type` objects.
module subroutine to_netcdf_vars(filename, vars, atts)
  !> Output filename to create.
  character(len=*), intent(in) :: filename
  !> Array of variables to write into the file.
  type(variable_type), intent(in) :: vars(:)
  !> Optional array of global attributes to attach to the dataset.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Internal `netcdf_type` handle used during writing.
  type(netcdf_type) :: nc

  nc = open_dataset(filename, "w")
  call put_var(nc, vars)
  if (present(atts)) then
    nc%atts = atts
    call put_attribute(nc)
  end if
  call close_dataset(nc)
end subroutine to_netcdf_vars

!> Create a netCDF file and write a single `variable_type` object.
module subroutine to_netcdf_var(filename, var, atts)
  !> Output filename to create.
  character(len=*), intent(in) :: filename
  !> Variable to write into the file.
  type(variable_type), intent(in) :: var
  !> Optional array of global attributes to attach to the dataset.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Internal `netcdf_type` handle used during writing.
  type(netcdf_type) :: nc

  nc = open_dataset(filename, "w")
  call put_var(nc, var)
  if (present(atts)) then
    nc%atts = atts
    call put_attribute(nc)
  end if
  call close_dataset(nc)
end subroutine to_netcdf_var

end submodule nc4f_dataset
