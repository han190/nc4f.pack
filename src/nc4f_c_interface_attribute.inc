! Attribute discovery, mutation, and typed value transfer.
! Included inside the interface block of nc4f_c_interface.

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
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated name of the attribute to inquire.
  integer(c_int), intent(out) :: xtypep
  !! Pointer to location for returned attribute data type.
  integer(c_size_t), intent(out) :: lenp
  !! Pointer to location for returned number of values currently stored in
  !! the attribute. For attributes of type NC_CHAR, you should not assume
  !! that this includes a trailing zero byte; it doesn't if the attribute was
  !! stored without a trailing zero byte, for example from a FORTRAN program.
  !! Before using the value as a C string, make sure it is null-terminated.
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
  !! The memory type must match the file type; no numeric conversion is performed.
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
  integer(c_int) :: nc_inq_natts
  !! **Options:**
  !! - NC_NOERR no error.
  !! - NC_EBADID bad ncid.
  !! - NC_EBADGRPID bad group ID.
end function nc_inq_natts

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
  !! File type and memory type of the attribute; no conversion is performed.
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

function nc_inq_attid(ncid, varid, name, idp) bind(c, name="nc_inq_attid")
  !! Return the zero-based attribute number.
  import :: c_int, c_char
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier, or NC_GLOBAL for a file/group attribute.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated object name.
  integer(c_int), intent(out) :: idp
  !! Returned zero-based attribute number.
  integer(c_int) :: nc_inq_attid
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ENOTATT Attribute not found.
end function nc_inq_attid

function nc_inq_atttype(ncid, varid, name, xtypep) bind(c, name="nc_inq_atttype")
  !! Return the NetCDF attribute type.
  import :: c_int, c_char
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier, or NC_GLOBAL for a file/group attribute.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated object name.
  integer(c_int), intent(out) :: xtypep
  !! Returned NetCDF attribute type.
  integer(c_int) :: nc_inq_atttype
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ENOTATT Attribute not found.
end function nc_inq_atttype

function nc_inq_attlen(ncid, varid, name, lenp) bind(c, name="nc_inq_attlen")
  !! Return the attribute element count.
  import :: c_int, c_char, c_size_t
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier, or NC_GLOBAL for a file/group attribute.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated object name.
  integer(c_size_t), intent(out) :: lenp
  !! Returned attribute element count.
  integer(c_int) :: nc_inq_attlen
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ENOTATT Attribute not found.
end function nc_inq_attlen

function nc_copy_att(ncid_in, varid_in, name, ncid_out, varid_out) bind(c, name="nc_copy_att")
  !! Copy an attribute, preserving its type and values.
  !! A new or enlarged attribute in a classic file requires destination define mode.
  import :: c_int, c_char
  integer(c_int), value :: ncid_in
  !! Source file or group identifier.
  integer(c_int), value :: varid_in
  !! Source variable ID, or NC_GLOBAL.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated object name.
  integer(c_int), value :: ncid_out
  !! Destination file or group identifier.
  integer(c_int), value :: varid_out
  !! Destination variable ID, or NC_GLOBAL.
  integer(c_int) :: nc_copy_att
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ENOTATT Source attribute not found.
  !! - NC_EPERM Destination is read-only.
end function nc_copy_att

function nc_rename_att(ncid, varid, name, newname) bind(c, name="nc_rename_att")
  !! Rename an attribute.
  !! For classic files, enter define mode if the new name is longer.
  import :: c_int, c_char
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier, or NC_GLOBAL for a file/group attribute.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated object name.
  character(kind=c_char), intent(in) :: newname(*)
  !! NUL-terminated replacement name.
  integer(c_int) :: nc_rename_att
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_EPERM Dataset is read-only.
  !! - NC_ENAMEINUSE The new name is already in use.
  !! - NC_EBADNAME Invalid new name.
  !! - NC_ENOTATT Attribute not found.
end function nc_rename_att

function nc_del_att(ncid, varid, name) bind(c, name="nc_del_att")
  !! Delete an attribute.
  !! Classic files must be in define mode; NetCDF-4 attributes may be deleted in data mode.
  import :: c_int, c_char
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier, or NC_GLOBAL for a file/group attribute.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated object name.
  integer(c_int) :: nc_del_att
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ENOTATT Attribute not found.
  !! - NC_EPERM Dataset is read-only.
  !! - NC_ENOTINDEFINE Classic file is not in define mode.
