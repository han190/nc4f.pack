submodule(module_netcdf) submodule_arithmetic
implicit none
contains

module function add_vars(x, y) result(res)
  type(variable_type), target, intent(in) :: x, y
  type(variable_type), target :: res
  type(c_ptr) :: x_cptr, y_cptr, r_cptr
  integer(int64) :: buffer_size

  if (any(x%dimensions /= y%dimensions)) &
    & error stop "[add_vars] Unequal dimensions."
  if (x%data_type /= y%data_type) &
    & error stop "[add_vars] Unequal data type."

  res%name = x%name
  res%data_type = x%data_type
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_FLOAT)
    block
    real(real32), pointer :: x_fptr(:), y_fptr(:), r_fptr(:)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr + y_fptr
    nullify (x_fptr, y_fptr, r_fptr)
    end block
  case (NC_DOUBLE)
    block
    real(real64), pointer :: x_fptr(:), y_fptr(:), r_fptr(:)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr + y_fptr
    nullify (x_fptr, y_fptr, r_fptr)
    end block
  case (NC_INT)
    block
    integer(int32), pointer :: x_fptr(:), y_fptr(:), r_fptr(:)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr + y_fptr
    nullify (x_fptr, y_fptr, r_fptr)
    end block
  case (NC_INT64)
    block
    integer(int64), pointer :: x_fptr(:), y_fptr(:), r_fptr(:)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr + y_fptr
    nullify (x_fptr, y_fptr, r_fptr)
    end block
  end select
end function add_vars

module function add_var_real32(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  real(real32), intent(in) :: y
  type(variable_type), target :: res
  type(c_ptr) :: x_cptr, r_cptr
  integer(int64) :: buffer_size

  res%name = x%name
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_FLOAT)
    block
    real(real32), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_FLOAT, NC_FLOAT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr + y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_DOUBLE)
    block
    real(real64), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_DOUBLE, NC_FLOAT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr + y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_INT)
    block
    integer(int32), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT, NC_FLOAT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr + y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_INT64)
    block
    integer(int64), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT64, NC_FLOAT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr + y
    nullify (x_fptr, r_fptr)
    end block
  end select
end function add_var_real32

module function add_real32_var(x, y) result(res)
  real(real32), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res
  type(c_ptr) :: y_cptr, r_cptr
  integer(int64) :: buffer_size

  res%name = y%name
  res%length = y%length
  res%dimensions = y%dimensions
  res%attributes = y%attributes

  select case (y%data_type)
  case (NC_FLOAT)
    block
    real(real32), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_FLOAT, NC_FLOAT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x + y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_DOUBLE)
    block
    real(real64), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_DOUBLE, NC_FLOAT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x + y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_INT)
    block
    integer(int32), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT, NC_FLOAT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x + y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_INT64)
    block
    integer(int64), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT64, NC_FLOAT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x + y_fptr
    nullify (y_fptr, r_fptr)
    end block
  end select
end function add_real32_var

module function add_var_real64(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  real(real64), intent(in) :: y
  type(variable_type), target :: res
  type(c_ptr) :: x_cptr, r_cptr
  integer(int64) :: buffer_size

  res%name = x%name
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_FLOAT)
    block
    real(real32), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_FLOAT, NC_DOUBLE)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr + y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_DOUBLE)
    block
    real(real64), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_DOUBLE, NC_DOUBLE)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr + y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_INT)
    block
    integer(int32), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT, NC_DOUBLE)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr + y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_INT64)
    block
    integer(int64), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT64, NC_DOUBLE)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr + y
    nullify (x_fptr, r_fptr)
    end block
  end select
end function add_var_real64

module function add_real64_var(x, y) result(res)
  real(real64), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res
  type(c_ptr) :: y_cptr, r_cptr
  integer(int64) :: buffer_size

  res%name = y%name
  res%length = y%length
  res%dimensions = y%dimensions
  res%attributes = y%attributes

  select case (y%data_type)
  case (NC_FLOAT)
    block
    real(real32), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_FLOAT, NC_DOUBLE)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x + y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_DOUBLE)
    block
    real(real64), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_DOUBLE, NC_DOUBLE)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x + y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_INT)
    block
    integer(int32), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT, NC_DOUBLE)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x + y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_INT64)
    block
    integer(int64), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT64, NC_DOUBLE)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x + y_fptr
    nullify (y_fptr, r_fptr)
    end block
  end select
end function add_real64_var

