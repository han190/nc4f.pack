! File lifecycle, format inquiry, and dataset-wide settings.
! Included inside the interface block of nc4f_c_interface.

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

function nc_inq_libvers() bind(c, name="nc_inq_libvers")
  !! Return the linked NetCDF library version string.
  import :: c_ptr
  type(c_ptr) :: nc_inq_libvers
  !! Pointer to library-owned NUL-terminated text; do not free or modify it.
end function nc_inq_libvers

function nc_redef(ncid) bind(c, name="nc_redef")
  !! Enter define mode to modify a dataset schema.
  !! Classic files require define mode for schema changes.
  import :: c_int
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int) :: nc_redef
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_EPERM Dataset is read-only.
  !! - NC_EINDEFINE Dataset is already in define mode.
end function nc_redef

function nc_enddef(ncid) bind(c, name="nc_enddef")
  !! Finish schema definition and enter data mode.
  !! Set variable storage properties before this call or the first data write.
  import :: c_int
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int) :: nc_enddef
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_ENOTINDEFINE Dataset is not in define mode.
end function nc_enddef

function nc_sync(ncid) bind(c, name="nc_sync")
  !! Flush pending writes and refresh cached dataset state.
  !! This is not a transaction or a substitute for nc_close().
  import :: c_int
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int) :: nc_sync
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
end function nc_sync

function nc_abort(ncid) bind(c, name="nc_abort")
  !! Close a dataset and abandon an unfinished classic define operation.
  !! A newly created dataset still in define mode may be deleted.
  !! This does not provide general rollback for data writes or NetCDF-4 changes.
  import :: c_int
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int) :: nc_abort
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
end function nc_abort

function nc_inq(ncid, ndimsp, nvarsp, nattsp, unlimdimidp) bind(c, name="nc_inq")
  !! Inquire about local dimensions, variables, attributes, and an unlimited dimension.
  !! Use nc_inq_unlimdims() to discover all unlimited dimensions in NetCDF-4 files.
  import :: c_int
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), intent(out) :: ndimsp
  !! Returned local dimension count.
  integer(c_int), intent(out) :: nvarsp
  !! Returned local variable count.
  integer(c_int), intent(out) :: nattsp
  !! Returned file/group attribute count.
  integer(c_int), intent(out) :: unlimdimidp
  !! Returned unlimited dimension ID, or -1 if absent.
  integer(c_int) :: nc_inq
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
end function nc_inq

function nc_inq_ndims(ncid, ndimsp) bind(c, name="nc_inq_ndims")
  !! Return the number of local dimensions.
  import :: c_int
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), intent(out) :: ndimsp
  !! Returned count.
  integer(c_int) :: nc_inq_ndims
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
end function nc_inq_ndims

function nc_inq_nvars(ncid, nvarsp) bind(c, name="nc_inq_nvars")
  !! Return the number of local variables.
  import :: c_int
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), intent(out) :: nvarsp
  !! Returned count.
  integer(c_int) :: nc_inq_nvars
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
end function nc_inq_nvars

function nc_inq_format(ncid, formatp) bind(c, name="nc_inq_format")
  !! Return the dataset format presented by the NetCDF API.
  import :: c_int
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), intent(out) :: formatp
  !! Returned NC_FORMAT_* constant; this is not a creation-mode bit mask.
  integer(c_int) :: nc_inq_format
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
end function nc_inq_format

function nc_inq_format_extended(ncid, formatp, modep) bind(c, name="nc_inq_format_extended")
  !! Return the underlying backend and effective mode flags.
  import :: c_int
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), intent(out) :: formatp
  !! Returned NC_FORMATX_* backend identifier.
  integer(c_int), intent(out) :: modep
  !! Returned effective open/create mode bit mask.
  integer(c_int) :: nc_inq_format_extended
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
end function nc_inq_format_extended

function nc_inq_path(ncid, pathlen, path) bind(c, name="nc_inq_path")
  !! Return the path or URL used to open the dataset.
  import :: c_int, c_size_t, c_ptr
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_size_t), intent(out) :: pathlen
  !! Returned path length excluding the NUL terminator.
  type(c_ptr), value :: path
  !! Pointer to a character(c_char) buffer of pathlen + 1 bytes.
  !! Pass c_null_ptr to query only the required length.
  integer(c_int) :: nc_inq_path
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
end function nc_inq_path

function nc_set_fill(ncid, fillmode, old_modep) bind(c, name="nc_set_fill")
  !! Set dataset fill mode and return the previous mode.
  !! Use nc_def_var_fill() for per-variable fill control.
  import :: c_int
  integer(c_int), value :: ncid
  !! Open file or group identifier.
  integer(c_int), value :: fillmode
  !! NC_FILL or NC_NOFILL; no-fill leaves unwritten data undefined.
  integer(c_int), intent(out) :: old_modep
  !! Previous fill mode.
  integer(c_int) :: nc_set_fill
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EBADID Invalid file or group identifier.
  !! - NC_EINVAL Invalid fill mode.
  !! - NC_EPERM Dataset is read-only.
end function nc_set_fill

function nc_set_chunk_cache(size, nelems, preemption) bind(c, name="nc_set_chunk_cache")
  !! Set the default chunk cache settings.
  !! Default settings apply to subsequently opened or created NetCDF-4/HDF5 files.
  import :: c_int, c_size_t, c_float
  integer(c_size_t), value :: size
  !! Chunk cache capacity in bytes.
  integer(c_size_t), value :: nelems
  !! Number of cache hash slots.
  real(c_float), value :: preemption
  !! Cache preemption policy between 0.0 and 1.0.
  integer(c_int) :: nc_set_chunk_cache
  !! **Options:**
  !! - NC_NOERR No error.
  !! - NC_EINVAL Invalid cache settings.
end function nc_set_chunk_cache

function nc_get_chunk_cache(sizep, nelemsp, preemptionp) bind(c, name="nc_get_chunk_cache")
  !! Query the default chunk cache settings.
  !! Default settings apply to subsequently opened or created NetCDF-4/HDF5 files.
  import :: c_int, c_size_t, c_float
  integer(c_size_t), intent(out) :: sizep
  !! Chunk cache capacity in bytes.
  integer(c_size_t), intent(out) :: nelemsp
  !! Number of cache hash slots.
  real(c_float), intent(out) :: preemptionp
  !! Cache preemption policy between 0.0 and 1.0.
  integer(c_int) :: nc_get_chunk_cache
  !! **Options:**
  !! - NC_NOERR No error.
end function nc_get_chunk_cache

! Additional serial C API, including legacy and extension interfaces.

function nc_def_user_format(mode_flag, dispatch_table, magic_number) bind(c, name="nc_def_user_format")
  !! Register a user-defined backend dispatch table and magic signature.
  !! The dispatch_table is an opaque pointer to a live NC_Dispatch built against the linked C library.
  !! Its callbacks and storage must outlive all datasets using it; this does not register MPI access.
  !! C declaration: int nc_def_user_format(int mode_flag, NC_Dispatch *dispatch_table, char *magic_number);
  import :: c_int, c_ptr
  integer(c_int), value :: mode_flag
  !! NC_UDF* mode flag.
  type(c_ptr), value :: dispatch_table
  !! Address of an NC_Dispatch table; callbacks and table storage must remain alive. C pointee: NC_Dispatch
  !! *.
  type(c_ptr), value :: magic_number
  !! Magic signature buffer (NC_MAX_MAGIC_NUMBER_LEN + 1 bytes).
  integer(c_int) :: nc_def_user_format
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_def_user_format

function nc_inq_user_format(mode_flag, dispatch_table, magic_number) bind(c, name="nc_inq_user_format")
  !! Query the dispatch table and magic signature for a user-defined backend.
  !! Returned dispatch storage remains library/backend owned; do not free it.
  !! C declaration: int nc_inq_user_format(int mode_flag, NC_Dispatch **dispatch_table, char *magic_number);
  import :: c_int, c_ptr
  integer(c_int), value :: mode_flag
  !! NC_UDF* mode flag.
  type(c_ptr), intent(out) :: dispatch_table
  !! Returned C pointer; pass a c_ptr variable, not c_loc() of a pointer slot.
  type(c_ptr), value :: magic_number
  !! Magic signature buffer (NC_MAX_MAGIC_NUMBER_LEN + 1 bytes).
  integer(c_int) :: nc_inq_user_format
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_inq_user_format

function nc_set_alignment(threshold, alignment) bind(c, name="nc_set_alignment")
  !! Set global HDF5 allocation threshold and alignment.
  !! C declaration: int nc_set_alignment(int threshold, int alignment);
  import :: c_int
  integer(c_int), value :: threshold
  !! HDF5 allocation threshold in bytes.
  integer(c_int), value :: alignment
  !! HDF5 allocation alignment in bytes.
  integer(c_int) :: nc_set_alignment
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_set_alignment

function nc_get_alignment(thresholdp, alignmentp) bind(c, name="nc_get_alignment")
  !! Query global HDF5 allocation threshold and alignment.
  !! C declaration: int nc_get_alignment(int* thresholdp, int* alignmentp);
  import :: c_int
  integer(c_int), intent(out) :: thresholdp
  !! Returned thresholdp value (C int).
  integer(c_int), intent(out) :: alignmentp
  !! Returned alignmentp value (C int).
  integer(c_int) :: nc_get_alignment
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_get_alignment

