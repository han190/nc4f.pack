submodule(nc4f) nc4f_extract
implicit none (type, external)
contains

module subroutine extract_att_int8_vector(att, ptr)
  type(attribute_type), target, intent(in) :: att
  integer(int8), pointer, intent(out) :: ptr(:)
  type(c_ptr) :: cptr

  cptr = c_loc(att%buffer(1))
  call c_f_pointer(cptr, ptr, [att%len])
end subroutine extract_att_int8_vector

module subroutine extract_att_int8_scalar(att, ptr)
  type(attribute_type), target, intent(in) :: att
  integer(int8), pointer, intent(out) :: ptr
  type(c_ptr) :: cptr

  if (att%len /= 1) error stop &
    & "[extract_att_int8_scalar] Not a scalar."
  cptr = c_loc(att%buffer(1))
  call c_f_pointer(cptr, ptr)
end subroutine extract_att_int8_scalar

module subroutine extract_att_int16_vector(att, ptr)
  type(attribute_type), target, intent(in) :: att
  integer(int16), pointer, intent(out) :: ptr(:)
  type(c_ptr) :: cptr

  cptr = c_loc(att%buffer(1))
  call c_f_pointer(cptr, ptr, [att%len])
end subroutine extract_att_int16_vector

module subroutine extract_att_int16_scalar(att, ptr)
  type(attribute_type), target, intent(in) :: att
  integer(int16), pointer, intent(out) :: ptr
  type(c_ptr) :: cptr

  if (att%len /= 1) error stop &
    & "[extract_att_int16_scalar] Not a scalar."
  cptr = c_loc(att%buffer(1))
  call c_f_pointer(cptr, ptr)
end subroutine extract_att_int16_scalar

module subroutine extract_att_int32_vector(att, ptr)
  type(attribute_type), target, intent(in) :: att
  integer(int32), pointer, intent(out) :: ptr(:)
  type(c_ptr) :: cptr

  cptr = c_loc(att%buffer(1))
  call c_f_pointer(cptr, ptr, [att%len])
end subroutine extract_att_int32_vector

module subroutine extract_att_int32_scalar(att, ptr)
  type(attribute_type), target, intent(in) :: att
  integer(int32), pointer, intent(out) :: ptr
  type(c_ptr) :: cptr

  if (att%len /= 1) error stop &
    & "[extract_att_int32_scalar] Not a scalar."
  cptr = c_loc(att%buffer(1))
  call c_f_pointer(cptr, ptr)
end subroutine extract_att_int32_scalar

module subroutine extract_att_int64_vector(att, ptr)
  type(attribute_type), target, intent(in) :: att
  integer(int64), pointer, intent(out) :: ptr(:)
  type(c_ptr) :: cptr

  cptr = c_loc(att%buffer(1))
  call c_f_pointer(cptr, ptr, [att%len])
end subroutine extract_att_int64_vector

module subroutine extract_att_int64_scalar(att, ptr)
  type(attribute_type), target, intent(in) :: att
  integer(int64), pointer, intent(out) :: ptr
  type(c_ptr) :: cptr

  if (att%len /= 1) error stop &
    & "[extract_att_int64_scalar] Not a scalar."
  cptr = c_loc(att%buffer(1))
  call c_f_pointer(cptr, ptr)
end subroutine extract_att_int64_scalar

module subroutine extract_att_real32_vector(att, ptr)
  type(attribute_type), target, intent(in) :: att
  real(real32), pointer, intent(out) :: ptr(:)
  type(c_ptr) :: cptr

  cptr = c_loc(att%buffer(1))
  call c_f_pointer(cptr, ptr, [att%len])
end subroutine extract_att_real32_vector

module subroutine extract_att_real32_scalar(att, ptr)
  type(attribute_type), target, intent(in) :: att
  real(real32), pointer, intent(out) :: ptr
  type(c_ptr) :: cptr

  if (att%len /= 1) error stop &
    & "[extract_att_real32_scalar] Not a scalar."
  cptr = c_loc(att%buffer(1))
  call c_f_pointer(cptr, ptr)
end subroutine extract_att_real32_scalar

module subroutine extract_att_real64_vector(att, ptr)
  type(attribute_type), target, intent(in) :: att
  real(real64), pointer, intent(out) :: ptr(:)
  type(c_ptr) :: cptr

  cptr = c_loc(att%buffer(1))
  call c_f_pointer(cptr, ptr, [att%len])