module function add_var_int32(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  integer(int32), intent(in) :: y
  type(variable_type), target :: res
  type(c_ptr) :: x_cptr, r_cptr
  integer(int64) :: buffer_size

  res%name = x%name
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_FLOAT)
    block
    real(real32), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_FLOAT, NC_INT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr + y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_DOUBLE)
    block
    real(real64), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_DOUBLE, NC_INT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr + y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_INT)
    block
    integer(int32), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT, NC_INT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr + y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_INT64)
    block
    integer(int64), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT64, NC_INT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr + y
    nullify (x_fptr, r_fptr)
    end block
  end select
end function add_var_int32

module function add_int32_var(x, y) result(res)
  integer(int32), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res
  type(c_ptr) :: y_cptr, r_cptr
  integer(int64) :: buffer_size

  res%name = y%name
  res%length = y%length
  res%dimensions = y%dimensions
  res%attributes = y%attributes

  select case (y%data_type)
  case (NC_FLOAT)
    block
    real(real32), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_FLOAT, NC_INT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x + y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_DOUBLE)
    block
    real(real64), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_DOUBLE, NC_INT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x + y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_INT)
    block
    integer(int32), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT, NC_INT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x + y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_INT64)
    block
    integer(int64), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT64, NC_INT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x + y_fptr
    nullify (y_fptr, r_fptr)
    end block
  end select
end function add_int32_var

module function add_var_int64(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  integer(int64), intent(in) :: y
  type(variable_type), target :: res
  type(c_ptr) :: x_cptr, r_cptr
  integer(int64) :: buffer_size

  res%name = x%name
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_FLOAT)
    block
    real(real32), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_FLOAT, NC_INT64)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr + y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_DOUBLE)
    block
    real(real64), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_DOUBLE, NC_INT64)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr + y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_INT)
    block
    integer(int32), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT, NC_INT64)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr + y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_INT64)
    block
    integer(int64), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT64, NC_INT64)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr + y
    nullify (x_fptr, r_fptr)
    end block
  end select
end function add_var_int64

module function add_int64_var(x, y) result(res)
  integer(int64), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res
  type(c_ptr) :: y_cptr, r_cptr
  integer(int64) :: buffer_size

  res%name = y%name
  res%length = y%length
  res%dimensions = y%dimensions
  res%attributes = y%attributes

  select case (y%data_type)
  case (NC_FLOAT)
    block
    real(real32), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_FLOAT, NC_INT64)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x + y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_DOUBLE)
    block
    real(real64), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_DOUBLE, NC_INT64)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x + y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_INT)
    block
    integer(int32), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT, NC_INT64)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x + y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_INT64)
    block
    integer(int64), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT64, NC_INT64)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x + y_fptr
    nullify (y_fptr, r_fptr)
    end block
  end select
end function add_int64_var

module function sub_vars(x, y) result(res)
  type(variable_type), target, intent(in) :: x, y
  type(variable_type), target :: res
  type(c_ptr) :: x_cptr, y_cptr, r_cptr
  integer(int64) :: buffer_size

  if (any(x%dimensions /= y%dimensions)) &
    & error stop "[add_vars] Unequal dimensions."
  if (x%data_type /= y%data_type) &
    & error stop "[add_vars] Unequal data type."

  res%name = x%name
  res%data_type = x%data_type
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_FLOAT)
    block
    real(real32), pointer :: x_fptr(:), y_fptr(:), r_fptr(:)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr - y_fptr
    nullify (x_fptr, y_fptr, r_fptr)
    end block
  case (NC_DOUBLE)
    block
    real(real64), pointer :: x_fptr(:), y_fptr(:), r_fptr(:)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr - y_fptr
    nullify (x_fptr, y_fptr, r_fptr)
    end block
  case (NC_INT)
    block
    integer(int32), pointer :: x_fptr(:), y_fptr(:), r_fptr(:)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr - y_fptr
    nullify (x_fptr, y_fptr, r_fptr)
    end block
  case (NC_INT64)
    block
    integer(int64), pointer :: x_fptr(:), y_fptr(:), r_fptr(:)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr - y_fptr
    nullify (x_fptr, y_fptr, r_fptr)
    end block
  end select
end function sub_vars

module function sub_var_real32(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  real(real32), intent(in) :: y
  type(variable_type), target :: res
  type(c_ptr) :: x_cptr, r_cptr
  integer(int64) :: buffer_size

  res%name = x%name
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_FLOAT)
    block
    real(real32), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_FLOAT, NC_FLOAT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr - y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_DOUBLE)
    block
    real(real64), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_DOUBLE, NC_FLOAT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr - y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_INT)
    block
    integer(int32), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT, NC_FLOAT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr - y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_INT64)
    block
    integer(int64), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT64, NC_FLOAT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr - y
    nullify (x_fptr, r_fptr)
    end block
  end select
end function sub_var_real32

