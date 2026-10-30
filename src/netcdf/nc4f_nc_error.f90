submodule(nc4f_nc) nc4f_nc_error
implicit none (type, external)
contains

logical elemental module function has_err(err) result(is_err)
  !! Return true when `err` represents a failed operation.
  type(error_type), intent(in) :: err
  !! Completed result of an nc4f operation.

  is_err = err%code /= NC_NOERR
end function has_err

pure logical module function handle_err(err) result(has_failed)
  !! Apply nc4f's fail-fast policy to a completed error result.
  type(error_type), intent(in) :: err
  !! Completed result of an nc4f operation.

  has_failed = has_err(err)
  if (.not. has_failed) return

  if (allocated(err%msg)) then
    error stop trim(err%msg)
  else
    error stop "nc4f operation failed without a diagnostic."
  end if
end function handle_err

module function netcdf_err(status, context) result(err)
  !! Convert a NetCDF C status into nc4f's normal error result.
  integer(c_int), intent(in) :: status
  !! Status code returned by a NetCDF C API call.
  character(len=*), intent(in), optional :: context
  !! Optional nc4f operation context for the diagnostic.
  type(error_type) :: err
  !! Constructed error result; success has code `NC_NOERR`.

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

function netcdf_msg(stat, context) result(msg)
  !! Return a Fortran diagnostic for a NetCDF C status.
  integer(c_int), intent(in) :: stat
  !! Status code returned by a NetCDF C API call.
  character(len=*), intent(in), optional :: context
  !! Optional nc4f operation context for the diagnostic.
  character(len=:), allocatable :: msg
  !! Allocatable diagnostic string.
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
