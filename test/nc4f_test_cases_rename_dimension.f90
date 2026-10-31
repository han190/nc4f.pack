submodule(nc4f_test_cases) nc4f_test_cases_rename_dimension
use, intrinsic :: iso_c_binding, only: c_ptr, c_associated, c_int, c_null_char, c_loc
use, non_intrinsic :: nc4f_c_interface, only: NC_EPERM, NC_MAX_NAME, nc_def_grp, nc_def_dim
use, non_intrinsic :: nc4f_ds, only: buffer2cptr
implicit none (type, external)
contains

module subroutine rename_dim_model(passed)
  !! Verify pure dimension renaming, repeated axes, direct scope, and storage preservation.
  logical, intent(inout) :: passed
  !! Set true when all assertions pass.
  type(dimension_type) :: dim
  type(variable_type), target :: var, owner
  type(group_type) :: grp, children(1)
  type(netcdf_type) :: root
  type(error_type) :: err
  type(c_ptr) :: addr

  dim = "x".dim.2
  dim%id = 81
  dim%is_unlim = .true.
  call rename_dimension(dim, "record   ", err)
  call chk_dim(err%code == NC_NOERR .and. dim%name == "record", "standalone padded name")
  call chk_dim(dim%id == 81 .and. dim%len == 2 .and. dim%is_unlim, "dimension metadata retained")
  var = datarray("matrix", reshape([1., 2., 3., 4.], [2, 2]), ["x".dim.2, "x".dim.2])
  deallocate (var%dims)
  allocate (var%dims(-1:0))
  var%dims = ["x".dim.2, "x".dim.2]
  var%dims%id = 12
  addr = c_loc(var%buffer(1))
  call rename_dimension(var, "x", "axis", err)
  call chk_dim(err%code == NC_NOERR, "repeated axes with nondefault bounds")
  call chk_dim(var%dims(-1)%name == "axis" .and. var%dims(0)%name == "axis", "all repeated axes renamed")
  call chk_dim(all(var%dims%id == 12) .and. c_associated(addr, c_loc(var%buffer(1))), "IDs and payload retained")
  deallocate (var%dims)
  var%dims = ["axis".dim.2, "axis".dim.2]
  children(1) = dataset("child", vars=[var])
  grp = dataset("/", vars=[var, var], grps=children)
  call rename_dimension(grp, "axis", "shared", err)
  call chk_dim(err%code == NC_NOERR .and. grp%dims(1)%name == "shared", "group declaration renamed")
  call chk_dim(grp%vars(2)%dims(2)%name == "shared", "every direct variable updated")
  call chk_dim(grp%grps(1)%dims(1)%name == "axis", "descendant model cache unchanged")
  call chk_dim(var%dims(1)%name == "axis", "independent snapshot unchanged")
  root%vars = grp%vars
  call rename_dimension(root, "shared", "implicit", err)
  call chk_dim(err%code == NC_NOERR .and. .not. allocated(root%dims), "implicit definitions without materialization")
  call pure_dim_calls(dim, var, grp, err)
  call chk_dim(err%code == NC_NOERR .and. grp%vars(1)%dims(1)%name == "pure", "pure generic callers")
  call rename_dimension(root, dim, "context", err=err)
  call chk_dim(err%code == NC_NOERR .and. dim%name == "context", "object context defaults to model only")
  call rename_dimension(root, dim, "again", update_file=.false., err=err)
  call chk_dim(err%code == NC_NOERR, "false object context ignores invalid group ID")
  call rename_dimension(root, "implicit", "local", update_file=.false., err=err)
  call chk_dim(err%code == NC_NOERR, "false group context ignores invalid group ID")
  owner = var
  call initialize(var, "borrowed", owner, deep=.false.)
  call rename_dimension(var, "pure", "borrowed_axis", err)
  call chk_dim(err%code == NC_NOERR .and. associated(var%ptr, owner%buffer), "borrowed storage retained")
  passed = .true.
end subroutine rename_dim_model

