submodule(nc4f_data) nc4f_data_arithmetic
!! Build deferred arithmetic expressions from variables and expressions.
implicit none (type, external)
contains

module function add_var_var(a, b) result(expr)
  type(variable_type), target, intent(in) :: a
  type(variable_type), target, intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
  expr%right%operation = OP_LEAF
  expr%right%leaf => b
end function add_var_var

module function add_var_expr(a, b) result(expr)
  type(variable_type), target, intent(in) :: a
  type(expression_type), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
  call copy_expr(b, expr%right)
end function add_var_expr

module function add_expr_var(a, b) result(expr)
  type(expression_type), intent(in) :: a
  type(variable_type), target, intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_LEAF
  expr%right%leaf => b
end function add_expr_var

module function add_expr_expr(a, b) result(expr)
  type(expression_type), intent(in) :: a
  type(expression_type), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  call copy_expr(b, expr%right)
end function add_expr_expr

module function sub_var_var(a, b) result(expr)
  type(variable_type), target, intent(in) :: a
  type(variable_type), target, intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
  expr%right%operation = OP_LEAF
  expr%right%leaf => b
end function sub_var_var

module function sub_var_expr(a, b) result(expr)
  type(variable_type), target, intent(in) :: a
  type(expression_type), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
  call copy_expr(b, expr%right)
end function sub_var_expr

module function sub_expr_var(a, b) result(expr)
  type(expression_type), intent(in) :: a
  type(variable_type), target, intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_LEAF
  expr%right%leaf => b
end function sub_expr_var

module function sub_expr_expr(a, b) result(expr)
  type(expression_type), intent(in) :: a
  type(expression_type), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  call copy_expr(b, expr%right)
end function sub_expr_expr

module function mul_var_var(a, b) result(expr)
  type(variable_type), target, intent(in) :: a
  type(variable_type), target, intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
  expr%right%operation = OP_LEAF
  expr%right%leaf => b
end function mul_var_var

module function mul_var_expr(a, b) result(expr)
  type(variable_type), target, intent(in) :: a
  type(expression_type), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
  call copy_expr(b, expr%right)
end function mul_var_expr

module function mul_expr_var(a, b) result(expr)
  type(expression_type), intent(in) :: a
  type(variable_type), target, intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_LEAF
  expr%right%leaf => b
end function mul_expr_var

module function mul_expr_expr(a, b) result(expr)
  type(expression_type), intent(in) :: a
  type(expression_type), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  call copy_expr(b, expr%right)
end function mul_expr_expr

module function div_var_var(a, b) result(expr)
  type(variable_type), target, intent(in) :: a
  type(variable_type), target, intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
  expr%right%operation = OP_LEAF
  expr%right%leaf => b
end function div_var_var

module function div_var_expr(a, b) result(expr)
  type(variable_type), target, intent(in) :: a
  type(expression_type), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
  call copy_expr(b, expr%right)
end function div_var_expr

module function div_expr_var(a, b) result(expr)
  type(expression_type), intent(in) :: a
  type(variable_type), target, intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_LEAF
  expr%right%leaf => b
end function div_expr_var

module function div_expr_expr(a, b) result(expr)
  type(expression_type), intent(in) :: a
  type(expression_type), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  call copy_expr(b, expr%right)
end function div_expr_expr

module function pow_var_var(a, b) result(expr)
  type(variable_type), target, intent(in) :: a
  type(variable_type), target, intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_POW
  allocate (expr%left, expr%right)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
  expr%right%operation = OP_LEAF
  expr%right%leaf => b
end function pow_var_var

module function pow_var_expr(a, b) result(expr)
  type(variable_type), target, intent(in) :: a
  type(expression_type), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_POW
  allocate (expr%left, expr%right)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
  call copy_expr(b, expr%right)
end function pow_var_expr

module function pow_expr_var(a, b) result(expr)
  type(expression_type), intent(in) :: a
  type(variable_type), target, intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_POW
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_LEAF
  expr%right%leaf => b
end function pow_expr_var

