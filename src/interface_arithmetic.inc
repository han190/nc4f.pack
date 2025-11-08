interface operator(+)
  module procedure :: add_vars
  module procedure :: add_var_int8
  module procedure :: add_int8_var
  module procedure :: add_var_int16
  module procedure :: add_int16_var
  module procedure :: add_var_int32
  module procedure :: add_int32_var
  module procedure :: add_var_int64
  module procedure :: add_int64_var
  module procedure :: add_var_real32
  module procedure :: add_real32_var
  module procedure :: add_var_real64
  module procedure :: add_real64_var
end interface operator(+)

interface operator(-)
  module procedure :: sub_vars
  module procedure :: sub_var_int8
  module procedure :: sub_int8_var
  module procedure :: sub_var_int16
  module procedure :: sub_int16_var
  module procedure :: sub_var_int32
  module procedure :: sub_int32_var
  module procedure :: sub_var_int64
  module procedure :: sub_int64_var
  module procedure :: sub_var_real32
  module procedure :: sub_real32_var
  module procedure :: sub_var_real64
  module procedure :: sub_real64_var
end interface operator(-)

interface operator(*)
  module procedure :: mul_vars
  module procedure :: mul_var_int8
  module procedure :: mul_int8_var
  module procedure :: mul_var_int16
  module procedure :: mul_int16_var
  module procedure :: mul_var_int32
  module procedure :: mul_int32_var
  module procedure :: mul_var_int64
  module procedure :: mul_int64_var
  module procedure :: mul_var_real32
  module procedure :: mul_real32_var
  module procedure :: mul_var_real64
  module procedure :: mul_real64_var
end interface operator(*)

interface operator(/)
  module procedure :: div_vars
  module procedure :: div_var_int8
  module procedure :: div_int8_var
  module procedure :: div_var_int16
  module procedure :: div_int16_var
  module procedure :: div_var_int32
  module procedure :: div_int32_var
  module procedure :: div_var_int64
  module procedure :: div_int64_var
  module procedure :: div_var_real32
  module procedure :: div_real32_var
  module procedure :: div_var_real64
  module procedure :: div_real64_var
end interface operator(/)

interface operator(**)
  module procedure :: pow_vars
  module procedure :: pow_var_int8
  module procedure :: pow_int8_var
  module procedure :: pow_var_int16
  module procedure :: pow_int16_var
  module procedure :: pow_var_int32
  module procedure :: pow_int32_var
  module procedure :: pow_var_int64
  module procedure :: pow_int64_var
  module procedure :: pow_var_real32
  module procedure :: pow_real32_var
  module procedure :: pow_var_real64
  module procedure :: pow_real64_var
end interface operator(**)

interface sum
  module procedure :: sum_vars
end interface sum

