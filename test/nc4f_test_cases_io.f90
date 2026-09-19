submodule(nc4f_test_cases) nc4f_test_cases_io

implicit none (type, external)

contains

!> Execute `hyperslab_rd`.
module subroutine hyperslab_rd(passed)
  !> Input/output argument(s): `passed`.
  logical, intent(inout) :: passed
  integer, parameter :: nx = 47, ny = 83
  real :: expected(3, 2)
  real, pointer :: values(:, :)
  type(netcdf_type) :: nc
  type(variable_type) :: actual, round_trip
  integer :: x, y

  nc = open_netcdf(TEST_RESULTS_DIR//"simple_wr.nc", "r")
  actual = get_variable(nc, "data", [4, 6], [3, 2])
  call close_netcdf(nc)
  call extract(actual, values)

  do concurrent(y=1:2, x=1:3)
    expected(x, y) = sqrt((x + 3 - 0.5*nx)**2 + (y + 5 - 0.5*ny)**2)
  end do
  passed = all(actual%dims == ["x".dim.3, "y".dim.2]) .and. &
    & all(abs(values - expected) <= epsilon(expected))
  if (.not. passed) return

  call to_netcdf(TEST_RESULTS_DIR//"hyperslab.nc", actual)
  nc = open_netcdf(TEST_RESULTS_DIR//"hyperslab.nc", "r")
  round_trip = get_variable(nc, "data")
  call close_netcdf(nc)
  passed = round_trip == actual
end subroutine hyperslab_rd

!> Execute `hyperslab_wr`.
module subroutine hyperslab_wr(passed)
  !> Input/output argument(s): `passed`.
  logical, intent(inout) :: passed
  integer(int32), parameter :: initial(2, 3) = &
    & reshape([1_int32, 2_int32, 3_int32, &
    & 4_int32, 5_int32, 6_int32], [2, 3])
  integer(int32), parameter :: updates(2, 2) = &
    & reshape([7_int32, 8_int32, 9_int32, 10_int32], [2, 2])
  integer(int32) :: expected(2, 5)
  integer(int32), pointer :: actual_values(:, :)
  type(error_type) :: err
  type(netcdf_type) :: nc
  type(variable_type) :: actual, chunk, var

  var = datarray("records", initial, ["x".dim.2, "time".dim.3])
  var%dims(2)%is_unlim = .true.
  call to_netcdf(TEST_RESULTS_DIR//"hyperslab-write.nc", var, err=err)
  if ((err%code /= NC_NOERR)) then
    passed = .false.
    return
  end if

  chunk = datarray("records", updates, ["x".dim.2, "time".dim.2])
  nc = open_netcdf(TEST_RESULTS_DIR//"hyperslab-write.nc", "a", err=err)
  if ((err%code /= NC_NOERR)) then
    passed = .false.
    return
  end if
  call put_variable(nc, chunk, [1, 4], [2, 2], err)
  if ((err%code /= NC_NOERR)) then
    call close_netcdf(nc)
    passed = .false.
    return
  end if
  call put_variable(nc, chunk, [2, 1], [2, 2], err)
  if (.not. ((err%code /= NC_NOERR) .and. err%code == NC_EEDGE)) then
    call close_netcdf(nc)
    passed = .false.
    return
  end if
  call close_netcdf(nc, err)
  if ((err%code /= NC_NOERR)) then
    passed = .false.
    return
  end if

  nc = open_netcdf(TEST_RESULTS_DIR//"hyperslab-write.nc", "r", err=err)
  if ((err%code /= NC_NOERR)) then
    passed = .false.
    return
  end if
  actual = get_variable(nc, "records", err)
  call close_netcdf(nc)
  if ((err%code /= NC_NOERR)) then
    passed = .false.
    return
  end if
  expected(:, :3) = initial
  expected(:, 4:) = updates
  call extract(actual, actual_values)
  passed = actual%dims(2)%is_unlim .and. all(actual_values == expected)
end subroutine hyperslab_wr

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
