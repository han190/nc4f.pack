#ifdef __LFORTRAN__
#define NC4F_REFERENCE_ATAN atan2
#else
#define NC4F_REFERENCE_ATAN atan
#endif

submodule(nc4f_test_data) nc4f_test_data_intrinsic
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
  & bessel_y0, bessel_y1, dim, sign, mod, modulo, atan2, hypot
implicit none (type, external)
contains

module subroutine collect_data_intrinsic(tests)
  type(unittest_type), allocatable, intent(out) :: tests(:)

  tests = [ &
    & new_unittest("real32 intrinsics", test_real32_intrinsics), &
    & new_unittest("real64 intrinsics", test_real64_intrinsics), &
    & new_unittest("integer absolute value", test_integer_abs), &
    & new_unittest("nested unary", test_nested_unary), &
    & new_unittest("unary invalid kinds", test_invalid_kind), &
    & new_unittest("unary domains", test_domains), &
    & new_unittest("real binary intrinsics", test_real_binary), &
    & new_unittest("integer binary intrinsics", test_integer_binary), &
    & new_unittest("binary domains and dimensions", test_binary_errors)]
end subroutine collect_data_intrinsic

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

subroutine test_real_binary(error)
  !! Check both real kinds, nested expressions, and scalar operands.
  type(error_type), allocatable, intent(out) :: error
  type(variable_type), target :: xvar, yvar
  real(real32) :: x(2), y(2)
  real(real64) :: xd(2), yd(2)

  x = [-2.5_real32, 3.5_real32]
  y = [1.5_real32, -4.0_real32]
  xvar = datarray("x", x, ["site".dim.2])
  yvar = datarray("y", y, ["site".dim.2])
  call check_real32_unary(dim(xvar, yvar), dim(x, y), &
    & "dim real32", error)
  if (allocated(error)) return
  call check_real32_unary(sign(xvar + 0.0_real32, yvar), &
    & sign(x, y), "sign real32", error)
  if (allocated(error)) return
  call check_real32_unary(mod(xvar, yvar + 0.0_real32), &
    & mod(x, y), "mod real32", error)
  if (allocated(error)) return
  call check_real32_unary(modulo(xvar + 0.0_real32, &
    & yvar + 0.0_real32), modulo(x, y), "modulo real32", error)
  if (allocated(error)) return
  call check_real32_unary(atan2(yvar, xvar), atan2(y, x), &
    & "atan2 real32", error)
  if (allocated(error)) return
  call check_real32_unary(atan(yvar + 0.0_real32, xvar), &
    & NC4F_REFERENCE_ATAN(y, x), "atan two arguments", error)
  if (allocated(error)) return
  call check_real32_unary(hypot(xvar, yvar + 0.0_real32), &
    & hypot(x, y), "hypot real32", error)
  if (allocated(error)) return
  call check_real32_unary(dim(xvar, 1.0_real32), &
    & dim(x, 1.0_real32), "dim right scalar", error)
  if (allocated(error)) return
  call check_real32_unary(sign(-2.0_real32, yvar), &
    & sign(-2.0_real32, y), "sign left scalar", error)
  if (allocated(error)) return
  call check_real32_unary(mod(xvar, 2.0_real32), &
    & mod(x, 2.0_real32), "mod right scalar", error)
  if (allocated(error)) return
  call check_real32_unary(modulo(-3.0_real32, yvar), &
    & modulo(-3.0_real32, y), "modulo left scalar", error)
  if (allocated(error)) return
  call check_real32_unary(atan2(1.0_real32, xvar), &
    & atan2(1.0_real32, x), "atan2 left scalar", error)
  if (allocated(error)) return
  call check_real32_unary(atan(yvar, 2.0_real32), &
    & NC4F_REFERENCE_ATAN(y, 2.0_real32), &
    & "atan right scalar", error)
  if (allocated(error)) return
  call check_real32_unary(hypot(3.0_real32, yvar), &
    & hypot(3.0_real32, y), "hypot left scalar", error)
  if (allocated(error)) return

  xd = [-2.5_real64, 3.5_real64]
  yd = [1.5_real64, -4.0_real64]
  xvar = datarray("x", xd, ["site".dim.2])
  yvar = datarray("y", yd, ["site".dim.2])
  call check_real64_unary(dim(xvar, yvar), dim(xd, yd), &
    & "dim real64", error)
  if (allocated(error)) return
  call check_real64_unary(sign(xvar, yvar), sign(xd, yd), &
    & "sign real64", error)
  if (allocated(error)) return
  call check_real64_unary(mod(xvar, yvar), mod(xd, yd), &
    & "mod real64", error)
  if (allocated(error)) return
  call check_real64_unary(modulo(xvar, yvar), modulo(xd, yd), &
    & "modulo real64", error)
  if (allocated(error)) return
  call check_real64_unary(atan2(yvar, xvar), atan2(yd, xd), &
    & "atan2 real64", error)
  if (allocated(error)) return
  call check_real64_unary(atan(yvar, xvar), &
    & NC4F_REFERENCE_ATAN(yd, xd), &
    & "atan two arguments real64", error)
  if (allocated(error)) return
  call check_real64_unary(hypot(xvar, yvar), hypot(xd, yd), &
    & "hypot real64", error)
