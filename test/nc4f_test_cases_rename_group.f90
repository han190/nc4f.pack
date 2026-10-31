submodule(nc4f_test_cases) nc4f_test_cases_rename_group
use, intrinsic :: iso_c_binding, only: c_ptr, c_associated
use, non_intrinsic :: nc4f_c_interface, only: NC_MAX_NAME, NC_EPERM
use, non_intrinsic :: nc4f_ds, only: buffer2cptr
implicit none (type, external)
contains

module subroutine rename_grp_model(passed)
  !! Test in-memory group renaming and preservation of model contents.
  logical, intent(inout) :: passed
  !! Set true when all checks in this test succeed.
  type(group_type) :: grp, parent, alias, snapshot, empty
  type(group_type), target :: kids(-2:0), grandchildren(1), none(0)
  type(netcdf_type) :: root
  type(error_type) :: err
  type(c_ptr) :: addr

  grp = dataset("old", vars=[datarray("v", [1.0, 2.0], ["x".dim.2])], atts=["title".att."group"])
  grp%id = 71
  grandchildren(1)%name = "nested"
  grp%grps => grandchildren
  addr = buffer2cptr(grp%vars(1))
  call rename_group(grp, "new padded   ", err)
  call chk_grp(err%code == NC_NOERR .and. grp%name == "new padded", "standalone trimmed name")
  call chk_grp(grp%id == 71 .and. associated(grp%grps, grandchildren), "group ID and child tree preserved")
  call chk_grp(c_associated(addr, buffer2cptr(grp%vars(1))), "variable storage preserved")
  call chk_grp(grp%dims(1)%name == "x" .and. grp%atts(1)%name == "title", "group metadata preserved")
  call rename_group(empty, "initialized")
  call chk_grp(empty%name == "initialized", "previously unnamed group")
  call rename_group(grp, repeat("a", NC_MAX_NAME), err)
  call chk_grp(err%code == NC_NOERR .and. len(grp%name) == NC_MAX_NAME, "maximum group name length")
  call rename_group(grp, "temperature_"//char(195)//char(169), err)
  call chk_grp(err%code == NC_NOERR, "UTF-8 group name")

  kids(-2) = grp
  kids(-2)%name = "child"
  kids(-1)%name = "other"
  parent%grps => kids
  alias = parent
  snapshot = kids(-2)
  call rename_group(parent, "child", "renamed", err)
  call chk_grp(err%code == NC_NOERR .and. kids(-2)%name == "renamed", "nonunit pointer lower bound")
  call chk_grp(alias%grps(-2)%name == "renamed", "shared child array observes rename")
  call chk_grp(snapshot%name == "child", "independent name remains snapshot")
  call chk_grp(associated(kids(-2)%grps, grandchildren), "renamed child retains descendants")
  call rename_grp_pure(grp, parent, err)
  call chk_grp(err%code == NC_NOERR .and. grp%name == "pure", "pure standalone caller")
  call chk_grp(kids(-2)%name == "pure_child", "pure child caller")
  call rename_group(parent, "pure_child", "pure_child", err)
  call chk_grp(err%code == NC_NOERR, "model same-name operation")
  call rename_group(parent, "pure_child", "other", err)
  call chk_grp(err%code == NC_ENAMEINUSE .and. kids(-2)%name == "pure_child", "model sibling collision")
  call rename_group(parent, "nested", "new", err)
  call chk_grp(err%code == NC_ENOGRP, "no recursive child search")
  call rename_group(parent, "missing", "missing", err)
  call chk_grp(err%code == NC_ENOGRP, "missing same-name source")
  kids(-1)%name = "pure_child"
  call rename_group(parent, "pure_child", "new", err)
  call chk_grp(err%code == NC_EINVAL, "duplicate source names")
  nullify (parent%grps)
  call rename_group(parent, "old", "new", err)
  call chk_grp(err%code == NC_ENOGRP, "unassociated child array")
  parent%grps => none
  call rename_group(parent, "old", "new", err)
  call chk_grp(err%code == NC_ENOGRP, "empty associated child array")

  root%grps => kids
  call rename_group(root, "pure_child", "new", err)
  call chk_grp(err%code == NC_EINVAL, "root accepted as parent with duplicate source check")
  kids(-1)%name = "other"
  call rename_group(root, "pure_child", "root_child", update_file=.false., err=err)
  call chk_grp(err%code == NC_NOERR .and. kids(-2)%name == "root_child", "false update ignores invalid root ID")
  call rename_group(parent, grp, "local", err=err)
  call chk_grp(err%code == NC_NOERR .and. grp%name == "local", "object update defaults to false")
  call rename_group(parent, grp, "local_again", update_file=.false., err=err)
  call chk_grp(err%code == NC_NOERR, "explicit false object update")
  call rename_group(root, "forbidden", err)
  call chk_grp(err%code == NC_EBADGRPID .and. .not. allocated(root%name), "unnamed root type rejected")
  root%name = "custom"
  call rename_group(root, "forbidden", err)
  call chk_grp(err%code == NC_EBADGRPID .and. root%name == "custom", "root type with non-root label rejected")
  grp%name = "/"
  call rename_group(grp, "forbidden", err)
  call chk_grp(err%code == NC_EBADGRPID .and. grp%name == "/", "root marker rejected")
  passed = .true.
end subroutine rename_grp_model

pure subroutine rename_grp_pure(grp, parent, err)
  !! Exercise both model group-renaming overloads from a pure caller.
  class(group_type), intent(inout) :: grp, parent
  !! grp: Non-root group whose local name is changed.
  !! parent: Parent whose direct child collection is edited or whose ID locates the file group.
  type(error_type), intent(out) :: err
  !! Receives the operation status and diagnostic message.
  call rename_group(grp, "pure")
  call rename_group(parent, "renamed", "pure_child", err)
end subroutine rename_grp_pure

module subroutine rename_grp_file(passed)
  !! Test persistent group renaming and synchronization of supplied caches.
  logical, intent(inout) :: passed
  !! Set true when all checks in this test succeed.
  character(*), parameter :: file = TEST_RESULTS_DIR//"rename-groups.nc"
  type(group_type) :: source, grp, snapshot, actual, alias, child
  type(group_type), target :: kids(2), descendants(1), cache(-1:0), nested_cache(1), partial(1)
  type(netcdf_type) :: nc
  type(variable_type) :: original, values
  type(attribute_type) :: att
  type(error_type) :: err
  integer :: saved_id
  type(c_ptr) :: addr

  original = datarray("v", [1.0, 2.0], ["x".dim.2], atts=["units".att."1"])
  kids(1) = dataset("old", vars=[original], atts=["title".att."original"])
  kids(2)%name = "other"
  descendants(1) = dataset("old", vars=[original])
  kids(1)%grps => descendants
  source%name = "/"
  source%grps => kids
  call to_netcdf(file, source)
  nc = open_netcdf(file, "a")
  grp = get_group(nc, "old")
  grp%vars = [get_variable(grp, "v")]
  snapshot = grp
  cache(-1) = grp
  cache(0) = get_group(nc, "other")
  nc%grps => cache
  grp%id = -999
  addr = buffer2cptr(grp%vars(1))
  call rename_group(nc, grp, "first", update_file=.true., err=err)
  call chk_grp(err%code == NC_NOERR .and. grp%name == "first", "file rename resolves stale child ID by name")
  call chk_grp(grp%id == -999 .and. c_associated(addr, buffer2cptr(grp%vars(1))), "object ID and storage retained")
  call chk_grp(snapshot%name == "old" .and. cache(-1)%name == "old", "detached names remain snapshots")
  cache(-1) = get_group(nc, "first")
  nested_cache(1) = get_group(cache(-1), "old")
  cache(-1)%grps => nested_cache
  saved_id = cache(-1)%id
  alias%grps => cache
  call rename_group(nc, "first", "second", update_file=.true., err=err)
  call chk_grp(err%code == NC_NOERR .and. cache(-1)%name == "second", "file cache with nonunit bounds")
  call chk_grp(alias%grps(-1)%name == "second", "file rename visible through shared cache")
  call chk_grp(cache(-1)%id == saved_id .and. associated(cache(-1)%grps, nested_cache), "cached ID/tree preserved")
  call rename_group(nc, "second", "second", update_file=.true., err=err)
  call chk_grp(err%code == NC_NOERR, "writable same-name file operation")
  ! Also exercise a supplied object that is itself in the parent's child array.
  call rename_group(nc, cache(-1), "third", update_file=.true., err=err)
  call chk_grp(err%code == NC_NOERR .and. alias%grps(-1)%name == "third", "supplied child aliases cache")
  nullify (nc%grps)
  call rename_group(nc, "third", "fourth", update_file=.true., err=err)
  call chk_grp(err%code == NC_NOERR .and. .not. associated(nc%grps), "unloaded group cache stays unloaded")
  partial(1) = get_group(nc, "other")
  nc%grps => partial
  call rename_group(nc, "fourth", "final", update_file=.true., err=err)
  call chk_grp(err%code == NC_NOERR .and. size(nc%grps) == 1, "partial group cache stays partial")
  call chk_grp(partial(1)%name == "other", "no invented cache entry")
  actual = get_group(nc, "final")
  child = get_group(actual, "old")
  call rename_group(actual, child, "other", update_file=.true., err=err)
  call chk_grp(err%code == NC_NOERR, "nested group scope permits name also present at root")
  call rename_group(nc, "other", "local_only", update_file=.false.)
  call rename_group(nc, grp, "detached_only")
  call close_netcdf(nc)

  nc = open_netcdf(file, "r")
  actual = get_group(nc, "final")
  values = get_variable(actual, "v")
  call chk_grp(values == original, "group contents persist unchanged")
  att = get_attribute(actual, "title")
  call chk_grp(att == ("title".att."original"), "global attribute persists")
  child = get_group(actual, "other")
  values = get_variable(child, "v")
  call chk_grp(values == original, "descendant follows renamed parent after reopen")
  child = get_group(nc, "old", err)
  call chk_grp(err%code == NC_ENOGRP, "old group name gone from file")
  child = get_group(actual, "old", err)
  call chk_grp(err%code == NC_ENOGRP, "old nested name gone from file")
  child = get_group(nc, "other", err)
  call chk_grp(err%code == NC_NOERR, "model-only parent operation did not write")
  child = get_group(nc, "local_only", err)
  call chk_grp(err%code == NC_ENOGRP, "model-only destination absent from file")
  call close_netcdf(nc)
  passed = .true.
end subroutine rename_grp_file

module subroutine rename_grp_errors(passed)
  !! Test group-renaming failures, unchanged state, and fail-fast behavior.
  logical, intent(inout) :: passed
  !! Set true when all checks in this test succeed.
  character(*), parameter :: file = TEST_RESULTS_DIR//"rename-group-errors.nc"
  character(len=NC_MAX_NAME + 1) :: invalid(12)
  character(len=1024) :: executable, command
  type(group_type) :: source, grp, unnamed, actual, bad
  type(group_type), target :: kids(2), cache(2)
  type(netcdf_type) :: nc, root
  type(attribute_type) :: att
  type(error_type) :: err, expected
  integer :: i, status, cmdstat

  grp%name = "old"
  att = "old".att.1
  invalid = [character(len=NC_MAX_NAME + 1) :: "", " leading", "bad/name", "bad"//achar(0)//"name", &
    & "bad"//achar(9), "bad"//achar(127), "-leading", char(195)//"x", repeat("a", NC_MAX_NAME + 1), &
    & char(224)//char(128)//char(128), char(237)//char(160)//char(128), char(244)//char(144)//char(128)//char(128)]
  do i = 1, size(invalid)
    call rename_group(grp, invalid(i), err)
    call rename_attribute(att, invalid(i), expected)
    call chk_grp(err%code == expected%code .and. err%code /= NC_NOERR, "shared name validation")
    call chk_grp(grp%name == "old", "invalid model name preserves group")
  end do
  kids(1)%name = "old"
  kids(2)%name = "other"
  source%name = "/"
  source%grps => kids
  call to_netcdf(file, source)
  nc = open_netcdf(file, "r")
  cache = kids
  nc%grps => cache
  call rename_group(nc, "old", "new", update_file=.true., err=err)
  call chk_grp(err%code == NC_EPERM .and. cache(1)%name == "old", "read-only failure preserves cache")
  call rename_group(nc, "old", "old", update_file=.true., err=err)
  call chk_grp(err%code == NC_EPERM, "same-name file operation preserves read-only error")
  call rename_group(nc, grp, "new", update_file=.true., err=err)
  call chk_grp(err%code == NC_EPERM .and. grp%name == "old", "read-only object unchanged")
  call close_netcdf(nc)
  nc = open_netcdf(file, "a")
  call rename_group(nc, "old", "other", update_file=.true., err=err)
  call chk_grp(err%code == NC_ENAMEINUSE, "disk sibling collision without cache")
  call rename_group(nc, grp, "other", update_file=.true., err=err)
  call chk_grp(err%code == NC_ENAMEINUSE .and. grp%name == "old", "disk collision preserves supplied group")
  call rename_group(nc, "absent", "new", update_file=.true., err=err)
  call chk_grp(err%code == NC_ENOGRP, "missing file source")
  call rename_group(nc, "absent", "absent", update_file=.true., err=err)
  call chk_grp(err%code == NC_ENOGRP, "missing file source same-name")
  call rename_group(nc, grp, "bad/name", update_file=.true., err=err)
  call chk_grp(err%code == NC_EBADNAME .and. grp%name == "old", "invalid file destination")
  call rename_group(nc, "old"//achar(0)//"suffix", "new", update_file=.true., err=err)
  call chk_grp(err%code == NC_EBADNAME, "invalid source cannot truncate at NUL")
  call rename_group(nc, unnamed, "new", update_file=.true., err=err)
  call chk_grp(err%code == NC_EINVAL .and. .not. allocated(unnamed%name), "unnamed supplied file group")
  unnamed%name = "absent"
  call rename_group(nc, unnamed, "new", update_file=.true., err=err)
  call chk_grp(err%code == NC_ENOGRP .and. unnamed%name == "absent", "missing supplied file group")
  root%name = "old"
  call rename_group(nc, root, "new", update_file=.true., err=err)
  call chk_grp(err%code == NC_EBADGRPID .and. root%name == "old", "root dynamic type rejected before file update")
  root%name = "/"
  grp%name = "/"
  call rename_group(nc, grp, "new", update_file=.true., err=err)
  call chk_grp(err%code == NC_EBADGRPID .and. grp%name == "/", "root marker rejected before file update")
  call rename_group(nc, "/", "new", update_file=.true., err=err)
  call chk_grp(err%code == NC_EBADNAME, "path input cannot rename root")
  grp%name = "old"
  cache(1)%name = "old"
  cache(2)%name = "new"
  nc%grps => cache
  call rename_group(nc, "old", "new", update_file=.true., err=err)
  call chk_grp(err%code == NC_ENAMEINUSE .and. cache(1)%name == "old", "cache-only collision stops file update")
  cache(2)%name = "old"
  call rename_group(nc, "old", "new", update_file=.true., err=err)
  call chk_grp(err%code == NC_EINVAL, "duplicate cached sources rejected")
  actual = get_group(nc, "old", err)
  call chk_grp(err%code == NC_NOERR, "cache errors leave disk source intact")
  actual = get_group(nc, "new", err)
  call chk_grp(err%code == NC_ENOGRP, "cache errors leave disk destination absent")
  call close_netcdf(nc)
  call rename_group(nc, grp, "new", update_file=.true., err=err)
  call chk_grp(err%code == NC_EBADID .and. grp%name == "old", "closed file leaves group unchanged")
  call rename_group(bad, "old", "new", update_file=.true., err=err)
  call chk_grp(err%code == NC_EBADID, "invalid parent ID")

  call get_command_argument(0, executable)
  do i = 1, 2
    if (i == 1) then
      command = '"'//trim(executable)//'" --rename-grp-invalid-model'
    else
      command = '"'//trim(executable)//'" --rename-grp-invalid-file'
    end if
    call execute_command_line(trim(command)//" > "//TEST_RESULTS_DIR//"rename-group-failfast.log 2>&1", &
      & exitstat=status, cmdstat=cmdstat)
    call chk_grp(cmdstat == 0 .and. status == 1, "group rename without err stops on failure")
  end do
  passed = .true.
end subroutine rename_grp_errors

pure subroutine chk_grp(condition, context)
  !! Terminate a group-renaming test when an assertion fails.
  logical, intent(in) :: condition
  !! Condition that must be true for the assertion to succeed.
  character(len=*), intent(in) :: context
  !! Label included in a failed assertion message.
  if (.not. condition) error stop "[rename group test] "//context
end subroutine chk_grp

end submodule nc4f_test_cases_rename_group
