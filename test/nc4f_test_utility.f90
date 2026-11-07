module nc4f_test_utility
use, intrinsic :: iso_c_binding, only: c_int, c_null_char
use, non_intrinsic :: testdrive, only: check, error_type
use, non_intrinsic :: nc4f_c_interface, only: nc_close, nc_create, &
  & NC_CLOBBER, NC_DISKLESS, NC_NETCDF4, NC_NOERR
use, non_intrinsic :: nc4f, only: netcdf_type, &
  & model_error_type => error_type, open_netcdf, close_netcdf
implicit none (type, external)
private
public :: open_dataset, finish, open_temp, close_temp

contains

subroutine open_dataset(error, ncid, enhanced)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int), intent(out) :: ncid
  logical, intent(in), optional :: enhanced
  integer(c_int) :: mode, status

  mode = ior(NC_CLOBBER, NC_DISKLESS)
  if (present(enhanced)) then
    if (enhanced) mode = ior(mode, NC_NETCDF4)
  end if
  status = nc_create("nc4f-test-dataset"//c_null_char, mode, ncid)
  call check(error, status == NC_NOERR, "nc_create setup failed")
end subroutine open_dataset

subroutine finish(error, ncid, status, context)
  type(error_type), allocatable, intent(inout) :: error
  integer(c_int), intent(in) :: ncid, status
  character(len=*), intent(in) :: context
  integer(c_int) :: close_status

  close_status = nc_close(ncid)
  if (allocated(error)) return
  call check(error, status == NC_NOERR, context)
  if (allocated(error)) return
  call check(error, close_status == NC_NOERR, "nc_close cleanup failed")
end subroutine finish

subroutine open_temp(error, nc)
  type(error_type), allocatable, intent(out) :: error
  type(netcdf_type), intent(out) :: nc
  type(model_error_type) :: err

  nc = open_netcdf("nc4f-test-temp.nc", mode="wn", &
    & diskless=.true., err=err)
  call check(error, err%code == NC_NOERR, &
    & "Diskless NetCDF setup failed")
end subroutine open_temp

subroutine close_temp(error, nc)
  type(error_type), allocatable, intent(inout) :: error
  type(netcdf_type), intent(inout) :: nc
  type(model_error_type) :: err

  call close_netcdf(nc, err)
  if (allocated(error)) return
  call check(error, err%code == NC_NOERR, &
    & "Diskless NetCDF cleanup failed")
end subroutine close_temp

end module nc4f_test_utility
