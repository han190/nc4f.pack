submodule(nc4f_test_data) nc4f_test_data_unary_intrinsic
use, intrinsic :: iso_fortran_env, only: &
  & int8, int16, int32, int64, real32, real64
use, non_intrinsic :: testdrive, only: &
  & check, error_type, new_unittest, unittest_type
use, non_intrinsic :: nc4f, only: &
  & datarray, evaluate, expression_type, extract, variable_type, &
  & error_type_model => error_type, operator(+), operator(*), &
  & assignment(=), &
  & operator(.dim.), NC_NOERR, NC_EINVAL, &
  & abs, sqrt, exp, log, log10, sin, &
  & cos, tan, asin, acos, atan, sinh, &
  & cosh, tanh, asinh, acosh, atanh, erf, &
  & erfc, erfc_scaled, gamma, log_gamma, bessel_j0, bessel_j1, &
  & bessel_y0, bessel_y1
implicit none (type, external)
contains

module subroutine collect_data_unary_intrinsic(tests)
  type(unittest_type), allocatable, intent(out) :: tests(:)

  tests = [ &
    & new_unittest("real32 intrinsics", test_real32_intrinsics), &
    & new_unittest("real64 intrinsics", test_real64_intrinsics), &
    & new_unittest("integer absolute value", test_integer_abs), &
    & new_unittest("nested unary", test_nested_unary), &
    & new_unittest("unary invalid kinds", test_invalid_kind), &
    & new_unittest("unary domains", test_domains)]
end subroutine collect_data_unary_intrinsic

