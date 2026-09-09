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
  !> Extract attribute data of kind `int8` as a vector.
  module subroutine extract_att_int8_vector(att, ptr)
    !> Source attribute to extract from.
    type(attribute_type), target, intent(in) :: att
    !> Output vector of `integer` of kind `int8`.
    integer(int8), pointer, intent(out) :: ptr(:)
  end subroutine extract_att_int8_vector

  !> Extract attribute data of kind `int8` as a scalar.
  module subroutine extract_att_int8_scalar(att, ptr)
    !> Source attribute to extract from.
    type(attribute_type), target, intent(in) :: att
    !> Output scalar `integer` of kind `int8`.
    integer(int8), pointer, intent(out) :: ptr
  end subroutine extract_att_int8_scalar

  !> Extract attribute data of kind `int16` as a vector.
  module subroutine extract_att_int16_vector(att, ptr)
    !> Source attribute to extract from.
    type(attribute_type), target, intent(in) :: att
    !> Output vector of `integer` of kind `int16`.
    integer(int16), pointer, intent(out) :: ptr(:)
  end subroutine extract_att_int16_vector

  !> Extract attribute data of kind `int16` as a scalar.
  module subroutine extract_att_int16_scalar(att, ptr)
    !> Source attribute to extract from.
    type(attribute_type), target, intent(in) :: att
    !> Output scalar `integer` of kind `int16`.
    integer(int16), pointer, intent(out) :: ptr
  end subroutine extract_att_int16_scalar

  !> Extract attribute data of kind `int32` as a vector.
  module subroutine extract_att_int32_vector(att, ptr)
    !> Source attribute to extract from.
    type(attribute_type), target, intent(in) :: att
    !> Output vector of `integer` of kind `int32`.
    integer(int32), pointer, intent(out) :: ptr(:)
  end subroutine extract_att_int32_vector

  !> Extract attribute data of kind `int32` as a scalar.
  module subroutine extract_att_int32_scalar(att, ptr)
    !> Source attribute to extract from.
    type(attribute_type), target, intent(in) :: att
    !> Output scalar `integer` of kind `int32`.
    integer(int32), pointer, intent(out) :: ptr
  end subroutine extract_att_int32_scalar

  !> Extract attribute data of kind `int64` as a vector.
  module subroutine extract_att_int64_vector(att, ptr)
    !> Source attribute to extract from.
    type(attribute_type), target, intent(in) :: att
    !> Output vector of `integer` of kind `int64`.
    integer(int64), pointer, intent(out) :: ptr(:)
  end subroutine extract_att_int64_vector

  !> Extract attribute data of kind `int64` as a scalar.
  module subroutine extract_att_int64_scalar(att, ptr)
    !> Source attribute to extract from.
    type(attribute_type), target, intent(in) :: att
    !> Output scalar `integer` of kind `int64`.
    integer(int64), pointer, intent(out) :: ptr
  end subroutine extract_att_int64_scalar

  !> Extract attribute data of kind `real32` as a vector.
  module subroutine extract_att_real32_vector(att, ptr)
    !> Source attribute to extract from.
    type(attribute_type), target, intent(in) :: att
    !> Output vector of `real` of kind `real32`.
    real(real32), pointer, intent(out) :: ptr(:)
  end subroutine extract_att_real32_vector

  !> Extract attribute data of kind `real32` as a scalar.
  module subroutine extract_att_real32_scalar(att, ptr)
    !> Source attribute to extract from.
    type(attribute_type), target, intent(in) :: att
    !> Output scalar `real` of kind `real32`.
    real(real32), pointer, intent(out) :: ptr
  end subroutine extract_att_real32_scalar

  !> Extract attribute data of kind `real64` as a vector.
  module subroutine extract_att_real64_vector(att, ptr)
    !> Source attribute to extract from.
    type(attribute_type), target, intent(in) :: att
    !> Output vector of `real` of kind `real64`.
    real(real64), pointer, intent(out) :: ptr(:)
  end subroutine extract_att_real64_vector

  !> Extract attribute data of kind `real64` as a scalar.
  module subroutine extract_att_real64_scalar(att, ptr)
    !> Source attribute to extract from.
    type(attribute_type), target, intent(in) :: att
    !> Output scalar `real` of kind `real64`.
    real(real64), pointer, intent(out) :: ptr
  end subroutine extract_att_real64_scalar

  !> Extract attribute data as a vector of characters.
  module subroutine extract_att_char_vector(att, ptr)
    !> Source attribute to extract from.
    type(attribute_type), target, intent(in) :: att
    !> Output vector of characters.
    character, pointer, intent(out) :: ptr(:)
  end subroutine extract_att_char_vector

  !> Extract attribute data as an allocated scalar string.
  module subroutine extract_att_char_scalar(att, ptr)
    !> Source attribute to extract from.
    type(attribute_type), target, intent(in) :: att
    !> Output scalar string (allocated by caller via pointer assignment).
    character(len=:), pointer, intent(out) :: ptr
  end subroutine extract_att_char_scalar

  !> Extract variable data of kind `int8` and rank 1 into `ptr`.
  module subroutine extract_var_int8_1d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int8), pointer, intent(out) :: ptr(:)
  end subroutine extract_var_int8_1d

  !> Extract variable data of kind `int8` and rank 2 into `ptr`.
  module subroutine extract_var_int8_2d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int8), pointer, intent(out) :: ptr(:, :)
  end subroutine extract_var_int8_2d

  !> Extract variable data of kind `int8` and rank 3 into `ptr`.
  module subroutine extract_var_int8_3d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int8), pointer, intent(out) :: ptr(:, :, :)
  end subroutine extract_var_int8_3d

  !> Extract variable data of kind `int8` and rank 4 into `ptr`.
  module subroutine extract_var_int8_4d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int8), pointer, intent(out) :: ptr(:, :, :, :)
  end subroutine extract_var_int8_4d

  !> Extract variable data of kind `int8` and rank 5 into `ptr`.
  module subroutine extract_var_int8_5d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :)
  end subroutine extract_var_int8_5d

  !> Extract variable data of kind `int8` and rank 6 into `ptr`.
  module subroutine extract_var_int8_6d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :, :)
  end subroutine extract_var_int8_6d

  !> Extract variable data of kind `int8` and rank 7 into `ptr`.
  module subroutine extract_var_int8_7d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :, :, :)
  end subroutine extract_var_int8_7d

  !> Extract variable data of kind `int8` and rank 8 into `ptr`.
  module subroutine extract_var_int8_8d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :)
  end subroutine extract_var_int8_8d

  !> Extract variable data of kind `int8` and rank 9 into `ptr`.
  module subroutine extract_var_int8_9d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :)
  end subroutine extract_var_int8_9d

  !> Extract variable data of kind `int8` and rank 10 into `ptr`.
  module subroutine extract_var_int8_10d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :)
  end subroutine extract_var_int8_10d

  !> Extract variable data of kind `int8` and rank 11 into `ptr`.
  module subroutine extract_var_int8_11d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :)
  end subroutine extract_var_int8_11d

  !> Extract variable data of kind `int8` and rank 12 into `ptr`.
  module subroutine extract_var_int8_12d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :)
  end subroutine extract_var_int8_12d

  !> Extract variable data of kind `int8` and rank 13 into `ptr`.
  module subroutine extract_var_int8_13d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :)
  end subroutine extract_var_int8_13d

  !> Extract variable data of kind `int8` and rank 14 into `ptr`.
  module subroutine extract_var_int8_14d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :)
  end subroutine extract_var_int8_14d

  !> Extract variable data of kind `int8` and rank 15 into `ptr`.
  module subroutine extract_var_int8_15d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int8), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :, :)
  end subroutine extract_var_int8_15d

  !> Extract variable data of kind `int16` and rank 1 into `ptr`.
  module subroutine extract_var_int16_1d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int16), pointer, intent(out) :: ptr(:)
  end subroutine extract_var_int16_1d

  !> Extract variable data of kind `int16` and rank 2 into `ptr`.
  module subroutine extract_var_int16_2d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int16), pointer, intent(out) :: ptr(:, :)
  end subroutine extract_var_int16_2d

  !> Extract variable data of kind `int16` and rank 3 into `ptr`.
  module subroutine extract_var_int16_3d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int16), pointer, intent(out) :: ptr(:, :, :)
  end subroutine extract_var_int16_3d

  !> Extract variable data of kind `int16` and rank 4 into `ptr`.
  module subroutine extract_var_int16_4d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int16), pointer, intent(out) :: ptr(:, :, :, :)
  end subroutine extract_var_int16_4d

  !> Extract variable data of kind `int16` and rank 5 into `ptr`.
  module subroutine extract_var_int16_5d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :)
  end subroutine extract_var_int16_5d

  !> Extract variable data of kind `int16` and rank 6 into `ptr`.
  module subroutine extract_var_int16_6d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :, :)
  end subroutine extract_var_int16_6d

  !> Extract variable data of kind `int16` and rank 7 into `ptr`.
  module subroutine extract_var_int16_7d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :, :, :)
  end subroutine extract_var_int16_7d

  !> Extract variable data of kind `int16` and rank 8 into `ptr`.
  module subroutine extract_var_int16_8d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :)
  end subroutine extract_var_int16_8d

  !> Extract variable data of kind `int16` and rank 9 into `ptr`.
  module subroutine extract_var_int16_9d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :)
  end subroutine extract_var_int16_9d

  !> Extract variable data of kind `int16` and rank 10 into `ptr`.
  module subroutine extract_var_int16_10d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :)
  end subroutine extract_var_int16_10d

  !> Extract variable data of kind `int16` and rank 11 into `ptr`.
  module subroutine extract_var_int16_11d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :)
  end subroutine extract_var_int16_11d

  !> Extract variable data of kind `int16` and rank 12 into `ptr`.
  module subroutine extract_var_int16_12d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :)
  end subroutine extract_var_int16_12d

  !> Extract variable data of kind `int16` and rank 13 into `ptr`.
  module subroutine extract_var_int16_13d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :)
  end subroutine extract_var_int16_13d

  !> Extract variable data of kind `int16` and rank 14 into `ptr`.
  module subroutine extract_var_int16_14d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :)
  end subroutine extract_var_int16_14d

  !> Extract variable data of kind `int16` and rank 15 into `ptr`.
  module subroutine extract_var_int16_15d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int16), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :, :)
  end subroutine extract_var_int16_15d

  !> Extract variable data of kind `int32` and rank 1 into `ptr`.
  module subroutine extract_var_int32_1d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int32), pointer, intent(out) :: ptr(:)
  end subroutine extract_var_int32_1d

  !> Extract variable data of kind `int32` and rank 2 into `ptr`.
  module subroutine extract_var_int32_2d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int32), pointer, intent(out) :: ptr(:, :)
  end subroutine extract_var_int32_2d

  !> Extract variable data of kind `int32` and rank 3 into `ptr`.
  module subroutine extract_var_int32_3d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int32), pointer, intent(out) :: ptr(:, :, :)
  end subroutine extract_var_int32_3d

  !> Extract variable data of kind `int32` and rank 4 into `ptr`.
  module subroutine extract_var_int32_4d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int32), pointer, intent(out) :: ptr(:, :, :, :)
  end subroutine extract_var_int32_4d

  !> Extract variable data of kind `int32` and rank 5 into `ptr`.
  module subroutine extract_var_int32_5d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :)
  end subroutine extract_var_int32_5d

  !> Extract variable data of kind `int32` and rank 6 into `ptr`.
  module subroutine extract_var_int32_6d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :, :)
  end subroutine extract_var_int32_6d

  !> Extract variable data of kind `int32` and rank 7 into `ptr`.
  module subroutine extract_var_int32_7d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :)
  end subroutine extract_var_int32_7d

  !> Extract variable data of kind `int32` and rank 8 into `ptr`.
  module subroutine extract_var_int32_8d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :)
  end subroutine extract_var_int32_8d

  !> Extract variable data of kind `int32` and rank 9 into `ptr`.
  module subroutine extract_var_int32_9d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :)
  end subroutine extract_var_int32_9d

  !> Extract variable data of kind `int32` and rank 10 into `ptr`.
  module subroutine extract_var_int32_10d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :)
  end subroutine extract_var_int32_10d

  !> Extract variable data of kind `int32` and rank 11 into `ptr`.
  module subroutine extract_var_int32_11d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :)
  end subroutine extract_var_int32_11d

  !> Extract variable data of kind `int32` and rank 12 into `ptr`.
  module subroutine extract_var_int32_12d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :)
  end subroutine extract_var_int32_12d

  !> Extract variable data of kind `int32` and rank 13 into `ptr`.
  module subroutine extract_var_int32_13d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :)
  end subroutine extract_var_int32_13d

  !> Extract variable data of kind `int32` and rank 14 into `ptr`.
  module subroutine extract_var_int32_14d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :)
  end subroutine extract_var_int32_14d

  !> Extract variable data of kind `int32` and rank 15 into `ptr`.
  module subroutine extract_var_int32_15d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :, :)
  end subroutine extract_var_int32_15d

  !> Extract variable data of kind `int64` and rank 1 into `ptr`.
  module subroutine extract_var_int64_1d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int64), pointer, intent(out) :: ptr(:)
  end subroutine extract_var_int64_1d

  !> Extract variable data of kind `int64` and rank 2 into `ptr`.
  module subroutine extract_var_int64_2d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int64), pointer, intent(out) :: ptr(:, :)
  end subroutine extract_var_int64_2d

  !> Extract variable data of kind `int64` and rank 3 into `ptr`.
  module subroutine extract_var_int64_3d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int64), pointer, intent(out) :: ptr(:, :, :)
  end subroutine extract_var_int64_3d

  !> Extract variable data of kind `int64` and rank 4 into `ptr`.
  module subroutine extract_var_int64_4d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int64), pointer, intent(out) :: ptr(:, :, :, :)
  end subroutine extract_var_int64_4d

  !> Extract variable data of kind `int64` and rank 5 into `ptr`.
  module subroutine extract_var_int64_5d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :)
  end subroutine extract_var_int64_5d

  !> Extract variable data of kind `int64` and rank 6 into `ptr`.
  module subroutine extract_var_int64_6d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :, :)
  end subroutine extract_var_int64_6d

  !> Extract variable data of kind `int64` and rank 7 into `ptr`.
  module subroutine extract_var_int64_7d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :)
  end subroutine extract_var_int64_7d

  !> Extract variable data of kind `int64` and rank 8 into `ptr`.
  module subroutine extract_var_int64_8d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :)
  end subroutine extract_var_int64_8d

  !> Extract variable data of kind `int64` and rank 9 into `ptr`.
  module subroutine extract_var_int64_9d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :)
  end subroutine extract_var_int64_9d

  !> Extract variable data of kind `int64` and rank 10 into `ptr`.
  module subroutine extract_var_int64_10d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :)
  end subroutine extract_var_int64_10d

  !> Extract variable data of kind `int64` and rank 11 into `ptr`.
  module subroutine extract_var_int64_11d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :)
  end subroutine extract_var_int64_11d

  !> Extract variable data of kind `int64` and rank 12 into `ptr`.
  module subroutine extract_var_int64_12d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :)
  end subroutine extract_var_int64_12d

  !> Extract variable data of kind `int64` and rank 13 into `ptr`.
  module subroutine extract_var_int64_13d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :)
  end subroutine extract_var_int64_13d

  !> Extract variable data of kind `int64` and rank 14 into `ptr`.
  module subroutine extract_var_int64_14d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :)
  end subroutine extract_var_int64_14d

  !> Extract variable data of kind `int64` and rank 15 into `ptr`.
  module subroutine extract_var_int64_15d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    integer(int64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :, :)
  end subroutine extract_var_int64_15d

  !> Extract variable data of kind `real32` and rank 1 into `ptr`.
  module subroutine extract_var_real32_1d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    real(real32), pointer, intent(out) :: ptr(:)
  end subroutine extract_var_real32_1d

  !> Extract variable data of kind `real32` and rank 2 into `ptr`.
  module subroutine extract_var_real32_2d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    real(real32), pointer, intent(out) :: ptr(:, :)
  end subroutine extract_var_real32_2d

  !> Extract variable data of kind `real32` and rank 3 into `ptr`.
  module subroutine extract_var_real32_3d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    real(real32), pointer, intent(out) :: ptr(:, :, :)
  end subroutine extract_var_real32_3d

  !> Extract variable data of kind `real32` and rank 4 into `ptr`.
  module subroutine extract_var_real32_4d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    real(real32), pointer, intent(out) :: ptr(:, :, :, :)
  end subroutine extract_var_real32_4d

  !> Extract variable data of kind `real32` and rank 5 into `ptr`.
  module subroutine extract_var_real32_5d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    real(real32), pointer, intent(out) :: ptr(:, :, :, :, :)
  end subroutine extract_var_real32_5d

  !> Extract variable data of kind `real32` and rank 6 into `ptr`.
  module subroutine extract_var_real32_6d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    real(real32), pointer, intent(out) :: ptr(:, :, :, :, :, :)
  end subroutine extract_var_real32_6d

  !> Extract variable data of kind `real32` and rank 7 into `ptr`.
  module subroutine extract_var_real32_7d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    real(real32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :)
  end subroutine extract_var_real32_7d

  !> Extract variable data of kind `real32` and rank 8 into `ptr`.
  module subroutine extract_var_real32_8d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    real(real32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :)
  end subroutine extract_var_real32_8d

  !> Extract variable data of kind `real32` and rank 9 into `ptr`.
  module subroutine extract_var_real32_9d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    real(real32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :)
  end subroutine extract_var_real32_9d

  !> Extract variable data of kind `real32` and rank 10 into `ptr`.
  module subroutine extract_var_real32_10d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    real(real32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :)
  end subroutine extract_var_real32_10d

  !> Extract variable data of kind `real32` and rank 11 into `ptr`.
  module subroutine extract_var_real32_11d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    real(real32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :)
  end subroutine extract_var_real32_11d

  !> Extract variable data of kind `real32` and rank 12 into `ptr`.
  module subroutine extract_var_real32_12d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    real(real32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :)
  end subroutine extract_var_real32_12d

  !> Extract variable data of kind `real32` and rank 13 into `ptr`.
  module subroutine extract_var_real32_13d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    real(real32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :)
  end subroutine extract_var_real32_13d

  !> Extract variable data of kind `real32` and rank 14 into `ptr`.
  module subroutine extract_var_real32_14d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    real(real32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :)
  end subroutine extract_var_real32_14d

  !> Extract variable data of kind `real32` and rank 15 into `ptr`.
  module subroutine extract_var_real32_15d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    real(real32), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :, :)
  end subroutine extract_var_real32_15d

  !> Extract variable data of kind `real64` and rank 1 into `ptr`.
  module subroutine extract_var_real64_1d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    real(real64), pointer, intent(out) :: ptr(:)
  end subroutine extract_var_real64_1d

  !> Extract variable data of kind `real64` and rank 2 into `ptr`.
  module subroutine extract_var_real64_2d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    real(real64), pointer, intent(out) :: ptr(:, :)
  end subroutine extract_var_real64_2d

  !> Extract variable data of kind `real64` and rank 3 into `ptr`.
  module subroutine extract_var_real64_3d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    real(real64), pointer, intent(out) :: ptr(:, :, :)
  end subroutine extract_var_real64_3d

  !> Extract variable data of kind `real64` and rank 4 into `ptr`.
  module subroutine extract_var_real64_4d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    real(real64), pointer, intent(out) :: ptr(:, :, :, :)
  end subroutine extract_var_real64_4d

  !> Extract variable data of kind `real64` and rank 5 into `ptr`.
  module subroutine extract_var_real64_5d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    real(real64), pointer, intent(out) :: ptr(:, :, :, :, :)
  end subroutine extract_var_real64_5d

  !> Extract variable data of kind `real64` and rank 6 into `ptr`.
  module subroutine extract_var_real64_6d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    real(real64), pointer, intent(out) :: ptr(:, :, :, :, :, :)
  end subroutine extract_var_real64_6d

  !> Extract variable data of kind `real64` and rank 7 into `ptr`.
  module subroutine extract_var_real64_7d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    real(real64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :)
  end subroutine extract_var_real64_7d

  !> Extract variable data of kind `real64` and rank 8 into `ptr`.
  module subroutine extract_var_real64_8d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    real(real64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :)
  end subroutine extract_var_real64_8d

  !> Extract variable data of kind `real64` and rank 9 into `ptr`.
  module subroutine extract_var_real64_9d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    real(real64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :)
  end subroutine extract_var_real64_9d

  !> Extract variable data of kind `real64` and rank 10 into `ptr`.
  module subroutine extract_var_real64_10d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    real(real64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :)
  end subroutine extract_var_real64_10d

  !> Extract variable data of kind `real64` and rank 11 into `ptr`.
  module subroutine extract_var_real64_11d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    real(real64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :)
  end subroutine extract_var_real64_11d

  !> Extract variable data of kind `real64` and rank 12 into `ptr`.
  module subroutine extract_var_real64_12d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    real(real64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :)
  end subroutine extract_var_real64_12d

  !> Extract variable data of kind `real64` and rank 13 into `ptr`.
  module subroutine extract_var_real64_13d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    real(real64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :)
  end subroutine extract_var_real64_13d

  !> Extract variable data of kind `real64` and rank 14 into `ptr`.
  module subroutine extract_var_real64_14d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    real(real64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :)
  end subroutine extract_var_real64_14d

  !> Extract variable data of kind `real64` and rank 15 into `ptr`.
  module subroutine extract_var_real64_15d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching element kind and rank.
    real(real64), pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :, :)
  end subroutine extract_var_real64_15d
  !> Extract character variable data of rank 1 into `ptr`.
  module subroutine extract_var_char_1d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching rank.
    character, pointer, intent(out) :: ptr(:)
  end subroutine extract_var_char_1d

  !> Extract character variable data of rank 2 into `ptr`.
  module subroutine extract_var_char_2d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching rank.
    character, pointer, intent(out) :: ptr(:, :)
  end subroutine extract_var_char_2d

  !> Extract character variable data of rank 3 into `ptr`.
  module subroutine extract_var_char_3d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching rank.
    character, pointer, intent(out) :: ptr(:, :, :)
  end subroutine extract_var_char_3d

  !> Extract character variable data of rank 4 into `ptr`.
  module subroutine extract_var_char_4d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching rank.
    character, pointer, intent(out) :: ptr(:, :, :, :)
  end subroutine extract_var_char_4d

  !> Extract character variable data of rank 5 into `ptr`.
  module subroutine extract_var_char_5d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching rank.
    character, pointer, intent(out) :: ptr(:, :, :, :, :)
  end subroutine extract_var_char_5d

  !> Extract character variable data of rank 6 into `ptr`.
  module subroutine extract_var_char_6d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching rank.
    character, pointer, intent(out) :: ptr(:, :, :, :, :, :)
  end subroutine extract_var_char_6d

  !> Extract character variable data of rank 7 into `ptr`.
  module subroutine extract_var_char_7d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching rank.
    character, pointer, intent(out) :: ptr(:, :, :, :, :, :, :)
  end subroutine extract_var_char_7d

  !> Extract character variable data of rank 8 into `ptr`.
  module subroutine extract_var_char_8d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching rank.
    character, pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :)
  end subroutine extract_var_char_8d

  !> Extract character variable data of rank 9 into `ptr`.
  module subroutine extract_var_char_9d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching rank.
    character, pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :)
  end subroutine extract_var_char_9d

  !> Extract character variable data of rank 10 into `ptr`.
  module subroutine extract_var_char_10d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching rank.
    character, pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :)
  end subroutine extract_var_char_10d

  !> Extract character variable data of rank 11 into `ptr`.
  module subroutine extract_var_char_11d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching rank.
    character, pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :)
  end subroutine extract_var_char_11d

  !> Extract character variable data of rank 12 into `ptr`.
  module subroutine extract_var_char_12d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching rank.
    character, pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :)
  end subroutine extract_var_char_12d

  !> Extract character variable data of rank 13 into `ptr`.
  module subroutine extract_var_char_13d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching rank.
    character, pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :)
  end subroutine extract_var_char_13d

  !> Extract character variable data of rank 14 into `ptr`.
  module subroutine extract_var_char_14d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching rank.
    character, pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :)
  end subroutine extract_var_char_14d

  !> Extract character variable data of rank 15 into `ptr`.
  module subroutine extract_var_char_15d(var, ptr)
    !> Source variable whose buffer will be mapped.
    type(variable_type), target, intent(in) :: var
    !> Output pointer with matching rank.
    character, pointer, intent(out) :: ptr(:, :, :, :, :, :, :, :, :, :, :, :, :, :, :)
  end subroutine extract_var_char_15d
end interface
