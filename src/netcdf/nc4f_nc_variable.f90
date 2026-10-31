submodule(nc4f_nc) nc4f_nc_variable
implicit none (type, external)
contains

module subroutine rename_var_nc_var(grp, var, new_name, update_file, err)
  !! Rename the supplied variable, optionally updating its name in the file.
  !! grp%vars and other copies are not synchronized; the old name selects the target.
  class(group_type), intent(in) :: grp
  !! Open group containing the supplied variable when a file update is requested.
  type(variable_type), intent(inout) :: var
  !! Variable whose local name is changed; its metadata and storage are preserved.
  character(len=*), intent(in) :: new_name
  !! Replacement local name; trailing Fortran blank padding is removed.
  logical, intent(in), optional :: update_file
  !! Whether to update the open NetCDF file as well as the model (default false).
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
  !! old_name: Existing local name to locate.
  !! new_name: Replacement local name; trailing Fortran blank padding is removed.
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
  !! old_name: Existing local name to locate.
  !! new_name: Replacement local name; trailing Fortran blank padding is removed.
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
  if (trim(old_name) == trim(new_name) .and. stat == NC_ENAMEINUSE) stat = NC_NOERR
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
  !! Scalar implementation shared by the fail-fast and error-aware overloads.
  class(group_type), intent(in) :: nc
  !! Open NetCDF dataset handle.
  character(len=*), intent(in) :: name
  !! Name used to identify the NetCDF object.
  integer, intent(in), optional :: start(:), count(:), stride(:)
  !! Optional starting indices, extents, and strides for the requested hyperslab.
  type(error_type), intent(out) :: err
  !! Error object updated if the operation fails.
  type(variable_type), target :: var
  !! Result produced by this operation.
  type(c_ptr) :: cptr, startp, countp, stridep
  integer(c_size_t), allocatable, target :: c_start(:), c_count(:)
  integer(c_ptrdiff_t), allocatable, target :: c_stride(:)
  integer(c_int) :: stat
  character(len=MAX_CHAR_LEN) :: msg
  integer, allocatable :: start_(:), count_(:), stride_(:)
  integer :: i, j, ndims
  integer(int64) :: f_start, f_count, f_stride

  err = error_type()
  var = inq_var_(nc, name, err)
  if (has_err(err)) return

  if (present(count) .and. .not. present(start) .or. &
    & present(stride) .and. (.not. present(start) .or. .not. present(count))) then
    err = error_type(NC_EINVAL, "get_variable", &
      & "count requires start; stride requires start and count.")
    return
  end if

  if (var%len == 0 .and. .not. present(start)) then
    call validate(var, context="[get_variable]")
    return
  end if

  ndims = size(var%dims)
  if (present(start)) then
    if (size(start) /= ndims) then
      err = error_type(NC_EINVAL, "get_variable", &
        & "start must have one entry per dimension.")
      return
    end if
  end if
  if (present(count)) then
    if (size(count) /= ndims) then
      err = error_type(NC_EINVAL, "get_variable", &
        & "count must have one entry per dimension.")
      return
    end if
  end if
  if (present(stride)) then
    if (size(stride) /= ndims) then
      err = error_type(NC_EINVAL, "get_variable", &
        & "stride must have one entry per dimension.")
      return
    end if
  end if

  allocate (start_(ndims), count_(ndims), stride_(ndims))
  start_ = 1
  stride_ = 1
  do i = 1, ndims
    count_(i) = int(var%dims(i)%len)
  end do
  if (present(start)) start_ = start
  if (present(start) .and. .not. present(count)) then
    do i = 1, ndims
      count_(i) = int(var%dims(i)%len - int(start_(i), int64) + 1_int64)
    end do
  end if
  if (present(count)) count_ = count
  if (present(stride)) stride_ = stride

  do i = 1, ndims
    f_start = int(start_(i), int64)
    f_count = int(count_(i), int64)
    f_stride = int(stride_(i), int64)
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
  var%len = size(var)

  if (var%len == 0) then
    call validate(var, context="[get_variable]")
    return
  end if

  call initialize(var)
  call validate(var, context="[get_variable]")
  allocate (c_start(ndims), c_count(ndims), c_stride(ndims))
  do i = 1, ndims
    j = ndims - i + 1
    c_start(j) = int(start_(i) - 1, c_size_t)
    c_count(j) = int(count_(i), c_size_t)
    c_stride(j) = int(stride_(i), c_ptrdiff_t)
  end do
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
  !! Scalar implementation shared by the fail-fast and error-aware overloads.
  class(group_type), intent(in) :: nc
  !! Open NetCDF dataset handle.
  character(len=*), intent(in) :: name
  !! Name used to identify the NetCDF object.
  type(error_type), intent(out) :: err
  !! Error object updated if the operation fails.
  type(variable_type) :: var
  !! Result produced by this operation.
  integer(c_int) :: stat
  character(len=MAX_CHAR_LEN) :: msg

  err = error_type()
  var%name = clip(name)
  write (msg, "(a)") var%name
  stat = nc_inq_varid(nc%id, f2cstr(var%name), var%id)
  err = netcdf_err(stat, "inquire_variable", msg)
  if (has_err(err)) return
  var%dtype = inq_vartype_(nc%id, var%id, err)
  if (has_err(err)) return
  var%atts = get_atts_var(nc, var, err=err)
  if (has_err(err)) return
  var%dims = inq_dims_var(nc, var, err=err)
  if (has_err(err)) return
  var%len = size(var)
