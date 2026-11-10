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
end interface