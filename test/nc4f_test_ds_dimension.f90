module nc4f_test_ds_dimension
use, intrinsic :: iso_fortran_env, only: int64
use, non_intrinsic :: testdrive, only: check, error_type, new_unittest, &
  & unittest_type
use, non_intrinsic :: nc4f, only: dimension_type, error_type_model => &
  & error_type, variable_type, group_type, NC_NOERR, &
  & rename_dimension, nameof, operator(.dim.), operator(.and.), &
  & operator(==), operator(/=)
implicit none (type, external)
private
public :: collect_ds_dimension

contains

subroutine collect_ds_dimension(tests)
  type(unittest_type), allocatable, intent(out) :: tests(:)

  tests = [ &
    & new_unittest("dimension constructors", test_constructors), &
    & new_unittest("dimension equality", test_equality), &
    & new_unittest("rename_dimension overloads", test_rename) &
    & ]
end subroutine collect_ds_dimension

subroutine test_constructors(error)
  type(error_type), allocatable, intent(out) :: error
  type(dimension_type) :: dim

  dim = "x" .dim. 3
  call check(error, nameof(dim) == "x" .and. dim%len == 3_int64, &
    & "Integer dimension constructor failed")
  if (allocated(error)) return
  dim = "record" .dim. (0_int64 .and. .true.)
  call check(error, dim%is_unlim .and. dim%len == 0_int64, &
    & "Unlimited dimension constructor failed")
end subroutine test_constructors

subroutine test_equality(error)
  type(error_type), allocatable, intent(out) :: error
  type(dimension_type) :: left, right

  left = "x" .dim. 3
  right = "x" .dim. 3
  call check(error, left == right, "Equal dimensions compare unequal")
  if (allocated(error)) return
  right = "x" .dim. 4
  call check(error, left /= right, "Different dimensions compare equal")
end subroutine test_equality

subroutine test_rename(error)
  type(error_type), allocatable, intent(out) :: error
  type(dimension_type) :: dim
  type(variable_type) :: var
  type(group_type) :: grp
  type(error_type_model) :: err

  dim = "old" .dim. 3
  call rename_dimension(dim, "new", err)
  call check(error, err%code == NC_NOERR .and. nameof(dim) == "new", &
    & "Dimension rename failed")
  if (allocated(error)) return
  allocate (var%dims(1))
  var%dims(1) = dim
  call rename_dimension(var, "new", "axis", err)
  call check(error, err%code == NC_NOERR .and. &
    & nameof(var%dims(1)) == "axis", "Variable axis rename failed")
  if (allocated(error)) return
  allocate (grp%dims(1), grp%vars(1))
  grp%dims(1) = dim
  grp%vars(1) = var
  call rename_dimension(grp, "new", "other", err)
  call check(error, err%code == NC_NOERR .and. &
    & nameof(grp%dims(1)) == "other", "Group dimension rename failed")
end subroutine test_rename

end module nc4f_test_ds_dimension
