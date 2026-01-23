submodule(nc4f_nc) nc4f_nc_util
implicit none (type, external)
contains

!> Handle errors from netCDF C API calls and raise Fortran errors.
module impure elemental subroutine handle_error(status, error_message)
  !> Status code returned by a netCDF C API call.
  integer(c_int), intent(in) :: status
  !> Optional user message to include in the error text.
  character(*), intent(in), optional :: error_message
  !> Pointer to a C string returned by `nc_strerror`.
  character(len=MAX_CHAR_LEN + 1), pointer :: fptr
  type(c_ptr) :: cptr
  integer :: inull, iptr
  !> Message buffer used to assemble the Fortran error string.
  character(len=MAX_CHAR_LEN) :: msg

  if (status /= NC_NOERR) then
    cptr = nc_strerror(status)
    call c_f_pointer(cptr, fptr)

    iptr = len_trim(fptr)
    inull = scan(fptr, c_null_char)
    if (inull /= 0) iptr = inull - 1
    iptr = max(1, min(iptr, NC_MAX_NAME))
    if (present(error_message)) then
      write (msg, "(a, a, '(', a, ')')") &
        & fptr(1:iptr), new_line('a'), clip(error_message)
      error stop trim(msg)
    else
      error stop fptr(1:iptr)
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

end submodule nc4f_nc_util
