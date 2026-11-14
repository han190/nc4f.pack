submodule(nc4f_test_data) nc4f_test_data_expression
use, intrinsic :: iso_fortran_env, only: &
  & int8, int16, int32, int64, real32, real64
use, intrinsic :: ieee_arithmetic, only: ieee_is_finite, ieee_is_nan
use, intrinsic :: ieee_exceptions, only: ieee_get_flag, ieee_set_flag, &
  & ieee_invalid, ieee_divide_by_zero
use, non_intrinsic :: testdrive, only: check, error_type, new_unittest, &
  & unittest_type
use, non_intrinsic :: nc4f, only: datarray, evaluate, expression_type, &
  & extract, variable_type, dimension_type, &
  & error_type_model => error_type, &
  & operator(+), operator(-), operator(*), operator(/), operator(**), &
  & operator(.dim.), assignment(=), NC_EINVAL, NC_NOERR
implicit none (type, external)
contains

module subroutine collect_data_expression(tests)
  type(unittest_type), allocatable, intent(out) :: tests(:)

  tests = [ &
    & new_unittest("nested addition", test_nested_addition), &
    & new_unittest("right-nested addition", test_right_nested_addition), &
    & new_unittest("subtraction", test_subtraction), &
    & new_unittest("multiplication", test_multiplication), &
    & new_unittest("division", test_division), &
    & new_unittest("power", test_power), &
    & new_unittest("scalar int8 power", test_scalar_int8_power), &
    & new_unittest("scalar int16 power", test_scalar_int16_power), &
    & new_unittest("scalar int32 power", test_scalar_int32_power), &
    & new_unittest("scalar int64 power", test_scalar_int64_power), &
    & new_unittest("scalar real32 power", test_scalar_real32_power), &
    & new_unittest("scalar real64 power", test_scalar_real64_power), &
    & new_unittest("scalar int8 arithmetic", &
    & test_scalar_int8_arithmetic), &
    & new_unittest("scalar int16 arithmetic", &
    & test_scalar_int16_arithmetic), &
    & new_unittest("scalar int32 arithmetic", &
    & test_scalar_int32_arithmetic), &
    & new_unittest("scalar int64 arithmetic", &
    & test_scalar_int64_arithmetic), &
    & new_unittest("scalar real32 arithmetic", &
    & test_scalar_real32_arithmetic), &
    & new_unittest("scalar real64 arithmetic", &
    & test_scalar_real64_arithmetic), &
    & new_unittest("mixed arithmetic", test_mixed_arithmetic), &
    & new_unittest("deep nested arithmetic", test_deep_nested_arithmetic), &
    & new_unittest("expression operands", test_expression_operands), &
    & new_unittest("division by zero", test_division_by_zero), &
    & new_unittest("negative integer power", test_negative_integer_power), &
    & new_unittest("zero reciprocal", test_zero_reciprocal), &
    & new_unittest("uninitialized expression", test_uninitialized_expression), &
    & new_unittest("dimension order", test_dimension_order), &
    & new_unittest("dimension length", test_dimension_length), &
    & new_unittest("type mismatch", test_type_mismatch), &
    & new_unittest("scalar type mismatch", test_scalar_type_mismatch), &
    & new_unittest("scalar zero divisor", test_scalar_zero_divisor), &
    & new_unittest("live borrowed values", test_live_values), &
    & new_unittest("missing operand storage", test_missing_storage), &
    & new_unittest("destination alias", test_destination_alias), &
    & new_unittest("fused borrowed matrix", test_fused_matrix), &
    & new_unittest("empty expression", test_empty_expression), &
    & new_unittest("blocked scratch reuse", test_blocked_scratch)]
end subroutine collect_data_expression

subroutine test_nested_addition(error)
  type(error_type), allocatable, intent(out) :: error
  type(variable_type), target :: a, b, c
  type(variable_type) :: result
  real(real32), pointer :: values(:)

  a = datarray("a", [1.0_real32, 2.0_real32], ["x" .dim. 2], deep=.true.)
  b = datarray("b", [3.0_real32, 4.0_real32], ["x" .dim. 2], deep=.true.)
  c = datarray("c", [5.0_real32, 6.0_real32], ["x" .dim. 2], deep=.true.)
  result = (a + b) + c
  call extract(result, values)
  call check(error, all(values == [9.0_real32, 12.0_real32]), &
    & "Nested addition differs")
end subroutine test_nested_addition

