submodule(nc4f_test_netcdf) nc4f_test_netcdf_attribute
use, intrinsic :: iso_c_binding, only: c_char, c_loc, c_null_char, &
  & c_size_t
use, non_intrinsic :: testdrive, only: check, &
  & test_error_type => error_type, new_unittest, unittest_type
use, non_intrinsic :: nc4f, only: attribute_type, netcdf_type, &
  & variable_type, model_error_type => error_type, &
  & define_variable, get_attribute, inquire_variable, &
  & rename_attribute, delete_attribute, nameof, &
  & operator(.att.), operator(.dim.), NC_FLOAT, NC_NOERR
use, non_intrinsic :: nc4f_c_interface, only: nc_put_att_text, NC_GLOBAL
use, non_intrinsic :: nc4f_test_utility, only: open_temp, close_temp
implicit none (type, external)

contains

module subroutine collect_netcdf_attribute(tests)
  type(unittest_type), allocatable, intent(out) :: tests(:)

  tests = [ &
    & new_unittest("global attribute file operations", test_global), &
    & new_unittest("variable attribute file operations", test_variable) &
    & ]
end subroutine collect_netcdf_attribute

subroutine test_global(error)
  type(test_error_type), allocatable, intent(out) :: error
  type(netcdf_type) :: nc
  type(attribute_type) :: att
  type(attribute_type), allocatable :: atts(:)
  type(model_error_type) :: err
  character(kind=c_char), target :: value(1)
  integer :: status

  call open_temp(error, nc)
  if (allocated(error)) return
  value = [character(kind=c_char) :: "x"]
  status = nc_put_att_text(nc%id, NC_GLOBAL, &
    & "title"//c_null_char, 1_c_size_t, c_loc(value))
  call check(error, status == NC_NOERR, &
    & "Global attribute setup failed")
  if (.not. allocated(error)) then
    att = get_attribute(nc, "title", err)
    atts = get_attribute(nc, err=err)
    call check(error, err%code == NC_NOERR .and. &
      & nameof(att) == "title" .and. size(atts) == 1, &
      & "Global attribute inquiry failed")
  end if
  if (.not. allocated(error)) then
    call rename_attribute(nc, "title", "heading", &
      & update_file=.true., err=err)
    call check(error, err%code == NC_NOERR, &
      & "Global attribute rename failed")
  end if
  if (.not. allocated(error)) then
    call delete_attribute(nc, "heading", &
      & update_file=.true., err=err)
    call check(error, err%code == NC_NOERR, &
      & "Global attribute deletion failed")
  end if
  call close_temp(error, nc)
end subroutine test_global

subroutine test_variable(error)
  type(test_error_type), allocatable, intent(out) :: error
  type(netcdf_type) :: nc
  type(variable_type) :: var
  type(attribute_type) :: att
  type(attribute_type), allocatable :: atts(:)
  type(model_error_type) :: err

  call open_temp(error, nc)
  if (allocated(error)) return
  call define_variable(nc, "v", NC_FLOAT, ["x" .dim. 1], &
    & atts=["units" .att. "K"], err=err)
  call check(error, err%code == NC_NOERR, &
    & "Variable attribute setup failed")
  if (.not. allocated(error)) then
    var = inquire_variable(nc, "v", err)
    att = get_attribute(nc, var, "units", err)
    atts = get_attribute(nc, var, err)
    call check(error, err%code == NC_NOERR .and. &
      & nameof(att) == "units" .and. size(atts) == 1, &
      & "Variable attribute inquiry failed")
  end if
  if (.not. allocated(error)) then
    call rename_attribute(nc, var, "units", "label", &
      & update_file=.true., err=err)
    call check(error, err%code == NC_NOERR, &
      & "Variable attribute rename failed")
  end if
  if (.not. allocated(error)) then
    call delete_attribute(nc, var, "label", &
      & update_file=.true., err=err)
    call check(error, err%code == NC_NOERR, &
      & "Variable attribute deletion failed")
  end if
  call close_temp(error, nc)
end subroutine test_variable

end submodule nc4f_test_netcdf_attribute
