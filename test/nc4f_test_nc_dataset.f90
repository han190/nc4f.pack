module nc4f_test_nc_dataset
use, intrinsic :: iso_c_binding, only: c_null_char
use, intrinsic :: iso_fortran_env, only: real32
use, non_intrinsic :: testdrive, only: check, &
  & test_error_type => error_type, new_unittest, unittest_type
use, non_intrinsic :: nc4f, only: netcdf_type, group_type, &
  & variable_type, model_error_type => error_type, datarray, dataset, &
  & open_netcdf, close_netcdf, to_netcdf, &
  & operator(.att.), operator(.dim.), NC_NOERR
use, non_intrinsic :: nc4f_c_interface, only: nc_delete
implicit none (type, external)
private
public :: collect_nc_dataset

contains

subroutine collect_nc_dataset(tests)
  type(unittest_type), allocatable, intent(out) :: tests(:)

  tests = [ &
    & new_unittest("open and close NetCDF", test_lifecycle), &
    & new_unittest("serialize variable", test_variable), &
    & new_unittest("serialize group", test_group) &
    & ]
end subroutine collect_nc_dataset

subroutine test_lifecycle(error)
  type(test_error_type), allocatable, intent(out) :: error
  type(netcdf_type) :: nc
  type(model_error_type) :: err

  nc = open_netcdf("nc4f-lifecycle.nc", mode="wn", &
    & diskless=.true., err=err)
  call check(error, err%code == NC_NOERR .and. &
    & nc%id >= 0, "open_netcdf failed")
  if (allocated(error)) return
  call close_netcdf(nc, err)
  call check(error, err%code == NC_NOERR .and. &
    & nc%id == -1, "close_netcdf failed")
end subroutine test_lifecycle

subroutine test_variable(error)
  type(test_error_type), allocatable, intent(out) :: error
  type(variable_type) :: var
  type(netcdf_type) :: nc
  type(model_error_type) :: err
  integer :: status

  var = datarray("v", [1.0_real32, 2.0_real32], &
    & ["x" .dim. 2])
  call to_netcdf("nc4f-variable-output.nc", var, err=err)
  call check(error, err%code == NC_NOERR, &
    & "to_netcdf variable overload failed")
  if (allocated(error)) return
  nc = open_netcdf("nc4f-variable-output.nc", err=err)
  call check(error, err%code == NC_NOERR, &
    & "Serialized variable file did not open")
  if (allocated(error)) return
  call close_netcdf(nc, err)
  status = nc_delete("nc4f-variable-output.nc"//c_null_char)
  call check(error, err%code == NC_NOERR .and. status == NC_NOERR, &
    & "Serialized variable file cleanup failed")
end subroutine test_variable

subroutine test_group(error)
  type(test_error_type), allocatable, intent(out) :: error
  type(group_type) :: grp
  type(netcdf_type) :: nc
  type(model_error_type) :: err
  integer :: status

  grp = dataset("root", atts=["title" .att. "sample"])
  call to_netcdf("nc4f-group-output.nc", grp, err=err)
  call check(error, err%code == NC_NOERR, &
    & "to_netcdf group overload failed")
  if (allocated(error)) return
  nc = open_netcdf("nc4f-group-output.nc", err=err)
  call check(error, err%code == NC_NOERR, &
    & "Serialized group file did not open")
  if (allocated(error)) return
  call close_netcdf(nc, err)
  status = nc_delete("nc4f-group-output.nc"//c_null_char)
  call check(error, err%code == NC_NOERR .and. status == NC_NOERR, &
    & "Serialized group file cleanup failed")
end subroutine test_group

end module nc4f_test_nc_dataset