module function sub_real32_var(x, y) result(res)
  real(real32), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res
  type(c_ptr) :: y_cptr, r_cptr
  integer(int64) :: buffer_size

  res%name = y%name
  res%length = y%length
  res%dimensions = y%dimensions
  res%attributes = y%attributes

  select case (y%data_type)
  case (NC_FLOAT)
    block
    real(real32), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_FLOAT, NC_FLOAT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x - y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_DOUBLE)
    block
    real(real64), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_DOUBLE, NC_FLOAT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x - y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_INT)
    block
    integer(int32), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT, NC_FLOAT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x - y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_INT64)
    block
    integer(int64), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT64, NC_FLOAT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x - y_fptr
    nullify (y_fptr, r_fptr)
    end block
  end select
end function sub_real32_var

module function sub_var_real64(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  real(real64), intent(in) :: y
  type(variable_type), target :: res
  type(c_ptr) :: x_cptr, r_cptr
  integer(int64) :: buffer_size

  res%name = x%name
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_FLOAT)
    block
    real(real32), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_FLOAT, NC_DOUBLE)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr - y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_DOUBLE)
    block
    real(real64), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_DOUBLE, NC_DOUBLE)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr - y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_INT)
    block
    integer(int32), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT, NC_DOUBLE)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr - y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_INT64)
    block
    integer(int64), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT64, NC_DOUBLE)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr - y
    nullify (x_fptr, r_fptr)
    end block
  end select
end function sub_var_real64

module function sub_real64_var(x, y) result(res)
  real(real64), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res
  type(c_ptr) :: y_cptr, r_cptr
  integer(int64) :: buffer_size

  res%name = y%name
  res%length = y%length
  res%dimensions = y%dimensions
  res%attributes = y%attributes

  select case (y%data_type)
  case (NC_FLOAT)
    block
    real(real32), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_FLOAT, NC_DOUBLE)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x - y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_DOUBLE)
    block
    real(real64), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_DOUBLE, NC_DOUBLE)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x - y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_INT)
    block
    integer(int32), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT, NC_DOUBLE)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x - y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_INT64)
    block
    integer(int64), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT64, NC_DOUBLE)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x - y_fptr
    nullify (y_fptr, r_fptr)
    end block
  end select
end function sub_real64_var

module function sub_var_int32(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  integer(int32), intent(in) :: y
  type(variable_type), target :: res
  type(c_ptr) :: x_cptr, r_cptr
  integer(int64) :: buffer_size

  res%name = x%name
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_FLOAT)
    block
    real(real32), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_FLOAT, NC_INT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr - y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_DOUBLE)
    block
    real(real64), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_DOUBLE, NC_INT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr - y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_INT)
    block
    integer(int32), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT, NC_INT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr - y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_INT64)
    block
    integer(int64), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT64, NC_INT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr - y
    nullify (x_fptr, r_fptr)
    end block
  end select
end function sub_var_int32

module function sub_int32_var(x, y) result(res)
  integer(int32), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res
  type(c_ptr) :: y_cptr, r_cptr
  integer(int64) :: buffer_size

  res%name = y%name
  res%length = y%length
  res%dimensions = y%dimensions
  res%attributes = y%attributes

  select case (y%data_type)
  case (NC_FLOAT)
    block
    real(real32), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_FLOAT, NC_INT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x - y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_DOUBLE)
    block
    real(real64), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_DOUBLE, NC_INT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x - y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_INT)
    block
    integer(int32), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT, NC_INT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x - y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_INT64)
    block
    integer(int64), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT64, NC_INT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x - y_fptr
    nullify (y_fptr, r_fptr)
    end block
  end select
end function sub_int32_var

module function sub_var_int64(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  integer(int64), intent(in) :: y
  type(variable_type), target :: res
  type(c_ptr) :: x_cptr, r_cptr
  integer(int64) :: buffer_size

  res%name = x%name
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_FLOAT)
    block
    real(real32), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_FLOAT, NC_INT64)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr - y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_DOUBLE)
    block
    real(real64), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_DOUBLE, NC_INT64)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr - y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_INT)
    block
    integer(int32), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT, NC_INT64)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr - y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_INT64)
    block
    integer(int64), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT64, NC_INT64)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr - y
    nullify (x_fptr, r_fptr)
    end block
  end select
end function sub_var_int64

