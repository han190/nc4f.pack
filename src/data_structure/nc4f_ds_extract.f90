submodule(nc4f_ds) nc4f_ds_extract
implicit none (type, external)
contains

module subroutine extract_att_int8_vector(att, ptr)
  !! Extract attribute data of kind `int8` as a `vector` from `att`.
  type(attribute_type), target, intent(in) :: att
  !! Source attribute to extract from.
  integer(int8), pointer, intent(out) :: ptr(:)
  !! Output vector of `integer` of kind `int8`.
  type(c_ptr) :: cptr
  !! C pointer used to map the attribute buffer into the Fortran pointer.

  call validate(att, BYTE_TYPE, "[extract_att_int8_vector]")
  if (att%len == 0) then
    nullify (ptr)
    return
  end if
  cptr = buffer2cptr(att)
  call c_f_pointer(cptr, ptr, [att%len])
end subroutine extract_att_int8_vector

module subroutine extract_att_int8_scalar(att, ptr)
  !! Extract attribute data of kind `int8` as a `scalar` from `att`.
  type(attribute_type), target, intent(in) :: att
  !! Source attribute to extract from.
  integer(int8), pointer, intent(out) :: ptr
  !! Output scalar `integer` of kind `int8`.
  type(c_ptr) :: cptr
  !! C pointer used to map the attribute buffer into the Fortran pointer.

  call validate(att, BYTE_TYPE, "[extract_att_int8_scalar]")
  if (att%len /= 1) error stop &
    & "[extract_att_int8_scalar] Not a scalar."
  cptr = buffer2cptr(att)
  call c_f_pointer(cptr, ptr)
end subroutine extract_att_int8_scalar

module subroutine extract_att_int16_vector(att, ptr)
  !! Extract attribute data of kind `int16` as a `vector` from `att`.
  type(attribute_type), target, intent(in) :: att
  !! Source attribute to extract from.
  integer(int16), pointer, intent(out) :: ptr(:)
  !! Output vector of `integer` of kind `int16`.
  type(c_ptr) :: cptr
  !! C pointer used to map the attribute buffer into the Fortran pointer.

  call validate(att, SHORT_TYPE, "[extract_att_int16_vector]")
  if (att%len == 0) then
    nullify (ptr)
    return
  end if
  cptr = buffer2cptr(att)
  call c_f_pointer(cptr, ptr, [att%len])
end subroutine extract_att_int16_vector

module subroutine extract_att_int16_scalar(att, ptr)
  !! Extract attribute data of kind `int16` as a `scalar` from `att`.
  type(attribute_type), target, intent(in) :: att
  !! Source attribute to extract from.
  integer(int16), pointer, intent(out) :: ptr
  !! Output scalar `integer` of kind `int16`.
  type(c_ptr) :: cptr
  !! C pointer used to map the attribute buffer into the Fortran pointer.

  call validate(att, SHORT_TYPE, "[extract_att_int16_scalar]")
  if (att%len /= 1) error stop &
    & "[extract_att_int16_scalar] Not a scalar."
  cptr = buffer2cptr(att)
  call c_f_pointer(cptr, ptr)
end subroutine extract_att_int16_scalar

module subroutine extract_att_int32_vector(att, ptr)
  !! Extract attribute data of kind `int32` as a `vector` from `att`.
  type(attribute_type), target, intent(in) :: att
  !! Source attribute to extract from.
  integer(int32), pointer, intent(out) :: ptr(:)
  !! Output vector of `integer` of kind `int32`.
  type(c_ptr) :: cptr
  !! C pointer used to map the attribute buffer into the Fortran pointer.

  call validate(att, INT_TYPE, "[extract_att_int32_vector]")
  if (att%len == 0) then
    nullify (ptr)
    return
  end if
  cptr = buffer2cptr(att)
  call c_f_pointer(cptr, ptr, [att%len])
end subroutine extract_att_int32_vector

module subroutine extract_att_int32_scalar(att, ptr)
  !! Extract attribute data of kind `int32` as a `scalar` from `att`.
  type(attribute_type), target, intent(in) :: att
  !! Source attribute to extract from.
  integer(int32), pointer, intent(out) :: ptr
  !! Output scalar `integer` of kind `int32`.
  type(c_ptr) :: cptr
  !! C pointer used to map the attribute buffer into the Fortran pointer.

  call validate(att, INT_TYPE, "[extract_att_int32_scalar]")
  if (att%len /= 1) error stop &
    & "[extract_att_int32_scalar] Not a scalar."
  cptr = buffer2cptr(att)
  call c_f_pointer(cptr, ptr)
