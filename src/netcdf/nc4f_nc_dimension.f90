submodule(nc4f_nc) nc4f_nc_dimension
implicit none (type, external)
contains

module subroutine rename_dim_nc_dim(grp, dim, new_name, update_file, err)
  !! Rename a locally defined file dimension and only the supplied dimension
  !! object.
  class(group_type), intent(in) :: grp
  !! Defining open group when update_file is true; its caches are not
  !! synchronized.
  type(dimension_type), intent(inout) :: dim
  !! Dimension whose old name selects the file target; its cached ID is not
  !! trusted.
  character(len=*), intent(in) :: new_name
  !! Replacement local name; trailing padding is ignored.
  logical, intent(in), optional :: update_file
  !! Whether to update the file as well as dim; defaults to false.
  type(error_type), intent(out), optional :: err
  !! Receives status; failures terminate execution when omitted.
  type(error_type) :: op_err
  type(dimension_type) :: staged, actual
  logical :: write_file

  write_file = .false.
  if (present(update_file)) write_file = update_file
  if (.not. write_file) then
    call rename_dimension(dim, new_name, op_err)
  else if (.not. allocated(dim%name)) then
    op_err = error_type(NC_EINVAL, "rename_dimension", &
      & "Dimension must have a name.")
  else
    call find_dim_nc_(grp%id, dim%name, new_name, actual, op_err)
    if (.not. has_err(op_err)) then
      call rename_dimension(staged, new_name, op_err)
      if (.not. has_err(op_err)) call put_dim_name_(grp%id, actual%id, &
        & dim%name, new_name, op_err)
      if (.not. has_err(op_err)) call move_alloc(staged%name, dim%name)
    end if
  end if
  call return_err(op_err, err)
end subroutine rename_dim_nc_dim

module subroutine rename_dim_nc_grp(grp, old_name, new_name, update_file, err)
  !! Rename a local file dimension and synchronize only direct loaded dimension
  !! references.
  class(group_type), intent(inout) :: grp
  !! Defining group; descendant caches and independent snapshots are unchanged.
  character(len=*), intent(in) :: old_name, new_name
  !! old_name: Local dimension to find. new_name: Replacement local name.
  logical, intent(in) :: update_file
  !! Whether to update the file; required to distinguish the model-only
  !! overload.
  type(error_type), intent(out), optional :: err
  !! Receives status; failures terminate execution when omitted.
  type(error_type) :: op_err
  type(group_type) :: staged
  type(dimension_type) :: actual

  if (.not. update_file) then
    call rename_dimension(grp, old_name, new_name, op_err)
  else
    call find_dim_nc_(grp%id, old_name, new_name, actual, op_err)
    if (.not. has_err(op_err)) then
      call stage_dim_grp_(grp, actual, staged)
      call rename_dimension(staged, old_name, new_name, op_err)
      if (.not. has_err(op_err)) call put_dim_name_(grp%id, actual%id, &
        & old_name, new_name, op_err)
      if (.not. has_err(op_err)) call commit_dim_grp_(grp, staged, old_name)
    end if
  end if
  call return_err(op_err, err)
end subroutine rename_dim_nc_grp