end function nc_del_att

function nc_get_att_schar(ncid, varid, name, ip) bind(c, name="nc_get_att_schar")
  !! Read an attribute using schar memory storage.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! Allocate enough storage for the count returned by nc_inq_attlen().
  import :: c_int, c_char, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier, or NC_GLOBAL for a file/group attribute.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated object name.
  type(c_ptr), value :: ip
  !! Pointer to contiguous integer(c_signed_char) storage.
  integer(c_int) :: nc_get_att_schar
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ENOTATT Attribute not found.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
end function nc_get_att_schar

function nc_put_att_schar(ncid, varid, name, xtype, len, op) bind(c, name="nc_put_att_schar")
  !! Write an attribute using schar memory storage.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! New or enlarged attributes in classic files require define mode.
  import :: c_int, c_char, c_size_t, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier, or NC_GLOBAL for a file/group attribute.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated object name.
  integer(c_int), value :: xtype
  !! Destination NetCDF numeric type; the suffix selects the source memory type.
  integer(c_size_t), value :: len
  !! Number of attribute elements (characters for NC_CHAR, strings for NC_STRING).
  type(c_ptr), value :: op
  !! Pointer to contiguous integer(c_signed_char) storage.
  integer(c_int) :: nc_put_att_schar
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_EPERM Dataset is read-only.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
end function nc_put_att_schar

function nc_get_att_short(ncid, varid, name, ip) bind(c, name="nc_get_att_short")
  !! Read an attribute using short memory storage.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! Allocate enough storage for the count returned by nc_inq_attlen().
  import :: c_int, c_char, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier, or NC_GLOBAL for a file/group attribute.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated object name.
  type(c_ptr), value :: ip
  !! Pointer to contiguous integer(c_short) storage.
  integer(c_int) :: nc_get_att_short
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ENOTATT Attribute not found.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
end function nc_get_att_short

function nc_put_att_short(ncid, varid, name, xtype, len, op) bind(c, name="nc_put_att_short")
  !! Write an attribute using short memory storage.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! New or enlarged attributes in classic files require define mode.
  import :: c_int, c_char, c_size_t, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier, or NC_GLOBAL for a file/group attribute.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated object name.
  integer(c_int), value :: xtype
  !! Destination NetCDF numeric type; the suffix selects the source memory type.
  integer(c_size_t), value :: len
  !! Number of attribute elements (characters for NC_CHAR, strings for NC_STRING).
  type(c_ptr), value :: op
  !! Pointer to contiguous integer(c_short) storage.
  integer(c_int) :: nc_put_att_short
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_EPERM Dataset is read-only.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
end function nc_put_att_short

function nc_get_att_int(ncid, varid, name, ip) bind(c, name="nc_get_att_int")
  !! Read an attribute using int memory storage.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! Allocate enough storage for the count returned by nc_inq_attlen().
  import :: c_int, c_char, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier, or NC_GLOBAL for a file/group attribute.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated object name.
  type(c_ptr), value :: ip
  !! Pointer to contiguous integer(c_int) storage.
  integer(c_int) :: nc_get_att_int
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ENOTATT Attribute not found.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
end function nc_get_att_int

function nc_put_att_int(ncid, varid, name, xtype, len, op) bind(c, name="nc_put_att_int")
  !! Write an attribute using int memory storage.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! New or enlarged attributes in classic files require define mode.
  import :: c_int, c_char, c_size_t, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier, or NC_GLOBAL for a file/group attribute.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated object name.
  integer(c_int), value :: xtype
  !! Destination NetCDF numeric type; the suffix selects the source memory type.
  integer(c_size_t), value :: len
  !! Number of attribute elements (characters for NC_CHAR, strings for NC_STRING).
  type(c_ptr), value :: op
  !! Pointer to contiguous integer(c_int) storage.
  integer(c_int) :: nc_put_att_int
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_EPERM Dataset is read-only.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
end function nc_put_att_int

function nc_get_att_long(ncid, varid, name, ip) bind(c, name="nc_get_att_long")
  !! Read an attribute using long memory storage.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! Allocate enough storage for the count returned by nc_inq_attlen().
  import :: c_int, c_char, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier, or NC_GLOBAL for a file/group attribute.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated object name.
  type(c_ptr), value :: ip
  !! Pointer to contiguous integer(c_long) storage.
  integer(c_int) :: nc_get_att_long
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ENOTATT Attribute not found.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
end function nc_get_att_long

