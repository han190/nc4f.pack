submodule(nc4f) nc4f_variable
implicit none (type, external)
contains

!> Read a variable's data from a netCDF dataset into a `variable_type`.
module impure elemental function get_var(nc, name, exist) result(var)
  !> High-level `netcdf_type` representing the open file.
  type(netcdf_type), intent(in) :: nc
  !> Name of the variable to read.
  character(len=*), intent(in) :: name
  !> Optional output flag set to true if the variable exists.
  logical, optional, intent(out) :: exist
  !> Variable object that will contain metadata and the data buffer.
  type(variable_type), target :: var
  !> C pointer to pass to the C API for reading raw data.
  type(c_ptr) :: cptr
  !> Temporary message buffer used for error reporting.
  character(len=MAX_CHAR_LEN) :: msg
  logical :: var_exist

  var = inq_var(nc, name, var_exist)
  if (present(exist)) then
    if (.not. var_exist) return
  else if (.not. var_exist) then
    error stop "[get_var] Variable "//name//"does not exist."
  end if

  zero_size_var: if (var%len == 0) then
    if (allocated(var%buffer)) deallocate (var%buffer)
    return
  end if zero_size_var

  call allocate_buffer(var)
  cptr = c_loc(var%buffer(1))
  write (msg, "('[get_var] Invalid variable:', 1x, a)") name
  call handle_error(nc_get_var(nc%id, var%id, cptr), msg)
end function get_var

!> Inquire a variable's metadata without reading its data buffer.
module impure elemental function inq_var(nc, name, exist) result(var)
  !> High-level `netcdf_type` representing the open file.
  type(netcdf_type), intent(in) :: nc
  !> Name of the variable to inquire.
  character(len=*), intent(in) :: name
  !> Optional output flag set to true if the variable exists.
  logical, optional, intent(out) :: exist
  !> Variable object containing metadata (name, type, dims, atts, len).
  type(variable_type) :: var
  !> Internal flag set when attributes are present for the variable.
  logical :: atts_exist
  !> Loop index.
  integer :: i

  var%name = clip(name)
  var%id = inq_varid(nc%id, var%name, exist)
  if (.not. exist) return
  var%dtype = inq_vartype(nc%id, var%id)
  var%atts = get_atts_var(nc, var, atts_exist)
  if (.not. atts_exist .and. allocated(var%atts)) deallocate (var%atts)
  var%dims = inq_dims_var(nc, var)
  var%len = 1
  do i = 1, size(var%dims)
    var%len = var%len*var%dims(i)%len
  end do
end function inq_var

!> Inquire the netCDF data type of a variable given `ncid` and `varid`.
impure elemental function inq_vartype(ncid, varid) result(vartype)
  !> C `ncid` for the dataset or group.
  integer(c_int), intent(in) :: ncid, varid
  !> Returned netCDF data type code (NC_* constant).
  integer(c_int) :: vartype
  !> Temporary message and format buffer used for error reporting.
  character(len=MAX_CHAR_LEN) :: msg, fmt

  fmt = "('[inq_vartype]', 2(1x, a, 1x, i0))"
  write (msg, fmt) "NCID", ncid, "VARID", varid
  call handle_error(nc_inq_vartype(ncid, varid, vartype), msg)
end function inq_vartype

!> Inquire the C `varid` for a variable name in a dataset.
impure elemental function inq_varid(ncid, name, exist) result(varid)
  !> C `ncid` for the dataset or group.
  integer(c_int), intent(in) :: ncid
  !> Name of the variable to lookup.
  character(len=*), intent(in) :: name
  !> Optional output flag set to true if the variable exists.
  logical, optional, intent(out) :: exist
  !> Returned C `varid` for the variable.
  integer(c_int) :: varid
  !> Status code returned by the C inquiry call.
  integer(c_int) :: stat
  !> Temporary message buffer used for error reporting.
  character(len=MAX_CHAR_LEN) :: msg

  stat = nc_inq_varid(ncid, f2cstr(name), varid)
  if (present(exist)) then
    exist = stat == NC_NOERR
    if (.not. exist) return
  end if

  write (msg, "('[inq_varid]', 1x, a)") name
  call handle_error(stat, msg)
end function inq_varid

!> Write a variable's data and metadata to a netCDF dataset.
module impure elemental subroutine put_var(nc, var)
  !> High-level `netcdf_type` representing the open file.
  type(netcdf_type), intent(in) :: nc
  !> Variable object containing metadata and a data buffer to write.
  type(variable_type), target, intent(in) :: var
  !> Temporary variable object used for definition and writing.
  type(variable_type) :: tmp

  tmp = def_var_(nc, var)
  if (allocated(var%atts)) call put_att_var(nc, tmp)
  call handle_error(nc_put_var(nc%id, tmp%id, c_loc(var%buffer(1))))
end subroutine put_var

!> Define a variable in the netCDF file and return its `variable_type`.
impure elemental function def_var_(nc, var) result(new_var)
  !> High-level `netcdf_type` representing the open file.
  type(netcdf_type), intent(in) :: nc
  !> Variable template describing the variable to define.
  type(variable_type), target, intent(in) :: var
  !> Returned `variable_type` representing the defined variable.
  type(variable_type) :: new_var
  !> Returned C `varid` assigned by the C API.
  integer(c_int) :: varid
  !> Array of C dimension ids used for the new variable (reversed order).
  integer(c_int), allocatable :: new_dimids(:)
  !> Array of `dimension_type` used to create the variable.
  type(dimension_type), allocatable :: new_dims(:)
  !> Number of dimensions and loop indices.
  integer :: n, i, j

  n = size(var%dims)
  allocate (new_dims(n), new_dimids(n))
  new_dims = def_dim(nc, var%dims)
  !> Reverse dimension since we use C APIs.
  do i = 1, n
    j = n - i + 1
    new_dimids(j) = new_dims(i)%id
  end do

  call handle_error(nc_def_var(nc%id, f2cstr(var%name), &
    & var%dtype, size(new_dims), new_dimids, varid))
  new_var%id = varid
  if (allocated(var%atts)) new_var%atts = var%atts