pure subroutine pure_dim_calls(dim, var, grp, err)
  !! Compile-time check that all three model overloads remain pure.
  type(dimension_type), intent(inout) :: dim
  !! Standalone dimension to rename.
  type(variable_type), intent(inout) :: var
  !! Variable with repeated axis references.
  type(group_type), intent(inout) :: grp
  !! Group with shared direct dimension references.
  type(error_type), intent(out) :: err
  !! Receives the group rename status.

  call rename_dimension(dim, "pure")
  call rename_dimension(var, "axis", "pure")
  call rename_dimension(grp, "shared", "pure", err)
end subroutine pure_dim_calls

module subroutine rename_dim_file(passed)
  !! Verify persistence, coordinate variables, local ownership, and partial cache updates.
  logical, intent(inout) :: passed
  !! Set true when all assertions pass.
  character(*), parameter :: file = TEST_RESULTS_DIR//"rename-dimensions.nc"
  type(variable_type), target :: vars(3), var
  real, pointer :: values(:, :)
  type(group_type) :: source, children(1), child, shadow
  type(netcdf_type), target :: nc
  type(dimension_type) :: dim
  type(dimension_type), allocatable :: dims(:)
  type(error_type) :: err
  type(c_ptr) :: addr
  integer(c_int) :: stat, shadow_id, dimid
  integer :: i

  vars(1) = datarray("x", [1., 2.], ["x".dim.2])
  vars(2) = datarray("matrix", reshape([1., 2., 3., 4.], [2, 2]), ["x".dim.2, "x".dim.2])
  vars(3) = datarray("records", [3., 4.], ["time".dim.2])
  vars(3)%dims(1)%is_unlim = .true.
  children(1) = dataset("child", vars=[vars(1)])
  source = dataset("/", vars=vars, grps=children)
  call to_netcdf(file, source)
  nc = open_netcdf(file, "a")
  stat = nc_def_grp(nc%id, "shadow"//c_null_char, shadow_id)
  call chk_dim(stat == NC_NOERR, "create shadow fixture")
  stat = nc_def_dim(shadow_id, "x"//c_null_char, 3_int64, dimid)
  call chk_dim(stat == NC_NOERR, "define shadow dimension")
  call inquire_group(nc, recur=.true.)
  ! Inquired variable metadata has no payload; load one to verify its storage
  ! address.
  nc%vars(1) = get_variable(nc, nc%vars(1)%name)
  addr = buffer2cptr(nc%vars(1))
  nc%dims%id = -999
  call rename_dimension(nc, "x", "axis", update_file=.true., err=err)
  call chk_dim(err%code == NC_NOERR, "file rename with stale cached dimension IDs")
  call chk_dim(c_associated(addr, buffer2cptr(nc%vars(1))), "group file rename retains payload")
  call chk_dim(all(nc%dims%id == -999), "cached dimension IDs preserved")
  call chk_dim(nc%vars(1)%name == "x" .and. nc%vars(1)%dims(1)%name == "axis", "coordinate name unchanged")
  do i = 1, size(nc%grps)
    if (nc%grps(i)%name == "child") then
      call chk_dim(nc%grps(i)%vars(1)%dims(1)%name == "x", "loaded descendant left unchanged")
    end if
  end do
  child = get_group(nc, "child")
  call rename_dimension(child, "axis", "forbidden", update_file=.true., err=err)
  call chk_dim(err%code == NC_EBADDIM, "inherited dimension rejected")
  var = get_variable(child, "x")
  call chk_dim(var%dims(1)%name == "axis", "inherited file reference follows parent rename")
  shadow = get_group(nc, "shadow")
  dims = inquire_dimensions(shadow)
  call chk_dim(size(dims) == 1 .and. dims(1)%name == "x", "shadowed local dimension unchanged")
  call rename_dimension(shadow, "x", "local", update_file=.true., err=err)
  call chk_dim(err%code == NC_NOERR .and. .not. allocated(shadow%dims), "unloaded subgroup cache remains unloaded")

  deallocate (nc%dims)
  call rename_dimension(nc, "axis", "distance", update_file=.true., err=err)
  call chk_dim(err%code == NC_NOERR .and. .not. allocated(nc%dims), "partial cache no new definitions")
  call chk_dim(nc%vars(2)%dims(2)%name == "distance", "partial cache repeated references updated")
  dim = "time".dim.2
  dim%is_unlim = .true.
  dim%id = -999
  call rename_dimension(nc, dim, "record", update_file=.true., err=err)
  call chk_dim(err%code == NC_NOERR .and. dim%id == -999 .and. dim%is_unlim, "unlimited object rename")
  call chk_dim(nc%vars(3)%dims(1)%name == "time", "object overload changes only supplied object")
  call rename_dimension(nc, "distance", "distance", update_file=.true., err=err)
  call chk_dim(err%code == NC_NOERR, "file self-rename")
  call close_netcdf(nc)
  nc = open_netcdf(file, "r")
  var = get_variable(nc, "matrix")
  call chk_dim(var%dims(1)%name == "distance" .and. var%dims(2)%name == "distance", "repeated rename persists")
  call chk_dim(all(var%dims%len == 2), "shape preserved")
  call extract(var, values)
  call chk_dim(all(values == reshape([1., 2., 3., 4.], [2, 2])), "stored values preserved")
  var = get_variable(nc, "records")
  call chk_dim(var%dims(1)%name == "record" .and. var%dims(1)%is_unlim, "unlimited rename persists")
  child = get_group(nc, "child")
  var = get_variable(child, "x")
  call chk_dim(var%dims(1)%name == "distance", "inherited rename persists")
  call close_netcdf(nc)
  passed = .true.
end subroutine rename_dim_file

module subroutine rename_dim_errors(passed)
  !! Verify validation, atomic cache updates, file errors, and fail-fast behavior.
  logical, intent(inout) :: passed
  !! Set true when all assertions pass.
  character(*), parameter :: file = TEST_RESULTS_DIR//"rename-dimension-errors.nc"
  type(group_type) :: grp
  type(netcdf_type) :: nc
  type(variable_type) :: var
  type(dimension_type) :: dim
  type(error_type) :: err
  integer :: i, status, cmdstat, unit, iostat
  character(len=1024) :: executable, command, line
  logical :: found_diagnostic

  call rename_dimension(grp, "missing", "new", update_file=.true., err=err)
  call chk_dim(err%code == NC_EBADID, "invalid group returns error safely")
  call chk_dim(.not. allocated(grp%dims), "failed lookup preserves cache")
  call rename_dimension(dim, "bad/name", err)
  call chk_dim(err%code == NC_EBADNAME .and. .not. allocated(dim%name), "bad name unchanged")
  call rename_dimension(dim, "x"//char(0), err)
  call chk_dim(err%code == NC_EBADNAME, "embedded NUL rejected")
  call rename_dimension(dim, repeat("a", NC_MAX_NAME + 1), err)
  call chk_dim(err%code == NC_EMAXNAME, "long name rejected")
  call rename_dimension(var, "x", "y", err)
  call chk_dim(err%code == NC_EBADDIM .and. .not. allocated(var%dims), "absent dimensions")
  grp%dims = ["x".dim.2, "x".dim.2]
  call rename_dimension(grp, "x", "y", err)
  call chk_dim(err%code == NC_EINVAL .and. grp%dims(1)%name == "x", "duplicate definitions")
  var = datarray("v", [1., 2.], ["x".dim.2])
  grp = dataset("/", vars=[var])
  grp%vars(1)%dims(1)%len = 3
  call rename_dimension(grp, "x", "y", err)
  call chk_dim(err%code == NC_EINVAL .and. grp%dims(1)%name == "x", "conflicting length leaves declaration")
  call chk_dim(grp%vars(1)%dims(1)%name == "x", "conflicting length leaves reference")
  grp%vars(1)%dims(1)%len = 2
  grp%dims(1)%id = 1
  grp%vars(1)%dims(1)%id = 2
  call rename_dimension(grp, "x", "y", err)
  call chk_dim(err%code == NC_EINVAL, "same name with different known identities is ambiguous")
  grp%vars(1)%dims(1)%id = 1
  grp%vars(1)%dims(1)%is_unlim = .true.
  call rename_dimension(grp, "x", "y", err)
  call chk_dim(err%code == NC_EINVAL, "conflicting unlimited status")
  var%dims = ["x".dim.2, "y".dim.2]
  call rename_dimension(var, "x", "y", err)
  call chk_dim(err%code == NC_ENAMEINUSE .and. var%dims(1)%name == "x", "do not merge dimensions")
  grp = dataset("/", vars=[datarray("v", [1., 2.], ["x".dim.2])])
  grp%dims = ["x".dim.2, "other".dim.3]
  call to_netcdf(file, grp)
  nc = open_netcdf(file, "a")
  call inquire_group(nc)
  call rename_dimension(nc, "x", "other", update_file=.true., err=err)
  call chk_dim(err%code == NC_ENAMEINUSE .and. nc%vars(1)%dims(1)%name == "x", "file collision cache unchanged")
  deallocate (nc%dims)
  call rename_dimension(nc, "x", "other", update_file=.true., err=err)
  call chk_dim(err%code == NC_ENAMEINUSE .and. nc%vars(1)%dims(1)%name == "x", "uncached file collision")
  nc%vars(1)%dims = ["x".dim.2, "x".dim.3]
  call rename_dimension(nc, "x", "renamed", update_file=.true., err=err)
  call chk_dim(err%code == NC_EINVAL, "cache inconsistency caught before file mutation")
  var = get_variable(nc, "v")
  call chk_dim(var%dims(1)%name == "x", "cache rejection preserves file")
  call rename_dimension(nc, "missing", "new", update_file=.true., err=err)
  call chk_dim(err%code == NC_EBADDIM, "missing file target")
  call rename_dimension(nc, dim, "new", update_file=.true., err=err)
  call chk_dim(err%code == NC_EINVAL, "unnamed file target")
  call close_netcdf(nc)
  nc = open_netcdf(file, "r")
  nc%vars = [var]
  call rename_dimension(nc, "x", "new", update_file=.true., err=err)
  call chk_dim(err%code == NC_EPERM .and. nc%vars(1)%dims(1)%name == "x", "read-only cache unchanged")
  call rename_dimension(nc, "x", "x", update_file=.true., err=err)
  call chk_dim(err%code == NC_EPERM, "read-only self-rename still checks permissions")
  call close_netcdf(nc)
  call rename_dimension(nc, "x", "new", update_file=.true., err=err)
  call chk_dim(err%code == NC_EBADID, "closed handle")
  call get_command_argument(0, executable)
  do i = 1, 2
    if (i == 1) then
      command = '"'//trim(executable)//'" --rename-dim-invalid-model'
    else
      command = '"'//trim(executable)//'" --rename-dim-invalid-file'
    end if
    call execute_command_line(trim(command)//" > "//TEST_RESULTS_DIR// "rename-dim-failfast.log 2>&1", &
      & exitstat=status, cmdstat=cmdstat)
    call chk_dim(cmdstat == 0 .and. status == 1, &
      & "missing err must ERROR STOP, not crash")
    open (newunit=unit, file=TEST_RESULTS_DIR//"rename-dim-failfast.log", &
      & status="old", iostat=iostat)
    call chk_dim(iostat == 0, "read child diagnostic")
    found_diagnostic = .false.
    do
      read (unit, '(a)', iostat=iostat) line
      if (iostat /= 0) exit
      if (i == 1) then
        if (index(line, "ERROR STOP [rename_dimension]") > 0) &
          & found_diagnostic = .true.
      else
        if (index(line, "ERROR STOP [inq_dims] Dimension count.") > 0) &
          & found_diagnostic = .true.
      end if
    end do
    close (unit)
    call chk_dim(found_diagnostic, "expected dimension failure diagnostic")
  end do
  passed = .true.
end subroutine rename_dim_errors

pure subroutine chk_dim(condition, message)
  !! Terminate on a failed dimension-renaming assertion.
  logical, intent(in) :: condition
  !! Assertion required to pass.
  character(len=*), intent(in) :: message
  !! Diagnostic identifying the failed check.

  if (.not. condition) error stop "[rename dimension test] "//message
end subroutine chk_dim

end submodule nc4f_test_cases_rename_dimension