function nc_put_att_long(ncid, varid, name, xtype, len, op) bind(c, name="nc_put_att_long")
  !! Write an attribute using long memory storage.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! New or enlarged attributes in classic files require define mode.
  import :: c_int, c_char, c_size_t, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier, or NC_GLOBAL for a file/group attribute.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated object name.
  integer(c_int), value :: xtype
  !! Destination NetCDF numeric type; the suffix selects the source memory type.
  integer(c_size_t), value :: len
  !! Number of attribute elements (characters for NC_CHAR, strings for NC_STRING).
  type(c_ptr), value :: op
  !! Pointer to contiguous integer(c_long) storage.
  integer(c_int) :: nc_put_att_long
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_EPERM Dataset is read-only.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
end function nc_put_att_long

function nc_get_att_longlong(ncid, varid, name, ip) bind(c, name="nc_get_att_longlong")
  !! Read an attribute using longlong memory storage.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! Allocate enough storage for the count returned by nc_inq_attlen().
  import :: c_int, c_char, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier, or NC_GLOBAL for a file/group attribute.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated object name.
  type(c_ptr), value :: ip
  !! Pointer to contiguous integer(c_long_long) storage.
  integer(c_int) :: nc_get_att_longlong
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ENOTATT Attribute not found.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
end function nc_get_att_longlong

function nc_put_att_longlong(ncid, varid, name, xtype, len, op) bind(c, name="nc_put_att_longlong")
  !! Write an attribute using longlong memory storage.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! New or enlarged attributes in classic files require define mode.
  import :: c_int, c_char, c_size_t, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier, or NC_GLOBAL for a file/group attribute.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated object name.
  integer(c_int), value :: xtype
  !! Destination NetCDF numeric type; the suffix selects the source memory type.
  integer(c_size_t), value :: len
  !! Number of attribute elements (characters for NC_CHAR, strings for NC_STRING).
  type(c_ptr), value :: op
  !! Pointer to contiguous integer(c_long_long) storage.
  integer(c_int) :: nc_put_att_longlong
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_EPERM Dataset is read-only.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
end function nc_put_att_longlong

function nc_get_att_float(ncid, varid, name, ip) bind(c, name="nc_get_att_float")
  !! Read an attribute using float memory storage.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! Allocate enough storage for the count returned by nc_inq_attlen().
  import :: c_int, c_char, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier, or NC_GLOBAL for a file/group attribute.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated object name.
  type(c_ptr), value :: ip
  !! Pointer to contiguous real(c_float) storage.
  integer(c_int) :: nc_get_att_float
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ENOTATT Attribute not found.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
end function nc_get_att_float

function nc_put_att_float(ncid, varid, name, xtype, len, op) bind(c, name="nc_put_att_float")
  !! Write an attribute using float memory storage.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! New or enlarged attributes in classic files require define mode.
  import :: c_int, c_char, c_size_t, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier, or NC_GLOBAL for a file/group attribute.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated object name.
  integer(c_int), value :: xtype
  !! Destination NetCDF numeric type; the suffix selects the source memory type.
  integer(c_size_t), value :: len
  !! Number of attribute elements (characters for NC_CHAR, strings for NC_STRING).
  type(c_ptr), value :: op
  !! Pointer to contiguous real(c_float) storage.
  integer(c_int) :: nc_put_att_float
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_EPERM Dataset is read-only.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
end function nc_put_att_float

function nc_get_att_double(ncid, varid, name, ip) bind(c, name="nc_get_att_double")
  !! Read an attribute using double memory storage.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! Allocate enough storage for the count returned by nc_inq_attlen().
  import :: c_int, c_char, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier, or NC_GLOBAL for a file/group attribute.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated object name.
  type(c_ptr), value :: ip
  !! Pointer to contiguous real(c_double) storage.
  integer(c_int) :: nc_get_att_double
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ENOTATT Attribute not found.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
end function nc_get_att_double

