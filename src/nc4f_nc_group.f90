submodule(nc4f_nc) nc4f_nc_group
implicit none (type, external)
contains

module function get_group(parent, name, err) result(group)
  !! Return a direct child group by name.
  class(group_type), intent(in) :: parent
  !! Data or metadata used by this operation.
  character(len=*), intent(in) :: name
  !! Name used to identify the NetCDF object.
  type(error_type), intent(out), optional :: err
  !! Error object updated if the operation fails.
  type(group_type) :: group
  !! Result produced by this operation.
  type(error_type) :: op_err

  group = get_grp_(parent, name, op_err)
  if (present(err)) then
    err = op_err
  else if (handle_err(op_err)) then
    return
  end if
end function get_group

module function inquire_subgroups(parent, err) result(grps)
  !! Return direct child groups with IDs and names populated.
  class(group_type), intent(in) :: parent
  !! Data or metadata used by this operation.
  type(error_type), intent(out), optional :: err
  !! Error object updated if the operation fails.
  type(group_type), allocatable :: grps(:)
  !! Result produced by this operation.
  type(error_type) :: op_err

  grps = inq_grps_(parent, op_err)
  if (present(err)) then
    err = op_err
  else if (handle_err(op_err)) then
    return
  end if
end function inquire_subgroups

recursive module subroutine inquire_group(group, &
  & inq_dims, inq_atts, inq_vars, inq_grps, recur, err)
  !! Materialize selected metadata for a group.
  class(group_type), intent(inout) :: group
  !! Dataset group to process.
  logical, intent(in), optional :: inq_dims, inq_atts, inq_vars, inq_grps
  !! Data or metadata used by this operation.
  logical, intent(in), optional :: recur
  !! Data or metadata used by this operation.
  type(error_type), intent(out), optional :: err
  !! Error object updated if the operation fails.
  type(error_type) :: op_err
  type(group_type), allocatable :: children(:)
  integer :: i
  logical :: inqd, inqa, inqv, inqg, recu

  inqd = requested(.true., inq_dims)
  inqa = requested(.true., inq_atts)
  inqv = requested(.true., inq_vars)
  recu = requested(.false., recur)
  inqg = requested(.true., inq_grps) .or. recu

  op_err = error_type()

  if (inqd) then
    group%dims = inq_dims_grp(group, err=op_err)
  end if
  if (.not. has_err(op_err) .and. inqa) then
    group%atts = get_atts_grp(group, err=op_err)
  end if
  if (.not. has_err(op_err) .and. inqv) then
    group%vars = inq_vars_(group, op_err)
  end if
  if (.not. has_err(op_err) .and. inqg) then
    children = inq_grps_(group, op_err)
    if (.not. has_err(op_err)) then
      if (associated(group%grps)) deallocate (group%grps)
      allocate (group%grps(size(children)))
      group%grps = children
    end if
    if (.not. has_err(op_err) .and. recu) then
      do i = 1, size(group%grps)
        call inquire_group(group%grps(i), inq_dims=inqd, &
          & inq_atts=inqa, inq_vars=inqv, &
          & inq_grps=.true., recur=.true., err=op_err)
        if (has_err(op_err)) exit
      end do
    end if
  end if

  if (present(err)) then
    err = op_err
  else if (handle_err(op_err)) then
    return
  end if
end subroutine inquire_group

module subroutine serialize_grp(root, grp, atts, err)
  !! Serialize one group as an existing file root.
  class(group_type), intent(in) :: root
  !! Data or metadata used by this operation.
  type(group_type), intent(in) :: grp
  !! Data or metadata used by this operation.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Attributes to process or attach.
  type(error_type), intent(out) :: err
  !! Error object updated if the operation fails.

  call define_grp_tree_(root, grp, err)
  if (has_err(err)) return
  if (present(atts)) then
    call write_grp_atts_(root, atts, err)
    if (has_err(err)) return
  end if
  call write_grp_tree_data_(root, grp, err)
end subroutine serialize_grp

