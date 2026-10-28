! Variable value transfer and cleanup of NetCDF-allocated strings.
! Included inside the interface block of nc4f_c_interface.

function nc_get_var(ncid, varid, ip) bind(c, name="nc_get_var")
  !! Read an entire variable in one call.
  !! The memory type must match the file type; no numeric conversion is performed.
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
  !! The memory type must match the file type; no numeric conversion is performed.
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

function nc_put_var(ncid, varid, op) bind(c, name="nc_put_var")
  !! Write an entire variable with one call.
  !! The memory type must match the file type; no numeric conversion is performed.
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
  !! The memory type must match the file type; no numeric conversion is performed.
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

function nc_get_vara(ncid, varid, startp, countp, ip) bind(c, name="nc_get_vara")
  !! Read a contiguous hyperslab.
  !! No numeric conversion is performed; memory and file types must match.
  !! Index vectors use C order; a Fortran-order wrapper must reverse dimension order.
  !! For rank-zero variables, start/count/stride pointers may be c_null_ptr.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: startp
  !! Pointer to rank zero-based indices of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: countp
  !! Pointer to rank element counts of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: ip
  !! Pointer to contiguous storage matching the variable's exact memory type.
  integer(c_int) :: nc_get_vara
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_EINVALCOORDS Invalid starting index.
  !! - NC_EEDGE Hyperslab exceeds a fixed dimension.
end function nc_get_vara

function nc_put_vars(ncid, varid, startp, countp, stridep, op) bind(c, name="nc_put_vars")
  !! Write a strided hyperslab.
  !! No numeric conversion is performed; memory and file types must match.
  !! Index vectors use C order; a Fortran-order wrapper must reverse dimension order.
  !! For rank-zero variables, start/count/stride pointers may be c_null_ptr.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: startp
  !! Pointer to rank zero-based indices of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: countp
  !! Pointer to rank element counts of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: stridep
  !! Pointer to rank positive strides of integer(c_ptrdiff_t), in C dimension order.
  !! Pass c_null_ptr for unit strides.
  type(c_ptr), value :: op
  !! Pointer to contiguous storage matching the variable's exact memory type.
  integer(c_int) :: nc_put_vars
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_EINVALCOORDS Invalid starting index.
  !! - NC_EEDGE Hyperslab exceeds a fixed dimension.
  !! - NC_ESTRIDE Invalid stride.
  !! - NC_EPERM Dataset is read-only.
end function nc_put_vars

function nc_get_var_schar(ncid, varid, ip) bind(c, name="nc_get_var_schar")
  !! Read an entire variable.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! The buffer must hold every current element; use hyperslabs when extending records.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: ip
  !! Pointer to contiguous integer(c_signed_char) storage.
  integer(c_int) :: nc_get_var_schar
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
end function nc_get_var_schar

function nc_get_vara_schar(ncid, varid, startp, countp, ip) bind(c, name="nc_get_vara_schar")
  !! Read a contiguous hyperslab.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! Index vectors use C order; a Fortran-order wrapper must reverse dimension order.
  !! For rank-zero variables, start/count/stride pointers may be c_null_ptr.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: startp
  !! Pointer to rank zero-based indices of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: countp
  !! Pointer to rank element counts of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: ip
  !! Pointer to contiguous integer(c_signed_char) storage.
  integer(c_int) :: nc_get_vara_schar
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
  !! - NC_EINVALCOORDS Invalid starting index.
  !! - NC_EEDGE Hyperslab exceeds a fixed dimension.
end function nc_get_vara_schar

function nc_get_vars_schar(ncid, varid, startp, countp, stridep, ip) bind(c, name="nc_get_vars_schar")
  !! Read a strided hyperslab.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! Index vectors use C order; a Fortran-order wrapper must reverse dimension order.
  !! For rank-zero variables, start/count/stride pointers may be c_null_ptr.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: startp
  !! Pointer to rank zero-based indices of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: countp
  !! Pointer to rank element counts of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: stridep
  !! Pointer to rank positive strides of integer(c_ptrdiff_t), in C dimension order.
  !! Pass c_null_ptr for unit strides.
  type(c_ptr), value :: ip
  !! Pointer to contiguous integer(c_signed_char) storage.
  integer(c_int) :: nc_get_vars_schar
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
  !! - NC_EINVALCOORDS Invalid starting index.
  !! - NC_EEDGE Hyperslab exceeds a fixed dimension.
  !! - NC_ESTRIDE Invalid stride.
end function nc_get_vars_schar

function nc_put_var_schar(ncid, varid, op) bind(c, name="nc_put_var_schar")
  !! Write an entire variable.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! The buffer must hold every current element; use hyperslabs when extending records.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: op
  !! Pointer to contiguous integer(c_signed_char) storage.
  integer(c_int) :: nc_put_var_schar
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
  !! - NC_EPERM Dataset is read-only.
end function nc_put_var_schar

function nc_put_vara_schar(ncid, varid, startp, countp, op) bind(c, name="nc_put_vara_schar")
  !! Write a contiguous hyperslab.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! Index vectors use C order; a Fortran-order wrapper must reverse dimension order.
  !! For rank-zero variables, start/count/stride pointers may be c_null_ptr.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: startp
  !! Pointer to rank zero-based indices of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: countp
  !! Pointer to rank element counts of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: op
  !! Pointer to contiguous integer(c_signed_char) storage.
  integer(c_int) :: nc_put_vara_schar
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
  !! - NC_EINVALCOORDS Invalid starting index.
  !! - NC_EEDGE Hyperslab exceeds a fixed dimension.
  !! - NC_EPERM Dataset is read-only.
end function nc_put_vara_schar

function nc_put_vars_schar(ncid, varid, startp, countp, stridep, op) bind(c, name="nc_put_vars_schar")
  !! Write a strided hyperslab.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! Index vectors use C order; a Fortran-order wrapper must reverse dimension order.
  !! For rank-zero variables, start/count/stride pointers may be c_null_ptr.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: startp
  !! Pointer to rank zero-based indices of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: countp
  !! Pointer to rank element counts of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: stridep
  !! Pointer to rank positive strides of integer(c_ptrdiff_t), in C dimension order.
  !! Pass c_null_ptr for unit strides.
  type(c_ptr), value :: op
  !! Pointer to contiguous integer(c_signed_char) storage.
  integer(c_int) :: nc_put_vars_schar
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
  !! - NC_EINVALCOORDS Invalid starting index.
  !! - NC_EEDGE Hyperslab exceeds a fixed dimension.
  !! - NC_ESTRIDE Invalid stride.
  !! - NC_EPERM Dataset is read-only.
end function nc_put_vars_schar

function nc_get_var_short(ncid, varid, ip) bind(c, name="nc_get_var_short")
  !! Read an entire variable.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! The buffer must hold every current element; use hyperslabs when extending records.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: ip
  !! Pointer to contiguous integer(c_short) storage.
  integer(c_int) :: nc_get_var_short
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
end function nc_get_var_short

function nc_get_vara_short(ncid, varid, startp, countp, ip) bind(c, name="nc_get_vara_short")
  !! Read a contiguous hyperslab.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! Index vectors use C order; a Fortran-order wrapper must reverse dimension order.
  !! For rank-zero variables, start/count/stride pointers may be c_null_ptr.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: startp
  !! Pointer to rank zero-based indices of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: countp
  !! Pointer to rank element counts of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: ip
  !! Pointer to contiguous integer(c_short) storage.
  integer(c_int) :: nc_get_vara_short
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
  !! - NC_EINVALCOORDS Invalid starting index.
  !! - NC_EEDGE Hyperslab exceeds a fixed dimension.
end function nc_get_vara_short

function nc_get_vars_short(ncid, varid, startp, countp, stridep, ip) bind(c, name="nc_get_vars_short")
  !! Read a strided hyperslab.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! Index vectors use C order; a Fortran-order wrapper must reverse dimension order.
  !! For rank-zero variables, start/count/stride pointers may be c_null_ptr.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: startp
  !! Pointer to rank zero-based indices of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: countp
  !! Pointer to rank element counts of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: stridep
  !! Pointer to rank positive strides of integer(c_ptrdiff_t), in C dimension order.
  !! Pass c_null_ptr for unit strides.
  type(c_ptr), value :: ip
  !! Pointer to contiguous integer(c_short) storage.
  integer(c_int) :: nc_get_vars_short
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
  !! - NC_EINVALCOORDS Invalid starting index.
  !! - NC_EEDGE Hyperslab exceeds a fixed dimension.
  !! - NC_ESTRIDE Invalid stride.
end function nc_get_vars_short

function nc_put_var_short(ncid, varid, op) bind(c, name="nc_put_var_short")
  !! Write an entire variable.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! The buffer must hold every current element; use hyperslabs when extending records.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: op
  !! Pointer to contiguous integer(c_short) storage.
  integer(c_int) :: nc_put_var_short
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
  !! - NC_EPERM Dataset is read-only.
end function nc_put_var_short

function nc_put_vara_short(ncid, varid, startp, countp, op) bind(c, name="nc_put_vara_short")
  !! Write a contiguous hyperslab.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! Index vectors use C order; a Fortran-order wrapper must reverse dimension order.
  !! For rank-zero variables, start/count/stride pointers may be c_null_ptr.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: startp
  !! Pointer to rank zero-based indices of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: countp
  !! Pointer to rank element counts of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: op
  !! Pointer to contiguous integer(c_short) storage.
  integer(c_int) :: nc_put_vara_short
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
  !! - NC_EINVALCOORDS Invalid starting index.
  !! - NC_EEDGE Hyperslab exceeds a fixed dimension.
  !! - NC_EPERM Dataset is read-only.
end function nc_put_vara_short

function nc_put_vars_short(ncid, varid, startp, countp, stridep, op) bind(c, name="nc_put_vars_short")
  !! Write a strided hyperslab.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! Index vectors use C order; a Fortran-order wrapper must reverse dimension order.
  !! For rank-zero variables, start/count/stride pointers may be c_null_ptr.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: startp
  !! Pointer to rank zero-based indices of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: countp
  !! Pointer to rank element counts of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: stridep
  !! Pointer to rank positive strides of integer(c_ptrdiff_t), in C dimension order.
  !! Pass c_null_ptr for unit strides.
  type(c_ptr), value :: op
  !! Pointer to contiguous integer(c_short) storage.
  integer(c_int) :: nc_put_vars_short
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
  !! - NC_EINVALCOORDS Invalid starting index.
  !! - NC_EEDGE Hyperslab exceeds a fixed dimension.
  !! - NC_ESTRIDE Invalid stride.
  !! - NC_EPERM Dataset is read-only.
end function nc_put_vars_short

function nc_get_var_int(ncid, varid, ip) bind(c, name="nc_get_var_int")
  !! Read an entire variable.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! The buffer must hold every current element; use hyperslabs when extending records.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: ip
  !! Pointer to contiguous integer(c_int) storage.
  integer(c_int) :: nc_get_var_int
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
end function nc_get_var_int

function nc_get_vara_int(ncid, varid, startp, countp, ip) bind(c, name="nc_get_vara_int")
  !! Read a contiguous hyperslab.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! Index vectors use C order; a Fortran-order wrapper must reverse dimension order.
  !! For rank-zero variables, start/count/stride pointers may be c_null_ptr.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: startp
  !! Pointer to rank zero-based indices of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: countp
  !! Pointer to rank element counts of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: ip
  !! Pointer to contiguous integer(c_int) storage.
  integer(c_int) :: nc_get_vara_int
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
  !! - NC_EINVALCOORDS Invalid starting index.
  !! - NC_EEDGE Hyperslab exceeds a fixed dimension.
end function nc_get_vara_int

