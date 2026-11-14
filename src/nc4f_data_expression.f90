submodule(nc4f_data) nc4f_data_expression
!! Evaluate deferred arithmetic and mathematical intrinsic expressions.
!! Leaves borrow variables and read their values during evaluation; callers
!! retain operand and target storage lifetimes.
implicit none (type, external)

integer, parameter :: BLOCK_SIZE = 1024
!! Maximum elements per numerical block; the final block may be shorter.
integer, parameter :: MAX_BLOCK_LANES = 32
!! Maximum independent output ranges, each with its own reusable scratch bank.
!! Bounds scratch memory independently of array length; execution may be serial.

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
  !! Validate the expression, evaluate blocks, and commit the staged result.
  !! Structural failures leave result unchanged and report through err.
  !! Numerical domains and exceptions follow Fortran and runtime settings.
  type(expression_type), intent(in) :: expr
  !! Expression tree whose leaves are read during evaluation.
  type(variable_type), target, intent(inout) :: result
  !! Destination variable, replaced only after successful evaluation.
  type(error_type), intent(out), optional :: err
  !! Receives structural failures; when omitted, they terminate execution.
  type(error_type) :: op_err
  !! Structural validation status returned before numerical execution.
  type(dimension_type), allocatable :: dims(:)
  !! Owned copy of the inferred output dimensions in Fortran order.
  type(variable_type), target :: staged
  !! Owned output storage committed only after evaluation finishes.
  type(coordinate_type), allocatable :: coords(:)
  !! Compatible coordinate mappings to propagate to the staged result.
  integer(data_type) :: dtype
  !! Numeric type selected for the output and kind-specific kernel.
  integer(int64) :: n
  !! Total output element count, including zero for an empty array.
  integer :: nbytes
  !! Checked byte count used to allocate the staged output buffer.

  call validate_expr(expr, dtype, dims, n, op_err)
  if (.exists. op_err) then
    call return_err(op_err, err)
    return
  end if
  call infer_expr_coords(expr, coords, op_err)
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
  if (allocated(coords)) staged%coords = coords
  allocate (staged%buffer(nbytes))
  if (n > 0) then
    select case (dtype)
    case (BYTE_TYPE)
      block
        integer(int8), contiguous, pointer :: values(:)
        !! Flat typed view of the staged output, in Fortran array order.
        call extract(staged, values)
        call evaluate_int8(expr, values)
      end block
    case (SHORT_TYPE)
      block
        integer(int16), contiguous, pointer :: values(:)
        !! Flat typed view of the staged output, in Fortran array order.
        call extract(staged, values)
        call evaluate_int16(expr, values)
      end block
    case (INT_TYPE)
      block
        integer(int32), contiguous, pointer :: values(:)
        !! Flat typed view of the staged output, in Fortran array order.
        call extract(staged, values)
        call evaluate_int32(expr, values)
      end block
    case (INT64_TYPE)
      block
        integer(int64), contiguous, pointer :: values(:)
        !! Flat typed view of the staged output, in Fortran array order.
        call extract(staged, values)
        call evaluate_int64(expr, values)
      end block
    case (FLOAT_TYPE)
      block
        real(real32), contiguous, pointer :: values(:)
        !! Flat typed view of the staged output, in Fortran array order.
        call extract(staged, values)
        call evaluate_real32(expr, values)
      end block
    case (DOUBLE_TYPE)
      block
        real(real64), contiguous, pointer :: values(:)
        !! Flat typed view of the staged output, in Fortran array order.
        call extract(staged, values)
        call evaluate_real64(expr, values)
      end block
    case default
      op_err = error_type(INVALID, "evaluate", &
        & "Unsupported operand type.")
      call return_err(op_err, err)
      return
    end select
  end if
  result%id = INVALID_INT32
  result%name = staged%name
  result%dtype = staged%dtype
  result%len = staged%len
  result%dims = staged%dims
  if (allocated(result%coords)) deallocate (result%coords)
  if (allocated(staged%coords)) result%coords = staged%coords
  if (allocated(result%atts)) deallocate (result%atts)
  if (allocated(result%storage)) deallocate (result%storage)
  nullify (result%ptr)
  call move_alloc(staged%buffer, result%buffer)
  call return_err(op_err, err)
end subroutine evaluate

recursive subroutine infer_expr_coords(expr, coords, err)
  !! Infer and compare coordinate mappings without evaluating data values.
  type(expression_type), intent(in) :: expr
  !! Deferred expression whose leaves supply coordinate collections.
  type(coordinate_type), allocatable, intent(out) :: coords(:)
  !! Ordered coordinates propagated to the evaluated result.
  type(error_type), intent(out) :: err
  !! Validation result for coordinate compatibility.
  type(coordinate_type), allocatable :: right_coords(:)
  !! Coordinate mappings inferred from the right subtree for comparison.
  integer :: i
  !! Position in the ordered coordinate collection.

  err = error_type()
  select case (expr%operation)
  case (OP_LEAF)
    if (associated(expr%coords)) coords = expr%coords
  case (OP_SCALAR_INT8, OP_SCALAR_INT16, OP_SCALAR_INT32, &
    & OP_SCALAR_INT64, OP_SCALAR_REAL32, OP_SCALAR_REAL64)
    return
  case default
    if (.not. allocated(expr%left)) return
    call infer_expr_coords(expr%left, coords, err)
    if (.exists. err) return
    if (.not. allocated(expr%right)) return
    call infer_expr_coords(expr%right, right_coords, err)
    if (.exists. err) return
    if (is_scalar_node(expr%left)) then
      if (allocated(right_coords)) coords = right_coords
      return
    end if
    if (is_scalar_node(expr%right)) return
    if (allocated(coords) .neqv. allocated(right_coords)) then
      err = error_type(INVALID, "evaluate", &
        & "Only one operand has coordinates.")
      return
    end if
    if (.not. allocated(coords)) return
    if (size(coords) /= size(right_coords)) then
      err = error_type(INVALID, "evaluate", &
        & "Operand coordinate counts differ.")
      return
    end if
    do i = 1, size(coords)
      call validate_coordinate_pair(coords(i), right_coords(i), err)
      if (.exists. err) return
    end do
  end select
end subroutine infer_expr_coords

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
  !! Right-subtree dimensions used to check binary operand compatibility.
  integer(data_type) :: right_type
  !! Numeric type inferred for the right subtree.
  integer(int64) :: right_len
  !! Element count inferred for the right subtree.

  err = error_type()
  dtype = NAT_TYPE
  n = 0
  select case (expr%operation)
  case (OP_LEAF)
    if (.exists. expr%leaf_error) then
      err = expr%leaf_error
      return
    end if
    if (.not. associated(expr%dims)) then
      err = error_type(INVALID, "evaluate", "Expression dimensions are absent.")
      return
    end if
    dtype = expr%dtype
    n = expr%len
    select case (dtype)
    case (BYTE_TYPE)
      if (n > 0) then
        if (.not. associated(expr%values_int8)) then
          err = error_type(INVALID, "evaluate", "Operand storage is absent.")
          return
        end if
        if (size(expr%values_int8, kind=int64) /= n) then
          err = error_type(INVALID, "evaluate", "Operand length differs.")
          return
        end if
      end if
    case (SHORT_TYPE)
      if (n > 0) then
        if (.not. associated(expr%values_int16)) then
          err = error_type(INVALID, "evaluate", "Operand storage is absent.")
          return
        end if
        if (size(expr%values_int16, kind=int64) /= n) then
          err = error_type(INVALID, "evaluate", "Operand length differs.")
          return
        end if
      end if
    case (INT_TYPE)
      if (n > 0) then
        if (.not. associated(expr%values_int32)) then
          err = error_type(INVALID, "evaluate", "Operand storage is absent.")
          return
        end if
        if (size(expr%values_int32, kind=int64) /= n) then
          err = error_type(INVALID, "evaluate", "Operand length differs.")
          return
        end if
      end if
    case (INT64_TYPE)
      if (n > 0) then
        if (.not. associated(expr%values_int64)) then
          err = error_type(INVALID, "evaluate", "Operand storage is absent.")
          return
        end if
        if (size(expr%values_int64, kind=int64) /= n) then
          err = error_type(INVALID, "evaluate", "Operand length differs.")
          return
        end if
      end if
    case (FLOAT_TYPE)
      if (n > 0) then
        if (.not. associated(expr%values_real32)) then
          err = error_type(INVALID, "evaluate", "Operand storage is absent.")
          return
        end if
        if (size(expr%values_real32, kind=int64) /= n) then
          err = error_type(INVALID, "evaluate", "Operand length differs.")
          return
        end if
      end if
    case (DOUBLE_TYPE)
      if (n > 0) then
        if (.not. associated(expr%values_real64)) then
          err = error_type(INVALID, "evaluate", "Operand storage is absent.")
          return
        end if
        if (size(expr%values_real64, kind=int64) /= n) then
          err = error_type(INVALID, "evaluate", "Operand length differs.")
          return
        end if
      end if
    case default
      err = error_type(INVALID, "evaluate", "Unsupported operand type.")
      return
    end select
    dims = expr%dims
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
  !! Return true for a stored numeric scalar that broadcasts over an array.
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

module subroutine init_expr_leaf(var, expr)
  !! Validate and bind views while the operand is available; never copy data.
  !! Invalid leaves retain a diagnostic returned later by evaluate.
  type(variable_type), target, intent(in) :: var
  !! Source operand; its data and metadata allocations must remain valid.
  type(expression_type), intent(out) :: expr
  !! New borrowed leaf, including any structural binding error for evaluate.

  expr%operation = OP_LEAF
  expr%dtype = var%dtype
  expr%len = var%len
  call validate(var, context="evaluate", err=expr%leaf_error)
  if (.exists. expr%leaf_error) return
  expr%dims => var%dims
  if (allocated(var%coords)) expr%coords => var%coords
  if (var%len == 0) return
  select case (var%dtype)
  case (BYTE_TYPE)
    call extract(var, expr%values_int8)
  case (SHORT_TYPE)
    call extract(var, expr%values_int16)
  case (INT_TYPE)
    call extract(var, expr%values_int32)
  case (INT64_TYPE)
    call extract(var, expr%values_int64)
  case (FLOAT_TYPE)
    call extract(var, expr%values_real32)
  case (DOUBLE_TYPE)
    call extract(var, expr%values_real64)
  end select
end subroutine init_expr_leaf

pure logical function is_direct_operand(expr) result(direct)
  !! Return true for leaves and scalars readable without subtree evaluation.
  type(expression_type), intent(in) :: expr
  !! Operand node to classify; numerical values are not inspected.
  direct = expr%operation == OP_LEAF .or. is_scalar_node(expr)
end function is_direct_operand

pure module subroutine init_expr_workspace(expr)
  !! Cache scratch needs for evaluating the more demanding branch first.
  !! Operand order is preserved; direct leaves and scalars need no work block.
  type(expression_type), intent(inout) :: expr
  !! Node with populated children; only its scratch_count is updated.
  integer :: left, right
  !! Scratch requirements of the left and right child subtrees.

  expr%scratch_count = 0
  if (.not. allocated(expr%left)) return
  expr%scratch_count = expr%left%scratch_count
  if (.not. allocated(expr%right)) return
  if (is_direct_operand(expr%right)) return
  if (is_direct_operand(expr%left)) then
    expr%scratch_count = expr%right%scratch_count
    return
  end if
  left = expr%left%scratch_count
  right = expr%right%scratch_count
  expr%scratch_count = max(left, right)
  if (left == right) expr%scratch_count = left + 1
end subroutine init_expr_workspace

pure subroutine evaluate_int8(expr, values)
  !! Concurrent lanes own disjoint output ranges and reusable scratch banks.
  type(expression_type), intent(in) :: expr
  !! Validated expression with bound leaves and a cached scratch requirement.
  integer(int8), contiguous, intent(out) :: values(:)
  !! Flat output partitioned into disjoint lanes; must not alias leaf storage.
  integer(int8), allocatable :: scratch(:,:,:)
  !! Work banks indexed by block element, live intermediate, and lane.
  integer(int64) :: n, blocks, lanes, lane
  !! Output size, block count, lane count, and current logical lane index.

  n = size(values, kind=int64)
  blocks = (n + BLOCK_SIZE - 1)/BLOCK_SIZE
  lanes = min(blocks, int(MAX_BLOCK_LANES, int64))
  allocate (scratch(min(n, int(BLOCK_SIZE, int64)), expr%scratch_count, lanes))
  do concurrent (lane=1:lanes)
    block
      integer(int64) :: first, last
      !! Inclusive one-based output bounds owned by this logical lane.
      first = ((lane - 1)*blocks/lanes)*BLOCK_SIZE + 1
      last = min(n, (lane*blocks/lanes)*BLOCK_SIZE)
      call evaluate_lane_int8(expr, first, values(first:last), scratch(:,:,lane))
    end block
  end do