end subroutine extract_att_real64_vector

module subroutine extract_att_real64_scalar(att, ptr)
  type(attribute_type), target, intent(in) :: att
  real(real64), pointer, intent(out) :: ptr
  type(c_ptr) :: cptr

  if (att%len /= 1) error stop &
    & "[extract_att_real64_scalar] Not a scalar."
  cptr = c_loc(att%buffer(1))
  call c_f_pointer(cptr, ptr)
end subroutine extract_att_real64_scalar

module subroutine extract_att_char_vector(att, ptr)
  type(attribute_type), target, intent(in) :: att
  character, pointer, intent(out) :: ptr(:)
  type(c_ptr) :: cptr

  cptr = c_loc(att%buffer(1))
  call c_f_pointer(cptr, ptr, [att%len])
end subroutine extract_att_char_vector

module subroutine extract_att_char_scalar(att, ptr)
  type(attribute_type), target, intent(in) :: att
  character(len=:), pointer, intent(out) :: ptr
  character, pointer :: ptrs(:)
  integer :: i

  call extract_att_char_vector(att, ptrs)
  do i = 1, size(ptrs)
    ptr(i:i) = ptrs(i)
  end do
end subroutine extract_att_char_scalar

module subroutine extract_var_int8_1d(var, ptr)
  type(variable_type), target, intent(in) :: var
  integer(int8), pointer, intent(out) :: ptr(:)
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int8_1d] Invalid rank."
  end associate
  if (nc2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int8_1d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, [var%len])
end subroutine extract_var_int8_1d

module subroutine extract_var_int8_2d(var, ptr)
  type(variable_type), target, intent(in) :: var
  integer(int8), pointer, intent(out) :: ptr(:, :)
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int8_2d] Invalid rank."
  end associate
  if (nc2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int8_2d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int8_2d

module subroutine extract_var_int8_3d(var, ptr)
  type(variable_type), target, intent(in) :: var
  integer(int8), pointer, intent(out) :: ptr(:, :, :)
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int8_3d] Invalid rank."
  end associate
  if (nc2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int8_3d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int8_3d

module subroutine extract_var_int8_4d(var, ptr)
  type(variable_type), target, intent(in) :: var
  integer(int8), pointer, intent(out) :: ptr(:, :, :, :)
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int8_4d] Invalid rank."
  end associate
  if (nc2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int8_4d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int8_4d

module subroutine extract_var_int8_5d(var, ptr)
  type(variable_type), target, intent(in) :: var
  integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :)
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int8_5d] Invalid rank."
  end associate
  if (nc2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int8_5d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int8_5d

module subroutine extract_var_int8_6d(var, ptr)
  type(variable_type), target, intent(in) :: var
  integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :, :)
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int8_6d] Invalid rank."
  end associate
  if (nc2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int8_6d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int8_6d

module subroutine extract_var_int8_7d(var, ptr)
  type(variable_type), target, intent(in) :: var
  integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :, :, :)
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int8_7d] Invalid rank."
  end associate
  if (nc2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int8_7d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int8_7d

module subroutine extract_var_int16_1d(var, ptr)
  type(variable_type), target, intent(in) :: var
  integer(int16), pointer, intent(out) :: ptr(:)
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int16_1d] Invalid rank."
  end associate
  if (nc2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int16_1d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, [var%len])
end subroutine extract_var_int16_1d

module subroutine extract_var_int16_2d(var, ptr)
  type(variable_type), target, intent(in) :: var
  integer(int16), pointer, intent(out) :: ptr(:, :)
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int16_2d] Invalid rank."
  end associate
  if (nc2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int16_2d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int16_2d

module subroutine extract_var_int16_3d(var, ptr)
  type(variable_type), target, intent(in) :: var
  integer(int16), pointer, intent(out) :: ptr(:, :, :)
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int16_3d] Invalid rank."
  end associate
  if (nc2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int16_3d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int16_3d

module subroutine extract_var_int16_4d(var, ptr)
  type(variable_type), target, intent(in) :: var
  integer(int16), pointer, intent(out) :: ptr(:, :, :, :)
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int16_4d] Invalid rank."
  end associate
  if (nc2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int16_4d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int16_4d

module subroutine extract_var_int16_5d(var, ptr)
  type(variable_type), target, intent(in) :: var
  integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :)
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int16_5d] Invalid rank."
  end associate
  if (nc2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int16_5d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int16_5d

module subroutine extract_var_int16_6d(var, ptr)
  type(variable_type), target, intent(in) :: var
  integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :, :)
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int16_6d] Invalid rank."
  end associate
  if (nc2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int16_6d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int16_6d

module subroutine extract_var_int16_7d(var, ptr)
  type(variable_type), target, intent(in) :: var
  integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :, :, :)
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int16_7d] Invalid rank."
  end associate
  if (nc2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int16_7d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int16_7d

module subroutine extract_var_int32_1d(var, ptr)
  type(variable_type), target, intent(in) :: var
  integer(int32), pointer, intent(out) :: ptr(:)
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int32_1d] Invalid rank."
  end associate
  if (nc2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int32_1d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, [var%len])