function nc_set_meta_block_size(size) bind(c, name="nc_set_meta_block_size")
  !! Set the minimum HDF5 metadata allocation block size.
  !! C declaration: int nc_set_meta_block_size(size_t size);
  import :: c_int, c_size_t
  integer(c_size_t), value :: size
  !! Size in bytes.
  integer(c_int) :: nc_set_meta_block_size
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_set_meta_block_size

function nc_get_meta_block_size(sizep) bind(c, name="nc_get_meta_block_size")
  !! Query the minimum HDF5 metadata allocation block size.
  !! C declaration: int nc_get_meta_block_size(size_t* sizep);
  import :: c_int, c_size_t
  integer(c_size_t), intent(out) :: sizep
  !! Returned sizep value (C size_t).
  integer(c_int) :: nc_get_meta_block_size
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_get_meta_block_size

function nc__create(path, cmode, initialsz, chunksizehintp, ncidp) bind(c, name="nc__create")
  !! Create a dataset with initial-size and I/O-buffer hints.
  !! C declaration: int nc__create(const char *path, int cmode, size_t initialsz, size_t *chunksizehintp, int
  !! *ncidp);
  import :: c_int, c_char, c_size_t
  character(kind=c_char), intent(in) :: path(*)
  !! NUL-terminated C string.
  integer(c_int), value :: cmode
  !! Creation mode bit mask.
  integer(c_size_t), value :: initialsz
  !! Initial file allocation size in bytes.
  integer(c_size_t), intent(inout) :: chunksizehintp
  !! Input/output I/O buffer size hint in bytes.
  integer(c_int), intent(out) :: ncidp
  !! Returned ncidp value (C int).
  integer(c_int) :: nc__create
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc__create

function nc__open(path, mode, chunksizehintp, ncidp) bind(c, name="nc__open")
  !! Open a dataset with an I/O-buffer hint.
  !! C declaration: int nc__open(const char *path, int mode, size_t *chunksizehintp, int *ncidp);
  import :: c_int, c_char, c_size_t
  character(kind=c_char), intent(in) :: path(*)
  !! NUL-terminated C string.
  integer(c_int), value :: mode
  !! Open/create mode bit mask.
  integer(c_size_t), intent(inout) :: chunksizehintp
  !! Input/output I/O buffer size hint in bytes.
  integer(c_int), intent(out) :: ncidp
  !! Returned ncidp value (C int).
  integer(c_int) :: nc__open
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc__open

function nc_set_default_format(format, old_formatp) bind(c, name="nc_set_default_format")
  !! Set the process-wide default format used by subsequent creates.
  !! C declaration: int nc_set_default_format(int format, int *old_formatp);
  import :: c_int
  integer(c_int), value :: format
  !! C int argument format.
  integer(c_int), intent(out) :: old_formatp
  !! Returned old_formatp value (C int).
  integer(c_int) :: nc_set_default_format
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_set_default_format

function nc__enddef(ncid, h_minfree, v_align, v_minfree, r_align) bind(c, name="nc__enddef")
  !! Leave classic define mode with header-space and alignment controls.
  !! C declaration: int nc__enddef(int ncid, size_t h_minfree, size_t v_align, size_t v_minfree, size_t
  !! r_align);
  import :: c_int, c_size_t
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_size_t), value :: h_minfree
  !! Additional classic header space in bytes.
  integer(c_size_t), value :: v_align
  !! Fixed-variable alignment in bytes.
  integer(c_size_t), value :: v_minfree
  !! Extra space after fixed variables in bytes.
  integer(c_size_t), value :: r_align
  !! Record-variable alignment in bytes.
  integer(c_int) :: nc__enddef
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc__enddef

function nc_show_metadata(ncid) bind(c, name="nc_show_metadata")
  !! Print the library metadata for an open dataset.
  !! C declaration: int nc_show_metadata(int ncid);
  import :: c_int
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int) :: nc_show_metadata
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_show_metadata

function nc_delete(path) bind(c, name="nc_delete")
  !! Delete a dataset by its path.
  !! C declaration: int nc_delete(const char *path);
  import :: c_int, c_char
  character(kind=c_char), intent(in) :: path(*)
  !! NUL-terminated C string.
  integer(c_int) :: nc_delete
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_delete

function nccreate(path, cmode) bind(c, name="nccreate")
  !! Legacy v2 API: Create a classic dataset and return its ID.
  !! Uses v2 return/error conventions, not modern NC_NOERR status semantics.
  !! Legacy process-global ncopts controls fatal errors and diagnostics; no accessor is provided.
  !! C declaration: int nccreate(const char* path, int cmode);
  import :: c_int, c_char
  character(kind=c_char), intent(in) :: path(*)
  !! NUL-terminated C string.
  integer(c_int), value :: cmode
  !! Creation mode bit mask.
  integer(c_int) :: nccreate
  !! V2 result (ID, size, previous setting, or success value); -1 indicates failure.
end function nccreate

function ncopen(path, mode) bind(c, name="ncopen")
  !! Legacy v2 API: Open a dataset and return its ID.
  !! Uses v2 return/error conventions, not modern NC_NOERR status semantics.
  !! Legacy process-global ncopts controls fatal errors and diagnostics; no accessor is provided.
  !! C declaration: int ncopen(const char* path, int mode);
  import :: c_int, c_char
  character(kind=c_char), intent(in) :: path(*)
  !! NUL-terminated C string.
  integer(c_int), value :: mode
  !! Open/create mode bit mask.
  integer(c_int) :: ncopen
  !! V2 result (ID, size, previous setting, or success value); -1 indicates failure.
end function ncopen

function ncsetfill(ncid, fillmode) bind(c, name="ncsetfill")
  !! Legacy v2 API: Set the fill mode and return the previous mode.
  !! Uses v2 return/error conventions, not modern NC_NOERR status semantics.
  !! Legacy process-global ncopts controls fatal errors and diagnostics; no accessor is provided.
  !! C declaration: int ncsetfill(int ncid, int fillmode);
  import :: c_int
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: fillmode
  !! C int argument fillmode.
  integer(c_int) :: ncsetfill
  !! V2 result (ID, size, previous setting, or success value); -1 indicates failure.
end function ncsetfill

function ncredef(ncid) bind(c, name="ncredef")
  !! Legacy v2 API: Enter define mode.
  !! Uses v2 return/error conventions, not modern NC_NOERR status semantics.
  !! Legacy process-global ncopts controls fatal errors and diagnostics; no accessor is provided.
  !! C declaration: int ncredef(int ncid);
  import :: c_int
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int) :: ncredef
  !! V2 result (ID, size, previous setting, or success value); -1 indicates failure.
end function ncredef

function ncendef(ncid) bind(c, name="ncendef")
  !! Legacy v2 API: Leave define mode.
  !! Uses v2 return/error conventions, not modern NC_NOERR status semantics.
  !! Legacy process-global ncopts controls fatal errors and diagnostics; no accessor is provided.
  !! C declaration: int ncendef(int ncid);
  import :: c_int
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int) :: ncendef
  !! V2 result (ID, size, previous setting, or success value); -1 indicates failure.
end function ncendef

function ncsync(ncid) bind(c, name="ncsync")
  !! Legacy v2 API: Synchronize dataset contents.
  !! Uses v2 return/error conventions, not modern NC_NOERR status semantics.
  !! Legacy process-global ncopts controls fatal errors and diagnostics; no accessor is provided.
  !! C declaration: int ncsync(int ncid);
  import :: c_int
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int) :: ncsync
  !! V2 result (ID, size, previous setting, or success value); -1 indicates failure.
end function ncsync

function ncabort(ncid) bind(c, name="ncabort")
  !! Legacy v2 API: Abort an unfinished definition and close the dataset.
  !! Uses v2 return/error conventions, not modern NC_NOERR status semantics.
  !! Legacy process-global ncopts controls fatal errors and diagnostics; no accessor is provided.
  !! C declaration: int ncabort(int ncid);
  import :: c_int
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int) :: ncabort
  !! V2 result (ID, size, previous setting, or success value); -1 indicates failure.
end function ncabort

function ncclose(ncid) bind(c, name="ncclose")
  !! Legacy v2 API: Close a dataset.
  !! Uses v2 return/error conventions, not modern NC_NOERR status semantics.
  !! Legacy process-global ncopts controls fatal errors and diagnostics; no accessor is provided.
  !! C declaration: int ncclose(int ncid);
  import :: c_int
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int) :: ncclose
  !! V2 result (ID, size, previous setting, or success value); -1 indicates failure.
end function ncclose

function ncinquire(ncid, ndimsp, nvarsp, nattsp, unlimdimp) bind(c, name="ncinquire")
  !! Legacy v2 API: Query dataset counts and its unlimited dimension.
  !! Uses v2 return/error conventions, not modern NC_NOERR status semantics.
  !! Legacy process-global ncopts controls fatal errors and diagnostics; no accessor is provided.
  !! C declaration: int ncinquire(int ncid, int *ndimsp, int *nvarsp, int *nattsp, int *unlimdimp);
  import :: c_int
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), intent(out) :: ndimsp
  !! Returned ndimsp value (C int).
  integer(c_int), intent(out) :: nvarsp
  !! Returned nvarsp value (C int).
  integer(c_int), intent(out) :: nattsp
  !! Returned nattsp value (C int).
  integer(c_int), intent(out) :: unlimdimp
  !! Returned unlimdimp value (C int).
  integer(c_int) :: ncinquire
  !! V2 result (ID, size, previous setting, or success value); -1 indicates failure.
