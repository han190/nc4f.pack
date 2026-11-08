submodule(nc4f_test_data) nc4f_test_data_variable
use, intrinsic :: iso_fortran_env, only: int64, real32
use, non_intrinsic :: testdrive, only: check, error_type, new_unittest, &
  & unittest_type
use, non_intrinsic :: nc4f, only: variable_type, group_type, &
  & storage_type, model_error_type => error_type, datarray, &
  & rename_variable, set_storage, nameof, typeof, size, shape, &
  & operator(.dim.), operator(==), &
  & operator(/=), NC_EINVAL, NC_ENDIAN_LITTLE, NC_FLOAT, NC_NOERR
implicit none (type, external)

contains

module subroutine collect_data_variable(tests)
  type(unittest_type), allocatable, intent(out) :: tests(:)

  tests = [ &
    & new_unittest("variable metadata and equality", test_metadata), &
    & new_unittest("variable size and shape", test_shape), &
    & new_unittest("rename_variable overloads", test_rename), &
    & new_unittest("set_storage validation", test_storage) &
    & ]
end subroutine collect_data_variable

subroutine test_metadata(error)
  type(error_type), allocatable, intent(out) :: error
  type(variable_type) :: left, right

  left = datarray("a", [1.0_real32, 2.0_real32], ["x" .dim. 2])
  right = left
  call check(error, left == right .and. nameof(left) == "a" .and. &
    & typeof(left) == NC_FLOAT, "Variable metadata or equality differs")
  if (allocated(error)) return
  right%name = "b"
  call check(error, left /= right, "Different variables compare equal")
end subroutine test_metadata

subroutine test_shape(error)
  type(error_type), allocatable, intent(out) :: error
  type(variable_type) :: var
  integer(int64) :: count

  var = datarray("grid", reshape([1.0_real32, 2.0_real32, &
    & 3.0_real32, 4.0_real32, 5.0_real32, 6.0_real32], [2, 3]), &
    & ["x" .dim. 2, "y" .dim. 3])
  count = size(var)
  call check(error, count == 6_int64 .and. size(var, 2) == 2_int64 &
    & .and. all(shape(var) == [2, 3]), &
    & "Variable size or shape differs")
end subroutine test_shape

subroutine test_rename(error)
  type(error_type), allocatable, intent(out) :: error
  type(variable_type) :: var
  type(group_type) :: grp
  type(model_error_type) :: err

  var = datarray("old", [1.0_real32], ["x" .dim. 1])
  call rename_variable(var, "new", err)
  call check(error, err%code == NC_NOERR .and. &
    & nameof(var) == "new", "Standalone variable rename failed")
  if (allocated(error)) return
  grp%vars = [var]
  call rename_variable(grp, "new", "again", err)
  call check(error, err%code == NC_NOERR .and. &
    & nameof(grp%vars(1)) == "again", "Group variable rename failed")
end subroutine test_rename

subroutine test_storage(error)
  type(error_type), allocatable, intent(out) :: error
  type(variable_type) :: var
  type(model_error_type) :: err
  type(storage_type) :: settings

  var = datarray("v", [1.0_real32, 2.0_real32], ["x" .dim. 2])
  call set_storage(var, chunks=[2_int64], deflate_level=3, &
    & shuffle=.true., endian=NC_ENDIAN_LITTLE, err=err)
  call check(error, err%code == NC_NOERR .and. &
    & allocated(var%storage), "Valid storage settings failed")
  if (allocated(error)) return
  settings = var%storage
  call check(error, settings%deflate_level == 3, &
    & "Storage value copy differs")
  if (allocated(error)) return
  call check(error, var%storage%deflate_level == 3 .and. &
    & var%storage%shuffle == 1 .and. &
    & var%storage%endian == NC_ENDIAN_LITTLE, &
    & "Storage settings differ")
  if (allocated(error)) return
  call set_storage(var, chunks=[0_int64], err=err)
  call check(error, err%code == NC_EINVAL .and. &
    & all(var%storage%chunks == [2_int64]), &
    & "Invalid storage settings changed the variable")
end subroutine test_storage

end submodule nc4f_test_data_variable
