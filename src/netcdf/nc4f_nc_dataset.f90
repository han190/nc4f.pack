submodule(nc4f_nc) nc4f_nc_dataset
implicit none (type, external)
contains

module function open_netcdf(file, mode, diskless, err) result(nc)
  !! Open or create a dataset and return a `netcdf_type` handle.
  character(len=*), intent(in) :: file
  !! Path to the dataset file.
  character(len=*), intent(in), optional :: mode
  !! Disk-backed aliases: r/read, a/append, w/write. Diskless aliases: r/read,
  !! a/append, an/append_temp, w/write, wn/write_temp.
  logical, intent(in), optional :: diskless
  !! Keep the NetCDF dataset in RAM; defaults to false (disk-backed access).
  !! When true, use a diskless mode or alias listed above. a/w and their aliases
  !! save on close; an/wn and their _temp aliases discard changes. This does not
  !! write back values modified in separate Fortran objects.
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
        & "; expected r/read, a/append, an/append_temp, "// &
        & "w/write, or wn/write_temp.")
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
  nc%id = -1_c_int
  nc%mode = NC_NOWRITE
  if (allocated(nc%atts)) deallocate (nc%atts)
  if (allocated(nc%dims)) deallocate (nc%dims)
  if (allocated(nc%vars)) deallocate (nc%vars)
  if (associated(nc%grps)) nullify (nc%grps)
end subroutine close_netcdf_

module subroutine to_netcdf_var(file, vars, atts, err, mode, start, count, &
  & stride)
  !! Serialize complete variables or update one selection in an existing file.
  character(len=*), intent(in) :: file
  !! Path of the output file to create or update.
  type(variable_type), intent(in) :: vars(..)
  !! Single variable or rank-one array; selections are allowed only for a single
  !! variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional global attributes to create or update on the file root.
  type(error_type), intent(out), optional :: err
  !! Optional operation result; failures terminate execution when omitted.
  character(len=*), intent(in), optional :: mode
  !! Optional w/write (default) or a/append mode; append requires an existing
  !! file.
  integer, intent(in), optional :: start(:)
  !! Optional one-based Fortran-order starting indices; defaults to ones.
  integer, intent(in), optional :: count(:)
  !! Optional element counts in Fortran order; defaults to the source shape.
  integer, intent(in), optional :: stride(:)
  !! Optional positive destination strides in Fortran order; defaults to ones.
  type(netcdf_type) :: nc
  !! Open destination dataset or subgroup; source objects and loaded caches are
  !! unchanged.
  type(error_type) :: op_err, cleanup_err
  integer :: i
  logical :: append, selected

  call write_mode_(mode, append, op_err)
  selected = present(start) .or. present(count) .or. present(stride)
  if (.not. has_err(op_err)) then
    if (selected .and. .not. append) &
      & op_err = error_type(NC_EINVAL, "to_netcdf", &
      & "Selections require mode='a' and an existing variable.")
  end if
  if (.not. has_err(op_err)) then
    select rank (items => vars)
    rank (0)
      call check_write_source_(items, .not. append, op_err)
    rank (1)
      if (selected) then
        op_err = error_type(NC_EINVAL, "to_netcdf", &
          & "Selections require a single variable, not an array.")
      else
        do i = lbound(items, 1), ubound(items, 1)
          call check_write_source_(items(i), .not. append, op_err)
          if (has_err(op_err)) exit
        end do
      end if
    rank default
      op_err = error_type(NC_EINVAL, "to_netcdf", &
        & "Expected a scalar or rank-one variable array.")
    end select
  end if
  if (.not. has_err(op_err)) call check_global_atts_(atts, op_err)
  if (has_err(op_err)) then
    call return_err(op_err, err)
    return
  end if
  if (append) then
    nc = open_netcdf(file, mode="a", err=op_err)
  else
    nc = open_netcdf(file, mode="w", err=op_err)
  end if
  if (.not. has_err(op_err)) then
    select rank (items => vars)
    rank (0)
      call write_item_(nc, items, append, op_err, start, count, stride)
    rank (1)
      do i = lbound(items, 1), ubound(items, 1)
        call write_item_(nc, items(i), append, op_err)
        if (has_err(op_err)) exit
      end do
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

pure subroutine write_mode_(mode, append, err)
  !! Resolve the requested file-writing mode without accessing the filesystem.
  character(len=*), intent(in), optional :: mode
  !! Optional w/write (default) or a/append mode; append requires an existing
  !! file.
  logical, intent(out) :: append
  !! Whether the operation updates an existing file instead of replacing it.
  type(error_type), intent(out) :: err
  !! Completed operation result; contains a diagnostic when the operation fails.

  append = .false.
  err = error_type()
  if (.not. present(mode)) return
  select case (trim(mode))
  case ("w", "write")
  case ("a", "append")
    append = .true.
  case default
    err = error_type(NC_EINVAL, "to_netcdf", &
      & "Expected mode w/write or a/append.")
  end select
end subroutine write_mode_

