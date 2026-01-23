submodule(nc4f_data_struct) nc4f_data_struct_extract
implicit none (type, external)
contains

!> Extract attribute data of kind `int8` as a `vector` from `att`.
module subroutine extract_att_int8_vector(att, ptr)
  !> Source attribute to extract from.
  type(attribute_type), target, intent(in) :: att
  !> Output vector of `integer` of kind `int8`.
  integer(int8), pointer, intent(out) :: ptr(:)
  !> C pointer used to map the attribute buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  cptr = c_loc(att%buffer(1))
  call c_f_pointer(cptr, ptr, [att%len])
end subroutine extract_att_int8_vector

!> Extract attribute data of kind `int8` as a `scalar` from `att`.
module subroutine extract_att_int8_scalar(att, ptr)
  !> Source attribute to extract from.
  type(attribute_type), target, intent(in) :: att
  !> Output scalar `integer` of kind `int8`.
  integer(int8), pointer, intent(out) :: ptr
  !> C pointer used to map the attribute buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  if (att%len /= 1) error stop &
    & "[extract_att_int8_scalar] Not a scalar."
  cptr = c_loc(att%buffer(1))
  call c_f_pointer(cptr, ptr)
end subroutine extract_att_int8_scalar

!> Extract attribute data of kind `int16` as a `vector` from `att`.
module subroutine extract_att_int16_vector(att, ptr)
  !> Source attribute to extract from.
  type(attribute_type), target, intent(in) :: att
  !> Output vector of `integer` of kind `int16`.
  integer(int16), pointer, intent(out) :: ptr(:)
  !> C pointer used to map the attribute buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  cptr = c_loc(att%buffer(1))
  call c_f_pointer(cptr, ptr, [att%len])
end subroutine extract_att_int16_vector

!> Extract attribute data of kind `int16` as a `scalar` from `att`.
module subroutine extract_att_int16_scalar(att, ptr)
  !> Source attribute to extract from.
  type(attribute_type), target, intent(in) :: att
  !> Output scalar `integer` of kind `int16`.
  integer(int16), pointer, intent(out) :: ptr
  !> C pointer used to map the attribute buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  if (att%len /= 1) error stop &
    & "[extract_att_int16_scalar] Not a scalar."
  cptr = c_loc(att%buffer(1))
  call c_f_pointer(cptr, ptr)
end subroutine extract_att_int16_scalar

!> Extract attribute data of kind `int32` as a `vector` from `att`.
module subroutine extract_att_int32_vector(att, ptr)
  !> Source attribute to extract from.
  type(attribute_type), target, intent(in) :: att
  !> Output vector of `integer` of kind `int32`.
  integer(int32), pointer, intent(out) :: ptr(:)
  !> C pointer used to map the attribute buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  cptr = c_loc(att%buffer(1))
  call c_f_pointer(cptr, ptr, [att%len])
end subroutine extract_att_int32_vector

!> Extract attribute data of kind `int32` as a `scalar` from `att`.
module subroutine extract_att_int32_scalar(att, ptr)
  !> Source attribute to extract from.
  type(attribute_type), target, intent(in) :: att
  !> Output scalar `integer` of kind `int32`.
  integer(int32), pointer, intent(out) :: ptr
  !> C pointer used to map the attribute buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  if (att%len /= 1) error stop &
    & "[extract_att_int32_scalar] Not a scalar."
  cptr = c_loc(att%buffer(1))
  call c_f_pointer(cptr, ptr)
end subroutine extract_att_int32_scalar

!> Extract attribute data of kind `int64` as a `vector` from `att`.
module subroutine extract_att_int64_vector(att, ptr)
  !> Source attribute to extract from.
  type(attribute_type), target, intent(in) :: att
  !> Output vector of `integer` of kind `int64`.
  integer(int64), pointer, intent(out) :: ptr(:)
  !> C pointer used to map the attribute buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  cptr = c_loc(att%buffer(1))
  call c_f_pointer(cptr, ptr, [att%len])
end subroutine extract_att_int64_vector

