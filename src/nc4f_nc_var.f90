submodule(nc4f_nc) nc4f_nc_var
implicit none (type, external)
contains

!> Read a variable's data from a netCDF dataset into a `variable_type`.
!> This elemental overload preserves the concise array-name API.
module impure elemental function get_var(nc, name) result(var)
  !> Input argument(s): `nc`.
  class(group_type), intent(in) :: nc
  !> Input argument(s): `name`.
  character(len=*), intent(in) :: name
  !> Return value: `var`.
  type(variable_type), target :: var
  type(error_type) :: err

  var = get_var_(nc, name, err)
  if (handle_err(err)) return
end function get_var

!> Read a scalar-named variable without stopping on a NetCDF failure.
module function get_var_err(nc, name, err) result(var)
  !> Input argument(s): `nc`.
  class(group_type), intent(in) :: nc
  !> Input argument(s): `name`.
  character(len=*), intent(in) :: name
  !> Output argument(s): `err`.
  type(error_type), intent(out) :: err
  !> Return value: `var`.
  type(variable_type), target :: var

  var = get_var_(nc, name, err)
end function get_var_err

!> Scalar implementation shared by the fail-fast and error-aware overloads.
function get_var_(nc, name, err) result(var)
  !> Input argument(s): `nc`.
  class(group_type), intent(in) :: nc
  !> Input argument(s): `name`.
  character(len=*), intent(in) :: name
  !> Output argument(s): `err`.
  type(error_type), intent(out) :: err
  !> Return value: `var`.
  type(variable_type), target :: var
  type(c_ptr) :: cptr
  integer(c_int) :: stat
  character(len=MAX_CHAR_LEN) :: msg

  err = error_type()
  var = inq_var_(nc, name, err)
  if (has_err(err)) return

  zero_size_var: if (var%len == 0) then
    call validate(var, context="[get_var]")
    return
  end if zero_size_var

  call initialize(var)
  call validate(var, context="[get_var]")
  cptr = buffer2cptr(var)
  write (msg, "('[get_var] Invalid variable:', 1x, a)") name
  stat = nc_get_var(nc%id, var%id, cptr)
  err = netcdf_err(stat, msg)
end function get_var_

!> Read a contiguous Fortran-order hyperslab into a `variable_type`.
module function get_vara(nc, name, start, count, err) result(var)
  !> Input argument(s): `nc`.
  class(group_type), intent(in) :: nc
  !> Input argument(s): `name`.
  character(len=*), intent(in) :: name
  !> Input argument(s): `start(:)`.
  integer, intent(in) :: start(:)
  !> Input argument(s): `count(:)`.
  integer, intent(in) :: count(:)
  !> Output argument(s): `err`.
  type(error_type), intent(out), optional :: err
  !> Return value: `var`.
  type(variable_type), target :: var
  type(error_type) :: op_err

  var = get_vara_(nc, name, start, count, op_err)
  if (present(err)) then
    err = op_err
  else if (handle_err(op_err)) then
    return
  end if
end function get_vara

