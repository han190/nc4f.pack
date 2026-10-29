! Variable schema, type inquiry, storage settings, and chunk caches.
! Included inside the interface block of nc4f_c_interface.

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
  !! Returned NetCDF Names of variable.
  integer(c_int), intent(out) :: xtypep
  !! Pointer where typeid will be stored.
  integer(c_int), intent(out) :: ndimsp
  !! Pointer where number of dimensions will be stored.
  integer(c_int), intent(out) :: dimidsp(*)
  !! Pointer where array of dimension IDs will be stored.
  integer(c_int), intent(out) :: nattsp
  !! Pointer where number of attributes will be stored.
  integer(c_int) :: nc_inq_var
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Bad ncid.
  !! - NC_ENOTVAR Invalid variable ID.
end function nc_inq_var

function nc_inq_varnatts(ncid, varid, nattsp) bind(c, name="nc_inq_varnatts")
  !! Learn how many attributes are associated with a variable.
  import :: c_int
  integer(c_int), value :: ncid
  !! NetCDF or group ID, from a previous call to nc_open(), nc_create(),
  !! nc_def_grp(), or associated inquiry functions such as nc_inq_ncid().
  integer(c_int), value :: varid
  !! Variable ID.
  integer(c_int), intent(out) :: nattsp
  !! Pointer where number of attributes will be stored.
  integer(c_int) :: nc_inq_varnatts
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Bad ncid.
  !! - NC_ENOTVAR Invalid variable ID.
end function nc_inq_varnatts

function nc_inq_varid(ncid, name, varidp) bind(c, name="nc_inq_varid")
  !! Find the ID of a variable, from the name.
  import :: c_int, c_char
  integer(c_int), value :: ncid
  !! NetCDF or group ID, from a previous call to nc_open(), nc_create(),
  !! nc_def_grp(), or associated inquiry functions such as nc_inq_ncid().
  character(kind=c_char), intent(in) :: name(*)
  !! Name of the variable.
  integer(c_int), intent(out) :: varidp
  !! Pointer to location for returned variable ID.
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
  !! Pointer where typeid will be stored.
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
  !! Pointer where array of dimension IDs will be stored.
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
  !! Pointer where number of dimensions will be stored.
  integer(c_int) :: nc_inq_varndims
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Bad ncid.
  !! - NC_ENOTVAR Invalid variable ID.
end function nc_inq_varndims

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

function nc_set_var_chunk_cache(ncid, varid, size, nelems, preemption) &
  & bind(c, name="nc_set_var_chunk_cache")
  !! Set a variable's chunk cache settings.
  !! Cache settings are transient and are not stored in the file.
  import :: c_int, c_size_t, c_float
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  integer(c_size_t), value :: size
  !! Chunk cache capacity in bytes.
  integer(c_size_t), value :: nelems
  !! Number of cache hash slots.
  real(c_float), value :: preemption
  !! Cache preemption policy between 0.0 and 1.0.
  integer(c_int) :: nc_set_var_chunk_cache
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ENOTNC4 Not a NetCDF-4/HDF5 file.
  !! - NC_EINVAL Invalid cache settings.
end function nc_set_var_chunk_cache

function nc_get_var_chunk_cache(ncid, varid, sizep, nelemsp, preemptionp) &
  & bind(c, name="nc_get_var_chunk_cache")
  !! Query a variable's chunk cache settings.
  !! Cache settings are transient and are not stored in the file.
  import :: c_int, c_size_t, c_float
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  integer(c_size_t), intent(out) :: sizep
  !! Chunk cache capacity in bytes.
  integer(c_size_t), intent(out) :: nelemsp
  !! Number of cache hash slots.
  real(c_float), intent(out) :: preemptionp
  !! Cache preemption policy between 0.0 and 1.0.
  integer(c_int) :: nc_get_var_chunk_cache
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ENOTNC4 Not a NetCDF-4/HDF5 file.
end function nc_get_var_chunk_cache

function nc_rename_var(ncid, varid, name) bind(c, name="nc_rename_var")
  !! Rename a variable.
  !! For classic files, enter define mode if the new name is longer.
  import :: c_int, c_char
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated object name.
  integer(c_int) :: nc_rename_var
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_EPERM Dataset is read-only.
  !! - NC_ENAMEINUSE The new name is already in use.
  !! - NC_EBADNAME Invalid new name.
  !! - NC_ENOTVAR Invalid variable.
end function nc_rename_var

function nc_inq_type(ncid, xtype, name, sizep) bind(c, name="nc_inq_type")
  !! Return a NetCDF type's name and in-memory size.
  import :: c_int, c_char, c_size_t
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: xtype
  !! Atomic or user-defined NetCDF type identifier.
  character(kind=c_char), intent(out) :: name(*)
  !! Caller-allocated buffer of at least NC_MAX_NAME + 1 characters; result is NUL-terminated.
  integer(c_size_t), intent(out) :: sizep
  !! Returned size in bytes of one in-memory element; not total string payload size.
  integer(c_int) :: nc_inq_type
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_EBADTYPE Invalid type identifier.
end function nc_inq_type

function nc_def_var_chunking(ncid, varid, storage, chunksizesp) bind(c, name="nc_def_var_chunking")
  !! Set a variable's storage layout and chunk sizes.
  !! Call after nc_def_var() and before nc_enddef() or the first data write.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  integer(c_int), value :: storage
  !! NC_CONTIGUOUS or NC_CHUNKED (NC_COMPACT where supported).
  type(c_ptr), value :: chunksizesp
  !! Pointer to rank entries of integer(c_size_t), in C dimension order.
  !! For non-chunked storage this argument may be c_null_ptr.
  integer(c_int) :: nc_def_var_chunking
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ENOTNC4 Not a NetCDF-4/HDF5 file.
  !! - NC_ELATEDEF Storage properties can no longer be changed.
  !! - NC_EINVAL Invalid storage settings.
