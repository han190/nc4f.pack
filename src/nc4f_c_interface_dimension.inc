! Dimension definition, discovery, and renaming.
! Included inside the interface block of nc4f_c_interface.

function nc_inq_dimlen(ncid, dimid, lenp) bind(c, name="nc_inq_dimlen")
  !! Find the length of a dimension.
  import :: c_int, c_size_t
  integer(c_int), value :: ncid
  !! NetCDF or group ID, from a previous call to nc_open(), nc_create(),
  !! nc_def_grp(), or associated inquiry functions such as nc_inq_ncid().
  integer(c_int), value :: dimid
  !! Dimension ID, from a previous call to nc_inq_dimid() or nc_def_dim().
  integer(c_size_t), intent(out) :: lenp
  !! Pointer where the length will be stored.
  integer(c_int) :: nc_inq_dimlen
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Not a valid ID.
  !! - NC_EBADDIM Invalid dimension ID or name.
end function nc_inq_dimlen

function nc_inq_dimids(ncid, ndims, dimids, include_parents) &
  & bind(c, name="nc_inq_dimids")
  !! Retrieve a list of dimension ids associated with a group.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! The ncid of the group in question.
  integer(c_int), intent(out) :: ndims
  !! Pointer to memory to contain the number of dimids associated with the
  !! group.
  type(c_ptr), value :: dimids
  !! Pointer to memory to contain the number of dimensions associated with
  !! the group.
  integer(c_int), value :: include_parents
  !! If non-zero, parent groups are also traversed.
  integer(c_int) :: nc_inq_dimids
  !! Error code or NC_NOERR for no error.
end function nc_inq_dimids

function nc_inq_dimid(ncid, name, idp) bind(c, name="nc_inq_dimid")
  !! Find the ID of a dimension from the name.
  import :: c_int, c_char
  integer(c_int), value :: ncid
  !! NetCDF or group ID, from a previous call to nc_open(), nc_create(),
  !! nc_def_grp(), or associated inquiry functions such as nc_inq_ncid().
  character(kind=c_char), intent(in) :: name(*)
  !! Name of the dimension.
  integer(c_int), intent(out) :: idp
  !! Pointer where dimension ID will be stored.
  integer(c_int) :: nc_inq_dimid
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Not a valid ID.
  !! - NC_EBADDIM Invalid dimension ID.
end function nc_inq_dimid

function nc_inq_dimname(ncid, dimid, name) bind(c, name="nc_inq_dimname")
  !! Find out the name of a dimension.
  import :: c_int, c_char
  integer(c_int), value :: ncid
  !! NetCDF or group ID, from a previous call to nc_open(), nc_create(),
  !! nc_def_grp(), or associated inquiry functions such as nc_inq_ncid().
  integer(c_int), value :: dimid
  !! Dimension ID, from a previous call to nc_inq_dimid() or nc_def_dim().
  character(kind=c_char), intent(out) :: name(*)
  !! Returned dimension name. The caller must allocate space for the returned
  !! name. The maximum possible length, in characters, of a dimension name is
  !! given by the predefined constant NC_MAX_NAME. (This doesn't include the
  !! null terminator, so declare your array to be size NC_MAX_NAME+1). The
  !! returned character array will be null-terminated.
  integer(c_int) :: nc_inq_dimname
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Not a valid ID.
  !! - NC_EBADDIM Invalid dimension ID or name.
end function nc_inq_dimname

function nc_inq_unlimdim(ncid, unlimdimidp) bind(c, name="nc_inq_unlimdim")
  !! Find the ID of the unlimited dimension.
  import :: c_int
  integer(c_int), value :: ncid
  !! NetCDF or group ID, from a previous call to nc_open(), nc_create(),
  !! nc_def_grp(), or associated inquiry functions such as nc_inq_ncid().
  integer(c_int), intent(out) :: unlimdimidp
  !! Pointer where unlimited dimension ID will be stored. If there is no
  !! unlimited dimension, -1 will be stored here.
  integer(c_int) :: nc_inq_unlimdim
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Not a valid ID.
end function nc_inq_unlimdim

function nc_inq_unlimdims(ncid, nunlimdimsp, unlimdimidsp) &
  & bind(c, name="nc_inq_unlimdims")
  !! Return the identifiers of all unlimited dimensions in a dataset or group.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! NetCDF or group ID.
  integer(c_int), intent(out) :: nunlimdimsp
  !! Number of unlimited dimensions.
  type(c_ptr), value :: unlimdimidsp
  !! Pointer to an array of unlimited dimension IDs, or NULL when querying
  !! only the count.
  integer(c_int) :: nc_inq_unlimdims
  !! NetCDF status code.
end function nc_inq_unlimdims

