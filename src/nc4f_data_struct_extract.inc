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
  module procedure :: extract_var_int16_1d
  module procedure :: extract_var_int16_2d
  module procedure :: extract_var_int16_3d
  module procedure :: extract_var_int16_4d
  module procedure :: extract_var_int16_5d
  module procedure :: extract_var_int16_6d
  module procedure :: extract_var_int16_7d
  module procedure :: extract_var_int32_1d
  module procedure :: extract_var_int32_2d
  module procedure :: extract_var_int32_3d
  module procedure :: extract_var_int32_4d
  module procedure :: extract_var_int32_5d
  module procedure :: extract_var_int32_6d
  module procedure :: extract_var_int32_7d
  module procedure :: extract_var_int64_1d
  module procedure :: extract_var_int64_2d
  module procedure :: extract_var_int64_3d
  module procedure :: extract_var_int64_4d
  module procedure :: extract_var_int64_5d
  module procedure :: extract_var_int64_6d
  module procedure :: extract_var_int64_7d
  module procedure :: extract_var_real32_1d
  module procedure :: extract_var_real32_2d
  module procedure :: extract_var_real32_3d
  module procedure :: extract_var_real32_4d
  module procedure :: extract_var_real32_5d
  module procedure :: extract_var_real32_6d
  module procedure :: extract_var_real32_7d
  module procedure :: extract_var_real64_1d
  module procedure :: extract_var_real64_2d
  module procedure :: extract_var_real64_3d
  module procedure :: extract_var_real64_4d
  module procedure :: extract_var_real64_5d
  module procedure :: extract_var_real64_6d
  module procedure :: extract_var_real64_7d
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
end interface
