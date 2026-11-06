module nc4f_test_c_interface_dimension
use, intrinsic :: iso_c_binding, only: c_char, c_int, c_loc, c_long, &
  & c_null_char, c_null_ptr, c_size_t
use, non_intrinsic :: testdrive, only: check, error_type, new_unittest, &
  & unittest_type
use, non_intrinsic :: nc4f_c_interface, only: nc_def_dim, nc_def_grp, &
  & nc_inq_dim, nc_inq_dimid, nc_inq_dimids, &
  & nc_inq_dimlen, nc_inq_dimname, nc_inq_unlimdim, nc_inq_unlimdims, &
  & nc_rename_dim, ncdimdef, ncdimid, ncdiminq, ncdimrename, &
  & NC_MAX_NAME, NC_NOERR, NC_UNLIMITED
use, non_intrinsic :: nc4f_test_utility, only: open_dataset, finish
implicit none (type, external)
private
public :: collect_c_interface_dimension

contains

subroutine collect_c_interface_dimension(tests)
  type(unittest_type), allocatable, intent(out) :: tests(:)

  tests = [ &
    & new_unittest("nc_def_dim", test_nc_def_dim), &
    & new_unittest("nc_inq_dimlen", test_nc_inq_dimlen), &
    & new_unittest("nc_inq_dimids", test_nc_inq_dimids), &
    & new_unittest("nc_inq_dimid", test_nc_inq_dimid), &
    & new_unittest("nc_inq_dimname", test_nc_inq_dimname), &
    & new_unittest("nc_inq_unlimdim", test_nc_inq_unlimdim), &
    & new_unittest("nc_inq_unlimdims", test_nc_inq_unlimdims), &
    & new_unittest("nc_inq_dim", test_nc_inq_dim), &
    & new_unittest("nc_rename_dim", test_nc_rename_dim), &
    & new_unittest("ncdimdef", test_ncdimdef), &
    & new_unittest("ncdimid", test_ncdimid), &
    & new_unittest("ncdiminq", test_ncdiminq), &
    & new_unittest("ncdimrename", test_ncdimrename)]
end subroutine collect_c_interface_dimension