end function inq_var_

function inq_vartype_(ncid, varid, err) result(vartype)
  !! Inquire a variable's NetCDF type while allowing a status to propagate.
  integer(c_int), intent(in) :: ncid
  !! Dataset identifier.
  integer(c_int), intent(in) :: varid
  !! Variable identifier.
  type(error_type), intent(out) :: err
  !! Error object updated if the operation fails.
  integer(c_int) :: vartype
  !! Result produced by this operation.
  integer(c_int) :: stat
  character(len=MAX_CHAR_LEN) :: msg, fmt

  err = error_type()
  vartype = NC_NAT
  fmt = "(2(a, 1x, i0, 1x))"
  write (msg, fmt) "NCID", ncid, "VARID", varid
  stat = nc_inq_vartype(ncid, varid, vartype)
  err = netcdf_err(stat, "inquire_variable", msg)
end function inq_vartype_

module subroutine put_vara(nc, var, start, count, err)
  !! Error-returning implementation of a Fortran-order hyperslab write.
  class(group_type), intent(in) :: nc
  !! Open NetCDF dataset handle.
  type(variable_type), target, intent(in) :: var
  !! Variable to process.
  integer, intent(in) :: start(:)
  !! Starting indices for the requested hyperslab.
  integer, intent(in) :: count(:)
  !! Element counts for the requested hyperslab.
  type(error_type), intent(out) :: err
  !! Error object updated if the operation fails.
  type(variable_type) :: target
  integer(c_size_t), allocatable, target :: c_start(:), c_count(:)
  type(c_ptr) :: startp, countp
  integer(c_int) :: stat
  character(len=MAX_CHAR_LEN) :: msg
  integer :: i, j, ndims
  integer(int64) :: f_start, f_count

  err = error_type()
  target = inq_var_(nc, var%name, err)
  if (has_err(err)) return

  ndims = size(target%dims)
  if (size(start) /= ndims .or. size(count) /= ndims) then
    err = error_type(NC_EINVAL, "put_vara", &
      & "start and count must have one entry per dimension.")
    return
  end if
  if (.not. allocated(var%dims) .or. size(var%dims) /= ndims) then
    err = error_type(NC_EINVAL, "put_vara", &
      & "Source rank must match the destination variable.")
    return
  end if
  if (var%dtype /= target%dtype) then
    err = error_type(NC_EINVAL, "put_vara", &
      & "Source and destination variable types must match.")
    return
  end if

  call validate(var, context="[put_vara]")
  allocate (c_start(ndims), c_count(ndims))
  do i = 1, ndims
    f_start = int(start(i), int64)
    f_count = int(count(i), int64)
    if (f_start < 1) then
      err = error_type(NC_EINVALCOORDS, "put_vara", &
        & "start indices must be positive.")
      return
    end if
    if (f_count <= 0) then
      err = error_type(NC_EINVAL, "put_vara", "count entries must be positive.")
      return
    end if
    if (var%dims(i)%len /= f_count) then
      err = error_type(NC_EINVAL, "put_vara", &
        & "Source dimensions must equal count.")
      return
    end if
    if (.not. target%dims(i)%is_unlim) then
      if (f_start > target%dims(i)%len .or. &
        & f_count > target%dims(i)%len - f_start + 1_int64) then
        err = error_type(NC_EEDGE, "put_vara", &
          & "Requested hyperslab exceeds a fixed dimension bound.")
        return
      end if
    end if

    j = ndims - i + 1
    c_start(j) = int(f_start - 1_int64, c_size_t)
    c_count(j) = int(f_count, c_size_t)
  end do
  if (var%len == 0) then
    err = error_type(NC_EINVAL, "put_vara", "Source variable is empty.")
    return
  end if
  if (ndims > 0) then
    startp = c_loc(c_start(1))
    countp = c_loc(c_count(1))
  else
    startp = c_null_ptr
    countp = c_null_ptr
  end if
  write (msg, "('Invalid variable:', 1x, a)") var%name
  stat = nc_put_vara(nc%id, target%id, startp, countp, buffer2cptr(var))
  err = netcdf_err(stat, "put_vara", msg)
