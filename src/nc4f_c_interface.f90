module nc4f_c_interface
use, intrinsic :: iso_c_binding, only: c_int, c_ptr, c_char, c_size_t, c_long
implicit none (type, external)
public

integer(c_int), parameter :: NC_NOWRITE = int(z'0000', kind=c_int)
!! Set read-only access for nc_open().
integer(c_int), parameter :: NC_WRITE = int(z'0001', kind=c_int)
!! Set read-write access for nc_open().
integer(c_int), parameter :: NC_CLOBBER = int(z'0000', kind=c_int)
!! Destroy existing file. Mode flag for nc_create().
integer(c_int), parameter :: NC_NOCLOBBER = int(z'0004', kind=c_int)
!! Don't destroy existing file. Mode flag for nc_create().
integer(c_int), parameter :: NC_NETCDF4 = int(z'1000', kind=c_int)
!! Use netCDF-4/HDF5 format. Mode flag for nc_create().

integer(c_int), parameter :: NC_NOERR = 0_c_int
!! No Error
integer(c_int), parameter :: NC_EBADID = -33_c_int
!! Invalid netCDF identifier.
integer(c_int), parameter :: NC_EINVAL = -36_c_int
!! Invalid argument.
integer(c_int), parameter :: NC_EINVALCOORDS = -40_c_int
!! Hyperslab coordinates are outside a dimension.
integer(c_int), parameter :: NC_ENOTATT = -43_c_int
!! Attribute not found.
integer(c_int), parameter :: NC_EBADDIM = -46_c_int
!! Dimension not found.
integer(c_int), parameter :: NC_ENOTVAR = -49_c_int
!! Variable not found.
integer(c_int), parameter :: NC_EEDGE = -57_c_int
!! Hyperslab edge lengths exceed a dimension bound.
integer(c_int), parameter :: NC_ENOTFOUND = -90_c_int
!! File not found.
integer(c_int), parameter :: NC_EBADGRPID = -116_c_int
!! Invalid group identifier.
integer(c_int), parameter :: NC_ENOGRP = -125_c_int
!! Group not found.
integer(c_int), parameter :: NC_MAX_NAME = 256_c_int

integer(c_int), parameter :: NC_MAX_DIMS = 1024_c_int
!! not enforced after 4.5.0
integer(c_int), parameter :: NC_GLOBAL = -1_c_int
!! Attribute id to put/get a global attribute.
integer(c_long), parameter :: NC_UNLIMITED = 0_c_long
!! Size argument to nc_def_dim() for an unlimited dimension.

integer(c_int), parameter :: NC_NAT = 0_c_int
!! Not A Type
integer(c_int), parameter :: NC_BYTE = 1_c_int
!! signed 1 byte integer
integer(c_int), parameter :: NC_CHAR = 2_c_int
!! ISO/ASCII character
integer(c_int), parameter :: NC_SHORT = 3_c_int
!! signed 2 byte integer
integer(c_int), parameter :: NC_INT = 4_c_int
!! signed 4 byte integer
integer(c_int), parameter :: NC_FLOAT = 5_c_int
!! single precision floating point number
integer(c_int), parameter :: NC_DOUBLE = 6_c_int
!! double precision floating point number
integer(c_int), parameter :: NC_UBYTE = 7_c_int ! N/A
!! unsigned 1 byte int
integer(c_int), parameter :: NC_USHORT = 8_c_int ! N/A
!! unsigned 2-byte int
integer(c_int), parameter :: NC_UINT = 9_c_int ! N/A
!! unsinged 4-byte int
integer(c_int), parameter :: NC_INT64 = 10_c_int
!! signed 8-byte int
integer(c_int), parameter :: NC_UINT64 = 11_c_int ! N/A
!! unsigned 8-byte int
integer(c_int), parameter :: NC_STRING = 12_c_int ! N/A
!! string