end subroutine extract_var_int32_1d

module subroutine extract_var_int32_2d(var, ptr)
  type(variable_type), target, intent(in) :: var
  integer(int32), pointer, intent(out) :: ptr(:, :)
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int32_2d] Invalid rank."
  end associate
  if (nc2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int32_2d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int32_2d

module subroutine extract_var_int32_3d(var, ptr)
  type(variable_type), target, intent(in) :: var
  integer(int32), pointer, intent(out) :: ptr(:, :, :)
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int32_3d] Invalid rank."
  end associate
  if (nc2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int32_3d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int32_3d

module subroutine extract_var_int32_4d(var, ptr)
  type(variable_type), target, intent(in) :: var
  integer(int32), pointer, intent(out) :: ptr(:, :, :, :)
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int32_4d] Invalid rank."
  end associate
  if (nc2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int32_4d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int32_4d

module subroutine extract_var_int32_5d(var, ptr)
  type(variable_type), target, intent(in) :: var
  integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :)
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int32_5d] Invalid rank."
  end associate
  if (nc2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int32_5d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int32_5d

module subroutine extract_var_int32_6d(var, ptr)
  type(variable_type), target, intent(in) :: var
  integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :, :)
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int32_6d] Invalid rank."
  end associate
  if (nc2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int32_6d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int32_6d

module subroutine extract_var_int32_7d(var, ptr)
  type(variable_type), target, intent(in) :: var
  integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :)
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int32_7d] Invalid rank."
  end associate
  if (nc2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int32_7d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int32_7d

module subroutine extract_var_int64_1d(var, ptr)
  type(variable_type), target, intent(in) :: var
  integer(int64), pointer, intent(out) :: ptr(:)
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int64_1d] Invalid rank."
  end associate
  if (nc2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int64_1d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, [var%len])
end subroutine extract_var_int64_1d

module subroutine extract_var_int64_2d(var, ptr)
  type(variable_type), target, intent(in) :: var
  integer(int64), pointer, intent(out) :: ptr(:, :)
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int64_2d] Invalid rank."
  end associate
  if (nc2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int64_2d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int64_2d

module subroutine extract_var_int64_3d(var, ptr)
  type(variable_type), target, intent(in) :: var
  integer(int64), pointer, intent(out) :: ptr(:, :, :)
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int64_3d] Invalid rank."
  end associate
  if (nc2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int64_3d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int64_3d

module subroutine extract_var_int64_4d(var, ptr)
  type(variable_type), target, intent(in) :: var
  integer(int64), pointer, intent(out) :: ptr(:, :, :, :)
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int64_4d] Invalid rank."
  end associate
  if (nc2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int64_4d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int64_4d

module subroutine extract_var_int64_5d(var, ptr)
  type(variable_type), target, intent(in) :: var
  integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :)
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int64_5d] Invalid rank."
  end associate
  if (nc2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int64_5d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int64_5d

module subroutine extract_var_int64_6d(var, ptr)
  type(variable_type), target, intent(in) :: var
  integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :, :)
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int64_6d] Invalid rank."
  end associate
  if (nc2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int64_6d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int64_6d

module subroutine extract_var_int64_7d(var, ptr)
  type(variable_type), target, intent(in) :: var
  integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :)
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int64_7d] Invalid rank."
  end associate
  if (nc2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int64_7d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int64_7d

module subroutine extract_var_real32_1d(var, ptr)
  type(variable_type), target, intent(in) :: var
  real(real32), pointer, intent(out) :: ptr(:)
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_real32_1d] Invalid rank."
  end associate
  if (nc2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_real32_1d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, [var%len])
end subroutine extract_var_real32_1d

