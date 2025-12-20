submodule(nc4f) nc4f_variable_constructor
implicit none (type, external)
contains

!> Construct a `variable_type` of rank 1 and kind int8 from an array.
module function new_var_int8_1d(name, values, dims, atts) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 1 and element type `integer` of kind `int8`.
  integer(int8), intent(in) :: values(:)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  !> Pointer view into the variable's internal buffer with matching type
  !> and rank. Used to copy the input `values` efficiently into `var`.
  integer(c_int8_t), pointer :: var_ptr(:)

  call allocate_variable(var, name, NC_BYTE, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int8_1d

!> Construct a `variable_type` of rank 2 and kind int8 from an array.
module function new_var_int8_2d(name, values, dims, atts) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 2 and element type `integer` of kind `int8`.
  integer(int8), intent(in) :: values(:, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  !> Pointer view into the variable's internal buffer with matching type
  !> and rank. Used to copy the input `values` efficiently into `var`.
  integer(c_int8_t), pointer :: var_ptr(:, :)

  call allocate_variable(var, name, NC_BYTE, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int8_2d

!> Construct a `variable_type` of rank 3 and kind int8 from an array.
module function new_var_int8_3d(name, values, dims, atts) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 3 and element type `integer` of kind `int8`.
  integer(int8), intent(in) :: values(:, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  !> Pointer view into the variable's internal buffer with matching type
  !> and rank. Used to copy the input `values` efficiently into `var`.
  integer(c_int8_t), pointer :: var_ptr(:, :, :)

  call allocate_variable(var, name, NC_BYTE, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int8_3d

!> Construct a `variable_type` of rank 4 and kind int8 from an array.
module function new_var_int8_4d(name, values, dims, atts) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 4 and element type `integer` of kind `int8`.
  integer(int8), intent(in) :: values(:, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  !> Pointer view into the variable's internal buffer with matching type
  !> and rank. Used to copy the input `values` efficiently into `var`.
  integer(c_int8_t), pointer :: var_ptr(:, :, :, :)

  call allocate_variable(var, name, NC_BYTE, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int8_4d

!> Construct a `variable_type` of rank 5 and kind int8 from an array.
module function new_var_int8_5d(name, values, dims, atts) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 5 and element type `integer` of kind `int8`.
  integer(int8), intent(in) :: values(:, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  !> Pointer view into the variable's internal buffer with matching type
  !> and rank. Used to copy the input `values` efficiently into `var`.
  integer(c_int8_t), pointer :: var_ptr(:, :, :, :, :)

  call allocate_variable(var, name, NC_BYTE, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int8_5d

!> Construct a `variable_type` of rank 6 and kind int8 from an array.
module function new_var_int8_6d(name, values, dims, atts) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 6 and element type `integer` of kind `int8`.
  integer(int8), intent(in) :: values(:, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  !> Pointer view into the variable's internal buffer with matching type
  !> and rank. Used to copy the input `values` efficiently into `var`.
  integer(c_int8_t), pointer :: var_ptr(:, :, :, :, :, :)

  call allocate_variable(var, name, NC_BYTE, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int8_6d

!> Construct a `variable_type` of rank 7 and kind int8 from an array.
module function new_var_int8_7d(name, values, dims, atts) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 7 and element type `integer` of kind `int8`.
  integer(int8), intent(in) :: values(:, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  !> Pointer view into the variable's internal buffer with matching type
  !> and rank. Used to copy the input `values` efficiently into `var`.
  integer(c_int8_t), pointer :: var_ptr(:, :, :, :, :, :, :)

  call allocate_variable(var, name, NC_BYTE, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int8_7d

!> Construct a `variable_type` of rank 1 and kind int16 from an array.
module function new_var_int16_1d(name, values, dims, atts) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 1 and element type `integer` of kind `int16`.
  integer(int16), intent(in) :: values(:)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  !> Pointer view into the variable's internal buffer with matching type
  !> and rank. Used to copy the input `values` efficiently into `var`.
  integer(c_int16_t), pointer :: var_ptr(:)

  call allocate_variable(var, name, NC_SHORT, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int16_1d

!> Construct a `variable_type` of rank 2 and kind int16 from an array.
module function new_var_int16_2d(name, values, dims, atts) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 2 and element type `integer` of kind `int16`.
  integer(int16), intent(in) :: values(:, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  !> Pointer view into the variable's internal buffer with matching type
  !> and rank. Used to copy the input `values` efficiently into `var`.
  integer(c_int16_t), pointer :: var_ptr(:, :)

  call allocate_variable(var, name, NC_SHORT, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int16_2d

!> Construct a `variable_type` of rank 3 and kind int16 from an array.
module function new_var_int16_3d(name, values, dims, atts) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 3 and element type `integer` of kind `int16`.
  integer(int16), intent(in) :: values(:, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  !> Pointer view into the variable's internal buffer with matching type
  !> and rank. Used to copy the input `values` efficiently into `var`.
  integer(c_int16_t), pointer :: var_ptr(:, :, :)

  call allocate_variable(var, name, NC_SHORT, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int16_3d

!> Construct a `variable_type` of rank 4 and kind int16 from an array.
module function new_var_int16_4d(name, values, dims, atts) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 4 and element type `integer` of kind `int16`.
  integer(int16), intent(in) :: values(:, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  !> Pointer view into the variable's internal buffer with matching type
  !> and rank. Used to copy the input `values` efficiently into `var`.
  integer(c_int16_t), pointer :: var_ptr(:, :, :, :)

  call allocate_variable(var, name, NC_SHORT, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int16_4d

!> Construct a `variable_type` of rank 5 and kind int16 from an array.
module function new_var_int16_5d(name, values, dims, atts) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 5 and element type `integer` of kind `int16`.
  integer(int16), intent(in) :: values(:, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  !> Pointer view into the variable's internal buffer with matching type
  !> and rank. Used to copy the input `values` efficiently into `var`.
  integer(c_int16_t), pointer :: var_ptr(:, :, :, :, :)

  call allocate_variable(var, name, NC_SHORT, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int16_5d

!> Construct a `variable_type` of rank 6 and kind int16 from an array.
module function new_var_int16_6d(name, values, dims, atts) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 6 and element type `integer` of kind `int16`.
  integer(int16), intent(in) :: values(:, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  !> Pointer view into the variable's internal buffer with matching type
  !> and rank. Used to copy the input `values` efficiently into `var`.
  integer(c_int16_t), pointer :: var_ptr(:, :, :, :, :, :)

  call allocate_variable(var, name, NC_SHORT, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int16_6d

!> Construct a `variable_type` of rank 7 and kind int16 from an array.
module function new_var_int16_7d(name, values, dims, atts) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 7 and element type `integer` of kind `int16`.
  integer(int16), intent(in) :: values(:, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  !> Pointer view into the variable's internal buffer with matching type
  !> and rank. Used to copy the input `values` efficiently into `var`.
  integer(c_int16_t), pointer :: var_ptr(:, :, :, :, :, :, :)

  call allocate_variable(var, name, NC_SHORT, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int16_7d

!> Construct a `variable_type` of rank 1 and kind int32 from an array.
module function new_var_int32_1d(name, values, dims, atts) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 1 and element type `integer` of kind `int32`.
  integer(int32), intent(in) :: values(:)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  !> Pointer view into the variable's internal buffer with matching type
  !> and rank. Used to copy the input `values` efficiently into `var`.
  integer(c_int32_t), pointer :: var_ptr(:)

  call allocate_variable(var, name, NC_INT, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int32_1d

!> Construct a `variable_type` of rank 2 and kind int32 from an array.
module function new_var_int32_2d(name, values, dims, atts) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 2 and element type `integer` of kind `int32`.
  integer(int32), intent(in) :: values(:, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  !> Pointer view into the variable's internal buffer with matching type
  !> and rank. Used to copy the input `values` efficiently into `var`.
  integer(c_int32_t), pointer :: var_ptr(:, :)

  call allocate_variable(var, name, NC_INT, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int32_2d

!> Construct a `variable_type` of rank 3 and kind int32 from an array.
module function new_var_int32_3d(name, values, dims, atts) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 3 and element type `integer` of kind `int32`.
  integer(int32), intent(in) :: values(:, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  !> Pointer view into the variable's internal buffer with matching type
  !> and rank. Used to copy the input `values` efficiently into `var`.
  integer(c_int32_t), pointer :: var_ptr(:, :, :)

  call allocate_variable(var, name, NC_INT, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int32_3d

!> Construct a `variable_type` of rank 4 and kind int32 from an array.
module function new_var_int32_4d(name, values, dims, atts) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 4 and element type `integer` of kind `int32`.
  integer(int32), intent(in) :: values(:, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  !> Pointer view into the variable's internal buffer with matching type
  !> and rank. Used to copy the input `values` efficiently into `var`.
  integer(c_int32_t), pointer :: var_ptr(:, :, :, :)

  call allocate_variable(var, name, NC_INT, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int32_4d

!> Construct a `variable_type` of rank 5 and kind int32 from an array.
module function new_var_int32_5d(name, values, dims, atts) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 5 and element type `integer` of kind `int32`.
  integer(int32), intent(in) :: values(:, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  !> Pointer view into the variable's internal buffer with matching type
  !> and rank. Used to copy the input `values` efficiently into `var`.
  integer(c_int32_t), pointer :: var_ptr(:, :, :, :, :)

  call allocate_variable(var, name, NC_INT, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int32_5d

!> Construct a `variable_type` of rank 6 and kind int32 from an array.
module function new_var_int32_6d(name, values, dims, atts) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 6 and element type `integer` of kind `int32`.
  integer(int32), intent(in) :: values(:, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  !> Pointer view into the variable's internal buffer with matching type
  !> and rank. Used to copy the input `values` efficiently into `var`.
  integer(c_int32_t), pointer :: var_ptr(:, :, :, :, :, :)

  call allocate_variable(var, name, NC_INT, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int32_6d

!> Construct a `variable_type` of rank 7 and kind int32 from an array.
module function new_var_int32_7d(name, values, dims, atts) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 7 and element type `integer` of kind `int32`.
  integer(int32), intent(in) :: values(:, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  !> Pointer view into the variable's internal buffer with matching type
  !> and rank. Used to copy the input `values` efficiently into `var`.
  integer(c_int32_t), pointer :: var_ptr(:, :, :, :, :, :, :)

  call allocate_variable(var, name, NC_INT, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int32_7d

!> Construct a `variable_type` of rank 1 and kind int64 from an array.
module function new_var_int64_1d(name, values, dims, atts) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 1 and element type `integer` of kind `int64`.
  integer(int64), intent(in) :: values(:)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  !> Pointer view into the variable's internal buffer with matching type
  !> and rank. Used to copy the input `values` efficiently into `var`.
  integer(c_int64_t), pointer :: var_ptr(:)

  call allocate_variable(var, name, NC_INT64, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int64_1d

!> Construct a `variable_type` of rank 2 and kind int64 from an array.
module function new_var_int64_2d(name, values, dims, atts) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 2 and element type `integer` of kind `int64`.
  integer(int64), intent(in) :: values(:, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  !> Pointer view into the variable's internal buffer with matching type
  !> and rank. Used to copy the input `values` efficiently into `var`.
  integer(c_int64_t), pointer :: var_ptr(:, :)

  call allocate_variable(var, name, NC_INT64, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int64_2d

!> Construct a `variable_type` of rank 3 and kind int64 from an array.
module function new_var_int64_3d(name, values, dims, atts) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 3 and element type `integer` of kind `int64`.
  integer(int64), intent(in) :: values(:, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  !> Pointer view into the variable's internal buffer with matching type
  !> and rank. Used to copy the input `values` efficiently into `var`.
  integer(c_int64_t), pointer :: var_ptr(:, :, :)

  call allocate_variable(var, name, NC_INT64, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int64_3d

!> Construct a `variable_type` of rank 4 and kind int64 from an array.
module function new_var_int64_4d(name, values, dims, atts) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 4 and element type `integer` of kind `int64`.
  integer(int64), intent(in) :: values(:, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  !> Pointer view into the variable's internal buffer with matching type
  !> and rank. Used to copy the input `values` efficiently into `var`.
  integer(c_int64_t), pointer :: var_ptr(:, :, :, :)

  call allocate_variable(var, name, NC_INT64, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int64_4d

!> Construct a `variable_type` of rank 5 and kind int64 from an array.
module function new_var_int64_5d(name, values, dims, atts) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 5 and element type `integer` of kind `int64`.
  integer(int64), intent(in) :: values(:, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  !> Pointer view into the variable's internal buffer with matching type
  !> and rank. Used to copy the input `values` efficiently into `var`.
  integer(c_int64_t), pointer :: var_ptr(:, :, :, :, :)

  call allocate_variable(var, name, NC_INT64, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int64_5d

!> Construct a `variable_type` of rank 6 and kind int64 from an array.
module function new_var_int64_6d(name, values, dims, atts) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 6 and element type `integer` of kind `int64`.
  integer(int64), intent(in) :: values(:, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  !> Pointer view into the variable's internal buffer with matching type
  !> and rank. Used to copy the input `values` efficiently into `var`.
  integer(c_int64_t), pointer :: var_ptr(:, :, :, :, :, :)

  call allocate_variable(var, name, NC_INT64, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int64_6d

!> Construct a `variable_type` of rank 7 and kind int64 from an array.
module function new_var_int64_7d(name, values, dims, atts) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 7 and element type `integer` of kind `int64`.
  integer(int64), intent(in) :: values(:, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  !> Pointer view into the variable's internal buffer with matching type
  !> and rank. Used to copy the input `values` efficiently into `var`.
  integer(c_int64_t), pointer :: var_ptr(:, :, :, :, :, :, :)

  call allocate_variable(var, name, NC_INT64, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_int64_7d

!> Construct a `variable_type` of rank 1 and kind real32 from an array.
module function new_var_real32_1d(name, values, dims, atts) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 1 and element type `real` of kind `real32`.
  real(real32), intent(in) :: values(:)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  !> Pointer view into the variable's internal buffer with matching type
  !> and rank. Used to copy the input `values` efficiently into `var`.
  real(c_float), pointer :: var_ptr(:)

  call allocate_variable(var, name, NC_FLOAT, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_real32_1d

!> Construct a `variable_type` of rank 2 and kind real32 from an array.
module function new_var_real32_2d(name, values, dims, atts) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 2 and element type `real` of kind `real32`.
  real(real32), intent(in) :: values(:, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  !> Pointer view into the variable's internal buffer with matching type
  !> and rank. Used to copy the input `values` efficiently into `var`.
  real(c_float), pointer :: var_ptr(:, :)

  call allocate_variable(var, name, NC_FLOAT, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_real32_2d

!> Construct a `variable_type` of rank 3 and kind real32 from an array.
module function new_var_real32_3d(name, values, dims, atts) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 3 and element type `real` of kind `real32`.
  real(real32), intent(in) :: values(:, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  !> Pointer view into the variable's internal buffer with matching type
  !> and rank. Used to copy the input `values` efficiently into `var`.
  real(c_float), pointer :: var_ptr(:, :, :)

  call allocate_variable(var, name, NC_FLOAT, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_real32_3d

!> Construct a `variable_type` of rank 4 and kind real32 from an array.
module function new_var_real32_4d(name, values, dims, atts) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 4 and element type `real` of kind `real32`.
  real(real32), intent(in) :: values(:, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  !> Pointer view into the variable's internal buffer with matching type
  !> and rank. Used to copy the input `values` efficiently into `var`.
  real(c_float), pointer :: var_ptr(:, :, :, :)

  call allocate_variable(var, name, NC_FLOAT, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_real32_4d

!> Construct a `variable_type` of rank 5 and kind real32 from an array.
module function new_var_real32_5d(name, values, dims, atts) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 5 and element type `real` of kind `real32`.
  real(real32), intent(in) :: values(:, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  !> Pointer view into the variable's internal buffer with matching type
  !> and rank. Used to copy the input `values` efficiently into `var`.
  real(c_float), pointer :: var_ptr(:, :, :, :, :)

  call allocate_variable(var, name, NC_FLOAT, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_real32_5d

!> Construct a `variable_type` of rank 6 and kind real32 from an array.
module function new_var_real32_6d(name, values, dims, atts) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 6 and element type `real` of kind `real32`.
  real(real32), intent(in) :: values(:, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  !> Pointer view into the variable's internal buffer with matching type
  !> and rank. Used to copy the input `values` efficiently into `var`.
  real(c_float), pointer :: var_ptr(:, :, :, :, :, :)

  call allocate_variable(var, name, NC_FLOAT, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_real32_6d

!> Construct a `variable_type` of rank 7 and kind real32 from an array.
module function new_var_real32_7d(name, values, dims, atts) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 7 and element type `real` of kind `real32`.
  real(real32), intent(in) :: values(:, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  !> Pointer view into the variable's internal buffer with matching type
  !> and rank. Used to copy the input `values` efficiently into `var`.
  real(c_float), pointer :: var_ptr(:, :, :, :, :, :, :)

  call allocate_variable(var, name, NC_FLOAT, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_real32_7d

!> Construct a `variable_type` of rank 1 and kind real64 from an array.
module function new_var_real64_1d(name, values, dims, atts) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 1 and element type `real` of kind `real64`.
  real(real64), intent(in) :: values(:)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  !> Pointer view into the variable's internal buffer with matching type
  !> and rank. Used to copy the input `values` efficiently into `var`.
  real(c_double), pointer :: var_ptr(:)

  call allocate_variable(var, name, NC_DOUBLE, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_real64_1d

!> Construct a `variable_type` of rank 2 and kind real64 from an array.
module function new_var_real64_2d(name, values, dims, atts) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 2 and element type `real` of kind `real64`.
  real(real64), intent(in) :: values(:, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  !> Pointer view into the variable's internal buffer with matching type
  !> and rank. Used to copy the input `values` efficiently into `var`.
  real(c_double), pointer :: var_ptr(:, :)

  call allocate_variable(var, name, NC_DOUBLE, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_real64_2d

!> Construct a `variable_type` of rank 3 and kind real64 from an array.
module function new_var_real64_3d(name, values, dims, atts) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 3 and element type `real` of kind `real64`.
  real(real64), intent(in) :: values(:, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  !> Pointer view into the variable's internal buffer with matching type
  !> and rank. Used to copy the input `values` efficiently into `var`.
  real(c_double), pointer :: var_ptr(:, :, :)

  call allocate_variable(var, name, NC_DOUBLE, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_real64_3d

!> Construct a `variable_type` of rank 4 and kind real64 from an array.
module function new_var_real64_4d(name, values, dims, atts) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 4 and element type `real` of kind `real64`.
  real(real64), intent(in) :: values(:, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  !> Pointer view into the variable's internal buffer with matching type
  !> and rank. Used to copy the input `values` efficiently into `var`.
  real(c_double), pointer :: var_ptr(:, :, :, :)

  call allocate_variable(var, name, NC_DOUBLE, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_real64_4d

!> Construct a `variable_type` of rank 5 and kind real64 from an array.
module function new_var_real64_5d(name, values, dims, atts) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 5 and element type `real` of kind `real64`.
  real(real64), intent(in) :: values(:, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  !> Pointer view into the variable's internal buffer with matching type
  !> and rank. Used to copy the input `values` efficiently into `var`.
  real(c_double), pointer :: var_ptr(:, :, :, :, :)

  call allocate_variable(var, name, NC_DOUBLE, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_real64_5d

!> Construct a `variable_type` of rank 6 and kind real64 from an array.
module function new_var_real64_6d(name, values, dims, atts) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 6 and element type `real` of kind `real64`.
  real(real64), intent(in) :: values(:, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  !> Pointer view into the variable's internal buffer with matching type
  !> and rank. Used to copy the input `values` efficiently into `var`.
  real(c_double), pointer :: var_ptr(:, :, :, :, :, :)

  call allocate_variable(var, name, NC_DOUBLE, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_real64_6d

!> Construct a `variable_type` of rank 7 and kind real64 from an array.
module function new_var_real64_7d(name, values, dims, atts) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 7 and element type `real` of kind `real64`.
  real(real64), intent(in) :: values(:, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  !> Pointer view into the variable's internal buffer with matching type
  !> and rank. Used to copy the input `values` efficiently into `var`.
  real(c_double), pointer :: var_ptr(:, :, :, :, :, :, :)

  call allocate_variable(var, name, NC_DOUBLE, size(values, kind=int64), dims, atts)
  call extract(var, var_ptr)
  var_ptr = values
end function new_var_real64_7d

end submodule nc4f_variable_constructor
