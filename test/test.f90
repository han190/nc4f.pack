program main

use, non_intrinsic :: module_test
use, non_intrinsic :: module_examples
implicit none

type(test_type), allocatable :: tests(:)
tests = [&
  & test_type("simple_wr", simple_wr), &
  & test_type("simple_rd", simple_rd)]
call run_tests(tests)

end program main
