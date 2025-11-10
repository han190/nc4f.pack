submodule(module_netcdf) submodule_variable_constructor
implicit none (type, external)
contains

module function new_variable_int8_1d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int8), target, intent(in) :: values(:)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type), target :: var
  integer(c_int8_t), pointer :: var_ptr(:)

  call new_variable_(var, name, NC_BYTE, size(values, kind=int64), dims)
  call allocate_buffer(var)
  call extract(var, var_ptr)
  var_ptr = values
  nullify (var_ptr)
  if (present(atts)) var%attributes = atts
end function new_variable_int8_1d

module function new_variable_int8_2d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int8), target, intent(in) :: values(:, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type), target :: var
  integer(c_int8_t), pointer :: var_ptr(:, :)

  call new_variable_(var, name, NC_BYTE, size(values, kind=int64), dims)
  call allocate_buffer(var)
  call extract(var, var_ptr)
  var_ptr = values
  nullify (var_ptr)
  if (present(atts)) var%attributes = atts
end function new_variable_int8_2d

module function new_variable_int8_3d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int8), target, intent(in) :: values(:, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type), target :: var
  integer(c_int8_t), pointer :: var_ptr(:, :, :)

  call new_variable_(var, name, NC_BYTE, size(values, kind=int64), dims)
  call allocate_buffer(var)
  call extract(var, var_ptr)
  var_ptr = values
  nullify (var_ptr)
  if (present(atts)) var%attributes = atts
end function new_variable_int8_3d

module function new_variable_int8_4d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int8), target, intent(in) :: values(:, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type), target :: var
  integer(c_int8_t), pointer :: var_ptr(:, :, :, :)

  call new_variable_(var, name, NC_BYTE, size(values, kind=int64), dims)
  call allocate_buffer(var)
  call extract(var, var_ptr)
  var_ptr = values
  nullify (var_ptr)
  if (present(atts)) var%attributes = atts
end function new_variable_int8_4d

module function new_variable_int8_5d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int8), target, intent(in) :: values(:, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type), target :: var
  integer(c_int8_t), pointer :: var_ptr(:, :, :, :, :)

  call new_variable_(var, name, NC_BYTE, size(values, kind=int64), dims)
  call allocate_buffer(var)
  call extract(var, var_ptr)
  var_ptr = values
  nullify (var_ptr)
  if (present(atts)) var%attributes = atts
end function new_variable_int8_5d

module function new_variable_int8_6d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int8), target, intent(in) :: values(:, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type), target :: var
  integer(c_int8_t), pointer :: var_ptr(:, :, :, :, :, :)

  call new_variable_(var, name, NC_BYTE, size(values, kind=int64), dims)
  call allocate_buffer(var)
  call extract(var, var_ptr)
  var_ptr = values
  nullify (var_ptr)
  if (present(atts)) var%attributes = atts
end function new_variable_int8_6d

module function new_variable_int8_7d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int8), target, intent(in) :: values(:, :, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type), target :: var
  integer(c_int8_t), pointer :: var_ptr(:, :, :, :, :, :, :)

  call new_variable_(var, name, NC_BYTE, size(values, kind=int64), dims)
  call allocate_buffer(var)
  call extract(var, var_ptr)
  var_ptr = values
  nullify (var_ptr)
  if (present(atts)) var%attributes = atts
end function new_variable_int8_7d

module function new_variable_int16_1d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int16), target, intent(in) :: values(:)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type), target :: var
  integer(c_int16_t), pointer :: var_ptr(:)

  call new_variable_(var, name, NC_SHORT, size(values, kind=int64), dims)
  call allocate_buffer(var)
  call extract(var, var_ptr)
  var_ptr = values
  nullify (var_ptr)
  if (present(atts)) var%attributes = atts
end function new_variable_int16_1d