end subroutine extract_att_int32_scalar

module subroutine extract_att_int64_vector(att, ptr)
  !! Extract attribute data of kind `int64` as a `vector` from `att`.
  type(attribute_type), target, intent(in) :: att
  !! Source attribute to extract from.
  integer(int64), pointer, intent(out) :: ptr(:)
  !! Output vector of `integer` of kind `int64`.
  type(c_ptr) :: cptr
  !! C pointer used to map the attribute buffer into the Fortran pointer.

  call validate(att, INT64_TYPE, "[extract_att_int64_vector]")
  if (att%len == 0) then
    nullify (ptr)
    return
  end if
  cptr = buffer2cptr(att)
  call c_f_pointer(cptr, ptr, [att%len])
end subroutine extract_att_int64_vector

module subroutine extract_att_int64_scalar(att, ptr)
  !! Extract attribute data of kind `int64` as a `scalar` from `att`.
  type(attribute_type), target, intent(in) :: att
  !! Source attribute to extract from.
  integer(int64), pointer, intent(out) :: ptr
  !! Output scalar `integer` of kind `int64`.
  type(c_ptr) :: cptr
  !! C pointer used to map the attribute buffer into the Fortran pointer.

  call validate(att, INT64_TYPE, "[extract_att_int64_scalar]")
  if (att%len /= 1) error stop &
    & "[extract_att_int64_scalar] Not a scalar."
  cptr = buffer2cptr(att)
  call c_f_pointer(cptr, ptr)
end subroutine extract_att_int64_scalar

module subroutine extract_att_real32_vector(att, ptr)
  !! Extract attribute data of kind `real32` as a `vector` from `att`.
  type(attribute_type), target, intent(in) :: att
  !! Source attribute to extract from.
  real(real32), pointer, intent(out) :: ptr(:)
  !! Output vector of `real` of kind `real32`.
  type(c_ptr) :: cptr
  !! C pointer used to map the attribute buffer into the Fortran pointer.

  call validate(att, FLOAT_TYPE, "[extract_att_real32_vector]")
  if (att%len == 0) then
    nullify (ptr)
    return
  end if
  cptr = buffer2cptr(att)
  call c_f_pointer(cptr, ptr, [att%len])
end subroutine extract_att_real32_vector

module subroutine extract_att_real32_scalar(att, ptr)
  !! Extract attribute data of kind `real32` as a `scalar` from `att`.
  type(attribute_type), target, intent(in) :: att
  !! Source attribute to extract from.
  real(real32), pointer, intent(out) :: ptr
  !! Output scalar `real` of kind `real32`.
  type(c_ptr) :: cptr
  !! C pointer used to map the attribute buffer into the Fortran pointer.

  call validate(att, FLOAT_TYPE, "[extract_att_real32_scalar]")
  if (att%len /= 1) error stop &
    & "[extract_att_real32_scalar] Not a scalar."
  cptr = buffer2cptr(att)
  call c_f_pointer(cptr, ptr)
end subroutine extract_att_real32_scalar

module subroutine extract_att_real64_vector(att, ptr)
  !! Extract attribute data of kind `real64` as a `vector` from `att`.
  type(attribute_type), target, intent(in) :: att
  !! Source attribute to extract from.
  real(real64), pointer, intent(out) :: ptr(:)
  !! Output vector of `real` of kind `real64`.
  type(c_ptr) :: cptr
  !! C pointer used to map the attribute buffer into the Fortran pointer.

  call validate(att, DOUBLE_TYPE, "[extract_att_real64_vector]")
  if (att%len == 0) then
    nullify (ptr)
    return
  end if
  cptr = buffer2cptr(att)
  call c_f_pointer(cptr, ptr, [att%len])
end subroutine extract_att_real64_vector

module subroutine extract_att_real64_scalar(att, ptr)
  !! Extract attribute data of kind `real64` as a `scalar` from `att`.
  type(attribute_type), target, intent(in) :: att
  !! Source attribute to extract from.
  real(real64), pointer, intent(out) :: ptr
  !! Output scalar `real` of kind `real64`.
  type(c_ptr) :: cptr
  !! C pointer used to map the attribute buffer into the Fortran pointer.

  call validate(att, DOUBLE_TYPE, "[extract_att_real64_scalar]")
  if (att%len /= 1) error stop &
    & "[extract_att_real64_scalar] Not a scalar."
  cptr = buffer2cptr(att)
  call c_f_pointer(cptr, ptr)