function nc_get_vars_int(ncid, varid, startp, countp, stridep, ip) bind(c, name="nc_get_vars_int")
  !! Read a strided hyperslab.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! Index vectors use C order; a Fortran-order wrapper must reverse dimension order.
  !! For rank-zero variables, start/count/stride pointers may be c_null_ptr.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: startp
  !! Pointer to rank zero-based indices of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: countp
  !! Pointer to rank element counts of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: stridep
  !! Pointer to rank positive strides of integer(c_ptrdiff_t), in C dimension order.
  !! Pass c_null_ptr for unit strides.
  type(c_ptr), value :: ip
  !! Pointer to contiguous integer(c_int) storage.
  integer(c_int) :: nc_get_vars_int
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
  !! - NC_EINVALCOORDS Invalid starting index.
  !! - NC_EEDGE Hyperslab exceeds a fixed dimension.
  !! - NC_ESTRIDE Invalid stride.
end function nc_get_vars_int

function nc_put_var_int(ncid, varid, op) bind(c, name="nc_put_var_int")
  !! Write an entire variable.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! The buffer must hold every current element; use hyperslabs when extending records.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: op
  !! Pointer to contiguous integer(c_int) storage.
  integer(c_int) :: nc_put_var_int
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
  !! - NC_EPERM Dataset is read-only.
end function nc_put_var_int

function nc_put_vara_int(ncid, varid, startp, countp, op) bind(c, name="nc_put_vara_int")
  !! Write a contiguous hyperslab.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! Index vectors use C order; a Fortran-order wrapper must reverse dimension order.
  !! For rank-zero variables, start/count/stride pointers may be c_null_ptr.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: startp
  !! Pointer to rank zero-based indices of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: countp
  !! Pointer to rank element counts of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: op
  !! Pointer to contiguous integer(c_int) storage.
  integer(c_int) :: nc_put_vara_int
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
  !! - NC_EINVALCOORDS Invalid starting index.
  !! - NC_EEDGE Hyperslab exceeds a fixed dimension.
  !! - NC_EPERM Dataset is read-only.
end function nc_put_vara_int

function nc_put_vars_int(ncid, varid, startp, countp, stridep, op) bind(c, name="nc_put_vars_int")
  !! Write a strided hyperslab.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! Index vectors use C order; a Fortran-order wrapper must reverse dimension order.
  !! For rank-zero variables, start/count/stride pointers may be c_null_ptr.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: startp
  !! Pointer to rank zero-based indices of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: countp
  !! Pointer to rank element counts of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: stridep
  !! Pointer to rank positive strides of integer(c_ptrdiff_t), in C dimension order.
  !! Pass c_null_ptr for unit strides.
  type(c_ptr), value :: op
  !! Pointer to contiguous integer(c_int) storage.
  integer(c_int) :: nc_put_vars_int
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
  !! - NC_EINVALCOORDS Invalid starting index.
  !! - NC_EEDGE Hyperslab exceeds a fixed dimension.
  !! - NC_ESTRIDE Invalid stride.
  !! - NC_EPERM Dataset is read-only.
end function nc_put_vars_int

function nc_get_var_long(ncid, varid, ip) bind(c, name="nc_get_var_long")
  !! Read an entire variable.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! The buffer must hold every current element; use hyperslabs when extending records.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: ip
  !! Pointer to contiguous integer(c_long) storage.
  integer(c_int) :: nc_get_var_long
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
end function nc_get_var_long

function nc_get_vara_long(ncid, varid, startp, countp, ip) bind(c, name="nc_get_vara_long")
  !! Read a contiguous hyperslab.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! Index vectors use C order; a Fortran-order wrapper must reverse dimension order.
  !! For rank-zero variables, start/count/stride pointers may be c_null_ptr.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: startp
  !! Pointer to rank zero-based indices of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: countp
  !! Pointer to rank element counts of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: ip
  !! Pointer to contiguous integer(c_long) storage.
  integer(c_int) :: nc_get_vara_long
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
  !! - NC_EINVALCOORDS Invalid starting index.
  !! - NC_EEDGE Hyperslab exceeds a fixed dimension.
end function nc_get_vara_long

function nc_get_vars_long(ncid, varid, startp, countp, stridep, ip) bind(c, name="nc_get_vars_long")
  !! Read a strided hyperslab.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! Index vectors use C order; a Fortran-order wrapper must reverse dimension order.
  !! For rank-zero variables, start/count/stride pointers may be c_null_ptr.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: startp
  !! Pointer to rank zero-based indices of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: countp
  !! Pointer to rank element counts of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: stridep
  !! Pointer to rank positive strides of integer(c_ptrdiff_t), in C dimension order.
  !! Pass c_null_ptr for unit strides.
  type(c_ptr), value :: ip
  !! Pointer to contiguous integer(c_long) storage.
  integer(c_int) :: nc_get_vars_long
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
  !! - NC_EINVALCOORDS Invalid starting index.
  !! - NC_EEDGE Hyperslab exceeds a fixed dimension.
  !! - NC_ESTRIDE Invalid stride.
end function nc_get_vars_long

function nc_put_var_long(ncid, varid, op) bind(c, name="nc_put_var_long")
  !! Write an entire variable.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! The buffer must hold every current element; use hyperslabs when extending records.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: op
  !! Pointer to contiguous integer(c_long) storage.
  integer(c_int) :: nc_put_var_long
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
  !! - NC_EPERM Dataset is read-only.
end function nc_put_var_long

function nc_put_vara_long(ncid, varid, startp, countp, op) bind(c, name="nc_put_vara_long")
  !! Write a contiguous hyperslab.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! Index vectors use C order; a Fortran-order wrapper must reverse dimension order.
  !! For rank-zero variables, start/count/stride pointers may be c_null_ptr.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: startp
  !! Pointer to rank zero-based indices of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: countp
  !! Pointer to rank element counts of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: op
  !! Pointer to contiguous integer(c_long) storage.
  integer(c_int) :: nc_put_vara_long
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
  !! - NC_EINVALCOORDS Invalid starting index.
  !! - NC_EEDGE Hyperslab exceeds a fixed dimension.
  !! - NC_EPERM Dataset is read-only.
end function nc_put_vara_long

function nc_put_vars_long(ncid, varid, startp, countp, stridep, op) bind(c, name="nc_put_vars_long")
  !! Write a strided hyperslab.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! Index vectors use C order; a Fortran-order wrapper must reverse dimension order.
  !! For rank-zero variables, start/count/stride pointers may be c_null_ptr.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: startp
  !! Pointer to rank zero-based indices of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: countp
  !! Pointer to rank element counts of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: stridep
  !! Pointer to rank positive strides of integer(c_ptrdiff_t), in C dimension order.
  !! Pass c_null_ptr for unit strides.
  type(c_ptr), value :: op
  !! Pointer to contiguous integer(c_long) storage.
  integer(c_int) :: nc_put_vars_long
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
  !! - NC_EINVALCOORDS Invalid starting index.
  !! - NC_EEDGE Hyperslab exceeds a fixed dimension.
  !! - NC_ESTRIDE Invalid stride.
  !! - NC_EPERM Dataset is read-only.
end function nc_put_vars_long

function nc_get_var_longlong(ncid, varid, ip) bind(c, name="nc_get_var_longlong")
  !! Read an entire variable.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! The buffer must hold every current element; use hyperslabs when extending records.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: ip
  !! Pointer to contiguous integer(c_long_long) storage.
  integer(c_int) :: nc_get_var_longlong
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
end function nc_get_var_longlong

function nc_get_vara_longlong(ncid, varid, startp, countp, ip) bind(c, name="nc_get_vara_longlong")
  !! Read a contiguous hyperslab.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! Index vectors use C order; a Fortran-order wrapper must reverse dimension order.
  !! For rank-zero variables, start/count/stride pointers may be c_null_ptr.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: startp
  !! Pointer to rank zero-based indices of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: countp
  !! Pointer to rank element counts of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: ip
  !! Pointer to contiguous integer(c_long_long) storage.
  integer(c_int) :: nc_get_vara_longlong
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
  !! - NC_EINVALCOORDS Invalid starting index.
  !! - NC_EEDGE Hyperslab exceeds a fixed dimension.
end function nc_get_vara_longlong

function nc_get_vars_longlong(ncid, varid, startp, countp, stridep, ip) bind(c, name="nc_get_vars_longlong")
  !! Read a strided hyperslab.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! Index vectors use C order; a Fortran-order wrapper must reverse dimension order.
  !! For rank-zero variables, start/count/stride pointers may be c_null_ptr.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: startp
  !! Pointer to rank zero-based indices of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: countp
  !! Pointer to rank element counts of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: stridep
  !! Pointer to rank positive strides of integer(c_ptrdiff_t), in C dimension order.
  !! Pass c_null_ptr for unit strides.
  type(c_ptr), value :: ip
  !! Pointer to contiguous integer(c_long_long) storage.
  integer(c_int) :: nc_get_vars_longlong
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
  !! - NC_EINVALCOORDS Invalid starting index.
  !! - NC_EEDGE Hyperslab exceeds a fixed dimension.
  !! - NC_ESTRIDE Invalid stride.
end function nc_get_vars_longlong

function nc_put_var_longlong(ncid, varid, op) bind(c, name="nc_put_var_longlong")
  !! Write an entire variable.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! The buffer must hold every current element; use hyperslabs when extending records.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: op
  !! Pointer to contiguous integer(c_long_long) storage.
  integer(c_int) :: nc_put_var_longlong
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
  !! - NC_EPERM Dataset is read-only.
end function nc_put_var_longlong

function nc_put_vara_longlong(ncid, varid, startp, countp, op) bind(c, name="nc_put_vara_longlong")
  !! Write a contiguous hyperslab.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! Index vectors use C order; a Fortran-order wrapper must reverse dimension order.
  !! For rank-zero variables, start/count/stride pointers may be c_null_ptr.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: startp
  !! Pointer to rank zero-based indices of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: countp
  !! Pointer to rank element counts of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: op
  !! Pointer to contiguous integer(c_long_long) storage.
  integer(c_int) :: nc_put_vara_longlong
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
  !! - NC_EINVALCOORDS Invalid starting index.
  !! - NC_EEDGE Hyperslab exceeds a fixed dimension.
  !! - NC_EPERM Dataset is read-only.
end function nc_put_vara_longlong

function nc_put_vars_longlong(ncid, varid, startp, countp, stridep, op) bind(c, name="nc_put_vars_longlong")
  !! Write a strided hyperslab.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! Index vectors use C order; a Fortran-order wrapper must reverse dimension order.
  !! For rank-zero variables, start/count/stride pointers may be c_null_ptr.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: startp
  !! Pointer to rank zero-based indices of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: countp
  !! Pointer to rank element counts of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: stridep
  !! Pointer to rank positive strides of integer(c_ptrdiff_t), in C dimension order.
  !! Pass c_null_ptr for unit strides.
  type(c_ptr), value :: op
  !! Pointer to contiguous integer(c_long_long) storage.
  integer(c_int) :: nc_put_vars_longlong
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
  !! - NC_EINVALCOORDS Invalid starting index.
  !! - NC_EEDGE Hyperslab exceeds a fixed dimension.
  !! - NC_ESTRIDE Invalid stride.
  !! - NC_EPERM Dataset is read-only.
end function nc_put_vars_longlong

function nc_get_var_float(ncid, varid, ip) bind(c, name="nc_get_var_float")
  !! Read an entire variable.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! The buffer must hold every current element; use hyperslabs when extending records.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: ip
  !! Pointer to contiguous real(c_float) storage.
  integer(c_int) :: nc_get_var_float
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
end function nc_get_var_float

function nc_get_vara_float(ncid, varid, startp, countp, ip) bind(c, name="nc_get_vara_float")
  !! Read a contiguous hyperslab.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! Index vectors use C order; a Fortran-order wrapper must reverse dimension order.
  !! For rank-zero variables, start/count/stride pointers may be c_null_ptr.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: startp
  !! Pointer to rank zero-based indices of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: countp
  !! Pointer to rank element counts of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: ip
  !! Pointer to contiguous real(c_float) storage.
  integer(c_int) :: nc_get_vara_float
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
  !! - NC_EINVALCOORDS Invalid starting index.
  !! - NC_EEDGE Hyperslab exceeds a fixed dimension.
