submodule(module_netcdf) submodule_utility
implicit none
contains

impure elemental module subroutine handle_error(status, error_message)
  integer(c_int), intent(in) :: status
  character(*), intent(in), optional :: error_message
  character(:), pointer :: fptr => null()
  type(c_ptr) :: cptr
  integer :: inull, iptr
  character(len=MAX_CHAR_LEN) :: message

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

pure module function c2fstr(f2cstring) result(string)
  character(kind=c_char, len=*), intent(in) :: f2cstring
  character(len=:), allocatable :: string
  integer :: inull, str_len

  str_len = len(f2cstring)
  inull = scan(f2cstring, c_null_char)
  if (inull /= 0) str_len = inull - 1
  str_len = max(1, min(str_len, NC_MAX_NAME))
  string = f2cstring(1:str_len)
end function c2fstr

pure module function f2cstr(string) result(f2cstring)
  character(len=*), intent(in) :: string
  character(kind=c_char, len=:), allocatable :: f2cstring

  f2cstring = trim(string)//c_null_char
end function f2cstr

pure logical module function allocation_required(buffer, buf_size)
  integer(int8), allocatable, intent(in) :: buffer(:)
  integer(int64), intent(in) :: buf_size

  allocation_required = .not. allocated(buffer) .or. size(buffer) < buf_size
end function allocation_required

module elemental function get_buffer_size(data_type, length) result(buffer_size)
  integer(int32), intent(in) :: data_type
  integer(int64), intent(in) :: length
  integer(int64) :: buffer_size
  character(len=NC_MAX_NAME) :: data_name
  integer(int64) :: st_size

  select case (data_type)
  case (NC_BYTE, NC_CHAR)
    st_size = storage_size(0_int8, kind=int64)
  case (NC_SHORT)
    st_size = storage_size(0_int16, kind=int64)
  case (NC_INT)
    st_size = storage_size(0_int32, kind=int64)
  case (NC_INT64)
    st_size = storage_size(0_int64, kind=int64)
  case (NC_FLOAT)
    st_size = storage_size(0.0_real32, kind=int64)
  case (NC_DOUBLE)
    st_size = storage_size(0.0_real64, kind=int64)
  case default
    write (data_name, "(i0)") data_type
    error stop "[get_buffer_size] Unsupported type."// &
      & " Data type: "//trim(data_name)//"."
  end select
  buffer_size = length*st_size/8
end function get_buffer_size

end submodule submodule_utility