module subroutine serialize_grps(root, grps, atts, err)
  !! Serialize groups as direct children of an existing file root.
  class(group_type), intent(in) :: root
  !! Data or metadata used by this operation.
  type(group_type), target, intent(in) :: grps(:)
  !! Data or metadata used by this operation.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Attributes to process or attach.
  type(error_type), intent(out) :: err
  !! Error object updated if the operation fails.
  type(group_type) :: child
  type(group_type), pointer :: source_child
  character(len=NC_MAX_NAME) :: child_name
  integer :: i

  err = error_type()
  do i = 1, size(grps)
    source_child => grps(i)
    if (.not. allocated(source_child%name)) then
      err = error_type(NC_EINVAL, "[to_netcdf_grps] Each group must have a name.")
      return
    end if
    if (trim(source_child%name) == "/") then
      err = error_type(NC_EINVAL, &
        & "[to_netcdf_grps] A first-level group cannot be named '/'.")
      return
    end if
  end do

  if (present(atts)) then
    call write_grp_atts_(root, atts, err)
    if (has_err(err)) return
  end if
  do i = 1, size(grps)
    source_child => grps(i)
    child_name = source_child%name
    child = def_grp_(root, child_name, err)
    if (has_err(err)) return
    call define_grp_tree_(child, source_child, err)
    if (has_err(err)) return
  end do
  do i = 1, size(grps)
    source_child => grps(i)
    child_name = source_child%name
    child = get_grp_(root, child_name, err)
    if (has_err(err)) return
    call write_grp_tree_data_(child, source_child, err)
    if (has_err(err)) return
  end do
end subroutine serialize_grps

recursive subroutine define_grp_tree_(target, source, err)
  !! Define all metadata in a group tree before any data are transferred.
  class(group_type), intent(in) :: target
  !! Target object or group to update.
  type(group_type), target, intent(in) :: source
  !! Source object or group to read from.
  type(error_type), intent(out) :: err
  !! Error object updated if the operation fails.
  type(dimension_type) :: defined_dim
  type(group_type) :: child
  type(group_type), pointer :: source_child
  type(variable_type) :: defined_var
  character(len=NC_MAX_NAME) :: child_name
  integer :: i

  err = error_type()
  if (allocated(source%dims)) then
    do i = 1, size(source%dims)
      defined_dim = def_dim(target, source%dims(i), err)
      if (has_err(err)) return
    end do
  end if
  if (allocated(source%atts)) then
    call write_grp_atts_(target, source%atts, err)
    if (has_err(err)) return
  end if
  if (allocated(source%vars)) then
    do i = 1, size(source%vars)
      if (.not. allocated(source%vars(i)%name)) then
        err = error_type(NC_EINVAL, "[to_netcdf] Each variable must have a name.")
        return
      end if
      defined_var = def_var(target, source%vars(i), err)
      if (has_err(err)) return
      call put_att_var(target, defined_var, err)
      if (has_err(err)) return
    end do
  end if
  if (associated(source%grps)) then
    do i = 1, size(source%grps)
      source_child => source%grps(i)
      if (.not. allocated(source_child%name)) then
        err = error_type(NC_EINVAL, "[to_netcdf] Each child group must have a name.")
        return
      end if
      child_name = source_child%name
      child = def_grp_(target, child_name, err)
      if (has_err(err)) return
      call define_grp_tree_(child, source_child, err)
      if (has_err(err)) return
    end do
  end if
end subroutine define_grp_tree_

subroutine write_grp_atts_(target, atts, err)
  !! Write group attributes without changing the in-memory group model.
  class(group_type), intent(in) :: target
  !! Target object or group to update.
  type(attribute_type), intent(in) :: atts(:)
  !! Attributes to process or attach.
  type(error_type), intent(out) :: err
  !! Error object updated if the operation fails.
  type(group_type) :: metadata

  metadata%id = target%id
  metadata%atts = atts
  call put_att_grp(metadata, err)
end subroutine write_grp_atts_

recursive subroutine write_grp_tree_data_(target, source, err)
  !! Write all data buffers after the complete group tree has been defined.
  class(group_type), intent(in) :: target
  !! Target object or group to update.
  type(group_type), target, intent(in) :: source
  !! Source object or group to read from.
  type(error_type), intent(out) :: err
  !! Error object updated if the operation fails.
  type(group_type) :: child
  type(group_type), pointer :: source_child
  integer, allocatable :: start(:), count(:)
  character(len=NC_MAX_NAME) :: child_name
  integer :: i, j, ndims

  err = error_type()
  if (allocated(source%vars)) then
    do i = 1, size(source%vars)
      if (source%vars(i)%len <= 0) cycle
      ndims = 0
      if (allocated(source%vars(i)%dims)) ndims = size(source%vars(i)%dims)
      allocate (start(ndims), count(ndims))
      start = 1
      do j = 1, ndims
        count(j) = int(source%vars(i)%dims(j)%len)
      end do
      call put_vara(target, source%vars(i), start, count, err)
      if (has_err(err)) return
      deallocate (start, count)
    end do
  end if
  if (associated(source%grps)) then
    do i = 1, size(source%grps)
      source_child => source%grps(i)
      child_name = source_child%name
      child = get_grp_(target, child_name, err)
      if (has_err(err)) return
      call write_grp_tree_data_(child, source_child, err)
      if (has_err(err)) return
    end do
  end if
