submodule(nc4f) nc4f_variable_constructor
implicit none (type, external)
contains

module function new_var_int8_1d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int8), intent(in) :: values(:)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type) :: var
  integer(c_int8_t), pointer :: var_ptr(:)

  call allocate_variable(var, name, NC_BYTE, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int8_1d

module function new_var_int8_2d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int8), intent(in) :: values(:, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type) :: var
  integer(c_int8_t), pointer :: var_ptr(:, :)

  call allocate_variable(var, name, NC_BYTE, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int8_2d

module function new_var_int8_3d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int8), intent(in) :: values(:, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type) :: var
  integer(c_int8_t), pointer :: var_ptr(:, :, :)

  call allocate_variable(var, name, NC_BYTE, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int8_3d

module function new_var_int8_4d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int8), intent(in) :: values(:, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type) :: var
  integer(c_int8_t), pointer :: var_ptr(:, :, :, :)

  call allocate_variable(var, name, NC_BYTE, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int8_4d

module function new_var_int8_5d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int8), intent(in) :: values(:, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type) :: var
  integer(c_int8_t), pointer :: var_ptr(:, :, :, :, :)

  call allocate_variable(var, name, NC_BYTE, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int8_5d

module function new_var_int8_6d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int8), intent(in) :: values(:, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type) :: var
  integer(c_int8_t), pointer :: var_ptr(:, :, :, :, :, :)

  call allocate_variable(var, name, NC_BYTE, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int8_6d

module function new_var_int8_7d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int8), intent(in) :: values(:, :, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type) :: var
  integer(c_int8_t), pointer :: var_ptr(:, :, :, :, :, :, :)

  call allocate_variable(var, name, NC_BYTE, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int8_7d

module function new_var_int16_1d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int16), intent(in) :: values(:)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type) :: var
  integer(c_int16_t), pointer :: var_ptr(:)

  call allocate_variable(var, name, NC_SHORT, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int16_1d

module function new_var_int16_2d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int16), intent(in) :: values(:, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type) :: var
  integer(c_int16_t), pointer :: var_ptr(:, :)

  call allocate_variable(var, name, NC_SHORT, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int16_2d

module function new_var_int16_3d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int16), intent(in) :: values(:, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type) :: var
  integer(c_int16_t), pointer :: var_ptr(:, :, :)

  call allocate_variable(var, name, NC_SHORT, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int16_3d

module function new_var_int16_4d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int16), intent(in) :: values(:, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type) :: var
  integer(c_int16_t), pointer :: var_ptr(:, :, :, :)

  call allocate_variable(var, name, NC_SHORT, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int16_4d

module function new_var_int16_5d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int16), intent(in) :: values(:, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type) :: var
  integer(c_int16_t), pointer :: var_ptr(:, :, :, :, :)

  call allocate_variable(var, name, NC_SHORT, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int16_5d

module function new_var_int16_6d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int16), intent(in) :: values(:, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type) :: var
  integer(c_int16_t), pointer :: var_ptr(:, :, :, :, :, :)

  call allocate_variable(var, name, NC_SHORT, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int16_6d

module function new_var_int16_7d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int16), intent(in) :: values(:, :, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type) :: var
  integer(c_int16_t), pointer :: var_ptr(:, :, :, :, :, :, :)

  call allocate_variable(var, name, NC_SHORT, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int16_7d

module function new_var_int32_1d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int32), intent(in) :: values(:)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type) :: var
  integer(c_int32_t), pointer :: var_ptr(:)

  call allocate_variable(var, name, NC_INT, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int32_1d

module function new_var_int32_2d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int32), intent(in) :: values(:, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type) :: var
  integer(c_int32_t), pointer :: var_ptr(:, :)

  call allocate_variable(var, name, NC_INT, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int32_2d

module function new_var_int32_3d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int32), intent(in) :: values(:, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type) :: var
  integer(c_int32_t), pointer :: var_ptr(:, :, :)

  call allocate_variable(var, name, NC_INT, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int32_3d

module function new_var_int32_4d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int32), intent(in) :: values(:, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type) :: var
  integer(c_int32_t), pointer :: var_ptr(:, :, :, :)

  call allocate_variable(var, name, NC_INT, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int32_4d

module function new_var_int32_5d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int32), intent(in) :: values(:, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type) :: var
  integer(c_int32_t), pointer :: var_ptr(:, :, :, :, :)

  call allocate_variable(var, name, NC_INT, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int32_5d

module function new_var_int32_6d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int32), intent(in) :: values(:, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type) :: var
  integer(c_int32_t), pointer :: var_ptr(:, :, :, :, :, :)

  call allocate_variable(var, name, NC_INT, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int32_6d

module function new_var_int32_7d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int32), intent(in) :: values(:, :, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type) :: var
  integer(c_int32_t), pointer :: var_ptr(:, :, :, :, :, :, :)

  call allocate_variable(var, name, NC_INT, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int32_7d

module function new_var_int64_1d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int64), intent(in) :: values(:)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type) :: var
  integer(c_int64_t), pointer :: var_ptr(:)

  call allocate_variable(var, name, NC_INT64, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int64_1d

module function new_var_int64_2d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int64), intent(in) :: values(:, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type) :: var
  integer(c_int64_t), pointer :: var_ptr(:, :)

  call allocate_variable(var, name, NC_INT64, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int64_2d

module function new_var_int64_3d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int64), intent(in) :: values(:, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type) :: var
  integer(c_int64_t), pointer :: var_ptr(:, :, :)

  call allocate_variable(var, name, NC_INT64, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int64_3d

module function new_var_int64_4d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int64), intent(in) :: values(:, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type) :: var
  integer(c_int64_t), pointer :: var_ptr(:, :, :, :)

  call allocate_variable(var, name, NC_INT64, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int64_4d

module function new_var_int64_5d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int64), intent(in) :: values(:, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type) :: var
  integer(c_int64_t), pointer :: var_ptr(:, :, :, :, :)

  call allocate_variable(var, name, NC_INT64, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int64_5d

module function new_var_int64_6d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int64), intent(in) :: values(:, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type) :: var
  integer(c_int64_t), pointer :: var_ptr(:, :, :, :, :, :)

  call allocate_variable(var, name, NC_INT64, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int64_6d

module function new_var_int64_7d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int64), intent(in) :: values(:, :, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type) :: var
  integer(c_int64_t), pointer :: var_ptr(:, :, :, :, :, :, :)

  call allocate_variable(var, name, NC_INT64, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int64_7d

module function new_var_real32_1d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  real(real32), intent(in) :: values(:)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type) :: var
  real(c_float), pointer :: var_ptr(:)

  call allocate_variable(var, name, NC_FLOAT, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_real32_1d

module function new_var_real32_2d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  real(real32), intent(in) :: values(:, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type) :: var
  real(c_float), pointer :: var_ptr(:, :)

  call allocate_variable(var, name, NC_FLOAT, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_real32_2d

module function new_var_real32_3d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  real(real32), intent(in) :: values(:, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type) :: var
  real(c_float), pointer :: var_ptr(:, :, :)

  call allocate_variable(var, name, NC_FLOAT, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_real32_3d

module function new_var_real32_4d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  real(real32), intent(in) :: values(:, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type) :: var
  real(c_float), pointer :: var_ptr(:, :, :, :)

  call allocate_variable(var, name, NC_FLOAT, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_real32_4d

module function new_var_real32_5d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  real(real32), intent(in) :: values(:, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type) :: var
  real(c_float), pointer :: var_ptr(:, :, :, :, :)

  call allocate_variable(var, name, NC_FLOAT, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_real32_5d

module function new_var_real32_6d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  real(real32), intent(in) :: values(:, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type) :: var
  real(c_float), pointer :: var_ptr(:, :, :, :, :, :)

  call allocate_variable(var, name, NC_FLOAT, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_real32_6d

module function new_var_real32_7d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  real(real32), intent(in) :: values(:, :, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type) :: var
  real(c_float), pointer :: var_ptr(:, :, :, :, :, :, :)

  call allocate_variable(var, name, NC_FLOAT, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_real32_7d

module function new_var_real64_1d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  real(real64), intent(in) :: values(:)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type) :: var
  real(c_double), pointer :: var_ptr(:)

  call allocate_variable(var, name, NC_DOUBLE, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_real64_1d

module function new_var_real64_2d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  real(real64), intent(in) :: values(:, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type) :: var
  real(c_double), pointer :: var_ptr(:, :)

  call allocate_variable(var, name, NC_DOUBLE, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_real64_2d

module function new_var_real64_3d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  real(real64), intent(in) :: values(:, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type) :: var
  real(c_double), pointer :: var_ptr(:, :, :)

  call allocate_variable(var, name, NC_DOUBLE, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_real64_3d

module function new_var_real64_4d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  real(real64), intent(in) :: values(:, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type) :: var
  real(c_double), pointer :: var_ptr(:, :, :, :)

  call allocate_variable(var, name, NC_DOUBLE, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_real64_4d

module function new_var_real64_5d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  real(real64), intent(in) :: values(:, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type) :: var
  real(c_double), pointer :: var_ptr(:, :, :, :, :)

  call allocate_variable(var, name, NC_DOUBLE, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_real64_5d

module function new_var_real64_6d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  real(real64), intent(in) :: values(:, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type) :: var
  real(c_double), pointer :: var_ptr(:, :, :, :, :, :)

  call allocate_variable(var, name, NC_DOUBLE, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_real64_6d

module function new_var_real64_7d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  real(real64), intent(in) :: values(:, :, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type) :: var
  real(c_double), pointer :: var_ptr(:, :, :, :, :, :, :)

  call allocate_variable(var, name, NC_DOUBLE, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_real64_7d

end submodule nc4f_variable_constructor
