submodule(nc4f_ds) nc4f_ds_validate
!! Shared validation for data-model storage and metadata.
implicit none (type, external)
contains

pure module subroutine validate_nc_name(name, context, err)
  !! Validate NetCDF name syntax independently of data-model storage.
  !! UTF-8 is validated here; callers supply NFC-normalized Unicode names.
  character(len=*), intent(in) :: name
  !! NetCDF local name to validate; trailing Fortran blank padding is ignored.
  character(len=*), intent(in) :: context
  !! Operation name for diagnostics, without brackets.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when absent.
  type(error_type) :: op_err
  character(len=:), allocatable :: ctx
  integer :: i, j, n, byte, ncont, lo, hi

  ctx = validation_context(context)
  op_err = error_type(NC_EBADNAME, ctx, "Invalid NetCDF name.")
  n = len_trim(name)
  if (n == 0) then
    call return_err(op_err, err)
    return
  end if
  if (n > NC_MAX_NAME) then
    op_err = error_type(NC_EMAXNAME, ctx, &
      & "NetCDF name exceeds NC_MAX_NAME bytes.")
    call return_err(op_err, err)
    return
  end if
  byte = iachar(name(1:1))
  if (byte < 128) then
    if (index("ABCDEFGHIJKLMNOPQRSTUVWXYZ"// &
      & "abcdefghijklmnopqrstuvwxyz0123456789_", name(1:1)) == 0) then
      call return_err(op_err, err)
      return
    end if
  end if
  i = 1
  do while (i <= n)
    byte = iachar(name(i:i))
    if (byte < 128) then
      if (byte < 32 .or. byte == 127 .or. name(i:i) == "/") then
        call return_err(op_err, err)
        return
      end if
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
      call return_err(op_err, err)
      return
    end select
    if (i + ncont > n) then
      call return_err(op_err, err)
      return
    end if
    byte = iachar(name(i + 1:i + 1))
    if (byte < lo .or. byte > hi) then
      call return_err(op_err, err)
      return
    end if
    do j = i + 2, i + ncont
      byte = iachar(name(j:j))
      if (byte < 128 .or. byte > 191) then
        call return_err(op_err, err)
        return
      end if
    end do
    i = i + ncont + 1
  end do
  op_err = error_type()
  call return_err(op_err, err)
end subroutine validate_nc_name

pure module subroutine validate_att(att, dtype, context, err)
  !! Validate an attribute's metadata and active byte storage.
  type(attribute_type), intent(in) :: att
  !! Attribute to process.
  integer(data_type), intent(in), optional :: dtype
  !! Dataset data type code to validate or translate.
  character(len=*), intent(in) :: context
  !! Context included in a validation or error message.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when absent.
  type(error_type) :: op_err
  integer(int64) :: ptr_size

  ptr_size = 0
  if (associated(att%ptr)) ptr_size = size(att%ptr, kind=int64)
  call validate_(att%dtype, att%len, att%buffer, &
    & associated(att%ptr), ptr_size, dtype, &
    & validation_context(context), "Attribute", op_err)
  call return_err(op_err, err)
end subroutine validate_att

pure module subroutine validate_var(var, dtype, rank, context, err)
  !! Validate a variable's metadata and active byte storage.
  type(variable_type), intent(in) :: var
  !! Variable to process.
  integer(data_type), intent(in), optional :: dtype
  !! Dataset data type code to validate or translate.
  integer, intent(in), optional :: rank
  !! Expected number of variable dimensions.
  character(len=*), intent(in) :: context
  !! Context included in a validation or error message.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when absent.
  type(error_type) :: op_err
  character(len=:), allocatable :: ctx
  integer(int64) :: ptr_size, nelems

  ctx = validation_context(context)
  if (.not. allocated(var%dims)) then
    op_err = error_type(NC_EINVAL, ctx, &
      & "Variable dimensions are not allocated.")
    call return_err(op_err, err)
    return
  end if
  if (present(rank)) then
    if (rank > 1 .and. size(var%dims) /= rank) then
      op_err = error_type(NC_EINVAL, ctx, "Unexpected variable rank.")
      call return_err(op_err, err)
      return
    end if
  end if

  call compute_size(var, nelems, op_err)
  if (.exists. op_err) then
    op_err%fname = ctx
    call return_err(op_err, err)
    return
  end if
  if (nelems /= var%len) then
    op_err = error_type(NC_EINVAL, ctx, &
      & "Dimension product differs from length.")
    call return_err(op_err, err)
    return
  end if

  ptr_size = 0
  if (associated(var%ptr)) ptr_size = size(var%ptr, kind=int64)
  call validate_(var%dtype, var%len, var%buffer, &
    & associated(var%ptr), ptr_size, dtype, ctx, "Variable", op_err)
  call return_err(op_err, err)