end subroutine put_vara

module subroutine put_var(nc, var, err)
  !! Scalar implementation shared by the fail-fast and error-aware overloads.
  class(group_type), intent(in) :: nc
  !! Open NetCDF dataset handle.
  type(variable_type), target, intent(in) :: var
  !! Variable to process.
  type(error_type), intent(out) :: err
  !! Error object updated if the operation fails.
  type(variable_type) :: tmp
  integer(c_size_t), allocatable, target :: c_start(:), c_count(:)
  type(c_ptr) :: startp, countp
  integer(c_int) :: stat
  integer :: i, j, ndims

  err = error_type()
  call validate(var, context="[put_var]")
  tmp = def_var(nc, var, err)
  if (has_err(err)) return
  if (allocated(var%atts)) then
    call put_att_var(nc, tmp, err)
    if (has_err(err)) return
  end if
  if (var%len <= 0) return

  ndims = size(var%dims)
  allocate (c_start(ndims), c_count(ndims))
  do i = 1, ndims
    j = ndims - i + 1
    c_start(j) = 0_c_size_t
    c_count(j) = int(var%dims(i)%len, c_size_t)
  end do
  if (ndims > 0) then
    startp = c_loc(c_start(1))
    countp = c_loc(c_count(1))
  else
    startp = c_null_ptr
    countp = c_null_ptr
  end if
  stat = nc_put_vara(nc%id, tmp%id, startp, countp, buffer2cptr(var))
  err = netcdf_err(stat, "put_var", "Write variable data.")
end subroutine put_var

module function def_var(nc, var, err) result(new_var)
  !! Define a variable in the netCDF file and return its `variable_type`.
  class(group_type), intent(in) :: nc
  !! Open NetCDF dataset handle.
  type(variable_type), intent(in) :: var
  !! Variable to process.
  type(error_type), intent(out) :: err
  !! Error object updated if the operation fails.
  type(variable_type) :: new_var
  !! Result produced by this operation.
  integer(c_int) :: varid, stat
  integer(c_int), allocatable :: new_dimids(:)
  type(dimension_type), allocatable :: new_dims(:)
  integer :: n, i, j

  new_var = variable_type()
  err = error_type()
  n = size(var%dims)
  allocate (new_dims(n), new_dimids(n))
  do i = 1, n
    new_dims(i) = def_dim(nc, var%dims(i), err)
    if (has_err(err)) return
  end do
  do i = 1, n
    !! Reverse dimensions because this module calls the C API.
    j = n - i + 1
    new_dimids(j) = new_dims(i)%id
  end do

  stat = nc_def_var(nc%id, f2cstr(var%name), var%dtype, size(new_dims), &
    & new_dimids, varid)
  err = netcdf_err(stat, "def_var", "Define variable.")
  if (has_err(err)) return
  new_var%id = varid
  if (allocated(var%atts)) new_var%atts = var%atts
end function def_var

end submodule nc4f_nc_variable