subroutine test_nc_def_dim(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, dimid, status
  integer(c_size_t) :: length

  call open_dataset(error, ncid)
  if (allocated(error)) return
  status = nc_def_dim(ncid, "x"//c_null_char, 3_c_size_t, dimid)
  if (status == NC_NOERR) status = nc_inq_dimlen(ncid, dimid, length)
  call finish(error, ncid, status, "nc_def_dim or inquiry failed")
  if (allocated(error)) return
  call check(error, length == 3_c_size_t, "Incorrect dimension length")
end subroutine test_nc_def_dim

subroutine test_nc_inq_dimlen(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, dimid, status
  integer(c_size_t) :: length

  call open_dataset(error, ncid)
  if (allocated(error)) return
  status = nc_def_dim(ncid, "x"//c_null_char, 7_c_size_t, dimid)
  if (status == NC_NOERR) status = nc_inq_dimlen(ncid, dimid, length)
  call finish(error, ncid, status, "nc_inq_dimlen failed")
  if (allocated(error)) return
  call check(error, length == 7_c_size_t, "Incorrect dimension length")
end subroutine test_nc_inq_dimlen

subroutine test_nc_inq_dimids(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, groupid, parentid, childid, count, status
  integer(c_int), target :: ids(2)

  call open_dataset(error, ncid, enhanced=.true.)
  if (allocated(error)) return
  ids = -1_c_int
  status = nc_def_dim(ncid, "parent"//c_null_char, 2_c_size_t, parentid)
  if (status == NC_NOERR) then
    status = nc_def_grp(ncid, "child"//c_null_char, groupid)
  end if
  if (status == NC_NOERR) then
    status = nc_def_dim(groupid, "local"//c_null_char, &
      & 3_c_size_t, childid)
  end if
  if (status == NC_NOERR) then
    status = nc_inq_dimids(groupid, count, c_loc(ids), 0_c_int)
  end if
  if (status == NC_NOERR) then
    call check(error, count == 1 .and. ids(1) == childid, &
      & "Local dimension IDs are incorrect")
  end if
  if (status == NC_NOERR .and. .not. allocated(error)) then
    status = nc_inq_dimids(groupid, count, c_loc(ids), 1_c_int)
  end if
  if (status == NC_NOERR .and. .not. allocated(error)) then
    call check(error, count == 2 .and. any(ids == parentid) .and. &
      & any(ids == childid), "Inherited dimension IDs are incorrect")
  end if
  call finish(error, ncid, status, "nc_inq_dimids failed")
end subroutine test_nc_inq_dimids

subroutine test_nc_inq_dimid(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, defined_id, found_id, status

  call open_dataset(error, ncid)
  if (allocated(error)) return
  status = nc_def_dim(ncid, "x"//c_null_char, 4_c_size_t, defined_id)
  if (status == NC_NOERR) then
    status = nc_inq_dimid(ncid, "x"//c_null_char, found_id)
  end if
  call finish(error, ncid, status, "nc_inq_dimid failed")
  if (allocated(error)) return
  call check(error, found_id == defined_id, "Incorrect dimension ID")
end subroutine test_nc_inq_dimid

subroutine test_nc_inq_dimname(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, dimid, status
  character(kind=c_char) :: name(NC_MAX_NAME + 1)

  call open_dataset(error, ncid)
  if (allocated(error)) return
  status = nc_def_dim(ncid, "x"//c_null_char, 4_c_size_t, dimid)
  if (status == NC_NOERR) status = nc_inq_dimname(ncid, dimid, name)
  call finish(error, ncid, status, "nc_inq_dimname failed")
  if (allocated(error)) return
  call check(error, name(1) == "x" .and. name(2) == c_null_char, &
    & "Incorrect or unterminated dimension name")
end subroutine test_nc_inq_dimname

subroutine test_nc_inq_unlimdim(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, defined_id, found_id, status

  call open_dataset(error, ncid)
  if (allocated(error)) return
  status = nc_def_dim(ncid, "time"//c_null_char, &
    & NC_UNLIMITED, defined_id)
  if (status == NC_NOERR) status = nc_inq_unlimdim(ncid, found_id)
  call finish(error, ncid, status, "nc_inq_unlimdim failed")
  if (allocated(error)) return
  call check(error, found_id == defined_id, "Incorrect unlimited ID")
end subroutine test_nc_inq_unlimdim

subroutine test_nc_inq_unlimdims(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, first_id, second_id, count, status
  integer(c_int), target :: ids(2)

  call open_dataset(error, ncid, enhanced=.true.)
  if (allocated(error)) return
  ids = -1_c_int
  status = nc_def_dim(ncid, "time"//c_null_char, &
    & NC_UNLIMITED, first_id)
  if (status == NC_NOERR) then
    status = nc_def_dim(ncid, "record"//c_null_char, &
      & NC_UNLIMITED, second_id)
  end if
  if (status == NC_NOERR) then
    status = nc_inq_unlimdims(ncid, count, c_null_ptr)
  end if
  if (status == NC_NOERR) then
    call check(error, count == 2, "Incorrect unlimited dimension count")
  end if
  if (status == NC_NOERR .and. .not. allocated(error)) then
    status = nc_inq_unlimdims(ncid, count, c_loc(ids))
  end if
  if (status == NC_NOERR .and. .not. allocated(error)) then
    call check(error, count == 2 .and. any(ids == first_id) .and. &
      & any(ids == second_id), "Incorrect unlimited dimension IDs")
  end if
  call finish(error, ncid, status, "nc_inq_unlimdims failed")
end subroutine test_nc_inq_unlimdims

subroutine test_nc_inq_dim(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, dimid, status
  integer(c_size_t) :: length
  character(kind=c_char) :: name(NC_MAX_NAME + 1)

  call open_dataset(error, ncid)
  if (allocated(error)) return
  status = nc_def_dim(ncid, "x"//c_null_char, 5_c_size_t, dimid)
  if (status == NC_NOERR) status = nc_inq_dim(ncid, dimid, name, length)
  call finish(error, ncid, status, "nc_inq_dim failed")
  if (allocated(error)) return
  call check(error, name(1) == "x" .and. name(2) == c_null_char &
    & .and. length == 5_c_size_t, "Incorrect dimension metadata")
end subroutine test_nc_inq_dim

subroutine test_nc_rename_dim(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, dimid, found_id, status

  call open_dataset(error, ncid)
  if (allocated(error)) return
  status = nc_def_dim(ncid, "x"//c_null_char, 5_c_size_t, dimid)
  if (status == NC_NOERR) then
    status = nc_rename_dim(ncid, dimid, "renamed"//c_null_char)
  end if
  if (status == NC_NOERR) then
    status = nc_inq_dimid(ncid, "renamed"//c_null_char, found_id)
  end if
  call finish(error, ncid, status, "nc_rename_dim failed")
  if (allocated(error)) return
  call check(error, found_id == dimid, "Rename changed the dimension ID")
end subroutine test_nc_rename_dim

subroutine test_ncdimdef(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, dimid, status
  integer(c_size_t) :: length

  call open_dataset(error, ncid)
  if (allocated(error)) return
  dimid = ncdimdef(ncid, "x"//c_null_char, 6_c_long)
  status = NC_NOERR
  if (dimid >= 0) status = nc_inq_dimlen(ncid, dimid, length)
  if (dimid < 0) status = -1_c_int
  call finish(error, ncid, status, "ncdimdef or inquiry failed")
  if (allocated(error)) return
  call check(error, length == 6_c_size_t, "Incorrect dimension length")
end subroutine test_ncdimdef

subroutine test_ncdimid(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, dimid, found_id, status

  call open_dataset(error, ncid)
  if (allocated(error)) return
  status = nc_def_dim(ncid, "x"//c_null_char, 2_c_size_t, dimid)
  if (status == NC_NOERR) found_id = ncdimid(ncid, "x"//c_null_char)
  call finish(error, ncid, status, "nc_def_dim setup failed")
  if (allocated(error)) return
  call check(error, found_id == dimid, "ncdimid returned wrong ID")
end subroutine test_ncdimid

subroutine test_ncdiminq(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, dimid, status, inquiry_status
  integer(c_long) :: length
  character(kind=c_char), target :: name(NC_MAX_NAME + 1)

  call open_dataset(error, ncid)
  if (allocated(error)) return
  status = nc_def_dim(ncid, "x"//c_null_char, 9_c_size_t, dimid)
  if (status == NC_NOERR) then
    inquiry_status = ncdiminq(ncid, dimid, c_loc(name), length)
    if (inquiry_status /= 0) status = inquiry_status
  end if
  call finish(error, ncid, status, "ncdiminq failed")
  if (allocated(error)) return
  call check(error, name(1) == "x" .and. name(2) == c_null_char &
    & .and. length == 9_c_long, "Incorrect legacy dimension metadata")
end subroutine test_ncdiminq

subroutine test_ncdimrename(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, dimid, found_id, status, rename_status

  call open_dataset(error, ncid)
  if (allocated(error)) return
  status = nc_def_dim(ncid, "x"//c_null_char, 5_c_size_t, dimid)
  if (status == NC_NOERR) then
    rename_status = ncdimrename(ncid, dimid, "y"//c_null_char)
    if (rename_status /= 0) status = rename_status
  end if
  if (status == NC_NOERR) then
    status = nc_inq_dimid(ncid, "y"//c_null_char, found_id)
  end if
  call finish(error, ncid, status, "ncdimrename failed")
  if (allocated(error)) return
  call check(error, found_id == dimid, "Rename changed dimension ID")
end subroutine test_ncdimrename

end module nc4f_test_c_interface_dimension