pure subroutine check_write_source_(var, defining, err)
  !! Validate source storage and, when creating, its variable definition.
  type(variable_type), intent(in) :: var
  !! Source variable whose name, metadata, and backing storage are validated.
  logical, intent(in) :: defining
  !! Whether to validate metadata for creation as well as source data storage.
  type(error_type), intent(out) :: err
  !! Completed operation result; contains a diagnostic when the operation fails.

  call validate(var, context="to_netcdf", err=err)
  if (has_err(err)) return
  if (.not. allocated(var%name)) then
    err = error_type(NC_EINVAL, "to_netcdf", &
      & "Variable name is not allocated.")
    return
  end if
  call validate(var%name, context="to_netcdf", err=err)
  if (has_err(err)) return
  if (defining) call validate_definition( &
    & var%name, var%dtype, var%dims, var%atts, err)
end subroutine check_write_source_

pure subroutine check_global_atts_(atts, err)
  !! Validate global attribute names and storage before opening an output file.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional global attributes whose names and storage are checked.
  type(error_type), intent(out) :: err
  !! Completed operation result; contains a diagnostic when the operation fails.
  integer :: i

  err = error_type()
  if (.not. present(atts)) return
  do i = 1, size(atts)
    if (.not. allocated(atts(i)%name)) then
      err = error_type(NC_EINVAL, "to_netcdf", &
        & "Attribute name is not allocated.")
      return
    end if
    call validate(atts(i)%name, context="to_netcdf", err=err)
    if (has_err(err)) return
    call validate(atts(i), context="to_netcdf", err=err)
    if (has_err(err)) return
  end do
end subroutine check_global_atts_

subroutine write_item_(nc, var, append, err, start, count, stride)
  !! Create a complete missing variable or update data in an existing
  !! destination.
  class(group_type), intent(in) :: nc
  !! Open destination dataset or subgroup; source objects and loaded caches are
  !! unchanged.
  type(variable_type), intent(in) :: var
  !! Source variable whose name selects the destination and whose storage
  !! supplies the data.
  logical, intent(in) :: append
  !! Whether the operation updates an existing file instead of replacing it.
  type(error_type), intent(out) :: err
  !! Completed operation result; contains a diagnostic when the operation fails.
  integer, intent(in), optional :: start(:)
  !! Optional one-based Fortran-order starting indices; defaults to ones.
  integer, intent(in), optional :: count(:)
  !! Optional element counts in Fortran order; defaults to the source shape.
  integer, intent(in), optional :: stride(:)
  !! Optional positive destination strides in Fortran order; defaults to ones.
  integer(c_int) :: stat, varid

  if (.not. append) then
    call define_variable(nc, var, err=err)
    if (has_err(err)) return
    call put_variable(nc, var, err=err)
    return
  end if
  stat = nc_inq_varid(nc%id, f2cstr(var%name), varid)
  if (stat == NC_ENOTVAR .and. .not. &
    & (present(start) .or. present(count) .or. present(stride))) then
    call define_variable(nc, var, err=err)
    if (has_err(err)) return
    call put_variable(nc, var, err=err)
    return
  end if
  err = netcdf_err(stat, "to_netcdf", "Find destination: "//var%name)
  if (has_err(err)) return
  call put_variable(nc, var, start, count, stride, err)
end subroutine write_item_

module subroutine to_netcdf_grp(file, grp, atts, err, mode, start, count, &
  & stride)
  !! Create a NetCDF file from a root group or direct child groups.
  character(len=*), intent(in) :: file
  !! Output file to create.
  type(group_type), intent(in) :: grp(..)
  !! Scalar root group or rank-one array of direct children.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional additional global attributes for the file root.
  type(error_type), intent(out), optional :: err
  !! Optional error result. When absent, failures stop the program.
  character(len=*), intent(in), optional :: mode
  !! Optional w/write mode; append/merge is rejected for group inputs.
  integer, intent(in), optional :: start(:)
  !! Unsupported for groups; presence is rejected before opening the file.
  integer, intent(in), optional :: count(:)
  !! Unsupported for groups; presence is rejected before opening the file.
  integer, intent(in), optional :: stride(:)
  !! Unsupported for groups; presence is rejected before opening the file.
  logical :: append
  !! Whether the operation updates an existing file instead of replacing it.
  type(error_type) :: op_err, cleanup_err
  type(group_type) :: file_root
  type(netcdf_type) :: nc
  !! Open destination dataset or subgroup; source objects and loaded caches are
  !! unchanged.

  call write_mode_(mode, append, op_err)
  if (.not. has_err(op_err)) then
    if (append .or. present(start) .or. present(count) .or. present(stride)) &
      & op_err = error_type(NC_EINVAL, "to_netcdf", &
      & "Groups require overwrite mode without selections.")
  end if
  if (.not. has_err(op_err)) then
    if (rank(grp) > 1) op_err = error_type(NC_EINVAL, "to_netcdf", &
      & "Expected a scalar or rank-one group array.")
  end if
  if (.not. has_err(op_err)) call check_global_atts_(atts, op_err)
  if (has_err(op_err)) then
    call return_err(op_err, err)
    return
  end if
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
