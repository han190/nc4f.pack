submodule(nc4f_nc) nc4f_nc_variable
implicit none (type, external)
contains

!> Read a variable's data from a netCDF dataset into a `variable_type`.
module function get_variable(nc, name, start, count, stride, err) result(var)
  !> Dataset or group containing the variable.
  class(group_type), intent(in) :: nc
  !> Name of the variable to read.
  character(len=*), intent(in) :: name
  !> Optional one-based Fortran-order hyperslab start indices.
  integer, intent(in), optional :: start(:)
  !> Optional hyperslab lengths.
  integer, intent(in), optional :: count(:)
  !> Optional hyperslab strides.
  integer, intent(in), optional :: stride(:)
  !> Optional operation error. When absent, failures stop the program.
  type(error_type), intent(out), optional :: err
  !> Materialized variable data and metadata.
  type(variable_type), target :: var
  type(error_type) :: op_err

  var = get_var_(nc, name, start, count, stride, op_err)
  if (present(err)) then
    err = op_err
  else if (handle_err(op_err)) then
    return
  end if
end function get_variable

!> Scalar implementation shared by the fail-fast and error-aware overloads.
function get_var_(nc, name, start, count, stride, err) result(var)
  !> Input argument(s): `nc`.
  class(group_type), intent(in) :: nc
  !> Input argument(s): `name`.
  character(len=*), intent(in) :: name
  integer, intent(in), optional :: start(:), count(:), stride(:)
  !> Output argument(s): `err`.
  type(error_type), intent(out) :: err
  !> Return value: `var`.
  type(variable_type), target :: var
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
    err = error_type(NC_EINVAL, &
      & "[get_variable] count requires start; stride requires start and count.")
    return
  end if

  if (var%len == 0 .and. .not. present(start)) then
    call validate(var, context="[get_variable]")
    return
  end if

  ndims = size(var%dims)
  if (present(start)) then
    if (size(start) /= ndims) then
      err = error_type(NC_EINVAL, &
        & "[get_variable] start must have one entry per dimension.")
      return
    end if
  end if
  if (present(count)) then
    if (size(count) /= ndims) then
      err = error_type(NC_EINVAL, &
        & "[get_variable] count must have one entry per dimension.")
      return
    end if
  end if
  if (present(stride)) then
    if (size(stride) /= ndims) then
      err = error_type(NC_EINVAL, &
        & "[get_variable] stride must have one entry per dimension.")
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
      err = error_type(NC_EINVALCOORDS, &
        & "[get_variable] start indices must be positive.")
      return
    end if
    if (f_count < 1 .or. f_stride < 1) then
      err = error_type(NC_EINVAL, &
        & "[get_variable] count and stride entries must be positive.")
      return
    end if
    if (f_start > var%dims(i)%len .or. &
      & f_count - 1_int64 > (var%dims(i)%len - f_start) / f_stride) then
      err = error_type(NC_EEDGE, &
        & "[get_variable] Requested hyperslab exceeds a dimension bound.")
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
  write (msg, "('[get_variable] Invalid variable:', 1x, a)") name
  stat = nc_get_vars(nc%id, var%id, startp, countp, stridep, cptr)
  err = netcdf_err(stat, msg)
end function get_var_

!> Inquire a variable's metadata without reading its data buffer.
module impure elemental function inquire_variable(nc, name, err) result(var)
  !> Group containing the variable.
  class(group_type), intent(in) :: nc
  !> Name of the variable to inquire.
  character(len=*), intent(in) :: name
  !> Optional operation error. When absent, failures stop the program.
  type(error_type), intent(out), optional :: err
  !> Variable metadata.
  type(variable_type) :: var
  type(error_type) :: op_err

  var = inq_var_(nc, name, op_err)
  if (present(err)) then
    err = op_err
  else if (handle_err(op_err)) then
    return
  end if
end function inquire_variable

!> Scalar implementation shared by the fail-fast and error-aware overloads.
function inq_var_(nc, name, err) result(var)
  !> Input argument(s): `nc`.
  class(group_type), intent(in) :: nc
  !> Input argument(s): `name`.
  character(len=*), intent(in) :: name
  !> Output argument(s): `err`.
  type(error_type), intent(out) :: err
  !> Return value: `var`.
  type(variable_type) :: var
  integer(c_int) :: stat
  character(len=MAX_CHAR_LEN) :: msg

  err = error_type()
  var%name = clip(name)
  write (msg, "('[inq_varid]', 1x, a)") var%name
  stat = nc_inq_varid(nc%id, f2cstr(var%name), var%id)
  err = netcdf_err(stat, msg)
  if (has_err(err)) return
  var%dtype = inq_vartype_(nc%id, var%id, err)
  if (has_err(err)) return
  var%atts = get_atts_var(nc, var, err=err)
  if (has_err(err)) return
  var%dims = inq_dims_var(nc, var, err=err)
  if (has_err(err)) return
  var%len = size(var)
end function inq_var_

