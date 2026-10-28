module nc4f_test_c_bindings
!! Exercise the C ABI directly, independently of the high-level data model.
use, intrinsic :: iso_c_binding
use, non_intrinsic :: nc4f_c_interface
implicit none (type, external)
private
public :: c_bindings_storage, c_bindings_formats, c_bindings_strings
public :: c_bindings_user_types, c_bindings_memory_mapped, c_bindings_legacy_aux

type, bind(c) :: observation_record
  integer(c_int) :: station
  real(c_double) :: samples(2)
  type(c_ptr) :: label
  type(nc_vlen_t) :: history
end type observation_record

character(*), parameter :: RESULTS = "build/test-results/"

contains

subroutine check(status, context)
  integer(c_int), intent(in) :: status
  character(*), intent(in) :: context
  if (status == NC_NOERR) return
  print *, "[C binding] ", context, ": status = ", status
  error stop "NetCDF C call failed."
end subroutine check

subroutine require(condition, context)
  logical, intent(in) :: condition
  character(*), intent(in) :: context
  if (condition) return
  print *, "[C binding] ", context
  error stop "NetCDF C binding assertion failed."
end subroutine require

subroutine c_bindings_storage(passed)
  !! Append strided records, convert numbers, and inspect persisted storage metadata.
  logical, intent(inout) :: passed
  integer(c_int) :: ncid, dimids(2), varid, grpid, format, mode, storage
  integer(c_int) :: shuffle, deflate, level, checksum, endian, nofill, xtype, attid
  integer(c_int) :: ndims, nvars, natts, unlim, oldfill
  integer(c_size_t), target :: chunks(2), actual_chunks(2), start(2), count(2)
  integer(c_ptrdiff_t), target :: stride(2)
  integer(c_size_t) :: length, cache_size, cache_nelems, old_size, old_nelems
  real(c_float) :: preemption, old_preemption
  integer(c_short), target :: fill, actual_fill, raw(2, 3)
  integer(c_int), target :: values(2, 2), replacement(2)
  real(c_double), target :: actual(2, 3), att(2), actual_att(2)
  character(kind=c_char) :: name(NC_MAX_NAME + 1)
  character(kind=c_char), allocatable, target :: path(:)

  passed = .false.
  call require(c_strlen(nc_inq_libvers()) > 0_c_size_t, "Library version")
  call check(nc_get_chunk_cache(old_size, old_nelems, old_preemption), "Get default cache")
  call check(nc_set_chunk_cache(1048576_c_size_t, 521_c_size_t, 0.5_c_float), "Set default cache")
  call check(nc_create(RESULTS//"c-storage.nc"//c_null_char, NC_NETCDF4, ncid), "Create")
  call check(nc_set_chunk_cache(old_size, old_nelems, old_preemption), "Restore default cache")
  call check(nc_inq_format(ncid, format), "Format")
  call require(format == NC_FORMAT_NETCDF4, "Enhanced format")
  call check(nc_inq_format_extended(ncid, format, mode), "Extended format")
  call require(format == NC_FORMATX_NC_HDF5 .and. iand(mode, NC_NETCDF4) /= 0, "HDF5 backend")
  call check(nc_inq_path(ncid, length, c_null_ptr), "Path length")
  allocate(path(length + 1))
  call check(nc_inq_path(ncid, length, c_loc(path)), "Path")
  call require(path(length + 1) == c_null_char, "Terminated path")
  call check(nc_set_fill(ncid, NC_FILL, oldfill), "Dataset fill mode")
  call check(nc_def_dim(ncid, "time"//c_null_char, NC_UNLIMITED, dimids(1)), "Time dimension")
  call check(nc_def_dim(ncid, "x"//c_null_char, 2_c_size_t, dimids(2)), "X dimension")
  call check(nc_def_var(ncid, "samples"//c_null_char, NC_SHORT, 2_c_int, dimids, varid), "Define samples")
  chunks = [2_c_size_t, 2_c_size_t]
  fill = -99_c_short
  call check(nc_def_var_chunking(ncid, varid, NC_CHUNKED, c_loc(chunks)), "Chunking")
  call check(nc_def_var_deflate(ncid, varid, NC_SHUFFLE, 1_c_int, 2_c_int), "Deflate")
  call check(nc_def_var_fletcher32(ncid, varid, NC_FLETCHER32), "Checksum")
  call check(nc_def_var_endian(ncid, varid, NC_ENDIAN_LITTLE), "Endianness")
  call check(nc_def_var_fill(ncid, varid, 0_c_int, c_loc(fill)), "Fill value")
  call check(nc_set_var_chunk_cache(ncid, varid, 1048576_c_size_t, 521_c_size_t, 0.25_c_float), "Var cache")
  call check(nc_get_var_chunk_cache(ncid, varid, cache_size, cache_nelems, preemption), "Inquire var cache")
  call require(cache_size == 1048576_c_size_t .and. cache_nelems == 521_c_size_t .and. &
    & abs(preemption - 0.25_c_float) < epsilon(preemption), "Variable cache round trip")
  att = [12.0_c_double, 34.0_c_double]
  call check(nc_put_att_double(ncid, varid, "range"//c_null_char, NC_SHORT, 2_c_size_t, c_loc(att)), "Put attribute")
  call check(nc_copy_att(ncid, varid, "range"//c_null_char, ncid, NC_GLOBAL), "Copy attribute")
  call check(nc_rename_att(ncid, NC_GLOBAL, "range"//c_null_char, "copied_range"//c_null_char), "Rename attribute")
  call check(nc_del_att(ncid, varid, "range"//c_null_char), "Delete attribute")
  call require(nc_inq_attid(ncid, varid, "range"//c_null_char, attid) == NC_ENOTATT, "Attribute absent")
  call check(nc_inq_att(ncid, NC_GLOBAL, "copied_range"//c_null_char, xtype, length), "Attribute inquiry")
  call require(xtype == NC_SHORT .and. length == 2, "Copied attribute metadata")
  call check(nc_inq_atttype(ncid, NC_GLOBAL, "copied_range"//c_null_char, xtype), "Attribute type")
  call check(nc_inq_attid(ncid, NC_GLOBAL, "copied_range"//c_null_char, attid), "Attribute ID")
  call check(nc_get_att_double(ncid, NC_GLOBAL, "copied_range"//c_null_char, c_loc(actual_att)), "Get attribute")
  call require(all(abs(actual_att - att) < epsilon(att)), "Converted attribute values")
  call check(nc_def_grp(ncid, "old"//c_null_char, grpid), "Define group")
  call check(nc_rename_grp(grpid, "observations"//c_null_char), "Rename group")
  call check(nc_inq_grpname_len(grpid, length), "Group path length")
  call require(length == len("/observations"), "Full group path length")
  call check(nc_rename_dim(ncid, dimids(2), "station"//c_null_char), "Rename dimension")
  call check(nc_rename_var(ncid, varid, "temperature"//c_null_char), "Rename variable")
  call check(nc_inq_type(ncid, NC_SHORT, name, length), "Type size")
  call require(length == c_sizeof(fill), "Short memory size")
  call check(nc_enddef(ncid), "End definition")

  ! C dimensions [time, station] map onto Fortran storage [station, time].
  start = 0_c_size_t
  count = 2_c_size_t
  stride = [2_c_ptrdiff_t, 1_c_ptrdiff_t]
  values = reshape([1_c_int, 2_c_int, 5_c_int, 6_c_int], [2, 2])
  call check(nc_put_vars_int(ncid, varid, c_loc(start), c_loc(count), c_loc(stride), c_loc(values)), "Strided append")
  call check(nc_sync(ncid), "Sync")
  call check(nc_close(ncid), "Close")
  call check(nc_open(RESULTS//"c-storage.nc"//c_null_char, NC_WRITE, ncid), "Reopen")
  call check(nc_inq_varid(ncid, "temperature"//c_null_char, varid), "Renamed variable")
  call check(nc_inq_var_chunking(ncid, varid, storage, c_loc(actual_chunks)), "Read chunks")
  call require(storage == NC_CHUNKED .and. all(actual_chunks == chunks), "Persisted chunks")
  call check(nc_inq_var_deflate(ncid, varid, shuffle, deflate, level), "Read deflate")
  call require(shuffle == NC_SHUFFLE .and. deflate == 1 .and. level == 2, "Persisted deflate")
  call check(nc_inq_var_fletcher32(ncid, varid, checksum), "Read checksum")
  call require(checksum == NC_FLETCHER32, "Persisted checksum")
  call check(nc_inq_var_endian(ncid, varid, endian), "Read endianness")
  call require(endian == NC_ENDIAN_LITTLE, "Persisted endianness")
  call check(nc_inq_var_fill(ncid, varid, nofill, c_loc(actual_fill)), "Read fill")
  call require(nofill == 0 .and. actual_fill == fill, "Persisted fill")
  call check(nc_inq(ncid, ndims, nvars, natts, unlim), "Dataset summary")
  call require(ndims == 2 .and. nvars == 1 .and. natts == 1, "Summary counts")
  call check(nc_inq_dim(ncid, unlim, name, length), "Unlimited dimension length")
  call require(length == 3, "Strided writes extended time")
  call check(nc_get_var_double(ncid, varid, c_loc(actual)), "Read converted values")
  call require(all(abs(actual(:, 2) - real(fill, c_double)) < epsilon(actual)), "Unwritten records filled")
  call require(all(abs(actual(:, 1) - [1.0_c_double, 2.0_c_double]) < epsilon(actual)), "First record")
  call require(all(abs(actual(:, 3) - [5.0_c_double, 6.0_c_double]) < epsilon(actual)), "Last record")
  start = [1_c_size_t, 0_c_size_t]
  count = [1_c_size_t, 2_c_size_t]
  replacement = [3_c_int, 4_c_int]
  call check(nc_put_vars_int(ncid, varid, c_loc(start), c_loc(count), c_null_ptr, c_loc(replacement)), "Unit strides")
  start = 0_c_size_t
  count = [3_c_size_t, 2_c_size_t]
  call check(nc_get_vara(ncid, varid, c_loc(start), c_loc(count), c_loc(raw)), "Read raw slab")
  call require(all(reshape(raw, [6]) == [1, 2, 3, 4, 5, 6]), "Raw short representation")
  count = 2_c_size_t
  values = 0
  call check(nc_get_vars_int(ncid, varid, c_loc(start), c_loc(count), c_loc(stride), c_loc(values)), "Read strided")
  call require(all(reshape(values, [4]) == [1, 2, 5, 6]), "Strided conversion")
  call check(nc_close(ncid), "Close updated dataset")
  passed = .true.
end subroutine c_bindings_storage

subroutine c_bindings_formats(passed)
  !! Exercise classic define mode, CDF-2/CDF-5 flags, and unsigned conversion.
  logical, intent(inout) :: passed
  integer(c_int), parameter :: modes(4) = [NC_CLOBBER, NC_64BIT_OFFSET, NC_64BIT_DATA, &
    & ior(NC_NETCDF4, NC_CLASSIC_MODEL)]
  integer(c_int), parameter :: formats(4) = [NC_FORMAT_CLASSIC, NC_FORMAT_64BIT_OFFSET, &
    & NC_FORMAT_CDF5, NC_FORMAT_NETCDF4_CLASSIC]
  integer(c_int) :: ncid, dimid, varid, format, n, i, xtype
  integer(c_int), target :: values(2)
  integer(c_long_long), target :: unsigned_values(2), actual_unsigned(2)
  integer(c_size_t), target :: start(1), count(1)
  real(c_float), target :: actual(2)
  character(kind=c_char), target :: text(3), actual_text(3)
  character(1) :: digit

  passed = .false.
  text = ['a', 'b', 'c']
  do i = 1, 4
    write(digit, '(i1)') i
    call check(nc_create(RESULTS//"c-format-"//digit//".nc"//c_null_char, modes(i), ncid), "Create format")
    call check(nc_def_dim(ncid, "x"//c_null_char, 2_c_size_t, dimid), "Define x")
    call check(nc_def_var(ncid, "v"//c_null_char, NC_INT, 1_c_int, [dimid], varid), "Define v")
    call check(nc_enddef(ncid), "Exit classic define mode")
    values = [7_c_int, 8_c_int]
    call check(nc_put_var_int(ncid, varid, c_loc(values)), "Write classic values")
    call check(nc_redef(ncid), "Reenter define mode")
    call check(nc_put_att_text(ncid, varid, "units"//c_null_char, 3_c_size_t, c_loc(text)), "Text attribute")
    call check(nc_enddef(ncid), "Finish metadata update")
    call check(nc_sync(ncid), "Sync classic")
    call check(nc_close(ncid), "Close classic")
    call check(nc_open(RESULTS//"c-format-"//digit//".nc"//c_null_char, NC_NOWRITE, ncid), "Read classic")
    call check(nc_inq_format(ncid, format), "Inquire format")
    call require(format == formats(i), "Requested format persisted")
    call check(nc_inq_ndims(ncid, n), "Dimension count")
    call require(n == 1, "One dimension")
    call check(nc_inq_nvars(ncid, n), "Variable count")
    call require(n == 1, "One variable")
    call check(nc_get_var_float(ncid, varid, c_loc(actual)), "Convert classic integers")
    call require(all(abs(actual - real(values, c_float)) < epsilon(actual)), "Classic values")
    call check(nc_get_att_text(ncid, varid, "units"//c_null_char, c_loc(actual_text)), "Read text attribute")
    call require(all(actual_text == text), "Non-NUL-terminated attribute text")
    call require(nc_put_var_int(ncid, varid, c_loc(values)) /= NC_NOERR, "Read-only write rejected")
    call check(nc_close(ncid), "Close classic read")
  end do

  call check(nc_create(RESULTS//"c-unsigned.nc"//c_null_char, NC_NETCDF4, ncid), "Create unsigned dataset")
  call check(nc_def_dim(ncid, "x"//c_null_char, 2_c_size_t, dimid), "Unsigned dimension")
  start = 0_c_size_t
  count = 2_c_size_t
  do xtype = NC_UBYTE, NC_UINT
    write(digit, '(i1)') xtype
    call check(nc_def_var(ncid, "u"//digit//c_null_char, xtype, 1_c_int, [dimid], varid), "Unsigned variable")
    select case (xtype)
    case (NC_UBYTE)
      unsigned_values = [128_c_long_long, 255_c_long_long]
    case (NC_USHORT)
      unsigned_values = [32768_c_long_long, 65535_c_long_long]
    case (NC_UINT)
      unsigned_values = [2147483648_c_long_long, 4294967295_c_long_long]
    end select
    call check(nc_put_vara_longlong(ncid, varid, c_loc(start), c_loc(count), c_loc(unsigned_values)), "Write unsigned")
    call check(nc_get_vara_longlong(ncid, varid, c_loc(start), c_loc(count), c_loc(actual_unsigned)), "Read unsigned")
    call require(all(actual_unsigned == unsigned_values), "Full unsigned range in wider signed memory")
  end do
  call require(nc_get_var_int(ncid, varid, c_loc(values)) == NC_ERANGE, "Overflow status preserved")
  call check(nc_close(ncid), "Close unsigned dataset")

  call check(nc_create(RESULTS//"c-abort.nc"//c_null_char, NC_CLOBBER, ncid), "Create abort test")
  call check(nc_abort(ncid), "Abort unfinished creation")
  passed = .true.
end subroutine c_bindings_formats

subroutine c_bindings_strings(passed)
  !! Verify char ** indirection, string ownership, and all string access shapes.
  logical, intent(inout) :: passed
  integer(c_int) :: ncid, dimid, varid, textid, scalarid
  integer(c_size_t) :: length
  integer(c_size_t), target :: start(1), count(1)
  integer(c_ptrdiff_t), target :: stride(1)
  type(c_ptr), target :: inputs(3), outputs(3), fillptr(1)
  character(kind=c_char, len=6), target :: first
  character(kind=c_char, len=2), target :: second
  character(kind=c_char, len=1), target :: empty
  character(kind=c_char), target :: text(3), actual_text(3)
  character(kind=c_char), pointer :: chars(:)
  integer(c_int) :: nofill

  passed = .false.
  first = 'alpha'//c_null_char
  second = 'b'//c_null_char
  empty = c_null_char
  text = ['x', c_null_char, 'z']
  inputs = [c_loc(first), c_loc(second), c_loc(empty)]
  outputs = c_null_ptr
  call check(nc_create(RESULTS//"c-strings.nc"//c_null_char, NC_NETCDF4, ncid), "Create strings")
  call check(nc_def_dim(ncid, "x"//c_null_char, 3_c_size_t, dimid), "String dimension")
  call check(nc_def_var(ncid, "labels"//c_null_char, NC_STRING, 1_c_int, [dimid], varid), "String variable")
  call check(nc_def_var(ncid, "text"//c_null_char, NC_CHAR, 1_c_int, [dimid], textid), "Text variable")
  call check(nc_def_var(ncid, "scalar"//c_null_char, NC_STRING, 0_c_int, [dimid], scalarid), "Scalar string")
  call check(nc_def_var_fill(ncid, varid, 0_c_int, c_loc(inputs(3))), "String fill")
  call check(nc_put_att_string(ncid, NC_GLOBAL, "labels"//c_null_char, 3_c_size_t, c_loc(inputs)), "String attribute")
  call check(nc_put_var_string(ncid, varid, c_loc(inputs)), "Whole string write")
  call check(nc_put_var_text(ncid, textid, c_loc(text)), "Text write")
  start = 0_c_size_t
  count = 1_c_size_t
  call check(nc_put_vara_string(ncid, scalarid, c_null_ptr, c_null_ptr, c_loc(inputs)), "Scalar string write")
  call check(nc_put_vara_string(ncid, varid, c_loc(start), c_loc(count), c_loc(inputs(2))), "String slab write")
  count = 2_c_size_t
  stride = 2_c_ptrdiff_t
  call check(nc_put_vars_string(ncid, varid, c_loc(start), c_loc(count), c_loc(stride), c_loc(inputs)), &
    & "Strided strings")
  call check(nc_close(ncid), "Close strings")
  call check(nc_open(RESULTS//"c-strings.nc"//c_null_char, NC_NOWRITE, ncid), "Reopen strings")
  call check(nc_get_var_string(ncid, varid, c_loc(outputs)), "Read whole strings")
  call require(c_strlen(outputs(1)) == 5 .and. c_strlen(outputs(3)) == 1, "Variable-length results")
  call c_f_pointer(outputs(1), chars, [6])
  call require(all(chars == ['a', 'l', 'p', 'h', 'a', c_null_char]), "String content")
  nullify(chars)
  call check(nc_free_string(3_c_size_t, c_loc(outputs)), "Free whole strings")
  outputs = c_null_ptr
  call check(nc_get_vars_string(ncid, varid, c_loc(start), c_loc(count), c_loc(stride), c_loc(outputs)), &
    & "Read strided strings")
  call require(c_strlen(outputs(1)) == 5 .and. c_strlen(outputs(2)) == 1, "Selected strings")
  call check(nc_free_string(2_c_size_t, c_loc(outputs)), "Free selected strings")
  outputs = c_null_ptr
  call check(nc_get_vara_string(ncid, scalarid, c_null_ptr, c_null_ptr, c_loc(outputs)), "Read scalar string")
  call require(c_strlen(outputs(1)) == 5, "Scalar string content")
  call check(nc_free_string(1_c_size_t, c_loc(outputs)), "Free scalar string")
  outputs = c_null_ptr
  call check(nc_inq_attlen(ncid, NC_GLOBAL, "labels"//c_null_char, length), "String attribute length")
  call require(length == 3, "Attribute count is strings, not bytes")
  call check(nc_get_att_string(ncid, NC_GLOBAL, "labels"//c_null_char, c_loc(outputs)), "Read string attribute")
  call require(c_strlen(outputs(3)) == 0, "Empty string attribute element")
  call check(nc_free_string(length, c_loc(outputs)), "Free attribute strings")
  fillptr = c_null_ptr
  call check(nc_inq_var_fill(ncid, varid, nofill, c_loc(fillptr)), "Read string fill")
  call require(c_strlen(fillptr(1)) == 0, "Empty fill string")
  call check(nc_free_string(1_c_size_t, c_loc(fillptr)), "Free fill string")
  call check(nc_get_var_text(ncid, textid, c_loc(actual_text)), "Read text")
  call require(all(actual_text == text), "NC_CHAR preserves embedded NUL")
  call check(nc_close(ncid), "Close string read")
  passed = .true.
end subroutine c_bindings_strings

subroutine c_bindings_user_types(passed)
  !! Exercise native padding, nested strings/VLENs, deep copy, enums, and opaque data.
  logical, intent(inout) :: passed
  integer(c_int) :: ncid, compound, sequence, enumeration, opaque, varid, enumvar, blobvar
  integer(c_int) :: base, classid, fieldid, fieldtype, rank, ntypes, equal
  integer(c_int), target :: members(2), fieldshape(1), histories(3), decoded_history(3), typeids(4)
  integer(c_int), pointer :: copied_history(:)
  integer(c_size_t) :: bytes, nfields, offset, nelems
  integer(c_intptr_t) :: record_address
  type(observation_record), target :: original, actual, copied
  type(observation_record), pointer :: allocated_copy
  type(c_ptr) :: allocation
  integer(c_signed_char), target :: blob(3), readblob(3)
  character(kind=c_char, len=7), target :: label
  character(kind=c_char), target :: name(NC_MAX_NAME + 1)

  passed = .false.
  call check(nc_create(RESULTS//"c-user-types.nc"//c_null_char, NC_NETCDF4, ncid), "Create user types")
  call check(nc_def_vlen(ncid, "history"//c_null_char, NC_INT, sequence), "Define VLEN")
  call check(nc_def_enum(ncid, NC_INT, "quality"//c_null_char, enumeration), "Define enum")
  members = [2_c_int, 7_c_int]
  call check(nc_insert_enum(ncid, enumeration, "good"//c_null_char, c_loc(members(1))), "Enum member good")
  call check(nc_insert_enum(ncid, enumeration, "bad"//c_null_char, c_loc(members(2))), "Enum member bad")
  call check(nc_def_opaque(ncid, 3_c_size_t, "blob"//c_null_char, opaque), "Define opaque")
  call check(nc_def_compound(ncid, c_sizeof(original), "observation"//c_null_char, compound), "Define compound")
  record_address = transfer(c_loc(original), record_address)
  offset = int(transfer(c_loc(original%station), record_address) - record_address, c_size_t)
  call check(nc_insert_compound(ncid, compound, "station"//c_null_char, offset, NC_INT), "Station field")
  offset = int(transfer(c_loc(original%samples), record_address) - record_address, c_size_t)
  fieldshape = 2_c_int
  call check(nc_insert_array_compound(ncid, compound, "samples"//c_null_char, offset, NC_DOUBLE, &
    & 1_c_int, c_loc(fieldshape)), "Array field with native padding")
  offset = int(transfer(c_loc(original%label), record_address) - record_address, c_size_t)
  call check(nc_insert_compound(ncid, compound, "label"//c_null_char, offset, NC_STRING), "String field")
  offset = int(transfer(c_loc(original%history), record_address) - record_address, c_size_t)
  call check(nc_insert_compound(ncid, compound, "history"//c_null_char, offset, sequence), "VLEN field")
  call check(nc_def_var(ncid, "record"//c_null_char, compound, 0_c_int, [0_c_int], varid), "Compound variable")
  call check(nc_def_var(ncid, "quality_value"//c_null_char, enumeration, 0_c_int, [0_c_int], enumvar), "Enum variable")
  call check(nc_def_var(ncid, "blob_value"//c_null_char, opaque, 0_c_int, [0_c_int], blobvar), "Opaque variable")
  call check(nc_enddef(ncid), "Commit user-defined types")
  call check(nc_inq_typeids(ncid, ntypes, c_loc(typeids)), "Enumerate types")
  call require(ntypes == 4 .and. any(typeids == compound), "All user types discoverable")
  call check(nc_inq_type_equal(ncid, compound, ncid, compound, equal), "Type equality")
  call require(equal /= 0, "Same type compares equal")
  call check(nc_inq_user_type(ncid, compound, c_loc(name), bytes, base, nfields, classid), "Compound metadata")
  call require(bytes == c_sizeof(original) .and. nfields == 4 .and. classid == NC_COMPOUND, "Compound layout")
  call check(nc_inq_compound_fieldindex(ncid, compound, "samples"//c_null_char, fieldid), "Field index")
  call check(nc_inq_compound_field(ncid, compound, fieldid, c_loc(name), offset, fieldtype, rank, &
    & c_loc(fieldshape)), "Array field inquiry")
  call require(fieldtype == NC_DOUBLE .and. rank == 1 .and. fieldshape(1) == 2, "Array field shape")
  call require(offset == int(transfer(c_loc(original%samples), record_address) - record_address, c_size_t), &
    & "Native padding preserved")
  call check(nc_inq_enum_ident(ncid, enumeration, 7_c_long_long, c_loc(name)), "Enum lookup")
  call require(all(name(1:4) == ['b', 'a', 'd', c_null_char]), "Enum identifier")

  label = 'sensor'//c_null_char
  histories = [10_c_int, 20_c_int, 30_c_int]
  original%station = 42_c_int
  original%samples = [1.25_c_double, 2.5_c_double]
  original%label = c_loc(label)
  call check(nc_put_vlen_element(ncid, sequence, c_loc(original%history), 3_c_size_t, c_loc(histories)), &
    & "Populate borrowed VLEN descriptor")
  call require(c_associated(original%history%p, c_loc(histories)), "Input VLEN borrows its payload")
  call check(nc_get_vlen_element(ncid, sequence, c_loc(original%history), nelems, c_loc(decoded_history)), &
    & "Extract VLEN payload")
  call require(nelems == 3 .and. all(decoded_history == histories), "VLEN element contents")
  blob = [1_c_signed_char, -1_c_signed_char, 99_c_signed_char]
  call check(nc_put_var(ncid, varid, c_loc(original)), "Write nested compound")
  call check(nc_put_var(ncid, enumvar, c_loc(members(2))), "Write enum")
  call check(nc_put_var(ncid, blobvar, c_loc(blob)), "Write opaque")
  call check(nc_close(ncid), "Close user types")
  call check(nc_open(RESULTS//"c-user-types.nc"//c_null_char, NC_NOWRITE, ncid), "Reopen user types")
  call check(nc_inq_typeid(ncid, "observation"//c_null_char, compound), "Find compound type")
  call check(nc_get_var(ncid, varid, c_loc(actual)), "Read nested compound")
  call require(actual%station == 42 .and. actual%history%len == 3, "Compound scalar and VLEN length")
  call require(all(abs(actual%samples - original%samples) < epsilon(actual%samples)), "Compound array field")
  call require(c_strlen(actual%label) == 6, "Compound string allocated")
  call check(ncaux_copy_data(ncid, compound, c_loc(actual), 1_c_size_t, c_loc(copied)), "Aux deep copy alias")
  call require(.not. c_associated(actual%history%p, copied%history%p), "Deep copy has independent payload")
  call check(nc_copy_data_all(ncid, compound, c_loc(actual), 1_c_size_t, allocation), "Allocate deep copy")
  call c_f_pointer(allocation, allocated_copy)
  call check(nc_reclaim_data(ncid, compound, c_loc(actual), 1_c_size_t), "Reclaim original nested allocations")
  call c_f_pointer(copied%history%p, copied_history, [3])
  call require(all(copied_history == histories), "Copy survives original reclamation")
  nullify(copied_history)
  call require(allocated_copy%station == 42, "Allocated copy survives original reclamation")
  nullify(allocated_copy)
  call check(ncaux_reclaim_data(ncid, compound, c_loc(copied), 1_c_size_t), "Reclaim copied nested allocations")
  call check(nc_reclaim_data_all(ncid, compound, allocation, 1_c_size_t), "Free allocated deep copy")
  call check(nc_get_var(ncid, blobvar, c_loc(readblob)), "Read opaque")
  call require(all(readblob == blob), "Opaque bytes round trip")
  call check(nc_get_var(ncid, enumvar, c_loc(members(1))), "Read enum")
  call require(members(1) == 7, "Enum value round trip")
  call check(nc_close(ncid), "Close user-type read")
  passed = .true.
end subroutine c_bindings_user_types

subroutine c_bindings_memory_mapped(passed)
  !! Exercise memory-file ownership, mapped layouts, scalar I/O, and filter controls.
  logical, intent(inout) :: passed
  integer(c_int) :: ncid, dims(2), varid, floatid, qmode, precision
  integer(c_int), target :: values(6), mapped(6)
  integer(c_int) :: shuffle, deflate, level
  integer(c_size_t), target :: start(2), count(2)
  integer(c_ptrdiff_t), target :: stride(2), imap(2)
  real(c_double), target :: scalar
  type(NC_memio), target :: info
  type(c_ptr) :: image

  passed = .false.
  call check(nc_create_mem("memory"//c_null_char, NC_CLOBBER, 0_c_size_t, ncid), "Create memory dataset")
  call check(nc_def_dim(ncid, "row"//c_null_char, 2_c_size_t, dims(1)), "Memory row dimension")
  call check(nc_def_dim(ncid, "col"//c_null_char, 3_c_size_t, dims(2)), "Memory col dimension")
  call check(nc_def_var(ncid, "v"//c_null_char, NC_INT, 2_c_int, dims, varid), "Memory variable")
  call check(nc_enddef(ncid), "End memory definition")
  values = [1, 2, 3, 4, 5, 6]
  call check(nc_put_var_int(ncid, varid, c_loc(values)), "Write memory values")
  start = 0_c_size_t
  count = [2_c_size_t, 3_c_size_t]
  stride = 1_c_ptrdiff_t
  imap = [1_c_ptrdiff_t, 2_c_ptrdiff_t]
  call check(nc_get_varm_int(ncid, varid, c_loc(start), c_loc(count), c_loc(stride), c_loc(imap), &
    & c_loc(mapped)), "Read mapped transpose")
  call require(all(mapped == [1, 4, 2, 5, 3, 6]), "Mapped memory strides are element counts")
  mapped = mapped + 10
  call check(nc_put_varm_int(ncid, varid, c_loc(start), c_loc(count), c_loc(stride), c_loc(imap), &
    & c_loc(mapped)), "Write mapped transpose")
  start = [1_c_size_t, 2_c_size_t]
  call check(nc_get_var1_double(ncid, varid, c_loc(start), c_loc(scalar)), "Read converted single element")
  call require(abs(scalar - 16.0_c_double) < epsilon(scalar), "Selected final element")
  scalar = 99.0_c_double
  call check(nc_put_var1_double(ncid, varid, c_loc(start), c_loc(scalar)), "Write converted single element")
  info%size = 0
  info%memory = c_null_ptr
  info%flags = 0
  call check(nc_close_memio(ncid, c_loc(info)), "Return memory image")
  image = info%memory
  call require(c_associated(image) .and. info%size > 0, "C-owned memory image returned")
  call check(nc_open_mem("memory"//c_null_char, NC_NOWRITE, info%size, image, ncid), "Open borrowed image")
  call check(nc_get_var_int(ncid, varid, c_loc(values)), "Read borrowed image")
  call require(all(values == [11, 12, 13, 14, 15, 99]), "Image retains mapped and scalar writes")
  call check(nc_close(ncid), "Close borrowed image")
  info%flags = NC_MEMIO_LOCKED
  call check(nc_open_memio("locked"//c_null_char, NC_NOWRITE, c_loc(info), ncid), "Open locked image")
  call check(nc_close_memio(ncid, c_loc(info)), "Close locked image")
  call require(c_associated(image, info%memory), "Locked image ownership retained")
  call c_free(image)

  call check(nc_create(RESULTS//"c-filters.nc"//c_null_char, NC_NETCDF4, ncid), "Create filters")
  call check(nc_def_dim(ncid, "x"//c_null_char, 6_c_size_t, dims(1)), "Filter dimension")
  call check(nc_def_var(ncid, "v"//c_null_char, NC_FLOAT, 1_c_int, dims(1:1), floatid), "Filter variable")
  call check(nc_def_var_quantize(ncid, floatid, NC_QUANTIZE_BITROUND, 12_c_int), "Quantization")
  call check(nc_inq_var_quantize(ncid, floatid, qmode, precision), "Quantization inquiry")
  call require(qmode == NC_QUANTIZE_BITROUND .and. precision == 12, "Quantization settings")
  call check(nc_def_var_deflate(ncid, floatid, 0_c_int, 1_c_int, 2_c_int), "Deflate filter")
  call check(nc_inq_var_deflate(ncid, floatid, shuffle, deflate, level), "Deflate inquiry")
  call require(shuffle == 0 .and. deflate == 1 .and. level == 2, "Deflate settings preserved")
  call check(nc_close(ncid), "Close filters")
  passed = .true.
end subroutine c_bindings_memory_mapped

subroutine c_bindings_legacy_aux(passed)
  !! Exercise legacy long-vector ABI, C-owned auxiliary output, and runtime configuration.
  logical, intent(inout) :: passed
  integer(c_int) :: ncid, varid
  integer(c_int), target :: dimid
  integer(c_int), target :: values(3), actual(3)
  integer(c_long), target :: start(1), count(1)
  integer(c_size_t) :: length
  type(c_ptr) :: buffer, joined
  type(NCPluginList), target :: paths

  passed = .false.
  ncid = nccreate(RESULTS//"c-legacy.nc"//c_null_char, NC_CLOBBER)
  call require(ncid >= 0, "Legacy create returns an ID")
  dimid = ncdimdef(ncid, "x"//c_null_char, 3_c_long)
  call require(dimid >= 0, "Legacy dimension ID")
  varid = ncvardef(ncid, "v"//c_null_char, NC_INT, 1_c_int, c_loc(dimid))
  call require(varid >= 0, "Legacy variable ID")
  call require(ncendef(ncid) /= -1, "Legacy end definition")
  start = 0_c_long
  count = 3_c_long
  values = [4, 5, 6]
  call require(ncvarput(ncid, varid, c_loc(start), c_loc(count), c_loc(values)) /= -1, "Legacy write")
  call require(ncvarget(ncid, varid, c_loc(start), c_loc(count), c_loc(actual)) /= -1, "Legacy read")
  call require(all(actual == values), "Legacy long counts and integer payload")
  call require(ncclose(ncid) /= -1, "Legacy close")

  call check(ncaux_readfile(RESULTS//"c-legacy.nc"//c_null_char, length, buffer), "Auxiliary file read")
  call check(nc_open_mem("aux"//c_null_char, NC_NOWRITE, length, buffer, ncid), "Open auxiliary buffer")
  call check(nc_get_var_int(ncid, varid, c_loc(actual)), "Read auxiliary image")
  call require(all(actual == values), "Auxiliary read contents")
  call check(nc_close(ncid), "Close auxiliary image")
  call c_free(buffer)
  call check(nc_rc_set("NC4F_TEST_KEY"//c_null_char, "value"//c_null_char), "Set runtime value")
  buffer = nc_rc_get("NC4F_TEST_KEY"//c_null_char)
  call require(c_associated(buffer), "Runtime lookup allocated a result")
  call require(c_strlen(buffer) == 5, "Runtime lookup value length")
  call c_free(buffer)
  paths%ndirs = 0
  paths%dirs = c_null_ptr
  call check(ncaux_plugin_path_parse("/tmp/a;/tmp/b"//c_null_char, ';', c_loc(paths)), "Parse isolated plugin list")
  call require(paths%ndirs == 2, "Two isolated plugin directories")
  call check(ncaux_plugin_path_tostring(c_loc(paths), ';', joined), "Join isolated plugin list")
  call require(c_strlen(joined) == 13, "Joined plugin path length")
  call c_free(joined)
  call check(ncaux_plugin_path_clear(c_loc(paths)), "Free isolated path contents")
  passed = .true.
end subroutine c_bindings_legacy_aux

end module nc4f_test_c_bindings