interface
  module function add_vars(x, y) result(res)
    type(variable_type), target, intent(in) :: x, y
    type(variable_type), target :: res
  end function add_vars

  module function add_var_int8(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    integer(int8), intent(in) :: y
    type(variable_type), target :: res
  end function add_var_int8

  module function add_int8_var(x, y) result(res)
    integer(int8), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function add_int8_var

  module function add_var_int16(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    integer(int16), intent(in) :: y
    type(variable_type), target :: res
  end function add_var_int16

  module function add_int16_var(x, y) result(res)
    integer(int16), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function add_int16_var

  module function add_var_int32(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    integer(int32), intent(in) :: y
    type(variable_type), target :: res
  end function add_var_int32

  module function add_int32_var(x, y) result(res)
    integer(int32), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function add_int32_var

  module function add_var_int64(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    integer(int64), intent(in) :: y
    type(variable_type), target :: res
  end function add_var_int64

  module function add_int64_var(x, y) result(res)
    integer(int64), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function add_int64_var

  module function add_var_real32(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    real(real32), intent(in) :: y
    type(variable_type), target :: res
  end function add_var_real32

  module function add_real32_var(x, y) result(res)
    real(real32), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function add_real32_var

  module function add_var_real64(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    real(real64), intent(in) :: y
    type(variable_type), target :: res
  end function add_var_real64

  module function add_real64_var(x, y) result(res)
    real(real64), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function add_real64_var

  module function sub_vars(x, y) result(res)
    type(variable_type), target, intent(in) :: x, y
    type(variable_type), target :: res
  end function sub_vars

  module function sub_var_int8(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    integer(int8), intent(in) :: y
    type(variable_type), target :: res
  end function sub_var_int8

  module function sub_int8_var(x, y) result(res)
    integer(int8), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function sub_int8_var

  module function sub_var_int16(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    integer(int16), intent(in) :: y
    type(variable_type), target :: res
  end function sub_var_int16

  module function sub_int16_var(x, y) result(res)
    integer(int16), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function sub_int16_var

  module function sub_var_int32(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    integer(int32), intent(in) :: y
    type(variable_type), target :: res
  end function sub_var_int32

  module function sub_int32_var(x, y) result(res)
    integer(int32), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function sub_int32_var

  module function sub_var_int64(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    integer(int64), intent(in) :: y
    type(variable_type), target :: res
  end function sub_var_int64

  module function sub_int64_var(x, y) result(res)
    integer(int64), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function sub_int64_var

  module function sub_var_real32(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    real(real32), intent(in) :: y
    type(variable_type), target :: res
  end function sub_var_real32

  module function sub_real32_var(x, y) result(res)
    real(real32), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function sub_real32_var

  module function sub_var_real64(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    real(real64), intent(in) :: y
    type(variable_type), target :: res
  end function sub_var_real64

  module function sub_real64_var(x, y) result(res)
    real(real64), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function sub_real64_var

  module function mul_vars(x, y) result(res)
    type(variable_type), target, intent(in) :: x, y
    type(variable_type), target :: res
  end function mul_vars

  module function mul_var_int8(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    integer(int8), intent(in) :: y
    type(variable_type), target :: res
  end function mul_var_int8

  module function mul_int8_var(x, y) result(res)
    integer(int8), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function mul_int8_var

  module function mul_var_int16(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    integer(int16), intent(in) :: y
    type(variable_type), target :: res
  end function mul_var_int16

  module function mul_int16_var(x, y) result(res)
    integer(int16), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function mul_int16_var

  module function mul_var_int32(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    integer(int32), intent(in) :: y
    type(variable_type), target :: res
  end function mul_var_int32

  module function mul_int32_var(x, y) result(res)
    integer(int32), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function mul_int32_var

  module function mul_var_int64(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    integer(int64), intent(in) :: y
    type(variable_type), target :: res
  end function mul_var_int64

  module function mul_int64_var(x, y) result(res)
    integer(int64), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function mul_int64_var

  module function mul_var_real32(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    real(real32), intent(in) :: y
    type(variable_type), target :: res
  end function mul_var_real32

  module function mul_real32_var(x, y) result(res)
    real(real32), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function mul_real32_var

  module function mul_var_real64(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    real(real64), intent(in) :: y
    type(variable_type), target :: res
  end function mul_var_real64

  module function mul_real64_var(x, y) result(res)
    real(real64), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function mul_real64_var

  module function div_vars(x, y) result(res)
    type(variable_type), target, intent(in) :: x, y
    type(variable_type), target :: res
  end function div_vars

  module function div_var_int8(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    integer(int8), intent(in) :: y
    type(variable_type), target :: res
  end function div_var_int8

  module function div_int8_var(x, y) result(res)
    integer(int8), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function div_int8_var

  module function div_var_int16(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    integer(int16), intent(in) :: y
    type(variable_type), target :: res
  end function div_var_int16

  module function div_int16_var(x, y) result(res)
    integer(int16), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function div_int16_var

  module function div_var_int32(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    integer(int32), intent(in) :: y
    type(variable_type), target :: res
  end function div_var_int32

  module function div_int32_var(x, y) result(res)
    integer(int32), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function div_int32_var

  module function div_var_int64(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    integer(int64), intent(in) :: y
    type(variable_type), target :: res
  end function div_var_int64

  module function div_int64_var(x, y) result(res)
    integer(int64), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function div_int64_var

  module function div_var_real32(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    real(real32), intent(in) :: y
    type(variable_type), target :: res
  end function div_var_real32

  module function div_real32_var(x, y) result(res)
    real(real32), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function div_real32_var

  module function div_var_real64(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    real(real64), intent(in) :: y
    type(variable_type), target :: res
  end function div_var_real64

  module function div_real64_var(x, y) result(res)
    real(real64), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function div_real64_var

  module function pow_vars(x, y) result(res)
    type(variable_type), target, intent(in) :: x, y
    type(variable_type), target :: res
  end function pow_vars

  module function pow_var_int8(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    integer(int8), intent(in) :: y
    type(variable_type), target :: res
  end function pow_var_int8

  module function pow_int8_var(x, y) result(res)
    integer(int8), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function pow_int8_var

  module function pow_var_int16(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    integer(int16), intent(in) :: y
    type(variable_type), target :: res
  end function pow_var_int16

  module function pow_int16_var(x, y) result(res)
    integer(int16), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function pow_int16_var

  module function pow_var_int32(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    integer(int32), intent(in) :: y
    type(variable_type), target :: res
  end function pow_var_int32

  module function pow_int32_var(x, y) result(res)
    integer(int32), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function pow_int32_var

  module function pow_var_int64(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    integer(int64), intent(in) :: y
    type(variable_type), target :: res
  end function pow_var_int64

  module function pow_int64_var(x, y) result(res)
    integer(int64), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function pow_int64_var

  module function pow_var_real32(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    real(real32), intent(in) :: y
    type(variable_type), target :: res
  end function pow_var_real32

  module function pow_real32_var(x, y) result(res)
    real(real32), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function pow_real32_var

  module function pow_var_real64(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    real(real64), intent(in) :: y
    type(variable_type), target :: res
  end function pow_var_real64

  module function pow_real64_var(x, y) result(res)
    real(real64), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function pow_real64_var

  module function sum_vars(vars) result(s)
    type(variable_type), intent(in) :: vars(:)
    type(variable_type) :: s
  end function sum_vars
end interface