end function nc_def_var_chunking

function nc_inq_var_chunking(ncid, varid, storagep, chunksizesp) bind(c, name="nc_inq_var_chunking")
  !! Query a variable's storage layout and chunk sizes.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  integer(c_int), intent(out) :: storagep
  !! Returned storage layout constant.
  type(c_ptr), value :: chunksizesp
  !! Pointer to rank entries of integer(c_size_t), or c_null_ptr.
  !! Chunk lengths are meaningful only for chunked storage.
  integer(c_int) :: nc_inq_var_chunking
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ENOTNC4 Not a NetCDF-4/HDF5 file.
end function nc_inq_var_chunking

function nc_def_var_deflate(ncid, varid, shuffle, deflate, deflate_level) bind(c, name="nc_def_var_deflate")
  !! Set a variable's zlib compression and shuffle settings.
  !! Call after nc_def_var() and before nc_enddef() or the first data write.
  import :: c_int
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  integer(c_int), value :: shuffle
  !! NC_SHUFFLE or NC_NOSHUFFLE.
  integer(c_int), value :: deflate
  !! Nonzero enables deflate compression; zero disables it.
  integer(c_int), value :: deflate_level
  !! Compression level from NC_MIN_DEFLATE_LEVEL to NC_MAX_DEFLATE_LEVEL.
  integer(c_int) :: nc_def_var_deflate
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ENOTNC4 Not a NetCDF-4/HDF5 file.
  !! - NC_ELATEDEF Storage properties can no longer be changed.
  !! - NC_EINVAL Invalid storage settings.
end function nc_def_var_deflate

function nc_inq_var_deflate(ncid, varid, shufflep, deflatep, deflate_levelp) &
  & bind(c, name="nc_inq_var_deflate")
  !! Query a variable's zlib compression and shuffle settings.
  import :: c_int
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  integer(c_int), intent(out) :: shufflep
  !! Returned shuffle enable flag.
  integer(c_int), intent(out) :: deflatep
  !! Returned deflate enable flag.
  integer(c_int), intent(out) :: deflate_levelp
  !! Returned deflate level (0 through 9).
  integer(c_int) :: nc_inq_var_deflate
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ENOTNC4 Not a NetCDF-4/HDF5 file.
end function nc_inq_var_deflate

function nc_def_var_fletcher32(ncid, varid, fletcher32) bind(c, name="nc_def_var_fletcher32")
  !! Set a variable's Fletcher32 checksum setting.
  !! Call after nc_def_var() and before nc_enddef() or the first data write.
  import :: c_int
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  integer(c_int), value :: fletcher32
  !! NC_FLETCHER32 or NC_NOCHECKSUM.
  integer(c_int) :: nc_def_var_fletcher32
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ENOTNC4 Not a NetCDF-4/HDF5 file.
  !! - NC_ELATEDEF Storage properties can no longer be changed.
  !! - NC_EINVAL Invalid storage settings.
end function nc_def_var_fletcher32

function nc_inq_var_fletcher32(ncid, varid, fletcher32p) bind(c, name="nc_inq_var_fletcher32")
  !! Query a variable's Fletcher32 checksum setting.
  import :: c_int
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  integer(c_int), intent(out) :: fletcher32p
  !! Returned checksum setting.
  integer(c_int) :: nc_inq_var_fletcher32
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ENOTNC4 Not a NetCDF-4/HDF5 file.
end function nc_inq_var_fletcher32

function nc_def_var_endian(ncid, varid, endian) bind(c, name="nc_def_var_endian")
  !! Set a variable's on-disk byte order.
  !! Call after nc_def_var() and before nc_enddef() or the first data write.
  import :: c_int
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  integer(c_int), value :: endian
  !! NC_ENDIAN_NATIVE, NC_ENDIAN_LITTLE, or NC_ENDIAN_BIG.
  integer(c_int) :: nc_def_var_endian
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ENOTNC4 Not a NetCDF-4/HDF5 file.
  !! - NC_ELATEDEF Storage properties can no longer be changed.
  !! - NC_EINVAL Invalid storage settings.
end function nc_def_var_endian

function nc_inq_var_endian(ncid, varid, endianp) bind(c, name="nc_inq_var_endian")
  !! Query a variable's on-disk byte order.
  import :: c_int
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  integer(c_int), intent(out) :: endianp
  !! Returned byte-order constant.
  integer(c_int) :: nc_inq_var_endian
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ENOTNC4 Not a NetCDF-4/HDF5 file.
end function nc_inq_var_endian

function nc_def_var_fill(ncid, varid, no_fill, fill_value) bind(c, name="nc_def_var_fill")
  !! Set a variable's fill value and fill behavior.
  !! Configure fill before writing data. For classic formats, do so in define mode.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  integer(c_int), value :: no_fill
  !! Nonzero disables filling; zero enables filling (this is a Boolean flag).
  type(c_ptr), value :: fill_value
  !! Pointer to one value with exactly the variable's memory type.
  !! Pass c_null_ptr to use the default fill value. NC_STRING uses a char **.
  integer(c_int) :: nc_def_var_fill
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ELATEFILL Fill settings cannot be changed after data have been written.
  !! - NC_EINVAL Invalid fill setting.
