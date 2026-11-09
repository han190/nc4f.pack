submodule(nc4f_data) nc4f_data_expression
!! Deferred element-wise arithmetic. Leaves borrow their variables and read
!! their values when evaluated; callers retain operand and target storage
!! lifetimes.
implicit none (type, external)
contains

module subroutine assign_expr(result, expr)
  type(variable_type), target, intent(inout) :: result
  type(expression_type), intent(in) :: expr

  call evaluate(expr, result)
end subroutine assign_expr

module subroutine evaluate(expr, result, err)
  type(expression_type), intent(in) :: expr
  type(variable_type), target, intent(inout) :: result
  type(error_type), intent(out), optional :: err
  type(error_type) :: op_err
  type(dimension_type), allocatable :: dims(:)
  type(variable_type), target :: staged
  integer(data_type) :: dtype
  integer(int64) :: n, i
  integer :: nbytes

  call validate_expr(expr, dtype, dims, n, op_err)
  if (.exists. op_err) then
    call return_err(op_err, err)
    return
  end if
  call compute_buffer_size(dtype, n, nbytes, op_err)
  if (.exists. op_err) then
    call return_err(op_err, err)
    return
  end if
  staged%name = ""
  staged%dtype = dtype
  staged%len = n
  staged%dims = dims
  allocate (staged%buffer(nbytes))
  if (n > 0) then
    select case (dtype)
    case (BYTE_TYPE)
      block
        integer(int8), pointer :: values(:)
        call extract(staged, values)
        do i = 1, n
          values(i) = eval_int8(expr, i, op_err)
          if (.exists. op_err) exit
        end do
      end block
    case (SHORT_TYPE)
      block
        integer(int16), pointer :: values(:)
        call extract(staged, values)
        do i = 1, n
          values(i) = eval_int16(expr, i, op_err)
          if (.exists. op_err) exit
        end do
      end block
    case (INT_TYPE)
      block
        integer(int32), pointer :: values(:)
        call extract(staged, values)
        do i = 1, n
          values(i) = eval_int32(expr, i, op_err)
          if (.exists. op_err) exit
        end do
      end block
    case (INT64_TYPE)
      block
        integer(int64), pointer :: values(:)
        call extract(staged, values)
        do i = 1, n
          values(i) = eval_int64(expr, i, op_err)
          if (.exists. op_err) exit
        end do
      end block
    case (FLOAT_TYPE)
      block
        real(real32), pointer :: values(:)
        call extract(staged, values)
        do i = 1, n
          values(i) = eval_real32(expr, i, op_err)
          if (.exists. op_err) exit
        end do
      end block
    case (DOUBLE_TYPE)
      block
        real(real64), pointer :: values(:)
        call extract(staged, values)
        do i = 1, n
          values(i) = eval_real64(expr, i, op_err)
          if (.exists. op_err) exit
        end do
      end block
    case default
      op_err = error_type(INVALID, "evaluate", &
        & "Unsupported operand type.")
      call return_err(op_err, err)
      return
    end select
  end if
  if (.exists. op_err) then
    call return_err(op_err, err)
    return
  end if
  result%id = INVALID_INT32
  result%name = staged%name
  result%dtype = staged%dtype
  result%len = staged%len
  result%dims = staged%dims
  if (allocated(result%atts)) deallocate (result%atts)
  if (allocated(result%storage)) deallocate (result%storage)
  nullify (result%ptr)
  call move_alloc(staged%buffer, result%buffer)
  call return_err(op_err, err)
end subroutine evaluate

