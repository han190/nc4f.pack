submodule(module_netcdf) submodule_utility
implicit none
contains

impure elemental module subroutine handle_error(status, error_message)
  integer(c_int), intent(in) :: status
  character(*), intent(in), optional :: error_message
  character(:), pointer :: fptr => null()
  type(c_ptr) :: cptr
  integer :: inull, iptr
  character(len=500) :: message

  if (status /= NC_NOERR) then
    allocate (character(len=NC_MAX_NAME + 1) :: fptr)

    cptr = nc_strerror(status)
    call c_f_pointer(cptr, fptr)

    iptr = len_trim(fptr)
    inull = scan(fptr, c_null_char)
    if (inull /= 0) iptr = inull - 1
    iptr = max(1, min(iptr, NC_MAX_NAME))
    if (present(error_message)) then
      message = fptr(1:iptr)//" ("//error_message//")"
      error stop trim(adjustl(message))
    else
      error stop trim(adjustl(fptr(1:iptr)))
    end if
  end if
  nullify (fptr)
end subroutine handle_error

pure module function fstr(cstring) result(string)
  character(kind=c_char, len=*), intent(in) :: cstring
  character(len=:), allocatable :: string
  integer :: inull, str_len

  str_len = len(cstring)
  inull = scan(cstring, c_null_char)
  if (inull /= 0) str_len = inull - 1
  str_len = max(1, min(str_len, NC_MAX_NAME))
  string = cstring(1:str_len)
end function fstr

pure module function cstr(string) result(cstring)
  character(len=*), intent(in) :: string
  character(kind=c_char, len=:), allocatable :: cstring
  cstring = trim(string)//c_null_char
end function cstr

logical module function reallocation_required(buffer, buf_size)
  integer(int8), allocatable, intent(inout) :: buffer(:)
  integer(int64), intent(in) :: buf_size

  reallocation_required = (.not. allocated(buffer)) &
    & .or. (size(buffer) < buf_size)
  if (allocated(buffer) .and. reallocation_required) deallocate (buffer)
end function reallocation_required

end submodule submodule_utility