end function nc_get_vara_float

function nc_get_vars_float(ncid, varid, startp, countp, stridep, ip) bind(c, name="nc_get_vars_float")
  !! Read a strided hyperslab.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! Index vectors use C order; a Fortran-order wrapper must reverse dimension order.
  !! For rank-zero variables, start/count/stride pointers may be c_null_ptr.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: startp
  !! Pointer to rank zero-based indices of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: countp
  !! Pointer to rank element counts of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: stridep
  !! Pointer to rank positive strides of integer(c_ptrdiff_t), in C dimension order.
  !! Pass c_null_ptr for unit strides.
  type(c_ptr), value :: ip
  !! Pointer to contiguous real(c_float) storage.
  integer(c_int) :: nc_get_vars_float
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
  !! - NC_EINVALCOORDS Invalid starting index.
  !! - NC_EEDGE Hyperslab exceeds a fixed dimension.
  !! - NC_ESTRIDE Invalid stride.
end function nc_get_vars_float

function nc_put_var_float(ncid, varid, op) bind(c, name="nc_put_var_float")
  !! Write an entire variable.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! The buffer must hold every current element; use hyperslabs when extending records.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: op
  !! Pointer to contiguous real(c_float) storage.
  integer(c_int) :: nc_put_var_float
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
  !! - NC_EPERM Dataset is read-only.
end function nc_put_var_float

function nc_put_vara_float(ncid, varid, startp, countp, op) bind(c, name="nc_put_vara_float")
  !! Write a contiguous hyperslab.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! Index vectors use C order; a Fortran-order wrapper must reverse dimension order.
  !! For rank-zero variables, start/count/stride pointers may be c_null_ptr.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: startp
  !! Pointer to rank zero-based indices of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: countp
  !! Pointer to rank element counts of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: op
  !! Pointer to contiguous real(c_float) storage.
  integer(c_int) :: nc_put_vara_float
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
  !! - NC_EINVALCOORDS Invalid starting index.
  !! - NC_EEDGE Hyperslab exceeds a fixed dimension.
  !! - NC_EPERM Dataset is read-only.
end function nc_put_vara_float

function nc_put_vars_float(ncid, varid, startp, countp, stridep, op) bind(c, name="nc_put_vars_float")
  !! Write a strided hyperslab.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! Index vectors use C order; a Fortran-order wrapper must reverse dimension order.
  !! For rank-zero variables, start/count/stride pointers may be c_null_ptr.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: startp
  !! Pointer to rank zero-based indices of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: countp
  !! Pointer to rank element counts of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: stridep
  !! Pointer to rank positive strides of integer(c_ptrdiff_t), in C dimension order.
  !! Pass c_null_ptr for unit strides.
  type(c_ptr), value :: op
  !! Pointer to contiguous real(c_float) storage.
  integer(c_int) :: nc_put_vars_float
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
  !! - NC_EINVALCOORDS Invalid starting index.
  !! - NC_EEDGE Hyperslab exceeds a fixed dimension.
  !! - NC_ESTRIDE Invalid stride.
  !! - NC_EPERM Dataset is read-only.
end function nc_put_vars_float

function nc_get_var_double(ncid, varid, ip) bind(c, name="nc_get_var_double")
  !! Read an entire variable.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! The buffer must hold every current element; use hyperslabs when extending records.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: ip
  !! Pointer to contiguous real(c_double) storage.
  integer(c_int) :: nc_get_var_double
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
end function nc_get_var_double

function nc_get_vara_double(ncid, varid, startp, countp, ip) bind(c, name="nc_get_vara_double")
  !! Read a contiguous hyperslab.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! Index vectors use C order; a Fortran-order wrapper must reverse dimension order.
  !! For rank-zero variables, start/count/stride pointers may be c_null_ptr.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: startp
  !! Pointer to rank zero-based indices of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: countp
  !! Pointer to rank element counts of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: ip
  !! Pointer to contiguous real(c_double) storage.
  integer(c_int) :: nc_get_vara_double
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
  !! - NC_EINVALCOORDS Invalid starting index.
  !! - NC_EEDGE Hyperslab exceeds a fixed dimension.
end function nc_get_vara_double

function nc_get_vars_double(ncid, varid, startp, countp, stridep, ip) bind(c, name="nc_get_vars_double")
  !! Read a strided hyperslab.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! Index vectors use C order; a Fortran-order wrapper must reverse dimension order.
  !! For rank-zero variables, start/count/stride pointers may be c_null_ptr.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: startp
  !! Pointer to rank zero-based indices of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: countp
  !! Pointer to rank element counts of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: stridep
  !! Pointer to rank positive strides of integer(c_ptrdiff_t), in C dimension order.
  !! Pass c_null_ptr for unit strides.
  type(c_ptr), value :: ip
  !! Pointer to contiguous real(c_double) storage.
  integer(c_int) :: nc_get_vars_double
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
  !! - NC_EINVALCOORDS Invalid starting index.
  !! - NC_EEDGE Hyperslab exceeds a fixed dimension.
  !! - NC_ESTRIDE Invalid stride.
end function nc_get_vars_double

function nc_put_var_double(ncid, varid, op) bind(c, name="nc_put_var_double")
  !! Write an entire variable.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! The buffer must hold every current element; use hyperslabs when extending records.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: op
  !! Pointer to contiguous real(c_double) storage.
  integer(c_int) :: nc_put_var_double
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
  !! - NC_EPERM Dataset is read-only.
end function nc_put_var_double

function nc_put_vara_double(ncid, varid, startp, countp, op) bind(c, name="nc_put_vara_double")
  !! Write a contiguous hyperslab.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! Index vectors use C order; a Fortran-order wrapper must reverse dimension order.
  !! For rank-zero variables, start/count/stride pointers may be c_null_ptr.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: startp
  !! Pointer to rank zero-based indices of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: countp
  !! Pointer to rank element counts of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: op
  !! Pointer to contiguous real(c_double) storage.
  integer(c_int) :: nc_put_vara_double
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
  !! - NC_EINVALCOORDS Invalid starting index.
  !! - NC_EEDGE Hyperslab exceeds a fixed dimension.
  !! - NC_EPERM Dataset is read-only.
end function nc_put_vara_double

function nc_put_vars_double(ncid, varid, startp, countp, stridep, op) bind(c, name="nc_put_vars_double")
  !! Write a strided hyperslab.
  !! The suffix selects the memory type; NetCDF converts to or from the file's numeric type.
  !! Index vectors use C order; a Fortran-order wrapper must reverse dimension order.
  !! For rank-zero variables, start/count/stride pointers may be c_null_ptr.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: startp
  !! Pointer to rank zero-based indices of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: countp
  !! Pointer to rank element counts of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: stridep
  !! Pointer to rank positive strides of integer(c_ptrdiff_t), in C dimension order.
  !! Pass c_null_ptr for unit strides.
  type(c_ptr), value :: op
  !! Pointer to contiguous real(c_double) storage.
  integer(c_int) :: nc_put_vars_double
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_ERANGE Numeric conversion exceeds the destination range.
  !! - NC_EINVALCOORDS Invalid starting index.
  !! - NC_EEDGE Hyperslab exceeds a fixed dimension.
  !! - NC_ESTRIDE Invalid stride.
  !! - NC_EPERM Dataset is read-only.
end function nc_put_vars_double

function nc_get_var_text(ncid, varid, ip) bind(c, name="nc_get_var_text")
  !! Read an entire variable.
  !! Transfers NC_CHAR values; numeric conversion is not supported.
  !! The buffer must hold every current element; use hyperslabs when extending records.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: ip
  !! Pointer to contiguous character(kind=c_char) storage; text data need not be NUL-terminated.
  integer(c_int) :: nc_get_var_text
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
end function nc_get_var_text

function nc_get_vara_text(ncid, varid, startp, countp, ip) bind(c, name="nc_get_vara_text")
  !! Read a contiguous hyperslab.
  !! Transfers NC_CHAR values; numeric conversion is not supported.
  !! Index vectors use C order; a Fortran-order wrapper must reverse dimension order.
  !! For rank-zero variables, start/count/stride pointers may be c_null_ptr.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: startp
  !! Pointer to rank zero-based indices of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: countp
  !! Pointer to rank element counts of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: ip
  !! Pointer to contiguous character(kind=c_char) storage; text data need not be NUL-terminated.
  integer(c_int) :: nc_get_vara_text
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_EINVALCOORDS Invalid starting index.
  !! - NC_EEDGE Hyperslab exceeds a fixed dimension.
end function nc_get_vara_text

function nc_get_vars_text(ncid, varid, startp, countp, stridep, ip) bind(c, name="nc_get_vars_text")
  !! Read a strided hyperslab.
  !! Transfers NC_CHAR values; numeric conversion is not supported.
  !! Index vectors use C order; a Fortran-order wrapper must reverse dimension order.
  !! For rank-zero variables, start/count/stride pointers may be c_null_ptr.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: startp
  !! Pointer to rank zero-based indices of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: countp
  !! Pointer to rank element counts of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: stridep
  !! Pointer to rank positive strides of integer(c_ptrdiff_t), in C dimension order.
  !! Pass c_null_ptr for unit strides.
  type(c_ptr), value :: ip
  !! Pointer to contiguous character(kind=c_char) storage; text data need not be NUL-terminated.
  integer(c_int) :: nc_get_vars_text
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_EINVALCOORDS Invalid starting index.
  !! - NC_EEDGE Hyperslab exceeds a fixed dimension.
  !! - NC_ESTRIDE Invalid stride.
end function nc_get_vars_text

function nc_put_var_text(ncid, varid, op) bind(c, name="nc_put_var_text")
  !! Write an entire variable.
  !! Transfers NC_CHAR values; numeric conversion is not supported.
  !! The buffer must hold every current element; use hyperslabs when extending records.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: op
  !! Pointer to contiguous character(kind=c_char) storage; text data need not be NUL-terminated.
  integer(c_int) :: nc_put_var_text
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_EPERM Dataset is read-only.
end function nc_put_var_text

function nc_put_vara_text(ncid, varid, startp, countp, op) bind(c, name="nc_put_vara_text")
  !! Write a contiguous hyperslab.
  !! Transfers NC_CHAR values; numeric conversion is not supported.
  !! Index vectors use C order; a Fortran-order wrapper must reverse dimension order.
  !! For rank-zero variables, start/count/stride pointers may be c_null_ptr.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: startp
  !! Pointer to rank zero-based indices of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: countp
  !! Pointer to rank element counts of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: op
  !! Pointer to contiguous character(kind=c_char) storage; text data need not be NUL-terminated.
  integer(c_int) :: nc_put_vara_text
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_EINVALCOORDS Invalid starting index.
  !! - NC_EEDGE Hyperslab exceeds a fixed dimension.
  !! - NC_EPERM Dataset is read-only.
end function nc_put_vara_text

function nc_put_vars_text(ncid, varid, startp, countp, stridep, op) bind(c, name="nc_put_vars_text")
  !! Write a strided hyperslab.
  !! Transfers NC_CHAR values; numeric conversion is not supported.
  !! Index vectors use C order; a Fortran-order wrapper must reverse dimension order.
  !! For rank-zero variables, start/count/stride pointers may be c_null_ptr.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: startp
  !! Pointer to rank zero-based indices of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: countp
  !! Pointer to rank element counts of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: stridep
  !! Pointer to rank positive strides of integer(c_ptrdiff_t), in C dimension order.
  !! Pass c_null_ptr for unit strides.
  type(c_ptr), value :: op
  !! Pointer to contiguous character(kind=c_char) storage; text data need not be NUL-terminated.
  integer(c_int) :: nc_put_vars_text
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_EINVALCOORDS Invalid starting index.
  !! - NC_EEDGE Hyperslab exceeds a fixed dimension.
  !! - NC_ESTRIDE Invalid stride.
  !! - NC_EPERM Dataset is read-only.
end function nc_put_vars_text