!> Error-returning implementation of a Fortran-order hyperslab read.
function get_vara_(nc, name, start, count, err) result(var)
  !> Input argument(s): `nc`.
  class(group_type), intent(in) :: nc
  !> Input argument(s): `name`.
  character(len=*), intent(in) :: name
  !> Input argument(s): `start(:)`.
  integer, intent(in) :: start(:)
  !> Input argument(s): `count(:)`.
  integer, intent(in) :: count(:)
  !> Output argument(s): `err`.
  type(error_type), intent(out) :: err
  !> Return value: `var`.
  type(variable_type), target :: var
  integer(c_size_t), allocatable, target :: c_start(:), c_count(:)
  type(c_ptr) :: startp, countp, datap
  integer(c_int) :: stat
  character(len=MAX_CHAR_LEN) :: msg
  integer :: i, j, ndims
  integer(int64) :: f_start, f_count

  err = error_type()
  var = inq_var_(nc, name, err)
  if (has_err(err)) return

  ndims = size(var%dims)
  if (size(start) /= ndims .or. size(count) /= ndims) then
    err = error_type(NC_EINVAL, &
      & "[get_vara] start and count must have one entry per dimension.")
    return
  end if

  allocate (c_start(ndims), c_count(ndims))
  do i = 1, ndims
    f_start = int(start(i), int64)
    f_count = int(count(i), int64)
    if (f_start < 1) then
      err = error_type(NC_EINVALCOORDS, &
        & "[get_vara] start indices must be positive.")
      return
    end if
    if (f_count <= 0) then
      err = error_type(NC_EINVAL, "[get_vara] count entries must be positive.")
      return
    end if
    if (f_start > var%dims(i)%len .or. &
      & f_count > var%dims(i)%len - f_start + 1_int64) then
      err = error_type(NC_EEDGE, &
        & "[get_vara] Requested hyperslab exceeds a dimension bound.")
      return
    end if

    j = ndims - i + 1
    c_start(j) = int(f_start - 1_int64, c_size_t)
    c_count(j) = int(f_count, c_size_t)
    var%dims(i)%len = f_count
    var%dims(i)%is_unlim = .false.
  end do
  var%len = size(var)
  call initialize(var)
  call validate(var, context="[get_vara]")

  if (ndims > 0) then
    startp = c_loc(c_start(1))
    countp = c_loc(c_count(1))
  else
    startp = c_null_ptr
    countp = c_null_ptr
  end if
  datap = buffer2cptr(var)
  write (msg, "('[get_vara] Invalid variable:', 1x, a)") name
  stat = nc_get_vara(nc%id, var%id, startp, countp, datap)
  err = netcdf_err(stat, msg)
end function get_vara_

!> Inquire a variable's metadata without reading its data buffer.
!> This elemental overload preserves the concise array-name API.
module impure elemental function inq_var(nc, name) result(var)
  !> Input argument(s): `nc`.
  class(group_type), intent(in) :: nc
  !> Input argument(s): `name`.
  character(len=*), intent(in) :: name
  !> Return value: `var`.
  type(variable_type) :: var
  type(error_type) :: err

  var = inq_var_(nc, name, err)
  if (handle_err(err)) return
end function inq_var

!> Inquire a scalar-named variable without stopping on a NetCDF failure.
module function inq_var_err(nc, name, err) result(var)
  !> Input argument(s): `nc`.
  class(group_type), intent(in) :: nc
  !> Input argument(s): `name`.
  character(len=*), intent(in) :: name
  !> Output argument(s): `err`.
  type(error_type), intent(out) :: err
  !> Return value: `var`.
  type(variable_type) :: var

  var = inq_var_(nc, name, err)
end function inq_var_err

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

!> Write a variable's data and metadata to a netCDF dataset.
!> This elemental overload preserves the existing array-variable API.
module impure elemental subroutine put_var(nc, var)
  !> Input argument(s): `nc`.
  class(group_type), intent(in) :: nc
  !> Input argument(s): `var`.
  type(variable_type), target, intent(in) :: var
  type(error_type) :: err

  call put_var_(nc, var, err)
  if (handle_err(err)) return
end subroutine put_var

!> Write a scalar variable without stopping on a NetCDF failure.
module subroutine put_var_err(nc, var, err)
  !> Input argument(s): `nc`.
  class(group_type), intent(in) :: nc
  !> Input argument(s): `var`.
  type(variable_type), target, intent(in) :: var
  !> Output argument(s): `err`.
  type(error_type), intent(out) :: err

  call put_var_(nc, var, err)
end subroutine put_var_err

!> Write a contiguous Fortran-order hyperslab to an existing variable.
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
  type(error_type), intent(out), optional :: err
  type(error_type) :: op_err

  call put_vara_(nc, var, start, count, op_err)
  if (present(err)) then
    err = op_err
  else if (handle_err(op_err)) then
    return
  end if
end subroutine put_vara

!> Error-returning implementation of a Fortran-order hyperslab write.
subroutine put_vara_(nc, var, start, count, err)
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
end subroutine put_vara_

!> Scalar implementation shared by the fail-fast and error-aware overloads.
subroutine put_var_(nc, var, err)
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
  tmp = def_var_(nc, var, err)
  if (has_err(err)) return
  if (allocated(var%atts)) then
    call put_att_var_err(nc, tmp, err)
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
end subroutine put_var_

!> Define a variable in the netCDF file and return its `variable_type`.
module function def_var_(nc, var, err) result(new_var)
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
    new_dims(i) = def_dim_err(nc, var%dims(i), err)
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
end function def_var_

end submodule nc4f_nc_var