end subroutine extract_att_real64_scalar

module subroutine extract_att_char_vector(att, ptr)
  !! Extract attribute data of kind `char` as a `vector` from `att`.
  type(attribute_type), target, intent(in) :: att
  !! Source attribute to extract from.
  character, pointer, intent(out) :: ptr(:)
  !! Output vector of characters.
  type(c_ptr) :: cptr
  !! C pointer used to map the attribute buffer into the Fortran pointer.

  call validate(att, CHAR_TYPE, "[extract_att_char_vector]")
  if (att%len == 0) then
    nullify (ptr)
    return
  end if
  cptr = buffer2cptr(att)
  call c_f_pointer(cptr, ptr, [att%len])
end subroutine extract_att_char_vector

module subroutine extract_att_char_scalar(att, ptr)
  !! Extract attribute data of kind `char` as a `scalar` from `att`.
  type(attribute_type), target, intent(in) :: att
  !! Source attribute to extract from.
  character(len=:), pointer, intent(out) :: ptr
  !! Output scalar string (allocated by caller via pointer assignment).
  character, pointer :: ptrs(:)
  !! Temporary vector of characters used for scalar extraction.
  integer :: i
  !! Loop index for copying characters.

  call validate(att, CHAR_TYPE, "[extract_att_char_scalar]")
  allocate (character(len=att%len) :: ptr)
  if (att%len == 0) return
  call extract_att_char_vector(att, ptrs)
  do i = 1, size(ptrs)
    ptr(i:i) = ptrs(i)
  end do
end subroutine extract_att_char_scalar

module subroutine extract_var_int8_1d(var, ptr)
  !! Extract variable data of kind `int8` and rank 1 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int8), pointer, intent(out) :: ptr(:)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, BYTE_TYPE, 1, "[extract_var_int8_1d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, [var%len])
end subroutine extract_var_int8_1d

module subroutine extract_var_int8_2d(var, ptr)
  !! Extract variable data of kind `int8` and rank 2 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int8), pointer, intent(out) :: ptr(:, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, BYTE_TYPE, 2, "[extract_var_int8_2d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int8_2d

module subroutine extract_var_int8_3d(var, ptr)
  !! Extract variable data of kind `int8` and rank 3 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int8), pointer, intent(out) :: ptr(:, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, BYTE_TYPE, 3, "[extract_var_int8_3d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int8_3d

module subroutine extract_var_int8_4d(var, ptr)
  !! Extract variable data of kind `int8` and rank 4 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int8), pointer, intent(out) :: ptr(:, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, BYTE_TYPE, 4, "[extract_var_int8_4d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int8_4d

module subroutine extract_var_int8_5d(var, ptr)
  !! Extract variable data of kind `int8` and rank 5 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, BYTE_TYPE, 5, "[extract_var_int8_5d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int8_5d

module subroutine extract_var_int8_6d(var, ptr)
  !! Extract variable data of kind `int8` and rank 6 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, BYTE_TYPE, 6, "[extract_var_int8_6d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int8_6d

module subroutine extract_var_int8_7d(var, ptr)
  !! Extract variable data of kind `int8` and rank 7 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, BYTE_TYPE, 7, "[extract_var_int8_7d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int8_7d

module subroutine extract_var_int8_8d(var, ptr)
  !! Extract variable data of kind `int8` and rank 8 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, BYTE_TYPE, 8, "[extract_var_int8_8d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int8_8d

module subroutine extract_var_int8_9d(var, ptr)
  !! Extract variable data of kind `int8` and rank 9 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, BYTE_TYPE, 9, "[extract_var_int8_9d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int8_9d

module subroutine extract_var_int8_10d(var, ptr)
  !! Extract variable data of kind `int8` and rank 10 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, BYTE_TYPE, 10, "[extract_var_int8_10d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int8_10d

module subroutine extract_var_int8_11d(var, ptr)
  !! Extract variable data of kind `int8` and rank 11 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, BYTE_TYPE, 11, "[extract_var_int8_11d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int8_11d

module subroutine extract_var_int8_12d(var, ptr)
  !! Extract variable data of kind `int8` and rank 12 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, BYTE_TYPE, 12, "[extract_var_int8_12d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int8_12d

module subroutine extract_var_int8_13d(var, ptr)
  !! Extract variable data of kind `int8` and rank 13 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, BYTE_TYPE, 13, "[extract_var_int8_13d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int8_13d

module subroutine extract_var_int8_14d(var, ptr)
  !! Extract variable data of kind `int8` and rank 14 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, BYTE_TYPE, 14, "[extract_var_int8_14d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int8_14d

module subroutine extract_var_int8_15d(var, ptr)
  !! Extract variable data of kind `int8` and rank 15 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, BYTE_TYPE, 15, "[extract_var_int8_15d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int8_15d

module subroutine extract_var_int16_1d(var, ptr)
  !! Extract variable data of kind `int16` and rank 1 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int16), pointer, intent(out) :: ptr(:)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, SHORT_TYPE, 1, "[extract_var_int16_1d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, [var%len])