end subroutine write_grp_tree_data_

function def_grp_(parent, name, err) result(group)
  !! Define a direct child group while retaining NetCDF's status result.
  class(group_type), intent(in) :: parent
  !! Data or metadata used by this operation.
  character(len=*), intent(in) :: name
  !! Name used to identify the NetCDF object.
  type(error_type), intent(out) :: err
  !! Error object updated if the operation fails.
  type(group_type) :: group
  !! Result produced by this operation.
  integer(c_int) :: stat

  group%name = clip(name)
  stat = nc_def_grp(parent%id, f2cstr(group%name), group%id)
  err = netcdf_err(stat, "[def_grp] "//group%name)
end function def_grp_

function get_grp_(parent, name, err) result(group)
  !! Get a direct child group while retaining NetCDF's status result.
  class(group_type), intent(in) :: parent
  !! Data or metadata used by this operation.
  character(len=*), intent(in) :: name
  !! Name used to identify the NetCDF object.
  type(error_type), intent(out) :: err
  !! Error object updated if the operation fails.
  type(group_type) :: group
  !! Result produced by this operation.
  integer(c_int) :: stat

  group%name = clip(name)
  stat = nc_inq_ncid(parent%id, f2cstr(group%name), group%id)
  err = netcdf_err(stat, "[get_grp] "//group%name)
end function get_grp_

function inq_grps_(parent, err) result(grps)
  !! Return direct child group handles with their IDs and local names.
  class(group_type), intent(in) :: parent
  !! Data or metadata used by this operation.
  type(error_type), intent(out) :: err
  !! Error object updated if the operation fails.
  type(group_type), allocatable :: grps(:)
  !! Result produced by this operation.
  integer(c_int), allocatable, target :: ids(:)
  character(kind=c_char, len=NC_MAX_NAME + 1) :: name
  integer(c_int) :: i, ngroups, stat

  err = error_type()
  stat = nc_inq_grps(parent%id, ngroups, c_null_ptr)
  err = netcdf_err(stat, "[inq_grps] Group count.")
  if (has_err(err)) return
  allocate (grps(ngroups), ids(ngroups))
  if (ngroups == 0) return

  stat = nc_inq_grps(parent%id, ngroups, c_loc(ids(1)))
  err = netcdf_err(stat, "[inq_grps] Group identifiers.")
  if (has_err(err)) return
  do i = 1, ngroups
    name = c_null_char
    stat = nc_inq_grpname(ids(i), name)
    err = netcdf_err(stat, "[inq_grps] Group name.")
    if (has_err(err)) return
    grps(i)%id = ids(i)
    grps(i)%name = clip(c2fstr(name))
  end do
end function inq_grps_

function inq_vars_(group, err) result(vars)
  !! Return local variables declared by a group.
  class(group_type), intent(in) :: group
  !! Data or metadata used by this operation.
  type(error_type), intent(out) :: err
  !! Error object updated if the operation fails.
  type(variable_type), allocatable :: vars(:)
  !! Retrieved variables.
  integer(c_int), allocatable, target :: ids(:)
  character(kind=c_char, len=NC_MAX_NAME + 1) :: name
  integer(c_int) :: i, nvars, stat

  err = error_type()
  stat = nc_inq_varids(group%id, nvars, c_null_ptr)
  err = netcdf_err(stat, "[inq_grp] Variable count.")
  if (has_err(err)) return
  allocate (vars(nvars), ids(nvars))
  if (nvars == 0) return

  stat = nc_inq_varids(group%id, nvars, c_loc(ids(1)))
  err = netcdf_err(stat, "[inq_grp] Variable identifiers.")
  if (has_err(err)) return
  do i = 1, nvars
    name = c_null_char
    stat = nc_inq_varname(group%id, ids(i), name)
    err = netcdf_err(stat, "[inq_grp] Variable name.")
    if (has_err(err)) return
    vars(i) = inquire_variable(group, c2fstr(name), err)
    if (has_err(err)) return
  end do
end function inq_vars_

logical elemental function requested(default, flag)
  !! Return the value of an optional logical inquiry flag.
  logical, intent(in) :: default
  !! Data or metadata used by this operation.
  logical, intent(in), optional :: flag
  !! Data or metadata used by this operation.

  requested = default
  if (present(flag)) requested = flag
end function requested

end submodule nc4f_nc_group