module function sub_int64_var(x, y) result(res)
  integer(int64), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res
  type(c_ptr) :: y_cptr, r_cptr
  integer(int64) :: buffer_size

  res%name = y%name
  res%length = y%length
  res%dimensions = y%dimensions
  res%attributes = y%attributes

  select case (y%data_type)
  case (NC_FLOAT)
    block
    real(real32), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_FLOAT, NC_INT64)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x - y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_DOUBLE)
    block
    real(real64), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_DOUBLE, NC_INT64)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x - y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_INT)
    block
    integer(int32), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT, NC_INT64)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x - y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_INT64)
    block
    integer(int64), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT64, NC_INT64)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x - y_fptr
    nullify (y_fptr, r_fptr)
    end block
  end select
end function sub_int64_var

module function mul_vars(x, y) result(res)
  type(variable_type), target, intent(in) :: x, y
  type(variable_type), target :: res
  type(c_ptr) :: x_cptr, y_cptr, r_cptr
  integer(int64) :: buffer_size

  if (any(x%dimensions /= y%dimensions)) &
    & error stop "[add_vars] Unequal dimensions."
  if (x%data_type /= y%data_type) &
    & error stop "[add_vars] Unequal data type."

  res%name = x%name
  res%data_type = x%data_type
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_FLOAT)
    block
    real(real32), pointer :: x_fptr(:), y_fptr(:), r_fptr(:)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr * y_fptr
    nullify (x_fptr, y_fptr, r_fptr)
    end block
  case (NC_DOUBLE)
    block
    real(real64), pointer :: x_fptr(:), y_fptr(:), r_fptr(:)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr * y_fptr
    nullify (x_fptr, y_fptr, r_fptr)
    end block
  case (NC_INT)
    block
    integer(int32), pointer :: x_fptr(:), y_fptr(:), r_fptr(:)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr * y_fptr
    nullify (x_fptr, y_fptr, r_fptr)
    end block
  case (NC_INT64)
    block
    integer(int64), pointer :: x_fptr(:), y_fptr(:), r_fptr(:)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr * y_fptr
    nullify (x_fptr, y_fptr, r_fptr)
    end block
  end select
end function mul_vars

module function mul_var_real32(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  real(real32), intent(in) :: y
  type(variable_type), target :: res
  type(c_ptr) :: x_cptr, r_cptr
  integer(int64) :: buffer_size

  res%name = x%name
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_FLOAT)
    block
    real(real32), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_FLOAT, NC_FLOAT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr * y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_DOUBLE)
    block
    real(real64), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_DOUBLE, NC_FLOAT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr * y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_INT)
    block
    integer(int32), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT, NC_FLOAT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr * y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_INT64)
    block
    integer(int64), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT64, NC_FLOAT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr * y
    nullify (x_fptr, r_fptr)
    end block
  end select
end function mul_var_real32

module function mul_real32_var(x, y) result(res)
  real(real32), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res
  type(c_ptr) :: y_cptr, r_cptr
  integer(int64) :: buffer_size

  res%name = y%name
  res%length = y%length
  res%dimensions = y%dimensions
  res%attributes = y%attributes

  select case (y%data_type)
  case (NC_FLOAT)
    block
    real(real32), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_FLOAT, NC_FLOAT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x * y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_DOUBLE)
    block
    real(real64), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_DOUBLE, NC_FLOAT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x * y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_INT)
    block
    integer(int32), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT, NC_FLOAT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x * y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_INT64)
    block
    integer(int64), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT64, NC_FLOAT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x * y_fptr
    nullify (y_fptr, r_fptr)
    end block
  end select
end function mul_real32_var

module function mul_var_real64(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  real(real64), intent(in) :: y
  type(variable_type), target :: res
  type(c_ptr) :: x_cptr, r_cptr
  integer(int64) :: buffer_size

  res%name = x%name
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_FLOAT)
    block
    real(real32), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_FLOAT, NC_DOUBLE)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr * y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_DOUBLE)
    block
    real(real64), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_DOUBLE, NC_DOUBLE)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr * y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_INT)
    block
    integer(int32), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT, NC_DOUBLE)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr * y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_INT64)
    block
    integer(int64), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT64, NC_DOUBLE)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr * y
    nullify (x_fptr, r_fptr)
    end block
  end select
end function mul_var_real64

module function mul_real64_var(x, y) result(res)
  real(real64), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res
  type(c_ptr) :: y_cptr, r_cptr
  integer(int64) :: buffer_size

  res%name = y%name
  res%length = y%length
  res%dimensions = y%dimensions
  res%attributes = y%attributes

  select case (y%data_type)
  case (NC_FLOAT)
    block
    real(real32), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_FLOAT, NC_DOUBLE)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x * y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_DOUBLE)
    block
    real(real64), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_DOUBLE, NC_DOUBLE)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x * y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_INT)
    block
    integer(int32), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT, NC_DOUBLE)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x * y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_INT64)
    block
    integer(int64), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT64, NC_DOUBLE)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x * y_fptr
    nullify (y_fptr, r_fptr)
    end block
  end select