module function pow_expr_expr(a, b) result(expr)
  type(expression_type), intent(in) :: a
  type(expression_type), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_POW
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  call copy_expr(b, expr%right)
end function pow_expr_expr

module function pow_var_int8(a, exponent) result(expr)
  type(variable_type), target, intent(in) :: a
  integer(int8), intent(in) :: exponent
  type(expression_type) :: expr

  expr%operation = OP_INT8_POW
  expr%exp_int = int(exponent, int64)
  allocate (expr%left)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
end function pow_var_int8

module function pow_expr_int8(a, exponent) result(expr)
  type(expression_type), intent(in) :: a
  integer(int8), intent(in) :: exponent
  type(expression_type) :: expr

  expr%operation = OP_INT8_POW
  expr%exp_int = int(exponent, int64)
  allocate (expr%left)
  call copy_expr(a, expr%left)
end function pow_expr_int8

module function pow_var_int16(a, exponent) result(expr)
  type(variable_type), target, intent(in) :: a
  integer(int16), intent(in) :: exponent
  type(expression_type) :: expr

  expr%operation = OP_INT16_POW
  expr%exp_int = int(exponent, int64)
  allocate (expr%left)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
end function pow_var_int16

module function pow_expr_int16(a, exponent) result(expr)
  type(expression_type), intent(in) :: a
  integer(int16), intent(in) :: exponent
  type(expression_type) :: expr

  expr%operation = OP_INT16_POW
  expr%exp_int = int(exponent, int64)
  allocate (expr%left)
  call copy_expr(a, expr%left)
end function pow_expr_int16

module function pow_var_int32(a, exponent) result(expr)
  type(variable_type), target, intent(in) :: a
  integer(int32), intent(in) :: exponent
  type(expression_type) :: expr

  expr%operation = OP_INT32_POW
  expr%exp_int = int(exponent, int64)
  allocate (expr%left)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
end function pow_var_int32

module function pow_expr_int32(a, exponent) result(expr)
  type(expression_type), intent(in) :: a
  integer(int32), intent(in) :: exponent
  type(expression_type) :: expr

  expr%operation = OP_INT32_POW
  expr%exp_int = int(exponent, int64)
  allocate (expr%left)
  call copy_expr(a, expr%left)
end function pow_expr_int32

module function pow_var_int64(a, exponent) result(expr)
  type(variable_type), target, intent(in) :: a
  integer(int64), intent(in) :: exponent
  type(expression_type) :: expr

  expr%operation = OP_INT64_POW
  expr%exp_int = int(exponent, int64)
  allocate (expr%left)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
end function pow_var_int64

module function pow_expr_int64(a, exponent) result(expr)
  type(expression_type), intent(in) :: a
  integer(int64), intent(in) :: exponent
  type(expression_type) :: expr

  expr%operation = OP_INT64_POW
  expr%exp_int = int(exponent, int64)
  allocate (expr%left)
  call copy_expr(a, expr%left)
end function pow_expr_int64

module function pow_var_real32(a, exponent) result(expr)
  type(variable_type), target, intent(in) :: a
  real(real32), intent(in) :: exponent
  type(expression_type) :: expr

  expr%operation = OP_REAL32_POW
  expr%exp_real = real(exponent, real64)
  allocate (expr%left)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
end function pow_var_real32

module function pow_expr_real32(a, exponent) result(expr)
  type(expression_type), intent(in) :: a
  real(real32), intent(in) :: exponent
  type(expression_type) :: expr

  expr%operation = OP_REAL32_POW
  expr%exp_real = real(exponent, real64)
  allocate (expr%left)
  call copy_expr(a, expr%left)
end function pow_expr_real32

module function pow_var_real64(a, exponent) result(expr)
  type(variable_type), target, intent(in) :: a
  real(real64), intent(in) :: exponent
  type(expression_type) :: expr

  expr%operation = OP_REAL64_POW
  expr%exp_real = real(exponent, real64)
  allocate (expr%left)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
end function pow_var_real64

