!> Shared non-error utilities for NetCDF operational submodules.
submodule(nc4f_nc) nc4f_nc_util

implicit none (type, external)

contains

!> Allocate a fresh byte buffer for an attribute read from a NetCDF file.
module subroutine initialize_att(att)
  type(attribute_type), intent(inout) :: att
  integer(int64) :: nbytes

  nbytes = checked_buffer_size(att%dtype, att%len, "[initialize_att]")
  if (associated(att%buffer)) nullify (att%buffer)
  allocate (att%buffer(nbytes))
end subroutine initialize_att

!> Allocate a fresh byte buffer for a variable read from a NetCDF file.
module subroutine initialize_var(var)
  type(variable_type), intent(inout) :: var
  integer(int64) :: nbytes

  nbytes = checked_buffer_size(var%dtype, var%len, "[initialize_var]")
  if (associated(var%buffer)) nullify (var%buffer)
  allocate (var%buffer(nbytes))
end subroutine initialize_var

!> Trim space from both ends of a character string.
module pure function clip(string) result(clipped)
  character(len=*), intent(in) :: string
  character(len=:), allocatable :: clipped

  clipped = trim(adjustl(string))
end function clip

!> Convert a NUL-terminated C string into a Fortran string.
module pure function c2fstr(cstr) result(fstr)
  character(kind=c_char, len=*), intent(in) :: cstr
  character(len=:), allocatable :: fstr
  integer :: inull, str_len

  str_len = len(cstr)
  inull = scan(cstr, c_null_char)
  if (inull /= 0) str_len = inull - 1
  str_len = max(1, min(str_len, int(NC_MAX_NAME)))
  fstr = cstr(1:str_len)
end function c2fstr

!> Convert a Fortran string into a NUL-terminated C string.
module pure function f2cstr(fstr) result(cstr)
  character(len=*), intent(in) :: fstr
  character(kind=c_char, len=:), allocatable :: cstr

  cstr = trim(fstr)//c_null_char
end function f2cstr

!> Validate a variable byte buffer before passing it to the C API.
module subroutine validate_var_buffer(var, context)
  type(variable_type), intent(in) :: var
  character(len=*), intent(in) :: context
  integer(int64) :: element_count, required_bytes

  if (.not. allocated(var%dims)) then
    error stop trim(context)//" Variable dimensions are not allocated."
  end if
  element_count = checked_dim_count(var%dims, context)
  if (element_count /= var%len) then
    error stop trim(context)//" Dimension product differs from variable length."
  end if
  required_bytes = checked_buffer_size(var%dtype, var%len, context)
  call validate_raw_buffer(var%buffer, required_bytes, "Variable", context)
end subroutine validate_var_buffer

!> Validate an attribute byte buffer before passing it to the C API.
module subroutine validate_att_buffer(att, context)
  type(attribute_type), intent(in) :: att
  character(len=*), intent(in) :: context
  integer(int64) :: required_bytes

  required_bytes = checked_buffer_size(att%dtype, att%len, context)
  call validate_raw_buffer(att%buffer, required_bytes, "Attribute", context)
end subroutine validate_att_buffer

!> Compute a checked element count for a dimension list.
module function checked_dim_count(dims, context) result(element_count)
  type(dimension_type), intent(in) :: dims(:)
  character(len=*), intent(in) :: context
  integer(int64) :: element_count
  integer :: i

  element_count = 1_int64
  do i = 1, size(dims)
    call checked_multiply(element_count, dims(i)%len, context)
  end do
end function checked_dim_count

!> Safely multiply one dimension length into an element count.
module subroutine checked_multiply(product_value, factor, context)
  integer(int64), intent(inout) :: product_value
  integer(int64), intent(in) :: factor
  character(len=*), intent(in) :: context

  if (factor < 0) error stop trim(context)//" Negative dimension length."
  if (factor == 0 .or. product_value == 0) then
    product_value = 0
  else if (product_value > huge(product_value)/factor) then
    error stop trim(context)//" Dimension product overflow."
  else
    product_value = product_value*factor
  end if
end subroutine checked_multiply

!> Return the checked byte count for a supported NetCDF data type.
module function checked_buffer_size(dtype, element_count, context) result(required_bytes)
  integer(c_int), intent(in) :: dtype
  integer(int64), intent(in) :: element_count
  character(len=*), intent(in) :: context
  integer(int64) :: bytes_per_element, required_bytes

  if (element_count < 0) error stop trim(context)//" Negative element count."
  select case (dtype)
  case (NC_BYTE, NC_CHAR)
    bytes_per_element = 1_int64
  case (NC_SHORT)
    bytes_per_element = 2_int64
  case (NC_INT, NC_FLOAT)
    bytes_per_element = 4_int64
  case (NC_INT64, NC_DOUBLE)
    bytes_per_element = 8_int64
  case default
    error stop trim(context)//" Unsupported netCDF data type."
  end select
  if (element_count > huge(required_bytes)/bytes_per_element) then
    error stop trim(context)//" Byte-size overflow."
  end if
  required_bytes = element_count*bytes_per_element
end function checked_buffer_size

!> Validate capacity of a pointer-backed raw byte buffer.
module subroutine validate_raw_buffer(buffer, required_bytes, object_name, context)
  integer(int8), pointer, intent(in) :: buffer(:)
  integer(int64), intent(in) :: required_bytes
  character(len=*), intent(in) :: object_name
  character(len=*), intent(in) :: context

  if (required_bytes == 0) return
  if (.not. associated(buffer)) then
    error stop trim(context)//" "//object_name//" buffer is not associated."
  end if
  if (size(buffer, kind=int64) < required_bytes) then
    error stop trim(context)//" "//object_name//" buffer is too small."
  end if
end subroutine validate_raw_buffer

end submodule nc4f_nc_util