end subroutine validate_var

pure subroutine validate_(idtype, ilen, ibuffer, iassoc, &
  & ptr_size, dtype, context, type_context, err)
  !! Validate common data-type, length, and byte-storage invariants.
  integer(data_type), intent(in) :: idtype
  !! Stored NetCDF data type.
  integer(int64), intent(in) :: ilen
  !! Stored element count.
  integer(int8), allocatable, intent(in) :: ibuffer(:)
  !! Owned byte storage.
  logical, intent(in) :: iassoc
  !! Whether borrowed byte storage is associated.
  integer(int64), intent(in) :: ptr_size
  !! Capacity of borrowed byte storage in bytes.
  integer(data_type), intent(in), optional :: dtype
  !! Expected NetCDF data type.
  character(len=*), intent(in) :: context
  !! Validation operation context.
  character(len=*), intent(in) :: type_context
  !! Data-model type used in diagnostics.
  type(error_type), intent(out) :: err
  !! Completed validation result.
  integer :: nbytes

  err = error_type()
  if (present(dtype)) then
    if (idtype /= dtype) then
      err = error_type(NC_EINVAL, context, &
        & "Unexpected "//trim(type_context)//" type.")
      return
    end if
  end if
  if (ilen < 0) then
    err = error_type(NC_EINVAL, context, &
      & "Negative "//trim(type_context)//" length.")
    return
  end if
  call compute_buffer_size(idtype, ilen, nbytes, err)
  if (.exists. err) then
    err%fname = context
    return
  end if
  if (allocated(ibuffer)) then
    if (iassoc) then
      err = error_type(NC_EINVAL, context, &
        & trim(type_context)//" has both owned and borrowed buffers.")
      return
    end if
    if (size(ibuffer, kind=int64) < int(nbytes, int64)) then
      err = error_type(NC_EINVAL, context, &
        & trim(type_context)//" buffer is too small.")
      return
    end if
  else if (nbytes > 0) then
    if (.not. iassoc) then
      err = error_type(NC_EINVAL, context, &
        & trim(type_context)//" buffer is not associated.")
      return
    end if
    if (ptr_size < int(nbytes, int64)) then
      err = error_type(NC_EINVAL, context, &
        & trim(type_context)//" buffer is too small.")
      return
    end if
  end if
end subroutine validate_

pure function validation_context(context) result(ctx)
  character(len=*), intent(in) :: context
  character(len=:), allocatable :: ctx
  integer :: nchars

  ctx = trim(adjustl(context))
  nchars = len(ctx)
  if (nchars >= 2) then
    if (ctx(1:1) == "[" .and. ctx(nchars:nchars) == "]") then
      ctx = trim(adjustl(ctx(2:nchars - 1)))
    end if
  end if
  if (len(ctx) == 0) ctx = "validate"
end function validation_context

module function buffer2cptr_att(att) result(cptr)
  !! Return the C address of an attribute's active byte storage.
  type(attribute_type), target, intent(in) :: att
  !! Attribute to process.
  type(c_ptr) :: cptr
  !! C pointer to the requested byte buffer.

  call validate(att, context="[buffer2cptr_att]")
  cptr = buffer2cptr_(att%len, att%buffer, att%ptr)
end function buffer2cptr_att

module function buffer2cptr_var(var) result(cptr)
  !! Return the C address of a variable's active byte storage.
  type(variable_type), target, intent(in) :: var
  !! Variable to process.
  type(c_ptr) :: cptr
  !! C pointer to the requested byte buffer.

  call validate(var, context="[buffer2cptr_var]")
  cptr = buffer2cptr_(var%len, var%buffer, var%ptr)
end function buffer2cptr_var

function buffer2cptr_(ilen, ibuffer, iptr) result(cptr)
  !! Return the C address of active owned or borrowed byte storage.
  integer(int64), intent(in) :: ilen
  !! Number of stored elements.
  integer(int8), allocatable, target, intent(in) :: ibuffer(:)
  !! Owned byte storage.
  integer(int8), contiguous, pointer, intent(in) :: iptr(:)
  !! Borrowed byte storage.
  type(c_ptr) :: cptr
  !! C address of the active storage.

  if (ilen == 0) then
    cptr = c_null_ptr
    return
  end if
  if (allocated(ibuffer)) then
    cptr = c_loc(ibuffer(1))
  else
    cptr = c_loc(iptr(1))
  end if
end function buffer2cptr_

end submodule nc4f_ds_validate
