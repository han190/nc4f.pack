module nc4f_test_nc_group
use, intrinsic :: iso_c_binding, only: c_null_char
use, non_intrinsic :: testdrive, only: check, &
  & test_error_type => error_type, new_unittest, unittest_type
use, non_intrinsic :: nc4f, only: netcdf_type, group_type, &
  & model_error_type => error_type, get_group, inquire_subgroups, &
  & inquire_group, rename_group, nameof, NC_NOERR
use, non_intrinsic :: nc4f_c_interface, only: nc_def_grp
use, non_intrinsic :: nc4f_test_nc_utility, only: open_temp, close_temp
implicit none (type, external)
private
public :: collect_nc_group

contains

subroutine collect_nc_group(tests)
  type(unittest_type), allocatable, intent(out) :: tests(:)

  tests = [ &
    & new_unittest("group inquiries", test_inquiry), &
    & new_unittest("rename file group", test_rename) &
    & ]
end subroutine collect_nc_group

subroutine test_inquiry(error)
  type(test_error_type), allocatable, intent(out) :: error
  type(netcdf_type) :: nc
  type(group_type) :: child
  type(group_type), allocatable :: children(:)
  type(model_error_type) :: err
  integer :: id, status

  call open_temp(error, nc)
  if (allocated(error)) return
  status = nc_def_grp(nc%id, "child"//c_null_char, id)
  call check(error, status == NC_NOERR, "Child group setup failed")
  if (.not. allocated(error)) then
    child = get_group(nc, "child", err)
    children = inquire_subgroups(nc, err)
    call check(error, err%code == NC_NOERR .and. &
      & child%id == id .and. size(children) == 1, &
      & "Group lookup or enumeration failed")
  end if
  if (.not. allocated(error)) then
    call inquire_group(nc, inq_grps=.true., err=err)
    call check(error, err%code == NC_NOERR .and. &
      & associated(nc%grps), "Recursive group inquiry failed")
  end if
  call close_temp(error, nc)
end subroutine test_inquiry

subroutine test_rename(error)
  type(test_error_type), allocatable, intent(out) :: error
  type(netcdf_type) :: nc
  type(group_type) :: child
  type(model_error_type) :: err
  integer :: id, status

  call open_temp(error, nc)
  if (allocated(error)) return
  status = nc_def_grp(nc%id, "old"//c_null_char, id)
  call check(error, status == NC_NOERR, "Child group setup failed")
  if (.not. allocated(error)) then
    child = get_group(nc, "old", err)
    call rename_group(nc, child, "middle", &
      & update_file=.true., err=err)
    call check(error, err%code == NC_NOERR .and. &
      & nameof(child) == "middle", "Object group rename failed")
  end if
  if (.not. allocated(error)) then
    call rename_group(nc, "middle", "new", &
      & update_file=.true., err=err)
    call check(error, err%code == NC_NOERR, &
      & "Named group rename failed")
  end if
  if (.not. allocated(error)) then
    child = get_group(nc, "new", err)
    call check(error, err%code == NC_NOERR .and. &
      & child%id == id, "Renamed group was not found")
  end if
  call close_temp(error, nc)
end subroutine test_rename

end module nc4f_test_nc_group