function nc_put_att_double(ncid, varid, name, xtype, len, op) bind(c, name="nc_put_att_double")
  !! Write an attribute using double memory storage.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! New or enlarged attributes in classic files require define mode.
  import :: c_int, c_char, c_size_t, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier, or NC_GLOBAL for a file/group attribute.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated object name.
  integer(c_int), value :: xtype
  !! Destination NetCDF numeric type; the suffix selects the source memory type.
  integer(c_size_t), value :: len
  !! Number of attribute elements (characters for NC_CHAR, strings for NC_STRING).
  type(c_ptr), value :: op
  !! Pointer to contiguous real(c_double) storage.
  integer(c_int) :: nc_put_att_double
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_EPERM Dataset is read-only.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
end function nc_put_att_double

function nc_get_att_text(ncid, varid, name, ip) bind(c, name="nc_get_att_text")
  !! Read an attribute using text memory storage.
  !! Transfers NC_CHAR values; numeric conversion is not supported.
  !! Allocate enough storage for the count returned by nc_inq_attlen().
  import :: c_int, c_char, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier, or NC_GLOBAL for a file/group attribute.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated object name.
  type(c_ptr), value :: ip
  !! Pointer to contiguous character(kind=c_char) storage; text data need not be NUL-terminated.
  integer(c_int) :: nc_get_att_text
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ENOTATT Attribute not found.
end function nc_get_att_text

function nc_put_att_text(ncid, varid, name, len, op) bind(c, name="nc_put_att_text")
  !! Write an attribute using text memory storage.
  !! Transfers NC_CHAR values; numeric conversion is not supported.
  !! New or enlarged attributes in classic files require define mode.
  import :: c_int, c_char, c_size_t, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier, or NC_GLOBAL for a file/group attribute.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated object name.
  integer(c_size_t), value :: len
  !! Number of attribute elements (characters for NC_CHAR, strings for NC_STRING).
  type(c_ptr), value :: op
  !! Pointer to contiguous character(kind=c_char) storage; text data need not be NUL-terminated.
  integer(c_int) :: nc_put_att_text
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_EPERM Dataset is read-only.
end function nc_put_att_text

function nc_get_att_string(ncid, varid, name, ip) bind(c, name="nc_get_att_string")
  !! Read an attribute using string memory storage.
  !! Transfers NC_STRING values; no conversion to NC_CHAR is performed.
  !! Allocate enough storage for the count returned by nc_inq_attlen().
  import :: c_int, c_char, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier, or NC_GLOBAL for a file/group attribute.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated object name.
  type(c_ptr), value :: ip
  !! Pointer to a caller-allocated array of c_ptr slots (C char **).
  !! NetCDF allocates each returned string; release with nc_free_string().
  integer(c_int) :: nc_get_att_string
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ENOTATT Attribute not found.
end function nc_get_att_string

function nc_put_att_string(ncid, varid, name, len, op) bind(c, name="nc_put_att_string")
  !! Write an attribute using string memory storage.
  !! Transfers NC_STRING values; no conversion to NC_CHAR is performed.
  !! New or enlarged attributes in classic files require define mode.
  import :: c_int, c_char, c_size_t, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier, or NC_GLOBAL for a file/group attribute.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated object name.
  integer(c_size_t), value :: len
  !! Number of attribute elements (characters for NC_CHAR, strings for NC_STRING).
  type(c_ptr), value :: op
  !! Pointer to an array of c_ptr values referencing NUL-terminated strings.
  !! The caller retains ownership of the pointer array and strings.
  integer(c_int) :: nc_put_att_string
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_EPERM Dataset is read-only.
end function nc_put_att_string

! Additional serial C API, including legacy and extension interfaces.

function ncattput(ncid, varid, name, xtype, len, op) bind(c, name="ncattput")
  !! Legacy v2 API: Write an attribute.
  !! Uses v2 return/error conventions, not modern NC_NOERR status semantics.
  !! Legacy process-global ncopts controls fatal errors and diagnostics; no accessor is provided.
  !! C declaration: int ncattput(int ncid, int varid, const char *name, nc_type xtype, int len, const void
  !! *op);
  import :: c_int, c_char, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated C string.
  integer(c_int), value :: xtype
  !! NetCDF type identifier.
  integer(c_int), value :: len
  !! Element count (not bytes except for byte/text types).
  type(c_ptr), value :: op
  !! Pointer to C-compatible storage. C pointee: const void *.
  integer(c_int) :: ncattput
  !! V2 result (ID, size, previous setting, or success value); -1 indicates failure.
end function ncattput

