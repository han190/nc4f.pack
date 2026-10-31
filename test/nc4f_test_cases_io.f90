submodule(nc4f_test_cases) nc4f_test_cases_io

use, intrinsic :: iso_c_binding, only: c_char, c_loc, c_null_char, c_size_t
use, non_intrinsic :: nc4f_c_interface, only: NC_DISKLESS, NC_PERSIST, NC_GLOBAL, nc_put_att_text
implicit none (type, external)

contains

module subroutine diskless_read(passed)
  logical, intent(inout) :: passed
  character(*), parameter :: file = TEST_RESULTS_DIR//"diskless-read.nc"
  type(netcdf_type) :: nc
  type(variable_type), target :: var, reread
  type(group_type) :: child
  type(attribute_type) :: att
  type(error_type) :: err
  real(real32), pointer :: values(:)

  var = datarray("data", [1.0_real32, 2.0_real32], ["x".dim.2])
  child = dataset("child", vars=[var], atts=["title".att."child"])
  call to_netcdf(file, [child])
  nc = open_netcdf(file, diskless=.true., err=err)
  call chk_diskless(err%code == NC_NOERR, "default diskless read")
  call chk_diskless(nc%mode == NC_DISKLESS, "read mode flags")
  child = get_group(nc, "child")
  att = get_attribute(child, "title")
  call chk_diskless(att == ("title".att."child"), "read subgroup attribute")
  var = get_variable(child, "data")
  call extract(var, values)
  call chk_diskless(all(values == [1.0_real32, 2.0_real32]), "read values")
  values = 9.0_real32
  reread = get_variable(child, "data")
  call extract(reread, values)
  call chk_diskless(all(values == [1.0_real32, 2.0_real32]), "extracted data does not write through")
  call rename_attribute(child, "title", "heading", update_file=.true., err=err)
  call chk_diskless(err%code /= NC_NOERR, "read-only rename rejected")
  call delete_attribute(child, "title", update_file=.true., err=err)
  call chk_diskless(err%code /= NC_NOERR, "read-only deletion rejected")
  call close_netcdf(nc, err)
  call chk_diskless(err%code == NC_NOERR, "close diskless read")
  call close_netcdf(nc, err)
  call chk_diskless(err%code == NC_EBADID, "close error propagated")
  nc = open_netcdf(file)
  child = get_group(nc, "child")
  att = get_attribute(child, "title")
  call chk_diskless(att == ("title".att."child"), "read-only source unchanged")
  call close_netcdf(nc)
  passed = .true.
end subroutine diskless_read