end function ncinquire

function nc_initialize() bind(c, name="nc_initialize")
  !! Explicitly initialize process-wide NetCDF library state.
  !! Normally initialization is automatic.
  !! C declaration: int nc_initialize(void);
  import :: c_int
  integer(c_int) :: nc_initialize
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_initialize

function nc_finalize() bind(c, name="nc_finalize")
  !! Finalize process-wide NetCDF state after all datasets have been closed.
  !! Do not call while any dataset or backend-dependent resource remains in use.
  !! C declaration: int nc_finalize(void);
  import :: c_int
  integer(c_int) :: nc_finalize
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_finalize

function nc_rc_get(key) bind(c, name="nc_rc_get")
  !! Look up a value in the NetCDF runtime configuration table.
  !! Returns c_null_ptr if absent; otherwise the caller must release the result with c_free().
  !! C declaration: char* nc_rc_get(const char* key);
  import :: c_ptr, c_char
  character(kind=c_char), intent(in) :: key(*)
  !! NUL-terminated C string.
  type(c_ptr) :: nc_rc_get
  !! Returned C pointer, or c_null_ptr; ownership is described above.
end function nc_rc_get

function nc_rc_set(key, value) bind(c, name="nc_rc_set")
  !! Set a value in the NetCDF runtime configuration table.
  !! C declaration: int nc_rc_set(const char* key, const char* value);
  import :: c_int, c_char
  character(kind=c_char), intent(in) :: key(*)
  !! NUL-terminated C string.
  character(kind=c_char), intent(in) :: value(*)
  !! NUL-terminated C string.
  integer(c_int) :: nc_rc_set
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_rc_set

function nc_open_mem(path, mode, size, memory, ncidp) bind(c, name="nc_open_mem")
  !! Open a caller-owned memory image as a read-only dataset.
  !! Keep the input image alive until the dataset is closed; NetCDF does not own it.
  !! C declaration: int nc_open_mem(const char* path, int mode, size_t size, void* memory, int* ncidp);
  import :: c_int, c_char, c_size_t, c_ptr
  character(kind=c_char), intent(in) :: path(*)
  !! NUL-terminated C string.
  integer(c_int), value :: mode
  !! Open/create mode bit mask.
  integer(c_size_t), value :: size
  !! Size in bytes.
  type(c_ptr), value :: memory
  !! Top-level memory buffer. C pointee: void*.
  integer(c_int), intent(out) :: ncidp
  !! Returned ncidp value (C int).
  integer(c_int) :: nc_open_mem
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_open_mem

function nc_create_mem(path, mode, initialsize, ncidp) bind(c, name="nc_create_mem")
  !! Create a dataset backed by a growable memory image.
  !! C declaration: int nc_create_mem(const char* path, int mode, size_t initialsize, int* ncidp);
  import :: c_int, c_char, c_size_t
  character(kind=c_char), intent(in) :: path(*)
  !! NUL-terminated C string.
  integer(c_int), value :: mode
  !! Open/create mode bit mask.
  integer(c_size_t), value :: initialsize
  !! Initial memory image size in bytes.
  integer(c_int), intent(out) :: ncidp
  !! Returned ncidp value (C int).
  integer(c_int) :: nc_create_mem
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_create_mem

function nc_open_memio(path, mode, info, ncidp) bind(c, name="nc_open_memio")
  !! Open a memory image with explicit allocation and ownership flags.
  !! With NC_MEMIO_LOCKED, the caller retains the fixed buffer until close.
  !! Without it, supply C-allocated storage that NetCDF may resize or free.
  !! C declaration: int nc_open_memio(const char* path, int mode, NC_memio* info, int* ncidp);
  import :: c_int, c_char, c_ptr
  character(kind=c_char), intent(in) :: path(*)
  !! NUL-terminated C string.
  integer(c_int), value :: mode
  !! Open/create mode bit mask.
  type(c_ptr), value :: info
  !! Address of an NC_memio structure. C pointee: NC_memio*.
  integer(c_int), intent(out) :: ncidp
  !! Returned ncidp value (C int).
  integer(c_int) :: nc_open_memio
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_open_memio

function nc_close_memio(ncid, info) bind(c, name="nc_close_memio")
  !! Close a memory dataset and return its final memory image.
  !! Free a returned unlocked memory image with c_free(); never free a locked Fortran buffer.
  !! C declaration: int nc_close_memio(int ncid, NC_memio* info);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  type(c_ptr), value :: info
  !! Address of an NC_memio structure. C pointee: NC_memio*.
  integer(c_int) :: nc_close_memio
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_close_memio

function nc_plugin_path_ndirs(ndirsp) bind(c, name="nc_plugin_path_ndirs")
  !! Query the number of plugin search directories.
  !! C declaration: int nc_plugin_path_ndirs(size_t* ndirsp);
  import :: c_int, c_size_t
  integer(c_size_t), intent(out) :: ndirsp
  !! Returned ndirsp value (C size_t).
  integer(c_int) :: nc_plugin_path_ndirs
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_plugin_path_ndirs

function nc_plugin_path_get(dirs) bind(c, name="nc_plugin_path_get")
  !! Copy the current plugin search path into an NCPluginList.
  !! Initialize dirs%dirs to c_null_ptr to request allocation.
  !! Release copied paths with ncaux_plugin_path_clear() for a Fortran-owned structure.
  !! C declaration: int nc_plugin_path_get(NCPluginList* dirs);
  import :: c_int, c_ptr
  type(c_ptr), value :: dirs
  !! Address of an NCPluginList structure. C pointee: NCPluginList*.
  integer(c_int) :: nc_plugin_path_get
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_plugin_path_get

function nc_plugin_path_set(dirs) bind(c, name="nc_plugin_path_set")
  !! Replace the process-wide plugin search path from an NCPluginList.
  !! C declaration: int nc_plugin_path_set(NCPluginList* dirs);
  import :: c_int, c_ptr
  type(c_ptr), value :: dirs
  !! Address of an NCPluginList structure. C pointee: NCPluginList*.
  integer(c_int) :: nc_plugin_path_set
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function nc_plugin_path_set

function ncaux_plugin_path_parsen(pathlen, pathlist, sep, dirs) bind(c, name="ncaux_plugin_path_parsen")
  !! Parse a counted plugin search path into an NCPluginList.
  !! C declaration: int ncaux_plugin_path_parsen(size_t pathlen, const char* pathlist, char sep, struct
  !! NCPluginList* dirs);
  import :: c_int, c_size_t, c_char, c_ptr
  integer(c_size_t), value :: pathlen
  !! C size_t argument pathlen.
  character(kind=c_char), intent(in) :: pathlist(*)
  !! NUL-terminated C string.
  character(kind=c_char), value :: sep
  !! Single separator byte; NUL selects the platform default.
  type(c_ptr), value :: dirs
  !! Address of an NCPluginList structure. C pointee: struct NCPluginList*.
  integer(c_int) :: ncaux_plugin_path_parsen
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function ncaux_plugin_path_parsen

function ncaux_plugin_path_parse(pathlist, sep, dirs) bind(c, name="ncaux_plugin_path_parse")
  !! Parse a NUL-terminated plugin search path into an NCPluginList.
  !! C declaration: int ncaux_plugin_path_parse(const char* pathlist, char sep, struct NCPluginList* dirs);
  import :: c_int, c_char, c_ptr
  character(kind=c_char), intent(in) :: pathlist(*)
  !! NUL-terminated C string.
  character(kind=c_char), value :: sep
  !! Single separator byte; NUL selects the platform default.
  type(c_ptr), value :: dirs
  !! Address of an NCPluginList structure. C pointee: struct NCPluginList*.
  integer(c_int) :: ncaux_plugin_path_parse
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function ncaux_plugin_path_parse

function ncaux_plugin_path_tostring(dirs, sep, catp) bind(c, name="ncaux_plugin_path_tostring")
  !! Join a plugin directory list into an allocated C string.
  !! Release the returned string with c_free().
  !! C declaration: int ncaux_plugin_path_tostring(const struct NCPluginList* dirs, char sep, char** catp);
  import :: c_int, c_ptr, c_char
  type(c_ptr), value :: dirs
  !! Address of an NCPluginList structure. C pointee: const struct NCPluginList*.
  character(kind=c_char), value :: sep
  !! Single separator byte; NUL selects the platform default.
  type(c_ptr), intent(out) :: catp
  !! Returned C pointer; pass a c_ptr variable, not c_loc() of a pointer slot.
  integer(c_int) :: ncaux_plugin_path_tostring
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function ncaux_plugin_path_tostring

function ncaux_plugin_path_clear(dirs) bind(c, name="ncaux_plugin_path_clear")
  !! Free a plugin list contents while retaining the list structure.
  !! C declaration: int ncaux_plugin_path_clear(struct NCPluginList* dirs);
  import :: c_int, c_ptr
  type(c_ptr), value :: dirs
  !! Address of an NCPluginList structure. C pointee: struct NCPluginList*.
  integer(c_int) :: ncaux_plugin_path_clear
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function ncaux_plugin_path_clear

