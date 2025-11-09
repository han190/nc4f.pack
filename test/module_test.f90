module module_test
implicit none(type, external)

public :: test_type
public :: run_tests
private

type :: test_type
  character(len=:), allocatable :: name
  procedure(test_proc), nopass, pointer :: test => null()
  logical :: passed = .false.
end type test_type

interface
  subroutine test_proc(passed)
    logical, intent(inout) :: passed
  end subroutine test_proc
end interface

contains

subroutine run_tests(tests)
  type(test_type), intent(inout) :: tests(:)
  integer :: i

  do i = 1, size(tests)
    call tests(i)%test(tests(i)%passed)
    if (tests(i)%passed) then
      print "(a)", "Test "//tests(i)%name//". Passed."
    else
      print "(a)", "Test "//tests(i)%name//". Failed."
    end if
  end do
end subroutine run_tests

end module module_test

