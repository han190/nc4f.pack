submodule(nc4f_data) nc4f_data_intrinsic
!! Build deferred element-wise intrinsic expressions. Variable leaves borrow
!! their data; expression operands are copied into the new unary node.
!! Metadata checks precede evaluation; numerical domains follow Fortran.
implicit none (type, external)
contains

module function abs_var(a) result(expr)
  !! Build a deferred ABS node from a borrowed variable.
  type(variable_type), target, intent(in) :: a
  !! Input variable; its storage is borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_ABS
  allocate (expr%left)
  call init_expr_leaf(a, expr%left)
  call init_expr_workspace(expr)
end function abs_var

module function abs_expr(a) result(expr)
  !! Build a deferred ABS node from a copied expression.
  type(expression_type), intent(in) :: a
  !! Input expression; its nodes are copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_ABS
  allocate (expr%left)
  expr%left = a
  call init_expr_workspace(expr)
end function abs_expr

module function sqrt_var(a) result(expr)
  !! Build a deferred SQRT node from a borrowed variable.
  type(variable_type), target, intent(in) :: a
  !! Input variable; its storage is borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_SQRT
  allocate (expr%left)
  call init_expr_leaf(a, expr%left)
  call init_expr_workspace(expr)
end function sqrt_var

module function sqrt_expr(a) result(expr)
  !! Build a deferred SQRT node from a copied expression.
  type(expression_type), intent(in) :: a
  !! Input expression; its nodes are copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_SQRT
  allocate (expr%left)
  expr%left = a
  call init_expr_workspace(expr)
end function sqrt_expr

module function exp_var(a) result(expr)
  !! Build a deferred EXP node from a borrowed variable.
  type(variable_type), target, intent(in) :: a
  !! Input variable; its storage is borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_EXP
  allocate (expr%left)
  call init_expr_leaf(a, expr%left)
  call init_expr_workspace(expr)
end function exp_var

module function exp_expr(a) result(expr)
  !! Build a deferred EXP node from a copied expression.
  type(expression_type), intent(in) :: a
  !! Input expression; its nodes are copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_EXP
  allocate (expr%left)
  expr%left = a
  call init_expr_workspace(expr)
end function exp_expr

module function log_var(a) result(expr)
  !! Build a deferred LOG node from a borrowed variable.
  type(variable_type), target, intent(in) :: a
  !! Input variable; its storage is borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_LOG
  allocate (expr%left)
  call init_expr_leaf(a, expr%left)
  call init_expr_workspace(expr)
end function log_var

module function log_expr(a) result(expr)
  !! Build a deferred LOG node from a copied expression.
  type(expression_type), intent(in) :: a
  !! Input expression; its nodes are copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_LOG
  allocate (expr%left)
  expr%left = a
  call init_expr_workspace(expr)
end function log_expr

module function log10_var(a) result(expr)
  !! Build a deferred LOG10 node from a borrowed variable.
  type(variable_type), target, intent(in) :: a
  !! Input variable; its storage is borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_LOG10
  allocate (expr%left)
  call init_expr_leaf(a, expr%left)
  call init_expr_workspace(expr)
end function log10_var

module function log10_expr(a) result(expr)
  !! Build a deferred LOG10 node from a copied expression.
  type(expression_type), intent(in) :: a
  !! Input expression; its nodes are copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_LOG10
  allocate (expr%left)
  expr%left = a
  call init_expr_workspace(expr)
end function log10_expr

module function sin_var(a) result(expr)
  !! Build a deferred SIN node from a borrowed variable.
  type(variable_type), target, intent(in) :: a
  !! Input variable; its storage is borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_SIN
  allocate (expr%left)
  call init_expr_leaf(a, expr%left)
  call init_expr_workspace(expr)
end function sin_var

module function sin_expr(a) result(expr)
  !! Build a deferred SIN node from a copied expression.
  type(expression_type), intent(in) :: a
  !! Input expression; its nodes are copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_SIN
  allocate (expr%left)
  expr%left = a
  call init_expr_workspace(expr)
end function sin_expr

module function cos_var(a) result(expr)
  !! Build a deferred COS node from a borrowed variable.
  type(variable_type), target, intent(in) :: a
  !! Input variable; its storage is borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_COS
  allocate (expr%left)
  call init_expr_leaf(a, expr%left)
  call init_expr_workspace(expr)
end function cos_var

module function cos_expr(a) result(expr)
  !! Build a deferred COS node from a copied expression.
  type(expression_type), intent(in) :: a
  !! Input expression; its nodes are copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_COS
  allocate (expr%left)
  expr%left = a
  call init_expr_workspace(expr)
end function cos_expr

module function tan_var(a) result(expr)
  !! Build a deferred TAN node from a borrowed variable.
  type(variable_type), target, intent(in) :: a
  !! Input variable; its storage is borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_TAN
  allocate (expr%left)
  call init_expr_leaf(a, expr%left)
  call init_expr_workspace(expr)
end function tan_var

module function tan_expr(a) result(expr)
  !! Build a deferred TAN node from a copied expression.
  type(expression_type), intent(in) :: a
  !! Input expression; its nodes are copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_TAN
  allocate (expr%left)
  expr%left = a
  call init_expr_workspace(expr)
end function tan_expr

module function asin_var(a) result(expr)
  !! Build a deferred ASIN node from a borrowed variable.
  type(variable_type), target, intent(in) :: a
  !! Input variable; its storage is borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_ASIN
  allocate (expr%left)
  call init_expr_leaf(a, expr%left)
  call init_expr_workspace(expr)
end function asin_var

module function asin_expr(a) result(expr)
  !! Build a deferred ASIN node from a copied expression.
  type(expression_type), intent(in) :: a
  !! Input expression; its nodes are copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_ASIN
  allocate (expr%left)
  expr%left = a
  call init_expr_workspace(expr)
end function asin_expr

module function acos_var(a) result(expr)
  !! Build a deferred ACOS node from a borrowed variable.
  type(variable_type), target, intent(in) :: a
  !! Input variable; its storage is borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_ACOS
  allocate (expr%left)
  call init_expr_leaf(a, expr%left)
  call init_expr_workspace(expr)
end function acos_var

module function acos_expr(a) result(expr)
  !! Build a deferred ACOS node from a copied expression.
  type(expression_type), intent(in) :: a
  !! Input expression; its nodes are copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_ACOS
  allocate (expr%left)
  expr%left = a
  call init_expr_workspace(expr)
end function acos_expr

module function atan_var(a) result(expr)
  !! Build a deferred ATAN node from a borrowed variable.
  type(variable_type), target, intent(in) :: a
  !! Input variable; its storage is borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_ATAN
  allocate (expr%left)
  call init_expr_leaf(a, expr%left)
  call init_expr_workspace(expr)
end function atan_var

module function atan_expr(a) result(expr)
  !! Build a deferred ATAN node from a copied expression.
  type(expression_type), intent(in) :: a
  !! Input expression; its nodes are copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_ATAN
  allocate (expr%left)
  expr%left = a
  call init_expr_workspace(expr)
end function atan_expr

module function sinh_var(a) result(expr)
  !! Build a deferred SINH node from a borrowed variable.
  type(variable_type), target, intent(in) :: a
  !! Input variable; its storage is borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_SINH
  allocate (expr%left)
  call init_expr_leaf(a, expr%left)
  call init_expr_workspace(expr)
end function sinh_var

module function sinh_expr(a) result(expr)
  !! Build a deferred SINH node from a copied expression.
  type(expression_type), intent(in) :: a
  !! Input expression; its nodes are copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_SINH
  allocate (expr%left)
  expr%left = a
  call init_expr_workspace(expr)
end function sinh_expr

module function cosh_var(a) result(expr)
  !! Build a deferred COSH node from a borrowed variable.
  type(variable_type), target, intent(in) :: a
  !! Input variable; its storage is borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_COSH
  allocate (expr%left)
  call init_expr_leaf(a, expr%left)
  call init_expr_workspace(expr)
end function cosh_var