end function def_var_

!> Return the number of elements for the whole variable or a single dim.
module pure function get_size(var, dim) result(n)
  !> Variable object to inspect.
  type(variable_type), intent(in) :: var
  !> Optional 1-based dimension index. If absent, return total size.
  integer, optional, intent(in) :: dim
  !> Number of elements returned (int64).
  integer(int64) :: n
  !> Local normalized dimension index and loop index.
  integer :: dim_, i

  if (.not. allocated(var%dims)) &
    & error stop "[get_size] Invalid dims."

  if (present(dim)) then
    dim_ = dim
  else
    dim_ = 0
  end if

  n = 1
  select case (dim_)
  case (0)
    do i = 1, size(var%dims)
      n = n*var%dims(i)%len
    end do
  case (1:)
    i = size(var%dims) - dim_ + 1
    n = var%dims(i)%len
  case default
    error stop "[get_size] Invalid dim."
  end select
end function get_size

!> Return the shape (lengths) of the variable's dimensions.
module pure function get_shape(var) result(n)
  !> Variable object to inspect.
  type(variable_type), intent(in) :: var
  !> Allocatable array of dimension lengths returned (int64 each).
  integer(int64), allocatable :: n(:)
  !> Number of dimensions and loop index.
  integer :: ndims, i

  if (.not. allocated(var%dims)) &
    & error stop "[get_size] Invalid dims."
  ndims = size(var%dims)
  if (.not. allocated(n)) then
    allocate (n(ndims))
  else if (size(n) /= ndims) then
    deallocate (n)
    allocate (n(ndims))
  end if

  do i = 1, ndims
    n(i) = var%dims(i)%len
  end do
end function get_shape

!> Allocate a variable `var` using metadata from `mold`.
module pure subroutine allocate_var_mold(var, mold)
  !> Variable to allocate and initialize.
  type(variable_type), intent(inout) :: var
  !> Mold containing metadata to copy into `var`.
  type(variable_type), intent(in) :: mold

  if (allocated(mold%atts)) then
    call allocate_var_meta(var, mold%name, &
      & mold%dtype, mold%len, mold%dims, mold%atts)
  else
    call allocate_var_meta(var, mold%name, &
      & mold%dtype, mold%len, mold%dims)
  end if
end subroutine allocate_var_mold

!> Allocate variable metadata and prepare its data buffer.
module pure subroutine allocate_var_meta(var, name, dtype, len, dims, atts)
  !> Variable to initialize and allocate.
  type(variable_type), intent(inout) :: var
  !> Name to assign to the variable.
  character(len=*), intent(in) :: name
  !> NetCDF data type code (NC_* constant) for the variable.
  integer(int32), intent(in) :: dtype
  !> Total number of elements for the variable.
  integer(int64), intent(in) :: len
  !> Array of dimensions describing the variable's shape.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional array of attributes to copy into the variable.
  type(attribute_type), optional, intent(in) :: atts(:)

  var%name = name
  var%dtype = dtype
  var%len = len
  var%dims = dims
  if (present(atts)) var%atts = atts
  call allocate_buffer_var(var)
end subroutine allocate_var_meta

!> Allocate or resize the variable's data buffer according to its type.
module pure subroutine allocate_buffer_var(var)
  !> Variable whose data buffer will be allocated or resized.
  type(variable_type), intent(inout) :: var
  !> Calculated buffer size in bytes.
  integer(int64) :: buffer_size

  !> Assuming var%dtype and var%len is properly initialized.
  buffer_size = get_buffer_size(var%dtype, var%len)
  if (allocation_required(var%buffer, buffer_size)) then
    if (allocated(var%buffer)) deallocate (var%buffer)
    allocate (var%buffer(buffer_size))
  end if
end subroutine allocate_buffer_var

!> Compare two `variable_type` values for deep equality of metadata and
!> contents. Returns true when name, type, length, dims, attributes and
!> buffer contents are equal.
module elemental logical function eq_var(x, y) result(res)
  !> Left-hand variable to compare.
  type(variable_type), intent(in) :: x
  !> Right-hand variable to compare.
  type(variable_type), intent(in) :: y
  !> Internal flags for allocation checks.
  logical :: is_alloc(2)

  res = (x%name == y%name) .and. &
    & (x%dtype == y%dtype) .and. (x%len == y%len)
  if (.not. res) return

  is_alloc(1) = allocated(x%dims)
  is_alloc(2) = allocated(y%dims)

  if (all(is_alloc)) then
    res = all(x%dims == y%dims)
  else
    res = .false.
  end if
  if (.not. res) return

  is_alloc(1) = allocated(x%atts)
  is_alloc(2) = allocated(y%atts)

  if (all(is_alloc)) then
    res = all(x%atts == y%atts)
  else if (.not. any(is_alloc)) then
    res = .true.
  else
    res = .false.
  end if
  if (.not. res) return

  res = all(x%buffer == y%buffer)
end function eq_var

!> Return true when two `variable_type` values differ.
module elemental logical function neq_var(x, y) result(res)
  !> Left-hand variable to compare.
  type(variable_type), intent(in) :: x
  !> Right-hand variable to compare.
  type(variable_type), intent(in) :: y

  res = .not. eq_var(x, y)
end function neq_var

end submodule nc4f_variable
