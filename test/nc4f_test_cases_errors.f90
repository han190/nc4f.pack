submodule(nc4f_test_cases) nc4f_test_cases_errors

implicit none (type, external)

contains

!> Execute `creation_policy`.
module subroutine creation_policy(passed)
  !> Input/output argument(s): `passed`.
  logical, intent(inout) :: passed
  real, parameter :: values(1) = [42.0]
  type(error_type) :: err
  type(netcdf_type) :: nc
  type(variable_type) :: var

  var = datarray("data", values, ["x".dim.1])
  call to_netcdf(TEST_RESULTS_DIR//"creation-policy.nc", var, err=err)
  if ((err%code /= NC_NOERR)) then
    passed = .false.
    return
  end if
  nc = open_netcdf(TEST_RESULTS_DIR//"creation-policy.nc", "a", err=err)
  if ((err%code /= NC_NOERR)) then
    passed = .false.
    return
  end if
  call close_netcdf(nc, err)
  if ((err%code /= NC_NOERR)) then
    passed = .false.
    return
  end if
  nc = open_netcdf(TEST_RESULTS_DIR//"creation-policy.nc", "w", err=err)
  if ((err%code /= NC_NOERR)) then
    passed = .false.
    return
  end if
  call close_netcdf(nc, err)
  passed = err%code == NC_NOERR
end subroutine creation_policy

!> Execute `error_handling`.
module subroutine error_handling(passed)
  !> Input/output argument(s): `passed`.
  logical, intent(inout) :: passed
  real, parameter :: values(1) = [42.0]
  character(len=1024) :: stdout
  integer :: iostat
  type(attribute_type) :: att
  type(error_type) :: err
  type(netcdf_type) :: nc
  type(variable_type) :: invalid, present, var, vars(2)

  passed = .false.
  err = error_type(NC_ENOTVAR, "constructed error")
  if (.not. (.exists.err .and. allocated(err%msg))) return
  err = error_type()
  if (.exists.err) return

  nc = open_netcdf(TEST_RESULTS_DIR//"unused.nc", "invalid", err=err)
  if (.not. ((err%code /= NC_NOERR) .and. err%code == NC_EINVAL)) return

  nc = open_netcdf(TEST_RESULTS_DIR// &
    & "missing-error-fixture/no-file.nc", err=err)
  if (.not. (.exists.err .and. allocated(err%msg))) return
  write (stdout, "(dt)", iostat=iostat) err
  if (iostat /= 0 .or. len_trim(stdout) == 0) return

  present = datarray("present", values, ["x".dim.1], ["units".att."1"])
  call to_netcdf(TEST_RESULTS_DIR//"error-handling.nc", present, err=err)
  if ((err%code /= NC_NOERR)) return
  nc = open_netcdf(TEST_RESULTS_DIR//"error-handling.nc", "r", err=err)
  if ((err%code /= NC_NOERR)) return

  var = inquire_variable(nc, "missing", err)
  if (.not. .exists.err .or. err%code /= NC_ENOTVAR) then
    call close_netcdf(nc)
    return
  end if
  var = get_variable(nc, "missing", err)
  if (.not. .exists.err .or. err%code /= NC_ENOTVAR) then
    call close_netcdf(nc)
    return
  end if
  var = get_variable(nc, "present", err)
  if ((err%code /= NC_NOERR)) then
    call close_netcdf(nc)
    return
  end if

  att = get_attribute(nc, "missing_global", err)
  if (.not. .exists.err .or. err%code /= NC_ENOTATT) then
    call close_netcdf(nc)
    return
  end if
  att = get_attribute(nc, var, "missing", err)
  if (.not. .exists.err .or. err%code /= NC_ENOTATT) then
    call close_netcdf(nc)
    return
  end if

  call close_netcdf(nc, err)
  if ((err%code /= NC_NOERR)) return

  invalid = datarray("", values, ["x".dim.1])
  vars = [present, invalid]
  call to_netcdf(TEST_RESULTS_DIR//"failed-write-cleanup.nc", vars, err=err)
  if (err%code == NC_NOERR) return
nc = open_netcdf(TEST_RESULTS_DIR//"failed-write-cleanup.nc", "a", err=err)
  if ((err%code /= NC_NOERR)) return
  var = get_variable(nc, "present", err)
  call close_netcdf(nc)
  passed = err%code == NC_NOERR .and. var%name == "present"
end subroutine error_handling

end submodule nc4f_test_cases_errors
