submodule(nc4f_test_cases) nc4f_test_cases_io

implicit none (type, external)

contains

!> Execute `unlimited_wr`.
module subroutine unlimited_wr(passed)
  !> Input/output argument(s): `passed`.
  logical, intent(inout) :: passed
  integer(int32), parameter :: values(2, 3) = reshape([ &
    & 1_int32, 2_int32, 3_int32, 4_int32, 5_int32, 6_int32], [2, 3])
  integer(int32), pointer :: actual_values(:, :)
  type(netcdf_type) :: nc
  type(variable_type) :: actual, var

  var = datarray("records", values, ["x".dim.2, "time".dim.3])
  var%dims(2)%is_unlim = .true.
  call to_netcdf(TEST_RESULTS_DIR//"unlimited.nc", var)

  nc = open_netcdf(TEST_RESULTS_DIR//"unlimited.nc", "r")
  actual = get_variable(nc, "records")
  call close_netcdf(nc)
  call extract(actual, actual_values)
  passed = actual%dims(2)%is_unlim .and. &
    & all(actual%dims == var%dims) .and. all(actual_values == values)
end subroutine unlimited_wr

!> Execute `unlimited_dims`.
module subroutine unlimited_dims(passed)
  !> Input/output argument(s): `passed`.
  logical, intent(inout) :: passed
  integer(int32), parameter :: values(2, 3) = reshape([ &
    & 1_int32, 2_int32, 3_int32, 4_int32, 5_int32, 6_int32], [2, 3])
  type(error_type) :: err
  type(netcdf_type) :: nc
  type(variable_type) :: actual, var

  var = datarray("records", values, ["x".dim.2, "time".dim.3])
  var%dims%is_unlim = .true.
  call to_netcdf(TEST_RESULTS_DIR//"multiple-unlimited.nc", var, err=err)
  if ((err%code /= NC_NOERR)) then
    passed = .false.
    return
  end if
  nc = open_netcdf(TEST_RESULTS_DIR//"multiple-unlimited.nc", "r", err=err)
  if ((err%code /= NC_NOERR)) then
    passed = .false.
    return
  end if
  actual = get_variable(nc, "records", err)
  call close_netcdf(nc)
  passed = err%code == NC_NOERR .and. all(actual%dims%is_unlim) .and. &
    & all(actual%dims == var%dims)
end subroutine unlimited_dims

end submodule nc4f_test_cases_io