function ncattinq(ncid, varid, name, xtypep, lenp) bind(c, name="ncattinq")
  !! Legacy v2 API: Query attribute type and length.
  !! Uses v2 return/error conventions, not modern NC_NOERR status semantics.
  !! Legacy process-global ncopts controls fatal errors and diagnostics; no accessor is provided.
  !! C declaration: int ncattinq(int ncid, int varid, const char *name, nc_type *xtypep, int *lenp);
  import :: c_int, c_char
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated C string.
  integer(c_int), intent(out) :: xtypep
  !! Returned xtypep value (C nc_type).
  integer(c_int), intent(out) :: lenp
  !! Returned lenp value (C int).
  integer(c_int) :: ncattinq
  !! V2 result (ID, size, previous setting, or success value); -1 indicates failure.
end function ncattinq

function ncattget(ncid, varid, name, ip) bind(c, name="ncattget")
  !! Legacy v2 API: Read an attribute.
  !! Uses v2 return/error conventions, not modern NC_NOERR status semantics.
  !! Legacy process-global ncopts controls fatal errors and diagnostics; no accessor is provided.
  !! C declaration: int ncattget(int ncid, int varid, const char *name, void *ip);
  import :: c_int, c_char, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated C string.
  type(c_ptr), value :: ip
  !! Pointer to C-compatible storage. C pointee: void *.
  integer(c_int) :: ncattget
  !! V2 result (ID, size, previous setting, or success value); -1 indicates failure.
end function ncattget

function ncattcopy(ncid_in, varid_in, name, ncid_out, varid_out) bind(c, name="ncattcopy")
  !! Legacy v2 API: Copy an attribute.
  !! Uses v2 return/error conventions, not modern NC_NOERR status semantics.
  !! Legacy process-global ncopts controls fatal errors and diagnostics; no accessor is provided.
  !! C declaration: int ncattcopy(int ncid_in, int varid_in, const char *name, int ncid_out, int varid_out);
  import :: c_int, c_char
  integer(c_int), value :: ncid_in
  !! Source dataset/group identifier.
  integer(c_int), value :: varid_in
  !! Source variable identifier, or NC_GLOBAL.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated C string.
  integer(c_int), value :: ncid_out
  !! Destination dataset/group identifier.
  integer(c_int), value :: varid_out
  !! Destination variable identifier, or NC_GLOBAL.
  integer(c_int) :: ncattcopy
  !! V2 result (ID, size, previous setting, or success value); -1 indicates failure.
end function ncattcopy

function ncattname(ncid, varid, attnum, name) bind(c, name="ncattname")
  !! Legacy v2 API: Find an attribute name by index.
  !! Uses v2 return/error conventions, not modern NC_NOERR status semantics.
  !! Legacy process-global ncopts controls fatal errors and diagnostics; no accessor is provided.
  !! C declaration: int ncattname(int ncid, int varid, int attnum, char *name);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  integer(c_int), value :: attnum
  !! C int argument attnum.
  type(c_ptr), value :: name
  !! Pointer to caller-provided C character output storage (NC_MAX_NAME + 1 for names).
  integer(c_int) :: ncattname
  !! V2 result (ID, size, previous setting, or success value); -1 indicates failure.
end function ncattname

function ncattrename(ncid, varid, name, newname) bind(c, name="ncattrename")
  !! Legacy v2 API: Rename an attribute.
  !! Uses v2 return/error conventions, not modern NC_NOERR status semantics.
  !! Legacy process-global ncopts controls fatal errors and diagnostics; no accessor is provided.
  !! C declaration: int ncattrename(int ncid, int varid, const char *name, const char *newname);
  import :: c_int, c_char
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated C string.
  character(kind=c_char), intent(in) :: newname(*)
  !! NUL-terminated C string.
  integer(c_int) :: ncattrename
  !! V2 result (ID, size, previous setting, or success value); -1 indicates failure.
end function ncattrename

function ncattdel(ncid, varid, name) bind(c, name="ncattdel")
  !! Legacy v2 API: Delete an attribute.
  !! Uses v2 return/error conventions, not modern NC_NOERR status semantics.
  !! Legacy process-global ncopts controls fatal errors and diagnostics; no accessor is provided.
  !! C declaration: int ncattdel(int ncid, int varid, const char *name);
  import :: c_int, c_char
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated C string.
  integer(c_int) :: ncattdel
  !! V2 result (ID, size, previous setting, or success value); -1 indicates failure.
end function ncattdel
