module nc4f_test_c_interface_group
use, intrinsic :: iso_c_binding, only: c_char, c_int, c_loc, &
  & c_null_char, c_null_ptr, c_size_t
use, non_intrinsic :: testdrive, only: check, error_type, new_unittest, &
  & unittest_type
use, non_intrinsic :: nc4f_c_interface, only: nc_def_grp, nc_inq_grps, &
  & nc_inq_grpname, nc_inq_grpname_full, &
  & nc_inq_grpname_len, nc_inq_grp_parent, nc_inq_grp_full_ncid, &
  & nc_inq_grp_ncid, nc_inq_ncid, nc_rename_grp, NC_MAX_NAME, NC_NOERR
use, non_intrinsic :: nc4f_test_utility, only: open_dataset, finish
implicit none (type, external)
private
public :: collect_c_interface_group

contains

subroutine collect_c_interface_group(tests)
  type(unittest_type), allocatable, intent(out) :: tests(:)

  tests = [ &
    & new_unittest("nc_def_grp", test_nc_def_grp), &
    & new_unittest("nc_inq_ncid", test_nc_inq_ncid), &
    & new_unittest("nc_inq_grps", test_nc_inq_grps), &
    & new_unittest("nc_inq_grpname", test_nc_inq_grpname), &
    & new_unittest("nc_inq_grpname_full", test_nc_inq_grpname_full), &
    & new_unittest("nc_inq_grp_parent", test_nc_inq_grp_parent), &
    & new_unittest("nc_inq_grp_full_ncid", &
    & test_nc_inq_grp_full_ncid), &
    & new_unittest("nc_inq_grpname_len", test_nc_inq_grpname_len), &
    & new_unittest("nc_rename_grp", test_nc_rename_grp), &
    & new_unittest("nc_inq_grp_ncid", test_nc_inq_grp_ncid)]
end subroutine collect_c_interface_group

