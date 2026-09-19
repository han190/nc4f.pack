submodule(nc4f_nc) nc4f_nc_dataset
implicit none (type, external)
contains

!> Open or create a dataset and return a `netcdf_type` handle.
module function open_netcdf(filename, mode, err) result(nc)
  !> Path to the dataset file.
  character(len=*), intent(in) :: filename
  !> Mode to open the file: 'r' for read, 'w' to recreate, or 'a' for
  !> read/write access to an existing dataset.
  character(len=*), intent(in), optional :: mode
  !> Optional error result. When absent, failures stop the program.
  type(error_type), intent(out), optional :: err
  !> Returned `netcdf_type` describing the opened dataset.
  type(netcdf_type) :: nc
  type(error_type) :: operation_err

  nc = open_netcdf_(filename, mode, operation_err)
  if (present(err)) then
    err = operation_err
  else if (handle_err(operation_err)) then
    return
  end if
end function open_netcdf

!> Open or create a dataset and construct the operation result.
function open_netcdf_(filename, mode, err) result(nc)
  !> Input argument(s): `filename`.
  character(len=*), intent(in) :: filename
  !> Input argument(s): `mode`.
  character(len=*), intent(in), optional :: mode
  !> Output argument(s): `err`.
  type(error_type), intent(out) :: err
  !> Return value: `nc`.
  type(netcdf_type) :: nc
  character(len=MAX_CHAR_LEN) :: msg, open_mode
  integer(c_int) :: stat

  err = error_type()
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
    write (msg, "('[open_netcdf]', 1x, a)") nc%filename
    err = netcdf_err(stat, msg)
    if (has_err(err)) return
    nc%mode = NC_NOWRITE

  case ("w", "write", "replace", "overwrite")

    nc%filename = clip(filename)
    write (msg, "('[open_netcdf]', 1x, a)") nc%filename
    stat = nc_create(f2cstr(nc%filename), ior(NC_NETCDF4, NC_CLOBBER), nc%id)
    err = netcdf_err(stat, msg)
    if (has_err(err)) return
    nc%mode = NC_NETCDF4

  case ("a", "append", "rw", "readwrite")

    nc%filename = clip(filename)
    stat = nc_open(f2cstr(nc%filename), NC_WRITE, nc%id)
    write (msg, "('[open_netcdf]', 1x, a)") nc%filename
    err = netcdf_err(stat, msg)
    if (has_err(err)) return
    nc%mode = NC_WRITE

  case default
    associate (fmt => "('[open_netcdf]', 1x, 'Invalid mode:', 1x, a)")
      write (msg, fmt) trim(open_mode)
    end associate
    err = error_type(NC_EINVAL, clip(msg))
    return
  end select
end function open_netcdf_

!> Close a dataset and free associated allocatables.
module subroutine close_netcdf(nc, err)
  !> `netcdf_type` representing the open dataset to close.
  type(netcdf_type), intent(inout) :: nc
  !> Output argument(s): `err`.
  type(error_type), intent(out), optional :: err
  type(error_type) :: operation_err

  call close_netcdf_(nc, operation_err)
  if (present(err)) then
    err = operation_err
  else if (handle_err(operation_err)) then
    return
  end if
end subroutine close_netcdf

!> Close a dataset and construct the operation result.
subroutine close_netcdf_(nc, err)
  !> Input/output argument(s): `nc`.
  type(netcdf_type), intent(inout) :: nc
  !> Output argument(s): `err`.
  type(error_type), intent(out) :: err
  integer(c_int) :: stat

  err = error_type()
  stat = nc_close(nc%id)
  err = netcdf_err(stat, "[close_netcdf]")
  if (has_err(err)) return
  if (allocated(nc%atts)) deallocate (nc%atts)
  if (allocated(nc%dims)) deallocate (nc%dims)
  if (allocated(nc%vars)) deallocate (nc%vars)
  if (associated(nc%grps)) nullify (nc%grps)
end subroutine close_netcdf_

