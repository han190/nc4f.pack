module nc4f_examples
use, non_intrinsic :: nc4f
implicit none (type, external)

public :: simple_wr, simple_rd
public :: sfc_pres_temp_wr
public :: sfc_pres_temp_rd
private

contains

!> Example: simple_wr
subroutine simple_wr(passed)
  logical, intent(inout) :: passed
  type(variable_type) :: var
  integer, parameter :: nx = 47, ny = 83
  real :: values(nx, ny)
  integer :: x, y
  character(len=1024) :: stdout

  do concurrent(y=1:ny, x=1:nx)
    values(x, y) = sqrt((x - 0.5*nx)**2 + (y - 0.5*ny)**2)
  end do
  var = data_array("data", values, ["x".dim.nx, "y".dim.ny])
  call to_netcdf("simple_wr.nc", var)
  write (stdout, "(dt)") var
  passed = trim(stdout) == "real(real32)::data (x:47, y:83)"
end subroutine simple_wr

!> Example: simple_rd
subroutine simple_rd(passed)
  logical, intent(inout) :: passed
  type(netcdf_type) :: nc
  type(variable_type) :: var
  integer, parameter :: nx = 47, ny = 83
  logical :: exist
  character(len=1024) :: stdout

  !> Check existence of a file.
  nc = open_dataset("file_that_does_not_exist.nc", exist=exist)
  passed = .not. exist
  if (.not. passed) return

  nc = open_dataset("simple_wr.nc", "r")
  var = inquire_variable(nc, "data", exist)
  write (stdout, "(dt)") var
  passed = var%name == "data" .and. &
         & all(var%dims == ["x".dim.nx, "y".dim.ny]) .and. &
         & trim(stdout) == "real(real32)::data (x:47, y:83)"
  call close_dataset(nc)
end subroutine simple_rd

!> Example: sfc_pres_temp_wr
subroutine sfc_pres_temp_wr(passed)
  logical, intent(inout) :: passed
  integer, parameter :: nlat = 181, nlon = 361
  real, parameter :: lat_max = 90.0, lon_max = 180.0
  real, allocatable :: pres(:, :), temp(:, :)
  real :: lats(nlat), lons(nlon)
  integer :: ilat, ilon
  type(variable_type) :: vars(4)

  allocate (pres(nlon, nlat), temp(nlon, nlat))
  do concurrent(ilon=1:nlon, ilat=1:nlat)
    lats(ilat) = lat_max - ilat + 1
    lons(ilon) = merge(ilon - lon_max*2 + 1, real(ilon), ilon > lon_max)
    pres(ilon, ilat) = 900.0 + 0.5*ilat - 0.5*ilon
    temp(ilon, ilat) = 9.0 + 0.5*ilat - 0.5*ilon
  end do

  associate ( &
    & lat_dim => "latitude".dim.nlat, &
    & lon_dim => "longitude".dim.nlon, &
    & degN => "units".att."degree_north", &
    & degE => "units".att."degree_east", &
    & degC => "units".att."celsius", &
    & hPa => "units".att."hPa")

    vars = [ &
           data_array("latitude", lats, [lat_dim], [degN]), &
           data_array("longitude", lons, [lon_dim], [degE]), &
           data_array("temperature", temp, [lon_dim, lat_dim], [degC]), &
           data_array("pressure", pres, [lon_dim, lat_dim], [hPa])]
  end associate
  call to_netcdf("sfc_pres_temp_wr.nc", vars)
  passed = .true.
end subroutine sfc_pres_temp_wr

!> Example sfc_pres_temp_rd
subroutine sfc_pres_temp_rd(passed)
  logical, intent(inout) :: passed
  type(netcdf_type) :: nc
  type(variable_type) :: var
  logical :: exist
  type(dimension_type) :: default_dims(2)
  integer, parameter :: nlat = 181, nlon = 361

  default_dims = ["longitude".dim.nlon, "latitude".dim.nlat]
  nc = open_dataset("sfc_pres_temp_wr.nc", "r")
  var = get_variable(nc, "pressure", exist)
  passed = all(var%dims == default_dims) .and. &
         & var%name == "pressure" .and. &
         & all(var%atts == ["units".att."hPa"])
  if (.not. passed) return

  var = get_variable(nc, "temperature", exist) - 273.15
  passed = all(var%dims == default_dims) .and. &
         & var%name == "temperature" .and. &
         & all(var%atts == ["units".att."celsius"])
  if (.not. passed) return

  var = inquire_variable(nc, "relative_humidity", exist)
  passed = .not. exist
end subroutine sfc_pres_temp_rd

end module nc4f_examples