subroutine test_right_nested_addition(error)
  type(error_type), allocatable, intent(out) :: error
  type(variable_type), target :: a, b, c
  type(variable_type) :: result
  real(real32), pointer :: values(:)

  a = datarray("a", [1.0_real32, 2.0_real32], ["x" .dim. 2], deep=.true.)
  b = datarray("b", [3.0_real32, 4.0_real32], ["x" .dim. 2], deep=.true.)
  c = datarray("c", [5.0_real32, 6.0_real32], ["x" .dim. 2], deep=.true.)
  result = a + (b + c)
  call extract(result, values)
  call check(error, all(values == [9.0_real32, 12.0_real32]), &
    & "Right-nested addition differs")
end subroutine test_right_nested_addition

subroutine test_subtraction(error)
  type(error_type), allocatable, intent(out) :: error
  type(variable_type), target :: a, b
  type(variable_type) :: result
  real(real32), pointer :: values(:)

  a = datarray("a", [5.0_real32, 8.0_real32], ["x" .dim. 2], deep=.true.)
  b = datarray("b", [2.0_real32, 3.0_real32], ["x" .dim. 2], deep=.true.)
  result = a - b
  call extract(result, values)
  call check(error, all(abs(values - [3.0_real32, 5.0_real32]) &
    & < 1.0e-6_real32), "Subtraction differs")
end subroutine test_subtraction

subroutine test_multiplication(error)
  type(error_type), allocatable, intent(out) :: error
  type(variable_type), target :: a, b
  type(variable_type) :: result
  real(real32), pointer :: values(:)

  a = datarray("a", [2.0_real32, 3.0_real32], ["x" .dim. 2], deep=.true.)
  b = datarray("b", [4.0_real32, 5.0_real32], ["x" .dim. 2], deep=.true.)
  result = a*b
  call extract(result, values)
  call check(error, all(abs(values - [8.0_real32, 15.0_real32]) &
    & < 1.0e-6_real32), "Multiplication differs")
end subroutine test_multiplication

subroutine test_division(error)
  type(error_type), allocatable, intent(out) :: error
  type(variable_type), target :: a, b
  type(variable_type) :: result
  real(real32), pointer :: values(:)

  a = datarray("a", [8.0_real32, 9.0_real32], ["x" .dim. 2], deep=.true.)
  b = datarray("b", [2.0_real32, 3.0_real32], ["x" .dim. 2], deep=.true.)
  result = a/b
  call extract(result, values)
  call check(error, all(abs(values - [4.0_real32, 3.0_real32]) &
    & < 1.0e-6_real32), "Division differs")
end subroutine test_division

subroutine test_power(error)
  type(error_type), allocatable, intent(out) :: error
  type(variable_type), target :: a, b
  type(variable_type) :: result
  real(real32), pointer :: values(:)

  a = datarray("a", [2.0_real32, 3.0_real32], ["x" .dim. 2], deep=.true.)
  b = datarray("b", [3.0_real32, 2.0_real32], ["x" .dim. 2], deep=.true.)
  result = a**b
  call extract(result, values)
  call check(error, all(abs(values - [8.0_real32, 9.0_real32]) &
    & < 1.0e-6_real32), "Power differs")
end subroutine test_power

subroutine test_scalar_int8_power(error)
  type(error_type), allocatable, intent(out) :: error
  type(variable_type), target :: a
  type(variable_type) :: result
  integer(int8), pointer :: values(:)

  a = datarray("a", [2_int8, 3_int8], ["x" .dim. 2], deep=.true.)
  result = a**2_int8
  call extract(result, values)
  call check(error, all(values == [4_int8, 9_int8]), &
    & "Variable int8 power differs")
  if (allocated(error)) return
  result = (a + a)**2_int8
  call extract(result, values)
  call check(error, all(values == [16_int8, 36_int8]), &
    & "Expression int8 power differs")
end subroutine test_scalar_int8_power

subroutine test_scalar_int16_power(error)
  type(error_type), allocatable, intent(out) :: error
  type(variable_type), target :: a
  type(variable_type) :: result
  integer(int16), pointer :: values(:)

  a = datarray("a", [2_int16, 3_int16], ["x" .dim. 2], deep=.true.)
  result = a**2_int16
  call extract(result, values)
  call check(error, all(values == [4_int16, 9_int16]), &
    & "Variable int16 power differs")
  if (allocated(error)) return
  result = (a + a)**2_int16
  call extract(result, values)
  call check(error, all(values == [16_int16, 36_int16]), &
    & "Expression int16 power differs")
end subroutine test_scalar_int16_power

subroutine test_scalar_int32_power(error)
  type(error_type), allocatable, intent(out) :: error
  type(variable_type), target :: a
  type(variable_type) :: result
  integer(int32), pointer :: values(:)

  a = datarray("a", [2_int32, 3_int32], ["x" .dim. 2], deep=.true.)
  result = a**2_int32
  call extract(result, values)
  call check(error, all(values == [4_int32, 9_int32]), &
    & "Variable int32 power differs")
  if (allocated(error)) return
  result = (a + a)**2_int32
  call extract(result, values)
  call check(error, all(values == [16_int32, 36_int32]), &
    & "Expression int32 power differs")
