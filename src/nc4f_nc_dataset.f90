submodule(nc4f_nc) nc4f_nc_dataset
implicit none (type, external)
contains

!> Open or create a dataset and return a `netcdf_type` handle.
module function open_dataset(filename, mode, inq_dims, inq_atts, error) &
  & result(nc)
  !> Path to the dataset file.
  character(len=*), intent(in) :: filename
  !> Mode to open the file: 'r' for read, 'w' to recreate, or 'a' for
  !> read/write access to an existing dataset.
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
  !> Input argument(s): `filename`.
  character(len=*), intent(in) :: filename
  !> Input argument(s): `mode`.
  character(len=*), intent(in), optional :: mode
  !> Input argument(s): `inq_dims`.
  logical, intent(in), optional :: inq_dims
  !> Input argument(s): `inq_atts`.
  logical, intent(in), optional :: inq_atts
  !> Output argument(s): `error`.
  type(error_type), intent(out) :: error
  !> Return value: `nc`.
  type(netcdf_type) :: nc
  character(len=MAX_CHAR_LEN) :: msg, open_mode
  integer(c_int) :: stat
  type(error_type) :: cleanup_error

  error = error_type()
  nc%name = "/"
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
    if (has_error(error)) return
    nc%mode = NC_NOWRITE
    if (optval(.false., inq_dims)) then
      nc%dims = inq_dims_grp(nc, error=error)
      if (has_error(error)) then
        call close_dataset_(nc, cleanup_error)
        return
      end if
    end if
    if (optval(.false., inq_atts)) then
      nc%atts = get_atts_grp(nc, error=error)
      if (has_error(error)) then
        call close_dataset_(nc, cleanup_error)
        return
      end if
    end if

  case ("w", "write", "replace", "overwrite")

    nc%filename = clip(filename)
    write (msg, "('[open_dataset]', 1x, a)") nc%filename
    stat = nc_create(f2cstr(nc%filename), ior(NC_NETCDF4, NC_CLOBBER), nc%id)
    error = make_netcdf_error(stat, msg)
    if (has_error(error)) return
    nc%mode = NC_NETCDF4

  case ("a", "append", "rw", "readwrite")

    nc%filename = clip(filename)
    stat = nc_open(f2cstr(nc%filename), NC_WRITE, nc%id)
    write (msg, "('[open_dataset]', 1x, a)") nc%filename
    error = make_netcdf_error(stat, msg)
    if (has_error(error)) return
    nc%mode = NC_WRITE
    if (optval(.false., inq_dims)) then
      nc%dims = inq_dims_grp(nc, error=error)
      if (has_error(error)) then
        call close_dataset_(nc, cleanup_error)
        return
      end if
    end if
    if (optval(.false., inq_atts)) then
      nc%atts = get_atts_grp(nc, error=error)
      if (has_error(error)) then
        call close_dataset_(nc, cleanup_error)
        return
      end if
    end if

  case default
    associate (fmt => "('[open_dataset]', 1x, 'Invalid mode:', 1x, a)")
      write (msg, fmt) trim(open_mode)
    end associate
    error = error_type(NC_EINVAL, clip(msg))
    return
  end select
end function open_dataset_

!> Compute `optval`.
elemental logical function optval(default, opt) result(val)
  !> Input argument(s): `default`.
  logical, intent(in) :: default
  !> Input argument(s): `opt`.
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
  !> Output argument(s): `error`.
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
  !> Input/output argument(s): `nc`.
  type(netcdf_type), intent(inout) :: nc
  !> Output argument(s): `error`.
  type(error_type), intent(out) :: error
  integer(c_int) :: stat

  error = error_type()
  stat = nc_close(nc%id)
  error = make_netcdf_error(stat, "[close_dataset]")
  if (has_error(error)) return
  if (allocated(nc%atts)) deallocate (nc%atts)
  if (allocated(nc%dims)) deallocate (nc%dims)
  if (allocated(nc%vars)) deallocate (nc%vars)
  if (associated(nc%grps)) nullify (nc%grps)
end subroutine close_dataset_

