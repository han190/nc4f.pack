submodule(nc4f_test_nc) nc4f_test_nc_utility
use, non_intrinsic :: testdrive, only: check, &
  & test_error_type => error_type, new_unittest, unittest_type
use, non_intrinsic :: nc4f, only: netcdf_type
use, non_intrinsic :: nc4f_test_utility, only: open_temp, close_temp
implicit none (type, external)

contains

module subroutine collect_nc_utility(tests)
  type(unittest_type), allocatable, intent(out) :: tests(:)

  tests = [new_unittest("NetCDF setup and cleanup", test_fixture)]
end subroutine collect_nc_utility

subroutine test_fixture(error)
  type(test_error_type), allocatable, intent(out) :: error
  type(netcdf_type) :: nc

  call open_temp(error, nc)
  if (allocated(error)) return
  call close_temp(error, nc)
  if (allocated(error)) return
  call check(error, nc%id == -1, "Closed NetCDF ID was retained")
end subroutine test_fixture

end submodule nc4f_test_nc_utility
