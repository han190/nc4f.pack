module nc4f_test_cases

use, intrinsic :: iso_fortran_env, only: int8, int16, int32, int64, real32, real64
use, non_intrinsic :: nc4f
implicit none (type, external)

public :: simple_wr, simple_rd, character_variables, buffer_edges
public :: creation_policy, error_handling
 public :: hyperslab_rd, hyperslab_wr, unlimited_wr, unlimited_dims
public :: sum_vars_test, sfc_pres_temp_wr, sfc_pres_temp_rd, extensive_wr, extensive_rd
public :: group_model, group_write
public :: nasa_cosp_read
public :: ecmwf_era40_read
public :: sresa1b_ccsm3_read, cami_initial_read, tos_o1_read, echam_spectral_read
public :: copy_semantics
public :: data_model
private

character(*), parameter :: TEST_RESULTS_DIR = "build/test-results/"
character(*), parameter :: NETCDF_TYPE_RESULT_FILE = &
  & "build/test-results/nasa_cosp_netcdf_type.txt"

interface
  module subroutine simple_wr(passed)
    !> Input/output argument(s): `passed`.
    logical, intent(inout) :: passed
  end subroutine simple_wr

  module subroutine simple_rd(passed)
    !> Input/output argument(s): `passed`.
    logical, intent(inout) :: passed
  end subroutine simple_rd

  module subroutine character_variables(passed)
    !> Input/output argument(s): `passed`.
    logical, intent(inout) :: passed
  end subroutine character_variables

  module subroutine buffer_edges(passed)
    !> Input/output argument(s): `passed`.
    logical, intent(inout) :: passed
  end subroutine buffer_edges

  module subroutine creation_policy(passed)
    !> Input/output argument(s): `passed`.
    logical, intent(inout) :: passed
  end subroutine creation_policy

  module subroutine error_handling(passed)
    !> Input/output argument(s): `passed`.
    logical, intent(inout) :: passed
  end subroutine error_handling

  module subroutine hyperslab_rd(passed)
    !> Input/output argument(s): `passed`.
    logical, intent(inout) :: passed
  end subroutine hyperslab_rd

  module subroutine hyperslab_wr(passed)
    !> Input/output argument(s): `passed`.
    logical, intent(inout) :: passed
  end subroutine hyperslab_wr

  module subroutine unlimited_wr(passed)
    !> Input/output argument(s): `passed`.
    logical, intent(inout) :: passed
  end subroutine unlimited_wr

  module subroutine unlimited_dims(passed)
    !> Input/output argument(s): `passed`.
    logical, intent(inout) :: passed
  end subroutine unlimited_dims

  module subroutine sum_vars_test(passed)
    !> Input/output argument(s): `passed`.
    logical, intent(inout) :: passed
  end subroutine sum_vars_test

  module subroutine sfc_pres_temp_wr(passed)
    !> Input/output argument(s): `passed`.
    logical, intent(inout) :: passed
  end subroutine sfc_pres_temp_wr

  module subroutine sfc_pres_temp_rd(passed)
    !> Input/output argument(s): `passed`.
    logical, intent(inout) :: passed
  end subroutine sfc_pres_temp_rd

  module subroutine extensive_wr(passed)
    !> Input/output argument(s): `passed`.
    logical, intent(inout) :: passed
  end subroutine extensive_wr

  module subroutine extensive_rd(passed)
    !> Input/output argument(s): `passed`.
    logical, intent(inout) :: passed
  end subroutine extensive_rd

  module subroutine group_model(passed)
    logical, intent(inout) :: passed
  end subroutine group_model

  module subroutine group_write(passed)
    logical, intent(inout) :: passed
  end subroutine group_write

  module subroutine nasa_cosp_read(passed)
    !> Input/output argument(s): `passed`.
    logical, intent(inout) :: passed
  end subroutine nasa_cosp_read

  module subroutine ecmwf_era40_read(passed)
    !> Input/output argument(s): `passed`.
    logical, intent(inout) :: passed
  end subroutine ecmwf_era40_read

  module subroutine sresa1b_ccsm3_read(passed)
    logical, intent(inout) :: passed
  end subroutine sresa1b_ccsm3_read

  module subroutine cami_initial_read(passed)
    logical, intent(inout) :: passed
  end subroutine cami_initial_read

  module subroutine tos_o1_read(passed)
    logical, intent(inout) :: passed
  end subroutine tos_o1_read

  module subroutine echam_spectral_read(passed)
    logical, intent(inout) :: passed
  end subroutine echam_spectral_read

  module subroutine copy_semantics(passed)
    logical, intent(inout) :: passed
  end subroutine copy_semantics

  module subroutine data_model(passed)
    logical, intent(inout) :: passed
  end subroutine data_model
end interface

end module nc4f_test_cases
