submodule(nc4f_nc) nc4f_nc_grp
implicit none (type, external)
contains

!> Return a direct child group by name.
module function get_grp(parent, name, err) result(group)
  !> Input argument: `parent`.
  class(group_type), intent(in) :: parent
  !> Input argument: `name`.
  character(len=*), intent(in) :: name
  !> Output argument: `err`.
  type(error_type), intent(out), optional :: err
  !> Return value: `group`.
  type(group_type) :: group
  type(error_type) :: op_err

  group = get_grp_(parent, name, op_err)
  if (present(err)) then
    err = op_err
  else if (handle_err(op_err)) then
    return
  end if
end function get_grp

!> Return direct child groups with IDs and names populated.
module function inq_subgrps(parent, err) result(grps)
  !> Input argument: `parent`.
  class(group_type), intent(in) :: parent
  !> Output argument: `err`.
  type(error_type), intent(out), optional :: err
  !> Return value: `grps`.
  type(group_type), allocatable :: grps(:)
  type(error_type) :: op_err

  grps = inq_grps_(parent, op_err)
  if (present(err)) then
    err = op_err
  else if (handle_err(op_err)) then
    return
  end if
end function inq_subgrps

!> Materialize selected metadata for a group.
module recursive subroutine inq_grp(group, inq_dims, inq_atts, inq_vars, &
  & inq_subgrps, recursive, err)
  class(group_type), intent(inout) :: group
  logical, intent(in), optional :: inq_dims, inq_atts, inq_vars, inq_subgrps
  logical, intent(in), optional :: recursive
  type(error_type), intent(out), optional :: err
  type(error_type) :: op_err
  type(group_type), allocatable :: children(:)
  integer :: i
  logical :: inqd, inqa, inqv, inqg, recu

  inqd = requested(.true., inq_dims)
  inqa = requested(.true., inq_atts)
  inqv = requested(.true., inq_vars)
  recu = requested(.false., recursive)
  inqg = requested(.true., inq_subgrps) .or. recu

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
        call inq_grp(group%grps(i), inq_dims=inqd, &
          & inq_atts=inqa, inq_vars=inqv, &
          & inq_subgrps=.true., recursive=.true., err=op_err)
        if (has_err(op_err)) exit
      end do
    end if
  end if

  if (present(err)) then
    err = op_err
  else if (handle_err(op_err)) then
    return
  end if
end subroutine inq_grp

!> Serialize one group as an existing file root.
module subroutine serialize_grp_(root, grp, atts, err)
  !> Input argument: `root`.
  class(group_type), intent(in) :: root
  !> Input argument: `grp`.
  type(group_type), intent(in) :: grp
  !> Input argument: `atts`.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Output argument: `err`.
  type(error_type), intent(out) :: err

  call define_grp_tree_(root, grp, err)
  if (has_err(err)) return
  if (present(atts)) then
    call write_grp_atts_(root, atts, err)
    if (has_err(err)) return
  end if
  call write_grp_tree_data_(root, grp, err)
end subroutine serialize_grp_

!> Serialize groups as direct children of an existing file root.
module subroutine serialize_grps_(root, grps, atts, err)
  !> Input argument: `root`.
  class(group_type), intent(in) :: root
  !> Input argument: `grps`.
  type(group_type), target, intent(in) :: grps(:)
  !> Input argument: `atts`.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Output argument: `err`.
  type(error_type), intent(out) :: err
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
end subroutine serialize_grps_

!> Define all metadata in a group tree before any data are transferred.
recursive subroutine define_grp_tree_(target, source, err)
  !> Input argument: `target`.
  class(group_type), intent(in) :: target
  !> Input argument: `source`.
  type(group_type), target, intent(in) :: source
  !> Output argument: `err`.
  type(error_type), intent(out) :: err
  type(dimension_type) :: defined_dim
  type(group_type) :: child
  type(group_type), pointer :: source_child
  type(variable_type) :: defined_var
  character(len=NC_MAX_NAME) :: child_name
  integer :: i

  err = error_type()
  if (allocated(source%dims)) then
    do i = 1, size(source%dims)
      defined_dim = def_dim_err(target, source%dims(i), err)
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
      defined_var = def_var_(target, source%vars(i), err)
      if (has_err(err)) return
      call put_att_var_err(target, defined_var, err)
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

