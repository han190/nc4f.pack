program main

use, intrinsic :: iso_fortran_env, only: real32
use, non_intrinsic :: nc4f
use, non_intrinsic :: nc4f_test_module
use, non_intrinsic :: nc4f_test_cases
use, non_intrinsic :: nc4f_test_c_bindings
implicit none (type, external)

character(len=128) :: command
type(test_type), allocatable :: tests(:)

call get_command_argument(1, command)
select case (trim(command))
case ("--ownership-invalid-noncontiguous")
  call invalid_noncontiguous_shallow_constructor()
case ("--ownership-invalid-character")
  call invalid_character_shallow_constructor()
case ("--rename-invalid-model")
  call invalid_model_rename()
case ("--rename-invalid-file")
  call invalid_file_rename()
case ("--rename-var-invalid-model")
  call invalid_model_var_rename()
case ("--rename-var-invalid-file")
  call invalid_file_var_rename()
case ("--rename-grp-invalid-model")
  call invalid_model_grp_rename()
case ("--rename-grp-invalid-file")
  call invalid_file_grp_rename()
case default
  tests = [&
    & test_type("c_bindings_storage", c_bindings_storage), &
    & test_type("c_bindings_formats", c_bindings_formats), &
    & test_type("c_bindings_strings", c_bindings_strings), &
    & test_type("c_bindings_user_types", c_bindings_user_types), &
    & test_type("c_bindings_memory_mapped", c_bindings_memory_mapped), &
    & test_type("c_bindings_legacy_aux", c_bindings_legacy_aux), &
    & test_type("simple_wr", simple_wr), &
    & test_type("simple_rd", simple_rd), &
    & test_type("character_variables", character_variables), &
    & test_type("elemental_reads", elemental_reads), &
    & test_type("hyperslab_reads", hyperslab_reads), &
    & test_type("creation_policy", creation_policy), &
    & test_type("error_handling", error_handling), &
    & test_type("rename_att_model", rename_att_model), &
    & test_type("rename_att_file", rename_att_file), &
    & test_type("rename_att_errors", rename_att_errors), &
    & test_type("rename_var_model", rename_var_model), &
    & test_type("rename_var_file", rename_var_file), &
    & test_type("rename_var_errors", rename_var_errors), &
    & test_type("rename_grp_model", rename_grp_model), &
    & test_type("rename_grp_file", rename_grp_file), &
    & test_type("rename_grp_errors", rename_grp_errors), &
    & test_type("unlimited_wr", unlimited_wr), &
    & test_type("unlimited_dims", unlimited_dims), &
    & test_type("sum_vars", sum_vars_test), &
    & test_type("sfc_pres_temp_wr", sfc_pres_temp_wr), &
    & test_type("sfc_pres_temp_rd", sfc_pres_temp_rd), &
    & test_type("buffer_edges", buffer_edges), &
    & test_type("extensive_wr", extensive_wr), &
    & test_type("extensive_rd", extensive_rd), &
    & test_type("group_model", group_model), &
    & test_type("group_write", group_write), &
    & test_type("copy_semantics", copy_semantics), &
    & test_type("data_model", data_model), &
    & test_type("nasa_cosp_read", nasa_cosp_read), &
    & test_type("ecmwf_era40_read", ecmwf_era40_read), &
    & test_type("sresa1b_ccsm3_read", sresa1b_ccsm3_read), &
    & test_type("sample_uddtio", sample_uddtio), &
    & test_type("cami_initial_read", cami_initial_read), &
    & test_type("tos_o1_read", tos_o1_read), &
    & test_type("echam_spectral_read", echam_spectral_read)]
  call setup_test_results()
  call run_tests(tests)

end select

contains

subroutine invalid_model_grp_rename()
  type(group_type) :: grp
  call rename_group(grp, "bad/name")
  stop 0
end subroutine invalid_model_grp_rename

subroutine invalid_file_grp_rename()
  type(group_type) :: parent
  call rename_group(parent, "old", "new", update_file=.true.)
  stop 0
end subroutine invalid_file_grp_rename

subroutine invalid_model_var_rename()
  type(variable_type) :: var

  call rename_variable(var, "bad/name")
  stop 0
end subroutine invalid_model_var_rename

subroutine invalid_file_var_rename()
  type(group_type) :: grp

  call rename_variable(grp, "old", "new", update_file=.true.)
  stop 0
end subroutine invalid_file_var_rename

subroutine invalid_model_rename()
  type(attribute_type) :: att

  att = "old".att.1
  call rename_attribute(att, "bad/name")
  stop 0 ! The parent test requires the library to fail before this point.
end subroutine invalid_model_rename

subroutine invalid_file_rename()
  type(group_type) :: grp

  call rename_attribute(grp, "old", "new", update_file=.true.)
  stop 0
end subroutine invalid_file_rename

subroutine invalid_noncontiguous_shallow_constructor()
  !! Attempt shallow construction from a noncontiguous array section.
  real(real32), target :: values(3, 3)
  type(variable_type) :: var

  values = reshape([1.0_real32, 2.0_real32, 3.0_real32, 4.0_real32, 5.0_real32, &
    & 6.0_real32, 7.0_real32, 8.0_real32, 9.0_real32], shape(values))
  var = datarray("invalid", values(1:2, 2:3), ["x".dim.2, "y".dim.2], deep=.false.)
  error stop "[ownership test] Noncontiguous shallow construction unexpectedly succeeded."
end subroutine invalid_noncontiguous_shallow_constructor

subroutine invalid_character_shallow_constructor()
  !! Attempt shallow construction from character storage.
  character, target :: values(2) = ["a", "b"]
  type(variable_type) :: var

  var = datarray("invalid", values, ["x".dim.2], deep=.false.)
  error stop "[ownership test] Character shallow construction unexpectedly succeeded."
end subroutine invalid_character_shallow_constructor

end program main