end function nc_def_var_fill

function nc_inq_var_fill(ncid, varid, no_fill, fill_valuep) bind(c, name="nc_inq_var_fill")
  !! Query a variable's fill value and no-fill flag.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  integer(c_int), intent(out) :: no_fill
  !! Returned nonzero value if filling is disabled.
  type(c_ptr), value :: fill_valuep
  !! Pointer to storage for one value of the variable's type, or c_null_ptr.
  !! For NC_STRING, supply a c_ptr slot and release its string with nc_free_string().
  integer(c_int) :: nc_inq_var_fill
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
end function nc_inq_var_fill

! Additional serial C API, including legacy and extension interfaces.

function nc_inq_typeids(ncid, ntypes, typeids) bind(c, name="nc_inq_typeids")
  !! Enumerate user-defined types declared in a group.
  !! C declaration: int nc_inq_typeids(int ncid, int *ntypes, int *typeids);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), intent(out) :: ntypes
  !! Returned ntypes value (C int).
  type(c_ptr), value :: typeids
  !! Caller-provided type ID vector; c_null_ptr queries only the count. C pointee: int *.
  integer(c_int) :: nc_inq_typeids
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_inq_typeids

function nc_inq_type_equal(ncid1, typeid1, ncid2, typeid2, equal) bind(c, name="nc_inq_type_equal")
  !! Compare two NetCDF types, possibly in different datasets.
  !! C declaration: int nc_inq_type_equal(int ncid1, nc_type typeid1, int ncid2, nc_type typeid2, int
  !! *equal);
  import :: c_int
  integer(c_int), value :: ncid1
  !! First dataset/group identifier.
  integer(c_int), value :: typeid1
  !! NetCDF type identifier.
  integer(c_int), value :: ncid2
  !! Second dataset/group identifier.
  integer(c_int), value :: typeid2
  !! Second NetCDF type identifier.
  integer(c_int), intent(out) :: equal
  !! Returned equal value (C int).
  integer(c_int) :: nc_inq_type_equal
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_inq_type_equal

function nc_def_compound(ncid, size, name, typeidp) bind(c, name="nc_def_compound")
  !! Define a compound type with a specified in-memory record size.
  !! C declaration: int nc_def_compound(int ncid, size_t size, const char *name, nc_type *typeidp);
  import :: c_int, c_size_t, c_char
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_size_t), value :: size
  !! Size in bytes.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated C string.
  integer(c_int), intent(out) :: typeidp
  !! Returned typeidp value (C nc_type).
  integer(c_int) :: nc_def_compound
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_def_compound

function nc_insert_compound(ncid, xtype, name, offset, field_typeid) bind(c, name="nc_insert_compound")
  !! Insert a scalar field at a byte offset in a compound type.
  !! C declaration: int nc_insert_compound(int ncid, nc_type xtype, const char *name, size_t offset, nc_type
  !! field_typeid);
  import :: c_int, c_char, c_size_t
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: xtype
  !! NetCDF type identifier.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated C string.
  integer(c_size_t), value :: offset
  !! Field offset in bytes, including native C structure padding.
  integer(c_int), value :: field_typeid
  !! Field NetCDF type identifier.
  integer(c_int) :: nc_insert_compound
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_insert_compound

function nc_insert_array_compound(ncid, xtype, name, offset, field_typeid, ndims, dim_sizes) &
  & bind(c, name="nc_insert_array_compound")
  !! Insert a fixed-size array field in a compound type.
  !! C declaration: int nc_insert_array_compound(int ncid, nc_type xtype, const char *name, size_t offset,
  !! nc_type field_typeid, int ndims, const int *dim_sizes);
  import :: c_int, c_char, c_size_t, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: xtype
  !! NetCDF type identifier.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated C string.
  integer(c_size_t), value :: offset
  !! Field offset in bytes, including native C structure padding.
  integer(c_int), value :: field_typeid
  !! Field NetCDF type identifier.
  integer(c_int), value :: ndims
  !! Number of field or variable dimensions.
  type(c_ptr), value :: dim_sizes
  !! Field shape in C dimension order. C pointee: const int *.
  integer(c_int) :: nc_insert_array_compound
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_insert_array_compound

function nc_inq_typeid(ncid, name, typeidp) bind(c, name="nc_inq_typeid")
  !! Find a user-defined type identifier by name.
  !! C declaration: int nc_inq_typeid(int ncid, const char *name, nc_type *typeidp);
  import :: c_int, c_char
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated C string.
  integer(c_int), intent(out) :: typeidp
  !! Returned typeidp value (C nc_type).
  integer(c_int) :: nc_inq_typeid
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_inq_typeid

function nc_inq_compound(ncid, xtype, name, sizep, nfieldsp) bind(c, name="nc_inq_compound")
  !! Query the name, record size, and field count of a compound type.
  !! C declaration: int nc_inq_compound(int ncid, nc_type xtype, char *name, size_t *sizep, size_t
  !! *nfieldsp);
  import :: c_int, c_ptr, c_size_t
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: xtype
  !! NetCDF type identifier.
  type(c_ptr), value :: name
  !! Pointer to caller-provided C character output storage (NC_MAX_NAME + 1 for names).
  integer(c_size_t), intent(out) :: sizep
  !! Returned sizep value (C size_t).
  integer(c_size_t), intent(out) :: nfieldsp
  !! Returned nfieldsp value (C size_t).
  integer(c_int) :: nc_inq_compound
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_inq_compound

