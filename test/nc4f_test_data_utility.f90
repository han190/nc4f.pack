submodule(nc4f_test_data) nc4f_test_data_utility
use, non_intrinsic :: testdrive, only: check, error_type, new_unittest, &
  & unittest_type
use, non_intrinsic :: nc4f, only: model_error_type => error_type, &
  & error_msg, operator(.exists.), NC_EBADID, NC_EBADDIM, &
  & NC_EBADGRPID, NC_EEDGE, NC_EBADTYPE, NC_EPERM, NC_EINVAL, &
  & NC_EINVALCOORDS, NC_ENOGRP, NC_ENOTATT, NC_ENOTFOUND, &
  & NC_ENOTVAR, NC_NOERR, NC_EBADNAME, NC_EMAXNAME, &
  & NC_ENAMEINUSE, NC_ENDIAN_NATIVE, NC_ENDIAN_LITTLE, &
  & NC_ENDIAN_BIG, NC_BYTE, NC_CHAR, NC_SHORT, NC_INT, &
  & NC_INT64, NC_FLOAT, NC_DOUBLE
implicit none (type, external)

contains

module subroutine collect_data_utility(tests)
  type(unittest_type), allocatable, intent(out) :: tests(:)

  tests = [ &
    & new_unittest("public status constants", test_status_constants), &
    & new_unittest("public type constants", test_type_constants), &
    & new_unittest("error_type and error_msg", test_error) &
    & ]
end subroutine collect_data_utility

subroutine test_status_constants(error)
  type(error_type), allocatable, intent(out) :: error
  integer :: errors(15)

  errors = [NC_EBADID, NC_EBADDIM, NC_EBADGRPID, NC_EEDGE, &
    & NC_EBADTYPE, NC_EPERM, NC_EINVAL, NC_EINVALCOORDS, &
    & NC_ENOGRP, NC_ENOTATT, NC_ENOTFOUND, NC_ENOTVAR, &
    & NC_EBADNAME, NC_EMAXNAME, NC_ENAMEINUSE]
  call check(error, NC_NOERR == 0 .and. all(errors /= NC_NOERR), &
    & "Public status constants are invalid")
end subroutine test_status_constants

subroutine test_type_constants(error)
  type(error_type), allocatable, intent(out) :: error
  integer :: types(7)

  types = [NC_BYTE, NC_CHAR, NC_SHORT, NC_INT, NC_INT64, &
    & NC_FLOAT, NC_DOUBLE]
  call check(error, all(types > 0) .and. &
    & NC_ENDIAN_NATIVE /= NC_ENDIAN_LITTLE .and. &
    & NC_ENDIAN_NATIVE /= NC_ENDIAN_BIG .and. &
    & NC_ENDIAN_LITTLE /= NC_ENDIAN_BIG, &
    & "Public data-type or endian constants are invalid")
end subroutine test_type_constants

subroutine test_error(error)
  type(error_type), allocatable, intent(out) :: error
  type(model_error_type) :: result

  result = model_error_type()
  call check(error, .not. (.exists. result) .and. &
    & error_msg(result) == "No error", "Success result differs")
  if (allocated(error)) return
  result = model_error_type(NC_EINVAL, "test", "bad input")
  call check(error, (.exists. result) .and. &
    & error_msg(result) == "[test] bad input", &
    & "Failure result differs")
end subroutine test_error

end submodule nc4f_test_data_utility
