interface data_array
  module procedure :: new_variable_int8_1d
  module procedure :: new_variable_int8_1d_att
  module procedure :: new_variable_int8_2d
  module procedure :: new_variable_int8_2d_att
  module procedure :: new_variable_int8_3d
  module procedure :: new_variable_int8_3d_att
  module procedure :: new_variable_int8_4d
  module procedure :: new_variable_int8_4d_att
  module procedure :: new_variable_int8_5d
  module procedure :: new_variable_int8_5d_att
  module procedure :: new_variable_int8_6d
  module procedure :: new_variable_int8_6d_att
  module procedure :: new_variable_int8_7d
  module procedure :: new_variable_int8_7d_att
  module procedure :: new_variable_int16_1d
  module procedure :: new_variable_int16_1d_att
  module procedure :: new_variable_int16_2d
  module procedure :: new_variable_int16_2d_att
  module procedure :: new_variable_int16_3d
  module procedure :: new_variable_int16_3d_att
  module procedure :: new_variable_int16_4d
  module procedure :: new_variable_int16_4d_att
  module procedure :: new_variable_int16_5d
  module procedure :: new_variable_int16_5d_att
  module procedure :: new_variable_int16_6d
  module procedure :: new_variable_int16_6d_att
  module procedure :: new_variable_int16_7d
  module procedure :: new_variable_int16_7d_att
  module procedure :: new_variable_int32_1d
  module procedure :: new_variable_int32_1d_att
  module procedure :: new_variable_int32_2d
  module procedure :: new_variable_int32_2d_att
  module procedure :: new_variable_int32_3d
  module procedure :: new_variable_int32_3d_att
  module procedure :: new_variable_int32_4d
  module procedure :: new_variable_int32_4d_att
  module procedure :: new_variable_int32_5d
  module procedure :: new_variable_int32_5d_att
  module procedure :: new_variable_int32_6d
  module procedure :: new_variable_int32_6d_att
  module procedure :: new_variable_int32_7d
  module procedure :: new_variable_int32_7d_att
  module procedure :: new_variable_int64_1d
  module procedure :: new_variable_int64_1d_att
  module procedure :: new_variable_int64_2d
  module procedure :: new_variable_int64_2d_att
  module procedure :: new_variable_int64_3d
  module procedure :: new_variable_int64_3d_att
  module procedure :: new_variable_int64_4d
  module procedure :: new_variable_int64_4d_att
  module procedure :: new_variable_int64_5d
  module procedure :: new_variable_int64_5d_att
  module procedure :: new_variable_int64_6d
  module procedure :: new_variable_int64_6d_att
  module procedure :: new_variable_int64_7d
  module procedure :: new_variable_int64_7d_att
  module procedure :: new_variable_real32_1d
  module procedure :: new_variable_real32_1d_att
  module procedure :: new_variable_real32_2d
  module procedure :: new_variable_real32_2d_att
  module procedure :: new_variable_real32_3d
  module procedure :: new_variable_real32_3d_att
  module procedure :: new_variable_real32_4d
  module procedure :: new_variable_real32_4d_att
  module procedure :: new_variable_real32_5d
  module procedure :: new_variable_real32_5d_att
  module procedure :: new_variable_real32_6d
  module procedure :: new_variable_real32_6d_att
  module procedure :: new_variable_real32_7d
  module procedure :: new_variable_real32_7d_att
  module procedure :: new_variable_real64_1d
  module procedure :: new_variable_real64_1d_att
  module procedure :: new_variable_real64_2d
  module procedure :: new_variable_real64_2d_att
  module procedure :: new_variable_real64_3d
  module procedure :: new_variable_real64_3d_att
  module procedure :: new_variable_real64_4d
  module procedure :: new_variable_real64_4d_att
  module procedure :: new_variable_real64_5d
  module procedure :: new_variable_real64_5d_att
  module procedure :: new_variable_real64_6d
  module procedure :: new_variable_real64_6d_att
  module procedure :: new_variable_real64_7d
  module procedure :: new_variable_real64_7d_att
end interface