function nc_inq_compound_name(ncid, xtype, name) bind(c, name="nc_inq_compound_name")
  !! Query the name of a compound type.
  !! C declaration: int nc_inq_compound_name(int ncid, nc_type xtype, char *name);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: xtype
  !! NetCDF type identifier.
  type(c_ptr), value :: name
  !! Pointer to caller-provided C character output storage (NC_MAX_NAME + 1 for names).
  integer(c_int) :: nc_inq_compound_name
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_inq_compound_name

function nc_inq_compound_size(ncid, xtype, sizep) bind(c, name="nc_inq_compound_size")
  !! Query the in-memory record size of a compound type.
  !! C declaration: int nc_inq_compound_size(int ncid, nc_type xtype, size_t *sizep);
  import :: c_int, c_size_t
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: xtype
  !! NetCDF type identifier.
  integer(c_size_t), intent(out) :: sizep
  !! Returned sizep value (C size_t).
  integer(c_int) :: nc_inq_compound_size
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_inq_compound_size

function nc_inq_compound_nfields(ncid, xtype, nfieldsp) bind(c, name="nc_inq_compound_nfields")
  !! Query the number of fields in a compound type.
  !! C declaration: int nc_inq_compound_nfields(int ncid, nc_type xtype, size_t *nfieldsp);
  import :: c_int, c_size_t
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: xtype
  !! NetCDF type identifier.
  integer(c_size_t), intent(out) :: nfieldsp
  !! Returned nfieldsp value (C size_t).
  integer(c_int) :: nc_inq_compound_nfields
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_inq_compound_nfields

function nc_inq_compound_field(ncid, xtype, fieldid, name, offsetp, field_typeidp, ndimsp, dim_sizesp) &
  & bind(c, name="nc_inq_compound_field")
  !! Query a compound field name, offset, type, and array shape.
  !! C declaration: int nc_inq_compound_field(int ncid, nc_type xtype, int fieldid, char *name, size_t
  !! *offsetp, nc_type *field_typeidp, int *ndimsp, int *dim_sizesp);
  import :: c_int, c_ptr, c_size_t
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: xtype
  !! NetCDF type identifier.
  integer(c_int), value :: fieldid
  !! Zero-based compound field index.
  type(c_ptr), value :: name
  !! Pointer to caller-provided C character output storage (NC_MAX_NAME + 1 for names).
  integer(c_size_t), intent(out) :: offsetp
  !! Returned offsetp value (C size_t).
  integer(c_int), intent(out) :: field_typeidp
  !! Returned field_typeidp value (C nc_type).
  integer(c_int), intent(out) :: ndimsp
  !! Returned ndimsp value (C int).
  type(c_ptr), value :: dim_sizesp
  !! Caller-provided field shape vector in C order. C pointee: int *.
  integer(c_int) :: nc_inq_compound_field
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_inq_compound_field

function nc_inq_compound_fieldname(ncid, xtype, fieldid, name) bind(c, name="nc_inq_compound_fieldname")
  !! Query the name of a compound field.
  !! C declaration: int nc_inq_compound_fieldname(int ncid, nc_type xtype, int fieldid, char *name);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: xtype
  !! NetCDF type identifier.
  integer(c_int), value :: fieldid
  !! Zero-based compound field index.
  type(c_ptr), value :: name
  !! Pointer to caller-provided C character output storage (NC_MAX_NAME + 1 for names).
  integer(c_int) :: nc_inq_compound_fieldname
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_inq_compound_fieldname

function nc_inq_compound_fieldindex(ncid, xtype, name, fieldidp) bind(c, name="nc_inq_compound_fieldindex")
  !! Find a zero-based compound field index by name.
  !! C declaration: int nc_inq_compound_fieldindex(int ncid, nc_type xtype, const char *name, int *fieldidp);
  import :: c_int, c_char
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: xtype
  !! NetCDF type identifier.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated C string.
  integer(c_int), intent(out) :: fieldidp
  !! Returned fieldidp value (C int).
  integer(c_int) :: nc_inq_compound_fieldindex
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_inq_compound_fieldindex

function nc_inq_compound_fieldoffset(ncid, xtype, fieldid, offsetp) bind(c, name="nc_inq_compound_fieldoffset")
  !! Query a compound field byte offset.
  !! C declaration: int nc_inq_compound_fieldoffset(int ncid, nc_type xtype, int fieldid, size_t *offsetp);
  import :: c_int, c_size_t
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: xtype
  !! NetCDF type identifier.
  integer(c_int), value :: fieldid
  !! Zero-based compound field index.
  integer(c_size_t), intent(out) :: offsetp
  !! Returned offsetp value (C size_t).
  integer(c_int) :: nc_inq_compound_fieldoffset
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_inq_compound_fieldoffset

function nc_inq_compound_fieldtype(ncid, xtype, fieldid, field_typeidp) bind(c, name="nc_inq_compound_fieldtype")
  !! Query a compound field NetCDF type.
  !! C declaration: int nc_inq_compound_fieldtype(int ncid, nc_type xtype, int fieldid, nc_type
  !! *field_typeidp);
  import :: c_int
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: xtype
  !! NetCDF type identifier.
  integer(c_int), value :: fieldid
  !! Zero-based compound field index.
  integer(c_int), intent(out) :: field_typeidp
  !! Returned field_typeidp value (C nc_type).
  integer(c_int) :: nc_inq_compound_fieldtype
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_inq_compound_fieldtype