!> Extract attribute data of kind `int64` as a `scalar` from `att`.
module subroutine extract_att_int64_scalar(att, ptr)
  !> Source attribute to extract from.
  type(attribute_type), target, intent(in) :: att
  !> Output scalar `integer` of kind `int64`.
  integer(int64), pointer, intent(out) :: ptr
  !> C pointer used to map the attribute buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  if (att%len /= 1) error stop &
    & "[extract_att_int64_scalar] Not a scalar."
  cptr = c_loc(att%buffer(1))
  call c_f_pointer(cptr, ptr)
end subroutine extract_att_int64_scalar

!> Extract attribute data of kind `real32` as a `vector` from `att`.
module subroutine extract_att_real32_vector(att, ptr)
  !> Source attribute to extract from.
  type(attribute_type), target, intent(in) :: att
  !> Output vector of `real` of kind `real32`.
  real(real32), pointer, intent(out) :: ptr(:)
  !> C pointer used to map the attribute buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  cptr = c_loc(att%buffer(1))
  call c_f_pointer(cptr, ptr, [att%len])
end subroutine extract_att_real32_vector

!> Extract attribute data of kind `real32` as a `scalar` from `att`.
module subroutine extract_att_real32_scalar(att, ptr)
  !> Source attribute to extract from.
  type(attribute_type), target, intent(in) :: att
  !> Output scalar `real` of kind `real32`.
  real(real32), pointer, intent(out) :: ptr
  !> C pointer used to map the attribute buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  if (att%len /= 1) error stop &
    & "[extract_att_real32_scalar] Not a scalar."
  cptr = c_loc(att%buffer(1))
  call c_f_pointer(cptr, ptr)
end subroutine extract_att_real32_scalar

!> Extract attribute data of kind `real64` as a `vector` from `att`.
module subroutine extract_att_real64_vector(att, ptr)
  !> Source attribute to extract from.
  type(attribute_type), target, intent(in) :: att
  !> Output vector of `real` of kind `real64`.
  real(real64), pointer, intent(out) :: ptr(:)
  !> C pointer used to map the attribute buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  cptr = c_loc(att%buffer(1))
  call c_f_pointer(cptr, ptr, [att%len])
end subroutine extract_att_real64_vector

!> Extract attribute data of kind `real64` as a `scalar` from `att`.
module subroutine extract_att_real64_scalar(att, ptr)
  !> Source attribute to extract from.
  type(attribute_type), target, intent(in) :: att
  !> Output scalar `real` of kind `real64`.
  real(real64), pointer, intent(out) :: ptr
  !> C pointer used to map the attribute buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  if (att%len /= 1) error stop &
    & "[extract_att_real64_scalar] Not a scalar."
  cptr = c_loc(att%buffer(1))
  call c_f_pointer(cptr, ptr)
end subroutine extract_att_real64_scalar

!> Extract attribute data of kind `char` as a `vector` from `att`.
module subroutine extract_att_char_vector(att, ptr)
  !> Source attribute to extract from.
  type(attribute_type), target, intent(in) :: att
  !> Output vector of characters.
  character, pointer, intent(out) :: ptr(:)
  !> C pointer used to map the attribute buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  cptr = c_loc(att%buffer(1))
  call c_f_pointer(cptr, ptr, [att%len])
end subroutine extract_att_char_vector

!> Extract attribute data of kind `char` as a `scalar` from `att`.
module subroutine extract_att_char_scalar(att, ptr)
  !> Source attribute to extract from.
  type(attribute_type), target, intent(in) :: att
  !> Output scalar string (allocated by caller via pointer assignment).
  character(len=:), pointer, intent(out) :: ptr
  !> Temporary vector of characters used for scalar extraction.
  character, pointer :: ptrs(:)
  !> Loop index for copying characters.
  integer :: i

  call extract_att_char_vector(att, ptrs)
  do i = 1, size(ptrs)
    ptr(i:i) = ptrs(i)
  end do
end subroutine extract_att_char_scalar

