program main

use, non_intrinsic :: nc4f_test_module
use, non_intrinsic :: nc4f_test_cases
implicit none (type, external)

type(test_type), allocatable :: tests(:)
tests = [&
  & test_type("simple_wr", simple_wr), &
  & test_type("simple_rd", simple_rd), &
  & test_type("character_variables", character_variables), &
  & test_type("creation_policy", creation_policy), &
  & test_type("error_handling", error_handling), &
  & test_type("hyperslab_rd", hyperslab_rd), &
  & test_type("hyperslab_wr", hyperslab_wr), &
  & test_type("unlimited_wr", unlimited_wr), &
  & test_type("unlimited_dims", unlimited_dims), &
  & test_type("sum_vars", sum_vars_test), &
  & test_type("sfc_pres_temp_wr", sfc_pres_temp_wr), &
  & test_type("sfc_pres_temp_rd", sfc_pres_temp_rd), &
  & test_type("buffer_edges", buffer_edges), &
  & test_type("extensive_wr", extensive_wr), &
  & test_type("extensive_rd", extensive_rd)]
call setup_test_results()
call run_tests(tests)

end program main