end subroutine extract_var_int16_1d

module subroutine extract_var_int16_2d(var, ptr)
  !! Extract variable data of kind `int16` and rank 2 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int16), pointer, intent(out) :: ptr(:, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, SHORT_TYPE, 2, "[extract_var_int16_2d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int16_2d

module subroutine extract_var_int16_3d(var, ptr)
  !! Extract variable data of kind `int16` and rank 3 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int16), pointer, intent(out) :: ptr(:, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, SHORT_TYPE, 3, "[extract_var_int16_3d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int16_3d

module subroutine extract_var_int16_4d(var, ptr)
  !! Extract variable data of kind `int16` and rank 4 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int16), pointer, intent(out) :: ptr(:, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, SHORT_TYPE, 4, "[extract_var_int16_4d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int16_4d

module subroutine extract_var_int16_5d(var, ptr)
  !! Extract variable data of kind `int16` and rank 5 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, SHORT_TYPE, 5, "[extract_var_int16_5d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int16_5d

module subroutine extract_var_int16_6d(var, ptr)
  !! Extract variable data of kind `int16` and rank 6 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, SHORT_TYPE, 6, "[extract_var_int16_6d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int16_6d

module subroutine extract_var_int16_7d(var, ptr)
  !! Extract variable data of kind `int16` and rank 7 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, SHORT_TYPE, 7, "[extract_var_int16_7d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int16_7d

module subroutine extract_var_int16_8d(var, ptr)
  !! Extract variable data of kind `int16` and rank 8 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, SHORT_TYPE, 8, "[extract_var_int16_8d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int16_8d

module subroutine extract_var_int16_9d(var, ptr)
  !! Extract variable data of kind `int16` and rank 9 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, SHORT_TYPE, 9, "[extract_var_int16_9d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int16_9d

module subroutine extract_var_int16_10d(var, ptr)
  !! Extract variable data of kind `int16` and rank 10 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, SHORT_TYPE, 10, "[extract_var_int16_10d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int16_10d

module subroutine extract_var_int16_11d(var, ptr)
  !! Extract variable data of kind `int16` and rank 11 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, SHORT_TYPE, 11, "[extract_var_int16_11d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int16_11d

module subroutine extract_var_int16_12d(var, ptr)
  !! Extract variable data of kind `int16` and rank 12 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, SHORT_TYPE, 12, "[extract_var_int16_12d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int16_12d

module subroutine extract_var_int16_13d(var, ptr)
  !! Extract variable data of kind `int16` and rank 13 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, SHORT_TYPE, 13, "[extract_var_int16_13d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int16_13d

module subroutine extract_var_int16_14d(var, ptr)
  !! Extract variable data of kind `int16` and rank 14 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, SHORT_TYPE, 14, "[extract_var_int16_14d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int16_14d

module subroutine extract_var_int16_15d(var, ptr)
  !! Extract variable data of kind `int16` and rank 15 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, SHORT_TYPE, 15, "[extract_var_int16_15d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int16_15d

module subroutine extract_var_int32_1d(var, ptr)
  !! Extract variable data of kind `int32` and rank 1 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int32), pointer, intent(out) :: ptr(:)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, INT_TYPE, 1, "[extract_var_int32_1d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, [var%len])
end subroutine extract_var_int32_1d