recursive subroutine validate_expr(expr, dtype, dims, n, err)
  type(expression_type), intent(in) :: expr
  integer(data_type), intent(out) :: dtype
  type(dimension_type), allocatable, intent(out) :: dims(:)
  integer(int64), intent(out) :: n
  type(error_type), intent(out) :: err
  type(dimension_type), allocatable :: right_dims(:)
  integer(data_type) :: right_type
  integer(int64) :: right_len

  err = error_type()
  dtype = NAT_TYPE
  n = 0
  select case (expr%operation)
  case (OP_LEAF)
    if (.not. associated(expr%leaf)) then
      err = error_type(INVALID, "evaluate", "Expression leaf is absent.")
      return
    end if
    if (.not. allocated(expr%leaf%buffer) .and. &
      & .not. associated(expr%leaf%ptr)) then
      err = error_type(INVALID, "evaluate", "Operand storage is absent.")
      return
    end if
    call validate(expr%leaf, context="evaluate", err=err)
    if (.exists. err) return
    dtype = expr%leaf%dtype
    select case (dtype)
    case (BYTE_TYPE, SHORT_TYPE, INT_TYPE, INT64_TYPE, FLOAT_TYPE, DOUBLE_TYPE)
    case default
      err = error_type(INVALID, "evaluate", "Unsupported operand type.")
      return
    end select
    dims = expr%leaf%dims
    n = expr%leaf%len
  case (OP_SCALAR_INT8, OP_SCALAR_INT16, OP_SCALAR_INT32, &
    & OP_SCALAR_INT64, OP_SCALAR_REAL32, OP_SCALAR_REAL64)
    select case (expr%operation)
    case (OP_SCALAR_INT8)
      dtype = BYTE_TYPE
    case (OP_SCALAR_INT16)
      dtype = SHORT_TYPE
    case (OP_SCALAR_INT32)
      dtype = INT_TYPE
    case (OP_SCALAR_INT64)
      dtype = INT64_TYPE
    case (OP_SCALAR_REAL32)
      dtype = FLOAT_TYPE
    case (OP_SCALAR_REAL64)
      dtype = DOUBLE_TYPE
    case default
      err = error_type(INVALID, "evaluate", &
        & "Unknown scalar expression operation.")
      return
    end select
    allocate (dims(0))
  case (OP_ADD, OP_SUB, OP_MUL, OP_DIV, OP_POW)
    if (.not. allocated(expr%left) .or. .not. allocated(expr%right)) then
      err = error_type(INVALID, "evaluate", "Arithmetic node is incomplete.")
      return
    end if
    call validate_expr(expr%left, dtype, dims, n, err)
    if (.exists. err) return
    call validate_expr(expr%right, right_type, right_dims, right_len, err)
    if (.exists. err) return
    if (dtype /= right_type) then
      err = error_type(INVALID, "evaluate", &
        & "Operand types differ.")
      return
    end if
    if (is_scalar_node(expr%left)) then
      dims = right_dims
      n = right_len
      return
    end if
    if (is_scalar_node(expr%right)) return
    if (n /= right_len) then
      err = error_type(INVALID, "evaluate", &
        & "Operand lengths differ.")
      return
    end if
    if (size(dims) /= size(right_dims)) then
      err = error_type(INVALID, "evaluate", &
        & "Operand dimension counts differ.")
      return
    end if
    if (.not. all(dims == right_dims)) then
      err = error_type(INVALID, "evaluate", &
        & "Operand dimensions differ in name, length, or order.")
      return
    end if
  case (OP_INT8_POW, OP_INT16_POW, OP_INT32_POW, OP_INT64_POW, &
    & OP_REAL32_POW, OP_REAL64_POW)
    if (.not. allocated(expr%left)) then
      err = error_type(INVALID, "evaluate", "Power node is incomplete.")
      return
    end if
    call validate_expr(expr%left, dtype, dims, n, err)
    if (.exists. err) return
    select case (expr%operation)
    case (OP_REAL32_POW)
      if (dtype /= DOUBLE_TYPE) dtype = FLOAT_TYPE
    case (OP_REAL64_POW)
      dtype = DOUBLE_TYPE
    case default
    end select
  case default
    err = error_type(INVALID, "evaluate", "Unknown expression operation.")
  end select
end subroutine validate_expr

pure logical function is_scalar_node(expr)
  type(expression_type), intent(in) :: expr

  select case (expr%operation)
  case (OP_SCALAR_INT8, OP_SCALAR_INT16, OP_SCALAR_INT32, &
    & OP_SCALAR_INT64, OP_SCALAR_REAL32, OP_SCALAR_REAL64)
    is_scalar_node = .true.
  case default
    is_scalar_node = .false.
  end select
end function is_scalar_node