function nc_get_var_string(ncid, varid, ip) bind(c, name="nc_get_var_string")
  !! Read an entire variable.
  !! Transfers NC_STRING values; no conversion to NC_CHAR is performed.
  !! The buffer must hold every current element; use hyperslabs when extending records.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: ip
  !! Pointer to a caller-allocated array of c_ptr slots (C char **).
  !! NetCDF allocates each returned string; release with nc_free_string().
  integer(c_int) :: nc_get_var_string
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
end function nc_get_var_string

function nc_get_vara_string(ncid, varid, startp, countp, ip) bind(c, name="nc_get_vara_string")
  !! Read a contiguous hyperslab.
  !! Transfers NC_STRING values; no conversion to NC_CHAR is performed.
  !! Index vectors use C order; a Fortran-order wrapper must reverse dimension order.
  !! For rank-zero variables, start/count/stride pointers may be c_null_ptr.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: startp
  !! Pointer to rank zero-based indices of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: countp
  !! Pointer to rank element counts of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: ip
  !! Pointer to a caller-allocated array of c_ptr slots (C char **).
  !! NetCDF allocates each returned string; release with nc_free_string().
  integer(c_int) :: nc_get_vara_string
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_EINVALCOORDS Invalid starting index.
  !! - NC_EEDGE Hyperslab exceeds a fixed dimension.
end function nc_get_vara_string

function nc_get_vars_string(ncid, varid, startp, countp, stridep, ip) bind(c, name="nc_get_vars_string")
  !! Read a strided hyperslab.
  !! Transfers NC_STRING values; no conversion to NC_CHAR is performed.
  !! Index vectors use C order; a Fortran-order wrapper must reverse dimension order.
  !! For rank-zero variables, start/count/stride pointers may be c_null_ptr.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: startp
  !! Pointer to rank zero-based indices of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: countp
  !! Pointer to rank element counts of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: stridep
  !! Pointer to rank positive strides of integer(c_ptrdiff_t), in C dimension order.
  !! Pass c_null_ptr for unit strides.
  type(c_ptr), value :: ip
  !! Pointer to a caller-allocated array of c_ptr slots (C char **).
  !! NetCDF allocates each returned string; release with nc_free_string().
  integer(c_int) :: nc_get_vars_string
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_EINVALCOORDS Invalid starting index.
  !! - NC_EEDGE Hyperslab exceeds a fixed dimension.
  !! - NC_ESTRIDE Invalid stride.
end function nc_get_vars_string

function nc_put_var_string(ncid, varid, op) bind(c, name="nc_put_var_string")
  !! Write an entire variable.
  !! Transfers NC_STRING values; no conversion to NC_CHAR is performed.
  !! The buffer must hold every current element; use hyperslabs when extending records.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: op
  !! Pointer to an array of c_ptr values referencing NUL-terminated strings.
  !! The caller retains ownership of the pointer array and strings.
  integer(c_int) :: nc_put_var_string
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_EPERM Dataset is read-only.
end function nc_put_var_string

function nc_put_vara_string(ncid, varid, startp, countp, op) bind(c, name="nc_put_vara_string")
  !! Write a contiguous hyperslab.
  !! Transfers NC_STRING values; no conversion to NC_CHAR is performed.
  !! Index vectors use C order; a Fortran-order wrapper must reverse dimension order.
  !! For rank-zero variables, start/count/stride pointers may be c_null_ptr.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: startp
  !! Pointer to rank zero-based indices of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: countp
  !! Pointer to rank element counts of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: op
  !! Pointer to an array of c_ptr values referencing NUL-terminated strings.
  !! The caller retains ownership of the pointer array and strings.
  integer(c_int) :: nc_put_vara_string
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_EINVALCOORDS Invalid starting index.
  !! - NC_EEDGE Hyperslab exceeds a fixed dimension.
  !! - NC_EPERM Dataset is read-only.
end function nc_put_vara_string

function nc_put_vars_string(ncid, varid, startp, countp, stridep, op) bind(c, name="nc_put_vars_string")
  !! Write a strided hyperslab.
  !! Transfers NC_STRING values; no conversion to NC_CHAR is performed.
  !! Index vectors use C order; a Fortran-order wrapper must reverse dimension order.
  !! For rank-zero variables, start/count/stride pointers may be c_null_ptr.
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier scoped by ncid.
  type(c_ptr), value :: startp
  !! Pointer to rank zero-based indices of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: countp
  !! Pointer to rank element counts of integer(c_size_t), in C dimension order.
  type(c_ptr), value :: stridep
  !! Pointer to rank positive strides of integer(c_ptrdiff_t), in C dimension order.
  !! Pass c_null_ptr for unit strides.
  type(c_ptr), value :: op
  !! Pointer to an array of c_ptr values referencing NUL-terminated strings.
  !! The caller retains ownership of the pointer array and strings.
  integer(c_int) :: nc_put_vars_string
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTVAR Invalid variable identifier.
  !! - NC_EINVALCOORDS Invalid starting index.
  !! - NC_EEDGE Hyperslab exceeds a fixed dimension.
  !! - NC_ESTRIDE Invalid stride.
  !! - NC_EPERM Dataset is read-only.
end function nc_put_vars_string

function nc_free_string(len, data) bind(c, name="nc_free_string")
  !! Free strings allocated by NetCDF string reads.
  !! Frees the pointed-to strings, not the pointer array itself.
  !! Do not call on caller-owned input strings; do not reuse or free returned strings twice.
  import :: c_int, c_size_t, c_ptr
  integer(c_size_t), value :: len
  !! Number of string pointers in the array.
  type(c_ptr), value :: data
  !! Pointer to the caller-owned array of c_ptr slots (C char **).
  integer(c_int) :: nc_free_string
  !! **Options:**
  !! - NC_NOERR No error.
end function nc_free_string

! Additional serial C API, including legacy and extension interfaces.

function nc_put_vlen_element(ncid, typeid1, vlen_element, len, data) bind(c, name="nc_put_vlen_element")
  !! Populate one nc_vlen_t descriptor from caller-owned element storage.
  !! The descriptor borrows data; do not reclaim caller-owned input payloads.
  !! C declaration: int nc_put_vlen_element(int ncid, int typeid1, void *vlen_element, size_t len, const void
  !! *data);
  import :: c_int, c_ptr, c_size_t
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: typeid1
  !! NetCDF type identifier.
  type(c_ptr), value :: vlen_element
  !! Address of one nc_vlen_t descriptor. C pointee: void *.
  integer(c_size_t), value :: len
  !! Element count (not bytes except for byte/text types).
  type(c_ptr), value :: data
  !! Payload data buffer. C pointee: const void *.
  integer(c_int) :: nc_put_vlen_element
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_put_vlen_element

function nc_get_vlen_element(ncid, typeid1, vlen_element, len, data) bind(c, name="nc_get_vlen_element")
  !! Copy one variable-length descriptor payload into caller storage.
  !! C declaration: int nc_get_vlen_element(int ncid, int typeid1, const void *vlen_element, size_t *len,
  !! void *data);
  import :: c_int, c_ptr, c_size_t
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: typeid1
  !! NetCDF type identifier.
  type(c_ptr), value :: vlen_element
  !! Address of one nc_vlen_t descriptor. C pointee: const void *.
  integer(c_size_t), intent(out) :: len
  !! Returned len value (C size_t).
  type(c_ptr), value :: data
  !! Payload data buffer. C pointee: void *.
  integer(c_int) :: nc_get_vlen_element
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_get_vlen_element

function nc_put_var1(ncid, varid, indexp, op) bind(c, name="nc_put_var1")
  !! Write one variable element.
  !! No numeric conversion is performed; match the file type in memory.
  !! C declaration: int nc_put_var1(int ncid, int varid, const size_t *indexp, const void *op);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: indexp
  !! Zero-based element indices in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: op
  !! Pointer to C-compatible storage. C pointee: const void *.
  integer(c_int) :: nc_put_var1
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_put_var1

function nc_get_var1(ncid, varid, indexp, ip) bind(c, name="nc_get_var1")
  !! Read one variable element.
  !! No numeric conversion is performed; match the file type in memory.
  !! C declaration: int nc_get_var1(int ncid, int varid, const size_t *indexp, void *ip);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: indexp
  !! Zero-based element indices in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: ip
  !! Pointer to C-compatible storage. C pointee: void *.
  integer(c_int) :: nc_get_var1
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_get_var1

function nc_put_varm(ncid, varid, startp, countp, stridep, imapp, op) bind(c, name="nc_put_varm")
  !! Write a mapped variable section.
  !! No numeric conversion is performed; match the file type in memory.
  !! imapp describes memory layout; unlike start/count, it is measured in memory elements.
  !! The destination/source buffer must span every address selected by the map.
  !! C declaration: int nc_put_varm(int ncid, int varid, const size_t *startp, const size_t *countp, const
  !! ptrdiff_t *stridep, const ptrdiff_t *imapp, const void *op);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: startp
  !! Zero-based start indices in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: countp
  !! Element counts in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: stridep
  !! Strides in C dimension order. C pointee: const ptrdiff_t *.
  type(c_ptr), value :: imapp
  !! Memory strides in C dimension order, measured in elements for modern typed APIs. C pointee: const
  !! ptrdiff_t *.
  type(c_ptr), value :: op
  !! Pointer to C-compatible storage. C pointee: const void *.
  integer(c_int) :: nc_put_varm
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_put_varm

function nc_get_varm(ncid, varid, startp, countp, stridep, imapp, ip) bind(c, name="nc_get_varm")
  !! Read a mapped variable section.
  !! No numeric conversion is performed; match the file type in memory.
  !! imapp describes memory layout; unlike start/count, it is measured in memory elements.
  !! The destination/source buffer must span every address selected by the map.
  !! C declaration: int nc_get_varm(int ncid, int varid, const size_t *startp, const size_t *countp, const
  !! ptrdiff_t *stridep, const ptrdiff_t *imapp, void *ip);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: startp
  !! Zero-based start indices in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: countp
  !! Element counts in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: stridep
  !! Strides in C dimension order. C pointee: const ptrdiff_t *.
  type(c_ptr), value :: imapp
  !! Memory strides in C dimension order, measured in elements for modern typed APIs. C pointee: const
  !! ptrdiff_t *.
  type(c_ptr), value :: ip
  !! Pointer to C-compatible storage. C pointee: void *.
  integer(c_int) :: nc_get_varm
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_get_varm

function nc_put_var1_text(ncid, varid, indexp, op) bind(c, name="nc_put_var1_text")
  !! Write one variable element.
  !! No numeric conversion is performed; match the file type in memory.
  !! C declaration: int nc_put_var1_text(int ncid, int varid, const size_t *indexp, const char *op);
  import :: c_int, c_ptr, c_char
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: indexp
  !! Zero-based element indices in C dimension order. C pointee: const size_t *.
  character(kind=c_char), intent(in) :: op(*)
  !! NUL-terminated C string.
  integer(c_int) :: nc_put_var1_text
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_put_var1_text

function nc_get_var1_text(ncid, varid, indexp, ip) bind(c, name="nc_get_var1_text")
  !! Read one variable element.
  !! No numeric conversion is performed; match the file type in memory.
  !! C declaration: int nc_get_var1_text(int ncid, int varid, const size_t *indexp, char *ip);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: indexp
  !! Zero-based element indices in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: ip
  !! Pointer to caller-provided C character output storage (NC_MAX_NAME + 1 for names).
  integer(c_int) :: nc_get_var1_text
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_get_var1_text

function nc_put_var1_schar(ncid, varid, indexp, op) bind(c, name="nc_put_var1_schar")
  !! Write one variable element.
  !! The schar suffix selects the C memory type; numeric types are converted by NetCDF.
  !! C declaration: int nc_put_var1_schar(int ncid, int varid, const size_t *indexp, const signed char *op);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: indexp
  !! Zero-based element indices in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: op
  !! Pointer to C-compatible storage. C pointee: const signed char *.
  integer(c_int) :: nc_put_var1_schar
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_put_var1_schar