function ncaux_plugin_path_reclaim(dirs) bind(c, name="ncaux_plugin_path_reclaim")
  !! Free a C-allocated plugin list structure and its contents.
  !! Use only for a C-allocated structure; use ncaux_plugin_path_clear() for Fortran-owned structures.
  !! C declaration: int ncaux_plugin_path_reclaim(struct NCPluginList* dirs);
  import :: c_int, c_ptr
  type(c_ptr), value :: dirs
  !! Address of an NCPluginList structure. C pointee: struct NCPluginList*.
  integer(c_int) :: ncaux_plugin_path_reclaim
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function ncaux_plugin_path_reclaim

function ncaux_plugin_path_append(dirs, dir) bind(c, name="ncaux_plugin_path_append")
  !! Append a directory to a plugin list.
  !! C declaration: int ncaux_plugin_path_append(struct NCPluginList* dirs, const char* dir);
  import :: c_int, c_ptr, c_char
  type(c_ptr), value :: dirs
  !! Address of an NCPluginList structure. C pointee: struct NCPluginList*.
  character(kind=c_char), intent(in) :: dir(*)
  !! NUL-terminated C string.
  integer(c_int) :: ncaux_plugin_path_append
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function ncaux_plugin_path_append

function ncaux_plugin_path_prepend(dirs, dir) bind(c, name="ncaux_plugin_path_prepend")
  !! Prepend a directory to a plugin list.
  !! C declaration: int ncaux_plugin_path_prepend(struct NCPluginList* dirs, const char* dir);
  import :: c_int, c_ptr, c_char
  type(c_ptr), value :: dirs
  !! Address of an NCPluginList structure. C pointee: struct NCPluginList*.
  character(kind=c_char), intent(in) :: dir(*)
  !! NUL-terminated C string.
  integer(c_int) :: ncaux_plugin_path_prepend
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function ncaux_plugin_path_prepend

function ncaux_plugin_path_stringlen() bind(c, name="ncaux_plugin_path_stringlen")
  !! Return the encoded length of the current plugin search path.
  !! C declaration: int ncaux_plugin_path_stringlen(void);
  import :: c_int
  integer(c_int) :: ncaux_plugin_path_stringlen
  !! Encoded path length, or a negative error result.
end function ncaux_plugin_path_stringlen

function ncaux_plugin_path_stringget(pathlen, path) bind(c, name="ncaux_plugin_path_stringget")
  !! Return the current plugin search path as a semicolon-separated string.
  !! C declaration: int ncaux_plugin_path_stringget(int pathlen, char* path);
  import :: c_int, c_ptr
  integer(c_int), value :: pathlen
  !! C int argument pathlen.
  type(c_ptr), value :: path
  !! Pointer to caller-provided C character output storage (NC_MAX_NAME + 1 for names).
  integer(c_int) :: ncaux_plugin_path_stringget
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function ncaux_plugin_path_stringget

function ncaux_plugin_path_stringset(pathlen, path) bind(c, name="ncaux_plugin_path_stringset")
  !! Replace the plugin search path from a semicolon-separated string.
  !! C declaration: int ncaux_plugin_path_stringset(int pathlen, const char* path);
  import :: c_int, c_char
  integer(c_int), value :: pathlen
  !! C int argument pathlen.
  character(kind=c_char), intent(in) :: path(*)
  !! NUL-terminated C string.
  integer(c_int) :: ncaux_plugin_path_stringset
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function ncaux_plugin_path_stringset

function ncaux_parse_provenance(ncprop, pairsp) bind(c, name="ncaux_parse_provenance")
  !! Parse _NCProperties into an allocated NULL-terminated key/value vector.
  !! Free each returned string with c_free(), then free the pointer vector.
  !! C declaration: int ncaux_parse_provenance(const char* ncprop, char*** pairsp);
  import :: c_int, c_char, c_ptr
  character(kind=c_char), intent(in) :: ncprop(*)
  !! NUL-terminated C string.
  type(c_ptr), intent(out) :: pairsp
  !! Returned C pointer; pass a c_ptr variable, not c_loc() of a pointer slot.
  integer(c_int) :: ncaux_parse_provenance
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function ncaux_parse_provenance

function NC_RO_create(path, cmode, initialsz, basepe, chunksizehintp, parameters, arg7, arg8) &
  & bind(c, name="NC_RO_create")
  !! Backend dispatch helper: reject a write to a read-only backend.
  !! Intended for custom backend implementers; arguments retain the C dispatch-table ABI.
  !! C declaration: int NC_RO_create(const char *path, int cmode, size_t initialsz, int basepe, size_t
  !! *chunksizehintp, void* parameters, const NC_Dispatch*, int);
  import :: c_int, c_char, c_size_t, c_ptr
  character(kind=c_char), intent(in) :: path(*)
  !! NUL-terminated C string.
  integer(c_int), value :: cmode
  !! Creation mode bit mask.
  integer(c_size_t), value :: initialsz
  !! Initial file allocation size in bytes.
  integer(c_int), value :: basepe
  !! C int argument basepe.
  integer(c_size_t), intent(inout) :: chunksizehintp
  !! Input/output I/O buffer size hint in bytes.
  type(c_ptr), value :: parameters
  !! Pointer to C-compatible storage. C pointee: void*.
  type(c_ptr), value :: arg7
  !! Pointer to C-compatible storage. C pointee: const NC_Dispatch*.
  integer(c_int), value :: arg8
  !! C int argument arg8.
  integer(c_int) :: NC_RO_create
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function NC_RO_create

function NC_RO_redef(ncid) bind(c, name="NC_RO_redef")
  !! Backend dispatch helper: reject a write to a read-only backend.
  !! Intended for custom backend implementers; arguments retain the C dispatch-table ABI.
  !! C declaration: int NC_RO_redef(int ncid);
  import :: c_int
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int) :: NC_RO_redef
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function NC_RO_redef

function NC_RO__enddef(ncid, h_minfree, v_align, v_minfree, r_align) bind(c, name="NC_RO__enddef")
  !! Backend dispatch helper: reject a write to a read-only backend.
  !! Intended for custom backend implementers; arguments retain the C dispatch-table ABI.
  !! C declaration: int NC_RO__enddef(int ncid, size_t h_minfree, size_t v_align, size_t v_minfree, size_t
  !! r_align);
  import :: c_int, c_size_t
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_size_t), value :: h_minfree
  !! Additional classic header space in bytes.
  integer(c_size_t), value :: v_align
  !! Fixed-variable alignment in bytes.
  integer(c_size_t), value :: v_minfree
  !! Extra space after fixed variables in bytes.
  integer(c_size_t), value :: r_align
  !! Record-variable alignment in bytes.
  integer(c_int) :: NC_RO__enddef
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function NC_RO__enddef

function NC_RO_sync(ncid) bind(c, name="NC_RO_sync")
  !! Backend dispatch helper: reject a write to a read-only backend.
  !! Intended for custom backend implementers; arguments retain the C dispatch-table ABI.
  !! C declaration: int NC_RO_sync(int ncid);
  import :: c_int
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int) :: NC_RO_sync
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function NC_RO_sync

function NC_RO_def_var_fill(arg1, arg2, arg3, arg4) bind(c, name="NC_RO_def_var_fill")
  !! Backend dispatch helper: reject a write to a read-only backend.
  !! Intended for custom backend implementers; arguments retain the C dispatch-table ABI.
  !! C declaration: int NC_RO_def_var_fill(int, int, int, const void *);
  import :: c_int, c_ptr
  integer(c_int), value :: arg1
  !! C int argument arg1.
  integer(c_int), value :: arg2
  !! C int argument arg2.
  integer(c_int), value :: arg3
  !! C int argument arg3.
  type(c_ptr), value :: arg4
  !! Pointer to C-compatible storage. C pointee: const void *.
  integer(c_int) :: NC_RO_def_var_fill
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function NC_RO_def_var_fill

function NC_RO_rename_att(ncid, varid, name, newname) bind(c, name="NC_RO_rename_att")
  !! Backend dispatch helper: reject a write to a read-only backend.
  !! Intended for custom backend implementers; arguments retain the C dispatch-table ABI.
  !! C declaration: int NC_RO_rename_att(int ncid, int varid, const char *name, const char *newname);
  import :: c_int, c_char
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated C string.
  character(kind=c_char), intent(in) :: newname(*)
  !! NUL-terminated C string.
  integer(c_int) :: NC_RO_rename_att
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function NC_RO_rename_att

function NC_RO_del_att(ncid, varid, arg3) bind(c, name="NC_RO_del_att")
  !! Backend dispatch helper: reject a write to a read-only backend.
  !! Intended for custom backend implementers; arguments retain the C dispatch-table ABI.
  !! C declaration: int NC_RO_del_att(int ncid, int varid, const char*);
  import :: c_int, c_char
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  character(kind=c_char), intent(in) :: arg3(*)
  !! NUL-terminated C string.
  integer(c_int) :: NC_RO_del_att
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function NC_RO_del_att

function NC_RO_put_att(ncid, varid, name, datatype, len, value, arg7) bind(c, name="NC_RO_put_att")
  !! Backend dispatch helper: reject a write to a read-only backend.
  !! Intended for custom backend implementers; arguments retain the C dispatch-table ABI.
  !! C declaration: int NC_RO_put_att(int ncid, int varid, const char *name, nc_type datatype, size_t len,
  !! const void *value, nc_type);
  import :: c_int, c_char, c_size_t, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated C string.
  integer(c_int), value :: datatype
  !! C nc_type argument datatype.
  integer(c_size_t), value :: len
  !! Element count (not bytes except for byte/text types).
  type(c_ptr), value :: value
  !! Pointer to C-compatible storage. C pointee: const void *.
  integer(c_int), value :: arg7
  !! C nc_type argument arg7.
  integer(c_int) :: NC_RO_put_att
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function NC_RO_put_att

