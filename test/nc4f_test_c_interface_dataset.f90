submodule(nc4f_test_c_interface) nc4f_test_c_interface_dataset
use, intrinsic :: iso_c_binding, only: c_associated, c_int, c_null_char, &
  & c_null_ptr, c_size_t
use, non_intrinsic :: testdrive, only: check, error_type, new_unittest, &
  & unittest_type
use, non_intrinsic :: nc4f_test_utility, only: open_dataset, finish
use, non_intrinsic :: nc4f_c_interface, only: c_strlen, nc_abort, &
  & nc_close, nc_create, nc_delete, nc_enddef, nc_inq, nc_inq_format, &
  & nc_inq_format_extended, nc_inq_libvers, nc_inq_ndims, nc_inq_nvars, &
  & nc_inq_path, nc_open, nc_redef, nc_set_fill, nc_sync, nccreate, &
  & ncopen, ncclose, ncabort, ncendef, ncinquire, ncredef, &
  & ncsetfill, ncsync, NC_CLOBBER, NC_DISKLESS, NC_EBADID, NC_FILL, &
  & NC_FORMAT_NETCDF4, NC_FORMATX_NC_HDF5, NC_NOERR, NC_NOWRITE, &
  & NC_PERSIST
implicit none (type, external)

contains

module subroutine collect_c_interface_dataset(tests)
  type(unittest_type), allocatable, intent(out) :: tests(:)
  tests = [ &
    & new_unittest("nc_create", test_nc_create), &
    & new_unittest("nc_open", test_nc_open), &
    & new_unittest("nccreate", test_nccreate), &
    & new_unittest("ncopen", test_ncopen), &
    & new_unittest("ncclose", test_ncclose), &
    & new_unittest("ncendef", test_ncendef), &
    & new_unittest("ncredef", test_ncredef), &
    & new_unittest("ncsync", test_ncsync), &
    & new_unittest("ncabort", test_ncabort), &
    & new_unittest("ncsetfill", test_ncsetfill), &
    & new_unittest("ncinquire", test_ncinquire), &
    & new_unittest("nc_inq_libvers", test_nc_inq_libvers), &
    & new_unittest("nc_close", test_nc_close), &
    & new_unittest("nc_enddef", test_nc_enddef), &
    & new_unittest("nc_redef", test_nc_redef), &
    & new_unittest("nc_sync", test_nc_sync), &
    & new_unittest("nc_abort", test_nc_abort), &
    & new_unittest("nc_inq", test_nc_inq), &
    & new_unittest("nc_inq_ndims", test_nc_inq_ndims), &
    & new_unittest("nc_inq_nvars", test_nc_inq_nvars), &
    & new_unittest("nc_inq_format", test_nc_inq_format), &
    & new_unittest("nc_inq_format_extended", &
    & test_nc_inq_format_extended), &
    & new_unittest("nc_inq_path", test_nc_inq_path), &
    & new_unittest("nc_set_fill", test_nc_set_fill) &
    & ]
end subroutine collect_c_interface_dataset

