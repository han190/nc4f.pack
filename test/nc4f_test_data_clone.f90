submodule(nc4f_test_data) nc4f_test_data_clone
use, intrinsic :: iso_fortran_env, only: real32
use, non_intrinsic :: testdrive, only: check, error_type, new_unittest, &
  & unittest_type
use, non_intrinsic :: nc4f, only: group_type, variable_type, &
  & datarray, dataset, extract, operator(.dim.)
implicit none (type, external)

contains

module subroutine collect_data_clone(tests)
  type(unittest_type), allocatable, intent(out) :: tests(:)

  tests = [new_unittest("deep dataset clone", test_deep_clone)]
end subroutine collect_data_clone

subroutine test_deep_clone(error)
  type(error_type), allocatable, intent(out) :: error
  type(variable_type) :: borrowed
  type(group_type) :: copy
  real(real32), target :: source(2)
  real(real32), pointer :: values(:)

  source = [1.0_real32, 2.0_real32]
  borrowed = datarray("v", source, ["x" .dim. 2], &
    & deep=.false.)
  copy = dataset("root", [borrowed], deep=.true.)
  source(1) = 9.0_real32
  call extract(copy%vars(1), values)
  call check(error, associated(values), "Cloned data is absent")
  if (allocated(error)) return
  call check(error, all(values == [1.0_real32, 2.0_real32]) &
    & .and. allocated(copy%vars(1)%buffer), &
    & "Deep clone still aliases source data")
end subroutine test_deep_clone

end submodule nc4f_test_data_clone
