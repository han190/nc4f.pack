module nc4f_test_nc_utility
use, non_intrinsic :: testdrive, only: check, &
  & test_error_type => error_type, new_unittest, unittest_type
use, non_intrinsic :: nc4f, only: netcdf_type, &
  & model_error_type => error_type, open_netcdf, close_netcdf, &
  & NC_NOERR
implicit none (type, external)
private
public :: collect_nc_utility, open_temp, close_temp

contains

subroutine collect_nc_utility(tests)
  type(unittest_type), allocatable, intent(out) :: tests(:)

  tests = [new_unittest("NetCDF setup and cleanup", test_fixture)]
end subroutine collect_nc_utility

subroutine open_temp(error, nc)
  type(test_error_type), allocatable, intent(out) :: error
  type(netcdf_type), intent(out) :: nc
  type(model_error_type) :: err

  nc = open_netcdf("nc4f-test-temp.nc", mode="wn", &
    & diskless=.true., err=err)
  call check(error, err%code == NC_NOERR, &
    & "Diskless NetCDF setup failed")
end subroutine open_temp

subroutine close_temp(error, nc)
  type(test_error_type), allocatable, intent(inout) :: error
  type(netcdf_type), intent(inout) :: nc
  type(model_error_type) :: err

  call close_netcdf(nc, err)
  if (allocated(error)) return
  call check(error, err%code == NC_NOERR, &
    & "Diskless NetCDF cleanup failed")
end subroutine close_temp

subroutine test_fixture(error)
  type(test_error_type), allocatable, intent(out) :: error
  type(netcdf_type) :: nc

  call open_temp(error, nc)
  if (allocated(error)) return
  call close_temp(error, nc)
  if (allocated(error)) return
  call check(error, nc%id == -1, "Closed NetCDF ID was retained")
end subroutine test_fixture

end module nc4f_test_nc_utility