function nc_get_var1_schar(ncid, varid, indexp, ip) bind(c, name="nc_get_var1_schar")
  !! Read one variable element.
  !! The schar suffix selects the C memory type; numeric types are converted by NetCDF.
  !! C declaration: int nc_get_var1_schar(int ncid, int varid, const size_t *indexp, signed char *ip);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: indexp
  !! Zero-based element indices in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: ip
  !! Pointer to C-compatible storage. C pointee: signed char *.
  integer(c_int) :: nc_get_var1_schar
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_get_var1_schar

function nc_put_var1_short(ncid, varid, indexp, op) bind(c, name="nc_put_var1_short")
  !! Write one variable element.
  !! The short suffix selects the C memory type; numeric types are converted by NetCDF.
  !! C declaration: int nc_put_var1_short(int ncid, int varid, const size_t *indexp, const short *op);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: indexp
  !! Zero-based element indices in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: op
  !! Pointer to C-compatible storage. C pointee: const short *.
  integer(c_int) :: nc_put_var1_short
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_put_var1_short

function nc_get_var1_short(ncid, varid, indexp, ip) bind(c, name="nc_get_var1_short")
  !! Read one variable element.
  !! The short suffix selects the C memory type; numeric types are converted by NetCDF.
  !! C declaration: int nc_get_var1_short(int ncid, int varid, const size_t *indexp, short *ip);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: indexp
  !! Zero-based element indices in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: ip
  !! Pointer to C-compatible storage. C pointee: short *.
  integer(c_int) :: nc_get_var1_short
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_get_var1_short

function nc_put_var1_int(ncid, varid, indexp, op) bind(c, name="nc_put_var1_int")
  !! Write one variable element.
  !! The int suffix selects the C memory type; numeric types are converted by NetCDF.
  !! C declaration: int nc_put_var1_int(int ncid, int varid, const size_t *indexp, const int *op);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: indexp
  !! Zero-based element indices in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: op
  !! Pointer to C-compatible storage. C pointee: const int *.
  integer(c_int) :: nc_put_var1_int
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_put_var1_int

function nc_get_var1_int(ncid, varid, indexp, ip) bind(c, name="nc_get_var1_int")
  !! Read one variable element.
  !! The int suffix selects the C memory type; numeric types are converted by NetCDF.
  !! C declaration: int nc_get_var1_int(int ncid, int varid, const size_t *indexp, int *ip);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: indexp
  !! Zero-based element indices in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: ip
  !! Pointer to C-compatible storage. C pointee: int *.
  integer(c_int) :: nc_get_var1_int
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_get_var1_int

function nc_put_var1_long(ncid, varid, indexp, op) bind(c, name="nc_put_var1_long")
  !! Write one variable element.
  !! The long suffix selects the C memory type; numeric types are converted by NetCDF.
  !! C declaration: int nc_put_var1_long(int ncid, int varid, const size_t *indexp, const long *op);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: indexp
  !! Zero-based element indices in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: op
  !! Pointer to C-compatible storage. C pointee: const long *.
  integer(c_int) :: nc_put_var1_long
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_put_var1_long

function nc_get_var1_long(ncid, varid, indexp, ip) bind(c, name="nc_get_var1_long")
  !! Read one variable element.
  !! The long suffix selects the C memory type; numeric types are converted by NetCDF.
  !! C declaration: int nc_get_var1_long(int ncid, int varid, const size_t *indexp, long *ip);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: indexp
  !! Zero-based element indices in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: ip
  !! Pointer to C-compatible storage. C pointee: long *.
  integer(c_int) :: nc_get_var1_long
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_get_var1_long

function nc_put_var1_float(ncid, varid, indexp, op) bind(c, name="nc_put_var1_float")
  !! Write one variable element.
  !! The float suffix selects the C memory type; numeric types are converted by NetCDF.
  !! C declaration: int nc_put_var1_float(int ncid, int varid, const size_t *indexp, const float *op);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: indexp
  !! Zero-based element indices in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: op
  !! Pointer to C-compatible storage. C pointee: const float *.
  integer(c_int) :: nc_put_var1_float
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_put_var1_float

function nc_get_var1_float(ncid, varid, indexp, ip) bind(c, name="nc_get_var1_float")
  !! Read one variable element.
  !! The float suffix selects the C memory type; numeric types are converted by NetCDF.
  !! C declaration: int nc_get_var1_float(int ncid, int varid, const size_t *indexp, float *ip);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: indexp
  !! Zero-based element indices in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: ip
  !! Pointer to C-compatible storage. C pointee: float *.
  integer(c_int) :: nc_get_var1_float
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_get_var1_float

function nc_put_var1_double(ncid, varid, indexp, op) bind(c, name="nc_put_var1_double")
  !! Write one variable element.
  !! The double suffix selects the C memory type; numeric types are converted by NetCDF.
  !! C declaration: int nc_put_var1_double(int ncid, int varid, const size_t *indexp, const double *op);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: indexp
  !! Zero-based element indices in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: op
  !! Pointer to C-compatible storage. C pointee: const double *.
  integer(c_int) :: nc_put_var1_double
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_put_var1_double

function nc_get_var1_double(ncid, varid, indexp, ip) bind(c, name="nc_get_var1_double")
  !! Read one variable element.
  !! The double suffix selects the C memory type; numeric types are converted by NetCDF.
  !! C declaration: int nc_get_var1_double(int ncid, int varid, const size_t *indexp, double *ip);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: indexp
  !! Zero-based element indices in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: ip
  !! Pointer to C-compatible storage. C pointee: double *.
  integer(c_int) :: nc_get_var1_double
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_get_var1_double

function nc_put_var1_longlong(ncid, varid, indexp, op) bind(c, name="nc_put_var1_longlong")
  !! Write one variable element.
  !! The longlong suffix selects the C memory type; numeric types are converted by NetCDF.
  !! C declaration: int nc_put_var1_longlong(int ncid, int varid, const size_t *indexp, const long long *op);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: indexp
  !! Zero-based element indices in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: op
  !! Pointer to C-compatible storage. C pointee: const long long *.
  integer(c_int) :: nc_put_var1_longlong
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_put_var1_longlong

function nc_get_var1_longlong(ncid, varid, indexp, ip) bind(c, name="nc_get_var1_longlong")
  !! Read one variable element.
  !! The longlong suffix selects the C memory type; numeric types are converted by NetCDF.
  !! C declaration: int nc_get_var1_longlong(int ncid, int varid, const size_t *indexp, long long *ip);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: indexp
  !! Zero-based element indices in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: ip
  !! Pointer to C-compatible storage. C pointee: long long *.
  integer(c_int) :: nc_get_var1_longlong
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_get_var1_longlong

function nc_put_var1_string(ncid, varid, indexp, op) bind(c, name="nc_put_var1_string")
  !! Write one variable element.
  !! No numeric conversion is performed; match the file type in memory.
  !! Read results contain C-allocated strings; release them with nc_free_string().
  !! C declaration: int nc_put_var1_string(int ncid, int varid, const size_t *indexp, const char **op);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: indexp
  !! Zero-based element indices in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: op
  !! Pointer to C-compatible storage. C pointee: const char **.
  integer(c_int) :: nc_put_var1_string
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_put_var1_string

function nc_get_var1_string(ncid, varid, indexp, ip) bind(c, name="nc_get_var1_string")
  !! Read one variable element.
  !! No numeric conversion is performed; match the file type in memory.
  !! Read results contain C-allocated strings; release them with nc_free_string().
  !! C declaration: int nc_get_var1_string(int ncid, int varid, const size_t *indexp, char **ip);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: indexp
  !! Zero-based element indices in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: ip
  !! Pointer to C-compatible storage. C pointee: char **.
  integer(c_int) :: nc_get_var1_string
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_get_var1_string

function nc_put_varm_text(ncid, varid, startp, countp, stridep, imapp, op) bind(c, name="nc_put_varm_text")
  !! Write a mapped variable section.
  !! No numeric conversion is performed; match the file type in memory.
  !! imapp describes memory layout; unlike start/count, it is measured in memory elements.
  !! The destination/source buffer must span every address selected by the map.
  !! C declaration: int nc_put_varm_text(int ncid, int varid, const size_t *startp, const size_t *countp,
  !! const ptrdiff_t *stridep, const ptrdiff_t *imapp, const char *op);
  import :: c_int, c_ptr, c_char
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: startp
  !! Zero-based start indices in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: countp
  !! Element counts in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: stridep
  !! Strides in C dimension order. C pointee: const ptrdiff_t *.
  type(c_ptr), value :: imapp
  !! Memory strides in C dimension order, measured in elements for modern typed APIs. C pointee: const
  !! ptrdiff_t *.
  character(kind=c_char), intent(in) :: op(*)
  !! NUL-terminated C string.
  integer(c_int) :: nc_put_varm_text
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_put_varm_text

function nc_get_varm_text(ncid, varid, startp, countp, stridep, imapp, ip) bind(c, name="nc_get_varm_text")
  !! Read a mapped variable section.
  !! No numeric conversion is performed; match the file type in memory.
  !! imapp describes memory layout; unlike start/count, it is measured in memory elements.
  !! The destination/source buffer must span every address selected by the map.
  !! C declaration: int nc_get_varm_text(int ncid, int varid, const size_t *startp, const size_t *countp,
  !! const ptrdiff_t *stridep, const ptrdiff_t *imapp, char *ip);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: startp
  !! Zero-based start indices in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: countp
  !! Element counts in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: stridep
  !! Strides in C dimension order. C pointee: const ptrdiff_t *.
  type(c_ptr), value :: imapp
  !! Memory strides in C dimension order, measured in elements for modern typed APIs. C pointee: const
  !! ptrdiff_t *.
  type(c_ptr), value :: ip
  !! Pointer to caller-provided C character output storage (NC_MAX_NAME + 1 for names).
  integer(c_int) :: nc_get_varm_text
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_get_varm_text

function nc_put_varm_schar(ncid, varid, startp, countp, stridep, imapp, op) bind(c, name="nc_put_varm_schar")
  !! Write a mapped variable section.
  !! The schar suffix selects the C memory type; numeric types are converted by NetCDF.
  !! imapp describes memory layout; unlike start/count, it is measured in memory elements.
  !! The destination/source buffer must span every address selected by the map.
  !! C declaration: int nc_put_varm_schar(int ncid, int varid, const size_t *startp, const size_t *countp,
  !! const ptrdiff_t *stridep, const ptrdiff_t *imapp, const signed char *op);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: startp
  !! Zero-based start indices in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: countp
  !! Element counts in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: stridep
  !! Strides in C dimension order. C pointee: const ptrdiff_t *.
  type(c_ptr), value :: imapp
  !! Memory strides in C dimension order, measured in elements for modern typed APIs. C pointee: const
  !! ptrdiff_t *.
  type(c_ptr), value :: op
  !! Pointer to C-compatible storage. C pointee: const signed char *.
  integer(c_int) :: nc_put_varm_schar
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_put_varm_schar

function nc_get_varm_schar(ncid, varid, startp, countp, stridep, imapp, ip) bind(c, name="nc_get_varm_schar")
  !! Read a mapped variable section.
  !! The schar suffix selects the C memory type; numeric types are converted by NetCDF.
  !! imapp describes memory layout; unlike start/count, it is measured in memory elements.
  !! The destination/source buffer must span every address selected by the map.
  !! C declaration: int nc_get_varm_schar(int ncid, int varid, const size_t *startp, const size_t *countp,
  !! const ptrdiff_t *stridep, const ptrdiff_t *imapp, signed char *ip);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: startp
  !! Zero-based start indices in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: countp
  !! Element counts in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: stridep
  !! Strides in C dimension order. C pointee: const ptrdiff_t *.
  type(c_ptr), value :: imapp
  !! Memory strides in C dimension order, measured in elements for modern typed APIs. C pointee: const
  !! ptrdiff_t *.
  type(c_ptr), value :: ip
  !! Pointer to C-compatible storage. C pointee: signed char *.
  integer(c_int) :: nc_get_varm_schar
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_get_varm_schar

