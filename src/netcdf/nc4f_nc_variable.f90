submodule(nc4f_nc) nc4f_nc_variable
implicit none (type, external)
contains

module subroutine rename_var_nc_var(grp, var, new_name, update_file, err)
  !! Rename the supplied variable, optionally updating its name in the file.
  !! grp%vars and other copies are not synchronized; the old name selects the
  !! target.
  class(group_type), intent(in) :: grp
  !! Open group containing the supplied variable when a file update is
  !! requested.
  type(variable_type), intent(inout) :: var
  !! Variable whose local name is changed; its metadata and storage are
  !! preserved.
  character(len=*), intent(in) :: new_name
  !! Replacement local name; trailing Fortran blank padding is removed.
  logical, intent(in), optional :: update_file
  !! Whether to update the open NetCDF file as well as the model (default
  !! false).
  type(error_type), intent(out), optional :: err
  !! Receives the status and diagnostic; failures stop execution when omitted.
  type(error_type) :: op_err
  type(variable_type) :: staged
  logical :: write_file

  write_file = .false.
  if (present(update_file)) write_file = update_file
  if (.not. write_file) then
    call rename_variable(var, new_name, op_err)
  else if (.not. allocated(var%name)) then
    op_err = error_type(NC_EINVAL, "rename_variable", &
      & "Variable must have a name.")
  else
    ! Prepare only the new name; never copy owned data or borrowed pointers.
    call rename_variable(staged, new_name, op_err)
    if (.not. has_err(op_err)) then
      call rename_var_nc_(grp%id, var%name, staged%name, op_err)
      if (.not. has_err(op_err)) call move_alloc(staged%name, var%name)
    end if
  end if
  call return_err(op_err, err)
end subroutine rename_var_nc_var

module subroutine rename_var_nc_grp(grp, old_name, new_name, update_file, err)
  !! Rename a file variable and its matching grp%vars entry, if loaded.
  !! update_file is required to distinguish this from the model-only overload.
  class(group_type), intent(inout) :: grp
  !! Group whose direct variable collection contains the name to change.
  character(len=*), intent(in) :: old_name, new_name
  !! old_name: Existing local name to locate. new_name: Replacement local name;
  !! trailing Fortran blank padding is removed.
  logical, intent(in) :: update_file
  !! Whether to update the open NetCDF file as well as the model.
  type(error_type), intent(out), optional :: err
  !! Receives the status and diagnostic; failures stop execution when omitted.
  type(error_type) :: op_err
  type(group_type) :: staged
  integer :: i, n, pos, lo

  if (.not. update_file) then
    call rename_variable(grp, old_name, new_name, op_err)
  else
    ! Stage names alone so the pure model layer checks syntax and collisions.
    ! An unloaded/partial cache must not require or invent a full variable.
    n = 0
    lo = 1
    if (allocated(grp%vars)) then
      n = size(grp%vars)
      lo = lbound(grp%vars, 1)
    end if
    allocate (staged%vars(n + 1))
    pos = 0
    do i = 1, n
      if (.not. allocated(grp%vars(lo + i - 1)%name)) cycle
      staged%vars(i)%name = grp%vars(lo + i - 1)%name
      if (staged%vars(i)%name == trim(old_name)) pos = i
    end do
    if (pos == 0) staged%vars(n + 1)%name = trim(old_name)
    call rename_variable(staged, old_name, new_name, op_err)
    if (.not. has_err(op_err)) then
      call rename_var_nc_(grp%id, old_name, new_name, op_err)
      if (.not. has_err(op_err) .and. pos /= 0) then
        call move_alloc(staged%vars(pos)%name, grp%vars(lo + pos - 1)%name)
      end if
    end if
  end if
  call return_err(op_err, err)
end subroutine rename_var_nc_grp