module subroutine extract_var_int32_2d(var, ptr)
  !! Extract variable data of kind `int32` and rank 2 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int32), pointer, intent(out) :: ptr(:, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, INT_TYPE, 2, "[extract_var_int32_2d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int32_2d

module subroutine extract_var_int32_3d(var, ptr)
  !! Extract variable data of kind `int32` and rank 3 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int32), pointer, intent(out) :: ptr(:, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, INT_TYPE, 3, "[extract_var_int32_3d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int32_3d

module subroutine extract_var_int32_4d(var, ptr)
  !! Extract variable data of kind `int32` and rank 4 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int32), pointer, intent(out) :: ptr(:, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, INT_TYPE, 4, "[extract_var_int32_4d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int32_4d

module subroutine extract_var_int32_5d(var, ptr)
  !! Extract variable data of kind `int32` and rank 5 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, INT_TYPE, 5, "[extract_var_int32_5d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int32_5d

module subroutine extract_var_int32_6d(var, ptr)
  !! Extract variable data of kind `int32` and rank 6 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, INT_TYPE, 6, "[extract_var_int32_6d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int32_6d

module subroutine extract_var_int32_7d(var, ptr)
  !! Extract variable data of kind `int32` and rank 7 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, INT_TYPE, 7, "[extract_var_int32_7d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int32_7d

module subroutine extract_var_int32_8d(var, ptr)
  !! Extract variable data of kind `int32` and rank 8 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, INT_TYPE, 8, "[extract_var_int32_8d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int32_8d

module subroutine extract_var_int32_9d(var, ptr)
  !! Extract variable data of kind `int32` and rank 9 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, INT_TYPE, 9, "[extract_var_int32_9d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int32_9d

module subroutine extract_var_int32_10d(var, ptr)
  !! Extract variable data of kind `int32` and rank 10 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, INT_TYPE, 10, "[extract_var_int32_10d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int32_10d

module subroutine extract_var_int32_11d(var, ptr)
  !! Extract variable data of kind `int32` and rank 11 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, INT_TYPE, 11, "[extract_var_int32_11d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int32_11d

module subroutine extract_var_int32_12d(var, ptr)
  !! Extract variable data of kind `int32` and rank 12 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, INT_TYPE, 12, "[extract_var_int32_12d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int32_12d

module subroutine extract_var_int32_13d(var, ptr)
  !! Extract variable data of kind `int32` and rank 13 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, INT_TYPE, 13, "[extract_var_int32_13d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int32_13d

module subroutine extract_var_int32_14d(var, ptr)
  !! Extract variable data of kind `int32` and rank 14 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, INT_TYPE, 14, "[extract_var_int32_14d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int32_14d

module subroutine extract_var_int32_15d(var, ptr)
  !! Extract variable data of kind `int32` and rank 15 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, INT_TYPE, 15, "[extract_var_int32_15d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int32_15d

module subroutine extract_var_int64_1d(var, ptr)
  !! Extract variable data of kind `int64` and rank 1 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int64), pointer, intent(out) :: ptr(:)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, INT64_TYPE, 1, "[extract_var_int64_1d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, [var%len])
end subroutine extract_var_int64_1d

