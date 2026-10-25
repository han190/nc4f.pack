interface extract
  module procedure :: extract_att_int8_vector
  module procedure :: extract_att_int8_scalar
  module procedure :: extract_att_int16_vector
  module procedure :: extract_att_int16_scalar
  module procedure :: extract_att_int32_vector
  module procedure :: extract_att_int32_scalar
  module procedure :: extract_att_int64_vector
  module procedure :: extract_att_int64_scalar
  module procedure :: extract_att_real32_vector
  module procedure :: extract_att_real32_scalar
  module procedure :: extract_att_real64_vector
  module procedure :: extract_att_real64_scalar
  module procedure :: extract_att_char_scalar
  module procedure :: extract_att_char_vector
  module procedure :: extract_var_int8_1d
  module procedure :: extract_var_int8_2d
  module procedure :: extract_var_int8_3d
  module procedure :: extract_var_int8_4d
  module procedure :: extract_var_int8_5d
  module procedure :: extract_var_int8_6d
  module procedure :: extract_var_int8_7d
  module procedure :: extract_var_int8_8d
  module procedure :: extract_var_int8_9d
  module procedure :: extract_var_int8_10d
  module procedure :: extract_var_int8_11d
  module procedure :: extract_var_int8_12d
  module procedure :: extract_var_int8_13d
  module procedure :: extract_var_int8_14d
  module procedure :: extract_var_int8_15d
  module procedure :: extract_var_int16_1d
  module procedure :: extract_var_int16_2d
  module procedure :: extract_var_int16_3d
  module procedure :: extract_var_int16_4d
  module procedure :: extract_var_int16_5d
  module procedure :: extract_var_int16_6d
  module procedure :: extract_var_int16_7d
  module procedure :: extract_var_int16_8d
  module procedure :: extract_var_int16_9d
  module procedure :: extract_var_int16_10d
  module procedure :: extract_var_int16_11d
  module procedure :: extract_var_int16_12d
  module procedure :: extract_var_int16_13d
  module procedure :: extract_var_int16_14d
  module procedure :: extract_var_int16_15d
  module procedure :: extract_var_int32_1d
  module procedure :: extract_var_int32_2d
  module procedure :: extract_var_int32_3d
  module procedure :: extract_var_int32_4d
  module procedure :: extract_var_int32_5d
  module procedure :: extract_var_int32_6d
  module procedure :: extract_var_int32_7d
  module procedure :: extract_var_int32_8d
  module procedure :: extract_var_int32_9d
  module procedure :: extract_var_int32_10d
  module procedure :: extract_var_int32_11d
  module procedure :: extract_var_int32_12d
  module procedure :: extract_var_int32_13d
  module procedure :: extract_var_int32_14d
  module procedure :: extract_var_int32_15d
  module procedure :: extract_var_int64_1d
  module procedure :: extract_var_int64_2d
  module procedure :: extract_var_int64_3d
  module procedure :: extract_var_int64_4d
  module procedure :: extract_var_int64_5d
  module procedure :: extract_var_int64_6d
  module procedure :: extract_var_int64_7d
  module procedure :: extract_var_int64_8d
  module procedure :: extract_var_int64_9d
  module procedure :: extract_var_int64_10d
  module procedure :: extract_var_int64_11d
  module procedure :: extract_var_int64_12d
  module procedure :: extract_var_int64_13d
  module procedure :: extract_var_int64_14d
  module procedure :: extract_var_int64_15d
  module procedure :: extract_var_real32_1d
  module procedure :: extract_var_real32_2d
  module procedure :: extract_var_real32_3d
  module procedure :: extract_var_real32_4d
  module procedure :: extract_var_real32_5d
  module procedure :: extract_var_real32_6d
  module procedure :: extract_var_real32_7d
  module procedure :: extract_var_real32_8d
  module procedure :: extract_var_real32_9d
  module procedure :: extract_var_real32_10d
  module procedure :: extract_var_real32_11d
  module procedure :: extract_var_real32_12d
  module procedure :: extract_var_real32_13d
  module procedure :: extract_var_real32_14d
  module procedure :: extract_var_real32_15d
  module procedure :: extract_var_real64_1d
  module procedure :: extract_var_real64_2d
  module procedure :: extract_var_real64_3d
  module procedure :: extract_var_real64_4d
  module procedure :: extract_var_real64_5d
  module procedure :: extract_var_real64_6d
  module procedure :: extract_var_real64_7d
  module procedure :: extract_var_real64_8d
  module procedure :: extract_var_real64_9d
  module procedure :: extract_var_real64_10d
  module procedure :: extract_var_real64_11d
  module procedure :: extract_var_real64_12d
  module procedure :: extract_var_real64_13d
  module procedure :: extract_var_real64_14d
  module procedure :: extract_var_real64_15d
  module procedure :: extract_var_char_1d
  module procedure :: extract_var_char_2d
  module procedure :: extract_var_char_3d
  module procedure :: extract_var_char_4d
  module procedure :: extract_var_char_5d
  module procedure :: extract_var_char_6d
  module procedure :: extract_var_char_7d
  module procedure :: extract_var_char_8d
  module procedure :: extract_var_char_9d
  module procedure :: extract_var_char_10d
  module procedure :: extract_var_char_11d
  module procedure :: extract_var_char_12d
  module procedure :: extract_var_char_13d
  module procedure :: extract_var_char_14d
  module procedure :: extract_var_char_15d