subroutine rename_var_nc_(ncid, old_name, new_name, err)
  !! Resolve by name in the supplied group; stored variable IDs are not trusted.
  integer(c_int), intent(in) :: ncid
  !! Open file or group identifier used by the NetCDF C API.
  character(len=*), intent(in) :: old_name, new_name
  !! old_name: Existing local name to locate. new_name: Replacement local name;
  !! trailing Fortran blank padding is removed.
  type(error_type), intent(out) :: err
  !! Receives the operation status and diagnostic message.
  type(variable_type) :: name
  integer(c_int) :: stat, varid

  ! The data-model generic applies the private shared checker without C calls.
  call rename_variable(name, old_name, err)
  if (has_err(err)) return
  call rename_variable(name, new_name, err)
  if (has_err(err)) return
  stat = nc_inq_varid(ncid, f2cstr(old_name), varid)
  err = netcdf_err(stat, "rename_variable", "Find variable: "//trim(old_name))
  if (has_err(err)) return
  stat = nc_rename_var(ncid, varid, f2cstr(new_name))
  ! Preserve access errors, but accept an existing variable renamed to itself.
  if (trim(old_name) == trim(new_name) .and. stat == NC_ENAMEINUSE) stat = &
    & NC_NOERR
  err = netcdf_err(stat, "rename_variable", "Rename variable: "// &
    & trim(old_name)//" -> "//trim(new_name))
end subroutine rename_var_nc_

module function get_variable(nc, name, start, count, stride, err) result(var)
  !! Read a variable's data from a netCDF dataset into a `variable_type`.
  class(group_type), intent(in) :: nc
  !! Dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer, intent(in), optional :: start(:)
  !! Optional one-based Fortran-order hyperslab start indices.
  integer, intent(in), optional :: count(:)
  !! Optional hyperslab lengths.
  integer, intent(in), optional :: stride(:)
  !! Optional hyperslab strides.
  type(error_type), intent(out), optional :: err
  !! Optional operation error. When absent, failures stop the program.
  type(variable_type), target :: var
  !! Materialized variable data and metadata.
  type(error_type) :: op_err

  var = get_var_(nc, name, start, count, stride, op_err)
  call return_err(op_err, err)
end function get_variable

function get_var_(nc, name, start, count, stride, err) result(var)
  !! Read data with a required error result for the public wrapper to handle.
  class(group_type), intent(in) :: nc
  !! Open NetCDF dataset handle.
  character(len=*), intent(in) :: name
  !! Name used to identify the NetCDF object.
  integer, intent(in), optional :: start(:)
  !! Optional one-based starting indices in Fortran order.
  integer, intent(in), optional :: count(:)
  !! Optional element counts in Fortran order; requires start.
  integer, intent(in), optional :: stride(:)
  !! Optional index spacing in Fortran order; requires start and count.
  type(error_type), intent(out) :: err
  !! Error object updated if the operation fails.
  type(variable_type), target :: var
  !! Result produced by this operation.
  type(c_ptr) :: cptr, startp, countp, stridep
  integer(c_size_t), allocatable, target :: c_start(:), c_count(:)
  integer(c_ptrdiff_t), allocatable, target :: c_stride(:)
  integer(c_int) :: stat
  character(len=MAX_CHAR_LEN) :: msg
  integer(int64), allocatable :: starts(:), counts(:), strides(:)
  integer :: i, ndims
  integer(int64) :: f_start, f_count, f_stride, nelems

  err = error_type()
  var = inq_var_(nc, name, err)
  if (has_err(err)) return

  if (present(count) .and. .not. present(start) .or. &
    & present(stride) .and. (.not. present(start) .or. &
    & .not. present(count))) then
    err = error_type(NC_EINVAL, "get_variable", &
      & "count requires start; stride requires start and count.")
    return
  end if

  if (var%len == 0 .and. .not. present(start)) then
    call validate(var, context="get_variable", err=err)
    return
  end if

  ndims = size(var%dims)
  call prepare_selection_(var%dims%len, "get_variable", &
    & starts, counts, strides, err, start, count, stride)
  if (has_err(err)) return

  if (present(start) .and. .not. present(count)) then
    counts = var%dims%len - starts + 1_int64
  end if

  do i = 1, ndims
    f_start = starts(i)
    f_count = counts(i)
    f_stride = strides(i)
    if (f_start < 1) then
      err = error_type(NC_EINVALCOORDS, "get_variable", &
        & "start indices must be positive.")
      return
    end if
    if (f_count < 1 .or. f_stride < 1) then
      err = error_type(NC_EINVAL, "get_variable", &
        & "count and stride entries must be positive.")
      return
    end if
    if (f_start > var%dims(i)%len .or. &
      & f_count - 1_int64 > (var%dims(i)%len - f_start) / f_stride) then
      err = error_type(NC_EEDGE, "get_variable", &
        & "Requested hyperslab exceeds a dimension bound.")
      return
    end if
    var%dims(i)%len = f_count
  end do
  call compute_size(var, nelems, err)
  if (.exists. err) return
  var%len = nelems

  if (var%len == 0) then
    call validate(var, context="get_variable", err=err)
    return
  end if

  call initialize(var, err)
  if (.exists. err) return
  call validate(var, context="get_variable", err=err)
  if (.exists. err) return
  call c_selection_(starts, counts, strides, c_start, c_count, c_stride)
  if (ndims > 0) then
    startp = c_loc(c_start(1))
    countp = c_loc(c_count(1))
    stridep = c_loc(c_stride(1))
  else
    startp = c_null_ptr
    countp = c_null_ptr
    stridep = c_null_ptr
  end if
  cptr = buffer2cptr(var)
  write (msg, "('Invalid variable:', 1x, a)") name
  stat = nc_get_vars(nc%id, var%id, startp, countp, stridep, cptr)
  err = netcdf_err(stat, "get_variable", msg)
end function get_var_

impure elemental module function inquire_variable(nc, name, err) result(var)
  !! Inquire a variable's metadata without reading its data buffer.
  class(group_type), intent(in) :: nc
  !! Group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to inquire.
  type(error_type), intent(out), optional :: err
  !! Optional operation error. When absent, failures stop the program.
  type(variable_type) :: var
  !! Variable metadata.
  type(error_type) :: op_err

  var = inq_var_(nc, name, op_err)
  call return_err(op_err, err)
end function inquire_variable

function inq_var_(nc, name, err) result(var)
  !! Read metadata for public inquiry and the shared read/write implementations.
  class(group_type), intent(in) :: nc
  !! Open NetCDF dataset handle.
  character(len=*), intent(in) :: name
  !! Name used to identify the NetCDF object.
  type(error_type), intent(out) :: err
  !! Error object updated if the operation fails.
  type(variable_type) :: var
  !! Result produced by this operation.
  integer(c_int) :: stat
  integer(int64) :: nelems
  character(len=MAX_CHAR_LEN) :: msg

  err = error_type()
  var%name = clip(name)
  write (msg, "(a)") var%name
  stat = nc_inq_varid(nc%id, f2cstr(var%name), var%id)
  err = netcdf_err(stat, "inquire_variable", msg)
  if (has_err(err)) return
  var%dtype = NC_NAT
  write (msg, "(2(a, 1x, i0, 1x))") "NCID", nc%id, "VARID", var%id
  stat = nc_inq_vartype(nc%id, var%id, var%dtype)
  err = netcdf_err(stat, "inquire_variable", msg)
  if (has_err(err)) return
  var%atts = get_atts_var(nc, var, err=err)
  if (has_err(err)) return
  var%dims = inq_dims_var(nc, var, err=err)
  if (has_err(err)) return
  call inquire_storage_(nc, var, err)
  if (has_err(err)) return
  call compute_size(var, nelems, err)
  if (.exists. err) return
  var%len = nelems
end function inq_var_

subroutine require_write_access_(nc, err)
  !! Use NetCDF's permission check, including for empty writes and subgroup
  !! handles. A temporary define-mode transition is restored when the file was
  !! in data mode.
  class(group_type), intent(in) :: nc
  !! Open destination dataset or subgroup; source objects and loaded caches are
  !! unchanged.
  type(error_type), intent(out) :: err
  !! Completed operation result; contains a diagnostic when the operation fails.
  integer(c_int) :: root, parent, stat

  root = nc%id
  do
    stat = nc_inq_grp_parent(root, parent)
    if (stat == NC_ENOGRP) exit
    err = netcdf_err(stat, "write_access", "Resolve root group.")
    if (has_err(err)) return
    root = parent
  end do
  stat = nc_redef(root)
  if (stat == NC_NOERR) then
    stat = nc_enddef(root)
  else if (stat == NC_EINDEFINE) then
    stat = NC_NOERR
  end if
  if (stat /= NC_NOERR) then
    err = netcdf_err(stat, "write_access", "Dataset must be writable.")
    return
  end if
  ! Enhanced-model NetCDF-4 also ends definition automatically on data writes.
  ! Leave existing define mode intact; no user-facing mode API is needed.
  err = error_type()
end subroutine require_write_access_

pure module subroutine validate_definition(name, dtype, dims, atts, err)
  !! Validate schema and attributes without requiring variable data storage.
  character(len=*), intent(in) :: name
  !! Local name of the variable to define; trailing Fortran padding is ignored.
  integer(c_int), intent(in) :: dtype
  !! Supported NetCDF primitive type code, such as NC_FLOAT or NC_INT.
  type(dimension_type), intent(in) :: dims(:)
  !! Destination dimensions in Fortran order; an empty array defines a scalar.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional attributes to validate, including the scalar matching-type
  !! _FillValue.
  type(error_type), intent(out) :: err
  !! Completed operation result; contains a diagnostic when the operation fails.
  integer :: i, j

  call validate(name, context="define_variable", err=err)
  if (has_err(err)) return
  select case (dtype)
  case (NC_BYTE, NC_CHAR, NC_SHORT, NC_INT, NC_INT64, NC_FLOAT, NC_DOUBLE)
  case default
    err = error_type(NC_EBADTYPE, "define_variable", &
      & "Unsupported variable type.")
    return
  end select
  do i = 1, size(dims)
    if (.not. allocated(dims(i)%name)) then
      err = error_type(NC_EINVAL, "define_variable", &
        & "Dimension name is not allocated.")
      return
    end if
    call validate(dims(i)%name, context="define_variable", err=err)
    if (has_err(err)) return
    if (dims(i)%len < 0 .or. (dims(i)%len == 0 .and. &
      & .not. dims(i)%is_unlim) .or. &
      & dims(i)%len > int(huge(0_c_size_t), int64)) then
      err = error_type(NC_EINVAL, "define_variable", &
        & "Invalid dimension length.")
      return
    end if
    do j = 1, i - 1
      if (dims(i)%name /= dims(j)%name) cycle
      if ((dims(i)%is_unlim .neqv. dims(j)%is_unlim) .or. &
        & dims(i)%len /= dims(j)%len) then
        err = error_type(NC_EINVAL, "define_variable", &
          & "Conflicting repeated dimension.")
        return
      end if
    end do
  end do
  if (.not. present(atts)) return
  do i = 1, size(atts)
    if (.not. allocated(atts(i)%name)) then
      err = error_type(NC_EINVAL, "define_variable", &
        & "Attribute name is not allocated.")
      return
    end if
    call validate(atts(i)%name, context="define_variable", err=err)
    if (has_err(err)) return
    call validate(atts(i), context="define_variable", err=err)
    if (has_err(err)) return
    if (atts(i)%name == "_FillValue") then
      if (atts(i)%dtype /= dtype .or. atts(i)%len /= 1) then
        err = error_type(NC_EINVAL, "define_variable", &
          & "_FillValue must be scalar and match the variable type.")
        return
      end if
    end if
    do j = 1, i - 1
      if (atts(i)%name /= atts(j)%name) cycle
      err = error_type(NC_EINVAL, "define_variable", &
        & "Duplicate attribute name.")
      return
    end do
  end do
end subroutine validate_definition

subroutine validate_storage_(storage, dtype, dims, atts, err)
  type(storage_type), intent(in) :: storage
  integer(c_int), intent(in) :: dtype
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(error_type), intent(out) :: err
  integer :: i

  err = error_type()
  if (allocated(storage%chunks)) then
    if (size(storage%chunks) /= size(dims) .or. size(dims) == 0) then
      err = error_type(NC_EINVAL, "define_variable", &
        & "Chunk rank must match non-scalar variable rank.")
      return
    end if
    if (any(storage%chunks <= 0)) then
      err = error_type(NC_EINVAL, "define_variable", &
        & "Chunk sizes must be positive.")
      return
    end if
  end if
  if (storage%deflate_level < -1 .or. storage%deflate_level > 9 .or. &
    & storage%shuffle < -1 .or. storage%shuffle > 1 .or. &
    & storage%fletcher32 < -1 .or. storage%fletcher32 > 1 .or. &
    & storage%no_fill < -1 .or. storage%no_fill > 1 .or. &
    & storage%endian < -1 .or. storage%endian > NC_ENDIAN_BIG) then
    err = error_type(NC_EINVAL, "define_variable", "Invalid storage setting.")
    return
  end if
  if (allocated(storage%fill_value)) then
    call validate(storage%fill_value, context="define_variable", err=err)
    if (has_err(err)) return
    if (storage%fill_value%len /= 1 .or. storage%fill_value%dtype /= &
      & dtype .or. storage%no_fill == 1) then
      err = error_type(NC_EINVAL, "define_variable", &
        & "Invalid custom fill value.")
      return
    end if
  end if
  if (present(atts)) then
    do i = 1, size(atts)
      if (atts(i)%name /= "_FillValue") cycle
      if (storage%no_fill == 1) then
        err = error_type(NC_EINVAL, "define_variable", &
          & "No-fill conflicts with _FillValue attribute.")
      end if
      if (allocated(storage%fill_value)) then
        if (storage%fill_value /= atts(i)) then
          err = error_type(NC_EINVAL, "define_variable", &
            & "Conflicting fill values.")
        end if
      end if
    end do
  end if
end subroutine validate_storage_

subroutine apply_storage_(nc, varid, name, storage, err)
  class(group_type), intent(in) :: nc
  integer(c_int), intent(in) :: varid
  character(len=*), intent(in) :: name
  type(storage_type), target, intent(in) :: storage
  type(error_type), intent(out) :: err
  integer(c_int) :: stat, fmt, shuffle, deflate
  integer(c_size_t), allocatable, target :: chunks(:)

  err = error_type()
  stat = nc_inq_format(nc%id, fmt)
  err = netcdf_err(stat, "define_variable", "Inquire format: "//trim(name))
  if (has_err(err)) return
  if (fmt /= NC_FORMAT_NETCDF4 .and. fmt /= NC_FORMAT_NETCDF4_CLASSIC) then
    if (allocated(storage%chunks) .or. storage%deflate_level >= 0 .or. &
      & storage%shuffle >= 0 .or. storage%fletcher32 >= 0 .or. &
      & storage%endian >= 0) then
      err = error_type(NC_EINVAL, "define_variable", &
        & "Storage filters require NetCDF-4 format.")
    end if
    if (has_err(err)) return
  end if
  if (allocated(storage%chunks)) then
    chunks = int(storage%chunks(size(storage%chunks):1:-1), c_size_t)
    stat = nc_def_var_chunking(nc%id, varid, NC_CHUNKED, c_loc(chunks(1)))
    err = netcdf_err(stat, "define_variable", "Set chunking: "//trim(name))
    if (has_err(err)) return
  end if
  if (storage%deflate_level >= 0 .or. storage%shuffle >= 0) then
    shuffle = max(storage%shuffle, 0_c_int)
    deflate = merge(1_c_int, 0_c_int, storage%deflate_level > 0)
    stat = nc_def_var_deflate(nc%id, varid, shuffle, deflate, &
      & max(storage%deflate_level, 0_c_int))
    err = netcdf_err(stat, "define_variable", "Set compression: "//trim(name))
    if (has_err(err)) return
  end if
  if (storage%fletcher32 >= 0) then
    stat = nc_def_var_fletcher32(nc%id, varid, storage%fletcher32)
    err = netcdf_err(stat, "define_variable", "Set checksum: "//trim(name))
    if (has_err(err)) return
  end if
  if (storage%endian >= 0) then
    stat = nc_def_var_endian(nc%id, varid, storage%endian)
    err = netcdf_err(stat, "define_variable", "Set endianness: "//trim(name))
    if (has_err(err)) return
  end if
  if (storage%no_fill >= 0 .or. allocated(storage%fill_value)) then
    if (allocated(storage%fill_value)) then
      stat = nc_def_var_fill(nc%id, varid, 0_c_int, &
        & buffer2cptr(storage%fill_value))
    else
      stat = nc_def_var_fill(nc%id, varid, max(storage%no_fill, 0_c_int), &
        & c_null_ptr)
    end if
    err = netcdf_err(stat, "define_variable", "Set fill: "//trim(name))
  end if
end subroutine apply_storage_

subroutine inquire_storage_(nc, var, err)
  class(group_type), intent(in) :: nc
  type(variable_type), intent(inout) :: var
  type(error_type), intent(out) :: err
  type(storage_type) :: storage
  integer(c_int) :: stat, fmt, layout, shuffle, deflate, level, checksum, &
    & endian, no_fill
  integer(c_size_t), allocatable, target :: chunks(:)
  integer :: rank

  err = error_type()
  stat = nc_inq_format(nc%id, fmt)
  err = netcdf_err(stat, "inquire_variable", "Inquire format: "//var%name)
  if (has_err(err)) return
  if (fmt /= NC_FORMAT_NETCDF4 .and. fmt /= NC_FORMAT_NETCDF4_CLASSIC) return
  rank = size(var%dims)
  allocate(chunks(max(rank, 1)))
  stat = nc_inq_var_chunking(nc%id, var%id, layout, c_loc(chunks(1)))
  err = netcdf_err(stat, "inquire_variable", "Inquire chunking: "//var%name)
  if (has_err(err)) return
  if (layout == NC_CHUNKED .and. rank > 0) storage%chunks = &
    & int(chunks(rank:1:-1), int64)
  stat = nc_inq_var_deflate(nc%id, var%id, shuffle, deflate, level)
  err = netcdf_err(stat, "inquire_variable", "Inquire compression: "//var%name)
  if (has_err(err)) return
  if (shuffle /= 0) storage%shuffle = shuffle
  if (deflate /= 0) storage%deflate_level = level
  stat = nc_inq_var_fletcher32(nc%id, var%id, checksum)
  err = netcdf_err(stat, "inquire_variable", "Inquire checksum: "//var%name)
  if (has_err(err)) return
  if (checksum /= 0) storage%fletcher32 = checksum
  stat = nc_inq_var_endian(nc%id, var%id, endian)
  err = netcdf_err(stat, "inquire_variable", "Inquire endianness: "//var%name)
  if (has_err(err)) return
  if (endian /= NC_ENDIAN_NATIVE) storage%endian = endian
  stat = nc_inq_var_fill(nc%id, var%id, no_fill, c_null_ptr)
  err = netcdf_err(stat, "inquire_variable", "Inquire fill: "//var%name)
  if (has_err(err)) return
  if (no_fill /= 0) storage%no_fill = 1
  if (allocated(var%atts)) then
    block
      integer :: i
      do i = 1, size(var%atts)
        if (var%atts(i)%name /= "_FillValue") cycle
        allocate(storage%fill_value)
        storage%fill_value = var%atts(i)
        exit
      end do
    end block
  end if
  if (allocated(storage%chunks) .or. storage%shuffle >= 0 .or. &
    & storage%deflate_level >= 0 .or. storage%fletcher32 >= 0 .or. &
    & storage%endian >= 0 .or. storage%no_fill >= 0 .or. &
    & allocated(storage%fill_value)) var%storage = storage
end subroutine inquire_storage_

module subroutine def_var(nc, var, err)
  !! Define a variable from metadata without reading or copying its data
  !! storage.
  class(group_type), intent(in) :: nc
  !! Open writable dataset or subgroup; loaded caches remain unchanged.
  type(variable_type), intent(in) :: var
  !! Schema providing name, type, dimensions, and attributes; the source is
  !! unchanged.
  type(error_type), intent(out), optional :: err
  !! Optional operation result; failures terminate execution when omitted.
  type(error_type) :: op_err

  if (.not. allocated(var%name) .or. .not. allocated(var%dims)) then
    op_err = error_type(NC_EINVAL, "define_variable", &
      & "Variable name and dimensions must be allocated.")
    call return_err(op_err, err)
    return
  end if
  call def_var_raw(nc, var%name, var%dtype, var%dims, var%atts, var%storage, &
    & err)
end subroutine def_var

module subroutine def_var_raw(nc, name, dtype, dims, atts, storage, err)
  !! Define a variable from explicit schema arguments without allocating data
  !! storage.
  class(group_type), intent(in) :: nc
  !! Open writable dataset or subgroup; loaded caches remain unchanged.
  character(len=*), intent(in) :: name
  !! Local variable name; trailing Fortran blank padding is ignored.
  integer(c_int), intent(in) :: dtype
  !! Supported NetCDF primitive type code, such as NC_FLOAT or NC_INT.
  type(dimension_type), intent(in) :: dims(:)
  !! Destination dimensions in Fortran order; an empty array defines a scalar.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional initial attributes, written before any variable data.
  type(storage_type), intent(in), optional :: storage
  !! Optional per-variable storage settings, applied before attributes and data.
  type(error_type), intent(out), optional :: err
  !! Optional operation result; failures terminate execution when omitted.
  type(variable_type) :: defined
  type(error_type) :: op_err
  integer(c_int) :: varid, stat
  integer(c_int), allocatable :: dimids(:)
  type(dimension_type) :: actual
  integer :: i, n
  logical :: found

  definition: block
    call validate_definition(name, dtype, dims, atts, op_err)
    if (has_err(op_err)) exit definition
    if (present(storage)) then
      call validate_storage_(storage, dtype, dims, atts, op_err)
      if (has_err(op_err)) exit definition
    end if
    stat = nc_inq_varid(nc%id, f2cstr(name), varid)
    if (stat == NC_NOERR) then
      op_err = error_type(NC_ENAMEINUSE, "define_variable", &
        & "Variable already exists: "//trim(name))
      exit definition
    end if
    if (stat /= NC_ENOTVAR) then
      op_err = netcdf_err(stat, "define_variable", &
        & "Inquire variable: "//trim(name))
      exit definition
    end if
    n = size(dims)
    do i = 1, n
      call resolve_dim(nc, dims(i), found, actual, op_err)
      if (has_err(op_err)) exit definition
    end do
    call require_write_access_(nc, op_err)
    if (has_err(op_err)) exit definition
    allocate (dimids(n))
    do i = 1, n
      actual = def_dim(nc, dims(i), op_err)
      if (has_err(op_err)) exit definition
      dimids(n-i+1) = actual%id
    end do
    stat = nc_def_var(nc%id, f2cstr(name), dtype, n, dimids, defined%id)
    op_err = netcdf_err(stat, "define_variable", &
      & "Define variable: "//trim(name))
    if (has_err(op_err)) exit definition
    if (present(storage)) then
      call apply_storage_(nc, defined%id, name, storage, op_err)
      if (has_err(op_err)) exit definition
    end if
    if (present(atts)) then
      if (present(storage)) then
        if (allocated(storage%fill_value)) then
          n = 0
          do i = 1, size(atts)
            if (atts(i)%name /= "_FillValue") n = n + 1
          end do
          allocate(defined%atts(n))
          n = 0
          do i = 1, size(atts)
            if (atts(i)%name == "_FillValue") cycle
            n = n + 1
            defined%atts(n) = atts(i)
          end do
        else
          defined%atts = atts
        end if
      else
        defined%atts = atts
      end if
    end if
    call put_att_var(nc, defined, op_err)
  end block definition
  call return_err(op_err, err)
end subroutine def_var_raw

module subroutine put_variable(nc, var, start, count, stride, err)
  !! Update data only; the file schema and attributes are preserved.
  class(group_type), intent(in) :: nc
  !! Open destination dataset or subgroup; source objects and loaded caches are
  !! unchanged.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose name selects the destination and whose storage
  !! supplies the data.
  integer, intent(in), optional :: start(:)
  !! Optional one-based Fortran-order starting indices; defaults to ones.
  integer, intent(in), optional :: count(:)
  !! Optional element counts in Fortran order; defaults to the source shape.
  integer, intent(in), optional :: stride(:)
  !! Optional positive destination strides in Fortran order; defaults to ones.
  type(error_type), intent(out), optional :: err
  !! Optional operation result; failures terminate execution when omitted.
  type(error_type) :: op_err
  type(variable_type) :: destination
  integer(int64), allocatable :: starts(:), counts(:), strides(:)
  integer(c_size_t), allocatable, target :: c_start(:), c_count(:)
  integer(c_ptrdiff_t), allocatable, target :: c_stride(:)
  type(c_ptr) :: startp, countp, stridep
  integer(c_int) :: stat
  integer :: i, ndims
  integer(int64) :: limit
  logical :: selected

  write_data: block
    op_err = error_type()
    if (.not. allocated(var%name)) then
      op_err = error_type(NC_EINVAL, "put_variable", &
        & "Source variable name is not allocated.")
      exit write_data
    end if
    call validate(var%name, context="put_variable", err=op_err)
    if (has_err(op_err)) exit write_data
    call validate(var, context="put_variable", err=op_err)
    if (has_err(op_err)) exit write_data
    destination = inq_var_(nc, var%name, op_err)
    if (has_err(op_err)) exit write_data
    ndims = size(destination%dims)
    if (size(var%dims) /= ndims .or. var%dtype /= destination%dtype) then
      op_err = error_type(NC_EINVAL, "put_variable", &
        & "Source rank and type must match the destination.")
      exit write_data
    end if
    call prepare_selection_(var%dims%len, "put_variable", &
      & starts, counts, strides, op_err, start, count, stride)
    if (has_err(op_err)) exit write_data
    selected = present(start) .or. present(count) .or. present(stride)
    limit = min(huge(0_int64), int(huge(0_c_size_t), int64))
    do i = 1, ndims
      if (.not. allocated(var%dims(i)%name)) then
        op_err = error_type(NC_EINVAL, "put_variable", &
          & "Source dimension name is not allocated.")
        exit write_data
      end if
      if (var%dims(i)%name /= destination%dims(i)%name) then
        op_err = error_type(NC_EINVAL, "put_variable", &
          & "Source dimension names/order must match the destination.")
        exit write_data
      end if
      if (starts(i) < 1 .or. starts(i) > limit) then
        op_err = error_type(NC_EINVALCOORDS, "put_variable", &
          & "Invalid start index.")
        exit write_data
      end if
      if (strides(i) < 1 .or. strides(i) > int(huge(0_c_ptrdiff_t), &
        & int64) .or. &
        & counts(i) < 0 .or. counts(i) > limit) then
        op_err = error_type(NC_EINVAL, "put_variable", &
          & "Invalid count or stride.")
        exit write_data
      end if
      if (counts(i) /= var%dims(i)%len .or. (selected .and. counts(i) == &
        & 0)) then
        op_err = error_type(NC_EINVAL, "put_variable", &
          & "Source shape must equal count; selected counts must be positive.")
        exit write_data
      end if
      if (counts(i) > 0) then
        if (counts(i) - 1 > (limit - starts(i)) / strides(i)) then
          op_err = error_type(NC_EINVAL, "put_variable", &
            & "Selection extent overflows supported indices.")
          exit write_data
        end if
        if (.not. destination%dims(i)%is_unlim) then
          if (starts(i) > destination%dims(i)%len) then
            op_err = error_type(NC_EEDGE, "put_variable", &
              & "Selection starts beyond a fixed dimension.")
            exit write_data
          end if
          if (counts(i) - 1 > (destination%dims(i)%len - starts(i)) / &
            & strides(i)) then
            op_err = error_type(NC_EEDGE, "put_variable", &
              & "Selection exceeds a fixed dimension.")
            exit write_data
          end if
        end if
      end if
    end do
    call c_selection_(starts, counts, strides, c_start, c_count, c_stride)
    startp = c_null_ptr
    countp = c_null_ptr
    stridep = c_null_ptr
    if (ndims > 0) then
      startp = c_loc(c_start(1))
      countp = c_loc(c_count(1))
      stridep = c_loc(c_stride(1))
    end if
    call require_write_access_(nc, op_err)
    if (has_err(op_err)) exit write_data
    if (any(strides /= 1)) then
      stat = nc_put_vars(nc%id, destination%id, &
        & startp, countp, stridep, buffer2cptr(var))
    else
      stat = nc_put_vara(nc%id, destination%id, &
        & startp, countp, buffer2cptr(var))
    end if
    op_err = netcdf_err(stat, "put_variable", "Write variable: "//var%name)
  end block write_data
  call return_err(op_err, err)
end subroutine put_variable

pure subroutine prepare_selection_(default_count, context, &
  & starts, counts, strides, err, start, count, stride)
  !! Check vector lengths and apply shared defaults; callers enforce
  !! operation-specific rules.
  integer(int64), intent(in) :: default_count(:)
  !! Default extents in Fortran order: file shape for reads and source shape for
  !! writes.
  character(len=*), intent(in) :: context
  !! Operation name used in selection diagnostics.
  integer(int64), allocatable, intent(out) :: starts(:)
  !! One-based starting indices in Fortran order; defaults to ones.
  integer(int64), allocatable, intent(out) :: counts(:)
  !! Element counts in Fortran order; defaults to default_count.
  integer(int64), allocatable, intent(out) :: strides(:)
  !! File index spacing in Fortran order; defaults to ones.
  type(error_type), intent(out) :: err
  !! Completed operation result; failure leaves the output vectors unallocated.
  integer, intent(in), optional :: start(:)
  !! Optional one-based starting indices, with one entry per dimension.
  integer, intent(in), optional :: count(:)
  !! Optional element counts, with one entry per dimension.
  integer, intent(in), optional :: stride(:)
  !! Optional index spacing, with one entry per dimension.
  integer :: ndims

  err = error_type()
  ndims = size(default_count)
  if (present(start)) then
    if (size(start) /= ndims) then
      err = error_type(NC_EINVAL, context, &
        & "start must have one entry per dimension.")
      return
    end if
  end if
  if (present(count)) then
    if (size(count) /= ndims) then
      err = error_type(NC_EINVAL, context, &
        & "count must have one entry per dimension.")
      return
    end if
  end if
  if (present(stride)) then
    if (size(stride) /= ndims) then
      err = error_type(NC_EINVAL, context, &
        & "stride must have one entry per dimension.")
      return
    end if
  end if
  allocate (starts(ndims), counts(ndims), strides(ndims))
  starts = 1_int64
  counts = default_count
  strides = 1_int64
  if (present(start)) starts = int(start, int64)
  if (present(count)) counts = int(count, int64)
  if (present(stride)) strides = int(stride, int64)
end subroutine prepare_selection_

pure subroutine c_selection_(starts, counts, strides, c_start, c_count, &
  & c_stride)
  !! Convert validated Fortran-order vectors to zero-based C order, including
  !! empty scalars.
  integer(int64), intent(in) :: starts(:)
  !! Validated one-based starting indices in Fortran order.
  integer(int64), intent(in) :: counts(:)
  !! Validated element counts, with the same length as starts.
  integer(int64), intent(in) :: strides(:)
  !! Validated index spacing, with the same length as starts.
  integer(c_size_t), allocatable, intent(out) :: c_start(:)
  !! Zero-based starting indices in reversed dimension order.
  integer(c_size_t), allocatable, intent(out) :: c_count(:)
  !! Element counts in reversed dimension order.
  integer(c_ptrdiff_t), allocatable, intent(out) :: c_stride(:)
  !! Index spacing in reversed dimension order.
  integer :: i, j, ndims

  ndims = size(starts)
  allocate (c_start(ndims), c_count(ndims), c_stride(ndims))
  do i = 1, ndims
    j = ndims - i + 1
    c_start(j) = int(starts(i) - 1_int64, c_size_t)
    c_count(j) = int(counts(i), c_size_t)
    c_stride(j) = int(strides(i), c_ptrdiff_t)
  end do
end subroutine c_selection_

end submodule nc4f_nc_variable
