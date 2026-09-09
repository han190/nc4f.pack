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

  vars(1) = data_array("a", a, ["x".dim.2, "y".dim.3])
  vars(2) = data_array("b", b, ["x".dim.2, "y".dim.3])
  vars(3) = data_array("c", c, ["x".dim.2, "y".dim.3])
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
      & data_array("latitude", lats, [lat_dim], [degN]), &
      & data_array("longitude", lons, [lon_dim], [degE]), &
      & data_array("temperature", temp, [lon_dim, lat_dim], [degC]), &
      & data_array("pressure", pres, [lon_dim, lat_dim], [hPa])]
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
  if (failed(error)) then
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
  if (failed(error)) then
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
    & data_array("int8_rank1", int8_values, dims(:1), ["marker".att.(-7_int8)]), &
    & data_array("int16_rank2", int16_values, dims(:2), ["marker".att.(-15_int16)]), &
    & data_array("int32_rank3", int32_values, dims(:3), ["marker".att.350_int32]), &
    & data_array("int64_rank4", int64_values, dims(:4), ["marker".att.7500_int64]), &
    & data_array("real32_rank5", real32_values_5d, dims(:5), ["marker".att.1.25_real32]), &
    & data_array("real64_rank6", real64_values_6d, dims(:6), ["marker".att.2.5_real64]), &
    & data_array("real32_rank7", real32_values_7d, dims, ["description".att."rank-seven variable"])]
end function extensive_variables

function extensive_attributes() result(atts)
  type(attribute_type), allocatable :: atts(:)

  atts = [ &
    & "title".att."nc4f extensive round trip", &
    & "revision".att.7_int32, &
    & "scale".att.0.125_real64]
end function extensive_attributes

end submodule nc4f_test_cases_data
