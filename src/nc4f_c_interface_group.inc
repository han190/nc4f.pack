! Group creation, navigation, and renaming.
! Included inside the interface block of nc4f_c_interface.

function nc_def_grp(parent_ncid, name, new_ncid) bind(c, name="nc_def_grp")
  !! Define a child group below `parent_ncid`.
  import :: c_int, c_char
  integer(c_int), value :: parent_ncid
  !! Parent file or group identifier.
  character(kind=c_char), intent(in) :: name(*)
  !! Name for the newly defined direct child group.
  integer(c_int), intent(out) :: new_ncid
  !! Returned identifier for the newly created group.
  integer(c_int) :: nc_def_grp
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_ENOTNC4 Not a netCDF-4 file.
  !! - NC_ENOTINDEFINE Not in define mode.
  !! - NC_ESTRICTNC3 Not permitted in netCDF-4 classic mode.
  !! - NC_EPERM File is read-only.
  !! - NC_ENOMEM Memory allocation failure.
  !! - NC_ENAMEINUSE Group name is already in use.
end function nc_def_grp

function nc_inq_ncid(ncid, name, grp_ncid) bind(c, name="nc_inq_ncid")
  !! Look up a direct child group by name.
  import :: c_int, c_char
  integer(c_int), value :: ncid
  !! Parent file or group identifier.
  character(kind=c_char), intent(in) :: name(*)
  !! Name of the direct child group to look up.
  integer(c_int), intent(out) :: grp_ncid
  !! Returned identifier for the matching child group.
  integer(c_int) :: nc_inq_ncid
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Bad ncid.
  !! - NC_ENOTNC4 Not a netCDF-4 file.
  !! - NC_ENOGRP Group not found.
end function nc_inq_ncid

function nc_inq_grps(ncid, numgrps, ncids) bind(c, name="nc_inq_grps")
  !! Return direct child group identifiers, or only their count when NULL.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! File or group identifier whose direct children are queried.
  integer(c_int), intent(out) :: numgrps
  !! Returned number of direct child groups.
  type(c_ptr), value :: ncids
  !! Caller-allocated array of `numgrps` group IDs, or C NULL to query only
  !! the number of groups.
  integer(c_int) :: nc_inq_grps
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Bad ncid.
end function nc_inq_grps

function nc_inq_grpname(ncid, name) bind(c, name="nc_inq_grpname")
  !! Return a group's local name.
  import :: c_int, c_char
  integer(c_int), value :: ncid
  !! Identifier of the group to name.
  character(kind=c_char), intent(out) :: name(*)
  !! Caller-allocated name buffer of at least `NC_MAX_NAME + 1` characters.
  integer(c_int) :: nc_inq_grpname
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Bad ncid.
end function nc_inq_grpname

function nc_inq_grpname_full(ncid, lenp, full_name) &
  & bind(c, name="nc_inq_grpname_full")
  !! Return a group's full path and required path length.
  import :: c_int, c_char, c_size_t
  integer(c_int), value :: ncid
  !! Identifier of the group whose full path is queried.
  integer(c_size_t), intent(out) :: lenp
  !! Returned length of the full path, excluding the trailing NUL byte.
  character(kind=c_char), intent(out) :: full_name(*)
  !! Caller-allocated buffer for the NUL-terminated full path. The root
  !! group path is `/` and has length one.
  integer(c_int) :: nc_inq_grpname_full
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Bad ncid.
  !! - NC_ENOMEM Memory allocation failure.
end function nc_inq_grpname_full

function nc_inq_grp_parent(ncid, parent_ncid) &
  & bind(c, name="nc_inq_grp_parent")
  !! Return the parent group identifier.
  import :: c_int
  integer(c_int), value :: ncid
  !! Identifier of the group whose parent is queried.
  integer(c_int), intent(out) :: parent_ncid
  !! Returned identifier for the direct parent group.
  integer(c_int) :: nc_inq_grp_parent
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Bad ncid.
  !! - NC_ENOGRP No parent group: `ncid` identifies the root group.
end function nc_inq_grp_parent

function nc_inq_grp_full_ncid(ncid, full_name, grp_ncid) &
  & bind(c, name="nc_inq_grp_full_ncid")
  !! Resolve a full group path relative to `ncid`.
  import :: c_int, c_char
  integer(c_int), value :: ncid
  !! File or group identifier relative to which the full path is resolved.
  character(kind=c_char), intent(in) :: full_name(*)
  !! Absolute or relative NUL-terminated group path to resolve.
  integer(c_int), intent(out) :: grp_ncid
  !! Returned identifier for the resolved group.
  integer(c_int) :: nc_inq_grp_full_ncid
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Bad ncid.
  !! - NC_ENOGRP Group not found.
  !! - NC_ENOMEM Memory allocation failure.
  !! - NC_EINVAL A group path is required.
end function nc_inq_grp_full_ncid

function nc_inq_grpname_len(ncid, lenp) bind(c, name="nc_inq_grpname_len")
  !! Return the length of a group's full path.
  import :: c_int, c_size_t
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_size_t), intent(out) :: lenp
  !! Returned full-path length excluding NUL; allocate lenp + 1 for nc_inq_grpname_full().
  integer(c_int) :: nc_inq_grpname_len
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
end function nc_inq_grpname_len

function nc_rename_grp(grpid, name) bind(c, name="nc_rename_grp")
  !! Rename a group.
  import :: c_int, c_char
  integer(c_int), value :: grpid
  !! Identifier of the group to rename.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated object name.
  integer(c_int) :: nc_rename_grp
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_EPERM Dataset is read-only.
  !! - NC_ENAMEINUSE The new name is already in use.
  !! - NC_EBADNAME Invalid new name.
  !! - NC_ENOTNC4 Not a NetCDF-4 file.
end function nc_rename_grp

! Additional serial C API, including legacy and extension interfaces.

function nc_inq_grp_ncid(ncid, grp_name, grp_ncid) bind(c, name="nc_inq_grp_ncid")
  !! Find a group by name; equivalent to nc_inq_ncid().
  !! C declaration: int nc_inq_grp_ncid(int ncid, const char *grp_name, int *grp_ncid);
  import :: c_int, c_char
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  character(kind=c_char), intent(in) :: grp_name(*)
  !! NUL-terminated C string.
  integer(c_int), intent(out) :: grp_ncid
  !! Returned grp_ncid value (C int).
  integer(c_int) :: nc_inq_grp_ncid
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_inq_grp_ncid