end subroutine test_scalar_int32_power

subroutine test_scalar_int64_power(error)
  type(error_type), allocatable, intent(out) :: error
  type(variable_type), target :: a
  type(variable_type) :: result
  integer(int64), pointer :: values(:)

  a = datarray("a", [2_int64, 3_int64], ["x" .dim. 2], deep=.true.)
  result = a**2_int64
  call extract(result, values)
  call check(error, all(values == [4_int64, 9_int64]), &
    & "Variable int64 power differs")
  if (allocated(error)) return
  result = (a + a)**2_int64
  call extract(result, values)
  call check(error, all(values == [16_int64, 36_int64]), &
    & "Expression int64 power differs")
end subroutine test_scalar_int64_power

subroutine test_scalar_real32_power(error)
  type(error_type), allocatable, intent(out) :: error
  type(variable_type), target :: a, integer_base, double_base
  type(variable_type) :: result
  real(real32), pointer :: values(:)
  real(real64), pointer :: values64(:)

  a = datarray("a", [4.0_real32, 9.0_real32], &
    & ["x" .dim. 2], deep=.true.)
  result = a**0.5_real32
  call extract(result, values)
  call check(error, all(abs(values - [2.0_real32, 3.0_real32]) &
    & < 1.0e-6_real32), "Variable real32 power differs")
  if (allocated(error)) return
  result = (a + a)**0.5_real32
  call extract(result, values)
  call check(error, all(abs(values - &
    & [sqrt(8.0_real32), sqrt(18.0_real32)]) < 1.0e-6_real32), &
    & "Expression real32 power differs")
  if (allocated(error)) return
  integer_base = datarray("integer_base", [4_int32, 9_int32], &
    & ["x" .dim. 2], deep=.true.)
  result = integer_base**0.5_real32
  call extract(result, values)
  call check(error, all(abs(values - [2.0_real32, 3.0_real32]) &
    & < 1.0e-6_real32), "Integer base real32 power differs")
  if (allocated(error)) return
  double_base = datarray("double_base", [4.0_real64, 9.0_real64], &
    & ["x" .dim. 2], deep=.true.)
  result = double_base**0.5_real32
  call extract(result, values64)
  call check(error, all(abs(values64 - [2.0_real64, 3.0_real64]) &
    & < 1.0e-12_real64), "Real64 base real32 power differs")
end subroutine test_scalar_real32_power

subroutine test_scalar_real64_power(error)
  type(error_type), allocatable, intent(out) :: error
  type(variable_type), target :: a
  type(variable_type) :: result
  real(real64), pointer :: values(:)

  a = datarray("a", [4.0_real32, 9.0_real32], &
    & ["x" .dim. 2], deep=.true.)
  result = a**0.5_real64
  call extract(result, values)
  call check(error, all(abs(values - [2.0_real64, 3.0_real64]) &
    & < 1.0e-12_real64), "Variable real64 power differs")
  if (allocated(error)) return
  result = (a + a)**0.5_real64
  call extract(result, values)
  call check(error, all(abs(values - &
    & [sqrt(8.0_real64), sqrt(18.0_real64)]) < 1.0e-12_real64), &
    & "Expression real64 power differs")
  if (allocated(error)) return
  result = (a**0.5_real64) + (a**0.5_real64)
  call extract(result, values)
  call check(error, all(abs(values - [4.0_real64, 6.0_real64]) &
    & < 1.0e-12_real64), "Nested real64 power differs")
end subroutine test_scalar_real64_power

subroutine test_mixed_arithmetic(error)
  type(error_type), allocatable, intent(out) :: error
  type(variable_type), target :: a, b, c
  type(variable_type) :: result
  real(real32), pointer :: values(:)

  a = datarray("a", [2.0_real32, 4.0_real32], ["x" .dim. 2], deep=.true.)
  b = datarray("b", [5.0_real32, 8.0_real32], ["x" .dim. 2], deep=.true.)
  c = datarray("c", [3.0_real32, 2.0_real32], ["x" .dim. 2], deep=.true.)
  result = (a**(-1)) * ((b - a) / (a + c))
  call extract(result, values)
  call check(error, all(abs(values - [0.3_real32, 1.0_real32/6.0_real32]) &
    & < 1.0e-6_real32), "Mixed arithmetic differs")
end subroutine test_mixed_arithmetic

