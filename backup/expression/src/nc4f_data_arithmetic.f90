submodule(nc4f_data) nc4f_data_arithmetic
!! Build deferred arithmetic expressions without evaluating their elements.
!! Variable leaves bind typed data and metadata views; nested nodes are
!! copied into the tree. Scalar operands are stored in expression nodes.
implicit none (type, external)
contains

module function add_var_var(a, b) result(expr)
  !! Build a deferred add node from var and var operands.
  type(variable_type), target, intent(in) :: a
  !! Left operand; the expression borrows this variable.
  type(variable_type), target, intent(in) :: b
  !! Right operand; the expression borrows this variable.
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function add_var_var

module function add_var_expr(a, b) result(expr)
  !! Build a deferred add node from var and expr operands.
  type(variable_type), target, intent(in) :: a
  !! Left operand; the expression borrows this variable.
  type(expression_type), intent(in) :: b
  !! Right operand; its tree is copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  call copy_expr(b, expr%right)
  call init_expr_workspace(expr)
end function add_var_expr

module function add_expr_var(a, b) result(expr)
  !! Build a deferred add node from expr and var operands.
  type(expression_type), intent(in) :: a
  !! Left operand; its tree is copied into the result.
  type(variable_type), target, intent(in) :: b
  !! Right operand; the expression borrows this variable.
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function add_expr_var

module function add_expr_expr(a, b) result(expr)
  !! Build a deferred add node from expr and expr operands.
  type(expression_type), intent(in) :: a
  !! Left operand; its tree is copied into the result.
  type(expression_type), intent(in) :: b
  !! Right operand; its tree is copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  call copy_expr(b, expr%right)
  call init_expr_workspace(expr)
end function add_expr_expr

module function sub_var_var(a, b) result(expr)
  !! Build a deferred sub node from var and var operands.
  type(variable_type), target, intent(in) :: a
  !! Left operand; the expression borrows this variable.
  type(variable_type), target, intent(in) :: b
  !! Right operand; the expression borrows this variable.
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function sub_var_var

module function sub_var_expr(a, b) result(expr)
  !! Build a deferred sub node from var and expr operands.
  type(variable_type), target, intent(in) :: a
  !! Left operand; the expression borrows this variable.
  type(expression_type), intent(in) :: b
  !! Right operand; its tree is copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  call copy_expr(b, expr%right)
  call init_expr_workspace(expr)
end function sub_var_expr

module function sub_expr_var(a, b) result(expr)
  !! Build a deferred sub node from expr and var operands.
  type(expression_type), intent(in) :: a
  !! Left operand; its tree is copied into the result.
  type(variable_type), target, intent(in) :: b
  !! Right operand; the expression borrows this variable.
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function sub_expr_var

module function sub_expr_expr(a, b) result(expr)
  !! Build a deferred sub node from expr and expr operands.
  type(expression_type), intent(in) :: a
  !! Left operand; its tree is copied into the result.
  type(expression_type), intent(in) :: b
  !! Right operand; its tree is copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  call copy_expr(b, expr%right)
  call init_expr_workspace(expr)
end function sub_expr_expr

module function mul_var_var(a, b) result(expr)
  !! Build a deferred mul node from var and var operands.
  type(variable_type), target, intent(in) :: a
  !! Left operand; the expression borrows this variable.
  type(variable_type), target, intent(in) :: b
  !! Right operand; the expression borrows this variable.
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function mul_var_var

module function mul_var_expr(a, b) result(expr)
  !! Build a deferred mul node from var and expr operands.
  type(variable_type), target, intent(in) :: a
  !! Left operand; the expression borrows this variable.
  type(expression_type), intent(in) :: b
  !! Right operand; its tree is copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  call copy_expr(b, expr%right)
  call init_expr_workspace(expr)
end function mul_var_expr

module function mul_expr_var(a, b) result(expr)
  !! Build a deferred mul node from expr and var operands.
  type(expression_type), intent(in) :: a
  !! Left operand; its tree is copied into the result.
  type(variable_type), target, intent(in) :: b
  !! Right operand; the expression borrows this variable.
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function mul_expr_var

module function mul_expr_expr(a, b) result(expr)
  !! Build a deferred mul node from expr and expr operands.
  type(expression_type), intent(in) :: a
  !! Left operand; its tree is copied into the result.
  type(expression_type), intent(in) :: b
  !! Right operand; its tree is copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  call copy_expr(b, expr%right)
  call init_expr_workspace(expr)
end function mul_expr_expr

module function div_var_var(a, b) result(expr)
  !! Build a deferred div node from var and var operands.
  type(variable_type), target, intent(in) :: a
  !! Left operand; the expression borrows this variable.
  type(variable_type), target, intent(in) :: b
  !! Right operand; the expression borrows this variable.
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function div_var_var

module function div_var_expr(a, b) result(expr)
  !! Build a deferred div node from var and expr operands.
  type(variable_type), target, intent(in) :: a
  !! Left operand; the expression borrows this variable.
  type(expression_type), intent(in) :: b
  !! Right operand; its tree is copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  call copy_expr(b, expr%right)
  call init_expr_workspace(expr)
end function div_var_expr

module function div_expr_var(a, b) result(expr)
  !! Build a deferred div node from expr and var operands.
  type(expression_type), intent(in) :: a
  !! Left operand; its tree is copied into the result.
  type(variable_type), target, intent(in) :: b
  !! Right operand; the expression borrows this variable.
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function div_expr_var

