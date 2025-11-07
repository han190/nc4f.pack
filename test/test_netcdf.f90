program main

use, non_intrinsic :: module_netcdf
implicit none

character(len=:), allocatable :: path
type(netcdf_type) :: nc
type(variable_type) :: T, P, coords(3)
real, parameter :: R = 287.0, CP = 1004.0
integer, parameter :: T0 = 300, P0 = 1000 * 100

path = "/Users/Han/Data/WRF/wrfout_d01_2016-08-14_12_00_00"
nc = open_dataset(path, "r")
T = get_variable(nc, "T")
P = sum(get_variable(nc, ["P ", "PB"]))
T = (T + T0)*(P0/P)**(R/CP)
coords = get_variable(nc, ["XLONG", "XLAT ", "XTIME"])
call close_dataset(nc)

nc = open_dataset("test.nc", "w")
call put_variable(nc, [T, coords])
call close_dataset(nc)

end program main