module function cosh_expr(a) result(expr)
  !! Build a deferred COSH node from a copied expression.
  type(expression_type), intent(in) :: a
  !! Input expression; its nodes are copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_COSH
  allocate (expr%left)
  expr%left = a
  call init_expr_workspace(expr)
end function cosh_expr

module function tanh_var(a) result(expr)
  !! Build a deferred TANH node from a borrowed variable.
  type(variable_type), target, intent(in) :: a
  !! Input variable; its storage is borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_TANH
  allocate (expr%left)
  call init_expr_leaf(a, expr%left)
  call init_expr_workspace(expr)
end function tanh_var

module function tanh_expr(a) result(expr)
  !! Build a deferred TANH node from a copied expression.
  type(expression_type), intent(in) :: a
  !! Input expression; its nodes are copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_TANH
  allocate (expr%left)
  expr%left = a
  call init_expr_workspace(expr)
end function tanh_expr

module function asinh_var(a) result(expr)
  !! Build a deferred ASINH node from a borrowed variable.
  type(variable_type), target, intent(in) :: a
  !! Input variable; its storage is borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_ASINH
  allocate (expr%left)
  call init_expr_leaf(a, expr%left)
  call init_expr_workspace(expr)
end function asinh_var

module function asinh_expr(a) result(expr)
  !! Build a deferred ASINH node from a copied expression.
  type(expression_type), intent(in) :: a
  !! Input expression; its nodes are copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_ASINH
  allocate (expr%left)
  expr%left = a
  call init_expr_workspace(expr)
end function asinh_expr

module function acosh_var(a) result(expr)
  !! Build a deferred ACOSH node from a borrowed variable.
  type(variable_type), target, intent(in) :: a
  !! Input variable; its storage is borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_ACOSH
  allocate (expr%left)
  call init_expr_leaf(a, expr%left)
  call init_expr_workspace(expr)
end function acosh_var

module function acosh_expr(a) result(expr)
  !! Build a deferred ACOSH node from a copied expression.
  type(expression_type), intent(in) :: a
  !! Input expression; its nodes are copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_ACOSH
  allocate (expr%left)
  expr%left = a
  call init_expr_workspace(expr)
end function acosh_expr

module function atanh_var(a) result(expr)
  !! Build a deferred ATANH node from a borrowed variable.
  type(variable_type), target, intent(in) :: a
  !! Input variable; its storage is borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_ATANH
  allocate (expr%left)
  call init_expr_leaf(a, expr%left)
  call init_expr_workspace(expr)
end function atanh_var

module function atanh_expr(a) result(expr)
  !! Build a deferred ATANH node from a copied expression.
  type(expression_type), intent(in) :: a
  !! Input expression; its nodes are copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_ATANH
  allocate (expr%left)
  expr%left = a
  call init_expr_workspace(expr)
end function atanh_expr

module function erf_var(a) result(expr)
  !! Build a deferred ERF node from a borrowed variable.
  type(variable_type), target, intent(in) :: a
  !! Input variable; its storage is borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_ERF
  allocate (expr%left)
  call init_expr_leaf(a, expr%left)
  call init_expr_workspace(expr)
end function erf_var

module function erf_expr(a) result(expr)
  !! Build a deferred ERF node from a copied expression.
  type(expression_type), intent(in) :: a
  !! Input expression; its nodes are copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_ERF
  allocate (expr%left)
  expr%left = a
  call init_expr_workspace(expr)
end function erf_expr

module function erfc_var(a) result(expr)
  !! Build a deferred ERFC node from a borrowed variable.
  type(variable_type), target, intent(in) :: a
  !! Input variable; its storage is borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_ERFC
  allocate (expr%left)
  call init_expr_leaf(a, expr%left)
  call init_expr_workspace(expr)
end function erfc_var

module function erfc_expr(a) result(expr)
  !! Build a deferred ERFC node from a copied expression.
  type(expression_type), intent(in) :: a
  !! Input expression; its nodes are copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_ERFC
  allocate (expr%left)
  expr%left = a
  call init_expr_workspace(expr)
end function erfc_expr

module function erfc_scaled_var(a) result(expr)
  !! Build a deferred ERFC_SCALED node from a borrowed variable.
  type(variable_type), target, intent(in) :: a
  !! Input variable; its storage is borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_ERFC_SCALED
  allocate (expr%left)
  call init_expr_leaf(a, expr%left)
  call init_expr_workspace(expr)
end function erfc_scaled_var

module function erfc_scaled_expr(a) result(expr)
  !! Build a deferred ERFC_SCALED node from a copied expression.
  type(expression_type), intent(in) :: a
  !! Input expression; its nodes are copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_ERFC_SCALED
  allocate (expr%left)
  expr%left = a
  call init_expr_workspace(expr)
end function erfc_scaled_expr

module function gamma_var(a) result(expr)
  !! Build a deferred GAMMA node from a borrowed variable.
  type(variable_type), target, intent(in) :: a
  !! Input variable; its storage is borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_GAMMA
  allocate (expr%left)
  call init_expr_leaf(a, expr%left)
  call init_expr_workspace(expr)
end function gamma_var

module function gamma_expr(a) result(expr)
  !! Build a deferred GAMMA node from a copied expression.
  type(expression_type), intent(in) :: a
  !! Input expression; its nodes are copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_GAMMA
  allocate (expr%left)
  expr%left = a
  call init_expr_workspace(expr)
end function gamma_expr

module function log_gamma_var(a) result(expr)
  !! Build a deferred LOG_GAMMA node from a borrowed variable.
  type(variable_type), target, intent(in) :: a
  !! Input variable; its storage is borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_LOG_GAMMA
  allocate (expr%left)
  call init_expr_leaf(a, expr%left)
  call init_expr_workspace(expr)
end function log_gamma_var

module function log_gamma_expr(a) result(expr)
  !! Build a deferred LOG_GAMMA node from a copied expression.
  type(expression_type), intent(in) :: a
  !! Input expression; its nodes are copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_LOG_GAMMA
  allocate (expr%left)
  expr%left = a
  call init_expr_workspace(expr)
end function log_gamma_expr

module function bessel_j0_var(a) result(expr)
  !! Build a deferred BESSEL_J0 node from a borrowed variable.
  type(variable_type), target, intent(in) :: a
  !! Input variable; its storage is borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_BESSEL_J0
  allocate (expr%left)
  call init_expr_leaf(a, expr%left)
  call init_expr_workspace(expr)
end function bessel_j0_var

module function bessel_j0_expr(a) result(expr)
  !! Build a deferred BESSEL_J0 node from a copied expression.
  type(expression_type), intent(in) :: a
  !! Input expression; its nodes are copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_BESSEL_J0
  allocate (expr%left)
  expr%left = a
  call init_expr_workspace(expr)
end function bessel_j0_expr

module function bessel_j1_var(a) result(expr)
  !! Build a deferred BESSEL_J1 node from a borrowed variable.
  type(variable_type), target, intent(in) :: a
  !! Input variable; its storage is borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_BESSEL_J1
  allocate (expr%left)
  call init_expr_leaf(a, expr%left)
  call init_expr_workspace(expr)
end function bessel_j1_var

module function bessel_j1_expr(a) result(expr)
  !! Build a deferred BESSEL_J1 node from a copied expression.
  type(expression_type), intent(in) :: a
  !! Input expression; its nodes are copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_BESSEL_J1
  allocate (expr%left)
  expr%left = a
  call init_expr_workspace(expr)
end function bessel_j1_expr

module function bessel_y0_var(a) result(expr)
  !! Build a deferred BESSEL_Y0 node from a borrowed variable.
  type(variable_type), target, intent(in) :: a
  !! Input variable; its storage is borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_BESSEL_Y0
  allocate (expr%left)
  call init_expr_leaf(a, expr%left)
  call init_expr_workspace(expr)
end function bessel_y0_var

module function bessel_y0_expr(a) result(expr)
  !! Build a deferred BESSEL_Y0 node from a copied expression.
  type(expression_type), intent(in) :: a
  !! Input expression; its nodes are copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_BESSEL_Y0
  allocate (expr%left)
  expr%left = a
  call init_expr_workspace(expr)
