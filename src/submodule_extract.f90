submodule(module_netcdf) submodule_extract
implicit none
contains

module subroutine extract_att_int8_1d(att, ptr)
  type(attribute_type), target, intent(in) :: att
  integer(int8), pointer, intent(out) :: ptr(:)
  type(c_ptr) :: cptr

  cptr = c_loc(att%buffer(1))
  call c_f_pointer(cptr, ptr, [att%length])
end subroutine extract_att_int8_1d

module subroutine extract_att_int8_scalar(att, val)
  type(attribute_type), target, intent(in) :: att
  integer(int8), intent(out) :: val
  integer(int8), pointer :: ptr(:)
  type(c_ptr) :: cptr

  if (att%length > 1) error stop "Attribute value is a vector."
  cptr = c_loc(att%buffer(1))
  call c_f_pointer(cptr, ptr, [att%length])
  val = ptr(1)
end subroutine extract_att_int8_scalar

module subroutine extract_var_int8_1d(var, ptr)
  type(variable_type), target, intent(in) :: var
  integer(int8), pointer, intent(out) :: ptr(:)
  type(c_ptr) :: cptr

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int8_1d

module subroutine extract_var_int8_2d(var, ptr)
  type(variable_type), target, intent(in) :: var
  integer(int8), pointer, intent(out) :: ptr(:, :)
  type(c_ptr) :: cptr

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int8_2d

module subroutine extract_var_int8_3d(var, ptr)
  type(variable_type), target, intent(in) :: var
  integer(int8), pointer, intent(out) :: ptr(:, :, :)
  type(c_ptr) :: cptr

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int8_3d

module subroutine extract_var_int8_4d(var, ptr)
  type(variable_type), target, intent(in) :: var
  integer(int8), pointer, intent(out) :: ptr(:, :, :, :)
  type(c_ptr) :: cptr

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int8_4d

module subroutine extract_var_int8_5d(var, ptr)
  type(variable_type), target, intent(in) :: var
  integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :)
  type(c_ptr) :: cptr

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int8_5d

module subroutine extract_att_int16_1d(att, ptr)
  type(attribute_type), target, intent(in) :: att
  integer(int16), pointer, intent(out) :: ptr(:)
  type(c_ptr) :: cptr

  cptr = c_loc(att%buffer(1))
  call c_f_pointer(cptr, ptr, [att%length])
end subroutine extract_att_int16_1d

module subroutine extract_att_int16_scalar(att, val)
  type(attribute_type), target, intent(in) :: att
  integer(int16), intent(out) :: val
  integer(int16), pointer :: ptr(:)
  type(c_ptr) :: cptr

  if (att%length > 1) error stop "Attribute value is a vector."
  cptr = c_loc(att%buffer(1))
  call c_f_pointer(cptr, ptr, [att%length])
  val = ptr(1)
end subroutine extract_att_int16_scalar

module subroutine extract_var_int16_1d(var, ptr)
  type(variable_type), target, intent(in) :: var
  integer(int16), pointer, intent(out) :: ptr(:)
  type(c_ptr) :: cptr

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int16_1d

module subroutine extract_var_int16_2d(var, ptr)
  type(variable_type), target, intent(in) :: var
  integer(int16), pointer, intent(out) :: ptr(:, :)
  type(c_ptr) :: cptr

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int16_2d

module subroutine extract_var_int16_3d(var, ptr)
  type(variable_type), target, intent(in) :: var
  integer(int16), pointer, intent(out) :: ptr(:, :, :)
  type(c_ptr) :: cptr

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int16_3d

module subroutine extract_var_int16_4d(var, ptr)
  type(variable_type), target, intent(in) :: var
  integer(int16), pointer, intent(out) :: ptr(:, :, :, :)
  type(c_ptr) :: cptr

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int16_4d

module subroutine extract_var_int16_5d(var, ptr)
  type(variable_type), target, intent(in) :: var
  integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :)
  type(c_ptr) :: cptr

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int16_5d