end function mul_real64_var

module function mul_var_int32(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  integer(int32), intent(in) :: y
  type(variable_type), target :: res
  type(c_ptr) :: x_cptr, r_cptr
  integer(int64) :: buffer_size

  res%name = x%name
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_FLOAT)
    block
    real(real32), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_FLOAT, NC_INT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr * y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_DOUBLE)
    block
    real(real64), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_DOUBLE, NC_INT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr * y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_INT)
    block
    integer(int32), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT, NC_INT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr * y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_INT64)
    block
    integer(int64), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT64, NC_INT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr * y
    nullify (x_fptr, r_fptr)
    end block
  end select
end function mul_var_int32

module function mul_int32_var(x, y) result(res)
  integer(int32), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res
  type(c_ptr) :: y_cptr, r_cptr
  integer(int64) :: buffer_size

  res%name = y%name
  res%length = y%length
  res%dimensions = y%dimensions
  res%attributes = y%attributes

  select case (y%data_type)
  case (NC_FLOAT)
    block
    real(real32), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_FLOAT, NC_INT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x * y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_DOUBLE)
    block
    real(real64), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_DOUBLE, NC_INT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x * y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_INT)
    block
    integer(int32), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT, NC_INT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x * y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_INT64)
    block
    integer(int64), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT64, NC_INT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x * y_fptr
    nullify (y_fptr, r_fptr)
    end block
  end select
end function mul_int32_var

module function mul_var_int64(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  integer(int64), intent(in) :: y
  type(variable_type), target :: res
  type(c_ptr) :: x_cptr, r_cptr
  integer(int64) :: buffer_size

  res%name = x%name
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_FLOAT)
    block
    real(real32), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_FLOAT, NC_INT64)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr * y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_DOUBLE)
    block
    real(real64), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_DOUBLE, NC_INT64)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr * y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_INT)
    block
    integer(int32), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT, NC_INT64)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr * y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_INT64)
    block
    integer(int64), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT64, NC_INT64)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr * y
    nullify (x_fptr, r_fptr)
    end block
  end select
end function mul_var_int64

module function mul_int64_var(x, y) result(res)
  integer(int64), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res
  type(c_ptr) :: y_cptr, r_cptr
  integer(int64) :: buffer_size

  res%name = y%name
  res%length = y%length
  res%dimensions = y%dimensions
  res%attributes = y%attributes

  select case (y%data_type)
  case (NC_FLOAT)
    block
    real(real32), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_FLOAT, NC_INT64)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x * y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_DOUBLE)
    block
    real(real64), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_DOUBLE, NC_INT64)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x * y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_INT)
    block
    integer(int32), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT, NC_INT64)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x * y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_INT64)
    block
    integer(int64), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT64, NC_INT64)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x * y_fptr
    nullify (y_fptr, r_fptr)
    end block
  end select
end function mul_int64_var

module function div_vars(x, y) result(res)
  type(variable_type), target, intent(in) :: x, y
  type(variable_type), target :: res
  type(c_ptr) :: x_cptr, y_cptr, r_cptr
  integer(int64) :: buffer_size

  if (any(x%dimensions /= y%dimensions)) &
    & error stop "[add_vars] Unequal dimensions."
  if (x%data_type /= y%data_type) &
    & error stop "[add_vars] Unequal data type."

  res%name = x%name
  res%data_type = x%data_type
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_FLOAT)
    block
    real(real32), pointer :: x_fptr(:), y_fptr(:), r_fptr(:)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr / y_fptr
    nullify (x_fptr, y_fptr, r_fptr)
    end block
  case (NC_DOUBLE)
    block
    real(real64), pointer :: x_fptr(:), y_fptr(:), r_fptr(:)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr / y_fptr
    nullify (x_fptr, y_fptr, r_fptr)
    end block
  case (NC_INT)
    block
    integer(int32), pointer :: x_fptr(:), y_fptr(:), r_fptr(:)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr / y_fptr
    nullify (x_fptr, y_fptr, r_fptr)
    end block
  case (NC_INT64)
    block
    integer(int64), pointer :: x_fptr(:), y_fptr(:), r_fptr(:)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr / y_fptr
    nullify (x_fptr, y_fptr, r_fptr)
    end block
  end select
end function div_vars

module function div_var_real32(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  real(real32), intent(in) :: y
  type(variable_type), target :: res
  type(c_ptr) :: x_cptr, r_cptr
  integer(int64) :: buffer_size

  res%name = x%name
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_FLOAT)
    block
    real(real32), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_FLOAT, NC_FLOAT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr / y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_DOUBLE)
    block
    real(real64), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_DOUBLE, NC_FLOAT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr / y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_INT)
    block
    integer(int32), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT, NC_FLOAT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr / y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_INT64)
    block
    integer(int64), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT64, NC_FLOAT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr / y
    nullify (x_fptr, r_fptr)
    end block
  end select
