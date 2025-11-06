program main

use, non_intrinsic :: module_netcdf
implicit none

character(len=:), allocatable :: path, varnames(:)
type(netcdf_type) :: nc
type(attribute_type), allocatable :: atts(:)
type(variable_type), allocatable :: vars(:)
logical, parameter :: unlimited = .true.

! path = "/Users/htang/Data/wrf/wrfout_d01_2016-08-14_12_00_00"
! path = "/Users/Han/Data/WRF/wrfout_d01_2016-08-14_12_00_00"
path = "/Users/Han/Data/ERA5/era5_4overview/era5_sngl_2025-08.nc"
nc = open_dataset(path, "r")
varnames = [character(len=50) :: "msl", &
	& "latitude", "longitude", "valid_time"]
allocate (vars(size(varnames)))
vars = inquire_variable(nc, varnames)
print "(dt)", vars
call close_dataset(nc)

! print "(dt)", vars

! nc = open_dataset("test.nc", "w")
! call put_attribute(nc, atts)
! call put_variable(nc, vars)
! call close_dataset(nc)

end program main