end subroutine test_real_binary

subroutine test_integer_binary(error)
  !! Check integer operations across all supported storage kinds.
  type(error_type), allocatable, intent(out) :: error
  type(variable_type), target :: a, b, result
  type(error_type_model) :: err
  integer(int8), pointer :: v8(:)
  integer(int16), pointer :: v16(:)
  integer(int32), pointer :: v32(:)
  integer(int64), pointer :: v64(:)

  a = datarray("a", [-5_int8, 7_int8], ["site".dim.2])
  b = datarray("b", [2_int8, -3_int8], ["site".dim.2])
  call evaluate(dim(a, b), result, err)
  call check(error, err%code == NC_NOERR, "int8 dim failed")
  if (allocated(error)) return
  call extract(result, v8)
  call check(error, all(v8 == [0_int8, 10_int8]), &
    & "int8 dim differs")
  if (allocated(error)) return

  a = datarray("a", [-5_int16, 7_int16], ["site".dim.2])
  call evaluate(sign(a, -2_int16), result, err)
  call check(error, err%code == NC_NOERR, "int16 sign failed")
  if (allocated(error)) return
  call extract(result, v16)
  call check(error, all(v16 == [-5_int16, -7_int16]), &
    & "int16 sign differs")
  if (allocated(error)) return

  a = datarray("a", [-5_int32, 7_int32], ["site".dim.2])
  b = datarray("b", [2_int32, -3_int32], ["site".dim.2])
  call evaluate(mod(a, b), result, err)
  call check(error, err%code == NC_NOERR, "int32 mod failed")
  if (allocated(error)) return
  call extract(result, v32)
  call check(error, all(v32 == mod([-5_int32, 7_int32], &
    & [2_int32, -3_int32])), "int32 mod differs")
  if (allocated(error)) return
  call evaluate(modulo(a, b), result, err)
  call check(error, err%code == NC_NOERR, "int32 modulo failed")
  if (allocated(error)) return
  call extract(result, v32)
  call check(error, all(v32 == modulo([-5_int32, 7_int32], &
    & [2_int32, -3_int32])), "int32 modulo differs")
  if (allocated(error)) return

  a = datarray("a", [-5_int64, 7_int64], ["site".dim.2])
  call evaluate(modulo(a, 3_int64), result, err)
  call check(error, err%code == NC_NOERR, "int64 modulo failed")
  if (allocated(error)) return
  call extract(result, v64)
  call check(error, all(v64 == [1_int64, 1_int64]), &
    & "int64 modulo differs")
end subroutine test_integer_binary

subroutine test_binary_errors(error)
  !! Reject invalid kinds, unequal dimensions, and undefined input pairs.
  type(error_type), allocatable, intent(out) :: error
  type(variable_type), target :: a, b, result
  type(error_type_model) :: err

  a = datarray("a", [1.0_real32, 2.0_real32], ["x".dim.2])
  b = datarray("b", [0.0_real32, 1.0_real32], ["x".dim.2])
  call evaluate(mod(a, b), result, err)
  call check(error, err%code == NC_EINVAL, &
    & "mod accepted a zero divisor")
  if (allocated(error)) return
  call evaluate(modulo(a, b), result, err)
  call check(error, err%code == NC_EINVAL, &
    & "modulo accepted a zero divisor")
  if (allocated(error)) return
  call evaluate(atan2(b, b), result, err)
  call check(error, err%code == NC_EINVAL, &
    & "atan2 accepted a zero pair")
  if (allocated(error)) return
  b = datarray("b", [1.0_real32, 2.0_real32], ["y".dim.2])
  call evaluate(hypot(a, b), result, err)
  call check(error, err%code == NC_EINVAL, &
    & "hypot accepted different dimensions")
  if (allocated(error)) return
  call evaluate(dim(a, 1.0_real64), result, err)
  call check(error, err%code == NC_EINVAL, &
    & "dim accepted a different scalar kind")
  if (allocated(error)) return
  a = datarray("a", [1_int32, 2_int32], ["x".dim.2])
  call evaluate(hypot(a, a), result, err)
  call check(error, err%code == NC_EINVAL, &
    & "hypot accepted integer data")
end subroutine test_binary_errors

end submodule nc4f_test_data_intrinsic
