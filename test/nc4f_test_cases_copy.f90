!> Tests for explicit deep and shallow construction semantics.
submodule(nc4f_test_cases) nc4f_test_cases_copy

use, intrinsic :: iso_c_binding, only: c_associated, c_loc
use, intrinsic :: iso_fortran_env, only: real32
implicit none (type, external)

contains

!> Execute `copy_semantics`.
module subroutine copy_semantics(passed)
  !> Whether the test case has passed.
  logical, intent(inout) :: passed
  type(attribute_type) :: copied_att, empty_att, owned_att, source_att
  type(group_type) :: borrowed_group, child, deep_group, empty_group, grandchild, &
    & shallow_group, unlimited_group
  type(group_type) :: child_grps(1), grandchild_grps(1)
  type(variable_type) :: borrowed_copy, deep_copy, deep_var, empty_shallow, &
    & noncontiguous_var, shallow_var, source_var, unlimited_var
  real(real32), target :: empty_values(0), raw_values(2), source_matrix(3, 3)
  real(real32), pointer :: att_values(:), borrowed_values(:), copied_att_values(:), &
    & deep_copy_values(:), deep_values(:), packed_values(:, :), shallow_values(:), &
    & source_values(:), unlimited_values(:)
  logical :: invalid_shallow_valid, scoped_owned_valid

  owned_att = "scale".att.[1.0_real32, 2.0_real32]
  copied_att = owned_att
  if (.not. allocated(owned_att%buffer) .or. associated(owned_att%ptr)) return
  if (.not. allocated(copied_att%buffer) .or. associated(copied_att%ptr)) return
  if (.not. is_contiguous(owned_att%buffer)) return
  call extract(owned_att, att_values)
  call extract(copied_att, copied_att_values)
  if (c_associated(c_loc(att_values(1)), c_loc(copied_att_values(1)))) return
  att_values(1) = 17.0_real32
  if (abs(copied_att_values(1) - 1.0_real32) > epsilon(1.0_real32)) return

  raw_values = [1.0_real32, 2.0_real32]
  deep_var = datarray("deep", raw_values, ["x".dim.2], deep=.true.)
  shallow_var = datarray("shallow", raw_values, ["x".dim.2], deep=.false.)
  deep_copy = deep_var
  block
    type(variable_type) :: temporary_borrow

    temporary_borrow = datarray("temporary-borrow", raw_values, ["x".dim.2], &
      & deep=.false.)
    borrowed_copy = temporary_borrow
  end block
  if (.not. allocated(deep_var%buffer) .or. associated(deep_var%ptr)) return
  if (.not. allocated(deep_copy%buffer) .or. associated(deep_copy%ptr)) return
  if (allocated(shallow_var%buffer) .or. .not. associated(shallow_var%ptr)) return
  if (allocated(borrowed_copy%buffer) .or. .not. associated(borrowed_copy%ptr)) return
  if (.not. is_contiguous(deep_var%buffer) .or. &
    & .not. is_contiguous(shallow_var%ptr)) return
  if (.not. c_associated(c_loc(shallow_var%ptr(1)), c_loc(raw_values(1)))) return
  if (.not. c_associated(c_loc(borrowed_copy%ptr(1)), c_loc(raw_values(1)))) return
  call extract(deep_var, deep_values)
  call extract(deep_copy, deep_copy_values)
  call extract(shallow_var, shallow_values)
  if (c_associated(c_loc(deep_values(1)), c_loc(raw_values(1)))) return
  if (c_associated(c_loc(deep_values(1)), c_loc(deep_copy_values(1)))) return
  raw_values(1) = 9.0_real32
  if (abs(deep_values(1) - 1.0_real32) > epsilon(1.0_real32) .or. &
    & abs(deep_copy_values(1) - 1.0_real32) > epsilon(1.0_real32) .or. &
    & abs(shallow_values(1) - 9.0_real32) > epsilon(1.0_real32)) return
  deep_values(1) = 17.0_real32
  if (abs(deep_values(1) - 17.0_real32) > epsilon(1.0_real32)) return
  if (abs(deep_copy_values(1) - 1.0_real32) > epsilon(1.0_real32)) return

  source_matrix = reshape([1.0_real32, 2.0_real32, 3.0_real32, 4.0_real32, &
    & 5.0_real32, 6.0_real32, 7.0_real32, 8.0_real32, 9.0_real32], [3, 3])
  if (is_contiguous(source_matrix(1:2, 2:3))) return
  noncontiguous_var = datarray("packed-section", source_matrix(1:2, 2:3), &
    & ["x".dim.2, "y".dim.2])
  if (.not. allocated(noncontiguous_var%buffer) .or. &
    & associated(noncontiguous_var%ptr)) return
  call extract(noncontiguous_var, packed_values)
  if (any(abs(packed_values - reshape([4.0_real32, 5.0_real32, 7.0_real32, &
    & 8.0_real32], [2, 2])) > epsilon(1.0_real32))) return
  source_matrix(1, 2) = 99.0_real32
  if (abs(packed_values(1, 1) - 4.0_real32) > epsilon(1.0_real32)) return

  empty_shallow = datarray("empty", empty_values, ["x".dim.0], deep=.false.)
  if (allocated(empty_shallow%buffer) .or. associated(empty_shallow%ptr)) return
  empty_att = "empty".att.empty_values
  empty_group = dataset("empty", atts=[empty_att], deep=.true.)
  if (.not. allocated(empty_att%buffer) .or. associated(empty_att%ptr)) return
  if (size(empty_att%buffer) /= 0) return
  if (.not. allocated(empty_group%atts(1)%buffer) .or. &
    & associated(empty_group%atts(1)%ptr)) return
  if (size(empty_group%atts(1)%buffer) /= 0) return

  unlimited_var = datarray("series", raw_values, ["time".dim.(2 .and. .true.)])
  unlimited_group = dataset("unlimited", [unlimited_var], deep=.true.)
  if (.not. unlimited_group%vars(1)%dims(1)%is_unlim) return
  if (.not. unlimited_group%dims(1)%is_unlim) return
  call extract(unlimited_group%vars(1), unlimited_values)
  if (any(abs(unlimited_values - raw_values) > epsilon(1.0_real32))) return

  call check_scoped_owned_value(scoped_owned_valid)
  if (.not. scoped_owned_valid) return
  call check_invalid_shallow_inputs(invalid_shallow_valid)
  if (.not. invalid_shallow_valid) return

  source_var = datarray("source", raw_values, ["x".dim.2])
  source_att = "units".att.[1.0_real32]
  grandchild = dataset("grandchild", [source_var])
  grandchild_grps(1) = grandchild
  child = dataset("child", grps=grandchild_grps)
  child_grps(1) = child
  shallow_group = dataset("root", [source_var], child_grps, atts=[source_att])
  deep_group = dataset("root", [source_var], child_grps, atts=[source_att], deep=.true.)
  borrowed_group = dataset("borrowed", [shallow_var])
  if (.not. allocated(shallow_group%vars(1)%buffer) .or. &
    & associated(shallow_group%vars(1)%ptr)) return
  if (.not. allocated(deep_group%vars(1)%buffer) .or. &
    & associated(deep_group%vars(1)%ptr)) return
  if (allocated(borrowed_group%vars(1)%buffer) .or. &
    & .not. associated(borrowed_group%vars(1)%ptr)) return
  if (.not. c_associated(c_loc(borrowed_group%vars(1)%ptr(1)), &
    & c_loc(raw_values(1)))) return
  call extract(source_var, source_values)
  source_values(2) = 17.0_real32
  call extract(shallow_group%vars(1), shallow_values)
  call extract(deep_group%vars(1), deep_values)
  if (c_associated(c_loc(shallow_values(1)), c_loc(source_values(1)))) return
  if (c_associated(c_loc(deep_values(1)), c_loc(source_values(1)))) return
  raw_values(2) = 23.0_real32
  call extract(borrowed_group%vars(1), borrowed_values)
  if (abs(borrowed_values(2) - 23.0_real32) > epsilon(1.0_real32)) return
  call extract(source_att, att_values)
  call extract(deep_group%atts(1), copied_att_values)
  att_values(1) = 99.0_real32
  if (abs(copied_att_values(1) - 1.0_real32) > epsilon(1.0_real32)) return
  call extract(child%grps(1)%vars(1), source_values)
  source_values(1) = 31.0_real32
  call extract(shallow_group%grps(1)%grps(1)%vars(1), shallow_values)
  call extract(deep_group%grps(1)%grps(1)%vars(1), deep_values)

  passed = abs(shallow_values(2) - 2.0_real32) <= epsilon(1.0_real32) .and. &
    & abs(deep_values(2) - 2.0_real32) <= epsilon(1.0_real32) .and. &
    & abs(shallow_values(1) - 31.0_real32) <= epsilon(1.0_real32) .and. &
    & abs(deep_values(1) - 9.0_real32) <= epsilon(1.0_real32) .and. &
    & associated(shallow_group%grps(1)%grps, child%grps) .and. &
    & .not. associated(deep_group%grps(1)%grps, child%grps)