end subroutine evaluate_int8

pure subroutine evaluate_lane_int8(expr, first, values, scratch)
  !! Scratch is allocated once by the caller, then reused for every block.
  type(expression_type), intent(in) :: expr
  !! Validated expression shared read-only by all logical lanes.
  integer(int64), intent(in) :: first
  !! One-based index in each leaf corresponding to values(1).
  integer(int8), contiguous, intent(out) :: values(:)
  !! This lane's disjoint contiguous segment of the complete output array.
  integer(int8), contiguous, intent(inout) :: scratch(:,:)
  !! Lane-private work bank; columns are reused as intermediates expire.
  integer(int64) :: offset, last
  !! Inclusive block bounds within this lane's local output segment.

  do offset = 1, size(values, kind=int64), BLOCK_SIZE
    last = min(size(values, kind=int64), offset + BLOCK_SIZE - 1)
    call eval_block_int8(expr, first + offset - 1, values(offset:last), scratch)
  end do
end subroutine evaluate_lane_int8

pure recursive subroutine eval_block_int8(node, first, values, scratch)
  !! Dispatch once per block; inner loops contain only typed numerical work.
  type(expression_type), intent(in) :: node
  !! Validated subtree to evaluate for the current block.
  integer(int64), intent(in) :: first
  !! One-based starting element in the original flat leaf arrays.
  integer(int8), contiguous, intent(out) :: values(:)
  !! Destination block, reused for child results; must not alias leaf storage.
  integer(int8), contiguous, intent(inout) :: scratch(:,:)
  !! Work columns beyond values; requires at least node%scratch_count columns.
  !! Active scratch sections and values must not overlap.
  integer :: n, i
  !! Block length and element index for scalar-exponent loops.

  n = size(values)
  select case (node%operation)
  case (OP_LEAF)
    values = node%values_int8(first:first+n-1)
  case (OP_SCALAR_INT8)
    values = int(node%exp_int, int8)
  case (OP_ABS)
    call eval_block_int8(node%left, first, values, scratch)
    values = abs(values)
  case (OP_ADD, OP_SUB, OP_MUL, OP_DIV, OP_POW, &
    & OP_DIM, OP_SIGN, OP_MOD, OP_MODULO, OP_ATAN2, OP_HYPOT)
    if (is_direct_operand(node%right)) then
      call eval_block_int8(node%left, first, values, scratch)
      call apply_operand_int8(node%operation, node%right, first, values, .false.)
    else if (is_direct_operand(node%left)) then
      call eval_block_int8(node%right, first, values, scratch)
      call apply_operand_int8(node%operation, node%left, first, values, .true.)
    else if (node%left%scratch_count >= node%right%scratch_count) then
      call eval_block_int8(node%left, first, values, scratch)
      call eval_block_int8(node%right, first, scratch(:n,1), scratch(:,2:))
      call apply_array_int8_int8(node%operation, scratch(:n,1), values, .false.)
    else
      call eval_block_int8(node%right, first, values, scratch)
      call eval_block_int8(node%left, first, scratch(:n,1), scratch(:,2:))
      call apply_array_int8_int8(node%operation, scratch(:n,1), values, .true.)
    end if
  case (OP_INT8_POW, OP_INT16_POW, OP_INT32_POW, OP_INT64_POW)
    call eval_block_int8(node%left, first, values, scratch)
    select case (node%operation)
    case (OP_INT8_POW)
    do i = 1, n
      values(i) = int(values(i)**int(node%exp_int, int8), int8)
    end do
    case (OP_INT16_POW)
    do i = 1, n
      values(i) = int(values(i)**int(node%exp_int, int16), int8)
    end do
    case (OP_INT32_POW)
    do i = 1, n
      values(i) = int(values(i)**int(node%exp_int, int32), int8)
    end do
    case (OP_INT64_POW)
    do i = 1, n
      values(i) = int(values(i)**int(node%exp_int, int64), int8)
    end do
    end select
  end select
end subroutine eval_block_int8

pure subroutine apply_operand_int8(operation, operand, first, values, reverse)
  !! Combine a direct leaf or scalar with an already evaluated int8 block.
  integer(operation_kind), intent(in) :: operation
  !! Validated binary arithmetic or intrinsic operation code.
  type(expression_type), intent(in) :: operand
  !! Bound leaf or stored scalar; its storage must not overlap values.
  integer(int64), intent(in) :: first
  !! One-based leaf offset; ignored when operand is a broadcast scalar.
  integer(int8), contiguous, intent(inout) :: values(:)
  !! Existing child result replaced in place by the binary operation result.
  logical, intent(in) :: reverse
  !! True places operand on the left; false places it on the right.
  integer :: n
  !! Number of elements read from a direct array operand.

  n = size(values)
  select case (operand%operation)
  case (OP_LEAF)
    select case (operand%dtype)
    case (BYTE_TYPE)
      call apply_array_int8_int8(operation, &
        & operand%values_int8(first:first+n-1), values, reverse)
    end select
  case (OP_SCALAR_INT8)
    call apply_scalar_int8(operation, int(operand%exp_int, int8), values, reverse)
  end select
end subroutine apply_operand_int8