module function div_expr_expr(a, b) result(expr)
  !! Build a deferred div node from expr and expr operands.
  type(expression_type), intent(in) :: a
  !! Left operand; its tree is copied into the result.
  type(expression_type), intent(in) :: b
  !! Right operand; its tree is copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  call copy_expr(b, expr%right)
  call init_expr_workspace(expr)
end function div_expr_expr

module function pow_var_var(a, b) result(expr)
  !! Build a deferred pow node from var and var operands.
  type(variable_type), target, intent(in) :: a
  !! Left operand; the expression borrows this variable.
  type(variable_type), target, intent(in) :: b
  !! Right operand; the expression borrows this variable.
  type(expression_type) :: expr

  expr%operation = OP_POW
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function pow_var_var

module function pow_var_expr(a, b) result(expr)
  !! Build a deferred pow node from var and expr operands.
  type(variable_type), target, intent(in) :: a
  !! Left operand; the expression borrows this variable.
  type(expression_type), intent(in) :: b
  !! Right operand; its tree is copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_POW
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  call copy_expr(b, expr%right)
  call init_expr_workspace(expr)
end function pow_var_expr

module function pow_expr_var(a, b) result(expr)
  !! Build a deferred pow node from expr and var operands.
  type(expression_type), intent(in) :: a
  !! Left operand; its tree is copied into the result.
  type(variable_type), target, intent(in) :: b
  !! Right operand; the expression borrows this variable.
  type(expression_type) :: expr

  expr%operation = OP_POW
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function pow_expr_var

module function pow_expr_expr(a, b) result(expr)
  !! Build a deferred pow node from expr and expr operands.
  type(expression_type), intent(in) :: a
  !! Left operand; its tree is copied into the result.
  type(expression_type), intent(in) :: b
  !! Right operand; its tree is copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_POW
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  call copy_expr(b, expr%right)
  call init_expr_workspace(expr)
end function pow_expr_expr

module function pow_var_int8(a, exponent) result(expr)
  !! Raise a var operand to a stored int8 scalar exponent later.
  type(variable_type), target, intent(in) :: a
  !! Base variable; the expression borrows it.
  integer(int8), intent(in) :: exponent
  !! Scalar exponent, stored by value for later evaluation.
  type(expression_type) :: expr

  expr%operation = OP_INT8_POW
  expr%exp_int = int(exponent, int64)
  allocate (expr%left)
  call init_expr_leaf(a, expr%left)
  call init_expr_workspace(expr)
end function pow_var_int8

module function pow_expr_int8(a, exponent) result(expr)
  !! Raise a expr operand to a stored int8 scalar exponent later.
  type(expression_type), intent(in) :: a
  !! Base expression; its tree is copied into the result.
  integer(int8), intent(in) :: exponent
  !! Scalar exponent, stored by value for later evaluation.
  type(expression_type) :: expr

  expr%operation = OP_INT8_POW
  expr%exp_int = int(exponent, int64)
  allocate (expr%left)
  call copy_expr(a, expr%left)
  call init_expr_workspace(expr)
end function pow_expr_int8

module function pow_var_int16(a, exponent) result(expr)
  !! Raise a var operand to a stored int16 scalar exponent later.
  type(variable_type), target, intent(in) :: a
  !! Base variable; the expression borrows it.
  integer(int16), intent(in) :: exponent
  !! Scalar exponent, stored by value for later evaluation.
  type(expression_type) :: expr

  expr%operation = OP_INT16_POW
  expr%exp_int = int(exponent, int64)
  allocate (expr%left)
  call init_expr_leaf(a, expr%left)
  call init_expr_workspace(expr)
end function pow_var_int16

module function pow_expr_int16(a, exponent) result(expr)
  !! Raise a expr operand to a stored int16 scalar exponent later.
  type(expression_type), intent(in) :: a
  !! Base expression; its tree is copied into the result.
  integer(int16), intent(in) :: exponent
  !! Scalar exponent, stored by value for later evaluation.
  type(expression_type) :: expr

  expr%operation = OP_INT16_POW
  expr%exp_int = int(exponent, int64)
  allocate (expr%left)
  call copy_expr(a, expr%left)
  call init_expr_workspace(expr)
end function pow_expr_int16

module function pow_var_int32(a, exponent) result(expr)
  !! Raise a var operand to a stored int32 scalar exponent later.
  type(variable_type), target, intent(in) :: a
  !! Base variable; the expression borrows it.
  integer(int32), intent(in) :: exponent
  !! Scalar exponent, stored by value for later evaluation.
  type(expression_type) :: expr

  expr%operation = OP_INT32_POW
  expr%exp_int = int(exponent, int64)
  allocate (expr%left)
  call init_expr_leaf(a, expr%left)
  call init_expr_workspace(expr)
end function pow_var_int32

module function pow_expr_int32(a, exponent) result(expr)
  !! Raise a expr operand to a stored int32 scalar exponent later.
  type(expression_type), intent(in) :: a
  !! Base expression; its tree is copied into the result.
  integer(int32), intent(in) :: exponent
  !! Scalar exponent, stored by value for later evaluation.
  type(expression_type) :: expr

  expr%operation = OP_INT32_POW
  expr%exp_int = int(exponent, int64)
  allocate (expr%left)
  call copy_expr(a, expr%left)
  call init_expr_workspace(expr)