recursive function eval_int8(expr, i, err) result(value)
  type(expression_type), intent(in) :: expr
  integer(int64), intent(in) :: i
  type(error_type), intent(out) :: err
  integer(int8) :: value, left, right
  integer(int8), pointer :: values(:)

  err = error_type()
  value = 0_int8
  select case (expr%operation)
  case (OP_LEAF)
    call extract(expr%leaf, values)
    value = values(i)
  case (OP_SCALAR_INT8)
    value = int(expr%exp_int, int8)
  case (OP_ADD, OP_SUB, OP_MUL, OP_DIV, OP_POW)
    left = eval_int8(expr%left, i, err)
    if (.exists. err) return
    right = eval_int8(expr%right, i, err)
    if (.exists. err) return
    select case (expr%operation)
    case (OP_ADD)
      value = left + right
    case (OP_SUB)
      value = left - right
    case (OP_MUL)
      value = left*right
    case (OP_DIV)
      if (right == 0_int8) then
        err = error_type(INVALID, "evaluate", "Division by zero.")
        return
      end if
      value = left/right
    case (OP_POW)
      if (right < 0) then
        err = error_type(INVALID, "evaluate", &
          & "Negative integer exponent is unsupported.")
        return
      end if
      value = left**right
    case default
      err = error_type(INVALID, "evaluate", &
        & "Unknown expression operation.")
    end select
  case (OP_INT8_POW, OP_INT16_POW, OP_INT32_POW, OP_INT64_POW)
    left = eval_int8(expr%left, i, err)
    if (.exists. err) return
    select case (expr%operation)
    case (OP_INT8_POW)
      if (expr%exp_int < 0) then
        err = error_type(INVALID, "evaluate", &
          & "Negative integer exponent is unsupported.")
        return
      end if
      value = int(left**int(expr%exp_int, int8), int8)
    case (OP_INT16_POW)
      if (expr%exp_int < 0) then
        err = error_type(INVALID, "evaluate", &
          & "Negative integer exponent is unsupported.")
        return
      end if
      value = int(left**int(expr%exp_int, int16), int8)
    case (OP_INT32_POW)
      if (expr%exp_int < 0) then
        err = error_type(INVALID, "evaluate", &
          & "Negative integer exponent is unsupported.")
        return
      end if
      value = int(left**int(expr%exp_int, int32), int8)
    case (OP_INT64_POW)
      if (expr%exp_int < 0) then
        err = error_type(INVALID, "evaluate", &
          & "Negative integer exponent is unsupported.")
        return
      end if
      value = int(left**int(expr%exp_int, int64), int8)
    case default
      err = error_type(INVALID, "evaluate", &
        & "Unknown expression operation.")
    end select
  case default
    err = error_type(INVALID, "evaluate", &
      & "Unknown expression operation.")
  end select
end function eval_int8

recursive function eval_int16(expr, i, err) result(value)
  type(expression_type), intent(in) :: expr
  integer(int64), intent(in) :: i
  type(error_type), intent(out) :: err
  integer(int16) :: value, left, right
  integer(int16), pointer :: values(:)

  err = error_type()
  value = 0_int16
  select case (expr%operation)
  case (OP_LEAF)
    call extract(expr%leaf, values)
    value = values(i)
  case (OP_SCALAR_INT16)
    value = int(expr%exp_int, int16)
  case (OP_ADD, OP_SUB, OP_MUL, OP_DIV, OP_POW)
    left = eval_int16(expr%left, i, err)
    if (.exists. err) return
    right = eval_int16(expr%right, i, err)
    if (.exists. err) return
    select case (expr%operation)
    case (OP_ADD)
      value = left + right
    case (OP_SUB)
      value = left - right
    case (OP_MUL)
      value = left*right
    case (OP_DIV)
      if (right == 0_int16) then
        err = error_type(INVALID, "evaluate", "Division by zero.")
        return
      end if
      value = left/right
    case (OP_POW)
      if (right < 0) then
        err = error_type(INVALID, "evaluate", &
          & "Negative integer exponent is unsupported.")
        return
      end if
      value = left**right
    case default
      err = error_type(INVALID, "evaluate", &
        & "Unknown expression operation.")
    end select
  case (OP_INT8_POW, OP_INT16_POW, OP_INT32_POW, OP_INT64_POW)
    left = eval_int16(expr%left, i, err)
    if (.exists. err) return
    select case (expr%operation)
    case (OP_INT8_POW)
      if (expr%exp_int < 0) then
        err = error_type(INVALID, "evaluate", &
          & "Negative integer exponent is unsupported.")
        return
      end if
      value = int(left**int(expr%exp_int, int8), int16)
    case (OP_INT16_POW)
      if (expr%exp_int < 0) then
        err = error_type(INVALID, "evaluate", &
          & "Negative integer exponent is unsupported.")
        return
      end if
      value = int(left**int(expr%exp_int, int16), int16)
    case (OP_INT32_POW)
      if (expr%exp_int < 0) then
        err = error_type(INVALID, "evaluate", &
          & "Negative integer exponent is unsupported.")
        return
      end if
      value = int(left**int(expr%exp_int, int32), int16)
    case (OP_INT64_POW)
      if (expr%exp_int < 0) then
        err = error_type(INVALID, "evaluate", &
          & "Negative integer exponent is unsupported.")
        return
      end if
      value = int(left**int(expr%exp_int, int64), int16)
    case default
      err = error_type(INVALID, "evaluate", &
        & "Unknown expression operation.")
    end select
  case default
    err = error_type(INVALID, "evaluate", &
      & "Unknown expression operation.")
  end select