!> Inquire a variable's NetCDF type while allowing a status to propagate.
function inq_vartype_(ncid, varid, err) result(vartype)
  !> Dataset identifier.
  integer(c_int), intent(in) :: ncid
  !> Variable identifier.
  integer(c_int), intent(in) :: varid
  !> Output argument(s): `err`.
  type(error_type), intent(out) :: err
  !> Return value: `vartype`.
  integer(c_int) :: vartype
  integer(c_int) :: stat
  character(len=MAX_CHAR_LEN) :: msg, fmt

  err = error_type()
  vartype = NC_NAT
  fmt = "('[inq_vartype]', 2(1x, a, 1x, i0))"
  write (msg, fmt) "NCID", ncid, "VARID", varid
  stat = nc_inq_vartype(ncid, varid, vartype)
  err = netcdf_err(stat, msg)
end function inq_vartype_

!> Error-returning implementation of a Fortran-order hyperslab write.
module subroutine put_vara(nc, var, start, count, err)
  !> Input argument(s): `nc`.
  class(group_type), intent(in) :: nc
  !> Input argument(s): `var`.
  type(variable_type), target, intent(in) :: var
  !> Input argument(s): `start(:)`.
  integer, intent(in) :: start(:)
  !> Input argument(s): `count(:)`.
  integer, intent(in) :: count(:)
  !> Output argument(s): `err`.
  type(error_type), intent(out) :: err
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
    err = error_type(NC_EINVAL, &
      & "[put_vara] start and count must have one entry per dimension.")
    return
  end if
  if (.not. allocated(var%dims) .or. size(var%dims) /= ndims) then
    err = error_type(NC_EINVAL, &
      & "[put_vara] Source rank must match the destination variable.")
    return
  end if
  if (var%dtype /= target%dtype) then
    err = error_type(NC_EINVAL, &
      & "[put_vara] Source and destination variable types must match.")
    return
  end if

  call validate(var, context="[put_vara]")
  allocate (c_start(ndims), c_count(ndims))
  do i = 1, ndims
    f_start = int(start(i), int64)
    f_count = int(count(i), int64)
    if (f_start < 1) then
      err = error_type(NC_EINVALCOORDS, &
        & "[put_vara] start indices must be positive.")
      return
    end if
    if (f_count <= 0) then
      err = error_type(NC_EINVAL, "[put_vara] count entries must be positive.")
      return
    end if
    if (var%dims(i)%len /= f_count) then
      err = error_type(NC_EINVAL, &
        & "[put_vara] Source dimensions must equal count.")
      return
    end if
    if (.not. target%dims(i)%is_unlim) then
      if (f_start > target%dims(i)%len .or. &
        & f_count > target%dims(i)%len - f_start + 1_int64) then
        err = error_type(NC_EEDGE, &
          & "[put_vara] Requested hyperslab exceeds a fixed dimension bound.")
        return
      end if
    end if

    j = ndims - i + 1
    c_start(j) = int(f_start - 1_int64, c_size_t)
    c_count(j) = int(f_count, c_size_t)
  end do
  if (var%len == 0) then
    err = error_type(NC_EINVAL, "[put_vara] Source variable is empty.")
    return
  end if
  if (ndims > 0) then
    startp = c_loc(c_start(1))
    countp = c_loc(c_count(1))
  else
    startp = c_null_ptr
    countp = c_null_ptr
  end if
  write (msg, "('[put_vara] Invalid variable:', 1x, a)") var%name
  stat = nc_put_vara(nc%id, target%id, startp, countp, buffer2cptr(var))
  err = netcdf_err(stat, msg)
end subroutine put_vara

!> Scalar implementation shared by the fail-fast and error-aware overloads.
module subroutine put_var(nc, var, err)
  !> Input argument(s): `nc`.
  class(group_type), intent(in) :: nc
  !> Input argument(s): `var`.
  type(variable_type), target, intent(in) :: var
  !> Output argument(s): `err`.
  type(error_type), intent(out) :: err
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
  err = netcdf_err(stat, "[put_var] Write variable data.")
end subroutine put_var

!> Define a variable in the netCDF file and return its `variable_type`.
module function def_var(nc, var, err) result(new_var)
  !> Input argument(s): `nc`.
  class(group_type), intent(in) :: nc
  !> Input argument(s): `var`.
  type(variable_type), intent(in) :: var
  !> Output argument(s): `err`.
  type(error_type), intent(out) :: err
  !> Return value: `new_var`.
  type(variable_type) :: new_var
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
  !> Reverse dimensions because this module calls the C API.
  do i = 1, n
    j = n - i + 1
    new_dimids(j) = new_dims(i)%id
  end do

  stat = nc_def_var(nc%id, f2cstr(var%name), var%dtype, size(new_dims), &
    & new_dimids, varid)
  err = netcdf_err(stat, "[def_var] Define variable.")
  if (has_err(err)) return
  new_var%id = varid
  if (allocated(var%atts)) new_var%atts = var%atts
end function def_var

end submodule nc4f_nc_variable
