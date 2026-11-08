submodule(nc4f_test_data) nc4f_test_data_io
use, intrinsic :: iso_fortran_env, only: real32
use, non_intrinsic :: testdrive, only: check, error_type, new_unittest, &
  & unittest_type
use, non_intrinsic :: nc4f, only: attribute_type, dimension_type, &
  & variable_type, group_type, netcdf_type, model_error_type => &
  & error_type, datarray, dataset, operator(.att.), &
  & operator(.dim.)
implicit none (type, external)

contains

module subroutine collect_data_io(tests)
  type(unittest_type), allocatable, intent(out) :: tests(:)

  tests = [new_unittest("formatted derived types", test_formatted)]
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
  open (newunit=unit, status="scratch", form="formatted")
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

end submodule nc4f_test_data_io
