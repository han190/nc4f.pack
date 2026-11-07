submodule(nc4f_test_ds) nc4f_test_ds_attribute_constructor
use, intrinsic :: iso_fortran_env, only: int8, int16, int32, int64, &
  & real32, real64
use, non_intrinsic :: testdrive, only: check, error_type, new_unittest, &
  & unittest_type
use, non_intrinsic :: nc4f, only: attribute_type, nameof, typeof, &
  & operator(.att.), NC_BYTE, NC_CHAR, NC_SHORT, NC_INT, NC_INT64, &
  & NC_FLOAT, NC_DOUBLE
implicit none (type, external)

contains

module subroutine collect_ds_attribute_constructor(tests)
  type(unittest_type), allocatable, intent(out) :: tests(:)

  tests = [ &
    & new_unittest("attribute scalar constructors", test_scalars), &
    & new_unittest("attribute vector constructors", test_vectors) &
    & ]
end subroutine collect_ds_attribute_constructor

subroutine test_scalars(error)
  type(error_type), allocatable, intent(out) :: error
  type(attribute_type) :: atts(7)

  atts(1) = "i8" .att. 1_int8
  atts(2) = "i16" .att. 2_int16
  atts(3) = "i32" .att. 3_int32
  atts(4) = "i64" .att. 4_int64
  atts(5) = "f32" .att. 5.0_real32
  atts(6) = "f64" .att. 6.0_real64
  atts(7) = "text" .att. "abc"
  call check(error, all(typeof(atts) == [NC_BYTE, NC_SHORT, NC_INT, &
    & NC_INT64, NC_FLOAT, NC_DOUBLE, NC_CHAR]), &
    & "Attribute scalar types differ")
  if (allocated(error)) return
  call check(error, nameof(atts(1)) == "i8" .and. &
    & atts(7)%len == 3_int64, "Attribute scalar metadata differs")
end subroutine test_scalars

subroutine test_vectors(error)
  type(error_type), allocatable, intent(out) :: error
  type(attribute_type) :: atts(6)

  atts(1) = "i8" .att. [1_int8, 2_int8]
  atts(2) = "i16" .att. [1_int16, 2_int16]
  atts(3) = "i32" .att. [1_int32, 2_int32]
  atts(4) = "i64" .att. [1_int64, 2_int64]
  atts(5) = "f32" .att. [1.0_real32, 2.0_real32]
  atts(6) = "f64" .att. [1.0_real64, 2.0_real64]
  call check(error, all(atts%len == 2_int64), &
    & "Attribute vector lengths differ")
  if (allocated(error)) return
  call check(error, all(typeof(atts) == [NC_BYTE, NC_SHORT, NC_INT, &
    & NC_INT64, NC_FLOAT, NC_DOUBLE]), &
    & "Attribute vector types differ")
end subroutine test_vectors

end submodule nc4f_test_ds_attribute_constructor
