submodule(nc4f_test_data) nc4f_test_data_coordinate
use, intrinsic :: iso_fortran_env, only: &
  & int8, int16, int32, int64, real32, real64
use, non_intrinsic :: testdrive, only: check, error_type, &
  & new_unittest, unittest_type
use, non_intrinsic :: nc4f, only: coordinate_type, variable_type, &
  & coordinate_at, coordinate_index, datarray, &
  & extract, validate, rename_dimension, nameof, typeof, size, shape, &
  & operator(.att.), operator(.dim.), &
  & operator(==), &
  & NC_NOERR, NC_EINVAL, NC_FLOAT
implicit none (type, external)
contains

module subroutine collect_data_coordinate(tests)
  type(unittest_type), allocatable, intent(out) :: tests(:)
  tests = [ &
    & new_unittest("time, lon, and lat coordinates", test_mapping), &
    & new_unittest("integer coordinate kinds", test_integer_kinds) &
    & ]
end subroutine collect_data_coordinate

subroutine test_mapping(error)
  use, non_intrinsic :: nc4f, only: model_error => error_type
  type(error_type), allocatable, intent(out) :: error
  type(coordinate_type) :: time_coord, lon, lat
  type(variable_type) :: var, copy
  type(model_error) :: err
  real(real32) :: lon_vals(2, 3), lat_vals(2, 3), value
  real(real32), pointer :: view(:)
  integer(int64) :: time_value
  integer :: i

  lon_vals = reshape([(real(i, real32), i=1,6)], [2, 3])
  lat_vals = lon_vals*10.0_real32
  time_coord = coordinate_type("time", [0_int64, 6_int64], &
    & ["time".dim.2], atts=["units".att."hours since 2000-01-01"])
  lon = coordinate_type("lon", lon_vals, &
    & ["west_east".dim.2, "south_north".dim.3], &
    & atts=["units".att."degrees_east"])
  lat = coordinate_type("lat", lat_vals, &
    & ["west_east".dim.2, "south_north".dim.3], &
    & atts=["units".att."degrees_north"])
  call check(error, size(lon) == 6 .and. &
    & all(shape(lon) == [2, 3]) .and. &
    & nameof(lon) == "lon" .and. typeof(lon) == NC_FLOAT, &
    & "Shared coordinate metadata differs")
  if (allocated(error)) return
  var = datarray("temperature", reshape([(real(i, real32), i=1,12)], &
    & [2, 3, 2]), ["west_east".dim.2, "south_north".dim.3, &
    & "time".dim.2], coords=[time_coord, lon, lat])
  call check(error, allocated(var%coords), "Coordinates were not attached")
  if (allocated(error)) return
  call coordinate_at(var%coords(1), [2], time_value)
  call coordinate_at(var%coords(2), [2, 3], value)
  call check(error, time_value == 6_int64 .and. &
    & value == 6.0_real32 .and. size(var%coords) == 3 .and. &
    & coordinate_index(var%coords, "lat") == 3, &
    & "Coordinate lookup differs")
  if (allocated(error)) return
  call extract(var%coords(3), view)
  call check(error, size(view) == 6 .and. &
    & view(6) == 60.0_real32, "Coordinate view differs")
  if (allocated(error)) return
  call rename_dimension(var, "west_east", "x", err)
  call check(error, err%code == NC_NOERR .and. &
    & var%coords(2)%dims(1)%name == "x" .and. &
    & var%coords(3)%dims(1)%name == "x", &
    & "Dimension rename did not update coordinates")
  if (allocated(error)) return
  copy = var
  lon%buffer = 0
  call coordinate_at(copy%coords(2), [2, 3], value)
  call check(error, value == 6.0_real32 .and. &
    & all(copy%coords == var%coords), "Coordinate copy differs")
  if (allocated(error)) return
  copy%coords(2)%name = "time"
  call validate(copy, context="coordinate test", err=err)
  call check(error, err%code == NC_EINVAL, &
    & "Duplicate coordinate names were accepted")
end subroutine test_mapping

subroutine test_integer_kinds(error)
  type(error_type), allocatable, intent(out) :: error
  type(coordinate_type), target :: coord
  integer(int8) :: value8
  integer(int16) :: value16
  integer(int32) :: value32
  integer(int64) :: value64
  integer(int32), pointer :: view(:)

  coord = coordinate_type("time", [1_int8, 2_int8], ["time".dim.2])
  call coordinate_at(coord, [2], value8)
  call check(error, value8 == 2_int8, "int8 time differs")
  if (allocated(error)) return
  coord = coordinate_type("time", [1_int16, 2_int16], ["time".dim.2])
  call coordinate_at(coord, [2], value16)
  call check(error, value16 == 2_int16, "int16 time differs")
  if (allocated(error)) return
  coord = coordinate_type("time", [1_int32, 2_int32], ["time".dim.2])
  call coordinate_at(coord, [2], value32)
  call extract(coord, view)
  call check(error, value32 == 2_int32 .and. &
    & view(2) == 2_int32, "int32 time differs")
  if (allocated(error)) return
  coord = coordinate_type("time", [1_int64, 2_int64], ["time".dim.2])
  call coordinate_at(coord, [2], value64)
  call check(error, value64 == 2_int64, "int64 time differs")
end subroutine test_integer_kinds

end submodule nc4f_test_data_coordinate
