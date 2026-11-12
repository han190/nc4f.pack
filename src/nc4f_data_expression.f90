submodule(nc4f_data) nc4f_data_expression
!! Evaluate deferred element-wise arithmetic and unary intrinsic expressions.
!! Leaves borrow variables and read their values during evaluation; callers
!! retain operand and target storage lifetimes.
implicit none (type, external)
contains

module subroutine assign_expr(result, expr)
  !! Evaluate an expression as defined assignment to a variable.
  type(variable_type), target, intent(inout) :: result
  !! Destination variable, replaced by the evaluated values.
  type(expression_type), intent(in) :: expr
  !! Deferred expression to assign.

  call evaluate(expr, result)
end subroutine assign_expr

module subroutine evaluate(expr, result, err)
  !! Validate the tree, evaluate each element, and replace result on success.
  !! A failed evaluation leaves result unchanged and reports through err.
  type(expression_type), intent(in) :: expr
  !! Expression tree whose leaves are read during evaluation.
  type(variable_type), target, intent(inout) :: result
  !! Destination variable, replaced only after successful evaluation.
  type(error_type), intent(out), optional :: err
  !! Receives failure details; if omitted, failures terminate execution.
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

pure recursive subroutine validate_expr(expr, dtype, dims, n, err)
  !! Check operand storage, types, and ordered dimensions before evaluation.
  !! Scalar nodes inherit the dimensions of their array operand.
  type(expression_type), intent(in) :: expr
  !! Expression subtree to validate.
  integer(data_type), intent(out) :: dtype
  !! Data type inferred for the subtree result.
  type(dimension_type), allocatable, intent(out) :: dims(:)
  !! Ordered dimensions inferred for the subtree result.
  integer(int64), intent(out) :: n
  !! Element count; zero for a scalar node.
  type(error_type), intent(out) :: err
  !! Receives validation failure details or a no-error value.
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
  case (OP_ABS, OP_SQRT, OP_EXP, OP_LOG, OP_LOG10, OP_SIN, OP_COS, OP_TAN, &
    & OP_ASIN, OP_ACOS, OP_ATAN, OP_SINH, OP_COSH, OP_TANH, OP_ASINH, &
    & OP_ACOSH, OP_ATANH, OP_ERF, OP_ERFC, OP_ERFC_SCALED, OP_GAMMA, &
    & OP_LOG_GAMMA, OP_BESSEL_J0, OP_BESSEL_J1, OP_BESSEL_Y0, OP_BESSEL_Y1)
    if (.not. allocated(expr%left)) then
      err = error_type(INVALID, "evaluate", "Unary node is incomplete.")
      return
    end if
    call validate_expr(expr%left, dtype, dims, n, err)
    if (.exists. err) return
    if (expr%operation /= OP_ABS .and. &
      & dtype /= FLOAT_TYPE .and. dtype /= DOUBLE_TYPE) then
      err = error_type(INVALID, "evaluate", &
        & "Unary intrinsic requires real data.")
    end if
  case (OP_ADD, OP_SUB, OP_MUL, OP_DIV, OP_POW, &
    & OP_DIM, OP_SIGN, OP_MOD, OP_MODULO, OP_ATAN2, OP_HYPOT)
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
    if ((expr%operation == OP_ATAN2 .or. &
      & expr%operation == OP_HYPOT) .and. &
      & dtype /= FLOAT_TYPE .and. dtype /= DOUBLE_TYPE) then
      err = error_type(INVALID, "evaluate", &
        & "This intrinsic requires real data.")
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
  !! Identify a stored numeric scalar, which broadcasts over an array node.
  type(expression_type), intent(in) :: expr
  !! Node to inspect for a stored scalar operation.

  select case (expr%operation)
  case (OP_SCALAR_INT8, OP_SCALAR_INT16, OP_SCALAR_INT32, &
    & OP_SCALAR_INT64, OP_SCALAR_REAL32, OP_SCALAR_REAL64)
    is_scalar_node = .true.
  case default
    is_scalar_node = .false.
  end select
end function is_scalar_node

