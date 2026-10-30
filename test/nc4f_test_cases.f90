module nc4f_test_cases

use, intrinsic :: iso_fortran_env, only: int8, int16, int32, int64, real32, &
  & real64
use, non_intrinsic :: nc4f
implicit none (type, external)

public :: simple_wr, simple_rd, character_variables, elemental_reads, hyperslab_reads, buffer_edges
public :: creation_policy, error_handling
public :: rename_att_model, rename_att_file, rename_att_errors
public :: rename_var_model, rename_var_file, rename_var_errors
public :: rename_grp_model, rename_grp_file, rename_grp_errors
public :: unlimited_wr, unlimited_dims
public :: sum_vars_test, sfc_pres_temp_wr, &
  & sfc_pres_temp_rd, extensive_wr, extensive_rd
public :: group_model, group_write
public :: nasa_cosp_read
public :: ecmwf_era40_read
public :: sresa1b_ccsm3_read, sample_uddtio, &
  & cami_initial_read, tos_o1_read, echam_spectral_read
public :: copy_semantics
public :: data_model
private

character(*), parameter :: TEST_RESULTS_DIR = "build/test-results/"
character(*), parameter :: NETCDF_TYPE_RESULT_FILE = &
  & "build/test-results/nasa_cosp_netcdf_type.txt"

interface
  module subroutine rename_grp_model(passed)
    logical, intent(inout) :: passed
  end subroutine rename_grp_model

  module subroutine rename_grp_file(passed)
    logical, intent(inout) :: passed
  end subroutine rename_grp_file

  module subroutine rename_grp_errors(passed)
    logical, intent(inout) :: passed
  end subroutine rename_grp_errors

  module subroutine rename_var_model(passed)
    logical, intent(inout) :: passed
  end subroutine rename_var_model

  module subroutine rename_var_file(passed)
    logical, intent(inout) :: passed
  end subroutine rename_var_file

  module subroutine rename_var_errors(passed)
    logical, intent(inout) :: passed
  end subroutine rename_var_errors

  module subroutine rename_att_model(passed)
    logical, intent(inout) :: passed
  end subroutine rename_att_model

  module subroutine rename_att_file(passed)
    logical, intent(inout) :: passed
  end subroutine rename_att_file

  module subroutine rename_att_errors(passed)
    logical, intent(inout) :: passed
  end subroutine rename_att_errors

  module subroutine simple_wr(passed)
    !! Perform the simple_wr operation.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine simple_wr

  module subroutine simple_rd(passed)
    !! Perform the simple_rd operation.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine simple_rd

  module subroutine character_variables(passed)
    !! Perform the character_variables operation.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine character_variables

  module subroutine elemental_reads(passed)
    !! Perform the elemental_reads operation.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine elemental_reads

  module subroutine hyperslab_reads(passed)
    !! Perform the hyperslab_reads operation.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine hyperslab_reads

  module subroutine buffer_edges(passed)
    !! Perform the buffer_edges operation.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine buffer_edges

  module subroutine creation_policy(passed)
    !! Perform the creation_policy operation.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine creation_policy

  module subroutine error_handling(passed)
    !! Perform the error_handling operation.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine error_handling

  module subroutine unlimited_wr(passed)
    !! Perform the unlimited_wr operation.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine unlimited_wr

  module subroutine unlimited_dims(passed)
    !! Perform the unlimited_dims operation.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine unlimited_dims

  module subroutine sum_vars_test(passed)
    !! Perform the sum_vars_test operation.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine sum_vars_test

  module subroutine sfc_pres_temp_wr(passed)
    !! Perform the sfc_pres_temp_wr operation.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine sfc_pres_temp_wr

  module subroutine sfc_pres_temp_rd(passed)
    !! Perform the sfc_pres_temp_rd operation.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine sfc_pres_temp_rd

  module subroutine extensive_wr(passed)
    !! Perform the extensive_wr operation.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine extensive_wr

  module subroutine extensive_rd(passed)
    !! Perform the extensive_rd operation.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine extensive_rd

  module subroutine group_model(passed)
    !! Perform the group_model operation.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine group_model

  module subroutine group_write(passed)
    !! Perform the group_write operation.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine group_write

  module subroutine nasa_cosp_read(passed)
    !! Perform the nasa_cosp_read operation.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine nasa_cosp_read

  module subroutine ecmwf_era40_read(passed)
    !! Perform the ecmwf_era40_read operation.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine ecmwf_era40_read

  module subroutine sresa1b_ccsm3_read(passed)
    !! Perform the sresa1b_ccsm3_read operation.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine sresa1b_ccsm3_read

  module subroutine sample_uddtio(passed)
    !! Perform the sample_uddtio operation.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine sample_uddtio

  module subroutine cami_initial_read(passed)
    !! Perform the cami_initial_read operation.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine cami_initial_read

  module subroutine tos_o1_read(passed)
    !! Perform the tos_o1_read operation.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine tos_o1_read

  module subroutine echam_spectral_read(passed)
    !! Perform the echam_spectral_read operation.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine echam_spectral_read

  module subroutine copy_semantics(passed)
    !! Perform the copy_semantics operation.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine copy_semantics

  module subroutine data_model(passed)
    !! Perform the data_model operation.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine data_model
end interface

end module nc4f_test_cases