function nc_def_dim(ncid, name, len, idp) bind(c, name="nc_def_dim")
  !! Define a new dimension.
  import :: c_int, c_char, c_size_t
  integer(c_int), value :: ncid
  !! NetCDF or group ID, from a previous call to nc_open(), nc_create(),
  !! nc_def_grp(), or associated inquiry functions such as nc_inq_ncid().
  character(kind=c_char), intent(in) :: name(*)
  !! Name of the dimension to be created.
  integer(c_size_t), value :: len
  !! Length of the dimension to be created. Use NC_UNLIMITED for unlimited
  !! dimensions.
  integer(c_int), intent(inout) :: idp
  !! Pointer where dimension ID will be stored.
  integer(c_int) :: nc_def_dim
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Not a valid ID.
  !! - NC_EMAXNAME Name is too long.
  !! - NC_EBADNAME Name breaks netCDF name rules.
  !! - NC_EINVAL Invalid input.
  !! - NC_ENOTINDEFINE Not in define mode.
  !! - NC_EDIMSIZE Invalid dimension size.
  !! - NC_EUNLIMIT NC_UNLIMITED size already in use
  !! - NC_EMAXDIMS NC_MAX_DIMS exceeded [not enforced after 4.5.0]
  !! - NC_ENAMEINUSE String match to name in use
  !! - NC_ENOMEM Memory allocation (malloc) failure
  !! - NC_EPERM Write to read only
end function nc_def_dim

function nc_inq_dim(ncid, dimid, name, lenp) bind(c, name="nc_inq_dim")
  !! Return a dimension's name and current length.
  import :: c_int, c_char, c_size_t
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: dimid
  !! Dimension identifier visible from ncid.
  character(kind=c_char), intent(out) :: name(*)
  !! Caller-allocated buffer of at least NC_MAX_NAME + 1 characters; result is NUL-terminated.
  integer(c_size_t), intent(out) :: lenp
  !! Returned current dimension length, including records already written.
  integer(c_int) :: nc_inq_dim
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_EBADDIM Invalid dimension.
end function nc_inq_dim

function nc_rename_dim(ncid, dimid, name) bind(c, name="nc_rename_dim")
  !! Rename a dimension.
  !! For classic files, enter define mode if the new name is longer.
  import :: c_int, c_char
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: dimid
  !! Dimension identifier visible from ncid.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated object name.
  integer(c_int) :: nc_rename_dim
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_EPERM Dataset is read-only.
  !! - NC_ENAMEINUSE The new name is already in use.
  !! - NC_EBADNAME Invalid new name.
  !! - NC_EBADDIM Invalid dimension.
end function nc_rename_dim

! Additional serial C API, including legacy and extension interfaces.

function ncdimdef(ncid, name, len) bind(c, name="ncdimdef")
  !! Legacy v2 API: Define a dimension and return its ID.
  !! Uses v2 return/error conventions, not modern NC_NOERR status semantics.
  !! Legacy process-global ncopts controls fatal errors and diagnostics; no accessor is provided.
  !! C declaration: int ncdimdef(int ncid, const char *name, long len);
  import :: c_int, c_char, c_long
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated C string.
  integer(c_long), value :: len
  !! Element count (not bytes except for byte/text types).
  integer(c_int) :: ncdimdef
  !! V2 result (ID, size, previous setting, or success value); -1 indicates failure.
end function ncdimdef

function ncdimid(ncid, name) bind(c, name="ncdimid")
  !! Legacy v2 API: Find a dimension ID by name.
  !! Uses v2 return/error conventions, not modern NC_NOERR status semantics.
  !! Legacy process-global ncopts controls fatal errors and diagnostics; no accessor is provided.
  !! C declaration: int ncdimid(int ncid, const char *name);
  import :: c_int, c_char
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated C string.
  integer(c_int) :: ncdimid
  !! V2 result (ID, size, previous setting, or success value); -1 indicates failure.
end function ncdimid

function ncdiminq(ncid, dimid, name, lenp) bind(c, name="ncdiminq")
  !! Legacy v2 API: Query dimension name and length.
  !! Uses v2 return/error conventions, not modern NC_NOERR status semantics.
  !! Legacy process-global ncopts controls fatal errors and diagnostics; no accessor is provided.
  !! C declaration: int ncdiminq(int ncid, int dimid, char *name, long *lenp);
  import :: c_int, c_ptr, c_long
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: dimid
  !! Dimension identifier.
  type(c_ptr), value :: name
  !! Pointer to caller-provided C character output storage (NC_MAX_NAME + 1 for names).
  integer(c_long), intent(out) :: lenp
  !! Returned lenp value (C long).
  integer(c_int) :: ncdiminq
  !! V2 result (ID, size, previous setting, or success value); -1 indicates failure.
end function ncdiminq

function ncdimrename(ncid, dimid, name) bind(c, name="ncdimrename")
  !! Legacy v2 API: Rename a dimension.
  !! Uses v2 return/error conventions, not modern NC_NOERR status semantics.
  !! Legacy process-global ncopts controls fatal errors and diagnostics; no accessor is provided.
  !! C declaration: int ncdimrename(int ncid, int dimid, const char *name);
  import :: c_int, c_char
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: dimid
  !! Dimension identifier.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated C string.
  integer(c_int) :: ncdimrename
  !! V2 result (ID, size, previous setting, or success value); -1 indicates failure.
end function ncdimrename
