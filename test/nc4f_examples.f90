module nc4f_examples
use, intrinsic :: iso_fortran_env, only: &
  & int8, int16, int32, int64, real32, real64
use, non_intrinsic :: nc4f
implicit none (type, external)

public :: simple_wr, simple_rd
public :: hyperslab_rd, unlimited_wr
public :: sum_vars_test
public :: error_handling
public :: sfc_pres_temp_wr
public :: sfc_pres_temp_rd
public :: buffer_edges
public :: extensive_wr, extensive_rd
private

character(*), parameter :: TEST_RESULTS_DIR = "build/test-results/"

contains

!> Element-wise summation materializes one output buffer.
subroutine sum_vars_test(passed)
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

  passed = all(abs(actual - b) <= epsilon(b)) .and. &
    & all(result%dims == vars(1)%dims)
end subroutine sum_vars_test

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
  call to_netcdf(TEST_RESULTS_DIR//"simple_wr.nc", var)
  write (stdout, "(dt)") var
  passed = trim(stdout) == "real(real32)::data (x:47, y:83)"
end subroutine simple_wr

!> Example: simple_rd
subroutine simple_rd(passed)
  logical, intent(inout) :: passed
  type(netcdf_type) :: nc
  type(variable_type) :: var
  integer, parameter :: nx = 47, ny = 83
  type(error_type) :: error
  character(len=1024) :: stdout

  !> Check a missing file without terminating the caller.
  nc = open_dataset(TEST_RESULTS_DIR//"file_that_does_not_exist.nc", error=error)
  passed = failed(error) .and. .not. found(error)
  if (.not. passed) return

  nc = open_dataset(TEST_RESULTS_DIR//"simple_wr.nc", "r")
  var = inquire_variable(nc, "data", error)
  if (failed(error)) then
    call close_dataset(nc)
    passed = .false.
    return
  end if
  write (stdout, "(dt)") var
  passed = var%name == "data" .and. &
         & all(var%dims == ["x".dim.nx, "y".dim.ny]) .and. &
         & trim(stdout) == "real(real32)::data (x:47, y:83)"
  call close_dataset(nc)
end subroutine simple_rd

!> Exercise recoverable NetCDF errors and their functional predicates.
subroutine error_handling(passed)
  logical, intent(inout) :: passed
  real, parameter :: values(1) = [42.0]
  character(len=1024) :: stdout
  integer :: io_stat
  type(attribute_type) :: att
  type(error_type) :: error
  type(netcdf_type) :: nc
  type(variable_type) :: present, var

  passed = .false.
  error = error_type(NC_ENOTVAR, "constructed error")
  if (.not. (failed(error) .and. .not. found(error) .and. &
    & allocated(error%message))) return
  error = error_type()
  if (failed(error)) return

  nc = open_dataset(TEST_RESULTS_DIR//"unused.nc", "invalid", error=error)
  if (.not. (failed(error) .and. error%code == NC_EINVAL)) return

  nc = open_dataset(TEST_RESULTS_DIR//"missing-error-fixture/no-file.nc", error=error)
  if (.not. (failed(error) .and. .not. found(error) .and. &
    & error%code /= NC_NOERR .and. allocated(error%message))) return
  write (stdout, "(dt)", iostat=io_stat) error
  if (io_stat /= 0 .or. len_trim(stdout) == 0) return

  present = data_array("present", values, ["x".dim.1], ["units".att."1"])
  call to_netcdf(TEST_RESULTS_DIR//"error-handling.nc", present, error=error)
  if (failed(error)) return
  nc = open_dataset(TEST_RESULTS_DIR//"error-handling.nc", "r", error=error)
  if (failed(error)) return

  var = inquire_variable(nc, "missing", error)
  if (found(error) .or. error%code /= NC_ENOTVAR) then
    call close_dataset(nc)
    return
  end if
  var = get_variable(nc, "missing", error)
  if (found(error) .or. error%code /= NC_ENOTVAR) then
    call close_dataset(nc)
    return
  end if
  var = get_variable(nc, "present", error)
  if (failed(error)) then
    call close_dataset(nc)
    return
  end if

  att = get_attribute(nc, "missing_global", error)
  if (found(error) .or. error%code /= NC_ENOTATT) then
    call close_dataset(nc)
    return
  end if
  att = get_attribute(nc, var, "missing", error)
  if (found(error) .or. error%code /= NC_ENOTATT) then
    call close_dataset(nc)
    return
  end if

  var = get_variable(nc, "present", [2], [1], error)
  if (.not. (failed(error) .and. found(error) .and. &
    & error%code == NC_EEDGE)) then
    call close_dataset(nc)
    return
  end if
  var = get_variable(nc, "present", [0], [1], error)
  if (.not. (failed(error) .and. error%code == NC_EINVALCOORDS)) then
    call close_dataset(nc)
    return
  end if
  call close_dataset(nc, error)
  passed = .not. failed(error)
end subroutine error_handling

!> Read and persist a selected Fortran-order hyperslab.
subroutine hyperslab_rd(passed)
  logical, intent(inout) :: passed
  integer, parameter :: nx = 47, ny = 83
  real :: expected(3, 2)
  real, pointer :: values(:, :)
  type(netcdf_type) :: nc
  type(variable_type) :: actual, round_trip
  integer :: x, y

  nc = open_dataset(TEST_RESULTS_DIR//"simple_wr.nc", "r")
  actual = get_variable(nc, "data", [4, 6], [3, 2])
  call close_dataset(nc)
  call extract(actual, values)

  do concurrent(y=1:2, x=1:3)
    expected(x, y) = sqrt((x + 3 - 0.5*nx)**2 + (y + 5 - 0.5*ny)**2)
  end do
  passed = all(actual%dims == ["x".dim.3, "y".dim.2]) .and. &
    & all(abs(values - expected) <= epsilon(expected))
  if (.not. passed) return

  call to_netcdf(TEST_RESULTS_DIR//"hyperslab.nc", actual)
  nc = open_dataset(TEST_RESULTS_DIR//"hyperslab.nc", "r")
  round_trip = get_variable(nc, "data")
  call close_dataset(nc)
  passed = round_trip == actual
end subroutine hyperslab_rd

!> Writing with an unlimited dimension must extend it to the buffer extent.
subroutine unlimited_wr(passed)
  logical, intent(inout) :: passed
  integer(int32), parameter :: values(2, 3) = reshape([ &
    & 1_int32, 2_int32, 3_int32, 4_int32, 5_int32, 6_int32], [2, 3])
  integer(int32), pointer :: actual_values(:, :)
  type(netcdf_type) :: nc
  type(variable_type) :: actual, var

  var = data_array("records", values, ["x".dim.2, "time".dim.3])
  var%dims(2)%is_unlim = .true.
  call to_netcdf(TEST_RESULTS_DIR//"unlimited.nc", var)

  nc = open_dataset(TEST_RESULTS_DIR//"unlimited.nc", "r")
  actual = get_variable(nc, "records")
  call close_dataset(nc)
  call extract(actual, actual_values)
  passed = actual%dims(2)%is_unlim .and. &
    & all(actual%dims == var%dims) .and. all(actual_values == values)
end subroutine unlimited_wr

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
  call to_netcdf(TEST_RESULTS_DIR//"sfc_pres_temp_wr.nc", vars)
  passed = .true.
end subroutine sfc_pres_temp_wr

!> Example sfc_pres_temp_rd
subroutine sfc_pres_temp_rd(passed)
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
  passed = all(var%dims == default_dims) .and. &
         & var%name == "pressure" .and. &
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
  passed = all(var%dims == default_dims) .and. &
         & var%name == "temperature" .and. &
         & var%atts(1)%name == "units" .and. units == "celsius"
  if (.not. passed) then
    call close_dataset(nc)
    return
  end if

  var = inquire_variable(nc, "relative_humidity", error)
  passed = .not. found(error) .and. error%code == NC_ENOTVAR
  call close_dataset(nc)
end subroutine sfc_pres_temp_rd

!> Exercise character extraction and boundary-length netCDF names.
subroutine buffer_edges(passed)
  logical, intent(inout) :: passed
  character(len=256) :: dim_name, att_name, var_name
  character(len=:), pointer :: text
  real, parameter :: values(2) = [1.0, 2.0]
  real, pointer :: read_values(:)
  type(attribute_type) :: empty_att
  type(variable_type) :: var
  type(netcdf_type) :: nc

  empty_att = "empty".att.""
  call extract(empty_att, text)
  passed = associated(text) .and. len(text) == 0
  if (associated(text)) deallocate (text)
  if (.not. passed) return

  dim_name = repeat("d", len(dim_name) - 1)
  att_name = repeat("a", len(att_name) - 1)
  var_name = repeat("v", len(var_name) - 1)
  var = data_array(var_name, values, [dim_name.dim.2], &
    & [att_name.att."maximum-length name"])
  call to_netcdf(TEST_RESULTS_DIR//"buffer_edges.nc", var)

  nc = open_dataset(TEST_RESULTS_DIR//"buffer_edges.nc", "r", inq_dims=.true.)
  var = get_variable(nc, var_name)
  call extract(var, read_values)
  passed = var%name == var_name .and. &
    & nc%dims(1)%name == dim_name .and. &
    & var%dims(1)%name == dim_name .and. &
    & var%atts(1)%name == att_name .and. &
    & all(abs(read_values - values) <= epsilon(values))
  call close_dataset(nc)
end subroutine buffer_edges

!> Write all supported numeric types across ranks one through seven.
subroutine extensive_wr(passed)
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

!> Read the extensive dataset and compare all metadata and raw values.
subroutine extensive_rd(passed)
  logical, intent(inout) :: passed
  character(len=16), parameter :: names(7) = [character(len=16) :: &
    & "int8_rank1", "int16_rank2", "int32_rank3", "int64_rank4", &
    & "real32_rank5", "real64_rank6", "real32_rank7"]
  type(variable_type), allocatable :: actual(:), expected(:)
  type(attribute_type), allocatable :: expected_atts(:)
  type(netcdf_type) :: nc
  logical :: found
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
      found = .false.
      do j = 1, size(nc%dims)
        if (nc%dims(j) == expected(7)%dims(i)) then
          found = .true.
          exit
        end if
      end do
      if (.not. found) then
        passed = .false.
        exit
      end if
    end do
  end if
  call close_dataset(nc)
end subroutine extensive_rd

!> Construct the variables shared by the extensive write/read tests.
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
  int16_values = reshape( &
    & [(int(10*i - 25, int16), i=1, size(int16_values))], &
    & shape(int16_values))
  int32_values = reshape( &
    & [(int(100*i - 450, int32), i=1, size(int32_values))], &
    & shape(int32_values))
  int64_values = reshape( &
    & [(int(1000*i - 8500, int64), i=1, size(int64_values))], &
    & shape(int64_values))
  real32_values_5d = reshape( &
    & [(real(i - 17, real32)/3.0_real32, i=1, size(real32_values_5d))], &
    & shape(real32_values_5d))
  real64_values_6d = reshape( &
    & [(real(i - 33, real64)/7.0_real64, i=1, size(real64_values_6d))], &
    & shape(real64_values_6d))
  real32_values_7d = reshape( &
    & [(real(i - 65, real32)/11.0_real32, i=1, size(real32_values_7d))], &
    & shape(real32_values_7d))

  vars = [ &
    & data_array("int8_rank1", int8_values, dims(:1), &
      & ["marker".att.(-7_int8)]), &
    & data_array("int16_rank2", int16_values, dims(:2), &
      & ["marker".att.(-15_int16)]), &
    & data_array("int32_rank3", int32_values, dims(:3), &
      & ["marker".att.350_int32]), &
    & data_array("int64_rank4", int64_values, dims(:4), &
      & ["marker".att.7500_int64]), &
    & data_array("real32_rank5", real32_values_5d, dims(:5), &
      & ["marker".att.1.25_real32]), &
    & data_array("real64_rank6", real64_values_6d, dims(:6), &
      & ["marker".att.2.5_real64]), &
    & data_array("real32_rank7", real32_values_7d, dims, &
      & ["description".att."rank-seven variable"])]
end function extensive_variables

!> Construct global attributes shared by the extensive tests.
function extensive_attributes() result(atts)
  type(attribute_type), allocatable :: atts(:)

  atts = [ &
    & "title".att."nc4f extensive round trip", &
    & "revision".att.7_int32, &
    & "scale".att.0.125_real64]
end function extensive_attributes

end module nc4f_examples
