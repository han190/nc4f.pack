submodule(nc4f_nc) nc4f_nc_util
implicit none (type, external)
contains

!> Handle errors from netCDF C API calls and raise Fortran errors.
module impure elemental subroutine handle_error(status, error_message)
  !> Status code returned by a netCDF C API call.
  integer(c_int), intent(in) :: status
  !> Optional user message to include in the error text.
  character(*), intent(in), optional :: error_message
  !> Pointer to the bytes of the C string returned by `nc_strerror`.
  character(kind=c_char), pointer :: fptr(:)
  type(c_ptr) :: cptr
  integer :: i, message_len
  !> Message buffer used to assemble the Fortran error string.
  character(len=MAX_CHAR_LEN) :: msg, netcdf_message

  if (status /= NC_NOERR) then
    netcdf_message = ""
    cptr = nc_strerror(status)
    if (.not. c_associated(cptr)) then
      netcdf_message = "Unknown netCDF error"
    else
      message_len = int(min(c_strlen(cptr), int(MAX_CHAR_LEN, c_size_t)))
      if (message_len == 0) then
        netcdf_message = "Unknown netCDF error"
      else
        call c_f_pointer(cptr, fptr, [message_len])
        do i = 1, message_len
          netcdf_message(i:i) = fptr(i)
        end do
      end if
    end if
    if (present(error_message)) then
      write (msg, "(a, a, '(', a, ')')") &
        & trim(netcdf_message), new_line('a'), clip(error_message)
      error stop trim(msg)
    else
      error stop trim(netcdf_message)
    end if
  end if
  nullify (fptr)
end subroutine handle_error

!> Trim left and right space of a character variable.
module pure function clip(string) result(clipped)
  !> The input string.
  character(len=*), intent(in) :: string
  !> The output string.
  character(len=:), allocatable :: clipped

  clipped = trim(adjustl(string))
end function clip

!> Convert a NUL-terminated C string to a Fortran allocatable string.
module pure function c2fstr(cstr) result(fstr)
  !> C-style NUL-terminated string to convert.
  character(kind=c_char, len=*), intent(in) :: cstr
  !> Fortran allocatable result string.
  character(len=:), allocatable :: fstr
  integer :: inull, str_len

  str_len = len(cstr)
  inull = scan(cstr, c_null_char)
  if (inull /= 0) str_len = inull - 1
  str_len = max(1, min(str_len, NC_MAX_NAME))
  fstr = cstr(1:str_len)
end function c2fstr

!> Convert a Fortran string to a NUL-terminated C string.
module pure function f2cstr(fstr) result(cstr)
  !> Fortran string to convert.
  character(len=*), intent(in) :: fstr
  !> NUL-terminated C string result.
  character(kind=c_char, len=:), allocatable :: cstr

  cstr = trim(fstr)//c_null_char
end function f2cstr

!> Validate a variable before exposing its byte buffer to the C API.
module subroutine validate_var_buffer(var, context)
  type(variable_type), intent(in) :: var
  character(len=*), intent(in) :: context
  integer(int64) :: element_count, required_bytes

  if (.not. allocated(var%dims)) &
    & error stop trim(context)//" Variable dimensions are not allocated."
  element_count = checked_dim_count(var%dims, context)
  if (element_count /= var%len) &
    & error stop trim(context)//" Dimension product differs from variable length."
  required_bytes = checked_buffer_size(var%dtype, var%len, context)
  call validate_raw_buffer(var%buffer, required_bytes, "Variable", context)
end subroutine validate_var_buffer

!> Validate an attribute before exposing its byte buffer to the C API.
module subroutine validate_att_buffer(att, context)
  type(attribute_type), intent(in) :: att
  character(len=*), intent(in) :: context
  integer(int64) :: required_bytes

  required_bytes = checked_buffer_size(att%dtype, att%len, context)
  call validate_raw_buffer(att%buffer, required_bytes, "Attribute", context)
end subroutine validate_att_buffer

!> Compute a checked element count from a list of dimensions.
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

!> Multiply a running element count by one dimension safely.
subroutine checked_multiply(product_value, factor, context)
  integer(int64), intent(inout) :: product_value
  integer(int64), intent(in) :: factor
  character(len=*), intent(in) :: context

  if (factor < 0) error stop trim(context)//" Negative dimension length."
  if (factor == 0 .or. product_value == 0) then
    product_value = 0
  else
    if (product_value > huge(product_value)/factor) &
      & error stop trim(context)//" Dimension product overflow."
    product_value = product_value*factor
  end if
end subroutine checked_multiply

!> Return the required byte count for one supported netCDF type.
function checked_buffer_size(dtype, element_count, context) result(required_bytes)
  integer(c_int), intent(in) :: dtype
  integer(int64), intent(in) :: element_count
  character(len=*), intent(in) :: context
  integer(int64) :: bytes_per_element, required_bytes

  if (element_count < 0) &
    & error stop trim(context)//" Negative element count."
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
  if (bytes_per_element > 0 .and. &
      & element_count > huge(required_bytes)/bytes_per_element) &
    & error stop trim(context)//" Byte-size overflow."
  required_bytes = element_count*bytes_per_element
end function checked_buffer_size

!> Check allocation and capacity of a raw byte buffer.
subroutine validate_raw_buffer(buffer, required_bytes, object_name, context)
  integer(int8), allocatable, intent(in) :: buffer(:)
  integer(int64), intent(in) :: required_bytes
  character(len=*), intent(in) :: object_name, context

  if (required_bytes == 0) return
  if (.not. allocated(buffer)) &
    & error stop trim(context)//" "//object_name//" buffer is not allocated."
  if (size(buffer, kind=int64) < required_bytes) &
    & error stop trim(context)//" "//object_name//" buffer is too small."
end subroutine validate_raw_buffer

end submodule nc4f_nc_util