end interface extract

interface
  module subroutine extract_att_int8_vector(att, ptr)
    !! Extract attribute data of kind `int8` as a vector.
    type(attribute_type), target, intent(in) :: att
    !! Source attribute to extract from.
    integer(int8), pointer, intent(out) :: ptr(:)
    !! Output vector of `integer` of kind `int8`.
  end subroutine extract_att_int8_vector

  module subroutine extract_att_int8_scalar(att, ptr)
    !! Extract attribute data of kind `int8` as a scalar.
    type(attribute_type), target, intent(in) :: att
    !! Source attribute to extract from.
    integer(int8), pointer, intent(out) :: ptr
    !! Output scalar `integer` of kind `int8`.
  end subroutine extract_att_int8_scalar

  module subroutine extract_att_int16_vector(att, ptr)
    !! Extract attribute data of kind `int16` as a vector.
    type(attribute_type), target, intent(in) :: att
    !! Source attribute to extract from.
    integer(int16), pointer, intent(out) :: ptr(:)
    !! Output vector of `integer` of kind `int16`.
  end subroutine extract_att_int16_vector

  module subroutine extract_att_int16_scalar(att, ptr)
    !! Extract attribute data of kind `int16` as a scalar.
    type(attribute_type), target, intent(in) :: att
    !! Source attribute to extract from.
    integer(int16), pointer, intent(out) :: ptr
    !! Output scalar `integer` of kind `int16`.
  end subroutine extract_att_int16_scalar

  module subroutine extract_att_int32_vector(att, ptr)
    !! Extract attribute data of kind `int32` as a vector.
    type(attribute_type), target, intent(in) :: att
    !! Source attribute to extract from.
    integer(int32), pointer, intent(out) :: ptr(:)
    !! Output vector of `integer` of kind `int32`.
  end subroutine extract_att_int32_vector

  module subroutine extract_att_int32_scalar(att, ptr)
    !! Extract attribute data of kind `int32` as a scalar.
    type(attribute_type), target, intent(in) :: att
    !! Source attribute to extract from.
    integer(int32), pointer, intent(out) :: ptr
    !! Output scalar `integer` of kind `int32`.
  end subroutine extract_att_int32_scalar

  module subroutine extract_att_int64_vector(att, ptr)
    !! Extract attribute data of kind `int64` as a vector.
    type(attribute_type), target, intent(in) :: att
    !! Source attribute to extract from.
    integer(int64), pointer, intent(out) :: ptr(:)
    !! Output vector of `integer` of kind `int64`.
  end subroutine extract_att_int64_vector

  module subroutine extract_att_int64_scalar(att, ptr)
    !! Extract attribute data of kind `int64` as a scalar.
    type(attribute_type), target, intent(in) :: att
    !! Source attribute to extract from.
    integer(int64), pointer, intent(out) :: ptr
    !! Output scalar `integer` of kind `int64`.
  end subroutine extract_att_int64_scalar

  module subroutine extract_att_real32_vector(att, ptr)
    !! Extract attribute data of kind `real32` as a vector.
    type(attribute_type), target, intent(in) :: att
    !! Source attribute to extract from.
    real(real32), pointer, intent(out) :: ptr(:)
    !! Output vector of `real` of kind `real32`.
  end subroutine extract_att_real32_vector

  module subroutine extract_att_real32_scalar(att, ptr)
    !! Extract attribute data of kind `real32` as a scalar.
    type(attribute_type), target, intent(in) :: att
    !! Source attribute to extract from.
    real(real32), pointer, intent(out) :: ptr
    !! Output scalar `real` of kind `real32`.
  end subroutine extract_att_real32_scalar

  module subroutine extract_att_real64_vector(att, ptr)
    !! Extract attribute data of kind `real64` as a vector.
    type(attribute_type), target, intent(in) :: att
    !! Source attribute to extract from.
    real(real64), pointer, intent(out) :: ptr(:)
    !! Output vector of `real` of kind `real64`.
  end subroutine extract_att_real64_vector

  module subroutine extract_att_real64_scalar(att, ptr)
    !! Extract attribute data of kind `real64` as a scalar.
    type(attribute_type), target, intent(in) :: att
    !! Source attribute to extract from.
    real(real64), pointer, intent(out) :: ptr
    !! Output scalar `real` of kind `real64`.
  end subroutine extract_att_real64_scalar

  module subroutine extract_att_char_vector(att, ptr)
    !! Extract attribute data as a vector of characters.
    type(attribute_type), target, intent(in) :: att
    !! Source attribute to extract from.
    character, pointer, intent(out) :: ptr(:)
    !! Output vector of characters.
  end subroutine extract_att_char_vector

  module subroutine extract_att_char_scalar(att, ptr)
    !! Extract attribute data as an allocated scalar string.
    type(attribute_type), target, intent(in) :: att
    !! Source attribute to extract from.
    character(len=:), pointer, intent(out) :: ptr
    !! Output scalar string (allocated by caller via pointer assignment).
  end subroutine extract_att_char_scalar

  module subroutine extract_var_int8_1d(var, ptr)
    !! Extract variable data of kind `int8` and rank 1 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int8), pointer, intent(out) :: ptr(:)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int8_1d

  module subroutine extract_var_int8_2d(var, ptr)
    !! Extract variable data of kind `int8` and rank 2 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int8), pointer, intent(out) :: ptr(:, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int8_2d

  module subroutine extract_var_int8_3d(var, ptr)
    !! Extract variable data of kind `int8` and rank 3 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int8), pointer, intent(out) :: ptr(:, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int8_3d

  module subroutine extract_var_int8_4d(var, ptr)
    !! Extract variable data of kind `int8` and rank 4 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int8), pointer, intent(out) :: ptr(:, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int8_4d

  module subroutine extract_var_int8_5d(var, ptr)
    !! Extract variable data of kind `int8` and rank 5 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int8_5d

  module subroutine extract_var_int8_6d(var, ptr)
    !! Extract variable data of kind `int8` and rank 6 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int8_6d

  module subroutine extract_var_int8_7d(var, ptr)
    !! Extract variable data of kind `int8` and rank 7 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int8_7d

  module subroutine extract_var_int8_8d(var, ptr)
    !! Extract variable data of kind `int8` and rank 8 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int8_8d

  module subroutine extract_var_int8_9d(var, ptr)
    !! Extract variable data of kind `int8` and rank 9 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int8_9d

  module subroutine extract_var_int8_10d(var, ptr)
    !! Extract variable data of kind `int8` and rank 10 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int8_10d

  module subroutine extract_var_int8_11d(var, ptr)
    !! Extract variable data of kind `int8` and rank 11 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int8_11d

  module subroutine extract_var_int8_12d(var, ptr)
    !! Extract variable data of kind `int8` and rank 12 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int8_12d

  module subroutine extract_var_int8_13d(var, ptr)
    !! Extract variable data of kind `int8` and rank 13 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int8_13d

  module subroutine extract_var_int8_14d(var, ptr)
    !! Extract variable data of kind `int8` and rank 14 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int8_14d

  module subroutine extract_var_int8_15d(var, ptr)
    !! Extract variable data of kind `int8` and rank 15 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int8_15d

  module subroutine extract_var_int16_1d(var, ptr)
    !! Extract variable data of kind `int16` and rank 1 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int16), pointer, intent(out) :: ptr(:)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int16_1d

  module subroutine extract_var_int16_2d(var, ptr)
    !! Extract variable data of kind `int16` and rank 2 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int16), pointer, intent(out) :: ptr(:, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int16_2d

  module subroutine extract_var_int16_3d(var, ptr)
    !! Extract variable data of kind `int16` and rank 3 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int16), pointer, intent(out) :: ptr(:, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int16_3d

  module subroutine extract_var_int16_4d(var, ptr)
    !! Extract variable data of kind `int16` and rank 4 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int16), pointer, intent(out) :: ptr(:, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int16_4d

  module subroutine extract_var_int16_5d(var, ptr)
    !! Extract variable data of kind `int16` and rank 5 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int16_5d

  module subroutine extract_var_int16_6d(var, ptr)
    !! Extract variable data of kind `int16` and rank 6 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int16_6d

  module subroutine extract_var_int16_7d(var, ptr)
    !! Extract variable data of kind `int16` and rank 7 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int16_7d

  module subroutine extract_var_int16_8d(var, ptr)
    !! Extract variable data of kind `int16` and rank 8 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int16_8d

  module subroutine extract_var_int16_9d(var, ptr)
    !! Extract variable data of kind `int16` and rank 9 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int16_9d

  module subroutine extract_var_int16_10d(var, ptr)
    !! Extract variable data of kind `int16` and rank 10 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int16_10d

  module subroutine extract_var_int16_11d(var, ptr)
    !! Extract variable data of kind `int16` and rank 11 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int16_11d

  module subroutine extract_var_int16_12d(var, ptr)
    !! Extract variable data of kind `int16` and rank 12 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int16_12d

  module subroutine extract_var_int16_13d(var, ptr)
    !! Extract variable data of kind `int16` and rank 13 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int16_13d

  module subroutine extract_var_int16_14d(var, ptr)
    !! Extract variable data of kind `int16` and rank 14 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int16_14d

  module subroutine extract_var_int16_15d(var, ptr)
    !! Extract variable data of kind `int16` and rank 15 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int16_15d

  module subroutine extract_var_int32_1d(var, ptr)
    !! Extract variable data of kind `int32` and rank 1 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int32), pointer, intent(out) :: ptr(:)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int32_1d

  module subroutine extract_var_int32_2d(var, ptr)
    !! Extract variable data of kind `int32` and rank 2 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int32), pointer, intent(out) :: ptr(:, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int32_2d

  module subroutine extract_var_int32_3d(var, ptr)
    !! Extract variable data of kind `int32` and rank 3 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int32), pointer, intent(out) :: ptr(:, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int32_3d

  module subroutine extract_var_int32_4d(var, ptr)
    !! Extract variable data of kind `int32` and rank 4 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int32), pointer, intent(out) :: ptr(:, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int32_4d

  module subroutine extract_var_int32_5d(var, ptr)
    !! Extract variable data of kind `int32` and rank 5 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int32_5d

  module subroutine extract_var_int32_6d(var, ptr)
    !! Extract variable data of kind `int32` and rank 6 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int32_6d

  module subroutine extract_var_int32_7d(var, ptr)
    !! Extract variable data of kind `int32` and rank 7 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int32_7d

  module subroutine extract_var_int32_8d(var, ptr)
    !! Extract variable data of kind `int32` and rank 8 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int32_8d

  module subroutine extract_var_int32_9d(var, ptr)
    !! Extract variable data of kind `int32` and rank 9 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int32_9d

  module subroutine extract_var_int32_10d(var, ptr)
    !! Extract variable data of kind `int32` and rank 10 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int32_10d

  module subroutine extract_var_int32_11d(var, ptr)
    !! Extract variable data of kind `int32` and rank 11 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int32_11d

  module subroutine extract_var_int32_12d(var, ptr)
    !! Extract variable data of kind `int32` and rank 12 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int32_12d

  module subroutine extract_var_int32_13d(var, ptr)
    !! Extract variable data of kind `int32` and rank 13 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int32_13d

  module subroutine extract_var_int32_14d(var, ptr)
    !! Extract variable data of kind `int32` and rank 14 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int32_14d

  module subroutine extract_var_int32_15d(var, ptr)
    !! Extract variable data of kind `int32` and rank 15 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int32_15d

  module subroutine extract_var_int64_1d(var, ptr)
    !! Extract variable data of kind `int64` and rank 1 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int64), pointer, intent(out) :: ptr(:)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int64_1d

  module subroutine extract_var_int64_2d(var, ptr)
    !! Extract variable data of kind `int64` and rank 2 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int64), pointer, intent(out) :: ptr(:, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int64_2d

  module subroutine extract_var_int64_3d(var, ptr)
    !! Extract variable data of kind `int64` and rank 3 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int64), pointer, intent(out) :: ptr(:, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int64_3d

  module subroutine extract_var_int64_4d(var, ptr)
    !! Extract variable data of kind `int64` and rank 4 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int64), pointer, intent(out) :: ptr(:, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int64_4d

  module subroutine extract_var_int64_5d(var, ptr)
    !! Extract variable data of kind `int64` and rank 5 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int64_5d

  module subroutine extract_var_int64_6d(var, ptr)
    !! Extract variable data of kind `int64` and rank 6 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int64_6d

  module subroutine extract_var_int64_7d(var, ptr)
    !! Extract variable data of kind `int64` and rank 7 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int64_7d

  module subroutine extract_var_int64_8d(var, ptr)
    !! Extract variable data of kind `int64` and rank 8 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int64_8d

  module subroutine extract_var_int64_9d(var, ptr)
    !! Extract variable data of kind `int64` and rank 9 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int64_9d

  module subroutine extract_var_int64_10d(var, ptr)
    !! Extract variable data of kind `int64` and rank 10 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int64_10d

  module subroutine extract_var_int64_11d(var, ptr)
    !! Extract variable data of kind `int64` and rank 11 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int64_11d

  module subroutine extract_var_int64_12d(var, ptr)
    !! Extract variable data of kind `int64` and rank 12 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int64_12d

  module subroutine extract_var_int64_13d(var, ptr)
    !! Extract variable data of kind `int64` and rank 13 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int64_13d

  module subroutine extract_var_int64_14d(var, ptr)
    !! Extract variable data of kind `int64` and rank 14 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int64_14d

  module subroutine extract_var_int64_15d(var, ptr)
    !! Extract variable data of kind `int64` and rank 15 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_int64_15d

  module subroutine extract_var_real32_1d(var, ptr)
    !! Extract variable data of kind `real32` and rank 1 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    real(real32), pointer, intent(out) :: ptr(:)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_real32_1d

  module subroutine extract_var_real32_2d(var, ptr)
    !! Extract variable data of kind `real32` and rank 2 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    real(real32), pointer, intent(out) :: ptr(:, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_real32_2d

  module subroutine extract_var_real32_3d(var, ptr)
    !! Extract variable data of kind `real32` and rank 3 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    real(real32), pointer, intent(out) :: ptr(:, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_real32_3d

  module subroutine extract_var_real32_4d(var, ptr)
    !! Extract variable data of kind `real32` and rank 4 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    real(real32), pointer, intent(out) :: ptr(:, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_real32_4d

  module subroutine extract_var_real32_5d(var, ptr)
    !! Extract variable data of kind `real32` and rank 5 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    real(real32), pointer, intent(out) :: ptr(:, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_real32_5d

  module subroutine extract_var_real32_6d(var, ptr)
    !! Extract variable data of kind `real32` and rank 6 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    real(real32), pointer, intent(out) :: ptr(:, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_real32_6d

  module subroutine extract_var_real32_7d(var, ptr)
    !! Extract variable data of kind `real32` and rank 7 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    real(real32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_real32_7d

  module subroutine extract_var_real32_8d(var, ptr)
    !! Extract variable data of kind `real32` and rank 8 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    real(real32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_real32_8d

  module subroutine extract_var_real32_9d(var, ptr)
    !! Extract variable data of kind `real32` and rank 9 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    real(real32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_real32_9d

  module subroutine extract_var_real32_10d(var, ptr)
    !! Extract variable data of kind `real32` and rank 10 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    real(real32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_real32_10d

  module subroutine extract_var_real32_11d(var, ptr)
    !! Extract variable data of kind `real32` and rank 11 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    real(real32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_real32_11d

  module subroutine extract_var_real32_12d(var, ptr)
    !! Extract variable data of kind `real32` and rank 12 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    real(real32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_real32_12d

  module subroutine extract_var_real32_13d(var, ptr)
    !! Extract variable data of kind `real32` and rank 13 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    real(real32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_real32_13d

  module subroutine extract_var_real32_14d(var, ptr)
    !! Extract variable data of kind `real32` and rank 14 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    real(real32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_real32_14d

  module subroutine extract_var_real32_15d(var, ptr)
    !! Extract variable data of kind `real32` and rank 15 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    real(real32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_real32_15d

  module subroutine extract_var_real64_1d(var, ptr)
    !! Extract variable data of kind `real64` and rank 1 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    real(real64), pointer, intent(out) :: ptr(:)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_real64_1d

  module subroutine extract_var_real64_2d(var, ptr)
    !! Extract variable data of kind `real64` and rank 2 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    real(real64), pointer, intent(out) :: ptr(:, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_real64_2d

  module subroutine extract_var_real64_3d(var, ptr)
    !! Extract variable data of kind `real64` and rank 3 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    real(real64), pointer, intent(out) :: ptr(:, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_real64_3d

  module subroutine extract_var_real64_4d(var, ptr)
    !! Extract variable data of kind `real64` and rank 4 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    real(real64), pointer, intent(out) :: ptr(:, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_real64_4d

  module subroutine extract_var_real64_5d(var, ptr)
    !! Extract variable data of kind `real64` and rank 5 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    real(real64), pointer, intent(out) :: ptr(:, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_real64_5d

  module subroutine extract_var_real64_6d(var, ptr)
    !! Extract variable data of kind `real64` and rank 6 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    real(real64), pointer, intent(out) :: ptr(:, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_real64_6d

  module subroutine extract_var_real64_7d(var, ptr)
    !! Extract variable data of kind `real64` and rank 7 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    real(real64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_real64_7d

  module subroutine extract_var_real64_8d(var, ptr)
    !! Extract variable data of kind `real64` and rank 8 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    real(real64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_real64_8d

  module subroutine extract_var_real64_9d(var, ptr)
    !! Extract variable data of kind `real64` and rank 9 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    real(real64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_real64_9d

  module subroutine extract_var_real64_10d(var, ptr)
    !! Extract variable data of kind `real64` and rank 10 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    real(real64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_real64_10d

  module subroutine extract_var_real64_11d(var, ptr)
    !! Extract variable data of kind `real64` and rank 11 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    real(real64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_real64_11d

  module subroutine extract_var_real64_12d(var, ptr)
    !! Extract variable data of kind `real64` and rank 12 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    real(real64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_real64_12d

  module subroutine extract_var_real64_13d(var, ptr)
    !! Extract variable data of kind `real64` and rank 13 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    real(real64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_real64_13d

  module subroutine extract_var_real64_14d(var, ptr)
    !! Extract variable data of kind `real64` and rank 14 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    real(real64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_real64_14d

  module subroutine extract_var_real64_15d(var, ptr)
    !! Extract variable data of kind `real64` and rank 15 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    real(real64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :, :)
    !! Output pointer with matching element kind and rank.
  end subroutine extract_var_real64_15d
  module subroutine extract_var_char_1d(var, ptr)
    !! Extract character variable data of rank 1 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    character, pointer, intent(out) :: ptr(:)
    !! Output pointer with matching rank.
  end subroutine extract_var_char_1d

  module subroutine extract_var_char_2d(var, ptr)
    !! Extract character variable data of rank 2 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    character, pointer, intent(out) :: ptr(:, :)
    !! Output pointer with matching rank.
  end subroutine extract_var_char_2d

  module subroutine extract_var_char_3d(var, ptr)
    !! Extract character variable data of rank 3 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    character, pointer, intent(out) :: ptr(:, :, :)
    !! Output pointer with matching rank.
  end subroutine extract_var_char_3d

  module subroutine extract_var_char_4d(var, ptr)
    !! Extract character variable data of rank 4 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    character, pointer, intent(out) :: ptr(:, :, :, :)
    !! Output pointer with matching rank.
  end subroutine extract_var_char_4d

  module subroutine extract_var_char_5d(var, ptr)
    !! Extract character variable data of rank 5 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    character, pointer, intent(out) :: ptr(:, :, :, :, :)
    !! Output pointer with matching rank.
  end subroutine extract_var_char_5d

  module subroutine extract_var_char_6d(var, ptr)
    !! Extract character variable data of rank 6 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    character, pointer, intent(out) :: ptr(:, :, :, :, :, :)
    !! Output pointer with matching rank.
  end subroutine extract_var_char_6d

  module subroutine extract_var_char_7d(var, ptr)
    !! Extract character variable data of rank 7 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    character, pointer, intent(out) :: ptr(:, :, :, :, :, :, :)
    !! Output pointer with matching rank.
  end subroutine extract_var_char_7d

  module subroutine extract_var_char_8d(var, ptr)
    !! Extract character variable data of rank 8 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    character, pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :)
    !! Output pointer with matching rank.
  end subroutine extract_var_char_8d

  module subroutine extract_var_char_9d(var, ptr)
    !! Extract character variable data of rank 9 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    character, pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :)
    !! Output pointer with matching rank.
  end subroutine extract_var_char_9d

  module subroutine extract_var_char_10d(var, ptr)
    !! Extract character variable data of rank 10 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    character, pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :)
    !! Output pointer with matching rank.
  end subroutine extract_var_char_10d

  module subroutine extract_var_char_11d(var, ptr)
    !! Extract character variable data of rank 11 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    character, pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :)
    !! Output pointer with matching rank.
  end subroutine extract_var_char_11d

  module subroutine extract_var_char_12d(var, ptr)
    !! Extract character variable data of rank 12 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    character, pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :)
    !! Output pointer with matching rank.
  end subroutine extract_var_char_12d

  module subroutine extract_var_char_13d(var, ptr)
    !! Extract character variable data of rank 13 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    character, pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :)
    !! Output pointer with matching rank.
  end subroutine extract_var_char_13d

  module subroutine extract_var_char_14d(var, ptr)
    !! Extract character variable data of rank 14 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    character, pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :)
    !! Output pointer with matching rank.
  end subroutine extract_var_char_14d

  module subroutine extract_var_char_15d(var, ptr)
    !! Extract character variable data of rank 15 into `ptr`.
    type(variable_type), target, intent(in) :: var
    !! Source variable whose buffer will be mapped.
    character, pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :, :)
    !! Output pointer with matching rank.
  end subroutine extract_var_char_15d
end interface