interface
  pure function c_strlen(str) bind(c, name="strlen") result(length)
    !! Return the length of a NUL-terminated C string.
    import :: c_ptr, c_size_t
    type(c_ptr), value :: str
    !! Data or metadata used by this operation.
    integer(c_size_t) :: length
    !! Result produced by this operation.
  end function c_strlen

  function nc_strerror(ncerr1) bind(c, name="nc_strerror")
    !! Given an error number, return an error message.
    import :: c_int, c_ptr
    integer(c_int), value :: ncerr1
    !! error number
    type(c_ptr) :: nc_strerror
    !! short string containing error message.
  end function nc_strerror

  function nc_open(path, mode, ncidp) bind(c, name="nc_open")
    !! Open an existing netCDF file.
    import :: c_char, c_int
    character(kind=c_char), intent(in) :: path(*)
    !! File name for netCDF dataset to be opened. When the dataset is located
    !! on some remote server, then the path may be an OPeNDAP URL rather than a
    !! file path.
    integer(c_int), value :: mode
    !! The open mode flag may include NC_WRITE (for read/write access) and
    !! NC_SHARE (see below) and NC_DISKLESS (see below).
    integer(c_int), intent(out) :: ncidp
    !! Pointer to location where returned netCDF ID is to be stored.
    integer(c_int) :: nc_open
    !! **Options:**
    !! - NC_NOERR No error.
    !! - NC_EPERM Attempting to create a netCDF file in a
    !!   directory where you do not have permission to open files.
    !! - NC_ENFILE Too many files open.
    !! - NC_ENOMEM Out of memory.
    !! - NC_EHDFERR HDF5 error. (NetCDF-4 files only.)
    !! - NC_EDIMMETA Error in netCDF-4 dimension metadata. (NetCDF-4 files
    !!   only.)
  end function nc_open

  function nc_create(path, cmode, ncidp) bind(c, name="nc_create")
    !! Create a new netCDF file.
    import :: c_char, c_int
    character(kind=c_char), intent(in) :: path(*)
    !! The file name of the new netCDF dataset.
    integer(c_int), value :: cmode
    !! The creation mode flag. The following flags are available: NC_CLOBBER
    !! (overwrite existing file), NC_NOCLOBBER (do not overwrite existing
    !! file), NC_SHARE (limit write caching - netcdf classic files only),
    !! NC_64BIT_OFFSET (create 64-bit offset file), NC_64BIT_DATA (alias
    !! NC_CDF5) (create CDF-5 file), NC_NETCDF4 (create netCDF-4/HDF5 file),
    !! NC_CLASSIC_MODEL (enforce netCDF classic mode on netCDF-4/HDF5 files),
    !! NC_DISKLESS (store data in memory), and NC_PERSIST (force the
    !! NC_DISKLESS data from memory to a file), NC_MMAP (use MMAP for
    !! NC_DISKLESS instead of NC_INMEMORY – deprecated). See discussion below.
    integer(c_int), intent(out) :: ncidp
    !! Pointer to location where returned netCDF ID is to be stored.
    integer(c_int) :: nc_create
    !! **Options:**
    !! - NC_NOERR No error.
    !! - NC_EEXIST Specifying a file name of a file that exists and also
    !!   specifying NC_NOCLOBBER.
    !! - NC_EPERM Attempting to create a netCDF file in a directory where you
    !!   do not have permission to create files.
    !! - NC_ENOMEM System out of memory.
    !! - NC_ENFILE Too many files open.
    !! - NC_EHDFERR HDF5 error (netCDF-4 files only).
    !! - NC_EFILEMETA Error writing netCDF-4 file-level metadata in HDF5 file.
    !!   (netCDF-4 files only).
    !! - NC_EDISKLESS if there was an error in creating the in-memory file.
  end function nc_create

  function nc_close(ncid) bind(c, name="nc_close")
    !! Close an open netCDF dataset.
    import :: c_int
    integer(c_int), value :: ncid
    !! NetCDF ID, from a previous call to nc_open() or nc_create().
    integer(c_int) :: nc_close
    !! **Options:**
    !! - NC_NOERR No error.
    !! - NC_EBADID Invalid id passed.
    !! - NC_EBADGRPID ncid did not contain the root group id of this file.
    !!   (NetCDF-4 only).
  end function nc_close

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

  function nc_inq_varids(ncid, nvars, varids) bind(c, name="nc_inq_varids")
    !! Return local variable identifiers, or only their count when NULL.
    import :: c_int, c_ptr
    integer(c_int), value :: ncid
    !! Group identifier whose locally declared variables are queried.
    integer(c_int), intent(out) :: nvars
    !! Returned number of locally declared variables.
    type(c_ptr), value :: varids
    !! Caller-allocated array of `nvars` variable IDs, or C NULL to query only
    !! the number of variables.
    integer(c_int) :: nc_inq_varids
    !! **Options:**
    !! - NC_NOERR No error.
    !! - NC_EBADID Bad ncid.
  end function nc_inq_varids

  function nc_inq_varname(ncid, varid, name) bind(c, name="nc_inq_varname")
    !! Return a variable's local name.
    import :: c_int, c_char
    integer(c_int), value :: ncid
    !! File or group identifier that scopes `varid`.
    integer(c_int), value :: varid
    !! Identifier of the variable to name.
    character(kind=c_char), intent(out) :: name(*)
    !! Caller-allocated name buffer of at least `NC_MAX_NAME + 1` characters.
    integer(c_int) :: nc_inq_varname
    !! **Options:**
    !! - NC_NOERR No error.
    !! - NC_EBADID Bad ncid.
    !! - NC_ENOTVAR Invalid variable ID.
  end function nc_inq_varname

  function nc_inq_att(ncid, varid, name, xtypep, lenp) &
    & bind(c, name="nc_inq_att")
    !! Return information about a netCDF attribute.
    import :: c_int, c_char, c_size_t
    integer(c_int), value :: ncid
    !! NetCDF or group ID, from a previous call to nc_open(), nc_create(),
    !! nc_def_grp(), or associated inquiry functions such as nc_inq_ncid().
    integer(c_int), value :: varid
    !! Variable ID of the attribute's variable, or NC_GLOBAL for a global
    !! attribute.
    character(kind=c_char), intent(in) :: name
    !! Pointer to the location for the returned attribute NetCDF Names.
    !! Ignored if NULL.
    integer(c_int), intent(out) :: xtypep
    !! Pointer to location for returned attribute data type. Ignored if NULL.
    integer(c_size_t), intent(out) :: lenp
    !! Pointer to location for returned number of values currently stored in
    !! the attribute. For attributes of type NC_CHAR, you should not assume
    !! that this includes a trailing zero byte; it doesn't if the attribute was
    !! stored without a trailing zero byte, for example from a FORTRAN program.
    !! Before using the value as a C string, make sure it is null-terminated.
    !! Ignored if NULL.
    integer(c_int) :: nc_inq_att
    !! **Options:**
    !! - NC_NOERR no error.
    !! - NC_EBADID bad ncid.
    !! - NC_ENOTVAR bad varid.
    !! - NC_EBADGRPID bad group ID.
    !! - NC_EBADNAME bad name.
    !! - NC_ENOTATT attribute not found.
    !! - NC_ECHAR illegal conversion to or from NC_CHAR.
    !! - NC_ENOMEM out of memory.
    !! - NC_ERANGE range error when converting data.
  end function nc_inq_att

  function nc_get_att(ncid, varid, name, value) bind(c, name="nc_get_att")
    !! Get an attribute of any type.
    import :: c_int, c_char, c_ptr
    integer(c_int), value :: ncid
    !! NetCDF file or group ID.
    integer(c_int), value :: varid
    !! Variable ID, or NC_GLOBAL for a global attribute.
    character(kind=c_char), intent(in) :: name(*)
    !! Attribute name.
    type(c_ptr), value :: value
    !! Pointer that will get array of attribute value(s). Use nc_inq_attlen()
    !! to learn length.
    integer(c_int) :: nc_get_att
    !! **Options:**
    !! - NC_NOERR for success.
    !! - NC_EBADID Bad ncid.
    !! - NC_ENOTVAR Bad varid.
    !! - NC_EBADNAME Bad name. See NetCDF Names.
    !! - NC_EINVAL Invalid parameters.
    !! - NC_ENOTATT Can't find attribute.
    !! - NC_ECHAR Can't convert to or from NC_CHAR.
    !! - NC_ENOMEM Out of memory.
    !! - NC_ERANGE Data conversion went out of range.
  end function nc_get_att

  function nc_inq_natts(ncid, nattsp) bind(c, name="nc_inq_natts")
    !! Find number of global or group attributes.
    import :: c_int
    integer(c_int), value :: ncid
    !! NetCDF or group ID, from a previous call to nc_open(), nc_create(),
    !! nc_def_grp(), or associated inquiry functions such as nc_inq_ncid().
    integer(c_int), intent(out) :: nattsp
    !! Pointer where number of global or group attributes will be written.
    !! Ignored if NULL.
    integer(c_int) :: nc_inq_natts
    !! **Options:**
    !! - NC_NOERR no error.
    !! - NC_EBADID bad ncid.
    !! - NC_EBADGRPID bad group ID.
  end function nc_inq_natts

  function nc_inq_var(ncid, varid, name, xtypep, ndimsp, dimidsp, nattsp) &
    & bind(c, name="nc_inq_var")
    !! Learn about a variable.
    import :: c_int, c_char
    integer(c_int), value :: ncid
    !! NetCDF or group ID, from a previous call to nc_open(), nc_create(),
    !! nc_def_grp(), or associated inquiry functions such as nc_inq_ncid().
    integer(c_int), value :: varid
    !! Variable ID
    character(kind=c_char), intent(out) :: name(*)
    !! Returned NetCDF Names of variable. Ignored if NULL.
    integer(c_int), intent(out) :: xtypep
    !! Pointer where typeid will be stored. Ignored if NULL.
    integer(c_int), intent(out) :: ndimsp
    !! Pointer where number of dimensions will be stored. Ignored if NULL.
    integer(c_int), intent(out) :: dimidsp(*)
    !! Pointer where array of dimension IDs will be stored. Ignored if NULL.
    integer(c_int), intent(out) :: nattsp
    !! Pointer where number of attributes will be stored. Ignored if NULL.
    integer(c_int) :: nc_inq_var
    !! **Options:**
    !! - NC_NOERR No error.
    !! - NC_EBADID Bad ncid.
    !! - NC_ENOTVAR Invalid variable ID.
  end function nc_inq_var

  function nc_inq_attname(ncid, varid, attnum, name) &
    & bind(c, name="nc_inq_attname")
    !! Find the name of an attribute.
    import :: c_int, c_char, c_ptr
    integer(c_int), value :: ncid
    !! NetCDF or group ID, from a previous call to nc_open(), nc_create(),
    !! nc_def_grp(), or associated inquiry functions such as nc_inq_ncid().
    integer(c_int), value :: varid
    !! Variable ID of the attribute's variable, or NC_GLOBAL for a global
    !! attribute.
    integer(c_int), value :: attnum
    !! Attribute number. The attributes for each variable are numbered from 0
    !! (the first attribute) to natts-1, where natts is the number of
    !! attributes for the variable, as returned from a call to
    !! nc_inq_varnatts().
    character(kind=c_char), intent(inout) :: name(*)
    !! Pointer to the location for the returned attribute NetCDF Names.
    integer(c_int) :: nc_inq_attname
    !! **Options:**
    !! - NC_NOERR no error.
    !! - NC_EBADID bad ncid.
    !! - NC_ENOTVAR bad varid.
    !! - NC_EBADGRPID bad group ID.
    !! - NC_EBADNAME bad name.
    !! - NC_ENOTATT attribute not found.
    !! - NC_ECHAR illegal conversion to or from NC_CHAR.
    !! - NC_ENOMEM out of memory.
    !! - NC_ERANGE range error when converting data.
  end function nc_inq_attname

  function nc_inq_varnatts(ncid, varid, nattsp) bind(c, name="nc_inq_varnatts")
    !! Learn how many attributes are associated with a variable.
    import :: c_int
    integer(c_int), value :: ncid
    !! NetCDF or group ID, from a previous call to nc_open(), nc_create(),
    !! nc_def_grp(), or associated inquiry functions such as nc_inq_ncid().
    integer(c_int), value :: varid
    !! Variable ID.
    integer(c_int), intent(out) :: nattsp
    !! Pointer where number of attributes will be stored. Ignored if NULL.
    integer(c_int) :: nc_inq_varnatts
    !! **Options:**
    !! - NC_NOERR No error.
    !! - NC_EBADID Bad ncid.
    !! - NC_ENOTVAR Invalid variable ID.
  end function nc_inq_varnatts

  function nc_put_att(ncid, varid, name, xtype, len, value) &
    & bind(c, name="nc_put_att")
    !! Write an attribute of any type.
    import :: c_int, c_char, c_size_t, c_ptr
    integer(c_int), value :: ncid
    !! NetCDF file or group ID.
    integer(c_int), value :: varid
    !! Variable ID, or NC_GLOBAL for a global attribute.
    character(kind=c_char), intent(in) :: name(*)
    !! Attribute NetCDF Names.
    integer(c_int), value :: xtype
    !! The type of attribute to write. Data will be converted to this type.
    integer(c_size_t), value :: len
    !! Number of values provided for the attribute.
    type(c_ptr), value :: value
    !! Pointer to one or more values.
    integer(c_int) :: nc_put_att
    !! **Options:**
    !! - NC_NOERR No error.
    !! - NC_EINVAL Invalid or global _FillValue.
    !! - NC_ENOTVAR Couldn't find varid.
    !! - NC_EBADTYPE Fill value and var must be same type.
    !! - NC_ENOMEM Out of memory
    !! - NC_ELATEFILL Too late to set fill value.
  end function nc_put_att

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
    !! returned character array will be null-terminated. Ignored if NULL.
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
    !! unlimited dimension, -1 will be stored here. Ignored if NULL.
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

  function nc_inq_varid(ncid, name, varidp) bind(c, name="nc_inq_varid")
    !! Find the ID of a variable, from the name.
    import :: c_int, c_char
    integer(c_int), value :: ncid
    !! NetCDF or group ID, from a previous call to nc_open(), nc_create(),
    !! nc_def_grp(), or associated inquiry functions such as nc_inq_ncid().
    character(kind=c_char), intent(in) :: name(*)
    !! Name of the variable.
    integer(c_int), intent(out) :: varidp
    !! Pointer to location for returned variable ID. Ignored if NULL.
    integer(c_int) :: nc_inq_varid
    !! **Options:**
    !! - NC_NOERR No error.
    !! - NC_EBADID Bad ncid.
    !! - NC_ENOTVAR Invalid variable ID.
  end function nc_inq_varid

  function nc_inq_vartype(ncid, varid, typep) bind(c, name="nc_inq_vartype")
    !! Learn the type of a variable.
    import :: c_int
    integer(c_int), value :: ncid
    !! NetCDF or group ID, from a previous call to nc_open(), nc_create(),
    !! nc_def_grp(), or associated inquiry functions such as nc_inq_ncid().
    integer(c_int), value :: varid
    !! Variable ID.
    integer(c_int), intent(out) :: typep
    !! Pointer where typeid will be stored. Ignored if NULL.
    integer(c_int) :: nc_inq_vartype
    !! **Options:**
    !! - NC_NOERR No error.
    !! - NC_EBADID Bad ncid.
    !! - NC_ENOTVAR Invalid variable ID.
  end function nc_inq_vartype

  function nc_inq_vardimid(ncid, varid, dimidsp) bind(c, name="nc_inq_vardimid")
    !! Learn the dimension IDs associated with a variable.
    import :: c_int
    integer(c_int), value :: ncid
    !! NetCDF or group ID, from a previous call to nc_open(), nc_create(),
    !! nc_def_grp(), or associated inquiry functions such as nc_inq_ncid().
    integer(c_int), value :: varid
    !! Variable ID.
    integer(c_int), intent(out) :: dimidsp(*)
    !! Pointer where array of dimension IDs will be stored. Ignored if NULL.
    integer(c_int) :: nc_inq_vardimid
    !! **Options:**
    !! - NC_NOERR No error.
    !! - NC_EBADID Bad ncid.
    !! - NC_ENOTVAR Invalid variable ID.
  end function nc_inq_vardimid

  function nc_inq_varndims(ncid, varid, ndimsp) bind(c, name="nc_inq_varndims")
    !! Learn how many dimensions are associated with a variable.
    import :: c_int
    integer(c_int), value :: ncid
    !! NetCDF or group ID, from a previous call to nc_open(), nc_create(),
    !! nc_def_grp(), or associated inquiry functions such as nc_inq_ncid().
    integer(c_int), value :: varid
    !! Variable ID.
    integer(c_int), intent(out) :: ndimsp
    !! Pointer where number of dimensions will be stored. Ignored if NULL.
    integer(c_int) :: nc_inq_varndims
    !! **Options:**
    !! - NC_NOERR No error.
    !! - NC_EBADID Bad ncid.
    !! - NC_ENOTVAR Invalid variable ID.
  end function nc_inq_varndims

  function nc_get_var(ncid, varid, ip) bind(c, name="nc_get_var")
    !! Read an entire variable in one call.
    import :: c_int, c_ptr
    integer(c_int), value :: ncid
    !! NetCDF or group ID, from a previous call to nc_open(), nc_create(),
    !! nc_def_grp(), or associated inquiry functions such as nc_inq_ncid().
    integer(c_int), value :: varid
    !! Variable ID.
    type(c_ptr), value :: ip
    !! Pointer where the data will be copied. Memory must be allocated by the
    !! user before this function is called.
    integer(c_int) :: nc_get_var
    !! **Options:**
    !! - NC_NOERR No error.
    !! - NC_ENOTVAR Variable not found.
    !! - NC_ERANGE One or more of the values are out of range.
    !! - NC_EINDEFINE Operation not allowed in define mode.
    !! - NC_EBADID Bad ncid.
  end function nc_get_var

  function nc_get_vars(ncid, varid, startp, countp, stridep, ip) &
    & bind(c, name="nc_get_vars")
    !! Read a strided hyperslab of a variable.
    import :: c_int, c_ptr
    integer(c_int), value :: ncid
    !! NetCDF or group ID, from a previous open or inquiry call.
    integer(c_int), value :: varid
    !! Variable ID.
    type(c_ptr), value :: startp
    !! Pointer to zero-based C-order start indices (`size_t *`).
    type(c_ptr), value :: countp
    !! Pointer to C-order edge lengths (`size_t *`).
    type(c_ptr), value :: stridep
    !! Pointer to C-order strides (`ptrdiff_t *`).
    type(c_ptr), value :: ip
    !! Pointer where the data will be copied.
    integer(c_int) :: nc_get_vars
    !! NetCDF status code.
  end function nc_get_vars

  function nc_def_var(ncid, name, xtype, ndims, dimidsp, varidp) &
    & bind(c, name="nc_def_var")
    !! Define a new variable.
    import :: c_int, c_char
    integer(c_int), value :: ncid
    !! NetCDF or group ID, from a previous call to nc_open(), nc_create(),
    !! nc_def_grp(), or associated inquiry functions such as nc_inq_ncid().
    character(kind=c_char), intent(in) :: name(*)
    !! Variable NetCDF Names.
    integer(c_int), value :: xtype
    !! (Data type)
    !! [https://docs.unidata.ucar.edu/nug/current/md_types.html#data_type]
    !! of the variable.
    integer(c_int), value :: ndims
    !! Number of dimensions for the variable. For example, 2 specifies a
    !! matrix, 1 specifies a vector, and 0 means the variable is a scalar with
    !! no dimensions. Must not be negative or greater than the predefined
    !! constant NC_MAX_VAR_DIMS. In netCDF-4/HDF5 files, may not exceed the
    !! HDF5 maximum number of dimensions (32).
    integer(c_int), intent(in) :: dimidsp(*)
    !! Vector of ndims dimension IDs corresponding to the variable dimensions.
    !! For classic model netCDF files, if the ID of the unlimited dimension is
    !! included, it must be first. This argument is ignored if ndims is 0. For
    !! expanded model netCDF4/HDF5 files, there may be any number of unlimited
    !! dimensions, and they may be used in any element of the dimids array.
    integer(c_int), intent(out) :: varidp
    !! Pointer to location for the returned variable ID.
    integer(c_int) :: nc_def_var
    !! **Options:**
    !! - NC_NOERR No error.
    !! - NC_EBADID Bad ncid.
    !! - NC_ENOTINDEFINE Not in define mode.
    !! - NC_ESTRICTNC3 Attempting netcdf-4 operation on strict nc3
    !!   netcdf-4 file.
    !! - NC_EMAXVARS NC_MAX_VARS exceeded [Not enforced after 4.5.0]
    !! - NC_EBADTYPE Bad type.
    !! - NC_EINVAL Invalid input.
    !! - NC_ENAMEINUSE Name already in use.
    !! - NC_EPERM Attempt to create object in read-only file.
  end function nc_def_var

  function nc_put_var(ncid, varid, op) bind(c, name="nc_put_var")
    !! Write an entire variable with one call.
    import :: c_int, c_ptr
    integer(c_int), value :: ncid
    !! NetCDF or group ID, from a previous call to nc_open(), nc_create(),
    !! nc_def_grp(), or associated inquiry functions such as nc_inq_ncid().
    integer(c_int), value :: varid
    !! Variable ID.
    type(c_ptr), value :: op
    !! Pointer from where the data will be copied.
    integer(c_int) :: nc_put_var
    !! **Options:**
    !! - NC_NOERR No error.
    !! - NC_ENOTVAR Variable not found.
    !! - NC_EINVALCOORDS Index exceeds dimension bound.
    !! - NC_EEDGE Start+count exceeds dimension bound.
    !! - NC_ERANGE One or more of the values are out of range.
    !! - NC_EINDEFINE Operation not allowed in define mode.
    !! - NC_EBADID Bad ncid.
  end function nc_put_var

  function nc_put_vara(ncid, varid, startp, countp, op) &
    & bind(c, name="nc_put_vara")
    !! Write a contiguous hyperslab of a variable.
    import :: c_int, c_ptr
    integer(c_int), value :: ncid
    !! NetCDF or group ID, from a previous open or create call.
    integer(c_int), value :: varid
    !! Variable ID.
    type(c_ptr), value :: startp
    !! Pointer to zero-based C-order start indices (`size_t *`).
    type(c_ptr), value :: countp
    !! Pointer to C-order edge lengths (`size_t *`).
    type(c_ptr), value :: op
    !! Pointer from where the data will be copied.
    integer(c_int) :: nc_put_vara
    !! NetCDF status code.
  end function nc_put_vara
end interface

end module nc4f_c_interface