interface
  module function new_variable_int8_1d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    integer(int8), target, intent(in) :: values(:)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_int8_1d

  module function new_variable_int8_1d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int8), target, intent(in) :: values(:)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_int8_1d_att

  module function new_variable_int8_2d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    integer(int8), target, intent(in) :: values(:, :)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_int8_2d

  module function new_variable_int8_2d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int8), target, intent(in) :: values(:, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_int8_2d_att

  module function new_variable_int8_3d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    integer(int8), target, intent(in) :: values(:, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_int8_3d

  module function new_variable_int8_3d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int8), target, intent(in) :: values(:, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_int8_3d_att

  module function new_variable_int8_4d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    integer(int8), target, intent(in) :: values(:, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_int8_4d

  module function new_variable_int8_4d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int8), target, intent(in) :: values(:, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_int8_4d_att

  module function new_variable_int8_5d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    integer(int8), target, intent(in) :: values(:, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_int8_5d

  module function new_variable_int8_5d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int8), target, intent(in) :: values(:, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_int8_5d_att

  module function new_variable_int8_6d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    integer(int8), target, intent(in) :: values(:, :, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_int8_6d

  module function new_variable_int8_6d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int8), target, intent(in) :: values(:, :, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_int8_6d_att

  module function new_variable_int8_7d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    integer(int8), target, intent(in) :: values(:, :, :, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_int8_7d

  module function new_variable_int8_7d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int8), target, intent(in) :: values(:, :, :, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_int8_7d_att

  module function new_variable_int16_1d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    integer(int16), target, intent(in) :: values(:)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_int16_1d

  module function new_variable_int16_1d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int16), target, intent(in) :: values(:)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_int16_1d_att

  module function new_variable_int16_2d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    integer(int16), target, intent(in) :: values(:, :)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_int16_2d

  module function new_variable_int16_2d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int16), target, intent(in) :: values(:, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_int16_2d_att

  module function new_variable_int16_3d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    integer(int16), target, intent(in) :: values(:, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_int16_3d

  module function new_variable_int16_3d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int16), target, intent(in) :: values(:, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_int16_3d_att

  module function new_variable_int16_4d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    integer(int16), target, intent(in) :: values(:, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_int16_4d

  module function new_variable_int16_4d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int16), target, intent(in) :: values(:, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_int16_4d_att

  module function new_variable_int16_5d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    integer(int16), target, intent(in) :: values(:, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_int16_5d

  module function new_variable_int16_5d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int16), target, intent(in) :: values(:, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_int16_5d_att

  module function new_variable_int16_6d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    integer(int16), target, intent(in) :: values(:, :, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_int16_6d

  module function new_variable_int16_6d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int16), target, intent(in) :: values(:, :, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_int16_6d_att

  module function new_variable_int16_7d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    integer(int16), target, intent(in) :: values(:, :, :, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_int16_7d

  module function new_variable_int16_7d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int16), target, intent(in) :: values(:, :, :, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_int16_7d_att

  module function new_variable_int32_1d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    integer(int32), target, intent(in) :: values(:)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_int32_1d

  module function new_variable_int32_1d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int32), target, intent(in) :: values(:)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_int32_1d_att

  module function new_variable_int32_2d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    integer(int32), target, intent(in) :: values(:, :)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_int32_2d

  module function new_variable_int32_2d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int32), target, intent(in) :: values(:, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_int32_2d_att

  module function new_variable_int32_3d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    integer(int32), target, intent(in) :: values(:, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_int32_3d

  module function new_variable_int32_3d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int32), target, intent(in) :: values(:, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_int32_3d_att

  module function new_variable_int32_4d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    integer(int32), target, intent(in) :: values(:, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_int32_4d

  module function new_variable_int32_4d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int32), target, intent(in) :: values(:, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_int32_4d_att

  module function new_variable_int32_5d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    integer(int32), target, intent(in) :: values(:, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_int32_5d

  module function new_variable_int32_5d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int32), target, intent(in) :: values(:, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_int32_5d_att

  module function new_variable_int32_6d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    integer(int32), target, intent(in) :: values(:, :, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_int32_6d

  module function new_variable_int32_6d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int32), target, intent(in) :: values(:, :, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_int32_6d_att

  module function new_variable_int32_7d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    integer(int32), target, intent(in) :: values(:, :, :, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_int32_7d

  module function new_variable_int32_7d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int32), target, intent(in) :: values(:, :, :, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_int32_7d_att

  module function new_variable_int64_1d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    integer(int64), target, intent(in) :: values(:)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_int64_1d

  module function new_variable_int64_1d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int64), target, intent(in) :: values(:)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_int64_1d_att

  module function new_variable_int64_2d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    integer(int64), target, intent(in) :: values(:, :)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_int64_2d

  module function new_variable_int64_2d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int64), target, intent(in) :: values(:, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_int64_2d_att

  module function new_variable_int64_3d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    integer(int64), target, intent(in) :: values(:, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_int64_3d

  module function new_variable_int64_3d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int64), target, intent(in) :: values(:, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_int64_3d_att

  module function new_variable_int64_4d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    integer(int64), target, intent(in) :: values(:, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_int64_4d

  module function new_variable_int64_4d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int64), target, intent(in) :: values(:, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_int64_4d_att

  module function new_variable_int64_5d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    integer(int64), target, intent(in) :: values(:, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_int64_5d

  module function new_variable_int64_5d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int64), target, intent(in) :: values(:, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_int64_5d_att

  module function new_variable_int64_6d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    integer(int64), target, intent(in) :: values(:, :, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_int64_6d

  module function new_variable_int64_6d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int64), target, intent(in) :: values(:, :, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_int64_6d_att

  module function new_variable_int64_7d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    integer(int64), target, intent(in) :: values(:, :, :, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_int64_7d

  module function new_variable_int64_7d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int64), target, intent(in) :: values(:, :, :, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_int64_7d_att

  module function new_variable_real32_1d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    real(real32), target, intent(in) :: values(:)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_real32_1d

  module function new_variable_real32_1d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    real(real32), target, intent(in) :: values(:)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_real32_1d_att

  module function new_variable_real32_2d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    real(real32), target, intent(in) :: values(:, :)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_real32_2d

  module function new_variable_real32_2d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    real(real32), target, intent(in) :: values(:, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_real32_2d_att

  module function new_variable_real32_3d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    real(real32), target, intent(in) :: values(:, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_real32_3d

  module function new_variable_real32_3d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    real(real32), target, intent(in) :: values(:, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_real32_3d_att

  module function new_variable_real32_4d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    real(real32), target, intent(in) :: values(:, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_real32_4d

  module function new_variable_real32_4d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    real(real32), target, intent(in) :: values(:, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_real32_4d_att

  module function new_variable_real32_5d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    real(real32), target, intent(in) :: values(:, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_real32_5d

  module function new_variable_real32_5d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    real(real32), target, intent(in) :: values(:, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_real32_5d_att

  module function new_variable_real32_6d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    real(real32), target, intent(in) :: values(:, :, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_real32_6d

  module function new_variable_real32_6d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    real(real32), target, intent(in) :: values(:, :, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_real32_6d_att

  module function new_variable_real32_7d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    real(real32), target, intent(in) :: values(:, :, :, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_real32_7d

  module function new_variable_real32_7d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    real(real32), target, intent(in) :: values(:, :, :, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_real32_7d_att

  module function new_variable_real64_1d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    real(real64), target, intent(in) :: values(:)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_real64_1d

  module function new_variable_real64_1d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    real(real64), target, intent(in) :: values(:)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_real64_1d_att

  module function new_variable_real64_2d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    real(real64), target, intent(in) :: values(:, :)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_real64_2d

  module function new_variable_real64_2d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    real(real64), target, intent(in) :: values(:, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_real64_2d_att

  module function new_variable_real64_3d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    real(real64), target, intent(in) :: values(:, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_real64_3d

  module function new_variable_real64_3d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    real(real64), target, intent(in) :: values(:, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_real64_3d_att

  module function new_variable_real64_4d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    real(real64), target, intent(in) :: values(:, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_real64_4d

  module function new_variable_real64_4d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    real(real64), target, intent(in) :: values(:, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_real64_4d_att

  module function new_variable_real64_5d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    real(real64), target, intent(in) :: values(:, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_real64_5d

  module function new_variable_real64_5d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    real(real64), target, intent(in) :: values(:, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_real64_5d_att

  module function new_variable_real64_6d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    real(real64), target, intent(in) :: values(:, :, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_real64_6d

  module function new_variable_real64_6d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    real(real64), target, intent(in) :: values(:, :, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_real64_6d_att

  module function new_variable_real64_7d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    real(real64), target, intent(in) :: values(:, :, :, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_real64_7d

  module function new_variable_real64_7d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    real(real64), target, intent(in) :: values(:, :, :, :, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_real64_7d_att

end interface