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
    type(variable_type), target, intent(in) :: a
    type(variable_type), target, intent(in) :: b
    type(expression_type) :: expr
  end function add_var_var

  module function add_var_expr(a, b) result(expr)
    type(variable_type), target, intent(in) :: a
    type(expression_type), intent(in) :: b
    type(expression_type) :: expr
  end function add_var_expr

  module function add_expr_var(a, b) result(expr)
    type(expression_type), intent(in) :: a
    type(variable_type), target, intent(in) :: b
    type(expression_type) :: expr
  end function add_expr_var

  module function add_expr_expr(a, b) result(expr)
    type(expression_type), intent(in) :: a
    type(expression_type), intent(in) :: b
    type(expression_type) :: expr
  end function add_expr_expr

  module function sub_var_var(a, b) result(expr)
    type(variable_type), target, intent(in) :: a
    type(variable_type), target, intent(in) :: b
    type(expression_type) :: expr
  end function sub_var_var

  module function sub_var_expr(a, b) result(expr)
    type(variable_type), target, intent(in) :: a
    type(expression_type), intent(in) :: b
    type(expression_type) :: expr
  end function sub_var_expr

  module function sub_expr_var(a, b) result(expr)
    type(expression_type), intent(in) :: a
    type(variable_type), target, intent(in) :: b
    type(expression_type) :: expr
  end function sub_expr_var

  module function sub_expr_expr(a, b) result(expr)
    type(expression_type), intent(in) :: a
    type(expression_type), intent(in) :: b
    type(expression_type) :: expr
  end function sub_expr_expr

  module function mul_var_var(a, b) result(expr)
    type(variable_type), target, intent(in) :: a
    type(variable_type), target, intent(in) :: b
    type(expression_type) :: expr
  end function mul_var_var

  module function mul_var_expr(a, b) result(expr)
    type(variable_type), target, intent(in) :: a
    type(expression_type), intent(in) :: b
    type(expression_type) :: expr
  end function mul_var_expr

  module function mul_expr_var(a, b) result(expr)
    type(expression_type), intent(in) :: a
    type(variable_type), target, intent(in) :: b
    type(expression_type) :: expr
  end function mul_expr_var

  module function mul_expr_expr(a, b) result(expr)
    type(expression_type), intent(in) :: a
    type(expression_type), intent(in) :: b
    type(expression_type) :: expr
  end function mul_expr_expr

  module function div_var_var(a, b) result(expr)
    type(variable_type), target, intent(in) :: a
    type(variable_type), target, intent(in) :: b
    type(expression_type) :: expr
  end function div_var_var

  module function div_var_expr(a, b) result(expr)
    type(variable_type), target, intent(in) :: a
    type(expression_type), intent(in) :: b
    type(expression_type) :: expr
  end function div_var_expr

  module function div_expr_var(a, b) result(expr)
    type(expression_type), intent(in) :: a
    type(variable_type), target, intent(in) :: b
    type(expression_type) :: expr
  end function div_expr_var

  module function div_expr_expr(a, b) result(expr)
    type(expression_type), intent(in) :: a
    type(expression_type), intent(in) :: b
    type(expression_type) :: expr
  end function div_expr_expr

  module function pow_var_var(a, b) result(expr)
    type(variable_type), target, intent(in) :: a
    type(variable_type), target, intent(in) :: b
    type(expression_type) :: expr
  end function pow_var_var

  module function pow_var_expr(a, b) result(expr)
    type(variable_type), target, intent(in) :: a
    type(expression_type), intent(in) :: b
    type(expression_type) :: expr
  end function pow_var_expr

  module function pow_expr_var(a, b) result(expr)
    type(expression_type), intent(in) :: a
    type(variable_type), target, intent(in) :: b
    type(expression_type) :: expr
  end function pow_expr_var

  module function pow_expr_expr(a, b) result(expr)
    type(expression_type), intent(in) :: a
    type(expression_type), intent(in) :: b
    type(expression_type) :: expr
  end function pow_expr_expr

  module function pow_var_int8(a, exponent) result(expr)
    type(variable_type), target, intent(in) :: a
    integer(int8), intent(in) :: exponent
    type(expression_type) :: expr
  end function pow_var_int8

  module function pow_expr_int8(a, exponent) result(expr)
    type(expression_type), intent(in) :: a
    integer(int8), intent(in) :: exponent
    type(expression_type) :: expr
  end function pow_expr_int8

  module function pow_var_int16(a, exponent) result(expr)
    type(variable_type), target, intent(in) :: a
    integer(int16), intent(in) :: exponent
    type(expression_type) :: expr
  end function pow_var_int16

  module function pow_expr_int16(a, exponent) result(expr)
    type(expression_type), intent(in) :: a
    integer(int16), intent(in) :: exponent
    type(expression_type) :: expr
  end function pow_expr_int16

  module function pow_var_int32(a, exponent) result(expr)
    type(variable_type), target, intent(in) :: a
    integer(int32), intent(in) :: exponent
    type(expression_type) :: expr
  end function pow_var_int32

  module function pow_expr_int32(a, exponent) result(expr)
    type(expression_type), intent(in) :: a
    integer(int32), intent(in) :: exponent
    type(expression_type) :: expr
  end function pow_expr_int32

  module function pow_var_int64(a, exponent) result(expr)
    type(variable_type), target, intent(in) :: a
    integer(int64), intent(in) :: exponent
    type(expression_type) :: expr
  end function pow_var_int64

  module function pow_expr_int64(a, exponent) result(expr)
    type(expression_type), intent(in) :: a
    integer(int64), intent(in) :: exponent
    type(expression_type) :: expr
  end function pow_expr_int64

  module function pow_var_real32(a, exponent) result(expr)
    type(variable_type), target, intent(in) :: a
    real(real32), intent(in) :: exponent
    type(expression_type) :: expr
  end function pow_var_real32

  module function pow_expr_real32(a, exponent) result(expr)
    type(expression_type), intent(in) :: a
    real(real32), intent(in) :: exponent
    type(expression_type) :: expr
  end function pow_expr_real32

  module function pow_var_real64(a, exponent) result(expr)
    type(variable_type), target, intent(in) :: a
    real(real64), intent(in) :: exponent
    type(expression_type) :: expr
  end function pow_var_real64

  module function pow_expr_real64(a, exponent) result(expr)
    type(expression_type), intent(in) :: a
    real(real64), intent(in) :: exponent
    type(expression_type) :: expr
  end function pow_expr_real64

  module function add_int8_var(a, b) result(expr)
    integer(int8), intent(in) :: a
    type(variable_type), target, intent(in) :: b
    type(expression_type) :: expr
  end function add_int8_var

  module function add_int8_expr(a, b) result(expr)
    integer(int8), intent(in) :: a
    type(expression_type), intent(in) :: b
    type(expression_type) :: expr
  end function add_int8_expr

  module function add_int16_var(a, b) result(expr)
    integer(int16), intent(in) :: a
    type(variable_type), target, intent(in) :: b
    type(expression_type) :: expr
  end function add_int16_var

  module function add_int16_expr(a, b) result(expr)
    integer(int16), intent(in) :: a
    type(expression_type), intent(in) :: b
    type(expression_type) :: expr
  end function add_int16_expr

  module function add_int32_var(a, b) result(expr)
    integer(int32), intent(in) :: a
    type(variable_type), target, intent(in) :: b
    type(expression_type) :: expr
  end function add_int32_var

  module function add_int32_expr(a, b) result(expr)
    integer(int32), intent(in) :: a
    type(expression_type), intent(in) :: b
    type(expression_type) :: expr
  end function add_int32_expr

  module function add_int64_var(a, b) result(expr)
    integer(int64), intent(in) :: a
    type(variable_type), target, intent(in) :: b
    type(expression_type) :: expr
  end function add_int64_var

  module function add_int64_expr(a, b) result(expr)
    integer(int64), intent(in) :: a
    type(expression_type), intent(in) :: b
    type(expression_type) :: expr
  end function add_int64_expr

  module function add_real32_var(a, b) result(expr)
    real(real32), intent(in) :: a
    type(variable_type), target, intent(in) :: b
    type(expression_type) :: expr
  end function add_real32_var

  module function add_real32_expr(a, b) result(expr)
    real(real32), intent(in) :: a
    type(expression_type), intent(in) :: b
    type(expression_type) :: expr
  end function add_real32_expr

  module function add_real64_var(a, b) result(expr)
    real(real64), intent(in) :: a
    type(variable_type), target, intent(in) :: b
    type(expression_type) :: expr
  end function add_real64_var

  module function add_real64_expr(a, b) result(expr)
    real(real64), intent(in) :: a
    type(expression_type), intent(in) :: b
    type(expression_type) :: expr
  end function add_real64_expr

  module function sub_int8_var(a, b) result(expr)
    integer(int8), intent(in) :: a
    type(variable_type), target, intent(in) :: b
    type(expression_type) :: expr
  end function sub_int8_var

  module function sub_int8_expr(a, b) result(expr)
    integer(int8), intent(in) :: a
    type(expression_type), intent(in) :: b
    type(expression_type) :: expr
  end function sub_int8_expr

  module function sub_int16_var(a, b) result(expr)
    integer(int16), intent(in) :: a
    type(variable_type), target, intent(in) :: b
    type(expression_type) :: expr
  end function sub_int16_var

  module function sub_int16_expr(a, b) result(expr)
    integer(int16), intent(in) :: a
    type(expression_type), intent(in) :: b
    type(expression_type) :: expr
  end function sub_int16_expr

  module function sub_int32_var(a, b) result(expr)
    integer(int32), intent(in) :: a
    type(variable_type), target, intent(in) :: b
    type(expression_type) :: expr
  end function sub_int32_var

  module function sub_int32_expr(a, b) result(expr)
    integer(int32), intent(in) :: a
    type(expression_type), intent(in) :: b
    type(expression_type) :: expr
  end function sub_int32_expr

  module function sub_int64_var(a, b) result(expr)
    integer(int64), intent(in) :: a
    type(variable_type), target, intent(in) :: b
    type(expression_type) :: expr
  end function sub_int64_var

  module function sub_int64_expr(a, b) result(expr)
    integer(int64), intent(in) :: a
    type(expression_type), intent(in) :: b
    type(expression_type) :: expr
  end function sub_int64_expr

  module function sub_real32_var(a, b) result(expr)
    real(real32), intent(in) :: a
    type(variable_type), target, intent(in) :: b
    type(expression_type) :: expr
  end function sub_real32_var

  module function sub_real32_expr(a, b) result(expr)
    real(real32), intent(in) :: a
    type(expression_type), intent(in) :: b
    type(expression_type) :: expr
  end function sub_real32_expr

  module function sub_real64_var(a, b) result(expr)
    real(real64), intent(in) :: a
    type(variable_type), target, intent(in) :: b
    type(expression_type) :: expr
  end function sub_real64_var

  module function sub_real64_expr(a, b) result(expr)
    real(real64), intent(in) :: a
    type(expression_type), intent(in) :: b
    type(expression_type) :: expr
  end function sub_real64_expr

  module function mul_int8_var(a, b) result(expr)
    integer(int8), intent(in) :: a
    type(variable_type), target, intent(in) :: b
    type(expression_type) :: expr
  end function mul_int8_var

  module function mul_int8_expr(a, b) result(expr)
    integer(int8), intent(in) :: a
    type(expression_type), intent(in) :: b
    type(expression_type) :: expr
  end function mul_int8_expr

  module function mul_int16_var(a, b) result(expr)
    integer(int16), intent(in) :: a
    type(variable_type), target, intent(in) :: b
    type(expression_type) :: expr
  end function mul_int16_var

  module function mul_int16_expr(a, b) result(expr)
    integer(int16), intent(in) :: a
    type(expression_type), intent(in) :: b
    type(expression_type) :: expr
  end function mul_int16_expr

  module function mul_int32_var(a, b) result(expr)
    integer(int32), intent(in) :: a
    type(variable_type), target, intent(in) :: b
    type(expression_type) :: expr
  end function mul_int32_var

  module function mul_int32_expr(a, b) result(expr)
    integer(int32), intent(in) :: a
    type(expression_type), intent(in) :: b
    type(expression_type) :: expr
  end function mul_int32_expr

  module function mul_int64_var(a, b) result(expr)
    integer(int64), intent(in) :: a
    type(variable_type), target, intent(in) :: b
    type(expression_type) :: expr
  end function mul_int64_var

  module function mul_int64_expr(a, b) result(expr)
    integer(int64), intent(in) :: a
    type(expression_type), intent(in) :: b
    type(expression_type) :: expr
  end function mul_int64_expr

  module function mul_real32_var(a, b) result(expr)
    real(real32), intent(in) :: a
    type(variable_type), target, intent(in) :: b
    type(expression_type) :: expr
  end function mul_real32_var

  module function mul_real32_expr(a, b) result(expr)
    real(real32), intent(in) :: a
    type(expression_type), intent(in) :: b
    type(expression_type) :: expr
  end function mul_real32_expr

  module function mul_real64_var(a, b) result(expr)
    real(real64), intent(in) :: a
    type(variable_type), target, intent(in) :: b
    type(expression_type) :: expr
  end function mul_real64_var

  module function mul_real64_expr(a, b) result(expr)
    real(real64), intent(in) :: a
    type(expression_type), intent(in) :: b
    type(expression_type) :: expr
  end function mul_real64_expr

  module function div_int8_var(a, b) result(expr)
    integer(int8), intent(in) :: a
    type(variable_type), target, intent(in) :: b
    type(expression_type) :: expr
  end function div_int8_var

  module function div_int8_expr(a, b) result(expr)
    integer(int8), intent(in) :: a
    type(expression_type), intent(in) :: b
    type(expression_type) :: expr
  end function div_int8_expr

  module function div_int16_var(a, b) result(expr)
    integer(int16), intent(in) :: a
    type(variable_type), target, intent(in) :: b
    type(expression_type) :: expr
  end function div_int16_var

  module function div_int16_expr(a, b) result(expr)
    integer(int16), intent(in) :: a
    type(expression_type), intent(in) :: b
    type(expression_type) :: expr
  end function div_int16_expr

  module function div_int32_var(a, b) result(expr)
    integer(int32), intent(in) :: a
    type(variable_type), target, intent(in) :: b
    type(expression_type) :: expr
  end function div_int32_var

  module function div_int32_expr(a, b) result(expr)
    integer(int32), intent(in) :: a
    type(expression_type), intent(in) :: b
    type(expression_type) :: expr
  end function div_int32_expr

  module function div_int64_var(a, b) result(expr)
    integer(int64), intent(in) :: a
    type(variable_type), target, intent(in) :: b
    type(expression_type) :: expr
  end function div_int64_var

  module function div_int64_expr(a, b) result(expr)
    integer(int64), intent(in) :: a
    type(expression_type), intent(in) :: b
    type(expression_type) :: expr
  end function div_int64_expr

  module function div_real32_var(a, b) result(expr)
    real(real32), intent(in) :: a
    type(variable_type), target, intent(in) :: b
    type(expression_type) :: expr
  end function div_real32_var

  module function div_real32_expr(a, b) result(expr)
    real(real32), intent(in) :: a
    type(expression_type), intent(in) :: b
    type(expression_type) :: expr
  end function div_real32_expr

  module function div_real64_var(a, b) result(expr)
    real(real64), intent(in) :: a
    type(variable_type), target, intent(in) :: b
    type(expression_type) :: expr
  end function div_real64_var

  module function div_real64_expr(a, b) result(expr)
    real(real64), intent(in) :: a
    type(expression_type), intent(in) :: b
    type(expression_type) :: expr
  end function div_real64_expr

  module function add_var_int8(a, b) result(expr)
    type(variable_type), target, intent(in) :: a
    integer(int8), intent(in) :: b
    type(expression_type) :: expr
  end function add_var_int8

  module function add_expr_int8(a, b) result(expr)
    type(expression_type), intent(in) :: a
    integer(int8), intent(in) :: b
    type(expression_type) :: expr
  end function add_expr_int8

  module function add_var_int16(a, b) result(expr)
    type(variable_type), target, intent(in) :: a
    integer(int16), intent(in) :: b
    type(expression_type) :: expr
  end function add_var_int16

  module function add_expr_int16(a, b) result(expr)
    type(expression_type), intent(in) :: a
    integer(int16), intent(in) :: b
    type(expression_type) :: expr
  end function add_expr_int16

  module function add_var_int32(a, b) result(expr)
    type(variable_type), target, intent(in) :: a
    integer(int32), intent(in) :: b
    type(expression_type) :: expr
  end function add_var_int32

  module function add_expr_int32(a, b) result(expr)
    type(expression_type), intent(in) :: a
    integer(int32), intent(in) :: b
    type(expression_type) :: expr
  end function add_expr_int32

  module function add_var_int64(a, b) result(expr)
    type(variable_type), target, intent(in) :: a
    integer(int64), intent(in) :: b
    type(expression_type) :: expr
  end function add_var_int64

  module function add_expr_int64(a, b) result(expr)
    type(expression_type), intent(in) :: a
    integer(int64), intent(in) :: b
    type(expression_type) :: expr
  end function add_expr_int64

  module function add_var_real32(a, b) result(expr)
    type(variable_type), target, intent(in) :: a
    real(real32), intent(in) :: b
    type(expression_type) :: expr
  end function add_var_real32

  module function add_expr_real32(a, b) result(expr)
    type(expression_type), intent(in) :: a
    real(real32), intent(in) :: b
    type(expression_type) :: expr
  end function add_expr_real32

  module function add_var_real64(a, b) result(expr)
    type(variable_type), target, intent(in) :: a
    real(real64), intent(in) :: b
    type(expression_type) :: expr
  end function add_var_real64

  module function add_expr_real64(a, b) result(expr)
    type(expression_type), intent(in) :: a
    real(real64), intent(in) :: b
    type(expression_type) :: expr
  end function add_expr_real64

  module function sub_var_int8(a, b) result(expr)
    type(variable_type), target, intent(in) :: a
    integer(int8), intent(in) :: b
    type(expression_type) :: expr
  end function sub_var_int8

  module function sub_expr_int8(a, b) result(expr)
    type(expression_type), intent(in) :: a
    integer(int8), intent(in) :: b
    type(expression_type) :: expr
  end function sub_expr_int8

  module function sub_var_int16(a, b) result(expr)
    type(variable_type), target, intent(in) :: a
    integer(int16), intent(in) :: b
    type(expression_type) :: expr
  end function sub_var_int16

  module function sub_expr_int16(a, b) result(expr)
    type(expression_type), intent(in) :: a
    integer(int16), intent(in) :: b
    type(expression_type) :: expr
  end function sub_expr_int16

  module function sub_var_int32(a, b) result(expr)
    type(variable_type), target, intent(in) :: a
    integer(int32), intent(in) :: b
    type(expression_type) :: expr
  end function sub_var_int32

  module function sub_expr_int32(a, b) result(expr)
    type(expression_type), intent(in) :: a
    integer(int32), intent(in) :: b
    type(expression_type) :: expr
  end function sub_expr_int32

  module function sub_var_int64(a, b) result(expr)
    type(variable_type), target, intent(in) :: a
    integer(int64), intent(in) :: b
    type(expression_type) :: expr
  end function sub_var_int64

  module function sub_expr_int64(a, b) result(expr)
    type(expression_type), intent(in) :: a
    integer(int64), intent(in) :: b
    type(expression_type) :: expr
  end function sub_expr_int64

  module function sub_var_real32(a, b) result(expr)
    type(variable_type), target, intent(in) :: a
    real(real32), intent(in) :: b
    type(expression_type) :: expr
  end function sub_var_real32

  module function sub_expr_real32(a, b) result(expr)
    type(expression_type), intent(in) :: a
    real(real32), intent(in) :: b
    type(expression_type) :: expr
  end function sub_expr_real32

  module function sub_var_real64(a, b) result(expr)
    type(variable_type), target, intent(in) :: a
    real(real64), intent(in) :: b
    type(expression_type) :: expr
  end function sub_var_real64

  module function sub_expr_real64(a, b) result(expr)
    type(expression_type), intent(in) :: a
    real(real64), intent(in) :: b
    type(expression_type) :: expr
  end function sub_expr_real64

  module function mul_var_int8(a, b) result(expr)
    type(variable_type), target, intent(in) :: a
    integer(int8), intent(in) :: b
    type(expression_type) :: expr
  end function mul_var_int8

  module function mul_expr_int8(a, b) result(expr)
    type(expression_type), intent(in) :: a
    integer(int8), intent(in) :: b
    type(expression_type) :: expr
  end function mul_expr_int8

  module function mul_var_int16(a, b) result(expr)
    type(variable_type), target, intent(in) :: a
    integer(int16), intent(in) :: b
    type(expression_type) :: expr
  end function mul_var_int16

  module function mul_expr_int16(a, b) result(expr)
    type(expression_type), intent(in) :: a
    integer(int16), intent(in) :: b
    type(expression_type) :: expr
  end function mul_expr_int16

  module function mul_var_int32(a, b) result(expr)
    type(variable_type), target, intent(in) :: a
    integer(int32), intent(in) :: b
    type(expression_type) :: expr
  end function mul_var_int32

  module function mul_expr_int32(a, b) result(expr)
    type(expression_type), intent(in) :: a
    integer(int32), intent(in) :: b
    type(expression_type) :: expr
  end function mul_expr_int32

  module function mul_var_int64(a, b) result(expr)
    type(variable_type), target, intent(in) :: a
    integer(int64), intent(in) :: b
    type(expression_type) :: expr
  end function mul_var_int64

  module function mul_expr_int64(a, b) result(expr)
    type(expression_type), intent(in) :: a
    integer(int64), intent(in) :: b
    type(expression_type) :: expr
  end function mul_expr_int64

  module function mul_var_real32(a, b) result(expr)
    type(variable_type), target, intent(in) :: a
    real(real32), intent(in) :: b
    type(expression_type) :: expr
  end function mul_var_real32

  module function mul_expr_real32(a, b) result(expr)
    type(expression_type), intent(in) :: a
    real(real32), intent(in) :: b
    type(expression_type) :: expr
  end function mul_expr_real32

  module function mul_var_real64(a, b) result(expr)
    type(variable_type), target, intent(in) :: a
    real(real64), intent(in) :: b
    type(expression_type) :: expr
  end function mul_var_real64

  module function mul_expr_real64(a, b) result(expr)
    type(expression_type), intent(in) :: a
    real(real64), intent(in) :: b
    type(expression_type) :: expr
  end function mul_expr_real64

  module function div_var_int8(a, b) result(expr)
    type(variable_type), target, intent(in) :: a
    integer(int8), intent(in) :: b
    type(expression_type) :: expr
  end function div_var_int8

  module function div_expr_int8(a, b) result(expr)
    type(expression_type), intent(in) :: a
    integer(int8), intent(in) :: b
    type(expression_type) :: expr
  end function div_expr_int8

  module function div_var_int16(a, b) result(expr)
    type(variable_type), target, intent(in) :: a
    integer(int16), intent(in) :: b
    type(expression_type) :: expr
  end function div_var_int16

  module function div_expr_int16(a, b) result(expr)
    type(expression_type), intent(in) :: a
    integer(int16), intent(in) :: b
    type(expression_type) :: expr
  end function div_expr_int16

  module function div_var_int32(a, b) result(expr)
    type(variable_type), target, intent(in) :: a
    integer(int32), intent(in) :: b
    type(expression_type) :: expr
  end function div_var_int32

  module function div_expr_int32(a, b) result(expr)
    type(expression_type), intent(in) :: a
    integer(int32), intent(in) :: b
    type(expression_type) :: expr
  end function div_expr_int32

  module function div_var_int64(a, b) result(expr)
    type(variable_type), target, intent(in) :: a
    integer(int64), intent(in) :: b
    type(expression_type) :: expr
  end function div_var_int64

  module function div_expr_int64(a, b) result(expr)
    type(expression_type), intent(in) :: a
    integer(int64), intent(in) :: b
    type(expression_type) :: expr
  end function div_expr_int64

  module function div_var_real32(a, b) result(expr)
    type(variable_type), target, intent(in) :: a
    real(real32), intent(in) :: b
    type(expression_type) :: expr
  end function div_var_real32

  module function div_expr_real32(a, b) result(expr)
    type(expression_type), intent(in) :: a
    real(real32), intent(in) :: b
    type(expression_type) :: expr
  end function div_expr_real32

  module function div_var_real64(a, b) result(expr)
    type(variable_type), target, intent(in) :: a
    real(real64), intent(in) :: b
    type(expression_type) :: expr
  end function div_var_real64

  module function div_expr_real64(a, b) result(expr)
    type(expression_type), intent(in) :: a
    real(real64), intent(in) :: b
    type(expression_type) :: expr
  end function div_expr_real64
end interface
