submodule(nc4f_test_nc) nc4f_test_nc_dimension
use, non_intrinsic :: testdrive, only: check, &
  & test_error_type => error_type, new_unittest, unittest_type
use, non_intrinsic :: nc4f, only: netcdf_type, variable_type, &
  & dimension_type, model_error_type => error_type, &
  & define_variable, inquire_dimensions, inquire_variable, &
  & rename_dimension, nameof, operator(.dim.), NC_FLOAT, NC_NOERR
use, non_intrinsic :: nc4f_test_utility, only: open_temp, close_temp
implicit none (type, external)

contains

module subroutine collect_nc_dimension(tests)
  type(unittest_type), allocatable, intent(out) :: tests(:)

  tests = [ &
    & new_unittest("inquire dimensions", test_inquiry), &
    & new_unittest("rename file dimension", test_rename), &
    & new_unittest("rename dimension object", test_rename_object) &
    & ]
end subroutine collect_nc_dimension

subroutine test_inquiry(error)
  type(test_error_type), allocatable, intent(out) :: error
  type(netcdf_type) :: nc
  type(variable_type) :: var
  type(dimension_type), allocatable :: dims(:)
  type(model_error_type) :: err

  call open_temp(error, nc)
  if (allocated(error)) return
  call define_variable(nc, "v", NC_FLOAT, ["x" .dim. 2], err=err)
  call check(error, err%code == NC_NOERR, "Dimension setup failed")
  if (.not. allocated(error)) then
    dims = inquire_dimensions(nc, err)
    call check(error, err%code == NC_NOERR .and. &
      & size(dims) == 1, "Group dimension inquiry failed")
  end if
  if (.not. allocated(error)) then
    var = inquire_variable(nc, "v", err)
    dims = inquire_dimensions(nc, var, err)
    call check(error, err%code == NC_NOERR .and. &
      & size(dims) == 1 .and. nameof(dims(1)) == "x", &
      & "Variable dimension inquiry failed")
  end if
  call close_temp(error, nc)
end subroutine test_inquiry

subroutine test_rename(error)
  type(test_error_type), allocatable, intent(out) :: error
  type(netcdf_type) :: nc
  type(dimension_type), allocatable :: dims(:)
  type(model_error_type) :: err

  call open_temp(error, nc)
  if (allocated(error)) return
  call define_variable(nc, "v", NC_FLOAT, ["x" .dim. 2], err=err)
  call check(error, err%code == NC_NOERR, "Dimension setup failed")
  if (.not. allocated(error)) then
    call rename_dimension(nc, "x", "renamed", &
      & update_file=.true., err=err)
    call check(error, err%code == NC_NOERR, &
      & "File dimension rename failed")
  end if
  if (.not. allocated(error)) then
    dims = inquire_dimensions(nc, err)
    call check(error, err%code == NC_NOERR .and. &
      & nameof(dims(1)) == "renamed", &
      & "File dimension name did not change")
  end if
  call close_temp(error, nc)
end subroutine test_rename

subroutine test_rename_object(error)
  type(test_error_type), allocatable, intent(out) :: error
  type(netcdf_type) :: nc
  type(dimension_type), allocatable :: dims(:)
  type(model_error_type) :: err

  call open_temp(error, nc)
  if (allocated(error)) return
  call define_variable(nc, "v", NC_FLOAT, ["x" .dim. 2], err=err)
  call check(error, err%code == NC_NOERR, "Dimension setup failed")
  if (.not. allocated(error)) then
    dims = inquire_dimensions(nc, err)
    call rename_dimension(nc, dims(1), "new", &
      & update_file=.true., err=err)
    call check(error, err%code == NC_NOERR .and. &
      & nameof(dims(1)) == "new", &
      & "Dimension object rename failed")
  end if
  call close_temp(error, nc)
end subroutine test_rename_object

end submodule nc4f_test_nc_dimension
