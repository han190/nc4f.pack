submodule(nc4f_test_ds) nc4f_test_ds_extract
use, intrinsic :: iso_fortran_env, only: int32, real32
use, non_intrinsic :: testdrive, only: check, error_type, new_unittest, &
  & unittest_type
use, non_intrinsic :: nc4f, only: attribute_type, variable_type, &
  & datarray, extract, operator(.att.), operator(.dim.)
implicit none (type, external)

contains

module subroutine collect_ds_extract(tests)
  type(unittest_type), allocatable, intent(out) :: tests(:)

  tests = [ &
    & new_unittest("extract attribute values", test_attribute), &
    & new_unittest("extract variable shape and values", test_variable) &
    & ]
end subroutine collect_ds_extract

subroutine test_attribute(error)
  type(error_type), allocatable, intent(out) :: error
  type(attribute_type) :: att
  integer(int32), pointer :: values(:)

  att = "levels" .att. [100_int32, 200_int32]
  call extract(att, values)
  call check(error, associated(values), "Attribute extraction failed")
  if (allocated(error)) return
  call check(error, all(values == [100_int32, 200_int32]), &
    & "Extracted attribute values differ")
end subroutine test_attribute

subroutine test_variable(error)
  type(error_type), allocatable, intent(out) :: error
  type(variable_type) :: var
  real(real32), pointer :: values(:, :)

  var = datarray("temperature", reshape([1.0_real32, 2.0_real32, &
    & 3.0_real32, 4.0_real32], [2, 2]), &
    & ["x" .dim. 2, "y" .dim. 2])
  call extract(var, values)
  call check(error, associated(values), "Variable extraction failed")
  if (allocated(error)) return
  call check(error, all(shape(values) == [2, 2]) .and. &
    & all(values == reshape([1.0_real32, 2.0_real32, &
    & 3.0_real32, 4.0_real32], [2, 2])), &
    & "Extracted variable values differ")
end subroutine test_variable

end submodule nc4f_test_ds_extract
