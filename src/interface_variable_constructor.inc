interface data_array
  module procedure :: new_var_int8_1d
  module procedure :: new_var_int8_2d
  module procedure :: new_var_int8_3d
  module procedure :: new_var_int8_4d
  module procedure :: new_var_int8_5d
  module procedure :: new_var_int8_6d
  module procedure :: new_var_int8_7d
  module procedure :: new_var_int16_1d
  module procedure :: new_var_int16_2d
  module procedure :: new_var_int16_3d
  module procedure :: new_var_int16_4d
  module procedure :: new_var_int16_5d
  module procedure :: new_var_int16_6d
  module procedure :: new_var_int16_7d
  module procedure :: new_var_int32_1d
  module procedure :: new_var_int32_2d
  module procedure :: new_var_int32_3d
  module procedure :: new_var_int32_4d
  module procedure :: new_var_int32_5d
  module procedure :: new_var_int32_6d
  module procedure :: new_var_int32_7d
  module procedure :: new_var_int64_1d
  module procedure :: new_var_int64_2d
  module procedure :: new_var_int64_3d
  module procedure :: new_var_int64_4d
  module procedure :: new_var_int64_5d
  module procedure :: new_var_int64_6d
  module procedure :: new_var_int64_7d
  module procedure :: new_var_real32_1d
  module procedure :: new_var_real32_2d
  module procedure :: new_var_real32_3d
  module procedure :: new_var_real32_4d
  module procedure :: new_var_real32_5d
  module procedure :: new_var_real32_6d
  module procedure :: new_var_real32_7d
  module procedure :: new_var_real64_1d
  module procedure :: new_var_real64_2d
  module procedure :: new_var_real64_3d
  module procedure :: new_var_real64_4d
  module procedure :: new_var_real64_5d
  module procedure :: new_var_real64_6d
  module procedure :: new_var_real64_7d
end interface

