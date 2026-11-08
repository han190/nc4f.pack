program nc4f_test
use, intrinsic :: iso_fortran_env, only: error_unit
use, non_intrinsic :: testdrive, only: new_testsuite, run_selected, &
  & run_testsuite, testsuite_type
use, non_intrinsic :: nc4f_test_c_interface, only: &
  & collect_c_interface_dimension, &
  & collect_c_interface_error, &
  & collect_c_interface_group, &
  & collect_c_interface_attribute, &
  & collect_c_interface_utility, &
  & collect_c_interface_dataset, &
  & collect_c_interface_io, &
  & collect_c_interface_variable
use, non_intrinsic :: nc4f_test_data, only: &
  & collect_data_dimension, &
  & collect_data_utility, &
  & collect_data_attribute_constructor, &
  & collect_data_attribute, &
  & collect_data_variable_constructor, &
  & collect_data_extract, &
  & collect_data_variable, &
  & collect_data_group, &
  & collect_data_arithmetic, &
  & collect_data_clone, &
  & collect_data_io, &
  & collect_data_validate
use, non_intrinsic :: nc4f_test_netcdf, only: &
  & collect_netcdf_utility, &
  & collect_netcdf_dataset, &
  & collect_netcdf_variable, &
  & collect_netcdf_dimension, &
  & collect_netcdf_attribute, &
  & collect_netcdf_group, &
  & collect_netcdf_error, &
  & collect_real_data
implicit none (type, external)

type(testsuite_type), allocatable :: suites(:)
integer :: i, stat
character(len=64) :: selected
character(len=64) :: selected_test
logical :: found

suites = [ &
  & new_testsuite("c_interface_attribute", collect_c_interface_attribute), &
  & new_testsuite("c_interface_dataset", collect_c_interface_dataset), &
  & new_testsuite("c_interface_dimension", collect_c_interface_dimension), &
  & new_testsuite("c_interface_error", collect_c_interface_error), &
  & new_testsuite("c_interface_group", collect_c_interface_group), &
  & new_testsuite("c_interface_io", collect_c_interface_io), &
  & new_testsuite("c_interface_utility", collect_c_interface_utility), &
  & new_testsuite("c_interface_variable", collect_c_interface_variable), &
  & new_testsuite("data_dimension", &
  &   collect_data_dimension), &
  & new_testsuite("data_utility", collect_data_utility), &
  & new_testsuite("data_attribute_constructor", &
  &   collect_data_attribute_constructor), &
  & new_testsuite("data_attribute", &
  &   collect_data_attribute), &
  & new_testsuite("data_variable_constructor", &
  &   collect_data_variable_constructor), &
  & new_testsuite("data_extract", collect_data_extract), &
  & new_testsuite("data_variable", collect_data_variable), &
  & new_testsuite("data_group", collect_data_group), &
  & new_testsuite("data_arithmetic", &
  &   collect_data_arithmetic), &
  & new_testsuite("data_clone", collect_data_clone), &
  & new_testsuite("data_io", collect_data_io), &
  & new_testsuite("data_validate", collect_data_validate), &
  & new_testsuite("netcdf_utility", collect_netcdf_utility), &
  & new_testsuite("netcdf_dataset", collect_netcdf_dataset), &
  & new_testsuite("netcdf_variable", collect_netcdf_variable), &
  & new_testsuite("netcdf_dimension", collect_netcdf_dimension), &
  & new_testsuite("netcdf_attribute", collect_netcdf_attribute), &
  & new_testsuite("netcdf_group", collect_netcdf_group), &
  & new_testsuite("netcdf_error", collect_netcdf_error), &
  & new_testsuite("real_data", collect_real_data)]

stat = 0
selected = ""
if (command_argument_count() > 0) call get_command_argument(1, selected)
selected_test = ""
if (command_argument_count() > 1) then
  call get_command_argument(2, selected_test)
end if
found = .false.
do i = 1, size(suites)
  if (len_trim(selected) > 0 .and. selected /= suites(i)%name) cycle
  found = .true.
  write (error_unit, "(a, 1x, a)") "Testing:", suites(i)%name
  if (len_trim(selected_test) > 0) then
    call run_selected(suites(i)%collect, trim(selected_test), &
      & error_unit, stat)
  else
    call run_testsuite(suites(i)%collect, error_unit, stat)
  end if
end do
if (.not. found) error stop "Unknown test suite."
if (stat > 0) error stop "New test suite failed."
end program nc4f_test
