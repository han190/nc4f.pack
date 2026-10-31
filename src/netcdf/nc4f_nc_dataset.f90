submodule(nc4f_nc) nc4f_nc_dataset
implicit none (type, external)
contains

module function open_netcdf(file, mode, diskless, err) result(nc)
  !! Open or create a dataset and return a `netcdf_type` handle.
  character(len=*), intent(in) :: file
  !! Path to the dataset file.
  character(len=*), intent(in), optional :: mode
  !! Disk-backed aliases: r/read, a/append, w/write.
  !! Diskless aliases: r/read, a/append, an/append_temp, w/write, wn/write_temp.
  logical, intent(in), optional :: diskless
  !! Keep the NetCDF dataset in RAM; defaults to false (disk-backed access).
  !! When true, use a diskless mode or alias listed above.
  !! a/w and their aliases save on close; an/wn and their _temp aliases discard changes.
  !! This does not write back values modified in separate Fortran objects.
  type(error_type), intent(out), optional :: err
  !! Optional error result. When absent, failures stop the program.
  type(netcdf_type) :: nc
  !! Returned `netcdf_type` describing the opened dataset.
  type(error_type) :: op_err
  character(len=MAX_CHAR_LEN) :: open_mode
  integer(c_int) :: stat, flags
  logical :: in_memory, create_file

  op_err = error_type()
  nc%name = "/"
  if (present(mode)) then
    open_mode = trim(mode)
  else
    open_mode = "r"
  end if

  in_memory = .false.
  if (present(diskless)) in_memory = diskless
  create_file = .false.
  if (in_memory) then
    select case (trim(open_mode))
    case ("r", "read")
      flags = ior(NC_NOWRITE, NC_DISKLESS)
    case ("a", "an", "append", "append_temp")
      flags = ior(NC_WRITE, NC_DISKLESS)
      if (trim(open_mode) == "append" .or. &
        & trim(open_mode) == "a") flags = ior(flags, NC_PERSIST)
    case ("w", "wn", "write", "write_temp")
      create_file = .true.
      flags = ior(ior(NC_NETCDF4, NC_CLOBBER), NC_DISKLESS)
      if (trim(open_mode) == "write" .or. &
        & trim(open_mode) == "w") flags = ior(flags, NC_PERSIST)
    case default
      op_err = error_type(NC_EINVAL, "open_netcdf", &
        & "Invalid diskless mode: "//trim(open_mode)// &
        & "; expected r/read, a/append, an/append_temp, w/write, or wn/write_temp.")
      call return_err(op_err, err)
      return
    end select
  else
    select case (trim(open_mode))
    case ("r", "read")
      flags = NC_NOWRITE
    case ("w", "write")
      create_file = .true.
      flags = ior(NC_NETCDF4, NC_CLOBBER)
    case ("a", "append")
      flags = NC_WRITE
    case default
      op_err = error_type(NC_EINVAL, "open_netcdf", &
        & "Invalid mode: "//trim(open_mode))
      call return_err(op_err, err)
      return
    end select
  end if

  nc%file = clip(file)
  if (create_file) then
    stat = nc_create(f2cstr(nc%file), flags, nc%id)
  else
    stat = nc_open(f2cstr(nc%file), flags, nc%id)
  end if
  op_err = netcdf_err(stat, "open_netcdf", nc%file)
  if (.not. has_err(op_err)) nc%mode = flags
  call return_err(op_err, err)
end function open_netcdf

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
  nc = open_netcdf(file, mode="w", err=op_err)
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
  nc = open_netcdf(file, mode="w", err=op_err)
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
