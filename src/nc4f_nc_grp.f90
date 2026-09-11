submodule(nc4f_nc) nc4f_nc_grp
implicit none (type, external)
contains

!> Return a direct child group by name.
module function get_grp(parent, name, error) result(group)
  class(group_type), intent(in) :: parent
  character(len=*), intent(in) :: name
  type(error_type), intent(out), optional :: error
  type(group_type) :: group
  type(error_type) :: operation_error

  group = get_grp_(parent, name, operation_error)
  if (present(error)) then
    error = operation_error
  else if (handle_error(operation_error)) then
    return
  end if
end function get_grp

!> Return direct child groups with IDs and names populated.
module function inq_grps(parent, error) result(grps)
  class(group_type), intent(in) :: parent
  type(error_type), intent(out), optional :: error
  type(group_type), allocatable :: grps(:)
  type(error_type) :: operation_error

  grps = inq_grps_(parent, operation_error)
  if (present(error)) then
    error = operation_error
  else if (handle_error(operation_error)) then
    return
  end if
end function inq_grps

!> Materialize selected metadata for a group.
module function inq_grp(group, inq_dims, inq_atts, inq_vars, &
  & inq_grps, recursive, error) result(description)
  class(group_type), intent(in) :: group
  logical, intent(in), optional :: inq_dims, inq_atts, inq_vars, inq_grps
  logical, intent(in), optional :: recursive
  type(error_type), intent(out), optional :: error
  type(group_type) :: description
  type(error_type) :: operation_error
  logical :: want_dims, want_atts, want_vars, want_groups, descend

  want_dims = requested(inq_dims)
  want_atts = requested(inq_atts)
  want_vars = requested(inq_vars)
  descend = requested(recursive)
  want_groups = requested(inq_grps) .or. descend

  description%id = group%id
  if (allocated(group%name)) description%name = group%name
  operation_error = error_type()

  if (want_dims) then
    description%dims = inq_dims_grp(group, error=operation_error)
  end if
  if (.not. failed(operation_error) .and. want_atts) then
    description%atts = get_atts_grp(group, error=operation_error)
  end if
  if (.not. failed(operation_error) .and. want_vars) then
    description%vars = inq_vars_(group, operation_error)
  end if
  if (.not. failed(operation_error) .and. want_groups) then
    description%grps = inq_grps_(group, operation_error)
    if (.not. failed(operation_error) .and. descend) then
      call materialize_children(description%grps, want_dims, want_atts, want_vars, operation_error)
    end if
  end if

  if (present(error)) then
    error = operation_error
  else if (handle_error(operation_error)) then
    return
  end if
end function inq_grp

!> Serialize one group as an existing file root.
module subroutine serialize_grp_(root, grp, atts, error)
  class(group_type), intent(in) :: root
  type(group_type), intent(in) :: grp
  type(attribute_type), intent(in), optional :: atts(:)
  type(error_type), intent(out) :: error

  call define_grp_tree_(root, grp, error)
  if (failed(error)) return
  if (present(atts)) then
    call write_grp_atts_(root, atts, error)
    if (failed(error)) return
  end if
  call write_grp_tree_data_(root, grp, error)
end subroutine serialize_grp_

