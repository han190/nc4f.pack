submodule(nc4f_test_netcdf) nc4f_test_netcdf_dataset
use, intrinsic :: iso_c_binding, only: c_null_char
use, intrinsic :: iso_fortran_env, only: real32
use, non_intrinsic :: testdrive, only: check, &
  & test_error_type => error_type, new_unittest, unittest_type
use, non_intrinsic :: nc4f, only: netcdf_type, group_type, &
  & variable_type, coordinate_type, model_error_type => error_type, &
  & datarray, dataset, extract, get_variable, open_netcdf, &
  & close_netcdf, to_netcdf, &
  & operator(.att.), operator(.dim.), operator(==), NC_NOERR
use, non_intrinsic :: nc4f_c_interface, only: nc_delete
implicit none (type, external)

contains

module subroutine collect_netcdf_dataset(tests)
  type(unittest_type), allocatable, intent(out) :: tests(:)

  tests = [ &
    & new_unittest("open and close NetCDF", test_lifecycle), &
    & new_unittest("serialize variable", test_variable), &
    & new_unittest("serialize group", test_group), &
    & new_unittest("coordinate round trip", test_coordinates), &
    & new_unittest("missing CF coordinate reference", &
    & test_missing_coordinate_reference) &
    & ]
end subroutine collect_netcdf_dataset

subroutine test_lifecycle(error)
  type(test_error_type), allocatable, intent(out) :: error
  type(netcdf_type) :: nc
  type(model_error_type) :: err

  nc = open_netcdf("nc4f-lifecycle.nc", mode="wn", &
    & diskless=.true., err=err)
  call check(error, err%code == NC_NOERR .and. &
    & nc%id >= 0, "open_netcdf failed")
  if (allocated(error)) return
  call close_netcdf(nc, err)
  call check(error, err%code == NC_NOERR .and. &
    & nc%id == -1, "close_netcdf failed")
end subroutine test_lifecycle

