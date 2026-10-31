module nc4f_test_cases

use, intrinsic :: iso_fortran_env, only: int8, int16, int32, int64, real32, &
  & real64
use, non_intrinsic :: nc4f
implicit none (type, external)

public :: simple_wr, simple_rd, character_variables, elemental_reads, hyperslab_reads, buffer_edges
public :: creation_policy, error_handling
public :: delete_att_model, delete_att_file, delete_att_errors
public :: rename_att_model, rename_att_file, rename_att_errors
public :: rename_var_model, rename_var_file, rename_var_errors
public :: rename_dim_model, rename_dim_file, rename_dim_errors
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
  module subroutine rename_dim_model(passed)
    !! Test dimension renaming and its documented scope and error guarantees.
    logical, intent(inout) :: passed
    !! Set true when all assertions pass.
  end subroutine rename_dim_model

  module subroutine rename_dim_file(passed)
    !! Test dimension renaming and its documented scope and error guarantees.
    logical, intent(inout) :: passed
    !! Set true when all assertions pass.
  end subroutine rename_dim_file

  module subroutine rename_dim_errors(passed)
    !! Test dimension renaming and its documented scope and error guarantees.
    logical, intent(inout) :: passed
    !! Set true when all assertions pass.
  end subroutine rename_dim_errors

  module subroutine delete_att_model(passed)
    !! Test pure model deletion and surviving attribute storage.
    logical, intent(inout) :: passed
    !! Set true when all checks pass.
  end subroutine delete_att_model

  module subroutine delete_att_file(passed)
    !! Test persistent file deletion and supplied cache synchronization.
    logical, intent(inout) :: passed
    !! Set true when all checks pass.
  end subroutine delete_att_file

  module subroutine delete_att_errors(passed)
    !! Test deletion errors, unchanged state, and failure without ERR.
    logical, intent(inout) :: passed
    !! Set true when all checks pass.
  end subroutine delete_att_errors

  module subroutine rename_grp_model(passed)
    !! Test in-memory group renaming and preservation of model contents.
    logical, intent(inout) :: passed
    !! Set true when all checks in this test succeed.
  end subroutine rename_grp_model

  module subroutine rename_grp_file(passed)
    !! Test persistent group renaming and synchronization of supplied caches.
    logical, intent(inout) :: passed
    !! Set true when all checks in this test succeed.
  end subroutine rename_grp_file

  module subroutine rename_grp_errors(passed)
    !! Test group-renaming failures, unchanged state, and fail-fast behavior.
    logical, intent(inout) :: passed
    !! Set true when all checks in this test succeed.
  end subroutine rename_grp_errors

  module subroutine rename_var_model(passed)
    !! Test in-memory variable renaming and preservation of model contents.
    logical, intent(inout) :: passed
    !! Set true when all checks in this test succeed.
  end subroutine rename_var_model

  module subroutine rename_var_file(passed)
    !! Test persistent variable renaming and synchronization of supplied caches.
    logical, intent(inout) :: passed
    !! Set true when all checks in this test succeed.
  end subroutine rename_var_file

  module subroutine rename_var_errors(passed)
    !! Test variable-renaming failures, unchanged state, and fail-fast behavior.
    logical, intent(inout) :: passed
    !! Set true when all checks in this test succeed.
  end subroutine rename_var_errors

  module subroutine rename_att_model(passed)
    !! Test in-memory attribute renaming and preservation of model contents.
    logical, intent(inout) :: passed
    !! Set true when all checks in this test succeed.
  end subroutine rename_att_model

  module subroutine rename_att_file(passed)
    !! Test persistent attribute renaming and synchronization of supplied caches.
    logical, intent(inout) :: passed
    !! Set true when all checks in this test succeed.
  end subroutine rename_att_file

  module subroutine rename_att_errors(passed)
    !! Test attribute-renaming failures, unchanged state, and fail-fast behavior.
    logical, intent(inout) :: passed
    !! Set true when all checks in this test succeed.
  end subroutine rename_att_errors

  module subroutine simple_wr(passed)
    !! Write a small numeric variable and its metadata to a NetCDF file.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine simple_wr

  module subroutine simple_rd(passed)
    !! Read and verify the variable written by the simple NetCDF example.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine simple_rd

  module subroutine character_variables(passed)
    !! Test construction, serialization, and extraction of character variables.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine character_variables

  module subroutine elemental_reads(passed)
    !! Execute elemental variable metadata and value reads with array arguments.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine elemental_reads

  module subroutine hyperslab_reads(passed)
    !! Execute strided variable reads and their argument validation.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine hyperslab_reads

  module subroutine buffer_edges(passed)
    !! Test empty attributes and long object names through file round trips.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine buffer_edges

  module subroutine creation_policy(passed)
    !! Test file creation and reopening in append and overwrite modes.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine creation_policy

  module subroutine error_handling(passed)
    !! Test returned error codes, diagnostic messages, and successful recovery.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine error_handling

  module subroutine unlimited_wr(passed)
    !! Round-trip a variable whose record dimension is unlimited.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine unlimited_wr

  module subroutine unlimited_dims(passed)
    !! Verify that dimension inquiries retain unlimited-dimension metadata.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine unlimited_dims

  module subroutine sum_vars_test(passed)
    !! Verify element-wise summation of compatible variable objects.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine sum_vars_test

  module subroutine sfc_pres_temp_wr(passed)
    !! Write the surface pressure and temperature example with dimensions and units.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine sfc_pres_temp_wr

  module subroutine sfc_pres_temp_rd(passed)
    !! Read and verify the surface pressure and temperature example file.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine sfc_pres_temp_rd

  module subroutine extensive_wr(passed)
    !! Write the mixed-type, mixed-rank round-trip fixture to NetCDF.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine extensive_wr

  module subroutine extensive_rd(passed)
    !! Verify types, shapes, attributes, and values in the extensive round-trip file.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine extensive_rd

  module subroutine group_model(passed)
    !! Exercise recursive group construction and ncdump-like formatted output.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine group_model

  module subroutine group_write(passed)
    !! Write recursive group descriptions through both group serialization APIs.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine group_write

  module subroutine nasa_cosp_read(passed)
    !! Read root-level data and metadata from NASA's externally produced
    !! CLDPROP COSP NetCDF-4 sample file.  The file also contains nested groups;
    !! this test intentionally exercises the currently supported root group only.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine nasa_cosp_read

  module subroutine ecmwf_era40_read(passed)
    !! Read coordinates, CF metadata, and packed data from Unidata's externally
    !! produced ECMWF ERA-40 sample file.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine ecmwf_era40_read

  module subroutine sresa1b_ccsm3_read(passed)
    !! Read a CF climate-model file through the root-group API.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine sresa1b_ccsm3_read

  module subroutine sample_uddtio(passed)
    !! Render every externally produced NetCDF fixture through NetCDF UDDTIO.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine sample_uddtio

  module subroutine cami_initial_read(passed)
    !! Read CAM initial-condition data with a four-dimensional hyperslab.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine cami_initial_read

  module subroutine tos_o1_read(passed)
    !! Read an ocean file whose first latitude row contains missing values.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine tos_o1_read

  module subroutine echam_spectral_read(passed)
    !! Read a spectral-grid file with non-geographical dimensions.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine echam_spectral_read

  module subroutine copy_semantics(passed)
    !! Test owned buffers, borrowed views, and deep versus shallow group copies.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine copy_semantics

  module subroutine data_model(passed)
    !! Test data-model metadata, validation, equality, and formatted output.
    logical, intent(inout) :: passed
    !! Whether the test case has passed.
  end subroutine data_model
end interface

end module nc4f_test_cases