module function new_variable_int16_2d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int16), target, intent(in) :: values(:, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type), target :: var
  integer(c_int16_t), pointer :: var_ptr(:, :)

  call new_variable_(var, name, NC_SHORT, size(values, kind=int64), dims)
  call allocate_buffer(var)
  call extract(var, var_ptr)
  var_ptr = values
  nullify (var_ptr)
  if (present(atts)) var%attributes = atts
end function new_variable_int16_2d

module function new_variable_int16_3d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int16), target, intent(in) :: values(:, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type), target :: var
  integer(c_int16_t), pointer :: var_ptr(:, :, :)

  call new_variable_(var, name, NC_SHORT, size(values, kind=int64), dims)
  call allocate_buffer(var)
  call extract(var, var_ptr)
  var_ptr = values
  nullify (var_ptr)
  if (present(atts)) var%attributes = atts
end function new_variable_int16_3d

module function new_variable_int16_4d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int16), target, intent(in) :: values(:, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type), target :: var
  integer(c_int16_t), pointer :: var_ptr(:, :, :, :)

  call new_variable_(var, name, NC_SHORT, size(values, kind=int64), dims)
  call allocate_buffer(var)
  call extract(var, var_ptr)
  var_ptr = values
  nullify (var_ptr)
  if (present(atts)) var%attributes = atts
end function new_variable_int16_4d

module function new_variable_int16_5d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int16), target, intent(in) :: values(:, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type), target :: var
  integer(c_int16_t), pointer :: var_ptr(:, :, :, :, :)

  call new_variable_(var, name, NC_SHORT, size(values, kind=int64), dims)
  call allocate_buffer(var)
  call extract(var, var_ptr)
  var_ptr = values
  nullify (var_ptr)
  if (present(atts)) var%attributes = atts
end function new_variable_int16_5d

module function new_variable_int16_6d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int16), target, intent(in) :: values(:, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type), target :: var
  integer(c_int16_t), pointer :: var_ptr(:, :, :, :, :, :)

  call new_variable_(var, name, NC_SHORT, size(values, kind=int64), dims)
  call allocate_buffer(var)
  call extract(var, var_ptr)
  var_ptr = values
  nullify (var_ptr)
  if (present(atts)) var%attributes = atts
end function new_variable_int16_6d

module function new_variable_int16_7d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int16), target, intent(in) :: values(:, :, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type), target :: var
  integer(c_int16_t), pointer :: var_ptr(:, :, :, :, :, :, :)

  call new_variable_(var, name, NC_SHORT, size(values, kind=int64), dims)
  call allocate_buffer(var)
  call extract(var, var_ptr)
  var_ptr = values
  nullify (var_ptr)
  if (present(atts)) var%attributes = atts
end function new_variable_int16_7d

module function new_variable_int32_1d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int32), target, intent(in) :: values(:)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type), target :: var
  integer(c_int32_t), pointer :: var_ptr(:)

  call new_variable_(var, name, NC_INT, size(values, kind=int64), dims)
  call allocate_buffer(var)
  call extract(var, var_ptr)
  var_ptr = values
  nullify (var_ptr)
  if (present(atts)) var%attributes = atts
end function new_variable_int32_1d

module function new_variable_int32_2d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int32), target, intent(in) :: values(:, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type), target :: var
  integer(c_int32_t), pointer :: var_ptr(:, :)

  call new_variable_(var, name, NC_INT, size(values, kind=int64), dims)
  call allocate_buffer(var)
  call extract(var, var_ptr)
  var_ptr = values
  nullify (var_ptr)
  if (present(atts)) var%attributes = atts
end function new_variable_int32_2d

module function new_variable_int32_3d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int32), target, intent(in) :: values(:, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type), target :: var
  integer(c_int32_t), pointer :: var_ptr(:, :, :)

  call new_variable_(var, name, NC_INT, size(values, kind=int64), dims)
  call allocate_buffer(var)
  call extract(var, var_ptr)
  var_ptr = values
  nullify (var_ptr)
  if (present(atts)) var%attributes = atts
end function new_variable_int32_3d

