module nc4f_c_interface
!! Low-level ISO_C_BINDING interfaces to the NetCDF C library.
!! These bindings retain C indexing, dimension order, string termination,
!! memory ownership, and status-code semantics. They do not apply CF decoding.
!! Include fragments share this module's public namespace and interface block.
!! Buffer pointers must reference correctly typed, contiguous, live storage.
!! Only arguments declared as type(c_ptr), value accept c_null_ptr.
!! Unsigned-integer APIs and entry points requiring C adapters are omitted.
!! Legacy result conventions and direct symbol aliases are documented individually.
use, intrinsic :: iso_c_binding, only: c_int, c_ptr, c_char, c_size_t, c_long, c_float, c_long_long, c_double
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
integer(c_size_t), parameter :: NC_UNLIMITED = 0_c_size_t
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
integer(c_int), parameter :: NC_UBYTE = 7_c_int
!! unsigned 1 byte int
integer(c_int), parameter :: NC_USHORT = 8_c_int
!! unsigned 2-byte int
integer(c_int), parameter :: NC_UINT = 9_c_int
!! unsigned 4-byte int
integer(c_int), parameter :: NC_INT64 = 10_c_int
!! signed 8-byte int
integer(c_int), parameter :: NC_UINT64 = 11_c_int
!! unsigned 8-byte int
integer(c_int), parameter :: NC_STRING = 12_c_int
!! string