subroutine test_deep_nested_arithmetic(error)
  type(error_type), allocatable, intent(out) :: error
  type(dimension_type) :: dims(2)
  type(variable_type), target :: rho, zeta, f, theta, offset, scale, powers
  type(variable_type) :: result
  type(expression_type) :: expr
  real(real64) :: rho_data(2, 2), zeta_data(2, 2), f_data(2, 2)
  real(real64) :: theta_data(2, 2), offset_data(2, 2)
  real(real64) :: scale_data(2, 2), power_data(2, 2), expected(2, 2)
  real(real64), pointer :: f_values(:, :), values(:, :)

  dims = ["x" .dim. 2, "y" .dim. 2]
  rho_data = reshape([2.0_real64, 4.0_real64, 5.0_real64, &
    & 10.0_real64], [2, 2])
  zeta_data = reshape([1.0_real64, 2.0_real64, 3.0_real64, &
    & 4.0_real64], [2, 2])
  f_data = 2.0_real64
  theta_data = reshape([4.0_real64, 9.0_real64, 16.0_real64, &
    & 25.0_real64], [2, 2])
  offset_data = 1.0_real64
  scale_data = reshape([2.0_real64, 3.0_real64, 4.0_real64, &
    & 5.0_real64], [2, 2])
  power_data = reshape([1.0_real64, 2.0_real64, 1.0_real64, &
    & 0.0_real64], [2, 2])

  rho = datarray("rho", rho_data, dims, deep=.true.)
  zeta = datarray("zeta", zeta_data, dims, deep=.true.)
  f = datarray("f", f_data, dims, deep=.true.)
  theta = datarray("theta", theta_data, dims, deep=.true.)
  offset = datarray("offset", offset_data, dims, deep=.true.)
  scale = datarray("scale", scale_data, dims, deep=.true.)
  powers = datarray("powers", power_data, dims, deep=.true.)

  expr = ( &
    & rho**(-1_int32) * ( &
    & ((zeta + f) * (theta - offset)) / (scale**2_int64)) + &
    & theta**0.5_real64 - (f/scale)**2_int16 + &
    & theta**powers)

  call extract(f, f_values)
  f_values(2, 1) = 3.0_real64
  f_data(2, 1) = 3.0_real64
  result = expr
  call extract(result, values)
  expected = rho_data**(-1_int32) * ( &
    & ((zeta_data + f_data) * (theta_data - offset_data)) / &
    & (scale_data**2_int64)) + theta_data**0.5_real64 - &
    & (f_data/scale_data)**2_int16 + theta_data**power_data
  call check(error, all(shape(values) == [2, 2]) .and. &
    & maxval(abs(values - expected)) < &
    & 1.0e-12_real64 * max(1.0_real64, maxval(abs(expected))), &
    & "Deep nested expression differs from intrinsic array arithmetic")
end subroutine test_deep_nested_arithmetic

subroutine test_expression_operands(error)
  type(error_type), allocatable, intent(out) :: error
  type(variable_type), target :: a, b, c
  type(variable_type) :: result
  real(real32), pointer :: values(:)

  a = datarray("a", [4.0_real32], ["x" .dim. 1], deep=.true.)
  b = datarray("b", [2.0_real32], ["x" .dim. 1], deep=.true.)
  c = datarray("c", [1.0_real32], ["x" .dim. 1], deep=.true.)
  result = (a - (b + c)) * c / (a**(b - c))
  call extract(result, values)
  call check(error, abs(values(1) - 0.25_real32) < 1.0e-6_real32, &
    & "Expression operand combinations differ")
  if (allocated(error)) return
  result = (a + b)**2
  call extract(result, values)
  call check(error, abs(values(1) - 36.0_real32) < 1.0e-6_real32, &
    & "Expression scalar power differs")
end subroutine test_expression_operands

subroutine test_division_by_zero(error)
  !! Floating-point exceptions follow the runtime, rather than NC4F errors.
  type(error_type), allocatable, intent(out) :: error
  type(variable_type), target :: a, b
  type(variable_type) :: result
  type(error_type_model) :: err
  logical :: saved_flags(2)
  real(real32), pointer :: values(:)
  logical :: correct

  a = datarray("a", [2.0_real32, 4.0_real32], ["x" .dim. 2])
  b = datarray("b", [1.0_real32, 0.0_real32], ["x" .dim. 2])
  ! Tests use the build's default nonhalting FP mode and restore raised flags.
  call ieee_get_flag([ieee_invalid, ieee_divide_by_zero], saved_flags)
  call evaluate(a/b, result, err)
  call extract(result, values)
  correct = values(1) == 2.0_real32 .and. .not. ieee_is_finite(values(2))
  correct = correct .and. .not. ieee_is_nan(values(2))
  call ieee_set_flag([ieee_invalid, ieee_divide_by_zero], saved_flags)
  call check(error, err%code == NC_NOERR .and. correct, &
    & "Real division did not retain the runtime result")
end subroutine test_division_by_zero