module subroutine extract_var_real32_2d(var, ptr)
  type(variable_type), target, intent(in) :: var
  real(real32), pointer, intent(out) :: ptr(:, :)
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_real32_2d] Invalid rank."
  end associate
  if (nc2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_real32_2d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real32_2d

module subroutine extract_var_real32_3d(var, ptr)
  type(variable_type), target, intent(in) :: var
  real(real32), pointer, intent(out) :: ptr(:, :, :)
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_real32_3d] Invalid rank."
  end associate
  if (nc2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_real32_3d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real32_3d

module subroutine extract_var_real32_4d(var, ptr)
  type(variable_type), target, intent(in) :: var
  real(real32), pointer, intent(out) :: ptr(:, :, :, :)
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_real32_4d] Invalid rank."
  end associate
  if (nc2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_real32_4d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real32_4d

module subroutine extract_var_real32_5d(var, ptr)
  type(variable_type), target, intent(in) :: var
  real(real32), pointer, intent(out) :: ptr(:, :, :, :, :)
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_real32_5d] Invalid rank."
  end associate
  if (nc2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_real32_5d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real32_5d

module subroutine extract_var_real32_6d(var, ptr)
  type(variable_type), target, intent(in) :: var
  real(real32), pointer, intent(out) :: ptr(:, :, :, :, :, :)
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_real32_6d] Invalid rank."
  end associate
  if (nc2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_real32_6d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real32_6d

module subroutine extract_var_real32_7d(var, ptr)
  type(variable_type), target, intent(in) :: var
  real(real32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :)
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_real32_7d] Invalid rank."
  end associate
  if (nc2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_real32_7d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real32_7d

module subroutine extract_var_real64_1d(var, ptr)
  type(variable_type), target, intent(in) :: var
  real(real64), pointer, intent(out) :: ptr(:)
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_real64_1d] Invalid rank."
  end associate
  if (nc2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_real64_1d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, [var%len])
end subroutine extract_var_real64_1d

module subroutine extract_var_real64_2d(var, ptr)
  type(variable_type), target, intent(in) :: var
  real(real64), pointer, intent(out) :: ptr(:, :)
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_real64_2d] Invalid rank."
  end associate
  if (nc2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_real64_2d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real64_2d

module subroutine extract_var_real64_3d(var, ptr)
  type(variable_type), target, intent(in) :: var
  real(real64), pointer, intent(out) :: ptr(:, :, :)
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_real64_3d] Invalid rank."
  end associate
  if (nc2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_real64_3d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real64_3d

module subroutine extract_var_real64_4d(var, ptr)
  type(variable_type), target, intent(in) :: var
  real(real64), pointer, intent(out) :: ptr(:, :, :, :)
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_real64_4d] Invalid rank."
  end associate
  if (nc2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_real64_4d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real64_4d

module subroutine extract_var_real64_5d(var, ptr)
  type(variable_type), target, intent(in) :: var
  real(real64), pointer, intent(out) :: ptr(:, :, :, :, :)
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_real64_5d] Invalid rank."
  end associate
  if (nc2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_real64_5d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real64_5d

module subroutine extract_var_real64_6d(var, ptr)
  type(variable_type), target, intent(in) :: var
  real(real64), pointer, intent(out) :: ptr(:, :, :, :, :, :)
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_real64_6d] Invalid rank."
  end associate
  if (nc2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_real64_6d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real64_6d

module subroutine extract_var_real64_7d(var, ptr)
  type(variable_type), target, intent(in) :: var
  real(real64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :)
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_real64_7d] Invalid rank."
  end associate
  if (nc2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_real64_7d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real64_7d

pure function nc2kind(nc_type) result(kind_val)
  integer(c_int), intent(in) :: nc_type
  integer :: kind_val

  select case (nc_type)
  case (NC_NAT)
    error stop "[nc2kind] Not a type."
  case (NC_BYTE)
    kind_val = kind(0_int8)
  case (NC_CHAR)
    kind_val = kind('')
  case (NC_SHORT)
    kind_val = kind(0_int16)
  case (NC_INT)
    kind_val = kind(0_int32)
  case (NC_FLOAT)
    kind_val = kind(0._real32)
  case (NC_DOUBLE)
    kind_val = kind(0._real64)
  case (NC_INT64)
    kind_val = kind(0._int64)
  case default
    error stop "[nc2kind] Unsupported type."
  end select
end function nc2kind

end submodule nc4f_extract
