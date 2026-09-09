submodule(nc4f_nc) nc4f_nc_util
implicit none (type, external)
contains

!> Apply the legacy fail-fast policy to a completed `error_type`.
!>
!> Construction is deliberately separate: `make_netcdf_error` forms values
!> from C statuses, and locally detected failures use the native
!> `error_type(status, message)` constructor directly.
module impure logical function handle_error(error) result(has_failed)
  !> Completed result of an nc4f operation.
  type(error_type), intent(in) :: error

  has_failed = failed(error)
  if (.not. has_failed) return

  if (allocated(error%message)) then
    error stop trim(error%message)
  else
    error stop "nc4f operation failed without a diagnostic."
  end if
end function handle_error

!> Construct an error result from a NetCDF C status and optional context.
module function make_netcdf_error(status, context) result(error)
  !> Status code returned by a NetCDF C API call.
  integer(c_int), intent(in) :: status
  !> Optional nc4f operation context to append to the NetCDF diagnostic.
  character(*), intent(in), optional :: context
  !> Constructed result. A successful status returns `error_type()`.
  type(error_type) :: error
  character(len=:), allocatable :: message

  if (status == NC_NOERR) then
    error = error_type()
  else
    if (present(context)) then
      message = netcdf_message(status, context)
    else
      message = netcdf_message(status)
    end if
    error = error_type(status, message)
  end if
end function make_netcdf_error

!> Convert a failed NetCDF C status and optional context into a diagnostic.
function netcdf_message(status, context) result(message)
  !> Status code returned by a NetCDF C API call.
  integer(c_int), intent(in) :: status
  !> Optional nc4f operation context to append to the NetCDF diagnostic.
  character(*), intent(in), optional :: context
  !> Allocatable Fortran diagnostic text.
  character(len=:), allocatable :: message
  !> Pointer to the bytes of the C string returned by `nc_strerror`.
  character(kind=c_char), pointer :: fptr(:)
  type(c_ptr) :: cptr
  integer :: i, message_len
  !> Message buffer used to assemble the Fortran error string.
  character(len=MAX_CHAR_LEN) :: status_message

  status_message = ""
  cptr = nc_strerror(status)
  if (.not. c_associated(cptr)) then
    status_message = "Unknown netCDF error"
  else
    message_len = int(min(c_strlen(cptr), int(MAX_CHAR_LEN, c_size_t)))
    if (message_len == 0) then
      status_message = "Unknown netCDF error"
    else
      call c_f_pointer(cptr, fptr, [message_len])
      do i = 1, message_len
        status_message(i:i) = fptr(i)
      end do
    end if
  end if

  if (present(context)) then
    message = trim(status_message)//new_line('a')//clip(context)
  else
    message = trim(status_message)
  end if
  nullify (fptr)
end function netcdf_message

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
  !> Input argument(s): `var`.
  type(variable_type), intent(in) :: var
  !> Input argument(s): `context`.
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
  !> Input argument(s): `att`.
  type(attribute_type), intent(in) :: att
  !> Input argument(s): `context`.
  character(len=*), intent(in) :: context
  integer(int64) :: required_bytes

  required_bytes = checked_buffer_size(att%dtype, att%len, context)
  call validate_raw_buffer(att%buffer, required_bytes, "Attribute", context)
end subroutine validate_att_buffer

!> Compute a checked element count from a list of dimensions.
module function checked_dim_count(dims, context) result(element_count)
  !> Input argument(s): `dims(:)`.
  type(dimension_type), intent(in) :: dims(:)
  !> Input argument(s): `context`.
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
  !> Input/output argument(s): `product_value`.
  integer(int64), intent(inout) :: product_value
  !> Input argument(s): `factor`.
  integer(int64), intent(in) :: factor
  !> Input argument(s): `context`.
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
  !> Input argument(s): `dtype`.
  integer(c_int), intent(in) :: dtype
  !> Input argument(s): `element_count`.
  integer(int64), intent(in) :: element_count
  !> Input argument(s): `context`.
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
  !> Input argument(s): `buffer(:)`.
  integer(int8), allocatable, intent(in) :: buffer(:)
  !> Input argument(s): `required_bytes`.
  integer(int64), intent(in) :: required_bytes
  !> Name of the buffer-owning object.
  character(len=*), intent(in) :: object_name
  !> Calling-context text for the diagnostic.
  character(len=*), intent(in) :: context

  if (required_bytes == 0) return
  if (.not. allocated(buffer)) &
    & error stop trim(context)//" "//object_name//" buffer is not allocated."
  if (size(buffer, kind=int64) < required_bytes) &
    & error stop trim(context)//" "//object_name//" buffer is too small."
end subroutine validate_raw_buffer

end submodule nc4f_nc_util