function nc_put_varm_short(ncid, varid, startp, countp, stridep, imapp, op) bind(c, name="nc_put_varm_short")
  !! Write a mapped variable section.
  !! The short suffix selects the C memory type; numeric types are converted by NetCDF.
  !! imapp describes memory layout; unlike start/count, it is measured in memory elements.
  !! The destination/source buffer must span every address selected by the map.
  !! C declaration: int nc_put_varm_short(int ncid, int varid, const size_t *startp, const size_t *countp,
  !! const ptrdiff_t *stridep, const ptrdiff_t *imapp, const short *op);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: startp
  !! Zero-based start indices in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: countp
  !! Element counts in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: stridep
  !! Strides in C dimension order. C pointee: const ptrdiff_t *.
  type(c_ptr), value :: imapp
  !! Memory strides in C dimension order, measured in elements for modern typed APIs. C pointee: const
  !! ptrdiff_t *.
  type(c_ptr), value :: op
  !! Pointer to C-compatible storage. C pointee: const short *.
  integer(c_int) :: nc_put_varm_short
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_put_varm_short

function nc_get_varm_short(ncid, varid, startp, countp, stridep, imapp, ip) bind(c, name="nc_get_varm_short")
  !! Read a mapped variable section.
  !! The short suffix selects the C memory type; numeric types are converted by NetCDF.
  !! imapp describes memory layout; unlike start/count, it is measured in memory elements.
  !! The destination/source buffer must span every address selected by the map.
  !! C declaration: int nc_get_varm_short(int ncid, int varid, const size_t *startp, const size_t *countp,
  !! const ptrdiff_t *stridep, const ptrdiff_t *imapp, short *ip);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: startp
  !! Zero-based start indices in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: countp
  !! Element counts in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: stridep
  !! Strides in C dimension order. C pointee: const ptrdiff_t *.
  type(c_ptr), value :: imapp
  !! Memory strides in C dimension order, measured in elements for modern typed APIs. C pointee: const
  !! ptrdiff_t *.
  type(c_ptr), value :: ip
  !! Pointer to C-compatible storage. C pointee: short *.
  integer(c_int) :: nc_get_varm_short
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_get_varm_short

function nc_put_varm_int(ncid, varid, startp, countp, stridep, imapp, op) bind(c, name="nc_put_varm_int")
  !! Write a mapped variable section.
  !! The int suffix selects the C memory type; numeric types are converted by NetCDF.
  !! imapp describes memory layout; unlike start/count, it is measured in memory elements.
  !! The destination/source buffer must span every address selected by the map.
  !! C declaration: int nc_put_varm_int(int ncid, int varid, const size_t *startp, const size_t *countp,
  !! const ptrdiff_t *stridep, const ptrdiff_t *imapp, const int *op);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: startp
  !! Zero-based start indices in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: countp
  !! Element counts in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: stridep
  !! Strides in C dimension order. C pointee: const ptrdiff_t *.
  type(c_ptr), value :: imapp
  !! Memory strides in C dimension order, measured in elements for modern typed APIs. C pointee: const
  !! ptrdiff_t *.
  type(c_ptr), value :: op
  !! Pointer to C-compatible storage. C pointee: const int *.
  integer(c_int) :: nc_put_varm_int
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_put_varm_int

function nc_get_varm_int(ncid, varid, startp, countp, stridep, imapp, ip) bind(c, name="nc_get_varm_int")
  !! Read a mapped variable section.
  !! The int suffix selects the C memory type; numeric types are converted by NetCDF.
  !! imapp describes memory layout; unlike start/count, it is measured in memory elements.
  !! The destination/source buffer must span every address selected by the map.
  !! C declaration: int nc_get_varm_int(int ncid, int varid, const size_t *startp, const size_t *countp,
  !! const ptrdiff_t *stridep, const ptrdiff_t *imapp, int *ip);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: startp
  !! Zero-based start indices in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: countp
  !! Element counts in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: stridep
  !! Strides in C dimension order. C pointee: const ptrdiff_t *.
  type(c_ptr), value :: imapp
  !! Memory strides in C dimension order, measured in elements for modern typed APIs. C pointee: const
  !! ptrdiff_t *.
  type(c_ptr), value :: ip
  !! Pointer to C-compatible storage. C pointee: int *.
  integer(c_int) :: nc_get_varm_int
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_get_varm_int

function nc_put_varm_long(ncid, varid, startp, countp, stridep, imapp, op) bind(c, name="nc_put_varm_long")
  !! Write a mapped variable section.
  !! The long suffix selects the C memory type; numeric types are converted by NetCDF.
  !! imapp describes memory layout; unlike start/count, it is measured in memory elements.
  !! The destination/source buffer must span every address selected by the map.
  !! C declaration: int nc_put_varm_long(int ncid, int varid, const size_t *startp, const size_t *countp,
  !! const ptrdiff_t *stridep, const ptrdiff_t *imapp, const long *op);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: startp
  !! Zero-based start indices in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: countp
  !! Element counts in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: stridep
  !! Strides in C dimension order. C pointee: const ptrdiff_t *.
  type(c_ptr), value :: imapp
  !! Memory strides in C dimension order, measured in elements for modern typed APIs. C pointee: const
  !! ptrdiff_t *.
  type(c_ptr), value :: op
  !! Pointer to C-compatible storage. C pointee: const long *.
  integer(c_int) :: nc_put_varm_long
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_put_varm_long

function nc_get_varm_long(ncid, varid, startp, countp, stridep, imapp, ip) bind(c, name="nc_get_varm_long")
  !! Read a mapped variable section.
  !! The long suffix selects the C memory type; numeric types are converted by NetCDF.
  !! imapp describes memory layout; unlike start/count, it is measured in memory elements.
  !! The destination/source buffer must span every address selected by the map.
  !! C declaration: int nc_get_varm_long(int ncid, int varid, const size_t *startp, const size_t *countp,
  !! const ptrdiff_t *stridep, const ptrdiff_t *imapp, long *ip);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: startp
  !! Zero-based start indices in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: countp
  !! Element counts in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: stridep
  !! Strides in C dimension order. C pointee: const ptrdiff_t *.
  type(c_ptr), value :: imapp
  !! Memory strides in C dimension order, measured in elements for modern typed APIs. C pointee: const
  !! ptrdiff_t *.
  type(c_ptr), value :: ip
  !! Pointer to C-compatible storage. C pointee: long *.
  integer(c_int) :: nc_get_varm_long
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_get_varm_long

function nc_put_varm_float(ncid, varid, startp, countp, stridep, imapp, op) bind(c, name="nc_put_varm_float")
  !! Write a mapped variable section.
  !! The float suffix selects the C memory type; numeric types are converted by NetCDF.
  !! imapp describes memory layout; unlike start/count, it is measured in memory elements.
  !! The destination/source buffer must span every address selected by the map.
  !! C declaration: int nc_put_varm_float(int ncid, int varid, const size_t *startp, const size_t *countp,
  !! const ptrdiff_t *stridep, const ptrdiff_t *imapp, const float *op);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: startp
  !! Zero-based start indices in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: countp
  !! Element counts in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: stridep
  !! Strides in C dimension order. C pointee: const ptrdiff_t *.
  type(c_ptr), value :: imapp
  !! Memory strides in C dimension order, measured in elements for modern typed APIs. C pointee: const
  !! ptrdiff_t *.
  type(c_ptr), value :: op
  !! Pointer to C-compatible storage. C pointee: const float *.
  integer(c_int) :: nc_put_varm_float
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_put_varm_float

function nc_get_varm_float(ncid, varid, startp, countp, stridep, imapp, ip) bind(c, name="nc_get_varm_float")
  !! Read a mapped variable section.
  !! The float suffix selects the C memory type; numeric types are converted by NetCDF.
  !! imapp describes memory layout; unlike start/count, it is measured in memory elements.
  !! The destination/source buffer must span every address selected by the map.
  !! C declaration: int nc_get_varm_float(int ncid, int varid, const size_t *startp, const size_t *countp,
  !! const ptrdiff_t *stridep, const ptrdiff_t *imapp, float *ip);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: startp
  !! Zero-based start indices in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: countp
  !! Element counts in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: stridep
  !! Strides in C dimension order. C pointee: const ptrdiff_t *.
  type(c_ptr), value :: imapp
  !! Memory strides in C dimension order, measured in elements for modern typed APIs. C pointee: const
  !! ptrdiff_t *.
  type(c_ptr), value :: ip
  !! Pointer to C-compatible storage. C pointee: float *.
  integer(c_int) :: nc_get_varm_float
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_get_varm_float

function nc_put_varm_double(ncid, varid, startp, countp, stridep, imapp, op) bind(c, name="nc_put_varm_double")
  !! Write a mapped variable section.
  !! The double suffix selects the C memory type; numeric types are converted by NetCDF.
  !! imapp describes memory layout; unlike start/count, it is measured in memory elements.
  !! The destination/source buffer must span every address selected by the map.
  !! C declaration: int nc_put_varm_double(int ncid, int varid, const size_t *startp, const size_t *countp,
  !! const ptrdiff_t *stridep, const ptrdiff_t *imapp, const double *op);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: startp
  !! Zero-based start indices in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: countp
  !! Element counts in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: stridep
  !! Strides in C dimension order. C pointee: const ptrdiff_t *.
  type(c_ptr), value :: imapp
  !! Memory strides in C dimension order, measured in elements for modern typed APIs. C pointee: const
  !! ptrdiff_t *.
  type(c_ptr), value :: op
  !! Pointer to C-compatible storage. C pointee: const double *.
  integer(c_int) :: nc_put_varm_double
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_put_varm_double

function nc_get_varm_double(ncid, varid, startp, countp, stridep, imapp, ip) bind(c, name="nc_get_varm_double")
  !! Read a mapped variable section.
  !! The double suffix selects the C memory type; numeric types are converted by NetCDF.
  !! imapp describes memory layout; unlike start/count, it is measured in memory elements.
  !! The destination/source buffer must span every address selected by the map.
  !! C declaration: int nc_get_varm_double(int ncid, int varid, const size_t *startp, const size_t *countp,
  !! const ptrdiff_t *stridep, const ptrdiff_t * imapp, double *ip);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: startp
  !! Zero-based start indices in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: countp
  !! Element counts in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: stridep
  !! Strides in C dimension order. C pointee: const ptrdiff_t *.
  type(c_ptr), value :: imapp
  !! Memory strides in C dimension order, measured in elements for modern typed APIs. C pointee: const
  !! ptrdiff_t *.
  type(c_ptr), value :: ip
  !! Pointer to C-compatible storage. C pointee: double *.
  integer(c_int) :: nc_get_varm_double
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_get_varm_double

function nc_put_varm_longlong(ncid, varid, startp, countp, stridep, imapp, op) &
  & bind(c, name="nc_put_varm_longlong")
  !! Write a mapped variable section.
  !! The longlong suffix selects the C memory type; numeric types are converted by NetCDF.
  !! imapp describes memory layout; unlike start/count, it is measured in memory elements.
  !! The destination/source buffer must span every address selected by the map.
  !! C declaration: int nc_put_varm_longlong(int ncid, int varid, const size_t *startp, const size_t *countp,
  !! const ptrdiff_t *stridep, const ptrdiff_t * imapp, const long long *op);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: startp
  !! Zero-based start indices in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: countp
  !! Element counts in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: stridep
  !! Strides in C dimension order. C pointee: const ptrdiff_t *.
  type(c_ptr), value :: imapp
  !! Memory strides in C dimension order, measured in elements for modern typed APIs. C pointee: const
  !! ptrdiff_t *.
  type(c_ptr), value :: op
  !! Pointer to C-compatible storage. C pointee: const long long *.
  integer(c_int) :: nc_put_varm_longlong
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_put_varm_longlong

