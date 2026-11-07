submodule(nc4f_test_c_interface) nc4f_test_c_interface_error
use, intrinsic :: iso_c_binding, only: c_associated, c_char, &
  & c_f_pointer, c_ptr, c_null_char
use, non_intrinsic :: testdrive, only: check, error_type, new_unittest, &
  & unittest_type
use, non_intrinsic :: nc4f_c_interface, only: nc_strerror, NC_EBADID
implicit none (type, external)

contains

module subroutine collect_c_interface_error(tests)
  type(unittest_type), allocatable, intent(out) :: tests(:)

  tests = [new_unittest("nc_strerror", test_nc_strerror)]
end subroutine collect_c_interface_error

subroutine test_nc_strerror(error)
  type(error_type), allocatable, intent(out) :: error
  type(c_ptr) :: message
  character(kind=c_char), pointer :: first(:)

  message = nc_strerror(NC_EBADID)
  call check(error, c_associated(message), "nc_strerror returned NULL")
  if (allocated(error)) return
  call c_f_pointer(message, first, [1])
  call check(error, first(1) /= c_null_char, &
    & "nc_strerror returned an empty message")
end subroutine test_nc_strerror

end submodule nc4f_test_c_interface_error