!> Create a netCDF file from one variable or a rank-one variable array.
module subroutine to_netcdf_var(filename, vars, atts, err)
  !> Output filename to create.
  character(len=*), intent(in) :: filename
  !> Variable or array of variables to write into the file.
  type(variable_type), intent(in) :: vars(..)
  !> Optional array of global attributes to attach to the dataset.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Optional error result. When absent, failures stop the program.
  type(error_type), intent(out), optional :: err
  type(netcdf_type) :: nc
  type(error_type) :: operation_err, cleanup_err
  integer :: i

  operation_err = error_type()
  nc = open_netcdf_(filename, mode="w", err=operation_err)
  if (.not. has_err(operation_err)) then
    select rank (items => vars)
    rank (0)
      call put_var_err(nc, items, operation_err)
    rank (1)
      do i = 1, size(items)
        call put_var_err(nc, items(i), operation_err)
        if (has_err(operation_err)) exit
      end do
    rank default
      operation_err = error_type(NC_EINVAL, &
        & "[to_netcdf_var] Expected a scalar or rank-one variable array.")
    end select

    if (.not. has_err(operation_err) .and. present(atts)) then
      nc%atts = atts
      call put_att_grp_err(nc, operation_err)
    end if
    if (has_err(operation_err)) then
      call close_netcdf_(nc, cleanup_err)
    else
      call close_netcdf_(nc, operation_err)
    end if
  end if

  if (present(err)) then
    err = operation_err
  else if (handle_err(operation_err)) then
    return
  end if
end subroutine to_netcdf_var

!> Create a NetCDF file whose root group has the supplied group's contents.
module subroutine to_netcdf_grp(filename, grp, atts, err)
  !> Output filename to create.
  character(len=*), intent(in) :: filename
  !> In-memory group to serialize as the file root.
  type(group_type), intent(in) :: grp
  !> Optional additional global attributes for the file root.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Optional error result. When absent, failures stop the program.
  type(error_type), intent(out), optional :: err
  type(error_type) :: operation_err

  call to_netcdf_grp_(filename, grp, atts, operation_err)
  if (present(err)) then
    err = operation_err
  else if (handle_err(operation_err)) then
    return
  end if
end subroutine to_netcdf_grp

!> Create a NetCDF file with the supplied groups below a new root group.
module subroutine to_netcdf_grps(filename, grps, atts, err)
  !> Output filename to create.
  character(len=*), intent(in) :: filename
  !> In-memory groups to serialize as the root's direct children.
  type(group_type), intent(in) :: grps(:)
  !> Optional global attributes for the otherwise empty file root.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Optional error result. When absent, failures stop the program.
  type(error_type), intent(out), optional :: err
  type(error_type) :: operation_err

  call to_netcdf_grps_(filename, grps, atts, operation_err)
  if (present(err)) then
    err = operation_err
  else if (handle_err(operation_err)) then
    return
  end if
end subroutine to_netcdf_grps

!> Error-returning implementation for a group treated as the file root.
subroutine to_netcdf_grp_(filename, grp, atts, err)
  !> Input argument: `filename`.
  character(len=*), intent(in) :: filename
  !> Input argument: `grp`.
  type(group_type), intent(in) :: grp
  !> Input argument: `atts`.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Output argument: `err`.
  type(error_type), intent(out) :: err
  type(error_type) :: cleanup_err
  type(group_type) :: file_root
  type(netcdf_type) :: nc

  err = error_type()
  nc = open_netcdf_(filename, mode="w", err=err)
  if (has_err(err)) return

  file_root%id = nc%id
  file_root%name = "/"
  call serialize_grp_(file_root, grp, atts, err)
  if (has_err(err)) then
    call close_netcdf_(nc, cleanup_err)
    return
  end if
  call close_netcdf_(nc, err)
end subroutine to_netcdf_grp_

!> Error-returning implementation for direct child groups of a new root.
subroutine to_netcdf_grps_(filename, grps, atts, err)
  !> Input argument: `filename`.
  character(len=*), intent(in) :: filename
  !> Input argument: `grps`.
  type(group_type), intent(in) :: grps(:)
  !> Input argument: `atts`.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Output argument: `err`.
  type(error_type), intent(out) :: err
  type(error_type) :: cleanup_err
  type(group_type) :: file_root
  type(netcdf_type) :: nc

  err = error_type()
  nc = open_netcdf_(filename, mode="w", err=err)
  if (has_err(err)) return

  file_root%id = nc%id
  file_root%name = "/"
  call serialize_grps_(file_root, grps, atts, err)
  if (has_err(err)) then
    call close_netcdf_(nc, cleanup_err)
    return
  end if
  call close_netcdf_(nc, err)
end subroutine to_netcdf_grps_

end submodule nc4f_nc_dataset
