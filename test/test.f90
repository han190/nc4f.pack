program main

use, non_intrinsic :: module_test
use, non_intrinsic :: module_examples
implicit none (type, external)

type(test_type), allocatable :: tests(:)
tests = [&
  & test_type("simple_wr", simple_wr), &
  & test_type("simple_rd", simple_rd), &
  & test_type("sfc_pres_temp_wr", sfc_pres_temp_wr), &
  & test_type("sfc_pres_temp_rd", sfc_pres_temp_rd)]
call run_tests(tests)

end program main
