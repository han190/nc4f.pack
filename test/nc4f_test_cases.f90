module nc4f_test_cases

use, intrinsic :: iso_fortran_env, only: int8, int16, int32, int64, real32, &
  & real64
use, non_intrinsic :: nc4f
implicit none (type, external)

public :: simple_wr, simple_rd, character_variables, elemental_reads, hyperslab_reads, buffer_edges
public :: creation_policy, error_handling
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
  !> Perform the simple_wr operation.
  module subroutine simple_wr(passed)
    !> Whether the test case has passed.
    logical, intent(inout) :: passed
  end subroutine simple_wr

  !> Perform the simple_rd operation.
  module subroutine simple_rd(passed)
    !> Whether the test case has passed.
    logical, intent(inout) :: passed
  end subroutine simple_rd

  !> Perform the character_variables operation.
  module subroutine character_variables(passed)
    !> Whether the test case has passed.
    logical, intent(inout) :: passed
  end subroutine character_variables

  !> Perform the elemental_reads operation.
  module subroutine elemental_reads(passed)
    !> Whether the test case has passed.
    logical, intent(inout) :: passed
  end subroutine elemental_reads

  !> Perform the hyperslab_reads operation.
  module subroutine hyperslab_reads(passed)
    !> Whether the test case has passed.
    logical, intent(inout) :: passed
  end subroutine hyperslab_reads

  !> Perform the buffer_edges operation.
  module subroutine buffer_edges(passed)
    !> Whether the test case has passed.
    logical, intent(inout) :: passed
  end subroutine buffer_edges

  !> Perform the creation_policy operation.
  module subroutine creation_policy(passed)
    !> Whether the test case has passed.
    logical, intent(inout) :: passed
  end subroutine creation_policy

  !> Perform the error_handling operation.
  module subroutine error_handling(passed)
    !> Whether the test case has passed.
    logical, intent(inout) :: passed
  end subroutine error_handling

  !> Perform the unlimited_wr operation.
  module subroutine unlimited_wr(passed)
    !> Whether the test case has passed.
    logical, intent(inout) :: passed
  end subroutine unlimited_wr

  !> Perform the unlimited_dims operation.
  module subroutine unlimited_dims(passed)
    !> Whether the test case has passed.
    logical, intent(inout) :: passed
  end subroutine unlimited_dims

  !> Perform the sum_vars_test operation.
  module subroutine sum_vars_test(passed)
    !> Whether the test case has passed.
    logical, intent(inout) :: passed
  end subroutine sum_vars_test

  !> Perform the sfc_pres_temp_wr operation.
  module subroutine sfc_pres_temp_wr(passed)
    !> Whether the test case has passed.
    logical, intent(inout) :: passed
  end subroutine sfc_pres_temp_wr

  !> Perform the sfc_pres_temp_rd operation.
  module subroutine sfc_pres_temp_rd(passed)
    !> Whether the test case has passed.
    logical, intent(inout) :: passed
  end subroutine sfc_pres_temp_rd

  !> Perform the extensive_wr operation.
  module subroutine extensive_wr(passed)
    !> Whether the test case has passed.
    logical, intent(inout) :: passed
  end subroutine extensive_wr

  !> Perform the extensive_rd operation.
  module subroutine extensive_rd(passed)
    !> Whether the test case has passed.
    logical, intent(inout) :: passed
  end subroutine extensive_rd

  !> Perform the group_model operation.
  module subroutine group_model(passed)
    !> Whether the test case has passed.
    logical, intent(inout) :: passed
  end subroutine group_model

  !> Perform the group_write operation.
  module subroutine group_write(passed)
    !> Whether the test case has passed.
    logical, intent(inout) :: passed
  end subroutine group_write

  !> Perform the nasa_cosp_read operation.
  module subroutine nasa_cosp_read(passed)
    !> Whether the test case has passed.
    logical, intent(inout) :: passed
  end subroutine nasa_cosp_read

  !> Perform the ecmwf_era40_read operation.
  module subroutine ecmwf_era40_read(passed)
    !> Whether the test case has passed.
    logical, intent(inout) :: passed
  end subroutine ecmwf_era40_read

  !> Perform the sresa1b_ccsm3_read operation.
  module subroutine sresa1b_ccsm3_read(passed)
    !> Whether the test case has passed.
    logical, intent(inout) :: passed
  end subroutine sresa1b_ccsm3_read

  !> Perform the sample_uddtio operation.
  module subroutine sample_uddtio(passed)
    !> Whether the test case has passed.
    logical, intent(inout) :: passed
  end subroutine sample_uddtio

  !> Perform the cami_initial_read operation.
  module subroutine cami_initial_read(passed)
    !> Whether the test case has passed.
    logical, intent(inout) :: passed
  end subroutine cami_initial_read

  !> Perform the tos_o1_read operation.
  module subroutine tos_o1_read(passed)
    !> Whether the test case has passed.
    logical, intent(inout) :: passed
  end subroutine tos_o1_read

  !> Perform the echam_spectral_read operation.
  module subroutine echam_spectral_read(passed)
    !> Whether the test case has passed.
    logical, intent(inout) :: passed
  end subroutine echam_spectral_read

  !> Perform the copy_semantics operation.
  module subroutine copy_semantics(passed)
    !> Whether the test case has passed.
    logical, intent(inout) :: passed
  end subroutine copy_semantics

  !> Perform the data_model operation.
  module subroutine data_model(passed)
    !> Whether the test case has passed.
    logical, intent(inout) :: passed
  end subroutine data_model
end interface

end module nc4f_test_cases