module subroutine extract_att_int32_1d(att, ptr)
  type(attribute_type), target, intent(in) :: att
  integer(int32), pointer, intent(out) :: ptr(:)
  type(c_ptr) :: cptr

  cptr = c_loc(att%buffer(1))
  call c_f_pointer(cptr, ptr, [att%length])
end subroutine extract_att_int32_1d

module subroutine extract_att_int32_scalar(att, val)
  type(attribute_type), target, intent(in) :: att
  integer(int32), intent(out) :: val
  integer(int32), pointer :: ptr(:)
  type(c_ptr) :: cptr

  if (att%length > 1) error stop "Attribute value is a vector."
  cptr = c_loc(att%buffer(1))
  call c_f_pointer(cptr, ptr, [att%length])
  val = ptr(1)
end subroutine extract_att_int32_scalar

module subroutine extract_var_int32_1d(var, ptr)
  type(variable_type), target, intent(in) :: var
  integer(int32), pointer, intent(out) :: ptr(:)
  type(c_ptr) :: cptr

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int32_1d

module subroutine extract_var_int32_2d(var, ptr)
  type(variable_type), target, intent(in) :: var
  integer(int32), pointer, intent(out) :: ptr(:, :)
  type(c_ptr) :: cptr

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int32_2d

module subroutine extract_var_int32_3d(var, ptr)
  type(variable_type), target, intent(in) :: var
  integer(int32), pointer, intent(out) :: ptr(:, :, :)
  type(c_ptr) :: cptr

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int32_3d

module subroutine extract_var_int32_4d(var, ptr)
  type(variable_type), target, intent(in) :: var
  integer(int32), pointer, intent(out) :: ptr(:, :, :, :)
  type(c_ptr) :: cptr

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int32_4d

module subroutine extract_var_int32_5d(var, ptr)
  type(variable_type), target, intent(in) :: var
  integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :)
  type(c_ptr) :: cptr

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int32_5d

module subroutine extract_att_int64_1d(att, ptr)
  type(attribute_type), target, intent(in) :: att
  integer(int64), pointer, intent(out) :: ptr(:)
  type(c_ptr) :: cptr

  cptr = c_loc(att%buffer(1))
  call c_f_pointer(cptr, ptr, [att%length])
end subroutine extract_att_int64_1d

module subroutine extract_att_int64_scalar(att, val)
  type(attribute_type), target, intent(in) :: att
  integer(int64), intent(out) :: val
  integer(int64), pointer :: ptr(:)
  type(c_ptr) :: cptr

  if (att%length > 1) error stop "Attribute value is a vector."
  cptr = c_loc(att%buffer(1))
  call c_f_pointer(cptr, ptr, [att%length])
  val = ptr(1)
end subroutine extract_att_int64_scalar

module subroutine extract_var_int64_1d(var, ptr)
  type(variable_type), target, intent(in) :: var
  integer(int64), pointer, intent(out) :: ptr(:)
  type(c_ptr) :: cptr

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int64_1d

module subroutine extract_var_int64_2d(var, ptr)
  type(variable_type), target, intent(in) :: var
  integer(int64), pointer, intent(out) :: ptr(:, :)
  type(c_ptr) :: cptr

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int64_2d

module subroutine extract_var_int64_3d(var, ptr)
  type(variable_type), target, intent(in) :: var
  integer(int64), pointer, intent(out) :: ptr(:, :, :)
  type(c_ptr) :: cptr

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int64_3d

module subroutine extract_var_int64_4d(var, ptr)
  type(variable_type), target, intent(in) :: var
  integer(int64), pointer, intent(out) :: ptr(:, :, :, :)
  type(c_ptr) :: cptr

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int64_4d

module subroutine extract_var_int64_5d(var, ptr)
  type(variable_type), target, intent(in) :: var
  integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :)
  type(c_ptr) :: cptr

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int64_5d

