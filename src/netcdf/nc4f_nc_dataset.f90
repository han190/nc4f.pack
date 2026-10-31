submodule(nc4f_nc) nc4f_nc_dataset
implicit none (type, external)
contains

module function open_netcdf(file, mode, err) result(nc)
  !! Open or create a dataset and return a `netcdf_type` handle.
  character(len=*), intent(in) :: file
  !! Path to the dataset file.
  character(len=*), intent(in), optional :: mode
  !! Mode to open the file: 'r' for read, 'w' to recreate, or 'a' for
  !! read/write access to an existing dataset.
  type(error_type), intent(out), optional :: err
  !! Optional error result. When absent, failures stop the program.
  type(netcdf_type) :: nc
  !! Returned `netcdf_type` describing the opened dataset.
  type(error_type) :: op_err

  nc = open_netcdf_(file, mode, op_err)
  call return_err(op_err, err)
end function open_netcdf

function open_netcdf_(file, mode, err) result(nc)
  !! Open or create a dataset and construct the operation result.
  character(len=*), intent(in) :: file
  !! Path of the NetCDF file to read or write.
  character(len=*), intent(in), optional :: mode
  !! File access mode: read, replace, or append, including supported aliases.
  type(error_type), intent(out) :: err
  !! Error object updated if the operation fails.
  type(netcdf_type) :: nc
  !! Result produced by this operation.
  character(len=MAX_CHAR_LEN) :: open_mode
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
    err = netcdf_err(stat, "open_netcdf", nc%file)
    if (has_err(err)) return
    nc%mode = NC_NOWRITE

  case ("w", "write", "replace", "overwrite")

    nc%file = clip(file)
    stat = nc_create(f2cstr(nc%file), ior(NC_NETCDF4, NC_CLOBBER), nc%id)
    err = netcdf_err(stat, "open_netcdf", nc%file)
    if (has_err(err)) return
    nc%mode = NC_NETCDF4

  case ("a", "append", "rw", "readwrite")

    nc%file = clip(file)
    stat = nc_open(f2cstr(nc%file), NC_WRITE, nc%id)
    err = netcdf_err(stat, "open_netcdf", nc%file)
    if (has_err(err)) return
    nc%mode = NC_WRITE

  case default
    err = error_type(NC_EINVAL, "open_netcdf", &
      & "Invalid mode: "//trim(open_mode))
    return
  end select
end function open_netcdf_

module subroutine close_netcdf(nc, err)
  !! Close a dataset and free associated allocatables.
  type(netcdf_type), intent(inout) :: nc
  !! `netcdf_type` representing the open dataset to close.
  type(error_type), intent(out), optional :: err
  !! Error object updated if the operation fails.
  type(error_type) :: op_err

  call close_netcdf_(nc, op_err)
  call return_err(op_err, err)
end subroutine close_netcdf

subroutine close_netcdf_(nc, err)
  !! Close a dataset and construct the operation result.
  type(netcdf_type), intent(inout) :: nc
  !! Open NetCDF dataset handle.
  type(error_type), intent(out) :: err
  !! Error object updated if the operation fails.
  integer(c_int) :: stat

  err = error_type()
  stat = nc_close(nc%id)
  err = netcdf_err(stat, "close_netcdf")
  if (has_err(err)) return
  if (allocated(nc%atts)) deallocate (nc%atts)
  if (allocated(nc%dims)) deallocate (nc%dims)
  if (allocated(nc%vars)) deallocate (nc%vars)
  if (associated(nc%grps)) nullify (nc%grps)
end subroutine close_netcdf_

module subroutine to_netcdf_var(file, vars, atts, err)
  !! Create a netCDF file from one variable or a rank-one variable array.
  character(len=*), intent(in) :: file
  !! Output file to create.
  type(variable_type), intent(in) :: vars(..)
  !! Variable or array of variables to write into the file.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional array of global attributes to attach to the dataset.
  type(error_type), intent(out), optional :: err
  !! Optional error result. When absent, failures stop the program.
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
      op_err = error_type(NC_EINVAL, "to_netcdf_var", &
        & "Expected a scalar or rank-one variable array.")
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

  call return_err(op_err, err)
end subroutine to_netcdf_var

module subroutine to_netcdf_grp(file, grp, atts, err)
  !! Create a NetCDF file from a root group or direct child groups.
  character(len=*), intent(in) :: file
  !! Output file to create.
  type(group_type), intent(in) :: grp(..)
  !! Scalar root group or rank-one array of direct children.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional additional global attributes for the file root.
  type(error_type), intent(out), optional :: err
  !! Optional error result. When absent, failures stop the program.
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
      op_err = error_type(NC_EINVAL, "to_netcdf_grp", &
        & "Expected a scalar or rank-one group array.")
    end select
    if (has_err(op_err)) then
      call close_netcdf_(nc, cleanup_err)
    else
      call close_netcdf_(nc, op_err)
    end if
  end if

  call return_err(op_err, err)
end subroutine to_netcdf_grp

end submodule nc4f_nc_dataset