module function pow_expr_real64(a, exponent) result(expr)
  type(expression_type), intent(in) :: a
  real(real64), intent(in) :: exponent
  type(expression_type) :: expr

  expr%operation = OP_REAL64_POW
  expr%exp_real = real(exponent, real64)
  allocate (expr%left)
  call copy_expr(a, expr%left)
end function pow_expr_real64

module function add_int8_var(a, b) result(expr)
  integer(int8), intent(in) :: a
  type(variable_type), target, intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT8
  expr%left%exp_int = int(a, int64)
  expr%right%operation = OP_LEAF
  expr%right%leaf => b
end function add_int8_var

module function add_int8_expr(a, b) result(expr)
  integer(int8), intent(in) :: a
  type(expression_type), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT8
  expr%left%exp_int = int(a, int64)
  call copy_expr(b, expr%right)
end function add_int8_expr

module function add_int16_var(a, b) result(expr)
  integer(int16), intent(in) :: a
  type(variable_type), target, intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT16
  expr%left%exp_int = int(a, int64)
  expr%right%operation = OP_LEAF
  expr%right%leaf => b
end function add_int16_var

module function add_int16_expr(a, b) result(expr)
  integer(int16), intent(in) :: a
  type(expression_type), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT16
  expr%left%exp_int = int(a, int64)
  call copy_expr(b, expr%right)
end function add_int16_expr

module function add_int32_var(a, b) result(expr)
  integer(int32), intent(in) :: a
  type(variable_type), target, intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT32
  expr%left%exp_int = int(a, int64)
  expr%right%operation = OP_LEAF
  expr%right%leaf => b
end function add_int32_var

module function add_int32_expr(a, b) result(expr)
  integer(int32), intent(in) :: a
  type(expression_type), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT32
  expr%left%exp_int = int(a, int64)
  call copy_expr(b, expr%right)
end function add_int32_expr

module function add_int64_var(a, b) result(expr)
  integer(int64), intent(in) :: a
  type(variable_type), target, intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT64
  expr%left%exp_int = int(a, int64)
  expr%right%operation = OP_LEAF
  expr%right%leaf => b
end function add_int64_var

module function add_int64_expr(a, b) result(expr)
  integer(int64), intent(in) :: a
  type(expression_type), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT64
  expr%left%exp_int = int(a, int64)
  call copy_expr(b, expr%right)
end function add_int64_expr

module function add_real32_var(a, b) result(expr)
  real(real32), intent(in) :: a
  type(variable_type), target, intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL32
  expr%left%exp_real = real(a, real64)
  expr%right%operation = OP_LEAF
  expr%right%leaf => b
end function add_real32_var

module function add_real32_expr(a, b) result(expr)
  real(real32), intent(in) :: a
  type(expression_type), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL32
  expr%left%exp_real = real(a, real64)
  call copy_expr(b, expr%right)
end function add_real32_expr

module function add_real64_var(a, b) result(expr)
  real(real64), intent(in) :: a
  type(variable_type), target, intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL64
  expr%left%exp_real = real(a, real64)
  expr%right%operation = OP_LEAF
  expr%right%leaf => b
end function add_real64_var

module function add_real64_expr(a, b) result(expr)
  real(real64), intent(in) :: a
  type(expression_type), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL64
  expr%left%exp_real = real(a, real64)
  call copy_expr(b, expr%right)
end function add_real64_expr

module function sub_int8_var(a, b) result(expr)
  integer(int8), intent(in) :: a
  type(variable_type), target, intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT8
  expr%left%exp_int = int(a, int64)
  expr%right%operation = OP_LEAF
  expr%right%leaf => b
end function sub_int8_var

module function sub_int8_expr(a, b) result(expr)
  integer(int8), intent(in) :: a
  type(expression_type), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT8
  expr%left%exp_int = int(a, int64)
  call copy_expr(b, expr%right)
end function sub_int8_expr

module function sub_int16_var(a, b) result(expr)
  integer(int16), intent(in) :: a
  type(variable_type), target, intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT16
  expr%left%exp_int = int(a, int64)
  expr%right%operation = OP_LEAF
  expr%right%leaf => b