function NC_RO_def_var(ncid, name, xtype, ndims, dimidsp, varidp) bind(c, name="NC_RO_def_var")
  !! Backend dispatch helper: reject a write to a read-only backend.
  !! Intended for custom backend implementers; arguments retain the C dispatch-table ABI.
  !! C declaration: int NC_RO_def_var(int ncid, const char *name, nc_type xtype, int ndims, const int
  !! *dimidsp, int *varidp);
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
  type(c_ptr), value :: varidp
  !! Pointer to C-compatible storage. C pointee: int *.
  integer(c_int) :: NC_RO_def_var
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function NC_RO_def_var

function NC_RO_rename_var(ncid, varid, name) bind(c, name="NC_RO_rename_var")
  !! Backend dispatch helper: reject a write to a read-only backend.
  !! Intended for custom backend implementers; arguments retain the C dispatch-table ABI.
  !! C declaration: int NC_RO_rename_var(int ncid, int varid, const char *name);
  import :: c_int, c_char
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated C string.
  integer(c_int) :: NC_RO_rename_var
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function NC_RO_rename_var

function NC_RO_put_vara(ncid, varid, start, count, value, arg6) bind(c, name="NC_RO_put_vara")
  !! Backend dispatch helper: reject a write to a read-only backend.
  !! Intended for custom backend implementers; arguments retain the C dispatch-table ABI.
  !! C declaration: int NC_RO_put_vara(int ncid, int varid, const size_t *start, const size_t *count, const
  !! void *value, nc_type);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: start
  !! Pointer to C-compatible storage. C pointee: const size_t *.
  type(c_ptr), value :: count
  !! Number of typed instances. C pointee: const size_t *.
  type(c_ptr), value :: value
  !! Pointer to C-compatible storage. C pointee: const void *.
  integer(c_int), value :: arg6
  !! C nc_type argument arg6.
  integer(c_int) :: NC_RO_put_vara
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function NC_RO_put_vara

function NC_RO_def_dim(ncid, name, len, idp) bind(c, name="NC_RO_def_dim")
  !! Backend dispatch helper: reject a write to a read-only backend.
  !! Intended for custom backend implementers; arguments retain the C dispatch-table ABI.
  !! C declaration: int NC_RO_def_dim(int ncid, const char *name, size_t len, int *idp);
  import :: c_int, c_char, c_size_t, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated C string.
  integer(c_size_t), value :: len
  !! Element count (not bytes except for byte/text types).
  type(c_ptr), value :: idp
  !! Pointer to C-compatible storage. C pointee: int *.
  integer(c_int) :: NC_RO_def_dim
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function NC_RO_def_dim

function NC_RO_rename_dim(ncid, dimid, name) bind(c, name="NC_RO_rename_dim")
  !! Backend dispatch helper: reject a write to a read-only backend.
  !! Intended for custom backend implementers; arguments retain the C dispatch-table ABI.
  !! C declaration: int NC_RO_rename_dim(int ncid, int dimid, const char *name);
  import :: c_int, c_char
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: dimid
  !! Dimension identifier.
  character(kind=c_char), intent(in) :: name(*)
  !! NUL-terminated C string.
  integer(c_int) :: NC_RO_rename_dim
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function NC_RO_rename_dim

function NC_RO_set_fill(ncid, fillmode, old_modep) bind(c, name="NC_RO_set_fill")
  !! Backend dispatch helper: reject a write to a read-only backend.
  !! Intended for custom backend implementers; arguments retain the C dispatch-table ABI.
  !! C declaration: int NC_RO_set_fill(int ncid, int fillmode, int *old_modep);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: fillmode
  !! C int argument fillmode.
  type(c_ptr), value :: old_modep
  !! Pointer to C-compatible storage. C pointee: int *.
  integer(c_int) :: NC_RO_set_fill
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function NC_RO_set_fill

function NC_NOTNC4_def_grp(arg1, arg2, arg3) bind(c, name="NC_NOTNC4_def_grp")
  !! Backend dispatch helper: report an unsupported enhanced-model operation.
  !! Intended for custom backend implementers; arguments retain the C dispatch-table ABI.
  !! C declaration: int NC_NOTNC4_def_grp(int, const char *, int *);
  import :: c_int, c_char, c_ptr
  integer(c_int), value :: arg1
  !! C int argument arg1.
  character(kind=c_char), intent(in) :: arg2(*)
  !! NUL-terminated C string.
  type(c_ptr), value :: arg3
  !! Pointer to C-compatible storage. C pointee: int *.
  integer(c_int) :: NC_NOTNC4_def_grp
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function NC_NOTNC4_def_grp

function NC_NOTNC4_rename_grp(arg1, arg2) bind(c, name="NC_NOTNC4_rename_grp")
  !! Backend dispatch helper: report an unsupported enhanced-model operation.
  !! Intended for custom backend implementers; arguments retain the C dispatch-table ABI.
  !! C declaration: int NC_NOTNC4_rename_grp(int, const char *);
  import :: c_int, c_char
  integer(c_int), value :: arg1
  !! C int argument arg1.
  character(kind=c_char), intent(in) :: arg2(*)
  !! NUL-terminated C string.
  integer(c_int) :: NC_NOTNC4_rename_grp
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function NC_NOTNC4_rename_grp

function NC_NOTNC4_def_compound(arg1, arg2, arg3, arg4) bind(c, name="NC_NOTNC4_def_compound")
  !! Backend dispatch helper: report an unsupported enhanced-model operation.
  !! Intended for custom backend implementers; arguments retain the C dispatch-table ABI.
  !! C declaration: int NC_NOTNC4_def_compound(int, size_t, const char *, nc_type *);
  import :: c_int, c_size_t, c_char, c_ptr
  integer(c_int), value :: arg1
  !! C int argument arg1.
  integer(c_size_t), value :: arg2
  !! C size_t argument arg2.
  character(kind=c_char), intent(in) :: arg3(*)
  !! NUL-terminated C string.
  type(c_ptr), value :: arg4
  !! Pointer to C-compatible storage. C pointee: nc_type *.
  integer(c_int) :: NC_NOTNC4_def_compound
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function NC_NOTNC4_def_compound

function NC_NOTNC4_insert_compound(arg1, arg2, arg3, arg4, arg5) bind(c, name="NC_NOTNC4_insert_compound")
  !! Backend dispatch helper: report an unsupported enhanced-model operation.
  !! Intended for custom backend implementers; arguments retain the C dispatch-table ABI.
  !! C declaration: int NC_NOTNC4_insert_compound(int, nc_type, const char *, size_t, nc_type);
  import :: c_int, c_char, c_size_t
  integer(c_int), value :: arg1
  !! C int argument arg1.
  integer(c_int), value :: arg2
  !! C nc_type argument arg2.
  character(kind=c_char), intent(in) :: arg3(*)
  !! NUL-terminated C string.
  integer(c_size_t), value :: arg4
  !! C size_t argument arg4.
  integer(c_int), value :: arg5
  !! C nc_type argument arg5.
  integer(c_int) :: NC_NOTNC4_insert_compound
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function NC_NOTNC4_insert_compound

function NC_NOTNC4_insert_array_compound(arg1, arg2, arg3, arg4, arg5, arg6, arg7) &
  & bind(c, name="NC_NOTNC4_insert_array_compound")
  !! Backend dispatch helper: report an unsupported enhanced-model operation.
  !! Intended for custom backend implementers; arguments retain the C dispatch-table ABI.
  !! C declaration: int NC_NOTNC4_insert_array_compound(int, nc_type, const char *, size_t, nc_type, int,
  !! const int *);
  import :: c_int, c_char, c_size_t, c_ptr
  integer(c_int), value :: arg1
  !! C int argument arg1.
  integer(c_int), value :: arg2
  !! C nc_type argument arg2.
  character(kind=c_char), intent(in) :: arg3(*)
  !! NUL-terminated C string.
  integer(c_size_t), value :: arg4
  !! C size_t argument arg4.
  integer(c_int), value :: arg5
  !! C nc_type argument arg5.
  integer(c_int), value :: arg6
  !! C int argument arg6.
  type(c_ptr), value :: arg7
  !! Pointer to C-compatible storage. C pointee: const int *.
  integer(c_int) :: NC_NOTNC4_insert_array_compound
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function NC_NOTNC4_insert_array_compound

function NC_NOTNC4_inq_typeid(arg1, arg2, arg3) bind(c, name="NC_NOTNC4_inq_typeid")
  !! Backend dispatch helper: report an unsupported enhanced-model operation.
  !! Intended for custom backend implementers; arguments retain the C dispatch-table ABI.
  !! C declaration: int NC_NOTNC4_inq_typeid(int, const char *, nc_type *);
  import :: c_int, c_char, c_ptr
  integer(c_int), value :: arg1
  !! C int argument arg1.
  character(kind=c_char), intent(in) :: arg2(*)
  !! NUL-terminated C string.
  type(c_ptr), value :: arg3
  !! Pointer to C-compatible storage. C pointee: nc_type *.
  integer(c_int) :: NC_NOTNC4_inq_typeid
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function NC_NOTNC4_inq_typeid

