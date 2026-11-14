subroutine sum_vars_test(passed)
  !! Verify element-wise summation of compatible variable objects.
  logical, intent(inout) :: passed
  !! Whether the test case has passed.
  real(real64), parameter :: a(2, 3) = reshape([ &
    & 1.0_real64, 2.0_real64, 3.0_real64, 4.0_real64, &
    & 5.0_real64, 6.0_real64], [2, 3])
  real(real64), parameter :: b(2, 3) = reshape([ &
    & 10.0_real64, 20.0_real64, 30.0_real64, 40.0_real64, &
    & 50.0_real64, 60.0_real64], [2, 3])
  real(real64), parameter :: c(2, 3) = -a
  real(real64), pointer :: actual(:, :)
  type(variable_type) :: result, vars(3)

  vars(1) = datarray("a", a, ["x".dim.2, "y".dim.3])
  vars(2) = datarray("b", b, ["x".dim.2, "y".dim.3])
  vars(3) = datarray("c", c, ["x".dim.2, "y".dim.3])
  result = sum(vars)
  call extract(result, actual)

  passed = all(abs(actual - b) <= epsilon(b)) .and. &
    & all(result%dims == vars(1)%dims)
end subroutine sum_vars_test