function nc_inq_compound_fieldndims(ncid, xtype, fieldid, ndimsp) bind(c, name="nc_inq_compound_fieldndims")
  !! Query a compound field rank (zero for a scalar).
  !! C declaration: int nc_inq_compound_fieldndims(int ncid, nc_type xtype, int fieldid, int *ndimsp);
  import :: c_int
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: xtype
  !! NetCDF type identifier.
  integer(c_int), value :: fieldid
  !! Zero-based compound field index.
  integer(c_int), intent(out) :: ndimsp
  !! Returned ndimsp value (C int).
  integer(c_int) :: nc_inq_compound_fieldndims
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_inq_compound_fieldndims

function nc_inq_compound_fielddim_sizes(ncid, xtype, fieldid, dim_sizes) &
  & bind(c, name="nc_inq_compound_fielddim_sizes")
  !! Query a compound array field shape in C dimension order.
  !! C declaration: int nc_inq_compound_fielddim_sizes(int ncid, nc_type xtype, int fieldid, int *dim_sizes);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: xtype
  !! NetCDF type identifier.
  integer(c_int), value :: fieldid
  !! Zero-based compound field index.
  type(c_ptr), value :: dim_sizes
  !! Field shape in C dimension order. C pointee: int *.
  integer(c_int) :: nc_inq_compound_fielddim_sizes
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_inq_compound_fielddim_sizes

function nc_def_vlen(ncid, name, base_typeid, xtypep) bind(c, name="nc_def_vlen")
  !! Define a variable-length sequence type.
  !! C declaration: int nc_def_vlen(int ncid, const char *name, nc_type base_typeid, nc_type *xtypep);
  import :: c_int, c_char
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated C string.
  integer(c_int), value :: base_typeid
  !! Base NetCDF type identifier.
  integer(c_int), intent(out) :: xtypep
  !! Returned xtypep value (C nc_type).
  integer(c_int) :: nc_def_vlen
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_def_vlen

function nc_inq_vlen(ncid, xtype, name, datum_sizep, base_nc_typep) bind(c, name="nc_inq_vlen")
  !! Query a variable-length type name, descriptor size, and base type.
  !! C declaration: int nc_inq_vlen(int ncid, nc_type xtype, char *name, size_t *datum_sizep, nc_type
  !! *base_nc_typep);
  import :: c_int, c_ptr, c_size_t
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: xtype
  !! NetCDF type identifier.
  type(c_ptr), value :: name
  !! Pointer to caller-provided C character output storage (NC_MAX_NAME + 1 for names).
  integer(c_size_t), intent(out) :: datum_sizep
  !! Returned datum_sizep value (C size_t).
  integer(c_int), intent(out) :: base_nc_typep
  !! Returned base_nc_typep value (C nc_type).
  integer(c_int) :: nc_inq_vlen
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_inq_vlen

function nc_inq_user_type(ncid, xtype, name, size, base_nc_typep, nfieldsp, classp) &
  & bind(c, name="nc_inq_user_type")
  !! Query a user-defined type name, size, base type, field count, and class.
  !! C declaration: int nc_inq_user_type(int ncid, nc_type xtype, char *name, size_t *size, nc_type
  !! *base_nc_typep, size_t *nfieldsp, int *classp);
  import :: c_int, c_ptr, c_size_t
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: xtype
  !! NetCDF type identifier.
  type(c_ptr), value :: name
  !! Pointer to caller-provided C character output storage (NC_MAX_NAME + 1 for names).
  integer(c_size_t), intent(out) :: size
  !! Returned size value (C size_t).
  integer(c_int), intent(out) :: base_nc_typep
  !! Returned base_nc_typep value (C nc_type).
  integer(c_size_t), intent(out) :: nfieldsp
  !! Returned nfieldsp value (C size_t).
  integer(c_int), intent(out) :: classp
  !! Returned classp value (C int).
  integer(c_int) :: nc_inq_user_type
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_inq_user_type

function nc_def_enum(ncid, base_typeid, name, typeidp) bind(c, name="nc_def_enum")
  !! Define an enumeration with an integer base type.
  !! C declaration: int nc_def_enum(int ncid, nc_type base_typeid, const char *name, nc_type *typeidp);
  import :: c_int, c_char
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: base_typeid
  !! Base NetCDF type identifier.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated C string.
  integer(c_int), intent(out) :: typeidp
  !! Returned typeidp value (C nc_type).
  integer(c_int) :: nc_def_enum
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_def_enum

function nc_insert_enum(ncid, xtype, name, value) bind(c, name="nc_insert_enum")
  !! Insert a name/value member into an enumeration.
  !! C declaration: int nc_insert_enum(int ncid, nc_type xtype, const char *name, const void *value);
  import :: c_int, c_char, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: xtype
  !! NetCDF type identifier.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated C string.
  type(c_ptr), value :: value
  !! Pointer to C-compatible storage. C pointee: const void *.
  integer(c_int) :: nc_insert_enum
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_insert_enum

function nc_inq_enum(ncid, xtype, name, base_nc_typep, base_sizep, num_membersp) bind(c, name="nc_inq_enum")
  !! Query an enumeration name, base type, base size, and member count.
  !! C declaration: int nc_inq_enum(int ncid, nc_type xtype, char *name, nc_type *base_nc_typep, size_t
  !! *base_sizep, size_t *num_membersp);
  import :: c_int, c_ptr, c_size_t
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: xtype
  !! NetCDF type identifier.
  type(c_ptr), value :: name
  !! Pointer to caller-provided C character output storage (NC_MAX_NAME + 1 for names).
  integer(c_int), intent(out) :: base_nc_typep
  !! Returned base_nc_typep value (C nc_type).
  integer(c_size_t), intent(out) :: base_sizep
  !! Returned base_sizep value (C size_t).
  integer(c_size_t), intent(out) :: num_membersp
  !! Returned num_membersp value (C size_t).
  integer(c_int) :: nc_inq_enum
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_inq_enum