module function new_variable_int32_4d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int32), target, intent(in) :: values(:, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type), target :: var
  integer(c_int32_t), pointer :: var_ptr(:, :, :, :)

  call new_variable_(var, name, NC_INT, size(values, kind=int64), dims)
  call allocate_buffer(var)
  call extract(var, var_ptr)
  var_ptr = values
  nullify (var_ptr)
  if (present(atts)) var%attributes = atts
end function new_variable_int32_4d

module function new_variable_int32_5d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int32), target, intent(in) :: values(:, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type), target :: var
  integer(c_int32_t), pointer :: var_ptr(:, :, :, :, :)

  call new_variable_(var, name, NC_INT, size(values, kind=int64), dims)
  call allocate_buffer(var)
  call extract(var, var_ptr)
  var_ptr = values
  nullify (var_ptr)
  if (present(atts)) var%attributes = atts
end function new_variable_int32_5d

module function new_variable_int32_6d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int32), target, intent(in) :: values(:, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type), target :: var
  integer(c_int32_t), pointer :: var_ptr(:, :, :, :, :, :)

  call new_variable_(var, name, NC_INT, size(values, kind=int64), dims)
  call allocate_buffer(var)
  call extract(var, var_ptr)
  var_ptr = values
  nullify (var_ptr)
  if (present(atts)) var%attributes = atts
end function new_variable_int32_6d

module function new_variable_int32_7d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int32), target, intent(in) :: values(:, :, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type), target :: var
  integer(c_int32_t), pointer :: var_ptr(:, :, :, :, :, :, :)

  call new_variable_(var, name, NC_INT, size(values, kind=int64), dims)
  call allocate_buffer(var)
  call extract(var, var_ptr)
  var_ptr = values
  nullify (var_ptr)
  if (present(atts)) var%attributes = atts
end function new_variable_int32_7d

module function new_variable_int64_1d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int64), target, intent(in) :: values(:)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type), target :: var
  integer(c_int64_t), pointer :: var_ptr(:)

  call new_variable_(var, name, NC_INT64, size(values, kind=int64), dims)
  call allocate_buffer(var)
  call extract(var, var_ptr)
  var_ptr = values
  nullify (var_ptr)
  if (present(atts)) var%attributes = atts
end function new_variable_int64_1d

module function new_variable_int64_2d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int64), target, intent(in) :: values(:, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type), target :: var
  integer(c_int64_t), pointer :: var_ptr(:, :)

  call new_variable_(var, name, NC_INT64, size(values, kind=int64), dims)
  call allocate_buffer(var)
  call extract(var, var_ptr)
  var_ptr = values
  nullify (var_ptr)
  if (present(atts)) var%attributes = atts
end function new_variable_int64_2d

module function new_variable_int64_3d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int64), target, intent(in) :: values(:, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type), target :: var
  integer(c_int64_t), pointer :: var_ptr(:, :, :)

  call new_variable_(var, name, NC_INT64, size(values, kind=int64), dims)
  call allocate_buffer(var)
  call extract(var, var_ptr)
  var_ptr = values
  nullify (var_ptr)
  if (present(atts)) var%attributes = atts
end function new_variable_int64_3d

module function new_variable_int64_4d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int64), target, intent(in) :: values(:, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type), target :: var
  integer(c_int64_t), pointer :: var_ptr(:, :, :, :)

  call new_variable_(var, name, NC_INT64, size(values, kind=int64), dims)
  call allocate_buffer(var)
  call extract(var, var_ptr)
  var_ptr = values
  nullify (var_ptr)
  if (present(atts)) var%attributes = atts
end function new_variable_int64_4d

module function new_variable_int64_5d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int64), target, intent(in) :: values(:, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type), target :: var
  integer(c_int64_t), pointer :: var_ptr(:, :, :, :, :)

  call new_variable_(var, name, NC_INT64, size(values, kind=int64), dims)
  call allocate_buffer(var)
  call extract(var, var_ptr)
  var_ptr = values
  nullify (var_ptr)
  if (present(atts)) var%attributes = atts
