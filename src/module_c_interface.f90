module module_c_interface

use, intrinsic :: iso_c_binding, only: c_int, c_ptr, c_char, c_size_t, c_long
implicit none (type, external)
public

!> Set read-only access for nc_open().
integer(c_int), parameter :: NC_NOWRITE = int(z'0000', kind=c_int)
!> Set read-write access for nc_open().
integer(c_int), parameter :: NC_WRITE = int(z'0001', kind=c_int)
!> Destroy existing file. Mode flag for nc_create().
integer(c_int), parameter :: NC_CLOBBER = int(z'0000', kind=c_int)
!> Don't destroy existing file. Mode flag for nc_create().
integer(c_int), parameter :: NC_NOCLOBBER = int(z'0004', kind=c_int)
!> Use netCDF-4/HDF5 format. Mode flag for nc_create().
integer(c_int), parameter :: NC_NETCDF4 = int(z'1000', kind=c_int)

!> No Error
integer(c_int), parameter :: NC_NOERR = 0_c_int
integer(c_int), parameter :: NC_MAX_NAME = 256_c_int

!> not enforced after 4.5.0
integer(c_int), parameter :: NC_MAX_DIMS = 1024_c_int
!> Attribute id to put/get a global attribute.
integer(c_int), parameter :: NC_GLOBAL = -1_c_int
!> Size argument to nc_def_dim() for an unlimited dimension.
integer(c_long), parameter :: NC_UNLIMITED = 0_c_long

!> Not A Type
integer(c_int), parameter :: NC_NAT = 0_c_int
!> signed 1 byte integer
integer(c_int), parameter :: NC_BYTE = 1_c_int
!> ISO/ASCII character
integer(c_int), parameter :: NC_CHAR = 2_c_int
!> signed 2 byte integer
integer(c_int), parameter :: NC_SHORT = 3_c_int
!> signed 4 byte integer
integer(c_int), parameter :: NC_INT = 4_c_int
!> single precision floating point number
integer(c_int), parameter :: NC_FLOAT = 5_c_int
!> double precision floating point number
integer(c_int), parameter :: NC_DOUBLE = 6_c_int
!> unsigned 1 byte int
integer(c_int), parameter :: NC_UBYTE = 7_c_int ! N/A
!> unsigned 2-byte int
integer(c_int), parameter :: NC_USHORT = 8_c_int ! N/A
!> unsinged 4-byte int
integer(c_int), parameter :: NC_UINT = 9_c_int ! N/A
!> signed 8-byte int
integer(c_int), parameter :: NC_INT64 = 10_c_int
!> unsigned 8-byte int
integer(c_int), parameter :: NC_UINT64 = 11_c_int ! N/A
!> string
integer(c_int), parameter :: NC_STRING = 12_c_int ! N/A

