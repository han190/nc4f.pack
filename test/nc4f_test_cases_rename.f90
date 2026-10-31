submodule(nc4f_test_cases) nc4f_test_cases_rename

use, intrinsic :: iso_c_binding, only: c_ptr, c_associated
use, non_intrinsic :: nc4f_c_interface, only: NC_MAX_NAME, NC_EPERM
use, non_intrinsic :: nc4f_ds, only: buffer2cptr
implicit none (type, external)
contains

module subroutine rename_att_model(passed)
  !! Test in-memory attribute renaming and preservation of model contents.
  logical, intent(inout) :: passed
  !! Set true when all checks in this test succeed.
  type(attribute_type), target :: att, borrowed
  type(attribute_type) :: before
  type(variable_type), target :: var
  type(group_type) :: grp
  type(netcdf_type) :: root
  type(error_type) :: err
  type(c_ptr) :: addr

  att = "old".att.[1_int32, 2_int32]
  att%id = 7
  before = att
  addr = buffer2cptr(att)
  call rename_attribute(att, "new", err)
  call chk_rename(err%code == NC_NOERR, "independent attribute")
  before%name = "new"
  call chk_rename(att == before .and. att%id == 7, "owned attribute metadata/value")
  call chk_rename(c_associated(addr, buffer2cptr(att)), "owned buffer address retained")

  call initialize(borrowed, "borrowed", att, deep=.false.)
  call rename_attribute(borrowed, "alias") ! Also exercise success without err.
  call chk_rename(associated(borrowed%ptr, att%buffer), "borrowed attribute storage retained")
  call chk_rename(.not. allocated(borrowed%buffer), "borrowed attribute remains borrowed")

  var = datarray("v", [1.0, 2.0], ["x".dim.2], atts=[att, "units".att."m"])
  addr = buffer2cptr(var%atts(1))
  call rename_attribute(var, "new", "long_name", err)
  call chk_rename(err%code == NC_NOERR, "variable attribute")
  call chk_rename(var%name == "v" .and. var%atts(1)%name == "long_name", "variable name unaffected")
  call chk_rename(var%atts(2)%name == "units", "attribute order retained")
  call chk_rename(c_associated(addr, buffer2cptr(var%atts(1))), "variable attribute buffer retained")

  grp%atts = ["title".att."group"]
  call rename_attribute(grp, "title", "description", err)
  call chk_rename(err%code == NC_NOERR .and. grp%atts(1)%name == "description", "group attribute")
  root%atts = grp%atts
  call rename_attribute(root, "description", "title", err)
  call chk_rename(err%code == NC_NOERR .and. root%atts(1)%name == "title", "extended root type")

  ! An invalid group ID must be ignored by both model-only context forms.
  call rename_attribute(grp, var, "long_name", "local", err=err)
  call chk_rename(err%code == NC_NOERR .and. var%atts(1)%name == "local", "omitted update_file")
  call rename_attribute(grp, var, "local", "long_name", update_file=.false., err=err)
  call chk_rename(err%code == NC_NOERR, "explicit false variable context")
  call rename_attribute(root, "title", "local", update_file=.false., err=err)
  call chk_rename(err%code == NC_NOERR .and. root%atts(1)%name == "local", "explicit false root context")
  call rename_attribute(var, "long_name", "long_name", err)
  call chk_rename(err%code == NC_NOERR, "model same-name no-op")

  call rename_attribute(att, repeat("a", NC_MAX_NAME), err)
  call chk_rename(err%code == NC_NOERR .and. len(att%name) == NC_MAX_NAME, "maximum name length")
  call rename_attribute(att, "valid padded   ", err)
  call chk_rename(err%code == NC_NOERR .and. len(att%name) == 12, "trailing padding removed")
  call rename_attribute(att, "temperature_"//char(195)//char(169), err)
  call chk_rename(err%code == NC_NOERR, "NFC UTF-8 name")
  call rename_pure_model(att, var, grp, err)
  call chk_rename(err%code == NC_NOERR, "model overloads callable from a pure procedure")
  call chk_rename(att%name == "pure_att" .and. var%atts(1)%name == "pure_var" .and. &
    & grp%atts(1)%name == "pure_grp", "pure caller changes supplied objects")
  passed = .true.
end subroutine rename_att_model

pure subroutine rename_pure_model(att, var, grp, err)
  !! Compile-time regression: the generic exposed by nc4f must retain purity.
  type(attribute_type), intent(inout) :: att
  !! Attribute whose local name is changed.
  type(variable_type), intent(inout) :: var
  !! Variable whose matching attribute is renamed; its data and own name are preserved.
  class(group_type), intent(inout) :: grp
  !! Group whose global attribute is renamed by the pure-call test.
  type(error_type), intent(out) :: err
  !! Receives the operation status and diagnostic message.

  call rename_attribute(att, "pure_att")
  call rename_attribute(var, "long_name", "pure_var", err)
  if (err%code /= NC_NOERR) return
  call rename_attribute(grp, "description", "pure_grp", err)
end subroutine rename_pure_model

module subroutine rename_att_file(passed)
  !! Test persistent attribute renaming and synchronization of supplied caches.
  logical, intent(inout) :: passed
  !! Set true when all checks in this test succeed.
  character(*), parameter :: file = TEST_RESULTS_DIR//"rename-attributes.nc"
  type(variable_type), target :: var
  type(variable_type) :: unloaded, snapshot
  type(group_type) :: source, children(1), child
  type(netcdf_type) :: nc
  type(attribute_type) :: att
  type(error_type) :: err
  type(c_ptr) :: addr

  var = datarray("data", [1.0, 2.0], ["x".dim.2], &
    & atts=["units".att."m", "long_name".att."measurement"])
  children(1) = dataset("child", vars=[var], atts=["title".att."child"])
  source = dataset("/", vars=[var], grps=children, atts=["title".att."root", "other".att.1])
  call to_netcdf(file, source)
  nc = open_netcdf(file, "a")

  ! File-only root rename works without loading global attributes.
  call rename_attribute(nc, "title", "description", update_file=.true., err=err)
  call chk_rename(err%code == NC_NOERR .and. .not. allocated(nc%atts), "unloaded root cache")
  nc%atts = get_attribute(nc)
  call rename_attribute(nc, "description", "heading", update_file=.true., err=err)
  call chk_rename(err%code == NC_NOERR .and. nc%atts(1)%name == "heading", "loaded root cache")
  call rename_attribute(nc, "heading", "heading", update_file=.true., err=err)
  call chk_rename(err%code == NC_NOERR, "file same-name no-op")

  var = get_variable(nc, "data")
  snapshot = var
  nc%vars = [var]
  var%id = -999 ! A detached/stale ID must not select the file target.
  addr = buffer2cptr(var%atts(1))
  call rename_attribute(nc, var, "units", "unit", update_file=.true., err=err)
  call chk_rename(err%code == NC_NOERR .and. var%atts(1)%name == "unit", "loaded variable cache")
  call chk_rename(var%id == -999, "rename leaves unrelated metadata alone")
  call chk_rename(c_associated(addr, buffer2cptr(var%atts(1))), "file rename retains buffer")
  call chk_rename(snapshot%atts(1)%name == "units" .and. nc%vars(1)%atts(1)%name == "units", &
    & "other snapshots unchanged")

  unloaded%name = "data"
  call rename_attribute(nc, unloaded, "long_name", "description", update_file=.true., err=err)
  call chk_rename(err%code == NC_NOERR .and. .not. allocated(unloaded%atts), "unloaded variable cache")
  unloaded%atts = ["unrelated".att.3]
  call rename_attribute(nc, unloaded, "description", "label", update_file=.true., err=err)
  call chk_rename(err%code == NC_NOERR .and. size(unloaded%atts) == 1, "partial cache remains partial")
  call chk_rename(unloaded%atts(1)%name == "unrelated", "no invented cache entry")

  child = get_group(nc, "child")
  child%atts = get_attribute(child)
  call rename_attribute(child, "title", "heading", update_file=.true., err=err)
  call chk_rename(err%code == NC_NOERR .and. child%atts(1)%name == "heading", "subgroup attribute")
  unloaded = variable_type()
  unloaded%name = "data"
  call rename_attribute(child, unloaded, "units", "child_unit", update_file=.true., err=err)
  call chk_rename(err%code == NC_NOERR, "variable resolved in supplied subgroup")

  ! Changes to loaded objects alone must never write through to the open file.
  call rename_attribute(var, "unit", "local_unit")
  call rename_attribute(nc, "heading", "local_heading", update_file=.false.)
  call close_netcdf(nc)
  nc = open_netcdf(file)
  att = get_attribute(nc, "heading")
  call chk_rename(att == ("heading".att."root"), "root rename persisted with value")
  att = get_attribute(nc, "local_heading", err)
  call chk_rename(err%code == NC_ENOTATT, "model root rename did not write")
  var = get_variable(nc, "data")
  att = get_attribute(nc, var, "unit")
  call chk_rename(att == ("unit".att."m"), "variable rename persisted with value")
  att = get_attribute(nc, var, "label")
  call chk_rename(att == ("label".att."measurement"), "partial/unloaded rename persisted")
  att = get_attribute(nc, var, "local_unit", err)
  call chk_rename(err%code == NC_ENOTATT, "model variable rename did not write")
  child = get_group(nc, "child")
  att = get_attribute(child, "heading")
  call chk_rename(att == ("heading".att."child"), "subgroup rename persisted")
  var = get_variable(child, "data")
  att = get_attribute(child, var, "child_unit")
  call chk_rename(att == ("child_unit".att."m"), "subgroup variable rename persisted")
  call close_netcdf(nc)
  passed = .true.
end subroutine rename_att_file

module subroutine rename_att_errors(passed)
  !! Test attribute-renaming failures, unchanged state, and fail-fast behavior.
  logical, intent(inout) :: passed
  !! Set true when all checks in this test succeed.
  character(*), parameter :: file = TEST_RESULTS_DIR//"rename-errors.nc"
  character(len=NC_MAX_NAME + 1) :: invalid(9)
  character(len=1024) :: executable, command
  type(attribute_type) :: att
  type(variable_type) :: var, empty
  type(group_type) :: grp
  type(netcdf_type) :: nc
  type(error_type) :: err
  integer :: i, status, cmdstat

  att = "old".att.1
  invalid = [character(len=NC_MAX_NAME + 1) :: "", " leading", "bad/name", "bad"//achar(0)//"name", &
    & "bad"//achar(9), "bad"//achar(127), "-leading", char(195)//"x", repeat("a", NC_MAX_NAME + 1)]
  do i = 1, size(invalid)
    call rename_attribute(att, invalid(i), err)
    if (i == size(invalid)) then
      call chk_rename(err%code == NC_EMAXNAME, "oversize name error")
    else
      call chk_rename(err%code == NC_EBADNAME, "invalid name error")
    end if
    call chk_rename(att%name == "old", "invalid name leaves model unchanged")
  end do
  call rename_attribute(empty, "old", "new", err)
  call chk_rename(err%code == NC_ENOTATT, "unallocated model attributes")
  allocate (empty%atts(0))
  call rename_attribute(empty, "old", "new", err)
  call chk_rename(err%code == NC_ENOTATT, "empty model attributes")
  var = datarray("data", [1.0], ["x".dim.1], atts=[att, "other".att.2])
  call rename_attribute(var, "old", "other", err)
  call chk_rename(err%code == NC_ENAMEINUSE .and. var%atts(1)%name == "old", "model collision")
  call rename_attribute(var, "missing", "missing", err)
  call chk_rename(err%code == NC_ENOTATT, "missing same-name source")
  grp%atts = [att, att]
  call rename_attribute(grp, "old", "new", err)
  call chk_rename(err%code == NC_EINVAL, "ambiguous duplicate source")

  call to_netcdf(file, var, atts=[att, "other".att.2])
  nc = open_netcdf(file, "r")
  nc%atts = get_attribute(nc)
  call rename_attribute(nc, "old", "new", update_file=.true., err=err)
  call chk_rename(err%code == NC_EPERM .and. nc%atts(1)%name == "old", "read-only group unchanged")
  call rename_attribute(nc, var, "old", "new", update_file=.true., err=err)
  call chk_rename(err%code == NC_EPERM .and. var%atts(1)%name == "old", "read-only variable unchanged")
  call rename_attribute(nc, "old", "old", update_file=.true., err=err)
  call chk_rename(err%code == NC_EPERM, "same-name does not mask read-only error")
  call close_netcdf(nc)

  nc = open_netcdf(file, "a")
  ! With no cache, collisions and missing attributes must be checked in the file.
  call rename_attribute(nc, "old", "other", update_file=.true., err=err)
  call chk_rename(err%code == NC_ENAMEINUSE, "file collision without cache")
  call rename_attribute(nc, "missing", "new", update_file=.true., err=err)
  call chk_rename(err%code == NC_ENOTATT, "missing file attribute")
  call rename_attribute(nc, "missing", "missing", update_file=.true., err=err)
  call chk_rename(err%code == NC_ENOTATT, "missing file same-name source")
  call rename_attribute(nc, var, "old", "bad/name", update_file=.true., err=err)
  call chk_rename(err%code == NC_EBADNAME .and. var%atts(1)%name == "old", "invalid file name unchanged")

  ! A conflict existing only in the cache must be caught before the file changes.
  nc%atts = ["old".att.1, "new".att.99]
  call rename_attribute(nc, "old", "new", update_file=.true., err=err)
  call chk_rename(err%code == NC_ENAMEINUSE .and. nc%atts(1)%name == "old", "cached conflict")
  att = get_attribute(nc, "old")
  call chk_rename(att == ("old".att.1), "cached conflict leaves file unchanged")
  call rename_attribute(nc, empty, "old", "new", update_file=.true., err=err)
  call chk_rename(err%code == NC_EINVAL, "unnamed variable")
  empty%name = "absent"
  call rename_attribute(nc, empty, "old", "new", update_file=.true., err=err)
  call chk_rename(err%code == NC_ENOTVAR, "missing variable")
  call close_netcdf(nc)
  call rename_attribute(nc, var, "old", "new", update_file=.true., err=err)
  call chk_rename(err%code == NC_EBADID .and. var%atts(1)%name == "old", "closed handle unchanged")
  grp = group_type()
  call rename_attribute(grp, "old", "new", update_file=.true., err=err)
  call chk_rename(err%code == NC_EBADID, "invalid group handle")

  call get_command_argument(0, executable)
  do i = 1, 2
    if (i == 1) then
      command = '"'//trim(executable)//'" --rename-invalid-model'
    else
      command = '"'//trim(executable)//'" --rename-invalid-file'
    end if
    call execute_command_line(trim(command)//" > "//TEST_RESULTS_DIR//"rename-failfast.log 2>&1", &
      & exitstat=status, cmdstat=cmdstat)
    call chk_rename(cmdstat == 0 .and. status /= 0, "failure without err stops child process")
  end do
  passed = .true.
end subroutine rename_att_errors

module subroutine rename_var_model(passed)
  !! Test in-memory variable renaming and preservation of model contents.
  logical, intent(inout) :: passed
  !! Set true when all checks in this test succeed.
  type(variable_type), target :: var, borrowed
  type(variable_type) :: before, other
  type(group_type) :: grp, children(1), bounded
  type(netcdf_type) :: root
  type(error_type) :: err
  type(c_ptr) :: addr

  var = datarray("old", [1.0, 2.0], ["old".dim.2], atts=["coordinates".att."old"])
  var%id = 41
  before = var
  addr = buffer2cptr(var)
  call rename_variable(var, "new", err)
  before%name = "new"
  call chk_rename(err%code == NC_NOERR .and. var == before, "independent variable metadata and data")
  call chk_rename(var%id == 41 .and. c_associated(addr, buffer2cptr(var)), "variable ID/buffer retained")
  call initialize(borrowed, "borrowed", var, deep=.false.)
  call rename_variable(borrowed, "alias")
  call chk_rename(associated(borrowed%ptr, var%buffer), "borrowed variable remains associated")
  call chk_rename(.not. allocated(borrowed%buffer), "borrowed variable remains borrowed")

  other = datarray("other", [3.0, 4.0], ["old".dim.2])
  children(1) = dataset("child", vars=[var])
  grp = dataset("/", vars=[var, other], grps=children)
  call rename_variable(grp, "new", "grouped", err)
  call chk_rename(err%code == NC_NOERR .and. grp%vars(1)%name == "grouped", "direct group variable")
  call chk_rename(grp%vars(2)%name == "other", "variable array order retained")
  call chk_rename(grp%vars(1)%dims(1)%name == "old", "model dimension is not renamed")
  call chk_rename(grp%vars(1)%atts(1) == ("coordinates".att."old"), "attribute references unchanged")
  call chk_rename(grp%grps(1)%vars(1)%name == "new", "child group not recursively renamed")
  call chk_rename(var%name == "new", "detached variable snapshot unchanged")
  root%vars = grp%vars
  call rename_variable(root, "grouped", "root_var", err)
  call chk_rename(err%code == NC_NOERR .and. root%vars(1)%name == "root_var", "root model overload")

  ! Invalid group IDs are irrelevant to model-only context calls.
  call rename_variable(grp, var, "local", err=err)
  call chk_rename(err%code == NC_NOERR .and. var%name == "local", "variable context default is model-only")
  call rename_variable(grp, var, "new", update_file=.false., err=err)
  call chk_rename(err%code == NC_NOERR .and. var%name == "new", "false variable context")
  call rename_variable(root, "root_var", "root_local", update_file=.false., err=err)
  call chk_rename(err%code == NC_NOERR .and. root%vars(1)%name == "root_local", "false root context")
  call rename_variable(grp, "grouped", "grouped", err)
  call chk_rename(err%code == NC_NOERR, "model variable same-name no-op")
  call rename_var_pure(var, grp, err)
  call chk_rename(err%code == NC_NOERR .and. var%name == "pure_var" .and. &
    & grp%vars(1)%name == "pure_grp_var", "pure variable generic callers")

  allocate (bounded%vars(0:1))
  bounded%vars = grp%vars
  call rename_variable(bounded, "pure_grp_var", "bounded", err)
  call chk_rename(err%code == NC_NOERR .and. bounded%vars(0)%name == "bounded", "nondefault array bounds")
  call rename_variable(var, repeat("a", NC_MAX_NAME), err)
  call chk_rename(err%code == NC_NOERR .and. len(var%name) == NC_MAX_NAME, "variable maximum name length")
  call rename_variable(var, "valid padded   ", err)
  call chk_rename(err%code == NC_NOERR .and. len(var%name) == 12, "variable name padding")
  call rename_variable(var, "temperature_"//char(195)//char(169), err)
  call chk_rename(err%code == NC_NOERR, "variable NFC UTF-8 name")
  passed = .true.
end subroutine rename_var_model

pure subroutine rename_var_pure(var, grp, err)
  !! Exercise both model variable-renaming overloads from a pure caller.
  type(variable_type), intent(inout) :: var
  !! Variable whose local name is changed; its metadata and storage are preserved.
  class(group_type), intent(inout) :: grp
  !! Group whose direct variable collection contains the name to change.
  type(error_type), intent(out) :: err
  !! Receives the operation status and diagnostic message.

  call rename_variable(var, "pure_var")
  call rename_variable(grp, "grouped", "pure_grp_var", err)
end subroutine rename_var_pure

module subroutine rename_var_file(passed)
  !! Test persistent variable renaming and synchronization of supplied caches.
  logical, intent(inout) :: passed
  !! Set true when all checks in this test succeed.
  character(*), parameter :: file = TEST_RESULTS_DIR//"rename-variables.nc"
  type(variable_type), target :: var
  type(variable_type) :: original, other, snapshot
  type(group_type) :: source, children(1), child
  type(netcdf_type), target :: nc
  type(error_type) :: err
  type(c_ptr) :: addr

  original = datarray("x", [1.0, 2.0], ["x".dim.2], atts=["coordinates".att."x"])
  other = datarray("other", [3.0, 4.0], ["x".dim.2], atts=["units".att."1"])
  children(1) = dataset("child", vars=[original])
  source = dataset("/", vars=[original, other], grps=children)
  call to_netcdf(file, source)
  nc = open_netcdf(file, "a")
  var = get_variable(nc, "x")
  snapshot = var
  nc%vars = [var, get_variable(nc, "other")]
  var%id = -999
  addr = buffer2cptr(var)
  call rename_variable(nc, var, "axis", update_file=.true., err=err)
  call chk_rename(err%code == NC_NOERR .and. var%name == "axis", "file rename uses old name, not stale ID")
  call chk_rename(var%id == -999 .and. c_associated(addr, buffer2cptr(var)), "file variable preserves ID/storage")
  call chk_rename(snapshot%name == "x" .and. nc%vars(1)%name == "x", "file rename leaves other snapshots")
  call chk_rename(var%dims(1)%name == "x", "coordinate rename preserves in-memory dimension name")

  nc%vars = [var, get_variable(nc, "other")]
  addr = buffer2cptr(nc%vars(1))
  call rename_variable(nc, "axis", "coordinate", update_file=.true., err=err)
  call chk_rename(err%code == NC_NOERR .and. nc%vars(1)%name == "coordinate", "group cache synchronized")
  call chk_rename(c_associated(addr, buffer2cptr(nc%vars(1))), "cached variable buffer retained")
  call rename_variable(nc, "coordinate", "coordinate", update_file=.true., err=err)
  call chk_rename(err%code == NC_NOERR, "file variable same-name no-op")
  deallocate (nc%vars)
  call rename_variable(nc, "coordinate", "longitude", update_file=.true., err=err)
  call chk_rename(err%code == NC_NOERR .and. .not. allocated(nc%vars), "unloaded variable cache")
  nc%vars = [get_variable(nc, "other")]
  call rename_variable(nc, "longitude", "position", update_file=.true., err=err)
  call chk_rename(err%code == NC_NOERR .and. size(nc%vars) == 1, "partial variable cache stays partial")
  call chk_rename(nc%vars(1)%name == "other", "no invented variable cache entry")

  child = get_group(nc, "child")
  child%vars = [get_variable(child, "x")]
  call rename_variable(child, "x", "child_position", update_file=.true., err=err)
  call chk_rename(err%code == NC_NOERR .and. child%vars(1)%name == "child_position", "subgroup variable cache")
  ! The same new name can exist in separate groups.
  var = get_variable(child, "child_position")
  call rename_variable(child, var, "position", update_file=.true., err=err)
  call chk_rename(err%code == NC_NOERR .and. var%name == "position", "subgroup supplied-variable overload")
  call rename_variable(nc, var, "model_only", update_file=.false.)
  call rename_variable(nc, "other", "local_other")
  call close_netcdf(nc)

  nc = open_netcdf(file)
  var = get_variable(nc, "position")
  original%name = "position"
  call chk_rename(var == original, "file data/attributes/dimensions persist after coordinate rename")
  call chk_rename(var%dims(1)%name == "x", "coordinate rename does not rename disk dimension")
  var = inquire_variable(nc, "x", err)
  call chk_rename(err%code == NC_ENOTVAR, "old disk variable name is gone")
  var = get_variable(nc, "other")
  call chk_rename(var == other, "model-only group rename does not write")
  child = get_group(nc, "child")
  var = get_variable(child, "position")
  call chk_rename(var == original, "subgroup rename persists independently")
  var = inquire_variable(child, "model_only", err)
  call chk_rename(err%code == NC_ENOTVAR, "model-only variable context does not write")
  call close_netcdf(nc)
  passed = .true.
end subroutine rename_var_file

module subroutine rename_var_errors(passed)
  !! Test variable-renaming failures, unchanged state, and fail-fast behavior.
  logical, intent(inout) :: passed
  !! Set true when all checks in this test succeed.
  character(*), parameter :: file = TEST_RESULTS_DIR//"rename-variable-errors.nc"
  character(len=NC_MAX_NAME + 1) :: invalid(12)
  character(len=1024) :: executable, command
  type(attribute_type) :: att
  type(variable_type) :: var, other, unnamed, actual
  type(group_type) :: grp, children(1)
  type(netcdf_type) :: nc
  type(error_type) :: err, att_err
  integer :: i, status, cmdstat

  var = datarray("old", [1.0], ["x".dim.1], atts=["units".att."1"])
  other = datarray("other", [2.0], ["x".dim.1])
  att = "old".att.1
  invalid = [character(len=NC_MAX_NAME + 1) :: "", " leading", "bad/name", "bad"//achar(0)//"name", &
    & "bad"//achar(9), "bad"//achar(127), "-leading", char(195)//"x", repeat("a", NC_MAX_NAME + 1), &
    & char(224)//char(128)//char(128), char(237)//char(160)//char(128), char(244)//char(144)//char(128)//char(128)]
  do i = 1, size(invalid)
    call rename_variable(var, invalid(i), err)
    call rename_attribute(att, invalid(i), att_err)
    call chk_rename(err%code == att_err%code .and. err%code /= NC_NOERR, "shared name checker errors")
    call chk_rename(var%name == "old" .and. att%name == "old", "invalid name preserves both models")
  end do
  call rename_variable(grp, "old", "new", err)
  call chk_rename(err%code == NC_ENOTVAR, "unallocated variable collection")
  allocate (grp%vars(0))
  call rename_variable(grp, "old", "new", err)
  call chk_rename(err%code == NC_ENOTVAR, "empty variable collection")
  grp%vars = [var, other]
  call rename_variable(grp, "old", "other", err)
  call chk_rename(err%code == NC_ENAMEINUSE .and. grp%vars(1)%name == "old", "model variable collision")
  call rename_variable(grp, "missing", "missing", err)
  call chk_rename(err%code == NC_ENOTVAR, "missing model variable same-name")
  grp%vars = [var, var]
  call rename_variable(grp, "old", "new", err)
  call chk_rename(err%code == NC_EINVAL, "duplicate model variable source")
  children(1) = dataset("child", vars=[var])
  grp = dataset("/", grps=children)
  call rename_variable(grp, "old", "new", err)
  call chk_rename(err%code == NC_ENOTVAR, "model rename does not search children")

  grp = dataset("/", vars=[var, other])
  call to_netcdf(file, grp)
  nc = open_netcdf(file, "r")
  nc%vars = [var, other]
  call rename_variable(nc, var, "new", update_file=.true., err=err)
  call chk_rename(err%code == NC_EPERM .and. var%name == "old", "read-only variable unchanged")
  call rename_variable(nc, "old", "new", update_file=.true., err=err)
  call chk_rename(err%code == NC_EPERM .and. nc%vars(1)%name == "old", "read-only group cache unchanged")
  call rename_variable(nc, "old", "old", update_file=.true., err=err)
  call chk_rename(err%code == NC_EPERM, "variable no-op preserves read-only error")
  call close_netcdf(nc)
  nc = open_netcdf(file, "a")
  call rename_variable(nc, "old", "other", update_file=.true., err=err)
  call chk_rename(err%code == NC_ENAMEINUSE, "file collision without cache")
  call rename_variable(nc, var, "other", update_file=.true., err=err)
  call chk_rename(err%code == NC_ENAMEINUSE .and. var%name == "old", "file collision preserves supplied variable")
  call rename_variable(nc, "absent", "new", update_file=.true., err=err)
  call chk_rename(err%code == NC_ENOTVAR, "missing file variable")
  call rename_variable(nc, "absent", "absent", update_file=.true., err=err)
  call chk_rename(err%code == NC_ENOTVAR, "missing file variable no-op")
  call rename_variable(nc, var, "bad/name", update_file=.true., err=err)
  call chk_rename(err%code == NC_EBADNAME .and. var%name == "old", "invalid file destination")
  call rename_variable(nc, "old"//achar(0)//"suffix", "new", update_file=.true., err=err)
  call chk_rename(err%code == NC_EBADNAME, "invalid file source cannot truncate at NUL")
  call rename_variable(nc, unnamed, "new", update_file=.true., err=err)
  call chk_rename(err%code == NC_EINVAL .and. .not. allocated(unnamed%name), "unnamed file variable")
  unnamed%name = "absent"
  call rename_variable(nc, unnamed, "new", update_file=.true., err=err)
  call chk_rename(err%code == NC_ENOTVAR .and. unnamed%name == "absent", "missing supplied variable")

  other%name = "new" ! A conflict only in cached metadata must stop before file mutation.
  nc%vars = [var, other]
  call rename_variable(nc, "old", "new", update_file=.true., err=err)
  call chk_rename(err%code == NC_ENAMEINUSE .and. nc%vars(1)%name == "old", "cached variable collision")
  actual = get_variable(nc, "old")
  call chk_rename(actual == var, "cached conflict preserves disk data")
  nc%vars = [var, var]
  call rename_variable(nc, "old", "new", update_file=.true., err=err)
  call chk_rename(err%code == NC_EINVAL, "duplicate file cache source")
  call close_netcdf(nc)
  call rename_variable(nc, var, "new", update_file=.true., err=err)
  call chk_rename(err%code == NC_EBADID .and. var%name == "old", "closed file variable unchanged")
  grp = group_type()
  call rename_variable(grp, "old", "new", update_file=.true., err=err)
  call chk_rename(err%code == NC_EBADID, "invalid group handle for variable rename")

  call get_command_argument(0, executable)
  do i = 1, 2
    if (i == 1) then
      command = '"'//trim(executable)//'" --rename-var-invalid-model'
    else
      command = '"'//trim(executable)//'" --rename-var-invalid-file'
    end if
    call execute_command_line(trim(command)//" > "//TEST_RESULTS_DIR//"rename-var-failfast.log 2>&1", &
      & exitstat=status, cmdstat=cmdstat)
    call chk_rename(cmdstat == 0 .and. status /= 0, "variable rename failure without err stops")
  end do
  passed = .true.
end subroutine rename_var_errors

pure subroutine chk_rename(condition, context)
  !! Terminate a renaming test when an assertion fails.
  logical, intent(in) :: condition
  !! Condition that must be true for the assertion to succeed.
  character(len=*), intent(in) :: context
  !! Label included in a failed assertion message.

  if (.not. condition) error stop "[rename test] "//context
end subroutine chk_rename

end submodule nc4f_test_cases_rename