subroutine test_negative_integer_power(error)
  type(error_type), allocatable, intent(out) :: error
  type(variable_type), target :: a
  type(variable_type) :: result
  type(error_type_model) :: err
  integer(int32), pointer :: values(:)
  integer :: exponent

  exponent = -1
  a = datarray("a", [2_int32, -1_int32, 1_int32], ["x" .dim. 3])
  call evaluate(a**exponent, result, err)
  call check(error, err%code == NC_NOERR, "Integer power failed")
  if (allocated(error)) return
  call extract(result, values)
  call check(error, all(values == [2_int32, -1_int32, 1_int32]**exponent), &
    & "Negative integer power differs from Fortran")
end subroutine test_negative_integer_power

subroutine test_zero_reciprocal(error)
  type(error_type), allocatable, intent(out) :: error
  type(variable_type), target :: a
  type(variable_type) :: result
  type(error_type_model) :: err
  logical :: saved_flags(2)
  real(real32), pointer :: values(:)
  logical :: correct

  a = datarray("a", [0.0_real32], ["x" .dim. 1])
  ! Tests use the build's default nonhalting FP mode and restore raised flags.
  call ieee_get_flag([ieee_invalid, ieee_divide_by_zero], saved_flags)
  call evaluate(a**(-1), result, err)
  call extract(result, values)
  correct = .not. ieee_is_finite(values(1)) .and. .not. ieee_is_nan(values(1))
  call ieee_set_flag([ieee_invalid, ieee_divide_by_zero], saved_flags)
  call check(error, err%code == NC_NOERR .and. correct, &
    & "Zero reciprocal did not retain the runtime result")
end subroutine test_zero_reciprocal

subroutine test_uninitialized_expression(error)
  type(error_type), allocatable, intent(out) :: error
  type(expression_type) :: expr
  type(variable_type) :: result
  type(error_type_model) :: err

  call evaluate(expr, result, err)
  call check(error, err%code == NC_EINVAL, &
    & "Uninitialized expression was accepted")
end subroutine test_uninitialized_expression

subroutine test_dimension_order(error)
  type(error_type), allocatable, intent(out) :: error
  type(variable_type), target :: a, b
  type(variable_type) :: result
  type(error_type_model) :: err

  a = datarray("a", reshape([1.0_real32, 2.0_real32, 3.0_real32, &
    & 4.0_real32, 5.0_real32, 6.0_real32], [2, 3]), &
    & ["x" .dim. 2, "y" .dim. 3], deep=.true.)
  b = datarray("b", reshape([1.0_real32, 2.0_real32, 3.0_real32, &
    & 4.0_real32, 5.0_real32, 6.0_real32], [3, 2]), &
    & ["y" .dim. 3, "x" .dim. 2], deep=.true.)
  call evaluate(a + b, result, err)
  call check(error, err%code == NC_EINVAL, &
    & "Reordered dimensions were accepted")
end subroutine test_dimension_order

subroutine test_dimension_length(error)
  type(error_type), allocatable, intent(out) :: error
  type(variable_type), target :: a, b
  type(variable_type) :: result
  type(error_type_model) :: err

  a = datarray("a", [1.0_real32, 2.0_real32], ["x" .dim. 2], deep=.true.)
  b = datarray("b", [1.0_real32, 2.0_real32, 3.0_real32], &
    & ["x" .dim. 3], deep=.true.)
  call evaluate(a + b, result, err)
  call check(error, err%code == NC_EINVAL, &
    & "Different dimension lengths were accepted")
end subroutine test_dimension_length

subroutine test_type_mismatch(error)
  type(error_type), allocatable, intent(out) :: error
  type(variable_type), target :: a, b
  type(variable_type) :: result
  type(error_type_model) :: err

  a = datarray("a", [1.0_real32, 2.0_real32], ["x" .dim. 2], deep=.true.)
  b = datarray("b", [1_int32, 2_int32], ["x" .dim. 2], deep=.true.)
  call evaluate(a + b, result, err)
  call check(error, err%code == NC_EINVAL, &
    & "Different data types were accepted")
end subroutine test_type_mismatch

subroutine test_scalar_type_mismatch(error)
  type(error_type), allocatable, intent(out) :: error
  type(variable_type), target :: a
  type(variable_type) :: result
  type(error_type_model) :: err

  a = datarray("a", [1.0_real32, 2.0_real32], &
    & ["x" .dim. 2], deep=.true.)
  call evaluate(1.0_real64 + a, result, err)
  call check(error, err%code == NC_EINVAL, &
    & "Mismatched scalar type was accepted")
end subroutine test_scalar_type_mismatch

