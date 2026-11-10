!! Arithmetic operators build deferred expression trees. Variable operands
!! are borrowed, and scalar operands are stored by value in their nodes.
!! + accepts variables, expressions, and supported scalars.
interface operator(+)
  module procedure :: add_var_var, add_expr_var, &
    & add_var_expr, add_expr_expr
  module procedure :: add_int8_var, add_int8_expr
  module procedure :: add_var_int8, add_expr_int8
  module procedure :: add_int16_var, add_int16_expr
  module procedure :: add_var_int16, add_expr_int16
  module procedure :: add_int32_var, add_int32_expr
  module procedure :: add_var_int32, add_expr_int32
  module procedure :: add_int64_var, add_int64_expr
  module procedure :: add_var_int64, add_expr_int64
  module procedure :: add_real32_var, add_real32_expr
  module procedure :: add_var_real32, add_expr_real32
  module procedure :: add_real64_var, add_real64_expr
  module procedure :: add_var_real64, add_expr_real64
end interface operator(+)

!! - accepts variables, expressions, and supported scalars.
interface operator(-)
  module procedure :: sub_var_var, sub_expr_var, &
    & sub_var_expr, sub_expr_expr
  module procedure :: sub_int8_var, sub_int8_expr
  module procedure :: sub_var_int8, sub_expr_int8
  module procedure :: sub_int16_var, sub_int16_expr
  module procedure :: sub_var_int16, sub_expr_int16
  module procedure :: sub_int32_var, sub_int32_expr
  module procedure :: sub_var_int32, sub_expr_int32
  module procedure :: sub_int64_var, sub_int64_expr
  module procedure :: sub_var_int64, sub_expr_int64
  module procedure :: sub_real32_var, sub_real32_expr
  module procedure :: sub_var_real32, sub_expr_real32
  module procedure :: sub_real64_var, sub_real64_expr
  module procedure :: sub_var_real64, sub_expr_real64
end interface operator(-)

!! * accepts variables, expressions, and supported scalars.
interface operator(*)
  module procedure :: mul_var_var, mul_expr_var, &
    & mul_var_expr, mul_expr_expr
  module procedure :: mul_int8_var, mul_int8_expr
  module procedure :: mul_var_int8, mul_expr_int8
  module procedure :: mul_int16_var, mul_int16_expr
  module procedure :: mul_var_int16, mul_expr_int16
  module procedure :: mul_int32_var, mul_int32_expr
  module procedure :: mul_var_int32, mul_expr_int32
  module procedure :: mul_int64_var, mul_int64_expr
  module procedure :: mul_var_int64, mul_expr_int64
  module procedure :: mul_real32_var, mul_real32_expr
  module procedure :: mul_var_real32, mul_expr_real32
  module procedure :: mul_real64_var, mul_real64_expr
  module procedure :: mul_var_real64, mul_expr_real64
end interface operator(*)

!! / accepts variables, expressions, and supported scalars.
interface operator(/)
  module procedure :: div_var_var, div_expr_var, &
    & div_var_expr, div_expr_expr
  module procedure :: div_int8_var, div_int8_expr
  module procedure :: div_var_int8, div_expr_int8
  module procedure :: div_int16_var, div_int16_expr
  module procedure :: div_var_int16, div_expr_int16
  module procedure :: div_int32_var, div_int32_expr
  module procedure :: div_var_int32, div_expr_int32
  module procedure :: div_int64_var, div_int64_expr
  module procedure :: div_var_int64, div_expr_int64
  module procedure :: div_real32_var, div_real32_expr
  module procedure :: div_var_real32, div_expr_real32
  module procedure :: div_real64_var, div_real64_expr
  module procedure :: div_var_real64, div_expr_real64
end interface operator(/)

!! ** accepts variables, expressions, and supported scalars.
interface operator(**)
  module procedure :: pow_var_var, pow_expr_var, &
    & pow_var_expr, pow_expr_expr
  module procedure :: pow_var_int8, pow_expr_int8
  module procedure :: pow_var_int16, pow_expr_int16
  module procedure :: pow_var_int32, pow_expr_int32
  module procedure :: pow_var_int64, pow_expr_int64
  module procedure :: pow_var_real32, pow_expr_real32
  module procedure :: pow_var_real64, pow_expr_real64
end interface operator(**)

