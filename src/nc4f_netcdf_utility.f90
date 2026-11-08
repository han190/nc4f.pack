submodule(nc4f_netcdf) nc4f_netcdf_utility
implicit none (type, external)
contains

pure module subroutine initialize_att(att, err)
  !! Allocate a fresh byte buffer for an attribute read from a NetCDF file.
  type(attribute_type), intent(inout) :: att
  !! Attribute to process.
  type(error_type), intent(out) :: err
  integer :: nbytes, alloc_stat

  call compute_buffer_size(att%dtype, att%len, nbytes, err)
  if (.exists. err) then
    err%fname = "initialize_att"
    return
  end if
  if (allocated(att%buffer)) deallocate (att%buffer)
  nullify (att%ptr)
  allocate (att%buffer(nbytes), stat=alloc_stat)
  if (alloc_stat /= 0) then
    err = error_type(NC_ENOMEM, "initialize_att", "Buffer allocation failed.")
  end if
end subroutine initialize_att

pure module subroutine initialize_var(var, err)
  !! Allocate a fresh byte buffer for a variable read from a NetCDF file.
  type(variable_type), intent(inout) :: var
  !! Variable to process.
  type(error_type), intent(out) :: err
  integer :: nbytes, alloc_stat

  call compute_buffer_size(var%dtype, var%len, nbytes, err)
  if (.exists. err) then
    err%fname = "initialize_var"
    return
  end if
  if (allocated(var%buffer)) deallocate (var%buffer)
  nullify (var%ptr)
  allocate (var%buffer(nbytes), stat=alloc_stat)
  if (alloc_stat /= 0) then
    err = error_type(NC_ENOMEM, "initialize_var", "Buffer allocation failed.")
  end if
end subroutine initialize_var

pure module function clip(string) result(clipped)
  !! Trim space from both ends of a character string.
  character(len=*), intent(in) :: string
  !! String to trim and left-adjust.
  character(len=:), allocatable :: clipped
  !! String with leading and trailing blanks removed.

  clipped = trim(adjustl(string))
end function clip

pure module function c2fstr(cstr) result(fstr)
  !! Convert a NUL-terminated C string into a Fortran string.
  character(kind=c_char, len=*), intent(in) :: cstr
  !! C character string whose first NUL marks the end of the converted text.
  character(len=:), allocatable :: fstr
  !! Fortran string converted from C storage.
  integer :: inull, str_len

  str_len = len(cstr)
  inull = scan(cstr, c_null_char)
  if (inull /= 0) str_len = inull - 1
  str_len = max(1, min(str_len, int(NC_MAX_NAME)))
  fstr = cstr(1:str_len)
end function c2fstr

pure module function f2cstr(fstr) result(cstr)
  !! Convert a Fortran string into a NUL-terminated C string.
  character(len=*), intent(in) :: fstr
  !! Fortran string whose trailing blanks are removed before appending NUL.
  character(kind=c_char, len=:), allocatable :: cstr
  !! C-compatible string converted from Fortran text.

  cstr = trim(fstr)//c_null_char
end function f2cstr

end submodule nc4f_netcdf_utility