subroutine test_nc_def_grp(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, childid, found_id, status

  call open_dataset(error, ncid, enhanced=.true.)
  if (allocated(error)) return
  status = nc_def_grp(ncid, "child"//c_null_char, childid)
  if (status == NC_NOERR) then
    status = nc_inq_ncid(ncid, "child"//c_null_char, found_id)
  end if
  call finish(error, ncid, status, "nc_def_grp or lookup failed")
  if (allocated(error)) return
  call check(error, found_id == childid, "Created group ID differs")
end subroutine test_nc_def_grp

subroutine test_nc_inq_ncid(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, childid, found_id, status

  call open_dataset(error, ncid, enhanced=.true.)
  if (allocated(error)) return
  status = nc_def_grp(ncid, "child"//c_null_char, childid)
  if (status == NC_NOERR) then
    status = nc_inq_ncid(ncid, "child"//c_null_char, found_id)
  end if
  call finish(error, ncid, status, "nc_inq_ncid failed")
  if (allocated(error)) return
  call check(error, found_id == childid, "Incorrect child group ID")
end subroutine test_nc_inq_ncid

subroutine test_nc_inq_grps(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, first_id, second_id, count, status
  integer(c_int), target :: ids(2)

  call open_dataset(error, ncid, enhanced=.true.)
  if (allocated(error)) return
  ids = -1_c_int
  status = nc_def_grp(ncid, "first"//c_null_char, first_id)
  if (status == NC_NOERR) then
    status = nc_def_grp(ncid, "second"//c_null_char, second_id)
  end if
  if (status == NC_NOERR) status = nc_inq_grps(ncid, count, c_null_ptr)
  if (status == NC_NOERR) then
    call check(error, count == 2, "Incorrect child group count")
  end if
  if (status == NC_NOERR .and. .not. allocated(error)) then
    status = nc_inq_grps(ncid, count, c_loc(ids))
  end if
  if (status == NC_NOERR .and. .not. allocated(error)) then
    call check(error, count == 2 .and. any(ids == first_id) .and. &
      & any(ids == second_id), "Incorrect child group IDs")
  end if
  call finish(error, ncid, status, "nc_inq_grps failed")
end subroutine test_nc_inq_grps

subroutine test_nc_inq_grpname(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, childid, status
  character(kind=c_char) :: name(NC_MAX_NAME + 1)

  call open_dataset(error, ncid, enhanced=.true.)
  if (allocated(error)) return
  status = nc_def_grp(ncid, "child"//c_null_char, childid)
  if (status == NC_NOERR) status = nc_inq_grpname(childid, name)
  call finish(error, ncid, status, "nc_inq_grpname failed")
  if (allocated(error)) return
  call check(error, all(name(1:5) == &
    & [character(kind=c_char) :: "c", "h", "i", "l", "d"]) .and. &
    & name(6) == c_null_char, "Incorrect local group name")
end subroutine test_nc_inq_grpname

subroutine test_nc_inq_grpname_full(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, parentid, childid, status, i
  integer(c_size_t) :: length
  character(kind=c_char) :: path(2 * NC_MAX_NAME + 3)
  character(len=13) :: actual

  call open_dataset(error, ncid, enhanced=.true.)
  if (allocated(error)) return
  status = nc_def_grp(ncid, "parent"//c_null_char, parentid)
  if (status == NC_NOERR) then
    status = nc_def_grp(parentid, "child"//c_null_char, childid)
  end if
  if (status == NC_NOERR) then
    status = nc_inq_grpname_full(childid, length, path)
  end if
  call finish(error, ncid, status, "nc_inq_grpname_full failed")
  if (allocated(error)) return
  do i = 1, len(actual)
    actual(i:i) = path(i)
  end do
  call check(error, length == 13_c_size_t .and. &
    & actual == "/parent/child" .and. path(14) == c_null_char, &
    & "Incorrect full group path")
end subroutine test_nc_inq_grpname_full

subroutine test_nc_inq_grp_parent(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, childid, parentid, status

  call open_dataset(error, ncid, enhanced=.true.)
  if (allocated(error)) return
  status = nc_def_grp(ncid, "child"//c_null_char, childid)
  if (status == NC_NOERR) status = nc_inq_grp_parent(childid, parentid)
  call finish(error, ncid, status, "nc_inq_grp_parent failed")
  if (allocated(error)) return
  call check(error, parentid == ncid, "Incorrect parent group ID")
end subroutine test_nc_inq_grp_parent

subroutine test_nc_inq_grp_full_ncid(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, parentid, childid, found_id, status

  call open_dataset(error, ncid, enhanced=.true.)
  if (allocated(error)) return
  status = nc_def_grp(ncid, "parent"//c_null_char, parentid)
  if (status == NC_NOERR) then
    status = nc_def_grp(parentid, "child"//c_null_char, childid)
  end if
  if (status == NC_NOERR) then
    status = nc_inq_grp_full_ncid(ncid, &
      & "/parent/child"//c_null_char, found_id)
  end if
  call finish(error, ncid, status, "nc_inq_grp_full_ncid failed")
  if (allocated(error)) return
  call check(error, found_id == childid, "Incorrect resolved group ID")
end subroutine test_nc_inq_grp_full_ncid

subroutine test_nc_inq_grpname_len(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, parentid, childid, status
  integer(c_size_t) :: length

  call open_dataset(error, ncid, enhanced=.true.)
  if (allocated(error)) return
  status = nc_def_grp(ncid, "parent"//c_null_char, parentid)
  if (status == NC_NOERR) then
    status = nc_def_grp(parentid, "child"//c_null_char, childid)
  end if
  if (status == NC_NOERR) status = nc_inq_grpname_len(childid, length)
  call finish(error, ncid, status, "nc_inq_grpname_len failed")
  if (allocated(error)) return
  call check(error, length == 13_c_size_t, "Incorrect full path length")
end subroutine test_nc_inq_grpname_len

subroutine test_nc_rename_grp(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, childid, found_id, status

  call open_dataset(error, ncid, enhanced=.true.)
  if (allocated(error)) return
  status = nc_def_grp(ncid, "old"//c_null_char, childid)
  if (status == NC_NOERR) then
    status = nc_rename_grp(childid, "new"//c_null_char)
  end if
  if (status == NC_NOERR) then
    status = nc_inq_ncid(ncid, "new"//c_null_char, found_id)
  end if
  call finish(error, ncid, status, "nc_rename_grp failed")
  if (allocated(error)) return
  call check(error, found_id == childid, "Rename changed group ID")
end subroutine test_nc_rename_grp

subroutine test_nc_inq_grp_ncid(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, childid, found_id, status

  call open_dataset(error, ncid, enhanced=.true.)
  if (allocated(error)) return
  status = nc_def_grp(ncid, "child"//c_null_char, childid)
  if (status == NC_NOERR) then
    status = nc_inq_grp_ncid(ncid, "child"//c_null_char, found_id)
  end if
  call finish(error, ncid, status, "nc_inq_grp_ncid failed")
  if (allocated(error)) return
  call check(error, found_id == childid, "Incorrect group ID")
end subroutine test_nc_inq_grp_ncid

end module nc4f_test_c_interface_group