end function pow_expr_int32

module function pow_var_int64(a, exponent) result(expr)
  !! Raise a var operand to a stored int64 scalar exponent later.
  type(variable_type), target, intent(in) :: a
  !! Base variable; the expression borrows it.
  integer(int64), intent(in) :: exponent
  !! Scalar exponent, stored by value for later evaluation.
  type(expression_type) :: expr

  expr%operation = OP_INT64_POW
  expr%exp_int = int(exponent, int64)
  allocate (expr%left)
  call init_expr_leaf(a, expr%left)
  call init_expr_workspace(expr)
end function pow_var_int64

module function pow_expr_int64(a, exponent) result(expr)
  !! Raise a expr operand to a stored int64 scalar exponent later.
  type(expression_type), intent(in) :: a
  !! Base expression; its tree is copied into the result.
  integer(int64), intent(in) :: exponent
  !! Scalar exponent, stored by value for later evaluation.
  type(expression_type) :: expr

  expr%operation = OP_INT64_POW
  expr%exp_int = int(exponent, int64)
  allocate (expr%left)
  call copy_expr(a, expr%left)
  call init_expr_workspace(expr)
end function pow_expr_int64

module function pow_var_real32(a, exponent) result(expr)
  !! Raise a var operand to a stored real32 scalar exponent later.
  type(variable_type), target, intent(in) :: a
  !! Base variable; the expression borrows it.
  real(real32), intent(in) :: exponent
  !! Scalar exponent, stored by value for later evaluation.
  type(expression_type) :: expr

  expr%operation = OP_REAL32_POW
  expr%exp_real = real(exponent, real64)
  allocate (expr%left)
  call init_expr_leaf(a, expr%left)
  call init_expr_workspace(expr)
end function pow_var_real32

module function pow_expr_real32(a, exponent) result(expr)
  !! Raise a expr operand to a stored real32 scalar exponent later.
  type(expression_type), intent(in) :: a
  !! Base expression; its tree is copied into the result.
  real(real32), intent(in) :: exponent
  !! Scalar exponent, stored by value for later evaluation.
  type(expression_type) :: expr

  expr%operation = OP_REAL32_POW
  expr%exp_real = real(exponent, real64)
  allocate (expr%left)
  call copy_expr(a, expr%left)
  call init_expr_workspace(expr)
end function pow_expr_real32

module function pow_var_real64(a, exponent) result(expr)
  !! Raise a var operand to a stored real64 scalar exponent later.
  type(variable_type), target, intent(in) :: a
  !! Base variable; the expression borrows it.
  real(real64), intent(in) :: exponent
  !! Scalar exponent, stored by value for later evaluation.
  type(expression_type) :: expr

  expr%operation = OP_REAL64_POW
  expr%exp_real = real(exponent, real64)
  allocate (expr%left)
  call init_expr_leaf(a, expr%left)
  call init_expr_workspace(expr)
end function pow_var_real64

module function pow_expr_real64(a, exponent) result(expr)
  !! Raise a expr operand to a stored real64 scalar exponent later.
  type(expression_type), intent(in) :: a
  !! Base expression; its tree is copied into the result.
  real(real64), intent(in) :: exponent
  !! Scalar exponent, stored by value for later evaluation.
  type(expression_type) :: expr

  expr%operation = OP_REAL64_POW
  expr%exp_real = real(exponent, real64)
  allocate (expr%left)
  call copy_expr(a, expr%left)
  call init_expr_workspace(expr)
end function pow_expr_real64

