module nc4f_test_c_interface_io
use, intrinsic :: iso_c_binding, only: c_associated, c_char, c_int, &
  & c_loc, c_long, &
  & c_long_long, c_ptrdiff_t, c_short, c_signed_char, c_size_t, &
  & c_float, c_double, c_null_char, c_ptr, c_null_ptr
use, non_intrinsic :: testdrive, only: check, error_type, new_unittest, &
  & unittest_type
use, non_intrinsic :: nc4f_test_utility, only: open_dataset, finish
use, non_intrinsic :: nc4f_c_interface, only: nc_def_dim, nc_def_var, &
  & nc_enddef, nc_free_string, c_strlen, NC_CHAR, NC_INT, &
  & NC_STRING, NC_NOERR, &
  & nc_put_var_schar, nc_get_var_schar, nc_put_vara_schar, &
  & nc_get_vara_schar, nc_put_vars_schar, nc_get_vars_schar, &
  & nc_put_var1_schar, nc_get_var1_schar, nc_put_varm_schar, &
  & nc_get_varm_schar, nc_put_var_short, nc_get_var_short, &
  & nc_put_vara_short, nc_get_vara_short, nc_put_vars_short, &
  & nc_get_vars_short, nc_put_var1_short, nc_get_var1_short, &
  & nc_put_varm_short, nc_get_varm_short, nc_put_var_int, &
  & nc_get_var_int, nc_put_vara_int, nc_get_vara_int, &
  & nc_put_vars_int, nc_get_vars_int, nc_put_var1_int, &
  & nc_get_var1_int, nc_put_varm_int, nc_get_varm_int, &
  & nc_put_var_long, nc_get_var_long, nc_put_vara_long, &
  & nc_get_vara_long, nc_put_vars_long, nc_get_vars_long, &
  & nc_put_var1_long, nc_get_var1_long, nc_put_varm_long, &
  & nc_get_varm_long, nc_put_var_longlong, nc_get_var_longlong, &
  & nc_put_vara_longlong, nc_get_vara_longlong, nc_put_vars_longlong, &
  & nc_get_vars_longlong, nc_put_var1_longlong, nc_get_var1_longlong, &
  & nc_put_varm_longlong, nc_get_varm_longlong, nc_put_var_float, &
  & nc_get_var_float, nc_put_vara_float, nc_get_vara_float, &
  & nc_put_vars_float, nc_get_vars_float, nc_put_var1_float, &
  & nc_get_var1_float, nc_put_varm_float, nc_get_varm_float, &
  & nc_put_var_double, nc_get_var_double, nc_put_vara_double, &
  & nc_get_vara_double, nc_put_vars_double, nc_get_vars_double, &
  & nc_put_var1_double, nc_get_var1_double, nc_put_varm_double, &
  & nc_get_varm_double, nc_put_var, nc_get_var, &
  & nc_put_vara, nc_get_vara, nc_put_vars, &
  & nc_get_vars, nc_put_var1, nc_get_var1, &
  & nc_put_varm, nc_get_varm, &
  & nc_put_var_text, nc_get_var_text, nc_put_vara_text, &
  & nc_get_vara_text, nc_put_vars_text, nc_get_vars_text, &
  & nc_put_var1_text, nc_get_var1_text, nc_put_varm_text, &
  & nc_get_varm_text, nc_put_var_string, nc_get_var_string, &
  & nc_put_vara_string, nc_get_vara_string, nc_put_vars_string, &
  & nc_get_vars_string, nc_put_var1_string, nc_get_var1_string, &
  & nc_put_varm_string, nc_get_varm_string
implicit none (type, external)
private
public :: collect_c_interface_io

contains

subroutine collect_c_interface_io(tests)
  type(unittest_type), allocatable, intent(out) :: tests(:)
  tests = [ &
    & new_unittest("nc_put_var_schar", test_nc_put_var_schar), &
    & new_unittest("nc_get_var_schar", test_nc_get_var_schar), &
    & new_unittest("nc_put_vara_schar", test_nc_put_vara_schar), &
    & new_unittest("nc_get_vara_schar", test_nc_get_vara_schar), &
    & new_unittest("nc_put_vars_schar", test_nc_put_vars_schar), &
    & new_unittest("nc_get_vars_schar", test_nc_get_vars_schar), &
    & new_unittest("nc_put_var1_schar", test_nc_put_var1_schar), &
    & new_unittest("nc_get_var1_schar", test_nc_get_var1_schar), &
    & new_unittest("nc_put_varm_schar", test_nc_put_varm_schar), &
    & new_unittest("nc_get_varm_schar", test_nc_get_varm_schar), &
    & new_unittest("nc_put_var_short", test_nc_put_var_short), &
    & new_unittest("nc_get_var_short", test_nc_get_var_short), &
    & new_unittest("nc_put_vara_short", test_nc_put_vara_short), &
    & new_unittest("nc_get_vara_short", test_nc_get_vara_short), &
    & new_unittest("nc_put_vars_short", test_nc_put_vars_short), &
    & new_unittest("nc_get_vars_short", test_nc_get_vars_short), &
    & new_unittest("nc_put_var1_short", test_nc_put_var1_short), &
    & new_unittest("nc_get_var1_short", test_nc_get_var1_short), &
    & new_unittest("nc_put_varm_short", test_nc_put_varm_short), &
    & new_unittest("nc_get_varm_short", test_nc_get_varm_short), &
    & new_unittest("nc_put_var_int", test_nc_put_var_int), &
    & new_unittest("nc_get_var_int", test_nc_get_var_int), &
    & new_unittest("nc_put_vara_int", test_nc_put_vara_int), &
    & new_unittest("nc_get_vara_int", test_nc_get_vara_int), &
    & new_unittest("nc_put_vars_int", test_nc_put_vars_int), &
    & new_unittest("nc_get_vars_int", test_nc_get_vars_int), &
    & new_unittest("nc_put_var1_int", test_nc_put_var1_int), &
    & new_unittest("nc_get_var1_int", test_nc_get_var1_int), &
    & new_unittest("nc_put_varm_int", test_nc_put_varm_int), &
    & new_unittest("nc_get_varm_int", test_nc_get_varm_int), &
    & new_unittest("nc_put_var_long", test_nc_put_var_long), &
    & new_unittest("nc_get_var_long", test_nc_get_var_long), &
    & new_unittest("nc_put_vara_long", test_nc_put_vara_long), &
    & new_unittest("nc_get_vara_long", test_nc_get_vara_long), &
    & new_unittest("nc_put_vars_long", test_nc_put_vars_long), &
    & new_unittest("nc_get_vars_long", test_nc_get_vars_long), &
    & new_unittest("nc_put_var1_long", test_nc_put_var1_long), &
    & new_unittest("nc_get_var1_long", test_nc_get_var1_long), &
    & new_unittest("nc_put_varm_long", test_nc_put_varm_long), &
    & new_unittest("nc_get_varm_long", test_nc_get_varm_long), &
    & new_unittest("nc_put_var_longlong", test_nc_put_var_longlong), &
    & new_unittest("nc_get_var_longlong", test_nc_get_var_longlong), &
    & new_unittest("nc_put_vara_longlong", test_nc_put_vara_longlong), &
    & new_unittest("nc_get_vara_longlong", test_nc_get_vara_longlong), &
    & new_unittest("nc_put_vars_longlong", test_nc_put_vars_longlong), &
    & new_unittest("nc_get_vars_longlong", test_nc_get_vars_longlong), &
    & new_unittest("nc_put_var1_longlong", test_nc_put_var1_longlong), &
    & new_unittest("nc_get_var1_longlong", test_nc_get_var1_longlong), &
    & new_unittest("nc_put_varm_longlong", test_nc_put_varm_longlong), &
    & new_unittest("nc_get_varm_longlong", test_nc_get_varm_longlong), &
    & new_unittest("nc_put_var_float", test_nc_put_var_float), &
    & new_unittest("nc_get_var_float", test_nc_get_var_float), &
    & new_unittest("nc_put_vara_float", test_nc_put_vara_float), &
    & new_unittest("nc_get_vara_float", test_nc_get_vara_float), &
    & new_unittest("nc_put_vars_float", test_nc_put_vars_float), &
    & new_unittest("nc_get_vars_float", test_nc_get_vars_float), &
    & new_unittest("nc_put_var1_float", test_nc_put_var1_float), &
    & new_unittest("nc_get_var1_float", test_nc_get_var1_float), &
    & new_unittest("nc_put_varm_float", test_nc_put_varm_float), &
    & new_unittest("nc_get_varm_float", test_nc_get_varm_float), &
    & new_unittest("nc_put_var_double", test_nc_put_var_double), &
    & new_unittest("nc_get_var_double", test_nc_get_var_double), &
    & new_unittest("nc_put_vara_double", test_nc_put_vara_double), &
    & new_unittest("nc_get_vara_double", test_nc_get_vara_double), &
    & new_unittest("nc_put_vars_double", test_nc_put_vars_double), &
    & new_unittest("nc_get_vars_double", test_nc_get_vars_double), &
    & new_unittest("nc_put_var1_double", test_nc_put_var1_double), &
    & new_unittest("nc_get_var1_double", test_nc_get_var1_double), &
    & new_unittest("nc_put_varm_double", test_nc_put_varm_double), &
    & new_unittest("nc_get_varm_double", test_nc_get_varm_double), &
    & new_unittest("nc_put_var", test_nc_put_var), &
    & new_unittest("nc_get_var", test_nc_get_var), &
    & new_unittest("nc_put_vara", test_nc_put_vara), &
    & new_unittest("nc_get_vara", test_nc_get_vara), &
    & new_unittest("nc_put_vars", test_nc_put_vars), &
    & new_unittest("nc_get_vars", test_nc_get_vars), &
    & new_unittest("nc_put_var1", test_nc_put_var1), &
    & new_unittest("nc_get_var1", test_nc_get_var1), &
    & new_unittest("nc_put_varm", test_nc_put_varm), &
    & new_unittest("nc_get_varm", test_nc_get_varm), &
    & new_unittest("nc_put_var_text", test_nc_put_var_text), &
    & new_unittest("nc_get_var_text", test_nc_get_var_text), &
    & new_unittest("nc_put_vara_text", test_nc_put_vara_text), &
    & new_unittest("nc_get_vara_text", test_nc_get_vara_text), &
    & new_unittest("nc_put_vars_text", test_nc_put_vars_text), &
    & new_unittest("nc_get_vars_text", test_nc_get_vars_text), &
    & new_unittest("nc_put_var1_text", test_nc_put_var1_text), &
    & new_unittest("nc_get_var1_text", test_nc_get_var1_text), &
    & new_unittest("nc_put_varm_text", test_nc_put_varm_text), &
    & new_unittest("nc_get_varm_text", test_nc_get_varm_text), &
    & new_unittest("nc_put_var_string", test_nc_put_var_string), &
    & new_unittest("nc_get_var_string", test_nc_get_var_string), &
    & new_unittest("nc_put_vara_string", test_nc_put_vara_string), &
    & new_unittest("nc_get_vara_string", test_nc_get_vara_string), &
    & new_unittest("nc_put_vars_string", test_nc_put_vars_string), &
    & new_unittest("nc_get_vars_string", test_nc_get_vars_string), &
    & new_unittest("nc_put_var1_string", test_nc_put_var1_string), &
    & new_unittest("nc_get_var1_string", test_nc_get_var1_string), &
    & new_unittest("nc_put_varm_string", test_nc_put_varm_string), &
    & new_unittest("nc_get_varm_string", test_nc_get_varm_string) &
    & ]
end subroutine collect_c_interface_io