recursive function eval_int8(expr, i, err) result(value)
  !! Evaluate element i of an integer(int8) expression tree.
  type(expression_type), intent(in) :: expr
  !! Expression subtree to evaluate.
  integer(int64), intent(in) :: i
  !! One-based element index in each array leaf.
  type(error_type), intent(out) :: err
  !! Receives an evaluation or numeric-domain error.
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
  case (OP_ABS)
    left = eval_int8(expr%left, i, err)
    if (.exists. err) return
    if (left == -huge(left) - 1_int8) then
      err = error_type(INVALID, "evaluate", &
        & "Integer absolute value is not representable.")
      return
    end if
    value = abs(left)
  case (OP_ADD, OP_SUB, OP_MUL, OP_DIV, OP_POW, &
    & OP_DIM, OP_SIGN, OP_MOD, OP_MODULO, OP_ATAN2, OP_HYPOT)
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
    case (OP_DIM)
      value = dim(left, right)
    case (OP_SIGN)
      value = sign(left, right)
    case (OP_MOD)
      if (right == 0) then
        err = error_type(INVALID, "evaluate", "MOD divisor is zero.")
        return
      end if
      if (right == -1) then
        value = 0
      else
        value = mod(left, right)
      end if
    case (OP_MODULO)
      if (right == 0) then
        err = error_type(INVALID, "evaluate", "MODULO divisor is zero.")
        return
      end if
      if (right == -1) then
        value = 0
      else
        value = modulo(left, right)
      end if
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
  !! Evaluate element i of an integer(int16) expression tree.
  type(expression_type), intent(in) :: expr
  !! Expression subtree to evaluate.
  integer(int64), intent(in) :: i
  !! One-based element index in each array leaf.
  type(error_type), intent(out) :: err
  !! Receives an evaluation or numeric-domain error.
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
  case (OP_ABS)
    left = eval_int16(expr%left, i, err)
    if (.exists. err) return
    if (left == -huge(left) - 1_int16) then
      err = error_type(INVALID, "evaluate", &
        & "Integer absolute value is not representable.")
      return
    end if
    value = abs(left)
  case (OP_ADD, OP_SUB, OP_MUL, OP_DIV, OP_POW, &
    & OP_DIM, OP_SIGN, OP_MOD, OP_MODULO, OP_ATAN2, OP_HYPOT)
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
    case (OP_DIM)
      value = dim(left, right)
    case (OP_SIGN)
      value = sign(left, right)
    case (OP_MOD)
      if (right == 0) then
        err = error_type(INVALID, "evaluate", "MOD divisor is zero.")
        return
      end if
      if (right == -1) then
        value = 0
      else
        value = mod(left, right)
      end if
    case (OP_MODULO)
      if (right == 0) then
        err = error_type(INVALID, "evaluate", "MODULO divisor is zero.")
        return
      end if
      if (right == -1) then
        value = 0
      else
        value = modulo(left, right)
      end if
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
  !! Evaluate element i of an integer(int32) expression tree.
  type(expression_type), intent(in) :: expr
  !! Expression subtree to evaluate.
  integer(int64), intent(in) :: i
  !! One-based element index in each array leaf.
  type(error_type), intent(out) :: err
  !! Receives an evaluation or numeric-domain error.
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
  case (OP_ABS)
    left = eval_int32(expr%left, i, err)
    if (.exists. err) return
    if (left == -huge(left) - 1_int32) then
      err = error_type(INVALID, "evaluate", &
        & "Integer absolute value is not representable.")
      return
    end if
    value = abs(left)
  case (OP_ADD, OP_SUB, OP_MUL, OP_DIV, OP_POW, &
    & OP_DIM, OP_SIGN, OP_MOD, OP_MODULO, OP_ATAN2, OP_HYPOT)
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
    case (OP_DIM)
      value = dim(left, right)
    case (OP_SIGN)
      value = sign(left, right)
    case (OP_MOD)
      if (right == 0) then
        err = error_type(INVALID, "evaluate", "MOD divisor is zero.")
        return
      end if
      if (right == -1) then
        value = 0
      else
        value = mod(left, right)
      end if
    case (OP_MODULO)
      if (right == 0) then
        err = error_type(INVALID, "evaluate", "MODULO divisor is zero.")
        return
      end if
      if (right == -1) then
        value = 0
      else
        value = modulo(left, right)
      end if
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
  !! Evaluate element i of an integer(int64) expression tree.
  type(expression_type), intent(in) :: expr
  !! Expression subtree to evaluate.
  integer(int64), intent(in) :: i
  !! One-based element index in each array leaf.
  type(error_type), intent(out) :: err
  !! Receives an evaluation or numeric-domain error.
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
  case (OP_ABS)
    left = eval_int64(expr%left, i, err)
    if (.exists. err) return
    if (left == -huge(left) - 1_int64) then
      err = error_type(INVALID, "evaluate", &
        & "Integer absolute value is not representable.")
      return
    end if
    value = abs(left)
  case (OP_ADD, OP_SUB, OP_MUL, OP_DIV, OP_POW, &
    & OP_DIM, OP_SIGN, OP_MOD, OP_MODULO, OP_ATAN2, OP_HYPOT)
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
    case (OP_DIM)
      value = dim(left, right)
    case (OP_SIGN)
      value = sign(left, right)
    case (OP_MOD)
      if (right == 0) then
        err = error_type(INVALID, "evaluate", "MOD divisor is zero.")
        return
      end if
      if (right == -1) then
        value = 0
      else
        value = mod(left, right)
      end if
    case (OP_MODULO)
      if (right == 0) then
        err = error_type(INVALID, "evaluate", "MODULO divisor is zero.")
        return
      end if
      if (right == -1) then
        value = 0
      else
        value = modulo(left, right)
      end if
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
  !! Evaluate element i of a real(real32) expression tree.
  type(expression_type), intent(in) :: expr
  !! Expression subtree to evaluate.
  integer(int64), intent(in) :: i
  !! One-based element index in each array leaf.
  type(error_type), intent(out) :: err
  !! Receives an evaluation or numeric-domain error.
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
  case (OP_ABS, OP_SQRT, OP_EXP, OP_LOG, OP_LOG10, OP_SIN, OP_COS, OP_TAN, &
    & OP_ASIN, OP_ACOS, OP_ATAN, OP_SINH, OP_COSH, OP_TANH, OP_ASINH, &
    & OP_ACOSH, OP_ATANH, OP_ERF, OP_ERFC, OP_ERFC_SCALED, OP_GAMMA, &
    & OP_LOG_GAMMA, OP_BESSEL_J0, OP_BESSEL_J1, OP_BESSEL_Y0, OP_BESSEL_Y1)
    left = eval_real32(expr%left, i, err)
    if (.exists. err) return
    value = apply_unary_real32(expr%operation, left, err)
  case (OP_ADD, OP_SUB, OP_MUL, OP_DIV, OP_POW, &
    & OP_DIM, OP_SIGN, OP_MOD, OP_MODULO, OP_ATAN2, OP_HYPOT)
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
    case (OP_DIM)
      value = dim(left, right)
    case (OP_SIGN)
      value = sign(left, right)
    case (OP_MOD)
      if (right == 0.0) then
        err = error_type(INVALID, "evaluate", "MOD divisor is zero.")
        return
      end if
      value = mod(left, right)
    case (OP_MODULO)
      if (right == 0.0) then
        err = error_type(INVALID, "evaluate", "MODULO divisor is zero.")
        return
      end if
      value = modulo(left, right)
    case (OP_ATAN2)
      if (left == 0.0 .and. right == 0.0) then
        err = error_type(INVALID, "evaluate", &
          & "ATAN2 arguments cannot both be zero.")
        return
      end if
      value = atan2(left, right)
    case (OP_HYPOT)
      value = hypot(left, right)
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
  !! Evaluate element i of a real(real64) expression tree.
  type(expression_type), intent(in) :: expr
  !! Expression subtree to evaluate.
  integer(int64), intent(in) :: i
  !! One-based element index in each array leaf.
  type(error_type), intent(out) :: err
  !! Receives an evaluation or numeric-domain error.
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
  case (OP_ABS, OP_SQRT, OP_EXP, OP_LOG, OP_LOG10, OP_SIN, OP_COS, OP_TAN, &
    & OP_ASIN, OP_ACOS, OP_ATAN, OP_SINH, OP_COSH, OP_TANH, OP_ASINH, &
    & OP_ACOSH, OP_ATANH, OP_ERF, OP_ERFC, OP_ERFC_SCALED, OP_GAMMA, &
    & OP_LOG_GAMMA, OP_BESSEL_J0, OP_BESSEL_J1, OP_BESSEL_Y0, OP_BESSEL_Y1)
    left = eval_real64(expr%left, i, err)
    if (.exists. err) return
    value = apply_unary_real64(expr%operation, left, err)
  case (OP_ADD, OP_SUB, OP_MUL, OP_DIV, OP_POW, &
    & OP_DIM, OP_SIGN, OP_MOD, OP_MODULO, OP_ATAN2, OP_HYPOT)
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
    case (OP_DIM)
      value = dim(left, right)
    case (OP_SIGN)
      value = sign(left, right)
    case (OP_MOD)
      if (right == 0.0) then
        err = error_type(INVALID, "evaluate", "MOD divisor is zero.")
        return
      end if
      value = mod(left, right)
    case (OP_MODULO)
      if (right == 0.0) then
        err = error_type(INVALID, "evaluate", "MODULO divisor is zero.")
        return
      end if
      value = modulo(left, right)
    case (OP_ATAN2)
      if (left == 0.0 .and. right == 0.0) then
        err = error_type(INVALID, "evaluate", &
          & "ATAN2 arguments cannot both be zero.")
        return
      end if
      value = atan2(left, right)
    case (OP_HYPOT)
      value = hypot(left, right)
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