!> Create a netCDF file from one variable or a rank-one variable array.
module subroutine to_netcdf_var(filename, vars, atts, error)
  !> Output filename to create.
  character(len=*), intent(in) :: filename
  !> Variable or array of variables to write into the file.
  type(variable_type), intent(in) :: vars(..)
  !> Optional array of global attributes to attach to the dataset.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Optional error result. When absent, failures stop the program.
  type(error_type), intent(out), optional :: error
  type(netcdf_type) :: nc
  type(error_type) :: operation_error, cleanup_error
  integer :: i

  operation_error = error_type()
  nc = open_dataset_(filename, mode="w", error=operation_error)
  if (.not. has_error(operation_error)) then
    select rank (items => vars)
    rank (0)
      call put_var_error(nc, items, operation_error)
    rank (1)
      do i = 1, size(items)
        call put_var_error(nc, items(i), operation_error)
        if (has_error(operation_error)) exit
      end do
    rank default
      operation_error = error_type(NC_EINVAL, &
        & "[to_netcdf_var] Expected a scalar or rank-one variable array.")
    end select

    if (.not. has_error(operation_error) .and. present(atts)) then
      nc%atts = atts
      call put_att_grp_error(nc, operation_error)
    end if
    if (has_error(operation_error)) then
      call close_dataset_(nc, cleanup_error)
    else
      call close_dataset_(nc, operation_error)
    end if
  end if

  if (present(error)) then
    error = operation_error
  else if (handle_error(operation_error)) then
    return
  end if
end subroutine to_netcdf_var

!> Create a NetCDF file whose root group has the supplied group's contents.
module subroutine to_netcdf_grp(filename, grp, atts, error)
  !> Output filename to create.
  character(len=*), intent(in) :: filename
  !> In-memory group to serialize as the file root.
  type(group_type), intent(in) :: grp
  !> Optional additional global attributes for the file root.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Optional error result. When absent, failures stop the program.
  type(error_type), intent(out), optional :: error
  type(error_type) :: operation_error

  call to_netcdf_grp_(filename, grp, atts, operation_error)
  if (present(error)) then
    error = operation_error
  else if (handle_error(operation_error)) then
    return
  end if
end subroutine to_netcdf_grp

!> Create a NetCDF file with the supplied groups below a new root group.
module subroutine to_netcdf_grps(filename, grps, atts, error)
  !> Output filename to create.
  character(len=*), intent(in) :: filename
  !> In-memory groups to serialize as the root's direct children.
  type(group_type), intent(in) :: grps(:)
  !> Optional global attributes for the otherwise empty file root.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Optional error result. When absent, failures stop the program.
  type(error_type), intent(out), optional :: error
  type(error_type) :: operation_error

  call to_netcdf_grps_(filename, grps, atts, operation_error)
  if (present(error)) then
    error = operation_error
  else if (handle_error(operation_error)) then
    return
  end if
end subroutine to_netcdf_grps

!> Error-returning implementation for a group treated as the file root.
subroutine to_netcdf_grp_(filename, grp, atts, error)
  !> Input argument: `filename`.
  character(len=*), intent(in) :: filename
  !> Input argument: `grp`.
  type(group_type), intent(in) :: grp
  !> Input argument: `atts`.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Output argument: `error`.
  type(error_type), intent(out) :: error
  type(error_type) :: cleanup_error
  type(group_type) :: file_root
  type(netcdf_type) :: nc

  error = error_type()
  nc = open_dataset_(filename, mode="w", error=error)
  if (has_error(error)) return

  file_root%id = nc%id
  file_root%name = "/"
  call serialize_grp_(file_root, grp, atts, error)
  if (has_error(error)) then
    call close_dataset_(nc, cleanup_error)
    return
  end if
  call close_dataset_(nc, error)
end subroutine to_netcdf_grp_

!> Error-returning implementation for direct child groups of a new root.
subroutine to_netcdf_grps_(filename, grps, atts, error)
  !> Input argument: `filename`.
  character(len=*), intent(in) :: filename
  !> Input argument: `grps`.
  type(group_type), intent(in) :: grps(:)
  !> Input argument: `atts`.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Output argument: `error`.
  type(error_type), intent(out) :: error
  type(error_type) :: cleanup_error
  type(group_type) :: file_root
  type(netcdf_type) :: nc

  error = error_type()
  nc = open_dataset_(filename, mode="w", error=error)
  if (has_error(error)) return

  file_root%id = nc%id
  file_root%name = "/"
  call serialize_grps_(file_root, grps, atts, error)
  if (has_error(error)) then
    call close_dataset_(nc, cleanup_error)
    return
  end if
  call close_dataset_(nc, error)
end subroutine to_netcdf_grps_

end submodule nc4f_nc_dataset