subroutine open_int_variable(error, ncid, varid)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int), intent(out) :: ncid, varid
  integer(c_int) :: dimid, status

  call open_dataset(error, ncid)
  if (allocated(error)) return
  status = nc_def_dim(ncid, "x"//c_null_char, 2_c_size_t, dimid)
  if (status == NC_NOERR) then
    status = nc_def_var(ncid, "v"//c_null_char, NC_INT, &
      & 1_c_int, [dimid], varid)
  end if
  if (status == NC_NOERR) status = nc_enddef(ncid)
  if (status == NC_NOERR) return
  call finish(error, ncid, status, "Variable setup failed")
end subroutine open_int_variable

subroutine test_nc_put_var_schar(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_signed_char), target :: values(2)
  integer(c_int), target :: actual(2)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_signed_char, 8_c_signed_char]
  actual = 0
  status = nc_put_var_schar(ncid, varid, &
    & c_loc(values))
  if (status == NC_NOERR) then
    status = nc_get_var_int(ncid, varid, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_var_schar failed")
  if (allocated(error)) return
  call check(error, all(actual == [7_c_int, 8_c_int]), &
    & "Variable data differs")
end subroutine test_nc_put_var_schar

subroutine test_nc_get_var_schar(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_signed_char), target :: values(2)
  integer(c_int), target :: initial(2)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_signed_char, 8_c_signed_char]
  initial = [7_c_int, 8_c_int]
  status = nc_put_var_int(ncid, varid, c_loc(initial))
  if (status /= NC_NOERR) then
    call finish(error, ncid, status, "Value setup failed")
    return
  end if
  values = 0
  status = nc_get_var_schar(ncid, varid, &
    & c_loc(values))
  call finish(error, ncid, status, "nc_get_var_schar failed")
  if (allocated(error)) return
  call check(error, all(values == initial), &
    & "Variable data differs")
end subroutine test_nc_get_var_schar