function NC_NOTNC4_inq_compound_field(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8) &
  & bind(c, name="NC_NOTNC4_inq_compound_field")
  !! Backend dispatch helper: report an unsupported enhanced-model operation.
  !! Intended for custom backend implementers; arguments retain the C dispatch-table ABI.
  !! C declaration: int NC_NOTNC4_inq_compound_field(int, nc_type, int, char *, size_t *, nc_type *, int *,
  !! int *);
  import :: c_int, c_ptr
  integer(c_int), value :: arg1
  !! C int argument arg1.
  integer(c_int), value :: arg2
  !! C nc_type argument arg2.
  integer(c_int), value :: arg3
  !! C int argument arg3.
  type(c_ptr), value :: arg4
  !! Pointer to caller-provided C character output storage (NC_MAX_NAME + 1 for names).
  type(c_ptr), value :: arg5
  !! Pointer to C-compatible storage. C pointee: size_t *.
  type(c_ptr), value :: arg6
  !! Pointer to C-compatible storage. C pointee: nc_type *.
  type(c_ptr), value :: arg7
  !! Pointer to C-compatible storage. C pointee: int *.
  type(c_ptr), value :: arg8
  !! Pointer to C-compatible storage. C pointee: int *.
  integer(c_int) :: NC_NOTNC4_inq_compound_field
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function NC_NOTNC4_inq_compound_field

function NC_NOTNC4_inq_compound_fieldindex(arg1, arg2, arg3, arg4) &
  & bind(c, name="NC_NOTNC4_inq_compound_fieldindex")
  !! Backend dispatch helper: report an unsupported enhanced-model operation.
  !! Intended for custom backend implementers; arguments retain the C dispatch-table ABI.
  !! C declaration: int NC_NOTNC4_inq_compound_fieldindex(int, nc_type, const char *, int *);
  import :: c_int, c_char, c_ptr
  integer(c_int), value :: arg1
  !! C int argument arg1.
  integer(c_int), value :: arg2
  !! C nc_type argument arg2.
  character(kind=c_char), intent(in) :: arg3(*)
  !! NUL-terminated C string.
  type(c_ptr), value :: arg4
  !! Pointer to C-compatible storage. C pointee: int *.
  integer(c_int) :: NC_NOTNC4_inq_compound_fieldindex
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function NC_NOTNC4_inq_compound_fieldindex

function NC_NOTNC4_def_vlen(arg1, arg2, base_typeid, arg4) bind(c, name="NC_NOTNC4_def_vlen")
  !! Backend dispatch helper: report an unsupported enhanced-model operation.
  !! Intended for custom backend implementers; arguments retain the C dispatch-table ABI.
  !! C declaration: int NC_NOTNC4_def_vlen(int, const char *, nc_type base_typeid, nc_type *);
  import :: c_int, c_char, c_ptr
  integer(c_int), value :: arg1
  !! C int argument arg1.
  character(kind=c_char), intent(in) :: arg2(*)
  !! NUL-terminated C string.
  integer(c_int), value :: base_typeid
  !! Base NetCDF type identifier.
  type(c_ptr), value :: arg4
  !! Pointer to C-compatible storage. C pointee: nc_type *.
  integer(c_int) :: NC_NOTNC4_def_vlen
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function NC_NOTNC4_def_vlen

function NC_NOTNC4_put_vlen_element(arg1, arg2, arg3, arg4, arg5) bind(c, name="NC_NOTNC4_put_vlen_element")
  !! Backend dispatch helper: report an unsupported enhanced-model operation.
  !! Intended for custom backend implementers; arguments retain the C dispatch-table ABI.
  !! C declaration: int NC_NOTNC4_put_vlen_element(int, int, void *, size_t, const void *);
  import :: c_int, c_ptr, c_size_t
  integer(c_int), value :: arg1
  !! C int argument arg1.
  integer(c_int), value :: arg2
  !! C int argument arg2.
  type(c_ptr), value :: arg3
  !! Pointer to C-compatible storage. C pointee: void *.
  integer(c_size_t), value :: arg4
  !! C size_t argument arg4.
  type(c_ptr), value :: arg5
  !! Pointer to C-compatible storage. C pointee: const void *.
  integer(c_int) :: NC_NOTNC4_put_vlen_element
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function NC_NOTNC4_put_vlen_element

function NC_NOTNC4_get_vlen_element(arg1, arg2, arg3, arg4, arg5) bind(c, name="NC_NOTNC4_get_vlen_element")
  !! Backend dispatch helper: report an unsupported enhanced-model operation.
  !! Intended for custom backend implementers; arguments retain the C dispatch-table ABI.
  !! C declaration: int NC_NOTNC4_get_vlen_element(int, int, const void *, size_t *, void *);
  import :: c_int, c_ptr
  integer(c_int), value :: arg1
  !! C int argument arg1.
  integer(c_int), value :: arg2
  !! C int argument arg2.
  type(c_ptr), value :: arg3
  !! Pointer to C-compatible storage. C pointee: const void *.
  type(c_ptr), value :: arg4
  !! Pointer to C-compatible storage. C pointee: size_t *.
  type(c_ptr), value :: arg5
  !! Pointer to C-compatible storage. C pointee: void *.
  integer(c_int) :: NC_NOTNC4_get_vlen_element
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function NC_NOTNC4_get_vlen_element

function NC_NOTNC4_def_enum(arg1, arg2, arg3, arg4) bind(c, name="NC_NOTNC4_def_enum")
  !! Backend dispatch helper: report an unsupported enhanced-model operation.
  !! Intended for custom backend implementers; arguments retain the C dispatch-table ABI.
  !! C declaration: int NC_NOTNC4_def_enum(int, nc_type, const char *, nc_type *);
  import :: c_int, c_char, c_ptr
  integer(c_int), value :: arg1
  !! C int argument arg1.
  integer(c_int), value :: arg2
  !! C nc_type argument arg2.
  character(kind=c_char), intent(in) :: arg3(*)
  !! NUL-terminated C string.
  type(c_ptr), value :: arg4
  !! Pointer to C-compatible storage. C pointee: nc_type *.
  integer(c_int) :: NC_NOTNC4_def_enum
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function NC_NOTNC4_def_enum

function NC_NOTNC4_insert_enum(arg1, arg2, arg3, arg4) bind(c, name="NC_NOTNC4_insert_enum")
  !! Backend dispatch helper: report an unsupported enhanced-model operation.
  !! Intended for custom backend implementers; arguments retain the C dispatch-table ABI.
  !! C declaration: int NC_NOTNC4_insert_enum(int, nc_type, const char *, const void *);
  import :: c_int, c_char, c_ptr
  integer(c_int), value :: arg1
  !! C int argument arg1.
  integer(c_int), value :: arg2
  !! C nc_type argument arg2.
  character(kind=c_char), intent(in) :: arg3(*)
  !! NUL-terminated C string.
  type(c_ptr), value :: arg4
  !! Pointer to C-compatible storage. C pointee: const void *.
  integer(c_int) :: NC_NOTNC4_insert_enum
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function NC_NOTNC4_insert_enum

function NC_NOTNC4_inq_enum_member(arg1, arg2, arg3, arg4, arg5) bind(c, name="NC_NOTNC4_inq_enum_member")
  !! Backend dispatch helper: report an unsupported enhanced-model operation.
  !! Intended for custom backend implementers; arguments retain the C dispatch-table ABI.
  !! C declaration: int NC_NOTNC4_inq_enum_member(int, nc_type, int, char *, void *);
  import :: c_int, c_ptr
  integer(c_int), value :: arg1
  !! C int argument arg1.
  integer(c_int), value :: arg2
  !! C nc_type argument arg2.
  integer(c_int), value :: arg3
  !! C int argument arg3.
  type(c_ptr), value :: arg4
  !! Pointer to caller-provided C character output storage (NC_MAX_NAME + 1 for names).
  type(c_ptr), value :: arg5
  !! Pointer to C-compatible storage. C pointee: void *.
  integer(c_int) :: NC_NOTNC4_inq_enum_member
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function NC_NOTNC4_inq_enum_member

function NC_NOTNC4_inq_enum_ident(arg1, arg2, arg3, arg4) bind(c, name="NC_NOTNC4_inq_enum_ident")
  !! Backend dispatch helper: report an unsupported enhanced-model operation.
  !! Intended for custom backend implementers; arguments retain the C dispatch-table ABI.
  !! C declaration: int NC_NOTNC4_inq_enum_ident(int, nc_type, long long, char *);
  import :: c_int, c_long_long, c_ptr
  integer(c_int), value :: arg1
  !! C int argument arg1.
  integer(c_int), value :: arg2
  !! C nc_type argument arg2.
  integer(c_long_long), value :: arg3
  !! C long long argument arg3.
  type(c_ptr), value :: arg4
  !! Pointer to caller-provided C character output storage (NC_MAX_NAME + 1 for names).
  integer(c_int) :: NC_NOTNC4_inq_enum_ident
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function NC_NOTNC4_inq_enum_ident

function NC_NOTNC4_def_opaque(arg1, arg2, arg3, arg4) bind(c, name="NC_NOTNC4_def_opaque")
  !! Backend dispatch helper: report an unsupported enhanced-model operation.
  !! Intended for custom backend implementers; arguments retain the C dispatch-table ABI.
  !! C declaration: int NC_NOTNC4_def_opaque(int, size_t, const char *, nc_type *);
  import :: c_int, c_size_t, c_char, c_ptr
  integer(c_int), value :: arg1
  !! C int argument arg1.
  integer(c_size_t), value :: arg2
  !! C size_t argument arg2.
  character(kind=c_char), intent(in) :: arg3(*)
  !! NUL-terminated C string.
  type(c_ptr), value :: arg4
  !! Pointer to C-compatible storage. C pointee: nc_type *.
  integer(c_int) :: NC_NOTNC4_def_opaque
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function NC_NOTNC4_def_opaque

