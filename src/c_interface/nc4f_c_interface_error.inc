function nc_strerror(ncerr1) bind(c, name="nc_strerror")
  !! Given an error number, return an error message.
  import :: c_int, c_ptr
  integer(c_int), value :: ncerr1
  !! error number
  type(c_ptr) :: nc_strerror
  !! Library-owned NUL-terminated error message; do not free or modify it.
end function nc_strerror