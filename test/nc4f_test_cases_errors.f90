submodule(nc4f_test_cases) nc4f_test_cases_errors

implicit none (type, external)

contains

module subroutine creation_policy(passed)
  !! Test file creation and reopening in append and overwrite modes.
  logical, intent(inout) :: passed
  !! Whether the test case has passed.
  real, parameter :: values(1) = [42.0]
  type(error_type) :: err
  type(netcdf_type) :: nc
  type(variable_type) :: var

  var = datarray("data", values, ["x".dim.1])
  call to_netcdf(TEST_RESULTS_DIR//"creation-policy.nc", var, err=err)
  if ((err%code /= NC_NOERR)) then
    passed = .false.
    return
  end if
  nc = open_netcdf(TEST_RESULTS_DIR//"creation-policy.nc", "a", err=err)
  if ((err%code /= NC_NOERR)) then
    passed = .false.
    return
  end if
  call close_netcdf(nc, err)
  if ((err%code /= NC_NOERR)) then
    passed = .false.
    return
  end if
  nc = open_netcdf(TEST_RESULTS_DIR//"creation-policy.nc", "w", err=err)
  if ((err%code /= NC_NOERR)) then
    passed = .false.
    return
  end if
  call close_netcdf(nc, err)
  passed = err%code == NC_NOERR
end subroutine creation_policy

module subroutine error_handling(passed)
  !! Test returned error codes, diagnostic messages, and successful recovery.
  logical, intent(inout) :: passed
  !! Whether the test case has passed.
  real, parameter :: values(1) = [42.0]
  character(len=1024) :: stdout
  integer :: iostat
  character(len=:), allocatable :: long_msg
  type(attribute_type) :: att
  type(attribute_type), allocatable :: atts(:)
  type(dimension_type), allocatable :: dims(:)
  type(group_type) :: unopened
  type(group_type), allocatable :: groups(:)
  type(error_type) :: err
  type(netcdf_type) :: nc
  type(variable_type) :: invalid, present, var, vars(2)

  passed = .false.
  if (.not. pure_error_predicates()) return
  if (.not. pure_storage_validation()) return
  if (.not. pure_name_validation()) return
  if (.not. storage_io_errors()) return
  if (.not. rejected_error("validate-name", &
    & "[test_validation] Invalid NetCDF name.")) return
  if (.not. rejected_error("validate-name-long", &
    & "[test_validation] NetCDF name exceeds NC_MAX_NAME bytes.")) return
  if (.not. rejected_error("validate-var", &
    & "[test_validation] Variable dimensions are not allocated.")) return
  if (.not. rejected_error("validate-att", &
    & "[test_validation] Attribute buffer is not associated.")) return
  if (.not. rejected_error("buffer-size", &
    & "[buffer_size] Byte-size overflow.")) return
  if (.not. rejected_error("variable-size", &
    & "[size] Negative dimension length.")) return
  if (.not. rejected_error("define-name", &
    & "[define_variable] Invalid NetCDF name.")) return
  if (.not. rejected_error("put-storage", &
    & "[put_variable] Source variable name is not allocated.")) return
  if (.not. rejected_error("write-storage", &
    & "[to_netcdf] Variable dimensions are not allocated.")) return
  if (.not. rejected_error("construct-no-fname", &
    & "[error_type] Failure requires an allocated fname.")) return
  if (.not. rejected_error("construct-no-msg", &
    & "[error_type] Failure requires an allocated msg.")) return
  if (.not. rejected_error("construct-blank-fname", &
    & "[error_type] Failure requires a nonblank fname.")) return
  if (.not. rejected_error("construct-blank-msg", &
    & "[error_type] Failure requires a nonblank msg.")) return
  if (.not. rejected_error("return-no-fname", &
    & "[error_type] Failure requires an allocated fname.")) return
  if (.not. rejected_error("return-no-msg", &
    & "[error_type] Failure requires an allocated msg.")) return
  if (.not. rejected_error("format-no-fname", &
    & "[error_type] Failure requires an allocated fname.")) return
  if (.not. rejected_error("format-blank-fname", &
    & "[error_type] Failure requires a nonblank fname.")) return
  if (.not. rejected_error("write-blank-msg", &
    & "[error_type] Failure requires a nonblank msg.")) return
  if (.not. rejected_error("fail-fast", &
    & "[test_error] Diagnostic.")) return

  ! Failed array inquiries must still return assignable array values.
  dims = inquire_dimensions(unopened, err=err)
  if (err%code /= NC_EBADID) return
  if (.not. allocated(dims)) return
  if (size(dims) /= 0) return
  dims = inquire_dimensions(unopened, invalid, err=err)
  if (err%code /= NC_EBADID .or. size(dims) /= 0) return
  atts = get_attribute(unopened, err=err)
  if (err%code /= NC_EBADID) return
  if (.not. allocated(atts)) return
  if (size(atts) /= 0) return
  atts = get_attribute(unopened, invalid, err=err)
  if (err%code /= NC_EBADID .or. size(atts) /= 0) return
  groups = inquire_subgroups(unopened, err=err)
  if (err%code /= NC_EBADID) return
  if (.not. allocated(groups)) return
  if (size(groups) /= 0) return
  call inquire_group(unopened, inq_dims=.false., inq_atts=.false., &
    & inq_grps=.false., err=err)
  if (err%code /= NC_EBADID) return
  if (.not. allocated(unopened%vars)) return
  if (size(unopened%vars) /= 0) return
  err = error_type()
  if (err%code /= NC_NOERR .or. error_msg(err) /= "No error") return
  err = error_type(NC_ENOTVAR, "test_error", "constructed error")
  if (.not. .exists.err) return
  if (.not. allocated(err%fname) .or. .not. allocated(err%msg)) return
  if (err%fname /= "test_error" .or. err%msg /= "constructed error") return
  if (error_msg(err) /= "[test_error] constructed error") return
  write (stdout, '(dt)', iostat=iostat) err
  if (iostat /= 0 .or. trim(stdout) /= error_msg(err)) return
  write (stdout, *, iostat=iostat) err
  if (iostat /= 0 .or. trim(adjustl(stdout)) /= error_msg(err)) return
  long_msg = repeat("long diagnostic ", 300)//"end"
  if (pure_error_text(long_msg) /= "[test_error] "//long_msg) return
  err = error_type()
  if (.exists.err) return
  if (allocated(err%fname) .or. allocated(err%msg)) return
  write (stdout, '(dt)', iostat=iostat) err
  if (iostat /= 0 .or. trim(stdout) /= "No error") return

  nc = open_netcdf(TEST_RESULTS_DIR//"unused.nc", "invalid", err=err)
  if (err%code /= NC_EINVAL) return
  if (err%fname /= "open_netcdf") return
  if (error_msg(err) /= "[open_netcdf] Invalid mode: invalid") return

  nc = open_netcdf(TEST_RESULTS_DIR// &
    & "missing-error-fixture/no-file.nc", err=err)
  if (.not. .exists.err) return
  if (.not. allocated(err%fname) .or. .not. allocated(err%msg)) return
  if (err%fname /= "open_netcdf") return
  if (index(err%msg, "missing-error-fixture/no-file.nc: ") == 0) return
  if (index(err%msg, "[open_netcdf]") /= 0) return
  write (stdout, "(dt)", iostat=iostat) err
  if (iostat /= 0 .or. trim(stdout) /= error_msg(err)) return

  present = datarray("present", values, ["x".dim.1], ["units".att."1"])
  call to_netcdf(TEST_RESULTS_DIR//"error-handling.nc", present, err=err)
  if ((err%code /= NC_NOERR)) return
  nc = open_netcdf(TEST_RESULTS_DIR//"error-handling.nc", "r", err=err)
  if ((err%code /= NC_NOERR)) return

  var = inquire_variable(nc, "missing", err)
  if (.not. .exists.err .or. err%code /= NC_ENOTVAR) then
    call close_netcdf(nc)
    return
  end if
  var = get_variable(nc, "missing", err=err)
  if (.not. .exists.err .or. err%code /= NC_ENOTVAR) then
    call close_netcdf(nc)
    return
  end if
  var = get_variable(nc, "present", err=err)
  if ((err%code /= NC_NOERR)) then
    call close_netcdf(nc)
    return
  end if

  att = get_attribute(nc, "missing_global", err)
  if (.not. .exists.err .or. err%code /= NC_ENOTATT) then
    call close_netcdf(nc)
    return
  end if
  att = get_attribute(nc, var, "missing", err)
  if (.not. .exists.err .or. err%code /= NC_ENOTATT) then
    call close_netcdf(nc)
    return
  end if

  call close_netcdf(nc, err)
  if ((err%code /= NC_NOERR)) return

  invalid = present
  invalid%len = 2
  call to_netcdf(TEST_RESULTS_DIR//"invalid-storage.nc", invalid, err=err)
  if (err%code /= NC_EINVAL) return
  if (index(err%msg, "Dimension product differs from length.") == 0) return
  call to_netcdf(TEST_RESULTS_DIR//"invalid-storage.nc", present, err=err)
  if (.exists. err) return

  invalid = datarray("", values, ["x".dim.1])
  ! Invalid array members are now rejected before opening in overwrite mode.
  call to_netcdf(TEST_RESULTS_DIR//"failed-write-cleanup.nc", present, err=err)
  if (err%code /= NC_NOERR) return
  vars = [present, invalid]
  call to_netcdf(TEST_RESULTS_DIR//"failed-write-cleanup.nc", vars, err=err)
  if (err%code == NC_NOERR) return
  nc = open_netcdf(TEST_RESULTS_DIR//"failed-write-cleanup.nc", "a", err=err)
  if ((err%code /= NC_NOERR)) return
  var = get_variable(nc, "present", err=err)
  call close_netcdf(nc)
  if (err%code /= NC_NOERR .or. var%name /= "present") return
  call close_netcdf(nc, err)
  if (err%code /= NC_EBADID) return
  if (.not. allocated(err%fname) .or. .not. allocated(err%msg)) return
  if (err%fname /= "close_netcdf" .or. len_trim(err%msg) == 0) return
  passed = .true.
end subroutine error_handling

pure logical function pure_name_validation() result(passed)
  use nc4f_ds, only: validate
  use nc4f_c_interface, only: NC_MAX_NAME
  type(error_type) :: err
  type(attribute_type) :: att
  type(variable_type) :: var
  character(len=8), parameter :: invalid_names(*) = [character(len=8) :: &
    & "", "bad/name", "bad"//achar(0), " bad", "/", "a"//achar(127), &
    & char(192)//char(175), char(237)//char(160)//char(128)]
  integer :: name_index

  passed = .false.
  do name_index = 1, size(invalid_names)
    call validate(invalid_names(name_index), context="[test_validation]", &
      & err=err)
    if (err%code /= NC_EBADNAME) return
    if (err%fname /= "test_validation") return
    if (err%msg /= "Invalid NetCDF name.") return
  end do
  call validate(repeat("a", NC_MAX_NAME + 1), "test_validation", err)
  if (err%code /= NC_EMAXNAME) return
  if (err%msg /= "NetCDF name exceeds NC_MAX_NAME bytes.") return
  call validate(repeat("a", NC_MAX_NAME), "test_validation", err)
  if (.exists. err) return
  if (allocated(err%fname) .or. allocated(err%msg)) return
  call validate("temperature  ", context="test_validation", err=err)
  if (.exists. err) return
  call validate(char(195)//char(169), context="test_validation", err=err)
  if (.exists. err) return
  call validate("valid_name", context="test_validation")

  att = "bad/name".att."K"
  call validate(att, context="test_validation", err=err)
  if (.exists. err) return
  var%name = "bad/name"
  var%dtype = att%dtype
  var%len = 1
  allocate (var%dims(0), var%buffer(1))
  call validate(var, context="test_validation", err=err)
  if (.exists. err) return
  passed = .true.
end function pure_name_validation

pure logical function pure_storage_validation() result(passed)
  use nc4f_ds, only: validate, compute_buffer_size, compute_size, buffer_size
  use nc4f_c_interface, only: NC_BYTE, NC_CHAR, NC_SHORT, NC_INT, &
    & NC_FLOAT, NC_DOUBLE, NC_INT64, NC_NAT
  type(attribute_type) :: att
  type(variable_type) :: var
  type(error_type) :: err
  integer(int8), target :: borrowed(2)
  integer, parameter :: dtypes(7) = &
    & [NC_BYTE, NC_CHAR, NC_SHORT, NC_INT, NC_FLOAT, NC_DOUBLE, NC_INT64]
  integer, parameter :: widths(7) = [1, 1, 2, 4, 4, 8, 8]
  integer :: nbytes, dtype_index
  integer(int64) :: nelems

  passed = .false.
  borrowed = 0_int8
  do dtype_index = 1, size(dtypes)
    call compute_buffer_size(dtypes(dtype_index), 2_int64, nbytes, err)
    if (.exists. err) return
    if (nbytes /= 2*widths(dtype_index)) return
    if (nbytes /= buffer_size(dtypes(dtype_index), 2_int64)) return
  end do
  call compute_buffer_size(NC_BYTE, -1_int64, nbytes, err)
  if (.not. validation_failure(err, "Negative element count.")) return
  if (nbytes /= 0) return

  att%dtype = NC_BYTE
  att%len = 0
  call validate(att, context="test_validation", err=err)
  if (.exists. err) return
  att%len = -1
  call validate(att, context="test_validation", err=err)
  if (.not. validation_failure(err, "Negative Attribute length.")) return
  att%len = 1
  call validate(att, NC_FLOAT, "test_validation", err)
  if (.not. validation_failure(err, "Unexpected Attribute type.")) return
  att%dtype = NC_NAT
  call validate(att, context="test_validation", err=err)
  if (.not. validation_failure(err, "Unsupported NetCDF data type.")) return
  att%dtype = NC_DOUBLE
  att%len = huge(0_int64)
  call validate(att, context="test_validation", err=err)
  if (.not. validation_failure(err, "Byte-size overflow.")) return
  att%dtype = NC_BYTE
  att%len = 1
  call validate(att, context="[test_validation]", err=err)
  if (.not. validation_failure(err, &
    & "Attribute buffer is not associated.")) return
  if (err%fname /= "test_validation") return
  allocate (att%buffer(0))
  call validate(att, context="test_validation", err=err)
  if (.not. validation_failure(err, "Attribute buffer is too small.")) return
  deallocate (att%buffer)
  att%ptr => borrowed
  att%len = 3
  call validate(att, context="test_validation", err=err)
  if (.not. validation_failure(err, "Attribute buffer is too small.")) return
  att%len = 2
  call validate(att, context="test_validation", err=err)
  if (.exists. err) return
  allocate (att%buffer(2))
  call validate(att, context="test_validation", err=err)
  if (.not. validation_failure(err, &
    & "Attribute has both owned and borrowed buffers.")) return
  if (.not. associated(att%ptr, borrowed)) return
  nullify (att%ptr)
  call validate(att, context="test_validation", err=err)
  if (.exists. err) return
  if (allocated(err%fname) .or. allocated(err%msg)) return
  call validate(att, context="test_validation")

  call validate(var, context="test_validation", err=err)
  if (.not. validation_failure(err, &
    & "Variable dimensions are not allocated.")) return
  allocate (var%dims(2))
  var%dims%len = [2_int64, 3_int64]
  var%dtype = NC_BYTE
  var%len = 6
  allocate (var%buffer(6))
  call validate(var, rank=3, context="test_validation", err=err)
  if (.not. validation_failure(err, "Unexpected variable rank.")) return
  call validate(var, rank=1, context="test_validation", err=err)
  if (.exists. err) return
  call validate(var, rank=2, context="test_validation", err=err)
  if (.exists. err) return
  call compute_size(var, nelems, err)
  if (.exists. err) return
  if (nelems /= size(var)) return
  call compute_size(var, nelems, err, dim=1)
  if (.exists. err) return
  if (nelems /= 3) return
  call compute_size(var, nelems, err, dim=3)
  if (.not. validation_failure(err, "Invalid dimension index.")) return
  call compute_size(var, nelems, err, dim=-1)
  if (.not. validation_failure(err, "Invalid dimension index.")) return
  var%len = 5
  call validate(var, context="test_validation", err=err)
  if (.not. validation_failure(err, &
    & "Dimension product differs from length.")) return
  var%dims(1)%len = -1
  call validate(var, context="test_validation", err=err)
  if (.not. validation_failure(err, "Negative dimension length.")) return
  call compute_size(var, nelems, err, dim=2)
  if (.not. validation_failure(err, "Negative dimension length.")) return
  var%dims%len = [huge(0_int64), 2_int64]
  call validate(var, context="test_validation", err=err)
  if (.not. validation_failure(err, "Dimension product overflow.")) return
  var%dims%len = [0_int64, 2_int64]
  var%len = 0
  deallocate (var%buffer)
  call validate(var, context="test_validation", err=err)
  if (.exists. err) return
  deallocate (var%dims)
  allocate (var%dims(0), var%buffer(1))
  var%len = 1
  call validate(var, context="test_validation", err=err)
  if (.exists. err) return
  passed = .true.
end function pure_storage_validation

pure logical function validation_failure(err, msg) result(failed)
  type(error_type), intent(in) :: err
  character(len=*), intent(in) :: msg

  failed = .false.
  if (err%code /= NC_EINVAL) return
  if (.not. allocated(err%fname)) return
  if (.not. allocated(err%msg)) return
  failed = len_trim(err%fname) > 0 .and. err%msg == msg
end function validation_failure

logical function storage_io_errors() result(passed)
  use, intrinsic :: iso_c_binding, only: c_loc, c_null_char, c_size_t, c_int
  use nc4f_c_interface, only: nc_def_var, nc_put_att, NC_UINT, NC_GLOBAL
  real, parameter :: values(1) = [42.0]
  type(variable_type) :: var, actual
  type(attribute_type) :: att
  type(group_type) :: grp
  type(netcdf_type) :: nc
  type(error_type) :: err
  integer(c_int) :: stat, varid, dimids(0)
  integer(c_int), target :: uint_value
  character(*), parameter :: filename = TEST_RESULTS_DIR//"storage-errors.nc"

  passed = .false.
  var = datarray("data", values, ["x".dim.1], ["units".att."K"])
  var%atts(1)%len = 2
  call to_netcdf(filename, var, err=err)
  if (.not. validation_failure(err, "Attribute buffer is too small.")) return
  att = var%atts(1)
  deallocate (var%atts)
  allocate (var%atts(0))
  call to_netcdf(filename, var, atts=[att], err=err)
  if (.not. validation_failure(err, "Attribute buffer is too small.")) return

  grp%name = "/"
  grp%vars = [var]
  grp%vars(1)%len = -1
  call to_netcdf(filename, grp, err=err)
  if (.not. validation_failure(err, &
    & "Dimension product differs from length.")) return
  deallocate (grp%vars(1)%dims)
  call to_netcdf(filename, grp, err=err)
  if (.not. validation_failure(err, &
    & "Variable dimensions are not allocated.")) return
  call to_netcdf(filename, var, err=err)
  if (.exists. err) return
  nc = open_netcdf(filename, "r", err=err)
  if (.exists. err) return
  actual = get_variable(nc, "data", err=err)
  call close_netcdf(nc)
  if (.exists. err) return
  if (actual /= var) return

  nc = open_netcdf(filename, "w", err=err)
  if (.exists. err) return
  stat = nc_def_var(nc%id, "uint"//c_null_char, NC_UINT, &
    & 0_c_int, dimids, varid)
  if (stat /= NC_NOERR) then
    call close_netcdf(nc)
    return
  end if
  uint_value = 1
  stat = nc_put_att(nc%id, NC_GLOBAL, "uint"//c_null_char, &
    & NC_UINT, 1_c_size_t, c_loc(uint_value))
  call close_netcdf(nc)
  if (stat /= NC_NOERR) return
  nc = open_netcdf(filename, "r", err=err)
  if (.exists. err) return
  actual = get_variable(nc, "uint", err=err)
  if (.not. validation_failure(err, "Unsupported NetCDF data type.")) then
    call close_netcdf(nc)
    return
  end if
  att = get_attribute(nc, "uint", err=err)
  call close_netcdf(nc)
  if (.not. validation_failure(err, "Unsupported NetCDF data type.")) return
  passed = .true.
end function storage_io_errors

pure logical function pure_error_predicates() result(passed)
  use, non_intrinsic :: nc4f_ds, only: &
    & error_type, has_err, operator(.exists.)
  use, non_intrinsic :: nc4f_nc, only: &
    & operator(.ncexists.) => operator(.exists.)
  use, non_intrinsic :: nc4f, only: &
    & operator(.publicexists.) => operator(.exists.)
  type(error_type) :: errors(2)
  logical, parameter :: expected(2) = [.false., .true.]

  errors(1) = error_type()
  errors(2) = error_type(NC_EINVAL, "test_error", "Predicate failure.")
  passed = .false.
  if (has_err(errors(1))) return
  if (.not. has_err(errors(2))) return
  if (.exists. errors(1)) return
  if (.not. (.exists. errors(2))) return
  if (.not. all(has_err(errors) .eqv. expected)) return
  if (.not. all((.exists. errors) .eqv. expected)) return
  if (.not. all((.ncexists. errors) .eqv. expected)) return
  if (.not. all((.publicexists. errors) .eqv. expected)) return
  passed = .true.
end function pure_error_predicates

pure function pure_error_text(msg) result(text)
  !! Check that construction and formatting are usable in pure callers.
  character(len=*), intent(in) :: msg
  !! Diagnostic text to preserve without truncation.
  character(len=:), allocatable :: text
  !! Formatted failure diagnostic.

  text = error_msg(error_type(NC_EINVAL, "test_error", msg))
end function pure_error_text

logical function rejected_error(mode, expected) result(rejected)
  !! Require a failing child and its diagnostic, not just a nonzero exit.
  character(len=*), intent(in) :: mode
  !! Invalid-error scenario to run in the child process.
  character(len=*), intent(in) :: expected
  !! Diagnostic that must appear in the child's output.
  character(len=1024) :: executable, command, line
  character(len=:), allocatable :: logfile
  integer :: status, cmdstat, unit, iostat

  rejected = .false.
  call get_command_argument(0, executable)
  logfile = TEST_RESULTS_DIR//"error-"//mode//".log"
  command = '"'//trim(executable)//'" --invalid-error '//mode// &
    & ' > "'//logfile//'" 2>&1'
  call execute_command_line(trim(command), exitstat=status, cmdstat=cmdstat)
  if (cmdstat /= 0 .or. status /= 1) return
  open (newunit=unit, file=logfile, status="old", iostat=iostat)
  if (iostat /= 0) return
  do
    read (unit, '(a)', iostat=iostat) line
    if (iostat /= 0) exit
    if (index(line, expected) > 0) rejected = .true.
  end do
  close (unit)
end function rejected_error

end submodule nc4f_test_cases_errors
