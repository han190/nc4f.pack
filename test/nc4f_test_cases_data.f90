submodule(nc4f_test_cases) nc4f_test_cases_data

implicit none (type, external)

contains

module subroutine sum_vars_test(passed)
  !> Input/output argument(s): `passed`.
  logical, intent(inout) :: passed
  real(real64), parameter :: a(2, 3) = reshape([ &
    & 1.0_real64, 2.0_real64, 3.0_real64, 4.0_real64, 5.0_real64, 6.0_real64], [2, 3])
  real(real64), parameter :: b(2, 3) = reshape([ &
    & 10.0_real64, 20.0_real64, 30.0_real64, 40.0_real64, 50.0_real64, 60.0_real64], [2, 3])
  real(real64), parameter :: c(2, 3) = -a
  real(real64), pointer :: actual(:, :)
  type(variable_type) :: result, vars(3)

  vars(1) = datarray("a", a, ["x".dim.2, "y".dim.3])
  vars(2) = datarray("b", b, ["x".dim.2, "y".dim.3])
  vars(3) = datarray("c", c, ["x".dim.2, "y".dim.3])
  result = sum(vars)
  call extract(result, actual)

  passed = all(abs(actual - b) <= epsilon(b)) .and. all(result%dims == vars(1)%dims)
end subroutine sum_vars_test

