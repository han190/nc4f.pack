submodule(nc4f_test_cases) nc4f_test_cases_group
implicit none (type, external)
contains

!> Exercise recursive group construction and ncdump-like formatted output.
module subroutine group_model(passed)
  logical, intent(inout) :: passed
  character(len=256) :: line
  integer :: child_at, dims_at, file_unit, groups_at, iostat, line_number, &
    & root_at, vars_at, atts_at
  type(group_type) :: child, container, root
  type(variable_type) :: child_var, root_var
  real :: child_values(3), root_values(2)

  root_values = [1.0, 2.0]
  child_values = [3.0, 4.0, 5.0]
  root_var = data_array("root_data", root_values, ["root_x".dim.2])
  child_var = data_array("child_data", child_values, ["child_x".dim.3])
  child = data_set("child", arrays=[child_var], atts=["title".att."child group"])
  container = data_set("container", grps=[child])
  root = data_set("/", arrays=[root_var], atts=["title".att."root group"], grps=[child])

  root_at = 0
  dims_at = 0
  vars_at = 0
  atts_at = 0
  groups_at = 0
  child_at = 0
  open (newunit=file_unit, file=TEST_RESULTS_DIR//"group_model.txt", &
    & status="replace", action="write", iostat=iostat)
  if (iostat == 0) then
    write (file_unit, "(dt)", iostat=iostat) root
    close (file_unit, iostat=iostat)
  end if
  if (iostat == 0) then
    open (newunit=file_unit, file=TEST_RESULTS_DIR//"group_model.txt", &
      & status="old", action="read", iostat=iostat)
  end if
  if (iostat == 0) then
    line_number = 0
    do
      read (file_unit, "(a)", iostat=iostat) line
      if (iostat /= 0) exit
      line_number = line_number + 1
      if (index(line, "group: / {") > 0 .and. root_at == 0) root_at = line_number
      if (index(line, "dimensions:") > 0 .and. dims_at == 0) dims_at = line_number
      if (index(line, "variables:") > 0 .and. vars_at == 0) vars_at = line_number
      if (index(line, "// global attributes:") > 0 .and. atts_at == 0) atts_at = line_number
      if (index(line, "groups:") > 0 .and. groups_at == 0) groups_at = line_number
      if (index(line, "  group: child {") > 0) child_at = line_number
    end do
    close (file_unit)
  end if

  passed = root%name == "/" .and. &
    & size(root%dims) == 1 .and. root%dims(1)%name == "root_x" .and. &
    & size(root%vars) == 1 .and. size(root%atts) == 1 .and. &
    & size(root%grps) == 1 .and. root%grps(1)%name == "child" .and. &
    & size(root%grps(1)%dims) == 1 .and. &
    & root%grps(1)%dims(1)%name == "child_x" .and. &
    & container%name == "container" .and. .not. allocated(container%dims) .and. &
    & .not. allocated(container%vars) .and. size(container%grps) == 1 .and. &
    & container%grps(1)%name == "child" .and. &
    & root_at > 0 .and. root_at < dims_at .and. dims_at < vars_at .and. &
    & vars_at < atts_at .and. atts_at < groups_at .and. groups_at < child_at
end subroutine group_model

!> Write recursive group descriptions through both group serialization APIs.
module subroutine group_write(passed)
  logical, intent(inout) :: passed
  real, pointer :: child_values(:), root_values(:)
  type(attribute_type) :: root_att
  type(error_type) :: error
  type(group_type) :: child, child_on_disk, invalid, parent, parent_on_disk, &
    & root, root_on_disk, sibling
  type(group_type), allocatable :: top_level(:)
  type(netcdf_type) :: nc
  type(variable_type) :: child_data, child_var, root_data, root_var, sibling_var

  passed = .false.
  root_var = data_array("root_data", [1.0, 2.0], ["root_x".dim.2])
  child_var = data_array("child_data", [3.0, 4.0, 5.0], ["child_x".dim.3])
  sibling_var = data_array("sibling_data", [6.0], ["sibling_x".dim.1])
  child = data_set("child", arrays=[child_var], atts=["title".att."child"])
  parent = data_set("parent", grps=[child])
  sibling = data_set("sibling", arrays=[sibling_var])
  root = data_set("input-root-name-is-ignored", arrays=[root_var], &
    & atts=["title".att."root"], grps=[parent])

  call to_netcdf_grp(TEST_RESULTS_DIR//"group-root.nc", root, &
    & atts=["writer".att."group_write"], error=error)
  if (failed(error)) return
  nc = open_dataset(TEST_RESULTS_DIR//"group-root.nc", "r", error=error)
  if (failed(error)) return
  root_on_disk = inquire_group(nc, inq_dims=.true., inq_atts=.true., &
    & inq_vars=.true., inq_grps=.true., recursive=.true., error=error)
  if (failed(error)) then
    call close_dataset(nc)
    return
  end if
  parent_on_disk = get_group(nc, "parent", error)
  if (failed(error)) then
    call close_dataset(nc)
    return
  end if
  child_on_disk = get_group(parent_on_disk, "child", error)
  if (failed(error)) then
    call close_dataset(nc)
    return
  end if
  root_data = get_variable(nc, "root_data", error)
  if (failed(error)) then
    call close_dataset(nc)
    return
  end if
  call extract(root_data, root_values)
  child_data = get_variable(child_on_disk, "child_data", error)
  if (failed(error)) then
    call close_dataset(nc)
    return
  end if
  call extract(child_data, child_values)
  call close_dataset(nc, error)
  if (failed(error)) then
    return
  end if
  if (.not. (root_on_disk%name == "/" .and. size(root_on_disk%vars) == 1 .and. &
    & size(root_on_disk%atts) == 2 .and. size(root_on_disk%grps) == 1 .and. &
    & root_on_disk%grps(1)%name == "parent" .and. &
    & size(root_on_disk%grps(1)%grps) == 1 .and. &
    & root_on_disk%grps(1)%grps(1)%name == "child" .and. &
    & all(abs(root_values - [1.0, 2.0]) <= epsilon(1.0)) .and. &
    & all(abs(child_values - [3.0, 4.0, 5.0]) <= epsilon(1.0)))) then
    return
  end if

  call to_netcdf_grps(TEST_RESULTS_DIR//"group-children.nc", [parent, sibling], &
    & atts=["title".att."group collection"], error=error)
  if (failed(error)) return
  nc = open_dataset(TEST_RESULTS_DIR//"group-children.nc", "r", error=error)
  if (failed(error)) return
  top_level = inquire_groups(nc, error)
  if (failed(error)) return
  root_att = get_attribute(nc, "title", error)
  if (failed(error)) then
    call close_dataset(nc)
    return
  end if
  if (.not. (root_att%name == "title" .and. size(top_level) == 2 .and. &
    & top_level(1)%name == "parent" .and. top_level(2)%name == "sibling")) then
    call close_dataset(nc)
    return
  end if
  parent_on_disk = inquire_group(top_level(1), inq_grps=.true., recursive=.true., &
    & error=error)
  if (failed(error)) then
    call close_dataset(nc)
    return
  end if
  call close_dataset(nc, error)
  if (failed(error)) return
  if (.not. (size(parent_on_disk%grps) == 1 .and. &
    & parent_on_disk%grps(1)%name == "child")) return

  invalid = data_set("/")
  call to_netcdf_grps(TEST_RESULTS_DIR//"invalid-root-child.nc", [invalid], error=error)
  passed = failed(error) .and. error%code == NC_EINVAL
end subroutine group_write

end submodule nc4f_test_cases_group