!> Write group attributes without changing the in-memory group model.
subroutine write_grp_atts_(target, atts, err)
  !> Input argument: `target`.
  class(group_type), intent(in) :: target
  !> Input argument: `atts`.
  type(attribute_type), intent(in) :: atts(:)
  !> Output argument: `err`.
  type(error_type), intent(out) :: err
  type(group_type) :: metadata

  metadata%id = target%id
  metadata%atts = atts
  call put_att_grp_err(metadata, err)
end subroutine write_grp_atts_

!> Write all data buffers after the complete group tree has been defined.
recursive subroutine write_grp_tree_data_(target, source, err)
  !> Input argument: `target`.
  class(group_type), intent(in) :: target
  !> Input argument: `source`.
  type(group_type), target, intent(in) :: source
  !> Output argument: `err`.
  type(error_type), intent(out) :: err
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
      call put_variable(target, source%vars(i), start, count, err=err)
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

!> Define a direct child group while retaining NetCDF's status result.
function def_grp_(parent, name, err) result(group)
  !> Input argument: `parent`.
  class(group_type), intent(in) :: parent
  !> Input argument: `name`.
  character(len=*), intent(in) :: name
  !> Output argument: `err`.
  type(error_type), intent(out) :: err
  !> Return value: `group`.
  type(group_type) :: group
  integer(c_int) :: stat

  group%name = clip(name)
  stat = nc_def_grp(parent%id, f2cstr(group%name), group%id)
  err = netcdf_err(stat, "[def_grp] "//group%name)
end function def_grp_

!> Get a direct child group while retaining NetCDF's status result.
function get_grp_(parent, name, err) result(group)
  !> Input argument: `parent`.
  class(group_type), intent(in) :: parent
  !> Input argument: `name`.
  character(len=*), intent(in) :: name
  !> Output argument: `err`.
  type(error_type), intent(out) :: err
  !> Return value: `group`.
  type(group_type) :: group
  integer(c_int) :: stat

  group%name = clip(name)
  stat = nc_inq_ncid(parent%id, f2cstr(group%name), group%id)
  err = netcdf_err(stat, "[get_grp] "//group%name)
end function get_grp_

!> Return direct child group handles with their IDs and local names.
function inq_grps_(parent, err) result(grps)
  !> Input argument: `parent`.
  class(group_type), intent(in) :: parent
  !> Output argument: `err`.
  type(error_type), intent(out) :: err
  !> Return value: `grps`.
  type(group_type), allocatable :: grps(:)
  integer(c_int), allocatable, target :: ids(:)
  character(kind=c_char, len=NC_MAX_NAME + 1) :: name
  integer(c_int) :: i, ngroups, stat

  err = error_type()
  stat = nc_inq_grps(parent%id, ngroups, c_null_ptr)
  err = netcdf_err(stat, "[inq_subgrps] Group count.")
  if (has_err(err)) return
  allocate (grps(ngroups), ids(ngroups))
  if (ngroups == 0) return

  stat = nc_inq_grps(parent%id, ngroups, c_loc(ids(1)))
  err = netcdf_err(stat, "[inq_subgrps] Group identifiers.")
  if (has_err(err)) return
  do i = 1, ngroups
    name = c_null_char
    stat = nc_inq_grpname(ids(i), name)
    err = netcdf_err(stat, "[inq_subgrps] Group name.")
    if (has_err(err)) return
    grps(i)%id = ids(i)
    grps(i)%name = clip(c2fstr(name))
  end do
end function inq_grps_

!> Return local variables declared by a group.
function inq_vars_(group, err) result(vars)
  !> Input argument: `group`.
  class(group_type), intent(in) :: group
  !> Output argument: `err`.
  type(error_type), intent(out) :: err
  !> Return value: `vars`.
  type(variable_type), allocatable :: vars(:)
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
    vars(i) = inq_var_err(group, c2fstr(name), err)
    if (has_err(err)) return
  end do
end function inq_vars_

!> Return the value of an optional logical inquiry flag.
pure logical function requested(default, flag)
  !> Input argument: `default`.
  logical, intent(in) :: default
  !> Input argument: `flag`.
  logical, intent(in), optional :: flag

  requested = default
  if (present(flag)) requested = flag
end function requested

end submodule nc4f_nc_grp
