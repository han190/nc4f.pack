module module_examples
use, non_intrinsic :: module_netcdf
implicit none (type, external)

public :: simple_wr
public :: simple_rd
public :: sfc_pres_temp_wr
public :: sfc_pres_temp_rd
private

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
    var%dims(1)%name == "x" .and. &
    var%dims(1)%len == nx .and. &
    var%dims(2)%name == "y" .and. &
    var%dims(2)%len == ny
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

subroutine sfc_pres_temp_rd(passed)
  logical, intent(inout) :: passed
  !> Example sfc_pres_temp_rd
  type(netcdf_type) :: nc
  type(variable_type) :: var
  integer, parameter :: nx = 47, nlon = 360
  logical :: exist

  nc = open_dataset("sfc_pres_temp_wr.nc", "r")
  var = inquire_variable(nc, "pressure", exist)
  associate (dims => var%dims)
    passed = exist .and. &
      & dims(1)%name == "latitude" .and. &
      & dims(1)%len == 47 .and. &
      & dims(2)%name == "longitude" .and. &
      & dims(2)%len == 360
  end associate
  if (.not. passed) return

  var = inquire_variable(nc, "temperature", exist)
  associate (dims => var%dims)
    passed = exist .and. &
      & dims(1)%name == "latitude" .and. &
      & dims(1)%len == 47 .and. &
      & dims(2)%name == "longitude" .and. &
      & dims(2)%len == 360
  end associate
end subroutine sfc_pres_temp_rd

end module module_examples