end function sub_int16_var

module function sub_int16_expr(a, b) result(expr)
  integer(int16), intent(in) :: a
  type(expression_type), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT16
  expr%left%exp_int = int(a, int64)
  call copy_expr(b, expr%right)
end function sub_int16_expr

module function sub_int32_var(a, b) result(expr)
  integer(int32), intent(in) :: a
  type(variable_type), target, intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT32
  expr%left%exp_int = int(a, int64)
  expr%right%operation = OP_LEAF
  expr%right%leaf => b
end function sub_int32_var

module function sub_int32_expr(a, b) result(expr)
  integer(int32), intent(in) :: a
  type(expression_type), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT32
  expr%left%exp_int = int(a, int64)
  call copy_expr(b, expr%right)
end function sub_int32_expr

module function sub_int64_var(a, b) result(expr)
  integer(int64), intent(in) :: a
  type(variable_type), target, intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT64
  expr%left%exp_int = int(a, int64)
  expr%right%operation = OP_LEAF
  expr%right%leaf => b
end function sub_int64_var

module function sub_int64_expr(a, b) result(expr)
  integer(int64), intent(in) :: a
  type(expression_type), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT64
  expr%left%exp_int = int(a, int64)
  call copy_expr(b, expr%right)
end function sub_int64_expr

module function sub_real32_var(a, b) result(expr)
  real(real32), intent(in) :: a
  type(variable_type), target, intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL32
  expr%left%exp_real = real(a, real64)
  expr%right%operation = OP_LEAF
  expr%right%leaf => b
end function sub_real32_var

module function sub_real32_expr(a, b) result(expr)
  real(real32), intent(in) :: a
  type(expression_type), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL32
  expr%left%exp_real = real(a, real64)
  call copy_expr(b, expr%right)
end function sub_real32_expr

module function sub_real64_var(a, b) result(expr)
  real(real64), intent(in) :: a
  type(variable_type), target, intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL64
  expr%left%exp_real = real(a, real64)
  expr%right%operation = OP_LEAF
  expr%right%leaf => b
end function sub_real64_var

module function sub_real64_expr(a, b) result(expr)
  real(real64), intent(in) :: a
  type(expression_type), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL64
  expr%left%exp_real = real(a, real64)
  call copy_expr(b, expr%right)
end function sub_real64_expr

module function mul_int8_var(a, b) result(expr)
  integer(int8), intent(in) :: a
  type(variable_type), target, intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT8
  expr%left%exp_int = int(a, int64)
  expr%right%operation = OP_LEAF
  expr%right%leaf => b
end function mul_int8_var

module function mul_int8_expr(a, b) result(expr)
  integer(int8), intent(in) :: a
  type(expression_type), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT8
  expr%left%exp_int = int(a, int64)
  call copy_expr(b, expr%right)
end function mul_int8_expr

module function mul_int16_var(a, b) result(expr)
  integer(int16), intent(in) :: a
  type(variable_type), target, intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT16
  expr%left%exp_int = int(a, int64)
  expr%right%operation = OP_LEAF
  expr%right%leaf => b
end function mul_int16_var

module function mul_int16_expr(a, b) result(expr)
  integer(int16), intent(in) :: a
  type(expression_type), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT16
  expr%left%exp_int = int(a, int64)
  call copy_expr(b, expr%right)
end function mul_int16_expr

module function mul_int32_var(a, b) result(expr)
  integer(int32), intent(in) :: a
  type(variable_type), target, intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT32
  expr%left%exp_int = int(a, int64)
  expr%right%operation = OP_LEAF
  expr%right%leaf => b
end function mul_int32_var

module function mul_int32_expr(a, b) result(expr)
  integer(int32), intent(in) :: a
  type(expression_type), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT32
  expr%left%exp_int = int(a, int64)
  call copy_expr(b, expr%right)
end function mul_int32_expr

module function mul_int64_var(a, b) result(expr)
  integer(int64), intent(in) :: a
  type(variable_type), target, intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT64
  expr%left%exp_int = int(a, int64)
  expr%right%operation = OP_LEAF
  expr%right%leaf => b
