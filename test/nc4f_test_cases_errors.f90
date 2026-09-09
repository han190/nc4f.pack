submodule(nc4f_test_cases) nc4f_test_cases_errors

implicit none (type, external)

contains

module subroutine creation_policy(passed)
  !> Input/output argument(s): `passed`.
  logical, intent(inout) :: passed
  real, parameter :: values(1) = [42.0]
  type(error_type) :: error
  type(netcdf_type) :: nc
  type(variable_type) :: var

  var = data_array("data", values, ["x".dim.1])
  call to_netcdf(TEST_RESULTS_DIR//"creation-policy.nc", var, error=error)
  if (failed(error)) then
    passed = .false.
    return
  end if
  nc = open_dataset(TEST_RESULTS_DIR//"creation-policy.nc", "a", error=error)
  if (failed(error)) then
    passed = .false.
    return
  end if
  call close_dataset(nc, error)
  if (failed(error)) then
    passed = .false.
    return
  end if
  nc = open_dataset(TEST_RESULTS_DIR//"creation-policy.nc", "w", error=error)
  if (failed(error)) then
    passed = .false.
    return
  end if
  call close_dataset(nc, error)
  passed = .not. failed(error)
end subroutine creation_policy

module subroutine error_handling(passed)
  !> Input/output argument(s): `passed`.
  logical, intent(inout) :: passed
  real, parameter :: values(1) = [42.0]
  character(len=1024) :: stdout
  integer :: io_stat
  type(attribute_type) :: att
  type(error_type) :: error
  type(netcdf_type) :: nc
  type(variable_type) :: invalid, present, var, vars(2)

  passed = .false.
  error = error_type(NC_ENOTVAR, "constructed error")
  if (.not. (failed(error) .and. .not. found(error) .and. allocated(error%message))) return
  error = error_type()
  if (failed(error)) return

  nc = open_dataset(TEST_RESULTS_DIR//"unused.nc", "invalid", error=error)
  if (.not. (failed(error) .and. error%code == NC_EINVAL)) return

  nc = open_dataset(TEST_RESULTS_DIR//"missing-error-fixture/no-file.nc", error=error)
  if (.not. (failed(error) .and. .not. found(error) .and. &
    & error%code /= NC_NOERR .and. allocated(error%message))) return
  write (stdout, "(dt)", iostat=io_stat) error
  if (io_stat /= 0 .or. len_trim(stdout) == 0) return

  present = data_array("present", values, ["x".dim.1], ["units".att."1"])
  call to_netcdf(TEST_RESULTS_DIR//"error-handling.nc", present, error=error)
  if (failed(error)) return
  nc = open_dataset(TEST_RESULTS_DIR//"error-handling.nc", "r", error=error)
  if (failed(error)) return

  var = inquire_variable(nc, "missing", error)
  if (found(error) .or. error%code /= NC_ENOTVAR) then
    call close_dataset(nc)
    return
  end if
  var = get_variable(nc, "missing", error)
  if (found(error) .or. error%code /= NC_ENOTVAR) then
    call close_dataset(nc)
    return
  end if
  var = get_variable(nc, "present", error)
  if (failed(error)) then
    call close_dataset(nc)
    return
  end if

  att = get_attribute(nc, "missing_global", error)
  if (found(error) .or. error%code /= NC_ENOTATT) then
    call close_dataset(nc)
    return
  end if
  att = get_attribute(nc, var, "missing", error)
  if (found(error) .or. error%code /= NC_ENOTATT) then
    call close_dataset(nc)
    return
  end if

  var = get_variable(nc, "present", [2], [1], error)
  if (.not. (failed(error) .and. found(error) .and. error%code == NC_EEDGE)) then
    call close_dataset(nc)
    return
  end if
  var = get_variable(nc, "present", [0], [1], error)
  if (.not. (failed(error) .and. error%code == NC_EINVALCOORDS)) then
    call close_dataset(nc)
    return
  end if
  call close_dataset(nc, error)
  if (failed(error)) return

  invalid = data_array("", values, ["x".dim.1])
  vars = [present, invalid]
  call to_netcdf(TEST_RESULTS_DIR//"failed-write-cleanup.nc", vars, error=error)
  if (.not. failed(error)) return
  nc = open_dataset(TEST_RESULTS_DIR//"failed-write-cleanup.nc", "a", error=error)
  if (failed(error)) return
  var = get_variable(nc, "present", error)
  call close_dataset(nc)
  passed = .not. failed(error) .and. var%name == "present"
end subroutine error_handling

end submodule nc4f_test_cases_errors
