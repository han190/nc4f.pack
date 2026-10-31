submodule(nc4f_test_cases) nc4f_test_cases_delete
use, intrinsic :: iso_c_binding, only: c_ptr, c_associated
use, non_intrinsic :: nc4f_c_interface, only: NC_EPERM, NC_MAX_NAME
use, non_intrinsic :: nc4f_ds, only: buffer2cptr
implicit none (type, external)
contains

module subroutine delete_att_model(passed)
  !! Test immediate removal, storage preservation, pure callers, and empty collections.
  logical, intent(inout) :: passed
  !! Set true when every model deletion check passes.
  type(variable_type), target :: var
  type(group_type) :: grp
  type(netcdf_type) :: root
  type(attribute_type), target :: owner
  type(error_type) :: err
  type(c_ptr) :: addr

  owner = "source".att.[1_int32, 2_int32]
  allocate (var%atts(-1:2))
  var%atts(-1) = "first".att.1
  var%atts(0) = "middle".att.2
  var%atts(1) = "owned".att.[3, 4]
  call initialize(var%atts(2), "borrowed", owner, deep=.false.)
  var%atts(1)%id = 9
  addr = buffer2cptr(var%atts(1))
  call delete_attribute(var, "middle   ", err)
  call chk_del(err%code == NC_NOERR .and. size(var%atts) == 3, "middle removal and nondefault bounds")
  call chk_del(var%atts(1)%name == "first" .and. var%atts(2)%name == "owned", "survivor order")
  call chk_del(var%atts(2)%id == 9, "model-only deletion preserves IDs")
  call chk_del(c_associated(addr, buffer2cptr(var%atts(2))), "owned storage moved without copying")
  call chk_del(associated(var%atts(3)%ptr, owner%buffer), "borrowed storage preserved")
  grp%atts = ["pure".att.1]
  call del_pure(var, grp, err)
  call chk_del(err%code == NC_NOERR .and. size(grp%atts) == 0, "pure group removal")
  call chk_del(var%atts(1)%name == "owned", "pure first-entry removal")
  call delete_attribute(grp, var, "borrowed", err=err)
  call chk_del(err%code == NC_NOERR .and. size(var%atts) == 1, "default context removes last entry")
  call chk_del(owner == ("source".att.[1_int32, 2_int32]), "deletion leaves borrowed target alive")
  call delete_attribute(grp, var, "owned", update_file=.false.)
  call chk_del(allocated(var%atts), "last removal retains allocated collection")
  call chk_del(size(var%atts) == 0, "last removal leaves zero entries")
  root%atts = ["title".att."root"]
  call delete_attribute(root, "title", update_file=.false., err=err)
  call chk_del(err%code == NC_NOERR .and. size(root%atts) == 0, "extended root and false context")
  passed = .true.
end subroutine delete_att_model

pure subroutine del_pure(var, grp, err)
  !! Compile-time check that both model generic overloads remain pure.
  type(variable_type), intent(inout) :: var
  !! Variable containing an attribute named first.
  type(group_type), intent(inout) :: grp
  !! Group containing an attribute named pure.
  type(error_type), intent(out) :: err
  !! Receives the group deletion status.

  call delete_attribute(var, "first")
  call delete_attribute(grp, "pure", err)
end subroutine del_pure