function apply_unary_real32(operation, x, err) result(value)
  !! Apply one real32 intrinsic and report invalid input domains through err.
  integer(operation_kind), intent(in) :: operation
  !! Intrinsic operation selected by the expression node.
  real(real32), intent(in) :: x
  !! Scalar value to transform.
  type(error_type), intent(out) :: err
  !! Receives an invalid-domain or unknown-operation error.
  real(real32) :: value

  err = error_type()
  value = 0.0_real32
  select case (operation)
  case (OP_ABS)
    value = abs(x)
  case (OP_SQRT)
    if (x < 0.0_real32) then
      err = error_type(INVALID, "evaluate", &
        & "Square root requires nonnegative data.")
      return
    end if
    value = sqrt(x)
  case (OP_EXP)
    value = exp(x)
  case (OP_LOG)
    if (x <= 0.0_real32) then
      err = error_type(INVALID, "evaluate", &
        & "Logarithm requires positive data.")
      return
    end if
    value = log(x)
  case (OP_LOG10)
    if (x <= 0.0_real32) then
      err = error_type(INVALID, "evaluate", &
        & "Logarithm requires positive data.")
      return
    end if
    value = log10(x)
  case (OP_SIN)
    value = sin(x)
  case (OP_COS)
    value = cos(x)
  case (OP_TAN)
    value = tan(x)
  case (OP_ASIN)
    if (abs(x) > 1.0_real32) then
      err = error_type(INVALID, "evaluate", &
        & "Inverse sine requires values in [-1, 1].")
      return
    end if
    value = asin(x)
  case (OP_ACOS)
    if (abs(x) > 1.0_real32) then
      err = error_type(INVALID, "evaluate", &
        & "Inverse cosine requires values in [-1, 1].")
      return
    end if
    value = acos(x)
  case (OP_ATAN)
    value = atan(x)
  case (OP_SINH)
    value = sinh(x)
  case (OP_COSH)
    value = cosh(x)
  case (OP_TANH)
    value = tanh(x)
  case (OP_ASINH)
    value = asinh(x)
  case (OP_ACOSH)
    if (x < 1.0_real32) then
      err = error_type(INVALID, "evaluate", &
        & "Inverse hyperbolic cosine requires x >= 1.")
      return
    end if
    value = acosh(x)
  case (OP_ATANH)
    if (abs(x) >= 1.0_real32) then
      err = error_type(INVALID, "evaluate", &
        & "Inverse hyperbolic tangent requires |x| < 1.")
      return
    end if
    value = atanh(x)
  case (OP_ERF)
    value = erf(x)
  case (OP_ERFC)
    value = erfc(x)
  case (OP_ERFC_SCALED)
    value = erfc_scaled(x)
  case (OP_GAMMA)
    if (x <= 0.0_real32 .and. x == aint(x)) then
      err = error_type(INVALID, "evaluate", &
        & "Gamma has a pole at this value.")
      return
    end if
    value = gamma(x)
  case (OP_LOG_GAMMA)
    if (x <= 0.0_real32 .and. x == aint(x)) then
      err = error_type(INVALID, "evaluate", &
        & "Log gamma has a pole at this value.")
      return
    end if
    value = log_gamma(x)
  case (OP_BESSEL_J0)
    ! Some macOS Flang runtimes lack the real32 Bessel symbols.
    value = real(bessel_j0(real(x, real64)), real32)
  case (OP_BESSEL_J1)
    value = real(bessel_j1(real(x, real64)), real32)
  case (OP_BESSEL_Y0)
    if (x <= 0.0_real32) then
      err = error_type(INVALID, "evaluate", &
        & "Bessel Y requires positive data.")
      return
    end if
    value = real(bessel_y0(real(x, real64)), real32)
  case (OP_BESSEL_Y1)
    if (x <= 0.0_real32) then
      err = error_type(INVALID, "evaluate", &
        & "Bessel Y requires positive data.")
      return
    end if
    value = real(bessel_y1(real(x, real64)), real32)
  case default
    err = error_type(INVALID, "evaluate", &
      & "Unknown unary intrinsic operation.")
  end select