module subroutine extract_var_int64_2d(var, ptr)
  !! Extract variable data of kind `int64` and rank 2 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int64), pointer, intent(out) :: ptr(:, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, INT64_TYPE, 2, "[extract_var_int64_2d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int64_2d

module subroutine extract_var_int64_3d(var, ptr)
  !! Extract variable data of kind `int64` and rank 3 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int64), pointer, intent(out) :: ptr(:, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, INT64_TYPE, 3, "[extract_var_int64_3d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int64_3d

module subroutine extract_var_int64_4d(var, ptr)
  !! Extract variable data of kind `int64` and rank 4 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int64), pointer, intent(out) :: ptr(:, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, INT64_TYPE, 4, "[extract_var_int64_4d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int64_4d

module subroutine extract_var_int64_5d(var, ptr)
  !! Extract variable data of kind `int64` and rank 5 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, INT64_TYPE, 5, "[extract_var_int64_5d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int64_5d

module subroutine extract_var_int64_6d(var, ptr)
  !! Extract variable data of kind `int64` and rank 6 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, INT64_TYPE, 6, "[extract_var_int64_6d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int64_6d

module subroutine extract_var_int64_7d(var, ptr)
  !! Extract variable data of kind `int64` and rank 7 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, INT64_TYPE, 7, "[extract_var_int64_7d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int64_7d

module subroutine extract_var_int64_8d(var, ptr)
  !! Extract variable data of kind `int64` and rank 8 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, INT64_TYPE, 8, "[extract_var_int64_8d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int64_8d

module subroutine extract_var_int64_9d(var, ptr)
  !! Extract variable data of kind `int64` and rank 9 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, INT64_TYPE, 9, "[extract_var_int64_9d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int64_9d

module subroutine extract_var_int64_10d(var, ptr)
  !! Extract variable data of kind `int64` and rank 10 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, INT64_TYPE, 10, "[extract_var_int64_10d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int64_10d

module subroutine extract_var_int64_11d(var, ptr)
  !! Extract variable data of kind `int64` and rank 11 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, INT64_TYPE, 11, "[extract_var_int64_11d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int64_11d

module subroutine extract_var_int64_12d(var, ptr)
  !! Extract variable data of kind `int64` and rank 12 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, INT64_TYPE, 12, "[extract_var_int64_12d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int64_12d

module subroutine extract_var_int64_13d(var, ptr)
  !! Extract variable data of kind `int64` and rank 13 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, INT64_TYPE, 13, "[extract_var_int64_13d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int64_13d

module subroutine extract_var_int64_14d(var, ptr)
  !! Extract variable data of kind `int64` and rank 14 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, INT64_TYPE, 14, "[extract_var_int64_14d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int64_14d

module subroutine extract_var_int64_15d(var, ptr)
  !! Extract variable data of kind `int64` and rank 15 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, INT64_TYPE, 15, "[extract_var_int64_15d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_int64_15d

module subroutine extract_var_real32_1d(var, ptr)
  !! Extract variable data of kind `real32` and rank 1 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  real(real32), pointer, intent(out) :: ptr(:)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, FLOAT_TYPE, 1, "[extract_var_real32_1d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, [var%len])
end subroutine extract_var_real32_1d

module subroutine extract_var_real32_2d(var, ptr)
  !! Extract variable data of kind `real32` and rank 2 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  real(real32), pointer, intent(out) :: ptr(:, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, FLOAT_TYPE, 2, "[extract_var_real32_2d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real32_2d

module subroutine extract_var_real32_3d(var, ptr)
  !! Extract variable data of kind `real32` and rank 3 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  real(real32), pointer, intent(out) :: ptr(:, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, FLOAT_TYPE, 3, "[extract_var_real32_3d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real32_3d

module subroutine extract_var_real32_4d(var, ptr)
  !! Extract variable data of kind `real32` and rank 4 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  real(real32), pointer, intent(out) :: ptr(:, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, FLOAT_TYPE, 4, "[extract_var_real32_4d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real32_4d

module subroutine extract_var_real32_5d(var, ptr)
  !! Extract variable data of kind `real32` and rank 5 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  real(real32), pointer, intent(out) :: ptr(:, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, FLOAT_TYPE, 5, "[extract_var_real32_5d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real32_5d

module subroutine extract_var_real32_6d(var, ptr)
  !! Extract variable data of kind `real32` and rank 6 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  real(real32), pointer, intent(out) :: ptr(:, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, FLOAT_TYPE, 6, "[extract_var_real32_6d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real32_6d

module subroutine extract_var_real32_7d(var, ptr)
  !! Extract variable data of kind `real32` and rank 7 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  real(real32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, FLOAT_TYPE, 7, "[extract_var_real32_7d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real32_7d

module subroutine extract_var_real32_8d(var, ptr)
  !! Extract variable data of kind `real32` and rank 8 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  real(real32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, FLOAT_TYPE, 8, "[extract_var_real32_8d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real32_8d

module subroutine extract_var_real32_9d(var, ptr)
  !! Extract variable data of kind `real32` and rank 9 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  real(real32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, FLOAT_TYPE, 9, "[extract_var_real32_9d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real32_9d

module subroutine extract_var_real32_10d(var, ptr)
  !! Extract variable data of kind `real32` and rank 10 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  real(real32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, FLOAT_TYPE, 10, "[extract_var_real32_10d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real32_10d

module subroutine extract_var_real32_11d(var, ptr)
  !! Extract variable data of kind `real32` and rank 11 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  real(real32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, FLOAT_TYPE, 11, "[extract_var_real32_11d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real32_11d

module subroutine extract_var_real32_12d(var, ptr)
  !! Extract variable data of kind `real32` and rank 12 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  real(real32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, FLOAT_TYPE, 12, "[extract_var_real32_12d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real32_12d

module subroutine extract_var_real32_13d(var, ptr)
  !! Extract variable data of kind `real32` and rank 13 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  real(real32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, FLOAT_TYPE, 13, "[extract_var_real32_13d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real32_13d

module subroutine extract_var_real32_14d(var, ptr)
  !! Extract variable data of kind `real32` and rank 14 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  real(real32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, FLOAT_TYPE, 14, "[extract_var_real32_14d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real32_14d

module subroutine extract_var_real32_15d(var, ptr)
  !! Extract variable data of kind `real32` and rank 15 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  real(real32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, FLOAT_TYPE, 15, "[extract_var_real32_15d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real32_15d

module subroutine extract_var_real64_1d(var, ptr)
  !! Extract variable data of kind `real64` and rank 1 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  real(real64), pointer, intent(out) :: ptr(:)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, DOUBLE_TYPE, 1, "[extract_var_real64_1d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, [var%len])
end subroutine extract_var_real64_1d

module subroutine extract_var_real64_2d(var, ptr)
  !! Extract variable data of kind `real64` and rank 2 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  real(real64), pointer, intent(out) :: ptr(:, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, DOUBLE_TYPE, 2, "[extract_var_real64_2d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real64_2d

module subroutine extract_var_real64_3d(var, ptr)
  !! Extract variable data of kind `real64` and rank 3 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  real(real64), pointer, intent(out) :: ptr(:, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, DOUBLE_TYPE, 3, "[extract_var_real64_3d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real64_3d

module subroutine extract_var_real64_4d(var, ptr)
  !! Extract variable data of kind `real64` and rank 4 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  real(real64), pointer, intent(out) :: ptr(:, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, DOUBLE_TYPE, 4, "[extract_var_real64_4d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real64_4d

module subroutine extract_var_real64_5d(var, ptr)
  !! Extract variable data of kind `real64` and rank 5 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  real(real64), pointer, intent(out) :: ptr(:, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, DOUBLE_TYPE, 5, "[extract_var_real64_5d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real64_5d

module subroutine extract_var_real64_6d(var, ptr)
  !! Extract variable data of kind `real64` and rank 6 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  real(real64), pointer, intent(out) :: ptr(:, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, DOUBLE_TYPE, 6, "[extract_var_real64_6d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real64_6d

module subroutine extract_var_real64_7d(var, ptr)
  !! Extract variable data of kind `real64` and rank 7 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  real(real64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, DOUBLE_TYPE, 7, "[extract_var_real64_7d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real64_7d

module subroutine extract_var_real64_8d(var, ptr)
  !! Extract variable data of kind `real64` and rank 8 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  real(real64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, DOUBLE_TYPE, 8, "[extract_var_real64_8d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real64_8d

module subroutine extract_var_real64_9d(var, ptr)
  !! Extract variable data of kind `real64` and rank 9 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  real(real64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, DOUBLE_TYPE, 9, "[extract_var_real64_9d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real64_9d

module subroutine extract_var_real64_10d(var, ptr)
  !! Extract variable data of kind `real64` and rank 10 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  real(real64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, DOUBLE_TYPE, 10, "[extract_var_real64_10d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real64_10d

module subroutine extract_var_real64_11d(var, ptr)
  !! Extract variable data of kind `real64` and rank 11 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  real(real64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, DOUBLE_TYPE, 11, "[extract_var_real64_11d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real64_11d

module subroutine extract_var_real64_12d(var, ptr)
  !! Extract variable data of kind `real64` and rank 12 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  real(real64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, DOUBLE_TYPE, 12, "[extract_var_real64_12d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real64_12d

module subroutine extract_var_real64_13d(var, ptr)
  !! Extract variable data of kind `real64` and rank 13 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  real(real64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, DOUBLE_TYPE, 13, "[extract_var_real64_13d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real64_13d

module subroutine extract_var_real64_14d(var, ptr)
  !! Extract variable data of kind `real64` and rank 14 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  real(real64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, DOUBLE_TYPE, 14, "[extract_var_real64_14d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real64_14d

module subroutine extract_var_real64_15d(var, ptr)
  !! Extract variable data of kind `real64` and rank 15 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  real(real64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !! Output pointer with matching element kind and rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, DOUBLE_TYPE, 15, "[extract_var_real64_15d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_real64_15d

module subroutine extract_var_char_1d(var, ptr)
  !! Extract character variable data of rank 1 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  character, pointer, intent(out) :: ptr(:)
  !! Output pointer with matching rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, CHAR_TYPE, 1, "[extract_var_char_1d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, [var%len])
end subroutine extract_var_char_1d

module subroutine extract_var_char_2d(var, ptr)
  !! Extract character variable data of rank 2 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  character, pointer, intent(out) :: ptr(:, :)
  !! Output pointer with matching rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, CHAR_TYPE, 2, "[extract_var_char_2d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_char_2d

module subroutine extract_var_char_3d(var, ptr)
  !! Extract character variable data of rank 3 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  character, pointer, intent(out) :: ptr(:, :, :)
  !! Output pointer with matching rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, CHAR_TYPE, 3, "[extract_var_char_3d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_char_3d

module subroutine extract_var_char_4d(var, ptr)
  !! Extract character variable data of rank 4 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  character, pointer, intent(out) :: ptr(:, :, :, :)
  !! Output pointer with matching rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, CHAR_TYPE, 4, "[extract_var_char_4d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_char_4d

module subroutine extract_var_char_5d(var, ptr)
  !! Extract character variable data of rank 5 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  character, pointer, intent(out) :: ptr(:, :, :, :, :)
  !! Output pointer with matching rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, CHAR_TYPE, 5, "[extract_var_char_5d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_char_5d

module subroutine extract_var_char_6d(var, ptr)
  !! Extract character variable data of rank 6 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  character, pointer, intent(out) :: ptr(:, :, :, :, :, :)
  !! Output pointer with matching rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, CHAR_TYPE, 6, "[extract_var_char_6d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_char_6d

module subroutine extract_var_char_7d(var, ptr)
  !! Extract character variable data of rank 7 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  character, pointer, intent(out) :: ptr(:, :, :, :, :, :, :)
  !! Output pointer with matching rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, CHAR_TYPE, 7, "[extract_var_char_7d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_char_7d

module subroutine extract_var_char_8d(var, ptr)
  !! Extract character variable data of rank 8 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  character, pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :)
  !! Output pointer with matching rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, CHAR_TYPE, 8, "[extract_var_char_8d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_char_8d

module subroutine extract_var_char_9d(var, ptr)
  !! Extract character variable data of rank 9 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  character, pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :)
  !! Output pointer with matching rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, CHAR_TYPE, 9, "[extract_var_char_9d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_char_9d

module subroutine extract_var_char_10d(var, ptr)
  !! Extract character variable data of rank 10 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  character, pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :)
  !! Output pointer with matching rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, CHAR_TYPE, 10, "[extract_var_char_10d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_char_10d

module subroutine extract_var_char_11d(var, ptr)
  !! Extract character variable data of rank 11 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  character, pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :)
  !! Output pointer with matching rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, CHAR_TYPE, 11, "[extract_var_char_11d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_char_11d

module subroutine extract_var_char_12d(var, ptr)
  !! Extract character variable data of rank 12 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  character, pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :)
  !! Output pointer with matching rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, CHAR_TYPE, 12, "[extract_var_char_12d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_char_12d

module subroutine extract_var_char_13d(var, ptr)
  !! Extract character variable data of rank 13 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  character, pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :)
  !! Output pointer with matching rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, CHAR_TYPE, 13, "[extract_var_char_13d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_char_13d

module subroutine extract_var_char_14d(var, ptr)
  !! Extract character variable data of rank 14 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  character, pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !! Output pointer with matching rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, CHAR_TYPE, 14, "[extract_var_char_14d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_char_14d

module subroutine extract_var_char_15d(var, ptr)
  !! Extract character variable data of rank 15 into `ptr`.
  type(variable_type), target, intent(in) :: var
  !! Source variable whose buffer will be mapped.
  character, pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !! Output pointer with matching rank.
  type(c_ptr) :: cptr
  !! C pointer used to map the variable buffer into the Fortran pointer.

  call validate(var, CHAR_TYPE, 15, "[extract_var_char_15d]")
  if (var%len == 0) then
    nullify (ptr)
    return
  end if

  cptr = buffer2cptr(var)
  call c_f_pointer(cptr, ptr, shape(var))
end subroutine extract_var_char_15d

pure function dtype2kind(dtype) result(kind_val)
  !! Map a netCDF integer type code to a Fortran `kind` value.
  integer(data_type), intent(in) :: dtype
  !! NetCDF integer type code (NC_* constant) to map.
  integer :: kind_val
  !! Returned Fortran `kind` corresponding to the netCDF type.

  select case (dtype)
  case (NAT_TYPE)
    error stop "[dtype2kind] Not a type."
  case (BYTE_TYPE)
    kind_val = kind(0_int8)
  case (CHAR_TYPE)
    kind_val = kind("")
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

end submodule nc4f_ds_extract