pure subroutine apply_array_int8_int8(operation, other, values, reverse)
  !! Combine a int8 array with a int8 block in place.
  !! Source elements are converted to the destination type when needed.
  integer(operation_kind), intent(in) :: operation
  !! Validated binary operation, dispatched before the concurrent loop.
  integer(int8), contiguous, intent(in) :: other(:)
  !! Read-only source block; must match values in size and not overlap it.
  integer(int8), contiguous, intent(inout) :: values(:)
  !! Input block replaced by the result; each iteration owns one element.
  logical, intent(in) :: reverse
  !! True uses other as the left operand; false uses it as the right operand.
  integer :: i
  !! Independent element index local to each concurrent iteration.

  select case (operation)
  case (OP_ADD)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other(i) + values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) + other(i)
      end do
    end if
  case (OP_SUB)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other(i) - values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) - other(i)
      end do
    end if
  case (OP_MUL)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other(i) * values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) * other(i)
      end do
    end if
  case (OP_DIV)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other(i) / values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) / other(i)
      end do
    end if
  case (OP_POW)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other(i) ** values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) ** other(i)
      end do
    end if
  case (OP_DIM)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = dim(other(i), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = dim(values(i), other(i))
      end do
    end if
  case (OP_SIGN)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = sign(other(i), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = sign(values(i), other(i))
      end do
    end if
  case (OP_MOD)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = mod(other(i), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = mod(values(i), other(i))
      end do
    end if
  case (OP_MODULO)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = modulo(other(i), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = modulo(values(i), other(i))
      end do
    end if
  end select
end subroutine apply_array_int8_int8

pure subroutine apply_scalar_int8(operation, other, values, reverse)
  !! Apply a broadcast int8 scalar to a int8 destination block in place.
  integer(operation_kind), intent(in) :: operation
  !! Validated binary operation, dispatched before the concurrent loop.
  integer(int8), intent(in) :: other
  !! Read-only scalar broadcast to every destination element.
  integer(int8), contiguous, intent(inout) :: values(:)
  !! Input block replaced by the result; each iteration owns one element.
  logical, intent(in) :: reverse
  !! True uses other as the left operand; false uses it as the right operand.
  integer :: i
  !! Independent element index local to each concurrent iteration.

  select case (operation)
  case (OP_ADD)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other + values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) + other
      end do
    end if
  case (OP_SUB)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other - values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) - other
      end do
    end if
  case (OP_MUL)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other * values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) * other
      end do
    end if
  case (OP_DIV)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other / values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) / other
      end do
    end if
  case (OP_POW)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other ** values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) ** other
      end do
    end if
  case (OP_DIM)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = dim(other, values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = dim(values(i), other)
      end do
    end if
  case (OP_SIGN)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = sign(other, values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = sign(values(i), other)
      end do
    end if
  case (OP_MOD)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = mod(other, values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = mod(values(i), other)
      end do
    end if
  case (OP_MODULO)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = modulo(other, values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = modulo(values(i), other)
      end do
    end if
  end select
end subroutine apply_scalar_int8

pure subroutine evaluate_int16(expr, values)
  !! Concurrent lanes own disjoint output ranges and reusable scratch banks.
  type(expression_type), intent(in) :: expr
  !! Validated expression with bound leaves and a cached scratch requirement.
  integer(int16), contiguous, intent(out) :: values(:)
  !! Flat output partitioned into disjoint lanes; must not alias leaf storage.
  integer(int16), allocatable :: scratch(:,:,:)
  !! Work banks indexed by block element, live intermediate, and lane.
  integer(int64) :: n, blocks, lanes, lane
  !! Output size, block count, lane count, and current logical lane index.

  n = size(values, kind=int64)
  blocks = (n + BLOCK_SIZE - 1)/BLOCK_SIZE
  lanes = min(blocks, int(MAX_BLOCK_LANES, int64))
  allocate (scratch(min(n, int(BLOCK_SIZE, int64)), expr%scratch_count, lanes))
  do concurrent (lane=1:lanes)
    block
      integer(int64) :: first, last
      !! Inclusive one-based output bounds owned by this logical lane.
      first = ((lane - 1)*blocks/lanes)*BLOCK_SIZE + 1
      last = min(n, (lane*blocks/lanes)*BLOCK_SIZE)
      call evaluate_lane_int16(expr, first, values(first:last), scratch(:,:,lane))
    end block
  end do
end subroutine evaluate_int16

pure subroutine evaluate_lane_int16(expr, first, values, scratch)
  !! Scratch is allocated once by the caller, then reused for every block.
  type(expression_type), intent(in) :: expr
  !! Validated expression shared read-only by all logical lanes.
  integer(int64), intent(in) :: first
  !! One-based index in each leaf corresponding to values(1).
  integer(int16), contiguous, intent(out) :: values(:)
  !! This lane's disjoint contiguous segment of the complete output array.
  integer(int16), contiguous, intent(inout) :: scratch(:,:)
  !! Lane-private work bank; columns are reused as intermediates expire.
  integer(int64) :: offset, last
  !! Inclusive block bounds within this lane's local output segment.

  do offset = 1, size(values, kind=int64), BLOCK_SIZE
    last = min(size(values, kind=int64), offset + BLOCK_SIZE - 1)
    call eval_block_int16(expr, first + offset - 1, values(offset:last), scratch)
  end do
end subroutine evaluate_lane_int16

pure recursive subroutine eval_block_int16(node, first, values, scratch)
  !! Dispatch once per block; inner loops contain only typed numerical work.
  type(expression_type), intent(in) :: node
  !! Validated subtree to evaluate for the current block.
  integer(int64), intent(in) :: first
  !! One-based starting element in the original flat leaf arrays.
  integer(int16), contiguous, intent(out) :: values(:)
  !! Destination block, reused for child results; must not alias leaf storage.
  integer(int16), contiguous, intent(inout) :: scratch(:,:)
  !! Work columns beyond values; requires at least node%scratch_count columns.
  !! Active scratch sections and values must not overlap.
  integer :: n, i
  !! Block length and element index for scalar-exponent loops.

  n = size(values)
  select case (node%operation)
  case (OP_LEAF)
    values = node%values_int16(first:first+n-1)
  case (OP_SCALAR_INT16)
    values = int(node%exp_int, int16)
  case (OP_ABS)
    call eval_block_int16(node%left, first, values, scratch)
    values = abs(values)
  case (OP_ADD, OP_SUB, OP_MUL, OP_DIV, OP_POW, &
    & OP_DIM, OP_SIGN, OP_MOD, OP_MODULO, OP_ATAN2, OP_HYPOT)
    if (is_direct_operand(node%right)) then
      call eval_block_int16(node%left, first, values, scratch)
      call apply_operand_int16(node%operation, node%right, first, values, .false.)
    else if (is_direct_operand(node%left)) then
      call eval_block_int16(node%right, first, values, scratch)
      call apply_operand_int16(node%operation, node%left, first, values, .true.)
    else if (node%left%scratch_count >= node%right%scratch_count) then
      call eval_block_int16(node%left, first, values, scratch)
      call eval_block_int16(node%right, first, scratch(:n,1), scratch(:,2:))
      call apply_array_int16_int16(node%operation, scratch(:n,1), values, .false.)
    else
      call eval_block_int16(node%right, first, values, scratch)
      call eval_block_int16(node%left, first, scratch(:n,1), scratch(:,2:))
      call apply_array_int16_int16(node%operation, scratch(:n,1), values, .true.)
    end if
  case (OP_INT8_POW, OP_INT16_POW, OP_INT32_POW, OP_INT64_POW)
    call eval_block_int16(node%left, first, values, scratch)
    select case (node%operation)
    case (OP_INT8_POW)
    do i = 1, n
      values(i) = int(values(i)**int(node%exp_int, int8), int16)
    end do
    case (OP_INT16_POW)
    do i = 1, n
      values(i) = int(values(i)**int(node%exp_int, int16), int16)
    end do
    case (OP_INT32_POW)
    do i = 1, n
      values(i) = int(values(i)**int(node%exp_int, int32), int16)
    end do
    case (OP_INT64_POW)
    do i = 1, n
      values(i) = int(values(i)**int(node%exp_int, int64), int16)
    end do
    end select
  end select
end subroutine eval_block_int16

pure subroutine apply_operand_int16(operation, operand, first, values, reverse)
  !! Combine a direct leaf or scalar with an already evaluated int16 block.
  integer(operation_kind), intent(in) :: operation
  !! Validated binary arithmetic or intrinsic operation code.
  type(expression_type), intent(in) :: operand
  !! Bound leaf or stored scalar; its storage must not overlap values.
  integer(int64), intent(in) :: first
  !! One-based leaf offset; ignored when operand is a broadcast scalar.
  integer(int16), contiguous, intent(inout) :: values(:)
  !! Existing child result replaced in place by the binary operation result.
  logical, intent(in) :: reverse
  !! True places operand on the left; false places it on the right.
  integer :: n
  !! Number of elements read from a direct array operand.

  n = size(values)
  select case (operand%operation)
  case (OP_LEAF)
    select case (operand%dtype)
    case (SHORT_TYPE)
      call apply_array_int16_int16(operation, &
        & operand%values_int16(first:first+n-1), values, reverse)
    end select
  case (OP_SCALAR_INT16)
    call apply_scalar_int16(operation, int(operand%exp_int, int16), values, reverse)
  end select
end subroutine apply_operand_int16

pure subroutine apply_array_int16_int16(operation, other, values, reverse)
  !! Combine a int16 array with a int16 block in place.
  !! Source elements are converted to the destination type when needed.
  integer(operation_kind), intent(in) :: operation
  !! Validated binary operation, dispatched before the concurrent loop.
  integer(int16), contiguous, intent(in) :: other(:)
  !! Read-only source block; must match values in size and not overlap it.
  integer(int16), contiguous, intent(inout) :: values(:)
  !! Input block replaced by the result; each iteration owns one element.
  logical, intent(in) :: reverse
  !! True uses other as the left operand; false uses it as the right operand.
  integer :: i
  !! Independent element index local to each concurrent iteration.

  select case (operation)
  case (OP_ADD)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other(i) + values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) + other(i)
      end do
    end if
  case (OP_SUB)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other(i) - values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) - other(i)
      end do
    end if
  case (OP_MUL)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other(i) * values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) * other(i)
      end do
    end if
  case (OP_DIV)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other(i) / values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) / other(i)
      end do
    end if
  case (OP_POW)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other(i) ** values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) ** other(i)
      end do
    end if
  case (OP_DIM)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = dim(other(i), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = dim(values(i), other(i))
      end do
    end if
  case (OP_SIGN)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = sign(other(i), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = sign(values(i), other(i))
      end do
    end if
  case (OP_MOD)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = mod(other(i), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = mod(values(i), other(i))
      end do
    end if
  case (OP_MODULO)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = modulo(other(i), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = modulo(values(i), other(i))
      end do
    end if
  end select
end subroutine apply_array_int16_int16

pure subroutine apply_scalar_int16(operation, other, values, reverse)
  !! Apply a broadcast int16 scalar to a int16 destination block in place.
  integer(operation_kind), intent(in) :: operation
  !! Validated binary operation, dispatched before the concurrent loop.
  integer(int16), intent(in) :: other
  !! Read-only scalar broadcast to every destination element.
  integer(int16), contiguous, intent(inout) :: values(:)
  !! Input block replaced by the result; each iteration owns one element.
  logical, intent(in) :: reverse
  !! True uses other as the left operand; false uses it as the right operand.
  integer :: i
  !! Independent element index local to each concurrent iteration.

  select case (operation)
  case (OP_ADD)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other + values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) + other
      end do
    end if
  case (OP_SUB)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other - values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) - other
      end do
    end if
  case (OP_MUL)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other * values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) * other
      end do
    end if
  case (OP_DIV)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other / values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) / other
      end do
    end if
  case (OP_POW)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other ** values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) ** other
      end do
    end if
  case (OP_DIM)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = dim(other, values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = dim(values(i), other)
      end do
    end if
  case (OP_SIGN)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = sign(other, values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = sign(values(i), other)
      end do
    end if
  case (OP_MOD)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = mod(other, values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = mod(values(i), other)
      end do
    end if
  case (OP_MODULO)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = modulo(other, values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = modulo(values(i), other)
      end do
    end if
  end select
end subroutine apply_scalar_int16

pure subroutine evaluate_int32(expr, values)
  !! Concurrent lanes own disjoint output ranges and reusable scratch banks.
  type(expression_type), intent(in) :: expr
  !! Validated expression with bound leaves and a cached scratch requirement.
  integer(int32), contiguous, intent(out) :: values(:)
  !! Flat output partitioned into disjoint lanes; must not alias leaf storage.
  integer(int32), allocatable :: scratch(:,:,:)
  !! Work banks indexed by block element, live intermediate, and lane.
  integer(int64) :: n, blocks, lanes, lane
  !! Output size, block count, lane count, and current logical lane index.

  n = size(values, kind=int64)
  blocks = (n + BLOCK_SIZE - 1)/BLOCK_SIZE
  lanes = min(blocks, int(MAX_BLOCK_LANES, int64))
  allocate (scratch(min(n, int(BLOCK_SIZE, int64)), expr%scratch_count, lanes))
  do concurrent (lane=1:lanes)
    block
      integer(int64) :: first, last
      !! Inclusive one-based output bounds owned by this logical lane.
      first = ((lane - 1)*blocks/lanes)*BLOCK_SIZE + 1
      last = min(n, (lane*blocks/lanes)*BLOCK_SIZE)
      call evaluate_lane_int32(expr, first, values(first:last), scratch(:,:,lane))
    end block
  end do
end subroutine evaluate_int32

pure subroutine evaluate_lane_int32(expr, first, values, scratch)
  !! Scratch is allocated once by the caller, then reused for every block.
  type(expression_type), intent(in) :: expr
  !! Validated expression shared read-only by all logical lanes.
  integer(int64), intent(in) :: first
  !! One-based index in each leaf corresponding to values(1).
  integer(int32), contiguous, intent(out) :: values(:)
  !! This lane's disjoint contiguous segment of the complete output array.
  integer(int32), contiguous, intent(inout) :: scratch(:,:)
  !! Lane-private work bank; columns are reused as intermediates expire.
  integer(int64) :: offset, last
  !! Inclusive block bounds within this lane's local output segment.

  do offset = 1, size(values, kind=int64), BLOCK_SIZE
    last = min(size(values, kind=int64), offset + BLOCK_SIZE - 1)
    call eval_block_int32(expr, first + offset - 1, values(offset:last), scratch)
  end do
end subroutine evaluate_lane_int32

pure recursive subroutine eval_block_int32(node, first, values, scratch)
  !! Dispatch once per block; inner loops contain only typed numerical work.
  type(expression_type), intent(in) :: node
  !! Validated subtree to evaluate for the current block.
  integer(int64), intent(in) :: first
  !! One-based starting element in the original flat leaf arrays.
  integer(int32), contiguous, intent(out) :: values(:)
  !! Destination block, reused for child results; must not alias leaf storage.
  integer(int32), contiguous, intent(inout) :: scratch(:,:)
  !! Work columns beyond values; requires at least node%scratch_count columns.
  !! Active scratch sections and values must not overlap.
  integer :: n, i
  !! Block length and element index for scalar-exponent loops.

  n = size(values)
  select case (node%operation)
  case (OP_LEAF)
    values = node%values_int32(first:first+n-1)
  case (OP_SCALAR_INT32)
    values = int(node%exp_int, int32)
  case (OP_ABS)
    call eval_block_int32(node%left, first, values, scratch)
    values = abs(values)
  case (OP_ADD, OP_SUB, OP_MUL, OP_DIV, OP_POW, &
    & OP_DIM, OP_SIGN, OP_MOD, OP_MODULO, OP_ATAN2, OP_HYPOT)
    if (is_direct_operand(node%right)) then
      call eval_block_int32(node%left, first, values, scratch)
      call apply_operand_int32(node%operation, node%right, first, values, .false.)
    else if (is_direct_operand(node%left)) then
      call eval_block_int32(node%right, first, values, scratch)
      call apply_operand_int32(node%operation, node%left, first, values, .true.)
    else if (node%left%scratch_count >= node%right%scratch_count) then
      call eval_block_int32(node%left, first, values, scratch)
      call eval_block_int32(node%right, first, scratch(:n,1), scratch(:,2:))
      call apply_array_int32_int32(node%operation, scratch(:n,1), values, .false.)
    else
      call eval_block_int32(node%right, first, values, scratch)
      call eval_block_int32(node%left, first, scratch(:n,1), scratch(:,2:))
      call apply_array_int32_int32(node%operation, scratch(:n,1), values, .true.)
    end if
  case (OP_INT8_POW, OP_INT16_POW, OP_INT32_POW, OP_INT64_POW)
    call eval_block_int32(node%left, first, values, scratch)
    select case (node%operation)
    case (OP_INT8_POW)
    do i = 1, n
      values(i) = int(values(i)**int(node%exp_int, int8), int32)
    end do
    case (OP_INT16_POW)
    do i = 1, n
      values(i) = int(values(i)**int(node%exp_int, int16), int32)
    end do
    case (OP_INT32_POW)
    do i = 1, n
      values(i) = int(values(i)**int(node%exp_int, int32), int32)
    end do
    case (OP_INT64_POW)
    do i = 1, n
      values(i) = int(values(i)**int(node%exp_int, int64), int32)
    end do
    end select
  end select
end subroutine eval_block_int32

pure subroutine apply_operand_int32(operation, operand, first, values, reverse)
  !! Combine a direct leaf or scalar with an already evaluated int32 block.
  integer(operation_kind), intent(in) :: operation
  !! Validated binary arithmetic or intrinsic operation code.
  type(expression_type), intent(in) :: operand
  !! Bound leaf or stored scalar; its storage must not overlap values.
  integer(int64), intent(in) :: first
  !! One-based leaf offset; ignored when operand is a broadcast scalar.
  integer(int32), contiguous, intent(inout) :: values(:)
  !! Existing child result replaced in place by the binary operation result.
  logical, intent(in) :: reverse
  !! True places operand on the left; false places it on the right.
  integer :: n
  !! Number of elements read from a direct array operand.

  n = size(values)
  select case (operand%operation)
  case (OP_LEAF)
    select case (operand%dtype)
    case (INT_TYPE)
      call apply_array_int32_int32(operation, &
        & operand%values_int32(first:first+n-1), values, reverse)
    end select
  case (OP_SCALAR_INT32)
    call apply_scalar_int32(operation, int(operand%exp_int, int32), values, reverse)
  end select
end subroutine apply_operand_int32

pure subroutine apply_array_int32_int32(operation, other, values, reverse)
  !! Combine a int32 array with a int32 block in place.
  !! Source elements are converted to the destination type when needed.
  integer(operation_kind), intent(in) :: operation
  !! Validated binary operation, dispatched before the concurrent loop.
  integer(int32), contiguous, intent(in) :: other(:)
  !! Read-only source block; must match values in size and not overlap it.
  integer(int32), contiguous, intent(inout) :: values(:)
  !! Input block replaced by the result; each iteration owns one element.
  logical, intent(in) :: reverse
  !! True uses other as the left operand; false uses it as the right operand.
  integer :: i
  !! Independent element index local to each concurrent iteration.

  select case (operation)
  case (OP_ADD)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other(i) + values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) + other(i)
      end do
    end if
  case (OP_SUB)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other(i) - values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) - other(i)
      end do
    end if
  case (OP_MUL)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other(i) * values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) * other(i)
      end do
    end if
  case (OP_DIV)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other(i) / values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) / other(i)
      end do
    end if
  case (OP_POW)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other(i) ** values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) ** other(i)
      end do
    end if
  case (OP_DIM)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = dim(other(i), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = dim(values(i), other(i))
      end do
    end if
  case (OP_SIGN)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = sign(other(i), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = sign(values(i), other(i))
      end do
    end if
  case (OP_MOD)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = mod(other(i), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = mod(values(i), other(i))
      end do
    end if
  case (OP_MODULO)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = modulo(other(i), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = modulo(values(i), other(i))
      end do
    end if
  end select
end subroutine apply_array_int32_int32

pure subroutine apply_scalar_int32(operation, other, values, reverse)
  !! Apply a broadcast int32 scalar to a int32 destination block in place.
  integer(operation_kind), intent(in) :: operation
  !! Validated binary operation, dispatched before the concurrent loop.
  integer(int32), intent(in) :: other
  !! Read-only scalar broadcast to every destination element.
  integer(int32), contiguous, intent(inout) :: values(:)
  !! Input block replaced by the result; each iteration owns one element.
  logical, intent(in) :: reverse
  !! True uses other as the left operand; false uses it as the right operand.
  integer :: i
  !! Independent element index local to each concurrent iteration.

  select case (operation)
  case (OP_ADD)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other + values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) + other
      end do
    end if
  case (OP_SUB)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other - values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) - other
      end do
    end if
  case (OP_MUL)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other * values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) * other
      end do
    end if
  case (OP_DIV)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other / values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) / other
      end do
    end if
  case (OP_POW)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other ** values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) ** other
      end do
    end if
  case (OP_DIM)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = dim(other, values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = dim(values(i), other)
      end do
    end if
  case (OP_SIGN)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = sign(other, values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = sign(values(i), other)
      end do
    end if
  case (OP_MOD)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = mod(other, values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = mod(values(i), other)
      end do
    end if
  case (OP_MODULO)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = modulo(other, values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = modulo(values(i), other)
      end do
    end if
  end select
end subroutine apply_scalar_int32

pure subroutine evaluate_int64(expr, values)
  !! Concurrent lanes own disjoint output ranges and reusable scratch banks.
  type(expression_type), intent(in) :: expr
  !! Validated expression with bound leaves and a cached scratch requirement.
  integer(int64), contiguous, intent(out) :: values(:)
  !! Flat output partitioned into disjoint lanes; must not alias leaf storage.
  integer(int64), allocatable :: scratch(:,:,:)
  !! Work banks indexed by block element, live intermediate, and lane.
  integer(int64) :: n, blocks, lanes, lane
  !! Output size, block count, lane count, and current logical lane index.

  n = size(values, kind=int64)
  blocks = (n + BLOCK_SIZE - 1)/BLOCK_SIZE
  lanes = min(blocks, int(MAX_BLOCK_LANES, int64))
  allocate (scratch(min(n, int(BLOCK_SIZE, int64)), expr%scratch_count, lanes))
  do concurrent (lane=1:lanes)
    block
      integer(int64) :: first, last
      !! Inclusive one-based output bounds owned by this logical lane.
      first = ((lane - 1)*blocks/lanes)*BLOCK_SIZE + 1
      last = min(n, (lane*blocks/lanes)*BLOCK_SIZE)
      call evaluate_lane_int64(expr, first, values(first:last), scratch(:,:,lane))
    end block
  end do
end subroutine evaluate_int64

pure subroutine evaluate_lane_int64(expr, first, values, scratch)
  !! Scratch is allocated once by the caller, then reused for every block.
  type(expression_type), intent(in) :: expr
  !! Validated expression shared read-only by all logical lanes.
  integer(int64), intent(in) :: first
  !! One-based index in each leaf corresponding to values(1).
  integer(int64), contiguous, intent(out) :: values(:)
  !! This lane's disjoint contiguous segment of the complete output array.
  integer(int64), contiguous, intent(inout) :: scratch(:,:)
  !! Lane-private work bank; columns are reused as intermediates expire.
  integer(int64) :: offset, last
  !! Inclusive block bounds within this lane's local output segment.

  do offset = 1, size(values, kind=int64), BLOCK_SIZE
    last = min(size(values, kind=int64), offset + BLOCK_SIZE - 1)
    call eval_block_int64(expr, first + offset - 1, values(offset:last), scratch)
  end do
end subroutine evaluate_lane_int64

pure recursive subroutine eval_block_int64(node, first, values, scratch)
  !! Dispatch once per block; inner loops contain only typed numerical work.
  type(expression_type), intent(in) :: node
  !! Validated subtree to evaluate for the current block.
  integer(int64), intent(in) :: first
  !! One-based starting element in the original flat leaf arrays.
  integer(int64), contiguous, intent(out) :: values(:)
  !! Destination block, reused for child results; must not alias leaf storage.
  integer(int64), contiguous, intent(inout) :: scratch(:,:)
  !! Work columns beyond values; requires at least node%scratch_count columns.
  !! Active scratch sections and values must not overlap.
  integer :: n, i
  !! Block length and element index for scalar-exponent loops.

  n = size(values)
  select case (node%operation)
  case (OP_LEAF)
    values = node%values_int64(first:first+n-1)
  case (OP_SCALAR_INT64)
    values = int(node%exp_int, int64)
  case (OP_ABS)
    call eval_block_int64(node%left, first, values, scratch)
    values = abs(values)
  case (OP_ADD, OP_SUB, OP_MUL, OP_DIV, OP_POW, &
    & OP_DIM, OP_SIGN, OP_MOD, OP_MODULO, OP_ATAN2, OP_HYPOT)
    if (is_direct_operand(node%right)) then
      call eval_block_int64(node%left, first, values, scratch)
      call apply_operand_int64(node%operation, node%right, first, values, .false.)
    else if (is_direct_operand(node%left)) then
      call eval_block_int64(node%right, first, values, scratch)
      call apply_operand_int64(node%operation, node%left, first, values, .true.)
    else if (node%left%scratch_count >= node%right%scratch_count) then
      call eval_block_int64(node%left, first, values, scratch)
      call eval_block_int64(node%right, first, scratch(:n,1), scratch(:,2:))
      call apply_array_int64_int64(node%operation, scratch(:n,1), values, .false.)
    else
      call eval_block_int64(node%right, first, values, scratch)
      call eval_block_int64(node%left, first, scratch(:n,1), scratch(:,2:))
      call apply_array_int64_int64(node%operation, scratch(:n,1), values, .true.)
    end if
  case (OP_INT8_POW, OP_INT16_POW, OP_INT32_POW, OP_INT64_POW)
    call eval_block_int64(node%left, first, values, scratch)
    select case (node%operation)
    case (OP_INT8_POW)
    do i = 1, n
      values(i) = int(values(i)**int(node%exp_int, int8), int64)
    end do
    case (OP_INT16_POW)
    do i = 1, n
      values(i) = int(values(i)**int(node%exp_int, int16), int64)
    end do
    case (OP_INT32_POW)
    do i = 1, n
      values(i) = int(values(i)**int(node%exp_int, int32), int64)
    end do
    case (OP_INT64_POW)
    do i = 1, n
      values(i) = int(values(i)**int(node%exp_int, int64), int64)
    end do
    end select
  end select
end subroutine eval_block_int64

pure subroutine apply_operand_int64(operation, operand, first, values, reverse)
  !! Combine a direct leaf or scalar with an already evaluated int64 block.
  integer(operation_kind), intent(in) :: operation
  !! Validated binary arithmetic or intrinsic operation code.
  type(expression_type), intent(in) :: operand
  !! Bound leaf or stored scalar; its storage must not overlap values.
  integer(int64), intent(in) :: first
  !! One-based leaf offset; ignored when operand is a broadcast scalar.
  integer(int64), contiguous, intent(inout) :: values(:)
  !! Existing child result replaced in place by the binary operation result.
  logical, intent(in) :: reverse
  !! True places operand on the left; false places it on the right.
  integer :: n
  !! Number of elements read from a direct array operand.

  n = size(values)
  select case (operand%operation)
  case (OP_LEAF)
    select case (operand%dtype)
    case (INT64_TYPE)
      call apply_array_int64_int64(operation, &
        & operand%values_int64(first:first+n-1), values, reverse)
    end select
  case (OP_SCALAR_INT64)
    call apply_scalar_int64(operation, int(operand%exp_int, int64), values, reverse)
  end select
end subroutine apply_operand_int64

pure subroutine apply_array_int64_int64(operation, other, values, reverse)
  !! Combine a int64 array with a int64 block in place.
  !! Source elements are converted to the destination type when needed.
  integer(operation_kind), intent(in) :: operation
  !! Validated binary operation, dispatched before the concurrent loop.
  integer(int64), contiguous, intent(in) :: other(:)
  !! Read-only source block; must match values in size and not overlap it.
  integer(int64), contiguous, intent(inout) :: values(:)
  !! Input block replaced by the result; each iteration owns one element.
  logical, intent(in) :: reverse
  !! True uses other as the left operand; false uses it as the right operand.
  integer :: i
  !! Independent element index local to each concurrent iteration.

  select case (operation)
  case (OP_ADD)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other(i) + values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) + other(i)
      end do
    end if
  case (OP_SUB)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other(i) - values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) - other(i)
      end do
    end if
  case (OP_MUL)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other(i) * values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) * other(i)
      end do
    end if
  case (OP_DIV)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other(i) / values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) / other(i)
      end do
    end if
  case (OP_POW)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other(i) ** values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) ** other(i)
      end do
    end if
  case (OP_DIM)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = dim(other(i), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = dim(values(i), other(i))
      end do
    end if
  case (OP_SIGN)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = sign(other(i), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = sign(values(i), other(i))
      end do
    end if
  case (OP_MOD)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = mod(other(i), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = mod(values(i), other(i))
      end do
    end if
  case (OP_MODULO)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = modulo(other(i), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = modulo(values(i), other(i))
      end do
    end if
  end select
end subroutine apply_array_int64_int64

pure subroutine apply_scalar_int64(operation, other, values, reverse)
  !! Apply a broadcast int64 scalar to a int64 destination block in place.
  integer(operation_kind), intent(in) :: operation
  !! Validated binary operation, dispatched before the concurrent loop.
  integer(int64), intent(in) :: other
  !! Read-only scalar broadcast to every destination element.
  integer(int64), contiguous, intent(inout) :: values(:)
  !! Input block replaced by the result; each iteration owns one element.
  logical, intent(in) :: reverse
  !! True uses other as the left operand; false uses it as the right operand.
  integer :: i
  !! Independent element index local to each concurrent iteration.

  select case (operation)
  case (OP_ADD)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other + values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) + other
      end do
    end if
  case (OP_SUB)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other - values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) - other
      end do
    end if
  case (OP_MUL)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other * values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) * other
      end do
    end if
  case (OP_DIV)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other / values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) / other
      end do
    end if
  case (OP_POW)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other ** values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) ** other
      end do
    end if
  case (OP_DIM)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = dim(other, values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = dim(values(i), other)
      end do
    end if
  case (OP_SIGN)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = sign(other, values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = sign(values(i), other)
      end do
    end if
  case (OP_MOD)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = mod(other, values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = mod(values(i), other)
      end do
    end if
  case (OP_MODULO)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = modulo(other, values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = modulo(values(i), other)
      end do
    end if
  end select
end subroutine apply_scalar_int64

pure subroutine evaluate_real32(expr, values)
  !! Concurrent lanes own disjoint output ranges and reusable scratch banks.
  type(expression_type), intent(in) :: expr
  !! Validated expression with bound leaves and a cached scratch requirement.
  real(real32), contiguous, intent(out) :: values(:)
  !! Flat output partitioned into disjoint lanes; must not alias leaf storage.
  real(real32), allocatable :: scratch(:,:,:)
  !! Work banks indexed by block element, live intermediate, and lane.
  integer(int64) :: n, blocks, lanes, lane
  !! Output size, block count, lane count, and current logical lane index.

  n = size(values, kind=int64)
  blocks = (n + BLOCK_SIZE - 1)/BLOCK_SIZE
  lanes = min(blocks, int(MAX_BLOCK_LANES, int64))
  allocate (scratch(min(n, int(BLOCK_SIZE, int64)), expr%scratch_count, lanes))
  do concurrent (lane=1:lanes)
    block
      integer(int64) :: first, last
      !! Inclusive one-based output bounds owned by this logical lane.
      first = ((lane - 1)*blocks/lanes)*BLOCK_SIZE + 1
      last = min(n, (lane*blocks/lanes)*BLOCK_SIZE)
      call evaluate_lane_real32(expr, first, values(first:last), scratch(:,:,lane))
    end block
  end do
end subroutine evaluate_real32

pure subroutine evaluate_lane_real32(expr, first, values, scratch)
  !! Scratch is allocated once by the caller, then reused for every block.
  type(expression_type), intent(in) :: expr
  !! Validated expression shared read-only by all logical lanes.
  integer(int64), intent(in) :: first
  !! One-based index in each leaf corresponding to values(1).
  real(real32), contiguous, intent(out) :: values(:)
  !! This lane's disjoint contiguous segment of the complete output array.
  real(real32), contiguous, intent(inout) :: scratch(:,:)
  !! Lane-private work bank; columns are reused as intermediates expire.
  integer(int64) :: offset, last
  !! Inclusive block bounds within this lane's local output segment.

  do offset = 1, size(values, kind=int64), BLOCK_SIZE
    last = min(size(values, kind=int64), offset + BLOCK_SIZE - 1)
    call eval_block_real32(expr, first + offset - 1, values(offset:last), scratch)
  end do
end subroutine evaluate_lane_real32

pure recursive subroutine eval_block_real32(node, first, values, scratch)
  !! Dispatch once per block; inner loops contain only typed numerical work.
  type(expression_type), intent(in) :: node
  !! Validated subtree to evaluate for the current block.
  integer(int64), intent(in) :: first
  !! One-based starting element in the original flat leaf arrays.
  real(real32), contiguous, intent(out) :: values(:)
  !! Destination block, reused for child results; must not alias leaf storage.
  real(real32), contiguous, intent(inout) :: scratch(:,:)
  !! Work columns beyond values; requires at least node%scratch_count columns.
  !! Active scratch sections and values must not overlap.
  integer :: n, i
  !! Block length and element index for scalar-exponent loops.

  n = size(values)
  select case (node%operation)
  case (OP_LEAF)
    select case (node%dtype)
    case (BYTE_TYPE)
      values = real(node%values_int8(first:first+n-1), real32)
    case (SHORT_TYPE)
      values = real(node%values_int16(first:first+n-1), real32)
    case (INT_TYPE)
      values = real(node%values_int32(first:first+n-1), real32)
    case (INT64_TYPE)
      values = real(node%values_int64(first:first+n-1), real32)
    case (FLOAT_TYPE)
      values = real(node%values_real32(first:first+n-1), real32)
    end select
  case (OP_SCALAR_INT8, OP_SCALAR_INT16, OP_SCALAR_INT32, OP_SCALAR_INT64)
    values = real(node%exp_int, real32)
  case (OP_SCALAR_REAL32, OP_SCALAR_REAL64)
    values = real(node%exp_real, real32)
  case (OP_ABS, OP_SQRT, OP_EXP, OP_LOG, OP_LOG10, OP_SIN, OP_COS, OP_TAN, &
    & OP_ASIN, OP_ACOS, OP_ATAN, OP_SINH, OP_COSH, OP_TANH, OP_ASINH, &
    & OP_ACOSH, OP_ATANH, OP_ERF, OP_ERFC, OP_ERFC_SCALED, OP_GAMMA, &
    & OP_LOG_GAMMA, OP_BESSEL_J0, OP_BESSEL_J1, OP_BESSEL_Y0, OP_BESSEL_Y1)
    call eval_block_real32(node%left, first, values, scratch)
    call apply_unary_real32(node%operation, values)
  case (OP_ADD, OP_SUB, OP_MUL, OP_DIV, OP_POW, &
    & OP_DIM, OP_SIGN, OP_MOD, OP_MODULO, OP_ATAN2, OP_HYPOT)
    if (is_direct_operand(node%right)) then
      call eval_block_real32(node%left, first, values, scratch)
      call apply_operand_real32(node%operation, node%right, first, values, .false.)
    else if (is_direct_operand(node%left)) then
      call eval_block_real32(node%right, first, values, scratch)
      call apply_operand_real32(node%operation, node%left, first, values, .true.)
    else if (node%left%scratch_count >= node%right%scratch_count) then
      call eval_block_real32(node%left, first, values, scratch)
      call eval_block_real32(node%right, first, scratch(:n,1), scratch(:,2:))
      call apply_array_real32_real32(node%operation, scratch(:n,1), values, .false.)
    else
      call eval_block_real32(node%right, first, values, scratch)
      call eval_block_real32(node%left, first, scratch(:n,1), scratch(:,2:))
      call apply_array_real32_real32(node%operation, scratch(:n,1), values, .true.)
    end if
  case (OP_INT8_POW, OP_INT16_POW, OP_INT32_POW, OP_INT64_POW)
    call eval_block_real32(node%left, first, values, scratch)
    select case (node%operation)
    case (OP_INT8_POW)
    do i = 1, n
      values(i) = values(i)**int(node%exp_int, int8)
    end do
    case (OP_INT16_POW)
    do i = 1, n
      values(i) = values(i)**int(node%exp_int, int16)
    end do
    case (OP_INT32_POW)
    do i = 1, n
      values(i) = values(i)**int(node%exp_int, int32)
    end do
    case (OP_INT64_POW)
    do i = 1, n
      values(i) = values(i)**int(node%exp_int, int64)
    end do
    end select
  case (OP_REAL32_POW, OP_REAL64_POW)
    call eval_block_real32(node%left, first, values, scratch)
    values = values**real(node%exp_real, real32)
  end select
end subroutine eval_block_real32

pure subroutine apply_operand_real32(operation, operand, first, values, reverse)
  !! Combine a direct leaf or scalar with an already evaluated real32 block.
  integer(operation_kind), intent(in) :: operation
  !! Validated binary arithmetic or intrinsic operation code.
  type(expression_type), intent(in) :: operand
  !! Bound leaf or stored scalar; its storage must not overlap values.
  integer(int64), intent(in) :: first
  !! One-based leaf offset; ignored when operand is a broadcast scalar.
  real(real32), contiguous, intent(inout) :: values(:)
  !! Existing child result replaced in place by the binary operation result.
  logical, intent(in) :: reverse
  !! True places operand on the left; false places it on the right.
  integer :: n
  !! Number of elements read from a direct array operand.

  n = size(values)
  select case (operand%operation)
  case (OP_LEAF)
    select case (operand%dtype)
    case (BYTE_TYPE)
      call apply_array_real32_int8(operation, &
        & operand%values_int8(first:first+n-1), values, reverse)
    case (SHORT_TYPE)
      call apply_array_real32_int16(operation, &
        & operand%values_int16(first:first+n-1), values, reverse)
    case (INT_TYPE)
      call apply_array_real32_int32(operation, &
        & operand%values_int32(first:first+n-1), values, reverse)
    case (INT64_TYPE)
      call apply_array_real32_int64(operation, &
        & operand%values_int64(first:first+n-1), values, reverse)
    case (FLOAT_TYPE)
      call apply_array_real32_real32(operation, &
        & operand%values_real32(first:first+n-1), values, reverse)
    end select
  case (OP_SCALAR_INT8, OP_SCALAR_INT16, OP_SCALAR_INT32, OP_SCALAR_INT64)
    call apply_scalar_real32(operation, real(operand%exp_int, real32), values, reverse)
  case (OP_SCALAR_REAL32, OP_SCALAR_REAL64)
    call apply_scalar_real32(operation, real(operand%exp_real, real32), values, reverse)
  end select
end subroutine apply_operand_real32

pure subroutine apply_array_real32_int8(operation, other, values, reverse)
  !! Combine a int8 array with a real32 block in place.
  !! Source elements are converted to the destination type when needed.
  integer(operation_kind), intent(in) :: operation
  !! Validated binary operation, dispatched before the concurrent loop.
  integer(int8), contiguous, intent(in) :: other(:)
  !! Read-only source block; must match values in size and not overlap it.
  real(real32), contiguous, intent(inout) :: values(:)
  !! Input block replaced by the result; each iteration owns one element.
  logical, intent(in) :: reverse
  !! True uses other as the left operand; false uses it as the right operand.
  integer :: i
  !! Independent element index local to each concurrent iteration.

  select case (operation)
  case (OP_ADD)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = real(other(i), real32) + values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) + real(other(i), real32)
      end do
    end if
  case (OP_SUB)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = real(other(i), real32) - values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) - real(other(i), real32)
      end do
    end if
  case (OP_MUL)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = real(other(i), real32) * values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) * real(other(i), real32)
      end do
    end if
  case (OP_DIV)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = real(other(i), real32) / values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) / real(other(i), real32)
      end do
    end if
  case (OP_POW)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = real(other(i), real32) ** values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) ** real(other(i), real32)
      end do
    end if
  case (OP_DIM)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = dim(real(other(i), real32), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = dim(values(i), real(other(i), real32))
      end do
    end if
  case (OP_SIGN)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = sign(real(other(i), real32), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = sign(values(i), real(other(i), real32))
      end do
    end if
  case (OP_MOD)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = mod(real(other(i), real32), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = mod(values(i), real(other(i), real32))
      end do
    end if
  case (OP_MODULO)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = modulo(real(other(i), real32), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = modulo(values(i), real(other(i), real32))
      end do
    end if
  case (OP_ATAN2)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = atan2(real(other(i), real32), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = atan2(values(i), real(other(i), real32))
      end do
    end if
  case (OP_HYPOT)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = hypot(real(other(i), real32), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = hypot(values(i), real(other(i), real32))
      end do
    end if
  end select
end subroutine apply_array_real32_int8

pure subroutine apply_array_real32_int16(operation, other, values, reverse)
  !! Combine a int16 array with a real32 block in place.
  !! Source elements are converted to the destination type when needed.
  integer(operation_kind), intent(in) :: operation
  !! Validated binary operation, dispatched before the concurrent loop.
  integer(int16), contiguous, intent(in) :: other(:)
  !! Read-only source block; must match values in size and not overlap it.
  real(real32), contiguous, intent(inout) :: values(:)
  !! Input block replaced by the result; each iteration owns one element.
  logical, intent(in) :: reverse
  !! True uses other as the left operand; false uses it as the right operand.
  integer :: i
  !! Independent element index local to each concurrent iteration.

  select case (operation)
  case (OP_ADD)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = real(other(i), real32) + values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) + real(other(i), real32)
      end do
    end if
  case (OP_SUB)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = real(other(i), real32) - values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) - real(other(i), real32)
      end do
    end if
  case (OP_MUL)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = real(other(i), real32) * values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) * real(other(i), real32)
      end do
    end if
  case (OP_DIV)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = real(other(i), real32) / values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) / real(other(i), real32)
      end do
    end if
  case (OP_POW)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = real(other(i), real32) ** values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) ** real(other(i), real32)
      end do
    end if
  case (OP_DIM)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = dim(real(other(i), real32), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = dim(values(i), real(other(i), real32))
      end do
    end if
  case (OP_SIGN)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = sign(real(other(i), real32), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = sign(values(i), real(other(i), real32))
      end do
    end if
  case (OP_MOD)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = mod(real(other(i), real32), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = mod(values(i), real(other(i), real32))
      end do
    end if
  case (OP_MODULO)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = modulo(real(other(i), real32), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = modulo(values(i), real(other(i), real32))
      end do
    end if
  case (OP_ATAN2)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = atan2(real(other(i), real32), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = atan2(values(i), real(other(i), real32))
      end do
    end if
  case (OP_HYPOT)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = hypot(real(other(i), real32), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = hypot(values(i), real(other(i), real32))
      end do
    end if
  end select
end subroutine apply_array_real32_int16

pure subroutine apply_array_real32_int32(operation, other, values, reverse)
  !! Combine a int32 array with a real32 block in place.
  !! Source elements are converted to the destination type when needed.
  integer(operation_kind), intent(in) :: operation
  !! Validated binary operation, dispatched before the concurrent loop.
  integer(int32), contiguous, intent(in) :: other(:)
  !! Read-only source block; must match values in size and not overlap it.
  real(real32), contiguous, intent(inout) :: values(:)
  !! Input block replaced by the result; each iteration owns one element.
  logical, intent(in) :: reverse
  !! True uses other as the left operand; false uses it as the right operand.
  integer :: i
  !! Independent element index local to each concurrent iteration.

  select case (operation)
  case (OP_ADD)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = real(other(i), real32) + values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) + real(other(i), real32)
      end do
    end if
  case (OP_SUB)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = real(other(i), real32) - values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) - real(other(i), real32)
      end do
    end if
  case (OP_MUL)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = real(other(i), real32) * values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) * real(other(i), real32)
      end do
    end if
  case (OP_DIV)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = real(other(i), real32) / values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) / real(other(i), real32)
      end do
    end if
  case (OP_POW)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = real(other(i), real32) ** values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) ** real(other(i), real32)
      end do
    end if
  case (OP_DIM)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = dim(real(other(i), real32), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = dim(values(i), real(other(i), real32))
      end do
    end if
  case (OP_SIGN)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = sign(real(other(i), real32), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = sign(values(i), real(other(i), real32))
      end do
    end if
  case (OP_MOD)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = mod(real(other(i), real32), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = mod(values(i), real(other(i), real32))
      end do
    end if
  case (OP_MODULO)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = modulo(real(other(i), real32), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = modulo(values(i), real(other(i), real32))
      end do
    end if
  case (OP_ATAN2)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = atan2(real(other(i), real32), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = atan2(values(i), real(other(i), real32))
      end do
    end if
  case (OP_HYPOT)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = hypot(real(other(i), real32), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = hypot(values(i), real(other(i), real32))
      end do
    end if
  end select
end subroutine apply_array_real32_int32

pure subroutine apply_array_real32_int64(operation, other, values, reverse)
  !! Combine a int64 array with a real32 block in place.
  !! Source elements are converted to the destination type when needed.
  integer(operation_kind), intent(in) :: operation
  !! Validated binary operation, dispatched before the concurrent loop.
  integer(int64), contiguous, intent(in) :: other(:)
  !! Read-only source block; must match values in size and not overlap it.
  real(real32), contiguous, intent(inout) :: values(:)
  !! Input block replaced by the result; each iteration owns one element.
  logical, intent(in) :: reverse
  !! True uses other as the left operand; false uses it as the right operand.
  integer :: i
  !! Independent element index local to each concurrent iteration.

  select case (operation)
  case (OP_ADD)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = real(other(i), real32) + values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) + real(other(i), real32)
      end do
    end if
  case (OP_SUB)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = real(other(i), real32) - values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) - real(other(i), real32)
      end do
    end if
  case (OP_MUL)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = real(other(i), real32) * values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) * real(other(i), real32)
      end do
    end if
  case (OP_DIV)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = real(other(i), real32) / values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) / real(other(i), real32)
      end do
    end if
  case (OP_POW)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = real(other(i), real32) ** values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) ** real(other(i), real32)
      end do
    end if
  case (OP_DIM)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = dim(real(other(i), real32), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = dim(values(i), real(other(i), real32))
      end do
    end if
  case (OP_SIGN)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = sign(real(other(i), real32), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = sign(values(i), real(other(i), real32))
      end do
    end if
  case (OP_MOD)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = mod(real(other(i), real32), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = mod(values(i), real(other(i), real32))
      end do
    end if
  case (OP_MODULO)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = modulo(real(other(i), real32), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = modulo(values(i), real(other(i), real32))
      end do
    end if
  case (OP_ATAN2)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = atan2(real(other(i), real32), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = atan2(values(i), real(other(i), real32))
      end do
    end if
  case (OP_HYPOT)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = hypot(real(other(i), real32), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = hypot(values(i), real(other(i), real32))
      end do
    end if
  end select
end subroutine apply_array_real32_int64

pure subroutine apply_array_real32_real32(operation, other, values, reverse)
  !! Combine a real32 array with a real32 block in place.
  !! Source elements are converted to the destination type when needed.
  integer(operation_kind), intent(in) :: operation
  !! Validated binary operation, dispatched before the concurrent loop.
  real(real32), contiguous, intent(in) :: other(:)
  !! Read-only source block; must match values in size and not overlap it.
  real(real32), contiguous, intent(inout) :: values(:)
  !! Input block replaced by the result; each iteration owns one element.
  logical, intent(in) :: reverse
  !! True uses other as the left operand; false uses it as the right operand.
  integer :: i
  !! Independent element index local to each concurrent iteration.

  select case (operation)
  case (OP_ADD)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other(i) + values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) + other(i)
      end do
    end if
  case (OP_SUB)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other(i) - values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) - other(i)
      end do
    end if
  case (OP_MUL)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other(i) * values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) * other(i)
      end do
    end if
  case (OP_DIV)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other(i) / values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) / other(i)
      end do
    end if
  case (OP_POW)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other(i) ** values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) ** other(i)
      end do
    end if
  case (OP_DIM)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = dim(other(i), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = dim(values(i), other(i))
      end do
    end if
  case (OP_SIGN)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = sign(other(i), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = sign(values(i), other(i))
      end do
    end if
  case (OP_MOD)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = mod(other(i), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = mod(values(i), other(i))
      end do
    end if
  case (OP_MODULO)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = modulo(other(i), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = modulo(values(i), other(i))
      end do
    end if
  case (OP_ATAN2)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = atan2(other(i), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = atan2(values(i), other(i))
      end do
    end if
  case (OP_HYPOT)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = hypot(other(i), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = hypot(values(i), other(i))
      end do
    end if
  end select
end subroutine apply_array_real32_real32

pure subroutine apply_scalar_real32(operation, other, values, reverse)
  !! Apply a broadcast real32 scalar to a real32 destination block in place.
  integer(operation_kind), intent(in) :: operation
  !! Validated binary operation, dispatched before the concurrent loop.
  real(real32), intent(in) :: other
  !! Read-only scalar broadcast to every destination element.
  real(real32), contiguous, intent(inout) :: values(:)
  !! Input block replaced by the result; each iteration owns one element.
  logical, intent(in) :: reverse
  !! True uses other as the left operand; false uses it as the right operand.
  integer :: i
  !! Independent element index local to each concurrent iteration.

  select case (operation)
  case (OP_ADD)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other + values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) + other
      end do
    end if
  case (OP_SUB)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other - values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) - other
      end do
    end if
  case (OP_MUL)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other * values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) * other
      end do
    end if
  case (OP_DIV)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other / values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) / other
      end do
    end if
  case (OP_POW)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other ** values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) ** other
      end do
    end if
  case (OP_DIM)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = dim(other, values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = dim(values(i), other)
      end do
    end if
  case (OP_SIGN)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = sign(other, values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = sign(values(i), other)
      end do
    end if
  case (OP_MOD)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = mod(other, values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = mod(values(i), other)
      end do
    end if
  case (OP_MODULO)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = modulo(other, values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = modulo(values(i), other)
      end do
    end if
  case (OP_ATAN2)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = atan2(other, values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = atan2(values(i), other)
      end do
    end if
  case (OP_HYPOT)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = hypot(other, values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = hypot(values(i), other)
      end do
    end if
  end select
end subroutine apply_scalar_real32

pure subroutine evaluate_real64(expr, values)
  !! Concurrent lanes own disjoint output ranges and reusable scratch banks.
  type(expression_type), intent(in) :: expr
  !! Validated expression with bound leaves and a cached scratch requirement.
  real(real64), contiguous, intent(out) :: values(:)
  !! Flat output partitioned into disjoint lanes; must not alias leaf storage.
  real(real64), allocatable :: scratch(:,:,:)
  !! Work banks indexed by block element, live intermediate, and lane.
  integer(int64) :: n, blocks, lanes, lane
  !! Output size, block count, lane count, and current logical lane index.

  n = size(values, kind=int64)
  blocks = (n + BLOCK_SIZE - 1)/BLOCK_SIZE
  lanes = min(blocks, int(MAX_BLOCK_LANES, int64))
  allocate (scratch(min(n, int(BLOCK_SIZE, int64)), expr%scratch_count, lanes))
  do concurrent (lane=1:lanes)
    block
      integer(int64) :: first, last
      !! Inclusive one-based output bounds owned by this logical lane.
      first = ((lane - 1)*blocks/lanes)*BLOCK_SIZE + 1
      last = min(n, (lane*blocks/lanes)*BLOCK_SIZE)
      call evaluate_lane_real64(expr, first, values(first:last), scratch(:,:,lane))
    end block
  end do
end subroutine evaluate_real64

pure subroutine evaluate_lane_real64(expr, first, values, scratch)
  !! Scratch is allocated once by the caller, then reused for every block.
  type(expression_type), intent(in) :: expr
  !! Validated expression shared read-only by all logical lanes.
  integer(int64), intent(in) :: first
  !! One-based index in each leaf corresponding to values(1).
  real(real64), contiguous, intent(out) :: values(:)
  !! This lane's disjoint contiguous segment of the complete output array.
  real(real64), contiguous, intent(inout) :: scratch(:,:)
  !! Lane-private work bank; columns are reused as intermediates expire.
  integer(int64) :: offset, last
  !! Inclusive block bounds within this lane's local output segment.

  do offset = 1, size(values, kind=int64), BLOCK_SIZE
    last = min(size(values, kind=int64), offset + BLOCK_SIZE - 1)
    call eval_block_real64(expr, first + offset - 1, values(offset:last), scratch)
  end do
end subroutine evaluate_lane_real64

pure recursive subroutine eval_block_real64(node, first, values, scratch)
  !! Dispatch once per block; inner loops contain only typed numerical work.
  type(expression_type), intent(in) :: node
  !! Validated subtree to evaluate for the current block.
  integer(int64), intent(in) :: first
  !! One-based starting element in the original flat leaf arrays.
  real(real64), contiguous, intent(out) :: values(:)
  !! Destination block, reused for child results; must not alias leaf storage.
  real(real64), contiguous, intent(inout) :: scratch(:,:)
  !! Work columns beyond values; requires at least node%scratch_count columns.
  !! Active scratch sections and values must not overlap.
  integer :: n, i
  !! Block length and element index for scalar-exponent loops.

  n = size(values)
  select case (node%operation)
  case (OP_LEAF)
    select case (node%dtype)
    case (BYTE_TYPE)
      values = real(node%values_int8(first:first+n-1), real64)
    case (SHORT_TYPE)
      values = real(node%values_int16(first:first+n-1), real64)
    case (INT_TYPE)
      values = real(node%values_int32(first:first+n-1), real64)
    case (INT64_TYPE)
      values = real(node%values_int64(first:first+n-1), real64)
    case (FLOAT_TYPE)
      values = real(node%values_real32(first:first+n-1), real64)
    case (DOUBLE_TYPE)
      values = real(node%values_real64(first:first+n-1), real64)
    end select
  case (OP_SCALAR_INT8, OP_SCALAR_INT16, OP_SCALAR_INT32, OP_SCALAR_INT64)
    values = real(node%exp_int, real64)
  case (OP_SCALAR_REAL32, OP_SCALAR_REAL64)
    values = real(node%exp_real, real64)
  case (OP_ABS, OP_SQRT, OP_EXP, OP_LOG, OP_LOG10, OP_SIN, OP_COS, OP_TAN, &
    & OP_ASIN, OP_ACOS, OP_ATAN, OP_SINH, OP_COSH, OP_TANH, OP_ASINH, &
    & OP_ACOSH, OP_ATANH, OP_ERF, OP_ERFC, OP_ERFC_SCALED, OP_GAMMA, &
    & OP_LOG_GAMMA, OP_BESSEL_J0, OP_BESSEL_J1, OP_BESSEL_Y0, OP_BESSEL_Y1)
    call eval_block_real64(node%left, first, values, scratch)
    call apply_unary_real64(node%operation, values)
  case (OP_ADD, OP_SUB, OP_MUL, OP_DIV, OP_POW, &
    & OP_DIM, OP_SIGN, OP_MOD, OP_MODULO, OP_ATAN2, OP_HYPOT)
    if (is_direct_operand(node%right)) then
      call eval_block_real64(node%left, first, values, scratch)
      call apply_operand_real64(node%operation, node%right, first, values, .false.)
    else if (is_direct_operand(node%left)) then
      call eval_block_real64(node%right, first, values, scratch)
      call apply_operand_real64(node%operation, node%left, first, values, .true.)
    else if (node%left%scratch_count >= node%right%scratch_count) then
      call eval_block_real64(node%left, first, values, scratch)
      call eval_block_real64(node%right, first, scratch(:n,1), scratch(:,2:))
      call apply_array_real64_real64(node%operation, scratch(:n,1), values, .false.)
    else
      call eval_block_real64(node%right, first, values, scratch)
      call eval_block_real64(node%left, first, scratch(:n,1), scratch(:,2:))
      call apply_array_real64_real64(node%operation, scratch(:n,1), values, .true.)
    end if
  case (OP_INT8_POW, OP_INT16_POW, OP_INT32_POW, OP_INT64_POW)
    call eval_block_real64(node%left, first, values, scratch)
    select case (node%operation)
    case (OP_INT8_POW)
    do i = 1, n
      values(i) = values(i)**int(node%exp_int, int8)
    end do
    case (OP_INT16_POW)
    do i = 1, n
      values(i) = values(i)**int(node%exp_int, int16)
    end do
    case (OP_INT32_POW)
    do i = 1, n
      values(i) = values(i)**int(node%exp_int, int32)
    end do
    case (OP_INT64_POW)
    do i = 1, n
      values(i) = values(i)**int(node%exp_int, int64)
    end do
    end select
  case (OP_REAL32_POW, OP_REAL64_POW)
    call eval_block_real64(node%left, first, values, scratch)
    values = values**real(node%exp_real, real64)
  end select
end subroutine eval_block_real64

pure subroutine apply_operand_real64(operation, operand, first, values, reverse)
  !! Combine a direct leaf or scalar with an already evaluated real64 block.
  integer(operation_kind), intent(in) :: operation
  !! Validated binary arithmetic or intrinsic operation code.
  type(expression_type), intent(in) :: operand
  !! Bound leaf or stored scalar; its storage must not overlap values.
  integer(int64), intent(in) :: first
  !! One-based leaf offset; ignored when operand is a broadcast scalar.
  real(real64), contiguous, intent(inout) :: values(:)
  !! Existing child result replaced in place by the binary operation result.
  logical, intent(in) :: reverse
  !! True places operand on the left; false places it on the right.
  integer :: n
  !! Number of elements read from a direct array operand.

  n = size(values)
  select case (operand%operation)
  case (OP_LEAF)
    select case (operand%dtype)
    case (BYTE_TYPE)
      call apply_array_real64_int8(operation, &
        & operand%values_int8(first:first+n-1), values, reverse)
    case (SHORT_TYPE)
      call apply_array_real64_int16(operation, &
        & operand%values_int16(first:first+n-1), values, reverse)
    case (INT_TYPE)
      call apply_array_real64_int32(operation, &
        & operand%values_int32(first:first+n-1), values, reverse)
    case (INT64_TYPE)
      call apply_array_real64_int64(operation, &
        & operand%values_int64(first:first+n-1), values, reverse)
    case (FLOAT_TYPE)
      call apply_array_real64_real32(operation, &
        & operand%values_real32(first:first+n-1), values, reverse)
    case (DOUBLE_TYPE)
      call apply_array_real64_real64(operation, &
        & operand%values_real64(first:first+n-1), values, reverse)
    end select
  case (OP_SCALAR_INT8, OP_SCALAR_INT16, OP_SCALAR_INT32, OP_SCALAR_INT64)
    call apply_scalar_real64(operation, real(operand%exp_int, real64), values, reverse)
  case (OP_SCALAR_REAL32, OP_SCALAR_REAL64)
    call apply_scalar_real64(operation, real(operand%exp_real, real64), values, reverse)
  end select
end subroutine apply_operand_real64

pure subroutine apply_array_real64_int8(operation, other, values, reverse)
  !! Combine a int8 array with a real64 block in place.
  !! Source elements are converted to the destination type when needed.
  integer(operation_kind), intent(in) :: operation
  !! Validated binary operation, dispatched before the concurrent loop.
  integer(int8), contiguous, intent(in) :: other(:)
  !! Read-only source block; must match values in size and not overlap it.
  real(real64), contiguous, intent(inout) :: values(:)
  !! Input block replaced by the result; each iteration owns one element.
  logical, intent(in) :: reverse
  !! True uses other as the left operand; false uses it as the right operand.
  integer :: i
  !! Independent element index local to each concurrent iteration.

  select case (operation)
  case (OP_ADD)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = real(other(i), real64) + values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) + real(other(i), real64)
      end do
    end if
  case (OP_SUB)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = real(other(i), real64) - values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) - real(other(i), real64)
      end do
    end if
  case (OP_MUL)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = real(other(i), real64) * values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) * real(other(i), real64)
      end do
    end if
  case (OP_DIV)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = real(other(i), real64) / values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) / real(other(i), real64)
      end do
    end if
  case (OP_POW)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = real(other(i), real64) ** values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) ** real(other(i), real64)
      end do
    end if
  case (OP_DIM)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = dim(real(other(i), real64), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = dim(values(i), real(other(i), real64))
      end do
    end if
  case (OP_SIGN)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = sign(real(other(i), real64), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = sign(values(i), real(other(i), real64))
      end do
    end if
  case (OP_MOD)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = mod(real(other(i), real64), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = mod(values(i), real(other(i), real64))
      end do
    end if
  case (OP_MODULO)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = modulo(real(other(i), real64), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = modulo(values(i), real(other(i), real64))
      end do
    end if
  case (OP_ATAN2)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = atan2(real(other(i), real64), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = atan2(values(i), real(other(i), real64))
      end do
    end if
  case (OP_HYPOT)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = hypot(real(other(i), real64), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = hypot(values(i), real(other(i), real64))
      end do
    end if
  end select
end subroutine apply_array_real64_int8

pure subroutine apply_array_real64_int16(operation, other, values, reverse)
  !! Combine a int16 array with a real64 block in place.
  !! Source elements are converted to the destination type when needed.
  integer(operation_kind), intent(in) :: operation
  !! Validated binary operation, dispatched before the concurrent loop.
  integer(int16), contiguous, intent(in) :: other(:)
  !! Read-only source block; must match values in size and not overlap it.
  real(real64), contiguous, intent(inout) :: values(:)
  !! Input block replaced by the result; each iteration owns one element.
  logical, intent(in) :: reverse
  !! True uses other as the left operand; false uses it as the right operand.
  integer :: i
  !! Independent element index local to each concurrent iteration.

  select case (operation)
  case (OP_ADD)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = real(other(i), real64) + values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) + real(other(i), real64)
      end do
    end if
  case (OP_SUB)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = real(other(i), real64) - values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) - real(other(i), real64)
      end do
    end if
  case (OP_MUL)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = real(other(i), real64) * values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) * real(other(i), real64)
      end do
    end if
  case (OP_DIV)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = real(other(i), real64) / values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) / real(other(i), real64)
      end do
    end if
  case (OP_POW)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = real(other(i), real64) ** values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) ** real(other(i), real64)
      end do
    end if
  case (OP_DIM)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = dim(real(other(i), real64), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = dim(values(i), real(other(i), real64))
      end do
    end if
  case (OP_SIGN)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = sign(real(other(i), real64), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = sign(values(i), real(other(i), real64))
      end do
    end if
  case (OP_MOD)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = mod(real(other(i), real64), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = mod(values(i), real(other(i), real64))
      end do
    end if
  case (OP_MODULO)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = modulo(real(other(i), real64), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = modulo(values(i), real(other(i), real64))
      end do
    end if
  case (OP_ATAN2)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = atan2(real(other(i), real64), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = atan2(values(i), real(other(i), real64))
      end do
    end if
  case (OP_HYPOT)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = hypot(real(other(i), real64), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = hypot(values(i), real(other(i), real64))
      end do
    end if
  end select
end subroutine apply_array_real64_int16

pure subroutine apply_array_real64_int32(operation, other, values, reverse)
  !! Combine a int32 array with a real64 block in place.
  !! Source elements are converted to the destination type when needed.
  integer(operation_kind), intent(in) :: operation
  !! Validated binary operation, dispatched before the concurrent loop.
  integer(int32), contiguous, intent(in) :: other(:)
  !! Read-only source block; must match values in size and not overlap it.
  real(real64), contiguous, intent(inout) :: values(:)
  !! Input block replaced by the result; each iteration owns one element.
  logical, intent(in) :: reverse
  !! True uses other as the left operand; false uses it as the right operand.
  integer :: i
  !! Independent element index local to each concurrent iteration.

  select case (operation)
  case (OP_ADD)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = real(other(i), real64) + values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) + real(other(i), real64)
      end do
    end if
  case (OP_SUB)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = real(other(i), real64) - values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) - real(other(i), real64)
      end do
    end if
  case (OP_MUL)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = real(other(i), real64) * values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) * real(other(i), real64)
      end do
    end if
  case (OP_DIV)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = real(other(i), real64) / values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) / real(other(i), real64)
      end do
    end if
  case (OP_POW)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = real(other(i), real64) ** values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) ** real(other(i), real64)
      end do
    end if
  case (OP_DIM)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = dim(real(other(i), real64), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = dim(values(i), real(other(i), real64))
      end do
    end if
  case (OP_SIGN)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = sign(real(other(i), real64), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = sign(values(i), real(other(i), real64))
      end do
    end if
  case (OP_MOD)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = mod(real(other(i), real64), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = mod(values(i), real(other(i), real64))
      end do
    end if
  case (OP_MODULO)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = modulo(real(other(i), real64), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = modulo(values(i), real(other(i), real64))
      end do
    end if
  case (OP_ATAN2)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = atan2(real(other(i), real64), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = atan2(values(i), real(other(i), real64))
      end do
    end if
  case (OP_HYPOT)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = hypot(real(other(i), real64), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = hypot(values(i), real(other(i), real64))
      end do
    end if
  end select
end subroutine apply_array_real64_int32

pure subroutine apply_array_real64_int64(operation, other, values, reverse)
  !! Combine a int64 array with a real64 block in place.
  !! Source elements are converted to the destination type when needed.
  integer(operation_kind), intent(in) :: operation
  !! Validated binary operation, dispatched before the concurrent loop.
  integer(int64), contiguous, intent(in) :: other(:)
  !! Read-only source block; must match values in size and not overlap it.
  real(real64), contiguous, intent(inout) :: values(:)
  !! Input block replaced by the result; each iteration owns one element.
  logical, intent(in) :: reverse
  !! True uses other as the left operand; false uses it as the right operand.
  integer :: i
  !! Independent element index local to each concurrent iteration.

  select case (operation)
  case (OP_ADD)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = real(other(i), real64) + values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) + real(other(i), real64)
      end do
    end if
  case (OP_SUB)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = real(other(i), real64) - values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) - real(other(i), real64)
      end do
    end if
  case (OP_MUL)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = real(other(i), real64) * values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) * real(other(i), real64)
      end do
    end if
  case (OP_DIV)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = real(other(i), real64) / values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) / real(other(i), real64)
      end do
    end if
  case (OP_POW)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = real(other(i), real64) ** values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) ** real(other(i), real64)
      end do
    end if
  case (OP_DIM)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = dim(real(other(i), real64), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = dim(values(i), real(other(i), real64))
      end do
    end if
  case (OP_SIGN)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = sign(real(other(i), real64), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = sign(values(i), real(other(i), real64))
      end do
    end if
  case (OP_MOD)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = mod(real(other(i), real64), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = mod(values(i), real(other(i), real64))
      end do
    end if
  case (OP_MODULO)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = modulo(real(other(i), real64), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = modulo(values(i), real(other(i), real64))
      end do
    end if
  case (OP_ATAN2)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = atan2(real(other(i), real64), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = atan2(values(i), real(other(i), real64))
      end do
    end if
  case (OP_HYPOT)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = hypot(real(other(i), real64), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = hypot(values(i), real(other(i), real64))
      end do
    end if
  end select
end subroutine apply_array_real64_int64

pure subroutine apply_array_real64_real32(operation, other, values, reverse)
  !! Combine a real32 array with a real64 block in place.
  !! Source elements are converted to the destination type when needed.
  integer(operation_kind), intent(in) :: operation
  !! Validated binary operation, dispatched before the concurrent loop.
  real(real32), contiguous, intent(in) :: other(:)
  !! Read-only source block; must match values in size and not overlap it.
  real(real64), contiguous, intent(inout) :: values(:)
  !! Input block replaced by the result; each iteration owns one element.
  logical, intent(in) :: reverse
  !! True uses other as the left operand; false uses it as the right operand.
  integer :: i
  !! Independent element index local to each concurrent iteration.

  select case (operation)
  case (OP_ADD)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = real(other(i), real64) + values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) + real(other(i), real64)
      end do
    end if
  case (OP_SUB)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = real(other(i), real64) - values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) - real(other(i), real64)
      end do
    end if
  case (OP_MUL)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = real(other(i), real64) * values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) * real(other(i), real64)
      end do
    end if
  case (OP_DIV)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = real(other(i), real64) / values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) / real(other(i), real64)
      end do
    end if
  case (OP_POW)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = real(other(i), real64) ** values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) ** real(other(i), real64)
      end do
    end if
  case (OP_DIM)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = dim(real(other(i), real64), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = dim(values(i), real(other(i), real64))
      end do
    end if
  case (OP_SIGN)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = sign(real(other(i), real64), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = sign(values(i), real(other(i), real64))
      end do
    end if
  case (OP_MOD)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = mod(real(other(i), real64), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = mod(values(i), real(other(i), real64))
      end do
    end if
  case (OP_MODULO)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = modulo(real(other(i), real64), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = modulo(values(i), real(other(i), real64))
      end do
    end if
  case (OP_ATAN2)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = atan2(real(other(i), real64), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = atan2(values(i), real(other(i), real64))
      end do
    end if
  case (OP_HYPOT)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = hypot(real(other(i), real64), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = hypot(values(i), real(other(i), real64))
      end do
    end if
  end select
end subroutine apply_array_real64_real32

pure subroutine apply_array_real64_real64(operation, other, values, reverse)
  !! Combine a real64 array with a real64 block in place.
  !! Source elements are converted to the destination type when needed.
  integer(operation_kind), intent(in) :: operation
  !! Validated binary operation, dispatched before the concurrent loop.
  real(real64), contiguous, intent(in) :: other(:)
  !! Read-only source block; must match values in size and not overlap it.
  real(real64), contiguous, intent(inout) :: values(:)
  !! Input block replaced by the result; each iteration owns one element.
  logical, intent(in) :: reverse
  !! True uses other as the left operand; false uses it as the right operand.
  integer :: i
  !! Independent element index local to each concurrent iteration.

  select case (operation)
  case (OP_ADD)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other(i) + values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) + other(i)
      end do
    end if
  case (OP_SUB)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other(i) - values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) - other(i)
      end do
    end if
  case (OP_MUL)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other(i) * values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) * other(i)
      end do
    end if
  case (OP_DIV)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other(i) / values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) / other(i)
      end do
    end if
  case (OP_POW)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other(i) ** values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) ** other(i)
      end do
    end if
  case (OP_DIM)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = dim(other(i), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = dim(values(i), other(i))
      end do
    end if
  case (OP_SIGN)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = sign(other(i), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = sign(values(i), other(i))
      end do
    end if
  case (OP_MOD)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = mod(other(i), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = mod(values(i), other(i))
      end do
    end if
  case (OP_MODULO)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = modulo(other(i), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = modulo(values(i), other(i))
      end do
    end if
  case (OP_ATAN2)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = atan2(other(i), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = atan2(values(i), other(i))
      end do
    end if
  case (OP_HYPOT)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = hypot(other(i), values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = hypot(values(i), other(i))
      end do
    end if
  end select
end subroutine apply_array_real64_real64

pure subroutine apply_scalar_real64(operation, other, values, reverse)
  !! Apply a broadcast real64 scalar to a real64 destination block in place.
  integer(operation_kind), intent(in) :: operation
  !! Validated binary operation, dispatched before the concurrent loop.
  real(real64), intent(in) :: other
  !! Read-only scalar broadcast to every destination element.
  real(real64), contiguous, intent(inout) :: values(:)
  !! Input block replaced by the result; each iteration owns one element.
  logical, intent(in) :: reverse
  !! True uses other as the left operand; false uses it as the right operand.
  integer :: i
  !! Independent element index local to each concurrent iteration.

  select case (operation)
  case (OP_ADD)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other + values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) + other
      end do
    end if
  case (OP_SUB)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other - values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) - other
      end do
    end if
  case (OP_MUL)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other * values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) * other
      end do
    end if
  case (OP_DIV)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other / values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) / other
      end do
    end if
  case (OP_POW)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = other ** values(i)
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = values(i) ** other
      end do
    end if
  case (OP_DIM)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = dim(other, values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = dim(values(i), other)
      end do
    end if
  case (OP_SIGN)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = sign(other, values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = sign(values(i), other)
      end do
    end if
  case (OP_MOD)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = mod(other, values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = mod(values(i), other)
      end do
    end if
  case (OP_MODULO)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = modulo(other, values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = modulo(values(i), other)
      end do
    end if
  case (OP_ATAN2)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = atan2(other, values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = atan2(values(i), other)
      end do
    end if
  case (OP_HYPOT)
    if (reverse) then
      do concurrent (i=1:size(values))
        values(i) = hypot(other, values(i))
      end do
    else
      do concurrent (i=1:size(values))
        values(i) = hypot(values(i), other)
      end do
    end if
  end select
end subroutine apply_scalar_real64

pure subroutine apply_unary_real32(operation, values)
  !! Apply one real real32 intrinsic to a block in place.
  !! Numerical domains and exceptions follow the Fortran intrinsic backend.
  integer(operation_kind), intent(in) :: operation
  !! Validated unary intrinsic operation code.
  real(real32), contiguous, intent(inout) :: values(:)
  !! Input block replaced elementwise by the selected intrinsic result.
  integer :: i
  !! Element index within the current block.

  select case (operation)
  case (OP_ABS)
    do i = 1, size(values)
      values(i) = abs(values(i))
    end do
  case (OP_SQRT)
    do i = 1, size(values)
      values(i) = sqrt(values(i))
    end do
  case (OP_EXP)
    do i = 1, size(values)
      values(i) = exp(values(i))
    end do
  case (OP_LOG)
    do i = 1, size(values)
      values(i) = log(values(i))
    end do
  case (OP_LOG10)
    do i = 1, size(values)
      values(i) = log10(values(i))
    end do
  case (OP_SIN)
    do i = 1, size(values)
      values(i) = sin(values(i))
    end do
  case (OP_COS)
    do i = 1, size(values)
      values(i) = cos(values(i))
    end do
  case (OP_TAN)
    do i = 1, size(values)
      values(i) = tan(values(i))
    end do
  case (OP_ASIN)
    do i = 1, size(values)
      values(i) = asin(values(i))
    end do
  case (OP_ACOS)
    do i = 1, size(values)
      values(i) = acos(values(i))
    end do
  case (OP_ATAN)
    do i = 1, size(values)
      values(i) = atan(values(i))
    end do
  case (OP_SINH)
    do i = 1, size(values)
      values(i) = sinh(values(i))
    end do
  case (OP_COSH)
    do i = 1, size(values)
      values(i) = cosh(values(i))
    end do
  case (OP_TANH)
    do i = 1, size(values)
      values(i) = tanh(values(i))
    end do
  case (OP_ASINH)
    do i = 1, size(values)
      values(i) = asinh(values(i))
    end do
  case (OP_ACOSH)
    do i = 1, size(values)
      values(i) = acosh(values(i))
    end do
  case (OP_ATANH)
    do i = 1, size(values)
      values(i) = atanh(values(i))
    end do
  case (OP_ERF)
    do i = 1, size(values)
      values(i) = erf(values(i))
    end do
  case (OP_ERFC)
    do i = 1, size(values)
      values(i) = erfc(values(i))
    end do
  case (OP_ERFC_SCALED)
    do i = 1, size(values)
      values(i) = erfc_scaled(values(i))
    end do
  case (OP_GAMMA)
    do i = 1, size(values)
      values(i) = gamma(values(i))
    end do
  case (OP_LOG_GAMMA)
    do i = 1, size(values)
      values(i) = log_gamma(values(i))
    end do
  case (OP_BESSEL_J0)
    ! Some macOS Flang runtimes lack the real32 Bessel symbols.
    do i = 1, size(values)
      values(i) = real(bessel_j0(real(values(i), real64)), real32)
    end do
  case (OP_BESSEL_J1)
    do i = 1, size(values)
      values(i) = real(bessel_j1(real(values(i), real64)), real32)
    end do
  case (OP_BESSEL_Y0)
    do i = 1, size(values)
      values(i) = real(bessel_y0(real(values(i), real64)), real32)
    end do
  case (OP_BESSEL_Y1)
    do i = 1, size(values)
      values(i) = real(bessel_y1(real(values(i), real64)), real32)
    end do
  end select
end subroutine apply_unary_real32

pure subroutine apply_unary_real64(operation, values)
  !! Apply one real real64 intrinsic to a block in place.
  !! Numerical domains and exceptions follow the Fortran intrinsic backend.
  integer(operation_kind), intent(in) :: operation
  !! Validated unary intrinsic operation code.
  real(real64), contiguous, intent(inout) :: values(:)
  !! Input block replaced elementwise by the selected intrinsic result.
  integer :: i
  !! Element index within the current block.

  select case (operation)
  case (OP_ABS)
    do i = 1, size(values)
      values(i) = abs(values(i))
    end do
  case (OP_SQRT)
    do i = 1, size(values)
      values(i) = sqrt(values(i))
    end do
  case (OP_EXP)
    do i = 1, size(values)
      values(i) = exp(values(i))
    end do
  case (OP_LOG)
    do i = 1, size(values)
      values(i) = log(values(i))
    end do
  case (OP_LOG10)
    do i = 1, size(values)
      values(i) = log10(values(i))
    end do
  case (OP_SIN)
    do i = 1, size(values)
      values(i) = sin(values(i))
    end do
  case (OP_COS)
    do i = 1, size(values)
      values(i) = cos(values(i))
    end do
  case (OP_TAN)
    do i = 1, size(values)
      values(i) = tan(values(i))
    end do
  case (OP_ASIN)
    do i = 1, size(values)
      values(i) = asin(values(i))
    end do
  case (OP_ACOS)
    do i = 1, size(values)
      values(i) = acos(values(i))
    end do
  case (OP_ATAN)
    do i = 1, size(values)
      values(i) = atan(values(i))
    end do
  case (OP_SINH)
    do i = 1, size(values)
      values(i) = sinh(values(i))
    end do
  case (OP_COSH)
    do i = 1, size(values)
      values(i) = cosh(values(i))
    end do
  case (OP_TANH)
    do i = 1, size(values)
      values(i) = tanh(values(i))
    end do
  case (OP_ASINH)
    do i = 1, size(values)
      values(i) = asinh(values(i))
    end do
  case (OP_ACOSH)
    do i = 1, size(values)
      values(i) = acosh(values(i))
    end do
  case (OP_ATANH)
    do i = 1, size(values)
      values(i) = atanh(values(i))
    end do
  case (OP_ERF)
    do i = 1, size(values)
      values(i) = erf(values(i))
    end do
  case (OP_ERFC)
    do i = 1, size(values)
      values(i) = erfc(values(i))
    end do
  case (OP_ERFC_SCALED)
    do i = 1, size(values)
      values(i) = erfc_scaled(values(i))
    end do
  case (OP_GAMMA)
    do i = 1, size(values)
      values(i) = gamma(values(i))
    end do
  case (OP_LOG_GAMMA)
    do i = 1, size(values)
      values(i) = log_gamma(values(i))
    end do
  case (OP_BESSEL_J0)
    do i = 1, size(values)
      values(i) = bessel_j0(values(i))
    end do
  case (OP_BESSEL_J1)
    do i = 1, size(values)
      values(i) = bessel_j1(values(i))
    end do
  case (OP_BESSEL_Y0)
    do i = 1, size(values)
      values(i) = bessel_y0(values(i))
    end do
  case (OP_BESSEL_Y1)
    do i = 1, size(values)
      values(i) = bessel_y1(values(i))
    end do
  end select
end subroutine apply_unary_real64

end submodule nc4f_data_expression