interface
  module function add_var_var(a, b) result(expr)
    !! Return a deferred add expression from var and var.
    type(variable_type), target, intent(in) :: a
    !! Left variable borrowed by the resulting expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable borrowed by the resulting expression.
    type(expression_type) :: expr
  end function add_var_var

  module function add_var_expr(a, b) result(expr)
    !! Return a deferred add expression from var and expr.
    type(variable_type), target, intent(in) :: a
    !! Left variable borrowed by the resulting expression.
    type(expression_type), intent(in) :: b
    !! Right expression copied into the resulting tree.
    type(expression_type) :: expr
  end function add_var_expr

  module function add_expr_var(a, b) result(expr)
    !! Return a deferred add expression from expr and var.
    type(expression_type), intent(in) :: a
    !! Left expression copied into the resulting tree.
    type(variable_type), target, intent(in) :: b
    !! Right variable borrowed by the resulting expression.
    type(expression_type) :: expr
  end function add_expr_var

  module function add_expr_expr(a, b) result(expr)
    !! Return a deferred add expression from expr and expr.
    type(expression_type), intent(in) :: a
    !! Left expression copied into the resulting tree.
    type(expression_type), intent(in) :: b
    !! Right expression copied into the resulting tree.
    type(expression_type) :: expr
  end function add_expr_expr

  module function sub_var_var(a, b) result(expr)
    !! Return a deferred sub expression from var and var.
    type(variable_type), target, intent(in) :: a
    !! Left variable borrowed by the resulting expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable borrowed by the resulting expression.
    type(expression_type) :: expr
  end function sub_var_var

  module function sub_var_expr(a, b) result(expr)
    !! Return a deferred sub expression from var and expr.
    type(variable_type), target, intent(in) :: a
    !! Left variable borrowed by the resulting expression.
    type(expression_type), intent(in) :: b
    !! Right expression copied into the resulting tree.
    type(expression_type) :: expr
  end function sub_var_expr

  module function sub_expr_var(a, b) result(expr)
    !! Return a deferred sub expression from expr and var.
    type(expression_type), intent(in) :: a
    !! Left expression copied into the resulting tree.
    type(variable_type), target, intent(in) :: b
    !! Right variable borrowed by the resulting expression.
    type(expression_type) :: expr
  end function sub_expr_var

  module function sub_expr_expr(a, b) result(expr)
    !! Return a deferred sub expression from expr and expr.
    type(expression_type), intent(in) :: a
    !! Left expression copied into the resulting tree.
    type(expression_type), intent(in) :: b
    !! Right expression copied into the resulting tree.
    type(expression_type) :: expr
  end function sub_expr_expr

  module function mul_var_var(a, b) result(expr)
    !! Return a deferred mul expression from var and var.
    type(variable_type), target, intent(in) :: a
    !! Left variable borrowed by the resulting expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable borrowed by the resulting expression.
    type(expression_type) :: expr
  end function mul_var_var

  module function mul_var_expr(a, b) result(expr)
    !! Return a deferred mul expression from var and expr.
    type(variable_type), target, intent(in) :: a
    !! Left variable borrowed by the resulting expression.
    type(expression_type), intent(in) :: b
    !! Right expression copied into the resulting tree.
    type(expression_type) :: expr
  end function mul_var_expr

  module function mul_expr_var(a, b) result(expr)
    !! Return a deferred mul expression from expr and var.
    type(expression_type), intent(in) :: a
    !! Left expression copied into the resulting tree.
    type(variable_type), target, intent(in) :: b
    !! Right variable borrowed by the resulting expression.
    type(expression_type) :: expr
  end function mul_expr_var

  module function mul_expr_expr(a, b) result(expr)
    !! Return a deferred mul expression from expr and expr.
    type(expression_type), intent(in) :: a
    !! Left expression copied into the resulting tree.
    type(expression_type), intent(in) :: b
    !! Right expression copied into the resulting tree.
    type(expression_type) :: expr
  end function mul_expr_expr

  module function div_var_var(a, b) result(expr)
    !! Return a deferred div expression from var and var.
    type(variable_type), target, intent(in) :: a
    !! Left variable borrowed by the resulting expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable borrowed by the resulting expression.
    type(expression_type) :: expr
  end function div_var_var

  module function div_var_expr(a, b) result(expr)
    !! Return a deferred div expression from var and expr.
    type(variable_type), target, intent(in) :: a
    !! Left variable borrowed by the resulting expression.
    type(expression_type), intent(in) :: b
    !! Right expression copied into the resulting tree.
    type(expression_type) :: expr
  end function div_var_expr

  module function div_expr_var(a, b) result(expr)
    !! Return a deferred div expression from expr and var.
    type(expression_type), intent(in) :: a
    !! Left expression copied into the resulting tree.
    type(variable_type), target, intent(in) :: b
    !! Right variable borrowed by the resulting expression.
    type(expression_type) :: expr
  end function div_expr_var

  module function div_expr_expr(a, b) result(expr)
    !! Return a deferred div expression from expr and expr.
    type(expression_type), intent(in) :: a
    !! Left expression copied into the resulting tree.
    type(expression_type), intent(in) :: b
    !! Right expression copied into the resulting tree.
    type(expression_type) :: expr
  end function div_expr_expr

  module function pow_var_var(a, b) result(expr)
    !! Return a deferred pow expression from var and var.
    type(variable_type), target, intent(in) :: a
    !! Left variable borrowed by the resulting expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable borrowed by the resulting expression.
    type(expression_type) :: expr
  end function pow_var_var

  module function pow_var_expr(a, b) result(expr)
    !! Return a deferred pow expression from var and expr.
    type(variable_type), target, intent(in) :: a
    !! Left variable borrowed by the resulting expression.
    type(expression_type), intent(in) :: b
    !! Right expression copied into the resulting tree.
    type(expression_type) :: expr
  end function pow_var_expr

  module function pow_expr_var(a, b) result(expr)
    !! Return a deferred pow expression from expr and var.
    type(expression_type), intent(in) :: a
    !! Left expression copied into the resulting tree.
    type(variable_type), target, intent(in) :: b
    !! Right variable borrowed by the resulting expression.
    type(expression_type) :: expr
  end function pow_expr_var

  module function pow_expr_expr(a, b) result(expr)
    !! Return a deferred pow expression from expr and expr.
    type(expression_type), intent(in) :: a
    !! Left expression copied into the resulting tree.
    type(expression_type), intent(in) :: b
    !! Right expression copied into the resulting tree.
    type(expression_type) :: expr
  end function pow_expr_expr

  module function pow_var_int8(a, exponent) result(expr)
    !! Return a deferred power with a int8 scalar exponent.
    type(variable_type), target, intent(in) :: a
    !! Base variable borrowed by the resulting expression.
    integer(int8), intent(in) :: exponent
    !! Scalar exponent stored by value for later evaluation.
    type(expression_type) :: expr
  end function pow_var_int8

  module function pow_expr_int8(a, exponent) result(expr)
    !! Return a deferred power with a int8 scalar exponent.
    type(expression_type), intent(in) :: a
    !! Base expression copied into the resulting tree.
    integer(int8), intent(in) :: exponent
    !! Scalar exponent stored by value for later evaluation.
    type(expression_type) :: expr
  end function pow_expr_int8

  module function pow_var_int16(a, exponent) result(expr)
    !! Return a deferred power with a int16 scalar exponent.
    type(variable_type), target, intent(in) :: a
    !! Base variable borrowed by the resulting expression.
    integer(int16), intent(in) :: exponent
    !! Scalar exponent stored by value for later evaluation.
    type(expression_type) :: expr
  end function pow_var_int16

  module function pow_expr_int16(a, exponent) result(expr)
    !! Return a deferred power with a int16 scalar exponent.
    type(expression_type), intent(in) :: a
    !! Base expression copied into the resulting tree.
    integer(int16), intent(in) :: exponent
    !! Scalar exponent stored by value for later evaluation.
    type(expression_type) :: expr
  end function pow_expr_int16

  module function pow_var_int32(a, exponent) result(expr)
    !! Return a deferred power with a int32 scalar exponent.
    type(variable_type), target, intent(in) :: a
    !! Base variable borrowed by the resulting expression.
    integer(int32), intent(in) :: exponent
    !! Scalar exponent stored by value for later evaluation.
    type(expression_type) :: expr
  end function pow_var_int32

  module function pow_expr_int32(a, exponent) result(expr)
    !! Return a deferred power with a int32 scalar exponent.
    type(expression_type), intent(in) :: a
    !! Base expression copied into the resulting tree.
    integer(int32), intent(in) :: exponent
    !! Scalar exponent stored by value for later evaluation.
    type(expression_type) :: expr
  end function pow_expr_int32

  module function pow_var_int64(a, exponent) result(expr)
    !! Return a deferred power with a int64 scalar exponent.
    type(variable_type), target, intent(in) :: a
    !! Base variable borrowed by the resulting expression.
    integer(int64), intent(in) :: exponent
    !! Scalar exponent stored by value for later evaluation.
    type(expression_type) :: expr
  end function pow_var_int64

  module function pow_expr_int64(a, exponent) result(expr)
    !! Return a deferred power with a int64 scalar exponent.
    type(expression_type), intent(in) :: a
    !! Base expression copied into the resulting tree.
    integer(int64), intent(in) :: exponent
    !! Scalar exponent stored by value for later evaluation.
    type(expression_type) :: expr
  end function pow_expr_int64

  module function pow_var_real32(a, exponent) result(expr)
    !! Return a deferred power with a real32 scalar exponent.
    type(variable_type), target, intent(in) :: a
    !! Base variable borrowed by the resulting expression.
    real(real32), intent(in) :: exponent
    !! Scalar exponent stored by value for later evaluation.
    type(expression_type) :: expr
  end function pow_var_real32

  module function pow_expr_real32(a, exponent) result(expr)
    !! Return a deferred power with a real32 scalar exponent.
    type(expression_type), intent(in) :: a
    !! Base expression copied into the resulting tree.
    real(real32), intent(in) :: exponent
    !! Scalar exponent stored by value for later evaluation.
    type(expression_type) :: expr
  end function pow_expr_real32

  module function pow_var_real64(a, exponent) result(expr)
    !! Return a deferred power with a real64 scalar exponent.
    type(variable_type), target, intent(in) :: a
    !! Base variable borrowed by the resulting expression.
    real(real64), intent(in) :: exponent
    !! Scalar exponent stored by value for later evaluation.
    type(expression_type) :: expr
  end function pow_var_real64

  module function pow_expr_real64(a, exponent) result(expr)
    !! Return a deferred power with a real64 scalar exponent.
    type(expression_type), intent(in) :: a
    !! Base expression copied into the resulting tree.
    real(real64), intent(in) :: exponent
    !! Scalar exponent stored by value for later evaluation.
    type(expression_type) :: expr
  end function pow_expr_real64

  module function add_int8_var(a, b) result(expr)
    !! Return a deferred add expression with a left int8 scalar.
    integer(int8), intent(in) :: a
    !! Left scalar stored by value in the resulting expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable borrowed by the resulting expression.
    type(expression_type) :: expr
  end function add_int8_var

  module function add_int8_expr(a, b) result(expr)
    !! Return a deferred add expression with a left int8 scalar.
    integer(int8), intent(in) :: a
    !! Left scalar stored by value in the resulting expression.
    type(expression_type), intent(in) :: b
    !! Right expression copied into the resulting tree.
    type(expression_type) :: expr
  end function add_int8_expr

  module function add_int16_var(a, b) result(expr)
    !! Return a deferred add expression with a left int16 scalar.
    integer(int16), intent(in) :: a
    !! Left scalar stored by value in the resulting expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable borrowed by the resulting expression.
    type(expression_type) :: expr
  end function add_int16_var

  module function add_int16_expr(a, b) result(expr)
    !! Return a deferred add expression with a left int16 scalar.
    integer(int16), intent(in) :: a
    !! Left scalar stored by value in the resulting expression.
    type(expression_type), intent(in) :: b
    !! Right expression copied into the resulting tree.
    type(expression_type) :: expr
  end function add_int16_expr

  module function add_int32_var(a, b) result(expr)
    !! Return a deferred add expression with a left int32 scalar.
    integer(int32), intent(in) :: a
    !! Left scalar stored by value in the resulting expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable borrowed by the resulting expression.
    type(expression_type) :: expr
  end function add_int32_var

  module function add_int32_expr(a, b) result(expr)
    !! Return a deferred add expression with a left int32 scalar.
    integer(int32), intent(in) :: a
    !! Left scalar stored by value in the resulting expression.
    type(expression_type), intent(in) :: b
    !! Right expression copied into the resulting tree.
    type(expression_type) :: expr
  end function add_int32_expr

  module function add_int64_var(a, b) result(expr)
    !! Return a deferred add expression with a left int64 scalar.
    integer(int64), intent(in) :: a
    !! Left scalar stored by value in the resulting expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable borrowed by the resulting expression.
    type(expression_type) :: expr
  end function add_int64_var

  module function add_int64_expr(a, b) result(expr)
    !! Return a deferred add expression with a left int64 scalar.
    integer(int64), intent(in) :: a
    !! Left scalar stored by value in the resulting expression.
    type(expression_type), intent(in) :: b
    !! Right expression copied into the resulting tree.
    type(expression_type) :: expr
  end function add_int64_expr

  module function add_real32_var(a, b) result(expr)
    !! Return a deferred add expression with a left real32 scalar.
    real(real32), intent(in) :: a
    !! Left scalar stored by value in the resulting expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable borrowed by the resulting expression.
    type(expression_type) :: expr
  end function add_real32_var

  module function add_real32_expr(a, b) result(expr)
    !! Return a deferred add expression with a left real32 scalar.
    real(real32), intent(in) :: a
    !! Left scalar stored by value in the resulting expression.
    type(expression_type), intent(in) :: b
    !! Right expression copied into the resulting tree.
    type(expression_type) :: expr
  end function add_real32_expr

  module function add_real64_var(a, b) result(expr)
    !! Return a deferred add expression with a left real64 scalar.
    real(real64), intent(in) :: a
    !! Left scalar stored by value in the resulting expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable borrowed by the resulting expression.
    type(expression_type) :: expr
  end function add_real64_var

  module function add_real64_expr(a, b) result(expr)
    !! Return a deferred add expression with a left real64 scalar.
    real(real64), intent(in) :: a
    !! Left scalar stored by value in the resulting expression.
    type(expression_type), intent(in) :: b
    !! Right expression copied into the resulting tree.
    type(expression_type) :: expr
  end function add_real64_expr

  module function sub_int8_var(a, b) result(expr)
    !! Return a deferred sub expression with a left int8 scalar.
    integer(int8), intent(in) :: a
    !! Left scalar stored by value in the resulting expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable borrowed by the resulting expression.
    type(expression_type) :: expr
  end function sub_int8_var

  module function sub_int8_expr(a, b) result(expr)
    !! Return a deferred sub expression with a left int8 scalar.
    integer(int8), intent(in) :: a
    !! Left scalar stored by value in the resulting expression.
    type(expression_type), intent(in) :: b
    !! Right expression copied into the resulting tree.
    type(expression_type) :: expr
  end function sub_int8_expr

  module function sub_int16_var(a, b) result(expr)
    !! Return a deferred sub expression with a left int16 scalar.
    integer(int16), intent(in) :: a
    !! Left scalar stored by value in the resulting expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable borrowed by the resulting expression.
    type(expression_type) :: expr
  end function sub_int16_var

  module function sub_int16_expr(a, b) result(expr)
    !! Return a deferred sub expression with a left int16 scalar.
    integer(int16), intent(in) :: a
    !! Left scalar stored by value in the resulting expression.
    type(expression_type), intent(in) :: b
    !! Right expression copied into the resulting tree.
    type(expression_type) :: expr
  end function sub_int16_expr

  module function sub_int32_var(a, b) result(expr)
    !! Return a deferred sub expression with a left int32 scalar.
    integer(int32), intent(in) :: a
    !! Left scalar stored by value in the resulting expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable borrowed by the resulting expression.
    type(expression_type) :: expr
  end function sub_int32_var

  module function sub_int32_expr(a, b) result(expr)
    !! Return a deferred sub expression with a left int32 scalar.
    integer(int32), intent(in) :: a
    !! Left scalar stored by value in the resulting expression.
    type(expression_type), intent(in) :: b
    !! Right expression copied into the resulting tree.
    type(expression_type) :: expr
  end function sub_int32_expr

  module function sub_int64_var(a, b) result(expr)
    !! Return a deferred sub expression with a left int64 scalar.
    integer(int64), intent(in) :: a
    !! Left scalar stored by value in the resulting expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable borrowed by the resulting expression.
    type(expression_type) :: expr
  end function sub_int64_var

  module function sub_int64_expr(a, b) result(expr)
    !! Return a deferred sub expression with a left int64 scalar.
    integer(int64), intent(in) :: a
    !! Left scalar stored by value in the resulting expression.
    type(expression_type), intent(in) :: b
    !! Right expression copied into the resulting tree.
    type(expression_type) :: expr
  end function sub_int64_expr

  module function sub_real32_var(a, b) result(expr)
    !! Return a deferred sub expression with a left real32 scalar.
    real(real32), intent(in) :: a
    !! Left scalar stored by value in the resulting expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable borrowed by the resulting expression.
    type(expression_type) :: expr
  end function sub_real32_var

  module function sub_real32_expr(a, b) result(expr)
    !! Return a deferred sub expression with a left real32 scalar.
    real(real32), intent(in) :: a
    !! Left scalar stored by value in the resulting expression.
    type(expression_type), intent(in) :: b
    !! Right expression copied into the resulting tree.
    type(expression_type) :: expr
  end function sub_real32_expr

  module function sub_real64_var(a, b) result(expr)
    !! Return a deferred sub expression with a left real64 scalar.
    real(real64), intent(in) :: a
    !! Left scalar stored by value in the resulting expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable borrowed by the resulting expression.
    type(expression_type) :: expr
  end function sub_real64_var

  module function sub_real64_expr(a, b) result(expr)
    !! Return a deferred sub expression with a left real64 scalar.
    real(real64), intent(in) :: a
    !! Left scalar stored by value in the resulting expression.
    type(expression_type), intent(in) :: b
    !! Right expression copied into the resulting tree.
    type(expression_type) :: expr
  end function sub_real64_expr

  module function mul_int8_var(a, b) result(expr)
    !! Return a deferred mul expression with a left int8 scalar.
    integer(int8), intent(in) :: a
    !! Left scalar stored by value in the resulting expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable borrowed by the resulting expression.
    type(expression_type) :: expr
  end function mul_int8_var

  module function mul_int8_expr(a, b) result(expr)
    !! Return a deferred mul expression with a left int8 scalar.
    integer(int8), intent(in) :: a
    !! Left scalar stored by value in the resulting expression.
    type(expression_type), intent(in) :: b
    !! Right expression copied into the resulting tree.
    type(expression_type) :: expr
  end function mul_int8_expr

  module function mul_int16_var(a, b) result(expr)
    !! Return a deferred mul expression with a left int16 scalar.
    integer(int16), intent(in) :: a
    !! Left scalar stored by value in the resulting expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable borrowed by the resulting expression.
    type(expression_type) :: expr
  end function mul_int16_var

  module function mul_int16_expr(a, b) result(expr)
    !! Return a deferred mul expression with a left int16 scalar.
    integer(int16), intent(in) :: a
    !! Left scalar stored by value in the resulting expression.
    type(expression_type), intent(in) :: b
    !! Right expression copied into the resulting tree.
    type(expression_type) :: expr
  end function mul_int16_expr

  module function mul_int32_var(a, b) result(expr)
    !! Return a deferred mul expression with a left int32 scalar.
    integer(int32), intent(in) :: a
    !! Left scalar stored by value in the resulting expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable borrowed by the resulting expression.
    type(expression_type) :: expr
  end function mul_int32_var

  module function mul_int32_expr(a, b) result(expr)
    !! Return a deferred mul expression with a left int32 scalar.
    integer(int32), intent(in) :: a
    !! Left scalar stored by value in the resulting expression.
    type(expression_type), intent(in) :: b
    !! Right expression copied into the resulting tree.
    type(expression_type) :: expr
  end function mul_int32_expr

  module function mul_int64_var(a, b) result(expr)
    !! Return a deferred mul expression with a left int64 scalar.
    integer(int64), intent(in) :: a
    !! Left scalar stored by value in the resulting expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable borrowed by the resulting expression.
    type(expression_type) :: expr
  end function mul_int64_var

  module function mul_int64_expr(a, b) result(expr)
    !! Return a deferred mul expression with a left int64 scalar.
    integer(int64), intent(in) :: a
    !! Left scalar stored by value in the resulting expression.
    type(expression_type), intent(in) :: b
    !! Right expression copied into the resulting tree.
    type(expression_type) :: expr
  end function mul_int64_expr

  module function mul_real32_var(a, b) result(expr)
    !! Return a deferred mul expression with a left real32 scalar.
    real(real32), intent(in) :: a
    !! Left scalar stored by value in the resulting expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable borrowed by the resulting expression.
    type(expression_type) :: expr
  end function mul_real32_var

  module function mul_real32_expr(a, b) result(expr)
    !! Return a deferred mul expression with a left real32 scalar.
    real(real32), intent(in) :: a
    !! Left scalar stored by value in the resulting expression.
    type(expression_type), intent(in) :: b
    !! Right expression copied into the resulting tree.
    type(expression_type) :: expr
  end function mul_real32_expr

  module function mul_real64_var(a, b) result(expr)
    !! Return a deferred mul expression with a left real64 scalar.
    real(real64), intent(in) :: a
    !! Left scalar stored by value in the resulting expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable borrowed by the resulting expression.
    type(expression_type) :: expr
  end function mul_real64_var

  module function mul_real64_expr(a, b) result(expr)
    !! Return a deferred mul expression with a left real64 scalar.
    real(real64), intent(in) :: a
    !! Left scalar stored by value in the resulting expression.
    type(expression_type), intent(in) :: b
    !! Right expression copied into the resulting tree.
    type(expression_type) :: expr
  end function mul_real64_expr

  module function div_int8_var(a, b) result(expr)
    !! Return a deferred div expression with a left int8 scalar.
    integer(int8), intent(in) :: a
    !! Left scalar stored by value in the resulting expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable borrowed by the resulting expression.
    type(expression_type) :: expr
  end function div_int8_var

  module function div_int8_expr(a, b) result(expr)
    !! Return a deferred div expression with a left int8 scalar.
    integer(int8), intent(in) :: a
    !! Left scalar stored by value in the resulting expression.
    type(expression_type), intent(in) :: b
    !! Right expression copied into the resulting tree.
    type(expression_type) :: expr
  end function div_int8_expr

  module function div_int16_var(a, b) result(expr)
    !! Return a deferred div expression with a left int16 scalar.
    integer(int16), intent(in) :: a
    !! Left scalar stored by value in the resulting expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable borrowed by the resulting expression.
    type(expression_type) :: expr
  end function div_int16_var

  module function div_int16_expr(a, b) result(expr)
    !! Return a deferred div expression with a left int16 scalar.
    integer(int16), intent(in) :: a
    !! Left scalar stored by value in the resulting expression.
    type(expression_type), intent(in) :: b
    !! Right expression copied into the resulting tree.
    type(expression_type) :: expr
  end function div_int16_expr

  module function div_int32_var(a, b) result(expr)
    !! Return a deferred div expression with a left int32 scalar.
    integer(int32), intent(in) :: a
    !! Left scalar stored by value in the resulting expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable borrowed by the resulting expression.
    type(expression_type) :: expr
  end function div_int32_var

  module function div_int32_expr(a, b) result(expr)
    !! Return a deferred div expression with a left int32 scalar.
    integer(int32), intent(in) :: a
    !! Left scalar stored by value in the resulting expression.
    type(expression_type), intent(in) :: b
    !! Right expression copied into the resulting tree.
    type(expression_type) :: expr
  end function div_int32_expr

  module function div_int64_var(a, b) result(expr)
    !! Return a deferred div expression with a left int64 scalar.
    integer(int64), intent(in) :: a
    !! Left scalar stored by value in the resulting expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable borrowed by the resulting expression.
    type(expression_type) :: expr
  end function div_int64_var

  module function div_int64_expr(a, b) result(expr)
    !! Return a deferred div expression with a left int64 scalar.
    integer(int64), intent(in) :: a
    !! Left scalar stored by value in the resulting expression.
    type(expression_type), intent(in) :: b
    !! Right expression copied into the resulting tree.
    type(expression_type) :: expr
  end function div_int64_expr

  module function div_real32_var(a, b) result(expr)
    !! Return a deferred div expression with a left real32 scalar.
    real(real32), intent(in) :: a
    !! Left scalar stored by value in the resulting expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable borrowed by the resulting expression.
    type(expression_type) :: expr
  end function div_real32_var

  module function div_real32_expr(a, b) result(expr)
    !! Return a deferred div expression with a left real32 scalar.
    real(real32), intent(in) :: a
    !! Left scalar stored by value in the resulting expression.
    type(expression_type), intent(in) :: b
    !! Right expression copied into the resulting tree.
    type(expression_type) :: expr
  end function div_real32_expr

  module function div_real64_var(a, b) result(expr)
    !! Return a deferred div expression with a left real64 scalar.
    real(real64), intent(in) :: a
    !! Left scalar stored by value in the resulting expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable borrowed by the resulting expression.
    type(expression_type) :: expr
  end function div_real64_var

  module function div_real64_expr(a, b) result(expr)
    !! Return a deferred div expression with a left real64 scalar.
    real(real64), intent(in) :: a
    !! Left scalar stored by value in the resulting expression.
    type(expression_type), intent(in) :: b
    !! Right expression copied into the resulting tree.
    type(expression_type) :: expr
  end function div_real64_expr

  module function add_var_int8(a, b) result(expr)
    !! Return a deferred add expression with a right int8 scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable borrowed by the resulting expression.
    integer(int8), intent(in) :: b
    !! Right scalar stored by value in the resulting expression.
    type(expression_type) :: expr
  end function add_var_int8

  module function add_expr_int8(a, b) result(expr)
    !! Return a deferred add expression with a right int8 scalar.
    type(expression_type), intent(in) :: a
    !! Left expression copied into the resulting tree.
    integer(int8), intent(in) :: b
    !! Right scalar stored by value in the resulting expression.
    type(expression_type) :: expr
  end function add_expr_int8

  module function add_var_int16(a, b) result(expr)
    !! Return a deferred add expression with a right int16 scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable borrowed by the resulting expression.
    integer(int16), intent(in) :: b
    !! Right scalar stored by value in the resulting expression.
    type(expression_type) :: expr
  end function add_var_int16

  module function add_expr_int16(a, b) result(expr)
    !! Return a deferred add expression with a right int16 scalar.
    type(expression_type), intent(in) :: a
    !! Left expression copied into the resulting tree.
    integer(int16), intent(in) :: b
    !! Right scalar stored by value in the resulting expression.
    type(expression_type) :: expr
  end function add_expr_int16

  module function add_var_int32(a, b) result(expr)
    !! Return a deferred add expression with a right int32 scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable borrowed by the resulting expression.
    integer(int32), intent(in) :: b
    !! Right scalar stored by value in the resulting expression.
    type(expression_type) :: expr
  end function add_var_int32

  module function add_expr_int32(a, b) result(expr)
    !! Return a deferred add expression with a right int32 scalar.
    type(expression_type), intent(in) :: a
    !! Left expression copied into the resulting tree.
    integer(int32), intent(in) :: b
    !! Right scalar stored by value in the resulting expression.
    type(expression_type) :: expr
  end function add_expr_int32

  module function add_var_int64(a, b) result(expr)
    !! Return a deferred add expression with a right int64 scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable borrowed by the resulting expression.
    integer(int64), intent(in) :: b
    !! Right scalar stored by value in the resulting expression.
    type(expression_type) :: expr
  end function add_var_int64

  module function add_expr_int64(a, b) result(expr)
    !! Return a deferred add expression with a right int64 scalar.
    type(expression_type), intent(in) :: a
    !! Left expression copied into the resulting tree.
    integer(int64), intent(in) :: b
    !! Right scalar stored by value in the resulting expression.
    type(expression_type) :: expr
  end function add_expr_int64

  module function add_var_real32(a, b) result(expr)
    !! Return a deferred add expression with a right real32 scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable borrowed by the resulting expression.
    real(real32), intent(in) :: b
    !! Right scalar stored by value in the resulting expression.
    type(expression_type) :: expr
  end function add_var_real32

  module function add_expr_real32(a, b) result(expr)
    !! Return a deferred add expression with a right real32 scalar.
    type(expression_type), intent(in) :: a
    !! Left expression copied into the resulting tree.
    real(real32), intent(in) :: b
    !! Right scalar stored by value in the resulting expression.
    type(expression_type) :: expr
  end function add_expr_real32

  module function add_var_real64(a, b) result(expr)
    !! Return a deferred add expression with a right real64 scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable borrowed by the resulting expression.
    real(real64), intent(in) :: b
    !! Right scalar stored by value in the resulting expression.
    type(expression_type) :: expr
  end function add_var_real64

  module function add_expr_real64(a, b) result(expr)
    !! Return a deferred add expression with a right real64 scalar.
    type(expression_type), intent(in) :: a
    !! Left expression copied into the resulting tree.
    real(real64), intent(in) :: b
    !! Right scalar stored by value in the resulting expression.
    type(expression_type) :: expr
  end function add_expr_real64

  module function sub_var_int8(a, b) result(expr)
    !! Return a deferred sub expression with a right int8 scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable borrowed by the resulting expression.
    integer(int8), intent(in) :: b
    !! Right scalar stored by value in the resulting expression.
    type(expression_type) :: expr
  end function sub_var_int8

  module function sub_expr_int8(a, b) result(expr)
    !! Return a deferred sub expression with a right int8 scalar.
    type(expression_type), intent(in) :: a
    !! Left expression copied into the resulting tree.
    integer(int8), intent(in) :: b
    !! Right scalar stored by value in the resulting expression.
    type(expression_type) :: expr
  end function sub_expr_int8

  module function sub_var_int16(a, b) result(expr)
    !! Return a deferred sub expression with a right int16 scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable borrowed by the resulting expression.
    integer(int16), intent(in) :: b
    !! Right scalar stored by value in the resulting expression.
    type(expression_type) :: expr
  end function sub_var_int16

  module function sub_expr_int16(a, b) result(expr)
    !! Return a deferred sub expression with a right int16 scalar.
    type(expression_type), intent(in) :: a
    !! Left expression copied into the resulting tree.
    integer(int16), intent(in) :: b
    !! Right scalar stored by value in the resulting expression.
    type(expression_type) :: expr
  end function sub_expr_int16

  module function sub_var_int32(a, b) result(expr)
    !! Return a deferred sub expression with a right int32 scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable borrowed by the resulting expression.
    integer(int32), intent(in) :: b
    !! Right scalar stored by value in the resulting expression.
    type(expression_type) :: expr
  end function sub_var_int32

  module function sub_expr_int32(a, b) result(expr)
    !! Return a deferred sub expression with a right int32 scalar.
    type(expression_type), intent(in) :: a
    !! Left expression copied into the resulting tree.
    integer(int32), intent(in) :: b
    !! Right scalar stored by value in the resulting expression.
    type(expression_type) :: expr
  end function sub_expr_int32

  module function sub_var_int64(a, b) result(expr)
    !! Return a deferred sub expression with a right int64 scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable borrowed by the resulting expression.
    integer(int64), intent(in) :: b
    !! Right scalar stored by value in the resulting expression.
    type(expression_type) :: expr
  end function sub_var_int64

  module function sub_expr_int64(a, b) result(expr)
    !! Return a deferred sub expression with a right int64 scalar.
    type(expression_type), intent(in) :: a
    !! Left expression copied into the resulting tree.
    integer(int64), intent(in) :: b
    !! Right scalar stored by value in the resulting expression.
    type(expression_type) :: expr
  end function sub_expr_int64

  module function sub_var_real32(a, b) result(expr)
    !! Return a deferred sub expression with a right real32 scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable borrowed by the resulting expression.
    real(real32), intent(in) :: b
    !! Right scalar stored by value in the resulting expression.
    type(expression_type) :: expr
  end function sub_var_real32

  module function sub_expr_real32(a, b) result(expr)
    !! Return a deferred sub expression with a right real32 scalar.
    type(expression_type), intent(in) :: a
    !! Left expression copied into the resulting tree.
    real(real32), intent(in) :: b
    !! Right scalar stored by value in the resulting expression.
    type(expression_type) :: expr
  end function sub_expr_real32

  module function sub_var_real64(a, b) result(expr)
    !! Return a deferred sub expression with a right real64 scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable borrowed by the resulting expression.
    real(real64), intent(in) :: b
    !! Right scalar stored by value in the resulting expression.
    type(expression_type) :: expr
  end function sub_var_real64

  module function sub_expr_real64(a, b) result(expr)
    !! Return a deferred sub expression with a right real64 scalar.
    type(expression_type), intent(in) :: a
    !! Left expression copied into the resulting tree.
    real(real64), intent(in) :: b
    !! Right scalar stored by value in the resulting expression.
    type(expression_type) :: expr
  end function sub_expr_real64

  module function mul_var_int8(a, b) result(expr)
    !! Return a deferred mul expression with a right int8 scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable borrowed by the resulting expression.
    integer(int8), intent(in) :: b
    !! Right scalar stored by value in the resulting expression.
    type(expression_type) :: expr
  end function mul_var_int8

  module function mul_expr_int8(a, b) result(expr)
    !! Return a deferred mul expression with a right int8 scalar.
    type(expression_type), intent(in) :: a
    !! Left expression copied into the resulting tree.
    integer(int8), intent(in) :: b
    !! Right scalar stored by value in the resulting expression.
    type(expression_type) :: expr
  end function mul_expr_int8

  module function mul_var_int16(a, b) result(expr)
    !! Return a deferred mul expression with a right int16 scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable borrowed by the resulting expression.
    integer(int16), intent(in) :: b
    !! Right scalar stored by value in the resulting expression.
    type(expression_type) :: expr
  end function mul_var_int16

  module function mul_expr_int16(a, b) result(expr)
    !! Return a deferred mul expression with a right int16 scalar.
    type(expression_type), intent(in) :: a
    !! Left expression copied into the resulting tree.
    integer(int16), intent(in) :: b
    !! Right scalar stored by value in the resulting expression.
    type(expression_type) :: expr
  end function mul_expr_int16

  module function mul_var_int32(a, b) result(expr)
    !! Return a deferred mul expression with a right int32 scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable borrowed by the resulting expression.
    integer(int32), intent(in) :: b
    !! Right scalar stored by value in the resulting expression.
    type(expression_type) :: expr
  end function mul_var_int32

  module function mul_expr_int32(a, b) result(expr)
    !! Return a deferred mul expression with a right int32 scalar.
    type(expression_type), intent(in) :: a
    !! Left expression copied into the resulting tree.
    integer(int32), intent(in) :: b
    !! Right scalar stored by value in the resulting expression.
    type(expression_type) :: expr
  end function mul_expr_int32

  module function mul_var_int64(a, b) result(expr)
    !! Return a deferred mul expression with a right int64 scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable borrowed by the resulting expression.
    integer(int64), intent(in) :: b
    !! Right scalar stored by value in the resulting expression.
    type(expression_type) :: expr
  end function mul_var_int64

  module function mul_expr_int64(a, b) result(expr)
    !! Return a deferred mul expression with a right int64 scalar.
    type(expression_type), intent(in) :: a
    !! Left expression copied into the resulting tree.
    integer(int64), intent(in) :: b
    !! Right scalar stored by value in the resulting expression.
    type(expression_type) :: expr
  end function mul_expr_int64

  module function mul_var_real32(a, b) result(expr)
    !! Return a deferred mul expression with a right real32 scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable borrowed by the resulting expression.
    real(real32), intent(in) :: b
    !! Right scalar stored by value in the resulting expression.
    type(expression_type) :: expr
  end function mul_var_real32

  module function mul_expr_real32(a, b) result(expr)
    !! Return a deferred mul expression with a right real32 scalar.
    type(expression_type), intent(in) :: a
    !! Left expression copied into the resulting tree.
    real(real32), intent(in) :: b
    !! Right scalar stored by value in the resulting expression.
    type(expression_type) :: expr
  end function mul_expr_real32

  module function mul_var_real64(a, b) result(expr)
    !! Return a deferred mul expression with a right real64 scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable borrowed by the resulting expression.
    real(real64), intent(in) :: b
    !! Right scalar stored by value in the resulting expression.
    type(expression_type) :: expr
  end function mul_var_real64

  module function mul_expr_real64(a, b) result(expr)
    !! Return a deferred mul expression with a right real64 scalar.
    type(expression_type), intent(in) :: a
    !! Left expression copied into the resulting tree.
    real(real64), intent(in) :: b
    !! Right scalar stored by value in the resulting expression.
    type(expression_type) :: expr
  end function mul_expr_real64

  module function div_var_int8(a, b) result(expr)
    !! Return a deferred div expression with a right int8 scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable borrowed by the resulting expression.
    integer(int8), intent(in) :: b
    !! Right scalar stored by value in the resulting expression.
    type(expression_type) :: expr
  end function div_var_int8

  module function div_expr_int8(a, b) result(expr)
    !! Return a deferred div expression with a right int8 scalar.
    type(expression_type), intent(in) :: a
    !! Left expression copied into the resulting tree.
    integer(int8), intent(in) :: b
    !! Right scalar stored by value in the resulting expression.
    type(expression_type) :: expr
  end function div_expr_int8

  module function div_var_int16(a, b) result(expr)
    !! Return a deferred div expression with a right int16 scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable borrowed by the resulting expression.
    integer(int16), intent(in) :: b
    !! Right scalar stored by value in the resulting expression.
    type(expression_type) :: expr
  end function div_var_int16

  module function div_expr_int16(a, b) result(expr)
    !! Return a deferred div expression with a right int16 scalar.
    type(expression_type), intent(in) :: a
    !! Left expression copied into the resulting tree.
    integer(int16), intent(in) :: b
    !! Right scalar stored by value in the resulting expression.
    type(expression_type) :: expr
  end function div_expr_int16

  module function div_var_int32(a, b) result(expr)
    !! Return a deferred div expression with a right int32 scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable borrowed by the resulting expression.
    integer(int32), intent(in) :: b
    !! Right scalar stored by value in the resulting expression.
    type(expression_type) :: expr
  end function div_var_int32

  module function div_expr_int32(a, b) result(expr)
    !! Return a deferred div expression with a right int32 scalar.
    type(expression_type), intent(in) :: a
    !! Left expression copied into the resulting tree.
    integer(int32), intent(in) :: b
    !! Right scalar stored by value in the resulting expression.
    type(expression_type) :: expr
  end function div_expr_int32

  module function div_var_int64(a, b) result(expr)
    !! Return a deferred div expression with a right int64 scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable borrowed by the resulting expression.
    integer(int64), intent(in) :: b
    !! Right scalar stored by value in the resulting expression.
    type(expression_type) :: expr
  end function div_var_int64

  module function div_expr_int64(a, b) result(expr)
    !! Return a deferred div expression with a right int64 scalar.
    type(expression_type), intent(in) :: a
    !! Left expression copied into the resulting tree.
    integer(int64), intent(in) :: b
    !! Right scalar stored by value in the resulting expression.
    type(expression_type) :: expr
  end function div_expr_int64

  module function div_var_real32(a, b) result(expr)
    !! Return a deferred div expression with a right real32 scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable borrowed by the resulting expression.
    real(real32), intent(in) :: b
    !! Right scalar stored by value in the resulting expression.
    type(expression_type) :: expr
  end function div_var_real32

  module function div_expr_real32(a, b) result(expr)
    !! Return a deferred div expression with a right real32 scalar.
    type(expression_type), intent(in) :: a
    !! Left expression copied into the resulting tree.
    real(real32), intent(in) :: b
    !! Right scalar stored by value in the resulting expression.
    type(expression_type) :: expr
  end function div_expr_real32

  module function div_var_real64(a, b) result(expr)
    !! Return a deferred div expression with a right real64 scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable borrowed by the resulting expression.
    real(real64), intent(in) :: b
    !! Right scalar stored by value in the resulting expression.
    type(expression_type) :: expr
  end function div_var_real64

  module function div_expr_real64(a, b) result(expr)
    !! Return a deferred div expression with a right real64 scalar.
    type(expression_type), intent(in) :: a
    !! Left expression copied into the resulting tree.
    real(real64), intent(in) :: b
    !! Right scalar stored by value in the resulting expression.
    type(expression_type) :: expr
  end function div_expr_real64
end interface
