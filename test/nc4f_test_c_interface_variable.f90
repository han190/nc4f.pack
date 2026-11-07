submodule(nc4f_test_c_interface) nc4f_test_c_interface_variable
use, intrinsic :: iso_c_binding, only: c_char, c_int, c_loc, &
  & c_null_char, c_size_t
use, non_intrinsic :: testdrive, only: check, error_type, new_unittest, &
  & unittest_type
use, non_intrinsic :: nc4f_test_utility, only: open_dataset, finish
use, non_intrinsic :: nc4f_c_interface, only: nc_def_dim, nc_def_var, &
  & nc_inq_dimid, NC_INT, NC_MAX_NAME, NC_NOERR, &
  & nc_inq_varids, &
  & nc_inq_varname, &
  & nc_inq_var, &
  & nc_inq_varnatts, &
  & nc_inq_varid, &
  & nc_inq_vartype, &
  & nc_inq_vardimid, &
  & nc_inq_varndims, &
  & nc_rename_var, &
  & nc_inq_type
implicit none (type, external)

contains

module subroutine collect_c_interface_variable(tests)
  type(unittest_type), allocatable, intent(out) :: tests(:)
  tests = [ &
    & new_unittest("nc_def_var", test_nc_def_var), &
    & new_unittest("nc_inq_varids", test_nc_inq_varids), &
    & new_unittest("nc_inq_varname", test_nc_inq_varname), &
    & new_unittest("nc_inq_var", test_nc_inq_var), &
    & new_unittest("nc_inq_varnatts", test_nc_inq_varnatts), &
    & new_unittest("nc_inq_varid", test_nc_inq_varid), &
    & new_unittest("nc_inq_vartype", test_nc_inq_vartype), &
    & new_unittest("nc_inq_vardimid", test_nc_inq_vardimid), &
    & new_unittest("nc_inq_varndims", test_nc_inq_varndims), &
    & new_unittest("nc_rename_var", test_nc_rename_var), &
    & new_unittest("nc_inq_type", test_nc_inq_type) &
    & ]
end subroutine collect_c_interface_variable