subroutine test_variable(error)
  type(test_error_type), allocatable, intent(out) :: error
  type(variable_type) :: var
  type(netcdf_type) :: nc
  type(model_error_type) :: err
  integer :: status

  var = datarray("v", [1.0_real32, 2.0_real32], &
    & ["x" .dim. 2])
  call to_netcdf("nc4f-variable-output.nc", var, err=err)
  call check(error, err%code == NC_NOERR, &
    & "to_netcdf variable overload failed")
  if (allocated(error)) return
  nc = open_netcdf("nc4f-variable-output.nc", err=err)
  call check(error, err%code == NC_NOERR, &
    & "Serialized variable file did not open")
  if (allocated(error)) return
  call close_netcdf(nc, err)
  status = nc_delete("nc4f-variable-output.nc"//c_null_char)
  call check(error, err%code == NC_NOERR .and. status == NC_NOERR, &
    & "Serialized variable file cleanup failed")
end subroutine test_variable

subroutine test_group(error)
  type(test_error_type), allocatable, intent(out) :: error
  type(group_type) :: grp
  type(netcdf_type) :: nc
  type(model_error_type) :: err
  integer :: status

  grp = dataset("root", atts=["title" .att. "sample"])
  call to_netcdf("nc4f-group-output.nc", grp, err=err)
  call check(error, err%code == NC_NOERR, &
    & "to_netcdf group overload failed")
  if (allocated(error)) return
  nc = open_netcdf("nc4f-group-output.nc", err=err)
  call check(error, err%code == NC_NOERR, &
    & "Serialized group file did not open")
  if (allocated(error)) return
  call close_netcdf(nc, err)
  status = nc_delete("nc4f-group-output.nc"//c_null_char)
  call check(error, err%code == NC_NOERR .and. status == NC_NOERR, &
    & "Serialized group file cleanup failed")
end subroutine test_group

subroutine test_coordinates(error)
  !! Check CF coordinate variables and their ordered parent reference.
  type(test_error_type), allocatable, intent(out) :: error
  !! Test-drive failure result.
  type(coordinate_type) :: lon, lat
  type(variable_type) :: source, source2, actual
  type(netcdf_type) :: nc
  type(model_error_type) :: err
  integer :: status

  lon = coordinate_type("lon", reshape([1.0_real32, 2.0_real32, &
    & 3.0_real32, 4.0_real32], [2, 2]), &
    & ["x".dim.2, "y".dim.2], &
    & atts=["units".att."degrees_east"])
  lat = coordinate_type("lat", reshape([5.0_real32, 6.0_real32, &
    & 7.0_real32, 8.0_real32], [2, 2]), lon%dims, &
    & atts=["units".att."degrees_north"])
  source = datarray("temperature", reshape([9.0_real32, 10.0_real32, &
    & 11.0_real32, 12.0_real32], [2, 2]), lon%dims, &
    & coords=[lon, lat])
  source2 = datarray("pressure", reshape([13.0_real32, 14.0_real32, &
    & 15.0_real32, 16.0_real32], [2, 2]), lon%dims, &
    & coords=[lon, lat])
  call to_netcdf("nc4f-coordinate-output.nc", &
    & [source, source2], err=err)
  call check(error, err%code == NC_NOERR, &
    & "Coordinate serialization failed")
  if (allocated(error)) return
  nc = open_netcdf("nc4f-coordinate-output.nc", err=err)
  if (err%code == NC_NOERR) then
    actual = get_variable(nc, "temperature", err=err)
    call close_netcdf(nc)
  end if
  call check(error, err%code == NC_NOERR, &
    & "Coordinate reconstruction failed")
  if (allocated(error)) return
  call check(error, allocated(actual%coords), &
    & "Coordinate collection was not reconstructed")
  if (allocated(error)) return
  call check(error, size(actual%coords) == 2, &
    & "Coordinate collection size changed")
  if (allocated(error)) return
  call check(error, all(actual%coords == [lon, lat]), &
    & "Coordinate order, values, or attributes changed")
  if (allocated(error)) return
  nc = open_netcdf("nc4f-coordinate-output.nc", err=err)
  if (err%code == NC_NOERR) then
    actual = get_variable(nc, "pressure", err=err)
    call close_netcdf(nc)
  end if
  call check(error, err%code == NC_NOERR .and. &
    & allocated(actual%coords), &
    & "Shared coordinates were not reconstructed")
  status = nc_delete("nc4f-coordinate-output.nc"//c_null_char)
  if (allocated(error)) return
  call check(error, status == NC_NOERR, &
    & "Coordinate file cleanup failed")
end subroutine test_coordinates

subroutine test_missing_coordinate_reference(error)
  !! Read data even when a CF coordinates attribute names an absent variable.
  type(test_error_type), allocatable, intent(out) :: error
  !! Test-drive failure result.
  type(variable_type) :: source
  type(variable_type), target :: actual
  type(netcdf_type) :: nc
  type(model_error_type) :: err
  character(len=:), pointer :: missing
  integer :: status, i
  logical :: found_missing

  source = datarray("temperature", [280.0_real32, 281.0_real32], &
    & ["station".dim.2], atts=["coordinates".att."height"])
  call to_netcdf("nc4f-missing-coordinate.nc", source, err=err)
  call check(error, err%code == NC_NOERR, &
    & "Missing-coordinate fixture could not be written")
  if (allocated(error)) return
  nc = open_netcdf("nc4f-missing-coordinate.nc", err=err)
  if (err%code == NC_NOERR) then
    actual = get_variable(nc, "temperature", err=err)
    call close_netcdf(nc)
  end if
  call check(error, err%code == NC_NOERR, &
    & "Missing CF coordinate reference blocked data reading")
  if (allocated(error)) return
  call check(error, .not. allocated(actual%coords), &
    & "Absent coordinate was attached to the variable")
  if (allocated(error)) return
  found_missing = .false.
  nullify (missing)
  do i = 1, size(actual%atts)
    if (actual%atts(i)%name /= "coordinate") cycle
    call extract(actual%atts(i), missing)
    found_missing = missing == "height (not found)"
    deallocate (missing)
    exit
  end do
  call check(error, found_missing, &
    & "Missing coordinate diagnostic attribute differs")
  status = nc_delete("nc4f-missing-coordinate.nc"//c_null_char)
  if (allocated(error)) return
  call check(error, status == NC_NOERR, &
    & "Missing-coordinate fixture cleanup failed")
end subroutine test_missing_coordinate_reference

end submodule nc4f_test_netcdf_dataset