end function bessel_y0_expr

module function bessel_y1_var(a) result(expr)
  !! Build a deferred BESSEL_Y1 node from a borrowed variable.
  type(variable_type), target, intent(in) :: a
  !! Input variable; its storage is borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_BESSEL_Y1
  allocate (expr%left)
  call init_expr_leaf(a, expr%left)
  call init_expr_workspace(expr)
end function bessel_y1_var

module function bessel_y1_expr(a) result(expr)
  !! Build a deferred BESSEL_Y1 node from a copied expression.
  type(expression_type), intent(in) :: a
  !! Input expression; its nodes are copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_BESSEL_Y1
  allocate (expr%left)
  expr%left = a
  call init_expr_workspace(expr)
end function bessel_y1_expr

module function dim_var_var(a, b) result(expr)
  !! Build a deferred DIM node from two operands.
  type(variable_type), target, intent(in) :: a
  !! Left variable, borrowed until evaluation.
  type(variable_type), target, intent(in) :: b
  !! Right variable, borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_DIM
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function dim_var_var

module function dim_var_expr(a, b) result(expr)
  !! Build a deferred DIM node from two operands.
  type(variable_type), target, intent(in) :: a
  !! Left variable, borrowed until evaluation.
  type(expression_type), intent(in) :: b
  !! Right expression, copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_DIM
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right = b
  call init_expr_workspace(expr)
end function dim_var_expr

module function dim_expr_var(a, b) result(expr)
  !! Build a deferred DIM node from two operands.
  type(expression_type), intent(in) :: a
  !! Left expression, copied into the result.
  type(variable_type), target, intent(in) :: b
  !! Right variable, borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_DIM
  allocate (expr%left, expr%right)
  expr%left = a
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function dim_expr_var

module function dim_expr_expr(a, b) result(expr)
  !! Build a deferred DIM node from two operands.
  type(expression_type), intent(in) :: a
  !! Left expression, copied into the result.
  type(expression_type), intent(in) :: b
  !! Right expression, copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_DIM
  allocate (expr%left, expr%right)
  expr%left = a
  expr%right = b
  call init_expr_workspace(expr)
end function dim_expr_expr