subroutine test_nc_def_var(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status, queried

  call seed(error, ncid, varid)
  if (allocated(error)) return
  status = nc_inq_varid(ncid, "v"//c_null_char, queried)
  call finish(error, ncid, status, "nc_def_var inquiry failed")
  if (allocated(error)) return
  call check(error, queried == varid, "Variable ID differs")
end subroutine test_nc_def_var

subroutine seed(error, ncid, varid)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int), intent(out) :: ncid, varid
  integer(c_int) :: dimid, status

  call open_dataset(error, ncid, enhanced=.true.)
  if (allocated(error)) return
  status = nc_def_dim(ncid, "x"//c_null_char, 2_c_size_t, dimid)
  if (status == NC_NOERR) then
    status = nc_def_var(ncid, "v"//c_null_char, NC_INT, &
      & 1_c_int, [dimid], varid)
  end if
  if (status == NC_NOERR) return
  call finish(error, ncid, status, "Variable setup failed")
end subroutine seed

subroutine test_nc_inq_varids(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status, count
  integer(c_int), target :: ids(1)

  call seed(error, ncid, varid)
  if (allocated(error)) return
  ids = -1_c_int
  status = nc_inq_varids(ncid, count, c_loc(ids))
  call finish(error, ncid, status, "nc_inq_varids failed")
  if (allocated(error)) return
  call check(error, count == 1 .and. ids(1) == varid, &
    & "Variable metadata differs")
end subroutine test_nc_inq_varids

subroutine test_nc_inq_varname(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  character(kind=c_char) :: name(NC_MAX_NAME + 1)

  call seed(error, ncid, varid)
  if (allocated(error)) return
  status = nc_inq_varname(ncid, varid, name)
  call finish(error, ncid, status, "nc_inq_varname failed")
  if (allocated(error)) return
  call check(error, name(1) == "v" .and. name(2) == c_null_char, &
    & "Variable metadata differs")
end subroutine test_nc_inq_varname

subroutine test_nc_inq_var(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status, xtype, ndims, natts
  integer(c_int) :: dims(1)
  character(kind=c_char) :: name(NC_MAX_NAME + 1)

  call seed(error, ncid, varid)
  if (allocated(error)) return
  status = nc_inq_var(ncid, varid, name, xtype, ndims, dims, natts)
  call finish(error, ncid, status, "nc_inq_var failed")
  if (allocated(error)) return
  call check(error, name(1) == "v" .and. xtype == NC_INT .and. ndims == 1 &
    & .and. natts == 0, &
    & "Variable metadata differs")
end subroutine test_nc_inq_var

subroutine test_nc_inq_varnatts(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status, count

  call seed(error, ncid, varid)
  if (allocated(error)) return
  status = nc_inq_varnatts(ncid, varid, count)
  call finish(error, ncid, status, "nc_inq_varnatts failed")
  if (allocated(error)) return
  call check(error, count == 0, &
    & "Variable metadata differs")
end subroutine test_nc_inq_varnatts

subroutine test_nc_inq_varid(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status, found_id

  call seed(error, ncid, varid)
  if (allocated(error)) return
  status = nc_inq_varid(ncid, "v"//c_null_char, found_id)
  call finish(error, ncid, status, "nc_inq_varid failed")
  if (allocated(error)) return
  call check(error, found_id == varid, &
    & "Variable metadata differs")
end subroutine test_nc_inq_varid

subroutine test_nc_inq_vartype(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status, xtype

  call seed(error, ncid, varid)
  if (allocated(error)) return
  status = nc_inq_vartype(ncid, varid, xtype)
  call finish(error, ncid, status, "nc_inq_vartype failed")
  if (allocated(error)) return
  call check(error, xtype == NC_INT, &
    & "Variable metadata differs")
end subroutine test_nc_inq_vartype

subroutine test_nc_inq_vardimid(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status, dims(1), defined_id

  call seed(error, ncid, varid)
  if (allocated(error)) return
  status = nc_inq_vardimid(ncid, varid, dims)
  if (status == NC_NOERR) then
    status = nc_inq_dimid(ncid, "x"//c_null_char, defined_id)
  end if
  call finish(error, ncid, status, "nc_inq_vardimid failed")
  if (allocated(error)) return
  call check(error, dims(1) == defined_id, &
    & "Variable metadata differs")
end subroutine test_nc_inq_vardimid

subroutine test_nc_inq_varndims(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status, count

  call seed(error, ncid, varid)
  if (allocated(error)) return
  status = nc_inq_varndims(ncid, varid, count)
  call finish(error, ncid, status, "nc_inq_varndims failed")
  if (allocated(error)) return
  call check(error, count == 1, &
    & "Variable metadata differs")
end subroutine test_nc_inq_varndims

subroutine test_nc_rename_var(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status, found_id

  call seed(error, ncid, varid)
  if (allocated(error)) return
  status = nc_rename_var(ncid, varid, "renamed"//c_null_char)
  if (status == NC_NOERR) then
    status = nc_inq_varid(ncid, "renamed"//c_null_char, found_id)
  end if
  call finish(error, ncid, status, "nc_rename_var failed")
  if (allocated(error)) return
  call check(error, found_id == varid, &
    & "Variable metadata differs")
end subroutine test_nc_rename_var

subroutine test_nc_inq_type(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_size_t) :: bytes
  character(kind=c_char) :: name(NC_MAX_NAME + 1)

  call seed(error, ncid, varid)
  if (allocated(error)) return
  status = nc_inq_type(ncid, NC_INT, name, bytes)
  call finish(error, ncid, status, "nc_inq_type failed")
  if (allocated(error)) return
  call check(error, bytes == 4_c_size_t, &
    & "Variable metadata differs")
end subroutine test_nc_inq_type

end submodule nc4f_test_c_interface_variable
