module nc4f_test_c_interface_utility
use, intrinsic :: iso_c_binding, only: c_associated, c_char, c_f_pointer, &
  & c_loc, c_null_char, c_null_ptr, c_ptr, c_size_t
use, non_intrinsic :: testdrive, only: check, error_type, new_unittest, &
  & unittest_type
use, non_intrinsic :: nc4f_c_interface, only: c_free, c_malloc, c_strlen
implicit none (type, external)
private
public :: collect_c_interface_utility

contains

subroutine collect_c_interface_utility(tests)
  type(unittest_type), allocatable, intent(out) :: tests(:)

  tests = [ &
    & new_unittest("c_strlen", test_c_strlen), &
    & new_unittest("c_malloc", test_c_malloc), &
    & new_unittest("c_free", test_c_free) &
    & ]
end subroutine collect_c_interface_utility

subroutine test_c_strlen(error)
  type(error_type), allocatable, intent(out) :: error
  character(kind=c_char), target :: chars(4)

  chars = [character(kind=c_char) :: "a", "b", "c", c_null_char]
  call check(error, c_strlen(c_loc(chars)) == 3_c_size_t, &
    & "Incorrect C string length")
end subroutine test_c_strlen

subroutine test_c_malloc(error)
  type(error_type), allocatable, intent(out) :: error
  type(c_ptr) :: memory
  character(kind=c_char), pointer :: bytes(:)

  memory = c_malloc(4_c_size_t)
  call check(error, c_associated(memory), "c_malloc returned NULL")
  if (allocated(error)) return
  call c_f_pointer(memory, bytes, [4])
  bytes = [character(kind=c_char) :: "t", "e", "s", "t"]
  call check(error, all(bytes == [character(kind=c_char) :: &
    & "t", "e", "s", "t"]), "Allocated memory is not writable")
  nullify(bytes)
  call c_free(memory)
end subroutine test_c_malloc

subroutine test_c_free(error)
  type(error_type), allocatable, intent(out) :: error
  type(c_ptr) :: memory

  memory = c_malloc(1_c_size_t)
  call check(error, c_associated(memory), "c_malloc setup failed")
  if (allocated(error)) return
  call c_free(memory)
  call c_free(c_null_ptr)
end subroutine test_c_free

end module nc4f_test_c_interface_utility