function nc_inq_enum_member(ncid, xtype, idx, name, value) bind(c, name="nc_inq_enum_member")
  !! Query one enumeration member by zero-based index.
  !! C declaration: int nc_inq_enum_member(int ncid, nc_type xtype, int idx, char *name, void *value);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: xtype
  !! NetCDF type identifier.
  integer(c_int), value :: idx
  !! Zero-based enum member index.
  type(c_ptr), value :: name
  !! Pointer to caller-provided C character output storage (NC_MAX_NAME + 1 for names).
  type(c_ptr), value :: value
  !! Pointer to C-compatible storage. C pointee: void *.
  integer(c_int) :: nc_inq_enum_member
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_inq_enum_member

function nc_inq_enum_ident(ncid, xtype, value, identifier) bind(c, name="nc_inq_enum_ident")
  !! Find an enumeration member name from its value.
  !! C declaration: int nc_inq_enum_ident(int ncid, nc_type xtype, long long value, char *identifier);
  import :: c_int, c_long_long, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: xtype
  !! NetCDF type identifier.
  integer(c_long_long), value :: value
  !! C long long argument value.
  type(c_ptr), value :: identifier
  !! Pointer to caller-provided C character output storage (NC_MAX_NAME + 1 for names).
  integer(c_int) :: nc_inq_enum_ident
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_inq_enum_ident

function nc_def_opaque(ncid, size, name, xtypep) bind(c, name="nc_def_opaque")
  !! Define an opaque fixed-size byte sequence type.
  !! C declaration: int nc_def_opaque(int ncid, size_t size, const char *name, nc_type *xtypep);
  import :: c_int, c_size_t, c_char
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_size_t), value :: size
  !! Size in bytes.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated C string.
  integer(c_int), intent(out) :: xtypep
  !! Returned xtypep value (C nc_type).
  integer(c_int) :: nc_def_opaque
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_def_opaque

function nc_inq_opaque(ncid, xtype, name, sizep) bind(c, name="nc_inq_opaque")
  !! Query an opaque type name and byte size.
  !! C declaration: int nc_inq_opaque(int ncid, nc_type xtype, char *name, size_t *sizep);
  import :: c_int, c_ptr, c_size_t
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: xtype
  !! NetCDF type identifier.
  type(c_ptr), value :: name
  !! Pointer to caller-provided C character output storage (NC_MAX_NAME + 1 for names).
  integer(c_size_t), intent(out) :: sizep
  !! Returned sizep value (C size_t).
  integer(c_int) :: nc_inq_opaque
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_inq_opaque

function nc_def_var_quantize(ncid, varid, quantize_mode, nsd) bind(c, name="nc_def_var_quantize")
  !! Configure lossy floating-point quantization before writing a variable.
  !! Call before writing data. BitGroom/GranularBR use decimal digits; BitRound uses binary bits.
  !! C declaration: int nc_def_var_quantize(int ncid, int varid, int quantize_mode, int nsd);
  import :: c_int
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  integer(c_int), value :: quantize_mode
  !! C int argument quantize_mode.
  integer(c_int), value :: nsd
  !! C int argument nsd.
  integer(c_int) :: nc_def_var_quantize
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_def_var_quantize

function nc_inq_var_quantize(ncid, varid, quantize_modep, nsdp) bind(c, name="nc_inq_var_quantize")
  !! Query a variable quantization mode and precision.
  !! C declaration: int nc_inq_var_quantize(int ncid, int varid, int *quantize_modep, int *nsdp);
  import :: c_int
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  integer(c_int), intent(out) :: quantize_modep
  !! Returned quantize_modep value (C int).
  integer(c_int), intent(out) :: nsdp
  !! Returned nsdp value (C int).
  integer(c_int) :: nc_inq_var_quantize
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_inq_var_quantize

function nc_def_var_szip(ncid, varid, options_mask, pixels_per_block) bind(c, name="nc_def_var_szip")
  !! Configure SZIP compression before writing a variable.
  !! C declaration: int nc_def_var_szip(int ncid, int varid, int options_mask, int pixels_per_block);
  import :: c_int
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  integer(c_int), value :: options_mask
  !! C int argument options_mask.
  integer(c_int), value :: pixels_per_block
  !! C int argument pixels_per_block.
  integer(c_int) :: nc_def_var_szip
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_def_var_szip

function nc_inq_var_szip(ncid, varid, options_maskp, pixels_per_blockp) bind(c, name="nc_inq_var_szip")
  !! Query SZIP compression options and pixels per block.
  !! C declaration: int nc_inq_var_szip(int ncid, int varid, int *options_maskp, int *pixels_per_blockp);
  import :: c_int
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  integer(c_int), intent(out) :: options_maskp
  !! Returned options_maskp value (C int).
  integer(c_int), intent(out) :: pixels_per_blockp
  !! Returned pixels_per_blockp value (C int).
  integer(c_int) :: nc_inq_var_szip
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_inq_var_szip