end function mul_int64_var

module function mul_int64_expr(a, b) result(expr)
  integer(int64), intent(in) :: a
  type(expression_type), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT64
  expr%left%exp_int = int(a, int64)
  call copy_expr(b, expr%right)
end function mul_int64_expr

module function mul_real32_var(a, b) result(expr)
  real(real32), intent(in) :: a
  type(variable_type), target, intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL32
  expr%left%exp_real = real(a, real64)
  expr%right%operation = OP_LEAF
  expr%right%leaf => b
end function mul_real32_var

module function mul_real32_expr(a, b) result(expr)
  real(real32), intent(in) :: a
  type(expression_type), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL32
  expr%left%exp_real = real(a, real64)
  call copy_expr(b, expr%right)
end function mul_real32_expr

module function mul_real64_var(a, b) result(expr)
  real(real64), intent(in) :: a
  type(variable_type), target, intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL64
  expr%left%exp_real = real(a, real64)
  expr%right%operation = OP_LEAF
  expr%right%leaf => b
end function mul_real64_var

module function mul_real64_expr(a, b) result(expr)
  real(real64), intent(in) :: a
  type(expression_type), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL64
  expr%left%exp_real = real(a, real64)
  call copy_expr(b, expr%right)
end function mul_real64_expr

module function div_int8_var(a, b) result(expr)
  integer(int8), intent(in) :: a
  type(variable_type), target, intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT8
  expr%left%exp_int = int(a, int64)
  expr%right%operation = OP_LEAF
  expr%right%leaf => b
end function div_int8_var

module function div_int8_expr(a, b) result(expr)
  integer(int8), intent(in) :: a
  type(expression_type), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT8
  expr%left%exp_int = int(a, int64)
  call copy_expr(b, expr%right)
end function div_int8_expr

module function div_int16_var(a, b) result(expr)
  integer(int16), intent(in) :: a
  type(variable_type), target, intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT16
  expr%left%exp_int = int(a, int64)
  expr%right%operation = OP_LEAF
  expr%right%leaf => b
end function div_int16_var

module function div_int16_expr(a, b) result(expr)
  integer(int16), intent(in) :: a
  type(expression_type), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT16
  expr%left%exp_int = int(a, int64)
  call copy_expr(b, expr%right)
end function div_int16_expr

module function div_int32_var(a, b) result(expr)
  integer(int32), intent(in) :: a
  type(variable_type), target, intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT32
  expr%left%exp_int = int(a, int64)
  expr%right%operation = OP_LEAF
  expr%right%leaf => b
end function div_int32_var

module function div_int32_expr(a, b) result(expr)
  integer(int32), intent(in) :: a
  type(expression_type), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT32
  expr%left%exp_int = int(a, int64)
  call copy_expr(b, expr%right)
end function div_int32_expr

module function div_int64_var(a, b) result(expr)
  integer(int64), intent(in) :: a
  type(variable_type), target, intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT64
  expr%left%exp_int = int(a, int64)
  expr%right%operation = OP_LEAF
  expr%right%leaf => b
end function div_int64_var

module function div_int64_expr(a, b) result(expr)
  integer(int64), intent(in) :: a
  type(expression_type), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_INT64
  expr%left%exp_int = int(a, int64)
  call copy_expr(b, expr%right)
end function div_int64_expr

module function div_real32_var(a, b) result(expr)
  real(real32), intent(in) :: a
  type(variable_type), target, intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL32
  expr%left%exp_real = real(a, real64)
  expr%right%operation = OP_LEAF
  expr%right%leaf => b
end function div_real32_var

module function div_real32_expr(a, b) result(expr)
  real(real32), intent(in) :: a
  type(expression_type), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL32
  expr%left%exp_real = real(a, real64)
  call copy_expr(b, expr%right)
end function div_real32_expr

module function div_real64_var(a, b) result(expr)
  real(real64), intent(in) :: a
  type(variable_type), target, intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL64
  expr%left%exp_real = real(a, real64)
  expr%right%operation = OP_LEAF
  expr%right%leaf => b
