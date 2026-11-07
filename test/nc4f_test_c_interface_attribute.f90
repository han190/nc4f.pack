submodule(nc4f_test_c_interface) nc4f_test_c_interface_attribute
use, intrinsic :: iso_c_binding, only: c_associated, c_char, c_double, &
  & c_float, c_int, c_loc, c_long, c_long_long, c_null_char, &
  & c_null_ptr, c_ptr, c_short, c_signed_char, c_size_t
use, non_intrinsic :: testdrive, only: check, error_type, new_unittest, &
  & unittest_type
use, non_intrinsic :: nc4f_test_utility, only: open_dataset, finish
use, non_intrinsic :: nc4f_c_interface, only: &
  & nc_inq_att, nc_get_att, nc_inq_natts, &
  & nc_inq_attname, nc_put_att, nc_inq_attid, &
  & nc_inq_atttype, nc_inq_attlen, nc_copy_att, &
  & nc_rename_att, nc_del_att, nc_get_att_schar, &
  & nc_put_att_schar, nc_get_att_short, nc_put_att_short, &
  & nc_get_att_int, nc_put_att_int, nc_get_att_long, &
  & nc_put_att_long, nc_get_att_longlong, nc_put_att_longlong, &
  & nc_get_att_float, nc_put_att_float, nc_get_att_double, &
  & nc_put_att_double, nc_get_att_text, nc_put_att_text, &
  & nc_get_att_string, nc_put_att_string, ncattput, &
  & ncattinq, ncattget, ncattcopy, &
  & ncattname, ncattrename, ncattdel, &
  & nc_def_grp, nc_def_var, nc_free_string, c_strlen, NC_ENOTATT, NC_GLOBAL, &
  & NC_INT, NC_MAX_NAME, NC_NOERR
implicit none (type, external)

contains

module subroutine collect_c_interface_attribute(tests)
  type(unittest_type), allocatable, intent(out) :: tests(:)
  tests = [ &
    & new_unittest("nc_inq_att", test_nc_inq_att), &
    & new_unittest("nc_get_att", test_nc_get_att), &
    & new_unittest("nc_inq_natts", test_nc_inq_natts), &
    & new_unittest("nc_inq_attname", test_nc_inq_attname), &
    & new_unittest("nc_put_att", test_nc_put_att), &
    & new_unittest("nc_inq_attid", test_nc_inq_attid), &
    & new_unittest("nc_inq_atttype", test_nc_inq_atttype), &
    & new_unittest("nc_inq_attlen", test_nc_inq_attlen), &
    & new_unittest("nc_copy_att", test_nc_copy_att), &
    & new_unittest("nc_rename_att", test_nc_rename_att), &
    & new_unittest("nc_del_att", test_nc_del_att), &
    & new_unittest("nc_get_att_schar", test_nc_get_att_schar), &
    & new_unittest("nc_put_att_schar", test_nc_put_att_schar), &
    & new_unittest("nc_get_att_short", test_nc_get_att_short), &
    & new_unittest("nc_put_att_short", test_nc_put_att_short), &
    & new_unittest("nc_get_att_int", test_nc_get_att_int), &
    & new_unittest("nc_put_att_int", test_nc_put_att_int), &
    & new_unittest("nc_get_att_long", test_nc_get_att_long), &
    & new_unittest("nc_put_att_long", test_nc_put_att_long), &
    & new_unittest("nc_get_att_longlong", test_nc_get_att_longlong), &
    & new_unittest("nc_put_att_longlong", test_nc_put_att_longlong), &
    & new_unittest("nc_get_att_float", test_nc_get_att_float), &
    & new_unittest("nc_put_att_float", test_nc_put_att_float), &
    & new_unittest("nc_get_att_double", test_nc_get_att_double), &
    & new_unittest("nc_put_att_double", test_nc_put_att_double), &
    & new_unittest("nc_get_att_text", test_nc_get_att_text), &
    & new_unittest("nc_put_att_text", test_nc_put_att_text), &
    & new_unittest("nc_get_att_string", test_nc_get_att_string), &
    & new_unittest("nc_put_att_string", test_nc_put_att_string), &
    & new_unittest("ncattput", test_ncattput), &
    & new_unittest("ncattinq", test_ncattinq), &
    & new_unittest("ncattget", test_ncattget), &
    & new_unittest("ncattcopy", test_ncattcopy), &
    & new_unittest("ncattname", test_ncattname), &
    & new_unittest("ncattrename", test_ncattrename), &
    & new_unittest("ncattdel", test_ncattdel) &
    & ]