function nc_copy_var(ncid_in, varid, ncid_out) bind(c, name="nc_copy_var")
  !! Copy a primitive variable and its attributes to another dataset.
  !! Destination dimensions must already match the source IDs and lengths.
  !! This API does not copy NC_STRING or user-defined-type variables.
  !! C declaration: int nc_copy_var(int ncid_in, int varid, int ncid_out);
  import :: c_int
  integer(c_int), value :: ncid_in
  !! Source dataset/group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  integer(c_int), value :: ncid_out
  !! Destination dataset/group identifier.
  integer(c_int) :: nc_copy_var
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_copy_var

function nctypelen(datatype) bind(c, name="nctypelen")
  !! Legacy v2 API: Return the byte size of a classic NetCDF type.
  !! Uses v2 return/error conventions, not modern NC_NOERR status semantics.
  !! Legacy process-global ncopts controls fatal errors and diagnostics; no accessor is provided.
  !! C declaration: int nctypelen(nc_type datatype);
  import :: c_int
  integer(c_int), value :: datatype
  !! C nc_type argument datatype.
  integer(c_int) :: nctypelen
  !! V2 result (ID, size, previous setting, or success value); -1 indicates failure.
end function nctypelen

function ncvardef(ncid, name, xtype, ndims, dimidsp) bind(c, name="ncvardef")
  !! Legacy v2 API: Define a variable and return its ID.
  !! Uses v2 return/error conventions, not modern NC_NOERR status semantics.
  !! Legacy process-global ncopts controls fatal errors and diagnostics; no accessor is provided.
  !! C declaration: int ncvardef(int ncid, const char *name, nc_type xtype, int ndims, const int *dimidsp);
  import :: c_int, c_char, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated C string.
  integer(c_int), value :: xtype
  !! NetCDF type identifier.
  integer(c_int), value :: ndims
  !! Number of field or variable dimensions.
  type(c_ptr), value :: dimidsp
  !! Variable dimension ID vector in C dimension order. C pointee: const int *.
  integer(c_int) :: ncvardef
  !! V2 result (ID, size, previous setting, or success value); -1 indicates failure.
end function ncvardef

function ncvarid(ncid, name) bind(c, name="ncvarid")
  !! Legacy v2 API: Find a variable ID by name.
  !! Uses v2 return/error conventions, not modern NC_NOERR status semantics.
  !! Legacy process-global ncopts controls fatal errors and diagnostics; no accessor is provided.
  !! C declaration: int ncvarid(int ncid, const char *name);
  import :: c_int, c_char
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated C string.
  integer(c_int) :: ncvarid
  !! V2 result (ID, size, previous setting, or success value); -1 indicates failure.
end function ncvarid

function ncvarinq(ncid, varid, name, xtypep, ndimsp, dimidsp, nattsp) bind(c, name="ncvarinq")
  !! Legacy v2 API: Query variable metadata.
  !! Uses v2 return/error conventions, not modern NC_NOERR status semantics.
  !! Legacy process-global ncopts controls fatal errors and diagnostics; no accessor is provided.
  !! C declaration: int ncvarinq(int ncid, int varid, char *name, nc_type *xtypep, int *ndimsp, int *dimidsp,
  !! int *nattsp);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: name
  !! Pointer to caller-provided C character output storage (NC_MAX_NAME + 1 for names).
  integer(c_int), intent(out) :: xtypep
  !! Returned xtypep value (C nc_type).
  integer(c_int), intent(out) :: ndimsp
  !! Returned ndimsp value (C int).
  type(c_ptr), value :: dimidsp
  !! Variable dimension ID vector in C dimension order. C pointee: int *.
  integer(c_int), intent(out) :: nattsp
  !! Returned nattsp value (C int).
  integer(c_int) :: ncvarinq
  !! V2 result (ID, size, previous setting, or success value); -1 indicates failure.
end function ncvarinq

function ncvarrename(ncid, varid, name) bind(c, name="ncvarrename")
  !! Legacy v2 API: Rename a variable.
  !! Uses v2 return/error conventions, not modern NC_NOERR status semantics.
  !! Legacy process-global ncopts controls fatal errors and diagnostics; no accessor is provided.
  !! C declaration: int ncvarrename(int ncid, int varid, const char *name);
  import :: c_int, c_char
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated C string.
  integer(c_int) :: ncvarrename
  !! V2 result (ID, size, previous setting, or success value); -1 indicates failure.
end function ncvarrename

function nc_def_var_bzip2(ncid, varid, level) bind(c, name="nc_def_var_bzip2")
  !! Configure the bzip2 filter before writing a variable.
  !! C declaration: int nc_def_var_bzip2(int ncid, int varid, int level);
  import :: c_int
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  integer(c_int), value :: level
  !! Compression level.
  integer(c_int) :: nc_def_var_bzip2
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_def_var_bzip2

function nc_inq_var_bzip2(ncid, varid, hasfilterp, levelp) bind(c, name="nc_inq_var_bzip2")
  !! Query the presence and level of the bzip2 filter.
  !! C declaration: int nc_inq_var_bzip2(int ncid, int varid, int* hasfilterp, int *levelp);
  import :: c_int
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  integer(c_int), intent(out) :: hasfilterp
  !! Returned hasfilterp value (C int).
  integer(c_int), intent(out) :: levelp
  !! Returned levelp value (C int).
  integer(c_int) :: nc_inq_var_bzip2
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_inq_var_bzip2