end function div_real64_var

module function div_real64_expr(a, b) result(expr)
  real(real64), intent(in) :: a
  type(expression_type), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  expr%left%operation = OP_SCALAR_REAL64
  expr%left%exp_real = real(a, real64)
  call copy_expr(b, expr%right)
end function div_real64_expr

module function add_var_int8(a, b) result(expr)
  type(variable_type), target, intent(in) :: a
  integer(int8), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
  expr%right%operation = OP_SCALAR_INT8
  expr%right%exp_int = int(b, int64)
end function add_var_int8

module function add_expr_int8(a, b) result(expr)
  type(expression_type), intent(in) :: a
  integer(int8), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_SCALAR_INT8
  expr%right%exp_int = int(b, int64)
end function add_expr_int8

module function add_var_int16(a, b) result(expr)
  type(variable_type), target, intent(in) :: a
  integer(int16), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
  expr%right%operation = OP_SCALAR_INT16
  expr%right%exp_int = int(b, int64)
end function add_var_int16

module function add_expr_int16(a, b) result(expr)
  type(expression_type), intent(in) :: a
  integer(int16), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_SCALAR_INT16
  expr%right%exp_int = int(b, int64)
end function add_expr_int16

module function add_var_int32(a, b) result(expr)
  type(variable_type), target, intent(in) :: a
  integer(int32), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
  expr%right%operation = OP_SCALAR_INT32
  expr%right%exp_int = int(b, int64)
end function add_var_int32

module function add_expr_int32(a, b) result(expr)
  type(expression_type), intent(in) :: a
  integer(int32), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_SCALAR_INT32
  expr%right%exp_int = int(b, int64)
end function add_expr_int32

module function add_var_int64(a, b) result(expr)
  type(variable_type), target, intent(in) :: a
  integer(int64), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
  expr%right%operation = OP_SCALAR_INT64
  expr%right%exp_int = int(b, int64)
end function add_var_int64

module function add_expr_int64(a, b) result(expr)
  type(expression_type), intent(in) :: a
  integer(int64), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_SCALAR_INT64
  expr%right%exp_int = int(b, int64)
end function add_expr_int64

module function add_var_real32(a, b) result(expr)
  type(variable_type), target, intent(in) :: a
  real(real32), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
  expr%right%operation = OP_SCALAR_REAL32
  expr%right%exp_real = real(b, real64)
end function add_var_real32

module function add_expr_real32(a, b) result(expr)
  type(expression_type), intent(in) :: a
  real(real32), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_SCALAR_REAL32
  expr%right%exp_real = real(b, real64)
end function add_expr_real32

module function add_var_real64(a, b) result(expr)
  type(variable_type), target, intent(in) :: a
  real(real64), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
  expr%right%operation = OP_SCALAR_REAL64
  expr%right%exp_real = real(b, real64)
end function add_var_real64

module function add_expr_real64(a, b) result(expr)
  type(expression_type), intent(in) :: a
  real(real64), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_ADD
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_SCALAR_REAL64
  expr%right%exp_real = real(b, real64)
end function add_expr_real64

module function sub_var_int8(a, b) result(expr)
  type(variable_type), target, intent(in) :: a
  integer(int8), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
  expr%right%operation = OP_SCALAR_INT8
  expr%right%exp_int = int(b, int64)
end function sub_var_int8

module function sub_expr_int8(a, b) result(expr)
  type(expression_type), intent(in) :: a
  integer(int8), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_SCALAR_INT8
  expr%right%exp_int = int(b, int64)
end function sub_expr_int8

module function sub_var_int16(a, b) result(expr)
  type(variable_type), target, intent(in) :: a
  integer(int16), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
  expr%right%operation = OP_SCALAR_INT16
  expr%right%exp_int = int(b, int64)
end function sub_var_int16

module function sub_expr_int16(a, b) result(expr)
  type(expression_type), intent(in) :: a
  integer(int16), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_SCALAR_INT16
  expr%right%exp_int = int(b, int64)