interface
  !> Given an error number, return an error message.
  function nc_strerror(ncerr1) bind(c, name="nc_strerror")
    import :: c_int, c_ptr
    !> error number
    integer(c_int), value :: ncerr1
    !> short string containing error message.
    type(c_ptr) :: nc_strerror
  end function nc_strerror

  !> Open an existing netCDF file.
  function nc_open(path, mode, ncidp) bind(c, name="nc_open")
    import :: c_char, c_int
    !> File name for netCDF dataset to be opened. When the dataset is located
    !> on some remote server, then the path may be an OPeNDAP URL rather than a
    !> file path.
    character(kind=c_char), intent(in) :: path(*)
    !> The open mode flag may include NC_WRITE (for read/write access) and
    !> NC_SHARE (see below) and NC_DISKLESS (see below).
    integer(c_int), value :: mode
    !> Pointer to location where returned netCDF ID is to be stored.
    integer(c_int), intent(out) :: ncidp
    !> Options:
    !> - NC_NOERR No error.
    !> - NC_EPERM Attempting to create a netCDF file in a
    !>  directory where you do not have permission to open files.
    !> - NC_ENFILE Too many files open.
    !> - NC_ENOMEM Out of memory.
    !> - NC_EHDFERR HDF5 error. (NetCDF-4 files only.)
    !> - NC_EDIMMETA Error in netCDF-4 dimension metadata. (NetCDF-4 files
    !>  only.)
    integer(c_int) :: nc_open
  end function nc_open

  !> Create a new netCDF file.
  function nc_create(path, cmode, ncidp) bind(c, name="nc_create")
    import :: c_char, c_int
    !> The file name of the new netCDF dataset.
    character(kind=c_char), intent(in) :: path(*)
    !> The creation mode flag. The following flags are available: NC_CLOBBER
    !> (overwrite existing file), NC_NOCLOBBER (do not overwrite existing
    !> file), NC_SHARE (limit write caching - netcdf classic files only),
    !> NC_64BIT_OFFSET (create 64-bit offset file), NC_64BIT_DATA (alias
    !> NC_CDF5) (create CDF-5 file), NC_NETCDF4 (create netCDF-4/HDF5 file),
    !> NC_CLASSIC_MODEL (enforce netCDF classic mode on netCDF-4/HDF5 files),
    !> NC_DISKLESS (store data in memory), and NC_PERSIST (force the
    !> NC_DISKLESS data from memory to a file), NC_MMAP (use MMAP for
    !> NC_DISKLESS instead of NC_INMEMORY – deprecated). See discussion below.
    integer(c_int), value :: cmode
    !> Pointer to location where returned netCDF ID is to be stored.
    integer(c_int), intent(out) :: ncidp
    !> Options:
    !> - NC_NOERR No error.
    !> - NC_EEXIST Specifying a file name of a file that exists and also
    !>  specifying NC_NOCLOBBER.
    !> - NC_EPERM Attempting to create a netCDF file in a directory where you
    !>  do not have permission to create files.
    !> - NC_ENOMEM System out of memory.
    !> - NC_ENFILE Too many files open.
    !> - NC_EHDFERR HDF5 error (netCDF-4 files only).
    !> - NC_EFILEMETA Error writing netCDF-4 file-level metadata in HDF5 file.
    !>  (netCDF-4 files only).
    !> - NC_EDISKLESS if there was an error in creating the in-memory file.
    integer(c_int) :: nc_create
  end function nc_create

  !> Close an open netCDF dataset.
  function nc_close(ncid) bind(c, name="nc_close")
    import :: c_int
    !> NetCDF ID, from a previous call to nc_open() or nc_create().
    integer(c_int), value :: ncid
    !> Options:
    !> - NC_NOERR No error.
    !> - NC_EBADID Invalid id passed.
    !> - NC_EBADGRPID ncid did not contain the root group id of this file.
    !>  (NetCDF-4 only).
    integer(c_int) :: nc_close
  end function nc_close

  !> Return information about a netCDF attribute.
  function nc_inq_att(ncid, varid, name, xtypep, lenp) &
    & bind(c, name="nc_inq_att")
    import :: c_int, c_char, c_size_t
    !> NetCDF or group ID, from a previous call to nc_open(), nc_create(),
    !> nc_def_grp(), or associated inquiry functions such as nc_inq_ncid().
    integer(c_int), value :: ncid
    !> Variable ID of the attribute's variable, or NC_GLOBAL for a global
    !> attribute.
    integer(c_int), value :: varid
    !> Pointer to the location for the returned attribute NetCDF Names.
    !> Ignored if NULL.
    character(kind=c_char), intent(in) :: name(*)
    !> Pointer to location for returned attribute data type. Ignored if NULL.
    integer(c_int), intent(out) :: xtypep
    !> Pointer to location for returned number of values currently stored in
    !> the attribute. For attributes of type NC_CHAR, you should not assume
    !> that this includes a trailing zero byte; it doesn't if the attribute was
    !> stored without a trailing zero byte, for example from a FORTRAN program.
    !> Before using the value as a C string, make sure it is null-terminated.
    !> Ignored if NULL.
    integer(c_size_t), intent(out) :: lenp
    !> Options:
    !> - NC_NOERR no error.
    !> - NC_EBADID bad ncid.
    !> - NC_ENOTVAR bad varid.
    !> - NC_EBADGRPID bad group ID.
    !> - NC_EBADNAME bad name.
    !> - NC_ENOTATT attribute not found.
    !> - NC_ECHAR illegal conversion to or from NC_CHAR.
    !> - NC_ENOMEM out of memory.
    !> - NC_ERANGE range error when converting data.
    integer(c_int) :: nc_inq_att
  end function nc_inq_att

  !> Get an attribute of any type.
  function nc_get_att(ncid, varid, name, value) bind(c, name="nc_get_att")
    import :: c_int, c_char, c_ptr
    !> NetCDF file or group ID.
    integer(c_int), value :: ncid
    !> Variable ID, or NC_GLOBAL for a global attribute.
    integer(c_int), value :: varid
    !> Attribute name.
    character(kind=c_char), intent(in) :: name(*)
    !> Pointer that will get array of attribute value(s). Use nc_inq_attlen()
    !> to learn length.
    type(c_ptr), value :: value
    !> Options:
    !> - NC_NOERR for success.
    !> - NC_EBADID Bad ncid.
    !> - NC_ENOTVAR Bad varid.
    !> - NC_EBADNAME Bad name. See NetCDF Names.
    !> - NC_EINVAL Invalid parameters.
    !> - NC_ENOTATT Can't find attribute.
    !> - NC_ECHAR Can't convert to or from NC_CHAR.
    !> - NC_ENOMEM Out of memory.
    !> - NC_ERANGE Data conversion went out of range.
    integer(c_int) :: nc_get_att
  end function nc_get_att

  !> Find number of global or group attributes.
  function nc_inq_natts(ncid, nattsp) bind(c, name="nc_inq_natts")
    import :: c_int
    !> NetCDF or group ID, from a previous call to nc_open(), nc_create(),
    !> nc_def_grp(), or associated inquiry functions such as nc_inq_ncid().
    integer(c_int), value :: ncid
    !> Pointer where number of global or group attributes will be written.
    !> Ignored if NULL.
    integer(c_int), intent(out) :: nattsp
    !> Options:
    !> - NC_NOERR no error.
    !> - NC_EBADID bad ncid.
    !> - NC_EBADGRPID bad group ID.
    integer(c_int) :: nc_inq_natts
  end function nc_inq_natts

  !> Learn about a variable.
  function nc_inq_var(ncid, varid, name, xtypep, ndimsp, dimidsp, nattsp) &
    & bind(c, name="nc_inq_var")
    import :: c_int, c_char
    !> NetCDF or group ID, from a previous call to nc_open(), nc_create(),
    !> nc_def_grp(), or associated inquiry functions such as nc_inq_ncid().
    integer(c_int), value :: ncid
    !> Variable ID
    integer(c_int), value :: varid
    !> Returned NetCDF Names of variable. Ignored if NULL.
    character(kind=c_char), intent(out) :: name(*)
    !> Pointer where typeid will be stored. Ignored if NULL.
    integer(c_int), intent(out) :: xtypep
    !> Pointer where number of dimensions will be stored. Ignored if NULL.
    integer(c_int), intent(out) :: ndimsp
    !> Pointer where array of dimension IDs will be stored. Ignored if NULL.
    integer(c_int), intent(out) :: dimidsp(*)
    !> Pointer where number of attributes will be stored. Ignored if NULL.
    integer(c_int), intent(out) :: nattsp
    !> Options:
    !> - NC_NOERR No error.
    !> - NC_EBADID Bad ncid.
    !> - NC_ENOTVAR Invalid variable ID.
    integer(c_int) :: nc_inq_var
  end function nc_inq_var

  !> Find the name of an attribute.
  function nc_inq_attname(ncid, varid, attnum, name) &
    & bind(c, name="nc_inq_attname")
    import :: c_int, c_char, c_ptr
    !> NetCDF or group ID, from a previous call to nc_open(), nc_create(),
    !> nc_def_grp(), or associated inquiry functions such as nc_inq_ncid().
    integer(c_int), value :: ncid
    !> Variable ID of the attribute's variable, or NC_GLOBAL for a global
    !> attribute.
    integer(c_int), value :: varid
    !> Attribute number. The attributes for each variable are numbered from 0
    !> (the first attribute) to natts-1, where natts is the number of
    !> attributes for the variable, as returned from a call to
    !> nc_inq_varnatts().
    integer(c_int), value :: attnum
    !> Pointer to the location for the returned attribute NetCDF Names.
    character(kind=c_char), intent(inout) :: name(*)
    !> Options:
    !> - NC_NOERR no error.
    !> - NC_EBADID bad ncid.
    !> - NC_ENOTVAR bad varid.
    !> - NC_EBADGRPID bad group ID.
    !> - NC_EBADNAME bad name.
    !> - NC_ENOTATT attribute not found.
    !> - NC_ECHAR illegal conversion to or from NC_CHAR.
    !> - NC_ENOMEM out of memory.
    !> - NC_ERANGE range error when converting data.
    integer(c_int) :: nc_inq_attname
  end function nc_inq_attname

  !> Learn how many attributes are associated with a variable.
  function nc_inq_varnatts(ncid, varid, nattsp) bind(c, name="nc_inq_varnatts")
    import :: c_int
    !> NetCDF or group ID, from a previous call to nc_open(), nc_create(),
    !> nc_def_grp(), or associated inquiry functions such as nc_inq_ncid().
    integer(c_int), value :: ncid
    !> Variable ID.
    integer(c_int), value :: varid
    !> Pointer where number of attributes will be stored. Ignored if NULL.
    integer(c_int), intent(out) :: nattsp
    !> Options:
    !> - NC_NOERR No error.
    !> - NC_EBADID Bad ncid.
    !> - NC_ENOTVAR Invalid variable ID.
    integer(c_int) :: nc_inq_varnatts
  end function nc_inq_varnatts

  !> Write an attribute of any type.
  function nc_put_att(ncid, varid, name, xtype, len, value) &
    & bind(c, name="nc_put_att")
    import :: c_int, c_char, c_size_t, c_ptr
    !> NetCDF file or group ID.
    integer(c_int), value :: ncid
    !> Variable ID, or NC_GLOBAL for a global attribute.
    integer(c_int), value :: varid
    !>         Attribute NetCDF Names.
    character(kind=c_char), intent(in) :: name(*)
    !> The type of attribute to write. Data will be converted to this type.
    integer(c_int), value :: xtype
    !> Number of values provided for the attribute.
    integer(c_size_t), value :: len
    !> Pointer to one or more values.
    type(c_ptr), value :: value
    !> Options:
    !> - NC_NOERR No error.
    !> - NC_EINVAL Invalid or global _FillValue.
    !> - NC_ENOTVAR Couldn't find varid.
    !> - NC_EBADTYPE Fill value and var must be same type.
    !> - NC_ENOMEM Out of memory
    !> - NC_ELATEFILL Too late to set fill value.
    integer(c_int) :: nc_put_att
  end function nc_put_att

  !> Find the length of a dimension.
  function nc_inq_dimlen(ncid, dimid, lenp) bind(c, name="nc_inq_dimlen")
    import :: c_int, c_size_t
    !> NetCDF or group ID, from a previous call to nc_open(), nc_create(),
    !> nc_def_grp(), or associated inquiry functions such as nc_inq_ncid().
    integer(c_int), value :: ncid
    !> Dimension ID, from a previous call to nc_inq_dimid() or nc_def_dim().
    integer(c_int), value :: dimid
    !> Pointer where the length will be stored.
    integer(c_size_t), intent(out) :: lenp
    !> Options:
    !> - NC_NOERR No error.
    !> - NC_EBADID Not a valid ID.
    !> - NC_EBADDIM Invalid dimension ID or name.
    integer(c_int) :: nc_inq_dimlen
  end function nc_inq_dimlen

  !> Retrieve a list of dimension ids associated with a group.
  function nc_inq_dimids(ncid, ndims, dimids, include_parents) &
    & bind(c, name="nc_inq_dimids")
    import :: c_int
    !> The ncid of the group in question.
    integer(c_int), value :: ncid
    !> Pointer to memory to contain the number of dimids associated with the
    !> group.
    integer(c_int), intent(out) :: ndims
    !> Pointer to memory to contain the number of dimensions associated with
    !> the group.
    integer(c_int), intent(out) :: dimids(*)
    !> If non-zero, parent groups are also traversed.
    integer(c_int), value :: include_parents
    !> Error code or NC_NOERR for no error.
    integer(c_int) :: nc_inq_dimids
  end function nc_inq_dimids

  !> Find the ID of a dimension from the name.
  function nc_inq_dimid(ncid, name, idp) bind(c, name="nc_inq_dimid")
    import :: c_int, c_char
    !> NetCDF or group ID, from a previous call to nc_open(), nc_create(),
    !> nc_def_grp(), or associated inquiry functions such as nc_inq_ncid().
    integer(c_int), value :: ncid
    !> Name of the dimension.
    character(kind=c_char), intent(in) :: name(*)
    !> Pointer where dimension ID will be stored.
    integer(c_int), intent(out) :: idp
    !> Options:
    !> - NC_NOERR No error.
    !> - NC_EBADID Not a valid ID.
    !> - NC_EBADDIM Invalid dimension ID.
    integer(c_int) :: nc_inq_dimid
  end function nc_inq_dimid

  !> Find out the name of a dimension.
  function nc_inq_dimname(ncid, dimid, name) bind(c, name="nc_inq_dimname")
    import :: c_int, c_char
    !> NetCDF or group ID, from a previous call to nc_open(), nc_create(),
    !> nc_def_grp(), or associated inquiry functions such as nc_inq_ncid().
    integer(c_int), value :: ncid
    !> Dimension ID, from a previous call to nc_inq_dimid() or nc_def_dim().
    integer(c_int), value :: dimid
    !> Returned dimension name. The caller must allocate space for the returned
    !> name. The maximum possible length, in characters, of a dimension name is
    !> given by the predefined constant NC_MAX_NAME. (This doesn't include the
    !> null terminator, so declare your array to be size NC_MAX_NAME+1). The
    !> returned character array will be null-terminated. Ignored if NULL.
    character(kind=c_char), intent(out) :: name(*)
    !> Options:
    !> - NC_NOERR No error.
    !> - NC_EBADID Not a valid ID.
    !> - NC_EBADDIM Invalid dimension ID or name.
    integer(c_int) :: nc_inq_dimname
  end function nc_inq_dimname

  !> Find the ID of the unlimited dimension.
  function nc_inq_unlimdim(ncid, unlimdimidp) bind(c, name="nc_inq_unlimdim")
    import :: c_int
    !> NetCDF or group ID, from a previous call to nc_open(), nc_create(),
    !> nc_def_grp(), or associated inquiry functions such as nc_inq_ncid().
    integer(c_int), value :: ncid
    !> Pointer where unlimited dimension ID will be stored. If there is no
    !> unlimited dimension, -1 will be stored here. Ignored if NULL.
    integer(c_int), intent(out) :: unlimdimidp
    !> Options:
    !> - NC_NOERR No error.
    !> - NC_EBADID Not a valid ID.
    integer(c_int) :: nc_inq_unlimdim
  end function nc_inq_unlimdim

  !> Define a new dimension.
  function nc_def_dim(ncid, name, len, idp) bind(c, name="nc_def_dim")
    import :: c_int, c_char, c_size_t
    !> NetCDF or group ID, from a previous call to nc_open(), nc_create(),
    !> nc_def_grp(), or associated inquiry functions such as nc_inq_ncid().
    integer(c_int), value :: ncid
    !> Name of the dimension to be created.
    character(kind=c_char), intent(in) :: name
    !> Length of the dimension to be created. Use NC_UNLIMITED for unlimited
    !> dimensions.
    integer(c_size_t), value :: len
    !> Pointer where dimension ID will be stored.
    integer(c_int), intent(inout) :: idp
    !> Options:
    !> - NC_NOERR No error.
    !> - NC_EBADID Not a valid ID.
    !> - NC_EMAXNAME Name is too long.
    !> - NC_EBADNAME Name breaks netCDF name rules.
    !> - NC_EINVAL Invalid input.
    !> - NC_ENOTINDEFINE Not in define mode.
    !> - NC_EDIMSIZE Invalid dimension size.
    !> - NC_EUNLIMIT NC_UNLIMITED size already in use
    !> - NC_EMAXDIMS NC_MAX_DIMS exceeded [not enforced after 4.5.0]
    !> - NC_ENAMEINUSE String match to name in use
    !> - NC_ENOMEM Memory allocation (malloc) failure
    !> - NC_EPERM Write to read only
    integer(c_int) :: nc_def_dim
  end function nc_def_dim

  !> Find the ID of a variable, from the name.
  function nc_inq_varid(ncid, name, varidp) bind(c, name="nc_inq_varid")
    import :: c_int, c_char
    !> NetCDF or group ID, from a previous call to nc_open(), nc_create(),
    !> nc_def_grp(), or associated inquiry functions such as nc_inq_ncid().
    integer(c_int), value :: ncid
    !> Name of the variable.
    character(kind=c_char), intent(in) :: name(*)
    !> Pointer to location for returned variable ID. Ignored if NULL.
    integer(c_int), intent(out) :: varidp
    !> Options:
    !> - NC_NOERR No error.
    !> - NC_EBADID Bad ncid.
    !> - NC_ENOTVAR Invalid variable ID.
    integer(c_int) :: nc_inq_varid
  end function nc_inq_varid

  !> Learn the type of a variable.
  function nc_inq_vartype(ncid, varid, typep) bind(c, name="nc_inq_vartype")
    import :: c_int
    !> NetCDF or group ID, from a previous call to nc_open(), nc_create(),
    !> nc_def_grp(), or associated inquiry functions such as nc_inq_ncid().
    integer(c_int), value :: ncid
    !> Variable ID.
    integer(c_int), value :: varid
    !> Pointer where typeid will be stored. Ignored if NULL.
    integer(c_int), intent(out) :: typep
    !> Options:
    !> - NC_NOERR No error.
    !> - NC_EBADID Bad ncid.
    !> - NC_ENOTVAR Invalid variable ID.
    integer(c_int) :: nc_inq_vartype
  end function nc_inq_vartype

  !> Learn the dimension IDs associated with a variable.
  function nc_inq_vardimid(ncid, varid, dimidsp) bind(c, name="nc_inq_vardimid")
    import :: c_int
    !> NetCDF or group ID, from a previous call to nc_open(), nc_create(),
    !> nc_def_grp(), or associated inquiry functions such as nc_inq_ncid().
    integer(c_int), value :: ncid
    !> Variable ID.
    integer(c_int), value :: varid
    !> Pointer where array of dimension IDs will be stored. Ignored if NULL.
    integer(c_int), intent(out) :: dimidsp(*)
    !> Options:
    !> - NC_NOERR No error.
    !> - NC_EBADID Bad ncid.
    !> - NC_ENOTVAR Invalid variable ID.
    integer(c_int) :: nc_inq_vardimid
  end function nc_inq_vardimid

  !> Learn how many dimensions are associated with a variable.
  function nc_inq_varndims(ncid, varid, ndimsp) bind(c, name="nc_inq_varndims")
    import :: c_int
    !> NetCDF or group ID, from a previous call to nc_open(), nc_create(),
    !> nc_def_grp(), or associated inquiry functions such as nc_inq_ncid().
    integer(c_int), value :: ncid
    !> Variable ID.
    integer(c_int), value :: varid
    !> Pointer where number of dimensions will be stored. Ignored if NULL.
    integer(c_int), intent(out) :: ndimsp
    !> Options:
    !> - NC_NOERR No error.
    !> - NC_EBADID Bad ncid.
    !> - NC_ENOTVAR Invalid variable ID.
    integer(c_int) :: nc_inq_varndims
  end function nc_inq_varndims

  !> Read an entire variable in one call.
  function nc_get_var(ncid, varid, ip) bind(c, name="nc_get_var")
    import :: c_int, c_ptr
    !> NetCDF or group ID, from a previous call to nc_open(), nc_create(),
    !> nc_def_grp(), or associated inquiry functions such as nc_inq_ncid().
    integer(c_int), value :: ncid
    !> Variable ID.
    integer(c_int), value :: varid
    !> Pointer where the data will be copied. Memory must be allocated by the
    !> user before this function is called.
    type(c_ptr), value :: ip
    !> Options:
    !> - NC_NOERR No error.
    !> - NC_ENOTVAR Variable not found.
    !> - NC_ERANGE One or more of the values are out of range.
    !> - NC_EINDEFINE Operation not allowed in define mode.
    !> - NC_EBADID Bad ncid.
    integer(c_int) :: nc_get_var
  end function nc_get_var

  !> Define a new variable.
  function nc_def_var(ncid, name, xtype, ndims, dimidsp, varidp) &
    & bind(c, name="nc_def_var")
    import :: c_int, c_char
    !> NetCDF or group ID, from a previous call to nc_open(), nc_create(),
    !> nc_def_grp(), or associated inquiry functions such as nc_inq_ncid().
    integer(c_int), value :: ncid
    !> Variable NetCDF Names.
    character(kind=c_char), intent(in) :: name(*)
    !> (Data type)
    !> [https://docs.unidata.ucar.edu/nug/current/md_types.html#data_type]
    !> of the variable.
    integer(c_int), value :: xtype
    !> Number of dimensions for the variable. For example, 2 specifies a
    !> matrix, 1 specifies a vector, and 0 means the variable is a scalar with
    !> no dimensions. Must not be negative or greater than the predefined
    !> constant NC_MAX_VAR_DIMS. In netCDF-4/HDF5 files, may not exceed the
    !> HDF5 maximum number of dimensions (32).
    integer(c_int), value :: ndims
    !> Vector of ndims dimension IDs corresponding to the variable dimensions.
    !> For classic model netCDF files, if the ID of the unlimited dimension is
    !> included, it must be first. This argument is ignored if ndims is 0. For
    !> expanded model netCDF4/HDF5 files, there may be any number of unlimited
    !> dimensions, and they may be used in any element of the dimids array.
    integer(c_int), intent(in) :: dimidsp(*)
    !> Pointer to location for the returned variable ID.
    integer(c_int), intent(out) :: varidp
    !> Options:
    !> - NC_NOERR No error.
    !> - NC_EBADID Bad ncid.
    !> - NC_ENOTINDEFINE Not in define mode.
    !> - NC_ESTRICTNC3 Attempting netcdf-4 operation on strict nc3 netcdf-4 file.
    !> - NC_EMAXVARS NC_MAX_VARS exceeded [Not enforced after 4.5.0]
    !> - NC_EBADTYPE Bad type.
    !> - NC_EINVAL Invalid input.
    !> - NC_ENAMEINUSE Name already in use.
    !> - NC_EPERM Attempt to create object in read-only file.
    integer(c_int) :: nc_def_var
  end function nc_def_var

  !> Write an entire variable with one call.
  function nc_put_var(ncid, varid, op) bind(c, name="nc_put_var")
    import :: c_int, c_ptr
    !> NetCDF or group ID, from a previous call to nc_open(), nc_create(),
    !> nc_def_grp(), or associated inquiry functions such as nc_inq_ncid().
    integer(c_int), value :: ncid
    !> Variable ID.
    integer(c_int), value :: varid
    !> Pointer from where the data will be copied.
    type(c_ptr), value :: op
    !> Options:
    !> - NC_NOERR No error.
    !> - NC_ENOTVAR Variable not found.
    !> - NC_EINVALCOORDS Index exceeds dimension bound.
    !> - NC_EEDGE Start+count exceeds dimension bound.
    !> - NC_ERANGE One or more of the values are out of range.
    !> - NC_EINDEFINE Operation not allowed in define mode.
    !> - NC_EBADID Bad ncid.
    integer(c_int) :: nc_put_var
  end function nc_put_var
end interface

end module module_c_interface
