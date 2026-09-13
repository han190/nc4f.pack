!> Shared non-error utilities for NetCDF operational submodules.
submodule(nc4f_nc) nc4f_nc_util

implicit none (type, external)

contains

!> Allocate a fresh byte buffer for an attribute read from a NetCDF file.
module subroutine initialize_att(att)
  !> Input/output argument: `att`.
  type(attribute_type), intent(inout) :: att
  integer :: nbytes

  nbytes = buffer_size(att%dtype, att%len, "[initialize_att]")
  if (associated(att%buffer)) nullify (att%buffer)
  allocate (att%buffer(nbytes))
end subroutine initialize_att

!> Allocate a fresh byte buffer for a variable read from a NetCDF file.
module subroutine initialize_var(var)
  !> Input/output argument: `var`.
  type(variable_type), intent(inout) :: var
  integer :: nbytes

  nbytes = buffer_size(var%dtype, var%len, "[initialize_var]")
  if (associated(var%buffer)) nullify (var%buffer)
  allocate (var%buffer(nbytes))
end subroutine initialize_var

!> Trim space from both ends of a character string.
module pure function clip(string) result(clipped)
  !> Input argument: `string`.
  character(len=*), intent(in) :: string
  !> Return value: `clipped`.
  character(len=:), allocatable :: clipped

  clipped = trim(adjustl(string))
end function clip

!> Convert a NUL-terminated C string into a Fortran string.
module pure function c2fstr(cstr) result(fstr)
  !> Input argument: `cstr`.
  character(kind=c_char, len=*), intent(in) :: cstr
  !> Return value: `fstr`.
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
  !> Input argument: `fstr`.
  character(len=*), intent(in) :: fstr
  !> Return value: `cstr`.
  character(kind=c_char, len=:), allocatable :: cstr

  cstr = trim(fstr)//c_null_char
end function f2cstr

!> Validate a variable byte buffer before passing it to the C API.
module subroutine validate_var_buffer(var, context)
  !> Input argument: `var`.
  type(variable_type), intent(in) :: var
  !> Input argument: `context`.
  character(len=*), intent(in) :: context
  integer :: required_bytes

  if (.not. allocated(var%dims)) then
    error stop trim(context)//" Variable dimensions are not allocated."
  end if
  if (size(var) /= var%len) then
    error stop trim(context)//" Dimension product differs from variable length."
  end if
  required_bytes = buffer_size(var%dtype, var%len, context)
  call validate_buffer(var%buffer, int(required_bytes, int64), "Variable", context)
end subroutine validate_var_buffer

!> Validate an attribute byte buffer before passing it to the C API.
module subroutine validate_att_buffer(att, context)
  !> Input argument: `att`.
  type(attribute_type), intent(in) :: att
  !> Input argument: `context`.
  character(len=*), intent(in) :: context
  integer :: required_bytes

  required_bytes = buffer_size(att%dtype, att%len, context)
  call validate_buffer(att%buffer, int(required_bytes, int64), "Attribute", context)
end subroutine validate_att_buffer

end submodule nc4f_nc_util
