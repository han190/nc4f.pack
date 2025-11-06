program main

use, non_intrinsic :: module_netcdf
implicit none

character(len=:), allocatable :: path
type(netcdf_type) :: nc
type(attribute_type), allocatable :: atts(:)
type(variable_type) :: vars(4)
logical, parameter :: unlimited = .true.

! path = "/Users/htang/Data/wrf/wrfout_d01_2016-08-14_12_00_00"
path = "/Users/Han/Data/WRF/wrfout_d01_2016-08-14_12_00_00"
nc = open_dataset(path, "r")
atts = get_attribute(nc)
vars = get_variable(nc, [character(len=10) :: "T", "XLONG", "XLAT", "XTIME"])
call close_dataset(nc)

print "(dt)", vars

nc = open_dataset("test.nc", "w")
call put_attribute(nc, atts)
call put_variable(nc, vars)
call close_dataset(nc)

end program main