! Format, storage, and status constants for the low-level interfaces.
integer(c_int), parameter :: NC_CLASSIC_MODEL = 256_c_int
!! Enforce the classic data model in a NetCDF-4 file.
integer(c_int), parameter :: NC_64BIT_OFFSET = 512_c_int
!! Create a CDF-2 file with 64-bit offsets.
integer(c_int), parameter :: NC_64BIT_DATA = 32_c_int
!! Create a CDF-5 file with 64-bit sizes and additional integer types.
integer(c_int), parameter :: NC_CDF5 = NC_64BIT_DATA
!! Alias for NC_64BIT_DATA.
integer(c_int), parameter :: NC_SHARE = 2048_c_int
!! Limit caching for shared classic-file access.
integer(c_int), parameter :: NC_FORMAT_CLASSIC = 1_c_int
!! Classic CDF-1 format returned by nc_inq_format().
integer(c_int), parameter :: NC_FORMAT_64BIT_OFFSET = 2_c_int
!! CDF-2 format returned by nc_inq_format().
integer(c_int), parameter :: NC_FORMAT_NETCDF4 = 3_c_int
!! NetCDF-4 enhanced format returned by nc_inq_format().
integer(c_int), parameter :: NC_FORMAT_NETCDF4_CLASSIC = 4_c_int
!! NetCDF-4 classic-model format returned by nc_inq_format().
integer(c_int), parameter :: NC_FORMAT_64BIT_DATA = 5_c_int
!! CDF-5 format returned by nc_inq_format().
integer(c_int), parameter :: NC_FORMAT_CDF5 = NC_FORMAT_64BIT_DATA
!! Alias for NC_FORMAT_64BIT_DATA.
integer(c_int), parameter :: NC_FORMATX_UNDEFINED = 0_c_int
!! Unknown backend returned by nc_inq_format_extended().
integer(c_int), parameter :: NC_FORMATX_NC3 = 1_c_int
!! Classic-format backend.
integer(c_int), parameter :: NC_FORMATX_NC_HDF5 = 2_c_int
!! NetCDF-4/HDF5 backend.
integer(c_int), parameter :: NC_FORMATX_NC4 = NC_FORMATX_NC_HDF5
!! Alias for the NetCDF-4/HDF5 backend.
integer(c_int), parameter :: NC_FORMATX_NC_HDF4 = 3_c_int
!! HDF4 backend, if enabled in NetCDF.
integer(c_int), parameter :: NC_FORMATX_PNETCDF = 4_c_int
!! Parallel-NetCDF backend.
integer(c_int), parameter :: NC_FORMATX_DAP2 = 5_c_int
!! DAP2 remote backend.
integer(c_int), parameter :: NC_FORMATX_DAP4 = 6_c_int
!! DAP4 remote backend.
integer(c_int), parameter :: NC_FILL = 0_c_int
!! Enable filling of unwritten data with nc_set_fill().
integer(c_int), parameter :: NC_NOFILL = 256_c_int
!! Disable dataset filling with nc_set_fill().
integer(c_int), parameter :: NC_CHUNKED = 0_c_int
!! Store a variable as chunks.
integer(c_int), parameter :: NC_CONTIGUOUS = 1_c_int
!! Store a variable contiguously.
integer(c_int), parameter :: NC_COMPACT = 2_c_int
!! Store a small variable in the HDF5 header, where supported.
integer(c_int), parameter :: NC_ENDIAN_NATIVE = 0_c_int
!! Use native byte order.
integer(c_int), parameter :: NC_ENDIAN_LITTLE = 1_c_int
!! Use little-endian byte order.
integer(c_int), parameter :: NC_ENDIAN_BIG = 2_c_int
!! Use big-endian byte order.
integer(c_int), parameter :: NC_NOCHECKSUM = 0_c_int
!! Disable checksumming.
integer(c_int), parameter :: NC_FLETCHER32 = 1_c_int
!! Enable Fletcher32 checksumming.
integer(c_int), parameter :: NC_NOSHUFFLE = 0_c_int
!! Disable the shuffle filter.
integer(c_int), parameter :: NC_SHUFFLE = 1_c_int
!! Enable the shuffle filter.
integer(c_int), parameter :: NC_MIN_DEFLATE_LEVEL = 0_c_int
!! Minimum zlib compression level.
integer(c_int), parameter :: NC_MAX_DEFLATE_LEVEL = 9_c_int
!! Maximum zlib compression level.
integer(c_int), parameter :: NC_MAX_VAR_DIMS = 1024_c_int
!! Maximum variable rank advertised by the C API; backends may impose lower limits.
integer(c_int), parameter :: NC_ENFILE = -34_c_int
!! Too many files open.
integer(c_int), parameter :: NC_EEXIST = -35_c_int
!! File exists and NC_NOCLOBBER was requested.
integer(c_int), parameter :: NC_EPERM = -37_c_int
!! Write attempted on a read-only dataset.
integer(c_int), parameter :: NC_ENOTINDEFINE = -38_c_int
!! Operation requires define mode.
integer(c_int), parameter :: NC_EINDEFINE = -39_c_int
!! Operation is not allowed in define mode.
integer(c_int), parameter :: NC_ENAMEINUSE = -42_c_int
!! Object name is already in use.
integer(c_int), parameter :: NC_EBADTYPE = -45_c_int
!! Invalid or incompatible NetCDF type.
integer(c_int), parameter :: NC_ECHAR = -56_c_int
!! Conversion between characters and numbers is forbidden.
integer(c_int), parameter :: NC_ESTRIDE = -58_c_int
!! Invalid stride.
integer(c_int), parameter :: NC_EBADNAME = -59_c_int
!! Invalid object name.
integer(c_int), parameter :: NC_ERANGE = -60_c_int
!! Numeric conversion is out of range.
integer(c_int), parameter :: NC_ENOMEM = -61_c_int
!! Memory allocation failed.
integer(c_int), parameter :: NC_EVARSIZE = -62_c_int
!! Variable size violates format limits.
integer(c_int), parameter :: NC_EDIMSIZE = -63_c_int
!! Invalid dimension length.
integer(c_int), parameter :: NC_ENOTNC = -51_c_int
!! Not a NetCDF file.
integer(c_int), parameter :: NC_EUNLIMPOS = -47_c_int
!! Unlimited dimension in an invalid position.
integer(c_int), parameter :: NC_EUNLIMIT = -54_c_int
!! An unlimited dimension already exists.
integer(c_int), parameter :: NC_EMAXNAME = -53_c_int
!! Object name is too long.
integer(c_int), parameter :: NC_ENOTNC4 = -111_c_int
!! Operation requires a NetCDF-4 file.
integer(c_int), parameter :: NC_ESTRICTNC3 = -112_c_int
!! Operation violates the classic data model.
integer(c_int), parameter :: NC_ELATEFILL = -122_c_int
!! Fill value was set after data were written.
integer(c_int), parameter :: NC_ELATEDEF = -123_c_int
!! Storage settings were set too late.
integer(c_int), parameter :: NC_EBADCHUNK = -127_c_int
!! Invalid chunk size.
integer(c_int), parameter :: NC_EHDFERR = -101_c_int
!! HDF5 backend error.

