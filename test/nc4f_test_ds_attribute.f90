submodule(nc4f_test_ds) nc4f_test_ds_attribute
use, non_intrinsic :: testdrive, only: check, error_type, new_unittest, &
  & unittest_type
use, non_intrinsic :: nc4f, only: attribute_type, variable_type, &
  & group_type, model_error_type => error_type, delete_attribute, &
  & rename_attribute, nameof, operator(.att.), operator(==), &
  & operator(/=), NC_NOERR, NC_ENOTATT
implicit none (type, external)

contains

module subroutine collect_ds_attribute(tests)
  type(unittest_type), allocatable, intent(out) :: tests(:)

  tests = [ &
    & new_unittest("attribute equality", test_equality), &
    & new_unittest("rename_attribute overloads", test_rename), &
    & new_unittest("delete_attribute overloads", test_delete) &
    & ]
end subroutine collect_ds_attribute

subroutine test_equality(error)
  type(error_type), allocatable, intent(out) :: error
  type(attribute_type) :: left, right

  left = "units" .att. "K"
  right = "units" .att. "K"
  call check(error, left == right, "Equal attributes compare unequal")
  if (allocated(error)) return
  right = "units" .att. "m"
  call check(error, left /= right, "Different values compare equal")
end subroutine test_equality

subroutine test_rename(error)
  type(error_type), allocatable, intent(out) :: error
  type(attribute_type) :: att
  type(variable_type) :: var
  type(group_type) :: grp
  type(model_error_type) :: err

  att = "old" .att. "x"
  call rename_attribute(att, "new", err)
  call check(error, err%code == NC_NOERR .and. &
    & nameof(att) == "new", "Standalone attribute rename failed")
  if (allocated(error)) return
  var%atts = [att]
  call rename_attribute(var, "new", "axis", err)
  call check(error, err%code == NC_NOERR .and. &
    & nameof(var%atts(1)) == "axis", "Variable attribute rename failed")
  if (allocated(error)) return
  grp%atts = [att]
  call rename_attribute(grp, "new", "global", err)
  call check(error, err%code == NC_NOERR .and. &
    & nameof(grp%atts(1)) == "global", "Group attribute rename failed")
end subroutine test_rename

subroutine test_delete(error)
  type(error_type), allocatable, intent(out) :: error
  type(variable_type) :: var
  type(group_type) :: grp
  type(model_error_type) :: err

  var%atts = ["units" .att. "K"]
  call delete_attribute(var, "units", err)
  call check(error, err%code == NC_NOERR .and. &
    & size(var%atts) == 0, "Variable attribute deletion failed")
  if (allocated(error)) return
  call delete_attribute(var, "units", err)
  call check(error, err%code == NC_ENOTATT, &
    & "Missing attribute did not report NC_ENOTATT")
  if (allocated(error)) return
  grp%atts = ["title" .att. "sample"]
  call delete_attribute(grp, "title", err)
  call check(error, err%code == NC_NOERR .and. &
    & size(grp%atts) == 0, "Group attribute deletion failed")
end subroutine test_delete

end submodule nc4f_test_ds_attribute
