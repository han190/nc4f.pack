submodule(nc4f_test_cases) nc4f_test_cases_write
use, intrinsic :: iso_c_binding, only: c_int, c_null_char
use, non_intrinsic :: nc4f_c_interface, only: nc_def_grp, nc_inq_dimid
implicit none (type, external)
contains

pure subroutine check_write(condition, message)
  !! Terminate on a failed write assertion without performing external-unit I/O.
  logical, intent(in) :: condition
  !! Condition that must hold for the test to continue.
  character(len=*), intent(in) :: message
  !! Diagnostic context identifying the assertion or operation being checked.
  if (.not. condition) error stop "[write API] "//message
end subroutine check_write

pure subroutine check_ok(err, message)
  !! Require a successful operation, retaining its diagnostic on failure.
  type(error_type), intent(in) :: err
  !! Operation result that must indicate success.
  character(len=*), intent(in) :: message
  !! Diagnostic context identifying the assertion or operation being checked.
  if (err%code == NC_NOERR) return
  call check_write(.false., message//": "//error_msg(err))
end subroutine check_ok

module subroutine write_definition(passed)
  !! Test metadata-only definition, dimension reuse, supported types, and subgroup access.
  logical, intent(inout) :: passed
  !! Set true when all assertions in this test pass.
  character(*), parameter :: file = TEST_RESULTS_DIR//"write-definition.nc"
  type(netcdf_type) :: nc
  !! Open destination dataset or subgroup; source objects and loaded caches are unchanged.
  type(group_type) :: child
  type(variable_type) :: var, got
  type(error_type) :: err
  !! Completed operation result; contains a diagnostic when the operation fails.
  type(dimension_type) :: scalar_dims(0)
  integer(c_int) :: stat, dimid
  integer, pointer :: ints(:)
  real, pointer :: reals(:)
  real :: empty(0)
  integer(int8), pointer :: bytes(:)
  integer(int16), pointer :: shorts(:)
  integer(int64), pointer :: longs(:)
  real(real64), pointer :: doubles(:)

  passed = .false.
  nc = open_netcdf(file, "w")
  ! Object definitions require schema metadata, but never require payload storage.
  call define_variable(nc, var, err)
  call check_write(err%code == NC_EINVAL, "reject unallocated object name")
  var%name = "metadata"
  var%dtype = NC_FLOAT
  call define_variable(nc, var, err=err)
  call check_write(err%code == NC_EINVAL, "reject unallocated object dimensions")
  var%dims = ["metadata_x".dim.1000000]
  call define_variable(nc=nc, var=var, err=err)
  call check_ok(err, "define object without storage or attributes")
  got = inquire_variable(nc, "metadata")
  call check_write(got%len == 1000000 .and. got%dtype == NC_FLOAT, "object schema")
  call check_write(.not. allocated(var%buffer) .and. .not. associated(var%ptr), &
    & "definition leaves source storage absent")
  call check_write(.not. allocated(var%atts), "definition leaves source attributes absent")
  call define_variable(nc, var, err)
  call check_write(err%code == NC_ENAMEINUSE, "reject duplicate object definition")

  var = datarray("object_values", [10, 20], ["object_x".dim.2], &
    & atts=["units".att."K", "_FillValue".att.(-1)])
  dimid = var%id
  call define_variable(nc, var, err)
  call check_ok(err, "define materialized object with attributes")
  got = get_variable(nc, "object_values")
  call extract(got, ints)
  call check_write(all(ints == -1), "definition writes fill attribute but no source data")
  call check_write(get_attribute(nc, got, "units") == ("units".att."K"), "object attributes")
  call extract(var, ints)
  call check_write(all(ints == [10, 20]) .and. var%id == dimid, "source data and ID unchanged")
  call put_variable(nc, var)
  got = get_variable(nc, "object_values")
  call extract(got, ints)
  call check_write(all(ints == [10, 20]), "write data after object definition")
  var%name = "invalid_object_fill"
  var%atts = ["_FillValue".att.0.0]
  call define_variable(nc, var, err)
  call check_write(err%code == NC_EINVAL, "object definition validates attributes")

  ! No variable-sized data allocation is needed for definition.
  call define_variable(nc, "large", NC_FLOAT, ["large_x".dim.1000000], err=err)
  call check_ok(err, "metadata-only definition")
  got = inquire_variable(nc, "large")
  call check_write(got%len == 1000000 .and. .not. allocated(got%buffer), "metadata-only inquiry")
  call define_variable(nc, "values", NC_INT, ["x".dim.4], ["units".att."original"], err)
  call check_ok(err, "define fixed variable")
  call define_variable(nc, &
    & variable_type(name="same_dimension", dtype=NC_FLOAT, &
    & dims=["x".dim.4]), err=err)
  call check_ok(err, "reuse fixed dimension")
  call define_variable(nc, "bad_dimension", NC_FLOAT, ["new_x".dim.3, "x".dim.5], err=err)
  call check_write(err%code == NC_EINVAL, "reject conflicting length")
  stat = nc_inq_dimid(nc%id, "new_x"//c_null_char, dimid)
  call check_write(stat == NC_EBADDIM, "preflight avoids creating earlier dimension")
  call define_variable(nc, &
    & variable_type(name="bad_unlimited", dtype=NC_FLOAT, &
    & dims=["x".dim.(4 .and. .true.)]), err=err)
  call check_write(err%code == NC_EINVAL, "reject conflicting unlimited status")
  call define_variable(nc, &
    & variable_type(name="values", dtype=NC_INT, &
    & dims=["must_not_exist".dim.8]), err=err)
  call check_write(err%code == NC_ENAMEINUSE, "existing variable is an error")
  stat = nc_inq_dimid(nc%id, "must_not_exist"//c_null_char, dimid)
  call check_write(stat == NC_EBADDIM, "existing variable does not create dimensions")
  call define_variable(nc, &
    & variable_type(name="bad_fill", dtype=NC_INT, &
    & dims=["unused".dim.2], &
    & atts=["_FillValue".att.0.0]), err=err)
  call check_write(err%code == NC_EINVAL, "reject mismatched fill attribute")
  call define_variable(nc, &
    & variable_type(name="bad_type", dtype=-1_c_int, &
    & dims=scalar_dims), err=err)
  call check_write(err%code == NC_EBADTYPE, "unsupported type")
  call define_variable(nc, &
    & variable_type(name="bad/name", dtype=NC_INT, &
    & dims=scalar_dims), err=err)
  call check_write(err%code == NC_EBADNAME, "invalid variable name")
  call define_variable(nc, &
    & variable_type(name="zero_fixed", dtype=NC_FLOAT, &
    & dims=["zero".dim.0]), err=err)
  call check_write(err%code == NC_EINVAL, "fixed zero must not silently become unlimited")

  var = datarray("values", [1, 2, 3, 4], ["x".dim.4], atts=["units".att."replacement"])
  call put_variable(nc, var, err=err)
  call check_ok(err, "created handle is writable")
  got = get_variable(nc, "values")
  call extract(got, ints)
  call check_write(all(ints == [1, 2, 3, 4]), "full integer write")
  call check_write(get_attribute(nc, got, "units") == ("units".att."original"), &
    & "preserve attributes")

  var = datarray("scalar", [3.5_real64], scalar_dims)
  call define_variable(nc, var)
  call put_variable(nc, var)
  call define_variable(nc, "byte", NC_BYTE, ["one".dim.1])
  call put_variable(nc, datarray("byte", [7_int8], ["one".dim.1]))
  call define_variable(nc, &
    & variable_type(name="short", dtype=NC_SHORT, &
    & dims=["one".dim.1]))
  call put_variable(nc, datarray("short", [123_int16], ["one".dim.1]))
  call define_variable(nc, &
    & variable_type(name="long", dtype=NC_INT64, &
    & dims=["one".dim.1]))
  call put_variable(nc, datarray("long", [1234567890123_int64], ["one".dim.1]))

  ! Reuse a parent's unlimited dimension from a subgroup and extend it.
  call define_variable(nc, &
    & variable_type(name="empty", dtype=NC_FLOAT, &
    & dims=["time".dim.(0 .and. .true.)]))
  call put_variable(nc, datarray("empty", empty, ["time".dim.(0 .and. .true.)]), err=err)
  call check_ok(err, "empty whole-variable write")
  stat = nc_def_grp(nc%id, "child"//c_null_char, child%id)
  call check_write(stat == NC_NOERR, "create subgroup")
  var = variable_type()
  var%name = "records"
  var%dtype = NC_FLOAT
  var%dims = ["time".dim.(0 .and. .true.)]
  call define_variable(child, var, err=err)
  call check_ok(err, "reuse inherited unlimited dimension")
  var = datarray("records", [10.0, 20.0], ["time".dim.2])
  call put_variable(child, var, start=[2], stride=[2], err=err)
  call check_ok(err, "subgroup strided append")
  got = inquire_variable(child, "records")
  call check_write(got%dims(1)%is_unlim .and. got%dims(1)%len == 4, "inherited unlimited growth")
  call close_netcdf(nc)

  nc = open_netcdf(file)
  got = get_variable(nc, "scalar")
  call extract(got, doubles)
  call check_write(size(got%dims) == 0 .and. doubles(1) == 3.5_real64, "scalar persistence")
  got = get_variable(nc, "byte")
  call extract(got, bytes)
  call check_write(bytes(1) == 7_int8, "byte persistence")
  got = get_variable(nc, "short")
  call extract(got, shorts)
  call check_write(shorts(1) == 123_int16, "short persistence")
  got = get_variable(nc, "long")
  call extract(got, longs)
  call check_write(longs(1) == 1234567890123_int64, "int64 persistence")
  child = get_group(nc, "child")
  got = get_variable(child, "records", start=[2], count=[2], stride=[2])
  call extract(got, reals)
  call check_write(all(reals == [10.0, 20.0]), "subgroup selection persistence")
  call put_variable(child, var, start=[2], stride=[2], err=err)
  call check_write(err%code == NC_EPERM, "read-only subgroup write")
  var = variable_type()
  var%name = "readonly"
  var%dtype = NC_FLOAT
  var%dims = ["time".dim.(0 .and. .true.)]
  call define_variable(child, var, err=err)
  call check_write(err%code == NC_EPERM, "read-only subgroup definition")
  call close_netcdf(nc)
  passed = .true.
end subroutine write_definition

module subroutine write_selection(passed)
  !! Test contiguous and strided writes, unlimited growth, and path/handle equivalence.
  logical, intent(inout) :: passed
  !! Set true when all assertions in this test pass.
  character(*), parameter :: file = TEST_RESULTS_DIR//"write-selection.nc"
  type(netcdf_type) :: nc
  !! Open destination dataset or subgroup; source objects and loaded caches are unchanged.
  type(variable_type) :: var, got
  type(error_type) :: err
  !! Completed operation result; contains a diagnostic when the operation fails.
  real :: expected(5, 4), empty(0)
  real, target :: patch(2, 2)
  real, pointer :: actual(:, :), records(:)
  character(len=1) :: chars(3)
  character(len=1), pointer :: letters(:)

  passed = .false.
  expected = -1.0
  patch = reshape([11.0, 12.0, 21.0, 22.0], [2, 2])
  nc = open_netcdf(file, "w")
  call define_variable(nc, &
    & variable_type(name="grid", dtype=NC_FLOAT, &
    & dims=["x".dim.5, "y".dim.4], &
    & atts=["_FillValue".att.(-1.0)]))
  var = datarray("grid", patch, ["x".dim.2, "y".dim.2], deep=.false.)
  call put_variable(nc, var, start=[2, 1], count=[2, 2], stride=[2, 3], err=err)
  call check_ok(err, "multidimensional strided write")
  expected(2:4:2, 1:4:3) = patch
  got = get_variable(nc, "grid")
  call extract(got, actual)
  call check_write(all(actual == expected), "selected and untouched values")
  call put_variable(nc, var, count=[2, 2], err=err)
  call check_ok(err, "count alone defaults start and stride")
  expected(1:2, 1:2) = patch
  call put_variable(nc, var, stride=[2, 2], err=err)
  call check_ok(err, "stride alone defaults start and count")
  expected(1:3:2, 1:3:2) = patch

  call define_variable(nc, &
    & variable_type(name="series", dtype=NC_FLOAT, &
    & dims=["time".dim.(0 .and. .true.)], &
    & atts=["_FillValue".att.(-9.0)]))
  var = datarray("series", [1.0, 2.0, 3.0], ["time".dim.3])
  call put_variable(nc, var, start=[2], stride=[2])
  got = get_variable(nc, "series")
  call extract(got, records)
  call check_write(all(records == [-9.0, 1.0, -9.0, 2.0, -9.0, 3.0]), "unlimited gaps and growth")
  call put_variable(nc, datarray("series", [4.0, 5.0], ["time".dim.2]), start=[7])

  call define_variable(nc, &
    & variable_type(name="two_unlimited", dtype=NC_FLOAT, &
    & dims=["u".dim.(0 .and. .true.), "v".dim.(0 .and. .true.)]))
  call put_variable(nc, datarray("two_unlimited", patch, ["u".dim.2, "v".dim.2]), &
    & start=[2, 3], stride=[3, 2])
  got = inquire_variable(nc, "two_unlimited")
  call check_write(all(got%dims%len == [5, 5]) .and. all(got%dims%is_unlim), &
    & "multiple unlimited growth")

  call define_variable(nc, &
    & variable_type(name="letters", dtype=NC_CHAR, &
    & dims=["letter".dim.5], &
    & atts=["_FillValue".att."-"]))
  chars = ["a", "b", "c"]
  var = datarray("letters", chars, ["letter".dim.3])
  call put_variable(nc, var, stride=[2], err=err)
  call check_ok(err, "character strided write")
  call close_netcdf(nc)
  nc = open_netcdf(file)
  got = get_variable(nc, "grid")
  call extract(got, actual)
  call check_write(all(actual == expected), "grid persistence")
  got = get_variable(nc, "series")
  call extract(got, records)
  call check_write(all(records == [-9.0, 1.0, -9.0, 2.0, -9.0, 3.0, 4.0, 5.0]), &
    & "append persistence")
  got = get_variable(nc, "letters")
  call extract(got, letters)
  call check_write(all(letters == ["a", "-", "b", "-", "c"]), "character persistence")
  call close_netcdf(nc)
  ! Repeat the same writes through to_netcdf and compare with the handle-based result.
  nc = open_netcdf(TEST_RESULTS_DIR//"write-selection-path.nc", "w")
  call define_variable(nc, &
    & variable_type(name="grid", dtype=NC_FLOAT, &
    & dims=["x".dim.5, "y".dim.4], &
    & atts=["_FillValue".att.(-1.0)]))
  call close_netcdf(nc)
  var = datarray("grid", patch, ["x".dim.2, "y".dim.2])
  call to_netcdf(TEST_RESULTS_DIR//"write-selection-path.nc", var, mode="a", &
    & start=[2, 1], count=[2, 2], stride=[2, 3])
  call to_netcdf(TEST_RESULTS_DIR//"write-selection-path.nc", var, mode="a", count=[2, 2])
  call to_netcdf(TEST_RESULTS_DIR//"write-selection-path.nc", var, mode="a", stride=[2, 2])
  nc = open_netcdf(TEST_RESULTS_DIR//"write-selection-path.nc")
  got = get_variable(nc, "grid")
  call extract(got, actual)
  call check_write(all(actual == expected), "path and handle writes agree")
  call close_netcdf(nc)
  ! Empty serialization remains valid when the dimension is explicitly unlimited.
  var = datarray("empty", empty, ["time".dim.(0 .and. .true.)])
  call to_netcdf(TEST_RESULTS_DIR//"write-empty.nc", var, err=err)
  call check_ok(err, "empty serialization")
  passed = .true.
end subroutine write_selection

module subroutine write_paths(passed)
  !! Test path-based creation and updates, preserving files on rejected requests.
  logical, intent(inout) :: passed
  !! Set true when all assertions in this test pass.
  character(*), parameter :: file = TEST_RESULTS_DIR//"write-paths.nc"
  type(netcdf_type) :: nc
  !! Open destination dataset or subgroup; source objects and loaded caches are unchanged.
  type(variable_type) :: var, got, extra
  type(group_type) :: grp
  type(error_type) :: err
  !! Completed operation result; contains a diagnostic when the operation fails.
  real, pointer :: values(:)

  passed = .false.
  var = datarray("data", [0.0, 0.0, 0.0, 0.0, 0.0, 0.0], ["x".dim.6], ["units".att."K"])
  call to_netcdf(file, var, ["title".att."initial"], err)
  call check_ok(err, "original positional signature")
  var = datarray("data", [10.0, 20.0, 30.0], ["x".dim.3], ["units".att."changed"])
  call to_netcdf(file, var, mode="append", start=[2], count=[3], stride=[2], err=err)
  call check_ok(err, "path strided update")
  call to_netcdf(file, var, start=[1], err=err)
  call check_write(err%code == NC_EINVAL, "selection cannot clobber")
  call to_netcdf(file, [var], mode="a", stride=[2], err=err)
  call check_write(err%code == NC_EINVAL, "variable array selection rejected")
  grp = dataset("root", [var])
  call to_netcdf(file, grp, stride=[2], err=err)
  call check_write(err%code == NC_EINVAL, "group selection cannot clobber")
  call to_netcdf(file, grp, mode="a", err=err)
  call check_write(err%code == NC_EINVAL, "group append rejected")
  call to_netcdf(file, var, mode="r", err=err)
  call check_write(err%code == NC_EINVAL, "invalid mode")
  extra = datarray("missing", [1.0], ["missing_dim".dim.1])
  call to_netcdf(file, extra, mode="a", start=[1], err=err)
  call check_write(err%code == NC_ENOTVAR, "selected write never defines")
  call to_netcdf(file, extra, mode="a", err=err)
  call check_ok(err, "append creates whole variable")
  call to_netcdf(file, datarray("data", [7.0], ["x".dim.1]), mode="a", err=err)
  call check_ok(err, "append existing writes source shape at origin")
  call to_netcdf(file, [extra], ["title".att."updated"], err, mode="a")
  call check_ok(err, "whole variable array append")
  nc = open_netcdf(file)
  got = get_variable(nc, "data")
  call extract(got, values)
  call check_write(all(values == [7.0, 10.0, 0.0, 20.0, 0.0, 30.0]), "preserved values and file")
  call check_write(get_attribute(nc, got, "units") == ("units".att."K"), &
    & "update preserves variable attributes")
  call check_write(get_attribute(nc, "title") == ("title".att."updated"), &
    & "explicit global attribute update")
  call close_netcdf(nc)
  ! Invalid input is rejected before overwrite opens the file.
  var%len = 999
  call to_netcdf(file, var, err=err)
  call check_write(err%code == NC_EINVAL, "invalid source rejected before overwrite")
  nc = open_netcdf(file)
  got = inquire_variable(nc, "missing")
  call check_write(got%len == 1, "preflight preserved file")
  call close_netcdf(nc)
  passed = .true.
end subroutine write_paths

module subroutine write_failures(passed)
  !! Test invalid selections, incompatible sources, and read-only or closed handles.
  logical, intent(inout) :: passed
  !! Set true when all assertions in this test pass.
  character(*), parameter :: file = TEST_RESULTS_DIR//"write-failures.nc"
  type(netcdf_type) :: nc
  !! Open destination dataset or subgroup; source objects and loaded caches are unchanged.
  type(variable_type) :: var, got, wrong
  type(error_type) :: err
  !! Completed operation result; contains a diagnostic when the operation fails.
  real, pointer :: values(:)
  real :: empty(0)

  passed = .false.
  var = datarray("data", [0.0, 0.0, 0.0, 0.0], ["x".dim.4])
  call to_netcdf(file, var)
  nc = open_netcdf(file, "a")
  var = datarray("data", [1.0, 2.0], ["x".dim.2])
  call put_variable(nc, var, start=[0], err=err)
  call check_write(err%code == NC_EINVALCOORDS, "zero start")
  call put_variable(nc, var, stride=[0], err=err)
  call check_write(err%code == NC_EINVAL, "zero stride")
  call put_variable(nc, var, stride=[-1], err=err)
  call check_write(err%code == NC_EINVAL, "negative stride")
  call put_variable(nc, var, count=[0], err=err)
  call check_write(err%code == NC_EINVAL, "zero selected count")
  call put_variable(nc, var, count=[1], err=err)
  call check_write(err%code == NC_EINVAL, "source shape mismatch")
  call put_variable(nc, var, start=[1, 1], err=err)
  call check_write(err%code == NC_EINVAL, "selection rank mismatch")
  call put_variable(nc, var, count=[2, 1], err=err)
  call check_write(err%code == NC_EINVAL, "write count rank mismatch")
  call put_variable(nc, var, stride=[1, 1], err=err)
  call check_write(err%code == NC_EINVAL, "write stride rank mismatch")

  ! Shared selection preparation must preserve the stricter read argument rules.
  got = get_variable(nc, "data", start=[1, 1], err=err)
  call check_write(err%code == NC_EINVAL, "read start rank mismatch")
  got = get_variable(nc, "data", start=[1], count=[1, 1], err=err)
  call check_write(err%code == NC_EINVAL, "read count rank mismatch")
  got = get_variable(nc, "data", start=[1], count=[1], stride=[1, 1], err=err)
  call check_write(err%code == NC_EINVAL, "read stride rank mismatch")
  got = get_variable(nc, "data", stride=[1], err=err)
  call check_write(err%code == NC_EINVAL, "read stride still requires start and count")
  got = get_variable(nc, "data", start=[1], stride=[1], err=err)
  call check_write(err%code == NC_EINVAL, "read stride still requires count")
  call put_variable(nc, var, stride=[4], err=err)
  call check_write(err%code == NC_EEDGE, "fixed bound with stride")
  call put_variable(nc, var, start=[huge(1)], stride=[huge(1)], err=err)
  call check_write(err%code == NC_EEDGE, "large indices do not wrap")
  wrong = datarray("data", [1, 2], ["x".dim.2])
  call put_variable(nc, wrong, err=err)
  call check_write(err%code == NC_EINVAL, "type mismatch")
  wrong = datarray("data", reshape([1.0, 2.0], [1, 2]), ["x".dim.1, "y".dim.2])
  call put_variable(nc, wrong, err=err)
  call check_write(err%code == NC_EINVAL, "source rank mismatch")
  wrong = datarray("data", [1.0, 2.0], ["wrong".dim.2])
  call put_variable(nc, wrong, err=err)
  call check_write(err%code == NC_EINVAL, "dimension order/name mismatch")
  wrong = datarray("missing", [1.0], ["x".dim.1])
  call put_variable(nc, wrong, err=err)
  call check_write(err%code == NC_ENOTVAR, "missing variable")
  call define_variable(nc, &
    & variable_type(name="empty", dtype=NC_FLOAT, &
    & dims=["time".dim.(0 .and. .true.)]))
  wrong = datarray("empty", empty, ["time".dim.(0 .and. .true.)])
  call put_variable(nc, wrong, start=[1], err=err)
  call check_write(err%code == NC_EINVAL, "explicit empty selection rejected")
  got = get_variable(nc, "data")
  call extract(got, values)
  call check_write(all(values == 0.0), "failed selections left data unchanged")
  call close_netcdf(nc)
  call put_variable(nc, var, err=err)
  call check_write(err%code == NC_EBADID, "closed handle")
  call define_variable(nc, &
    & variable_type(name="closed", dtype=NC_FLOAT, &
    & dims=["x".dim.4]), err=err)
  call check_write(err%code == NC_EBADID, "closed handle definition")
  nc = open_netcdf(file)
  call put_variable(nc, var, err=err)
  call check_write(err%code == NC_EPERM, "read-only data write")
  call define_variable(nc, &
    & variable_type(name="readonly", dtype=NC_FLOAT, &
    & dims=["new".dim.4]), err=err)
  call check_write(err%code == NC_EPERM, "read-only definition")
  call put_variable(nc, wrong, err=err)
  call check_write(err%code == NC_EPERM, "read-only empty write")
  call close_netcdf(nc)
  passed = .true.
end subroutine write_failures

end submodule nc4f_test_cases_write