module subroutine diskless_edit(passed)
  logical, intent(inout) :: passed
  character(*), parameter :: file = TEST_RESULTS_DIR//"diskless-edit.nc"
  character(11), parameter :: modes(*) = [character(11) :: &
    & "an", "a", "append_temp", "append"]
  logical, parameter :: saves(*) = [.false., .true., .false., .true.]
  type(netcdf_type) :: nc
  type(variable_type) :: var
  type(group_type) :: child
  type(attribute_type) :: att
  type(error_type) :: err
  integer :: mode_index

  do mode_index = 1, size(modes)
    var = datarray("data", [1.0_real32, 2.0_real32], ["x".dim.2])
    child = dataset("child", vars=[var], atts=["title".att."child", "remove".att.1])
    call to_netcdf(file, [child])
    nc = open_netcdf(file, modes(mode_index), .true., err)
    call chk_diskless(err%code == NC_NOERR, "open "//modes(mode_index))
    call chk_diskless(iand(nc%mode, NC_DISKLESS) /= 0, "edit diskless flag")
    call chk_diskless((iand(nc%mode, NC_PERSIST) /= 0) .eqv. saves(mode_index), "edit persist flag")
    child = get_group(nc, "child")
    call rename_variable(child, "data", "renamed", update_file=.true.)
    call rename_dimension(child, "x", "axis", update_file=.true.)
    call rename_attribute(child, "title", "heading", update_file=.true.)
    call delete_attribute(child, "remove", update_file=.true.)
    call rename_group(nc, "child", "renamed_child", update_file=.true.)
    child = get_group(nc, "renamed_child")
    var = get_variable(child, "renamed")
    call chk_diskless(var%dims(1)%name == "axis", "RAM dimension renamed")
    att = get_attribute(child, "heading")
    call chk_diskless(att == ("heading".att."child"), "RAM attribute renamed")
    att = get_attribute(child, "remove", err=err)
    call chk_diskless(err%code == NC_ENOTATT, "RAM attribute deleted")
    call close_netcdf(nc, err)
    call chk_diskless(err%code == NC_NOERR, "close "//modes(mode_index))
    nc = open_netcdf(file)
    if (saves(mode_index)) then
      child = get_group(nc, "renamed_child")
      var = get_variable(child, "renamed")
      call chk_diskless(var%dims(1)%name == "axis", "dimension persisted")
      att = get_attribute(child, "heading")
      call chk_diskless(att == ("heading".att."child"), "rename persisted")
      att = get_attribute(child, "remove", err=err)
      call chk_diskless(err%code == NC_ENOTATT, "deletion persisted")
    else
      child = get_group(nc, "child")
      var = get_variable(child, "data")
      call chk_diskless(var%dims(1)%name == "x", "original dimension retained")
      att = get_attribute(child, "title")
      call chk_diskless(att == ("title".att."child"), "original name retained")
      att = get_attribute(child, "remove")
      call chk_diskless(att == ("remove".att.1), "original attribute retained")
    end if
    call close_netcdf(nc)
  end do
  passed = .true.
end subroutine diskless_edit

module subroutine diskless_create(passed)
  logical, intent(inout) :: passed
  character(*), parameter :: file = TEST_RESULTS_DIR//"diskless-create.nc"
  character(10), parameter :: modes(*) = [character(10) :: &
    & "wn", "w", "write_temp", "write"]
  logical, parameter :: saves(*) = [.false., .true., .false., .true.]
  character(kind=c_char, len=3), target :: marker = "ram"
  type(netcdf_type) :: nc
  type(variable_type) :: var
  type(attribute_type) :: att
  type(error_type) :: err
  logical :: exists
  integer :: mode_index, file_unit, existing_index

  do mode_index = 1, size(modes)
    do existing_index = 0, 1
      inquire(file=file, exist=exists)
      if (exists) then
        open(newunit=file_unit, file=file, status="old")
        close(file_unit, status="delete")
      end if
      if (existing_index == 1) then
        var = datarray("original", [1.0_real32], ["x".dim.1])
        call to_netcdf(file, var)
      end if
      nc = open_netcdf(file, modes(mode_index), diskless=.true., err=err)
      call chk_diskless(err%code == NC_NOERR, "create "//modes(mode_index))
      call chk_diskless(iand(nc%mode, NC_DISKLESS) /= 0, "create diskless flag")
      call chk_diskless((iand(nc%mode, NC_PERSIST) /= 0) .eqv. saves(mode_index), "create persist flag")
      call chk_diskless(nc_put_att_text(nc%id, NC_GLOBAL, "marker"//c_null_char, &
        & 3_c_size_t, c_loc(marker)) == NC_NOERR, "populate RAM dataset")
      att = get_attribute(nc, "marker")
      call chk_diskless(att == ("marker".att."ram"), "read created RAM data")
      call close_netcdf(nc, err)
      call chk_diskless(err%code == NC_NOERR, "close "//modes(mode_index))
      inquire(file=file, exist=exists)
      call chk_diskless(exists .eqv. (saves(mode_index) .or. existing_index == 1), "creation persistence")
      if (.not. exists) cycle
      nc = open_netcdf(file)
      if (saves(mode_index)) then
        att = get_attribute(nc, "marker")
        call chk_diskless(att == ("marker".att."ram"), "created data persisted")
        var = get_variable(nc, "original", err=err)
        call chk_diskless(err%code == NC_ENOTVAR, "persistent create replaces contents")
      else
        var = get_variable(nc, "original")
        att = get_attribute(nc, "marker", err=err)
        call chk_diskless(err%code == NC_ENOTATT, "nonpersistent create preserves original file")
      end if
      call close_netcdf(nc)
    end do
  end do
  passed = .true.
end subroutine diskless_create

module subroutine diskless_modes(passed)
  logical, intent(inout) :: passed
  character(*), parameter :: file = TEST_RESULTS_DIR//"diskless-modes.nc"
  character(*), parameter :: missing = TEST_RESULTS_DIR//"diskless-missing.nc"
  character(6), parameter :: disk_modes(*) = [character(6) :: &
    & "r", "read", "a", "append", "w", "write"]
  character(11), parameter :: existing_modes(*) = [character(11) :: "r", "a", "an", "read", "append", "append_temp"]
  character(11), parameter :: temp_modes(*) = [character(11) :: "an", "wn", "append_temp", "write_temp"]
  character(20), parameter :: invalid_modes(*) = [character(20) :: "rp", "rn", "", "xx", "ap", "wp", &
    & "read_diskless", "append_diskless", "append_diskless_temp", "write_diskless", "write_diskless_temp", &
    & "rw", "readwrite", "replace", "overwrite"]
  type(netcdf_type) :: nc
  type(variable_type) :: var
  type(error_type) :: err
  logical :: exists
  integer :: mode_index, file_unit

  var = datarray("original", [1.0_real32], ["x".dim.1])
  do mode_index = 1, size(disk_modes)
    call to_netcdf(file, var)
    nc = open_netcdf(file, trim(disk_modes(mode_index)), .false., err)
    call chk_diskless(err%code == NC_NOERR, "disk-backed alias "//trim(disk_modes(mode_index)))
    call chk_diskless(iand(nc%mode, NC_DISKLESS) == 0, "disk-backed mode flags")
    call close_netcdf(nc)
  end do
  call to_netcdf(file, var)
  do mode_index = 1, size(temp_modes)
    nc = open_netcdf(file, temp_modes(mode_index), err=err)
    call chk_diskless(err%code == NC_EINVAL, "reject diskless mode without diskless")
    nc = open_netcdf(file, temp_modes(mode_index), .false., err)
    call chk_diskless(err%code == NC_EINVAL, "reject diskless mode with explicit false")
  end do
  do mode_index = 1, size(invalid_modes)
    nc = open_netcdf(file, invalid_modes(mode_index), .true., err)
    call chk_diskless(err%code == NC_EINVAL, "invalid diskless mode")
    call chk_diskless(index(err%msg, "r/read") > 0 .and. &
      & index(err%msg, "a/append") > 0 .and. index(err%msg, "an/append_temp") > 0 .and. &
      & index(err%msg, "w/write") > 0 .and. index(err%msg, "wn/write_temp") > 0, &
      & "diskless diagnostic lists aliases")
    nc = open_netcdf(file, invalid_modes(mode_index), .false., err)
    call chk_diskless(err%code == NC_EINVAL, "invalid disk-backed mode")
    nc = open_netcdf(file, invalid_modes(mode_index), err=err)
    call chk_diskless(err%code == NC_EINVAL, "invalid mode with default storage")
  end do
  nc = open_netcdf(file, "r", .true., err)
  call chk_diskless(err%code == NC_NOERR, "explicit diskless read")
  var = get_variable(nc, "original")
  call chk_diskless(var%len == 1, "invalid opens preserve existing file")
  call close_netcdf(nc)

  nc = open_netcdf(file, "read", .true., err)
  call chk_diskless(err%code == NC_NOERR, "long diskless read alias")
  call chk_diskless(nc%mode == NC_DISKLESS, "long read alias flags match r")
  var = get_variable(nc, "original")
  call chk_diskless(var%len == 1, "long read alias retrieves data")
  call rename_variable(nc, "original", "renamed", update_file=.true., err=err)
  call chk_diskless(err%code /= NC_NOERR, "long read alias remains read-only")
  call close_netcdf(nc)

  inquire(file=missing, exist=exists)
  if (exists) then
    open(newunit=file_unit, file=missing, status="old")
    close(file_unit, status="delete")
  end if
  nc = open_netcdf(missing, "wp", .true., err)
  call chk_diskless(err%code == NC_EINVAL, "validate before creation")
  do mode_index = 1, size(existing_modes)
    nc = open_netcdf(missing, trim(existing_modes(mode_index)), .true., err)
    call chk_diskless(err%code /= NC_NOERR, "diskless open requires existing file")
    call chk_diskless(err%fname == "open_netcdf" .and. len_trim(err%msg) > 0, "open error context")
  end do
  inquire(file=missing, exist=exists)
  call chk_diskless(.not. exists, "failed opens do not create files")
  passed = .true.
end subroutine diskless_modes

subroutine chk_diskless(condition, context)
  logical, intent(in) :: condition
  character(*), intent(in) :: context

  if (condition) return
  print *, "[diskless] ", context
  error stop "Diskless I/O assertion failed."
end subroutine chk_diskless

module subroutine unlimited_wr(passed)
  !! Round-trip a variable whose record dimension is unlimited.
  logical, intent(inout) :: passed
  !! Whether the test case has passed.
  integer(int32), parameter :: values(2, 3) = reshape([ &
    & 1_int32, 2_int32, 3_int32, 4_int32, 5_int32, 6_int32], [2, 3])
  integer(int32), pointer :: actual_values(:, :)
  type(netcdf_type) :: nc
  type(variable_type) :: actual, var

  var = datarray("records", values, ["x".dim.2, "time".dim.3])
  var%dims(2)%is_unlim = .true.
  call to_netcdf(TEST_RESULTS_DIR//"unlimited.nc", var)

  nc = open_netcdf(TEST_RESULTS_DIR//"unlimited.nc", "r")
  actual = get_variable(nc, "records")
  call close_netcdf(nc)
  call extract(actual, actual_values)
  passed = actual%dims(2)%is_unlim .and. &
    & all(actual%dims == var%dims) .and. all(actual_values == values)
end subroutine unlimited_wr

module subroutine unlimited_dims(passed)
  !! Verify that dimension inquiries retain unlimited-dimension metadata.
  logical, intent(inout) :: passed
  !! Whether the test case has passed.
  integer(int32), parameter :: values(2, 3) = reshape([ &
    & 1_int32, 2_int32, 3_int32, 4_int32, 5_int32, 6_int32], [2, 3])
  type(error_type) :: err
  type(netcdf_type) :: nc
  type(variable_type) :: actual, var

  var = datarray("records", values, ["x".dim.2, "time".dim.3])
  var%dims%is_unlim = .true.
  call to_netcdf(TEST_RESULTS_DIR//"multiple-unlimited.nc", var, err=err)
  if ((err%code /= NC_NOERR)) then
    passed = .false.
    return
  end if
  nc = open_netcdf(TEST_RESULTS_DIR//"multiple-unlimited.nc", "r", err=err)
  if ((err%code /= NC_NOERR)) then
    passed = .false.
    return
  end if
  actual = get_variable(nc, "records", err=err)
  call close_netcdf(nc)
  passed = err%code == NC_NOERR .and. all(actual%dims%is_unlim) .and. &
    & all(actual%dims == var%dims)
end subroutine unlimited_dims

end submodule nc4f_test_cases_io
