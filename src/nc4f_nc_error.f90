submodule(nc4f_nc) nc4f_nc_error
implicit none (type, external)
contains

!> Return true when `err` represents a failed operation.
logical elemental module function has_err(err) result(is_err)
  !> Completed result of an nc4f operation.
  type(error_type), intent(in) :: err

  is_err = err%code /= NC_NOERR
end function has_err

!> Apply nc4f's fail-fast policy to a completed error result.
logical impure module function handle_err(err) result(has_failed)
  !> Completed result of an nc4f operation.
  type(error_type), intent(in) :: err

  has_failed = has_err(err)
  if (.not. has_failed) return

  if (allocated(err%msg)) then
    error stop trim(err%msg)
  else
    error stop "nc4f operation failed without a diagnostic."
  end if
end function handle_err

!> Convert a NetCDF C status into nc4f's normal error result.
module function netcdf_err(status, context) result(err)
  !> Status code returned by a NetCDF C API call.
  integer(c_int), intent(in) :: status
  !> Optional nc4f operation context for the diagnostic.
  character(len=*), intent(in), optional :: context
  !> Constructed error result; success has code `NC_NOERR`.
  type(error_type) :: err

  if (status == NC_NOERR) then
    err = error_type()
  else if (present(context)) then
    err%code = status
    err%msg = netcdf_msg(status, context)
  else
    err%code = status
    err%msg = netcdf_msg(status)
  end if
end function netcdf_err

!> Return a Fortran diagnostic for a NetCDF C status.
function netcdf_msg(stat, context) result(msg)
  !> Status code returned by a NetCDF C API call.
  integer(c_int), intent(in) :: stat
  !> Optional nc4f operation context for the diagnostic.
  character(len=*), intent(in), optional :: context
  !> Allocatable diagnostic string.
  character(len=:), allocatable :: msg
  character(kind=c_char), pointer :: chars(:)
  type(c_ptr) :: cstr
  character(len=MAX_CHAR_LEN) :: stat_msg
  integer :: i, msg_len

  stat_msg = ""
  cstr = nc_strerror(stat)
  if (.not. c_associated(cstr)) then
    stat_msg = "Unknown netCDF error"
  else
    msg_len = int(min(c_strlen(cstr), int(MAX_CHAR_LEN, c_size_t)))
    if (msg_len == 0) then
      stat_msg = "Unknown netCDF error"
    else
      call c_f_pointer(cstr, chars, [msg_len])
      do i = 1, msg_len
        stat_msg(i:i) = chars(i)
      end do
    end if
  end if

  if (present(context)) then
    msg = trim(stat_msg)//new_line("a")//clip(context)
  else
    msg = trim(stat_msg)
  end if
end function netcdf_msg

end submodule nc4f_nc_error