end function eval_int16

recursive function eval_int32(expr, i, err) result(value)
  type(expression_type), intent(in) :: expr
  integer(int64), intent(in) :: i
  type(error_type), intent(out) :: err
  integer(int32) :: value, left, right
  integer(int32), pointer :: values(:)

  err = error_type()
  value = 0_int32
  select case (expr%operation)
  case (OP_LEAF)
    call extract(expr%leaf, values)
    value = values(i)
  case (OP_SCALAR_INT32)
    value = int(expr%exp_int, int32)
  case (OP_ADD, OP_SUB, OP_MUL, OP_DIV, OP_POW)
    left = eval_int32(expr%left, i, err)
    if (.exists. err) return
    right = eval_int32(expr%right, i, err)
    if (.exists. err) return
    select case (expr%operation)
    case (OP_ADD)
      value = left + right
    case (OP_SUB)
      value = left - right
    case (OP_MUL)
      value = left*right
    case (OP_DIV)
      if (right == 0_int32) then
        err = error_type(INVALID, "evaluate", "Division by zero.")
        return
      end if
      value = left/right
    case (OP_POW)
      if (right < 0) then
        err = error_type(INVALID, "evaluate", &
          & "Negative integer exponent is unsupported.")
        return
      end if
      value = left**right
    case default
      err = error_type(INVALID, "evaluate", &
        & "Unknown expression operation.")
    end select
  case (OP_INT8_POW, OP_INT16_POW, OP_INT32_POW, OP_INT64_POW)
    left = eval_int32(expr%left, i, err)
    if (.exists. err) return
    select case (expr%operation)
    case (OP_INT8_POW)
      if (expr%exp_int < 0) then
        err = error_type(INVALID, "evaluate", &
          & "Negative integer exponent is unsupported.")
        return
      end if
      value = int(left**int(expr%exp_int, int8), int32)
    case (OP_INT16_POW)
      if (expr%exp_int < 0) then
        err = error_type(INVALID, "evaluate", &
          & "Negative integer exponent is unsupported.")
        return
      end if
      value = int(left**int(expr%exp_int, int16), int32)
    case (OP_INT32_POW)
      if (expr%exp_int < 0) then
        err = error_type(INVALID, "evaluate", &
          & "Negative integer exponent is unsupported.")
        return
      end if
      value = int(left**int(expr%exp_int, int32), int32)
    case (OP_INT64_POW)
      if (expr%exp_int < 0) then
        err = error_type(INVALID, "evaluate", &
          & "Negative integer exponent is unsupported.")
        return
      end if
      value = int(left**int(expr%exp_int, int64), int32)
    case default
      err = error_type(INVALID, "evaluate", &
        & "Unknown expression operation.")
    end select
  case default
    err = error_type(INVALID, "evaluate", &
      & "Unknown expression operation.")
  end select
end function eval_int32