end function sub_expr_int16

module function sub_var_int32(a, b) result(expr)
  type(variable_type), target, intent(in) :: a
  integer(int32), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
  expr%right%operation = OP_SCALAR_INT32
  expr%right%exp_int = int(b, int64)
end function sub_var_int32

module function sub_expr_int32(a, b) result(expr)
  type(expression_type), intent(in) :: a
  integer(int32), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_SCALAR_INT32
  expr%right%exp_int = int(b, int64)
end function sub_expr_int32

module function sub_var_int64(a, b) result(expr)
  type(variable_type), target, intent(in) :: a
  integer(int64), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
  expr%right%operation = OP_SCALAR_INT64
  expr%right%exp_int = int(b, int64)
end function sub_var_int64

module function sub_expr_int64(a, b) result(expr)
  type(expression_type), intent(in) :: a
  integer(int64), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_SCALAR_INT64
  expr%right%exp_int = int(b, int64)
end function sub_expr_int64

module function sub_var_real32(a, b) result(expr)
  type(variable_type), target, intent(in) :: a
  real(real32), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
  expr%right%operation = OP_SCALAR_REAL32
  expr%right%exp_real = real(b, real64)
end function sub_var_real32

module function sub_expr_real32(a, b) result(expr)
  type(expression_type), intent(in) :: a
  real(real32), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_SCALAR_REAL32
  expr%right%exp_real = real(b, real64)
end function sub_expr_real32

module function sub_var_real64(a, b) result(expr)
  type(variable_type), target, intent(in) :: a
  real(real64), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
  expr%right%operation = OP_SCALAR_REAL64
  expr%right%exp_real = real(b, real64)
end function sub_var_real64

module function sub_expr_real64(a, b) result(expr)
  type(expression_type), intent(in) :: a
  real(real64), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_SUB
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_SCALAR_REAL64
  expr%right%exp_real = real(b, real64)
end function sub_expr_real64

module function mul_var_int8(a, b) result(expr)
  type(variable_type), target, intent(in) :: a
  integer(int8), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
  expr%right%operation = OP_SCALAR_INT8
  expr%right%exp_int = int(b, int64)
end function mul_var_int8

module function mul_expr_int8(a, b) result(expr)
  type(expression_type), intent(in) :: a
  integer(int8), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_SCALAR_INT8
  expr%right%exp_int = int(b, int64)
end function mul_expr_int8

module function mul_var_int16(a, b) result(expr)
  type(variable_type), target, intent(in) :: a
  integer(int16), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
  expr%right%operation = OP_SCALAR_INT16
  expr%right%exp_int = int(b, int64)
end function mul_var_int16

module function mul_expr_int16(a, b) result(expr)
  type(expression_type), intent(in) :: a
  integer(int16), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_SCALAR_INT16
  expr%right%exp_int = int(b, int64)
end function mul_expr_int16

module function mul_var_int32(a, b) result(expr)
  type(variable_type), target, intent(in) :: a
  integer(int32), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
  expr%right%operation = OP_SCALAR_INT32
  expr%right%exp_int = int(b, int64)
end function mul_var_int32

module function mul_expr_int32(a, b) result(expr)
  type(expression_type), intent(in) :: a
  integer(int32), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_SCALAR_INT32
  expr%right%exp_int = int(b, int64)
end function mul_expr_int32

module function mul_var_int64(a, b) result(expr)
  type(variable_type), target, intent(in) :: a
  integer(int64), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
  expr%right%operation = OP_SCALAR_INT64
  expr%right%exp_int = int(b, int64)
end function mul_var_int64

module function mul_expr_int64(a, b) result(expr)
  type(expression_type), intent(in) :: a
  integer(int64), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_SCALAR_INT64
  expr%right%exp_int = int(b, int64)
end function mul_expr_int64

module function mul_var_real32(a, b) result(expr)
  type(variable_type), target, intent(in) :: a
  real(real32), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
  expr%right%operation = OP_SCALAR_REAL32
  expr%right%exp_real = real(b, real64)
