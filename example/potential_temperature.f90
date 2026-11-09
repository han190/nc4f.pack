program potential_temperature_example

use, intrinsic :: iso_fortran_env, only: real32
use, non_intrinsic :: nc4f
implicit none (type, external)

integer, parameter :: nlon = 12, nlat = 7
! Reference pressure (Pa) and dry-air constants (J kg-1 K-1).
real, parameter :: P0 = 100000.0, R = 287.05, CP = 1004.0
real, parameter :: PI = acos(-1.0)
character(len=*), parameter :: file = "potential_temperature.nc"

real :: lat_vals(nlat), lon_vals(nlon)
real, dimension(nlon, nlat) :: tmp_vals, pre_vals, expected
real :: lat_rad, lon_rad
real, pointer :: theta_vals(:, :)

type(dimension_type) :: grid_dims(2)
type(variable_type) :: lat, lon, tmp, pre
type(variable_type) :: T, P, theta
type(netcdf_type) :: nc
integer :: i, j

do j = 1, nlat
  lat_vals(j) = -75.0 + 25.0 * (j - 1)
end do
do i = 1, nlon
  lon_vals(i) = -165.0 + 30.0 * (i - 1)
end do

do j = 1, nlat
  lat_rad = lat_vals(j) * PI / 180.0
  do i = 1, nlon
    lon_rad = lon_vals(i) * PI / 180.0
    tmp_vals(i, j) = 273.15 + 18.0 * cos(lat_rad) &
      & + 4.0 * sin(2.0 * lon_rad) * cos(lat_rad) &
      & - 0.05 * abs(lat_vals(j))
    pre_vals(i, j) = P0 - 7000.0 * sin(lat_rad)**2 &
      & + 600.0 * cos(3.0 * lon_rad) * cos(lat_rad)
  end do
end do

grid_dims = ["longitude".dim.nlon, "latitude".dim.nlat]
lat = datarray("latitude", lat_vals, ["latitude".dim.nlat], &
  & atts=["units".att."degrees_north", "long_name".att."Latitude"])
lon = datarray( &
  & "longitude", lon_vals, ["longitude".dim.nlon], &
  & atts=["units".att."degrees_east", "long_name".att."Longitude"])
tmp = datarray( &
  & "temperature", tmp_vals, grid_dims, &
  & atts=["units".att."K", "long_name".att."Synthetic air temperature"])
pre = datarray( &
  & "pressure", pre_vals, grid_dims, &
  & atts=["units".att."Pa", "long_name".att."Synthetic air pressure"])

call to_netcdf(file, [lat, lon, tmp, pre], &
  & atts=["title".att."Synthetic potential temperature example"])

nc = open_netcdf(file, "r")
T = get_variable(nc, "temperature")
P = get_variable(nc, "pressure")
call close_netcdf(nc)

theta = T * (P0 / P) ** (R / CP)
theta%name = "theta"
theta%atts = ["units".att."K", "long_name".att."Potential temperature"]

call to_netcdf(file, theta, mode="a")
print *, "Wrote to", file
print *, theta

end program potential_temperature_example
