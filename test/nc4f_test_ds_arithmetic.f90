module nc4f_test_ds_arithmetic
use, intrinsic :: iso_fortran_env, only: real32
use, non_intrinsic :: testdrive, only: check, error_type, new_unittest, &
  & unittest_type
use, non_intrinsic :: nc4f, only: variable_type, datarray, extract, &
  & operator(.dim.), sum
implicit none (type, external)
private
public :: collect_ds_arithmetic

contains

subroutine collect_ds_arithmetic(tests)
  type(unittest_type), allocatable, intent(out) :: tests(:)

  tests = [new_unittest("sum variables", test_sum)]
end subroutine collect_ds_arithmetic

subroutine test_sum(error)
  type(error_type), allocatable, intent(out) :: error
  type(variable_type) :: vars(2), total
  real(real32), pointer :: values(:)

  vars(1) = datarray("v", [1.0_real32, 2.0_real32], &
    & ["x" .dim. 2])
  vars(2) = datarray("v", [3.0_real32, 4.0_real32], &
    & ["x" .dim. 2])
  total = sum(vars)
  call extract(total, values)
  call check(error, associated(values), "Summed values are absent")
  if (allocated(error)) return
  call check(error, all(values == [4.0_real32, 6.0_real32]), &
    & "Variable sum differs")
end subroutine test_sum

end module nc4f_test_ds_arithmetic