subroutine test_scalar_zero_divisor(error)
  type(error_type), allocatable, intent(out) :: error
  type(variable_type), target :: a
  type(variable_type) :: result
  type(error_type_model) :: err
  logical :: saved_flags(2)
  real(real64), pointer :: values(:)
  logical :: correct

  a = datarray("a", [1.0_real64, 0.0_real64], ["x" .dim. 2])
  ! Tests use the build's default nonhalting FP mode and restore raised flags.
  call ieee_get_flag([ieee_invalid, ieee_divide_by_zero], saved_flags)
  call evaluate(a/0.0_real64, result, err)
  call extract(result, values)
  correct = .not. ieee_is_finite(values(1)) .and. ieee_is_nan(values(2))
  call ieee_set_flag([ieee_invalid, ieee_divide_by_zero], saved_flags)
  call check(error, err%code == NC_NOERR .and. correct, &
    & "Scalar division did not retain the runtime result")
end subroutine test_scalar_zero_divisor

subroutine test_live_values(error)
  type(error_type), allocatable, intent(out) :: error
  real(real32), target :: a_values(2), b_values(2)
  type(variable_type), target :: a, b
  type(variable_type) :: result
  type(expression_type) :: expr
  real(real32), pointer :: values(:)

  a_values = [1.0_real32, 2.0_real32]
  b_values = [3.0_real32, 4.0_real32]
  a = datarray("a", a_values, ["x" .dim. 2], deep=.false.)
  b = datarray("b", b_values, ["x" .dim. 2], deep=.false.)
  expr = a + b
  a_values(1) = 7.0_real32
  result = expr
  call extract(result, values)
  call check(error, all(values == [10.0_real32, 6.0_real32]), &
    & "Expression did not read current operand values")
  if (allocated(error)) return
  a = datarray("a", a_values, ["x" .dim. 2])
  b = datarray("b", b_values, ["x" .dim. 2])
  expr = a + b
  call extract(a, values)
  values(2) = 8.0_real32
  result = expr
  call extract(result, values)
  call check(error, all(values == [10.0_real32, 12.0_real32]), &
    & "Expression did not retain the owned-buffer view")
end subroutine test_live_values

subroutine test_missing_storage(error)
  type(error_type), allocatable, intent(out) :: error
  type(variable_type), target :: a, b
  type(variable_type) :: result
  type(expression_type) :: expr
  type(error_type_model) :: err

  a = datarray("a", [1.0_real32], ["x" .dim. 1], deep=.true.)
  b = datarray("b", [2.0_real32], ["x" .dim. 1], deep=.true.)
  result = datarray("result", [9.0_real32], ["x" .dim. 1], deep=.true.)
  ! Missing storage is recorded at binding, before any pointer can expire.
  deallocate (a%buffer)
  expr = a + b
  expr = expr + 1.0_real32
  call evaluate(expr, result, err)
  call check(error, err%code == NC_EINVAL .and. &
    & result%name == "result", "Missing storage changed the result")
end subroutine test_missing_storage

subroutine test_destination_alias(error)
  type(error_type), allocatable, intent(out) :: error
  type(variable_type), target :: a, b
  real(real32), pointer :: values(:)

  a = datarray("a", [1.0_real32, 2.0_real32], ["x" .dim. 2], deep=.true.)
  b = datarray("b", [3.0_real32, 4.0_real32], ["x" .dim. 2], deep=.true.)
  a = a + b
  call extract(a, values)
  call check(error, all(values == [4.0_real32, 6.0_real32]), &
    & "Destination alias produced wrong values")
end subroutine test_destination_alias

subroutine test_scalar_int8_arithmetic(error)
  type(error_type), allocatable, intent(out) :: error
  type(variable_type), target :: a
  type(variable_type) :: result
  integer(int8), pointer :: values(:)

  a = datarray("a", [2_int8, 4_int8], &
    & ["x" .dim. 2], deep=.true.)
  result = (8_int8/a) + (a*3_int8) - &
    & (10_int8 - a) + ((a + 2_int8)/2_int8)
  call extract(result, values)
  call check(error, all(values == [4_int8, &
    & 11_int8]), "Scalar and variable arithmetic differs")
  if (allocated(error)) return
  result = 1_int8 + 12_int8/(a + 2_int8) + &
    & 2_int8*(a + 1_int8) - (10_int8 - (a + 1_int8))
  call extract(result, values)
  call check(error, all(values == [3_int8, &
    & 8_int8]), "Scalar and expression arithmetic differs")
end subroutine test_scalar_int8_arithmetic

