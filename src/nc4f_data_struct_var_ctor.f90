submodule(nc4f_data_struct) nc4f_data_struct_var_ctor
implicit none (type, external)
contains

!> Construct a `variable_type` of rank 1 and kind int8 from an array.
module function new_var_int8_1d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 1 and element type `integer` of kind `int8`.
  integer(int8), contiguous, target, intent(in) :: values(:)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, BYTE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(BYTE_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int8_1d

!> Construct a `variable_type` of rank 2 and kind int8 from an array.
module function new_var_int8_2d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 2 and element type `integer` of kind `int8`.
  integer(int8), contiguous, target, intent(in) :: values(:, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, BYTE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(BYTE_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int8_2d

!> Construct a `variable_type` of rank 3 and kind int8 from an array.
module function new_var_int8_3d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 3 and element type `integer` of kind `int8`.
  integer(int8), contiguous, target, intent(in) :: values(:, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, BYTE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(BYTE_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int8_3d

!> Construct a `variable_type` of rank 4 and kind int8 from an array.
module function new_var_int8_4d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 4 and element type `integer` of kind `int8`.
  integer(int8), contiguous, target, intent(in) :: values(:, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, BYTE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(BYTE_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int8_4d

!> Construct a `variable_type` of rank 5 and kind int8 from an array.
module function new_var_int8_5d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 5 and element type `integer` of kind `int8`.
  integer(int8), contiguous, target, intent(in) :: values(:, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, BYTE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(BYTE_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int8_5d

!> Construct a `variable_type` of rank 6 and kind int8 from an array.
module function new_var_int8_6d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 6 and element type `integer` of kind `int8`.
  integer(int8), contiguous, target, intent(in) :: values(:, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, BYTE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(BYTE_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int8_6d

!> Construct a `variable_type` of rank 7 and kind int8 from an array.
module function new_var_int8_7d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 7 and element type `integer` of kind `int8`.
  integer(int8), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, BYTE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(BYTE_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int8_7d

!> Construct a `variable_type` of rank 8 and kind int8 from an array.
module function new_var_int8_8d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 8 and element type `integer` of kind `int8`.
  integer(int8), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, BYTE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(BYTE_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int8_8d

!> Construct a `variable_type` of rank 9 and kind int8 from an array.
module function new_var_int8_9d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 9 and element type `integer` of kind `int8`.
  integer(int8), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, BYTE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(BYTE_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int8_9d

!> Construct a `variable_type` of rank 10 and kind int8 from an array.
module function new_var_int8_10d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 10 and element type `integer` of kind `int8`.
  integer(int8), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, BYTE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(BYTE_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int8_10d

!> Construct a `variable_type` of rank 11 and kind int8 from an array.
module function new_var_int8_11d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 11 and element type `integer` of kind `int8`.
  integer(int8), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, BYTE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(BYTE_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int8_11d

!> Construct a `variable_type` of rank 12 and kind int8 from an array.
module function new_var_int8_12d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 12 and element type `integer` of kind `int8`.
  integer(int8), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, BYTE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(BYTE_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int8_12d

!> Construct a `variable_type` of rank 13 and kind int8 from an array.
module function new_var_int8_13d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 13 and element type `integer` of kind `int8`.
  integer(int8), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, BYTE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(BYTE_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int8_13d

!> Construct a `variable_type` of rank 14 and kind int8 from an array.
module function new_var_int8_14d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 14 and element type `integer` of kind `int8`.
  integer(int8), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, BYTE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(BYTE_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int8_14d

!> Construct a `variable_type` of rank 15 and kind int8 from an array.
module function new_var_int8_15d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 15 and element type `integer` of kind `int8`.
  integer(int8), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, BYTE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(BYTE_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int8_15d

!> Construct a `variable_type` of rank 1 and kind int16 from an array.
module function new_var_int16_1d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 1 and element type `integer` of kind `int16`.
  integer(int16), contiguous, target, intent(in) :: values(:)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, SHORT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(SHORT_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int16_1d

!> Construct a `variable_type` of rank 2 and kind int16 from an array.
module function new_var_int16_2d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 2 and element type `integer` of kind `int16`.
  integer(int16), contiguous, target, intent(in) :: values(:, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, SHORT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(SHORT_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int16_2d

!> Construct a `variable_type` of rank 3 and kind int16 from an array.
module function new_var_int16_3d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 3 and element type `integer` of kind `int16`.
  integer(int16), contiguous, target, intent(in) :: values(:, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, SHORT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(SHORT_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int16_3d

!> Construct a `variable_type` of rank 4 and kind int16 from an array.
module function new_var_int16_4d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 4 and element type `integer` of kind `int16`.
  integer(int16), contiguous, target, intent(in) :: values(:, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, SHORT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(SHORT_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int16_4d

!> Construct a `variable_type` of rank 5 and kind int16 from an array.
module function new_var_int16_5d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 5 and element type `integer` of kind `int16`.
  integer(int16), contiguous, target, intent(in) :: values(:, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, SHORT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(SHORT_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int16_5d

!> Construct a `variable_type` of rank 6 and kind int16 from an array.
module function new_var_int16_6d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 6 and element type `integer` of kind `int16`.
  integer(int16), contiguous, target, intent(in) :: values(:, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, SHORT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(SHORT_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int16_6d

!> Construct a `variable_type` of rank 7 and kind int16 from an array.
module function new_var_int16_7d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 7 and element type `integer` of kind `int16`.
  integer(int16), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, SHORT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(SHORT_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int16_7d

!> Construct a `variable_type` of rank 8 and kind int16 from an array.
module function new_var_int16_8d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 8 and element type `integer` of kind `int16`.
  integer(int16), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, SHORT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(SHORT_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int16_8d

!> Construct a `variable_type` of rank 9 and kind int16 from an array.
module function new_var_int16_9d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 9 and element type `integer` of kind `int16`.
  integer(int16), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, SHORT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(SHORT_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int16_9d

!> Construct a `variable_type` of rank 10 and kind int16 from an array.
module function new_var_int16_10d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 10 and element type `integer` of kind `int16`.
  integer(int16), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, SHORT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(SHORT_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int16_10d

!> Construct a `variable_type` of rank 11 and kind int16 from an array.
module function new_var_int16_11d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 11 and element type `integer` of kind `int16`.
  integer(int16), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, SHORT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(SHORT_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int16_11d

!> Construct a `variable_type` of rank 12 and kind int16 from an array.
module function new_var_int16_12d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 12 and element type `integer` of kind `int16`.
  integer(int16), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, SHORT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(SHORT_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int16_12d

!> Construct a `variable_type` of rank 13 and kind int16 from an array.
module function new_var_int16_13d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 13 and element type `integer` of kind `int16`.
  integer(int16), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, SHORT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(SHORT_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int16_13d

!> Construct a `variable_type` of rank 14 and kind int16 from an array.
module function new_var_int16_14d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 14 and element type `integer` of kind `int16`.
  integer(int16), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, SHORT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(SHORT_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int16_14d

!> Construct a `variable_type` of rank 15 and kind int16 from an array.
module function new_var_int16_15d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 15 and element type `integer` of kind `int16`.
  integer(int16), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, SHORT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(SHORT_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int16_15d

!> Construct a `variable_type` of rank 1 and kind int32 from an array.
module function new_var_int32_1d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 1 and element type `integer` of kind `int32`.
  integer(int32), contiguous, target, intent(in) :: values(:)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, INT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(INT_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int32_1d

!> Construct a `variable_type` of rank 2 and kind int32 from an array.
module function new_var_int32_2d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 2 and element type `integer` of kind `int32`.
  integer(int32), contiguous, target, intent(in) :: values(:, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, INT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(INT_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int32_2d

!> Construct a `variable_type` of rank 3 and kind int32 from an array.
module function new_var_int32_3d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 3 and element type `integer` of kind `int32`.
  integer(int32), contiguous, target, intent(in) :: values(:, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, INT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(INT_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int32_3d

!> Construct a `variable_type` of rank 4 and kind int32 from an array.
module function new_var_int32_4d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 4 and element type `integer` of kind `int32`.
  integer(int32), contiguous, target, intent(in) :: values(:, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, INT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(INT_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int32_4d

!> Construct a `variable_type` of rank 5 and kind int32 from an array.
module function new_var_int32_5d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 5 and element type `integer` of kind `int32`.
  integer(int32), contiguous, target, intent(in) :: values(:, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, INT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(INT_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int32_5d

!> Construct a `variable_type` of rank 6 and kind int32 from an array.
module function new_var_int32_6d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 6 and element type `integer` of kind `int32`.
  integer(int32), contiguous, target, intent(in) :: values(:, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, INT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(INT_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int32_6d

!> Construct a `variable_type` of rank 7 and kind int32 from an array.
module function new_var_int32_7d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 7 and element type `integer` of kind `int32`.
  integer(int32), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, INT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(INT_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int32_7d

!> Construct a `variable_type` of rank 8 and kind int32 from an array.
module function new_var_int32_8d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 8 and element type `integer` of kind `int32`.
  integer(int32), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, INT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(INT_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int32_8d

!> Construct a `variable_type` of rank 9 and kind int32 from an array.
module function new_var_int32_9d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 9 and element type `integer` of kind `int32`.
  integer(int32), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, INT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(INT_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int32_9d

!> Construct a `variable_type` of rank 10 and kind int32 from an array.
module function new_var_int32_10d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 10 and element type `integer` of kind `int32`.
  integer(int32), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, INT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(INT_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int32_10d

!> Construct a `variable_type` of rank 11 and kind int32 from an array.
module function new_var_int32_11d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 11 and element type `integer` of kind `int32`.
  integer(int32), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, INT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(INT_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int32_11d

!> Construct a `variable_type` of rank 12 and kind int32 from an array.
module function new_var_int32_12d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 12 and element type `integer` of kind `int32`.
  integer(int32), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, INT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(INT_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int32_12d

!> Construct a `variable_type` of rank 13 and kind int32 from an array.
module function new_var_int32_13d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 13 and element type `integer` of kind `int32`.
  integer(int32), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, INT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(INT_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int32_13d

!> Construct a `variable_type` of rank 14 and kind int32 from an array.
module function new_var_int32_14d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 14 and element type `integer` of kind `int32`.
  integer(int32), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, INT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(INT_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int32_14d

!> Construct a `variable_type` of rank 15 and kind int32 from an array.
module function new_var_int32_15d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 15 and element type `integer` of kind `int32`.
  integer(int32), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, INT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(INT_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int32_15d

!> Construct a `variable_type` of rank 1 and kind int64 from an array.
module function new_var_int64_1d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 1 and element type `integer` of kind `int64`.
  integer(int64), contiguous, target, intent(in) :: values(:)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, INT64_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(INT64_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int64_1d

!> Construct a `variable_type` of rank 2 and kind int64 from an array.
module function new_var_int64_2d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 2 and element type `integer` of kind `int64`.
  integer(int64), contiguous, target, intent(in) :: values(:, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, INT64_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(INT64_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int64_2d

!> Construct a `variable_type` of rank 3 and kind int64 from an array.
module function new_var_int64_3d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 3 and element type `integer` of kind `int64`.
  integer(int64), contiguous, target, intent(in) :: values(:, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, INT64_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(INT64_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int64_3d

!> Construct a `variable_type` of rank 4 and kind int64 from an array.
module function new_var_int64_4d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 4 and element type `integer` of kind `int64`.
  integer(int64), contiguous, target, intent(in) :: values(:, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, INT64_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(INT64_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int64_4d

!> Construct a `variable_type` of rank 5 and kind int64 from an array.
module function new_var_int64_5d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 5 and element type `integer` of kind `int64`.
  integer(int64), contiguous, target, intent(in) :: values(:, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, INT64_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(INT64_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int64_5d

!> Construct a `variable_type` of rank 6 and kind int64 from an array.
module function new_var_int64_6d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 6 and element type `integer` of kind `int64`.
  integer(int64), contiguous, target, intent(in) :: values(:, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, INT64_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(INT64_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int64_6d

!> Construct a `variable_type` of rank 7 and kind int64 from an array.
module function new_var_int64_7d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 7 and element type `integer` of kind `int64`.
  integer(int64), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, INT64_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(INT64_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int64_7d

!> Construct a `variable_type` of rank 8 and kind int64 from an array.
module function new_var_int64_8d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 8 and element type `integer` of kind `int64`.
  integer(int64), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, INT64_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(INT64_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int64_8d

!> Construct a `variable_type` of rank 9 and kind int64 from an array.
module function new_var_int64_9d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 9 and element type `integer` of kind `int64`.
  integer(int64), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, INT64_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(INT64_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int64_9d

!> Construct a `variable_type` of rank 10 and kind int64 from an array.
module function new_var_int64_10d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 10 and element type `integer` of kind `int64`.
  integer(int64), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, INT64_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(INT64_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int64_10d

!> Construct a `variable_type` of rank 11 and kind int64 from an array.
module function new_var_int64_11d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 11 and element type `integer` of kind `int64`.
  integer(int64), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, INT64_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(INT64_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int64_11d

!> Construct a `variable_type` of rank 12 and kind int64 from an array.
module function new_var_int64_12d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 12 and element type `integer` of kind `int64`.
  integer(int64), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, INT64_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(INT64_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int64_12d

!> Construct a `variable_type` of rank 13 and kind int64 from an array.
module function new_var_int64_13d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 13 and element type `integer` of kind `int64`.
  integer(int64), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, INT64_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(INT64_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int64_13d

!> Construct a `variable_type` of rank 14 and kind int64 from an array.
module function new_var_int64_14d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 14 and element type `integer` of kind `int64`.
  integer(int64), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, INT64_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(INT64_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int64_14d

!> Construct a `variable_type` of rank 15 and kind int64 from an array.
module function new_var_int64_15d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 15 and element type `integer` of kind `int64`.
  integer(int64), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, INT64_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(INT64_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_int64_15d

!> Construct a `variable_type` of rank 1 and kind real32 from an array.
module function new_var_real32_1d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 1 and element type `real` of kind `real32`.
  real(real32), contiguous, target, intent(in) :: values(:)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, FLOAT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(FLOAT_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_real32_1d

!> Construct a `variable_type` of rank 2 and kind real32 from an array.
module function new_var_real32_2d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 2 and element type `real` of kind `real32`.
  real(real32), contiguous, target, intent(in) :: values(:, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, FLOAT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(FLOAT_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_real32_2d

!> Construct a `variable_type` of rank 3 and kind real32 from an array.
module function new_var_real32_3d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 3 and element type `real` of kind `real32`.
  real(real32), contiguous, target, intent(in) :: values(:, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, FLOAT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(FLOAT_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_real32_3d

!> Construct a `variable_type` of rank 4 and kind real32 from an array.
module function new_var_real32_4d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 4 and element type `real` of kind `real32`.
  real(real32), contiguous, target, intent(in) :: values(:, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, FLOAT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(FLOAT_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_real32_4d

!> Construct a `variable_type` of rank 5 and kind real32 from an array.
module function new_var_real32_5d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 5 and element type `real` of kind `real32`.
  real(real32), contiguous, target, intent(in) :: values(:, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, FLOAT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(FLOAT_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_real32_5d

!> Construct a `variable_type` of rank 6 and kind real32 from an array.
module function new_var_real32_6d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 6 and element type `real` of kind `real32`.
  real(real32), contiguous, target, intent(in) :: values(:, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, FLOAT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(FLOAT_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_real32_6d

!> Construct a `variable_type` of rank 7 and kind real32 from an array.
module function new_var_real32_7d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 7 and element type `real` of kind `real32`.
  real(real32), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, FLOAT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(FLOAT_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_real32_7d

!> Construct a `variable_type` of rank 8 and kind real32 from an array.
module function new_var_real32_8d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 8 and element type `real` of kind `real32`.
  real(real32), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, FLOAT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(FLOAT_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_real32_8d

!> Construct a `variable_type` of rank 9 and kind real32 from an array.
module function new_var_real32_9d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 9 and element type `real` of kind `real32`.
  real(real32), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, FLOAT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(FLOAT_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_real32_9d

!> Construct a `variable_type` of rank 10 and kind real32 from an array.
module function new_var_real32_10d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 10 and element type `real` of kind `real32`.
  real(real32), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, FLOAT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(FLOAT_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_real32_10d

!> Construct a `variable_type` of rank 11 and kind real32 from an array.
module function new_var_real32_11d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 11 and element type `real` of kind `real32`.
  real(real32), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, FLOAT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(FLOAT_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_real32_11d

!> Construct a `variable_type` of rank 12 and kind real32 from an array.
module function new_var_real32_12d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 12 and element type `real` of kind `real32`.
  real(real32), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, FLOAT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(FLOAT_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_real32_12d

!> Construct a `variable_type` of rank 13 and kind real32 from an array.
module function new_var_real32_13d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 13 and element type `real` of kind `real32`.
  real(real32), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, FLOAT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(FLOAT_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_real32_13d

!> Construct a `variable_type` of rank 14 and kind real32 from an array.
module function new_var_real32_14d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 14 and element type `real` of kind `real32`.
  real(real32), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, FLOAT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(FLOAT_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_real32_14d

!> Construct a `variable_type` of rank 15 and kind real32 from an array.
module function new_var_real32_15d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 15 and element type `real` of kind `real32`.
  real(real32), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, FLOAT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(FLOAT_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_real32_15d

!> Construct a `variable_type` of rank 1 and kind real64 from an array.
module function new_var_real64_1d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 1 and element type `real` of kind `real64`.
  real(real64), contiguous, target, intent(in) :: values(:)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, DOUBLE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(DOUBLE_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_real64_1d

!> Construct a `variable_type` of rank 2 and kind real64 from an array.
module function new_var_real64_2d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 2 and element type `real` of kind `real64`.
  real(real64), contiguous, target, intent(in) :: values(:, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, DOUBLE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(DOUBLE_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_real64_2d

!> Construct a `variable_type` of rank 3 and kind real64 from an array.
module function new_var_real64_3d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 3 and element type `real` of kind `real64`.
  real(real64), contiguous, target, intent(in) :: values(:, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, DOUBLE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(DOUBLE_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_real64_3d

!> Construct a `variable_type` of rank 4 and kind real64 from an array.
module function new_var_real64_4d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 4 and element type `real` of kind `real64`.
  real(real64), contiguous, target, intent(in) :: values(:, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, DOUBLE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(DOUBLE_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_real64_4d

!> Construct a `variable_type` of rank 5 and kind real64 from an array.
module function new_var_real64_5d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 5 and element type `real` of kind `real64`.
  real(real64), contiguous, target, intent(in) :: values(:, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, DOUBLE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(DOUBLE_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_real64_5d

!> Construct a `variable_type` of rank 6 and kind real64 from an array.
module function new_var_real64_6d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 6 and element type `real` of kind `real64`.
  real(real64), contiguous, target, intent(in) :: values(:, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, DOUBLE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(DOUBLE_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_real64_6d

!> Construct a `variable_type` of rank 7 and kind real64 from an array.
module function new_var_real64_7d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 7 and element type `real` of kind `real64`.
  real(real64), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, DOUBLE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(DOUBLE_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_real64_7d

!> Construct a `variable_type` of rank 8 and kind real64 from an array.
module function new_var_real64_8d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 8 and element type `real` of kind `real64`.
  real(real64), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, DOUBLE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(DOUBLE_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_real64_8d

!> Construct a `variable_type` of rank 9 and kind real64 from an array.
module function new_var_real64_9d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 9 and element type `real` of kind `real64`.
  real(real64), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, DOUBLE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(DOUBLE_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_real64_9d

!> Construct a `variable_type` of rank 10 and kind real64 from an array.
module function new_var_real64_10d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 10 and element type `real` of kind `real64`.
  real(real64), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, DOUBLE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(DOUBLE_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_real64_10d

!> Construct a `variable_type` of rank 11 and kind real64 from an array.
module function new_var_real64_11d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 11 and element type `real` of kind `real64`.
  real(real64), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, DOUBLE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(DOUBLE_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_real64_11d

!> Construct a `variable_type` of rank 12 and kind real64 from an array.
module function new_var_real64_12d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 12 and element type `real` of kind `real64`.
  real(real64), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, DOUBLE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(DOUBLE_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_real64_12d

!> Construct a `variable_type` of rank 13 and kind real64 from an array.
module function new_var_real64_13d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 13 and element type `real` of kind `real64`.
  real(real64), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, DOUBLE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(DOUBLE_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_real64_13d

!> Construct a `variable_type` of rank 14 and kind real64 from an array.
module function new_var_real64_14d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 14 and element type `real` of kind `real64`.
  real(real64), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, DOUBLE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(DOUBLE_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_real64_14d

!> Construct a `variable_type` of rank 15 and kind real64 from an array.
module function new_var_real64_15d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Array of values to populate the variable's data buffer.
  !> The array has rank 15 and element type `real` of kind `real64`.
  real(real64), contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_var(var, name, DOUBLE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%buffer, &
        & [buffer_size(DOUBLE_TYPE, size(values, kind=int64))])
    end if
  else if (.not. deep_copy) then
    allocate (var%buffer(0))
  end if
end function new_var_real64_15d

!> Construct a `variable_type` of rank 1 from a character array.
module function new_var_char_1d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Single-character values to populate the variable's data buffer.
  character, contiguous, target, intent(in) :: values(:)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy) error stop "[datarray] Shallow character buffers are unsupported."
  call init_var(var, name, CHAR_TYPE, size(values, kind=int64), dims, atts, deep=.true.)
  if (size(values) > 0) var%buffer = transfer(values, 0_int8, size(var%buffer))
end function new_var_char_1d

!> Construct a `variable_type` of rank 2 from a character array.
module function new_var_char_2d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Single-character values to populate the variable's data buffer.
  character, contiguous, target, intent(in) :: values(:, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy) error stop "[datarray] Shallow character buffers are unsupported."
  call init_var(var, name, CHAR_TYPE, size(values, kind=int64), dims, atts, deep=.true.)
  if (size(values) > 0) var%buffer = transfer(values, 0_int8, size(var%buffer))
end function new_var_char_2d

!> Construct a `variable_type` of rank 3 from a character array.
module function new_var_char_3d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Single-character values to populate the variable's data buffer.
  character, contiguous, target, intent(in) :: values(:, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy) error stop "[datarray] Shallow character buffers are unsupported."
  call init_var(var, name, CHAR_TYPE, size(values, kind=int64), dims, atts, deep=.true.)
  if (size(values) > 0) var%buffer = transfer(values, 0_int8, size(var%buffer))
end function new_var_char_3d

!> Construct a `variable_type` of rank 4 from a character array.
module function new_var_char_4d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Single-character values to populate the variable's data buffer.
  character, contiguous, target, intent(in) :: values(:, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy) error stop "[datarray] Shallow character buffers are unsupported."
  call init_var(var, name, CHAR_TYPE, size(values, kind=int64), dims, atts, deep=.true.)
  if (size(values) > 0) var%buffer = transfer(values, 0_int8, size(var%buffer))
end function new_var_char_4d

!> Construct a `variable_type` of rank 5 from a character array.
module function new_var_char_5d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Single-character values to populate the variable's data buffer.
  character, contiguous, target, intent(in) :: values(:, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy) error stop "[datarray] Shallow character buffers are unsupported."
  call init_var(var, name, CHAR_TYPE, size(values, kind=int64), dims, atts, deep=.true.)
  if (size(values) > 0) var%buffer = transfer(values, 0_int8, size(var%buffer))
end function new_var_char_5d

!> Construct a `variable_type` of rank 6 from a character array.
module function new_var_char_6d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Single-character values to populate the variable's data buffer.
  character, contiguous, target, intent(in) :: values(:, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy) error stop "[datarray] Shallow character buffers are unsupported."
  call init_var(var, name, CHAR_TYPE, size(values, kind=int64), dims, atts, deep=.true.)
  if (size(values) > 0) var%buffer = transfer(values, 0_int8, size(var%buffer))
end function new_var_char_6d

!> Construct a `variable_type` of rank 7 from a character array.
module function new_var_char_7d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Single-character values to populate the variable's data buffer.
  character, contiguous, target, intent(in) :: values(:, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy) error stop "[datarray] Shallow character buffers are unsupported."
  call init_var(var, name, CHAR_TYPE, size(values, kind=int64), dims, atts, deep=.true.)
  if (size(values) > 0) var%buffer = transfer(values, 0_int8, size(var%buffer))
end function new_var_char_7d

!> Construct a `variable_type` of rank 8 from a character array.
module function new_var_char_8d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Single-character values to populate the variable's data buffer.
  character, contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy) error stop "[datarray] Shallow character buffers are unsupported."
  call init_var(var, name, CHAR_TYPE, size(values, kind=int64), dims, atts, deep=.true.)
  if (size(values) > 0) var%buffer = transfer(values, 0_int8, size(var%buffer))
end function new_var_char_8d

!> Construct a `variable_type` of rank 9 from a character array.
module function new_var_char_9d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Single-character values to populate the variable's data buffer.
  character, contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy) error stop "[datarray] Shallow character buffers are unsupported."
  call init_var(var, name, CHAR_TYPE, size(values, kind=int64), dims, atts, deep=.true.)
  if (size(values) > 0) var%buffer = transfer(values, 0_int8, size(var%buffer))
end function new_var_char_9d

!> Construct a `variable_type` of rank 10 from a character array.
module function new_var_char_10d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Single-character values to populate the variable's data buffer.
  character, contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy) error stop "[datarray] Shallow character buffers are unsupported."
  call init_var(var, name, CHAR_TYPE, size(values, kind=int64), dims, atts, deep=.true.)
  if (size(values) > 0) var%buffer = transfer(values, 0_int8, size(var%buffer))
end function new_var_char_10d

!> Construct a `variable_type` of rank 11 from a character array.
module function new_var_char_11d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Single-character values to populate the variable's data buffer.
  character, contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy) error stop "[datarray] Shallow character buffers are unsupported."
  call init_var(var, name, CHAR_TYPE, size(values, kind=int64), dims, atts, deep=.true.)
  if (size(values) > 0) var%buffer = transfer(values, 0_int8, size(var%buffer))
end function new_var_char_11d

!> Construct a `variable_type` of rank 12 from a character array.
module function new_var_char_12d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Single-character values to populate the variable's data buffer.
  character, contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy) error stop "[datarray] Shallow character buffers are unsupported."
  call init_var(var, name, CHAR_TYPE, size(values, kind=int64), dims, atts, deep=.true.)
  if (size(values) > 0) var%buffer = transfer(values, 0_int8, size(var%buffer))
end function new_var_char_12d

!> Construct a `variable_type` of rank 13 from a character array.
module function new_var_char_13d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Single-character values to populate the variable's data buffer.
  character, contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy) error stop "[datarray] Shallow character buffers are unsupported."
  call init_var(var, name, CHAR_TYPE, size(values, kind=int64), dims, atts, deep=.true.)
  if (size(values) > 0) var%buffer = transfer(values, 0_int8, size(var%buffer))
end function new_var_char_13d

!> Construct a `variable_type` of rank 14 from a character array.
module function new_var_char_14d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Single-character values to populate the variable's data buffer.
  character, contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy) error stop "[datarray] Shallow character buffers are unsupported."
  call init_var(var, name, CHAR_TYPE, size(values, kind=int64), dims, atts, deep=.true.)
  if (size(values) > 0) var%buffer = transfer(values, 0_int8, size(var%buffer))
end function new_var_char_14d

!> Construct a `variable_type` of rank 15 from a character array.
module function new_var_char_15d(name, values, dims, atts, deep) result(var)
  !> Name of the variable to create (will be trimmed).
  character(len=*), intent(in) :: name
  !> Single-character values to populate the variable's data buffer.
  character, contiguous, target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !> Dimensions describing the variable's shape, ordered in Fortran order.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional list of attributes to attach to the variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> When true (default), copy values into owned storage.  When false,
  !> retain a borrowed view of this contiguous target array.
  logical, intent(in), optional :: deep
  !> Resulting `variable_type` initialized with metadata and buffer.
  type(variable_type) :: var
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy) error stop "[datarray] Shallow character buffers are unsupported."
  call init_var(var, name, CHAR_TYPE, size(values, kind=int64), dims, atts, deep=.true.)
  if (size(values) > 0) var%buffer = transfer(values, 0_int8, size(var%buffer))
end function new_var_char_15d
end submodule nc4f_data_struct_var_ctor