subroutine test_nc_put_vara_schar(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_signed_char), target :: values(2)
  integer(c_int), target :: actual(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_signed_char, 8_c_signed_char]
  actual = 0
  start = 0_c_size_t
  count = 2_c_size_t
  status = nc_put_vara_schar(ncid, varid, &
    & c_loc(start), c_loc(count), c_loc(values))
  if (status == NC_NOERR) then
    status = nc_get_var_int(ncid, varid, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_vara_schar failed")
  if (allocated(error)) return
  call check(error, all(actual == [7_c_int, 8_c_int]), &
    & "Variable data differs")
end subroutine test_nc_put_vara_schar

subroutine test_nc_get_vara_schar(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_signed_char), target :: values(2)
  integer(c_int), target :: initial(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_signed_char, 8_c_signed_char]
  initial = [7_c_int, 8_c_int]
  status = nc_put_var_int(ncid, varid, c_loc(initial))
  if (status /= NC_NOERR) then
    call finish(error, ncid, status, "Value setup failed")
    return
  end if
  values = 0
  start = 0_c_size_t
  count = 2_c_size_t
  status = nc_get_vara_schar(ncid, varid, &
    & c_loc(start), c_loc(count), c_loc(values))
  call finish(error, ncid, status, "nc_get_vara_schar failed")
  if (allocated(error)) return
  call check(error, all(values == initial), &
    & "Variable data differs")
end subroutine test_nc_get_vara_schar

subroutine test_nc_put_vars_schar(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_signed_char), target :: values(2)
  integer(c_int), target :: actual(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)
  integer(c_ptrdiff_t), target :: stride(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_signed_char, 8_c_signed_char]
  actual = 0
  start = 0_c_size_t
  count = 2_c_size_t
  stride = 1_c_ptrdiff_t
  status = nc_put_vars_schar(ncid, varid, &
    & c_loc(start), c_loc(count), c_loc(stride), c_loc(values))
  if (status == NC_NOERR) then
    status = nc_get_var_int(ncid, varid, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_vars_schar failed")
  if (allocated(error)) return
  call check(error, all(actual == [7_c_int, 8_c_int]), &
    & "Variable data differs")
end subroutine test_nc_put_vars_schar

subroutine test_nc_get_vars_schar(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_signed_char), target :: values(2)
  integer(c_int), target :: initial(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)
  integer(c_ptrdiff_t), target :: stride(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_signed_char, 8_c_signed_char]
  initial = [7_c_int, 8_c_int]
  status = nc_put_var_int(ncid, varid, c_loc(initial))
  if (status /= NC_NOERR) then
    call finish(error, ncid, status, "Value setup failed")
    return
  end if
  values = 0
  start = 0_c_size_t
  count = 2_c_size_t
  stride = 1_c_ptrdiff_t
  status = nc_get_vars_schar(ncid, varid, &
    & c_loc(start), c_loc(count), c_loc(stride), c_loc(values))
  call finish(error, ncid, status, "nc_get_vars_schar failed")
  if (allocated(error)) return
  call check(error, all(values == initial), &
    & "Variable data differs")
end subroutine test_nc_get_vars_schar

subroutine test_nc_put_var1_schar(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_signed_char), target :: values(1)
  integer(c_int), target :: actual(2)
  integer(c_size_t), target :: start(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_signed_char]
  actual = 0
  start = 0_c_size_t
  status = nc_put_var1_schar(ncid, varid, &
    & c_loc(start), c_loc(values))
  if (status == NC_NOERR) then
    status = nc_get_var_int(ncid, varid, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_var1_schar failed")
  if (allocated(error)) return
  call check(error, actual(1) == 7_c_int, &
    & "Variable data differs")
end subroutine test_nc_put_var1_schar

subroutine test_nc_get_var1_schar(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_signed_char), target :: values(1)
  integer(c_int), target :: initial(2)
  integer(c_size_t), target :: start(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_signed_char]
  initial = [7_c_int, 8_c_int]
  status = nc_put_var_int(ncid, varid, c_loc(initial))
  if (status /= NC_NOERR) then
    call finish(error, ncid, status, "Value setup failed")
    return
  end if
  values = 0
  start = 0_c_size_t
  status = nc_get_var1_schar(ncid, varid, &
    & c_loc(start), c_loc(values))
  call finish(error, ncid, status, "nc_get_var1_schar failed")
  if (allocated(error)) return
  call check(error, all(values == initial(1:1)), &
    & "Variable data differs")
end subroutine test_nc_get_var1_schar

subroutine test_nc_put_varm_schar(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_signed_char), target :: values(2)
  integer(c_int), target :: actual(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)
  integer(c_ptrdiff_t), target :: stride(1)
  integer(c_ptrdiff_t), target :: imap(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_signed_char, 8_c_signed_char]
  actual = 0
  start = 0_c_size_t
  count = 2_c_size_t
  stride = 1_c_ptrdiff_t
  imap = 1_c_ptrdiff_t
  status = nc_put_varm_schar(ncid, varid, &
    & c_loc(start), c_loc(count), &
    & c_loc(stride), c_loc(imap), c_loc(values))
  if (status == NC_NOERR) then
    status = nc_get_var_int(ncid, varid, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_varm_schar failed")
  if (allocated(error)) return
  call check(error, all(actual == [7_c_int, 8_c_int]), &
    & "Variable data differs")
end subroutine test_nc_put_varm_schar

subroutine test_nc_get_varm_schar(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_signed_char), target :: values(2)
  integer(c_int), target :: initial(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)
  integer(c_ptrdiff_t), target :: stride(1)
  integer(c_ptrdiff_t), target :: imap(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_signed_char, 8_c_signed_char]
  initial = [7_c_int, 8_c_int]
  status = nc_put_var_int(ncid, varid, c_loc(initial))
  if (status /= NC_NOERR) then
    call finish(error, ncid, status, "Value setup failed")
    return
  end if
  values = 0
  start = 0_c_size_t
  count = 2_c_size_t
  stride = 1_c_ptrdiff_t
  imap = 1_c_ptrdiff_t
  status = nc_get_varm_schar(ncid, varid, &
    & c_loc(start), c_loc(count), &
    & c_loc(stride), c_loc(imap), c_loc(values))
  call finish(error, ncid, status, "nc_get_varm_schar failed")
  if (allocated(error)) return
  call check(error, all(values == initial), &
    & "Variable data differs")
end subroutine test_nc_get_varm_schar

subroutine test_nc_put_var_short(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_short), target :: values(2)
  integer(c_int), target :: actual(2)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_short, 8_c_short]
  actual = 0
  status = nc_put_var_short(ncid, varid, &
    & c_loc(values))
  if (status == NC_NOERR) then
    status = nc_get_var_int(ncid, varid, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_var_short failed")
  if (allocated(error)) return
  call check(error, all(actual == [7_c_int, 8_c_int]), &
    & "Variable data differs")
end subroutine test_nc_put_var_short

subroutine test_nc_get_var_short(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_short), target :: values(2)
  integer(c_int), target :: initial(2)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_short, 8_c_short]
  initial = [7_c_int, 8_c_int]
  status = nc_put_var_int(ncid, varid, c_loc(initial))
  if (status /= NC_NOERR) then
    call finish(error, ncid, status, "Value setup failed")
    return
  end if
  values = 0
  status = nc_get_var_short(ncid, varid, &
    & c_loc(values))
  call finish(error, ncid, status, "nc_get_var_short failed")
  if (allocated(error)) return
  call check(error, all(values == initial), &
    & "Variable data differs")
end subroutine test_nc_get_var_short

subroutine test_nc_put_vara_short(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_short), target :: values(2)
  integer(c_int), target :: actual(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_short, 8_c_short]
  actual = 0
  start = 0_c_size_t
  count = 2_c_size_t
  status = nc_put_vara_short(ncid, varid, &
    & c_loc(start), c_loc(count), c_loc(values))
  if (status == NC_NOERR) then
    status = nc_get_var_int(ncid, varid, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_vara_short failed")
  if (allocated(error)) return
  call check(error, all(actual == [7_c_int, 8_c_int]), &
    & "Variable data differs")
end subroutine test_nc_put_vara_short

subroutine test_nc_get_vara_short(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_short), target :: values(2)
  integer(c_int), target :: initial(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_short, 8_c_short]
  initial = [7_c_int, 8_c_int]
  status = nc_put_var_int(ncid, varid, c_loc(initial))
  if (status /= NC_NOERR) then
    call finish(error, ncid, status, "Value setup failed")
    return
  end if
  values = 0
  start = 0_c_size_t
  count = 2_c_size_t
  status = nc_get_vara_short(ncid, varid, &
    & c_loc(start), c_loc(count), c_loc(values))
  call finish(error, ncid, status, "nc_get_vara_short failed")
  if (allocated(error)) return
  call check(error, all(values == initial), &
    & "Variable data differs")
end subroutine test_nc_get_vara_short

subroutine test_nc_put_vars_short(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_short), target :: values(2)
  integer(c_int), target :: actual(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)
  integer(c_ptrdiff_t), target :: stride(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_short, 8_c_short]
  actual = 0
  start = 0_c_size_t
  count = 2_c_size_t
  stride = 1_c_ptrdiff_t
  status = nc_put_vars_short(ncid, varid, &
    & c_loc(start), c_loc(count), c_loc(stride), c_loc(values))
  if (status == NC_NOERR) then
    status = nc_get_var_int(ncid, varid, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_vars_short failed")
  if (allocated(error)) return
  call check(error, all(actual == [7_c_int, 8_c_int]), &
    & "Variable data differs")
end subroutine test_nc_put_vars_short

subroutine test_nc_get_vars_short(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_short), target :: values(2)
  integer(c_int), target :: initial(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)
  integer(c_ptrdiff_t), target :: stride(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_short, 8_c_short]
  initial = [7_c_int, 8_c_int]
  status = nc_put_var_int(ncid, varid, c_loc(initial))
  if (status /= NC_NOERR) then
    call finish(error, ncid, status, "Value setup failed")
    return
  end if
  values = 0
  start = 0_c_size_t
  count = 2_c_size_t
  stride = 1_c_ptrdiff_t
  status = nc_get_vars_short(ncid, varid, &
    & c_loc(start), c_loc(count), c_loc(stride), c_loc(values))
  call finish(error, ncid, status, "nc_get_vars_short failed")
  if (allocated(error)) return
  call check(error, all(values == initial), &
    & "Variable data differs")
end subroutine test_nc_get_vars_short

subroutine test_nc_put_var1_short(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_short), target :: values(1)
  integer(c_int), target :: actual(2)
  integer(c_size_t), target :: start(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_short]
  actual = 0
  start = 0_c_size_t
  status = nc_put_var1_short(ncid, varid, &
    & c_loc(start), c_loc(values))
  if (status == NC_NOERR) then
    status = nc_get_var_int(ncid, varid, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_var1_short failed")
  if (allocated(error)) return
  call check(error, actual(1) == 7_c_int, &
    & "Variable data differs")
end subroutine test_nc_put_var1_short

subroutine test_nc_get_var1_short(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_short), target :: values(1)
  integer(c_int), target :: initial(2)
  integer(c_size_t), target :: start(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_short]
  initial = [7_c_int, 8_c_int]
  status = nc_put_var_int(ncid, varid, c_loc(initial))
  if (status /= NC_NOERR) then
    call finish(error, ncid, status, "Value setup failed")
    return
  end if
  values = 0
  start = 0_c_size_t
  status = nc_get_var1_short(ncid, varid, &
    & c_loc(start), c_loc(values))
  call finish(error, ncid, status, "nc_get_var1_short failed")
  if (allocated(error)) return
  call check(error, all(values == initial(1:1)), &
    & "Variable data differs")
end subroutine test_nc_get_var1_short

subroutine test_nc_put_varm_short(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_short), target :: values(2)
  integer(c_int), target :: actual(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)
  integer(c_ptrdiff_t), target :: stride(1)
  integer(c_ptrdiff_t), target :: imap(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_short, 8_c_short]
  actual = 0
  start = 0_c_size_t
  count = 2_c_size_t
  stride = 1_c_ptrdiff_t
  imap = 1_c_ptrdiff_t
  status = nc_put_varm_short(ncid, varid, &
    & c_loc(start), c_loc(count), &
    & c_loc(stride), c_loc(imap), c_loc(values))
  if (status == NC_NOERR) then
    status = nc_get_var_int(ncid, varid, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_varm_short failed")
  if (allocated(error)) return
  call check(error, all(actual == [7_c_int, 8_c_int]), &
    & "Variable data differs")
end subroutine test_nc_put_varm_short

subroutine test_nc_get_varm_short(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_short), target :: values(2)
  integer(c_int), target :: initial(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)
  integer(c_ptrdiff_t), target :: stride(1)
  integer(c_ptrdiff_t), target :: imap(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_short, 8_c_short]
  initial = [7_c_int, 8_c_int]
  status = nc_put_var_int(ncid, varid, c_loc(initial))
  if (status /= NC_NOERR) then
    call finish(error, ncid, status, "Value setup failed")
    return
  end if
  values = 0
  start = 0_c_size_t
  count = 2_c_size_t
  stride = 1_c_ptrdiff_t
  imap = 1_c_ptrdiff_t
  status = nc_get_varm_short(ncid, varid, &
    & c_loc(start), c_loc(count), &
    & c_loc(stride), c_loc(imap), c_loc(values))
  call finish(error, ncid, status, "nc_get_varm_short failed")
  if (allocated(error)) return
  call check(error, all(values == initial), &
    & "Variable data differs")
end subroutine test_nc_get_varm_short

subroutine test_nc_put_var_int(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_int), target :: values(2)
  integer(c_int), target :: actual(2)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_int, 8_c_int]
  actual = 0
  status = nc_put_var_int(ncid, varid, &
    & c_loc(values))
  if (status == NC_NOERR) then
    status = nc_get_var_int(ncid, varid, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_var_int failed")
  if (allocated(error)) return
  call check(error, all(actual == [7_c_int, 8_c_int]), &
    & "Variable data differs")
end subroutine test_nc_put_var_int

subroutine test_nc_get_var_int(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_int), target :: values(2)
  integer(c_int), target :: initial(2)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_int, 8_c_int]
  initial = [7_c_int, 8_c_int]
  status = nc_put_var_int(ncid, varid, c_loc(initial))
  if (status /= NC_NOERR) then
    call finish(error, ncid, status, "Value setup failed")
    return
  end if
  values = 0
  status = nc_get_var_int(ncid, varid, &
    & c_loc(values))
  call finish(error, ncid, status, "nc_get_var_int failed")
  if (allocated(error)) return
  call check(error, all(values == initial), &
    & "Variable data differs")
end subroutine test_nc_get_var_int

subroutine test_nc_put_vara_int(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_int), target :: values(2)
  integer(c_int), target :: actual(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_int, 8_c_int]
  actual = 0
  start = 0_c_size_t
  count = 2_c_size_t
  status = nc_put_vara_int(ncid, varid, &
    & c_loc(start), c_loc(count), c_loc(values))
  if (status == NC_NOERR) then
    status = nc_get_var_int(ncid, varid, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_vara_int failed")
  if (allocated(error)) return
  call check(error, all(actual == [7_c_int, 8_c_int]), &
    & "Variable data differs")
end subroutine test_nc_put_vara_int

subroutine test_nc_get_vara_int(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_int), target :: values(2)
  integer(c_int), target :: initial(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_int, 8_c_int]
  initial = [7_c_int, 8_c_int]
  status = nc_put_var_int(ncid, varid, c_loc(initial))
  if (status /= NC_NOERR) then
    call finish(error, ncid, status, "Value setup failed")
    return
  end if
  values = 0
  start = 0_c_size_t
  count = 2_c_size_t
  status = nc_get_vara_int(ncid, varid, &
    & c_loc(start), c_loc(count), c_loc(values))
  call finish(error, ncid, status, "nc_get_vara_int failed")
  if (allocated(error)) return
  call check(error, all(values == initial), &
    & "Variable data differs")
end subroutine test_nc_get_vara_int

subroutine test_nc_put_vars_int(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_int), target :: values(2)
  integer(c_int), target :: actual(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)
  integer(c_ptrdiff_t), target :: stride(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_int, 8_c_int]
  actual = 0
  start = 0_c_size_t
  count = 2_c_size_t
  stride = 1_c_ptrdiff_t
  status = nc_put_vars_int(ncid, varid, &
    & c_loc(start), c_loc(count), c_loc(stride), c_loc(values))
  if (status == NC_NOERR) then
    status = nc_get_var_int(ncid, varid, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_vars_int failed")
  if (allocated(error)) return
  call check(error, all(actual == [7_c_int, 8_c_int]), &
    & "Variable data differs")
end subroutine test_nc_put_vars_int

subroutine test_nc_get_vars_int(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_int), target :: values(2)
  integer(c_int), target :: initial(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)
  integer(c_ptrdiff_t), target :: stride(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_int, 8_c_int]
  initial = [7_c_int, 8_c_int]
  status = nc_put_var_int(ncid, varid, c_loc(initial))
  if (status /= NC_NOERR) then
    call finish(error, ncid, status, "Value setup failed")
    return
  end if
  values = 0
  start = 0_c_size_t
  count = 2_c_size_t
  stride = 1_c_ptrdiff_t
  status = nc_get_vars_int(ncid, varid, &
    & c_loc(start), c_loc(count), c_loc(stride), c_loc(values))
  call finish(error, ncid, status, "nc_get_vars_int failed")
  if (allocated(error)) return
  call check(error, all(values == initial), &
    & "Variable data differs")
end subroutine test_nc_get_vars_int

subroutine test_nc_put_var1_int(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_int), target :: values(1)
  integer(c_int), target :: actual(2)
  integer(c_size_t), target :: start(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_int]
  actual = 0
  start = 0_c_size_t
  status = nc_put_var1_int(ncid, varid, &
    & c_loc(start), c_loc(values))
  if (status == NC_NOERR) then
    status = nc_get_var_int(ncid, varid, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_var1_int failed")
  if (allocated(error)) return
  call check(error, actual(1) == 7_c_int, &
    & "Variable data differs")
end subroutine test_nc_put_var1_int

subroutine test_nc_get_var1_int(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_int), target :: values(1)
  integer(c_int), target :: initial(2)
  integer(c_size_t), target :: start(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_int]
  initial = [7_c_int, 8_c_int]
  status = nc_put_var_int(ncid, varid, c_loc(initial))
  if (status /= NC_NOERR) then
    call finish(error, ncid, status, "Value setup failed")
    return
  end if
  values = 0
  start = 0_c_size_t
  status = nc_get_var1_int(ncid, varid, &
    & c_loc(start), c_loc(values))
  call finish(error, ncid, status, "nc_get_var1_int failed")
  if (allocated(error)) return
  call check(error, all(values == initial(1:1)), &
    & "Variable data differs")
end subroutine test_nc_get_var1_int

subroutine test_nc_put_varm_int(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_int), target :: values(2)
  integer(c_int), target :: actual(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)
  integer(c_ptrdiff_t), target :: stride(1)
  integer(c_ptrdiff_t), target :: imap(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_int, 8_c_int]
  actual = 0
  start = 0_c_size_t
  count = 2_c_size_t
  stride = 1_c_ptrdiff_t
  imap = 1_c_ptrdiff_t
  status = nc_put_varm_int(ncid, varid, &
    & c_loc(start), c_loc(count), &
    & c_loc(stride), c_loc(imap), c_loc(values))
  if (status == NC_NOERR) then
    status = nc_get_var_int(ncid, varid, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_varm_int failed")
  if (allocated(error)) return
  call check(error, all(actual == [7_c_int, 8_c_int]), &
    & "Variable data differs")
end subroutine test_nc_put_varm_int

subroutine test_nc_get_varm_int(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_int), target :: values(2)
  integer(c_int), target :: initial(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)
  integer(c_ptrdiff_t), target :: stride(1)
  integer(c_ptrdiff_t), target :: imap(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_int, 8_c_int]
  initial = [7_c_int, 8_c_int]
  status = nc_put_var_int(ncid, varid, c_loc(initial))
  if (status /= NC_NOERR) then
    call finish(error, ncid, status, "Value setup failed")
    return
  end if
  values = 0
  start = 0_c_size_t
  count = 2_c_size_t
  stride = 1_c_ptrdiff_t
  imap = 1_c_ptrdiff_t
  status = nc_get_varm_int(ncid, varid, &
    & c_loc(start), c_loc(count), &
    & c_loc(stride), c_loc(imap), c_loc(values))
  call finish(error, ncid, status, "nc_get_varm_int failed")
  if (allocated(error)) return
  call check(error, all(values == initial), &
    & "Variable data differs")
end subroutine test_nc_get_varm_int

subroutine test_nc_put_var_long(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_long), target :: values(2)
  integer(c_int), target :: actual(2)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_long, 8_c_long]
  actual = 0
  status = nc_put_var_long(ncid, varid, &
    & c_loc(values))
  if (status == NC_NOERR) then
    status = nc_get_var_int(ncid, varid, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_var_long failed")
  if (allocated(error)) return
  call check(error, all(actual == [7_c_int, 8_c_int]), &
    & "Variable data differs")
end subroutine test_nc_put_var_long

subroutine test_nc_get_var_long(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_long), target :: values(2)
  integer(c_int), target :: initial(2)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_long, 8_c_long]
  initial = [7_c_int, 8_c_int]
  status = nc_put_var_int(ncid, varid, c_loc(initial))
  if (status /= NC_NOERR) then
    call finish(error, ncid, status, "Value setup failed")
    return
  end if
  values = 0
  status = nc_get_var_long(ncid, varid, &
    & c_loc(values))
  call finish(error, ncid, status, "nc_get_var_long failed")
  if (allocated(error)) return
  call check(error, all(values == initial), &
    & "Variable data differs")
end subroutine test_nc_get_var_long

subroutine test_nc_put_vara_long(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_long), target :: values(2)
  integer(c_int), target :: actual(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_long, 8_c_long]
  actual = 0
  start = 0_c_size_t
  count = 2_c_size_t
  status = nc_put_vara_long(ncid, varid, &
    & c_loc(start), c_loc(count), c_loc(values))
  if (status == NC_NOERR) then
    status = nc_get_var_int(ncid, varid, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_vara_long failed")
  if (allocated(error)) return
  call check(error, all(actual == [7_c_int, 8_c_int]), &
    & "Variable data differs")
end subroutine test_nc_put_vara_long

subroutine test_nc_get_vara_long(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_long), target :: values(2)
  integer(c_int), target :: initial(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_long, 8_c_long]
  initial = [7_c_int, 8_c_int]
  status = nc_put_var_int(ncid, varid, c_loc(initial))
  if (status /= NC_NOERR) then
    call finish(error, ncid, status, "Value setup failed")
    return
  end if
  values = 0
  start = 0_c_size_t
  count = 2_c_size_t
  status = nc_get_vara_long(ncid, varid, &
    & c_loc(start), c_loc(count), c_loc(values))
  call finish(error, ncid, status, "nc_get_vara_long failed")
  if (allocated(error)) return
  call check(error, all(values == initial), &
    & "Variable data differs")
end subroutine test_nc_get_vara_long

subroutine test_nc_put_vars_long(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_long), target :: values(2)
  integer(c_int), target :: actual(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)
  integer(c_ptrdiff_t), target :: stride(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_long, 8_c_long]
  actual = 0
  start = 0_c_size_t
  count = 2_c_size_t
  stride = 1_c_ptrdiff_t
  status = nc_put_vars_long(ncid, varid, &
    & c_loc(start), c_loc(count), c_loc(stride), c_loc(values))
  if (status == NC_NOERR) then
    status = nc_get_var_int(ncid, varid, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_vars_long failed")
  if (allocated(error)) return
  call check(error, all(actual == [7_c_int, 8_c_int]), &
    & "Variable data differs")
end subroutine test_nc_put_vars_long

subroutine test_nc_get_vars_long(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_long), target :: values(2)
  integer(c_int), target :: initial(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)
  integer(c_ptrdiff_t), target :: stride(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_long, 8_c_long]
  initial = [7_c_int, 8_c_int]
  status = nc_put_var_int(ncid, varid, c_loc(initial))
  if (status /= NC_NOERR) then
    call finish(error, ncid, status, "Value setup failed")
    return
  end if
  values = 0
  start = 0_c_size_t
  count = 2_c_size_t
  stride = 1_c_ptrdiff_t
  status = nc_get_vars_long(ncid, varid, &
    & c_loc(start), c_loc(count), c_loc(stride), c_loc(values))
  call finish(error, ncid, status, "nc_get_vars_long failed")
  if (allocated(error)) return
  call check(error, all(values == initial), &
    & "Variable data differs")
end subroutine test_nc_get_vars_long

subroutine test_nc_put_var1_long(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_long), target :: values(1)
  integer(c_int), target :: actual(2)
  integer(c_size_t), target :: start(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_long]
  actual = 0
  start = 0_c_size_t
  status = nc_put_var1_long(ncid, varid, &
    & c_loc(start), c_loc(values))
  if (status == NC_NOERR) then
    status = nc_get_var_int(ncid, varid, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_var1_long failed")
  if (allocated(error)) return
  call check(error, actual(1) == 7_c_int, &
    & "Variable data differs")
end subroutine test_nc_put_var1_long

subroutine test_nc_get_var1_long(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_long), target :: values(1)
  integer(c_int), target :: initial(2)
  integer(c_size_t), target :: start(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_long]
  initial = [7_c_int, 8_c_int]
  status = nc_put_var_int(ncid, varid, c_loc(initial))
  if (status /= NC_NOERR) then
    call finish(error, ncid, status, "Value setup failed")
    return
  end if
  values = 0
  start = 0_c_size_t
  status = nc_get_var1_long(ncid, varid, &
    & c_loc(start), c_loc(values))
  call finish(error, ncid, status, "nc_get_var1_long failed")
  if (allocated(error)) return
  call check(error, all(values == initial(1:1)), &
    & "Variable data differs")
end subroutine test_nc_get_var1_long

subroutine test_nc_put_varm_long(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_long), target :: values(2)
  integer(c_int), target :: actual(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)
  integer(c_ptrdiff_t), target :: stride(1)
  integer(c_ptrdiff_t), target :: imap(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_long, 8_c_long]
  actual = 0
  start = 0_c_size_t
  count = 2_c_size_t
  stride = 1_c_ptrdiff_t
  imap = 1_c_ptrdiff_t
  status = nc_put_varm_long(ncid, varid, &
    & c_loc(start), c_loc(count), &
    & c_loc(stride), c_loc(imap), c_loc(values))
  if (status == NC_NOERR) then
    status = nc_get_var_int(ncid, varid, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_varm_long failed")
  if (allocated(error)) return
  call check(error, all(actual == [7_c_int, 8_c_int]), &
    & "Variable data differs")
end subroutine test_nc_put_varm_long

subroutine test_nc_get_varm_long(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_long), target :: values(2)
  integer(c_int), target :: initial(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)
  integer(c_ptrdiff_t), target :: stride(1)
  integer(c_ptrdiff_t), target :: imap(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_long, 8_c_long]
  initial = [7_c_int, 8_c_int]
  status = nc_put_var_int(ncid, varid, c_loc(initial))
  if (status /= NC_NOERR) then
    call finish(error, ncid, status, "Value setup failed")
    return
  end if
  values = 0
  start = 0_c_size_t
  count = 2_c_size_t
  stride = 1_c_ptrdiff_t
  imap = 1_c_ptrdiff_t
  status = nc_get_varm_long(ncid, varid, &
    & c_loc(start), c_loc(count), &
    & c_loc(stride), c_loc(imap), c_loc(values))
  call finish(error, ncid, status, "nc_get_varm_long failed")
  if (allocated(error)) return
  call check(error, all(values == initial), &
    & "Variable data differs")
end subroutine test_nc_get_varm_long

subroutine test_nc_put_var_longlong(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_long_long), target :: values(2)
  integer(c_int), target :: actual(2)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_long_long, 8_c_long_long]
  actual = 0
  status = nc_put_var_longlong(ncid, varid, &
    & c_loc(values))
  if (status == NC_NOERR) then
    status = nc_get_var_int(ncid, varid, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_var_longlong failed")
  if (allocated(error)) return
  call check(error, all(actual == [7_c_int, 8_c_int]), &
    & "Variable data differs")
end subroutine test_nc_put_var_longlong

subroutine test_nc_get_var_longlong(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_long_long), target :: values(2)
  integer(c_int), target :: initial(2)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_long_long, 8_c_long_long]
  initial = [7_c_int, 8_c_int]
  status = nc_put_var_int(ncid, varid, c_loc(initial))
  if (status /= NC_NOERR) then
    call finish(error, ncid, status, "Value setup failed")
    return
  end if
  values = 0
  status = nc_get_var_longlong(ncid, varid, &
    & c_loc(values))
  call finish(error, ncid, status, "nc_get_var_longlong failed")
  if (allocated(error)) return
  call check(error, all(values == initial), &
    & "Variable data differs")
end subroutine test_nc_get_var_longlong

subroutine test_nc_put_vara_longlong(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_long_long), target :: values(2)
  integer(c_int), target :: actual(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_long_long, 8_c_long_long]
  actual = 0
  start = 0_c_size_t
  count = 2_c_size_t
  status = nc_put_vara_longlong(ncid, varid, &
    & c_loc(start), c_loc(count), c_loc(values))
  if (status == NC_NOERR) then
    status = nc_get_var_int(ncid, varid, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_vara_longlong failed")
  if (allocated(error)) return
  call check(error, all(actual == [7_c_int, 8_c_int]), &
    & "Variable data differs")
end subroutine test_nc_put_vara_longlong

subroutine test_nc_get_vara_longlong(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_long_long), target :: values(2)
  integer(c_int), target :: initial(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_long_long, 8_c_long_long]
  initial = [7_c_int, 8_c_int]
  status = nc_put_var_int(ncid, varid, c_loc(initial))
  if (status /= NC_NOERR) then
    call finish(error, ncid, status, "Value setup failed")
    return
  end if
  values = 0
  start = 0_c_size_t
  count = 2_c_size_t
  status = nc_get_vara_longlong(ncid, varid, &
    & c_loc(start), c_loc(count), c_loc(values))
  call finish(error, ncid, status, "nc_get_vara_longlong failed")
  if (allocated(error)) return
  call check(error, all(values == initial), &
    & "Variable data differs")
end subroutine test_nc_get_vara_longlong

subroutine test_nc_put_vars_longlong(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_long_long), target :: values(2)
  integer(c_int), target :: actual(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)
  integer(c_ptrdiff_t), target :: stride(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_long_long, 8_c_long_long]
  actual = 0
  start = 0_c_size_t
  count = 2_c_size_t
  stride = 1_c_ptrdiff_t
  status = nc_put_vars_longlong(ncid, varid, &
    & c_loc(start), c_loc(count), c_loc(stride), c_loc(values))
  if (status == NC_NOERR) then
    status = nc_get_var_int(ncid, varid, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_vars_longlong failed")
  if (allocated(error)) return
  call check(error, all(actual == [7_c_int, 8_c_int]), &
    & "Variable data differs")
end subroutine test_nc_put_vars_longlong

subroutine test_nc_get_vars_longlong(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_long_long), target :: values(2)
  integer(c_int), target :: initial(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)
  integer(c_ptrdiff_t), target :: stride(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_long_long, 8_c_long_long]
  initial = [7_c_int, 8_c_int]
  status = nc_put_var_int(ncid, varid, c_loc(initial))
  if (status /= NC_NOERR) then
    call finish(error, ncid, status, "Value setup failed")
    return
  end if
  values = 0
  start = 0_c_size_t
  count = 2_c_size_t
  stride = 1_c_ptrdiff_t
  status = nc_get_vars_longlong(ncid, varid, &
    & c_loc(start), c_loc(count), c_loc(stride), c_loc(values))
  call finish(error, ncid, status, "nc_get_vars_longlong failed")
  if (allocated(error)) return
  call check(error, all(values == initial), &
    & "Variable data differs")
end subroutine test_nc_get_vars_longlong

subroutine test_nc_put_var1_longlong(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_long_long), target :: values(1)
  integer(c_int), target :: actual(2)
  integer(c_size_t), target :: start(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_long_long]
  actual = 0
  start = 0_c_size_t
  status = nc_put_var1_longlong(ncid, varid, &
    & c_loc(start), c_loc(values))
  if (status == NC_NOERR) then
    status = nc_get_var_int(ncid, varid, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_var1_longlong failed")
  if (allocated(error)) return
  call check(error, actual(1) == 7_c_int, &
    & "Variable data differs")
end subroutine test_nc_put_var1_longlong

subroutine test_nc_get_var1_longlong(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_long_long), target :: values(1)
  integer(c_int), target :: initial(2)
  integer(c_size_t), target :: start(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_long_long]
  initial = [7_c_int, 8_c_int]
  status = nc_put_var_int(ncid, varid, c_loc(initial))
  if (status /= NC_NOERR) then
    call finish(error, ncid, status, "Value setup failed")
    return
  end if
  values = 0
  start = 0_c_size_t
  status = nc_get_var1_longlong(ncid, varid, &
    & c_loc(start), c_loc(values))
  call finish(error, ncid, status, "nc_get_var1_longlong failed")
  if (allocated(error)) return
  call check(error, all(values == initial(1:1)), &
    & "Variable data differs")
end subroutine test_nc_get_var1_longlong

subroutine test_nc_put_varm_longlong(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_long_long), target :: values(2)
  integer(c_int), target :: actual(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)
  integer(c_ptrdiff_t), target :: stride(1)
  integer(c_ptrdiff_t), target :: imap(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_long_long, 8_c_long_long]
  actual = 0
  start = 0_c_size_t
  count = 2_c_size_t
  stride = 1_c_ptrdiff_t
  imap = 1_c_ptrdiff_t
  status = nc_put_varm_longlong(ncid, varid, &
    & c_loc(start), c_loc(count), &
    & c_loc(stride), c_loc(imap), c_loc(values))
  if (status == NC_NOERR) then
    status = nc_get_var_int(ncid, varid, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_varm_longlong failed")
  if (allocated(error)) return
  call check(error, all(actual == [7_c_int, 8_c_int]), &
    & "Variable data differs")
end subroutine test_nc_put_varm_longlong

subroutine test_nc_get_varm_longlong(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_long_long), target :: values(2)
  integer(c_int), target :: initial(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)
  integer(c_ptrdiff_t), target :: stride(1)
  integer(c_ptrdiff_t), target :: imap(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_long_long, 8_c_long_long]
  initial = [7_c_int, 8_c_int]
  status = nc_put_var_int(ncid, varid, c_loc(initial))
  if (status /= NC_NOERR) then
    call finish(error, ncid, status, "Value setup failed")
    return
  end if
  values = 0
  start = 0_c_size_t
  count = 2_c_size_t
  stride = 1_c_ptrdiff_t
  imap = 1_c_ptrdiff_t
  status = nc_get_varm_longlong(ncid, varid, &
    & c_loc(start), c_loc(count), &
    & c_loc(stride), c_loc(imap), c_loc(values))
  call finish(error, ncid, status, "nc_get_varm_longlong failed")
  if (allocated(error)) return
  call check(error, all(values == initial), &
    & "Variable data differs")
end subroutine test_nc_get_varm_longlong

subroutine test_nc_put_var_float(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  real(c_float), target :: values(2)
  integer(c_int), target :: actual(2)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7.0_c_float, 8.0_c_float]
  actual = 0
  status = nc_put_var_float(ncid, varid, &
    & c_loc(values))
  if (status == NC_NOERR) then
    status = nc_get_var_int(ncid, varid, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_var_float failed")
  if (allocated(error)) return
  call check(error, all(actual == [7_c_int, 8_c_int]), &
    & "Variable data differs")
end subroutine test_nc_put_var_float

subroutine test_nc_get_var_float(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  real(c_float), target :: values(2)
  integer(c_int), target :: initial(2)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7.0_c_float, 8.0_c_float]
  initial = [7_c_int, 8_c_int]
  status = nc_put_var_int(ncid, varid, c_loc(initial))
  if (status /= NC_NOERR) then
    call finish(error, ncid, status, "Value setup failed")
    return
  end if
  values = 0
  status = nc_get_var_float(ncid, varid, &
    & c_loc(values))
  call finish(error, ncid, status, "nc_get_var_float failed")
  if (allocated(error)) return
  call check(error, all(values == initial), &
    & "Variable data differs")
end subroutine test_nc_get_var_float

subroutine test_nc_put_vara_float(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  real(c_float), target :: values(2)
  integer(c_int), target :: actual(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7.0_c_float, 8.0_c_float]
  actual = 0
  start = 0_c_size_t
  count = 2_c_size_t
  status = nc_put_vara_float(ncid, varid, &
    & c_loc(start), c_loc(count), c_loc(values))
  if (status == NC_NOERR) then
    status = nc_get_var_int(ncid, varid, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_vara_float failed")
  if (allocated(error)) return
  call check(error, all(actual == [7_c_int, 8_c_int]), &
    & "Variable data differs")
end subroutine test_nc_put_vara_float

subroutine test_nc_get_vara_float(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  real(c_float), target :: values(2)
  integer(c_int), target :: initial(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7.0_c_float, 8.0_c_float]
  initial = [7_c_int, 8_c_int]
  status = nc_put_var_int(ncid, varid, c_loc(initial))
  if (status /= NC_NOERR) then
    call finish(error, ncid, status, "Value setup failed")
    return
  end if
  values = 0
  start = 0_c_size_t
  count = 2_c_size_t
  status = nc_get_vara_float(ncid, varid, &
    & c_loc(start), c_loc(count), c_loc(values))
  call finish(error, ncid, status, "nc_get_vara_float failed")
  if (allocated(error)) return
  call check(error, all(values == initial), &
    & "Variable data differs")
end subroutine test_nc_get_vara_float

subroutine test_nc_put_vars_float(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  real(c_float), target :: values(2)
  integer(c_int), target :: actual(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)
  integer(c_ptrdiff_t), target :: stride(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7.0_c_float, 8.0_c_float]
  actual = 0
  start = 0_c_size_t
  count = 2_c_size_t
  stride = 1_c_ptrdiff_t
  status = nc_put_vars_float(ncid, varid, &
    & c_loc(start), c_loc(count), c_loc(stride), c_loc(values))
  if (status == NC_NOERR) then
    status = nc_get_var_int(ncid, varid, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_vars_float failed")
  if (allocated(error)) return
  call check(error, all(actual == [7_c_int, 8_c_int]), &
    & "Variable data differs")
end subroutine test_nc_put_vars_float

subroutine test_nc_get_vars_float(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  real(c_float), target :: values(2)
  integer(c_int), target :: initial(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)
  integer(c_ptrdiff_t), target :: stride(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7.0_c_float, 8.0_c_float]
  initial = [7_c_int, 8_c_int]
  status = nc_put_var_int(ncid, varid, c_loc(initial))
  if (status /= NC_NOERR) then
    call finish(error, ncid, status, "Value setup failed")
    return
  end if
  values = 0
  start = 0_c_size_t
  count = 2_c_size_t
  stride = 1_c_ptrdiff_t
  status = nc_get_vars_float(ncid, varid, &
    & c_loc(start), c_loc(count), c_loc(stride), c_loc(values))
  call finish(error, ncid, status, "nc_get_vars_float failed")
  if (allocated(error)) return
  call check(error, all(values == initial), &
    & "Variable data differs")
end subroutine test_nc_get_vars_float

subroutine test_nc_put_var1_float(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  real(c_float), target :: values(1)
  integer(c_int), target :: actual(2)
  integer(c_size_t), target :: start(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7.0_c_float]
  actual = 0
  start = 0_c_size_t
  status = nc_put_var1_float(ncid, varid, &
    & c_loc(start), c_loc(values))
  if (status == NC_NOERR) then
    status = nc_get_var_int(ncid, varid, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_var1_float failed")
  if (allocated(error)) return
  call check(error, actual(1) == 7_c_int, &
    & "Variable data differs")
end subroutine test_nc_put_var1_float

subroutine test_nc_get_var1_float(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  real(c_float), target :: values(1)
  integer(c_int), target :: initial(2)
  integer(c_size_t), target :: start(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7.0_c_float]
  initial = [7_c_int, 8_c_int]
  status = nc_put_var_int(ncid, varid, c_loc(initial))
  if (status /= NC_NOERR) then
    call finish(error, ncid, status, "Value setup failed")
    return
  end if
  values = 0
  start = 0_c_size_t
  status = nc_get_var1_float(ncid, varid, &
    & c_loc(start), c_loc(values))
  call finish(error, ncid, status, "nc_get_var1_float failed")
  if (allocated(error)) return
  call check(error, all(values == initial(1:1)), &
    & "Variable data differs")
end subroutine test_nc_get_var1_float

subroutine test_nc_put_varm_float(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  real(c_float), target :: values(2)
  integer(c_int), target :: actual(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)
  integer(c_ptrdiff_t), target :: stride(1)
  integer(c_ptrdiff_t), target :: imap(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7.0_c_float, 8.0_c_float]
  actual = 0
  start = 0_c_size_t
  count = 2_c_size_t
  stride = 1_c_ptrdiff_t
  imap = 1_c_ptrdiff_t
  status = nc_put_varm_float(ncid, varid, &
    & c_loc(start), c_loc(count), &
    & c_loc(stride), c_loc(imap), c_loc(values))
  if (status == NC_NOERR) then
    status = nc_get_var_int(ncid, varid, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_varm_float failed")
  if (allocated(error)) return
  call check(error, all(actual == [7_c_int, 8_c_int]), &
    & "Variable data differs")
end subroutine test_nc_put_varm_float

subroutine test_nc_get_varm_float(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  real(c_float), target :: values(2)
  integer(c_int), target :: initial(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)
  integer(c_ptrdiff_t), target :: stride(1)
  integer(c_ptrdiff_t), target :: imap(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7.0_c_float, 8.0_c_float]
  initial = [7_c_int, 8_c_int]
  status = nc_put_var_int(ncid, varid, c_loc(initial))
  if (status /= NC_NOERR) then
    call finish(error, ncid, status, "Value setup failed")
    return
  end if
  values = 0
  start = 0_c_size_t
  count = 2_c_size_t
  stride = 1_c_ptrdiff_t
  imap = 1_c_ptrdiff_t
  status = nc_get_varm_float(ncid, varid, &
    & c_loc(start), c_loc(count), &
    & c_loc(stride), c_loc(imap), c_loc(values))
  call finish(error, ncid, status, "nc_get_varm_float failed")
  if (allocated(error)) return
  call check(error, all(values == initial), &
    & "Variable data differs")
end subroutine test_nc_get_varm_float

subroutine test_nc_put_var_double(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  real(c_double), target :: values(2)
  integer(c_int), target :: actual(2)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7.0_c_double, 8.0_c_double]
  actual = 0
  status = nc_put_var_double(ncid, varid, &
    & c_loc(values))
  if (status == NC_NOERR) then
    status = nc_get_var_int(ncid, varid, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_var_double failed")
  if (allocated(error)) return
  call check(error, all(actual == [7_c_int, 8_c_int]), &
    & "Variable data differs")
end subroutine test_nc_put_var_double

subroutine test_nc_get_var_double(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  real(c_double), target :: values(2)
  integer(c_int), target :: initial(2)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7.0_c_double, 8.0_c_double]
  initial = [7_c_int, 8_c_int]
  status = nc_put_var_int(ncid, varid, c_loc(initial))
  if (status /= NC_NOERR) then
    call finish(error, ncid, status, "Value setup failed")
    return
  end if
  values = 0
  status = nc_get_var_double(ncid, varid, &
    & c_loc(values))
  call finish(error, ncid, status, "nc_get_var_double failed")
  if (allocated(error)) return
  call check(error, all(values == initial), &
    & "Variable data differs")
end subroutine test_nc_get_var_double

subroutine test_nc_put_vara_double(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  real(c_double), target :: values(2)
  integer(c_int), target :: actual(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7.0_c_double, 8.0_c_double]
  actual = 0
  start = 0_c_size_t
  count = 2_c_size_t
  status = nc_put_vara_double(ncid, varid, &
    & c_loc(start), c_loc(count), c_loc(values))
  if (status == NC_NOERR) then
    status = nc_get_var_int(ncid, varid, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_vara_double failed")
  if (allocated(error)) return
  call check(error, all(actual == [7_c_int, 8_c_int]), &
    & "Variable data differs")
end subroutine test_nc_put_vara_double

subroutine test_nc_get_vara_double(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  real(c_double), target :: values(2)
  integer(c_int), target :: initial(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7.0_c_double, 8.0_c_double]
  initial = [7_c_int, 8_c_int]
  status = nc_put_var_int(ncid, varid, c_loc(initial))
  if (status /= NC_NOERR) then
    call finish(error, ncid, status, "Value setup failed")
    return
  end if
  values = 0
  start = 0_c_size_t
  count = 2_c_size_t
  status = nc_get_vara_double(ncid, varid, &
    & c_loc(start), c_loc(count), c_loc(values))
  call finish(error, ncid, status, "nc_get_vara_double failed")
  if (allocated(error)) return
  call check(error, all(values == initial), &
    & "Variable data differs")
end subroutine test_nc_get_vara_double

subroutine test_nc_put_vars_double(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  real(c_double), target :: values(2)
  integer(c_int), target :: actual(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)
  integer(c_ptrdiff_t), target :: stride(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7.0_c_double, 8.0_c_double]
  actual = 0
  start = 0_c_size_t
  count = 2_c_size_t
  stride = 1_c_ptrdiff_t
  status = nc_put_vars_double(ncid, varid, &
    & c_loc(start), c_loc(count), c_loc(stride), c_loc(values))
  if (status == NC_NOERR) then
    status = nc_get_var_int(ncid, varid, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_vars_double failed")
  if (allocated(error)) return
  call check(error, all(actual == [7_c_int, 8_c_int]), &
    & "Variable data differs")
end subroutine test_nc_put_vars_double

subroutine test_nc_get_vars_double(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  real(c_double), target :: values(2)
  integer(c_int), target :: initial(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)
  integer(c_ptrdiff_t), target :: stride(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7.0_c_double, 8.0_c_double]
  initial = [7_c_int, 8_c_int]
  status = nc_put_var_int(ncid, varid, c_loc(initial))
  if (status /= NC_NOERR) then
    call finish(error, ncid, status, "Value setup failed")
    return
  end if
  values = 0
  start = 0_c_size_t
  count = 2_c_size_t
  stride = 1_c_ptrdiff_t
  status = nc_get_vars_double(ncid, varid, &
    & c_loc(start), c_loc(count), c_loc(stride), c_loc(values))
  call finish(error, ncid, status, "nc_get_vars_double failed")
  if (allocated(error)) return
  call check(error, all(values == initial), &
    & "Variable data differs")
end subroutine test_nc_get_vars_double

subroutine test_nc_put_var1_double(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  real(c_double), target :: values(1)
  integer(c_int), target :: actual(2)
  integer(c_size_t), target :: start(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7.0_c_double]
  actual = 0
  start = 0_c_size_t
  status = nc_put_var1_double(ncid, varid, &
    & c_loc(start), c_loc(values))
  if (status == NC_NOERR) then
    status = nc_get_var_int(ncid, varid, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_var1_double failed")
  if (allocated(error)) return
  call check(error, actual(1) == 7_c_int, &
    & "Variable data differs")
end subroutine test_nc_put_var1_double

subroutine test_nc_get_var1_double(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  real(c_double), target :: values(1)
  integer(c_int), target :: initial(2)
  integer(c_size_t), target :: start(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7.0_c_double]
  initial = [7_c_int, 8_c_int]
  status = nc_put_var_int(ncid, varid, c_loc(initial))
  if (status /= NC_NOERR) then
    call finish(error, ncid, status, "Value setup failed")
    return
  end if
  values = 0
  start = 0_c_size_t
  status = nc_get_var1_double(ncid, varid, &
    & c_loc(start), c_loc(values))
  call finish(error, ncid, status, "nc_get_var1_double failed")
  if (allocated(error)) return
  call check(error, all(values == initial(1:1)), &
    & "Variable data differs")
end subroutine test_nc_get_var1_double

subroutine test_nc_put_varm_double(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  real(c_double), target :: values(2)
  integer(c_int), target :: actual(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)
  integer(c_ptrdiff_t), target :: stride(1)
  integer(c_ptrdiff_t), target :: imap(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7.0_c_double, 8.0_c_double]
  actual = 0
  start = 0_c_size_t
  count = 2_c_size_t
  stride = 1_c_ptrdiff_t
  imap = 1_c_ptrdiff_t
  status = nc_put_varm_double(ncid, varid, &
    & c_loc(start), c_loc(count), &
    & c_loc(stride), c_loc(imap), c_loc(values))
  if (status == NC_NOERR) then
    status = nc_get_var_int(ncid, varid, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_varm_double failed")
  if (allocated(error)) return
  call check(error, all(actual == [7_c_int, 8_c_int]), &
    & "Variable data differs")
end subroutine test_nc_put_varm_double

subroutine test_nc_get_varm_double(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  real(c_double), target :: values(2)
  integer(c_int), target :: initial(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)
  integer(c_ptrdiff_t), target :: stride(1)
  integer(c_ptrdiff_t), target :: imap(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7.0_c_double, 8.0_c_double]
  initial = [7_c_int, 8_c_int]
  status = nc_put_var_int(ncid, varid, c_loc(initial))
  if (status /= NC_NOERR) then
    call finish(error, ncid, status, "Value setup failed")
    return
  end if
  values = 0
  start = 0_c_size_t
  count = 2_c_size_t
  stride = 1_c_ptrdiff_t
  imap = 1_c_ptrdiff_t
  status = nc_get_varm_double(ncid, varid, &
    & c_loc(start), c_loc(count), &
    & c_loc(stride), c_loc(imap), c_loc(values))
  call finish(error, ncid, status, "nc_get_varm_double failed")
  if (allocated(error)) return
  call check(error, all(values == initial), &
    & "Variable data differs")
end subroutine test_nc_get_varm_double

subroutine test_nc_put_var(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_int), target :: values(2)
  integer(c_int), target :: actual(2)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_int, 8_c_int]
  actual = 0
  status = nc_put_var(ncid, varid, &
    & c_loc(values))
  if (status == NC_NOERR) then
    status = nc_get_var_int(ncid, varid, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_var failed")
  if (allocated(error)) return
  call check(error, all(actual == [7_c_int, 8_c_int]), &
    & "Variable data differs")
end subroutine test_nc_put_var

subroutine test_nc_get_var(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_int), target :: values(2)
  integer(c_int), target :: initial(2)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_int, 8_c_int]
  initial = [7_c_int, 8_c_int]
  status = nc_put_var_int(ncid, varid, c_loc(initial))
  if (status /= NC_NOERR) then
    call finish(error, ncid, status, "Value setup failed")
    return
  end if
  values = 0
  status = nc_get_var(ncid, varid, &
    & c_loc(values))
  call finish(error, ncid, status, "nc_get_var failed")
  if (allocated(error)) return
  call check(error, all(values == initial), &
    & "Variable data differs")
end subroutine test_nc_get_var

subroutine test_nc_put_vara(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_int), target :: values(2)
  integer(c_int), target :: actual(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_int, 8_c_int]
  actual = 0
  start = 0_c_size_t
  count = 2_c_size_t
  status = nc_put_vara(ncid, varid, &
    & c_loc(start), c_loc(count), c_loc(values))
  if (status == NC_NOERR) then
    status = nc_get_var_int(ncid, varid, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_vara failed")
  if (allocated(error)) return
  call check(error, all(actual == [7_c_int, 8_c_int]), &
    & "Variable data differs")
end subroutine test_nc_put_vara

subroutine test_nc_get_vara(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_int), target :: values(2)
  integer(c_int), target :: initial(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_int, 8_c_int]
  initial = [7_c_int, 8_c_int]
  status = nc_put_var_int(ncid, varid, c_loc(initial))
  if (status /= NC_NOERR) then
    call finish(error, ncid, status, "Value setup failed")
    return
  end if
  values = 0
  start = 0_c_size_t
  count = 2_c_size_t
  status = nc_get_vara(ncid, varid, &
    & c_loc(start), c_loc(count), c_loc(values))
  call finish(error, ncid, status, "nc_get_vara failed")
  if (allocated(error)) return
  call check(error, all(values == initial), &
    & "Variable data differs")
end subroutine test_nc_get_vara

subroutine test_nc_put_vars(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_int), target :: values(2)
  integer(c_int), target :: actual(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)
  integer(c_ptrdiff_t), target :: stride(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_int, 8_c_int]
  actual = 0
  start = 0_c_size_t
  count = 2_c_size_t
  stride = 1_c_ptrdiff_t
  status = nc_put_vars(ncid, varid, &
    & c_loc(start), c_loc(count), c_loc(stride), c_loc(values))
  if (status == NC_NOERR) then
    status = nc_get_var_int(ncid, varid, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_vars failed")
  if (allocated(error)) return
  call check(error, all(actual == [7_c_int, 8_c_int]), &
    & "Variable data differs")
end subroutine test_nc_put_vars

subroutine test_nc_get_vars(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_int), target :: values(2)
  integer(c_int), target :: initial(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)
  integer(c_ptrdiff_t), target :: stride(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_int, 8_c_int]
  initial = [7_c_int, 8_c_int]
  status = nc_put_var_int(ncid, varid, c_loc(initial))
  if (status /= NC_NOERR) then
    call finish(error, ncid, status, "Value setup failed")
    return
  end if
  values = 0
  start = 0_c_size_t
  count = 2_c_size_t
  stride = 1_c_ptrdiff_t
  status = nc_get_vars(ncid, varid, &
    & c_loc(start), c_loc(count), c_loc(stride), c_loc(values))
  call finish(error, ncid, status, "nc_get_vars failed")
  if (allocated(error)) return
  call check(error, all(values == initial), &
    & "Variable data differs")
end subroutine test_nc_get_vars

subroutine test_nc_put_var1(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_int), target :: values(1)
  integer(c_int), target :: actual(2)
  integer(c_size_t), target :: start(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_int]
  actual = 0
  start = 0_c_size_t
  status = nc_put_var1(ncid, varid, &
    & c_loc(start), c_loc(values))
  if (status == NC_NOERR) then
    status = nc_get_var_int(ncid, varid, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_var1 failed")
  if (allocated(error)) return
  call check(error, actual(1) == 7_c_int, &
    & "Variable data differs")
end subroutine test_nc_put_var1

subroutine test_nc_get_var1(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_int), target :: values(1)
  integer(c_int), target :: initial(2)
  integer(c_size_t), target :: start(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_int]
  initial = [7_c_int, 8_c_int]
  status = nc_put_var_int(ncid, varid, c_loc(initial))
  if (status /= NC_NOERR) then
    call finish(error, ncid, status, "Value setup failed")
    return
  end if
  values = 0
  start = 0_c_size_t
  status = nc_get_var1(ncid, varid, &
    & c_loc(start), c_loc(values))
  call finish(error, ncid, status, "nc_get_var1 failed")
  if (allocated(error)) return
  call check(error, all(values == initial(1:1)), &
    & "Variable data differs")
end subroutine test_nc_get_var1

subroutine test_nc_put_varm(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_int), target :: values(2)
  integer(c_int), target :: actual(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)
  integer(c_ptrdiff_t), target :: stride(1)
  integer(c_ptrdiff_t), target :: imap(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_int, 8_c_int]
  actual = 0
  start = 0_c_size_t
  count = 2_c_size_t
  stride = 1_c_ptrdiff_t
  imap = 1_c_ptrdiff_t
  status = nc_put_varm(ncid, varid, &
    & c_loc(start), c_loc(count), &
    & c_loc(stride), c_loc(imap), c_loc(values))
  if (status == NC_NOERR) then
    status = nc_get_var_int(ncid, varid, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_varm failed")
  if (allocated(error)) return
  call check(error, all(actual == [7_c_int, 8_c_int]), &
    & "Variable data differs")
end subroutine test_nc_put_varm

subroutine test_nc_get_varm(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  integer(c_int), target :: values(2)
  integer(c_int), target :: initial(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)
  integer(c_ptrdiff_t), target :: stride(1)
  integer(c_ptrdiff_t), target :: imap(1)

  call open_int_variable(error, ncid, varid)
  if (allocated(error)) return
  values = [7_c_int, 8_c_int]
  initial = [7_c_int, 8_c_int]
  status = nc_put_var_int(ncid, varid, c_loc(initial))
  if (status /= NC_NOERR) then
    call finish(error, ncid, status, "Value setup failed")
    return
  end if
  values = 0
  start = 0_c_size_t
  count = 2_c_size_t
  stride = 1_c_ptrdiff_t
  imap = 1_c_ptrdiff_t
  status = nc_get_varm(ncid, varid, &
    & c_loc(start), c_loc(count), &
    & c_loc(stride), c_loc(imap), c_loc(values))
  call finish(error, ncid, status, "nc_get_varm failed")
  if (allocated(error)) return
  call check(error, all(values == initial), &
    & "Variable data differs")
end subroutine test_nc_get_varm

subroutine open_special_variable(error, ncid, varid, xtype)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int), intent(out) :: ncid, varid
  integer(c_int), intent(in) :: xtype
  integer(c_int) :: dimid, status

  call open_dataset(error, ncid, enhanced=xtype == NC_STRING)
  if (allocated(error)) return
  status = nc_def_dim(ncid, "x"//c_null_char, 2_c_size_t, dimid)
  if (status == NC_NOERR) then
    status = nc_def_var(ncid, "v"//c_null_char, xtype, &
      & 1_c_int, [dimid], varid)
  end if
  if (status == NC_NOERR) status = nc_enddef(ncid)
  if (status == NC_NOERR) return
  call finish(error, ncid, status, "Special variable setup failed")
end subroutine open_special_variable

subroutine test_nc_put_var_text(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  character(kind=c_char), target :: values(2)
  character(kind=c_char), target :: actual(2)

  call open_special_variable(error, ncid, varid, NC_CHAR)
  if (allocated(error)) return
  values = [character(kind=c_char) :: "a", "b"]
  actual = c_null_char
  status = nc_put_var_text(ncid, varid, &
    & c_loc(values))
  if (status == NC_NOERR) then
    status = nc_get_var_text(ncid, varid, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_var_text failed")
  if (allocated(error)) return
  call check(error, all(actual == values), &
    & "Text variable data differs")
end subroutine test_nc_put_var_text

subroutine test_nc_get_var_text(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  character(kind=c_char), target :: values(2)
  character(kind=c_char), target :: initial(2)

  call open_special_variable(error, ncid, varid, NC_CHAR)
  if (allocated(error)) return
  values = [character(kind=c_char) :: "a", "b"]
  initial = [character(kind=c_char) :: "a", "b"]
  status = nc_put_var_text(ncid, varid, c_loc(initial))
  if (status /= NC_NOERR) then
    call finish(error, ncid, status, "Text setup failed")
    return
  end if
  values = c_null_char
  status = nc_get_var_text(ncid, varid, &
    & c_loc(values))
  call finish(error, ncid, status, "nc_get_var_text failed")
  if (allocated(error)) return
  call check(error, all(values == initial), &
    & "Text variable data differs")
end subroutine test_nc_get_var_text

subroutine test_nc_put_vara_text(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  character(kind=c_char), target :: values(2)
  character(kind=c_char), target :: actual(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)

  call open_special_variable(error, ncid, varid, NC_CHAR)
  if (allocated(error)) return
  values = [character(kind=c_char) :: "a", "b"]
  actual = c_null_char
  start = 0_c_size_t
  count = 2_c_size_t
  status = nc_put_vara_text(ncid, varid, &
    & c_loc(start), c_loc(count), c_loc(values))
  if (status == NC_NOERR) then
    status = nc_get_var_text(ncid, varid, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_vara_text failed")
  if (allocated(error)) return
  call check(error, all(actual == values), &
    & "Text variable data differs")
end subroutine test_nc_put_vara_text

subroutine test_nc_get_vara_text(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  character(kind=c_char), target :: values(2)
  character(kind=c_char), target :: initial(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)

  call open_special_variable(error, ncid, varid, NC_CHAR)
  if (allocated(error)) return
  values = [character(kind=c_char) :: "a", "b"]
  initial = [character(kind=c_char) :: "a", "b"]
  status = nc_put_var_text(ncid, varid, c_loc(initial))
  if (status /= NC_NOERR) then
    call finish(error, ncid, status, "Text setup failed")
    return
  end if
  values = c_null_char
  start = 0_c_size_t
  count = 2_c_size_t
  status = nc_get_vara_text(ncid, varid, &
    & c_loc(start), c_loc(count), c_loc(values))
  call finish(error, ncid, status, "nc_get_vara_text failed")
  if (allocated(error)) return
  call check(error, all(values == initial), &
    & "Text variable data differs")
end subroutine test_nc_get_vara_text

subroutine test_nc_put_vars_text(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  character(kind=c_char), target :: values(2)
  character(kind=c_char), target :: actual(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)
  integer(c_ptrdiff_t), target :: stride(1)

  call open_special_variable(error, ncid, varid, NC_CHAR)
  if (allocated(error)) return
  values = [character(kind=c_char) :: "a", "b"]
  actual = c_null_char
  start = 0_c_size_t
  count = 2_c_size_t
  stride = 1_c_ptrdiff_t
  status = nc_put_vars_text(ncid, varid, &
    & c_loc(start), c_loc(count), c_loc(stride), c_loc(values))
  if (status == NC_NOERR) then
    status = nc_get_var_text(ncid, varid, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_vars_text failed")
  if (allocated(error)) return
  call check(error, all(actual == values), &
    & "Text variable data differs")
end subroutine test_nc_put_vars_text

subroutine test_nc_get_vars_text(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  character(kind=c_char), target :: values(2)
  character(kind=c_char), target :: initial(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)
  integer(c_ptrdiff_t), target :: stride(1)

  call open_special_variable(error, ncid, varid, NC_CHAR)
  if (allocated(error)) return
  values = [character(kind=c_char) :: "a", "b"]
  initial = [character(kind=c_char) :: "a", "b"]
  status = nc_put_var_text(ncid, varid, c_loc(initial))
  if (status /= NC_NOERR) then
    call finish(error, ncid, status, "Text setup failed")
    return
  end if
  values = c_null_char
  start = 0_c_size_t
  count = 2_c_size_t
  stride = 1_c_ptrdiff_t
  status = nc_get_vars_text(ncid, varid, &
    & c_loc(start), c_loc(count), c_loc(stride), c_loc(values))
  call finish(error, ncid, status, "nc_get_vars_text failed")
  if (allocated(error)) return
  call check(error, all(values == initial), &
    & "Text variable data differs")
end subroutine test_nc_get_vars_text

subroutine test_nc_put_var1_text(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  character(kind=c_char), target :: values(1)
  character(kind=c_char), target :: actual(2)
  integer(c_size_t), target :: start(1)

  call open_special_variable(error, ncid, varid, NC_CHAR)
  if (allocated(error)) return
  values = [character(kind=c_char) :: "a"]
  actual = c_null_char
  start = 0_c_size_t
  status = nc_put_var1_text(ncid, varid, &
    & c_loc(start), values)
  if (status == NC_NOERR) then
    status = nc_get_var1_text(ncid, varid, &
      & c_loc(start), c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_var1_text failed")
  if (allocated(error)) return
  call check(error, actual(1) == values(1), &
    & "Text variable data differs")
end subroutine test_nc_put_var1_text

subroutine test_nc_get_var1_text(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  character(kind=c_char), target :: values(1)
  character(kind=c_char), target :: initial(2)
  integer(c_size_t), target :: start(1)

  call open_special_variable(error, ncid, varid, NC_CHAR)
  if (allocated(error)) return
  values = [character(kind=c_char) :: "a"]
  initial = [character(kind=c_char) :: "a", "b"]
  status = nc_put_var_text(ncid, varid, c_loc(initial))
  if (status /= NC_NOERR) then
    call finish(error, ncid, status, "Text setup failed")
    return
  end if
  values = c_null_char
  start = 0_c_size_t
  status = nc_get_var1_text(ncid, varid, &
    & c_loc(start), c_loc(values))
  call finish(error, ncid, status, "nc_get_var1_text failed")
  if (allocated(error)) return
  call check(error, values(1) == initial(1), &
    & "Text variable data differs")
end subroutine test_nc_get_var1_text

subroutine test_nc_put_varm_text(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  character(kind=c_char), target :: values(2)
  character(kind=c_char), target :: actual(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)
  integer(c_ptrdiff_t), target :: stride(1)
  integer(c_ptrdiff_t), target :: imap(1)

  call open_special_variable(error, ncid, varid, NC_CHAR)
  if (allocated(error)) return
  values = [character(kind=c_char) :: "a", "b"]
  actual = c_null_char
  start = 0_c_size_t
  count = 2_c_size_t
  stride = 1_c_ptrdiff_t
  imap = 1_c_ptrdiff_t
  status = nc_put_varm_text(ncid, varid, &
    & c_loc(start), c_loc(count), &
    & c_loc(stride), c_loc(imap), values)
  if (status == NC_NOERR) then
    status = nc_get_var_text(ncid, varid, c_loc(actual))
  end if
  call finish(error, ncid, status, "nc_put_varm_text failed")
  if (allocated(error)) return
  call check(error, all(actual == values), &
    & "Text variable data differs")
end subroutine test_nc_put_varm_text

subroutine test_nc_get_varm_text(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  character(kind=c_char), target :: values(2)
  character(kind=c_char), target :: initial(2)
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)
  integer(c_ptrdiff_t), target :: stride(1)
  integer(c_ptrdiff_t), target :: imap(1)

  call open_special_variable(error, ncid, varid, NC_CHAR)
  if (allocated(error)) return
  values = [character(kind=c_char) :: "a", "b"]
  initial = [character(kind=c_char) :: "a", "b"]
  status = nc_put_var_text(ncid, varid, c_loc(initial))
  if (status /= NC_NOERR) then
    call finish(error, ncid, status, "Text setup failed")
    return
  end if
  values = c_null_char
  start = 0_c_size_t
  count = 2_c_size_t
  stride = 1_c_ptrdiff_t
  imap = 1_c_ptrdiff_t
  status = nc_get_varm_text(ncid, varid, &
    & c_loc(start), c_loc(count), &
    & c_loc(stride), c_loc(imap), c_loc(values))
  call finish(error, ncid, status, "nc_get_varm_text failed")
  if (allocated(error)) return
  call check(error, all(values == initial), &
    & "Text variable data differs")
end subroutine test_nc_get_varm_text

subroutine test_nc_put_var_string(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  character(kind=c_char), target :: a(2), b(2)
  type(c_ptr), target :: values(2), actual(2)
  integer(c_int) :: free_status

  call open_special_variable(error, ncid, varid, NC_STRING)
  if (allocated(error)) return
  a = [character(kind=c_char) :: "a", c_null_char]
  b = [character(kind=c_char) :: "b", c_null_char]
  values(1) = c_loc(a)
  values(2) = c_loc(b)
  actual = c_null_ptr
  status = nc_put_var_string(ncid, varid, &
    & c_loc(values))
  if (status == NC_NOERR) then
    status = nc_get_var_string(ncid, varid, c_loc(actual))
  end if
  if (status == NC_NOERR) then
    call check(error, c_associated(actual(1)), &
      & "String result is NULL")
    if (.not. allocated(error)) then
      call check(error, c_strlen(actual(1)) == 1_c_size_t, &
        & "String length differs")
    end if
  end if
  if (c_associated(actual(1))) then
    free_status = nc_free_string(2_c_size_t, c_loc(actual))
    if (status == NC_NOERR) status = free_status
  end if
  call finish(error, ncid, status, "nc_put_var_string failed")
end subroutine test_nc_put_var_string

subroutine test_nc_get_var_string(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  character(kind=c_char), target :: a(2), b(2)
  type(c_ptr), target :: values(2), actual(2)
  integer(c_int) :: free_status

  call open_special_variable(error, ncid, varid, NC_STRING)
  if (allocated(error)) return
  a = [character(kind=c_char) :: "a", c_null_char]
  b = [character(kind=c_char) :: "b", c_null_char]
  values(1) = c_loc(a)
  values(2) = c_loc(b)
  actual = c_null_ptr
  status = nc_put_var_string(ncid, varid, c_loc(values))
  if (status /= NC_NOERR) then
    call finish(error, ncid, status, "String setup failed")
    return
  end if
  values = c_null_ptr
  status = nc_get_var_string(ncid, varid, &
    & c_loc(values))
  if (status == NC_NOERR) then
    call check(error, c_associated(values(1)), &
      & "String result is NULL")
    if (.not. allocated(error)) then
      call check(error, c_strlen(values(1)) == 1_c_size_t, &
        & "String length differs")
    end if
  end if
  if (c_associated(values(1))) then
    free_status = nc_free_string(2_c_size_t, c_loc(values))
    if (status == NC_NOERR) status = free_status
  end if
  call finish(error, ncid, status, "nc_get_var_string failed")
end subroutine test_nc_get_var_string

subroutine test_nc_put_vara_string(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  character(kind=c_char), target :: a(2), b(2)
  type(c_ptr), target :: values(2), actual(2)
  integer(c_int) :: free_status
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)

  call open_special_variable(error, ncid, varid, NC_STRING)
  if (allocated(error)) return
  a = [character(kind=c_char) :: "a", c_null_char]
  b = [character(kind=c_char) :: "b", c_null_char]
  values(1) = c_loc(a)
  values(2) = c_loc(b)
  actual = c_null_ptr
  start = 0_c_size_t
  count = 2_c_size_t
  status = nc_put_vara_string(ncid, varid, &
    & c_loc(start), c_loc(count), c_loc(values))
  if (status == NC_NOERR) then
    status = nc_get_var_string(ncid, varid, c_loc(actual))
  end if
  if (status == NC_NOERR) then
    call check(error, c_associated(actual(1)), &
      & "String result is NULL")
    if (.not. allocated(error)) then
      call check(error, c_strlen(actual(1)) == 1_c_size_t, &
        & "String length differs")
    end if
  end if
  if (c_associated(actual(1))) then
    free_status = nc_free_string(2_c_size_t, c_loc(actual))
    if (status == NC_NOERR) status = free_status
  end if
  call finish(error, ncid, status, "nc_put_vara_string failed")
end subroutine test_nc_put_vara_string

subroutine test_nc_get_vara_string(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  character(kind=c_char), target :: a(2), b(2)
  type(c_ptr), target :: values(2), actual(2)
  integer(c_int) :: free_status
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)

  call open_special_variable(error, ncid, varid, NC_STRING)
  if (allocated(error)) return
  a = [character(kind=c_char) :: "a", c_null_char]
  b = [character(kind=c_char) :: "b", c_null_char]
  values(1) = c_loc(a)
  values(2) = c_loc(b)
  actual = c_null_ptr
  status = nc_put_var_string(ncid, varid, c_loc(values))
  if (status /= NC_NOERR) then
    call finish(error, ncid, status, "String setup failed")
    return
  end if
  values = c_null_ptr
  start = 0_c_size_t
  count = 2_c_size_t
  status = nc_get_vara_string(ncid, varid, &
    & c_loc(start), c_loc(count), c_loc(values))
  if (status == NC_NOERR) then
    call check(error, c_associated(values(1)), &
      & "String result is NULL")
    if (.not. allocated(error)) then
      call check(error, c_strlen(values(1)) == 1_c_size_t, &
        & "String length differs")
    end if
  end if
  if (c_associated(values(1))) then
    free_status = nc_free_string(2_c_size_t, c_loc(values))
    if (status == NC_NOERR) status = free_status
  end if
  call finish(error, ncid, status, "nc_get_vara_string failed")
end subroutine test_nc_get_vara_string

subroutine test_nc_put_vars_string(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  character(kind=c_char), target :: a(2), b(2)
  type(c_ptr), target :: values(2), actual(2)
  integer(c_int) :: free_status
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)
  integer(c_ptrdiff_t), target :: stride(1)

  call open_special_variable(error, ncid, varid, NC_STRING)
  if (allocated(error)) return
  a = [character(kind=c_char) :: "a", c_null_char]
  b = [character(kind=c_char) :: "b", c_null_char]
  values(1) = c_loc(a)
  values(2) = c_loc(b)
  actual = c_null_ptr
  start = 0_c_size_t
  count = 2_c_size_t
  stride = 1_c_ptrdiff_t
  status = nc_put_vars_string(ncid, varid, &
    & c_loc(start), c_loc(count), c_loc(stride), c_loc(values))
  if (status == NC_NOERR) then
    status = nc_get_var_string(ncid, varid, c_loc(actual))
  end if
  if (status == NC_NOERR) then
    call check(error, c_associated(actual(1)), &
      & "String result is NULL")
    if (.not. allocated(error)) then
      call check(error, c_strlen(actual(1)) == 1_c_size_t, &
        & "String length differs")
    end if
  end if
  if (c_associated(actual(1))) then
    free_status = nc_free_string(2_c_size_t, c_loc(actual))
    if (status == NC_NOERR) status = free_status
  end if
  call finish(error, ncid, status, "nc_put_vars_string failed")
end subroutine test_nc_put_vars_string

subroutine test_nc_get_vars_string(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  character(kind=c_char), target :: a(2), b(2)
  type(c_ptr), target :: values(2), actual(2)
  integer(c_int) :: free_status
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)
  integer(c_ptrdiff_t), target :: stride(1)

  call open_special_variable(error, ncid, varid, NC_STRING)
  if (allocated(error)) return
  a = [character(kind=c_char) :: "a", c_null_char]
  b = [character(kind=c_char) :: "b", c_null_char]
  values(1) = c_loc(a)
  values(2) = c_loc(b)
  actual = c_null_ptr
  status = nc_put_var_string(ncid, varid, c_loc(values))
  if (status /= NC_NOERR) then
    call finish(error, ncid, status, "String setup failed")
    return
  end if
  values = c_null_ptr
  start = 0_c_size_t
  count = 2_c_size_t
  stride = 1_c_ptrdiff_t
  status = nc_get_vars_string(ncid, varid, &
    & c_loc(start), c_loc(count), c_loc(stride), c_loc(values))
  if (status == NC_NOERR) then
    call check(error, c_associated(values(1)), &
      & "String result is NULL")
    if (.not. allocated(error)) then
      call check(error, c_strlen(values(1)) == 1_c_size_t, &
        & "String length differs")
    end if
  end if
  if (c_associated(values(1))) then
    free_status = nc_free_string(2_c_size_t, c_loc(values))
    if (status == NC_NOERR) status = free_status
  end if
  call finish(error, ncid, status, "nc_get_vars_string failed")
end subroutine test_nc_get_vars_string

subroutine test_nc_put_var1_string(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  character(kind=c_char), target :: a(2), b(2)
  type(c_ptr), target :: values(1), actual(1)
  integer(c_int) :: free_status
  integer(c_size_t), target :: start(1)

  call open_special_variable(error, ncid, varid, NC_STRING)
  if (allocated(error)) return
  a = [character(kind=c_char) :: "a", c_null_char]
  b = [character(kind=c_char) :: "b", c_null_char]
  values(1) = c_loc(a)
  actual = c_null_ptr
  start = 0_c_size_t
  status = nc_put_var1_string(ncid, varid, &
    & c_loc(start), c_loc(values))
  if (status == NC_NOERR) then
    status = nc_get_var1_string(ncid, varid, &
      & c_loc(start), c_loc(actual))
  end if
  if (status == NC_NOERR) then
    call check(error, c_associated(actual(1)), &
      & "String result is NULL")
    if (.not. allocated(error)) then
      call check(error, c_strlen(actual(1)) == 1_c_size_t, &
        & "String length differs")
    end if
  end if
  if (c_associated(actual(1))) then
    free_status = nc_free_string(1_c_size_t, c_loc(actual))
    if (status == NC_NOERR) status = free_status
  end if
  call finish(error, ncid, status, "nc_put_var1_string failed")
end subroutine test_nc_put_var1_string

subroutine test_nc_get_var1_string(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  character(kind=c_char), target :: a(2), b(2)
  type(c_ptr), target :: values(2), actual(1)
  integer(c_int) :: free_status
  integer(c_size_t), target :: start(1)

  call open_special_variable(error, ncid, varid, NC_STRING)
  if (allocated(error)) return
  a = [character(kind=c_char) :: "a", c_null_char]
  b = [character(kind=c_char) :: "b", c_null_char]
  values(1) = c_loc(a)
  values(2) = c_loc(b)
  actual = c_null_ptr
  status = nc_put_var_string(ncid, varid, c_loc(values))
  if (status /= NC_NOERR) then
    call finish(error, ncid, status, "String setup failed")
    return
  end if
  values = c_null_ptr
  start = 0_c_size_t
  status = nc_get_var1_string(ncid, varid, &
    & c_loc(start), c_loc(values))
  if (status == NC_NOERR) then
    call check(error, c_associated(values(1)), &
      & "String result is NULL")
    if (.not. allocated(error)) then
      call check(error, c_strlen(values(1)) == 1_c_size_t, &
        & "String length differs")
    end if
  end if
  if (c_associated(values(1))) then
    free_status = nc_free_string(1_c_size_t, c_loc(values))
    if (status == NC_NOERR) status = free_status
  end if
  call finish(error, ncid, status, "nc_get_var1_string failed")
end subroutine test_nc_get_var1_string

subroutine test_nc_put_varm_string(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  character(kind=c_char), target :: a(2), b(2)
  type(c_ptr), target :: values(2), actual(2)
  integer(c_int) :: free_status
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)
  integer(c_ptrdiff_t), target :: stride(1)
  integer(c_ptrdiff_t), target :: imap(1)

  call open_special_variable(error, ncid, varid, NC_STRING)
  if (allocated(error)) return
  a = [character(kind=c_char) :: "a", c_null_char]
  b = [character(kind=c_char) :: "b", c_null_char]
  values(1) = c_loc(a)
  values(2) = c_loc(b)
  actual = c_null_ptr
  start = 0_c_size_t
  count = 2_c_size_t
  stride = 1_c_ptrdiff_t
  imap = 1_c_ptrdiff_t
  status = nc_put_varm_string(ncid, varid, &
    & c_loc(start), c_loc(count), &
    & c_loc(stride), c_loc(imap), c_loc(values))
  if (status == NC_NOERR) then
    status = nc_get_var_string(ncid, varid, c_loc(actual))
  end if
  if (status == NC_NOERR) then
    call check(error, c_associated(actual(1)), &
      & "String result is NULL")
    if (.not. allocated(error)) then
      call check(error, c_strlen(actual(1)) == 1_c_size_t, &
        & "String length differs")
    end if
  end if
  if (c_associated(actual(1))) then
    free_status = nc_free_string(2_c_size_t, c_loc(actual))
    if (status == NC_NOERR) status = free_status
  end if
  call finish(error, ncid, status, "nc_put_varm_string failed")
end subroutine test_nc_put_varm_string

subroutine test_nc_get_varm_string(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, varid, status
  character(kind=c_char), target :: a(2), b(2)
  type(c_ptr), target :: values(2), actual(2)
  integer(c_int) :: free_status
  integer(c_size_t), target :: start(1)
  integer(c_size_t), target :: count(1)
  integer(c_ptrdiff_t), target :: stride(1)
  integer(c_ptrdiff_t), target :: imap(1)

  call open_special_variable(error, ncid, varid, NC_STRING)
  if (allocated(error)) return
  a = [character(kind=c_char) :: "a", c_null_char]
  b = [character(kind=c_char) :: "b", c_null_char]
  values(1) = c_loc(a)
  values(2) = c_loc(b)
  actual = c_null_ptr
  status = nc_put_var_string(ncid, varid, c_loc(values))
  if (status /= NC_NOERR) then
    call finish(error, ncid, status, "String setup failed")
    return
  end if
  values = c_null_ptr
  start = 0_c_size_t
  count = 2_c_size_t
  stride = 1_c_ptrdiff_t
  imap = 1_c_ptrdiff_t
  status = nc_get_varm_string(ncid, varid, &
    & c_loc(start), c_loc(count), &
    & c_loc(stride), c_loc(imap), c_loc(values))
  if (status == NC_NOERR) then
    call check(error, c_associated(values(1)), &
      & "String result is NULL")
    if (.not. allocated(error)) then
      call check(error, c_strlen(values(1)) == 1_c_size_t, &
        & "String length differs")
    end if
  end if
  if (c_associated(values(1))) then
    free_status = nc_free_string(2_c_size_t, c_loc(values))
    if (status == NC_NOERR) status = free_status
  end if
  call finish(error, ncid, status, "nc_get_varm_string failed")
end subroutine test_nc_get_varm_string

end module nc4f_test_c_interface_io
