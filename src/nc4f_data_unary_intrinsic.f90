submodule(nc4f_data) nc4f_data_unary_intrinsic
!! Build deferred elementwise intrinsic expressions.
implicit none (type, external)
contains

module function abs_var(a) result(expr)
  type(variable_type), target, intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_ABS
  allocate (expr%left)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
end function abs_var

module function abs_expr(a) result(expr)
  type(expression_type), intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_ABS
  allocate (expr%left)
  expr%left = a
end function abs_expr

module function sqrt_var(a) result(expr)
  type(variable_type), target, intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_SQRT
  allocate (expr%left)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
end function sqrt_var

module function sqrt_expr(a) result(expr)
  type(expression_type), intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_SQRT
  allocate (expr%left)
  expr%left = a
end function sqrt_expr

module function exp_var(a) result(expr)
  type(variable_type), target, intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_EXP
  allocate (expr%left)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
end function exp_var

module function exp_expr(a) result(expr)
  type(expression_type), intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_EXP
  allocate (expr%left)
  expr%left = a
end function exp_expr

module function log_var(a) result(expr)
  type(variable_type), target, intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_LOG
  allocate (expr%left)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
end function log_var

module function log_expr(a) result(expr)
  type(expression_type), intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_LOG
  allocate (expr%left)
  expr%left = a
end function log_expr

module function log10_var(a) result(expr)
  type(variable_type), target, intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_LOG10
  allocate (expr%left)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
end function log10_var

module function log10_expr(a) result(expr)
  type(expression_type), intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_LOG10
  allocate (expr%left)
  expr%left = a
end function log10_expr

module function sin_var(a) result(expr)
  type(variable_type), target, intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_SIN
  allocate (expr%left)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
end function sin_var

module function sin_expr(a) result(expr)
  type(expression_type), intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_SIN
  allocate (expr%left)
  expr%left = a
end function sin_expr

module function cos_var(a) result(expr)
  type(variable_type), target, intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_COS
  allocate (expr%left)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
end function cos_var

module function cos_expr(a) result(expr)
  type(expression_type), intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_COS
  allocate (expr%left)
  expr%left = a
end function cos_expr

module function tan_var(a) result(expr)
  type(variable_type), target, intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_TAN
  allocate (expr%left)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
end function tan_var

module function tan_expr(a) result(expr)
  type(expression_type), intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_TAN
  allocate (expr%left)
  expr%left = a
end function tan_expr

module function asin_var(a) result(expr)
  type(variable_type), target, intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_ASIN
  allocate (expr%left)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
end function asin_var

module function asin_expr(a) result(expr)
  type(expression_type), intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_ASIN
  allocate (expr%left)
  expr%left = a
end function asin_expr

module function acos_var(a) result(expr)
  type(variable_type), target, intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_ACOS
  allocate (expr%left)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
end function acos_var

module function acos_expr(a) result(expr)
  type(expression_type), intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_ACOS
  allocate (expr%left)
  expr%left = a
end function acos_expr

module function atan_var(a) result(expr)
  type(variable_type), target, intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_ATAN
  allocate (expr%left)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
end function atan_var

module function atan_expr(a) result(expr)
  type(expression_type), intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_ATAN
  allocate (expr%left)
  expr%left = a
end function atan_expr

module function sinh_var(a) result(expr)
  type(variable_type), target, intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_SINH
  allocate (expr%left)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
end function sinh_var

module function sinh_expr(a) result(expr)
  type(expression_type), intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_SINH
  allocate (expr%left)
  expr%left = a
end function sinh_expr

module function cosh_var(a) result(expr)
  type(variable_type), target, intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_COSH
  allocate (expr%left)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
end function cosh_var

module function cosh_expr(a) result(expr)
  type(expression_type), intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_COSH
  allocate (expr%left)
  expr%left = a
end function cosh_expr

module function tanh_var(a) result(expr)
  type(variable_type), target, intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_TANH
  allocate (expr%left)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
end function tanh_var

