module nc4f_test_nc_error
use, non_intrinsic :: testdrive, only: check, &
  & test_error_type => error_type, new_unittest, unittest_type
use, non_intrinsic :: nc4f, only: netcdf_type, &
  & model_error_type => error_type, open_netcdf, error_msg, &
  & operator(.exists.), NC_EINVAL
implicit none (type, external)
private
public :: collect_nc_error

contains

subroutine collect_nc_error(tests)
  type(unittest_type), allocatable, intent(out) :: tests(:)

  tests = [new_unittest("NetCDF error propagation", test_error)]
end subroutine collect_nc_error

subroutine test_error(error)
  type(test_error_type), allocatable, intent(out) :: error
  type(netcdf_type) :: nc
  type(model_error_type) :: err

  nc = open_netcdf("unused.nc", mode="invalid", err=err)
  call check(error, err%code == NC_EINVAL .and. &
    & (.exists. err), "Invalid mode did not return NC_EINVAL")
  if (allocated(error)) return
  call check(error, index(error_msg(err), "open_netcdf") > 0, &
    & "NetCDF error lacks operation context")
end subroutine test_error

end module nc4f_test_nc_error