subroutine test_nc_create(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, status

  status = nc_create("nc4f-create"//c_null_char, &
    & ior(NC_CLOBBER, NC_DISKLESS), ncid)
  call check(error, status == NC_NOERR, "nc_create failed")
  if (allocated(error)) return
  call finish(error, ncid, NC_NOERR, "nc_create failed")
end subroutine test_nc_create

subroutine test_nc_open(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, status

  status = nc_create("nc4f-open"//c_null_char, &
    & ior(NC_CLOBBER, ior(NC_DISKLESS, NC_PERSIST)), ncid)
  call check(error, status == NC_NOERR, "File setup failed")
  if (allocated(error)) return
  status = nc_close(ncid)
  call check(error, status == NC_NOERR, "File setup close failed")
  if (allocated(error)) return
  status = nc_open("nc4f-open"//c_null_char, NC_NOWRITE, ncid)
  call check(error, status == NC_NOERR, "nc_open failed")
  if (allocated(error)) return
  status = nc_close(ncid)
  call check(error, status == NC_NOERR, "nc_open close failed")
  if (allocated(error)) return
  status = nc_delete("nc4f-open"//c_null_char)
  call check(error, status == NC_NOERR, "nc_open cleanup failed")
end subroutine test_nc_open

subroutine test_nccreate(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid

  ncid = nccreate("nc4f-legacy-create"//c_null_char, &
    & ior(NC_CLOBBER, NC_DISKLESS))
  call check(error, ncid >= 0, "nccreate failed")
  if (allocated(error)) return
  call check(error, ncclose(ncid) == 0, "ncclose failed")
end subroutine test_nccreate

subroutine test_ncopen(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, status

  status = nc_create("nc4f-legacy-open"//c_null_char, &
    & ior(NC_CLOBBER, ior(NC_DISKLESS, NC_PERSIST)), ncid)
  call check(error, status == NC_NOERR, "File setup failed")
  if (allocated(error)) return
  status = nc_close(ncid)
  call check(error, status == NC_NOERR, "File setup close failed")
  if (allocated(error)) return
  ncid = ncopen("nc4f-legacy-open"//c_null_char, NC_NOWRITE)
  call check(error, ncid >= 0, "ncopen failed")
  if (allocated(error)) return
  call check(error, ncclose(ncid) == 0, "ncclose failed")
  if (allocated(error)) return
  status = nc_delete("nc4f-legacy-open"//c_null_char)
  call check(error, status == NC_NOERR, "ncopen cleanup failed")
end subroutine test_ncopen

subroutine test_ncclose(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid

  ncid = nccreate("nc4f-legacy-close"//c_null_char, &
    & ior(NC_CLOBBER, NC_DISKLESS))
  call check(error, ncid >= 0, "nccreate setup failed")
  if (allocated(error)) return
  call check(error, ncclose(ncid) == 0, "ncclose failed")
end subroutine test_ncclose

subroutine test_ncendef(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, status

  call open_dataset(error, ncid)
  if (allocated(error)) return
  status = ncendef(ncid)
  call finish(error, ncid, status, "ncendef failed")
end subroutine test_ncendef

subroutine test_ncredef(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, status

  call open_dataset(error, ncid)
  if (allocated(error)) return
  status = ncendef(ncid)
  if (status == 0) status = ncredef(ncid)
  call finish(error, ncid, status, "ncredef failed")
end subroutine test_ncredef

subroutine test_ncsync(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, status

  call open_dataset(error, ncid)
  if (allocated(error)) return
  status = ncendef(ncid)
  if (status == 0) status = ncsync(ncid)
  call finish(error, ncid, status, "ncsync failed")
end subroutine test_ncsync

subroutine test_ncabort(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, status

  call open_dataset(error, ncid)
  if (allocated(error)) return
  status = ncabort(ncid)
  call check(error, status == 0, "ncabort failed")
  if (allocated(error)) return
  call check(error, nc_close(ncid) == NC_EBADID, &
    & "Aborted ID remained usable")
end subroutine test_ncabort

subroutine test_ncsetfill(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, previous

  call open_dataset(error, ncid)
  if (allocated(error)) return
  previous = ncsetfill(ncid, NC_FILL)
  call finish(error, ncid, NC_NOERR, "ncsetfill cleanup failed")
  if (allocated(error)) return
  call check(error, previous == NC_FILL, "Previous fill mode differs")
end subroutine test_ncsetfill

subroutine test_ncinquire(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, ndims, nvars, natts, unlim, status

  call open_dataset(error, ncid)
  if (allocated(error)) return
  status = ncinquire(ncid, ndims, nvars, natts, unlim)
  call check(error, status == ncid, "ncinquire failed")
  call finish(error, ncid, NC_NOERR, "ncinquire cleanup failed")
  if (allocated(error)) return
  call check(error, ndims == 0 .and. nvars == 0 .and. natts == 0 &
    & .and. unlim == -1, "Empty dataset metadata differs")
end subroutine test_ncinquire

subroutine test_nc_inq_libvers(error)
  type(error_type), allocatable, intent(out) :: error
  call check(error, c_associated(nc_inq_libvers()), &
    & "Version pointer is NULL")
  if (allocated(error)) return
  call check(error, c_strlen(nc_inq_libvers()) > 0_c_size_t, &
    & "Version string is empty")
end subroutine test_nc_inq_libvers

subroutine test_nc_close(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, status
  call open_dataset(error, ncid)
  if (allocated(error)) return
  status = nc_close(ncid)
  call check(error, status == NC_NOERR, "nc_close failed")
  if (allocated(error)) return
  call check(error, nc_close(ncid) == NC_EBADID, &
    & "Closed ID remained usable")
end subroutine test_nc_close

subroutine test_nc_enddef(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, status
  call open_dataset(error, ncid)
  if (allocated(error)) return
  status = nc_enddef(ncid)
  call finish(error, ncid, status, "nc_enddef failed")
end subroutine test_nc_enddef

subroutine test_nc_redef(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, status
  call open_dataset(error, ncid)
  if (allocated(error)) return
  status = nc_enddef(ncid)
  if (status == NC_NOERR) status = nc_redef(ncid)
  call finish(error, ncid, status, "nc_redef failed")
end subroutine test_nc_redef

subroutine test_nc_sync(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, status
  call open_dataset(error, ncid)
  if (allocated(error)) return
  status = nc_enddef(ncid)
  if (status == NC_NOERR) status = nc_sync(ncid)
  call finish(error, ncid, status, "nc_sync failed")
end subroutine test_nc_sync

subroutine test_nc_abort(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, status
  call open_dataset(error, ncid)
  if (allocated(error)) return
  status = nc_abort(ncid)
  call check(error, status == NC_NOERR, "nc_abort failed")
  if (allocated(error)) return
  call check(error, nc_close(ncid) == NC_EBADID, &
    & "Aborted ID remained usable")
end subroutine test_nc_abort

subroutine test_nc_inq(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, ndims, nvars, natts, unlim, status
  call open_dataset(error, ncid)
  if (allocated(error)) return
  status = nc_inq(ncid, ndims, nvars, natts, unlim)
  call finish(error, ncid, status, "nc_inq failed")
  if (allocated(error)) return
  call check(error, ndims == 0 .and. nvars == 0 .and. natts == 0 &
    & .and. unlim == -1, "Incorrect empty dataset metadata")
end subroutine test_nc_inq

subroutine test_nc_inq_ndims(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, count, status
  call open_dataset(error, ncid)
  if (allocated(error)) return
  status = nc_inq_ndims(ncid, count)
  call finish(error, ncid, status, "nc_inq_ndims failed")
  if (allocated(error)) return
  call check(error, count == 0, "Incorrect dimension count")
end subroutine test_nc_inq_ndims

subroutine test_nc_inq_nvars(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, count, status
  call open_dataset(error, ncid)
  if (allocated(error)) return
  status = nc_inq_nvars(ncid, count)
  call finish(error, ncid, status, "nc_inq_nvars failed")
  if (allocated(error)) return
  call check(error, count == 0, "Incorrect variable count")
end subroutine test_nc_inq_nvars

subroutine test_nc_inq_format(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, format, status
  call open_dataset(error, ncid, enhanced=.true.)
  if (allocated(error)) return
  status = nc_inq_format(ncid, format)
  call finish(error, ncid, status, "nc_inq_format failed")
  if (allocated(error)) return
  call check(error, format == NC_FORMAT_NETCDF4, "Incorrect format")
end subroutine test_nc_inq_format

subroutine test_nc_inq_format_extended(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, format, mode, status
  call open_dataset(error, ncid, enhanced=.true.)
  if (allocated(error)) return
  status = nc_inq_format_extended(ncid, format, mode)
  call finish(error, ncid, status, "nc_inq_format_extended failed")
  if (allocated(error)) return
  call check(error, format == NC_FORMATX_NC_HDF5, &
    & "Incorrect backend format")
end subroutine test_nc_inq_format_extended

subroutine test_nc_inq_path(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, status
  integer(c_size_t) :: length
  call open_dataset(error, ncid)
  if (allocated(error)) return
  status = nc_inq_path(ncid, length, c_null_ptr)
  call finish(error, ncid, status, "nc_inq_path failed")
  if (allocated(error)) return
  call check(error, length > 0_c_size_t, "Dataset path is empty")
end subroutine test_nc_inq_path

subroutine test_nc_set_fill(error)
  type(error_type), allocatable, intent(out) :: error
  integer(c_int) :: ncid, old_mode, status
  call open_dataset(error, ncid)
  if (allocated(error)) return
  status = nc_set_fill(ncid, NC_FILL, old_mode)
  call finish(error, ncid, status, "nc_set_fill failed")
  if (allocated(error)) return
  call check(error, old_mode == NC_FILL, "Incorrect previous fill mode")
end subroutine test_nc_set_fill

end submodule nc4f_test_c_interface_dataset