module function tanh_expr(a) result(expr)
  type(expression_type), intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_TANH
  allocate (expr%left)
  expr%left = a
end function tanh_expr

module function asinh_var(a) result(expr)
  type(variable_type), target, intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_ASINH
  allocate (expr%left)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
end function asinh_var

module function asinh_expr(a) result(expr)
  type(expression_type), intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_ASINH
  allocate (expr%left)
  expr%left = a
end function asinh_expr

module function acosh_var(a) result(expr)
  type(variable_type), target, intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_ACOSH
  allocate (expr%left)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
end function acosh_var

module function acosh_expr(a) result(expr)
  type(expression_type), intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_ACOSH
  allocate (expr%left)
  expr%left = a
end function acosh_expr

module function atanh_var(a) result(expr)
  type(variable_type), target, intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_ATANH
  allocate (expr%left)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
end function atanh_var

module function atanh_expr(a) result(expr)
  type(expression_type), intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_ATANH
  allocate (expr%left)
  expr%left = a
end function atanh_expr

module function erf_var(a) result(expr)
  type(variable_type), target, intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_ERF
  allocate (expr%left)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
end function erf_var

module function erf_expr(a) result(expr)
  type(expression_type), intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_ERF
  allocate (expr%left)
  expr%left = a
end function erf_expr

module function erfc_var(a) result(expr)
  type(variable_type), target, intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_ERFC
  allocate (expr%left)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
end function erfc_var

module function erfc_expr(a) result(expr)
  type(expression_type), intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_ERFC
  allocate (expr%left)
  expr%left = a
end function erfc_expr

module function erfc_scaled_var(a) result(expr)
  type(variable_type), target, intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_ERFC_SCALED
  allocate (expr%left)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
end function erfc_scaled_var

module function erfc_scaled_expr(a) result(expr)
  type(expression_type), intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_ERFC_SCALED
  allocate (expr%left)
  expr%left = a
end function erfc_scaled_expr

module function gamma_var(a) result(expr)
  type(variable_type), target, intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_GAMMA
  allocate (expr%left)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
end function gamma_var

module function gamma_expr(a) result(expr)
  type(expression_type), intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_GAMMA
  allocate (expr%left)
  expr%left = a
end function gamma_expr

module function log_gamma_var(a) result(expr)
  type(variable_type), target, intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_LOG_GAMMA
  allocate (expr%left)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
end function log_gamma_var

module function log_gamma_expr(a) result(expr)
  type(expression_type), intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_LOG_GAMMA
  allocate (expr%left)
  expr%left = a
end function log_gamma_expr

module function bessel_j0_var(a) result(expr)
  type(variable_type), target, intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_BESSEL_J0
  allocate (expr%left)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
end function bessel_j0_var

module function bessel_j0_expr(a) result(expr)
  type(expression_type), intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_BESSEL_J0
  allocate (expr%left)
  expr%left = a
end function bessel_j0_expr

module function bessel_j1_var(a) result(expr)
  type(variable_type), target, intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_BESSEL_J1
  allocate (expr%left)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
end function bessel_j1_var

module function bessel_j1_expr(a) result(expr)
  type(expression_type), intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_BESSEL_J1
  allocate (expr%left)
  expr%left = a
end function bessel_j1_expr

module function bessel_y0_var(a) result(expr)
  type(variable_type), target, intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_BESSEL_Y0
  allocate (expr%left)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
end function bessel_y0_var

module function bessel_y0_expr(a) result(expr)
  type(expression_type), intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_BESSEL_Y0
  allocate (expr%left)
  expr%left = a
end function bessel_y0_expr

module function bessel_y1_var(a) result(expr)
  type(variable_type), target, intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_BESSEL_Y1
  allocate (expr%left)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
end function bessel_y1_var

module function bessel_y1_expr(a) result(expr)
  type(expression_type), intent(in) :: a
  type(expression_type) :: expr

  expr%operation = OP_BESSEL_Y1
  allocate (expr%left)
  expr%left = a
end function bessel_y1_expr

end submodule nc4f_data_unary_intrinsic
