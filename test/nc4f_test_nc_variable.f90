module nc4f_test_nc_variable
use, intrinsic :: iso_fortran_env, only: real32
use, non_intrinsic :: testdrive, only: check, &
  & test_error_type => error_type, new_unittest, unittest_type
use, non_intrinsic :: nc4f, only: netcdf_type, variable_type, &
  & model_error_type => error_type, datarray, define_variable, &
  & put_variable, get_variable, inquire_variable, rename_variable, &
  & extract, nameof, &
  & operator(.dim.), NC_FLOAT, NC_NOERR
use, non_intrinsic :: nc4f_test_nc_utility, only: open_temp, close_temp
implicit none (type, external)
private
public :: collect_nc_variable

contains

subroutine collect_nc_variable(tests)
  type(unittest_type), allocatable, intent(out) :: tests(:)

  tests = [ &
    & new_unittest("define and inquire variable", test_definition), &
    & new_unittest("put and get variable", test_values), &
    & new_unittest("rename file variable", test_rename) &
    & ]
end subroutine collect_nc_variable

subroutine test_definition(error)
  type(test_error_type), allocatable, intent(out) :: error
  type(netcdf_type) :: nc
  type(variable_type) :: schema, found
  type(model_error_type) :: err

  call open_temp(error, nc)
  if (allocated(error)) return
  call define_variable(nc, "raw", NC_FLOAT, ["x" .dim. 2], err=err)
  call check(error, err%code == NC_NOERR, &
    & "Raw define_variable overload failed")
  if (.not. allocated(error)) then
    schema = datarray("object", [1.0_real32, 2.0_real32], &
      & ["x" .dim. 2])
    call define_variable(nc, schema, err)
    call check(error, err%code == NC_NOERR, &
      & "Object define_variable overload failed")
  end if
  if (.not. allocated(error)) then
    found = inquire_variable(nc, "object", err)
    call check(error, err%code == NC_NOERR .and. &
      & nameof(found) == "object", "inquire_variable failed")
  end if
  call close_temp(error, nc)
end subroutine test_definition

subroutine test_values(error)
  type(test_error_type), allocatable, intent(out) :: error
  type(netcdf_type) :: nc
  type(variable_type) :: source, actual
  type(model_error_type) :: err
  real(real32), pointer :: values(:)

  call open_temp(error, nc)
  if (allocated(error)) return
  source = datarray("v", [1.0_real32, 2.0_real32], &
    & ["x" .dim. 2])
  call define_variable(nc, source, err)
  call check(error, err%code == NC_NOERR, &
    & "Variable setup failed")
  if (.not. allocated(error)) then
    call put_variable(nc, source, err=err)
    call check(error, err%code == NC_NOERR, &
      & "put_variable failed")
  end if
  if (.not. allocated(error)) then
    actual = get_variable(nc, "v", err=err)
    call check(error, err%code == NC_NOERR, &
      & "get_variable failed")
  end if
  if (.not. allocated(error)) then
    call extract(actual, values)
    call check(error, associated(values), &
      & "Read variable has no values")
  end if
  if (.not. allocated(error)) then
    call check(error, all(values == [1.0_real32, 2.0_real32]), &
      & "Read variable values differ")
  end if
  call close_temp(error, nc)
end subroutine test_values

subroutine test_rename(error)
  type(test_error_type), allocatable, intent(out) :: error
  type(netcdf_type) :: nc
  type(variable_type) :: var
  type(model_error_type) :: err

  call open_temp(error, nc)
  if (allocated(error)) return
  call define_variable(nc, "old", NC_FLOAT, ["x" .dim. 1], err=err)
  call check(error, err%code == NC_NOERR, &
    & "Variable setup failed")
  if (.not. allocated(error)) then
    var = inquire_variable(nc, "old", err)
    call rename_variable(nc, var, "middle", &
      & update_file=.true., err=err)
    call check(error, err%code == NC_NOERR .and. &
      & nameof(var) == "middle", "Object variable rename failed")
  end if
  if (.not. allocated(error)) then
    call rename_variable(nc, "middle", "new", &
      & update_file=.true., err=err)
    call check(error, err%code == NC_NOERR, &
      & "Named variable rename failed")
  end if
  if (.not. allocated(error)) then
    var = inquire_variable(nc, "new", err)
    call check(error, err%code == NC_NOERR .and. &
      & nameof(var) == "new", "Renamed variable was not found")
  end if
  call close_temp(error, nc)
end subroutine test_rename

end module nc4f_test_nc_variable
