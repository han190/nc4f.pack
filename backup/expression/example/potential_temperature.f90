program potential_temperature_example

use, intrinsic :: iso_fortran_env, only: real32
use, non_intrinsic :: nc4f
implicit none (type, external)

integer, parameter :: nlon = 83, nlat = 47
! Reference pressure (Pa) and dry-air constants (J kg-1 K-1).
real, parameter :: P0 = 100000.0, R = 287.05, CP = 1004.0, TM = 273.15
real, parameter :: PI = acos(-1.0)
character(len=*), parameter :: file = "potential_temperature.nc"

real :: lat_vals(nlat), lon_vals(nlon)
real, dimension(nlon, nlat) :: tmp_vals, pre_vals

type(dimension_type) :: lat_dim, lon_dim
type(coordinate_type) :: lat, lon
type(variable_type) :: tmp, pre
type(variable_type), target :: T, P
type(variable_type) :: theta
type(netcdf_type) :: nc
integer :: i, j

lon_vals = [(-180.0 + (i - 1) * 360.0 / nlon, i=1, nlon)]
lat_vals = [(-90.0 + (j - 1) * 180.0 / (nlat - 1), j=1, nlat)]

do concurrent (j=1:nlat, i=1:nlon)
  associate(phi => lat_vals(j) * PI / 180.0, &
    & lambda => lon_vals(i) * PI / 180.0)

    tmp_vals(i, j) = TM + sin(2.0 * lambda) * cos(phi) * 4.0
    pre_vals(i, j) = P0 + cos(3.0 * lambda) * cos(phi) * 600.0
  end associate
end do

! Dimensions
lat_dim = "latitude".dim.nlat
lon_dim = "longitude".dim.nlon

! Coordinate
lat = coordinate_type("latitude", lat_vals, [lat_dim], &
  & atts=["units".att."degrees_north", &
  & "standard_name".att."latitude", "axis".att."Y"])
lon = coordinate_type("longitude", lon_vals, [lon_dim], &
  & atts=["units".att."degrees_east", &
  & "standard_name".att."longitude", "axis".att."X"])

! Variables
tmp = datarray("temperature", tmp_vals, &
  & dims=[lon_dim, lat_dim], coords=[lon, lat], &
  & atts=["units".att."K", "long_name".att."Air temperature"])
pre = datarray("pressure", pre_vals, &
  & dims=[lon_dim, lat_dim], coords=[lon, lat], &
  & atts=["units".att."Pa", "long_name".att."Air pressure"])

! Write to netcdf
call to_netcdf(file, [tmp, pre], &
  & atts=["title".att."Synthetic potential temperature example"])

! Read from netcdf
nc = open_netcdf(file, "r")
T = get_variable(nc, "temperature")
P = get_variable(nc, "pressure")
call close_netcdf(nc)
if (.not. allocated(T%coords) .or. .not. allocated(P%coords)) then
  error stop "Coordinate round trip failed."
end if

! Append to netcdf
theta = T*(P0/P)**(R/CP)
theta%name = "theta"
theta%atts = ["units".att."K", "long_name".att."Potential temperature"]
print *, theta
call to_netcdf(file, theta, mode="a")

end program potential_temperature_example