interface
  module function new_var_int8_1d(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int8), target, intent(in) :: values(:)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in), optional :: atts(:)
    type(variable_type), target :: var
  end function new_var_int8_1d

  module function new_var_int8_2d(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int8), target, intent(in) :: values(:, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in), optional :: atts(:)
    type(variable_type), target :: var
  end function new_var_int8_2d

  module function new_var_int8_3d(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int8), target, intent(in) :: values(:, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in), optional :: atts(:)
    type(variable_type), target :: var
  end function new_var_int8_3d

  module function new_var_int8_4d(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int8), target, intent(in) :: values(:, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in), optional :: atts(:)
    type(variable_type), target :: var
  end function new_var_int8_4d

  module function new_var_int8_5d(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int8), target, intent(in) :: values(:, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in), optional :: atts(:)
    type(variable_type), target :: var
  end function new_var_int8_5d

  module function new_var_int8_6d(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int8), target, intent(in) :: values(:, :, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in), optional :: atts(:)
    type(variable_type), target :: var
  end function new_var_int8_6d

  module function new_var_int8_7d(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int8), target, intent(in) :: values(:, :, :, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in), optional :: atts(:)
    type(variable_type), target :: var
  end function new_var_int8_7d

  module function new_var_int16_1d(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int16), target, intent(in) :: values(:)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in), optional :: atts(:)
    type(variable_type), target :: var
  end function new_var_int16_1d

  module function new_var_int16_2d(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int16), target, intent(in) :: values(:, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in), optional :: atts(:)
    type(variable_type), target :: var
  end function new_var_int16_2d

  module function new_var_int16_3d(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int16), target, intent(in) :: values(:, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in), optional :: atts(:)
    type(variable_type), target :: var
  end function new_var_int16_3d

  module function new_var_int16_4d(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int16), target, intent(in) :: values(:, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in), optional :: atts(:)
    type(variable_type), target :: var
  end function new_var_int16_4d

  module function new_var_int16_5d(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int16), target, intent(in) :: values(:, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in), optional :: atts(:)
    type(variable_type), target :: var
  end function new_var_int16_5d

  module function new_var_int16_6d(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int16), target, intent(in) :: values(:, :, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in), optional :: atts(:)
    type(variable_type), target :: var
  end function new_var_int16_6d

  module function new_var_int16_7d(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int16), target, intent(in) :: values(:, :, :, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in), optional :: atts(:)
    type(variable_type), target :: var
  end function new_var_int16_7d

  module function new_var_int32_1d(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int32), target, intent(in) :: values(:)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in), optional :: atts(:)
    type(variable_type), target :: var
  end function new_var_int32_1d

  module function new_var_int32_2d(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int32), target, intent(in) :: values(:, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in), optional :: atts(:)
    type(variable_type), target :: var
  end function new_var_int32_2d

  module function new_var_int32_3d(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int32), target, intent(in) :: values(:, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in), optional :: atts(:)
    type(variable_type), target :: var
  end function new_var_int32_3d

  module function new_var_int32_4d(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int32), target, intent(in) :: values(:, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in), optional :: atts(:)
    type(variable_type), target :: var
  end function new_var_int32_4d

  module function new_var_int32_5d(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int32), target, intent(in) :: values(:, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in), optional :: atts(:)
    type(variable_type), target :: var
  end function new_var_int32_5d

  module function new_var_int32_6d(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int32), target, intent(in) :: values(:, :, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in), optional :: atts(:)
    type(variable_type), target :: var
  end function new_var_int32_6d

  module function new_var_int32_7d(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int32), target, intent(in) :: values(:, :, :, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in), optional :: atts(:)
    type(variable_type), target :: var
  end function new_var_int32_7d

  module function new_var_int64_1d(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int64), target, intent(in) :: values(:)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in), optional :: atts(:)
    type(variable_type), target :: var
  end function new_var_int64_1d

  module function new_var_int64_2d(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int64), target, intent(in) :: values(:, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in), optional :: atts(:)
    type(variable_type), target :: var
  end function new_var_int64_2d

  module function new_var_int64_3d(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int64), target, intent(in) :: values(:, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in), optional :: atts(:)
    type(variable_type), target :: var
  end function new_var_int64_3d

  module function new_var_int64_4d(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int64), target, intent(in) :: values(:, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in), optional :: atts(:)
    type(variable_type), target :: var
  end function new_var_int64_4d

  module function new_var_int64_5d(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int64), target, intent(in) :: values(:, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in), optional :: atts(:)
    type(variable_type), target :: var
  end function new_var_int64_5d

  module function new_var_int64_6d(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int64), target, intent(in) :: values(:, :, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in), optional :: atts(:)
    type(variable_type), target :: var
  end function new_var_int64_6d

  module function new_var_int64_7d(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int64), target, intent(in) :: values(:, :, :, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in), optional :: atts(:)
    type(variable_type), target :: var
  end function new_var_int64_7d

  module function new_var_real32_1d(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    real(real32), target, intent(in) :: values(:)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in), optional :: atts(:)
    type(variable_type), target :: var
  end function new_var_real32_1d

  module function new_var_real32_2d(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    real(real32), target, intent(in) :: values(:, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in), optional :: atts(:)
    type(variable_type), target :: var
  end function new_var_real32_2d

  module function new_var_real32_3d(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    real(real32), target, intent(in) :: values(:, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in), optional :: atts(:)
    type(variable_type), target :: var
  end function new_var_real32_3d

  module function new_var_real32_4d(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    real(real32), target, intent(in) :: values(:, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in), optional :: atts(:)
    type(variable_type), target :: var
  end function new_var_real32_4d

  module function new_var_real32_5d(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    real(real32), target, intent(in) :: values(:, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in), optional :: atts(:)
    type(variable_type), target :: var
  end function new_var_real32_5d

  module function new_var_real32_6d(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    real(real32), target, intent(in) :: values(:, :, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in), optional :: atts(:)
    type(variable_type), target :: var
  end function new_var_real32_6d

  module function new_var_real32_7d(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    real(real32), target, intent(in) :: values(:, :, :, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in), optional :: atts(:)
    type(variable_type), target :: var
  end function new_var_real32_7d

  module function new_var_real64_1d(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    real(real64), target, intent(in) :: values(:)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in), optional :: atts(:)
    type(variable_type), target :: var
  end function new_var_real64_1d

  module function new_var_real64_2d(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    real(real64), target, intent(in) :: values(:, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in), optional :: atts(:)
    type(variable_type), target :: var
  end function new_var_real64_2d

  module function new_var_real64_3d(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    real(real64), target, intent(in) :: values(:, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in), optional :: atts(:)
    type(variable_type), target :: var
  end function new_var_real64_3d

  module function new_var_real64_4d(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    real(real64), target, intent(in) :: values(:, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in), optional :: atts(:)
    type(variable_type), target :: var
  end function new_var_real64_4d

  module function new_var_real64_5d(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    real(real64), target, intent(in) :: values(:, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in), optional :: atts(:)
    type(variable_type), target :: var
  end function new_var_real64_5d

  module function new_var_real64_6d(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    real(real64), target, intent(in) :: values(:, :, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in), optional :: atts(:)
    type(variable_type), target :: var
  end function new_var_real64_6d

  module function new_var_real64_7d(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    real(real64), target, intent(in) :: values(:, :, :, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in), optional :: atts(:)
    type(variable_type), target :: var
  end function new_var_real64_7d

end interface