module subroutine delete_att_file(passed)
  !! Test persistent deletion, partial caches, storage, and invalidated attribute IDs.
  logical, intent(inout) :: passed
  !! Set true when every file deletion check passes.
  character(*), parameter :: file = TEST_RESULTS_DIR//"delete-attributes.nc"
  type(variable_type), target :: var
  type(variable_type) :: unloaded, snapshot
  type(group_type) :: source, children(1), child
  type(netcdf_type) :: nc
  type(attribute_type) :: att, empty
  type(attribute_type), target :: owner
  type(error_type) :: err
  type(c_ptr) :: addr

  var = datarray("data", [1.0, 2.0], ["x".dim.2], &
    & atts=["units".att."m", "long_name".att."measurement", "extra".att.3])
  children(1) = dataset("child", vars=[var], atts=["title".att."child"])
  source = dataset("/", vars=[var], grps=children, atts=["title".att."root", "other".att.1])
  call to_netcdf(file, source)
  nc = open_netcdf(file, "a")
  call delete_attribute(nc, "title", update_file=.true., err=err)
  call chk_del(err%code == NC_NOERR .and. .not. allocated(nc%atts), "unloaded root cache")
  nc%atts = get_attribute(nc)
  call delete_attribute(nc, "other", update_file=.true.)
  call chk_del(size(nc%atts) == 0, "loaded root cache")

  var = get_variable(nc, "data")
  snapshot = var
  nc%vars = [var]
  var%id = -999
  var%atts%id = 42
  addr = buffer2cptr(var%atts(2))
  call delete_attribute(nc, var, "units", update_file=.true., err=err)
  call chk_del(err%code == NC_NOERR .and. size(var%atts) == 2, "resolve variable by name despite stale ID")
  call chk_del(c_associated(addr, buffer2cptr(var%atts(1))), "file deletion preserves surviving buffer")
  call chk_del(all(var%atts%id == empty%id), "surviving attribute IDs invalidated")
  call chk_del(size(snapshot%atts) == 3 .and. size(nc%vars(1)%atts) == 3, "independent snapshots unchanged")

  unloaded%name = "data"
  call delete_attribute(nc, unloaded, "extra", update_file=.true., err=err)
  call chk_del(err%code == NC_NOERR .and. .not. allocated(unloaded%atts), "unloaded variable cache")
  unloaded%atts = ["stale".att.4]
  unloaded%atts%id = 8
  call delete_attribute(nc, unloaded, "long_name", update_file=.true., err=err)
  call chk_del(err%code == NC_NOERR .and. size(unloaded%atts) == 1, "partial cache missing deleted entry")
  call chk_del(unloaded%atts(1)%id == empty%id, "partial cache IDs also invalidated")

  child = get_group(nc, "child")
  child%atts = get_attribute(child)
  call delete_attribute(child, "title", update_file=.true., err=err)
  call chk_del(err%code == NC_NOERR .and. size(child%atts) == 0, "subgroup global attribute")
  ! Cached values may be borrowed, unrelated to the actual stored attribute
  ! value.
  owner = "source".att.[1, 2]
  deallocate (var%atts)
  allocate (var%atts(-1:0))
  var%atts(-1) = "units".att."m"
  call initialize(var%atts(0), "long_name", owner, deep=.false.)
  call delete_attribute(child, var, "units", update_file=.true., err=err)
  call chk_del(err%code == NC_NOERR .and. size(var%atts) == 1, "file nondefault cache bounds")
  call chk_del(associated(var%atts(1)%ptr, owner%buffer), "file deletion preserves borrowed survivor")
  call close_netcdf(nc)

  nc = open_netcdf(file, "r")
  att = get_attribute(nc, "title", err)
  call chk_del(err%code == NC_ENOTATT, "root deletion persists")
  att = get_attribute(nc, "other", err)
  call chk_del(err%code == NC_ENOTATT, "last root attribute deletion persists")
  var = get_variable(nc, "data")
  call chk_del(size(var%atts) == 0, "all root variable attribute deletions persist")
  child = get_group(nc, "child")
  att = get_attribute(child, "title", err)
  call chk_del(err%code == NC_ENOTATT, "subgroup deletion persists")
  var = get_variable(child, "data")
  att = get_attribute(child, var, "units", err)
  call chk_del(err%code == NC_ENOTATT, "subgroup variable deletion persists")
  att = get_attribute(child, var, "long_name", err)
  call chk_del(err%code == NC_NOERR .and. att == ("long_name".att. "measurement"), "survivor value on disk")
  call close_netcdf(nc)
  passed = .true.
end subroutine delete_att_file