module function dim_int8_var(a, b) result(expr)
  !! Build a deferred DIM node with a left scalar.
  integer(int8), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable, borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_DIM
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT8
  expr%left%exp_int = int(a, int64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function dim_int8_var

module function dim_var_int8(a, b) result(expr)
  !! Build a deferred DIM node with a right scalar.
  type(variable_type), target, intent(in) :: a
  !! Left variable, borrowed until evaluation.
  integer(int8), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_DIM
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_INT8
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function dim_var_int8

module function dim_int8_expr(a, b) result(expr)
  !! Build a deferred DIM node with a left scalar.
  integer(int8), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression, copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_DIM
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT8
  expr%left%exp_int = int(a, int64)
  expr%right = b
  call init_expr_workspace(expr)
end function dim_int8_expr

module function dim_expr_int8(a, b) result(expr)
  !! Build a deferred DIM node with a right scalar.
  type(expression_type), intent(in) :: a
  !! Left expression, copied into the result.
  integer(int8), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_DIM
  allocate (expr%left, expr%right)
  expr%left = a
  expr%right%operation = OP_SCALAR_INT8
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function dim_expr_int8

module function dim_int16_var(a, b) result(expr)
  !! Build a deferred DIM node with a left scalar.
  integer(int16), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable, borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_DIM
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT16
  expr%left%exp_int = int(a, int64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function dim_int16_var

module function dim_var_int16(a, b) result(expr)
  !! Build a deferred DIM node with a right scalar.
  type(variable_type), target, intent(in) :: a
  !! Left variable, borrowed until evaluation.
  integer(int16), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_DIM
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_INT16
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function dim_var_int16

module function dim_int16_expr(a, b) result(expr)
  !! Build a deferred DIM node with a left scalar.
  integer(int16), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression, copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_DIM
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT16
  expr%left%exp_int = int(a, int64)
  expr%right = b
  call init_expr_workspace(expr)
end function dim_int16_expr

module function dim_expr_int16(a, b) result(expr)
  !! Build a deferred DIM node with a right scalar.
  type(expression_type), intent(in) :: a
  !! Left expression, copied into the result.
  integer(int16), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_DIM
  allocate (expr%left, expr%right)
  expr%left = a
  expr%right%operation = OP_SCALAR_INT16
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function dim_expr_int16

module function dim_int32_var(a, b) result(expr)
  !! Build a deferred DIM node with a left scalar.
  integer(int32), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable, borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_DIM
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT32
  expr%left%exp_int = int(a, int64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function dim_int32_var

module function dim_var_int32(a, b) result(expr)
  !! Build a deferred DIM node with a right scalar.
  type(variable_type), target, intent(in) :: a
  !! Left variable, borrowed until evaluation.
  integer(int32), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_DIM
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_INT32
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function dim_var_int32

module function dim_int32_expr(a, b) result(expr)
  !! Build a deferred DIM node with a left scalar.
  integer(int32), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression, copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_DIM
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT32
  expr%left%exp_int = int(a, int64)
  expr%right = b
  call init_expr_workspace(expr)
end function dim_int32_expr

module function dim_expr_int32(a, b) result(expr)
  !! Build a deferred DIM node with a right scalar.
  type(expression_type), intent(in) :: a
  !! Left expression, copied into the result.
  integer(int32), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_DIM
  allocate (expr%left, expr%right)
  expr%left = a
  expr%right%operation = OP_SCALAR_INT32
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function dim_expr_int32

module function dim_int64_var(a, b) result(expr)
  !! Build a deferred DIM node with a left scalar.
  integer(int64), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable, borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_DIM
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT64
  expr%left%exp_int = int(a, int64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function dim_int64_var

module function dim_var_int64(a, b) result(expr)
  !! Build a deferred DIM node with a right scalar.
  type(variable_type), target, intent(in) :: a
  !! Left variable, borrowed until evaluation.
  integer(int64), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_DIM
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_INT64
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function dim_var_int64

module function dim_int64_expr(a, b) result(expr)
  !! Build a deferred DIM node with a left scalar.
  integer(int64), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression, copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_DIM
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT64
  expr%left%exp_int = int(a, int64)
  expr%right = b
  call init_expr_workspace(expr)
end function dim_int64_expr

module function dim_expr_int64(a, b) result(expr)
  !! Build a deferred DIM node with a right scalar.
  type(expression_type), intent(in) :: a
  !! Left expression, copied into the result.
  integer(int64), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_DIM
  allocate (expr%left, expr%right)
  expr%left = a
  expr%right%operation = OP_SCALAR_INT64
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function dim_expr_int64

module function dim_real32_var(a, b) result(expr)
  !! Build a deferred DIM node with a left scalar.
  real(real32), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable, borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_DIM
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL32
  expr%left%exp_real = real(a, real64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function dim_real32_var

module function dim_var_real32(a, b) result(expr)
  !! Build a deferred DIM node with a right scalar.
  type(variable_type), target, intent(in) :: a
  !! Left variable, borrowed until evaluation.
  real(real32), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_DIM
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_REAL32
  expr%right%exp_real = real(b, real64)
  call init_expr_workspace(expr)
end function dim_var_real32

module function dim_real32_expr(a, b) result(expr)
  !! Build a deferred DIM node with a left scalar.
  real(real32), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression, copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_DIM
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL32
  expr%left%exp_real = real(a, real64)
  expr%right = b
  call init_expr_workspace(expr)
end function dim_real32_expr

module function dim_expr_real32(a, b) result(expr)
  !! Build a deferred DIM node with a right scalar.
  type(expression_type), intent(in) :: a
  !! Left expression, copied into the result.
  real(real32), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_DIM
  allocate (expr%left, expr%right)
  expr%left = a
  expr%right%operation = OP_SCALAR_REAL32
  expr%right%exp_real = real(b, real64)
  call init_expr_workspace(expr)
end function dim_expr_real32

module function dim_real64_var(a, b) result(expr)
  !! Build a deferred DIM node with a left scalar.
  real(real64), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable, borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_DIM
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL64
  expr%left%exp_real = real(a, real64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function dim_real64_var

module function dim_var_real64(a, b) result(expr)
  !! Build a deferred DIM node with a right scalar.
  type(variable_type), target, intent(in) :: a
  !! Left variable, borrowed until evaluation.
  real(real64), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_DIM
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_REAL64
  expr%right%exp_real = real(b, real64)
  call init_expr_workspace(expr)
end function dim_var_real64

module function dim_real64_expr(a, b) result(expr)
  !! Build a deferred DIM node with a left scalar.
  real(real64), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression, copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_DIM
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL64
  expr%left%exp_real = real(a, real64)
  expr%right = b
  call init_expr_workspace(expr)
end function dim_real64_expr

module function dim_expr_real64(a, b) result(expr)
  !! Build a deferred DIM node with a right scalar.
  type(expression_type), intent(in) :: a
  !! Left expression, copied into the result.
  real(real64), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_DIM
  allocate (expr%left, expr%right)
  expr%left = a
  expr%right%operation = OP_SCALAR_REAL64
  expr%right%exp_real = real(b, real64)
  call init_expr_workspace(expr)
end function dim_expr_real64

module function sign_var_var(a, b) result(expr)
  !! Build a deferred SIGN node from two operands.
  type(variable_type), target, intent(in) :: a
  !! Left variable, borrowed until evaluation.
  type(variable_type), target, intent(in) :: b
  !! Right variable, borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_SIGN
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function sign_var_var

module function sign_var_expr(a, b) result(expr)
  !! Build a deferred SIGN node from two operands.
  type(variable_type), target, intent(in) :: a
  !! Left variable, borrowed until evaluation.
  type(expression_type), intent(in) :: b
  !! Right expression, copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_SIGN
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right = b
  call init_expr_workspace(expr)
end function sign_var_expr

module function sign_expr_var(a, b) result(expr)
  !! Build a deferred SIGN node from two operands.
  type(expression_type), intent(in) :: a
  !! Left expression, copied into the result.
  type(variable_type), target, intent(in) :: b
  !! Right variable, borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_SIGN
  allocate (expr%left, expr%right)
  expr%left = a
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function sign_expr_var

module function sign_expr_expr(a, b) result(expr)
  !! Build a deferred SIGN node from two operands.
  type(expression_type), intent(in) :: a
  !! Left expression, copied into the result.
  type(expression_type), intent(in) :: b
  !! Right expression, copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_SIGN
  allocate (expr%left, expr%right)
  expr%left = a
  expr%right = b
  call init_expr_workspace(expr)
end function sign_expr_expr

module function sign_int8_var(a, b) result(expr)
  !! Build a deferred SIGN node with a left scalar.
  integer(int8), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable, borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_SIGN
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT8
  expr%left%exp_int = int(a, int64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function sign_int8_var

module function sign_var_int8(a, b) result(expr)
  !! Build a deferred SIGN node with a right scalar.
  type(variable_type), target, intent(in) :: a
  !! Left variable, borrowed until evaluation.
  integer(int8), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_SIGN
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_INT8
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function sign_var_int8

module function sign_int8_expr(a, b) result(expr)
  !! Build a deferred SIGN node with a left scalar.
  integer(int8), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression, copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_SIGN
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT8
  expr%left%exp_int = int(a, int64)
  expr%right = b
  call init_expr_workspace(expr)
end function sign_int8_expr

module function sign_expr_int8(a, b) result(expr)
  !! Build a deferred SIGN node with a right scalar.
  type(expression_type), intent(in) :: a
  !! Left expression, copied into the result.
  integer(int8), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_SIGN
  allocate (expr%left, expr%right)
  expr%left = a
  expr%right%operation = OP_SCALAR_INT8
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function sign_expr_int8

module function sign_int16_var(a, b) result(expr)
  !! Build a deferred SIGN node with a left scalar.
  integer(int16), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable, borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_SIGN
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT16
  expr%left%exp_int = int(a, int64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function sign_int16_var

module function sign_var_int16(a, b) result(expr)
  !! Build a deferred SIGN node with a right scalar.
  type(variable_type), target, intent(in) :: a
  !! Left variable, borrowed until evaluation.
  integer(int16), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_SIGN
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_INT16
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function sign_var_int16

module function sign_int16_expr(a, b) result(expr)
  !! Build a deferred SIGN node with a left scalar.
  integer(int16), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression, copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_SIGN
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT16
  expr%left%exp_int = int(a, int64)
  expr%right = b
  call init_expr_workspace(expr)
end function sign_int16_expr

module function sign_expr_int16(a, b) result(expr)
  !! Build a deferred SIGN node with a right scalar.
  type(expression_type), intent(in) :: a
  !! Left expression, copied into the result.
  integer(int16), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_SIGN
  allocate (expr%left, expr%right)
  expr%left = a
  expr%right%operation = OP_SCALAR_INT16
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function sign_expr_int16

module function sign_int32_var(a, b) result(expr)
  !! Build a deferred SIGN node with a left scalar.
  integer(int32), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable, borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_SIGN
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT32
  expr%left%exp_int = int(a, int64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function sign_int32_var

module function sign_var_int32(a, b) result(expr)
  !! Build a deferred SIGN node with a right scalar.
  type(variable_type), target, intent(in) :: a
  !! Left variable, borrowed until evaluation.
  integer(int32), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_SIGN
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_INT32
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function sign_var_int32

module function sign_int32_expr(a, b) result(expr)
  !! Build a deferred SIGN node with a left scalar.
  integer(int32), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression, copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_SIGN
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT32
  expr%left%exp_int = int(a, int64)
  expr%right = b
  call init_expr_workspace(expr)
end function sign_int32_expr

module function sign_expr_int32(a, b) result(expr)
  !! Build a deferred SIGN node with a right scalar.
  type(expression_type), intent(in) :: a
  !! Left expression, copied into the result.
  integer(int32), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_SIGN
  allocate (expr%left, expr%right)
  expr%left = a
  expr%right%operation = OP_SCALAR_INT32
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function sign_expr_int32

module function sign_int64_var(a, b) result(expr)
  !! Build a deferred SIGN node with a left scalar.
  integer(int64), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable, borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_SIGN
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT64
  expr%left%exp_int = int(a, int64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function sign_int64_var

module function sign_var_int64(a, b) result(expr)
  !! Build a deferred SIGN node with a right scalar.
  type(variable_type), target, intent(in) :: a
  !! Left variable, borrowed until evaluation.
  integer(int64), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_SIGN
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_INT64
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function sign_var_int64

module function sign_int64_expr(a, b) result(expr)
  !! Build a deferred SIGN node with a left scalar.
  integer(int64), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression, copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_SIGN
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT64
  expr%left%exp_int = int(a, int64)
  expr%right = b
  call init_expr_workspace(expr)
end function sign_int64_expr

module function sign_expr_int64(a, b) result(expr)
  !! Build a deferred SIGN node with a right scalar.
  type(expression_type), intent(in) :: a
  !! Left expression, copied into the result.
  integer(int64), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_SIGN
  allocate (expr%left, expr%right)
  expr%left = a
  expr%right%operation = OP_SCALAR_INT64
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function sign_expr_int64

module function sign_real32_var(a, b) result(expr)
  !! Build a deferred SIGN node with a left scalar.
  real(real32), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable, borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_SIGN
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL32
  expr%left%exp_real = real(a, real64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function sign_real32_var

module function sign_var_real32(a, b) result(expr)
  !! Build a deferred SIGN node with a right scalar.
  type(variable_type), target, intent(in) :: a
  !! Left variable, borrowed until evaluation.
  real(real32), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_SIGN
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_REAL32
  expr%right%exp_real = real(b, real64)
  call init_expr_workspace(expr)
end function sign_var_real32

module function sign_real32_expr(a, b) result(expr)
  !! Build a deferred SIGN node with a left scalar.
  real(real32), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression, copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_SIGN
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL32
  expr%left%exp_real = real(a, real64)
  expr%right = b
  call init_expr_workspace(expr)
end function sign_real32_expr

module function sign_expr_real32(a, b) result(expr)
  !! Build a deferred SIGN node with a right scalar.
  type(expression_type), intent(in) :: a
  !! Left expression, copied into the result.
  real(real32), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_SIGN
  allocate (expr%left, expr%right)
  expr%left = a
  expr%right%operation = OP_SCALAR_REAL32
  expr%right%exp_real = real(b, real64)
  call init_expr_workspace(expr)
end function sign_expr_real32

module function sign_real64_var(a, b) result(expr)
  !! Build a deferred SIGN node with a left scalar.
  real(real64), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable, borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_SIGN
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL64
  expr%left%exp_real = real(a, real64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function sign_real64_var

module function sign_var_real64(a, b) result(expr)
  !! Build a deferred SIGN node with a right scalar.
  type(variable_type), target, intent(in) :: a
  !! Left variable, borrowed until evaluation.
  real(real64), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_SIGN
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_REAL64
  expr%right%exp_real = real(b, real64)
  call init_expr_workspace(expr)
end function sign_var_real64

module function sign_real64_expr(a, b) result(expr)
  !! Build a deferred SIGN node with a left scalar.
  real(real64), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression, copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_SIGN
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL64
  expr%left%exp_real = real(a, real64)
  expr%right = b
  call init_expr_workspace(expr)
end function sign_real64_expr

module function sign_expr_real64(a, b) result(expr)
  !! Build a deferred SIGN node with a right scalar.
  type(expression_type), intent(in) :: a
  !! Left expression, copied into the result.
  real(real64), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_SIGN
  allocate (expr%left, expr%right)
  expr%left = a
  expr%right%operation = OP_SCALAR_REAL64
  expr%right%exp_real = real(b, real64)
  call init_expr_workspace(expr)
end function sign_expr_real64

module function mod_var_var(a, b) result(expr)
  !! Build a deferred MOD node from two operands.
  type(variable_type), target, intent(in) :: a
  !! Left variable, borrowed until evaluation.
  type(variable_type), target, intent(in) :: b
  !! Right variable, borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_MOD
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function mod_var_var

module function mod_var_expr(a, b) result(expr)
  !! Build a deferred MOD node from two operands.
  type(variable_type), target, intent(in) :: a
  !! Left variable, borrowed until evaluation.
  type(expression_type), intent(in) :: b
  !! Right expression, copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_MOD
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right = b
  call init_expr_workspace(expr)
end function mod_var_expr

module function mod_expr_var(a, b) result(expr)
  !! Build a deferred MOD node from two operands.
  type(expression_type), intent(in) :: a
  !! Left expression, copied into the result.
  type(variable_type), target, intent(in) :: b
  !! Right variable, borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_MOD
  allocate (expr%left, expr%right)
  expr%left = a
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function mod_expr_var

module function mod_expr_expr(a, b) result(expr)
  !! Build a deferred MOD node from two operands.
  type(expression_type), intent(in) :: a
  !! Left expression, copied into the result.
  type(expression_type), intent(in) :: b
  !! Right expression, copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_MOD
  allocate (expr%left, expr%right)
  expr%left = a
  expr%right = b
  call init_expr_workspace(expr)
end function mod_expr_expr

module function mod_int8_var(a, b) result(expr)
  !! Build a deferred MOD node with a left scalar.
  integer(int8), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable, borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_MOD
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT8
  expr%left%exp_int = int(a, int64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function mod_int8_var

module function mod_var_int8(a, b) result(expr)
  !! Build a deferred MOD node with a right scalar.
  type(variable_type), target, intent(in) :: a
  !! Left variable, borrowed until evaluation.
  integer(int8), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_MOD
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_INT8
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function mod_var_int8

module function mod_int8_expr(a, b) result(expr)
  !! Build a deferred MOD node with a left scalar.
  integer(int8), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression, copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_MOD
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT8
  expr%left%exp_int = int(a, int64)
  expr%right = b
  call init_expr_workspace(expr)
end function mod_int8_expr

module function mod_expr_int8(a, b) result(expr)
  !! Build a deferred MOD node with a right scalar.
  type(expression_type), intent(in) :: a
  !! Left expression, copied into the result.
  integer(int8), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_MOD
  allocate (expr%left, expr%right)
  expr%left = a
  expr%right%operation = OP_SCALAR_INT8
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function mod_expr_int8

module function mod_int16_var(a, b) result(expr)
  !! Build a deferred MOD node with a left scalar.
  integer(int16), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable, borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_MOD
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT16
  expr%left%exp_int = int(a, int64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function mod_int16_var

module function mod_var_int16(a, b) result(expr)
  !! Build a deferred MOD node with a right scalar.
  type(variable_type), target, intent(in) :: a
  !! Left variable, borrowed until evaluation.
  integer(int16), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_MOD
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_INT16
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function mod_var_int16

module function mod_int16_expr(a, b) result(expr)
  !! Build a deferred MOD node with a left scalar.
  integer(int16), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression, copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_MOD
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT16
  expr%left%exp_int = int(a, int64)
  expr%right = b
  call init_expr_workspace(expr)
end function mod_int16_expr

module function mod_expr_int16(a, b) result(expr)
  !! Build a deferred MOD node with a right scalar.
  type(expression_type), intent(in) :: a
  !! Left expression, copied into the result.
  integer(int16), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_MOD
  allocate (expr%left, expr%right)
  expr%left = a
  expr%right%operation = OP_SCALAR_INT16
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function mod_expr_int16

module function mod_int32_var(a, b) result(expr)
  !! Build a deferred MOD node with a left scalar.
  integer(int32), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable, borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_MOD
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT32
  expr%left%exp_int = int(a, int64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function mod_int32_var

module function mod_var_int32(a, b) result(expr)
  !! Build a deferred MOD node with a right scalar.
  type(variable_type), target, intent(in) :: a
  !! Left variable, borrowed until evaluation.
  integer(int32), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_MOD
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_INT32
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function mod_var_int32

module function mod_int32_expr(a, b) result(expr)
  !! Build a deferred MOD node with a left scalar.
  integer(int32), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression, copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_MOD
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT32
  expr%left%exp_int = int(a, int64)
  expr%right = b
  call init_expr_workspace(expr)
end function mod_int32_expr

module function mod_expr_int32(a, b) result(expr)
  !! Build a deferred MOD node with a right scalar.
  type(expression_type), intent(in) :: a
  !! Left expression, copied into the result.
  integer(int32), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_MOD
  allocate (expr%left, expr%right)
  expr%left = a
  expr%right%operation = OP_SCALAR_INT32
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function mod_expr_int32

module function mod_int64_var(a, b) result(expr)
  !! Build a deferred MOD node with a left scalar.
  integer(int64), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable, borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_MOD
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT64
  expr%left%exp_int = int(a, int64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function mod_int64_var

module function mod_var_int64(a, b) result(expr)
  !! Build a deferred MOD node with a right scalar.
  type(variable_type), target, intent(in) :: a
  !! Left variable, borrowed until evaluation.
  integer(int64), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_MOD
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_INT64
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function mod_var_int64

module function mod_int64_expr(a, b) result(expr)
  !! Build a deferred MOD node with a left scalar.
  integer(int64), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression, copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_MOD
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT64
  expr%left%exp_int = int(a, int64)
  expr%right = b
  call init_expr_workspace(expr)
end function mod_int64_expr

module function mod_expr_int64(a, b) result(expr)
  !! Build a deferred MOD node with a right scalar.
  type(expression_type), intent(in) :: a
  !! Left expression, copied into the result.
  integer(int64), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_MOD
  allocate (expr%left, expr%right)
  expr%left = a
  expr%right%operation = OP_SCALAR_INT64
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function mod_expr_int64

module function mod_real32_var(a, b) result(expr)
  !! Build a deferred MOD node with a left scalar.
  real(real32), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable, borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_MOD
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL32
  expr%left%exp_real = real(a, real64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function mod_real32_var

module function mod_var_real32(a, b) result(expr)
  !! Build a deferred MOD node with a right scalar.
  type(variable_type), target, intent(in) :: a
  !! Left variable, borrowed until evaluation.
  real(real32), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_MOD
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_REAL32
  expr%right%exp_real = real(b, real64)
  call init_expr_workspace(expr)
end function mod_var_real32

module function mod_real32_expr(a, b) result(expr)
  !! Build a deferred MOD node with a left scalar.
  real(real32), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression, copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_MOD
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL32
  expr%left%exp_real = real(a, real64)
  expr%right = b
  call init_expr_workspace(expr)
end function mod_real32_expr

module function mod_expr_real32(a, b) result(expr)
  !! Build a deferred MOD node with a right scalar.
  type(expression_type), intent(in) :: a
  !! Left expression, copied into the result.
  real(real32), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_MOD
  allocate (expr%left, expr%right)
  expr%left = a
  expr%right%operation = OP_SCALAR_REAL32
  expr%right%exp_real = real(b, real64)
  call init_expr_workspace(expr)
end function mod_expr_real32

module function mod_real64_var(a, b) result(expr)
  !! Build a deferred MOD node with a left scalar.
  real(real64), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable, borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_MOD
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL64
  expr%left%exp_real = real(a, real64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function mod_real64_var

module function mod_var_real64(a, b) result(expr)
  !! Build a deferred MOD node with a right scalar.
  type(variable_type), target, intent(in) :: a
  !! Left variable, borrowed until evaluation.
  real(real64), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_MOD
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_REAL64
  expr%right%exp_real = real(b, real64)
  call init_expr_workspace(expr)
end function mod_var_real64

module function mod_real64_expr(a, b) result(expr)
  !! Build a deferred MOD node with a left scalar.
  real(real64), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression, copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_MOD
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL64
  expr%left%exp_real = real(a, real64)
  expr%right = b
  call init_expr_workspace(expr)
end function mod_real64_expr

module function mod_expr_real64(a, b) result(expr)
  !! Build a deferred MOD node with a right scalar.
  type(expression_type), intent(in) :: a
  !! Left expression, copied into the result.
  real(real64), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_MOD
  allocate (expr%left, expr%right)
  expr%left = a
  expr%right%operation = OP_SCALAR_REAL64
  expr%right%exp_real = real(b, real64)
  call init_expr_workspace(expr)
end function mod_expr_real64

module function modulo_var_var(a, b) result(expr)
  !! Build a deferred MODULO node from two operands.
  type(variable_type), target, intent(in) :: a
  !! Left variable, borrowed until evaluation.
  type(variable_type), target, intent(in) :: b
  !! Right variable, borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_MODULO
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function modulo_var_var

module function modulo_var_expr(a, b) result(expr)
  !! Build a deferred MODULO node from two operands.
  type(variable_type), target, intent(in) :: a
  !! Left variable, borrowed until evaluation.
  type(expression_type), intent(in) :: b
  !! Right expression, copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_MODULO
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right = b
  call init_expr_workspace(expr)
end function modulo_var_expr

module function modulo_expr_var(a, b) result(expr)
  !! Build a deferred MODULO node from two operands.
  type(expression_type), intent(in) :: a
  !! Left expression, copied into the result.
  type(variable_type), target, intent(in) :: b
  !! Right variable, borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_MODULO
  allocate (expr%left, expr%right)
  expr%left = a
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function modulo_expr_var

module function modulo_expr_expr(a, b) result(expr)
  !! Build a deferred MODULO node from two operands.
  type(expression_type), intent(in) :: a
  !! Left expression, copied into the result.
  type(expression_type), intent(in) :: b
  !! Right expression, copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_MODULO
  allocate (expr%left, expr%right)
  expr%left = a
  expr%right = b
  call init_expr_workspace(expr)
end function modulo_expr_expr

module function modulo_int8_var(a, b) result(expr)
  !! Build a deferred MODULO node with a left scalar.
  integer(int8), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable, borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_MODULO
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT8
  expr%left%exp_int = int(a, int64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function modulo_int8_var

module function modulo_var_int8(a, b) result(expr)
  !! Build a deferred MODULO node with a right scalar.
  type(variable_type), target, intent(in) :: a
  !! Left variable, borrowed until evaluation.
  integer(int8), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_MODULO
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_INT8
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function modulo_var_int8

module function modulo_int8_expr(a, b) result(expr)
  !! Build a deferred MODULO node with a left scalar.
  integer(int8), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression, copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_MODULO
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT8
  expr%left%exp_int = int(a, int64)
  expr%right = b
  call init_expr_workspace(expr)
end function modulo_int8_expr

module function modulo_expr_int8(a, b) result(expr)
  !! Build a deferred MODULO node with a right scalar.
  type(expression_type), intent(in) :: a
  !! Left expression, copied into the result.
  integer(int8), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_MODULO
  allocate (expr%left, expr%right)
  expr%left = a
  expr%right%operation = OP_SCALAR_INT8
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function modulo_expr_int8

module function modulo_int16_var(a, b) result(expr)
  !! Build a deferred MODULO node with a left scalar.
  integer(int16), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable, borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_MODULO
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT16
  expr%left%exp_int = int(a, int64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function modulo_int16_var

module function modulo_var_int16(a, b) result(expr)
  !! Build a deferred MODULO node with a right scalar.
  type(variable_type), target, intent(in) :: a
  !! Left variable, borrowed until evaluation.
  integer(int16), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_MODULO
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_INT16
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function modulo_var_int16

module function modulo_int16_expr(a, b) result(expr)
  !! Build a deferred MODULO node with a left scalar.
  integer(int16), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression, copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_MODULO
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT16
  expr%left%exp_int = int(a, int64)
  expr%right = b
  call init_expr_workspace(expr)
end function modulo_int16_expr

module function modulo_expr_int16(a, b) result(expr)
  !! Build a deferred MODULO node with a right scalar.
  type(expression_type), intent(in) :: a
  !! Left expression, copied into the result.
  integer(int16), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_MODULO
  allocate (expr%left, expr%right)
  expr%left = a
  expr%right%operation = OP_SCALAR_INT16
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function modulo_expr_int16

module function modulo_int32_var(a, b) result(expr)
  !! Build a deferred MODULO node with a left scalar.
  integer(int32), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable, borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_MODULO
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT32
  expr%left%exp_int = int(a, int64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function modulo_int32_var

module function modulo_var_int32(a, b) result(expr)
  !! Build a deferred MODULO node with a right scalar.
  type(variable_type), target, intent(in) :: a
  !! Left variable, borrowed until evaluation.
  integer(int32), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_MODULO
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_INT32
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function modulo_var_int32

module function modulo_int32_expr(a, b) result(expr)
  !! Build a deferred MODULO node with a left scalar.
  integer(int32), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression, copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_MODULO
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT32
  expr%left%exp_int = int(a, int64)
  expr%right = b
  call init_expr_workspace(expr)
end function modulo_int32_expr

module function modulo_expr_int32(a, b) result(expr)
  !! Build a deferred MODULO node with a right scalar.
  type(expression_type), intent(in) :: a
  !! Left expression, copied into the result.
  integer(int32), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_MODULO
  allocate (expr%left, expr%right)
  expr%left = a
  expr%right%operation = OP_SCALAR_INT32
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function modulo_expr_int32

module function modulo_int64_var(a, b) result(expr)
  !! Build a deferred MODULO node with a left scalar.
  integer(int64), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable, borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_MODULO
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT64
  expr%left%exp_int = int(a, int64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function modulo_int64_var

module function modulo_var_int64(a, b) result(expr)
  !! Build a deferred MODULO node with a right scalar.
  type(variable_type), target, intent(in) :: a
  !! Left variable, borrowed until evaluation.
  integer(int64), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_MODULO
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_INT64
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function modulo_var_int64

module function modulo_int64_expr(a, b) result(expr)
  !! Build a deferred MODULO node with a left scalar.
  integer(int64), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression, copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_MODULO
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT64
  expr%left%exp_int = int(a, int64)
  expr%right = b
  call init_expr_workspace(expr)
end function modulo_int64_expr

module function modulo_expr_int64(a, b) result(expr)
  !! Build a deferred MODULO node with a right scalar.
  type(expression_type), intent(in) :: a
  !! Left expression, copied into the result.
  integer(int64), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_MODULO
  allocate (expr%left, expr%right)
  expr%left = a
  expr%right%operation = OP_SCALAR_INT64
  expr%right%exp_int = int(b, int64)
  call init_expr_workspace(expr)
end function modulo_expr_int64

module function modulo_real32_var(a, b) result(expr)
  !! Build a deferred MODULO node with a left scalar.
  real(real32), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable, borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_MODULO
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL32
  expr%left%exp_real = real(a, real64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function modulo_real32_var

module function modulo_var_real32(a, b) result(expr)
  !! Build a deferred MODULO node with a right scalar.
  type(variable_type), target, intent(in) :: a
  !! Left variable, borrowed until evaluation.
  real(real32), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_MODULO
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_REAL32
  expr%right%exp_real = real(b, real64)
  call init_expr_workspace(expr)
end function modulo_var_real32

module function modulo_real32_expr(a, b) result(expr)
  !! Build a deferred MODULO node with a left scalar.
  real(real32), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression, copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_MODULO
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL32
  expr%left%exp_real = real(a, real64)
  expr%right = b
  call init_expr_workspace(expr)
end function modulo_real32_expr

module function modulo_expr_real32(a, b) result(expr)
  !! Build a deferred MODULO node with a right scalar.
  type(expression_type), intent(in) :: a
  !! Left expression, copied into the result.
  real(real32), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_MODULO
  allocate (expr%left, expr%right)
  expr%left = a
  expr%right%operation = OP_SCALAR_REAL32
  expr%right%exp_real = real(b, real64)
  call init_expr_workspace(expr)
end function modulo_expr_real32

module function modulo_real64_var(a, b) result(expr)
  !! Build a deferred MODULO node with a left scalar.
  real(real64), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable, borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_MODULO
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL64
  expr%left%exp_real = real(a, real64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function modulo_real64_var

module function modulo_var_real64(a, b) result(expr)
  !! Build a deferred MODULO node with a right scalar.
  type(variable_type), target, intent(in) :: a
  !! Left variable, borrowed until evaluation.
  real(real64), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_MODULO
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_REAL64
  expr%right%exp_real = real(b, real64)
  call init_expr_workspace(expr)
end function modulo_var_real64

module function modulo_real64_expr(a, b) result(expr)
  !! Build a deferred MODULO node with a left scalar.
  real(real64), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression, copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_MODULO
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL64
  expr%left%exp_real = real(a, real64)
  expr%right = b
  call init_expr_workspace(expr)
end function modulo_real64_expr

module function modulo_expr_real64(a, b) result(expr)
  !! Build a deferred MODULO node with a right scalar.
  type(expression_type), intent(in) :: a
  !! Left expression, copied into the result.
  real(real64), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_MODULO
  allocate (expr%left, expr%right)
  expr%left = a
  expr%right%operation = OP_SCALAR_REAL64
  expr%right%exp_real = real(b, real64)
  call init_expr_workspace(expr)
end function modulo_expr_real64

module function atan2_var_var(a, b) result(expr)
  !! Build a deferred ATAN2 node from two operands.
  type(variable_type), target, intent(in) :: a
  !! Left variable, borrowed until evaluation.
  type(variable_type), target, intent(in) :: b
  !! Right variable, borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_ATAN2
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function atan2_var_var

module function atan2_var_expr(a, b) result(expr)
  !! Build a deferred ATAN2 node from two operands.
  type(variable_type), target, intent(in) :: a
  !! Left variable, borrowed until evaluation.
  type(expression_type), intent(in) :: b
  !! Right expression, copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_ATAN2
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right = b
  call init_expr_workspace(expr)
end function atan2_var_expr

module function atan2_expr_var(a, b) result(expr)
  !! Build a deferred ATAN2 node from two operands.
  type(expression_type), intent(in) :: a
  !! Left expression, copied into the result.
  type(variable_type), target, intent(in) :: b
  !! Right variable, borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_ATAN2
  allocate (expr%left, expr%right)
  expr%left = a
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function atan2_expr_var

module function atan2_expr_expr(a, b) result(expr)
  !! Build a deferred ATAN2 node from two operands.
  type(expression_type), intent(in) :: a
  !! Left expression, copied into the result.
  type(expression_type), intent(in) :: b
  !! Right expression, copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_ATAN2
  allocate (expr%left, expr%right)
  expr%left = a
  expr%right = b
  call init_expr_workspace(expr)
end function atan2_expr_expr

module function atan2_real32_var(a, b) result(expr)
  !! Build a deferred ATAN2 node with a left scalar.
  real(real32), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable, borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_ATAN2
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL32
  expr%left%exp_real = real(a, real64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function atan2_real32_var

module function atan2_var_real32(a, b) result(expr)
  !! Build a deferred ATAN2 node with a right scalar.
  type(variable_type), target, intent(in) :: a
  !! Left variable, borrowed until evaluation.
  real(real32), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_ATAN2
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_REAL32
  expr%right%exp_real = real(b, real64)
  call init_expr_workspace(expr)
end function atan2_var_real32

module function atan2_real32_expr(a, b) result(expr)
  !! Build a deferred ATAN2 node with a left scalar.
  real(real32), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression, copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_ATAN2
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL32
  expr%left%exp_real = real(a, real64)
  expr%right = b
  call init_expr_workspace(expr)
end function atan2_real32_expr

module function atan2_expr_real32(a, b) result(expr)
  !! Build a deferred ATAN2 node with a right scalar.
  type(expression_type), intent(in) :: a
  !! Left expression, copied into the result.
  real(real32), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_ATAN2
  allocate (expr%left, expr%right)
  expr%left = a
  expr%right%operation = OP_SCALAR_REAL32
  expr%right%exp_real = real(b, real64)
  call init_expr_workspace(expr)
end function atan2_expr_real32

module function atan2_real64_var(a, b) result(expr)
  !! Build a deferred ATAN2 node with a left scalar.
  real(real64), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable, borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_ATAN2
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL64
  expr%left%exp_real = real(a, real64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function atan2_real64_var

module function atan2_var_real64(a, b) result(expr)
  !! Build a deferred ATAN2 node with a right scalar.
  type(variable_type), target, intent(in) :: a
  !! Left variable, borrowed until evaluation.
  real(real64), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_ATAN2
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_REAL64
  expr%right%exp_real = real(b, real64)
  call init_expr_workspace(expr)
end function atan2_var_real64

module function atan2_real64_expr(a, b) result(expr)
  !! Build a deferred ATAN2 node with a left scalar.
  real(real64), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression, copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_ATAN2
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL64
  expr%left%exp_real = real(a, real64)
  expr%right = b
  call init_expr_workspace(expr)
end function atan2_real64_expr

module function atan2_expr_real64(a, b) result(expr)
  !! Build a deferred ATAN2 node with a right scalar.
  type(expression_type), intent(in) :: a
  !! Left expression, copied into the result.
  real(real64), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_ATAN2
  allocate (expr%left, expr%right)
  expr%left = a
  expr%right%operation = OP_SCALAR_REAL64
  expr%right%exp_real = real(b, real64)
  call init_expr_workspace(expr)
end function atan2_expr_real64

module function atan_var_var(a, b) result(expr)
  !! Build a deferred ATAN node from two operands.
  type(variable_type), target, intent(in) :: a
  !! Left variable, borrowed until evaluation.
  type(variable_type), target, intent(in) :: b
  !! Right variable, borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_ATAN2
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function atan_var_var

module function atan_var_expr(a, b) result(expr)
  !! Build a deferred ATAN node from two operands.
  type(variable_type), target, intent(in) :: a
  !! Left variable, borrowed until evaluation.
  type(expression_type), intent(in) :: b
  !! Right expression, copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_ATAN2
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right = b
  call init_expr_workspace(expr)
end function atan_var_expr

module function atan_expr_var(a, b) result(expr)
  !! Build a deferred ATAN node from two operands.
  type(expression_type), intent(in) :: a
  !! Left expression, copied into the result.
  type(variable_type), target, intent(in) :: b
  !! Right variable, borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_ATAN2
  allocate (expr%left, expr%right)
  expr%left = a
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function atan_expr_var

module function atan_expr_expr(a, b) result(expr)
  !! Build a deferred ATAN node from two operands.
  type(expression_type), intent(in) :: a
  !! Left expression, copied into the result.
  type(expression_type), intent(in) :: b
  !! Right expression, copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_ATAN2
  allocate (expr%left, expr%right)
  expr%left = a
  expr%right = b
  call init_expr_workspace(expr)
end function atan_expr_expr

module function atan_real32_var(a, b) result(expr)
  !! Build a deferred ATAN node with a left scalar.
  real(real32), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable, borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_ATAN2
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL32
  expr%left%exp_real = real(a, real64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function atan_real32_var

module function atan_var_real32(a, b) result(expr)
  !! Build a deferred ATAN node with a right scalar.
  type(variable_type), target, intent(in) :: a
  !! Left variable, borrowed until evaluation.
  real(real32), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_ATAN2
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_REAL32
  expr%right%exp_real = real(b, real64)
  call init_expr_workspace(expr)
end function atan_var_real32

module function atan_real32_expr(a, b) result(expr)
  !! Build a deferred ATAN node with a left scalar.
  real(real32), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression, copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_ATAN2
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL32
  expr%left%exp_real = real(a, real64)
  expr%right = b
  call init_expr_workspace(expr)
end function atan_real32_expr

module function atan_expr_real32(a, b) result(expr)
  !! Build a deferred ATAN node with a right scalar.
  type(expression_type), intent(in) :: a
  !! Left expression, copied into the result.
  real(real32), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_ATAN2
  allocate (expr%left, expr%right)
  expr%left = a
  expr%right%operation = OP_SCALAR_REAL32
  expr%right%exp_real = real(b, real64)
  call init_expr_workspace(expr)
end function atan_expr_real32

module function atan_real64_var(a, b) result(expr)
  !! Build a deferred ATAN node with a left scalar.
  real(real64), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable, borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_ATAN2
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL64
  expr%left%exp_real = real(a, real64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function atan_real64_var

module function atan_var_real64(a, b) result(expr)
  !! Build a deferred ATAN node with a right scalar.
  type(variable_type), target, intent(in) :: a
  !! Left variable, borrowed until evaluation.
  real(real64), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_ATAN2
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_REAL64
  expr%right%exp_real = real(b, real64)
  call init_expr_workspace(expr)
end function atan_var_real64

module function atan_real64_expr(a, b) result(expr)
  !! Build a deferred ATAN node with a left scalar.
  real(real64), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression, copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_ATAN2
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL64
  expr%left%exp_real = real(a, real64)
  expr%right = b
  call init_expr_workspace(expr)
end function atan_real64_expr

module function atan_expr_real64(a, b) result(expr)
  !! Build a deferred ATAN node with a right scalar.
  type(expression_type), intent(in) :: a
  !! Left expression, copied into the result.
  real(real64), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_ATAN2
  allocate (expr%left, expr%right)
  expr%left = a
  expr%right%operation = OP_SCALAR_REAL64
  expr%right%exp_real = real(b, real64)
  call init_expr_workspace(expr)
end function atan_expr_real64

module function hypot_var_var(a, b) result(expr)
  !! Build a deferred HYPOT node from two operands.
  type(variable_type), target, intent(in) :: a
  !! Left variable, borrowed until evaluation.
  type(variable_type), target, intent(in) :: b
  !! Right variable, borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_HYPOT
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function hypot_var_var

module function hypot_var_expr(a, b) result(expr)
  !! Build a deferred HYPOT node from two operands.
  type(variable_type), target, intent(in) :: a
  !! Left variable, borrowed until evaluation.
  type(expression_type), intent(in) :: b
  !! Right expression, copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_HYPOT
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right = b
  call init_expr_workspace(expr)
end function hypot_var_expr

module function hypot_expr_var(a, b) result(expr)
  !! Build a deferred HYPOT node from two operands.
  type(expression_type), intent(in) :: a
  !! Left expression, copied into the result.
  type(variable_type), target, intent(in) :: b
  !! Right variable, borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_HYPOT
  allocate (expr%left, expr%right)
  expr%left = a
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function hypot_expr_var

module function hypot_expr_expr(a, b) result(expr)
  !! Build a deferred HYPOT node from two operands.
  type(expression_type), intent(in) :: a
  !! Left expression, copied into the result.
  type(expression_type), intent(in) :: b
  !! Right expression, copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_HYPOT
  allocate (expr%left, expr%right)
  expr%left = a
  expr%right = b
  call init_expr_workspace(expr)
end function hypot_expr_expr

module function hypot_real32_var(a, b) result(expr)
  !! Build a deferred HYPOT node with a left scalar.
  real(real32), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable, borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_HYPOT
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL32
  expr%left%exp_real = real(a, real64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function hypot_real32_var

module function hypot_var_real32(a, b) result(expr)
  !! Build a deferred HYPOT node with a right scalar.
  type(variable_type), target, intent(in) :: a
  !! Left variable, borrowed until evaluation.
  real(real32), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_HYPOT
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_REAL32
  expr%right%exp_real = real(b, real64)
  call init_expr_workspace(expr)
end function hypot_var_real32

module function hypot_real32_expr(a, b) result(expr)
  !! Build a deferred HYPOT node with a left scalar.
  real(real32), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression, copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_HYPOT
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL32
  expr%left%exp_real = real(a, real64)
  expr%right = b
  call init_expr_workspace(expr)
end function hypot_real32_expr

module function hypot_expr_real32(a, b) result(expr)
  !! Build a deferred HYPOT node with a right scalar.
  type(expression_type), intent(in) :: a
  !! Left expression, copied into the result.
  real(real32), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_HYPOT
  allocate (expr%left, expr%right)
  expr%left = a
  expr%right%operation = OP_SCALAR_REAL32
  expr%right%exp_real = real(b, real64)
  call init_expr_workspace(expr)
end function hypot_expr_real32

module function hypot_real64_var(a, b) result(expr)
  !! Build a deferred HYPOT node with a left scalar.
  real(real64), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(variable_type), target, intent(in) :: b
  !! Right variable, borrowed until evaluation.
  type(expression_type) :: expr

  expr%operation = OP_HYPOT
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL64
  expr%left%exp_real = real(a, real64)
  call init_expr_leaf(b, expr%right)
  call init_expr_workspace(expr)
end function hypot_real64_var

module function hypot_var_real64(a, b) result(expr)
  !! Build a deferred HYPOT node with a right scalar.
  type(variable_type), target, intent(in) :: a
  !! Left variable, borrowed until evaluation.
  real(real64), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_HYPOT
  allocate (expr%left, expr%right)
  call init_expr_leaf(a, expr%left)
  expr%right%operation = OP_SCALAR_REAL64
  expr%right%exp_real = real(b, real64)
  call init_expr_workspace(expr)
end function hypot_var_real64

module function hypot_real64_expr(a, b) result(expr)
  !! Build a deferred HYPOT node with a left scalar.
  real(real64), intent(in) :: a
  !! Left scalar, stored by value in the expression.
  type(expression_type), intent(in) :: b
  !! Right expression, copied into the result.
  type(expression_type) :: expr

  expr%operation = OP_HYPOT
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL64
  expr%left%exp_real = real(a, real64)
  expr%right = b
  call init_expr_workspace(expr)
end function hypot_real64_expr

module function hypot_expr_real64(a, b) result(expr)
  !! Build a deferred HYPOT node with a right scalar.
  type(expression_type), intent(in) :: a
  !! Left expression, copied into the result.
  real(real64), intent(in) :: b
  !! Right scalar, stored by value in the expression.
  type(expression_type) :: expr

  expr%operation = OP_HYPOT
  allocate (expr%left, expr%right)
  expr%left = a
  expr%right%operation = OP_SCALAR_REAL64
  expr%right%exp_real = real(b, real64)
  call init_expr_workspace(expr)
end function hypot_expr_real64

end submodule nc4f_data_intrinsic