subroutine test_scalar_int16_arithmetic(error)
  type(error_type), allocatable, intent(out) :: error
  type(variable_type), target :: a
  type(variable_type) :: result
  integer(int16), pointer :: values(:)

  a = datarray("a", [2_int16, 4_int16], &
    & ["x" .dim. 2], deep=.true.)
  result = (8_int16/a) + (a*3_int16) - &
    & (10_int16 - a) + ((a + 2_int16)/2_int16)
  call extract(result, values)
  call check(error, all(values == [4_int16, &
    & 11_int16]), "Scalar and variable arithmetic differs")
  if (allocated(error)) return
  result = 1_int16 + 12_int16/(a + 2_int16) + &
    & 2_int16*(a + 1_int16) - (10_int16 - (a + 1_int16))
  call extract(result, values)
  call check(error, all(values == [3_int16, &
    & 8_int16]), "Scalar and expression arithmetic differs")
end subroutine test_scalar_int16_arithmetic

subroutine test_scalar_int32_arithmetic(error)
  type(error_type), allocatable, intent(out) :: error
  type(variable_type), target :: a
  type(variable_type) :: result
  integer(int32), pointer :: values(:)

  a = datarray("a", [2_int32, 4_int32], &
    & ["x" .dim. 2], deep=.true.)
  result = (8_int32/a) + (a*3_int32) - &
    & (10_int32 - a) + ((a + 2_int32)/2_int32)
  call extract(result, values)
  call check(error, all(values == [4_int32, &
    & 11_int32]), "Scalar and variable arithmetic differs")
  if (allocated(error)) return
  result = 1_int32 + 12_int32/(a + 2_int32) + &
    & 2_int32*(a + 1_int32) - (10_int32 - (a + 1_int32))
  call extract(result, values)
  call check(error, all(values == [3_int32, &
    & 8_int32]), "Scalar and expression arithmetic differs")
end subroutine test_scalar_int32_arithmetic

subroutine test_scalar_int64_arithmetic(error)
  type(error_type), allocatable, intent(out) :: error
  type(variable_type), target :: a
  type(variable_type) :: result
  integer(int64), pointer :: values(:)

  a = datarray("a", [2_int64, 4_int64], &
    & ["x" .dim. 2], deep=.true.)
  result = (8_int64/a) + (a*3_int64) - &
    & (10_int64 - a) + ((a + 2_int64)/2_int64)
  call extract(result, values)
  call check(error, all(values == [4_int64, &
    & 11_int64]), "Scalar and variable arithmetic differs")
  if (allocated(error)) return
  result = 1_int64 + 12_int64/(a + 2_int64) + &
    & 2_int64*(a + 1_int64) - (10_int64 - (a + 1_int64))
  call extract(result, values)
  call check(error, all(values == [3_int64, &
    & 8_int64]), "Scalar and expression arithmetic differs")
end subroutine test_scalar_int64_arithmetic

subroutine test_scalar_real32_arithmetic(error)
  type(error_type), allocatable, intent(out) :: error
  type(variable_type), target :: a
  type(variable_type) :: result
  real(real32), pointer :: values(:)

  a = datarray("a", [2.0_real32, 4.0_real32], &
    & ["x" .dim. 2], deep=.true.)
  result = (8.0_real32/a) + (a*3.0_real32) - &
    & (10.0_real32 - a) + ((a + 2.0_real32)/2.0_real32)
  call extract(result, values)
  call check(error, all(abs(values - [4.0_real32, &
    & 11.0_real32]) < 1.0e-5_real32), &
    & "Scalar and variable arithmetic differs")
  if (allocated(error)) return
  result = 1.0_real32 + 12.0_real32/(a + 2.0_real32) + &
    & 2.0_real32*(a + 1.0_real32) - (10.0_real32 - (a + 1.0_real32))
  call extract(result, values)
  call check(error, all(abs(values - [3.0_real32, &
    & 8.0_real32]) < 1.0e-5_real32), &
    & "Scalar and expression arithmetic differs")
end subroutine test_scalar_real32_arithmetic

subroutine test_scalar_real64_arithmetic(error)
  type(error_type), allocatable, intent(out) :: error
  type(variable_type), target :: a
  type(variable_type) :: result
  real(real64), pointer :: values(:)

  a = datarray("a", [2.0_real64, 4.0_real64], &
    & ["x" .dim. 2], deep=.true.)
  result = (8.0_real64/a) + (a*3.0_real64) - &
    & (10.0_real64 - a) + ((a + 2.0_real64)/2.0_real64)
  call extract(result, values)
  call check(error, all(abs(values - [4.0_real64, &
    & 11.0_real64]) < 1.0e-12_real64), &
    & "Scalar and variable arithmetic differs")
  if (allocated(error)) return
  result = 1.0_real64 + 12.0_real64/(a + 2.0_real64) + &
    & 2.0_real64*(a + 1.0_real64) - (10.0_real64 - (a + 1.0_real64))
  call extract(result, values)
  call check(error, all(abs(values - [3.0_real64, &
    & 8.0_real64]) < 1.0e-12_real64), &
    & "Scalar and expression arithmetic differs")