end function mul_var_real32

module function mul_expr_real32(a, b) result(expr)
  type(expression_type), intent(in) :: a
  real(real32), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_SCALAR_REAL32
  expr%right%exp_real = real(b, real64)
end function mul_expr_real32

module function mul_var_real64(a, b) result(expr)
  type(variable_type), target, intent(in) :: a
  real(real64), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
  expr%right%operation = OP_SCALAR_REAL64
  expr%right%exp_real = real(b, real64)
end function mul_var_real64

module function mul_expr_real64(a, b) result(expr)
  type(expression_type), intent(in) :: a
  real(real64), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_MUL
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_SCALAR_REAL64
  expr%right%exp_real = real(b, real64)
end function mul_expr_real64

module function div_var_int8(a, b) result(expr)
  type(variable_type), target, intent(in) :: a
  integer(int8), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
  expr%right%operation = OP_SCALAR_INT8
  expr%right%exp_int = int(b, int64)
end function div_var_int8

module function div_expr_int8(a, b) result(expr)
  type(expression_type), intent(in) :: a
  integer(int8), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_SCALAR_INT8
  expr%right%exp_int = int(b, int64)
end function div_expr_int8

module function div_var_int16(a, b) result(expr)
  type(variable_type), target, intent(in) :: a
  integer(int16), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
  expr%right%operation = OP_SCALAR_INT16
  expr%right%exp_int = int(b, int64)
end function div_var_int16

module function div_expr_int16(a, b) result(expr)
  type(expression_type), intent(in) :: a
  integer(int16), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_SCALAR_INT16
  expr%right%exp_int = int(b, int64)
end function div_expr_int16

module function div_var_int32(a, b) result(expr)
  type(variable_type), target, intent(in) :: a
  integer(int32), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
  expr%right%operation = OP_SCALAR_INT32
  expr%right%exp_int = int(b, int64)
end function div_var_int32

module function div_expr_int32(a, b) result(expr)
  type(expression_type), intent(in) :: a
  integer(int32), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_SCALAR_INT32
  expr%right%exp_int = int(b, int64)
end function div_expr_int32

module function div_var_int64(a, b) result(expr)
  type(variable_type), target, intent(in) :: a
  integer(int64), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
  expr%right%operation = OP_SCALAR_INT64
  expr%right%exp_int = int(b, int64)
end function div_var_int64

module function div_expr_int64(a, b) result(expr)
  type(expression_type), intent(in) :: a
  integer(int64), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_SCALAR_INT64
  expr%right%exp_int = int(b, int64)
end function div_expr_int64

module function div_var_real32(a, b) result(expr)
  type(variable_type), target, intent(in) :: a
  real(real32), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
  expr%right%operation = OP_SCALAR_REAL32
  expr%right%exp_real = real(b, real64)
end function div_var_real32

module function div_expr_real32(a, b) result(expr)
  type(expression_type), intent(in) :: a
  real(real32), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_SCALAR_REAL32
  expr%right%exp_real = real(b, real64)
end function div_expr_real32

module function div_var_real64(a, b) result(expr)
  type(variable_type), target, intent(in) :: a
  real(real64), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  expr%left%operation = OP_LEAF
  expr%left%leaf => a
  expr%right%operation = OP_SCALAR_REAL64
  expr%right%exp_real = real(b, real64)
end function div_var_real64

module function div_expr_real64(a, b) result(expr)
  type(expression_type), intent(in) :: a
  real(real64), intent(in) :: b
  type(expression_type) :: expr

  expr%operation = OP_DIV
  allocate (expr%left, expr%right)
  call copy_expr(a, expr%left)
  expr%right%operation = OP_SCALAR_REAL64
  expr%right%exp_real = real(b, real64)
end function div_expr_real64

recursive subroutine copy_expr(source, dest)
  type(expression_type), intent(in) :: source
  type(expression_type), intent(out) :: dest

  dest%operation = source%operation
  dest%exp_int = source%exp_int
  dest%exp_real = source%exp_real
  dest%leaf => source%leaf
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