function nc_get_varm_longlong(ncid, varid, startp, countp, stridep, imapp, ip) &
  & bind(c, name="nc_get_varm_longlong")
  !! Read a mapped variable section.
  !! The longlong suffix selects the C memory type; numeric types are converted by NetCDF.
  !! imapp describes memory layout; unlike start/count, it is measured in memory elements.
  !! The destination/source buffer must span every address selected by the map.
  !! C declaration: int nc_get_varm_longlong(int ncid, int varid, const size_t *startp, const size_t *countp,
  !! const ptrdiff_t *stridep, const ptrdiff_t * imapp, long long *ip);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: startp
  !! Zero-based start indices in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: countp
  !! Element counts in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: stridep
  !! Strides in C dimension order. C pointee: const ptrdiff_t *.
  type(c_ptr), value :: imapp
  !! Memory strides in C dimension order, measured in elements for modern typed APIs. C pointee: const
  !! ptrdiff_t *.
  type(c_ptr), value :: ip
  !! Pointer to C-compatible storage. C pointee: long long *.
  integer(c_int) :: nc_get_varm_longlong
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_get_varm_longlong

function nc_put_varm_string(ncid, varid, startp, countp, stridep, imapp, op) bind(c, name="nc_put_varm_string")
  !! Write a mapped variable section.
  !! No numeric conversion is performed; match the file type in memory.
  !! imapp describes memory layout; unlike start/count, it is measured in memory elements.
  !! The destination/source buffer must span every address selected by the map.
  !! Read results contain C-allocated strings; release them with nc_free_string().
  !! C declaration: int nc_put_varm_string(int ncid, int varid, const size_t *startp, const size_t *countp,
  !! const ptrdiff_t *stridep, const ptrdiff_t * imapp, const char **op);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: startp
  !! Zero-based start indices in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: countp
  !! Element counts in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: stridep
  !! Strides in C dimension order. C pointee: const ptrdiff_t *.
  type(c_ptr), value :: imapp
  !! Memory strides in C dimension order, measured in elements for modern typed APIs. C pointee: const
  !! ptrdiff_t *.
  type(c_ptr), value :: op
  !! Pointer to C-compatible storage. C pointee: const char **.
  integer(c_int) :: nc_put_varm_string
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_put_varm_string

function nc_get_varm_string(ncid, varid, startp, countp, stridep, imapp, ip) bind(c, name="nc_get_varm_string")
  !! Read a mapped variable section.
  !! No numeric conversion is performed; match the file type in memory.
  !! imapp describes memory layout; unlike start/count, it is measured in memory elements.
  !! The destination/source buffer must span every address selected by the map.
  !! Read results contain C-allocated strings; release them with nc_free_string().
  !! C declaration: int nc_get_varm_string(int ncid, int varid, const size_t *startp, const size_t *countp,
  !! const ptrdiff_t *stridep, const ptrdiff_t * imapp, char **ip);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: startp
  !! Zero-based start indices in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: countp
  !! Element counts in C dimension order. C pointee: const size_t *.
  type(c_ptr), value :: stridep
  !! Strides in C dimension order. C pointee: const ptrdiff_t *.
  type(c_ptr), value :: imapp
  !! Memory strides in C dimension order, measured in elements for modern typed APIs. C pointee: const
  !! ptrdiff_t *.
  type(c_ptr), value :: ip
  !! Pointer to C-compatible storage. C pointee: char **.
  integer(c_int) :: nc_get_varm_string
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_get_varm_string

function nc_free_vlens(nelems, vlens) bind(c, name="nc_free_vlens")
  !! Release library-allocated payloads of an nc_vlen_t array.
  !! Only use for library-allocated payloads with fixed-size base elements.
  !! The descriptor array is retained. Use nc_reclaim_data() for nested allocating types.
  !! C declaration: int nc_free_vlens(size_t nelems, nc_vlen_t vlens[]);
  import :: c_int, c_size_t, c_ptr
  integer(c_size_t), value :: nelems
  !! Number of typed instances.
  type(c_ptr), value :: vlens
  !! Address of a contiguous nc_vlen_t descriptor array. C pointee: nc_vlen_t *.
  integer(c_int) :: nc_free_vlens
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_free_vlens

function nc_free_vlen(vl) bind(c, name="nc_free_vlen")
  !! Release the library-allocated payload of one nc_vlen_t descriptor.
  !! Only use for library-allocated payloads with fixed-size base elements.
  !! Use nc_reclaim_data() for nested strings or VLENs; the descriptor itself is not freed.
  !! C declaration: int nc_free_vlen(nc_vlen_t *vl);
  import :: c_int, c_ptr
  type(c_ptr), value :: vl
  !! Address of one nc_vlen_t descriptor. C pointee: nc_vlen_t *.
  integer(c_int) :: nc_free_vlen
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_free_vlen

function nc_reclaim_data(ncid, xtypeid, memory, nelems) bind(c, name="nc_reclaim_data")
  !! Recursively release nested allocations while retaining the top-level buffer.
  !! The dataset must remain open to resolve user-defined types.
  !! Never reclaim borrowed Fortran storage or static strings nested in an input record.
  !! C declaration: int nc_reclaim_data(int ncid, nc_type xtypeid, void* memory, size_t nelems);
  import :: c_int, c_ptr, c_size_t
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: xtypeid
  !! NetCDF type identifier.
  type(c_ptr), value :: memory
  !! Top-level memory buffer. C pointee: void*.
  integer(c_size_t), value :: nelems
  !! Number of typed instances.
  integer(c_int) :: nc_reclaim_data
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_reclaim_data

function nc_reclaim_data_all(ncid, xtypeid, memory, nelems) bind(c, name="nc_reclaim_data_all")
  !! Recursively release nested allocations and the C-allocated top-level buffer.
  !! The dataset must remain open; the top-level allocation must be compatible with C free().
  !! Never pass c_loc() of Fortran-owned storage to this function.
  !! C declaration: int nc_reclaim_data_all(int ncid, nc_type xtypeid, void* memory, size_t nelems);
  import :: c_int, c_ptr, c_size_t
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: xtypeid
  !! NetCDF type identifier.
  type(c_ptr), value :: memory
  !! Top-level memory buffer. C pointee: void*.
  integer(c_size_t), value :: nelems
  !! Number of typed instances.
  integer(c_int) :: nc_reclaim_data_all
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_reclaim_data_all

function nc_copy_data(ncid, xtypeid, memory, count, copy) bind(c, name="nc_copy_data")
  !! Deep-copy typed instances into an existing caller-owned destination buffer.
  !! Reclaim the copied nested allocations with nc_reclaim_data() before closing the dataset.
  !! C declaration: int nc_copy_data(int ncid, nc_type xtypeid, const void* memory, size_t count, void*
  !! copy);
  import :: c_int, c_ptr, c_size_t
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: xtypeid
  !! NetCDF type identifier.
  type(c_ptr), value :: memory
  !! Top-level memory buffer. C pointee: const void*.
  integer(c_size_t), value :: count
  !! Number of typed instances.
  type(c_ptr), value :: copy
  !! Preallocated destination buffer. C pointee: void*.
  integer(c_int) :: nc_copy_data
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_copy_data

function nc_copy_data_all(ncid, xtypeid, memory, count, copyp) bind(c, name="nc_copy_data_all")
  !! Deep-copy typed instances into a newly allocated C destination buffer.
  !! Reclaim the returned pointer with nc_reclaim_data_all() before closing the dataset.
  !! C declaration: int nc_copy_data_all(int ncid, nc_type xtypeid, const void* memory, size_t count, void**
  !! copyp);
  import :: c_int, c_ptr, c_size_t
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: xtypeid
  !! NetCDF type identifier.
  type(c_ptr), value :: memory
  !! Top-level memory buffer. C pointee: const void*.
  integer(c_size_t), value :: count
  !! Number of typed instances.
  type(c_ptr), intent(out) :: copyp
  !! Returned C pointer; pass a c_ptr variable, not c_loc() of a pointer slot.
  integer(c_int) :: nc_copy_data_all
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_copy_data_all

function ncvarput1(ncid, varid, indexp, op) bind(c, name="ncvarput1")
  !! Legacy v2 API: Write one variable element.
  !! Uses v2 return/error conventions, not modern NC_NOERR status semantics.
  !! Legacy process-global ncopts controls fatal errors and diagnostics; no accessor is provided.
  !! Index/count/stride/map vectors contain C long values; legacy maps use byte strides.
  !! C declaration: int ncvarput1(int ncid, int varid, const long *indexp, const void *op);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: indexp
  !! Zero-based element indices in C dimension order. C pointee: const long *.
  type(c_ptr), value :: op
  !! Pointer to C-compatible storage. C pointee: const void *.
  integer(c_int) :: ncvarput1
  !! V2 result (ID, size, previous setting, or success value); -1 indicates failure.
end function ncvarput1

function ncvarget1(ncid, varid, indexp, ip) bind(c, name="ncvarget1")
  !! Legacy v2 API: Read one variable element.
  !! Uses v2 return/error conventions, not modern NC_NOERR status semantics.
  !! Legacy process-global ncopts controls fatal errors and diagnostics; no accessor is provided.
  !! Index/count/stride/map vectors contain C long values; legacy maps use byte strides.
  !! C declaration: int ncvarget1(int ncid, int varid, const long *indexp, void *ip);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: indexp
  !! Zero-based element indices in C dimension order. C pointee: const long *.
  type(c_ptr), value :: ip
  !! Pointer to C-compatible storage. C pointee: void *.
  integer(c_int) :: ncvarget1
  !! V2 result (ID, size, previous setting, or success value); -1 indicates failure.
end function ncvarget1

function ncvarput(ncid, varid, startp, countp, op) bind(c, name="ncvarput")
  !! Legacy v2 API: Write a contiguous variable section.
  !! Uses v2 return/error conventions, not modern NC_NOERR status semantics.
  !! Legacy process-global ncopts controls fatal errors and diagnostics; no accessor is provided.
  !! Index/count/stride/map vectors contain C long values; legacy maps use byte strides.
  !! C declaration: int ncvarput(int ncid, int varid, const long *startp, const long *countp, const void
  !! *op);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: startp
  !! Zero-based start indices in C dimension order. C pointee: const long *.
  type(c_ptr), value :: countp
  !! Element counts in C dimension order. C pointee: const long *.
  type(c_ptr), value :: op
  !! Pointer to C-compatible storage. C pointee: const void *.
  integer(c_int) :: ncvarput
  !! V2 result (ID, size, previous setting, or success value); -1 indicates failure.
end function ncvarput

function ncvarget(ncid, varid, startp, countp, ip) bind(c, name="ncvarget")
  !! Legacy v2 API: Read a contiguous variable section.
  !! Uses v2 return/error conventions, not modern NC_NOERR status semantics.
  !! Legacy process-global ncopts controls fatal errors and diagnostics; no accessor is provided.
  !! Index/count/stride/map vectors contain C long values; legacy maps use byte strides.
  !! C declaration: int ncvarget(int ncid, int varid, const long *startp, const long *countp, void *ip);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: startp
  !! Zero-based start indices in C dimension order. C pointee: const long *.
  type(c_ptr), value :: countp
  !! Element counts in C dimension order. C pointee: const long *.
  type(c_ptr), value :: ip
  !! Pointer to C-compatible storage. C pointee: void *.
  integer(c_int) :: ncvarget
  !! V2 result (ID, size, previous setting, or success value); -1 indicates failure.
end function ncvarget

