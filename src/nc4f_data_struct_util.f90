submodule(nc4f_data_struct) nc4f_data_struct_util
implicit none (type, external)
contains

!> Return true when an operation reported a non-success status.
module pure elemental logical function failed_error(error) result(has_failed)
  !> Input argument(s): `error`.
  type(error_type), intent(in) :: error

  has_failed = error%code /= NC_NOERR
end function failed_error

!> Return false when an operation failed because a NetCDF object was absent.
module pure elemental logical function found_error(error) result(is_present)
  !> Input argument(s): `error`.
  type(error_type), intent(in) :: error
  !> `nc_open` may return the C system `ENOENT` value directly rather than
  !> the NetCDF-specific `NC_ENOTFOUND` status.  `ENOENT` is 2 on the
  !> supported POSIX and Windows C runtimes.
  integer(c_int), parameter :: ENOENT = 2_c_int

  select case (error%code)
  case (ENOENT, NC_ENOTFOUND, NC_ENOTVAR, NC_ENOTATT, NC_EBADDIM)
    is_present = .false.
  case default
    is_present = .true.
  end select
end function found_error

!> Check whether re-allocation of a buffer is required.
!> This compares the current buffer size with the requested target size.
module pure logical function allocation_required(buffer, bsize)
  !> Buffer array to check.
  integer(int8), allocatable, intent(in) :: buffer(:)
  !> Target buffer size required.
  integer(int64), intent(in) :: bsize

  allocation_required = .false.
  if (.not. allocated(buffer)) then
    allocation_required = .true.
  else if (size(buffer) < bsize) then
    allocation_required = .true.
  end if
end function allocation_required

!> Compute the buffer size in bytes for a given netCDF data type and
!> number of elements.
module elemental function get_buffer_size(dtype, len) result(buffer_size)
  !> NetCDF data type code (NC_* constants).
  integer(data_type), intent(in) :: dtype
  !> Number of elements of the given type.
  integer(int64), intent(in) :: len
  !> Result buffer size.
  integer(int64) :: buffer_size
  character(len=MAX_CHAR_LEN) :: data_name
  integer(int64) :: st_size

  if (len < 0) error stop &
    & "[get_buffer_size] Negative element count."

  select case (dtype)
  case (BYTE_TYPE, CHAR_TYPE)
    st_size = storage_size(0_int8, kind=int64)
  case (SHORT_TYPE)
    st_size = storage_size(0_int16, kind=int64)
  case (INT_TYPE)
    st_size = storage_size(0_int32, kind=int64)
  case (INT64_TYPE)
    st_size = storage_size(0_int64, kind=int64)
  case (FLOAT_TYPE)
    st_size = storage_size(0.0_real32, kind=int64)
  case (DOUBLE_TYPE)
    st_size = storage_size(0.0_real64, kind=int64)
  case default
    write (data_name, "(i0)") dtype
    error stop "[get_buffer_size] Unsupported type."// &
      & " Data type: "//trim(data_name)//"."
  end select
  st_size = st_size/8
  if (st_size > 0 .and. len > huge(buffer_size)/st_size) &
    & error stop "[get_buffer_size] Byte-size overflow."
  buffer_size = len*st_size
end function get_buffer_size

!> Compute a dimension product while checking invalid lengths and overflow.
module pure function checked_dim_product(dims, context) result(element_count)
  !> Input argument(s): `dims(:)`.
  type(dimension_type), intent(in) :: dims(:)
  !> Input argument(s): `context`.
  character(len=*), intent(in) :: context
  integer(int64) :: element_count
  integer :: i

  element_count = 1_int64
  do i = 1, size(dims)
    if (dims(i)%len < 0) error stop trim(context)// &
      & " Negative dimension length."
    if (dims(i)%len == 0 .or. element_count == 0) then
      element_count = 0
    else
      if (element_count > huge(element_count)/dims(i)%len) &
        & error stop trim(context)//" Dimension product overflow."
      element_count = element_count*dims(i)%len
    end if
  end do
end function checked_dim_product

!> Validate an attribute's metadata and backing byte buffer.
module pure subroutine validate_att_data(att, expected_dtype, context)
  !> Input argument(s): `att`.
  type(attribute_type), intent(in) :: att
  !> Input argument(s): `expected_dtype`.
  integer(data_type), intent(in) :: expected_dtype
  !> Input argument(s): `context`.
  character(len=*), intent(in) :: context
  integer(int64) :: required_bytes

  if (att%dtype /= expected_dtype) &
    & error stop trim(context)//" Unexpected attribute type."
  required_bytes = get_buffer_size(att%dtype, att%len)
  if (required_bytes == 0) return
  if (.not. allocated(att%buffer)) &
    & error stop trim(context)//" Attribute buffer is not allocated."
  if (size(att%buffer, kind=int64) < required_bytes) &
    & error stop trim(context)//" Attribute buffer is too small."
end subroutine validate_att_data

!> Validate a variable's metadata and backing byte buffer.
module pure subroutine validate_var_data(var, expected_dtype, expected_rank, context)
  !> Input argument(s): `var`.
  type(variable_type), intent(in) :: var
  !> Input argument(s): `expected_dtype`.
  integer(data_type), intent(in) :: expected_dtype
  !> Input argument(s): `expected_rank`.
  integer, intent(in) :: expected_rank
  !> Input argument(s): `context`.
  character(len=*), intent(in) :: context
  integer(int64) :: element_count, required_bytes

  if (var%dtype /= expected_dtype) &
    & error stop trim(context)//" Unexpected variable type."
  if (.not. allocated(var%dims)) &
    & error stop trim(context)//" Variable dimensions are not allocated."
  if (expected_rank > 1 .and. size(var%dims) /= expected_rank) &
    & error stop trim(context)//" Unexpected variable rank."
  element_count = checked_dim_product(var%dims, context)
  if (element_count /= var%len) &
    & error stop trim(context)//" Dimension product differs from variable length."
  required_bytes = get_buffer_size(var%dtype, var%len)
  if (required_bytes == 0) return
  if (.not. allocated(var%buffer)) &
    & error stop trim(context)//" Variable buffer is not allocated."
  if (size(var%buffer, kind=int64) < required_bytes) &
    & error stop trim(context)//" Variable buffer is too small."
end subroutine validate_var_data

end submodule nc4f_data_struct_util