end subroutine test_scalar_real64_arithmetic

subroutine test_fused_matrix(error)
  type(error_type), allocatable, intent(out) :: error
  integer, parameter :: m = 37, n = 29
  real(real64), target :: x(m,n), y(m,n), z(m,n)
  real(real64), pointer :: values(:,:)
  type(variable_type), target :: a, b, c, result
  type(expression_type) :: expr
  type(error_type_model) :: err
  integer :: i, pass

  x = reshape([(real(i, real64)/100, i=1,m*n)], [m,n])
  y = 2.0_real64*x
  z = 3.0_real64*x
  a = datarray("a", x, ["x".dim.m, "y".dim.n], deep=.false.)
  b = datarray("b", y, ["x".dim.m, "y".dim.n], deep=.false.)
  c = datarray("c", z, ["x".dim.m, "y".dim.n], deep=.false.)
  expr = a*(b+c)
  do pass = 1, 2
    call evaluate(expr, result, err)
    call check(error, err%code == NC_NOERR, "Matrix evaluation failed")
    if (allocated(error)) return
    call extract(result, values)
    call check(error, all(abs(values - x*(y+z)) < 1.0e-12_real64), &
      & "Expression views lost matrix order or live values")
    if (allocated(error)) return
    y = y + 1.0_real64
  end do
  a = a*(b+c)
  call extract(a, values)
  call check(error, all(abs(values - x*(y+z)) < 1.0e-12_real64), &
    & "Borrowed destination alias changed source values prematurely")
end subroutine test_fused_matrix

subroutine test_blocked_scratch(error)
  !! Cross block/lane boundaries with two and three simultaneously live buffers.
  type(error_type), allocatable, intent(out) :: error
  integer, parameter :: n = 65553
  type(variable_type), target :: a, b, c, d, e, f, g, h, result
  type(expression_type) :: left, right
  real(real64) :: x(n), expected_left(n), expected_right(n)
  real(real64), pointer :: values(:)
  integer :: i, pass

  x = [(1.0_real64 + real(mod(i, 19), real64)/100, i=1,n)]
  a = datarray("a", x, ["x".dim.n])
  b = datarray("b", x+0.1_real64, ["x".dim.n])
  c = datarray("c", x+0.2_real64, ["x".dim.n])
  d = datarray("d", x+0.3_real64, ["x".dim.n])
  e = datarray("e", x+0.4_real64, ["x".dim.n])
  f = datarray("f", x+0.5_real64, ["x".dim.n])
  g = datarray("g", x+0.6_real64, ["x".dim.n])
  h = datarray("h", x+0.7_real64, ["x".dim.n])
  left = (a+b)*(c+d) + (e+f)*(g+h)
  right = (a+c)*(b+d) + (e+g)*(f+h)
  expected_left = (x+(x+0.1_real64))*((x+0.2_real64)+(x+0.3_real64)) + &
    & ((x+0.4_real64)+(x+0.5_real64))*((x+0.6_real64)+(x+0.7_real64))
  expected_right = (x+(x+0.2_real64))*((x+0.1_real64)+(x+0.3_real64)) + &
    & ((x+0.4_real64)+(x+0.6_real64))*((x+0.5_real64)+(x+0.7_real64))
  do pass = 1, 2
    result = left - right
    call extract(result, values)
    call check(error, all(abs(values-(expected_left-expected_right)) < &
      & 1.0e-10_real64), "Balanced tree lost a live scratch buffer")
    if (allocated(error)) return
    result = (a+b)/right
    call extract(result, values)
    call check(error, all(abs(values-(x+(x+0.1_real64))/expected_right) < &
      & 1.0e-12_real64), "Right-first division reversed its operands")
    if (allocated(error)) return
    result = left/(a+b)
    call extract(result, values)
    call check(error, all(abs(values-expected_left/(x+(x+0.1_real64))) < &
      & 1.0e-10_real64), "Left-first division reversed its operands")
    if (allocated(error)) return
  end do
end subroutine test_blocked_scratch

subroutine test_empty_expression(error)
  type(error_type), allocatable, intent(out) :: error
  type(variable_type), target :: a, b
  type(variable_type) :: result
  type(error_type_model) :: err
  real(real64) :: empty(0,3)

  a = datarray("a", empty, ["x".dim.0, "y".dim.3])
  b = datarray("b", empty, ["x".dim.0, "y".dim.3])
  call evaluate(a*b, result, err)
  call check(error, err%code == NC_NOERR .and. result%len == 0, &
    & "Empty expression attempted to map a leaf")
  if (allocated(error)) return
  call check(error, allocated(result%buffer), "Empty output is not owned")
end subroutine test_empty_expression

end submodule nc4f_test_data_expression