end subroutine collect_c_interface_attribute

subroutine seed(error, ncid, enhanced)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int), intent(out) :: ncid
  logical, intent(in), optional :: enhanced
  integer(c_int), target :: value
  integer(c_int) :: status

  if (present(enhanced)) then
    call open_dataset(error, ncid, enhanced=enhanced)
  else
    call open_dataset(error, ncid, enhanced=.true.)
  end if
  if (allocated(error)) return
  value = 7_c_int
  status = nc_put_att_int(ncid, NC_GLOBAL, "a"//c_null_char, &
    & NC_INT, 1_c_size_t, c_loc(value))
  if (status == NC_NOERR) return
  call finish(error, ncid, status, "Attribute setup failed")
end subroutine seed

subroutine test_nc_put_att_schar(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, status
  integer(c_signed_char), target :: source, actual

  call seed(error, ncid)
  if (allocated(error)) return
  source = 7_c_signed_char
  actual = 0
  status = nc_put_att_schar(ncid, NC_GLOBAL, "b"//c_null_char, &
    & NC_INT, 1_c_size_t, c_loc(source))
  if (status == NC_NOERR) then
    status = nc_get_att_schar(ncid, NC_GLOBAL, &
      & "b"//c_null_char, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_att_schar failed")
  if (allocated(error)) return
  call check(error, actual == source, "Attribute value differs")
end subroutine test_nc_put_att_schar

subroutine test_nc_get_att_schar(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, status
  integer(c_signed_char), target :: source, actual

  call seed(error, ncid)
  if (allocated(error)) return
  source = 7_c_signed_char
  actual = 0
  status = nc_put_att_schar(ncid, NC_GLOBAL, "b"//c_null_char, &
    & NC_INT, 1_c_size_t, c_loc(source))
  if (status == NC_NOERR) then
    status = nc_get_att_schar(ncid, NC_GLOBAL, &
      & "b"//c_null_char, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_get_att_schar failed")
  if (allocated(error)) return
  call check(error, actual == source, "Attribute value differs")
end subroutine test_nc_get_att_schar

subroutine test_nc_put_att_short(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, status
  integer(c_short), target :: source, actual

  call seed(error, ncid)
  if (allocated(error)) return
  source = 7_c_short
  actual = 0
  status = nc_put_att_short(ncid, NC_GLOBAL, "b"//c_null_char, &
    & NC_INT, 1_c_size_t, c_loc(source))
  if (status == NC_NOERR) then
    status = nc_get_att_short(ncid, NC_GLOBAL, &
      & "b"//c_null_char, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_att_short failed")
  if (allocated(error)) return
  call check(error, actual == source, "Attribute value differs")
end subroutine test_nc_put_att_short

subroutine test_nc_get_att_short(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, status
  integer(c_short), target :: source, actual

  call seed(error, ncid)
  if (allocated(error)) return
  source = 7_c_short
  actual = 0
  status = nc_put_att_short(ncid, NC_GLOBAL, "b"//c_null_char, &
    & NC_INT, 1_c_size_t, c_loc(source))
  if (status == NC_NOERR) then
    status = nc_get_att_short(ncid, NC_GLOBAL, &
      & "b"//c_null_char, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_get_att_short failed")
  if (allocated(error)) return
  call check(error, actual == source, "Attribute value differs")
end subroutine test_nc_get_att_short

subroutine test_nc_put_att_int(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, status
  integer(c_int), target :: source, actual

  call seed(error, ncid)
  if (allocated(error)) return
  source = 7_c_int
  actual = 0
  status = nc_put_att_int(ncid, NC_GLOBAL, "b"//c_null_char, &
    & NC_INT, 1_c_size_t, c_loc(source))
  if (status == NC_NOERR) then
    status = nc_get_att_int(ncid, NC_GLOBAL, &
      & "b"//c_null_char, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_att_int failed")
  if (allocated(error)) return
  call check(error, actual == source, "Attribute value differs")
end subroutine test_nc_put_att_int

subroutine test_nc_get_att_int(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, status
  integer(c_int), target :: source, actual

  call seed(error, ncid)
  if (allocated(error)) return
  source = 7_c_int
  actual = 0
  status = nc_put_att_int(ncid, NC_GLOBAL, "b"//c_null_char, &
    & NC_INT, 1_c_size_t, c_loc(source))
  if (status == NC_NOERR) then
    status = nc_get_att_int(ncid, NC_GLOBAL, &
      & "b"//c_null_char, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_get_att_int failed")
  if (allocated(error)) return
  call check(error, actual == source, "Attribute value differs")
end subroutine test_nc_get_att_int

subroutine test_nc_put_att_long(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, status
  integer(c_long), target :: source, actual

  call seed(error, ncid)
  if (allocated(error)) return
  source = 7_c_long
  actual = 0
  status = nc_put_att_long(ncid, NC_GLOBAL, "b"//c_null_char, &
    & NC_INT, 1_c_size_t, c_loc(source))
  if (status == NC_NOERR) then
    status = nc_get_att_long(ncid, NC_GLOBAL, &
      & "b"//c_null_char, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_att_long failed")
  if (allocated(error)) return
  call check(error, actual == source, "Attribute value differs")
end subroutine test_nc_put_att_long

subroutine test_nc_get_att_long(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, status
  integer(c_long), target :: source, actual

  call seed(error, ncid)
  if (allocated(error)) return
  source = 7_c_long
  actual = 0
  status = nc_put_att_long(ncid, NC_GLOBAL, "b"//c_null_char, &
    & NC_INT, 1_c_size_t, c_loc(source))
  if (status == NC_NOERR) then
    status = nc_get_att_long(ncid, NC_GLOBAL, &
      & "b"//c_null_char, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_get_att_long failed")
  if (allocated(error)) return
  call check(error, actual == source, "Attribute value differs")
end subroutine test_nc_get_att_long

subroutine test_nc_put_att_longlong(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, status
  integer(c_long_long), target :: source, actual

  call seed(error, ncid)
  if (allocated(error)) return
  source = 7_c_long_long
  actual = 0
  status = nc_put_att_longlong(ncid, NC_GLOBAL, "b"//c_null_char, &
    & NC_INT, 1_c_size_t, c_loc(source))
  if (status == NC_NOERR) then
    status = nc_get_att_longlong(ncid, NC_GLOBAL, &
      & "b"//c_null_char, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_att_longlong failed")
  if (allocated(error)) return
  call check(error, actual == source, "Attribute value differs")
end subroutine test_nc_put_att_longlong

subroutine test_nc_get_att_longlong(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, status
  integer(c_long_long), target :: source, actual

  call seed(error, ncid)
  if (allocated(error)) return
  source = 7_c_long_long
  actual = 0
  status = nc_put_att_longlong(ncid, NC_GLOBAL, "b"//c_null_char, &
    & NC_INT, 1_c_size_t, c_loc(source))
  if (status == NC_NOERR) then
    status = nc_get_att_longlong(ncid, NC_GLOBAL, &
      & "b"//c_null_char, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_get_att_longlong failed")
  if (allocated(error)) return
  call check(error, actual == source, "Attribute value differs")
end subroutine test_nc_get_att_longlong

subroutine test_nc_put_att_float(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, status
  real(c_float), target :: source, actual

  call seed(error, ncid)
  if (allocated(error)) return
  source = 7.0_c_float
  actual = 0
  status = nc_put_att_float(ncid, NC_GLOBAL, "b"//c_null_char, &
    & NC_INT, 1_c_size_t, c_loc(source))
  if (status == NC_NOERR) then
    status = nc_get_att_float(ncid, NC_GLOBAL, &
      & "b"//c_null_char, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_att_float failed")
  if (allocated(error)) return
  call check(error, actual == source, "Attribute value differs")
end subroutine test_nc_put_att_float

subroutine test_nc_get_att_float(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, status
  real(c_float), target :: source, actual

  call seed(error, ncid)
  if (allocated(error)) return
  source = 7.0_c_float
  actual = 0
  status = nc_put_att_float(ncid, NC_GLOBAL, "b"//c_null_char, &
    & NC_INT, 1_c_size_t, c_loc(source))
  if (status == NC_NOERR) then
    status = nc_get_att_float(ncid, NC_GLOBAL, &
      & "b"//c_null_char, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_get_att_float failed")
  if (allocated(error)) return
  call check(error, actual == source, "Attribute value differs")
end subroutine test_nc_get_att_float

subroutine test_nc_put_att_double(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, status
  real(c_double), target :: source, actual

  call seed(error, ncid)
  if (allocated(error)) return
  source = 7.0_c_double
  actual = 0
  status = nc_put_att_double(ncid, NC_GLOBAL, "b"//c_null_char, &
    & NC_INT, 1_c_size_t, c_loc(source))
  if (status == NC_NOERR) then
    status = nc_get_att_double(ncid, NC_GLOBAL, &
      & "b"//c_null_char, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_att_double failed")
  if (allocated(error)) return
  call check(error, actual == source, "Attribute value differs")
end subroutine test_nc_put_att_double

subroutine test_nc_get_att_double(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, status
  real(c_double), target :: source, actual

  call seed(error, ncid)
  if (allocated(error)) return
  source = 7.0_c_double
  actual = 0
  status = nc_put_att_double(ncid, NC_GLOBAL, "b"//c_null_char, &
    & NC_INT, 1_c_size_t, c_loc(source))
  if (status == NC_NOERR) then
    status = nc_get_att_double(ncid, NC_GLOBAL, &
      & "b"//c_null_char, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_get_att_double failed")
  if (allocated(error)) return
  call check(error, actual == source, "Attribute value differs")
end subroutine test_nc_get_att_double

subroutine test_nc_put_att(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, status
  integer(c_int), target :: source, actual

  call seed(error, ncid)
  if (allocated(error)) return
  source = 7_c_int
  actual = 0
  status = nc_put_att(ncid, NC_GLOBAL, "b"//c_null_char, &
    & NC_INT, 1_c_size_t, c_loc(source))
  if (status == NC_NOERR) then
    status = nc_get_att(ncid, NC_GLOBAL, "b"//c_null_char, &
      & c_loc(actual))
  end if
  call finish(error, ncid, status, "Generic attribute transfer failed")
  if (allocated(error)) return
  call check(error, actual == source, "Attribute value differs")
end subroutine test_nc_put_att

subroutine test_nc_get_att(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, status
  integer(c_int), target :: source, actual

  call seed(error, ncid)
  if (allocated(error)) return
  source = 7_c_int
  actual = 0
  status = nc_put_att(ncid, NC_GLOBAL, "b"//c_null_char, &
    & NC_INT, 1_c_size_t, c_loc(source))
  if (status == NC_NOERR) then
    status = nc_get_att(ncid, NC_GLOBAL, "b"//c_null_char, &
      & c_loc(actual))
  end if
  call finish(error, ncid, status, "Generic attribute transfer failed")
  if (allocated(error)) return
  call check(error, actual == source, "Attribute value differs")
end subroutine test_nc_get_att

subroutine test_nc_put_att_text(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, status
  character(kind=c_char), target :: source(3), actual(3)

  call seed(error, ncid)
  if (allocated(error)) return
  source = [character(kind=c_char) :: "c", "a", "t"]
  actual = c_null_char
  status = nc_put_att_text(ncid, NC_GLOBAL, "b"//c_null_char, &
    & 3_c_size_t, c_loc(source))
  if (status == NC_NOERR) then
    status = nc_get_att_text(ncid, NC_GLOBAL, "b"//c_null_char, &
      & c_loc(actual))
  end if
  call finish(error, ncid, status, "Text attribute transfer failed")
  if (allocated(error)) return
  call check(error, all(actual == source), "Text attribute differs")
end subroutine test_nc_put_att_text

subroutine test_nc_get_att_text(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, status
  character(kind=c_char), target :: source(3), actual(3)

  call seed(error, ncid)
  if (allocated(error)) return
  source = [character(kind=c_char) :: "c", "a", "t"]
  actual = c_null_char
  status = nc_put_att_text(ncid, NC_GLOBAL, "b"//c_null_char, &
    & 3_c_size_t, c_loc(source))
  if (status == NC_NOERR) then
    status = nc_get_att_text(ncid, NC_GLOBAL, "b"//c_null_char, &
      & c_loc(actual))
  end if
  call finish(error, ncid, status, "Text attribute transfer failed")
  if (allocated(error)) return
  call check(error, all(actual == source), "Text attribute differs")
end subroutine test_nc_get_att_text

subroutine test_nc_put_att_string(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, status, free_status
  character(kind=c_char), target :: chars(4)
  type(c_ptr), target :: input(1), output(1)

  call seed(error, ncid)
  if (allocated(error)) return
  chars = [character(kind=c_char) :: "c", "a", "t", c_null_char]
  input(1) = c_loc(chars)
  output(1) = c_null_ptr
  status = nc_put_att_string(ncid, NC_GLOBAL, "b"//c_null_char, &
    & 1_c_size_t, c_loc(input))
  if (status == NC_NOERR) then
    status = nc_get_att_string(ncid, NC_GLOBAL, "b"//c_null_char, &
      & c_loc(output))
  end if
  if (status == NC_NOERR) then
    call check(error, c_associated(output(1)), "String pointer is NULL")
    if (.not. allocated(error)) then
      call check(error, c_strlen(output(1)) == 3_c_size_t, &
        & "String attribute length differs")
    end if
  end if
  if (c_associated(output(1))) then
    free_status = nc_free_string(1_c_size_t, c_loc(output))
    if (status == NC_NOERR) status = free_status
  end if
  call finish(error, ncid, status, "String attribute transfer failed")
end subroutine test_nc_put_att_string

subroutine test_nc_get_att_string(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, status, free_status
  character(kind=c_char), target :: chars(4)
  type(c_ptr), target :: input(1), output(1)

  call seed(error, ncid)
  if (allocated(error)) return
  chars = [character(kind=c_char) :: "c", "a", "t", c_null_char]
  input(1) = c_loc(chars)
  output(1) = c_null_ptr
  status = nc_put_att_string(ncid, NC_GLOBAL, "b"//c_null_char, &
    & 1_c_size_t, c_loc(input))
  if (status == NC_NOERR) then
    status = nc_get_att_string(ncid, NC_GLOBAL, "b"//c_null_char, &
      & c_loc(output))
  end if
  if (status == NC_NOERR) then
    call check(error, c_associated(output(1)), "String pointer is NULL")
    if (.not. allocated(error)) then
      call check(error, c_strlen(output(1)) == 3_c_size_t, &
        & "String attribute length differs")
    end if
  end if
  if (c_associated(output(1))) then
    free_status = nc_free_string(1_c_size_t, c_loc(output))
    if (status == NC_NOERR) status = free_status
  end if
  call finish(error, ncid, status, "String attribute transfer failed")
end subroutine test_nc_get_att_string

subroutine test_nc_inq_att(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, status, xtype
  integer(c_size_t) :: length

  call seed(error, ncid)
  if (allocated(error)) return
  status = nc_inq_att(ncid, NC_GLOBAL, "a"//c_null_char, &
    & xtype, length)
  call finish(error, ncid, status, "nc_inq_att failed")
  if (allocated(error)) return
  call check(error, xtype == NC_INT .and. length == 1_c_size_t, &
    & "Incorrect attribute metadata")
end subroutine test_nc_inq_att

subroutine test_nc_inq_natts(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, status, count

  call seed(error, ncid)
  if (allocated(error)) return
  status = nc_inq_natts(ncid, count)
  call finish(error, ncid, status, "nc_inq_natts failed")
  if (allocated(error)) return
  call check(error, count == 1_c_int, "Incorrect attribute count")
end subroutine test_nc_inq_natts

subroutine test_nc_inq_attname(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, status
  character(kind=c_char) :: name(NC_MAX_NAME + 1)

  call seed(error, ncid)
  if (allocated(error)) return
  status = nc_inq_attname(ncid, NC_GLOBAL, 0_c_int, name)
  call finish(error, ncid, status, "nc_inq_attname failed")
  if (allocated(error)) return
  call check(error, name(1) == "a" .and. name(2) == c_null_char, &
    & "Incorrect attribute name")
end subroutine test_nc_inq_attname

subroutine test_nc_inq_attid(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, status, id

  call seed(error, ncid)
  if (allocated(error)) return
  status = nc_inq_attid(ncid, NC_GLOBAL, "a"//c_null_char, id)
  call finish(error, ncid, status, "nc_inq_attid failed")
  if (allocated(error)) return
  call check(error, id == 0_c_int, "Incorrect attribute ID")
end subroutine test_nc_inq_attid

subroutine test_nc_inq_atttype(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, status, xtype

  call seed(error, ncid)
  if (allocated(error)) return
  status = nc_inq_atttype(ncid, NC_GLOBAL, "a"//c_null_char, xtype)
  call finish(error, ncid, status, "nc_inq_atttype failed")
  if (allocated(error)) return
  call check(error, xtype == NC_INT, "Incorrect attribute type")
end subroutine test_nc_inq_atttype

subroutine test_nc_inq_attlen(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, status
  integer(c_size_t) :: length

  call seed(error, ncid)
  if (allocated(error)) return
  status = nc_inq_attlen(ncid, NC_GLOBAL, "a"//c_null_char, length)
  call finish(error, ncid, status, "nc_inq_attlen failed")
  if (allocated(error)) return
  call check(error, length == 1_c_size_t, "Incorrect attribute length")
end subroutine test_nc_inq_attlen

subroutine test_nc_copy_att(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, childid, status, xtype
  integer(c_size_t) :: length

  call seed(error, ncid)
  if (allocated(error)) return
  status = nc_def_grp(ncid, "child"//c_null_char, childid)
  if (status == NC_NOERR) then
    status = nc_copy_att(ncid, NC_GLOBAL, "a"//c_null_char, &
      & childid, NC_GLOBAL)
  end if
  if (status == NC_NOERR) then
    status = nc_inq_att(childid, NC_GLOBAL, "a"//c_null_char, &
      & xtype, length)
  end if
  call finish(error, ncid, status, "nc_copy_att failed")
  if (allocated(error)) return
  call check(error, xtype == NC_INT .and. length == 1_c_size_t, &
    & "Copied attribute differs")
end subroutine test_nc_copy_att

subroutine test_nc_rename_att(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, status, id

  call seed(error, ncid)
  if (allocated(error)) return
  status = nc_rename_att(ncid, NC_GLOBAL, "a"//c_null_char, &
    & "b"//c_null_char)
  if (status == NC_NOERR) then
    status = nc_inq_attid(ncid, NC_GLOBAL, "b"//c_null_char, id)
  end if
  call finish(error, ncid, status, "nc_rename_att failed")
  if (allocated(error)) return
  call check(error, id == 0_c_int, "Renamed attribute ID differs")
end subroutine test_nc_rename_att

subroutine test_nc_del_att(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, status, id

  call seed(error, ncid)
  if (allocated(error)) return
  status = nc_del_att(ncid, NC_GLOBAL, "a"//c_null_char)
  if (status == NC_NOERR) then
    status = nc_inq_attid(ncid, NC_GLOBAL, "a"//c_null_char, id)
  end if
  if (status == NC_ENOTATT) status = NC_NOERR
  call finish(error, ncid, status, "nc_del_att failed")
end subroutine test_nc_del_att

subroutine test_ncattput(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, status, xtype, length
  integer(c_int), target :: value

  call seed(error, ncid, enhanced=.false.)
  if (allocated(error)) return
  value = 11_c_int
  status = ncattput(ncid, NC_GLOBAL, "b"//c_null_char, &
    & NC_INT, 1_c_int, c_loc(value))
  if (status == 0) then
    status = ncattinq(ncid, NC_GLOBAL, "b"//c_null_char, &
      & xtype, length)
  end if
  if (status == 1) status = NC_NOERR
  call finish(error, ncid, status, "ncattput failed")
  if (allocated(error)) return
  call check(error, xtype == NC_INT .and. length == 1_c_int, &
    & "Legacy attribute metadata differs")
end subroutine test_ncattput

subroutine test_ncattinq(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, status, xtype, length

  call seed(error, ncid, enhanced=.false.)
  if (allocated(error)) return
  status = ncattinq(ncid, NC_GLOBAL, "a"//c_null_char, &
    & xtype, length)
  if (status == 1) status = NC_NOERR
  call finish(error, ncid, status, "ncattinq failed")
  if (allocated(error)) return
  call check(error, xtype == NC_INT .and. length == 1_c_int, &
    & "Legacy attribute metadata differs")
end subroutine test_ncattinq

subroutine test_ncattget(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, status
  integer(c_int), target :: value

  call seed(error, ncid, enhanced=.false.)
  if (allocated(error)) return
  value = 0_c_int
  status = ncattget(ncid, NC_GLOBAL, "a"//c_null_char, c_loc(value))
  if (status == 1) status = NC_NOERR
  call finish(error, ncid, status, "ncattget failed")
  if (allocated(error)) return
  call check(error, value == 7_c_int, "Legacy attribute value differs")
end subroutine test_ncattget

subroutine test_ncattcopy(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status, xtype, length
  integer(c_int) :: dimids(1)

  call seed(error, ncid, enhanced=.false.)
  if (allocated(error)) return
  status = nc_def_var(ncid, "v"//c_null_char, NC_INT, &
    & 0_c_int, dimids, varid)
  if (status == NC_NOERR) then
    status = ncattcopy(ncid, NC_GLOBAL, "a"//c_null_char, &
      & ncid, varid)
  end if
  if (status == NC_NOERR) then
    status = ncattinq(ncid, varid, "a"//c_null_char, &
      & xtype, length)
  end if
  if (status == 1) status = NC_NOERR
  call finish(error, ncid, status, "ncattcopy failed")
  if (allocated(error)) return
  call check(error, xtype == NC_INT .and. length == 1_c_int, &
    & "Legacy copied attribute differs")
end subroutine test_ncattcopy

subroutine test_ncattname(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, status
  character(kind=c_char), target :: name(NC_MAX_NAME + 1)

  call seed(error, ncid, enhanced=.false.)
  if (allocated(error)) return
  status = ncattname(ncid, NC_GLOBAL, 0_c_int, c_loc(name))
  call finish(error, ncid, status, "ncattname failed")
  if (allocated(error)) return
  call check(error, name(1) == "a" .and. name(2) == c_null_char, &
    & "Legacy attribute name differs")
end subroutine test_ncattname

subroutine test_ncattrename(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, status, id

  call seed(error, ncid, enhanced=.false.)
  if (allocated(error)) return
  status = ncattrename(ncid, NC_GLOBAL, "a"//c_null_char, &
    & "b"//c_null_char)
  if (status == 1) then
    status = nc_inq_attid(ncid, NC_GLOBAL, "b"//c_null_char, id)
  end if
  call finish(error, ncid, status, "ncattrename failed")
  if (allocated(error)) return
  call check(error, id == 0_c_int, "Legacy renamed attribute differs")
end subroutine test_ncattrename

subroutine test_ncattdel(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, status, id

  call seed(error, ncid, enhanced=.false.)
  if (allocated(error)) return
  status = ncattdel(ncid, NC_GLOBAL, "a"//c_null_char)
  if (status == 1) then
    status = nc_inq_attid(ncid, NC_GLOBAL, "a"//c_null_char, id)
  end if
  if (status == NC_ENOTATT) status = NC_NOERR
  call finish(error, ncid, status, "ncattdel failed")
end subroutine test_ncattdel

end submodule nc4f_test_c_interface_attribute
