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

  invalid = datarray("", values, ["x".dim.1])
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
