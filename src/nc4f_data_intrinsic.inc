interface abs
  module procedure :: abs_var, abs_expr
end interface abs

interface sqrt
  module procedure :: sqrt_var, sqrt_expr
end interface sqrt

interface exp
  module procedure :: exp_var, exp_expr
end interface exp

interface log
  module procedure :: log_var, log_expr
end interface log

interface log10
  module procedure :: log10_var, log10_expr
end interface log10

interface sin
  module procedure :: sin_var, sin_expr
end interface sin

interface cos
  module procedure :: cos_var, cos_expr
end interface cos

interface tan
  module procedure :: tan_var, tan_expr
end interface tan

interface asin
  module procedure :: asin_var, asin_expr
end interface asin

interface acos
  module procedure :: acos_var, acos_expr
end interface acos

interface atan
  module procedure :: atan_var, atan_expr
  module procedure :: atan_var_var, atan_var_expr, &
    & atan_expr_var, atan_expr_expr
  module procedure :: atan_real32_var, atan_real32_expr
  module procedure :: atan_var_real32, atan_expr_real32
  module procedure :: atan_real64_var, atan_real64_expr
  module procedure :: atan_var_real64, atan_expr_real64
end interface atan

interface sinh
  module procedure :: sinh_var, sinh_expr
end interface sinh

interface cosh
  module procedure :: cosh_var, cosh_expr
end interface cosh

interface tanh
  module procedure :: tanh_var, tanh_expr
end interface tanh

interface asinh
  module procedure :: asinh_var, asinh_expr
end interface asinh

interface acosh
  module procedure :: acosh_var, acosh_expr
end interface acosh

interface atanh
  module procedure :: atanh_var, atanh_expr
end interface atanh

interface erf
  module procedure :: erf_var, erf_expr
end interface erf

interface erfc
  module procedure :: erfc_var, erfc_expr
end interface erfc

interface erfc_scaled
  module procedure :: erfc_scaled_var, erfc_scaled_expr
end interface erfc_scaled

interface gamma
  module procedure :: gamma_var, gamma_expr
end interface gamma

interface log_gamma
  module procedure :: log_gamma_var, log_gamma_expr
end interface log_gamma

interface bessel_j0
  module procedure :: bessel_j0_var, bessel_j0_expr
end interface bessel_j0

interface bessel_j1
  module procedure :: bessel_j1_var, bessel_j1_expr
end interface bessel_j1

interface bessel_y0
  module procedure :: bessel_y0_var, bessel_y0_expr
end interface bessel_y0

interface bessel_y1
  module procedure :: bessel_y1_var, bessel_y1_expr
end interface bessel_y1

!! ${NAME.upper()} builds a deferred element-wise expression.
interface dim
  module procedure :: dim_var_var, dim_var_expr, &
    & dim_expr_var, dim_expr_expr
  module procedure :: dim_int8_var, dim_int8_expr
  module procedure :: dim_var_int8, dim_expr_int8
  module procedure :: dim_int16_var, dim_int16_expr
  module procedure :: dim_var_int16, dim_expr_int16
  module procedure :: dim_int32_var, dim_int32_expr
  module procedure :: dim_var_int32, dim_expr_int32
  module procedure :: dim_int64_var, dim_int64_expr
  module procedure :: dim_var_int64, dim_expr_int64
  module procedure :: dim_real32_var, dim_real32_expr
  module procedure :: dim_var_real32, dim_expr_real32
  module procedure :: dim_real64_var, dim_real64_expr
  module procedure :: dim_var_real64, dim_expr_real64
end interface dim

!! ${NAME.upper()} builds a deferred element-wise expression.
interface sign
  module procedure :: sign_var_var, sign_var_expr, &
    & sign_expr_var, sign_expr_expr
  module procedure :: sign_int8_var, sign_int8_expr
  module procedure :: sign_var_int8, sign_expr_int8
  module procedure :: sign_int16_var, sign_int16_expr
  module procedure :: sign_var_int16, sign_expr_int16
  module procedure :: sign_int32_var, sign_int32_expr
  module procedure :: sign_var_int32, sign_expr_int32
  module procedure :: sign_int64_var, sign_int64_expr
  module procedure :: sign_var_int64, sign_expr_int64
  module procedure :: sign_real32_var, sign_real32_expr
  module procedure :: sign_var_real32, sign_expr_real32
  module procedure :: sign_real64_var, sign_real64_expr
  module procedure :: sign_var_real64, sign_expr_real64
end interface sign

!! ${NAME.upper()} builds a deferred element-wise expression.
interface mod
  module procedure :: mod_var_var, mod_var_expr, &
    & mod_expr_var, mod_expr_expr
  module procedure :: mod_int8_var, mod_int8_expr
  module procedure :: mod_var_int8, mod_expr_int8
  module procedure :: mod_int16_var, mod_int16_expr
  module procedure :: mod_var_int16, mod_expr_int16
  module procedure :: mod_int32_var, mod_int32_expr
  module procedure :: mod_var_int32, mod_expr_int32
  module procedure :: mod_int64_var, mod_int64_expr
  module procedure :: mod_var_int64, mod_expr_int64
  module procedure :: mod_real32_var, mod_real32_expr
  module procedure :: mod_var_real32, mod_expr_real32
  module procedure :: mod_real64_var, mod_real64_expr
  module procedure :: mod_var_real64, mod_expr_real64
end interface mod

!! ${NAME.upper()} builds a deferred element-wise expression.
interface modulo
  module procedure :: modulo_var_var, modulo_var_expr, &
    & modulo_expr_var, modulo_expr_expr
  module procedure :: modulo_int8_var, modulo_int8_expr
  module procedure :: modulo_var_int8, modulo_expr_int8
  module procedure :: modulo_int16_var, modulo_int16_expr
  module procedure :: modulo_var_int16, modulo_expr_int16
  module procedure :: modulo_int32_var, modulo_int32_expr
  module procedure :: modulo_var_int32, modulo_expr_int32
  module procedure :: modulo_int64_var, modulo_int64_expr
  module procedure :: modulo_var_int64, modulo_expr_int64
  module procedure :: modulo_real32_var, modulo_real32_expr
  module procedure :: modulo_var_real32, modulo_expr_real32
  module procedure :: modulo_real64_var, modulo_real64_expr
  module procedure :: modulo_var_real64, modulo_expr_real64
end interface modulo

!! ${NAME.upper()} builds a deferred element-wise expression.
interface atan2
  module procedure :: atan2_var_var, atan2_var_expr, &
    & atan2_expr_var, atan2_expr_expr
  module procedure :: atan2_real32_var, atan2_real32_expr
  module procedure :: atan2_var_real32, atan2_expr_real32
  module procedure :: atan2_real64_var, atan2_real64_expr
  module procedure :: atan2_var_real64, atan2_expr_real64
end interface atan2

!! ${NAME.upper()} builds a deferred element-wise expression.
interface hypot
  module procedure :: hypot_var_var, hypot_var_expr, &
    & hypot_expr_var, hypot_expr_expr
  module procedure :: hypot_real32_var, hypot_real32_expr
  module procedure :: hypot_var_real32, hypot_expr_real32
  module procedure :: hypot_real64_var, hypot_real64_expr
  module procedure :: hypot_var_real64, hypot_expr_real64