function nc_def_var_zstandard(ncid, varid, level) bind(c, name="nc_def_var_zstandard")
  !! Configure the Zstandard filter before writing a variable.
  !! C declaration: int nc_def_var_zstandard(int ncid, int varid, int level);
  import :: c_int
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  integer(c_int), value :: level
  !! Compression level.
  integer(c_int) :: nc_def_var_zstandard
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_def_var_zstandard

function nc_inq_var_zstandard(ncid, varid, hasfilterp, levelp) bind(c, name="nc_inq_var_zstandard")
  !! Query the presence and level of the Zstandard filter.
  !! C declaration: int nc_inq_var_zstandard(int ncid, int varid, int* hasfilterp, int *levelp);
  import :: c_int
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  integer(c_int), intent(out) :: hasfilterp
  !! Returned hasfilterp value (C int).
  integer(c_int), intent(out) :: levelp
  !! Returned levelp value (C int).
  integer(c_int) :: nc_inq_var_zstandard
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_inq_var_zstandard

function ncaux_inq_any_type(ncid, typeid, name, size, basetypep, nfieldsp, classp) &
  & bind(c, name="ncaux_inq_any_type")
  !! Query either an atomic or user-defined type.
  !! C declaration: int ncaux_inq_any_type(int ncid, nc_type typeid, char *name, size_t *size, nc_type
  !! *basetypep, size_t *nfieldsp, int *classp);
  import :: c_int, c_ptr, c_size_t
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: typeid
  !! NetCDF type identifier.
  type(c_ptr), value :: name
  !! Pointer to caller-provided C character output storage (NC_MAX_NAME + 1 for names).
  integer(c_size_t), intent(out) :: size
  !! Returned size value (C size_t).
  integer(c_int), intent(out) :: basetypep
  !! Returned basetypep value (C nc_type).
  integer(c_size_t), intent(out) :: nfieldsp
  !! Returned nfieldsp value (C size_t).
  integer(c_int), intent(out) :: classp
  !! Returned classp value (C int).
  integer(c_int) :: ncaux_inq_any_type
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function ncaux_inq_any_type

function ncaux_type_alignment(xtype, ncid, alignp) bind(c, name="ncaux_type_alignment")
  !! Query the native memory alignment required by a NetCDF type.
  !! C declaration: int ncaux_type_alignment(int xtype, int ncid, size_t* alignp);
  import :: c_int, c_size_t
  integer(c_int), value :: xtype
  !! NetCDF type identifier.
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_size_t), intent(out) :: alignp
  !! Returned alignp value (C size_t).
  integer(c_int) :: ncaux_type_alignment
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function ncaux_type_alignment

function ncaux_class_alignment(ncclass, alignp) bind(c, name="ncaux_class_alignment")
  !! Query the native alignment for a NetCDF type class.
  !! C declaration: int ncaux_class_alignment(int ncclass, size_t* alignp);
  import :: c_int, c_size_t
  integer(c_int), value :: ncclass
  !! C int argument ncclass.
  integer(c_size_t), intent(out) :: alignp
  !! Returned alignp value (C size_t).
  integer(c_int) :: ncaux_class_alignment
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function ncaux_class_alignment

function ncaux_begin_compound(ncid, name, alignmode, tag) bind(c, name="ncaux_begin_compound")
  !! Begin building a compound type with automatic field alignment.
  !! C declaration: int ncaux_begin_compound(int ncid, const char *name, int alignmode, void** tag);
  import :: c_int, c_char, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated C string.
  integer(c_int), value :: alignmode
  !! NCAUX_ALIGN_C or NCAUX_ALIGN_UNIFORM.
  type(c_ptr), intent(out) :: tag
  !! Returned C pointer; pass a c_ptr variable, not c_loc() of a pointer slot.
  integer(c_int) :: ncaux_begin_compound
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function ncaux_begin_compound

function ncaux_end_compound(tag, xtypeid) bind(c, name="ncaux_end_compound")
  !! Finish an auxiliary compound builder and return its type identifier.
  !! C declaration: int ncaux_end_compound(void* tag, nc_type* xtypeid);
  import :: c_int, c_ptr
  type(c_ptr), value :: tag
  !! Pointer to C-compatible storage. C pointee: void*.
  integer(c_int), intent(out) :: xtypeid
  !! Returned xtypeid value (C nc_type).
  integer(c_int) :: ncaux_end_compound
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function ncaux_end_compound

function ncaux_abort_compound(tag) bind(c, name="ncaux_abort_compound")
  !! Discard an unfinished auxiliary compound builder.
  !! C declaration: int ncaux_abort_compound(void* tag);
  import :: c_int, c_ptr
  type(c_ptr), value :: tag
  !! Pointer to C-compatible storage. C pointee: void*.
  integer(c_int) :: ncaux_abort_compound
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function ncaux_abort_compound

function ncaux_add_field(tag, name, field_type, ndims, dimsizes) bind(c, name="ncaux_add_field")
  !! Add a field to an auxiliary compound builder.
  !! C declaration: int ncaux_add_field(void* tag, const char *name, nc_type field_type, int ndims, const
  !! int* dimsizes);
  import :: c_int, c_ptr, c_char
  type(c_ptr), value :: tag
  !! Pointer to C-compatible storage. C pointee: void*.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated C string.
  integer(c_int), value :: field_type
  !! C nc_type argument field_type.
  integer(c_int), value :: ndims
  !! Number of field or variable dimensions.
  type(c_ptr), value :: dimsizes
  !! Pointer to C-compatible storage. C pointee: const int*.
  integer(c_int) :: ncaux_add_field
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function ncaux_add_field
