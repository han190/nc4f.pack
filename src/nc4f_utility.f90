submodule(nc4f) nc4f_utility
implicit none (type, external)
contains

!> NetCDF error handler.
module impure elemental subroutine handle_error(status, error_message)
  integer(c_int), intent(in) :: status
  character(*), intent(in), optional :: error_message
  character(len=MAX_CHAR_LEN + 1), pointer :: fptr
  type(c_ptr) :: cptr
  integer :: inull, iptr
  character(len=MAX_CHAR_LEN) :: err_msg

  if (status /= NC_NOERR) then
    cptr = nc_strerror(status)
    call c_f_pointer(cptr, fptr)

    iptr = len_trim(fptr)
    inull = scan(fptr, c_null_char)
    if (inull /= 0) iptr = inull - 1
    iptr = max(1, min(iptr, NC_MAX_NAME))
    if (present(error_message)) then
      write (err_msg, "(a, '(', a, ')')") fptr(1:iptr), error_message
      error stop trim(adjustl(err_msg))
    else
      error stop fptr(1:iptr)
    end if
  end if
  nullify (fptr)
end subroutine handle_error

!> Convert C string to Fortran string.
module pure function c2fstr(cstr) result(fstr)
  character(kind=c_char, len=*), intent(in) :: cstr
  character(len=:), allocatable :: fstr
  integer :: inull, str_len

  str_len = len(cstr)
  inull = scan(cstr, c_null_char)
  if (inull /= 0) str_len = inull - 1
  str_len = max(1, min(str_len, NC_MAX_NAME))
  fstr = cstr(1:str_len)
end function c2fstr

!> Convert Fortran string to C string.
module pure function f2cstr(fstr) result(cstr)
  character(len=*), intent(in) :: fstr
  character(kind=c_char, len=:), allocatable :: cstr

  cstr = trim(fstr)//c_null_char
end function f2cstr

!> Check if a buffer re-allocation is required
!> by comparing buffer size with a target size (`bsize`).
module pure logical function allocation_required(buffer, bsize)
  integer(int8), allocatable, intent(in) :: buffer(:)
  integer(int64), intent(in) :: bsize

  allocation_required = .false.
  if (.not. allocated(buffer)) then
    allocation_required = .true.
  else if (size(buffer) < bsize) then
    allocation_required = .true.
  end if
end function allocation_required

!> Compute buffer size based on data type and length.
module elemental function get_buffer_size(dtype, len) result(buffer_size)
  integer(int32), intent(in) :: dtype
  integer(int64), intent(in) :: len
  integer(int64) :: buffer_size
  character(len=NC_MAX_NAME) :: data_name
  integer(int64) :: st_size

  select case (dtype)
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
    write (data_name, "(i0)") dtype
    error stop "[get_buffer_size] Unsupported type."// &
      & " Data type: "//trim(data_name)//"."
  end select
  buffer_size = len*st_size/8
end function get_buffer_size

end submodule nc4f_utility