function ncvarputs(ncid, varid, startp, countp, stridep, op) bind(c, name="ncvarputs")
  !! Legacy v2 API: Write a strided variable section.
  !! Uses v2 return/error conventions, not modern NC_NOERR status semantics.
  !! Legacy process-global ncopts controls fatal errors and diagnostics; no accessor is provided.
  !! Index/count/stride/map vectors contain C long values; legacy maps use byte strides.
  !! C declaration: int ncvarputs(int ncid, int varid, const long *startp, const long *countp, const long
  !! *stridep, const void *op);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: startp
  !! Zero-based start indices in C dimension order. C pointee: const long *.
  type(c_ptr), value :: countp
  !! Element counts in C dimension order. C pointee: const long *.
  type(c_ptr), value :: stridep
  !! Strides in C dimension order. C pointee: const long *.
  type(c_ptr), value :: op
  !! Pointer to C-compatible storage. C pointee: const void *.
  integer(c_int) :: ncvarputs
  !! V2 result (ID, size, previous setting, or success value); -1 indicates failure.
end function ncvarputs

function ncvargets(ncid, varid, startp, countp, stridep, ip) bind(c, name="ncvargets")
  !! Legacy v2 API: Read a strided variable section.
  !! Uses v2 return/error conventions, not modern NC_NOERR status semantics.
  !! Legacy process-global ncopts controls fatal errors and diagnostics; no accessor is provided.
  !! Index/count/stride/map vectors contain C long values; legacy maps use byte strides.
  !! C declaration: int ncvargets(int ncid, int varid, const long *startp, const long *countp, const long
  !! *stridep, void *ip);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: startp
  !! Zero-based start indices in C dimension order. C pointee: const long *.
  type(c_ptr), value :: countp
  !! Element counts in C dimension order. C pointee: const long *.
  type(c_ptr), value :: stridep
  !! Strides in C dimension order. C pointee: const long *.
  type(c_ptr), value :: ip
  !! Pointer to C-compatible storage. C pointee: void *.
  integer(c_int) :: ncvargets
  !! V2 result (ID, size, previous setting, or success value); -1 indicates failure.
end function ncvargets

function ncvarputg(ncid, varid, startp, countp, stridep, imapp, op) bind(c, name="ncvarputg")
  !! Legacy v2 API: Write a mapped variable section.
  !! Uses v2 return/error conventions, not modern NC_NOERR status semantics.
  !! Legacy process-global ncopts controls fatal errors and diagnostics; no accessor is provided.
  !! Index/count/stride/map vectors contain C long values; legacy maps use byte strides.
  !! C declaration: int ncvarputg(int ncid, int varid, const long *startp, const long *countp, const long
  !! *stridep, const long *imapp, const void *op);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: startp
  !! Zero-based start indices in C dimension order. C pointee: const long *.
  type(c_ptr), value :: countp
  !! Element counts in C dimension order. C pointee: const long *.
  type(c_ptr), value :: stridep
  !! Strides in C dimension order. C pointee: const long *.
  type(c_ptr), value :: imapp
  !! Memory strides in C dimension order, measured in elements for modern typed APIs. C pointee: const long
  !! *.
  type(c_ptr), value :: op
  !! Pointer to C-compatible storage. C pointee: const void *.
  integer(c_int) :: ncvarputg
  !! V2 result (ID, size, previous setting, or success value); -1 indicates failure.
end function ncvarputg

function ncvargetg(ncid, varid, startp, countp, stridep, imapp, ip) bind(c, name="ncvargetg")
  !! Legacy v2 API: Read a mapped variable section.
  !! Uses v2 return/error conventions, not modern NC_NOERR status semantics.
  !! Legacy process-global ncopts controls fatal errors and diagnostics; no accessor is provided.
  !! Index/count/stride/map vectors contain C long values; legacy maps use byte strides.
  !! C declaration: int ncvargetg(int ncid, int varid, const long *startp, const long *countp, const long
  !! *stridep, const long *imapp, void *ip);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: startp
  !! Zero-based start indices in C dimension order. C pointee: const long *.
  type(c_ptr), value :: countp
  !! Element counts in C dimension order. C pointee: const long *.
  type(c_ptr), value :: stridep
  !! Strides in C dimension order. C pointee: const long *.
  type(c_ptr), value :: imapp
  !! Memory strides in C dimension order, measured in elements for modern typed APIs. C pointee: const long
  !! *.
  type(c_ptr), value :: ip
  !! Pointer to C-compatible storage. C pointee: void *.
  integer(c_int) :: ncvargetg
  !! V2 result (ID, size, previous setting, or success value); -1 indicates failure.
end function ncvargetg

function ncrecinq(ncid, nrecvarsp, recvaridsp, recsizesp) bind(c, name="ncrecinq")
  !! Legacy v2 API: Query record-variable identifiers and record sizes.
  !! Uses v2 return/error conventions, not modern NC_NOERR status semantics.
  !! Legacy process-global ncopts controls fatal errors and diagnostics; no accessor is provided.
  !! C declaration: int ncrecinq(int ncid, int *nrecvarsp, int *recvaridsp, long *recsizesp);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), intent(out) :: nrecvarsp
  !! Returned nrecvarsp value (C int).
  type(c_ptr), value :: recvaridsp
  !! Caller-provided record-variable ID vector. C pointee: int *.
  type(c_ptr), value :: recsizesp
  !! Caller-provided record sizes in bytes (C long array). C pointee: long *.
  integer(c_int) :: ncrecinq
  !! V2 result (ID, size, previous setting, or success value); -1 indicates failure.
end function ncrecinq

function ncrecget(ncid, recnum, datap) bind(c, name="ncrecget")
  !! Legacy v2 API: Read one record from all record variables.
  !! Uses v2 return/error conventions, not modern NC_NOERR status semantics.
  !! Legacy process-global ncopts controls fatal errors and diagnostics; no accessor is provided.
  !! C declaration: int ncrecget(int ncid, long recnum, void **datap);
  import :: c_int, c_long, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_long), value :: recnum
  !! Zero-based record number.
  type(c_ptr), value :: datap
  !! Pointer to C-compatible storage. C pointee: void **.
  integer(c_int) :: ncrecget
  !! V2 result (ID, size, previous setting, or success value); -1 indicates failure.
end function ncrecget

function ncrecput(ncid, recnum, datap) bind(c, name="ncrecput")
  !! Legacy v2 API: Write one record to all record variables.
  !! Uses v2 return/error conventions, not modern NC_NOERR status semantics.
  !! Legacy process-global ncopts controls fatal errors and diagnostics; no accessor is provided.
  !! C declaration: int ncrecput(int ncid, long recnum, void *const *datap);
  import :: c_int, c_long, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_long), value :: recnum
  !! Zero-based record number.
  type(c_ptr), value :: datap
  !! Pointer to C-compatible storage. C pointee: void *const *.
  integer(c_int) :: ncrecput
  !! V2 result (ID, size, previous setting, or success value); -1 indicates failure.
end function ncrecput

function ncaux_reclaim_data(ncid, xtype, memory, count) bind(c, name="ncaux_reclaim_data")
  !! Compatibility entry point for nc_reclaim_data().
  !! The dataset must remain open to resolve user-defined types.
  !! Never reclaim borrowed Fortran storage or static strings nested in an input record.
  !! C declaration: int ncaux_reclaim_data(int ncid, int xtype, void* memory, size_t count);
  import :: c_int, c_ptr, c_size_t
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: xtype
  !! NetCDF type identifier.
  type(c_ptr), value :: memory
  !! Top-level memory buffer. C pointee: void*.
  integer(c_size_t), value :: count
  !! Number of typed instances.
  integer(c_int) :: ncaux_reclaim_data
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function ncaux_reclaim_data

function ncaux_reclaim_data_all(ncid, xtype, memory, count) bind(c, name="ncaux_reclaim_data_all")
  !! Compatibility entry point for nc_reclaim_data_all().
  !! The dataset must remain open; the top-level allocation must be compatible with C free().
  !! Never pass c_loc() of Fortran-owned storage to this function.
  !! C declaration: int ncaux_reclaim_data_all(int ncid, int xtype, void* memory, size_t count);
  import :: c_int, c_ptr, c_size_t
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: xtype
  !! NetCDF type identifier.
  type(c_ptr), value :: memory
  !! Top-level memory buffer. C pointee: void*.
  integer(c_size_t), value :: count
  !! Number of typed instances.
  integer(c_int) :: ncaux_reclaim_data_all
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function ncaux_reclaim_data_all

function ncaux_copy_data(ncid, xtype, memory, count, copy) bind(c, name="nc_copy_data")
  !! Compatibility name bound directly to nc_copy_data(); no C adapter is required.
  !! Reclaim the copied nested allocations with nc_reclaim_data() before closing the dataset.
  !! C declaration: int ncaux_copy_data(int ncid, int xtype, void* memory, size_t count, void* copy);
  import :: c_int, c_ptr, c_size_t
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: xtype
  !! NetCDF type identifier.
  type(c_ptr), value :: memory
  !! Top-level memory buffer. C pointee: void*.
  integer(c_size_t), value :: count
  !! Number of typed instances.
  type(c_ptr), value :: copy
  !! Preallocated destination buffer. C pointee: void*.
  integer(c_int) :: ncaux_copy_data
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
  !! - NC_ENOTBUILT Optional support is unavailable, where applicable.
end function ncaux_copy_data

function ncaux_copy_data_all(ncid, xtype, memory, count, copyp) bind(c, name="nc_copy_data_all")
  !! Compatibility name bound directly to nc_copy_data_all(); no C adapter is required.
  !! Reclaim the returned pointer with nc_reclaim_data_all() before closing the dataset.
  !! C declaration: int ncaux_copy_data_all(int ncid, int xtype, void* memory, size_t count, void** copyp);
  import :: c_int, c_ptr, c_size_t
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: xtype
  !! NetCDF type identifier.
  type(c_ptr), value :: memory
  !! Top-level memory buffer. C pointee: void*.
  integer(c_size_t), value :: count
  !! Number of typed instances.
  type(c_ptr), intent(out) :: copyp
  !! Returned C pointer; pass a c_ptr variable, not c_loc() of a pointer slot.
  integer(c_int) :: ncaux_copy_data_all
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
  !! - NC_ENOTBUILT Optional support is unavailable, where applicable.
end function ncaux_copy_data_all

function ncaux_dump_data(ncid, xtypeid, memory, count, buf) bind(c, name="ncaux_dump_data")
  !! Format typed data as an allocated diagnostic string.
  !! Release the returned diagnostic string with c_free().
  !! C declaration: int ncaux_dump_data(int ncid, nc_type xtypeid, void* memory, size_t count, char** buf);
  import :: c_int, c_ptr, c_size_t
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: xtypeid
  !! NetCDF type identifier.
  type(c_ptr), value :: memory
  !! Top-level memory buffer. C pointee: void*.
  integer(c_size_t), value :: count
  !! Number of typed instances.
  type(c_ptr), intent(out) :: buf
  !! Returned C pointer; pass a c_ptr variable, not c_loc() of a pointer slot.
  integer(c_int) :: ncaux_dump_data
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function ncaux_dump_data

function ncaux_readfile(filename, sizep, content) bind(c, name="ncaux_readfile")
  !! Read a file into a newly allocated C memory buffer.
  !! Release the returned content with c_free().
  !! C declaration: int ncaux_readfile(const char* filename, size_t* sizep, void** content);
  import :: c_int, c_char, c_size_t, c_ptr
  character(kind=c_char), intent(in) :: filename(*)
  !! NUL-terminated C string.
  integer(c_size_t), intent(out) :: sizep
  !! Returned sizep value (C size_t).
  type(c_ptr), intent(out) :: content
  !! Returned C pointer; pass a c_ptr variable, not c_loc() of a pointer slot.
  integer(c_int) :: ncaux_readfile
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function ncaux_readfile

function ncaux_writefile(filename, size, content) bind(c, name="ncaux_writefile")
  !! Write a memory buffer to a file.
  !! C declaration: int ncaux_writefile(const char* filename, size_t size, void* content);
  import :: c_int, c_char, c_size_t, c_ptr
  character(kind=c_char), intent(in) :: filename(*)
  !! NUL-terminated C string.
  integer(c_size_t), value :: size
  !! Size in bytes.
  type(c_ptr), value :: content
  !! Pointer to C-compatible storage. C pointee: void*.
  integer(c_int) :: ncaux_writefile
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function ncaux_writefile