contains

  !> Exercise a deep value after the constructor's source has left scope.
  subroutine check_scoped_owned_value(valid)
    !> Data or metadata used by this operation.
    logical, intent(out) :: valid
    type(variable_type) :: scoped_var
    real(real32), pointer :: scoped_values(:)

    scoped_var = new_scoped_owned_var()
    valid = allocated(scoped_var%buffer) .and. .not. associated(scoped_var%ptr)
    if (.not. valid) return
    call extract(scoped_var, scoped_values)
    valid = all(abs(scoped_values - [5.0_real32, 6.0_real32]) <= &
      & epsilon(1.0_real32))
  end subroutine check_scoped_owned_value

  !> Build an owned variable from local storage which ceases to exist on return.
  function new_scoped_owned_var() result(var)
    !> Retrieved or constructed variable.
    type(variable_type) :: var
    real(real32), target :: local_values(2)

    local_values = [5.0_real32, 6.0_real32]
    var = datarray("scoped", local_values, ["x".dim.2], deep=.true.)
  end function new_scoped_owned_var

  !> Confirm that invalid shallow constructors terminate in child processes.
  subroutine check_invalid_shallow_inputs(valid)
    !> Whether both invalid shallow-construction probes terminated as expected.
    logical, intent(out) :: valid
    character(len=1024) :: executable
    integer :: char_status, command_status, noncontiguous_status

    valid = .false.
    call get_command_argument(0, executable)
    if (len_trim(executable) == 0) return
    call execute_command_line(trim(executable)// &
      & " --ownership-invalid-noncontiguous >/dev/null 2>&1", &
      & exitstat=noncontiguous_status, cmdstat=command_status)
    if (command_status /= 0 .or. noncontiguous_status == 0) return
    call execute_command_line(trim(executable)// &
      & " --ownership-invalid-character >/dev/null 2>&1", &
      & exitstat=char_status, cmdstat=command_status)
    valid = command_status == 0 .and. char_status /= 0
  end subroutine check_invalid_shallow_inputs
end subroutine copy_semantics

end submodule nc4f_test_cases_copy
