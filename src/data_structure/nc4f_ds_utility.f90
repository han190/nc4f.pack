submodule(nc4f_ds) nc4f_ds_utility
!! Shared pure validation and error-handling utilities.
implicit none (type, external)
contains

pure module subroutine check_nc_name(name, err, context)
  !! Check NetCDF name syntax without C calls. Trailing Fortran padding is ignored.
  !! UTF-8 is validated here; callers supply NFC-normalized Unicode names.
  character(len=*), intent(in) :: name
  !! NetCDF local name to validate; trailing Fortran blank padding is ignored.
  type(error_type), intent(out) :: err
  !! Receives the operation status and diagnostic message.
  character(len=*), intent(in), optional :: context
  !! Context label included in error diagnostics.
  character(len=:), allocatable :: ctx
  integer :: i, j, n, byte, ncont, lo, hi

  ctx = "[check_nc_name]"
  if (present(context)) ctx = context
  err = error_type(NC_EBADNAME, ctx//" Invalid NetCDF name.")
  n = len_trim(name)
  if (n == 0) return
  if (n > NC_MAX_NAME) then
    err = error_type(NC_EMAXNAME, &
      & ctx//" NetCDF name exceeds NC_MAX_NAME bytes.")
    return
  end if
  byte = iachar(name(1:1))
  if (byte < 128) then
    if (index("ABCDEFGHIJKLMNOPQRSTUVWXYZ"// &
      & "abcdefghijklmnopqrstuvwxyz0123456789_", name(1:1)) == 0) return
  end if
  i = 1
  do while (i <= n)
    byte = iachar(name(i:i))
    if (byte < 128) then
      if (byte < 32 .or. byte == 127 .or. name(i:i) == "/") return
      i = i + 1
      cycle
    end if
    ! Reject malformed, overlong, surrogate, and out-of-range UTF-8 sequences.
    lo = 128
    hi = 191
    select case (byte)
    case (194:223)
      ncont = 1
    case (224:239)
      ncont = 2
      if (byte == 224) lo = 160
      if (byte == 237) hi = 159
    case (240:244)
      ncont = 3
      if (byte == 240) lo = 144
      if (byte == 244) hi = 143
    case default
      return
    end select
    if (i + ncont > n) return
    byte = iachar(name(i + 1:i + 1))
    if (byte < lo .or. byte > hi) return
    do j = i + 2, i + ncont
      byte = iachar(name(j:j))
      if (byte < 128 .or. byte > 191) return
    end do
    i = i + ncont + 1
  end do
  err = error_type()
end subroutine check_nc_name

pure module subroutine return_err(op_err, err)
  !! Return an optional error or terminate, shared by model and NetCDF operations.
  type(error_type), intent(in) :: op_err
  !! Completed operation result to return or use for error termination.
  type(error_type), intent(out), optional :: err
  !! Receives the status and diagnostic; failures stop execution when omitted.

  if (present(err)) then
    err = op_err
  else if (op_err%code /= NC_NOERR) then
    if (allocated(op_err%msg)) then
      error stop trim(op_err%msg)
    else
      error stop "nc4f operation failed without a diagnostic."
    end if
  end if
end subroutine return_err

end submodule nc4f_ds_utility