end function apply_unary_real32

function apply_unary_real64(operation, x, err) result(value)
  !! Apply one real64 intrinsic and report invalid input domains through err.
  integer(operation_kind), intent(in) :: operation
  !! Intrinsic operation selected by the expression node.
  real(real64), intent(in) :: x
  !! Scalar value to transform.
  type(error_type), intent(out) :: err
  !! Receives an invalid-domain or unknown-operation error.
  real(real64) :: value

  err = error_type()
  value = 0.0_real64
  select case (operation)
  case (OP_ABS)
    value = abs(x)
  case (OP_SQRT)
    if (x < 0.0_real64) then
      err = error_type(INVALID, "evaluate", &
        & "Square root requires nonnegative data.")
      return
    end if
    value = sqrt(x)
  case (OP_EXP)
    value = exp(x)
  case (OP_LOG)
    if (x <= 0.0_real64) then
      err = error_type(INVALID, "evaluate", &
        & "Logarithm requires positive data.")
      return
    end if
    value = log(x)
  case (OP_LOG10)
    if (x <= 0.0_real64) then
      err = error_type(INVALID, "evaluate", &
        & "Logarithm requires positive data.")
      return
    end if
    value = log10(x)
  case (OP_SIN)
    value = sin(x)
  case (OP_COS)
    value = cos(x)
  case (OP_TAN)
    value = tan(x)
  case (OP_ASIN)
    if (abs(x) > 1.0_real64) then
      err = error_type(INVALID, "evaluate", &
        & "Inverse sine requires values in [-1, 1].")
      return
    end if
    value = asin(x)
  case (OP_ACOS)
    if (abs(x) > 1.0_real64) then
      err = error_type(INVALID, "evaluate", &
        & "Inverse cosine requires values in [-1, 1].")
      return
    end if
    value = acos(x)
  case (OP_ATAN)
    value = atan(x)
  case (OP_SINH)
    value = sinh(x)
  case (OP_COSH)
    value = cosh(x)
  case (OP_TANH)
    value = tanh(x)
  case (OP_ASINH)
    value = asinh(x)
  case (OP_ACOSH)
    if (x < 1.0_real64) then
      err = error_type(INVALID, "evaluate", &
        & "Inverse hyperbolic cosine requires x >= 1.")
      return
    end if
    value = acosh(x)
  case (OP_ATANH)
    if (abs(x) >= 1.0_real64) then
      err = error_type(INVALID, "evaluate", &
        & "Inverse hyperbolic tangent requires |x| < 1.")
      return
    end if
    value = atanh(x)
  case (OP_ERF)
    value = erf(x)
  case (OP_ERFC)
    value = erfc(x)
  case (OP_ERFC_SCALED)
    value = erfc_scaled(x)
  case (OP_GAMMA)
    if (x <= 0.0_real64 .and. x == aint(x)) then
      err = error_type(INVALID, "evaluate", &
        & "Gamma has a pole at this value.")
      return
    end if
    value = gamma(x)
  case (OP_LOG_GAMMA)
    if (x <= 0.0_real64 .and. x == aint(x)) then
      err = error_type(INVALID, "evaluate", &
        & "Log gamma has a pole at this value.")
      return
    end if
    value = log_gamma(x)
  case (OP_BESSEL_J0)
    value = bessel_j0(x)
  case (OP_BESSEL_J1)
    value = bessel_j1(x)
  case (OP_BESSEL_Y0)
    if (x <= 0.0_real64) then
      err = error_type(INVALID, "evaluate", &
        & "Bessel Y requires positive data.")
      return
    end if
    value = bessel_y0(x)
  case (OP_BESSEL_Y1)
    if (x <= 0.0_real64) then
      err = error_type(INVALID, "evaluate", &
        & "Bessel Y requires positive data.")
      return
    end if
    value = bessel_y1(x)
  case default
    err = error_type(INVALID, "evaluate", &
      & "Unknown unary intrinsic operation.")
  end select
end function apply_unary_real64

end submodule nc4f_data_expression