integer(c_int), parameter :: NC_VLEN = 13_c_int
!! vlen (variable-length) types
integer(c_int), parameter :: NC_OPAQUE = 14_c_int
!! opaque types
integer(c_int), parameter :: NC_ENUM = 15_c_int
!! enum types
integer(c_int), parameter :: NC_COMPOUND = 16_c_int
!! compound types
integer(c_int), parameter :: NC_FIRSTUSERTYPEID = 32_c_int
!! First identifier available for user-defined types.
integer(c_int), parameter :: NC_FILL_INT = -2147483647_c_int
!! Default fill value for NC_INT variables.
integer(c_int), parameter :: NC_FILL_UBYTE = 255_c_int
!! Default fill value for NC_UBYTE variables.
integer(c_int), parameter :: NC_MAX_BYTE = 127_c_int
!! Maximum value representable by NC_BYTE.
integer(c_int), parameter :: NC_MAX_CHAR = 255_c_int
!! Maximum unsigned byte value for NC_CHAR storage.
integer(c_int), parameter :: NC_MAX_INT = 2147483647_c_int
!! Maximum value representable by NC_INT.
integer(c_int), parameter :: NC_DISKLESS = 8_c_int
!! Use diskless file. Mode flag for nc_open() or nc_create().
integer(c_int), parameter :: NC_MMAP = 16_c_int
!! Use diskless file with mmap. Mode flag for nc_open() or nc_create()
integer(c_int), parameter :: NC_UDF0 = 64_c_int
!! User-defined format 0 (bit 6).
integer(c_int), parameter :: NC_UDF1 = 128_c_int
!! User-defined format 1 (bit 7).
integer(c_int), parameter :: NC_UDF2 = 65536_c_int
!! User-defined format 2 (bit 16).
integer(c_int), parameter :: NC_UDF3 = 524288_c_int
!! User-defined format 3 (bit 19).
integer(c_int), parameter :: NC_UDF4 = 1048576_c_int
!! User-defined format 4 (bit 20).
integer(c_int), parameter :: NC_UDF5 = 2097152_c_int
!! User-defined format 5 (bit 21).
integer(c_int), parameter :: NC_UDF6 = 4194304_c_int
!! User-defined format 6 (bit 22).
integer(c_int), parameter :: NC_UDF7 = 8388608_c_int
!! User-defined format 7 (bit 23).
integer(c_int), parameter :: NC_UDF8 = 16777216_c_int
!! User-defined format 8 (bit 24).
integer(c_int), parameter :: NC_UDF9 = 33554432_c_int
!! User-defined format 9 (bit 25).
integer(c_int), parameter :: NC_LOCK = 1024_c_int
!! Deprecated advisory-locking flag; currently ignored by NetCDF.
integer(c_int), parameter :: NC_PERSIST = 16384_c_int
!! Save diskless contents to disk. Mode flag for nc_open() or nc_create()
integer(c_int), parameter :: NC_INMEMORY = 32768_c_int
!! Read from memory. Mode flag for nc_open() or nc_create()
integer(c_int), parameter :: NC_NOATTCREORD = 131072_c_int
!! Disable the netcdf-4 (hdf5) attribute creation order tracking
integer(c_int), parameter :: NC_NODIMSCALE_ATTACH = 262144_c_int
!! Disable the netcdf-4 (hdf5) attaching of dimscales to variables (#2128)
integer(c_int), parameter :: NC_MAX_MAGIC_NUMBER_LEN = 8_c_int
!! Max len of user-defined format magic number.
integer(c_int), parameter :: NC_MAX_UDF_FORMATS = 10_c_int
!! NetCDF C constant NC_MAX_UDF_FORMATS.
integer(c_int), parameter :: NC_FORMATX_UDF0 = 8_c_int
!! User-defined format 0
integer(c_int), parameter :: NC_FORMATX_UDF1 = 9_c_int
!! User-defined format 1
integer(c_int), parameter :: NC_FORMATX_NCZARR = 10_c_int
!! Added in version 4.8.0
integer(c_int), parameter :: NC_FORMATX_UDF2 = 11_c_int
!! User-defined format 2
integer(c_int), parameter :: NC_FORMATX_UDF3 = 12_c_int
!! User-defined format 3
integer(c_int), parameter :: NC_FORMATX_UDF4 = 13_c_int
!! User-defined format 4
integer(c_int), parameter :: NC_FORMATX_UDF5 = 14_c_int
!! User-defined format 5
integer(c_int), parameter :: NC_FORMATX_UDF6 = 15_c_int
!! User-defined format 6
integer(c_int), parameter :: NC_FORMATX_UDF7 = 16_c_int
!! User-defined format 7
integer(c_int), parameter :: NC_FORMATX_UDF8 = 17_c_int
!! User-defined format 8
integer(c_int), parameter :: NC_FORMATX_UDF9 = 18_c_int
!! User-defined format 9
integer(c_size_t), parameter :: NC_SIZEHINT_DEFAULT = 0_c_size_t
!! Request the library's default I/O buffer size hint.
integer(c_int), parameter :: NC_MAX_ATTRS = 8192_c_int
!! not enforced after 4.5.0
integer(c_int), parameter :: NC_MAX_VARS = 8192_c_int
!! not enforced after 4.5.0
integer(c_int), parameter :: NC_VIRTUAL = 4_c_int
!! Virtual variable storage layout identifier.
integer(c_int), parameter :: NC_SZIP_NN = 32_c_int
!! SZIP NN option mask.
integer(c_int), parameter :: NC_SZIP_EC = 4_c_int
!! SZIP EC option mask.
integer(c_int), parameter :: NC_NOQUANTIZE = 0_c_int
!! No quantization in use.
integer(c_int), parameter :: NC_QUANTIZE_BITGROOM = 1_c_int
!! Use BitGroom quantization.
integer(c_int), parameter :: NC_QUANTIZE_GRANULARBR = 2_c_int
!! Use Granular BitRound quantization.
integer(c_int), parameter :: NC_QUANTIZE_BITROUND = 3_c_int
!! Use BitRound quantization.
integer(c_int), parameter :: NC_QUANTIZE_MAX_FLOAT_NSD = 6_c_int
!! Maximum significant decimal digits for quantizing NC_FLOAT values.
integer(c_int), parameter :: NC_QUANTIZE_MAX_DOUBLE_NSD = 15_c_int
!! Maximum significant decimal digits for quantizing NC_DOUBLE values.
integer(c_int), parameter :: NC_EMAXDIMS = -41_c_int
!! not enforced after 4.5.0
integer(c_int), parameter :: NC_EMAXATTS = -44_c_int
!! NC_MAX_ATTRS exceeded - not enforced after 4.5.0
integer(c_int), parameter :: NC_EMAXVARS = -48_c_int
!! not enforced after 4.5.0
integer(c_int), parameter :: NC_ESTS = -52_c_int
!! In Fortran, string too short
integer(c_int), parameter :: NC_ENORECVARS = -55_c_int
!! nc_rec op when there are no record vars
integer(c_int), parameter :: NC_ETRUNC = -64_c_int
!! File likely truncated or possibly corrupted
integer(c_int), parameter :: NC_EAXISTYPE = -65_c_int
!! Unknown axis type.
integer(c_int), parameter :: NC_EDAP = -66_c_int
!! Generic DAP error
integer(c_int), parameter :: NC_ECURL = -67_c_int
!! Generic libcurl error
integer(c_int), parameter :: NC_EIO = -68_c_int
!! Generic IO error
integer(c_int), parameter :: NC_ENODATA = -69_c_int
!! Attempt to access variable with no data
integer(c_int), parameter :: NC_EDAPSVC = -70_c_int
!! DAP server error
integer(c_int), parameter :: NC_EDAS = -71_c_int
!! Malformed or inaccessible DAS
integer(c_int), parameter :: NC_EDDS = -72_c_int
!! Malformed or inaccessible DDS
integer(c_int), parameter :: NC_EDATADDS = -73_c_int
!! Malformed or inaccessible DATADDS
integer(c_int), parameter :: NC_EDAPURL = -74_c_int
!! Malformed DAP URL
integer(c_int), parameter :: NC_EDAPCONSTRAINT = -75_c_int
!! Malformed DAP Constraint
integer(c_int), parameter :: NC_ETRANSLATION = -76_c_int
!! Untranslatable construct
integer(c_int), parameter :: NC_EACCESS = -77_c_int
!! Access Failure
integer(c_int), parameter :: NC_EAUTH = -78_c_int
!! Authorization Failure
integer(c_int), parameter :: NC_ECANTREMOVE = -91_c_int
!! Can't remove file
integer(c_int), parameter :: NC_EINTERNAL = -92_c_int
!! NetCDF Library Internal Error
integer(c_int), parameter :: NC_EPNETCDF = -93_c_int
!! Error at PnetCDF layer
integer(c_int), parameter :: NC_ECANTREAD = -102_c_int
!! Can't read.
integer(c_int), parameter :: NC_ECANTWRITE = -103_c_int
!! Can't write.
integer(c_int), parameter :: NC_ECANTCREATE = -104_c_int
!! Can't create.
integer(c_int), parameter :: NC_EFILEMETA = -105_c_int
!! Problem with file metadata.
integer(c_int), parameter :: NC_EDIMMETA = -106_c_int
!! Problem with dimension metadata.
integer(c_int), parameter :: NC_EATTMETA = -107_c_int
!! Problem with attribute metadata.
integer(c_int), parameter :: NC_EVARMETA = -108_c_int
!! Problem with variable metadata.
integer(c_int), parameter :: NC_ENOCOMPOUND = -109_c_int
!! Not a compound type.
integer(c_int), parameter :: NC_EATTEXISTS = -110_c_int
!! Attribute already exists.
integer(c_int), parameter :: NC_ENOTNC3 = -113_c_int
!! Attempting netcdf-3 operation on netcdf-4 file.
integer(c_int), parameter :: NC_ENOPAR = -114_c_int
!! Parallel operation on file opened for non-parallel access.
integer(c_int), parameter :: NC_EPARINIT = -115_c_int
!! Error initializing for parallel access.
integer(c_int), parameter :: NC_EBADTYPID = -117_c_int
!! Bad type ID.
integer(c_int), parameter :: NC_ETYPDEFINED = -118_c_int
!! Type has already been defined and may not be edited.
integer(c_int), parameter :: NC_EBADFIELD = -119_c_int
!! Bad field ID.
integer(c_int), parameter :: NC_EBADCLASS = -120_c_int
!! Bad class.
integer(c_int), parameter :: NC_EMAPTYPE = -121_c_int
!! Mapped access for atomic types only.
integer(c_int), parameter :: NC_EDIMSCALE = -124_c_int
!! Problem with HDF5 dimscales.
integer(c_int), parameter :: NC_ESTORAGE = -126_c_int
!! Can't specify both contiguous and chunking.
integer(c_int), parameter :: NC_ENOTBUILT = -128_c_int
!! Attempt to use feature that was not turned on when netCDF was built.
integer(c_int), parameter :: NC_EDISKLESS = -129_c_int
!! Error in using diskless  access.
integer(c_int), parameter :: NC_ECANTEXTEND = -130_c_int
!! Attempt to extend dataset during ind. I/O operation.
integer(c_int), parameter :: NC_EMPI = -131_c_int
!! MPI operation failed.
integer(c_int), parameter :: NC_EFILTER = -132_c_int
!! Filter operation failed.
integer(c_int), parameter :: NC_ERCFILE = -133_c_int
!! RC file failure
integer(c_int), parameter :: NC_ENULLPAD = -134_c_int
!! Header Bytes not Null-Byte padded
integer(c_int), parameter :: NC_EINMEMORY = -135_c_int
!! In-memory file error
integer(c_int), parameter :: NC_ENOFILTER = -136_c_int
!! Filter not defined on variable.
integer(c_int), parameter :: NC_ENCZARR = -137_c_int
!! Error at NCZarr layer.
integer(c_int), parameter :: NC_ES3 = -138_c_int
!! Generic S3 error
integer(c_int), parameter :: NC_EEMPTY = -139_c_int
!! Attempt to read empty NCZarr map key
integer(c_int), parameter :: NC_EOBJECT = -140_c_int
!! Some object exists when it should not
integer(c_int), parameter :: NC_ENOOBJECT = -141_c_int
!! Some object not found
integer(c_int), parameter :: NC_EPLUGIN = -142_c_int
!! Unclassified failure in accessing a dynamically loaded plugin>
integer(c_int), parameter :: NC_ENOTZARR = -143_c_int
!! Malformed (NC)Zarr file
integer(c_int), parameter :: NC_EZARRMETA = -144_c_int
!! Invalid (NC)Zarr file consolidated metadata
integer(c_int), parameter :: NC_HAVE_NEW_CHUNKING_API = 1_c_int
!! NetCDF C constant NC_HAVE_NEW_CHUNKING_API.
integer(c_int), parameter :: NC_TURN_OFF_LOGGING = -1_c_int
!! Disable diagnostic logging with nc_set_log_level().
integer(c_int), parameter :: NC_EXDR = -32_c_int
!! V2 API error.
integer(c_int), parameter :: NC_SYSERR = -31_c_int
!! V2 API system error.
integer(c_int), parameter :: NC_FATAL = 1_c_int
!! For V2 API, exit on error.
integer(c_int), parameter :: NC_VERBOSE = 2_c_int
!! For V2 API, be verbose on error.
integer(c_int), parameter :: NC_MEMIO_LOCKED = 1_c_int
!! Do not try to realloc or free provided memory
integer(c_int), parameter :: NC_MAX_PIXELS_PER_BLOCK = 32_c_int
!! Maximum pixels_per_block accepted by nc_def_var_szip().
integer(c_int), parameter :: NCAUX_ALIGN_C = 0_c_int
!! Use native C alignment in auxiliary compound-type builders.
integer(c_int), parameter :: NC_DISPATCH_VERSION = 5_c_int
!! Dispatch table ABI version for the NetCDF-C 4.10.1 baseline.

! C ABI descriptor layouts. Pointer components are C pointers, not Fortran pointers.
type, bind(c) :: nc_vlen_t
  !! Variable-length sequence descriptor. Read payloads require explicit reclamation.
  integer(c_size_t) :: len
  !! Number of base-type elements.
  type(c_ptr) :: p
  !! Address of the payload.
end type nc_vlen_t

type, bind(c) :: NC_memio
  !! Memory-file descriptor from netcdf_mem.h.
  integer(c_size_t) :: size
  !! Image capacity/length in bytes, according to the operation.
  type(c_ptr) :: memory
  !! Image address; ownership depends on flags and the open/close operation.
  integer(c_int) :: flags
  !! NC_MEMIO_LOCKED prevents the library from reallocating or freeing caller storage.
end type NC_memio

type, bind(c) :: NCPluginList
  !! Plugin path list from netcdf_filter.h; initialize dirs to c_null_ptr before allocating calls.
  integer(c_size_t) :: ndirs
  !! Number of directory strings.
  type(c_ptr) :: dirs
  !! Address of a C char ** directory vector.
end type NCPluginList

interface
  pure function c_strlen(str) bind(c, name="strlen") result(length)
    !! Return the length of a NUL-terminated C string.
    import :: c_ptr, c_size_t
    type(c_ptr), value :: str
    !! Pointer to a live NUL-terminated C string; must not be c_null_ptr.
    integer(c_size_t) :: length
    !! Number of bytes before the first NUL, excluding the terminator.
  end function c_strlen

  function nc_strerror(ncerr1) bind(c, name="nc_strerror")
    !! Given an error number, return an error message.
    import :: c_int, c_ptr
    integer(c_int), value :: ncerr1
    !! error number
    type(c_ptr) :: nc_strerror
    !! Library-owned NUL-terminated error message; do not free or modify it.
  end function nc_strerror

  subroutine c_free(memory) bind(c, name="free")
    !! Release a C allocation, such as nc_rc_get() or an unlocked memory-file image.
    !! Never pass a Fortran allocation or a borrowed pointer. c_null_ptr is allowed.
    import :: c_ptr
    type(c_ptr), value :: memory
    !! C-allocated address to release.
  end subroutine c_free

  function c_malloc(size) bind(c, name="malloc")
    !! Allocate C-owned storage for APIs that may resize or free the input buffer.
    import :: c_ptr, c_size_t
    integer(c_size_t), value :: size
    !! Requested allocation size in bytes.
    type(c_ptr) :: c_malloc
    !! Allocated address, or c_null_ptr on allocation failure; release with c_free().
  end function c_malloc

  include 'nc4f_c_interface_dataset.inc'
  include 'nc4f_c_interface_group.inc'
  include 'nc4f_c_interface_dimension.inc'
  include 'nc4f_c_interface_variable.inc'
  include 'nc4f_c_interface_attribute.inc'
  include 'nc4f_c_interface_io.inc'
end interface

end module nc4f_c_interface
