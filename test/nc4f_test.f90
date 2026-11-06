program nc4f_test
use, intrinsic :: iso_fortran_env, only: error_unit
use, non_intrinsic :: testdrive, only: new_testsuite, run_selected, &
  & run_testsuite, testsuite_type
use, non_intrinsic :: nc4f_test_c_interface_dimension, only: &
  & collect_c_interface_dimension
use, non_intrinsic :: nc4f_test_c_interface_error, only: &
  & collect_c_interface_error
use, non_intrinsic :: nc4f_test_c_interface_group, only: &
  & collect_c_interface_group
use, non_intrinsic :: nc4f_test_c_interface_attribute, only: &
  & collect_c_interface_attribute
use, non_intrinsic :: nc4f_test_c_interface_utility, only: &
  & collect_c_interface_utility
use, non_intrinsic :: nc4f_test_c_interface_dataset, only: &
  & collect_c_interface_dataset
use, non_intrinsic :: nc4f_test_c_interface_io, only: &
  & collect_c_interface_io
use, non_intrinsic :: nc4f_test_c_interface_variable, only: &
  & collect_c_interface_variable
use, non_intrinsic :: nc4f_test_ds_dimension, only: &
  & collect_ds_dimension
use, non_intrinsic :: nc4f_test_ds_utility, only: &
  & collect_ds_utility
use, non_intrinsic :: nc4f_test_ds_attribute_constructor, &
  & only: collect_ds_attribute_constructor
use, non_intrinsic :: nc4f_test_ds_attribute, only: &
  & collect_ds_attribute
use, non_intrinsic :: nc4f_test_ds_variable_constructor, &
  & only: collect_ds_variable_constructor
use, non_intrinsic :: nc4f_test_ds_extract, only: &
  & collect_ds_extract
use, non_intrinsic :: nc4f_test_ds_variable, only: &
  & collect_ds_variable
use, non_intrinsic :: nc4f_test_ds_group, only: &
  & collect_ds_group
use, non_intrinsic :: nc4f_test_ds_arithmetic, only: &
  & collect_ds_arithmetic
use, non_intrinsic :: nc4f_test_ds_clone, only: &
  & collect_ds_clone
use, non_intrinsic :: nc4f_test_ds_io, only: &
  & collect_ds_io
use, non_intrinsic :: nc4f_test_ds_validate, only: &
  & collect_ds_validate
use, non_intrinsic :: nc4f_test_nc_utility, only: collect_nc_utility
use, non_intrinsic :: nc4f_test_nc_dataset, only: collect_nc_dataset
use, non_intrinsic :: nc4f_test_nc_variable, only: collect_nc_variable
use, non_intrinsic :: nc4f_test_nc_dimension, only: collect_nc_dimension
use, non_intrinsic :: nc4f_test_nc_attribute, only: collect_nc_attribute
use, non_intrinsic :: nc4f_test_nc_group, only: collect_nc_group
use, non_intrinsic :: nc4f_test_nc_error, only: collect_nc_error
use, non_intrinsic :: nc4f_test_real_data, only: collect_real_data
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
  & new_testsuite("ds_dimension", &
  &   collect_ds_dimension), &
  & new_testsuite("ds_utility", &
  &   collect_ds_utility), &
  & new_testsuite("ds_attribute_constructor", &
  &   collect_ds_attribute_constructor), &
  & new_testsuite("ds_attribute", &
  &   collect_ds_attribute), &
  & new_testsuite("ds_variable_constructor", &
  &   collect_ds_variable_constructor), &
  & new_testsuite("ds_extract", &
  &   collect_ds_extract), &
  & new_testsuite("ds_variable", &
  &   collect_ds_variable), &
  & new_testsuite("ds_group", &
  &   collect_ds_group), &
  & new_testsuite("ds_arithmetic", &
  &   collect_ds_arithmetic), &
  & new_testsuite("ds_clone", &
  &   collect_ds_clone), &
  & new_testsuite("ds_io", &
  &   collect_ds_io), &
  & new_testsuite("ds_validate", &
  &   collect_ds_validate), &
  & new_testsuite("nc_utility", collect_nc_utility), &
  & new_testsuite("nc_dataset", collect_nc_dataset), &
  & new_testsuite("nc_variable", collect_nc_variable), &
  & new_testsuite("nc_dimension", collect_nc_dimension), &
  & new_testsuite("nc_attribute", collect_nc_attribute), &
  & new_testsuite("nc_group", collect_nc_group), &
  & new_testsuite("nc_error", collect_nc_error), &
  & new_testsuite("real_data", collect_real_data) &
  & ]
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