end interface hypot

interface
  module function abs_var(a) result(expr)
    !! Build a deferred ABS expression from a borrowed variable.
    type(variable_type), target, intent(in) :: a
    !! Input variable; its storage is borrowed until evaluation.
    type(expression_type) :: expr
  end function abs_var

  module function abs_expr(a) result(expr)
    !! Build a deferred ABS expression from an expression.
    type(expression_type), intent(in) :: a
    !! Input expression; its nodes are copied into the result.
    type(expression_type) :: expr
  end function abs_expr

  module function sqrt_var(a) result(expr)
    !! Build a deferred SQRT expression from a borrowed variable.
    type(variable_type), target, intent(in) :: a
    !! Input variable; its storage is borrowed until evaluation.
    type(expression_type) :: expr
  end function sqrt_var

  module function sqrt_expr(a) result(expr)
    !! Build a deferred SQRT expression from an expression.
    type(expression_type), intent(in) :: a
    !! Input expression; its nodes are copied into the result.
    type(expression_type) :: expr
  end function sqrt_expr

  module function exp_var(a) result(expr)
    !! Build a deferred EXP expression from a borrowed variable.
    type(variable_type), target, intent(in) :: a
    !! Input variable; its storage is borrowed until evaluation.
    type(expression_type) :: expr
  end function exp_var

  module function exp_expr(a) result(expr)
    !! Build a deferred EXP expression from an expression.
    type(expression_type), intent(in) :: a
    !! Input expression; its nodes are copied into the result.
    type(expression_type) :: expr
  end function exp_expr

  module function log_var(a) result(expr)
    !! Build a deferred LOG expression from a borrowed variable.
    type(variable_type), target, intent(in) :: a
    !! Input variable; its storage is borrowed until evaluation.
    type(expression_type) :: expr
  end function log_var

  module function log_expr(a) result(expr)
    !! Build a deferred LOG expression from an expression.
    type(expression_type), intent(in) :: a
    !! Input expression; its nodes are copied into the result.
    type(expression_type) :: expr
  end function log_expr

  module function log10_var(a) result(expr)
    !! Build a deferred LOG10 expression from a borrowed variable.
    type(variable_type), target, intent(in) :: a
    !! Input variable; its storage is borrowed until evaluation.
    type(expression_type) :: expr
  end function log10_var

  module function log10_expr(a) result(expr)
    !! Build a deferred LOG10 expression from an expression.
    type(expression_type), intent(in) :: a
    !! Input expression; its nodes are copied into the result.
    type(expression_type) :: expr
  end function log10_expr

  module function sin_var(a) result(expr)
    !! Build a deferred SIN expression from a borrowed variable.
    type(variable_type), target, intent(in) :: a
    !! Input variable; its storage is borrowed until evaluation.
    type(expression_type) :: expr
  end function sin_var

  module function sin_expr(a) result(expr)
    !! Build a deferred SIN expression from an expression.
    type(expression_type), intent(in) :: a
    !! Input expression; its nodes are copied into the result.
    type(expression_type) :: expr
  end function sin_expr

  module function cos_var(a) result(expr)
    !! Build a deferred COS expression from a borrowed variable.
    type(variable_type), target, intent(in) :: a
    !! Input variable; its storage is borrowed until evaluation.
    type(expression_type) :: expr
  end function cos_var

  module function cos_expr(a) result(expr)
    !! Build a deferred COS expression from an expression.
    type(expression_type), intent(in) :: a
    !! Input expression; its nodes are copied into the result.
    type(expression_type) :: expr
  end function cos_expr

  module function tan_var(a) result(expr)
    !! Build a deferred TAN expression from a borrowed variable.
    type(variable_type), target, intent(in) :: a
    !! Input variable; its storage is borrowed until evaluation.
    type(expression_type) :: expr
  end function tan_var

  module function tan_expr(a) result(expr)
    !! Build a deferred TAN expression from an expression.
    type(expression_type), intent(in) :: a
    !! Input expression; its nodes are copied into the result.
    type(expression_type) :: expr
  end function tan_expr

  module function asin_var(a) result(expr)
    !! Build a deferred ASIN expression from a borrowed variable.
    type(variable_type), target, intent(in) :: a
    !! Input variable; its storage is borrowed until evaluation.
    type(expression_type) :: expr
  end function asin_var

  module function asin_expr(a) result(expr)
    !! Build a deferred ASIN expression from an expression.
    type(expression_type), intent(in) :: a
    !! Input expression; its nodes are copied into the result.
    type(expression_type) :: expr
  end function asin_expr

  module function acos_var(a) result(expr)
    !! Build a deferred ACOS expression from a borrowed variable.
    type(variable_type), target, intent(in) :: a
    !! Input variable; its storage is borrowed until evaluation.
    type(expression_type) :: expr
  end function acos_var

  module function acos_expr(a) result(expr)
    !! Build a deferred ACOS expression from an expression.
    type(expression_type), intent(in) :: a
    !! Input expression; its nodes are copied into the result.
    type(expression_type) :: expr
  end function acos_expr

  module function atan_var(a) result(expr)
    !! Build a deferred ATAN expression from a borrowed variable.
    type(variable_type), target, intent(in) :: a
    !! Input variable; its storage is borrowed until evaluation.
    type(expression_type) :: expr
  end function atan_var

  module function atan_expr(a) result(expr)
    !! Build a deferred ATAN expression from an expression.
    type(expression_type), intent(in) :: a
    !! Input expression; its nodes are copied into the result.
    type(expression_type) :: expr
  end function atan_expr

  module function sinh_var(a) result(expr)
    !! Build a deferred SINH expression from a borrowed variable.
    type(variable_type), target, intent(in) :: a
    !! Input variable; its storage is borrowed until evaluation.
    type(expression_type) :: expr
  end function sinh_var

  module function sinh_expr(a) result(expr)
    !! Build a deferred SINH expression from an expression.
    type(expression_type), intent(in) :: a
    !! Input expression; its nodes are copied into the result.
    type(expression_type) :: expr
  end function sinh_expr

  module function cosh_var(a) result(expr)
    !! Build a deferred COSH expression from a borrowed variable.
    type(variable_type), target, intent(in) :: a
    !! Input variable; its storage is borrowed until evaluation.
    type(expression_type) :: expr
  end function cosh_var

  module function cosh_expr(a) result(expr)
    !! Build a deferred COSH expression from an expression.
    type(expression_type), intent(in) :: a
    !! Input expression; its nodes are copied into the result.
    type(expression_type) :: expr
  end function cosh_expr

  module function tanh_var(a) result(expr)
    !! Build a deferred TANH expression from a borrowed variable.
    type(variable_type), target, intent(in) :: a
    !! Input variable; its storage is borrowed until evaluation.
    type(expression_type) :: expr
  end function tanh_var

  module function tanh_expr(a) result(expr)
    !! Build a deferred TANH expression from an expression.
    type(expression_type), intent(in) :: a
    !! Input expression; its nodes are copied into the result.
    type(expression_type) :: expr
  end function tanh_expr

  module function asinh_var(a) result(expr)
    !! Build a deferred ASINH expression from a borrowed variable.
    type(variable_type), target, intent(in) :: a
    !! Input variable; its storage is borrowed until evaluation.
    type(expression_type) :: expr
  end function asinh_var

  module function asinh_expr(a) result(expr)
    !! Build a deferred ASINH expression from an expression.
    type(expression_type), intent(in) :: a
    !! Input expression; its nodes are copied into the result.
    type(expression_type) :: expr
  end function asinh_expr

  module function acosh_var(a) result(expr)
    !! Build a deferred ACOSH expression from a borrowed variable.
    type(variable_type), target, intent(in) :: a
    !! Input variable; its storage is borrowed until evaluation.
    type(expression_type) :: expr
  end function acosh_var

  module function acosh_expr(a) result(expr)
    !! Build a deferred ACOSH expression from an expression.
    type(expression_type), intent(in) :: a
    !! Input expression; its nodes are copied into the result.
    type(expression_type) :: expr
  end function acosh_expr

  module function atanh_var(a) result(expr)
    !! Build a deferred ATANH expression from a borrowed variable.
    type(variable_type), target, intent(in) :: a
    !! Input variable; its storage is borrowed until evaluation.
    type(expression_type) :: expr
  end function atanh_var

  module function atanh_expr(a) result(expr)
    !! Build a deferred ATANH expression from an expression.
    type(expression_type), intent(in) :: a
    !! Input expression; its nodes are copied into the result.
    type(expression_type) :: expr
  end function atanh_expr

  module function erf_var(a) result(expr)
    !! Build a deferred ERF expression from a borrowed variable.
    type(variable_type), target, intent(in) :: a
    !! Input variable; its storage is borrowed until evaluation.
    type(expression_type) :: expr
  end function erf_var

  module function erf_expr(a) result(expr)
    !! Build a deferred ERF expression from an expression.
    type(expression_type), intent(in) :: a
    !! Input expression; its nodes are copied into the result.
    type(expression_type) :: expr
  end function erf_expr

  module function erfc_var(a) result(expr)
    !! Build a deferred ERFC expression from a borrowed variable.
    type(variable_type), target, intent(in) :: a
    !! Input variable; its storage is borrowed until evaluation.
    type(expression_type) :: expr
  end function erfc_var

  module function erfc_expr(a) result(expr)
    !! Build a deferred ERFC expression from an expression.
    type(expression_type), intent(in) :: a
    !! Input expression; its nodes are copied into the result.
    type(expression_type) :: expr
  end function erfc_expr

  module function erfc_scaled_var(a) result(expr)
    !! Build a deferred ERFC_SCALED expression from a borrowed variable.
    type(variable_type), target, intent(in) :: a
    !! Input variable; its storage is borrowed until evaluation.
    type(expression_type) :: expr
  end function erfc_scaled_var

  module function erfc_scaled_expr(a) result(expr)
    !! Build a deferred ERFC_SCALED expression from an expression.
    type(expression_type), intent(in) :: a
    !! Input expression; its nodes are copied into the result.
    type(expression_type) :: expr
  end function erfc_scaled_expr

  module function gamma_var(a) result(expr)
    !! Build a deferred GAMMA expression from a borrowed variable.
    type(variable_type), target, intent(in) :: a
    !! Input variable; its storage is borrowed until evaluation.
    type(expression_type) :: expr
  end function gamma_var

  module function gamma_expr(a) result(expr)
    !! Build a deferred GAMMA expression from an expression.
    type(expression_type), intent(in) :: a
    !! Input expression; its nodes are copied into the result.
    type(expression_type) :: expr
  end function gamma_expr

  module function log_gamma_var(a) result(expr)
    !! Build a deferred LOG_GAMMA expression from a borrowed variable.
    type(variable_type), target, intent(in) :: a
    !! Input variable; its storage is borrowed until evaluation.
    type(expression_type) :: expr
  end function log_gamma_var

  module function log_gamma_expr(a) result(expr)
    !! Build a deferred LOG_GAMMA expression from an expression.
    type(expression_type), intent(in) :: a
    !! Input expression; its nodes are copied into the result.
    type(expression_type) :: expr
  end function log_gamma_expr

  module function bessel_j0_var(a) result(expr)
    !! Build a deferred BESSEL_J0 expression from a borrowed variable.
    type(variable_type), target, intent(in) :: a
    !! Input variable; its storage is borrowed until evaluation.
    type(expression_type) :: expr
  end function bessel_j0_var

  module function bessel_j0_expr(a) result(expr)
    !! Build a deferred BESSEL_J0 expression from an expression.
    type(expression_type), intent(in) :: a
    !! Input expression; its nodes are copied into the result.
    type(expression_type) :: expr
  end function bessel_j0_expr

  module function bessel_j1_var(a) result(expr)
    !! Build a deferred BESSEL_J1 expression from a borrowed variable.
    type(variable_type), target, intent(in) :: a
    !! Input variable; its storage is borrowed until evaluation.
    type(expression_type) :: expr
  end function bessel_j1_var

  module function bessel_j1_expr(a) result(expr)
    !! Build a deferred BESSEL_J1 expression from an expression.
    type(expression_type), intent(in) :: a
    !! Input expression; its nodes are copied into the result.
    type(expression_type) :: expr
  end function bessel_j1_expr

  module function bessel_y0_var(a) result(expr)
    !! Build a deferred BESSEL_Y0 expression from a borrowed variable.
    type(variable_type), target, intent(in) :: a
    !! Input variable; its storage is borrowed until evaluation.
    type(expression_type) :: expr
  end function bessel_y0_var

  module function bessel_y0_expr(a) result(expr)
    !! Build a deferred BESSEL_Y0 expression from an expression.
    type(expression_type), intent(in) :: a
    !! Input expression; its nodes are copied into the result.
    type(expression_type) :: expr
  end function bessel_y0_expr

  module function bessel_y1_var(a) result(expr)
    !! Build a deferred BESSEL_Y1 expression from a borrowed variable.
    type(variable_type), target, intent(in) :: a
    !! Input variable; its storage is borrowed until evaluation.
    type(expression_type) :: expr
  end function bessel_y1_var

  module function bessel_y1_expr(a) result(expr)
    !! Build a deferred BESSEL_Y1 expression from an expression.
    type(expression_type), intent(in) :: a
    !! Input expression; its nodes are copied into the result.
    type(expression_type) :: expr
  end function bessel_y1_expr

  module function dim_var_var(a, b) result(expr)
    !! Build a deferred DIM expression from two operands.
    type(variable_type), target, intent(in) :: a
    !! Left variable, borrowed until evaluation.
    type(variable_type), target, intent(in) :: b
    !! Right variable, borrowed until evaluation.
    type(expression_type) :: expr
  end function dim_var_var

  module function dim_var_expr(a, b) result(expr)
    !! Build a deferred DIM expression from two operands.
    type(variable_type), target, intent(in) :: a
    !! Left variable, borrowed until evaluation.
    type(expression_type), intent(in) :: b
    !! Right expression, copied into the result.
    type(expression_type) :: expr
  end function dim_var_expr

  module function dim_expr_var(a, b) result(expr)
    !! Build a deferred DIM expression from two operands.
    type(expression_type), intent(in) :: a
    !! Left expression, copied into the result.
    type(variable_type), target, intent(in) :: b
    !! Right variable, borrowed until evaluation.
    type(expression_type) :: expr
  end function dim_expr_var

  module function dim_expr_expr(a, b) result(expr)
    !! Build a deferred DIM expression from two operands.
    type(expression_type), intent(in) :: a
    !! Left expression, copied into the result.
    type(expression_type), intent(in) :: b
    !! Right expression, copied into the result.
    type(expression_type) :: expr
  end function dim_expr_expr

  module function dim_int8_var(a, b) result(expr)
    !! Build a deferred DIM expression with a left scalar.
    integer(int8), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable, borrowed until evaluation.
    type(expression_type) :: expr
  end function dim_int8_var

  module function dim_var_int8(a, b) result(expr)
    !! Build a deferred DIM expression with a right scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable, borrowed until evaluation.
    integer(int8), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function dim_var_int8

  module function dim_int8_expr(a, b) result(expr)
    !! Build a deferred DIM expression with a left scalar.
    integer(int8), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(expression_type), intent(in) :: b
    !! Right expression, copied into the result.
    type(expression_type) :: expr
  end function dim_int8_expr

  module function dim_expr_int8(a, b) result(expr)
    !! Build a deferred DIM expression with a right scalar.
    type(expression_type), intent(in) :: a
    !! Left expression, copied into the result.
    integer(int8), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function dim_expr_int8

  module function dim_int16_var(a, b) result(expr)
    !! Build a deferred DIM expression with a left scalar.
    integer(int16), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable, borrowed until evaluation.
    type(expression_type) :: expr
  end function dim_int16_var

  module function dim_var_int16(a, b) result(expr)
    !! Build a deferred DIM expression with a right scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable, borrowed until evaluation.
    integer(int16), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function dim_var_int16

  module function dim_int16_expr(a, b) result(expr)
    !! Build a deferred DIM expression with a left scalar.
    integer(int16), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(expression_type), intent(in) :: b
    !! Right expression, copied into the result.
    type(expression_type) :: expr
  end function dim_int16_expr

  module function dim_expr_int16(a, b) result(expr)
    !! Build a deferred DIM expression with a right scalar.
    type(expression_type), intent(in) :: a
    !! Left expression, copied into the result.
    integer(int16), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function dim_expr_int16

  module function dim_int32_var(a, b) result(expr)
    !! Build a deferred DIM expression with a left scalar.
    integer(int32), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable, borrowed until evaluation.
    type(expression_type) :: expr
  end function dim_int32_var

  module function dim_var_int32(a, b) result(expr)
    !! Build a deferred DIM expression with a right scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable, borrowed until evaluation.
    integer(int32), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function dim_var_int32

  module function dim_int32_expr(a, b) result(expr)
    !! Build a deferred DIM expression with a left scalar.
    integer(int32), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(expression_type), intent(in) :: b
    !! Right expression, copied into the result.
    type(expression_type) :: expr
  end function dim_int32_expr

  module function dim_expr_int32(a, b) result(expr)
    !! Build a deferred DIM expression with a right scalar.
    type(expression_type), intent(in) :: a
    !! Left expression, copied into the result.
    integer(int32), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function dim_expr_int32

  module function dim_int64_var(a, b) result(expr)
    !! Build a deferred DIM expression with a left scalar.
    integer(int64), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable, borrowed until evaluation.
    type(expression_type) :: expr
  end function dim_int64_var

  module function dim_var_int64(a, b) result(expr)
    !! Build a deferred DIM expression with a right scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable, borrowed until evaluation.
    integer(int64), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function dim_var_int64

  module function dim_int64_expr(a, b) result(expr)
    !! Build a deferred DIM expression with a left scalar.
    integer(int64), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(expression_type), intent(in) :: b
    !! Right expression, copied into the result.
    type(expression_type) :: expr
  end function dim_int64_expr

  module function dim_expr_int64(a, b) result(expr)
    !! Build a deferred DIM expression with a right scalar.
    type(expression_type), intent(in) :: a
    !! Left expression, copied into the result.
    integer(int64), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function dim_expr_int64

  module function dim_real32_var(a, b) result(expr)
    !! Build a deferred DIM expression with a left scalar.
    real(real32), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable, borrowed until evaluation.
    type(expression_type) :: expr
  end function dim_real32_var

  module function dim_var_real32(a, b) result(expr)
    !! Build a deferred DIM expression with a right scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable, borrowed until evaluation.
    real(real32), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function dim_var_real32

  module function dim_real32_expr(a, b) result(expr)
    !! Build a deferred DIM expression with a left scalar.
    real(real32), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(expression_type), intent(in) :: b
    !! Right expression, copied into the result.
    type(expression_type) :: expr
  end function dim_real32_expr

  module function dim_expr_real32(a, b) result(expr)
    !! Build a deferred DIM expression with a right scalar.
    type(expression_type), intent(in) :: a
    !! Left expression, copied into the result.
    real(real32), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function dim_expr_real32

  module function dim_real64_var(a, b) result(expr)
    !! Build a deferred DIM expression with a left scalar.
    real(real64), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable, borrowed until evaluation.
    type(expression_type) :: expr
  end function dim_real64_var

  module function dim_var_real64(a, b) result(expr)
    !! Build a deferred DIM expression with a right scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable, borrowed until evaluation.
    real(real64), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function dim_var_real64

  module function dim_real64_expr(a, b) result(expr)
    !! Build a deferred DIM expression with a left scalar.
    real(real64), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(expression_type), intent(in) :: b
    !! Right expression, copied into the result.
    type(expression_type) :: expr
  end function dim_real64_expr

  module function dim_expr_real64(a, b) result(expr)
    !! Build a deferred DIM expression with a right scalar.
    type(expression_type), intent(in) :: a
    !! Left expression, copied into the result.
    real(real64), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function dim_expr_real64

  module function sign_var_var(a, b) result(expr)
    !! Build a deferred SIGN expression from two operands.
    type(variable_type), target, intent(in) :: a
    !! Left variable, borrowed until evaluation.
    type(variable_type), target, intent(in) :: b
    !! Right variable, borrowed until evaluation.
    type(expression_type) :: expr
  end function sign_var_var

  module function sign_var_expr(a, b) result(expr)
    !! Build a deferred SIGN expression from two operands.
    type(variable_type), target, intent(in) :: a
    !! Left variable, borrowed until evaluation.
    type(expression_type), intent(in) :: b
    !! Right expression, copied into the result.
    type(expression_type) :: expr
  end function sign_var_expr

  module function sign_expr_var(a, b) result(expr)
    !! Build a deferred SIGN expression from two operands.
    type(expression_type), intent(in) :: a
    !! Left expression, copied into the result.
    type(variable_type), target, intent(in) :: b
    !! Right variable, borrowed until evaluation.
    type(expression_type) :: expr
  end function sign_expr_var

  module function sign_expr_expr(a, b) result(expr)
    !! Build a deferred SIGN expression from two operands.
    type(expression_type), intent(in) :: a
    !! Left expression, copied into the result.
    type(expression_type), intent(in) :: b
    !! Right expression, copied into the result.
    type(expression_type) :: expr
  end function sign_expr_expr

  module function sign_int8_var(a, b) result(expr)
    !! Build a deferred SIGN expression with a left scalar.
    integer(int8), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable, borrowed until evaluation.
    type(expression_type) :: expr
  end function sign_int8_var

  module function sign_var_int8(a, b) result(expr)
    !! Build a deferred SIGN expression with a right scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable, borrowed until evaluation.
    integer(int8), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function sign_var_int8

  module function sign_int8_expr(a, b) result(expr)
    !! Build a deferred SIGN expression with a left scalar.
    integer(int8), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(expression_type), intent(in) :: b
    !! Right expression, copied into the result.
    type(expression_type) :: expr
  end function sign_int8_expr

  module function sign_expr_int8(a, b) result(expr)
    !! Build a deferred SIGN expression with a right scalar.
    type(expression_type), intent(in) :: a
    !! Left expression, copied into the result.
    integer(int8), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function sign_expr_int8

  module function sign_int16_var(a, b) result(expr)
    !! Build a deferred SIGN expression with a left scalar.
    integer(int16), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable, borrowed until evaluation.
    type(expression_type) :: expr
  end function sign_int16_var

  module function sign_var_int16(a, b) result(expr)
    !! Build a deferred SIGN expression with a right scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable, borrowed until evaluation.
    integer(int16), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function sign_var_int16

  module function sign_int16_expr(a, b) result(expr)
    !! Build a deferred SIGN expression with a left scalar.
    integer(int16), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(expression_type), intent(in) :: b
    !! Right expression, copied into the result.
    type(expression_type) :: expr
  end function sign_int16_expr

  module function sign_expr_int16(a, b) result(expr)
    !! Build a deferred SIGN expression with a right scalar.
    type(expression_type), intent(in) :: a
    !! Left expression, copied into the result.
    integer(int16), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function sign_expr_int16

  module function sign_int32_var(a, b) result(expr)
    !! Build a deferred SIGN expression with a left scalar.
    integer(int32), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable, borrowed until evaluation.
    type(expression_type) :: expr
  end function sign_int32_var

  module function sign_var_int32(a, b) result(expr)
    !! Build a deferred SIGN expression with a right scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable, borrowed until evaluation.
    integer(int32), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function sign_var_int32

  module function sign_int32_expr(a, b) result(expr)
    !! Build a deferred SIGN expression with a left scalar.
    integer(int32), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(expression_type), intent(in) :: b
    !! Right expression, copied into the result.
    type(expression_type) :: expr
  end function sign_int32_expr

  module function sign_expr_int32(a, b) result(expr)
    !! Build a deferred SIGN expression with a right scalar.
    type(expression_type), intent(in) :: a
    !! Left expression, copied into the result.
    integer(int32), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function sign_expr_int32

  module function sign_int64_var(a, b) result(expr)
    !! Build a deferred SIGN expression with a left scalar.
    integer(int64), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable, borrowed until evaluation.
    type(expression_type) :: expr
  end function sign_int64_var

  module function sign_var_int64(a, b) result(expr)
    !! Build a deferred SIGN expression with a right scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable, borrowed until evaluation.
    integer(int64), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function sign_var_int64

  module function sign_int64_expr(a, b) result(expr)
    !! Build a deferred SIGN expression with a left scalar.
    integer(int64), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(expression_type), intent(in) :: b
    !! Right expression, copied into the result.
    type(expression_type) :: expr
  end function sign_int64_expr

  module function sign_expr_int64(a, b) result(expr)
    !! Build a deferred SIGN expression with a right scalar.
    type(expression_type), intent(in) :: a
    !! Left expression, copied into the result.
    integer(int64), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function sign_expr_int64

  module function sign_real32_var(a, b) result(expr)
    !! Build a deferred SIGN expression with a left scalar.
    real(real32), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable, borrowed until evaluation.
    type(expression_type) :: expr
  end function sign_real32_var

  module function sign_var_real32(a, b) result(expr)
    !! Build a deferred SIGN expression with a right scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable, borrowed until evaluation.
    real(real32), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function sign_var_real32

  module function sign_real32_expr(a, b) result(expr)
    !! Build a deferred SIGN expression with a left scalar.
    real(real32), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(expression_type), intent(in) :: b
    !! Right expression, copied into the result.
    type(expression_type) :: expr
  end function sign_real32_expr

  module function sign_expr_real32(a, b) result(expr)
    !! Build a deferred SIGN expression with a right scalar.
    type(expression_type), intent(in) :: a
    !! Left expression, copied into the result.
    real(real32), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function sign_expr_real32

  module function sign_real64_var(a, b) result(expr)
    !! Build a deferred SIGN expression with a left scalar.
    real(real64), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable, borrowed until evaluation.
    type(expression_type) :: expr
  end function sign_real64_var

  module function sign_var_real64(a, b) result(expr)
    !! Build a deferred SIGN expression with a right scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable, borrowed until evaluation.
    real(real64), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function sign_var_real64

  module function sign_real64_expr(a, b) result(expr)
    !! Build a deferred SIGN expression with a left scalar.
    real(real64), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(expression_type), intent(in) :: b
    !! Right expression, copied into the result.
    type(expression_type) :: expr
  end function sign_real64_expr

  module function sign_expr_real64(a, b) result(expr)
    !! Build a deferred SIGN expression with a right scalar.
    type(expression_type), intent(in) :: a
    !! Left expression, copied into the result.
    real(real64), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function sign_expr_real64

  module function mod_var_var(a, b) result(expr)
    !! Build a deferred MOD expression from two operands.
    type(variable_type), target, intent(in) :: a
    !! Left variable, borrowed until evaluation.
    type(variable_type), target, intent(in) :: b
    !! Right variable, borrowed until evaluation.
    type(expression_type) :: expr
  end function mod_var_var

  module function mod_var_expr(a, b) result(expr)
    !! Build a deferred MOD expression from two operands.
    type(variable_type), target, intent(in) :: a
    !! Left variable, borrowed until evaluation.
    type(expression_type), intent(in) :: b
    !! Right expression, copied into the result.
    type(expression_type) :: expr
  end function mod_var_expr

  module function mod_expr_var(a, b) result(expr)
    !! Build a deferred MOD expression from two operands.
    type(expression_type), intent(in) :: a
    !! Left expression, copied into the result.
    type(variable_type), target, intent(in) :: b
    !! Right variable, borrowed until evaluation.
    type(expression_type) :: expr
  end function mod_expr_var

  module function mod_expr_expr(a, b) result(expr)
    !! Build a deferred MOD expression from two operands.
    type(expression_type), intent(in) :: a
    !! Left expression, copied into the result.
    type(expression_type), intent(in) :: b
    !! Right expression, copied into the result.
    type(expression_type) :: expr
  end function mod_expr_expr

  module function mod_int8_var(a, b) result(expr)
    !! Build a deferred MOD expression with a left scalar.
    integer(int8), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable, borrowed until evaluation.
    type(expression_type) :: expr
  end function mod_int8_var

  module function mod_var_int8(a, b) result(expr)
    !! Build a deferred MOD expression with a right scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable, borrowed until evaluation.
    integer(int8), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function mod_var_int8

  module function mod_int8_expr(a, b) result(expr)
    !! Build a deferred MOD expression with a left scalar.
    integer(int8), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(expression_type), intent(in) :: b
    !! Right expression, copied into the result.
    type(expression_type) :: expr
  end function mod_int8_expr

  module function mod_expr_int8(a, b) result(expr)
    !! Build a deferred MOD expression with a right scalar.
    type(expression_type), intent(in) :: a
    !! Left expression, copied into the result.
    integer(int8), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function mod_expr_int8

  module function mod_int16_var(a, b) result(expr)
    !! Build a deferred MOD expression with a left scalar.
    integer(int16), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable, borrowed until evaluation.
    type(expression_type) :: expr
  end function mod_int16_var

  module function mod_var_int16(a, b) result(expr)
    !! Build a deferred MOD expression with a right scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable, borrowed until evaluation.
    integer(int16), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function mod_var_int16

  module function mod_int16_expr(a, b) result(expr)
    !! Build a deferred MOD expression with a left scalar.
    integer(int16), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(expression_type), intent(in) :: b
    !! Right expression, copied into the result.
    type(expression_type) :: expr
  end function mod_int16_expr

  module function mod_expr_int16(a, b) result(expr)
    !! Build a deferred MOD expression with a right scalar.
    type(expression_type), intent(in) :: a
    !! Left expression, copied into the result.
    integer(int16), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function mod_expr_int16

  module function mod_int32_var(a, b) result(expr)
    !! Build a deferred MOD expression with a left scalar.
    integer(int32), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable, borrowed until evaluation.
    type(expression_type) :: expr
  end function mod_int32_var

  module function mod_var_int32(a, b) result(expr)
    !! Build a deferred MOD expression with a right scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable, borrowed until evaluation.
    integer(int32), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function mod_var_int32

  module function mod_int32_expr(a, b) result(expr)
    !! Build a deferred MOD expression with a left scalar.
    integer(int32), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(expression_type), intent(in) :: b
    !! Right expression, copied into the result.
    type(expression_type) :: expr
  end function mod_int32_expr

  module function mod_expr_int32(a, b) result(expr)
    !! Build a deferred MOD expression with a right scalar.
    type(expression_type), intent(in) :: a
    !! Left expression, copied into the result.
    integer(int32), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function mod_expr_int32

  module function mod_int64_var(a, b) result(expr)
    !! Build a deferred MOD expression with a left scalar.
    integer(int64), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable, borrowed until evaluation.
    type(expression_type) :: expr
  end function mod_int64_var

  module function mod_var_int64(a, b) result(expr)
    !! Build a deferred MOD expression with a right scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable, borrowed until evaluation.
    integer(int64), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function mod_var_int64

  module function mod_int64_expr(a, b) result(expr)
    !! Build a deferred MOD expression with a left scalar.
    integer(int64), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(expression_type), intent(in) :: b
    !! Right expression, copied into the result.
    type(expression_type) :: expr
  end function mod_int64_expr

  module function mod_expr_int64(a, b) result(expr)
    !! Build a deferred MOD expression with a right scalar.
    type(expression_type), intent(in) :: a
    !! Left expression, copied into the result.
    integer(int64), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function mod_expr_int64

  module function mod_real32_var(a, b) result(expr)
    !! Build a deferred MOD expression with a left scalar.
    real(real32), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable, borrowed until evaluation.
    type(expression_type) :: expr
  end function mod_real32_var

  module function mod_var_real32(a, b) result(expr)
    !! Build a deferred MOD expression with a right scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable, borrowed until evaluation.
    real(real32), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function mod_var_real32

  module function mod_real32_expr(a, b) result(expr)
    !! Build a deferred MOD expression with a left scalar.
    real(real32), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(expression_type), intent(in) :: b
    !! Right expression, copied into the result.
    type(expression_type) :: expr
  end function mod_real32_expr

  module function mod_expr_real32(a, b) result(expr)
    !! Build a deferred MOD expression with a right scalar.
    type(expression_type), intent(in) :: a
    !! Left expression, copied into the result.
    real(real32), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function mod_expr_real32

  module function mod_real64_var(a, b) result(expr)
    !! Build a deferred MOD expression with a left scalar.
    real(real64), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable, borrowed until evaluation.
    type(expression_type) :: expr
  end function mod_real64_var

  module function mod_var_real64(a, b) result(expr)
    !! Build a deferred MOD expression with a right scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable, borrowed until evaluation.
    real(real64), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function mod_var_real64

  module function mod_real64_expr(a, b) result(expr)
    !! Build a deferred MOD expression with a left scalar.
    real(real64), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(expression_type), intent(in) :: b
    !! Right expression, copied into the result.
    type(expression_type) :: expr
  end function mod_real64_expr

  module function mod_expr_real64(a, b) result(expr)
    !! Build a deferred MOD expression with a right scalar.
    type(expression_type), intent(in) :: a
    !! Left expression, copied into the result.
    real(real64), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function mod_expr_real64

  module function modulo_var_var(a, b) result(expr)
    !! Build a deferred MODULO expression from two operands.
    type(variable_type), target, intent(in) :: a
    !! Left variable, borrowed until evaluation.
    type(variable_type), target, intent(in) :: b
    !! Right variable, borrowed until evaluation.
    type(expression_type) :: expr
  end function modulo_var_var

  module function modulo_var_expr(a, b) result(expr)
    !! Build a deferred MODULO expression from two operands.
    type(variable_type), target, intent(in) :: a
    !! Left variable, borrowed until evaluation.
    type(expression_type), intent(in) :: b
    !! Right expression, copied into the result.
    type(expression_type) :: expr
  end function modulo_var_expr

  module function modulo_expr_var(a, b) result(expr)
    !! Build a deferred MODULO expression from two operands.
    type(expression_type), intent(in) :: a
    !! Left expression, copied into the result.
    type(variable_type), target, intent(in) :: b
    !! Right variable, borrowed until evaluation.
    type(expression_type) :: expr
  end function modulo_expr_var

  module function modulo_expr_expr(a, b) result(expr)
    !! Build a deferred MODULO expression from two operands.
    type(expression_type), intent(in) :: a
    !! Left expression, copied into the result.
    type(expression_type), intent(in) :: b
    !! Right expression, copied into the result.
    type(expression_type) :: expr
  end function modulo_expr_expr

  module function modulo_int8_var(a, b) result(expr)
    !! Build a deferred MODULO expression with a left scalar.
    integer(int8), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable, borrowed until evaluation.
    type(expression_type) :: expr
  end function modulo_int8_var

  module function modulo_var_int8(a, b) result(expr)
    !! Build a deferred MODULO expression with a right scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable, borrowed until evaluation.
    integer(int8), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function modulo_var_int8

  module function modulo_int8_expr(a, b) result(expr)
    !! Build a deferred MODULO expression with a left scalar.
    integer(int8), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(expression_type), intent(in) :: b
    !! Right expression, copied into the result.
    type(expression_type) :: expr
  end function modulo_int8_expr

  module function modulo_expr_int8(a, b) result(expr)
    !! Build a deferred MODULO expression with a right scalar.
    type(expression_type), intent(in) :: a
    !! Left expression, copied into the result.
    integer(int8), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function modulo_expr_int8

  module function modulo_int16_var(a, b) result(expr)
    !! Build a deferred MODULO expression with a left scalar.
    integer(int16), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable, borrowed until evaluation.
    type(expression_type) :: expr
  end function modulo_int16_var

  module function modulo_var_int16(a, b) result(expr)
    !! Build a deferred MODULO expression with a right scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable, borrowed until evaluation.
    integer(int16), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function modulo_var_int16

  module function modulo_int16_expr(a, b) result(expr)
    !! Build a deferred MODULO expression with a left scalar.
    integer(int16), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(expression_type), intent(in) :: b
    !! Right expression, copied into the result.
    type(expression_type) :: expr
  end function modulo_int16_expr

  module function modulo_expr_int16(a, b) result(expr)
    !! Build a deferred MODULO expression with a right scalar.
    type(expression_type), intent(in) :: a
    !! Left expression, copied into the result.
    integer(int16), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function modulo_expr_int16

  module function modulo_int32_var(a, b) result(expr)
    !! Build a deferred MODULO expression with a left scalar.
    integer(int32), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable, borrowed until evaluation.
    type(expression_type) :: expr
  end function modulo_int32_var

  module function modulo_var_int32(a, b) result(expr)
    !! Build a deferred MODULO expression with a right scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable, borrowed until evaluation.
    integer(int32), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function modulo_var_int32

  module function modulo_int32_expr(a, b) result(expr)
    !! Build a deferred MODULO expression with a left scalar.
    integer(int32), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(expression_type), intent(in) :: b
    !! Right expression, copied into the result.
    type(expression_type) :: expr
  end function modulo_int32_expr

  module function modulo_expr_int32(a, b) result(expr)
    !! Build a deferred MODULO expression with a right scalar.
    type(expression_type), intent(in) :: a
    !! Left expression, copied into the result.
    integer(int32), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function modulo_expr_int32

  module function modulo_int64_var(a, b) result(expr)
    !! Build a deferred MODULO expression with a left scalar.
    integer(int64), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable, borrowed until evaluation.
    type(expression_type) :: expr
  end function modulo_int64_var

  module function modulo_var_int64(a, b) result(expr)
    !! Build a deferred MODULO expression with a right scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable, borrowed until evaluation.
    integer(int64), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function modulo_var_int64

  module function modulo_int64_expr(a, b) result(expr)
    !! Build a deferred MODULO expression with a left scalar.
    integer(int64), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(expression_type), intent(in) :: b
    !! Right expression, copied into the result.
    type(expression_type) :: expr
  end function modulo_int64_expr

  module function modulo_expr_int64(a, b) result(expr)
    !! Build a deferred MODULO expression with a right scalar.
    type(expression_type), intent(in) :: a
    !! Left expression, copied into the result.
    integer(int64), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function modulo_expr_int64

  module function modulo_real32_var(a, b) result(expr)
    !! Build a deferred MODULO expression with a left scalar.
    real(real32), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable, borrowed until evaluation.
    type(expression_type) :: expr
  end function modulo_real32_var

  module function modulo_var_real32(a, b) result(expr)
    !! Build a deferred MODULO expression with a right scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable, borrowed until evaluation.
    real(real32), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function modulo_var_real32

  module function modulo_real32_expr(a, b) result(expr)
    !! Build a deferred MODULO expression with a left scalar.
    real(real32), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(expression_type), intent(in) :: b
    !! Right expression, copied into the result.
    type(expression_type) :: expr
  end function modulo_real32_expr

  module function modulo_expr_real32(a, b) result(expr)
    !! Build a deferred MODULO expression with a right scalar.
    type(expression_type), intent(in) :: a
    !! Left expression, copied into the result.
    real(real32), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function modulo_expr_real32

  module function modulo_real64_var(a, b) result(expr)
    !! Build a deferred MODULO expression with a left scalar.
    real(real64), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable, borrowed until evaluation.
    type(expression_type) :: expr
  end function modulo_real64_var

  module function modulo_var_real64(a, b) result(expr)
    !! Build a deferred MODULO expression with a right scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable, borrowed until evaluation.
    real(real64), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function modulo_var_real64

  module function modulo_real64_expr(a, b) result(expr)
    !! Build a deferred MODULO expression with a left scalar.
    real(real64), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(expression_type), intent(in) :: b
    !! Right expression, copied into the result.
    type(expression_type) :: expr
  end function modulo_real64_expr

  module function modulo_expr_real64(a, b) result(expr)
    !! Build a deferred MODULO expression with a right scalar.
    type(expression_type), intent(in) :: a
    !! Left expression, copied into the result.
    real(real64), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function modulo_expr_real64

  module function atan2_var_var(a, b) result(expr)
    !! Build a deferred ATAN2 expression from two operands.
    type(variable_type), target, intent(in) :: a
    !! Left variable, borrowed until evaluation.
    type(variable_type), target, intent(in) :: b
    !! Right variable, borrowed until evaluation.
    type(expression_type) :: expr
  end function atan2_var_var

  module function atan2_var_expr(a, b) result(expr)
    !! Build a deferred ATAN2 expression from two operands.
    type(variable_type), target, intent(in) :: a
    !! Left variable, borrowed until evaluation.
    type(expression_type), intent(in) :: b
    !! Right expression, copied into the result.
    type(expression_type) :: expr
  end function atan2_var_expr

  module function atan2_expr_var(a, b) result(expr)
    !! Build a deferred ATAN2 expression from two operands.
    type(expression_type), intent(in) :: a
    !! Left expression, copied into the result.
    type(variable_type), target, intent(in) :: b
    !! Right variable, borrowed until evaluation.
    type(expression_type) :: expr
  end function atan2_expr_var

  module function atan2_expr_expr(a, b) result(expr)
    !! Build a deferred ATAN2 expression from two operands.
    type(expression_type), intent(in) :: a
    !! Left expression, copied into the result.
    type(expression_type), intent(in) :: b
    !! Right expression, copied into the result.
    type(expression_type) :: expr
  end function atan2_expr_expr

  module function atan2_real32_var(a, b) result(expr)
    !! Build a deferred ATAN2 expression with a left scalar.
    real(real32), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable, borrowed until evaluation.
    type(expression_type) :: expr
  end function atan2_real32_var

  module function atan2_var_real32(a, b) result(expr)
    !! Build a deferred ATAN2 expression with a right scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable, borrowed until evaluation.
    real(real32), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function atan2_var_real32

  module function atan2_real32_expr(a, b) result(expr)
    !! Build a deferred ATAN2 expression with a left scalar.
    real(real32), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(expression_type), intent(in) :: b
    !! Right expression, copied into the result.
    type(expression_type) :: expr
  end function atan2_real32_expr

  module function atan2_expr_real32(a, b) result(expr)
    !! Build a deferred ATAN2 expression with a right scalar.
    type(expression_type), intent(in) :: a
    !! Left expression, copied into the result.
    real(real32), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function atan2_expr_real32

  module function atan2_real64_var(a, b) result(expr)
    !! Build a deferred ATAN2 expression with a left scalar.
    real(real64), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable, borrowed until evaluation.
    type(expression_type) :: expr
  end function atan2_real64_var

  module function atan2_var_real64(a, b) result(expr)
    !! Build a deferred ATAN2 expression with a right scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable, borrowed until evaluation.
    real(real64), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function atan2_var_real64

  module function atan2_real64_expr(a, b) result(expr)
    !! Build a deferred ATAN2 expression with a left scalar.
    real(real64), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(expression_type), intent(in) :: b
    !! Right expression, copied into the result.
    type(expression_type) :: expr
  end function atan2_real64_expr

  module function atan2_expr_real64(a, b) result(expr)
    !! Build a deferred ATAN2 expression with a right scalar.
    type(expression_type), intent(in) :: a
    !! Left expression, copied into the result.
    real(real64), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function atan2_expr_real64

  module function atan_var_var(a, b) result(expr)
    !! Build a deferred ATAN expression from two operands.
    type(variable_type), target, intent(in) :: a
    !! Left variable, borrowed until evaluation.
    type(variable_type), target, intent(in) :: b
    !! Right variable, borrowed until evaluation.
    type(expression_type) :: expr
  end function atan_var_var

  module function atan_var_expr(a, b) result(expr)
    !! Build a deferred ATAN expression from two operands.
    type(variable_type), target, intent(in) :: a
    !! Left variable, borrowed until evaluation.
    type(expression_type), intent(in) :: b
    !! Right expression, copied into the result.
    type(expression_type) :: expr
  end function atan_var_expr

  module function atan_expr_var(a, b) result(expr)
    !! Build a deferred ATAN expression from two operands.
    type(expression_type), intent(in) :: a
    !! Left expression, copied into the result.
    type(variable_type), target, intent(in) :: b
    !! Right variable, borrowed until evaluation.
    type(expression_type) :: expr
  end function atan_expr_var

  module function atan_expr_expr(a, b) result(expr)
    !! Build a deferred ATAN expression from two operands.
    type(expression_type), intent(in) :: a
    !! Left expression, copied into the result.
    type(expression_type), intent(in) :: b
    !! Right expression, copied into the result.
    type(expression_type) :: expr
  end function atan_expr_expr

  module function atan_real32_var(a, b) result(expr)
    !! Build a deferred ATAN expression with a left scalar.
    real(real32), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable, borrowed until evaluation.
    type(expression_type) :: expr
  end function atan_real32_var

  module function atan_var_real32(a, b) result(expr)
    !! Build a deferred ATAN expression with a right scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable, borrowed until evaluation.
    real(real32), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function atan_var_real32

  module function atan_real32_expr(a, b) result(expr)
    !! Build a deferred ATAN expression with a left scalar.
    real(real32), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(expression_type), intent(in) :: b
    !! Right expression, copied into the result.
    type(expression_type) :: expr
  end function atan_real32_expr

  module function atan_expr_real32(a, b) result(expr)
    !! Build a deferred ATAN expression with a right scalar.
    type(expression_type), intent(in) :: a
    !! Left expression, copied into the result.
    real(real32), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function atan_expr_real32

  module function atan_real64_var(a, b) result(expr)
    !! Build a deferred ATAN expression with a left scalar.
    real(real64), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable, borrowed until evaluation.
    type(expression_type) :: expr
  end function atan_real64_var

  module function atan_var_real64(a, b) result(expr)
    !! Build a deferred ATAN expression with a right scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable, borrowed until evaluation.
    real(real64), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function atan_var_real64

  module function atan_real64_expr(a, b) result(expr)
    !! Build a deferred ATAN expression with a left scalar.
    real(real64), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(expression_type), intent(in) :: b
    !! Right expression, copied into the result.
    type(expression_type) :: expr
  end function atan_real64_expr

  module function atan_expr_real64(a, b) result(expr)
    !! Build a deferred ATAN expression with a right scalar.
    type(expression_type), intent(in) :: a
    !! Left expression, copied into the result.
    real(real64), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function atan_expr_real64

  module function hypot_var_var(a, b) result(expr)
    !! Build a deferred HYPOT expression from two operands.
    type(variable_type), target, intent(in) :: a
    !! Left variable, borrowed until evaluation.
    type(variable_type), target, intent(in) :: b
    !! Right variable, borrowed until evaluation.
    type(expression_type) :: expr
  end function hypot_var_var

  module function hypot_var_expr(a, b) result(expr)
    !! Build a deferred HYPOT expression from two operands.
    type(variable_type), target, intent(in) :: a
    !! Left variable, borrowed until evaluation.
    type(expression_type), intent(in) :: b
    !! Right expression, copied into the result.
    type(expression_type) :: expr
  end function hypot_var_expr

  module function hypot_expr_var(a, b) result(expr)
    !! Build a deferred HYPOT expression from two operands.
    type(expression_type), intent(in) :: a
    !! Left expression, copied into the result.
    type(variable_type), target, intent(in) :: b
    !! Right variable, borrowed until evaluation.
    type(expression_type) :: expr
  end function hypot_expr_var

  module function hypot_expr_expr(a, b) result(expr)
    !! Build a deferred HYPOT expression from two operands.
    type(expression_type), intent(in) :: a
    !! Left expression, copied into the result.
    type(expression_type), intent(in) :: b
    !! Right expression, copied into the result.
    type(expression_type) :: expr
  end function hypot_expr_expr

  module function hypot_real32_var(a, b) result(expr)
    !! Build a deferred HYPOT expression with a left scalar.
    real(real32), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable, borrowed until evaluation.
    type(expression_type) :: expr
  end function hypot_real32_var

  module function hypot_var_real32(a, b) result(expr)
    !! Build a deferred HYPOT expression with a right scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable, borrowed until evaluation.
    real(real32), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function hypot_var_real32

  module function hypot_real32_expr(a, b) result(expr)
    !! Build a deferred HYPOT expression with a left scalar.
    real(real32), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(expression_type), intent(in) :: b
    !! Right expression, copied into the result.
    type(expression_type) :: expr
  end function hypot_real32_expr

  module function hypot_expr_real32(a, b) result(expr)
    !! Build a deferred HYPOT expression with a right scalar.
    type(expression_type), intent(in) :: a
    !! Left expression, copied into the result.
    real(real32), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function hypot_expr_real32

  module function hypot_real64_var(a, b) result(expr)
    !! Build a deferred HYPOT expression with a left scalar.
    real(real64), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(variable_type), target, intent(in) :: b
    !! Right variable, borrowed until evaluation.
    type(expression_type) :: expr
  end function hypot_real64_var

  module function hypot_var_real64(a, b) result(expr)
    !! Build a deferred HYPOT expression with a right scalar.
    type(variable_type), target, intent(in) :: a
    !! Left variable, borrowed until evaluation.
    real(real64), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function hypot_var_real64

  module function hypot_real64_expr(a, b) result(expr)
    !! Build a deferred HYPOT expression with a left scalar.
    real(real64), intent(in) :: a
    !! Left scalar, stored by value in the expression.
    type(expression_type), intent(in) :: b
    !! Right expression, copied into the result.
    type(expression_type) :: expr
  end function hypot_real64_expr

  module function hypot_expr_real64(a, b) result(expr)
    !! Build a deferred HYPOT expression with a right scalar.
    type(expression_type), intent(in) :: a
    !! Left expression, copied into the result.
    real(real64), intent(in) :: b
    !! Right scalar, stored by value in the expression.
    type(expression_type) :: expr
  end function hypot_expr_real64
end interface