subroutine test_real32_intrinsics(error)
  type(error_type), allocatable, intent(out) :: error
  type(variable_type), target :: a, positive
  real(real32) :: x(2), x_positive(2)

  x = [0.25_real32, 0.5_real32]
  x_positive = [1.25_real32, 2.0_real32]
  a = datarray("a", x, ["x" .dim. 2], deep=.true.)
  positive = datarray("positive", x_positive, &
    & ["x" .dim. 2], deep=.true.)
  call check_real32_unary(abs(a), abs(x), &
    & "abs variable", error)
  if (allocated(error)) return
  call check_real32_unary(abs(a + 0.0_real32), &
    & abs(x), "abs expression", error)
  if (allocated(error)) return
  call check_real32_unary(sqrt(a), sqrt(x), &
    & "sqrt variable", error)
  if (allocated(error)) return
  call check_real32_unary(sqrt(a + 0.0_real32), &
    & sqrt(x), "sqrt expression", error)
  if (allocated(error)) return
  call check_real32_unary(exp(a), exp(x), &
    & "exp variable", error)
  if (allocated(error)) return
  call check_real32_unary(exp(a + 0.0_real32), &
    & exp(x), "exp expression", error)
  if (allocated(error)) return
  call check_real32_unary(log(a), log(x), &
    & "log variable", error)
  if (allocated(error)) return
  call check_real32_unary(log(a + 0.0_real32), &
    & log(x), "log expression", error)
  if (allocated(error)) return
  call check_real32_unary(log10(a), log10(x), &
    & "log10 variable", error)
  if (allocated(error)) return
  call check_real32_unary(log10(a + 0.0_real32), &
    & log10(x), "log10 expression", error)
  if (allocated(error)) return
  call check_real32_unary(sin(a), sin(x), &
    & "sin variable", error)
  if (allocated(error)) return
  call check_real32_unary(sin(a + 0.0_real32), &
    & sin(x), "sin expression", error)
  if (allocated(error)) return
  call check_real32_unary(cos(a), cos(x), &
    & "cos variable", error)
  if (allocated(error)) return
  call check_real32_unary(cos(a + 0.0_real32), &
    & cos(x), "cos expression", error)
  if (allocated(error)) return
  call check_real32_unary(tan(a), tan(x), &
    & "tan variable", error)
  if (allocated(error)) return
  call check_real32_unary(tan(a + 0.0_real32), &
    & tan(x), "tan expression", error)
  if (allocated(error)) return
  call check_real32_unary(asin(a), asin(x), &
    & "asin variable", error)
  if (allocated(error)) return
  call check_real32_unary(asin(a + 0.0_real32), &
    & asin(x), "asin expression", error)
  if (allocated(error)) return
  call check_real32_unary(acos(a), acos(x), &
    & "acos variable", error)
  if (allocated(error)) return
  call check_real32_unary(acos(a + 0.0_real32), &
    & acos(x), "acos expression", error)
  if (allocated(error)) return
  call check_real32_unary(atan(a), atan(x), &
    & "atan variable", error)
  if (allocated(error)) return
  call check_real32_unary(atan(a + 0.0_real32), &
    & atan(x), "atan expression", error)
  if (allocated(error)) return
  call check_real32_unary(sinh(a), sinh(x), &
    & "sinh variable", error)
  if (allocated(error)) return
  call check_real32_unary(sinh(a + 0.0_real32), &
    & sinh(x), "sinh expression", error)
  if (allocated(error)) return
  call check_real32_unary(cosh(a), cosh(x), &
    & "cosh variable", error)
  if (allocated(error)) return
  call check_real32_unary(cosh(a + 0.0_real32), &
    & cosh(x), "cosh expression", error)
  if (allocated(error)) return
  call check_real32_unary(tanh(a), tanh(x), &
    & "tanh variable", error)
  if (allocated(error)) return
  call check_real32_unary(tanh(a + 0.0_real32), &
    & tanh(x), "tanh expression", error)
  if (allocated(error)) return
  call check_real32_unary(asinh(a), asinh(x), &
    & "asinh variable", error)
  if (allocated(error)) return
  call check_real32_unary(asinh(a + 0.0_real32), &
    & asinh(x), "asinh expression", error)
  if (allocated(error)) return
  call check_real32_unary(acosh(positive), acosh(x_positive), &
    & "acosh variable", error)
  if (allocated(error)) return
  call check_real32_unary(acosh(positive + 0.0_real32), &
    & acosh(x_positive), "acosh expression", error)
  if (allocated(error)) return
  call check_real32_unary(atanh(a), atanh(x), &
    & "atanh variable", error)
  if (allocated(error)) return
  call check_real32_unary(atanh(a + 0.0_real32), &
    & atanh(x), "atanh expression", error)
  if (allocated(error)) return
  call check_real32_unary(erf(a), erf(x), &
    & "erf variable", error)
  if (allocated(error)) return
  call check_real32_unary(erf(a + 0.0_real32), &
    & erf(x), "erf expression", error)
  if (allocated(error)) return
  call check_real32_unary(erfc(a), erfc(x), &
    & "erfc variable", error)
  if (allocated(error)) return
  call check_real32_unary(erfc(a + 0.0_real32), &
    & erfc(x), "erfc expression", error)
  if (allocated(error)) return
  call check_real32_unary(erfc_scaled(a), erfc_scaled(x), &
    & "erfc_scaled variable", error)
  if (allocated(error)) return
  call check_real32_unary(erfc_scaled(a + 0.0_real32), &
    & erfc_scaled(x), "erfc_scaled expression", error)
  if (allocated(error)) return
  call check_real32_unary(gamma(a), gamma(x), &
    & "gamma variable", error)
  if (allocated(error)) return
  call check_real32_unary(gamma(a + 0.0_real32), &
    & gamma(x), "gamma expression", error)
  if (allocated(error)) return
  call check_real32_unary(log_gamma(a), log_gamma(x), &
    & "log_gamma variable", error)
  if (allocated(error)) return
  call check_real32_unary(log_gamma(a + 0.0_real32), &
    & log_gamma(x), "log_gamma expression", error)
  if (allocated(error)) return
  call check_real32_unary(bessel_j0(a), &
    & real(bessel_j0(real(x, real64)), real32), &
    & "bessel_j0 variable", error)
  if (allocated(error)) return
  call check_real32_unary(bessel_j0(a + 0.0_real32), &
    & real(bessel_j0(real(x, real64)), real32), &
    & "bessel_j0 expression", error)
  if (allocated(error)) return
  call check_real32_unary(bessel_j1(a), &
    & real(bessel_j1(real(x, real64)), real32), &
    & "bessel_j1 variable", error)
  if (allocated(error)) return
  call check_real32_unary(bessel_j1(a + 0.0_real32), &
    & real(bessel_j1(real(x, real64)), real32), &
    & "bessel_j1 expression", error)
  if (allocated(error)) return
  call check_real32_unary(bessel_y0(a), &
    & real(bessel_y0(real(x, real64)), real32), &
    & "bessel_y0 variable", error)
  if (allocated(error)) return
  call check_real32_unary(bessel_y0(a + 0.0_real32), &
    & real(bessel_y0(real(x, real64)), real32), &
    & "bessel_y0 expression", error)
  if (allocated(error)) return
  call check_real32_unary(bessel_y1(a), &
    & real(bessel_y1(real(x, real64)), real32), &
    & "bessel_y1 variable", error)
  if (allocated(error)) return
  call check_real32_unary(bessel_y1(a + 0.0_real32), &
    & real(bessel_y1(real(x, real64)), real32), &
    & "bessel_y1 expression", error)
  if (allocated(error)) return