recursive function eval_int64(expr, i, err) result(value)
  type(expression_type), intent(in) :: expr
  integer(int64), intent(in) :: i
  type(error_type), intent(out) :: err
  integer(int64) :: value, left, right
  integer(int64), pointer :: values(:)

  err = error_type()
  value = 0_int64
  select case (expr%operation)
  case (OP_LEAF)
    call extract(expr%leaf, values)
    value = values(i)
  case (OP_SCALAR_INT64)
    value = int(expr%exp_int, int64)
  case (OP_ADD, OP_SUB, OP_MUL, OP_DIV, OP_POW)
    left = eval_int64(expr%left, i, err)
    if (.exists. err) return
    right = eval_int64(expr%right, i, err)
    if (.exists. err) return
    select case (expr%operation)
    case (OP_ADD)
      value = left + right
    case (OP_SUB)
      value = left - right
    case (OP_MUL)
      value = left*right
    case (OP_DIV)
      if (right == 0_int64) then
        err = error_type(INVALID, "evaluate", "Division by zero.")
        return
      end if
      value = left/right
    case (OP_POW)
      if (right < 0) then
        err = error_type(INVALID, "evaluate", &
          & "Negative integer exponent is unsupported.")
        return
      end if
      value = left**right
    case default
      err = error_type(INVALID, "evaluate", &
        & "Unknown expression operation.")
    end select
  case (OP_INT8_POW, OP_INT16_POW, OP_INT32_POW, OP_INT64_POW)
    left = eval_int64(expr%left, i, err)
    if (.exists. err) return
    select case (expr%operation)
    case (OP_INT8_POW)
      if (expr%exp_int < 0) then
        err = error_type(INVALID, "evaluate", &
          & "Negative integer exponent is unsupported.")
        return
      end if
      value = int(left**int(expr%exp_int, int8), int64)
    case (OP_INT16_POW)
      if (expr%exp_int < 0) then
        err = error_type(INVALID, "evaluate", &
          & "Negative integer exponent is unsupported.")
        return
      end if
      value = int(left**int(expr%exp_int, int16), int64)
    case (OP_INT32_POW)
      if (expr%exp_int < 0) then
        err = error_type(INVALID, "evaluate", &
          & "Negative integer exponent is unsupported.")
        return
      end if
      value = int(left**int(expr%exp_int, int32), int64)
    case (OP_INT64_POW)
      if (expr%exp_int < 0) then
        err = error_type(INVALID, "evaluate", &
          & "Negative integer exponent is unsupported.")
        return
      end if
      value = int(left**int(expr%exp_int, int64), int64)
    case default
      err = error_type(INVALID, "evaluate", &
        & "Unknown expression operation.")
    end select
  case default
    err = error_type(INVALID, "evaluate", &
      & "Unknown expression operation.")
  end select
end function eval_int64