module function add_int8_var(a, b) result(expr)
  !! Build a deferred add node with a int8 scalar on the left.
  integer(int8), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable; the expression borrows it.
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT8
  expr%left%exp_int = int(a, int64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function add_int8_var

module function add_int8_expr(a, b) result(expr)
  !! Build a deferred add node with a int8 scalar on the left.
  integer(int8), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression; its tree is copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT8
  expr%left%exp_int = int(a, int64)
  call copy_expr(b, expr%right)
  call init_expr_workspace(expr)
end function add_int8_expr

module function add_int16_var(a, b) result(expr)
  !! Build a deferred add node with a int16 scalar on the left.
  integer(int16), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable; the expression borrows it.
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT16
  expr%left%exp_int = int(a, int64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function add_int16_var

module function add_int16_expr(a, b) result(expr)
  !! Build a deferred add node with a int16 scalar on the left.
  integer(int16), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression; its tree is copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT16
  expr%left%exp_int = int(a, int64)
  call copy_expr(b, expr%right)
  call init_expr_workspace(expr)
end function add_int16_expr

module function add_int32_var(a, b) result(expr)
  !! Build a deferred add node with a int32 scalar on the left.
  integer(int32), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable; the expression borrows it.
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT32
  expr%left%exp_int = int(a, int64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function add_int32_var

module function add_int32_expr(a, b) result(expr)
  !! Build a deferred add node with a int32 scalar on the left.
  integer(int32), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression; its tree is copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT32
  expr%left%exp_int = int(a, int64)
  call copy_expr(b, expr%right)
  call init_expr_workspace(expr)
end function add_int32_expr

module function add_int64_var(a, b) result(expr)
  !! Build a deferred add node with a int64 scalar on the left.
  integer(int64), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable; the expression borrows it.
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT64
  expr%left%exp_int = int(a, int64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function add_int64_var

module function add_int64_expr(a, b) result(expr)
  !! Build a deferred add node with a int64 scalar on the left.
  integer(int64), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression; its tree is copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT64
  expr%left%exp_int = int(a, int64)
  call copy_expr(b, expr%right)
  call init_expr_workspace(expr)
end function add_int64_expr

module function add_real32_var(a, b) result(expr)
  !! Build a deferred add node with a real32 scalar on the left.
  real(real32), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable; the expression borrows it.
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL32
  expr%left%exp_real = real(a, real64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function add_real32_var

module function add_real32_expr(a, b) result(expr)
  !! Build a deferred add node with a real32 scalar on the left.
  real(real32), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression; its tree is copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL32
  expr%left%exp_real = real(a, real64)
  call copy_expr(b, expr%right)
  call init_expr_workspace(expr)
end function add_real32_expr

module function add_real64_var(a, b) result(expr)
  !! Build a deferred add node with a real64 scalar on the left.
  real(real64), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable; the expression borrows it.
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL64
  expr%left%exp_real = real(a, real64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function add_real64_var

module function add_real64_expr(a, b) result(expr)
  !! Build a deferred add node with a real64 scalar on the left.
  real(real64), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression; its tree is copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL64
  expr%left%exp_real = real(a, real64)
  call copy_expr(b, expr%right)
  call init_expr_workspace(expr)
end function add_real64_expr

module function sub_int8_var(a, b) result(expr)
  !! Build a deferred sub node with a int8 scalar on the left.
  integer(int8), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable; the expression borrows it.
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT8
  expr%left%exp_int = int(a, int64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function sub_int8_var

module function sub_int8_expr(a, b) result(expr)
  !! Build a deferred sub node with a int8 scalar on the left.
  integer(int8), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression; its tree is copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT8
  expr%left%exp_int = int(a, int64)
  call copy_expr(b, expr%right)
  call init_expr_workspace(expr)
end function sub_int8_expr

module function sub_int16_var(a, b) result(expr)
  !! Build a deferred sub node with a int16 scalar on the left.
  integer(int16), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable; the expression borrows it.
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT16
  expr%left%exp_int = int(a, int64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function sub_int16_var

module function sub_int16_expr(a, b) result(expr)
  !! Build a deferred sub node with a int16 scalar on the left.
  integer(int16), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression; its tree is copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT16
  expr%left%exp_int = int(a, int64)
  call copy_expr(b, expr%right)
  call init_expr_workspace(expr)
end function sub_int16_expr

module function sub_int32_var(a, b) result(expr)
  !! Build a deferred sub node with a int32 scalar on the left.
  integer(int32), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable; the expression borrows it.
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT32
  expr%left%exp_int = int(a, int64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function sub_int32_var

module function sub_int32_expr(a, b) result(expr)
  !! Build a deferred sub node with a int32 scalar on the left.
  integer(int32), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression; its tree is copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT32
  expr%left%exp_int = int(a, int64)
  call copy_expr(b, expr%right)
  call init_expr_workspace(expr)
end function sub_int32_expr

module function sub_int64_var(a, b) result(expr)
  !! Build a deferred sub node with a int64 scalar on the left.
  integer(int64), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable; the expression borrows it.
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT64
  expr%left%exp_int = int(a, int64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function sub_int64_var

module function sub_int64_expr(a, b) result(expr)
  !! Build a deferred sub node with a int64 scalar on the left.
  integer(int64), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression; its tree is copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT64
  expr%left%exp_int = int(a, int64)
  call copy_expr(b, expr%right)
  call init_expr_workspace(expr)
end function sub_int64_expr

module function sub_real32_var(a, b) result(expr)
  !! Build a deferred sub node with a real32 scalar on the left.
  real(real32), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable; the expression borrows it.
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL32
  expr%left%exp_real = real(a, real64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function sub_real32_var

module function sub_real32_expr(a, b) result(expr)
  !! Build a deferred sub node with a real32 scalar on the left.
  real(real32), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression; its tree is copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL32
  expr%left%exp_real = real(a, real64)
  call copy_expr(b, expr%right)
  call init_expr_workspace(expr)
end function sub_real32_expr

module function sub_real64_var(a, b) result(expr)
  !! Build a deferred sub node with a real64 scalar on the left.
  real(real64), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable; the expression borrows it.
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL64
  expr%left%exp_real = real(a, real64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function sub_real64_var

module function sub_real64_expr(a, b) result(expr)
  !! Build a deferred sub node with a real64 scalar on the left.
  real(real64), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression; its tree is copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL64
  expr%left%exp_real = real(a, real64)
  call copy_expr(b, expr%right)
  call init_expr_workspace(expr)
end function sub_real64_expr

module function mul_int8_var(a, b) result(expr)
  !! Build a deferred mul node with a int8 scalar on the left.
  integer(int8), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable; the expression borrows it.
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT8
  expr%left%exp_int = int(a, int64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function mul_int8_var

module function mul_int8_expr(a, b) result(expr)
  !! Build a deferred mul node with a int8 scalar on the left.
  integer(int8), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression; its tree is copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT8
  expr%left%exp_int = int(a, int64)
  call copy_expr(b, expr%right)
  call init_expr_workspace(expr)
end function mul_int8_expr

module function mul_int16_var(a, b) result(expr)
  !! Build a deferred mul node with a int16 scalar on the left.
  integer(int16), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable; the expression borrows it.
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT16
  expr%left%exp_int = int(a, int64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function mul_int16_var

module function mul_int16_expr(a, b) result(expr)
  !! Build a deferred mul node with a int16 scalar on the left.
  integer(int16), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression; its tree is copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT16
  expr%left%exp_int = int(a, int64)
  call copy_expr(b, expr%right)
  call init_expr_workspace(expr)
end function mul_int16_expr

module function mul_int32_var(a, b) result(expr)
  !! Build a deferred mul node with a int32 scalar on the left.
  integer(int32), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable; the expression borrows it.
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT32
  expr%left%exp_int = int(a, int64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function mul_int32_var

module function mul_int32_expr(a, b) result(expr)
  !! Build a deferred mul node with a int32 scalar on the left.
  integer(int32), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression; its tree is copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT32
  expr%left%exp_int = int(a, int64)
  call copy_expr(b, expr%right)
  call init_expr_workspace(expr)
end function mul_int32_expr

module function mul_int64_var(a, b) result(expr)
  !! Build a deferred mul node with a int64 scalar on the left.
  integer(int64), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable; the expression borrows it.
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT64
  expr%left%exp_int = int(a, int64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function mul_int64_var

module function mul_int64_expr(a, b) result(expr)
  !! Build a deferred mul node with a int64 scalar on the left.
  integer(int64), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression; its tree is copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT64
  expr%left%exp_int = int(a, int64)
  call copy_expr(b, expr%right)
  call init_expr_workspace(expr)
end function mul_int64_expr

module function mul_real32_var(a, b) result(expr)
  !! Build a deferred mul node with a real32 scalar on the left.
  real(real32), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable; the expression borrows it.
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL32
  expr%left%exp_real = real(a, real64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function mul_real32_var

module function mul_real32_expr(a, b) result(expr)
  !! Build a deferred mul node with a real32 scalar on the left.
  real(real32), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression; its tree is copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL32
  expr%left%exp_real = real(a, real64)
  call copy_expr(b, expr%right)
  call init_expr_workspace(expr)
end function mul_real32_expr

module function mul_real64_var(a, b) result(expr)
  !! Build a deferred mul node with a real64 scalar on the left.
  real(real64), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable; the expression borrows it.
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL64
  expr%left%exp_real = real(a, real64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function mul_real64_var

module function mul_real64_expr(a, b) result(expr)
  !! Build a deferred mul node with a real64 scalar on the left.
  real(real64), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression; its tree is copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL64
  expr%left%exp_real = real(a, real64)
  call copy_expr(b, expr%right)
  call init_expr_workspace(expr)
end function mul_real64_expr

module function div_int8_var(a, b) result(expr)
  !! Build a deferred div node with a int8 scalar on the left.
  integer(int8), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable; the expression borrows it.
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT8
  expr%left%exp_int = int(a, int64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function div_int8_var

module function div_int8_expr(a, b) result(expr)
  !! Build a deferred div node with a int8 scalar on the left.
  integer(int8), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression; its tree is copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT8
  expr%left%exp_int = int(a, int64)
  call copy_expr(b, expr%right)
  call init_expr_workspace(expr)
end function div_int8_expr

module function div_int16_var(a, b) result(expr)
  !! Build a deferred div node with a int16 scalar on the left.
  integer(int16), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable; the expression borrows it.
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT16
  expr%left%exp_int = int(a, int64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function div_int16_var

module function div_int16_expr(a, b) result(expr)
  !! Build a deferred div node with a int16 scalar on the left.
  integer(int16), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression; its tree is copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT16
  expr%left%exp_int = int(a, int64)
  call copy_expr(b, expr%right)
  call init_expr_workspace(expr)
end function div_int16_expr

module function div_int32_var(a, b) result(expr)
  !! Build a deferred div node with a int32 scalar on the left.
  integer(int32), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable; the expression borrows it.
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT32
  expr%left%exp_int = int(a, int64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function div_int32_var

module function div_int32_expr(a, b) result(expr)
  !! Build a deferred div node with a int32 scalar on the left.
  integer(int32), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression; its tree is copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT32
  expr%left%exp_int = int(a, int64)
  call copy_expr(b, expr%right)
  call init_expr_workspace(expr)
end function div_int32_expr

module function div_int64_var(a, b) result(expr)
  !! Build a deferred div node with a int64 scalar on the left.
  integer(int64), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable; the expression borrows it.
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT64
  expr%left%exp_int = int(a, int64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function div_int64_var

module function div_int64_expr(a, b) result(expr)
  !! Build a deferred div node with a int64 scalar on the left.
  integer(int64), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression; its tree is copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT64
  expr%left%exp_int = int(a, int64)
  call copy_expr(b, expr%right)
  call init_expr_workspace(expr)
end function div_int64_expr

module function div_real32_var(a, b) result(expr)
  !! Build a deferred div node with a real32 scalar on the left.
  real(real32), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable; the expression borrows it.
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL32
  expr%left%exp_real = real(a, real64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function div_real32_var

module function div_real32_expr(a, b) result(expr)
  !! Build a deferred div node with a real32 scalar on the left.
  real(real32), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression; its tree is copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL32
  expr%left%exp_real = real(a, real64)
  call copy_expr(b, expr%right)
  call init_expr_workspace(expr)
end function div_real32_expr

module function div_real64_var(a, b) result(expr)
  !! Build a deferred div node with a real64 scalar on the left.
  real(real64), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable; the expression borrows it.
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL64
  expr%left%exp_real = real(a, real64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function div_real64_var

module function div_real64_expr(a, b) result(expr)
  !! Build a deferred div node with a real64 scalar on the left.
  real(real64), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression; its tree is copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL64
  expr%left%exp_real = real(a, real64)
  call copy_expr(b, expr%right)
  call init_expr_workspace(expr)
end function div_real64_expr

module function add_var_int8(a, b) result(expr)
  !! Build a deferred add node with a int8 scalar on the right.
  type(variable_type), target, intent(in) :: a
  !! Left variable; the expression borrows it.
  integer(int8), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_INT8
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function add_var_int8

module function add_expr_int8(a, b) result(expr)
  !! Build a deferred add node with a int8 scalar on the right.
  type(expression_type), intent(in) :: a
  !! Left expression; its tree is copied into the result.
  integer(int8), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_SCALAR_INT8
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function add_expr_int8

module function add_var_int16(a, b) result(expr)
  !! Build a deferred add node with a int16 scalar on the right.
  type(variable_type), target, intent(in) :: a
  !! Left variable; the expression borrows it.
  integer(int16), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_INT16
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function add_var_int16

module function add_expr_int16(a, b) result(expr)
  !! Build a deferred add node with a int16 scalar on the right.
  type(expression_type), intent(in) :: a
  !! Left expression; its tree is copied into the result.
  integer(int16), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_SCALAR_INT16
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function add_expr_int16

module function add_var_int32(a, b) result(expr)
  !! Build a deferred add node with a int32 scalar on the right.
  type(variable_type), target, intent(in) :: a
  !! Left variable; the expression borrows it.
  integer(int32), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_INT32
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function add_var_int32

module function add_expr_int32(a, b) result(expr)
  !! Build a deferred add node with a int32 scalar on the right.
  type(expression_type), intent(in) :: a
  !! Left expression; its tree is copied into the result.
  integer(int32), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_SCALAR_INT32
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function add_expr_int32

module function add_var_int64(a, b) result(expr)
  !! Build a deferred add node with a int64 scalar on the right.
  type(variable_type), target, intent(in) :: a
  !! Left variable; the expression borrows it.
  integer(int64), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_INT64
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function add_var_int64

module function add_expr_int64(a, b) result(expr)
  !! Build a deferred add node with a int64 scalar on the right.
  type(expression_type), intent(in) :: a
  !! Left expression; its tree is copied into the result.
  integer(int64), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_SCALAR_INT64
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function add_expr_int64

module function add_var_real32(a, b) result(expr)
  !! Build a deferred add node with a real32 scalar on the right.
  type(variable_type), target, intent(in) :: a
  !! Left variable; the expression borrows it.
  real(real32), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_REAL32
  expr%right%exp_real = real(b, real64)
  call init_expr_workspace(expr)
end function add_var_real32

module function add_expr_real32(a, b) result(expr)
  !! Build a deferred add node with a real32 scalar on the right.
  type(expression_type), intent(in) :: a
  !! Left expression; its tree is copied into the result.
  real(real32), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_SCALAR_REAL32
  expr%right%exp_real = real(b, real64)
  call init_expr_workspace(expr)
end function add_expr_real32

module function add_var_real64(a, b) result(expr)
  !! Build a deferred add node with a real64 scalar on the right.
  type(variable_type), target, intent(in) :: a
  !! Left variable; the expression borrows it.
  real(real64), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_REAL64
  expr%right%exp_real = real(b, real64)
  call init_expr_workspace(expr)
end function add_var_real64

module function add_expr_real64(a, b) result(expr)
  !! Build a deferred add node with a real64 scalar on the right.
  type(expression_type), intent(in) :: a
  !! Left expression; its tree is copied into the result.
  real(real64), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_SCALAR_REAL64
  expr%right%exp_real = real(b, real64)
  call init_expr_workspace(expr)
end function add_expr_real64

module function sub_var_int8(a, b) result(expr)
  !! Build a deferred sub node with a int8 scalar on the right.
  type(variable_type), target, intent(in) :: a
  !! Left variable; the expression borrows it.
  integer(int8), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_INT8
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function sub_var_int8

module function sub_expr_int8(a, b) result(expr)
  !! Build a deferred sub node with a int8 scalar on the right.
  type(expression_type), intent(in) :: a
  !! Left expression; its tree is copied into the result.
  integer(int8), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_SCALAR_INT8
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function sub_expr_int8

module function sub_var_int16(a, b) result(expr)
  !! Build a deferred sub node with a int16 scalar on the right.
  type(variable_type), target, intent(in) :: a
  !! Left variable; the expression borrows it.
  integer(int16), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_INT16
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function sub_var_int16

module function sub_expr_int16(a, b) result(expr)
  !! Build a deferred sub node with a int16 scalar on the right.
  type(expression_type), intent(in) :: a
  !! Left expression; its tree is copied into the result.
  integer(int16), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_SCALAR_INT16
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function sub_expr_int16

module function sub_var_int32(a, b) result(expr)
  !! Build a deferred sub node with a int32 scalar on the right.
  type(variable_type), target, intent(in) :: a
  !! Left variable; the expression borrows it.
  integer(int32), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_INT32
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function sub_var_int32

module function sub_expr_int32(a, b) result(expr)
  !! Build a deferred sub node with a int32 scalar on the right.
  type(expression_type), intent(in) :: a
  !! Left expression; its tree is copied into the result.
  integer(int32), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_SCALAR_INT32
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function sub_expr_int32

module function sub_var_int64(a, b) result(expr)
  !! Build a deferred sub node with a int64 scalar on the right.
  type(variable_type), target, intent(in) :: a
  !! Left variable; the expression borrows it.
  integer(int64), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_INT64
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function sub_var_int64

module function sub_expr_int64(a, b) result(expr)
  !! Build a deferred sub node with a int64 scalar on the right.
  type(expression_type), intent(in) :: a
  !! Left expression; its tree is copied into the result.
  integer(int64), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_SCALAR_INT64
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function sub_expr_int64

module function sub_var_real32(a, b) result(expr)
  !! Build a deferred sub node with a real32 scalar on the right.
  type(variable_type), target, intent(in) :: a
  !! Left variable; the expression borrows it.
  real(real32), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_REAL32
  expr%right%exp_real = real(b, real64)
  call init_expr_workspace(expr)
end function sub_var_real32

module function sub_expr_real32(a, b) result(expr)
  !! Build a deferred sub node with a real32 scalar on the right.
  type(expression_type), intent(in) :: a
  !! Left expression; its tree is copied into the result.
  real(real32), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_SCALAR_REAL32
  expr%right%exp_real = real(b, real64)
  call init_expr_workspace(expr)
end function sub_expr_real32

module function sub_var_real64(a, b) result(expr)
  !! Build a deferred sub node with a real64 scalar on the right.
  type(variable_type), target, intent(in) :: a
  !! Left variable; the expression borrows it.
  real(real64), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_REAL64
  expr%right%exp_real = real(b, real64)
  call init_expr_workspace(expr)
end function sub_var_real64

module function sub_expr_real64(a, b) result(expr)
  !! Build a deferred sub node with a real64 scalar on the right.
  type(expression_type), intent(in) :: a
  !! Left expression; its tree is copied into the result.
  real(real64), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_SCALAR_REAL64
  expr%right%exp_real = real(b, real64)
  call init_expr_workspace(expr)
end function sub_expr_real64

module function mul_var_int8(a, b) result(expr)
  !! Build a deferred mul node with a int8 scalar on the right.
  type(variable_type), target, intent(in) :: a
  !! Left variable; the expression borrows it.
  integer(int8), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_INT8
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function mul_var_int8

module function mul_expr_int8(a, b) result(expr)
  !! Build a deferred mul node with a int8 scalar on the right.
  type(expression_type), intent(in) :: a
  !! Left expression; its tree is copied into the result.
  integer(int8), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_SCALAR_INT8
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function mul_expr_int8

module function mul_var_int16(a, b) result(expr)
  !! Build a deferred mul node with a int16 scalar on the right.
  type(variable_type), target, intent(in) :: a
  !! Left variable; the expression borrows it.
  integer(int16), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_INT16
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function mul_var_int16

module function mul_expr_int16(a, b) result(expr)
  !! Build a deferred mul node with a int16 scalar on the right.
  type(expression_type), intent(in) :: a
  !! Left expression; its tree is copied into the result.
  integer(int16), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_SCALAR_INT16
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function mul_expr_int16

module function mul_var_int32(a, b) result(expr)
  !! Build a deferred mul node with a int32 scalar on the right.
  type(variable_type), target, intent(in) :: a
  !! Left variable; the expression borrows it.
  integer(int32), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_INT32
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function mul_var_int32

module function mul_expr_int32(a, b) result(expr)
  !! Build a deferred mul node with a int32 scalar on the right.
  type(expression_type), intent(in) :: a
  !! Left expression; its tree is copied into the result.
  integer(int32), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_SCALAR_INT32
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function mul_expr_int32

module function mul_var_int64(a, b) result(expr)
  !! Build a deferred mul node with a int64 scalar on the right.
  type(variable_type), target, intent(in) :: a
  !! Left variable; the expression borrows it.
  integer(int64), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_INT64
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function mul_var_int64

module function mul_expr_int64(a, b) result(expr)
  !! Build a deferred mul node with a int64 scalar on the right.
  type(expression_type), intent(in) :: a
  !! Left expression; its tree is copied into the result.
  integer(int64), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_SCALAR_INT64
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function mul_expr_int64

module function mul_var_real32(a, b) result(expr)
  !! Build a deferred mul node with a real32 scalar on the right.
  type(variable_type), target, intent(in) :: a
  !! Left variable; the expression borrows it.
  real(real32), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_REAL32
  expr%right%exp_real = real(b, real64)
  call init_expr_workspace(expr)
end function mul_var_real32

module function mul_expr_real32(a, b) result(expr)
  !! Build a deferred mul node with a real32 scalar on the right.
  type(expression_type), intent(in) :: a
  !! Left expression; its tree is copied into the result.
  real(real32), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_SCALAR_REAL32
  expr%right%exp_real = real(b, real64)
  call init_expr_workspace(expr)
end function mul_expr_real32

module function mul_var_real64(a, b) result(expr)
  !! Build a deferred mul node with a real64 scalar on the right.
  type(variable_type), target, intent(in) :: a
  !! Left variable; the expression borrows it.
  real(real64), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_REAL64
  expr%right%exp_real = real(b, real64)
  call init_expr_workspace(expr)
end function mul_var_real64

module function mul_expr_real64(a, b) result(expr)
  !! Build a deferred mul node with a real64 scalar on the right.
  type(expression_type), intent(in) :: a
  !! Left expression; its tree is copied into the result.
  real(real64), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_SCALAR_REAL64
  expr%right%exp_real = real(b, real64)
  call init_expr_workspace(expr)
end function mul_expr_real64

module function div_var_int8(a, b) result(expr)
  !! Build a deferred div node with a int8 scalar on the right.
  type(variable_type), target, intent(in) :: a
  !! Left variable; the expression borrows it.
  integer(int8), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_INT8
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function div_var_int8

module function div_expr_int8(a, b) result(expr)
  !! Build a deferred div node with a int8 scalar on the right.
  type(expression_type), intent(in) :: a
  !! Left expression; its tree is copied into the result.
  integer(int8), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_SCALAR_INT8
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function div_expr_int8

module function div_var_int16(a, b) result(expr)
  !! Build a deferred div node with a int16 scalar on the right.
  type(variable_type), target, intent(in) :: a
  !! Left variable; the expression borrows it.
  integer(int16), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_INT16
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function div_var_int16

module function div_expr_int16(a, b) result(expr)
  !! Build a deferred div node with a int16 scalar on the right.
  type(expression_type), intent(in) :: a
  !! Left expression; its tree is copied into the result.
  integer(int16), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_SCALAR_INT16
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function div_expr_int16

module function div_var_int32(a, b) result(expr)
  !! Build a deferred div node with a int32 scalar on the right.
  type(variable_type), target, intent(in) :: a
  !! Left variable; the expression borrows it.
  integer(int32), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_INT32
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function div_var_int32

module function div_expr_int32(a, b) result(expr)
  !! Build a deferred div node with a int32 scalar on the right.
  type(expression_type), intent(in) :: a
  !! Left expression; its tree is copied into the result.
  integer(int32), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_SCALAR_INT32
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function div_expr_int32

module function div_var_int64(a, b) result(expr)
  !! Build a deferred div node with a int64 scalar on the right.
  type(variable_type), target, intent(in) :: a
  !! Left variable; the expression borrows it.
  integer(int64), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_INT64
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function div_var_int64

module function div_expr_int64(a, b) result(expr)
  !! Build a deferred div node with a int64 scalar on the right.
  type(expression_type), intent(in) :: a
  !! Left expression; its tree is copied into the result.
  integer(int64), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_SCALAR_INT64
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function div_expr_int64

module function div_var_real32(a, b) result(expr)
  !! Build a deferred div node with a real32 scalar on the right.
  type(variable_type), target, intent(in) :: a
  !! Left variable; the expression borrows it.
  real(real32), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_REAL32
  expr%right%exp_real = real(b, real64)
  call init_expr_workspace(expr)
end function div_var_real32

module function div_expr_real32(a, b) result(expr)
  !! Build a deferred div node with a real32 scalar on the right.
  type(expression_type), intent(in) :: a
  !! Left expression; its tree is copied into the result.
  real(real32), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_SCALAR_REAL32
  expr%right%exp_real = real(b, real64)
  call init_expr_workspace(expr)
end function div_expr_real32

module function div_var_real64(a, b) result(expr)
  !! Build a deferred div node with a real64 scalar on the right.
  type(variable_type), target, intent(in) :: a
  !! Left variable; the expression borrows it.
  real(real64), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_REAL64
  expr%right%exp_real = real(b, real64)
  call init_expr_workspace(expr)
end function div_var_real64

module function div_expr_real64(a, b) result(expr)
  !! Build a deferred div node with a real64 scalar on the right.
  type(expression_type), intent(in) :: a
  !! Left expression; its tree is copied into the result.
  real(real64), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_SCALAR_REAL64
  expr%right%exp_real = real(b, real64)
  call init_expr_workspace(expr)
end function div_expr_real64

recursive subroutine copy_expr(source, dest)
  !! Copy the tree structure while retaining borrowed operand views.
  type(expression_type), intent(in) :: source
  !! Expression tree to copy; its data and metadata remain borrowed.
  type(expression_type), intent(out) :: dest
  !! Receives an independent node tree with the same operand views.

  dest%operation = source%operation
  dest%scratch_count = source%scratch_count
  dest%exp_int = source%exp_int
  dest%exp_real = source%exp_real
  dest%dtype = source%dtype
  dest%len = source%len
  dest%dims => source%dims
  dest%coords => source%coords
  dest%leaf_error = source%leaf_error
  dest%values_int8 => source%values_int8
  dest%values_int16 => source%values_int16
  dest%values_int32 => source%values_int32
  dest%values_int64 => source%values_int64
  dest%values_real32 => source%values_real32
  dest%values_real64 => source%values_real64
  if (allocated(source%left)) then
    allocate (dest%left)
    call copy_expr(source%left, dest%left)
  end if
  if (allocated(source%right)) then
    allocate (dest%right)
    call copy_expr(source%right, dest%right)
  end if
end subroutine copy_expr

end submodule nc4f_data_arithmetic