end function new_variable_int64_5d

module function new_variable_int64_6d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int64), target, intent(in) :: values(:, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type), target :: var
  integer(c_int64_t), pointer :: var_ptr(:, :, :, :, :, :)

  call new_variable_(var, name, NC_INT64, size(values, kind=int64), dims)
  call allocate_buffer(var)
  call extract(var, var_ptr)
  var_ptr = values
  nullify (var_ptr)
  if (present(atts)) var%attributes = atts
end function new_variable_int64_6d

module function new_variable_int64_7d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int64), target, intent(in) :: values(:, :, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type), target :: var
  integer(c_int64_t), pointer :: var_ptr(:, :, :, :, :, :, :)

  call new_variable_(var, name, NC_INT64, size(values, kind=int64), dims)
  call allocate_buffer(var)
  call extract(var, var_ptr)
  var_ptr = values
  nullify (var_ptr)
  if (present(atts)) var%attributes = atts
end function new_variable_int64_7d

module function new_variable_real32_1d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  real(real32), target, intent(in) :: values(:)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type), target :: var
  real(c_float), pointer :: var_ptr(:)

  call new_variable_(var, name, NC_FLOAT, size(values, kind=int64), dims)
  call allocate_buffer(var)
  call extract(var, var_ptr)
  var_ptr = values
  nullify (var_ptr)
  if (present(atts)) var%attributes = atts
end function new_variable_real32_1d

module function new_variable_real32_2d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  real(real32), target, intent(in) :: values(:, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type), target :: var
  real(c_float), pointer :: var_ptr(:, :)

  call new_variable_(var, name, NC_FLOAT, size(values, kind=int64), dims)
  call allocate_buffer(var)
  call extract(var, var_ptr)
  var_ptr = values
  nullify (var_ptr)
  if (present(atts)) var%attributes = atts
end function new_variable_real32_2d

module function new_variable_real32_3d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  real(real32), target, intent(in) :: values(:, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type), target :: var
  real(c_float), pointer :: var_ptr(:, :, :)

  call new_variable_(var, name, NC_FLOAT, size(values, kind=int64), dims)
  call allocate_buffer(var)
  call extract(var, var_ptr)
  var_ptr = values
  nullify (var_ptr)
  if (present(atts)) var%attributes = atts
end function new_variable_real32_3d

module function new_variable_real32_4d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  real(real32), target, intent(in) :: values(:, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type), target :: var
  real(c_float), pointer :: var_ptr(:, :, :, :)

  call new_variable_(var, name, NC_FLOAT, size(values, kind=int64), dims)
  call allocate_buffer(var)
  call extract(var, var_ptr)
  var_ptr = values
  nullify (var_ptr)
  if (present(atts)) var%attributes = atts
end function new_variable_real32_4d

module function new_variable_real32_5d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  real(real32), target, intent(in) :: values(:, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type), target :: var
  real(c_float), pointer :: var_ptr(:, :, :, :, :)

  call new_variable_(var, name, NC_FLOAT, size(values, kind=int64), dims)
  call allocate_buffer(var)
  call extract(var, var_ptr)
  var_ptr = values
  nullify (var_ptr)
  if (present(atts)) var%attributes = atts
end function new_variable_real32_5d

module function new_variable_real32_6d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  real(real32), target, intent(in) :: values(:, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type), target :: var
  real(c_float), pointer :: var_ptr(:, :, :, :, :, :)

  call new_variable_(var, name, NC_FLOAT, size(values, kind=int64), dims)
  call allocate_buffer(var)
  call extract(var, var_ptr)
  var_ptr = values
  nullify (var_ptr)
  if (present(atts)) var%attributes = atts
end function new_variable_real32_6d