!> Serialize groups as direct children of an existing file root.
module subroutine serialize_grps_(root, grps, atts, error)
  class(group_type), intent(in) :: root
  type(group_type), target, intent(in) :: grps(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(error_type), intent(out) :: error
  type(group_type) :: child
  type(group_type), pointer :: source_child
  character(len=NC_MAX_NAME) :: child_name
  integer :: i

  error = error_type()
  do i = 1, size(grps)
    source_child => grps(i)
    if (.not. allocated(source_child%name)) then
      error = error_type(NC_EINVAL, "[to_netcdf_grps] Each group must have a name.")
      return
    end if
    if (trim(source_child%name) == "/") then
      error = error_type(NC_EINVAL, &
        & "[to_netcdf_grps] A first-level group cannot be named '/'.")
      return
    end if
  end do

  if (present(atts)) then
    call write_grp_atts_(root, atts, error)
    if (failed(error)) return
  end if
  do i = 1, size(grps)
    source_child => grps(i)
    child_name = source_child%name
    child = def_grp_(root, child_name, error)
    if (failed(error)) return
    call define_grp_tree_(child, source_child, error)
    if (failed(error)) return
  end do
  do i = 1, size(grps)
    source_child => grps(i)
    child_name = source_child%name
    child = get_grp_(root, child_name, error)
    if (failed(error)) return
    call write_grp_tree_data_(child, source_child, error)
    if (failed(error)) return
  end do
end subroutine serialize_grps_

!> Define all metadata in a group tree before any data are transferred.
recursive subroutine define_grp_tree_(target, source, error)
  class(group_type), intent(in) :: target
  type(group_type), target, intent(in) :: source
  type(error_type), intent(out) :: error
  type(dimension_type) :: defined_dim
  type(group_type) :: child
  type(group_type), pointer :: source_child
  type(variable_type) :: defined_var
  character(len=NC_MAX_NAME) :: child_name
  integer :: i

  error = error_type()
  if (allocated(source%dims)) then
    do i = 1, size(source%dims)
      defined_dim = def_dim_error(target, source%dims(i), error)
      if (failed(error)) return
    end do
  end if
  if (allocated(source%atts)) then
    call write_grp_atts_(target, source%atts, error)
    if (failed(error)) return
  end if
  if (allocated(source%vars)) then
    do i = 1, size(source%vars)
      if (.not. allocated(source%vars(i)%name)) then
        error = error_type(NC_EINVAL, "[to_netcdf] Each variable must have a name.")
        return
      end if
      defined_var = def_var_(target, source%vars(i), error)
      if (failed(error)) return
      call put_att_var_error(target, defined_var, error)
      if (failed(error)) return
    end do
  end if
  if (allocated(source%grps)) then
    do i = 1, size(source%grps)
      source_child => source%grps(i)
      if (.not. allocated(source_child%name)) then
        error = error_type(NC_EINVAL, "[to_netcdf] Each child group must have a name.")
        return
      end if
      child_name = source_child%name
      child = def_grp_(target, child_name, error)
      if (failed(error)) return
      call define_grp_tree_(child, source_child, error)
      if (failed(error)) return
    end do
  end if
end subroutine define_grp_tree_

!> Write group attributes without changing the in-memory group model.
subroutine write_grp_atts_(target, atts, error)
  class(group_type), intent(in) :: target
  type(attribute_type), intent(in) :: atts(:)
  type(error_type), intent(out) :: error
  type(group_type) :: metadata

  metadata%id = target%id
  metadata%atts = atts
  call put_att_grp_error(metadata, error)
end subroutine write_grp_atts_

!> Write all data buffers after the complete group tree has been defined.
recursive subroutine write_grp_tree_data_(target, source, error)
  class(group_type), intent(in) :: target
  type(group_type), target, intent(in) :: source
  type(error_type), intent(out) :: error
  type(group_type) :: child
  type(group_type), pointer :: source_child
  integer, allocatable :: start(:), count(:)
  character(len=NC_MAX_NAME) :: child_name
  integer :: i, j, ndims

  error = error_type()
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
      call put_variable(target, source%vars(i), start, count, error=error)
      if (failed(error)) return
      deallocate (start, count)
    end do
  end if
  if (allocated(source%grps)) then
    do i = 1, size(source%grps)
      source_child => source%grps(i)
      child_name = source_child%name
      child = get_grp_(target, child_name, error)
      if (failed(error)) return
      call write_grp_tree_data_(child, source_child, error)
      if (failed(error)) return
    end do
  end if
end subroutine write_grp_tree_data_

!> Define a direct child group while retaining NetCDF's status result.
function def_grp_(parent, name, error) result(group)
  class(group_type), intent(in) :: parent
  character(len=*), intent(in) :: name
  type(error_type), intent(out) :: error
  type(group_type) :: group
  integer(c_int) :: stat

  group%name = clip(name)
  stat = nc_def_grp(parent%id, f2cstr(group%name), group%id)
  error = make_netcdf_error(stat, "[def_grp] "//group%name)
end function def_grp_

!> Get a direct child group while retaining NetCDF's status result.
function get_grp_(parent, name, error) result(group)
  class(group_type), intent(in) :: parent
  character(len=*), intent(in) :: name
  type(error_type), intent(out) :: error
  type(group_type) :: group
  integer(c_int) :: stat

  group%name = clip(name)
  stat = nc_inq_ncid(parent%id, f2cstr(group%name), group%id)
  error = make_netcdf_error(stat, "[get_grp] "//group%name)
end function get_grp_

!> Return direct child group handles with their IDs and local names.
function inq_grps_(parent, error) result(grps)
  class(group_type), intent(in) :: parent
  type(error_type), intent(out) :: error
  type(group_type), allocatable :: grps(:)
  integer(c_int), allocatable, target :: ids(:)
  character(kind=c_char, len=NC_MAX_NAME + 1) :: name
  integer(c_int) :: i, ngroups, stat

  error = error_type()
  stat = nc_inq_grps(parent%id, ngroups, c_null_ptr)
  error = make_netcdf_error(stat, "[inq_grps] Group count.")
  if (failed(error)) return
  allocate (grps(ngroups), ids(ngroups))
  if (ngroups == 0) return

  stat = nc_inq_grps(parent%id, ngroups, c_loc(ids(1)))
  error = make_netcdf_error(stat, "[inq_grps] Group identifiers.")
  if (failed(error)) return
  do i = 1, ngroups
    name = c_null_char
    stat = nc_inq_grpname(ids(i), name)
    error = make_netcdf_error(stat, "[inq_grps] Group name.")
    if (failed(error)) return
    grps(i)%id = ids(i)
    grps(i)%name = clip(c2fstr(name))
  end do
end function inq_grps_

!> Return local variables declared by a group.
function inq_vars_(group, error) result(vars)
  class(group_type), intent(in) :: group
  type(error_type), intent(out) :: error
  type(variable_type), allocatable :: vars(:)
  integer(c_int), allocatable, target :: ids(:)
  character(kind=c_char, len=NC_MAX_NAME + 1) :: name
  integer(c_int) :: i, nvars, stat

  error = error_type()
  stat = nc_inq_varids(group%id, nvars, c_null_ptr)
  error = make_netcdf_error(stat, "[inq_grp] Variable count.")
  if (failed(error)) return
  allocate (vars(nvars), ids(nvars))
  if (nvars == 0) return

  stat = nc_inq_varids(group%id, nvars, c_loc(ids(1)))
  error = make_netcdf_error(stat, "[inq_grp] Variable identifiers.")
  if (failed(error)) return
  do i = 1, nvars
    name = c_null_char
    stat = nc_inq_varname(group%id, ids(i), name)
    error = make_netcdf_error(stat, "[inq_grp] Variable name.")
    if (failed(error)) return
    vars(i) = inq_var_error(group, c2fstr(name), error)
    if (failed(error)) return
  end do
end function inq_vars_

!> Recursively materialize already-discovered child groups.
subroutine materialize_children(grps, want_dims, want_atts, want_vars, error)
  type(group_type), intent(inout) :: grps(:)
  logical, intent(in) :: want_dims, want_atts, want_vars
  type(error_type), intent(out) :: error
  integer :: i

  error = error_type()
  do i = 1, size(grps)
    grps(i) = inq_grp(grps(i), inq_dims=want_dims, inq_atts=want_atts, &
      & inq_vars=want_vars, inq_grps=.true., recursive=.true., error=error)
    if (failed(error)) return
  end do
end subroutine materialize_children

!> Return the value of an optional logical inquiry flag.
pure logical function requested(flag)
  logical, intent(in), optional :: flag

  requested = .false.
  if (present(flag)) requested = flag
end function requested

end submodule nc4f_nc_grp
