!> Tests for explicit deep and shallow construction semantics.
submodule(nc4f_test_cases) nc4f_test_cases_copy

use, intrinsic :: iso_c_binding, only: c_associated, c_loc
use, intrinsic :: iso_fortran_env, only: real32
implicit none (type, external)

contains

!> Execute `copy_semantics`.
module subroutine copy_semantics(passed)
  !> Input/output argument: `passed`.
  logical, intent(inout) :: passed
  type(group_type) :: child, deep_group, grandchild, shallow_group
  type(group_type) :: child_grps(1), grandchild_grps(1)
  type(variable_type) :: deep_var, shallow_var, source_var
  real(real32), target :: raw_values(2)
  real(real32), pointer :: deep_values(:), shallow_values(:), source_values(:)

  raw_values = [1.0_real32, 2.0_real32]
  deep_var = datarray("deep", raw_values, ["x".dim.2], deep=.true.)
  shallow_var = datarray("shallow", raw_values, ["x".dim.2], deep=.false.)
  raw_values(1) = 9.0_real32
  call extract(deep_var, deep_values)
  call extract(shallow_var, shallow_values)
  if (c_associated(c_loc(deep_var%buffer(1)), c_loc(raw_values(1)))) return
  if (.not. c_associated(c_loc(shallow_var%buffer(1)), c_loc(raw_values(1)))) return
  if (abs(deep_values(1) - 1.0_real32) > epsilon(1.0_real32) .or. &
    & abs(shallow_values(1) - 9.0_real32) > epsilon(1.0_real32)) return

  source_var = datarray("source", raw_values, ["x".dim.2])
  grandchild = dataset("grandchild", [source_var])
  grandchild_grps(1) = grandchild
  child = dataset("child", grps=grandchild_grps)
  child_grps(1) = child
  shallow_group = dataset("root", [source_var], child_grps)
  deep_group = dataset("root", [source_var], child_grps, deep=.true.)
  call extract(source_var, source_values)
  source_values(2) = 17.0_real32
  call extract(shallow_group%vars(1), shallow_values)
  call extract(deep_group%vars(1), deep_values)

  passed = c_associated(c_loc(shallow_group%vars(1)%buffer(1)), c_loc(source_var%buffer(1))) .and. &
    & .not. c_associated(c_loc(deep_group%vars(1)%buffer(1)), c_loc(source_var%buffer(1))) .and. &
    & abs(shallow_values(2) - 17.0_real32) <= epsilon(1.0_real32) .and. &
    & abs(deep_values(2) - 2.0_real32) <= epsilon(1.0_real32) .and. &
    & associated(shallow_group%grps(1)%grps, child%grps) .and. &
    & .not. associated(deep_group%grps(1)%grps, child%grps)
end subroutine copy_semantics

end submodule nc4f_test_cases_copy
