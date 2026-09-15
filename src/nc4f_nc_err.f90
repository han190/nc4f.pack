submodule(nc4f_nc) nc4f_nc_err
implicit none (type, external)
contains

!> Return true when `error` represents a failed operation.
module pure elemental logical function has_error(error) result(is_error)
  !> Completed result of an nc4f operation.
  type(error_type), intent(in) :: error

  is_error = error%code /= NC_NOERR
end function has_error

!> Apply nc4f's fail-fast policy to a completed error result.
module impure logical function handle_error(error) result(has_failed)
  !> Completed result of an nc4f operation.
  type(error_type), intent(in) :: error

  has_failed = has_error(error)
  if (.not. has_failed) return

  if (allocated(error%message)) then
    error stop trim(error%message)
  else
    error stop "nc4f operation failed without a diagnostic."
  end if
end function handle_error

!> Convert a NetCDF C status into nc4f's normal error result.
module function make_netcdf_error(status, context) result(error)
  !> Status code returned by a NetCDF C API call.
  integer(c_int), intent(in) :: status
  !> Optional nc4f operation context for the diagnostic.
  character(len=*), intent(in), optional :: context
  !> Constructed error result; success has code `NC_NOERR`.
  type(error_type) :: error

  if (status == NC_NOERR) then
    error = error_type()
  else if (present(context)) then
    error%code = status
    error%message = netcdf_message(status, context)
  else
    error%code = status
    error%message = netcdf_message(status)
  end if
end function make_netcdf_error

!> Return a Fortran diagnostic for a NetCDF C status.
module function netcdf_message(status, context) result(message)
  !> Status code returned by a NetCDF C API call.
  integer(c_int), intent(in) :: status
  !> Optional nc4f operation context for the diagnostic.
  character(len=*), intent(in), optional :: context
  !> Allocatable diagnostic string.
  character(len=:), allocatable :: message
  character(kind=c_char), pointer :: chars(:)
  type(c_ptr) :: cstr
  character(len=MAX_CHAR_LEN) :: status_message
  integer :: i, message_len

  status_message = ""
  cstr = nc_strerror(status)
  if (.not. c_associated(cstr)) then
    status_message = "Unknown netCDF error"
  else
    message_len = int(min(c_strlen(cstr), int(MAX_CHAR_LEN, c_size_t)))
    if (message_len == 0) then
      status_message = "Unknown netCDF error"
    else
      call c_f_pointer(cstr, chars, [message_len])
      do i = 1, message_len
        status_message(i:i) = chars(i)
      end do
    end if
  end if

  if (present(context)) then
    message = trim(status_message)//new_line("a")//clip(context)
  else
    message = trim(status_message)
  end if
end function netcdf_message

end submodule nc4f_nc_err
