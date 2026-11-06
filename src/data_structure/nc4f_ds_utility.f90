submodule(nc4f_ds) nc4f_ds_utility
!! Shared pure validation and error-handling utilities.
implicit none (type, external)
contains

logical elemental module function has_err(err) result(is_err)
  !! Return true when `err` represents a failed operation.
  type(error_type), intent(in) :: err
  !! Completed result of an nc4f operation.

  is_err = err%code /= NC_NOERR
end function has_err

pure module function make_err(code, fname, msg) result(err)
  !! Construct a success result or a checked failure diagnostic.
  integer(c_int), intent(in), optional :: code
  !! NetCDF status code; defaults to NC_NOERR.
  character(len=*), intent(in), optional :: fname
  !! Operation name, required and nonblank on failure.
  character(len=*), intent(in), optional :: msg
  !! Diagnostic text, required and nonblank on failure.
  type(error_type) :: err
  !! Constructed result with validated failure fields.

  if (present(code)) err%code = code
  if (present(fname)) err%fname = fname
  if (present(msg)) err%msg = msg
  call validate_err(err)
end function make_err

pure module function error_msg(err) result(text)
  !! Return "[fname] msg" for failures or "No error" for success.
  class(error_type), intent(in) :: err
  !! Result to validate and format without external I/O.
  character(len=:), allocatable :: text
  !! Complete formatted diagnostic.

  call validate_err(err)
  if (.exists. err) then
    text = "["//trim(err%fname)//"] "//trim(err%msg)
  else
    text = "No error"
  end if
end function error_msg

pure subroutine validate_err(err)
  !! Reject failures with missing or blank diagnostic fields.
  class(error_type), intent(in) :: err
  !! Result to validate; success needs no diagnostic fields.

  if (.not. (.exists. err)) return
  if (.not. allocated(err%fname)) &
    & error stop "[error_type] Failure requires an allocated fname."
  if (len_trim(err%fname) == 0) &
    & error stop "[error_type] Failure requires a nonblank fname."
  if (.not. allocated(err%msg)) &
    & error stop "[error_type] Failure requires an allocated msg."
  if (len_trim(err%msg) == 0) &
    & error stop "[error_type] Failure requires a nonblank msg."
end subroutine validate_err

pure module subroutine return_err(op_err, err)
  !! Return an optional error or terminate, shared by model and NetCDF
  !! operations.
  type(error_type), intent(in) :: op_err
  !! Completed operation result to return or use for error termination.
  type(error_type), intent(out), optional :: err
  !! Receives the status and diagnostic; failures stop execution when omitted.

  call validate_err(op_err)
  if (present(err)) then
    err = op_err
  else if (.exists. op_err) then
    error stop error_msg(op_err)
  end if
end subroutine return_err

pure module function buffer_size(dtype, len) result(nbytes)
  !! Compute the byte count for a NetCDF type and element count, checking
  !! overflow.
  integer(data_type), intent(in) :: dtype
  !! Dataset data type code to validate or translate.
  integer(int64), intent(in) :: len
  !! Length of the dimension or attribute.
  integer :: nbytes
  !! Result produced by this operation.
  type(error_type) :: op_err

  call compute_buffer_size(dtype, len, nbytes, op_err)
  call return_err(op_err)
end function buffer_size

pure module subroutine compute_buffer_size(dtype, len, nbytes, err)
  integer(data_type), intent(in) :: dtype
  integer(int64), intent(in) :: len
  integer, intent(out) :: nbytes
  type(error_type), intent(out) :: err
  integer(int64) :: item_bytes

  err = error_type()
  nbytes = 0
  if (len < 0) then
    err = error_type(NC_EINVAL, "buffer_size", "Negative element count.")
    return
  end if
  select case (dtype)
  case (BYTE_TYPE, CHAR_TYPE)
    item_bytes = 1
  case (SHORT_TYPE)
    item_bytes = storage_size(0_int16)/storage_size(0_int8)
  case (INT_TYPE, FLOAT_TYPE)
    item_bytes = storage_size(0_int32)/storage_size(0_int8)
  case (INT64_TYPE, DOUBLE_TYPE)
    item_bytes = storage_size(0_int64)/storage_size(0_int8)
  case default
    err = error_type(NC_EINVAL, "buffer_size", &
      & "Unsupported NetCDF data type.")
    return
  end select
  if (len > int(huge(nbytes), int64)/item_bytes) then
    err = error_type(NC_EINVAL, "buffer_size", "Byte-size overflow.")
    return
  end if
  nbytes = int(len*item_bytes)
end subroutine compute_buffer_size

end submodule nc4f_ds_utility
