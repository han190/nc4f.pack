submodule(nc4f_nc) nc4f_nc_utility
implicit none (type, external)
contains

!> Allocate a fresh byte buffer for an attribute read from a NetCDF file.
module subroutine initialize_att(att)
  !> Attribute to process.
  type(attribute_type), intent(inout) :: att
  integer :: nbytes

  nbytes = buffer_size(att%dtype, att%len, "[initialize_att]")
  if (allocated(att%buffer)) deallocate (att%buffer)
  nullify (att%ptr)
  allocate (att%buffer(nbytes))
end subroutine initialize_att

!> Allocate a fresh byte buffer for a variable read from a NetCDF file.
module subroutine initialize_var(var)
  !> Variable to process.
  type(variable_type), intent(inout) :: var
  integer :: nbytes

  nbytes = buffer_size(var%dtype, var%len, "[initialize_var]")
  if (allocated(var%buffer)) deallocate (var%buffer)
  nullify (var%ptr)
  allocate (var%buffer(nbytes))
end subroutine initialize_var

!> Trim space from both ends of a character string.
module pure function clip(string) result(clipped)
  !> Data or metadata used by this operation.
  character(len=*), intent(in) :: string
  !> String with trailing blanks removed.
  character(len=:), allocatable :: clipped

  clipped = trim(adjustl(string))
end function clip

!> Convert a NUL-terminated C string into a Fortran string.
module pure function c2fstr(cstr) result(fstr)
  !> Data or metadata used by this operation.
  character(kind=c_char, len=*), intent(in) :: cstr
  !> Fortran string converted from C storage.
  character(len=:), allocatable :: fstr
  integer :: inull, str_len

  str_len = len(cstr)
  inull = scan(cstr, c_null_char)
  if (inull /= 0) str_len = inull - 1
  str_len = max(1, min(str_len, int(NC_MAX_NAME)))
  fstr = cstr(1:str_len)
end function c2fstr

!> Convert a Fortran string into a NUL-terminated C string.
module pure function f2cstr(fstr) result(cstr)
  !> Data or metadata used by this operation.
  character(len=*), intent(in) :: fstr
  !> C-compatible string converted from Fortran text.
  character(kind=c_char, len=:), allocatable :: cstr

  cstr = trim(fstr)//c_null_char
end function f2cstr

end submodule nc4f_nc_utility