recursive function eval_real32(expr, i, err) result(value)
  type(expression_type), intent(in) :: expr
  integer(int64), intent(in) :: i
  type(error_type), intent(out) :: err
  real(real32) :: value, left, right
  real(real32), pointer :: values(:)

  err = error_type()
  value = 0.0_real32
  select case (expr%operation)
  case (OP_LEAF)
    select case (expr%leaf%dtype)
    case (BYTE_TYPE)
      block
        integer(int8), pointer :: source(:)
        call extract(expr%leaf, source)
        value = real(source(i), real32)
      end block
    case (SHORT_TYPE)
      block
        integer(int16), pointer :: source(:)
        call extract(expr%leaf, source)
        value = real(source(i), real32)
      end block
    case (INT_TYPE)
      block
        integer(int32), pointer :: source(:)
        call extract(expr%leaf, source)
        value = real(source(i), real32)
      end block
    case (INT64_TYPE)
      block
        integer(int64), pointer :: source(:)
        call extract(expr%leaf, source)
        value = real(source(i), real32)
      end block
    case (FLOAT_TYPE)
      call extract(expr%leaf, values)
      value = values(i)
    case default
      err = error_type(INVALID, "evaluate", "Unsupported operand type.")
    end select
  case (OP_SCALAR_INT8, OP_SCALAR_INT16, OP_SCALAR_INT32, &
    & OP_SCALAR_INT64)
    value = real(expr%exp_int, real32)
  case (OP_SCALAR_REAL32, OP_SCALAR_REAL64)
    value = real(expr%exp_real, real32)
  case (OP_ADD, OP_SUB, OP_MUL, OP_DIV, OP_POW)
    left = eval_real32(expr%left, i, err)
    if (.exists. err) return
    right = eval_real32(expr%right, i, err)
    if (.exists. err) return
    select case (expr%operation)
    case (OP_ADD)
      value = left + right
    case (OP_SUB)
      value = left - right
    case (OP_MUL)
      value = left*right
    case (OP_DIV)
      if (abs(right) <= 0.0_real32) then
        err = error_type(INVALID, "evaluate", "Division by zero.")
        return
      end if
      value = left/right
    case (OP_POW)
      if (abs(left) <= 0.0_real32 .and. right < 0.0_real32) then
        err = error_type(INVALID, "evaluate", &
          & "Zero cannot have a negative exponent.")
        return
      end if
      if (left < 0.0_real32) then
        err = error_type(INVALID, "evaluate", &
          & "Negative base requires an integer exponent.")
        return
      end if
      value = left**right
    case default
      err = error_type(INVALID, "evaluate", &
        & "Unknown expression operation.")
    end select
  case (OP_INT8_POW, OP_INT16_POW, OP_INT32_POW, OP_INT64_POW)
    left = eval_real32(expr%left, i, err)
    if (.exists. err) return
    select case (expr%operation)
    case (OP_INT8_POW)
      if (abs(left) <= 0.0_real32 .and. &
        & expr%exp_int < 0) then
        err = error_type(INVALID, "evaluate", &
          & "Zero cannot have a negative exponent.")
        return
      end if
      value = left**int(expr%exp_int, int8)
    case (OP_INT16_POW)
      if (abs(left) <= 0.0_real32 .and. &
        & expr%exp_int < 0) then
        err = error_type(INVALID, "evaluate", &
          & "Zero cannot have a negative exponent.")
        return
      end if
      value = left**int(expr%exp_int, int16)
    case (OP_INT32_POW)
      if (abs(left) <= 0.0_real32 .and. &
        & expr%exp_int < 0) then
        err = error_type(INVALID, "evaluate", &
          & "Zero cannot have a negative exponent.")
        return
      end if
      value = left**int(expr%exp_int, int32)
    case (OP_INT64_POW)
      if (abs(left) <= 0.0_real32 .and. &
        & expr%exp_int < 0) then
        err = error_type(INVALID, "evaluate", &
          & "Zero cannot have a negative exponent.")
        return
      end if
      value = left**int(expr%exp_int, int64)
    case default
      err = error_type(INVALID, "evaluate", &
        & "Unknown expression operation.")
    end select
  case (OP_REAL32_POW, OP_REAL64_POW)
    left = eval_real32(expr%left, i, err)
    if (.exists. err) return
    select case (expr%operation)
    case (OP_REAL32_POW)
      right = real(expr%exp_real, real32)
    case (OP_REAL64_POW)
      right = real(expr%exp_real, real32)
    case default
      err = error_type(INVALID, "evaluate", &
        & "Unknown expression operation.")
      return
    end select
    if (abs(left) <= 0.0_real32 .and. right < 0.0_real32) then
      err = error_type(INVALID, "evaluate", &
        & "Zero cannot have a negative exponent.")
      return
    end if
    if (left < 0.0_real32) then
      err = error_type(INVALID, "evaluate", &
        & "Negative base requires an integer exponent.")
      return
    end if
    value = left**right
  case default
    err = error_type(INVALID, "evaluate", &
      & "Unknown expression operation.")
  end select
end function eval_real32