end function div_var_real32

module function div_real32_var(x, y) result(res)
  real(real32), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res
  type(c_ptr) :: y_cptr, r_cptr
  integer(int64) :: buffer_size

  res%name = y%name
  res%length = y%length
  res%dimensions = y%dimensions
  res%attributes = y%attributes

  select case (y%data_type)
  case (NC_FLOAT)
    block
    real(real32), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_FLOAT, NC_FLOAT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x / y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_DOUBLE)
    block
    real(real64), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_DOUBLE, NC_FLOAT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x / y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_INT)
    block
    integer(int32), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT, NC_FLOAT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x / y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_INT64)
    block
    integer(int64), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT64, NC_FLOAT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x / y_fptr
    nullify (y_fptr, r_fptr)
    end block
  end select
end function div_real32_var

module function div_var_real64(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  real(real64), intent(in) :: y
  type(variable_type), target :: res
  type(c_ptr) :: x_cptr, r_cptr
  integer(int64) :: buffer_size

  res%name = x%name
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_FLOAT)
    block
    real(real32), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_FLOAT, NC_DOUBLE)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr / y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_DOUBLE)
    block
    real(real64), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_DOUBLE, NC_DOUBLE)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr / y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_INT)
    block
    integer(int32), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT, NC_DOUBLE)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr / y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_INT64)
    block
    integer(int64), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT64, NC_DOUBLE)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr / y
    nullify (x_fptr, r_fptr)
    end block
  end select
end function div_var_real64

module function div_real64_var(x, y) result(res)
  real(real64), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res
  type(c_ptr) :: y_cptr, r_cptr
  integer(int64) :: buffer_size

  res%name = y%name
  res%length = y%length
  res%dimensions = y%dimensions
  res%attributes = y%attributes

  select case (y%data_type)
  case (NC_FLOAT)
    block
    real(real32), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_FLOAT, NC_DOUBLE)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x / y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_DOUBLE)
    block
    real(real64), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_DOUBLE, NC_DOUBLE)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x / y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_INT)
    block
    integer(int32), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT, NC_DOUBLE)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x / y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_INT64)
    block
    integer(int64), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT64, NC_DOUBLE)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x / y_fptr
    nullify (y_fptr, r_fptr)
    end block
  end select
end function div_real64_var

module function div_var_int32(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  integer(int32), intent(in) :: y
  type(variable_type), target :: res
  type(c_ptr) :: x_cptr, r_cptr
  integer(int64) :: buffer_size

  res%name = x%name
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_FLOAT)
    block
    real(real32), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_FLOAT, NC_INT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr / y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_DOUBLE)
    block
    real(real64), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_DOUBLE, NC_INT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr / y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_INT)
    block
    integer(int32), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT, NC_INT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr / y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_INT64)
    block
    integer(int64), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT64, NC_INT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr / y
    nullify (x_fptr, r_fptr)
    end block
  end select
end function div_var_int32

module function div_int32_var(x, y) result(res)
  integer(int32), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res
  type(c_ptr) :: y_cptr, r_cptr
  integer(int64) :: buffer_size

  res%name = y%name
  res%length = y%length
  res%dimensions = y%dimensions
  res%attributes = y%attributes

  select case (y%data_type)
  case (NC_FLOAT)
    block
    real(real32), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_FLOAT, NC_INT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x / y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_DOUBLE)
    block
    real(real64), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_DOUBLE, NC_INT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x / y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_INT)
    block
    integer(int32), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT, NC_INT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x / y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_INT64)
    block
    integer(int64), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT64, NC_INT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x / y_fptr
    nullify (y_fptr, r_fptr)
    end block
  end select
end function div_int32_var

module function div_var_int64(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  integer(int64), intent(in) :: y
  type(variable_type), target :: res
  type(c_ptr) :: x_cptr, r_cptr
  integer(int64) :: buffer_size

  res%name = x%name
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_FLOAT)
    block
    real(real32), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_FLOAT, NC_INT64)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr / y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_DOUBLE)
    block
    real(real64), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_DOUBLE, NC_INT64)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr / y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_INT)
    block
    integer(int32), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT, NC_INT64)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr / y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_INT64)
    block
    integer(int64), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT64, NC_INT64)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr / y
    nullify (x_fptr, r_fptr)
    end block
  end select
end function div_var_int64