function NC_NOTNC4_def_var_deflate(arg1, arg2, arg3, arg4, arg5) bind(c, name="NC_NOTNC4_def_var_deflate")
  !! Backend dispatch helper: report an unsupported enhanced-model operation.
  !! Intended for custom backend implementers; arguments retain the C dispatch-table ABI.
  !! C declaration: int NC_NOTNC4_def_var_deflate(int, int, int, int, int);
  import :: c_int
  integer(c_int), value :: arg1
  !! C int argument arg1.
  integer(c_int), value :: arg2
  !! C int argument arg2.
  integer(c_int), value :: arg3
  !! C int argument arg3.
  integer(c_int), value :: arg4
  !! C int argument arg4.
  integer(c_int), value :: arg5
  !! C int argument arg5.
  integer(c_int) :: NC_NOTNC4_def_var_deflate
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function NC_NOTNC4_def_var_deflate

function NC_NOTNC4_def_var_fletcher32(arg1, arg2, arg3) bind(c, name="NC_NOTNC4_def_var_fletcher32")
  !! Backend dispatch helper: report an unsupported enhanced-model operation.
  !! Intended for custom backend implementers; arguments retain the C dispatch-table ABI.
  !! C declaration: int NC_NOTNC4_def_var_fletcher32(int, int, int);
  import :: c_int
  integer(c_int), value :: arg1
  !! C int argument arg1.
  integer(c_int), value :: arg2
  !! C int argument arg2.
  integer(c_int), value :: arg3
  !! C int argument arg3.
  integer(c_int) :: NC_NOTNC4_def_var_fletcher32
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function NC_NOTNC4_def_var_fletcher32

function NC_NOTNC4_def_var_chunking(arg1, arg2, arg3, arg4) bind(c, name="NC_NOTNC4_def_var_chunking")
  !! Backend dispatch helper: report an unsupported enhanced-model operation.
  !! Intended for custom backend implementers; arguments retain the C dispatch-table ABI.
  !! C declaration: int NC_NOTNC4_def_var_chunking(int, int, int, const size_t *);
  import :: c_int, c_ptr
  integer(c_int), value :: arg1
  !! C int argument arg1.
  integer(c_int), value :: arg2
  !! C int argument arg2.
  integer(c_int), value :: arg3
  !! C int argument arg3.
  type(c_ptr), value :: arg4
  !! Pointer to C-compatible storage. C pointee: const size_t *.
  integer(c_int) :: NC_NOTNC4_def_var_chunking
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function NC_NOTNC4_def_var_chunking

function NC_NOTNC4_def_var_endian(arg1, arg2, arg3) bind(c, name="NC_NOTNC4_def_var_endian")
  !! Backend dispatch helper: report an unsupported enhanced-model operation.
  !! Intended for custom backend implementers; arguments retain the C dispatch-table ABI.
  !! C declaration: int NC_NOTNC4_def_var_endian(int, int, int);
  import :: c_int
  integer(c_int), value :: arg1
  !! C int argument arg1.
  integer(c_int), value :: arg2
  !! C int argument arg2.
  integer(c_int), value :: arg3
  !! C int argument arg3.
  integer(c_int) :: NC_NOTNC4_def_var_endian
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function NC_NOTNC4_def_var_endian

function NC_NOTNC4_set_var_chunk_cache(arg1, arg2, arg3, arg4, arg5) &
  & bind(c, name="NC_NOTNC4_set_var_chunk_cache")
  !! Backend dispatch helper: report an unsupported enhanced-model operation.
  !! Intended for custom backend implementers; arguments retain the C dispatch-table ABI.
  !! C declaration: int NC_NOTNC4_set_var_chunk_cache(int, int, size_t, size_t, float);
  import :: c_int, c_size_t, c_float
  integer(c_int), value :: arg1
  !! C int argument arg1.
  integer(c_int), value :: arg2
  !! C int argument arg2.
  integer(c_size_t), value :: arg3
  !! C size_t argument arg3.
  integer(c_size_t), value :: arg4
  !! C size_t argument arg4.
  real(c_float), value :: arg5
  !! C float argument arg5.
  integer(c_int) :: NC_NOTNC4_set_var_chunk_cache
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function NC_NOTNC4_set_var_chunk_cache

function NC_NOTNC4_get_var_chunk_cache(arg1, arg2, arg3, arg4, arg5) &
  & bind(c, name="NC_NOTNC4_get_var_chunk_cache")
  !! Backend dispatch helper: report an unsupported enhanced-model operation.
  !! Intended for custom backend implementers; arguments retain the C dispatch-table ABI.
  !! C declaration: int NC_NOTNC4_get_var_chunk_cache(int, int, size_t *, size_t *, float *);
  import :: c_int, c_ptr
  integer(c_int), value :: arg1
  !! C int argument arg1.
  integer(c_int), value :: arg2
  !! C int argument arg2.
  type(c_ptr), value :: arg3
  !! Pointer to C-compatible storage. C pointee: size_t *.
  type(c_ptr), value :: arg4
  !! Pointer to C-compatible storage. C pointee: size_t *.
  type(c_ptr), value :: arg5
  !! Pointer to C-compatible storage. C pointee: float *.
  integer(c_int) :: NC_NOTNC4_get_var_chunk_cache
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function NC_NOTNC4_get_var_chunk_cache

function NC_NOTNC4_inq_ncid(arg1, arg2, arg3) bind(c, name="NC_NOTNC4_inq_ncid")
  !! Backend dispatch helper: report an unsupported enhanced-model operation.
  !! Intended for custom backend implementers; arguments retain the C dispatch-table ABI.
  !! C declaration: int NC_NOTNC4_inq_ncid(int, const char *, int *);
  import :: c_int, c_char, c_ptr
  integer(c_int), value :: arg1
  !! C int argument arg1.
  character(kind=c_char), intent(in) :: arg2(*)
  !! NUL-terminated C string.
  type(c_ptr), value :: arg3
  !! Pointer to C-compatible storage. C pointee: int *.
  integer(c_int) :: NC_NOTNC4_inq_ncid
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function NC_NOTNC4_inq_ncid

function NC_NOTNC4_inq_grps(arg1, arg2, arg3) bind(c, name="NC_NOTNC4_inq_grps")
  !! Backend dispatch helper: report an unsupported enhanced-model operation.
  !! Intended for custom backend implementers; arguments retain the C dispatch-table ABI.
  !! C declaration: int NC_NOTNC4_inq_grps(int, int *, int *);
  import :: c_int, c_ptr
  integer(c_int), value :: arg1
  !! C int argument arg1.
  type(c_ptr), value :: arg2
  !! Pointer to C-compatible storage. C pointee: int *.
  type(c_ptr), value :: arg3
  !! Pointer to C-compatible storage. C pointee: int *.
  integer(c_int) :: NC_NOTNC4_inq_grps
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function NC_NOTNC4_inq_grps

function NC_NOTNC4_inq_grpname(arg1, arg2) bind(c, name="NC_NOTNC4_inq_grpname")
  !! Backend dispatch helper: report an unsupported enhanced-model operation.
  !! Intended for custom backend implementers; arguments retain the C dispatch-table ABI.
  !! C declaration: int NC_NOTNC4_inq_grpname(int, char *);
  import :: c_int, c_ptr
  integer(c_int), value :: arg1
  !! C int argument arg1.
  type(c_ptr), value :: arg2
  !! Pointer to caller-provided C character output storage (NC_MAX_NAME + 1 for names).
  integer(c_int) :: NC_NOTNC4_inq_grpname
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function NC_NOTNC4_inq_grpname

function NC_NOTNC4_inq_grpname_full(arg1, arg2, arg3) bind(c, name="NC_NOTNC4_inq_grpname_full")
  !! Backend dispatch helper: report an unsupported enhanced-model operation.
  !! Intended for custom backend implementers; arguments retain the C dispatch-table ABI.
  !! C declaration: int NC_NOTNC4_inq_grpname_full(int, size_t *, char *);
  import :: c_int, c_ptr
  integer(c_int), value :: arg1
  !! C int argument arg1.
  type(c_ptr), value :: arg2
  !! Pointer to C-compatible storage. C pointee: size_t *.
  type(c_ptr), value :: arg3
  !! Pointer to caller-provided C character output storage (NC_MAX_NAME + 1 for names).
  integer(c_int) :: NC_NOTNC4_inq_grpname_full
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function NC_NOTNC4_inq_grpname_full

function NC_NOTNC4_inq_grp_parent(arg1, arg2) bind(c, name="NC_NOTNC4_inq_grp_parent")
  !! Backend dispatch helper: report an unsupported enhanced-model operation.
  !! Intended for custom backend implementers; arguments retain the C dispatch-table ABI.
  !! C declaration: int NC_NOTNC4_inq_grp_parent(int, int *);
  import :: c_int, c_ptr
  integer(c_int), value :: arg1
  !! C int argument arg1.
  type(c_ptr), value :: arg2
  !! Pointer to C-compatible storage. C pointee: int *.
  integer(c_int) :: NC_NOTNC4_inq_grp_parent
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function NC_NOTNC4_inq_grp_parent

