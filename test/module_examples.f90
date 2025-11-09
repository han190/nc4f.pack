module module_examples
use, non_intrinsic :: module_netcdf
implicit none (type, external)

contains

subroutine simple_wr(passed)
  logical, intent(inout) :: passed
  !> Example: simple_wr
  type(variable_type) :: var
  integer, parameter :: nx = 47, ny = 83
  real :: values(nx, ny)
  integer :: x, y

  do concurrent(y=1:ny, x=1:nx)
    values(x, y) = sqrt((x - 0.5*nx)**2 + (y - 0.5*ny)**2)
  end do
  var = data_array("data", values, ["x".dim.nx, "y".dim.ny])
  call to_netcdf("simple_wr.nc", var)
  passed = .true.
end subroutine simple_wr

subroutine simple_rd(passed)
  logical, intent(inout) :: passed
  !> Example: simple_rd
  type(netcdf_type) :: nc
  type(variable_type) :: var
  integer, parameter :: nx = 47, ny = 83
  logical :: exist

  nc = open_dataset("simple_wr.nc", "r")
  var = inquire_variable(nc, "data", exist)
  passed = &
    var%dimensions(1)%name == "x" .and. &
    var%dimensions(1)%length == nx .and. &
    var%dimensions(2)%name == "y" .and. &
    var%dimensions(2)%length == ny
  call close_dataset(nc)
end subroutine simple_rd

subroutine sfc_pres_temp_wr(passed)
  logical, intent(inout) :: passed
  !> Example: sfc_pres_temp_wr
  integer, parameter :: nlat = 47, nlon = 360
  real :: pres(nlat, nlon), temp(nlat, nlon)
  real :: lats(nlat), lons(nlon)
  integer :: ilat, ilon
  type(variable_type) :: vars(4)

  do concurrent(ilon=1:nlon, ilat=1:nlat)
    lats(ilat) = 90.0 - ilat + 1
    lons(ilon) = merge(ilon - 360, ilon, ilon > 180)
    pres(ilat, ilon) = 900.0 + 0.5*ilat - 0.5*ilon
    temp(ilat, ilon) = 9.0 + 0.5*ilat - 0.5*ilon
  end do

  vars = [ &
    data_array("latitude", lats, &
      & ["latitude".dim.nlat], &
      & ["units".att."degree_north"]), &
    data_array("longitude", lons, &
      & ["longitude".dim.nlon], &
      & ["units".att."degree_east"]), &
    data_array("temperature", temp, &
      & ["latitude".dim.nlat, "longitude".dim.nlon], &
      & ["units".att."celsius"]), &
    data_array("pressure", pres, &
      & ["latitude".dim.nlat, "longitude".dim.nlon], &
      & ["units".att."hPa"])]
  call to_netcdf("sfc_pres_temp_wr.nc", vars)
  passed = .true.
end subroutine sfc_pres_temp_wr

end module module_examples