module function div_int64_var(x, y) result(res)
  integer(int64), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res
  type(c_ptr) :: y_cptr, r_cptr
  integer(int64) :: buffer_size

  res%name = y%name
  res%length = y%length
  res%dimensions = y%dimensions
  res%attributes = y%attributes

  select case (y%data_type)
  case (NC_FLOAT)
    block
    real(real32), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_FLOAT, NC_INT64)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x / y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_DOUBLE)
    block
    real(real64), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_DOUBLE, NC_INT64)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x / y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_INT)
    block
    integer(int32), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT, NC_INT64)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x / y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_INT64)
    block
    integer(int64), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT64, NC_INT64)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x / y_fptr
    nullify (y_fptr, r_fptr)
    end block
  end select
end function div_int64_var

module function pow_vars(x, y) result(res)
  type(variable_type), target, intent(in) :: x, y
  type(variable_type), target :: res
  type(c_ptr) :: x_cptr, y_cptr, r_cptr
  integer(int64) :: buffer_size

  if (any(x%dimensions /= y%dimensions)) &
    & error stop "[add_vars] Unequal dimensions."
  if (x%data_type /= y%data_type) &
    & error stop "[add_vars] Unequal data type."

  res%name = x%name
  res%data_type = x%data_type
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_FLOAT)
    block
    real(real32), pointer :: x_fptr(:), y_fptr(:), r_fptr(:)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr ** y_fptr
    nullify (x_fptr, y_fptr, r_fptr)
    end block
  case (NC_DOUBLE)
    block
    real(real64), pointer :: x_fptr(:), y_fptr(:), r_fptr(:)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr ** y_fptr
    nullify (x_fptr, y_fptr, r_fptr)
    end block
  case (NC_INT)
    block
    integer(int32), pointer :: x_fptr(:), y_fptr(:), r_fptr(:)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr ** y_fptr
    nullify (x_fptr, y_fptr, r_fptr)
    end block
  case (NC_INT64)
    block
    integer(int64), pointer :: x_fptr(:), y_fptr(:), r_fptr(:)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr ** y_fptr
    nullify (x_fptr, y_fptr, r_fptr)
    end block
  end select
end function pow_vars

module function pow_var_real32(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  real(real32), intent(in) :: y
  type(variable_type), target :: res
  type(c_ptr) :: x_cptr, r_cptr
  integer(int64) :: buffer_size

  res%name = x%name
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_FLOAT)
    block
    real(real32), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_FLOAT, NC_FLOAT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr ** y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_DOUBLE)
    block
    real(real64), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_DOUBLE, NC_FLOAT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr ** y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_INT)
    block
    integer(int32), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT, NC_FLOAT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr ** y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_INT64)
    block
    integer(int64), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT64, NC_FLOAT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr ** y
    nullify (x_fptr, r_fptr)
    end block
  end select
end function pow_var_real32

module function pow_real32_var(x, y) result(res)
  real(real32), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res
  type(c_ptr) :: y_cptr, r_cptr
  integer(int64) :: buffer_size

  res%name = y%name
  res%length = y%length
  res%dimensions = y%dimensions
  res%attributes = y%attributes

  select case (y%data_type)
  case (NC_FLOAT)
    block
    real(real32), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_FLOAT, NC_FLOAT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x ** y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_DOUBLE)
    block
    real(real64), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_DOUBLE, NC_FLOAT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x ** y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_INT)
    block
    integer(int32), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT, NC_FLOAT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x ** y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_INT64)
    block
    integer(int64), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT64, NC_FLOAT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x ** y_fptr
    nullify (y_fptr, r_fptr)
    end block
  end select
end function pow_real32_var

module function pow_var_real64(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  real(real64), intent(in) :: y
  type(variable_type), target :: res
  type(c_ptr) :: x_cptr, r_cptr
  integer(int64) :: buffer_size

  res%name = x%name
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_FLOAT)
    block
    real(real32), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_FLOAT, NC_DOUBLE)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr ** y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_DOUBLE)
    block
    real(real64), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_DOUBLE, NC_DOUBLE)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr ** y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_INT)
    block
    integer(int32), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT, NC_DOUBLE)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr ** y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_INT64)
    block
    integer(int64), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT64, NC_DOUBLE)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr ** y
    nullify (x_fptr, r_fptr)
    end block
  end select
end function pow_var_real64