subroutine find_dim_nc_(ncid, old_name, new_name, dim, err)
  !! Validate names and resolve only dimensions defined directly in the supplied
  !! group.
  integer(c_int), intent(in) :: ncid
  !! Open defining group identifier.
  character(len=*), intent(in) :: old_name, new_name
  !! old_name: Existing local name. new_name: Proposed replacement.
  type(dimension_type), intent(out) :: dim
  !! Fresh file identity and metadata of the target dimension.
  type(error_type), intent(out) :: err
  !! Receives lookup or validation status; inherited targets return NC_EBADDIM.
  type(dimension_type), allocatable :: dims(:)
  type(dimension_type) :: checked
  integer :: i

  call rename_dimension(checked, old_name, err)
  if (has_err(err)) return
  call rename_dimension(checked, new_name, err)
  if (has_err(err)) return
  dims = inq_dims_(ncid, err=err)
  if (has_err(err)) return
  do i = 1, size(dims)
    if (dims(i)%name /= trim(old_name)) cycle
    dim = dims(i)
    return
  end do
  err = error_type(NC_EBADDIM, "rename_dimension", &
    & "Dimension is not defined in this group: "//trim(old_name))
end subroutine find_dim_nc_

subroutine put_dim_name_(ncid, dimid, old_name, new_name, err)
  !! Apply the file rename while retaining existence and write-access checks for
  !! self-renames.
  integer(c_int), intent(in) :: ncid, dimid
  !! ncid: Defining group. dimid: Freshly resolved local dimension identifier.
  character(len=*), intent(in) :: old_name, new_name
  !! old_name: Existing name. new_name: Validated replacement.
  type(error_type), intent(out) :: err
  !! Receives the C operation status without mutating any supplied cache.
  integer(c_int) :: stat

  stat = nc_rename_dim(ncid, dimid, f2cstr(new_name))
  if (trim(old_name) == trim(new_name) .and. stat == NC_ENAMEINUSE) stat = &
    & NC_NOERR
  err = netcdf_err(stat, "rename_dimension", &
    & "Rename dimension: "//trim(old_name)//" -> "//trim(new_name))
end subroutine put_dim_name_

pure subroutine stage_dim_grp_(grp, actual, staged)
  !! Copy dimension metadata only, adding a temporary definition for an
  !! incomplete cache.
  class(group_type), intent(in) :: grp
  !! Supplied cache; variable payloads, attributes, and child pointers are never
  !! copied.
  type(dimension_type), intent(in) :: actual
  !! File dimension used as a placeholder when no cached definition exists.
  type(group_type), intent(out) :: staged
  !! Temporary model containing only dimension definitions and direct variable
  !! dimensions.
  type(dimension_type) :: placeholder
  integer :: i, j, n
  logical :: found

  n = 0
  found = .false.
  placeholder = actual
  if (allocated(grp%dims)) then
    n = size(grp%dims)
    do i = lbound(grp%dims, 1), ubound(grp%dims, 1)
      if (.not. allocated(grp%dims(i)%name)) cycle
      if (grp%dims(i)%name == actual%name) found = .true.
    end do
  end if
  if (allocated(grp%vars)) then
    allocate (staged%vars(lbound(grp%vars, 1):ubound(grp%vars, 1)))
    do i = lbound(grp%vars, 1), ubound(grp%vars, 1)
      if (.not. allocated(grp%vars(i)%dims)) cycle
      staged%vars(i)%dims = grp%vars(i)%dims
      do j = lbound(grp%vars(i)%dims, 1), ubound(grp%vars(i)%dims, 1)
        if (.not. allocated(grp%vars(i)%dims(j)%name)) cycle
        ! A cache may describe an earlier unlimited extent; compare cached
        ! copies to each other.
        if (grp%vars(i)%dims(j)%name == actual%name) placeholder = &
          & grp%vars(i)%dims(j)
      end do
    end do
  end if
  allocate (staged%dims(n + merge(0, 1, found)))
  if (allocated(grp%dims)) staged%dims(:n) = grp%dims
  if (.not. found) staged%dims(n + 1) = placeholder
end subroutine stage_dim_grp_

pure subroutine commit_dim_grp_(grp, staged, old_name)
  !! Move prepared names into existing cache entries without allocating or
  !! replacing arrays.
  class(group_type), intent(inout) :: grp
  !! Original cache whose direct matching dimension names are updated.
  type(group_type), intent(inout) :: staged
  !! Staged metadata supplying the new names after a successful file operation.
  character(len=*), intent(in) :: old_name
  !! Original name used to select cache entries; unrelated entries remain
  !! untouched.
  integer :: i, j, k

  k = 0
  if (allocated(grp%dims)) then
    do i = lbound(grp%dims, 1), ubound(grp%dims, 1)
      k = k + 1
      if (.not. allocated(grp%dims(i)%name)) cycle
      if (grp%dims(i)%name == &
        & trim(old_name)) call move_alloc(staged%dims(k)%name, grp%dims(i)%name)
    end do
  end if
  if (.not. allocated(grp%vars)) return
  do i = lbound(grp%vars, 1), ubound(grp%vars, 1)
    if (.not. allocated(grp%vars(i)%dims)) cycle
    k = lbound(staged%vars(i)%dims, 1)
    do j = lbound(grp%vars(i)%dims, 1), ubound(grp%vars(i)%dims, 1)
      if (allocated(grp%vars(i)%dims(j)%name)) then
        if (grp%vars(i)%dims(j)%name == trim(old_name)) then
          call move_alloc(staged%vars(i)%dims(k)%name, &
            & grp%vars(i)%dims(j)%name)
        end if
      end if
      k = k + 1
    end do
  end do
end subroutine commit_dim_grp_


module function inq_dims_grp(nc, err) result(dims)
  !! Inquire all dimensions for the top-level group of a netCDF file.
  class(group_type), intent(in) :: nc
  !! High-level `netcdf_type` representing the open file.
  type(error_type), intent(out), optional :: err
  !! Optional error result. When absent, failures stop the program.
  type(dimension_type), allocatable :: dims(:)
  !! Allocatable array of `dimension_type` in Fortran order.
  type(error_type) :: op_err

  dims = inq_dims_(nc%id, err=op_err)
  call return_err(op_err, err)
end function inq_dims_grp

module function inq_dims_var(nc, var, err) result(dims)
  !! Inquire the dimensions attached to a variable.
  class(group_type), intent(in) :: nc
  !! High-level `netcdf_type` for the file.
  type(variable_type), intent(in) :: var
  !! `variable_type` describing the variable.
  type(error_type), intent(out), optional :: err
  !! Optional error result. When absent, failures stop the program.
  type(dimension_type), allocatable :: dims(:)
  !! Allocatable array of `dimension_type` for that variable.
  type(error_type) :: op_err

  dims = inq_dims_(nc%id, var%id, op_err)
  call return_err(op_err, err)
end function inq_dims_var

function inq_dims_(ncid, varid, err) result(dims)
  !! Low-level helper to inquire dimensions from a netCDF `ncid` or an optional
  !! `varid`.
  integer(c_int), intent(in) :: ncid
  !! C `ncid` for the dataset or group.
  integer(c_int), optional, intent(in) :: varid
  !! Optional C `varid` for a variable. If present, return that variable's
  !! dimensions.
  type(error_type), intent(out) :: err
  !! Completed result of this operation.
  type(dimension_type), allocatable :: dims(:)
  !! Allocatable array of `dimension_type` in Fortran ordering (reversed
  !! relative to the C API ordering).
  integer(c_int), allocatable, target :: dimids(:)
  character(len=NC_MAX_NAME + 1, kind=c_char) :: dim_name
  integer(c_int) :: i, j, ndims, stat
  integer(c_int), parameter :: include_parents = 0_c_int

  ! Callers assign the result before inspecting ERR, even on failure.
  allocate (dims(0))
  err = error_type()
  if (present(varid)) then
    stat = nc_inq_varndims(ncid, varid, ndims)
    err = netcdf_err(stat, "inq_dims", "Variable rank.")
    if (has_err(err)) return
    allocate (dimids(ndims))
    if (ndims > 0) then
      stat = nc_inq_vardimid(ncid, varid, dimids)
      err = netcdf_err(stat, "inq_dims", "Variable dimensions.")
      if (has_err(err)) return
    end if
  else
    stat = nc_inq_dimids(ncid, ndims, c_null_ptr, include_parents)
    err = netcdf_err(stat, "inq_dims", "Dimension count.")
    if (has_err(err)) return
    allocate (dimids(ndims))
    if (ndims > 0) then
      stat = nc_inq_dimids(ncid, ndims, c_loc(dimids(1)), include_parents)
      err = netcdf_err(stat, "inq_dims", "Dimension identifiers.")
      if (has_err(err)) return
    end if
  end if
  deallocate (dims)
  allocate (dims(ndims))

  do i = 1, ndims
    !! Since this module uses the C API, the dimension order is reversed when
    !! read into a Fortran program.
    j = ndims - i + 1
    dims(j)%id = dimids(i)
    stat = nc_inq_dimname(ncid, dimids(i), dim_name)
    err = netcdf_err(stat, "inq_dims", "Dimension name.")
    if (has_err(err)) return
    stat = nc_inq_dimlen(ncid, dimids(i), dims(j)%len)
    err = netcdf_err(stat, "inq_dims", "Dimension length.")
    if (has_err(err)) return
    dims(j)%name = clip(c2fstr(dim_name))
    call dim_unlimited_(ncid, dimids(i), dims(j)%is_unlim, err)
    if (has_err(err)) return
  end do
end function inq_dims_

subroutine dim_unlimited_(ncid, dimid, unlimited, err)
  !! Dimension IDs are file-wide; search the group and its ancestors.
  integer(c_int), intent(in) :: ncid
  !! Open group identifier from which to search for the dimension.
  integer(c_int), intent(in) :: dimid
  !! Identifier of the visible dimension whose unlimited status is requested.
  logical, intent(out) :: unlimited
  !! True when the dimension is unlimited in the supplied group or an ancestor.
  type(error_type), intent(out) :: err
  !! Completed operation result; contains a diagnostic when the operation fails.
  integer(c_int) :: groupid, parent, n, stat
  integer(c_int), allocatable, target :: ids(:)

  err = error_type()
  unlimited = .false.
  groupid = ncid
  do
    stat = nc_inq_unlimdims(groupid, n, c_null_ptr)
    err = netcdf_err(stat, "resolve_dimension", &
      & "Inquire unlimited dimensions.")
    if (has_err(err)) return
    allocate(ids(n))
    if (n > 0) then
      stat = nc_inq_unlimdims(groupid, n, c_loc(ids(1)))
      err = netcdf_err(stat, "resolve_dimension", &
        & "Inquire unlimited dimension IDs.")
      if (has_err(err)) return
      unlimited = any(ids == dimid)
    end if
    deallocate(ids)
    if (unlimited) return
    stat = nc_inq_grp_parent(groupid, parent)
    if (stat == NC_ENOGRP) return
    err = netcdf_err(stat, "resolve_dimension", "Inquire parent group.")
    if (has_err(err)) return
    groupid = parent
  end do
end subroutine dim_unlimited_

module subroutine resolve_dim(nc, dim, found, actual, err)
  !! Resolve a visible dimension and validate its fixed length and unlimited
  !! status.
  class(group_type), intent(in) :: nc
  !! Open destination dataset or subgroup; source objects and loaded caches are
  !! unchanged.
  type(dimension_type), intent(in) :: dim
  !! Requested dimension name, length, and unlimited status.
  logical, intent(out) :: found
  !! True when a visible dimension with the requested name exists.
  type(dimension_type), intent(out) :: actual
  !! Resolved file metadata; valid only when found is true and err indicates
  !! success.
  type(error_type), intent(out) :: err
  !! Completed operation result; contains a diagnostic when the operation fails.
  integer(c_int) :: stat, dimid
  integer(c_size_t) :: length

  found = .false.
  err = error_type()
  if (.not. allocated(dim%name)) then
    err = error_type(NC_EINVAL, "resolve_dimension", &
      & "Dimension name is not allocated.")
    return
  end if
  call validate(dim%name, context="resolve_dimension", err=err)
  if (has_err(err)) return
  if (dim%len < 0 .or. (dim%len == 0 .and. .not. dim%is_unlim) .or. &
    & dim%len > int(huge(0_c_size_t), int64)) then
    err = error_type(NC_EINVAL, "resolve_dimension", &
      & "Invalid dimension length.")
    return
  end if
  stat = nc_inq_dimid(nc%id, f2cstr(dim%name), dimid)
  if (stat == NC_EBADDIM) return
  err = netcdf_err(stat, "resolve_dimension", dim%name)
  if (has_err(err)) return
  found = .true.
  stat = nc_inq_dimlen(nc%id, dimid, length)
  err = netcdf_err(stat, "resolve_dimension", dim%name)
  if (has_err(err)) return
  actual = dimension_type(dimid, dim%name, int(length, int64), .false.)
  call dim_unlimited_(nc%id, dimid, actual%is_unlim, err)
  if (has_err(err)) return
  if (actual%is_unlim .neqv. dim%is_unlim) then
    err = error_type(NC_EINVAL, "resolve_dimension", &
      & "Conflicting unlimited status: "//dim%name)
  else if (.not. actual%is_unlim .and. actual%len /= dim%len) then
    err = error_type(NC_EINVAL, "resolve_dimension", &
      & "Conflicting fixed dimension length: "//dim%name)
  end if
end subroutine resolve_dim

module function def_dim(nc, dim, err) result(new_dim)
  !! Reuse a compatible visible dimension or create a missing local dimension.
  class(group_type), intent(in) :: nc
  !! Open destination dataset or subgroup; source objects and loaded caches are
  !! unchanged.
  type(dimension_type), intent(in) :: dim
  !! Requested dimension name, length, and unlimited status.
  type(error_type), intent(out) :: err
  !! Completed operation result; contains a diagnostic when the operation fails.
  type(dimension_type) :: new_dim
  !! Created or reused dimension, including its current file length and
  !! identifier.
  integer(c_int) :: stat, dimid
  integer(c_size_t) :: length
  logical :: found
  !! True when a visible dimension with the requested name exists.

  call resolve_dim(nc, dim, found, new_dim, err)
  if (has_err(err) .or. found) return
  length = int(dim%len, c_size_t)
  if (dim%is_unlim) length = NC_UNLIMITED
  stat = nc_def_dim(nc%id, f2cstr(dim%name), length, dimid)
  err = netcdf_err(stat, "def_dim", dim%name)
  if (has_err(err)) return
  new_dim = dimension_type(dimid, dim%name, int(length, int64), dim%is_unlim)
end function def_dim

end submodule nc4f_nc_dimension
