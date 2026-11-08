submodule(nc4f_test_data) nc4f_test_data_variable_constructor
use, intrinsic :: iso_fortran_env, only: int8, int16, int32, int64, &
  & real32, real64
use, non_intrinsic :: testdrive, only: check, error_type, new_unittest, &
  & unittest_type
use, non_intrinsic :: nc4f, only: datarray, dimension_type, &
  & variable_type, nameof, typeof, operator(.dim.), NC_BYTE, &
  & NC_SHORT, NC_INT, NC_INT64, NC_FLOAT, NC_DOUBLE
implicit none (type, external)

contains

module subroutine collect_data_variable_constructor(tests)
  type(unittest_type), allocatable, intent(out) :: tests(:)

  tests = [ &
    & new_unittest("numeric datarray kinds", test_kinds), &
    & new_unittest("datarray rank and ownership", test_ownership) &
    & ]
end subroutine collect_data_variable_constructor

subroutine test_kinds(error)
  type(error_type), allocatable, intent(out) :: error
  type(variable_type) :: vars(6)
  type(dimension_type) :: dims(1)

  dims = ["x" .dim. 2]
  vars(1) = datarray("i8", [1_int8, 2_int8], dims)
  vars(2) = datarray("i16", [1_int16, 2_int16], dims)
  vars(3) = datarray("i32", [1_int32, 2_int32], dims)
  vars(4) = datarray("i64", [1_int64, 2_int64], dims)
  vars(5) = datarray("f32", [1.0_real32, 2.0_real32], dims)
  vars(6) = datarray("f64", [1.0_real64, 2.0_real64], dims)
  call check(error, all(typeof(vars) == [NC_BYTE, NC_SHORT, NC_INT, &
    & NC_INT64, NC_FLOAT, NC_DOUBLE]), &
    & "Numeric datarray types differ")
  if (allocated(error)) return
  call check(error, nameof(vars(5)) == "f32" .and. &
    & all(vars%len == 2_int64), "Numeric datarray metadata differs")
end subroutine test_kinds

subroutine test_ownership(error)
  type(error_type), allocatable, intent(out) :: error
  type(variable_type) :: owned, borrowed
  real(real32), target :: values(2, 2)

  values = reshape([1.0_real32, 2.0_real32, &
    & 3.0_real32, 4.0_real32], [2, 2])
  owned = datarray("owned", values, &
    & ["x" .dim. 2, "y" .dim. 2])
  borrowed = datarray("borrowed", values, &
    & ["x" .dim. 2, "y" .dim. 2], deep=.false.)
  call check(error, allocated(owned%buffer) .and. &
    & .not. associated(owned%ptr), "Deep datarray did not own storage")
  if (allocated(error)) return
  call check(error, associated(borrowed%ptr) .and. &
    & .not. allocated(borrowed%buffer), &
    & "Shallow datarray did not borrow storage")
end subroutine test_ownership

end submodule nc4f_test_data_variable_constructor