!> Extract variable data of kind `int8` and rank 1 into `ptr`.
module subroutine extract_var_int8_1d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int8), pointer, intent(out) :: ptr(:)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int8_1d] Invalid rank."
  end associate
  if (dtype2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int8_1d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, [var%len])
end subroutine extract_var_int8_1d

!> Extract variable data of kind `int8` and rank 2 into `ptr`.
module subroutine extract_var_int8_2d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int8), pointer, intent(out) :: ptr(:, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int8_2d] Invalid rank."
  end associate
  if (dtype2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int8_2d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int8_2d

!> Extract variable data of kind `int8` and rank 3 into `ptr`.
module subroutine extract_var_int8_3d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int8), pointer, intent(out) :: ptr(:, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int8_3d] Invalid rank."
  end associate
  if (dtype2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int8_3d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int8_3d

!> Extract variable data of kind `int8` and rank 4 into `ptr`.
module subroutine extract_var_int8_4d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int8), pointer, intent(out) :: ptr(:, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int8_4d] Invalid rank."
  end associate
  if (dtype2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int8_4d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int8_4d

!> Extract variable data of kind `int8` and rank 5 into `ptr`.
module subroutine extract_var_int8_5d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int8_5d] Invalid rank."
  end associate
  if (dtype2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int8_5d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int8_5d

!> Extract variable data of kind `int8` and rank 6 into `ptr`.
module subroutine extract_var_int8_6d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int8_6d] Invalid rank."
  end associate
  if (dtype2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int8_6d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int8_6d

!> Extract variable data of kind `int8` and rank 7 into `ptr`.
module subroutine extract_var_int8_7d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int8_7d] Invalid rank."
  end associate
  if (dtype2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int8_7d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int8_7d

!> Extract variable data of kind `int16` and rank 1 into `ptr`.
module subroutine extract_var_int16_1d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int16), pointer, intent(out) :: ptr(:)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int16_1d] Invalid rank."
  end associate
  if (dtype2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int16_1d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, [var%len])
end subroutine extract_var_int16_1d

!> Extract variable data of kind `int16` and rank 2 into `ptr`.
module subroutine extract_var_int16_2d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int16), pointer, intent(out) :: ptr(:, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int16_2d] Invalid rank."
  end associate
  if (dtype2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int16_2d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int16_2d

!> Extract variable data of kind `int16` and rank 3 into `ptr`.
module subroutine extract_var_int16_3d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int16), pointer, intent(out) :: ptr(:, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int16_3d] Invalid rank."
  end associate
  if (dtype2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int16_3d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int16_3d

!> Extract variable data of kind `int16` and rank 4 into `ptr`.
module subroutine extract_var_int16_4d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int16), pointer, intent(out) :: ptr(:, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int16_4d] Invalid rank."
  end associate
  if (dtype2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int16_4d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int16_4d

!> Extract variable data of kind `int16` and rank 5 into `ptr`.
module subroutine extract_var_int16_5d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int16_5d] Invalid rank."
  end associate
  if (dtype2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int16_5d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int16_5d

!> Extract variable data of kind `int16` and rank 6 into `ptr`.
module subroutine extract_var_int16_6d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int16_6d] Invalid rank."
  end associate
  if (dtype2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int16_6d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int16_6d

!> Extract variable data of kind `int16` and rank 7 into `ptr`.
module subroutine extract_var_int16_7d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int16_7d] Invalid rank."
  end associate
  if (dtype2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int16_7d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int16_7d

!> Extract variable data of kind `int32` and rank 1 into `ptr`.
module subroutine extract_var_int32_1d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int32), pointer, intent(out) :: ptr(:)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int32_1d] Invalid rank."
  end associate
  if (dtype2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int32_1d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, [var%len])
end subroutine extract_var_int32_1d