module function pow_real64_var(x, y) result(res)
  real(real64), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res
  type(c_ptr) :: y_cptr, r_cptr
  integer(int64) :: buffer_size

  res%name = y%name
  res%length = y%length
  res%dimensions = y%dimensions
  res%attributes = y%attributes

  select case (y%data_type)
  case (NC_FLOAT)
    block
    real(real32), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_FLOAT, NC_DOUBLE)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x ** y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_DOUBLE)
    block
    real(real64), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_DOUBLE, NC_DOUBLE)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x ** y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_INT)
    block
    integer(int32), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT, NC_DOUBLE)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x ** y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_INT64)
    block
    integer(int64), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT64, NC_DOUBLE)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x ** y_fptr
    nullify (y_fptr, r_fptr)
    end block
  end select
end function pow_real64_var

module function pow_var_int32(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  integer(int32), intent(in) :: y
  type(variable_type), target :: res
  type(c_ptr) :: x_cptr, r_cptr
  integer(int64) :: buffer_size

  res%name = x%name
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_FLOAT)
    block
    real(real32), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_FLOAT, NC_INT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr ** y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_DOUBLE)
    block
    real(real64), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_DOUBLE, NC_INT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr ** y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_INT)
    block
    integer(int32), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT, NC_INT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr ** y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_INT64)
    block
    integer(int64), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT64, NC_INT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr ** y
    nullify (x_fptr, r_fptr)
    end block
  end select
end function pow_var_int32

module function pow_int32_var(x, y) result(res)
  integer(int32), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res
  type(c_ptr) :: y_cptr, r_cptr
  integer(int64) :: buffer_size

  res%name = y%name
  res%length = y%length
  res%dimensions = y%dimensions
  res%attributes = y%attributes

  select case (y%data_type)
  case (NC_FLOAT)
    block
    real(real32), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_FLOAT, NC_INT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x ** y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_DOUBLE)
    block
    real(real64), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_DOUBLE, NC_INT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x ** y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_INT)
    block
    integer(int32), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT, NC_INT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x ** y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_INT64)
    block
    integer(int64), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT64, NC_INT)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x ** y_fptr
    nullify (y_fptr, r_fptr)
    end block
  end select
end function pow_int32_var

module function pow_var_int64(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  integer(int64), intent(in) :: y
  type(variable_type), target :: res
  type(c_ptr) :: x_cptr, r_cptr
  integer(int64) :: buffer_size

  res%name = x%name
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_FLOAT)
    block
    real(real32), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_FLOAT, NC_INT64)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr ** y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_DOUBLE)
    block
    real(real64), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_DOUBLE, NC_INT64)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr ** y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_INT)
    block
    integer(int32), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT, NC_INT64)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr ** y
    nullify (x_fptr, r_fptr)
    end block
  case (NC_INT64)
    block
    integer(int64), pointer :: x_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT64, NC_INT64)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    x_cptr = c_loc(x%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(x_cptr, x_fptr, [x%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x_fptr ** y
    nullify (x_fptr, r_fptr)
    end block
  end select
end function pow_var_int64

module function pow_int64_var(x, y) result(res)
  integer(int64), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res
  type(c_ptr) :: y_cptr, r_cptr
  integer(int64) :: buffer_size

  res%name = y%name
  res%length = y%length
  res%dimensions = y%dimensions
  res%attributes = y%attributes

  select case (y%data_type)
  case (NC_FLOAT)
    block
    real(real32), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_FLOAT, NC_INT64)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x ** y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_DOUBLE)
    block
    real(real64), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_DOUBLE, NC_INT64)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x ** y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_INT)
    block
    integer(int32), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT, NC_INT64)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x ** y_fptr
    nullify (y_fptr, r_fptr)
    end block
  case (NC_INT64)
    block
    integer(int64), pointer :: y_fptr(:), r_fptr(:)

    res%data_type = max(NC_INT64, NC_INT64)
    buffer_size = get_buffer_size(res%data_type, res%length)
    if (allocation_required(res%buffer, buffer_size)) then
      if (allocated(res%buffer)) deallocate (res%buffer)
      allocate (res%buffer(buffer_size))
    end if

    y_cptr = c_loc(y%buffer(1))
    r_cptr = c_loc(res%buffer(1))

    call c_f_pointer(y_cptr, y_fptr, [y%length])
    call c_f_pointer(r_cptr, r_fptr, [res%length])

    r_fptr = x ** y_fptr
    nullify (y_fptr, r_fptr)
    end block
  end select
end function pow_int64_var

module function sum_vars(vars) result(s)
  type(variable_type), intent(in) :: vars(:)
  type(variable_type) :: s
  integer :: i

  select case (size(vars))
  case (1)
    s = vars(1)
  case (2)
    s = vars(1) + vars(2)
  case (3:)
    s = vars(1)
    do i = 2, size(vars)
      s = s + vars(i)
    end do
  case default
    error stop "[sum_vars] Invalid size."
  end select
end function sum_vars

end submodule submodule_arithmetic
