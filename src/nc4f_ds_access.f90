!> Shared validation for data-model storage and metadata.
submodule(nc4f_ds) nc4f_ds_access
implicit none (type, external)
contains

!> Validate an attribute's metadata and active byte storage.
pure module subroutine validate_att(att, dtype, context)
  !> Attribute to process.
  type(attribute_type), intent(in) :: att
  !> Dataset data type code to validate or translate.
  integer(data_type), intent(in), optional :: dtype
  !> Context included in a validation or error message.
  character(len=*), intent(in) :: context
  integer(int64) :: ptr_size

  ptr_size = 0
  if (associated(att%ptr)) ptr_size = size(att%ptr, kind=int64)
  call validate_(att%dtype, att%len, att%buffer, &
    & associated(att%ptr), ptr_size, dtype, context, "Attribute")
end subroutine validate_att

!> Validate a variable's metadata and active byte storage.
pure module subroutine validate_var(var, dtype, rank, context)
  !> Variable to process.
  type(variable_type), intent(in) :: var
  !> Dataset data type code to validate or translate.
  integer(data_type), intent(in), optional :: dtype
  !> Expected number of variable dimensions.
  integer, intent(in), optional :: rank
  !> Context included in a validation or error message.
  character(len=*), intent(in) :: context
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

!> Validate common data-type, length, and byte-storage invariants.
pure subroutine validate_(idtype, ilen, ibuffer, iassoc, &
  & ptr_size, dtype, context, type_context)
  !> Stored NetCDF data type.
  integer(data_type), intent(in) :: idtype
  !> Stored element count.
  integer(int64), intent(in) :: ilen
  !> Owned byte storage.
  integer(int8), allocatable, intent(in) :: ibuffer(:)
  !> Whether borrowed byte storage is associated.
  logical, intent(in) :: iassoc
  !> Capacity of borrowed byte storage in bytes.
  integer(int64), intent(in) :: ptr_size
  !> Expected NetCDF data type.
  integer(data_type), intent(in), optional :: dtype
  !> Validation operation context.
  character(len=*), intent(in) :: context
  !> Data-model type used in diagnostics.
  character(len=*), intent(in) :: type_context
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

!> Return the C address of an attribute's active byte storage.
module function buffer2cptr_att(att) result(cptr)
  !> Attribute to process.
  type(attribute_type), target, intent(in) :: att
  !> C pointer to the requested byte buffer.
  type(c_ptr) :: cptr

  call validate(att, context="[buffer2cptr_att]")
  cptr = buffer2cptr_(att%len, att%buffer, att%ptr)
end function buffer2cptr_att

!> Return the C address of a variable's active byte storage.
module function buffer2cptr_var(var) result(cptr)
  !> Variable to process.
  type(variable_type), target, intent(in) :: var
  !> C pointer to the requested byte buffer.
  type(c_ptr) :: cptr

  call validate(var, context="[buffer2cptr_var]")
  cptr = buffer2cptr_(var%len, var%buffer, var%ptr)
end function buffer2cptr_var

!> Return the C address of active owned or borrowed byte storage.
function buffer2cptr_(ilen, ibuffer, iptr) result(cptr)
  !> Number of stored elements.
  integer(int64), intent(in) :: ilen
  !> Owned byte storage.
  integer(int8), allocatable, target, intent(in) :: ibuffer(:)
  !> Borrowed byte storage.
  integer(int8), contiguous, pointer, intent(in) :: iptr(:)
  !> C address of the active storage.
  type(c_ptr) :: cptr

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