!> Extract variable data of kind `int32` and rank 2 into `ptr`.
module subroutine extract_var_int32_2d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int32), pointer, intent(out) :: ptr(:, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int32_2d] Invalid rank."
  end associate
  if (dtype2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int32_2d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int32_2d

!> Extract variable data of kind `int32` and rank 3 into `ptr`.
module subroutine extract_var_int32_3d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int32), pointer, intent(out) :: ptr(:, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int32_3d] Invalid rank."
  end associate
  if (dtype2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int32_3d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int32_3d

!> Extract variable data of kind `int32` and rank 4 into `ptr`.
module subroutine extract_var_int32_4d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int32), pointer, intent(out) :: ptr(:, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int32_4d] Invalid rank."
  end associate
  if (dtype2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int32_4d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int32_4d

!> Extract variable data of kind `int32` and rank 5 into `ptr`.
module subroutine extract_var_int32_5d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int32_5d] Invalid rank."
  end associate
  if (dtype2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int32_5d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int32_5d

!> Extract variable data of kind `int32` and rank 6 into `ptr`.
module subroutine extract_var_int32_6d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int32_6d] Invalid rank."
  end associate
  if (dtype2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int32_6d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int32_6d

!> Extract variable data of kind `int32` and rank 7 into `ptr`.
module subroutine extract_var_int32_7d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int32_7d] Invalid rank."
  end associate
  if (dtype2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int32_7d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int32_7d

!> Extract variable data of kind `int64` and rank 1 into `ptr`.
module subroutine extract_var_int64_1d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int64), pointer, intent(out) :: ptr(:)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int64_1d] Invalid rank."
  end associate
  if (dtype2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int64_1d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, [var%len])
end subroutine extract_var_int64_1d

!> Extract variable data of kind `int64` and rank 2 into `ptr`.
module subroutine extract_var_int64_2d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int64), pointer, intent(out) :: ptr(:, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int64_2d] Invalid rank."
  end associate
  if (dtype2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int64_2d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int64_2d

!> Extract variable data of kind `int64` and rank 3 into `ptr`.
module subroutine extract_var_int64_3d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int64), pointer, intent(out) :: ptr(:, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int64_3d] Invalid rank."
  end associate
  if (dtype2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int64_3d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int64_3d

!> Extract variable data of kind `int64` and rank 4 into `ptr`.
module subroutine extract_var_int64_4d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int64), pointer, intent(out) :: ptr(:, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int64_4d] Invalid rank."
  end associate
  if (dtype2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int64_4d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int64_4d

!> Extract variable data of kind `int64` and rank 5 into `ptr`.
module subroutine extract_var_int64_5d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int64_5d] Invalid rank."
  end associate
  if (dtype2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int64_5d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int64_5d

!> Extract variable data of kind `int64` and rank 6 into `ptr`.
module subroutine extract_var_int64_6d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int64_6d] Invalid rank."
  end associate
  if (dtype2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int64_6d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int64_6d

!> Extract variable data of kind `int64` and rank 7 into `ptr`.
module subroutine extract_var_int64_7d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_int64_7d] Invalid rank."
  end associate
  if (dtype2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_int64_7d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int64_7d

!> Extract variable data of kind `real32` and rank 1 into `ptr`.
module subroutine extract_var_real32_1d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  real(real32), pointer, intent(out) :: ptr(:)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_real32_1d] Invalid rank."
  end associate
  if (dtype2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_real32_1d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, [var%len])
end subroutine extract_var_real32_1d

