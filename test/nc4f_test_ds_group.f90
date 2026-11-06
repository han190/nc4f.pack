module nc4f_test_ds_group
use, intrinsic :: iso_fortran_env, only: int64, real32
use, non_intrinsic :: testdrive, only: check, error_type, new_unittest, &
  & unittest_type
use, non_intrinsic :: nc4f, only: attribute_type, group_type, &
  & variable_type, &
  & model_error_type => error_type, datarray, dataset, nameof, &
  & rename_group, initialize, operator(.att.), operator(.dim.), &
  & NC_CHAR, NC_FLOAT, NC_NOERR
implicit none (type, external)
private
public :: collect_ds_group

contains

subroutine collect_ds_group(tests)
  type(unittest_type), allocatable, intent(out) :: tests(:)

  tests = [ &
    & new_unittest("dataset overloads", test_dataset), &
    & new_unittest("initialize model objects", test_initialize), &
    & new_unittest("rename_group overloads", test_rename) &
    & ]
end subroutine collect_ds_group

subroutine test_dataset(error)
  type(error_type), allocatable, intent(out) :: error
  type(group_type) :: empty, with_vars, with_grps, all
  type(variable_type) :: var

  var = datarray("v", [1.0_real32], ["x" .dim. 1])
  empty = dataset("empty")
  with_vars = dataset("vars", [var])
  with_grps = dataset("groups", [empty])
  all = dataset("root", [var], [empty], ["title" .att. "sample"])
  call check(error, nameof(empty) == "empty" .and. &
    & size(with_vars%vars) == 1 .and. &
    & associated(with_grps%grps) .and. &
    & size(all%atts) == 1, "Dataset constructors differ")
end subroutine test_dataset

subroutine test_initialize(error)
  type(error_type), allocatable, intent(out) :: error
  type(attribute_type) :: att, att_copy
  type(variable_type) :: var, var_copy

  call initialize(att, "text", NC_CHAR, 2_int64)
  call initialize(att_copy, "copy", att)
  call check(error, allocated(att%buffer) .and. &
    & allocated(att_copy%buffer) .and. att_copy%len == 2_int64, &
    & "Attribute initialization failed")
  if (allocated(error)) return
  call initialize(var, "v", NC_FLOAT, 2_int64, ["x" .dim. 2])
  call initialize(var_copy, "v_copy", var)
  call check(error, allocated(var%buffer) .and. &
    & allocated(var_copy%buffer) .and. &
    & var_copy%len == 2_int64, "Variable initialization failed")
end subroutine test_initialize

subroutine test_rename(error)
  type(error_type), allocatable, intent(out) :: error
  type(group_type) :: child, parent
  type(model_error_type) :: err

  child = dataset("old")
  call rename_group(child, "new", err)
  call check(error, err%code == NC_NOERR .and. &
    & nameof(child) == "new", "Standalone group rename failed")
  if (allocated(error)) return
  parent = dataset("root", [child])
  call rename_group(parent, "new", "again", err)
  call check(error, err%code == NC_NOERR .and. &
    & nameof(parent%grps(1)) == "again", &
    & "Child group rename failed")
end subroutine test_rename

end module nc4f_test_ds_group