module subroutine sfc_pres_temp_wr(passed)
  !> Input/output argument(s): `passed`.
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
      & datarray("latitude", lats, [lat_dim], [degN]), &
      & datarray("longitude", lons, [lon_dim], [degE]), &
      & datarray("temperature", temp, [lon_dim, lat_dim], [degC]), &
      & datarray("pressure", pres, [lon_dim, lat_dim], [hPa])]
  end associate
  call to_netcdf(TEST_RESULTS_DIR//"sfc_pres_temp_wr.nc", vars)
  passed = .true.
end subroutine sfc_pres_temp_wr

module subroutine sfc_pres_temp_rd(passed)
  !> Input/output argument(s): `passed`.
  logical, intent(inout) :: passed
  type(netcdf_type) :: nc
  type(variable_type) :: var
  type(error_type) :: error
  character(len=:), pointer :: units
  type(dimension_type) :: default_dims(2)
  integer, parameter :: nlat = 181, nlon = 361

  default_dims = ["longitude".dim.nlon, "latitude".dim.nlat]
  nc = open_dataset(TEST_RESULTS_DIR//"sfc_pres_temp_wr.nc", "r")
  var = get_variable(nc, "pressure", error)
  if ((error%code /= NC_NOERR)) then
    call close_dataset(nc)
    passed = .false.
    return
  end if
  passed = all(var%dims == default_dims) .and. var%name == "pressure" .and. &
    & all(var%atts == ["units".att."hPa"])
  if (.not. passed) then
    call close_dataset(nc)
    return
  end if

  var = get_variable(nc, "temperature", error)
  if ((error%code /= NC_NOERR)) then
    call close_dataset(nc)
    passed = .false.
    return
  end if
  call extract(var%atts(1), units)
  passed = all(var%dims == default_dims) .and. var%name == "temperature" .and. &
    & var%atts(1)%name == "units" .and. units == "celsius"
  if (.not. passed) then
    call close_dataset(nc)
    return
  end if

  var = inquire_variable(nc, "relative_humidity", error)
  passed = .not. found(error) .and. error%code == NC_ENOTVAR
  call close_dataset(nc)
end subroutine sfc_pres_temp_rd

module subroutine extensive_wr(passed)
  !> Input/output argument(s): `passed`.
  logical, intent(inout) :: passed
  type(variable_type), allocatable :: vars(:)
  logical :: file_exists
  integer(int64) :: file_size

  vars = extensive_variables()
  call to_netcdf(TEST_RESULTS_DIR//"extensive.nc", vars, extensive_attributes())
  inquire (file=TEST_RESULTS_DIR//"extensive.nc", exist=file_exists, size=file_size)
  passed = file_exists
  if (passed) passed = file_size > 0
end subroutine extensive_wr

module subroutine extensive_rd(passed)
  !> Input/output argument(s): `passed`.
  logical, intent(inout) :: passed
  character(len=16), parameter :: names(7) = [character(len=16) :: &
    & "int8_rank1", "int16_rank2", "int32_rank3", "int64_rank4", &
    & "real32_rank5", "real64_rank6", "real32_rank7"]
  type(variable_type), allocatable :: actual(:), expected(:)
  type(attribute_type), allocatable :: expected_atts(:)
  type(netcdf_type) :: nc
  logical :: is_found
  integer :: i, j

  expected = extensive_variables()
  expected_atts = extensive_attributes()
  nc = open_dataset(TEST_RESULTS_DIR//"extensive.nc", "r", inq_dims=.true., inq_atts=.true.)
  actual = get_variable(nc, names)

  passed = size(actual) == size(expected)
  if (passed) passed = all(actual == expected)
  if (passed) passed = allocated(nc%atts)
  if (passed) passed = size(nc%atts) == size(expected_atts)
  if (passed) passed = all(nc%atts == expected_atts)
  if (passed) passed = allocated(nc%dims)
  if (passed) passed = size(nc%dims) == size(expected(7)%dims)

  if (passed) then
    do i = 1, size(expected(7)%dims)
      is_found = .false.
      do j = 1, size(nc%dims)
        if (nc%dims(j) == expected(7)%dims(i)) then
          is_found = .true.
          exit
        end if
      end do
      if (.not. is_found) then
        passed = .false.
        exit
      end if
    end do
  end if
  call close_dataset(nc)
end subroutine extensive_rd

!> Read root-level data and metadata from NASA's externally produced
!> CLDPROP COSP NetCDF-4 sample file.  The file also contains nested groups;
!> this test intentionally exercises the currently supported root group only.
module subroutine nasa_cosp_read(passed)
  !> Input/output argument(s): `passed`.
  logical, intent(inout) :: passed
  character(*), parameter :: SAMPLE_FILE = &
    & "data/CLDPROPCOSP_M3_MODIS_Aqua.A2014032.011.2020112203433.nc"
  character(len=:), pointer :: yaml
  real(real64), pointer :: latitude(:), longitude(:)
  type(attribute_type) :: units, yaml_config
  type(error_type) :: error
  type(group_type), allocatable :: grps(:)
  type(group_type) :: root, solar_zenith
  type(netcdf_type), target :: nc
  type(variable_type) :: latitude_var, longitude_var
  class(group_type), pointer :: nc_group
  integer :: file_unit, io_stat
  logical :: is_open, output_open

  passed = .false.
  is_open = .false.
  output_open = .false.
  nullify (yaml)
  nc = open_dataset(SAMPLE_FILE, "r", error=error)
  if ((error%code /= NC_NOERR)) return
  is_open = .true.

  nasa_read: block
    grps = inquire_groups(nc, error)
    if ((error%code /= NC_NOERR)) exit nasa_read
    root = inquire_group(nc, inq_dims=.true., inq_atts=.true., inq_vars=.true., &
      & inq_grps=.true., recursive=.true., error=error)
    if ((error%code /= NC_NOERR)) exit nasa_read
    nc%dims = root%dims
    nc%atts = root%atts
    nc%vars = root%vars
    if (associated(root%grps)) then
      allocate (nc%grps(size(root%grps)))
      nc%grps = root%grps
    end if
    nc_group => nc

    open (newunit=file_unit, file=NETCDF_TYPE_RESULT_FILE, status="replace", &
      & action="write", iostat=io_stat)
    if (io_stat /= 0) exit nasa_read
    output_open = .true.
    write (file_unit, "(dt)", iostat=io_stat) nc_group
    close (file_unit, iostat=io_stat)
    output_open = .false.
    if (io_stat /= 0) exit nasa_read

    solar_zenith = get_group(nc, "Solar_Zenith", error)
    if ((error%code /= NC_NOERR)) exit nasa_read
    solar_zenith = inquire_group(solar_zenith, inq_dims=.true., inq_atts=.true., &
      & inq_vars=.true., inq_grps=.true., error=error)
    if ((error%code /= NC_NOERR)) exit nasa_read

    latitude_var = get_variable(nc, "latitude", error)
    if ((error%code /= NC_NOERR)) exit nasa_read
    longitude_var = get_variable(nc, "longitude", error)
    if ((error%code /= NC_NOERR)) exit nasa_read
    units = get_attribute(nc, latitude_var, "units", error)
    if ((error%code /= NC_NOERR)) exit nasa_read
    yaml_config = get_attribute(nc, "YAML_config", error)
    if ((error%code /= NC_NOERR)) exit nasa_read

    call extract(latitude_var, latitude)
    call extract(longitude_var, longitude)
    call extract(units, yaml)
    if (associated(yaml)) then
      nullify (yaml)
    end if
    call extract(yaml_config, yaml)
    if (.not. associated(yaml)) exit nasa_read
    if (len(yaml) <= 1024) exit nasa_read

    passed = size(nc%dims) == 9 .and. size(grps) == 23 .and. &
      & grps(1)%name == "Solar_Zenith" .and. solar_zenith%name == "Solar_Zenith" .and. &
      & size(solar_zenith%dims) == 0 .and. size(solar_zenith%atts) == 7 .and. &
      & size(solar_zenith%vars) == 5 .and. associated(solar_zenith%grps) .and. &
      & size(solar_zenith%grps) == 0 .and. &
      & size(latitude) == 180 .and. size(longitude) == 360 .and. &
      & latitude_var%dims(1)%name == "latitude" .and. &
      & longitude_var%dims(1)%name == "longitude" .and. &
      & abs(latitude(1) + 89.5_real64) <= epsilon(latitude(1)) .and. &
      & abs(latitude(180) - 89.5_real64) <= epsilon(latitude(180)) .and. &
      & abs(longitude(1) + 179.5_real64) <= epsilon(longitude(1)) .and. &
      & abs(longitude(360) - 179.5_real64) <= epsilon(longitude(360)) .and. &
      & yaml(:14) == "grid_settings:"
  end block nasa_read

  if (output_open) close (file_unit)
  if (associated(yaml)) nullify (yaml)
  if (is_open) then
    call close_dataset(nc, error)
    if ((error%code /= NC_NOERR)) passed = .false.
  end if
end subroutine nasa_cosp_read

!> Read coordinates, CF metadata, and packed data from Unidata's externally
!> produced ECMWF ERA-40 sample file.
module subroutine ecmwf_era40_read(passed)
  !> Input/output argument(s): `passed`.
  logical, intent(inout) :: passed
  character(*), parameter :: SAMPLE_FILE = "data/ECMWF_ERA-40_subset.nc"
  character(len=:), pointer :: conventions, longitude_units, temperature_units
  integer(int16), pointer :: temperature(:, :, :)
  real(real32), pointer :: latitude(:), longitude(:)
  type(attribute_type) :: conventions_att, longitude_units_att, temperature_units_att
  type(error_type) :: error
  type(netcdf_type) :: nc
  type(variable_type) :: latitude_var, longitude_var, temperature_var
  logical :: is_open

  passed = .false.
  is_open = .false.
  nullify (conventions, longitude_units, temperature_units, temperature, latitude, longitude)
  nc = open_dataset(SAMPLE_FILE, "r", inq_dims=.true., error=error)
  if ((error%code /= NC_NOERR)) return
  is_open = .true.

  era40_read: block
    latitude_var = get_variable(nc, "latitude", error)
    if ((error%code /= NC_NOERR)) exit era40_read
    longitude_var = get_variable(nc, "longitude", error)
    if ((error%code /= NC_NOERR)) exit era40_read
    temperature_var = get_variable(nc, "p2t", [1, 1, 1], [4, 3, 2], error)
    if ((error%code /= NC_NOERR)) exit era40_read
    conventions_att = get_attribute(nc, "Conventions", error)
    if ((error%code /= NC_NOERR)) exit era40_read
    longitude_units_att = get_attribute(nc, longitude_var, "units", error)
    if ((error%code /= NC_NOERR)) exit era40_read
    temperature_units_att = get_attribute(nc, temperature_var, "units", error)
    if ((error%code /= NC_NOERR)) exit era40_read

    call extract(latitude_var, latitude)
    call extract(longitude_var, longitude)
    call extract(temperature_var, temperature)
    call extract(conventions_att, conventions)
    call extract(longitude_units_att, longitude_units)
    call extract(temperature_units_att, temperature_units)
    if (.not. associated(conventions) .or. .not. associated(longitude_units) .or. &
      & .not. associated(temperature_units) .or. .not. associated(temperature) .or. &
      & .not. associated(latitude) .or. .not. associated(longitude)) exit era40_read

    passed = size(nc%dims) == 3 .and. &
      & size(latitude) == 73 .and. size(longitude) == 144 .and. &
      & all(shape(temperature) == [4, 3, 2]) .and. &
      & latitude_var%dims(1)%name == "latitude" .and. &
      & longitude_var%dims(1)%name == "longitude" .and. &
      & temperature_var%dims(1)%name == "longitude" .and. &
      & temperature_var%dims(2)%name == "latitude" .and. &
      & temperature_var%dims(3)%name == "time" .and. &
      & abs(latitude(1) - 90.0_real32) <= epsilon(latitude(1)) .and. &
      & abs(latitude(73) + 90.0_real32) <= epsilon(latitude(73)) .and. &
      & abs(longitude(1)) <= epsilon(longitude(1)) .and. &
      & abs(longitude(144) - 357.5_real32) <= epsilon(longitude(144)) .and. &
      & conventions == "CF-1.0" .and. longitude_units == "degrees_east" .and. &
      & temperature_units == "K" .and. any(temperature /= -32767_int16)
  end block era40_read

  if (associated(conventions)) deallocate (conventions)
  if (associated(longitude_units)) deallocate (longitude_units)
  if (associated(temperature_units)) deallocate (temperature_units)
  if (is_open) then
    call close_dataset(nc, error)
    if ((error%code /= NC_NOERR)) passed = .false.
  end if
end subroutine ecmwf_era40_read

function extensive_variables() result(vars)
  type(variable_type), allocatable :: vars(:)
  type(dimension_type) :: dims(7)
  integer(int8) :: int8_values(2)
  integer(int16) :: int16_values(2, 2)
  integer(int32) :: int32_values(2, 2, 2)
  integer(int64) :: int64_values(2, 2, 2, 2)
  real(real32) :: real32_values_5d(2, 2, 2, 2, 2)
  real(real64) :: real64_values_6d(2, 2, 2, 2, 2, 2)
  real(real32) :: real32_values_7d(2, 2, 2, 2, 2, 2, 2)
  integer :: i

  dims = ["d1".dim.2, "d2".dim.2, "d3".dim.2, "d4".dim.2, &
    & "d5".dim.2, "d6".dim.2, "d7".dim.2]
  int8_values = [-7_int8, 12_int8]
  int16_values = reshape([(int(10*i - 25, int16), i=1, size(int16_values))], shape(int16_values))
  int32_values = reshape([(int(100*i - 450, int32), i=1, size(int32_values))], shape(int32_values))
  int64_values = reshape([(int(1000*i - 8500, int64), i=1, size(int64_values))], shape(int64_values))
  real32_values_5d = reshape([(real(i - 17, real32)/3.0_real32, i=1, size(real32_values_5d))], &
    & shape(real32_values_5d))
  real64_values_6d = reshape([(real(i - 33, real64)/7.0_real64, i=1, size(real64_values_6d))], &
    & shape(real64_values_6d))
  real32_values_7d = reshape([(real(i - 65, real32)/11.0_real32, i=1, size(real32_values_7d))], &
    & shape(real32_values_7d))

  vars = [ &
    & datarray("int8_rank1", int8_values, dims(:1), ["marker".att.(-7_int8)]), &
    & datarray("int16_rank2", int16_values, dims(:2), ["marker".att.(-15_int16)]), &
    & datarray("int32_rank3", int32_values, dims(:3), ["marker".att.350_int32]), &
    & datarray("int64_rank4", int64_values, dims(:4), ["marker".att.7500_int64]), &
    & datarray("real32_rank5", real32_values_5d, dims(:5), ["marker".att.1.25_real32]), &
    & datarray("real64_rank6", real64_values_6d, dims(:6), ["marker".att.2.5_real64]), &
    & datarray("real32_rank7", real32_values_7d, dims, ["description".att."rank-seven variable"])]
end function extensive_variables

function extensive_attributes() result(atts)
  type(attribute_type), allocatable :: atts(:)

  atts = [ &
    & "title".att."nc4f extensive round trip", &
    & "revision".att.7_int32, &
    & "scale".att.0.125_real64]
end function extensive_attributes

end submodule nc4f_test_cases_data