module subroutine delete_att_errors(passed)
  !! Test missing/invalid names, failed file writes, duplicate caches, and error stops.
  logical, intent(inout) :: passed
  !! Set true when every failure check passes.
  character(*), parameter :: file = TEST_RESULTS_DIR//"delete-errors.nc"
  type(variable_type) :: var, missing
  type(group_type) :: grp
  type(netcdf_type) :: nc
  type(attribute_type) :: att
  type(error_type) :: err
  character(len=1024) :: executable, command
  integer :: i, status, cmdstat

  call delete_attribute(grp, "absent", err)
  call chk_del(err%code == NC_ENOTATT .and. .not. allocated(grp%atts), "unallocated collection unchanged")
  allocate (grp%atts(0))
  call delete_attribute(grp, "absent", err)
  call chk_del(err%code == NC_ENOTATT .and. size(grp%atts) == 0, "empty collection unchanged")
  grp%atts = ["a".att.1, "a".att.2]
  call delete_attribute(grp, "a", err)
  call chk_del(err%code == NC_EINVAL .and. size(grp%atts) == 2, "duplicate source rejected")
  call delete_attribute(grp, "bad/name", err)
  call chk_del(err%code == NC_EBADNAME, "path rejected")
  call delete_attribute(grp, "a"//char(0)//"b", err)
  call chk_del(err%code == NC_EBADNAME, "embedded NUL rejected")
  call delete_attribute(grp, "", err)
  call chk_del(err%code == NC_EBADNAME, "empty name rejected")
  call delete_attribute(grp, repeat("a", NC_MAX_NAME + 1), err)
  call chk_del(err%code == NC_EMAXNAME, "long name rejected")

  var = datarray("data", [1.0], ["x".dim.1], atts=["a".att.1])
  call to_netcdf(file, var, atts=["a".att.1])
  nc = open_netcdf(file, "r")
  nc%atts = get_attribute(nc)
  nc%atts%id = 7
  call delete_attribute(nc, "a", update_file=.true., err=err)
  call chk_del(err%code == NC_EPERM .and. size(nc%atts) == 1, "read-only group cache unchanged")
  call chk_del(nc%atts(1)%id == 7, "failed deletion preserves cached IDs")
  call delete_attribute(nc, var, "a", update_file=.true., err=err)
  call chk_del(err%code == NC_EPERM .and. size(var%atts) == 1, "read-only variable cache unchanged")
  call close_netcdf(nc)
  nc = open_netcdf(file, "a")
  nc%atts = ["absent".att.2]
  call delete_attribute(nc, "absent", update_file=.true., err=err)
  call chk_del(err%code == NC_ENOTATT .and. size(nc%atts) == 1, "file authoritative for missing attribute")
  nc%atts = ["a".att.1, "a".att.2]
  call delete_attribute(nc, "a", update_file=.true., err=err)
  call chk_del(err%code == NC_EINVAL .and. size(nc%atts) == 2, "duplicate cache rejected before C mutation")
  att = get_attribute(nc, "a", err)
  call chk_del(err%code == NC_NOERR .and. att == ("a".att.1), "duplicate rejection preserves file")
  call delete_attribute(nc, "a"//char(0), update_file=.true., err=err)
  call chk_del(err%code == NC_EBADNAME, "invalid file attribute name")
  call delete_attribute(nc, missing, "a", update_file=.true., err=err)
  call chk_del(err%code == NC_EINVAL, "unnamed variable")
  missing%name = "bad/name"
  call delete_attribute(nc, missing, "a", update_file=.true., err=err)
  call chk_del(err%code == NC_EBADNAME, "invalid variable name")
  missing%name = "absent"
  call delete_attribute(nc, missing, "a", update_file=.true., err=err)
  call chk_del(err%code == NC_ENOTVAR, "missing variable")
  call close_netcdf(nc)
  call delete_attribute(nc, var, "a", update_file=.true., err=err)
  call chk_del(err%code == NC_EBADID .and. size(var%atts) == 1, "closed group leaves cache unchanged")

  call get_command_argument(0, executable)
  do i = 1, 2
    if (i == 1) then
      command = '"'//trim(executable)//'" --delete-invalid-model'
    else
      command = '"'//trim(executable)//'" --delete-invalid-file'
    end if
    call execute_command_line(trim(command)//" > "//TEST_RESULTS_DIR// "delete-failfast.log 2>&1", &
      & exitstat=status, cmdstat=cmdstat)
    call chk_del(cmdstat == 0 .and. status /= 0, "failure without err stops child process")
  end do
  passed = .true.
end subroutine delete_att_errors

pure subroutine chk_del(condition, message)
  !! Stop the test immediately when a deletion assertion fails.
  logical, intent(in) :: condition
  !! Condition required for the test to pass.
  character(len=*), intent(in) :: message
  !! Diagnostic identifying the failed assertion.

  if (.not. condition) error stop "[delete test] "//message
end subroutine chk_del

end submodule nc4f_test_cases_delete