module function new_variable_real32_7d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  real(real32), target, intent(in) :: values(:, :, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type), target :: var
  real(c_float), pointer :: var_ptr(:, :, :, :, :, :, :)

  call new_variable_(var, name, NC_FLOAT, size(values, kind=int64), dims)
  call allocate_buffer(var)
  call extract(var, var_ptr)
  var_ptr = values
  nullify (var_ptr)
  if (present(atts)) var%attributes = atts
end function new_variable_real32_7d

module function new_variable_real64_1d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  real(real64), target, intent(in) :: values(:)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type), target :: var
  real(c_double), pointer :: var_ptr(:)

  call new_variable_(var, name, NC_DOUBLE, size(values, kind=int64), dims)
  call allocate_buffer(var)
  call extract(var, var_ptr)
  var_ptr = values
  nullify (var_ptr)
  if (present(atts)) var%attributes = atts
end function new_variable_real64_1d

module function new_variable_real64_2d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  real(real64), target, intent(in) :: values(:, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type), target :: var
  real(c_double), pointer :: var_ptr(:, :)

  call new_variable_(var, name, NC_DOUBLE, size(values, kind=int64), dims)
  call allocate_buffer(var)
  call extract(var, var_ptr)
  var_ptr = values
  nullify (var_ptr)
  if (present(atts)) var%attributes = atts
end function new_variable_real64_2d

module function new_variable_real64_3d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  real(real64), target, intent(in) :: values(:, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type), target :: var
  real(c_double), pointer :: var_ptr(:, :, :)

  call new_variable_(var, name, NC_DOUBLE, size(values, kind=int64), dims)
  call allocate_buffer(var)
  call extract(var, var_ptr)
  var_ptr = values
  nullify (var_ptr)
  if (present(atts)) var%attributes = atts
end function new_variable_real64_3d

module function new_variable_real64_4d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  real(real64), target, intent(in) :: values(:, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type), target :: var
  real(c_double), pointer :: var_ptr(:, :, :, :)

  call new_variable_(var, name, NC_DOUBLE, size(values, kind=int64), dims)
  call allocate_buffer(var)
  call extract(var, var_ptr)
  var_ptr = values
  nullify (var_ptr)
  if (present(atts)) var%attributes = atts
end function new_variable_real64_4d

module function new_variable_real64_5d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  real(real64), target, intent(in) :: values(:, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type), target :: var
  real(c_double), pointer :: var_ptr(:, :, :, :, :)

  call new_variable_(var, name, NC_DOUBLE, size(values, kind=int64), dims)
  call allocate_buffer(var)
  call extract(var, var_ptr)
  var_ptr = values
  nullify (var_ptr)
  if (present(atts)) var%attributes = atts
end function new_variable_real64_5d

module function new_variable_real64_6d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  real(real64), target, intent(in) :: values(:, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type), target :: var
  real(c_double), pointer :: var_ptr(:, :, :, :, :, :)

  call new_variable_(var, name, NC_DOUBLE, size(values, kind=int64), dims)
  call allocate_buffer(var)
  call extract(var, var_ptr)
  var_ptr = values
  nullify (var_ptr)
  if (present(atts)) var%attributes = atts
end function new_variable_real64_6d

module function new_variable_real64_7d(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  real(real64), target, intent(in) :: values(:, :, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type), target :: var
  real(c_double), pointer :: var_ptr(:, :, :, :, :, :, :)

  call new_variable_(var, name, NC_DOUBLE, size(values, kind=int64), dims)
  call allocate_buffer(var)
  call extract(var, var_ptr)
  var_ptr = values
  nullify (var_ptr)
  if (present(atts)) var%attributes = atts
end function new_variable_real64_7d

pure subroutine new_variable_(var, name, data_type, length, dims)
  type(variable_type), intent(inout) :: var
  character(len=*), intent(in) :: name
  integer(int32), intent(in) :: data_type
  integer(int64), intent(in) :: length
  type(dimension_type), intent(in) :: dims(:)

  var%name = trim(adjustl(name))
  var%data_type = data_type
  var%length = length
  var%dimensions = dims
end subroutine new_variable_

end submodule submodule_variable_constructor