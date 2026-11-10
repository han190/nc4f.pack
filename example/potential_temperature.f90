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

type(dimension_type) :: lat_dim, lon_dim
type(variable_type) :: lat, lon, tmp, pre
type(variable_type) :: T, P, theta
type(netcdf_type) :: nc
integer :: i, j

lon_vals = [(-165.0 + 30 * (i - 1), i=1, nlon)]
lat_vals = [(-75.0 + 25 * (j - 1), j=1, nlat)]

do concurrent (j=1:nlat, i=1:nlon)
  associate(phi => lat_vals(j) * PI / 180.0, &
    & lambda => lon_vals(i) * PI / 180.0)

    tmp_vals(i, j) = 273.15 + 18.0 * cos(phi) &
      & + 4.0 * sin(2.0 * lambda) * cos(phi)
    pre_vals(i, j) = P0 - 7000.0 * sin(phi)**2 &
      & + 600.0 * cos(3.0 * lambda) * cos(phi)
  end associate
end do

lat_dim = "latitude".dim.nlat
lon_dim = "longitude".dim.nlon

lat = datarray("latitude", lat_vals, [lat_dim], &
  & atts=["units".att."degrees_north", "long_name".att."Latitude"])
lon = datarray("longitude", lon_vals, [lon_dim], &
  & atts=["units".att."degrees_east", "long_name".att."Longitude"])
tmp = datarray("temperature", tmp_vals, [lon_dim, lat_dim], &
  & atts=["units".att."K", "long_name".att."Air temperature"])
pre = datarray("pressure", pre_vals, [lon_dim, lat_dim], &
  & atts=["units".att."Pa", "long_name".att."Air pressure"])

call to_netcdf(file, [lat, lon, tmp, pre], &
  & atts=["title".att."Synthetic potential temperature example"])

nc = open_netcdf(file, "r")
T = get_variable(nc, "temperature")
P = get_variable(nc, "pressure")
call close_netcdf(nc)

theta = T * (P0 / P)**(R / CP)
theta%name = "theta"
theta%atts = ["units".att."K", "long_name".att."Potential temperature"]

call to_netcdf(file, theta, mode="a")
print *, "Wrote to", file
print *, theta

end program potential_temperature_example