function NC_NOTNC4_inq_grp_full_ncid(arg1, arg2, arg3) bind(c, name="NC_NOTNC4_inq_grp_full_ncid")
  !! Backend dispatch helper: report an unsupported enhanced-model operation.
  !! Intended for custom backend implementers; arguments retain the C dispatch-table ABI.
  !! C declaration: int NC_NOTNC4_inq_grp_full_ncid(int, const char *, int *);
  import :: c_int, c_char, c_ptr
  integer(c_int), value :: arg1
  !! C int argument arg1.
  character(kind=c_char), intent(in) :: arg2(*)
  !! NUL-terminated C string.
  type(c_ptr), value :: arg3
  !! Pointer to C-compatible storage. C pointee: int *.
  integer(c_int) :: NC_NOTNC4_inq_grp_full_ncid
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function NC_NOTNC4_inq_grp_full_ncid

function NC_NOTNC4_inq_varids(arg1, arg2, arg3) bind(c, name="NC_NOTNC4_inq_varids")
  !! Backend dispatch helper: report an unsupported enhanced-model operation.
  !! Intended for custom backend implementers; arguments retain the C dispatch-table ABI.
  !! C declaration: int NC_NOTNC4_inq_varids(int, int *, int *);
  import :: c_int, c_ptr
  integer(c_int), value :: arg1
  !! C int argument arg1.
  type(c_ptr), value :: arg2
  !! Pointer to C-compatible storage. C pointee: int *.
  type(c_ptr), value :: arg3
  !! Pointer to C-compatible storage. C pointee: int *.
  integer(c_int) :: NC_NOTNC4_inq_varids
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function NC_NOTNC4_inq_varids

function NC_NOTNC4_inq_dimids(arg1, arg2, arg3, arg4) bind(c, name="NC_NOTNC4_inq_dimids")
  !! Backend dispatch helper: report an unsupported enhanced-model operation.
  !! Intended for custom backend implementers; arguments retain the C dispatch-table ABI.
  !! C declaration: int NC_NOTNC4_inq_dimids(int, int *, int *, int);
  import :: c_int, c_ptr
  integer(c_int), value :: arg1
  !! C int argument arg1.
  type(c_ptr), value :: arg2
  !! Pointer to C-compatible storage. C pointee: int *.
  type(c_ptr), value :: arg3
  !! Pointer to C-compatible storage. C pointee: int *.
  integer(c_int), value :: arg4
  !! C int argument arg4.
  integer(c_int) :: NC_NOTNC4_inq_dimids
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function NC_NOTNC4_inq_dimids

function NC_NOTNC4_inq_typeids(arg1, arg2, arg3) bind(c, name="NC_NOTNC4_inq_typeids")
  !! Backend dispatch helper: report an unsupported enhanced-model operation.
  !! Intended for custom backend implementers; arguments retain the C dispatch-table ABI.
  !! C declaration: int NC_NOTNC4_inq_typeids(int, int *, int *);
  import :: c_int, c_ptr
  integer(c_int), value :: arg1
  !! C int argument arg1.
  type(c_ptr), value :: arg2
  !! Pointer to C-compatible storage. C pointee: int *.
  type(c_ptr), value :: arg3
  !! Pointer to C-compatible storage. C pointee: int *.
  integer(c_int) :: NC_NOTNC4_inq_typeids
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function NC_NOTNC4_inq_typeids

function NC_NOTNC4_inq_user_type(arg1, arg2, arg3, arg4, arg5, arg6, arg7) &
  & bind(c, name="NC_NOTNC4_inq_user_type")
  !! Backend dispatch helper: report an unsupported enhanced-model operation.
  !! Intended for custom backend implementers; arguments retain the C dispatch-table ABI.
  !! C declaration: int NC_NOTNC4_inq_user_type(int, nc_type, char *, size_t *, nc_type *, size_t *, int *);
  import :: c_int, c_ptr
  integer(c_int), value :: arg1
  !! C int argument arg1.
  integer(c_int), value :: arg2
  !! C nc_type argument arg2.
  type(c_ptr), value :: arg3
  !! Pointer to caller-provided C character output storage (NC_MAX_NAME + 1 for names).
  type(c_ptr), value :: arg4
  !! Pointer to C-compatible storage. C pointee: size_t *.
  type(c_ptr), value :: arg5
  !! Pointer to C-compatible storage. C pointee: nc_type *.
  type(c_ptr), value :: arg6
  !! Pointer to C-compatible storage. C pointee: size_t *.
  type(c_ptr), value :: arg7
  !! Pointer to C-compatible storage. C pointee: int *.
  integer(c_int) :: NC_NOTNC4_inq_user_type
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function NC_NOTNC4_inq_user_type

function NC_NOTNC4_def_var_quantize(arg1, arg2, arg3, arg4) bind(c, name="NC_NOTNC4_def_var_quantize")
  !! Backend dispatch helper: report an unsupported enhanced-model operation.
  !! Intended for custom backend implementers; arguments retain the C dispatch-table ABI.
  !! C declaration: int NC_NOTNC4_def_var_quantize(int, int, int, int);
  import :: c_int
  integer(c_int), value :: arg1
  !! C int argument arg1.
  integer(c_int), value :: arg2
  !! C int argument arg2.
  integer(c_int), value :: arg3
  !! C int argument arg3.
  integer(c_int), value :: arg4
  !! C int argument arg4.
  integer(c_int) :: NC_NOTNC4_def_var_quantize
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function NC_NOTNC4_def_var_quantize

function NC_NOTNC4_inq_var_quantize(arg1, arg2, arg3, arg4) bind(c, name="NC_NOTNC4_inq_var_quantize")
  !! Backend dispatch helper: report an unsupported enhanced-model operation.
  !! Intended for custom backend implementers; arguments retain the C dispatch-table ABI.
  !! C declaration: int NC_NOTNC4_inq_var_quantize(int, int, int *, int *);
  import :: c_int, c_ptr
  integer(c_int), value :: arg1
  !! C int argument arg1.
  integer(c_int), value :: arg2
  !! C int argument arg2.
  type(c_ptr), value :: arg3
  !! Pointer to C-compatible storage. C pointee: int *.
  type(c_ptr), value :: arg4
  !! Pointer to C-compatible storage. C pointee: int *.
  integer(c_int) :: NC_NOTNC4_inq_var_quantize
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function NC_NOTNC4_inq_var_quantize

function NC_NOTNC3_get_varm(ncid, varid, start, edges, stride, imapp, value0, memtype) &
  & bind(c, name="NC_NOTNC3_get_varm")
  !! Backend dispatch helper: report unsupported mapped access.
  !! Intended for custom backend implementers; arguments retain the C dispatch-table ABI.
  !! C declaration: int NC_NOTNC3_get_varm(int ncid, int varid, const size_t *start, const size_t *edges,
  !! const ptrdiff_t *stride, const ptrdiff_t *imapp, void *value0, nc_type memtype);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: start
  !! Pointer to C-compatible storage. C pointee: const size_t *.
  type(c_ptr), value :: edges
  !! Pointer to C-compatible storage. C pointee: const size_t *.
  type(c_ptr), value :: stride
  !! Pointer to C-compatible storage. C pointee: const ptrdiff_t *.
  type(c_ptr), value :: imapp
  !! Memory strides in C dimension order, measured in elements for modern typed APIs. C pointee: const
  !! ptrdiff_t *.
  type(c_ptr), value :: value0
  !! Pointer to C-compatible storage. C pointee: void *.
  integer(c_int), value :: memtype
  !! C nc_type argument memtype.
  integer(c_int) :: NC_NOTNC3_get_varm
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function NC_NOTNC3_get_varm

function NC_NOTNC3_put_varm(ncid, varid, start, edges, stride, imapp, value0, memtype) &
  & bind(c, name="NC_NOTNC3_put_varm")
  !! Backend dispatch helper: report unsupported mapped access.
  !! Intended for custom backend implementers; arguments retain the C dispatch-table ABI.
  !! C declaration: int NC_NOTNC3_put_varm(int ncid, int varid, const size_t * start, const size_t *edges,
  !! const ptrdiff_t *stride, const ptrdiff_t *imapp, const void *value0, nc_type memtype);
  import :: c_int, c_ptr
  integer(c_int), value :: ncid
  !! Open dataset or group identifier.
  integer(c_int), value :: varid
  !! Variable identifier.
  type(c_ptr), value :: start
  !! Pointer to C-compatible storage. C pointee: const size_t *.
  type(c_ptr), value :: edges
  !! Pointer to C-compatible storage. C pointee: const size_t *.
  type(c_ptr), value :: stride
  !! Pointer to C-compatible storage. C pointee: const ptrdiff_t *.
  type(c_ptr), value :: imapp
  !! Memory strides in C dimension order, measured in elements for modern typed APIs. C pointee: const
  !! ptrdiff_t *.
  type(c_ptr), value :: value0
  !! Pointer to C-compatible storage. C pointee: const void *.
  integer(c_int), value :: memtype
  !! C nc_type argument memtype.
  integer(c_int) :: NC_NOTNC3_put_varm
  !! **Options:**
  !! - NC_NOERR Success.
  !! - A NetCDF error code on failure; backend and feature errors are preserved.
end function NC_NOTNC3_put_varm