!> Extract variable data of kind `real32` and rank 2 into `ptr`.
module subroutine extract_var_real32_2d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  real(real32), pointer, intent(out) :: ptr(:, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_real32_2d] Invalid rank."
  end associate
  if (dtype2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_real32_2d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real32_2d

!> Extract variable data of kind `real32` and rank 3 into `ptr`.
module subroutine extract_var_real32_3d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  real(real32), pointer, intent(out) :: ptr(:, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_real32_3d] Invalid rank."
  end associate
  if (dtype2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_real32_3d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real32_3d

!> Extract variable data of kind `real32` and rank 4 into `ptr`.
module subroutine extract_var_real32_4d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  real(real32), pointer, intent(out) :: ptr(:, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_real32_4d] Invalid rank."
  end associate
  if (dtype2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_real32_4d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real32_4d

!> Extract variable data of kind `real32` and rank 5 into `ptr`.
module subroutine extract_var_real32_5d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  real(real32), pointer, intent(out) :: ptr(:, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_real32_5d] Invalid rank."
  end associate
  if (dtype2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_real32_5d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real32_5d

!> Extract variable data of kind `real32` and rank 6 into `ptr`.
module subroutine extract_var_real32_6d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  real(real32), pointer, intent(out) :: ptr(:, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_real32_6d] Invalid rank."
  end associate
  if (dtype2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_real32_6d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real32_6d

!> Extract variable data of kind `real32` and rank 7 into `ptr`.
module subroutine extract_var_real32_7d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  real(real32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_real32_7d] Invalid rank."
  end associate
  if (dtype2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_real32_7d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real32_7d

!> Extract variable data of kind `real64` and rank 1 into `ptr`.
module subroutine extract_var_real64_1d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  real(real64), pointer, intent(out) :: ptr(:)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_real64_1d] Invalid rank."
  end associate
  if (dtype2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_real64_1d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, [var%len])
end subroutine extract_var_real64_1d

!> Extract variable data of kind `real64` and rank 2 into `ptr`.
module subroutine extract_var_real64_2d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  real(real64), pointer, intent(out) :: ptr(:, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_real64_2d] Invalid rank."
  end associate
  if (dtype2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_real64_2d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real64_2d

!> Extract variable data of kind `real64` and rank 3 into `ptr`.
module subroutine extract_var_real64_3d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  real(real64), pointer, intent(out) :: ptr(:, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_real64_3d] Invalid rank."
  end associate
  if (dtype2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_real64_3d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real64_3d

!> Extract variable data of kind `real64` and rank 4 into `ptr`.
module subroutine extract_var_real64_4d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  real(real64), pointer, intent(out) :: ptr(:, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_real64_4d] Invalid rank."
  end associate
  if (dtype2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_real64_4d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real64_4d

!> Extract variable data of kind `real64` and rank 5 into `ptr`.
module subroutine extract_var_real64_5d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  real(real64), pointer, intent(out) :: ptr(:, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_real64_5d] Invalid rank."
  end associate
  if (dtype2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_real64_5d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real64_5d

!> Extract variable data of kind `real64` and rank 6 into `ptr`.
module subroutine extract_var_real64_6d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  real(real64), pointer, intent(out) :: ptr(:, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_real64_6d] Invalid rank."
  end associate
  if (dtype2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_real64_6d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real64_6d

!> Extract variable data of kind `real64` and rank 7 into `ptr`.
module subroutine extract_var_real64_7d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  real(real64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  associate (rank_ptr => rank(ptr))
    if (rank_ptr > 1 .and. rank_ptr /= size(shape(var))) error stop &
      & "[extract_var_real64_7d] Invalid rank."
  end associate
  if (dtype2kind(var%dtype) /= kind(ptr)) error stop &
    & "[extract_var_real64_7d] Invalid kind."

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real64_7d

!> Map a netCDF integer type code to a Fortran `kind` value.
pure function dtype2kind(dtype) result(kind_val)
  !> NetCDF integer type code (NC_* constant) to map.
  integer(data_type), intent(in) :: dtype
  !> Returned Fortran `kind` corresponding to the netCDF type.
  integer :: kind_val

  select case (dtype)
  case (NAT_TYPE)
    error stop "[dtype2kind] Not a type."
  case (BYTE_TYPE)
    kind_val = kind(0_int8)
  case (CHAR_TYPE)
    kind_val = kind('')
  case (SHORT_TYPE)
    kind_val = kind(0_int16)
  case (INT_TYPE)
    kind_val = kind(0_int32)
  case (FLOAT_TYPE)
    kind_val = kind(0._real32)
  case (DOUBLE_TYPE)
    kind_val = kind(0._real64)
  case (INT64_TYPE)
    kind_val = kind(0._int64)
  case default
    error stop "[dtype2kind] Unsupported type."
  end select
end function dtype2kind

end submodule nc4f_data_struct_extract