recursive function eval_real64(expr, i, err) result(value)
  type(expression_type), intent(in) :: expr
  integer(int64), intent(in) :: i
  type(error_type), intent(out) :: err
  real(real64) :: value, left, right
  real(real64), pointer :: values(:)

  err = error_type()
  value = 0.0_real64
  select case (expr%operation)
  case (OP_LEAF)
    select case (expr%leaf%dtype)
    case (BYTE_TYPE)
      block
        integer(int8), pointer :: source(:)
        call extract(expr%leaf, source)
        value = real(source(i), real64)
      end block
    case (SHORT_TYPE)
      block
        integer(int16), pointer :: source(:)
        call extract(expr%leaf, source)
        value = real(source(i), real64)
      end block
    case (INT_TYPE)
      block
        integer(int32), pointer :: source(:)
        call extract(expr%leaf, source)
        value = real(source(i), real64)
      end block
    case (INT64_TYPE)
      block
        integer(int64), pointer :: source(:)
        call extract(expr%leaf, source)
        value = real(source(i), real64)
      end block
    case (FLOAT_TYPE)
      block
        real(real32), pointer :: source(:)
        call extract(expr%leaf, source)
        value = real(source(i), real64)
      end block
    case (DOUBLE_TYPE)
      call extract(expr%leaf, values)
      value = values(i)
    case default
      err = error_type(INVALID, "evaluate", "Unsupported operand type.")
    end select
  case (OP_SCALAR_INT8, OP_SCALAR_INT16, OP_SCALAR_INT32, &
    & OP_SCALAR_INT64)
    value = real(expr%exp_int, real64)
  case (OP_SCALAR_REAL32, OP_SCALAR_REAL64)
    value = real(expr%exp_real, real64)
  case (OP_ADD, OP_SUB, OP_MUL, OP_DIV, OP_POW)
    left = eval_real64(expr%left, i, err)
    if (.exists. err) return
    right = eval_real64(expr%right, i, err)
    if (.exists. err) return
    select case (expr%operation)
    case (OP_ADD)
      value = left + right
    case (OP_SUB)
      value = left - right
    case (OP_MUL)
      value = left*right
    case (OP_DIV)
      if (abs(right) <= 0.0_real64) then
        err = error_type(INVALID, "evaluate", "Division by zero.")
        return
      end if
      value = left/right
    case (OP_POW)
      if (abs(left) <= 0.0_real64 .and. right < 0.0_real64) then
        err = error_type(INVALID, "evaluate", &
          & "Zero cannot have a negative exponent.")
        return
      end if
      if (left < 0.0_real64) then
        err = error_type(INVALID, "evaluate", &
          & "Negative base requires an integer exponent.")
        return
      end if
      value = left**right
    case default
      err = error_type(INVALID, "evaluate", &
        & "Unknown expression operation.")
    end select
  case (OP_INT8_POW, OP_INT16_POW, OP_INT32_POW, OP_INT64_POW)
    left = eval_real64(expr%left, i, err)
    if (.exists. err) return
    select case (expr%operation)
    case (OP_INT8_POW)
      if (abs(left) <= 0.0_real64 .and. &
        & expr%exp_int < 0) then
        err = error_type(INVALID, "evaluate", &
          & "Zero cannot have a negative exponent.")
        return
      end if
      value = left**int(expr%exp_int, int8)
    case (OP_INT16_POW)
      if (abs(left) <= 0.0_real64 .and. &
        & expr%exp_int < 0) then
        err = error_type(INVALID, "evaluate", &
          & "Zero cannot have a negative exponent.")
        return
      end if
      value = left**int(expr%exp_int, int16)
    case (OP_INT32_POW)
      if (abs(left) <= 0.0_real64 .and. &
        & expr%exp_int < 0) then
        err = error_type(INVALID, "evaluate", &
          & "Zero cannot have a negative exponent.")
        return
      end if
      value = left**int(expr%exp_int, int32)
    case (OP_INT64_POW)
      if (abs(left) <= 0.0_real64 .and. &
        & expr%exp_int < 0) then
        err = error_type(INVALID, "evaluate", &
          & "Zero cannot have a negative exponent.")
        return
      end if
      value = left**int(expr%exp_int, int64)
    case default
      err = error_type(INVALID, "evaluate", &
        & "Unknown expression operation.")
    end select
  case (OP_REAL32_POW, OP_REAL64_POW)
    left = eval_real64(expr%left, i, err)
    if (.exists. err) return
    select case (expr%operation)
    case (OP_REAL32_POW)
      right = real(expr%exp_real, real64)
    case (OP_REAL64_POW)
      right = real(expr%exp_real, real64)
    case default
      err = error_type(INVALID, "evaluate", &
        & "Unknown expression operation.")
      return
    end select
    if (abs(left) <= 0.0_real64 .and. right < 0.0_real64) then
      err = error_type(INVALID, "evaluate", &
        & "Zero cannot have a negative exponent.")
      return
    end if
    if (left < 0.0_real64) then
      err = error_type(INVALID, "evaluate", &
        & "Negative base requires an integer exponent.")
      return
    end if
    value = left**right
  case default
    err = error_type(INVALID, "evaluate", &
      & "Unknown expression operation.")
  end select
end function eval_real64

end submodule nc4f_data_expression
