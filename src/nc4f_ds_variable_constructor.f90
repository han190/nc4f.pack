submodule(nc4f_ds) nc4f_ds_variable_constructor
implicit none (type, external)
contains

module function new_var_int8_1d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 1 and kind int8 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int8), target, intent(in) :: values(:)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 1 and element type `integer` of kind `int8`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, BYTE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(BYTE_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int8_1d

module function new_var_int8_2d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 2 and kind int8 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int8), target, intent(in) :: values(:, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 2 and element type `integer` of kind `int8`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, BYTE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(BYTE_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int8_2d

module function new_var_int8_3d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 3 and kind int8 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int8), target, intent(in) :: values(:, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 3 and element type `integer` of kind `int8`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, BYTE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(BYTE_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int8_3d

module function new_var_int8_4d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 4 and kind int8 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int8), target, intent(in) :: values(:, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 4 and element type `integer` of kind `int8`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, BYTE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(BYTE_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int8_4d

module function new_var_int8_5d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 5 and kind int8 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int8), target, intent(in) :: values(:, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 5 and element type `integer` of kind `int8`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, BYTE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(BYTE_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int8_5d

module function new_var_int8_6d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 6 and kind int8 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int8), target, intent(in) :: values(:, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 6 and element type `integer` of kind `int8`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, BYTE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(BYTE_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int8_6d

module function new_var_int8_7d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 7 and kind int8 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int8), target, intent(in) :: values(:, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 7 and element type `integer` of kind `int8`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, BYTE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(BYTE_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int8_7d

module function new_var_int8_8d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 8 and kind int8 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int8), target, intent(in) :: values(:, :, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 8 and element type `integer` of kind `int8`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, BYTE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(BYTE_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int8_8d

module function new_var_int8_9d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 9 and kind int8 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int8), target, intent(in) :: values(:, :, :, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 9 and element type `integer` of kind `int8`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, BYTE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(BYTE_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int8_9d

module function new_var_int8_10d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 10 and kind int8 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int8), target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 10 and element type `integer` of kind `int8`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, BYTE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(BYTE_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int8_10d

module function new_var_int8_11d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 11 and kind int8 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int8), target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 11 and element type `integer` of kind `int8`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, BYTE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(BYTE_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int8_11d

module function new_var_int8_12d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 12 and kind int8 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int8), target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 12 and element type `integer` of kind `int8`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, BYTE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(BYTE_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int8_12d

module function new_var_int8_13d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 13 and kind int8 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int8), target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 13 and element type `integer` of kind `int8`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, BYTE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(BYTE_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int8_13d

module function new_var_int8_14d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 14 and kind int8 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int8), target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 14 and element type `integer` of kind `int8`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, BYTE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(BYTE_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int8_14d

module function new_var_int8_15d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 15 and kind int8 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int8), target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 15 and element type `integer` of kind `int8`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, BYTE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(BYTE_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int8_15d

module function new_var_int16_1d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 1 and kind int16 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int16), target, intent(in) :: values(:)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 1 and element type `integer` of kind `int16`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, SHORT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(SHORT_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int16_1d

module function new_var_int16_2d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 2 and kind int16 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int16), target, intent(in) :: values(:, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 2 and element type `integer` of kind `int16`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, SHORT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(SHORT_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int16_2d

module function new_var_int16_3d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 3 and kind int16 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int16), target, intent(in) :: values(:, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 3 and element type `integer` of kind `int16`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, SHORT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(SHORT_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int16_3d

module function new_var_int16_4d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 4 and kind int16 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int16), target, intent(in) :: values(:, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 4 and element type `integer` of kind `int16`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, SHORT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(SHORT_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int16_4d

module function new_var_int16_5d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 5 and kind int16 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int16), target, intent(in) :: values(:, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 5 and element type `integer` of kind `int16`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, SHORT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(SHORT_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int16_5d

module function new_var_int16_6d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 6 and kind int16 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int16), target, intent(in) :: values(:, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 6 and element type `integer` of kind `int16`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, SHORT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(SHORT_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int16_6d

module function new_var_int16_7d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 7 and kind int16 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int16), target, intent(in) :: values(:, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 7 and element type `integer` of kind `int16`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, SHORT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(SHORT_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int16_7d

module function new_var_int16_8d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 8 and kind int16 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int16), target, intent(in) :: values(:, :, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 8 and element type `integer` of kind `int16`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, SHORT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(SHORT_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int16_8d

module function new_var_int16_9d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 9 and kind int16 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int16), target, intent(in) :: values(:, :, :, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 9 and element type `integer` of kind `int16`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, SHORT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(SHORT_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int16_9d

module function new_var_int16_10d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 10 and kind int16 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int16), target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 10 and element type `integer` of kind `int16`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, SHORT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(SHORT_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int16_10d

module function new_var_int16_11d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 11 and kind int16 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int16), target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 11 and element type `integer` of kind `int16`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, SHORT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(SHORT_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int16_11d

module function new_var_int16_12d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 12 and kind int16 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int16), target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 12 and element type `integer` of kind `int16`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, SHORT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(SHORT_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int16_12d

module function new_var_int16_13d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 13 and kind int16 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int16), target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 13 and element type `integer` of kind `int16`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, SHORT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(SHORT_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int16_13d

module function new_var_int16_14d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 14 and kind int16 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int16), target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 14 and element type `integer` of kind `int16`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, SHORT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(SHORT_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int16_14d

module function new_var_int16_15d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 15 and kind int16 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int16), target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 15 and element type `integer` of kind `int16`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, SHORT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(SHORT_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int16_15d

module function new_var_int32_1d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 1 and kind int32 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int32), target, intent(in) :: values(:)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 1 and element type `integer` of kind `int32`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, INT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(INT_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int32_1d

module function new_var_int32_2d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 2 and kind int32 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int32), target, intent(in) :: values(:, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 2 and element type `integer` of kind `int32`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, INT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(INT_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int32_2d

module function new_var_int32_3d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 3 and kind int32 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int32), target, intent(in) :: values(:, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 3 and element type `integer` of kind `int32`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, INT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(INT_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int32_3d

module function new_var_int32_4d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 4 and kind int32 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int32), target, intent(in) :: values(:, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 4 and element type `integer` of kind `int32`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, INT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(INT_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int32_4d

module function new_var_int32_5d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 5 and kind int32 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int32), target, intent(in) :: values(:, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 5 and element type `integer` of kind `int32`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, INT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(INT_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int32_5d

module function new_var_int32_6d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 6 and kind int32 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int32), target, intent(in) :: values(:, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 6 and element type `integer` of kind `int32`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, INT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(INT_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int32_6d

module function new_var_int32_7d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 7 and kind int32 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int32), target, intent(in) :: values(:, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 7 and element type `integer` of kind `int32`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, INT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(INT_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int32_7d

module function new_var_int32_8d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 8 and kind int32 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int32), target, intent(in) :: values(:, :, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 8 and element type `integer` of kind `int32`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, INT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(INT_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int32_8d

module function new_var_int32_9d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 9 and kind int32 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int32), target, intent(in) :: values(:, :, :, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 9 and element type `integer` of kind `int32`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, INT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(INT_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int32_9d

module function new_var_int32_10d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 10 and kind int32 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int32), target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 10 and element type `integer` of kind `int32`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, INT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(INT_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int32_10d

module function new_var_int32_11d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 11 and kind int32 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int32), target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 11 and element type `integer` of kind `int32`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, INT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(INT_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int32_11d

module function new_var_int32_12d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 12 and kind int32 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int32), target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 12 and element type `integer` of kind `int32`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, INT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(INT_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int32_12d

module function new_var_int32_13d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 13 and kind int32 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int32), target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 13 and element type `integer` of kind `int32`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, INT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(INT_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int32_13d

module function new_var_int32_14d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 14 and kind int32 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int32), target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 14 and element type `integer` of kind `int32`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, INT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(INT_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int32_14d

module function new_var_int32_15d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 15 and kind int32 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int32), target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 15 and element type `integer` of kind `int32`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, INT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(INT_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int32_15d

module function new_var_int64_1d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 1 and kind int64 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int64), target, intent(in) :: values(:)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 1 and element type `integer` of kind `int64`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, INT64_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(INT64_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int64_1d

module function new_var_int64_2d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 2 and kind int64 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int64), target, intent(in) :: values(:, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 2 and element type `integer` of kind `int64`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, INT64_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(INT64_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int64_2d

module function new_var_int64_3d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 3 and kind int64 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int64), target, intent(in) :: values(:, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 3 and element type `integer` of kind `int64`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, INT64_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(INT64_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int64_3d

module function new_var_int64_4d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 4 and kind int64 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int64), target, intent(in) :: values(:, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 4 and element type `integer` of kind `int64`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, INT64_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(INT64_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int64_4d

module function new_var_int64_5d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 5 and kind int64 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int64), target, intent(in) :: values(:, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 5 and element type `integer` of kind `int64`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, INT64_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(INT64_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int64_5d

module function new_var_int64_6d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 6 and kind int64 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int64), target, intent(in) :: values(:, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 6 and element type `integer` of kind `int64`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, INT64_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(INT64_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int64_6d

module function new_var_int64_7d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 7 and kind int64 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int64), target, intent(in) :: values(:, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 7 and element type `integer` of kind `int64`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, INT64_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(INT64_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int64_7d

module function new_var_int64_8d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 8 and kind int64 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int64), target, intent(in) :: values(:, :, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 8 and element type `integer` of kind `int64`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, INT64_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(INT64_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int64_8d

module function new_var_int64_9d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 9 and kind int64 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int64), target, intent(in) :: values(:, :, :, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 9 and element type `integer` of kind `int64`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, INT64_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(INT64_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int64_9d

module function new_var_int64_10d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 10 and kind int64 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int64), target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 10 and element type `integer` of kind `int64`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, INT64_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(INT64_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int64_10d

module function new_var_int64_11d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 11 and kind int64 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int64), target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 11 and element type `integer` of kind `int64`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, INT64_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(INT64_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int64_11d

module function new_var_int64_12d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 12 and kind int64 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int64), target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 12 and element type `integer` of kind `int64`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, INT64_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(INT64_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int64_12d

module function new_var_int64_13d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 13 and kind int64 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int64), target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 13 and element type `integer` of kind `int64`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, INT64_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(INT64_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int64_13d

module function new_var_int64_14d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 14 and kind int64 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int64), target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 14 and element type `integer` of kind `int64`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, INT64_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(INT64_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int64_14d

module function new_var_int64_15d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 15 and kind int64 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  integer(int64), target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 15 and element type `integer` of kind `int64`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, INT64_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(INT64_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_int64_15d

module function new_var_real32_1d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 1 and kind real32 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  real(real32), target, intent(in) :: values(:)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 1 and element type `real` of kind `real32`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, FLOAT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(FLOAT_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_real32_1d

module function new_var_real32_2d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 2 and kind real32 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  real(real32), target, intent(in) :: values(:, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 2 and element type `real` of kind `real32`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, FLOAT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(FLOAT_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_real32_2d

module function new_var_real32_3d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 3 and kind real32 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  real(real32), target, intent(in) :: values(:, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 3 and element type `real` of kind `real32`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, FLOAT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(FLOAT_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_real32_3d

module function new_var_real32_4d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 4 and kind real32 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  real(real32), target, intent(in) :: values(:, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 4 and element type `real` of kind `real32`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, FLOAT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(FLOAT_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_real32_4d

module function new_var_real32_5d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 5 and kind real32 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  real(real32), target, intent(in) :: values(:, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 5 and element type `real` of kind `real32`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, FLOAT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(FLOAT_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_real32_5d

module function new_var_real32_6d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 6 and kind real32 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  real(real32), target, intent(in) :: values(:, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 6 and element type `real` of kind `real32`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, FLOAT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(FLOAT_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_real32_6d

module function new_var_real32_7d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 7 and kind real32 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  real(real32), target, intent(in) :: values(:, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 7 and element type `real` of kind `real32`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, FLOAT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(FLOAT_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_real32_7d

module function new_var_real32_8d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 8 and kind real32 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  real(real32), target, intent(in) :: values(:, :, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 8 and element type `real` of kind `real32`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, FLOAT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(FLOAT_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_real32_8d

module function new_var_real32_9d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 9 and kind real32 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  real(real32), target, intent(in) :: values(:, :, :, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 9 and element type `real` of kind `real32`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, FLOAT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(FLOAT_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_real32_9d

module function new_var_real32_10d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 10 and kind real32 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  real(real32), target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 10 and element type `real` of kind `real32`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, FLOAT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(FLOAT_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_real32_10d

module function new_var_real32_11d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 11 and kind real32 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  real(real32), target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 11 and element type `real` of kind `real32`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, FLOAT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(FLOAT_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_real32_11d

module function new_var_real32_12d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 12 and kind real32 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  real(real32), target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 12 and element type `real` of kind `real32`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, FLOAT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(FLOAT_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_real32_12d

module function new_var_real32_13d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 13 and kind real32 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  real(real32), target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 13 and element type `real` of kind `real32`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, FLOAT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(FLOAT_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_real32_13d

module function new_var_real32_14d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 14 and kind real32 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  real(real32), target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 14 and element type `real` of kind `real32`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, FLOAT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(FLOAT_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_real32_14d

module function new_var_real32_15d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 15 and kind real32 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  real(real32), target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 15 and element type `real` of kind `real32`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, FLOAT_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(FLOAT_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_real32_15d

module function new_var_real64_1d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 1 and kind real64 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  real(real64), target, intent(in) :: values(:)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 1 and element type `real` of kind `real64`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, DOUBLE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(DOUBLE_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_real64_1d

module function new_var_real64_2d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 2 and kind real64 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  real(real64), target, intent(in) :: values(:, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 2 and element type `real` of kind `real64`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, DOUBLE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(DOUBLE_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_real64_2d

module function new_var_real64_3d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 3 and kind real64 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  real(real64), target, intent(in) :: values(:, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 3 and element type `real` of kind `real64`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, DOUBLE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(DOUBLE_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_real64_3d

module function new_var_real64_4d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 4 and kind real64 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  real(real64), target, intent(in) :: values(:, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 4 and element type `real` of kind `real64`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, DOUBLE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(DOUBLE_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_real64_4d

module function new_var_real64_5d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 5 and kind real64 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  real(real64), target, intent(in) :: values(:, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 5 and element type `real` of kind `real64`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, DOUBLE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(DOUBLE_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_real64_5d

module function new_var_real64_6d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 6 and kind real64 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  real(real64), target, intent(in) :: values(:, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 6 and element type `real` of kind `real64`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, DOUBLE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(DOUBLE_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_real64_6d

module function new_var_real64_7d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 7 and kind real64 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  real(real64), target, intent(in) :: values(:, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 7 and element type `real` of kind `real64`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, DOUBLE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(DOUBLE_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_real64_7d

module function new_var_real64_8d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 8 and kind real64 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  real(real64), target, intent(in) :: values(:, :, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 8 and element type `real` of kind `real64`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, DOUBLE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(DOUBLE_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_real64_8d

module function new_var_real64_9d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 9 and kind real64 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  real(real64), target, intent(in) :: values(:, :, :, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 9 and element type `real` of kind `real64`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, DOUBLE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(DOUBLE_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_real64_9d

module function new_var_real64_10d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 10 and kind real64 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  real(real64), target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 10 and element type `real` of kind `real64`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, DOUBLE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(DOUBLE_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_real64_10d

module function new_var_real64_11d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 11 and kind real64 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  real(real64), target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 11 and element type `real` of kind `real64`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, DOUBLE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(DOUBLE_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_real64_11d

module function new_var_real64_12d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 12 and kind real64 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  real(real64), target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 12 and element type `real` of kind `real64`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, DOUBLE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(DOUBLE_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_real64_12d

module function new_var_real64_13d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 13 and kind real64 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  real(real64), target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 13 and element type `real` of kind `real64`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, DOUBLE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(DOUBLE_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_real64_13d

module function new_var_real64_14d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 14 and kind real64 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  real(real64), target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 14 and element type `real` of kind `real64`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, DOUBLE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(DOUBLE_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_real64_14d

module function new_var_real64_15d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 15 and kind real64 from an array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  real(real64), target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !! Array of values to populate the variable's data buffer.
  !! The array has rank 15 and element type `real` of kind `real64`.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  type(c_ptr) :: cptr
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy .and. .not. is_contiguous(values)) then
    error stop "[datarray] Shallow values must be contiguous."
  end if
  call init_var_(var, name, DOUBLE_TYPE, size(values, kind=int64), dims, atts, deep_copy)
  if (size(values) > 0) then
    if (deep_copy) then
      var%buffer = transfer(values, 0_int8, size(var%buffer))
    else
      cptr = c_loc(values(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
      call c_f_pointer(cptr, var%ptr, &
        & [buffer_size(DOUBLE_TYPE, size(values, kind=int64))])
    end if
  end if
end function new_var_real64_15d

module function new_var_char_1d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 1 from a character array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  character, target, intent(in) :: values(:)
  !! Single-character values to populate the variable's data buffer.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy) error stop "[datarray] Shallow character buffers are unsupported."
  call init_var_(var, name, CHAR_TYPE, size(values, kind=int64), dims, atts, deep=.true.)
  if (size(values) > 0) var%buffer = transfer(values, 0_int8, size(var%buffer))
end function new_var_char_1d

module function new_var_char_2d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 2 from a character array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  character, target, intent(in) :: values(:, :)
  !! Single-character values to populate the variable's data buffer.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy) error stop "[datarray] Shallow character buffers are unsupported."
  call init_var_(var, name, CHAR_TYPE, size(values, kind=int64), dims, atts, deep=.true.)
  if (size(values) > 0) var%buffer = transfer(values, 0_int8, size(var%buffer))
end function new_var_char_2d

module function new_var_char_3d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 3 from a character array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  character, target, intent(in) :: values(:, :, :)
  !! Single-character values to populate the variable's data buffer.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy) error stop "[datarray] Shallow character buffers are unsupported."
  call init_var_(var, name, CHAR_TYPE, size(values, kind=int64), dims, atts, deep=.true.)
  if (size(values) > 0) var%buffer = transfer(values, 0_int8, size(var%buffer))
end function new_var_char_3d

module function new_var_char_4d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 4 from a character array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  character, target, intent(in) :: values(:, :, :, :)
  !! Single-character values to populate the variable's data buffer.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy) error stop "[datarray] Shallow character buffers are unsupported."
  call init_var_(var, name, CHAR_TYPE, size(values, kind=int64), dims, atts, deep=.true.)
  if (size(values) > 0) var%buffer = transfer(values, 0_int8, size(var%buffer))
end function new_var_char_4d

module function new_var_char_5d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 5 from a character array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  character, target, intent(in) :: values(:, :, :, :, :)
  !! Single-character values to populate the variable's data buffer.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy) error stop "[datarray] Shallow character buffers are unsupported."
  call init_var_(var, name, CHAR_TYPE, size(values, kind=int64), dims, atts, deep=.true.)
  if (size(values) > 0) var%buffer = transfer(values, 0_int8, size(var%buffer))
end function new_var_char_5d

module function new_var_char_6d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 6 from a character array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  character, target, intent(in) :: values(:, :, :, :, :, :)
  !! Single-character values to populate the variable's data buffer.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy) error stop "[datarray] Shallow character buffers are unsupported."
  call init_var_(var, name, CHAR_TYPE, size(values, kind=int64), dims, atts, deep=.true.)
  if (size(values) > 0) var%buffer = transfer(values, 0_int8, size(var%buffer))
end function new_var_char_6d

module function new_var_char_7d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 7 from a character array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  character, target, intent(in) :: values(:, :, :, :, :, :, :)
  !! Single-character values to populate the variable's data buffer.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy) error stop "[datarray] Shallow character buffers are unsupported."
  call init_var_(var, name, CHAR_TYPE, size(values, kind=int64), dims, atts, deep=.true.)
  if (size(values) > 0) var%buffer = transfer(values, 0_int8, size(var%buffer))
end function new_var_char_7d

module function new_var_char_8d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 8 from a character array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  character, target, intent(in) :: values(:, :, :, :, :, :, :, :)
  !! Single-character values to populate the variable's data buffer.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy) error stop "[datarray] Shallow character buffers are unsupported."
  call init_var_(var, name, CHAR_TYPE, size(values, kind=int64), dims, atts, deep=.true.)
  if (size(values) > 0) var%buffer = transfer(values, 0_int8, size(var%buffer))
end function new_var_char_8d

module function new_var_char_9d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 9 from a character array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  character, target, intent(in) :: values(:, :, :, :, :, :, :, :, :)
  !! Single-character values to populate the variable's data buffer.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy) error stop "[datarray] Shallow character buffers are unsupported."
  call init_var_(var, name, CHAR_TYPE, size(values, kind=int64), dims, atts, deep=.true.)
  if (size(values) > 0) var%buffer = transfer(values, 0_int8, size(var%buffer))
end function new_var_char_9d

module function new_var_char_10d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 10 from a character array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  character, target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :)
  !! Single-character values to populate the variable's data buffer.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy) error stop "[datarray] Shallow character buffers are unsupported."
  call init_var_(var, name, CHAR_TYPE, size(values, kind=int64), dims, atts, deep=.true.)
  if (size(values) > 0) var%buffer = transfer(values, 0_int8, size(var%buffer))
end function new_var_char_10d

module function new_var_char_11d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 11 from a character array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  character, target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :)
  !! Single-character values to populate the variable's data buffer.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy) error stop "[datarray] Shallow character buffers are unsupported."
  call init_var_(var, name, CHAR_TYPE, size(values, kind=int64), dims, atts, deep=.true.)
  if (size(values) > 0) var%buffer = transfer(values, 0_int8, size(var%buffer))
end function new_var_char_11d

module function new_var_char_12d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 12 from a character array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  character, target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :)
  !! Single-character values to populate the variable's data buffer.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy) error stop "[datarray] Shallow character buffers are unsupported."
  call init_var_(var, name, CHAR_TYPE, size(values, kind=int64), dims, atts, deep=.true.)
  if (size(values) > 0) var%buffer = transfer(values, 0_int8, size(var%buffer))
end function new_var_char_12d

module function new_var_char_13d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 13 from a character array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  character, target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :, :)
  !! Single-character values to populate the variable's data buffer.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy) error stop "[datarray] Shallow character buffers are unsupported."
  call init_var_(var, name, CHAR_TYPE, size(values, kind=int64), dims, atts, deep=.true.)
  if (size(values) > 0) var%buffer = transfer(values, 0_int8, size(var%buffer))
end function new_var_char_13d

module function new_var_char_14d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 14 from a character array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  character, target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !! Single-character values to populate the variable's data buffer.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy) error stop "[datarray] Shallow character buffers are unsupported."
  call init_var_(var, name, CHAR_TYPE, size(values, kind=int64), dims, atts, deep=.true.)
  if (size(values) > 0) var%buffer = transfer(values, 0_int8, size(var%buffer))
end function new_var_char_14d

module function new_var_char_15d(name, values, dims, atts, deep) result(var)
  !! Construct a `variable_type` of rank 15 from a character array.
  character(len=*), intent(in) :: name
  !! Name of the variable to create (will be trimmed).
  character, target, intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :, :, :, :)
  !! Single-character values to populate the variable's data buffer.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable's shape, ordered in Fortran order.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional list of attributes to attach to the variable.
  logical, intent(in), optional :: deep
  !! When true (default), copy values into owned storage.  When false,
  !! retain a borrowed view of this contiguous target array.
  type(variable_type) :: var
  !! Resulting `variable_type` initialized with metadata and buffer.
  logical :: deep_copy
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (.not. deep_copy) error stop "[datarray] Shallow character buffers are unsupported."
  call init_var_(var, name, CHAR_TYPE, size(values, kind=int64), dims, atts, deep=.true.)
  if (size(values) > 0) var%buffer = transfer(values, 0_int8, size(var%buffer))
end function new_var_char_15d
end submodule nc4f_ds_variable_constructor