end subroutine test_real32_intrinsics

subroutine check_real32_unary(expr, expected, label, error)
  type(expression_type), intent(in) :: expr
  real(real32), intent(in) :: expected(:)
  character(len=*), intent(in) :: label
  type(error_type), allocatable, intent(out) :: error
  type(variable_type), target :: result
  type(error_type_model) :: err
  real(real32), pointer :: values(:)

  call evaluate(expr, result, err)
  call check(error, err%code == NC_NOERR, label//" failed")
  if (allocated(error)) return
  call extract(result, values)
  call check(error, all(abs(values - expected) < &
    & 1.0e-5_real32), &
    & label//" values differ")
  if (allocated(error)) return
  call check(error, size(result%dims) == 1 .and. &
    & result%dims(1)%len == 2, label//" dimensions differ")
end subroutine check_real32_unary

subroutine test_real64_intrinsics(error)
  type(error_type), allocatable, intent(out) :: error
  type(variable_type), target :: a, positive
  real(real64) :: x(2), x_positive(2)

  x = [0.25_real64, 0.5_real64]
  x_positive = [1.25_real64, 2.0_real64]
  a = datarray("a", x, ["x" .dim. 2], deep=.true.)
  positive = datarray("positive", x_positive, &
    & ["x" .dim. 2], deep=.true.)
  call check_real64_unary(abs(a), abs(x), &
    & "abs variable", error)
  if (allocated(error)) return
  call check_real64_unary(abs(a + 0.0_real64), &
    & abs(x), "abs expression", error)
  if (allocated(error)) return
  call check_real64_unary(sqrt(a), sqrt(x), &
    & "sqrt variable", error)
  if (allocated(error)) return
  call check_real64_unary(sqrt(a + 0.0_real64), &
    & sqrt(x), "sqrt expression", error)
  if (allocated(error)) return
  call check_real64_unary(exp(a), exp(x), &
    & "exp variable", error)
  if (allocated(error)) return
  call check_real64_unary(exp(a + 0.0_real64), &
    & exp(x), "exp expression", error)
  if (allocated(error)) return
  call check_real64_unary(log(a), log(x), &
    & "log variable", error)
  if (allocated(error)) return
  call check_real64_unary(log(a + 0.0_real64), &
    & log(x), "log expression", error)
  if (allocated(error)) return
  call check_real64_unary(log10(a), log10(x), &
    & "log10 variable", error)
  if (allocated(error)) return
  call check_real64_unary(log10(a + 0.0_real64), &
    & log10(x), "log10 expression", error)
  if (allocated(error)) return
  call check_real64_unary(sin(a), sin(x), &
    & "sin variable", error)
  if (allocated(error)) return
  call check_real64_unary(sin(a + 0.0_real64), &
    & sin(x), "sin expression", error)
  if (allocated(error)) return
  call check_real64_unary(cos(a), cos(x), &
    & "cos variable", error)
  if (allocated(error)) return
  call check_real64_unary(cos(a + 0.0_real64), &
    & cos(x), "cos expression", error)
  if (allocated(error)) return
  call check_real64_unary(tan(a), tan(x), &
    & "tan variable", error)
  if (allocated(error)) return
  call check_real64_unary(tan(a + 0.0_real64), &
    & tan(x), "tan expression", error)
  if (allocated(error)) return
  call check_real64_unary(asin(a), asin(x), &
    & "asin variable", error)
  if (allocated(error)) return
  call check_real64_unary(asin(a + 0.0_real64), &
    & asin(x), "asin expression", error)
  if (allocated(error)) return
  call check_real64_unary(acos(a), acos(x), &
    & "acos variable", error)
  if (allocated(error)) return
  call check_real64_unary(acos(a + 0.0_real64), &
    & acos(x), "acos expression", error)
  if (allocated(error)) return
  call check_real64_unary(atan(a), atan(x), &
    & "atan variable", error)
  if (allocated(error)) return
  call check_real64_unary(atan(a + 0.0_real64), &
    & atan(x), "atan expression", error)
  if (allocated(error)) return
  call check_real64_unary(sinh(a), sinh(x), &
    & "sinh variable", error)
  if (allocated(error)) return
  call check_real64_unary(sinh(a + 0.0_real64), &
    & sinh(x), "sinh expression", error)
  if (allocated(error)) return
  call check_real64_unary(cosh(a), cosh(x), &
    & "cosh variable", error)
  if (allocated(error)) return
  call check_real64_unary(cosh(a + 0.0_real64), &
    & cosh(x), "cosh expression", error)
  if (allocated(error)) return
  call check_real64_unary(tanh(a), tanh(x), &
    & "tanh variable", error)
  if (allocated(error)) return
  call check_real64_unary(tanh(a + 0.0_real64), &
    & tanh(x), "tanh expression", error)
  if (allocated(error)) return
  call check_real64_unary(asinh(a), asinh(x), &
    & "asinh variable", error)
  if (allocated(error)) return
  call check_real64_unary(asinh(a + 0.0_real64), &
    & asinh(x), "asinh expression", error)
  if (allocated(error)) return
  call check_real64_unary(acosh(positive), acosh(x_positive), &
    & "acosh variable", error)
  if (allocated(error)) return
  call check_real64_unary(acosh(positive + 0.0_real64), &
    & acosh(x_positive), "acosh expression", error)
  if (allocated(error)) return
  call check_real64_unary(atanh(a), atanh(x), &
    & "atanh variable", error)
  if (allocated(error)) return
  call check_real64_unary(atanh(a + 0.0_real64), &
    & atanh(x), "atanh expression", error)
  if (allocated(error)) return
  call check_real64_unary(erf(a), erf(x), &
    & "erf variable", error)
  if (allocated(error)) return
  call check_real64_unary(erf(a + 0.0_real64), &
    & erf(x), "erf expression", error)
  if (allocated(error)) return
  call check_real64_unary(erfc(a), erfc(x), &
    & "erfc variable", error)
  if (allocated(error)) return
  call check_real64_unary(erfc(a + 0.0_real64), &
    & erfc(x), "erfc expression", error)
  if (allocated(error)) return
  call check_real64_unary(erfc_scaled(a), erfc_scaled(x), &
    & "erfc_scaled variable", error)
  if (allocated(error)) return
  call check_real64_unary(erfc_scaled(a + 0.0_real64), &
    & erfc_scaled(x), "erfc_scaled expression", error)
  if (allocated(error)) return
  call check_real64_unary(gamma(a), gamma(x), &
    & "gamma variable", error)
  if (allocated(error)) return
  call check_real64_unary(gamma(a + 0.0_real64), &
    & gamma(x), "gamma expression", error)
  if (allocated(error)) return
  call check_real64_unary(log_gamma(a), log_gamma(x), &
    & "log_gamma variable", error)
  if (allocated(error)) return
  call check_real64_unary(log_gamma(a + 0.0_real64), &
    & log_gamma(x), "log_gamma expression", error)
  if (allocated(error)) return
  call check_real64_unary(bessel_j0(a), bessel_j0(x), &
    & "bessel_j0 variable", error)
  if (allocated(error)) return
  call check_real64_unary(bessel_j0(a + 0.0_real64), &
    & bessel_j0(x), "bessel_j0 expression", error)
  if (allocated(error)) return
  call check_real64_unary(bessel_j1(a), bessel_j1(x), &
    & "bessel_j1 variable", error)
  if (allocated(error)) return
  call check_real64_unary(bessel_j1(a + 0.0_real64), &
    & bessel_j1(x), "bessel_j1 expression", error)
  if (allocated(error)) return
  call check_real64_unary(bessel_y0(a), bessel_y0(x), &
    & "bessel_y0 variable", error)
  if (allocated(error)) return
  call check_real64_unary(bessel_y0(a + 0.0_real64), &
    & bessel_y0(x), "bessel_y0 expression", error)
  if (allocated(error)) return
  call check_real64_unary(bessel_y1(a), bessel_y1(x), &
    & "bessel_y1 variable", error)
  if (allocated(error)) return
  call check_real64_unary(bessel_y1(a + 0.0_real64), &
    & bessel_y1(x), "bessel_y1 expression", error)
  if (allocated(error)) return
end subroutine test_real64_intrinsics

subroutine check_real64_unary(expr, expected, label, error)
  type(expression_type), intent(in) :: expr
  real(real64), intent(in) :: expected(:)
  character(len=*), intent(in) :: label
  type(error_type), allocatable, intent(out) :: error
  type(variable_type), target :: result
  type(error_type_model) :: err
  real(real64), pointer :: values(:)

  call evaluate(expr, result, err)
  call check(error, err%code == NC_NOERR, label//" failed")
  if (allocated(error)) return
  call extract(result, values)
  call check(error, all(abs(values - expected) < &
    & 1.0e-12_real64), &
    & label//" values differ")
  if (allocated(error)) return
  call check(error, size(result%dims) == 1 .and. &
    & result%dims(1)%len == 2, label//" dimensions differ")
end subroutine check_real64_unary

subroutine test_integer_abs(error)
  type(error_type), allocatable, intent(out) :: error
  type(variable_type), target :: a
  type(variable_type), target :: result
  type(error_type_model) :: err
  integer(int8), pointer :: values_int8(:)
  integer(int16), pointer :: values_int16(:)
  integer(int32), pointer :: values_int32(:)
  integer(int64), pointer :: values_int64(:)

  a = datarray("a", [-2_int8, 3_int8], &
    & ["x" .dim. 2], deep=.true.)
  call evaluate(abs(a), result, err)
  call check(error, err%code == NC_NOERR, "int8 abs failed")
  if (allocated(error)) return
  call extract(result, values_int8)
  call check(error, all(values_int8 == &
    & [2_int8, 3_int8]), "int8 abs differs")
  if (allocated(error)) return
  a = datarray("a", [-2_int16, 3_int16], &
    & ["x" .dim. 2], deep=.true.)
  call evaluate(abs(a), result, err)
  call check(error, err%code == NC_NOERR, "int16 abs failed")
  if (allocated(error)) return
  call extract(result, values_int16)
  call check(error, all(values_int16 == &
    & [2_int16, 3_int16]), "int16 abs differs")
  if (allocated(error)) return
  a = datarray("a", [-2_int32, 3_int32], &
    & ["x" .dim. 2], deep=.true.)
  call evaluate(abs(a), result, err)
  call check(error, err%code == NC_NOERR, "int32 abs failed")
  if (allocated(error)) return
  call extract(result, values_int32)
  call check(error, all(values_int32 == &
    & [2_int32, 3_int32]), "int32 abs differs")
  if (allocated(error)) return
  a = datarray("a", [-2_int64, 3_int64], &
    & ["x" .dim. 2], deep=.true.)
  call evaluate(abs(a), result, err)
  call check(error, err%code == NC_NOERR, "int64 abs failed")
  if (allocated(error)) return
  call extract(result, values_int64)
  call check(error, all(values_int64 == &
    & [2_int64, 3_int64]), "int64 abs differs")
  if (allocated(error)) return
  a = datarray("a", [-huge(0_int8) - 1_int8], &
    & ["x" .dim. 1], deep=.true.)
  call evaluate(abs(a), result, err)
  call check(error, err%code == NC_EINVAL, &
    & "Unrepresentable int8 absolute value was accepted")
end subroutine test_integer_abs

subroutine test_nested_unary(error)
  type(error_type), allocatable, intent(out) :: error
  type(variable_type), target :: a, result
  real(real32), pointer :: values(:)
  real(real32) :: x(2)

  x = [0.25_real32, 0.5_real32]
  a = datarray("a", x, ["x" .dim. 2], deep=.true.)
  result = 2.0_real32*cos(a + 0.5_real32)
  call extract(result, values)
  call check(error, all(abs(values - &
    & 2.0_real32*cos(x + 0.5_real32)) < 1.0e-5_real32), &
    & "Nested unary result differs")
end subroutine test_nested_unary

subroutine test_invalid_kind(error)
  type(error_type), allocatable, intent(out) :: error
  type(variable_type), target :: a, result
  type(error_type_model) :: err

  a = datarray("a", [1_int32, 2_int32], &
    & ["x" .dim. 2], deep=.true.)
  call evaluate(cos(a), result, err)
  call check(error, err%code == NC_EINVAL, &
    & "Cosine accepted integer data")
end subroutine test_invalid_kind

subroutine test_domains(error)
  type(error_type), allocatable, intent(out) :: error
  type(variable_type), target :: a, result
  type(error_type_model) :: err

  a = datarray("a", [-2.0_real32, 0.0_real32], &
    & ["x" .dim. 2], deep=.true.)
  call evaluate(sqrt(a), result, err)
  call check(error, err%code == NC_EINVAL, &
    & "sqrt accepted out-of-domain input")
  if (allocated(error)) return
  call evaluate(log(a), result, err)
  call check(error, err%code == NC_EINVAL, &
    & "log accepted out-of-domain input")
  if (allocated(error)) return
  call evaluate(log10(a), result, err)
  call check(error, err%code == NC_EINVAL, &
    & "log10 accepted out-of-domain input")
  if (allocated(error)) return
  call evaluate(asin(a), result, err)
  call check(error, err%code == NC_EINVAL, &
    & "asin accepted out-of-domain input")
  if (allocated(error)) return
  call evaluate(acos(a), result, err)
  call check(error, err%code == NC_EINVAL, &
    & "acos accepted out-of-domain input")
  if (allocated(error)) return
  call evaluate(acosh(a), result, err)
  call check(error, err%code == NC_EINVAL, &
    & "acosh accepted out-of-domain input")
  if (allocated(error)) return
  call evaluate(atanh(a), result, err)
  call check(error, err%code == NC_EINVAL, &
    & "atanh accepted out-of-domain input")
  if (allocated(error)) return
  call evaluate(gamma(a), result, err)
  call check(error, err%code == NC_EINVAL, &
    & "gamma accepted out-of-domain input")
  if (allocated(error)) return
  call evaluate(log_gamma(a), result, err)
  call check(error, err%code == NC_EINVAL, &
    & "log_gamma accepted out-of-domain input")
  if (allocated(error)) return
  call evaluate(bessel_y0(a), result, err)
  call check(error, err%code == NC_EINVAL, &
    & "bessel_y0 accepted out-of-domain input")
  if (allocated(error)) return
  call evaluate(bessel_y1(a), result, err)
  call check(error, err%code == NC_EINVAL, &
    & "bessel_y1 accepted out-of-domain input")
  if (allocated(error)) return
end subroutine test_domains

end submodule nc4f_test_data_unary_intrinsic
