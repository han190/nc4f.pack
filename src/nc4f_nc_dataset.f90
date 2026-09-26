submodule(nc4f_nc) nc4f_nc_dataset
implicit none (type, external)
contains

!> Open or create a dataset and return a `netcdf_type` handle.
module function open_netcdf(file, mode, err) result(nc)
  !> Path to the dataset file.
  character(len=*), intent(in) :: file
  !> Mode to open the file: 'r' for read, 'w' to recreate, or 'a' for
  !> read/write access to an existing dataset.
  character(len=*), intent(in), optional :: mode
  !> Optional error result. When absent, failures stop the program.
  type(error_type), intent(out), optional :: err
  !> Returned `netcdf_type` describing the opened dataset.
  type(netcdf_type) :: nc
  type(error_type) :: op_err

  nc = open_netcdf_(file, mode, op_err)
  if (present(err)) then
    err = op_err
  else if (handle_err(op_err)) then
    return
  end if
end function open_netcdf

!> Open or create a dataset and construct the operation result.
function open_netcdf_(file, mode, err) result(nc)
  !> Input argument(s): `file`.
  character(len=*), intent(in) :: file
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

    nc%file = clip(file)
    stat = nc_open(f2cstr(nc%file), NC_NOWRITE, nc%id)
    write (msg, "('[open_netcdf]', 1x, a)") nc%file
    err = netcdf_err(stat, msg)
    if (has_err(err)) return
    nc%mode = NC_NOWRITE

  case ("w", "write", "replace", "overwrite")

    nc%file = clip(file)
    write (msg, "('[open_netcdf]', 1x, a)") nc%file
    stat = nc_create(f2cstr(nc%file), ior(NC_NETCDF4, NC_CLOBBER), nc%id)
    err = netcdf_err(stat, msg)
    if (has_err(err)) return
    nc%mode = NC_NETCDF4

  case ("a", "append", "rw", "readwrite")

    nc%file = clip(file)
    stat = nc_open(f2cstr(nc%file), NC_WRITE, nc%id)
    write (msg, "('[open_netcdf]', 1x, a)") nc%file
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
  type(error_type) :: op_err

  call close_netcdf_(nc, op_err)
  if (present(err)) then
    err = op_err
  else if (handle_err(op_err)) then
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
module subroutine to_netcdf_var(file, vars, atts, err)
  !> Output file to create.
  character(len=*), intent(in) :: file
  !> Variable or array of variables to write into the file.
  type(variable_type), intent(in) :: vars(..)
  !> Optional array of global attributes to attach to the dataset.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Optional error result. When absent, failures stop the program.
  type(error_type), intent(out), optional :: err
  type(netcdf_type) :: nc
  type(error_type) :: op_err, cleanup_err
  integer :: i

  op_err = error_type()
  nc = open_netcdf_(file, mode="w", err=op_err)
  if (.not. has_err(op_err)) then
    select rank (items => vars)
    rank (0)
      call put_var(nc, items, op_err)
    rank (1)
      do i = 1, size(items)
        call put_var(nc, items(i), op_err)
        if (has_err(op_err)) exit
      end do
    rank default
      op_err = error_type(NC_EINVAL, &
        & "[to_netcdf_var] Expected a scalar or rank-one variable array.")
    end select

    if (.not. has_err(op_err) .and. present(atts)) then
      nc%atts = atts
      call put_att_grp(nc, op_err)
    end if
    if (has_err(op_err)) then
      call close_netcdf_(nc, cleanup_err)
    else
      call close_netcdf_(nc, op_err)
    end if
  end if

  if (present(err)) then
    err = op_err
  else if (handle_err(op_err)) then
    return
  end if
end subroutine to_netcdf_var

!> Create a NetCDF file from a root group or direct child groups.
module subroutine to_netcdf_grp(file, grp, atts, err)
  !> Output file to create.
  character(len=*), intent(in) :: file
  !> Scalar root group or rank-one array of direct children.
  type(group_type), intent(in) :: grp(..)
  !> Optional additional global attributes for the file root.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Optional error result. When absent, failures stop the program.
  type(error_type), intent(out), optional :: err
  type(error_type) :: op_err, cleanup_err
  type(group_type) :: file_root
  type(netcdf_type) :: nc

  op_err = error_type()
  nc = open_netcdf_(file, mode="w", err=op_err)
  if (.not. has_err(op_err)) then
    file_root%id = nc%id
    file_root%name = "/"
    select rank (items => grp)
    rank (0)
      call serialize_grp(file_root, items, atts, op_err)
    rank (1)
      call serialize_grps(file_root, items, atts, op_err)
    rank default
      op_err = error_type(NC_EINVAL, &
        & "[to_netcdf_grp] Expected a scalar or rank-one group array.")
    end select
    if (has_err(op_err)) then
      call close_netcdf_(nc, cleanup_err)
    else
      call close_netcdf_(nc, op_err)
    end if
  end if

  if (present(err)) then
    err = op_err
  else if (handle_err(op_err)) then
    return
  end if
end subroutine to_netcdf_grp

end submodule nc4f_nc_dataset