module subroutine extract_att_real32_1d(att, ptr)
  type(attribute_type), target, intent(in) :: att
  real(real32), pointer, intent(out) :: ptr(:)
  type(c_ptr) :: cptr

  cptr = c_loc(att%buffer(1))
  call c_f_pointer(cptr, ptr, [att%length])
end subroutine extract_att_real32_1d

module subroutine extract_att_real32_scalar(att, val)
  type(attribute_type), target, intent(in) :: att
  real(real32), intent(out) :: val
  real(real32), pointer :: ptr(:)
  type(c_ptr) :: cptr

  if (att%length > 1) error stop "Attribute value is a vector."
  cptr = c_loc(att%buffer(1))
  call c_f_pointer(cptr, ptr, [att%length])
  val = ptr(1)
end subroutine extract_att_real32_scalar

module subroutine extract_var_real32_1d(var, ptr)
  type(variable_type), target, intent(in) :: var
  real(real32), pointer, intent(out) :: ptr(:)
  type(c_ptr) :: cptr

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real32_1d

module subroutine extract_var_real32_2d(var, ptr)
  type(variable_type), target, intent(in) :: var
  real(real32), pointer, intent(out) :: ptr(:, :)
  type(c_ptr) :: cptr

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real32_2d

module subroutine extract_var_real32_3d(var, ptr)
  type(variable_type), target, intent(in) :: var
  real(real32), pointer, intent(out) :: ptr(:, :, :)
  type(c_ptr) :: cptr

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real32_3d

module subroutine extract_var_real32_4d(var, ptr)
  type(variable_type), target, intent(in) :: var
  real(real32), pointer, intent(out) :: ptr(:, :, :, :)
  type(c_ptr) :: cptr

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real32_4d

module subroutine extract_var_real32_5d(var, ptr)
  type(variable_type), target, intent(in) :: var
  real(real32), pointer, intent(out) :: ptr(:, :, :, :, :)
  type(c_ptr) :: cptr

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real32_5d

module subroutine extract_att_real64_1d(att, ptr)
  type(attribute_type), target, intent(in) :: att
  real(real64), pointer, intent(out) :: ptr(:)
  type(c_ptr) :: cptr

  cptr = c_loc(att%buffer(1))
  call c_f_pointer(cptr, ptr, [att%length])
end subroutine extract_att_real64_1d

module subroutine extract_att_real64_scalar(att, val)
  type(attribute_type), target, intent(in) :: att
  real(real64), intent(out) :: val
  real(real64), pointer :: ptr(:)
  type(c_ptr) :: cptr

  if (att%length > 1) error stop "Attribute value is a vector."
  cptr = c_loc(att%buffer(1))
  call c_f_pointer(cptr, ptr, [att%length])
  val = ptr(1)
end subroutine extract_att_real64_scalar

module subroutine extract_var_real64_1d(var, ptr)
  type(variable_type), target, intent(in) :: var
  real(real64), pointer, intent(out) :: ptr(:)
  type(c_ptr) :: cptr

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real64_1d

module subroutine extract_var_real64_2d(var, ptr)
  type(variable_type), target, intent(in) :: var
  real(real64), pointer, intent(out) :: ptr(:, :)
  type(c_ptr) :: cptr

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real64_2d

module subroutine extract_var_real64_3d(var, ptr)
  type(variable_type), target, intent(in) :: var
  real(real64), pointer, intent(out) :: ptr(:, :, :)
  type(c_ptr) :: cptr

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real64_3d

module subroutine extract_var_real64_4d(var, ptr)
  type(variable_type), target, intent(in) :: var
  real(real64), pointer, intent(out) :: ptr(:, :, :, :)
  type(c_ptr) :: cptr

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real64_4d

module subroutine extract_var_real64_5d(var, ptr)
  type(variable_type), target, intent(in) :: var
  real(real64), pointer, intent(out) :: ptr(:, :, :, :, :)
  type(c_ptr) :: cptr

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real64_5d

end submodule submodule_extract
