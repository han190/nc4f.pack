#ifdef __LFORTRAN__
#define NC4F_UNIT_KEYWORD unit
#else
#define NC4F_UNIT_KEYWORD newunit
#endif

submodule(nc4f_test_data) nc4f_test_data_io
use, intrinsic :: iso_fortran_env, only: real32
use, non_intrinsic :: testdrive, only: check, error_type, new_unittest, &
  & unittest_type
use, non_intrinsic :: nc4f, only: attribute_type, dimension_type, &
  & variable_type, coordinate_type, group_type, netcdf_type, &
  & model_error_type => &
  & error_type, datarray, dataset, operator(.att.), &
  & operator(.dim.)
implicit none (type, external)

contains

module subroutine collect_data_io(tests)
  type(unittest_type), allocatable, intent(out) :: tests(:)

  tests = [ &
    & new_unittest("formatted derived types", test_formatted), &
    & new_unittest("formatted coordinate", test_formatted_coordinate), &
    & new_unittest("formatted variable coordinates", &
    & test_formatted_variable_coords)]
end subroutine collect_data_io

subroutine test_formatted(error)
  type(error_type), allocatable, intent(out) :: error
  type(attribute_type) :: att
  type(dimension_type) :: dim
  type(variable_type) :: var
  type(group_type) :: grp
  type(netcdf_type) :: nc
  type(model_error_type) :: err
  character(len=256) :: line
  integer :: unit, stat

  att = "units" .att. "K"
  dim = "x" .dim. 1
  var = datarray("temperature", [1.0_real32], [dim])
  grp = dataset("root", [var], [att])
  nc%name = "/"
  nc%file = "model.nc"
  unit = 91
  open (NC4F_UNIT_KEYWORD=unit, status="scratch", form="formatted")
  write (unit, *, iostat=stat) att
  if (stat == 0) write (unit, *, iostat=stat) dim
  if (stat == 0) write (unit, *, iostat=stat) var
  if (stat == 0) write (unit, *, iostat=stat) grp
  if (stat == 0) write (unit, *, iostat=stat) nc
  if (stat == 0) write (unit, *, iostat=stat) err
  call check(error, stat == 0, "Formatted derived-type write failed")
  if (allocated(error)) then
    close (unit)
    return
  end if
  rewind (unit)
  read (unit, "(a)", iostat=stat) line
  close (unit)
  call check(error, stat == 0 .and. index(line, "units") > 0, &
    & "Formatted attribute output differs")
end subroutine test_formatted

subroutine test_formatted_coordinate(error)
  !! Check list-directed and DT output of coordinate metadata.
  type(error_type), allocatable, intent(out) :: error
  !! Test-drive failure result.
  type(coordinate_type) :: coord
  character(len=256) :: line
  integer :: unit, stat

  coord = coordinate_type("latitude", [10.0_real32, 20.0_real32], &
    & ["station".dim.2], atts=["units".att."degrees_north"])
  unit = 91
  open (NC4F_UNIT_KEYWORD=unit, status="scratch", form="formatted")
  write (unit, *, iostat=stat) coord
  call check(error, stat == 0, "List-directed coordinate write failed")
  if (allocated(error)) then
    close (unit)
    return
  end if
  rewind (unit)
  read (unit, "(a)", iostat=stat) line
  call check(error, stat == 0 .and. &
    & index(line, "float latitude(station) ;") > 0, &
    & "Coordinate declaration differs")
  if (allocated(error)) then
    close (unit)
    return
  end if
  read (unit, "(a)", iostat=stat) line
  call check(error, stat == 0 .and. &
    & index(line, "units") > 0 .and. &
    & index(line, "degrees_north") > 0, &
    & "Coordinate attributes were not formatted")
  if (allocated(error)) then
    close (unit)
    return
  end if
  rewind (unit)
  write (unit, "(dt)", iostat=stat) coord
  close (unit)
  call check(error, stat == 0, "DT coordinate write failed")
end subroutine test_formatted_coordinate

subroutine test_formatted_variable_coords(error)
  !! Print only attached coordinate names within a variable declaration.
  type(error_type), allocatable, intent(out) :: error
  !! Test-drive failure result.
  type(coordinate_type) :: latitude
  type(variable_type) :: var
  character(len=256) :: line
  integer :: unit, stat

  latitude = coordinate_type("latitude", &
    & [10.0_real32, 20.0_real32], ["station".dim.2], &
    & atts=["units".att."degrees_north"])
  var = datarray("temperature", [280.0_real32, 281.0_real32], &
    & ["station".dim.2], coords=[latitude])
  line = ""
  unit = 91
  open (NC4F_UNIT_KEYWORD=unit, status="scratch", form="formatted")
  write (unit, *, iostat=stat) var
  if (stat == 0) rewind (unit)
  if (stat == 0) read (unit, "(a)", iostat=stat) line
  if (stat == 0) read (unit, "(a)", iostat=stat) line
  close (unit)
  call check(error, stat == 0 .and. &
    & index(line, 'coordinates = "latitude"') > 0 .and. &
    & index(line, "degrees_north") == 0, &
    & "Variable output did not summarize its coordinates")
end subroutine test_formatted_variable_coords

end submodule nc4f_test_data_io
