submodule(nc4f_ds) nc4f_ds_access
!! Shared validation for data-model storage and metadata.
implicit none (type, external)
contains

pure module subroutine validate_att(att, dtype, context)
  !! Validate an attribute's metadata and active byte storage.
  type(attribute_type), intent(in) :: att
  !! Attribute to process.
  integer(data_type), intent(in), optional :: dtype
  !! Dataset data type code to validate or translate.
  character(len=*), intent(in) :: context
  !! Context included in a validation or error message.
  integer(int64) :: ptr_size

  ptr_size = 0
  if (associated(att%ptr)) ptr_size = size(att%ptr, kind=int64)
  call validate_(att%dtype, att%len, att%buffer, &
    & associated(att%ptr), ptr_size, dtype, context, "Attribute")
end subroutine validate_att

pure module subroutine validate_var(var, dtype, rank, context)
  !! Validate a variable's metadata and active byte storage.
  type(variable_type), intent(in) :: var
  !! Variable to process.
  integer(data_type), intent(in), optional :: dtype
  !! Dataset data type code to validate or translate.
  integer, intent(in), optional :: rank
  !! Expected number of variable dimensions.
  character(len=*), intent(in) :: context
  !! Context included in a validation or error message.
  integer(int64) :: ptr_size

  if (.not. allocated(var%dims)) error stop &
    & trim(context)//" Variable dimensions are not allocated."
  if (present(rank)) then
    if (rank > 1 .and. size(var%dims) /= rank) then
      error stop trim(context)//" Unexpected variable rank."
    end if
  end if

  if (size(var) /= var%len) error stop &
    & trim(context)//" Dimension product differs from length."

  ptr_size = 0
  if (associated(var%ptr)) ptr_size = size(var%ptr, kind=int64)
  call validate_(var%dtype, var%len, var%buffer, &
    & associated(var%ptr), ptr_size, dtype, context, "Variable")
end subroutine validate_var

pure subroutine validate_(idtype, ilen, ibuffer, iassoc, &
  & ptr_size, dtype, context, type_context)
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
  integer :: nbytes

  if (present(dtype)) then
    if (idtype /= dtype) error stop trim(context)//" Unexpected "// &
      & trim(type_context)//" type."
  end if
  if (ilen < 0) error stop trim(context)//" Negative "// &
    & trim(type_context)//" length."
  nbytes = buffer_size(idtype, ilen, context)
  if (allocated(ibuffer)) then
    if (iassoc) error stop trim(context)//" "// &
      & trim(type_context)//" has both owned and borrowed buffers."
    if (size(ibuffer, kind=int64) < int(nbytes, int64)) then
      error stop trim(context)//" "// &
        & trim(type_context)//" buffer is too small."
    end if
  else if (nbytes > 0) then
    if (.not. iassoc) then
      error stop trim(context)//" "// &
        & trim(type_context)//" buffer is not associated."
    end if
    if (ptr_size < int(nbytes, int64)) then
      error stop trim(context)//" "// &
        & trim(type_context)//" buffer is too small."
    end if
  end if
end subroutine validate_

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

end submodule nc4f_ds_access
