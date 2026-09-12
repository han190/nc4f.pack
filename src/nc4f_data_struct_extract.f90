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

  call validate_att_data(att, BYTE_TYPE, "[extract_att_int8_vector]")
  if (att%len == 0) then
    nullify (ptr)
    return
  end if
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

  call validate_att_data(att, BYTE_TYPE, "[extract_att_int8_scalar]")
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

  call validate_att_data(att, SHORT_TYPE, "[extract_att_int16_vector]")
  if (att%len == 0) then
    nullify (ptr)
    return
  end if
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

  call validate_att_data(att, SHORT_TYPE, "[extract_att_int16_scalar]")
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

  call validate_att_data(att, INT_TYPE, "[extract_att_int32_vector]")
  if (att%len == 0) then
    nullify (ptr)
    return
  end if
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

  call validate_att_data(att, INT_TYPE, "[extract_att_int32_scalar]")
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

  call validate_att_data(att, INT64_TYPE, "[extract_att_int64_vector]")
  if (att%len == 0) then
    nullify (ptr)
    return
  end if
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

  call validate_att_data(att, INT64_TYPE, "[extract_att_int64_scalar]")
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

  call validate_att_data(att, FLOAT_TYPE, "[extract_att_real32_vector]")
  if (att%len == 0) then
    nullify (ptr)
    return
  end if
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

  call validate_att_data(att, FLOAT_TYPE, "[extract_att_real32_scalar]")
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

  call validate_att_data(att, DOUBLE_TYPE, "[extract_att_real64_vector]")
  if (att%len == 0) then
    nullify (ptr)
    return
  end if
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

  call validate_att_data(att, DOUBLE_TYPE, "[extract_att_real64_scalar]")
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

  call validate_att_data(att, CHAR_TYPE, "[extract_att_char_vector]")
  if (att%len == 0) then
    nullify (ptr)
    return
  end if
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

  call validate_att_data(att, CHAR_TYPE, "[extract_att_char_scalar]")
  allocate (character(len=att%len) :: ptr)
  if (att%len == 0) return
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

  call validate_var_data(var, BYTE_TYPE, 1, "[extract_var_int8_1d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

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

  call validate_var_data(var, BYTE_TYPE, 2, "[extract_var_int8_2d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int8_2d

!> Extract variable data of kind `int8` and rank 3 into `ptr`.
module subroutine extract_var_int8_3d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int8), pointer, intent(out) :: ptr(:, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, BYTE_TYPE, 3, "[extract_var_int8_3d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int8_3d

!> Extract variable data of kind `int8` and rank 4 into `ptr`.
module subroutine extract_var_int8_4d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int8), pointer, intent(out) :: ptr(:, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, BYTE_TYPE, 4, "[extract_var_int8_4d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int8_4d

!> Extract variable data of kind `int8` and rank 5 into `ptr`.
module subroutine extract_var_int8_5d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, BYTE_TYPE, 5, "[extract_var_int8_5d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int8_5d

!> Extract variable data of kind `int8` and rank 6 into `ptr`.
module subroutine extract_var_int8_6d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, BYTE_TYPE, 6, "[extract_var_int8_6d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int8_6d

!> Extract variable data of kind `int8` and rank 7 into `ptr`.
module subroutine extract_var_int8_7d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, BYTE_TYPE, 7, "[extract_var_int8_7d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int8_7d

!> Extract variable data of kind `int8` and rank 8 into `ptr`.
module subroutine extract_var_int8_8d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, BYTE_TYPE, 8, "[extract_var_int8_8d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int8_8d

!> Extract variable data of kind `int8` and rank 9 into `ptr`.
module subroutine extract_var_int8_9d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, BYTE_TYPE, 9, "[extract_var_int8_9d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int8_9d

!> Extract variable data of kind `int8` and rank 10 into `ptr`.
module subroutine extract_var_int8_10d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, BYTE_TYPE, 10, "[extract_var_int8_10d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int8_10d

!> Extract variable data of kind `int8` and rank 11 into `ptr`.
module subroutine extract_var_int8_11d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, BYTE_TYPE, 11, "[extract_var_int8_11d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int8_11d

!> Extract variable data of kind `int8` and rank 12 into `ptr`.
module subroutine extract_var_int8_12d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, BYTE_TYPE, 12, "[extract_var_int8_12d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int8_12d

!> Extract variable data of kind `int8` and rank 13 into `ptr`.
module subroutine extract_var_int8_13d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, BYTE_TYPE, 13, "[extract_var_int8_13d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int8_13d

!> Extract variable data of kind `int8` and rank 14 into `ptr`.
module subroutine extract_var_int8_14d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, BYTE_TYPE, 14, "[extract_var_int8_14d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int8_14d

!> Extract variable data of kind `int8` and rank 15 into `ptr`.
module subroutine extract_var_int8_15d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, BYTE_TYPE, 15, "[extract_var_int8_15d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int8_15d

!> Extract variable data of kind `int16` and rank 1 into `ptr`.
module subroutine extract_var_int16_1d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int16), pointer, intent(out) :: ptr(:)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, SHORT_TYPE, 1, "[extract_var_int16_1d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

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

  call validate_var_data(var, SHORT_TYPE, 2, "[extract_var_int16_2d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int16_2d

!> Extract variable data of kind `int16` and rank 3 into `ptr`.
module subroutine extract_var_int16_3d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int16), pointer, intent(out) :: ptr(:, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, SHORT_TYPE, 3, "[extract_var_int16_3d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int16_3d

!> Extract variable data of kind `int16` and rank 4 into `ptr`.
module subroutine extract_var_int16_4d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int16), pointer, intent(out) :: ptr(:, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, SHORT_TYPE, 4, "[extract_var_int16_4d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int16_4d

!> Extract variable data of kind `int16` and rank 5 into `ptr`.
module subroutine extract_var_int16_5d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, SHORT_TYPE, 5, "[extract_var_int16_5d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int16_5d

!> Extract variable data of kind `int16` and rank 6 into `ptr`.
module subroutine extract_var_int16_6d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, SHORT_TYPE, 6, "[extract_var_int16_6d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int16_6d

!> Extract variable data of kind `int16` and rank 7 into `ptr`.
module subroutine extract_var_int16_7d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, SHORT_TYPE, 7, "[extract_var_int16_7d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int16_7d

!> Extract variable data of kind `int16` and rank 8 into `ptr`.
module subroutine extract_var_int16_8d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, SHORT_TYPE, 8, "[extract_var_int16_8d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int16_8d

!> Extract variable data of kind `int16` and rank 9 into `ptr`.
module subroutine extract_var_int16_9d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, SHORT_TYPE, 9, "[extract_var_int16_9d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int16_9d

!> Extract variable data of kind `int16` and rank 10 into `ptr`.
module subroutine extract_var_int16_10d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, SHORT_TYPE, 10, "[extract_var_int16_10d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int16_10d

!> Extract variable data of kind `int16` and rank 11 into `ptr`.
module subroutine extract_var_int16_11d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, SHORT_TYPE, 11, "[extract_var_int16_11d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int16_11d

!> Extract variable data of kind `int16` and rank 12 into `ptr`.
module subroutine extract_var_int16_12d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, SHORT_TYPE, 12, "[extract_var_int16_12d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int16_12d

!> Extract variable data of kind `int16` and rank 13 into `ptr`.
module subroutine extract_var_int16_13d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, SHORT_TYPE, 13, "[extract_var_int16_13d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int16_13d

!> Extract variable data of kind `int16` and rank 14 into `ptr`.
module subroutine extract_var_int16_14d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, SHORT_TYPE, 14, "[extract_var_int16_14d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int16_14d

!> Extract variable data of kind `int16` and rank 15 into `ptr`.
module subroutine extract_var_int16_15d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, SHORT_TYPE, 15, "[extract_var_int16_15d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int16_15d

!> Extract variable data of kind `int32` and rank 1 into `ptr`.
module subroutine extract_var_int32_1d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int32), pointer, intent(out) :: ptr(:)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, INT_TYPE, 1, "[extract_var_int32_1d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

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

  call validate_var_data(var, INT_TYPE, 2, "[extract_var_int32_2d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int32_2d

!> Extract variable data of kind `int32` and rank 3 into `ptr`.
module subroutine extract_var_int32_3d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int32), pointer, intent(out) :: ptr(:, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, INT_TYPE, 3, "[extract_var_int32_3d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int32_3d

!> Extract variable data of kind `int32` and rank 4 into `ptr`.
module subroutine extract_var_int32_4d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int32), pointer, intent(out) :: ptr(:, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, INT_TYPE, 4, "[extract_var_int32_4d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int32_4d

!> Extract variable data of kind `int32` and rank 5 into `ptr`.
module subroutine extract_var_int32_5d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, INT_TYPE, 5, "[extract_var_int32_5d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int32_5d

!> Extract variable data of kind `int32` and rank 6 into `ptr`.
module subroutine extract_var_int32_6d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, INT_TYPE, 6, "[extract_var_int32_6d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int32_6d

!> Extract variable data of kind `int32` and rank 7 into `ptr`.
module subroutine extract_var_int32_7d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, INT_TYPE, 7, "[extract_var_int32_7d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int32_7d

!> Extract variable data of kind `int32` and rank 8 into `ptr`.
module subroutine extract_var_int32_8d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, INT_TYPE, 8, "[extract_var_int32_8d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int32_8d

!> Extract variable data of kind `int32` and rank 9 into `ptr`.
module subroutine extract_var_int32_9d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, INT_TYPE, 9, "[extract_var_int32_9d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int32_9d

!> Extract variable data of kind `int32` and rank 10 into `ptr`.
module subroutine extract_var_int32_10d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, INT_TYPE, 10, "[extract_var_int32_10d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int32_10d

!> Extract variable data of kind `int32` and rank 11 into `ptr`.
module subroutine extract_var_int32_11d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, INT_TYPE, 11, "[extract_var_int32_11d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int32_11d

!> Extract variable data of kind `int32` and rank 12 into `ptr`.
module subroutine extract_var_int32_12d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, INT_TYPE, 12, "[extract_var_int32_12d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int32_12d

!> Extract variable data of kind `int32` and rank 13 into `ptr`.
module subroutine extract_var_int32_13d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, INT_TYPE, 13, "[extract_var_int32_13d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int32_13d

!> Extract variable data of kind `int32` and rank 14 into `ptr`.
module subroutine extract_var_int32_14d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, INT_TYPE, 14, "[extract_var_int32_14d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int32_14d

!> Extract variable data of kind `int32` and rank 15 into `ptr`.
module subroutine extract_var_int32_15d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, INT_TYPE, 15, "[extract_var_int32_15d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int32_15d

!> Extract variable data of kind `int64` and rank 1 into `ptr`.
module subroutine extract_var_int64_1d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int64), pointer, intent(out) :: ptr(:)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, INT64_TYPE, 1, "[extract_var_int64_1d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

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

  call validate_var_data(var, INT64_TYPE, 2, "[extract_var_int64_2d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int64_2d

!> Extract variable data of kind `int64` and rank 3 into `ptr`.
module subroutine extract_var_int64_3d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int64), pointer, intent(out) :: ptr(:, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, INT64_TYPE, 3, "[extract_var_int64_3d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int64_3d

!> Extract variable data of kind `int64` and rank 4 into `ptr`.
module subroutine extract_var_int64_4d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int64), pointer, intent(out) :: ptr(:, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, INT64_TYPE, 4, "[extract_var_int64_4d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int64_4d

!> Extract variable data of kind `int64` and rank 5 into `ptr`.
module subroutine extract_var_int64_5d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, INT64_TYPE, 5, "[extract_var_int64_5d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int64_5d

!> Extract variable data of kind `int64` and rank 6 into `ptr`.
module subroutine extract_var_int64_6d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, INT64_TYPE, 6, "[extract_var_int64_6d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int64_6d

!> Extract variable data of kind `int64` and rank 7 into `ptr`.
module subroutine extract_var_int64_7d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, INT64_TYPE, 7, "[extract_var_int64_7d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int64_7d

!> Extract variable data of kind `int64` and rank 8 into `ptr`.
module subroutine extract_var_int64_8d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, INT64_TYPE, 8, "[extract_var_int64_8d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int64_8d

!> Extract variable data of kind `int64` and rank 9 into `ptr`.
module subroutine extract_var_int64_9d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, INT64_TYPE, 9, "[extract_var_int64_9d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int64_9d

!> Extract variable data of kind `int64` and rank 10 into `ptr`.
module subroutine extract_var_int64_10d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, INT64_TYPE, 10, "[extract_var_int64_10d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int64_10d

!> Extract variable data of kind `int64` and rank 11 into `ptr`.
module subroutine extract_var_int64_11d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, INT64_TYPE, 11, "[extract_var_int64_11d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int64_11d

!> Extract variable data of kind `int64` and rank 12 into `ptr`.
module subroutine extract_var_int64_12d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, INT64_TYPE, 12, "[extract_var_int64_12d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int64_12d

!> Extract variable data of kind `int64` and rank 13 into `ptr`.
module subroutine extract_var_int64_13d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, INT64_TYPE, 13, "[extract_var_int64_13d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int64_13d

!> Extract variable data of kind `int64` and rank 14 into `ptr`.
module subroutine extract_var_int64_14d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, INT64_TYPE, 14, "[extract_var_int64_14d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int64_14d

!> Extract variable data of kind `int64` and rank 15 into `ptr`.
module subroutine extract_var_int64_15d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, INT64_TYPE, 15, "[extract_var_int64_15d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_int64_15d

!> Extract variable data of kind `real32` and rank 1 into `ptr`.
module subroutine extract_var_real32_1d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  real(real32), pointer, intent(out) :: ptr(:)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, FLOAT_TYPE, 1, "[extract_var_real32_1d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

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

  call validate_var_data(var, FLOAT_TYPE, 2, "[extract_var_real32_2d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_real32_2d

!> Extract variable data of kind `real32` and rank 3 into `ptr`.
module subroutine extract_var_real32_3d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  real(real32), pointer, intent(out) :: ptr(:, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, FLOAT_TYPE, 3, "[extract_var_real32_3d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_real32_3d

!> Extract variable data of kind `real32` and rank 4 into `ptr`.
module subroutine extract_var_real32_4d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  real(real32), pointer, intent(out) :: ptr(:, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, FLOAT_TYPE, 4, "[extract_var_real32_4d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_real32_4d

!> Extract variable data of kind `real32` and rank 5 into `ptr`.
module subroutine extract_var_real32_5d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  real(real32), pointer, intent(out) :: ptr(:, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, FLOAT_TYPE, 5, "[extract_var_real32_5d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_real32_5d

!> Extract variable data of kind `real32` and rank 6 into `ptr`.
module subroutine extract_var_real32_6d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  real(real32), pointer, intent(out) :: ptr(:, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, FLOAT_TYPE, 6, "[extract_var_real32_6d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_real32_6d

!> Extract variable data of kind `real32` and rank 7 into `ptr`.
module subroutine extract_var_real32_7d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  real(real32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, FLOAT_TYPE, 7, "[extract_var_real32_7d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_real32_7d

!> Extract variable data of kind `real32` and rank 8 into `ptr`.
module subroutine extract_var_real32_8d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  real(real32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, FLOAT_TYPE, 8, "[extract_var_real32_8d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_real32_8d

!> Extract variable data of kind `real32` and rank 9 into `ptr`.
module subroutine extract_var_real32_9d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  real(real32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, FLOAT_TYPE, 9, "[extract_var_real32_9d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_real32_9d

!> Extract variable data of kind `real32` and rank 10 into `ptr`.
module subroutine extract_var_real32_10d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  real(real32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, FLOAT_TYPE, 10, "[extract_var_real32_10d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_real32_10d

!> Extract variable data of kind `real32` and rank 11 into `ptr`.
module subroutine extract_var_real32_11d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  real(real32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, FLOAT_TYPE, 11, "[extract_var_real32_11d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_real32_11d

!> Extract variable data of kind `real32` and rank 12 into `ptr`.
module subroutine extract_var_real32_12d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  real(real32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, FLOAT_TYPE, 12, "[extract_var_real32_12d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_real32_12d

!> Extract variable data of kind `real32` and rank 13 into `ptr`.
module subroutine extract_var_real32_13d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  real(real32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, FLOAT_TYPE, 13, "[extract_var_real32_13d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_real32_13d

!> Extract variable data of kind `real32` and rank 14 into `ptr`.
module subroutine extract_var_real32_14d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  real(real32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, FLOAT_TYPE, 14, "[extract_var_real32_14d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_real32_14d

!> Extract variable data of kind `real32` and rank 15 into `ptr`.
module subroutine extract_var_real32_15d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  real(real32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, FLOAT_TYPE, 15, "[extract_var_real32_15d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_real32_15d

!> Extract variable data of kind `real64` and rank 1 into `ptr`.
module subroutine extract_var_real64_1d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  real(real64), pointer, intent(out) :: ptr(:)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, DOUBLE_TYPE, 1, "[extract_var_real64_1d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

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

  call validate_var_data(var, DOUBLE_TYPE, 2, "[extract_var_real64_2d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_real64_2d

!> Extract variable data of kind `real64` and rank 3 into `ptr`.
module subroutine extract_var_real64_3d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  real(real64), pointer, intent(out) :: ptr(:, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, DOUBLE_TYPE, 3, "[extract_var_real64_3d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_real64_3d

!> Extract variable data of kind `real64` and rank 4 into `ptr`.
module subroutine extract_var_real64_4d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  real(real64), pointer, intent(out) :: ptr(:, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, DOUBLE_TYPE, 4, "[extract_var_real64_4d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_real64_4d

!> Extract variable data of kind `real64` and rank 5 into `ptr`.
module subroutine extract_var_real64_5d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  real(real64), pointer, intent(out) :: ptr(:, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, DOUBLE_TYPE, 5, "[extract_var_real64_5d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_real64_5d

!> Extract variable data of kind `real64` and rank 6 into `ptr`.
module subroutine extract_var_real64_6d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  real(real64), pointer, intent(out) :: ptr(:, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, DOUBLE_TYPE, 6, "[extract_var_real64_6d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_real64_6d

!> Extract variable data of kind `real64` and rank 7 into `ptr`.
module subroutine extract_var_real64_7d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  real(real64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, DOUBLE_TYPE, 7, "[extract_var_real64_7d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_real64_7d

!> Extract variable data of kind `real64` and rank 8 into `ptr`.
module subroutine extract_var_real64_8d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  real(real64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, DOUBLE_TYPE, 8, "[extract_var_real64_8d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_real64_8d

!> Extract variable data of kind `real64` and rank 9 into `ptr`.
module subroutine extract_var_real64_9d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  real(real64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, DOUBLE_TYPE, 9, "[extract_var_real64_9d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_real64_9d

!> Extract variable data of kind `real64` and rank 10 into `ptr`.
module subroutine extract_var_real64_10d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  real(real64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, DOUBLE_TYPE, 10, "[extract_var_real64_10d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_real64_10d

!> Extract variable data of kind `real64` and rank 11 into `ptr`.
module subroutine extract_var_real64_11d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  real(real64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, DOUBLE_TYPE, 11, "[extract_var_real64_11d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_real64_11d

!> Extract variable data of kind `real64` and rank 12 into `ptr`.
module subroutine extract_var_real64_12d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  real(real64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, DOUBLE_TYPE, 12, "[extract_var_real64_12d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_real64_12d

!> Extract variable data of kind `real64` and rank 13 into `ptr`.
module subroutine extract_var_real64_13d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  real(real64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, DOUBLE_TYPE, 13, "[extract_var_real64_13d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_real64_13d

!> Extract variable data of kind `real64` and rank 14 into `ptr`.
module subroutine extract_var_real64_14d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  real(real64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, DOUBLE_TYPE, 14, "[extract_var_real64_14d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_real64_14d

!> Extract variable data of kind `real64` and rank 15 into `ptr`.
module subroutine extract_var_real64_15d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching element kind and rank.
  real(real64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, DOUBLE_TYPE, 15, "[extract_var_real64_15d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_real64_15d

!> Extract character variable data of rank 1 into `ptr`.
module subroutine extract_var_char_1d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching rank.
  character, pointer, intent(out) :: ptr(:)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, CHAR_TYPE, 1, "[extract_var_char_1d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, [var%len])
end subroutine extract_var_char_1d

!> Extract character variable data of rank 2 into `ptr`.
module subroutine extract_var_char_2d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching rank.
  character, pointer, intent(out) :: ptr(:, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, CHAR_TYPE, 2, "[extract_var_char_2d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_char_2d

!> Extract character variable data of rank 3 into `ptr`.
module subroutine extract_var_char_3d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching rank.
  character, pointer, intent(out) :: ptr(:, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, CHAR_TYPE, 3, "[extract_var_char_3d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_char_3d

!> Extract character variable data of rank 4 into `ptr`.
module subroutine extract_var_char_4d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching rank.
  character, pointer, intent(out) :: ptr(:, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, CHAR_TYPE, 4, "[extract_var_char_4d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_char_4d

!> Extract character variable data of rank 5 into `ptr`.
module subroutine extract_var_char_5d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching rank.
  character, pointer, intent(out) :: ptr(:, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, CHAR_TYPE, 5, "[extract_var_char_5d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_char_5d

!> Extract character variable data of rank 6 into `ptr`.
module subroutine extract_var_char_6d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching rank.
  character, pointer, intent(out) :: ptr(:, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, CHAR_TYPE, 6, "[extract_var_char_6d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_char_6d

!> Extract character variable data of rank 7 into `ptr`.
module subroutine extract_var_char_7d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching rank.
  character, pointer, intent(out) :: ptr(:, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, CHAR_TYPE, 7, "[extract_var_char_7d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_char_7d

!> Extract character variable data of rank 8 into `ptr`.
module subroutine extract_var_char_8d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching rank.
  character, pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, CHAR_TYPE, 8, "[extract_var_char_8d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_char_8d

!> Extract character variable data of rank 9 into `ptr`.
module subroutine extract_var_char_9d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching rank.
  character, pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, CHAR_TYPE, 9, "[extract_var_char_9d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_char_9d

!> Extract character variable data of rank 10 into `ptr`.
module subroutine extract_var_char_10d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching rank.
  character, pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, CHAR_TYPE, 10, "[extract_var_char_10d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_char_10d

!> Extract character variable data of rank 11 into `ptr`.
module subroutine extract_var_char_11d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching rank.
  character, pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, CHAR_TYPE, 11, "[extract_var_char_11d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_char_11d

!> Extract character variable data of rank 12 into `ptr`.
module subroutine extract_var_char_12d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching rank.
  character, pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, CHAR_TYPE, 12, "[extract_var_char_12d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_char_12d

!> Extract character variable data of rank 13 into `ptr`.
module subroutine extract_var_char_13d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching rank.
  character, pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, CHAR_TYPE, 13, "[extract_var_char_13d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_char_13d

!> Extract character variable data of rank 14 into `ptr`.
module subroutine extract_var_char_14d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching rank.
  character, pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, CHAR_TYPE, 14, "[extract_var_char_14d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_char_14d

!> Extract character variable data of rank 15 into `ptr`.
module subroutine extract_var_char_15d(var, ptr)
  !> Source variable whose buffer will be mapped.
  type(variable_type), target, intent(in) :: var
  !> Output pointer with matching rank.
  character, pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !> C pointer used to map the variable buffer into the Fortran pointer.
  type(c_ptr) :: cptr

  call validate_var_data(var, CHAR_TYPE, 15, "[extract_var_char_15d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = c_loc(var%buffer(1))
  call c_f_pointer(cptr, ptr, get_shape_(var))
end subroutine extract_var_char_15d

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
