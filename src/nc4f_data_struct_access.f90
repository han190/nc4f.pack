!> Shared validation for data-model storage and metadata.
submodule(nc4f_data_struct) nc4f_data_struct_access
implicit none (type, external)
contains

!> Validate an attribute's metadata and active byte storage.
pure module subroutine validate_att(att, dtype, context)
  !> Input argument: `att`.
  type(attribute_type), intent(in) :: att
  !> Input argument: `dtype`.
  integer(data_type), intent(in), optional :: dtype
  !> Input argument: `context`.
  character(len=*), intent(in) :: context
  integer :: nbytes

  if (present(dtype)) then
    if (att%dtype /= dtype) error stop trim(context)// &
      & " Unexpected attribute type."
  end if
  if (att%len < 0) error stop trim(context)//" Negative attribute length."
  nbytes = buffer_size(att%dtype, att%len, context)
  if (allocated(att%buffer)) then
    if (associated(att%ptr)) error stop trim(context)// &
      & " Attribute has both owned and borrowed buffers."
    if (size(att%buffer, kind=int64) < int(nbytes, int64)) then
      error stop trim(context)//" Attribute buffer is too small."
    end if
  else
    if (nbytes > 0) then
      if (.not. associated(att%ptr)) then
        error stop trim(context)//" Attribute buffer is not associated."
      end if
      if (size(att%ptr, kind=int64) < int(nbytes, int64)) then
        error stop trim(context)//" Attribute buffer is too small."
      end if
    end if
  end if
end subroutine validate_att

!> Validate a variable's metadata and active byte storage.
pure module subroutine validate_var(var, dtype, rank, context)
  !> Input argument: `var`.
  type(variable_type), intent(in) :: var
  !> Input argument: `dtype`.
  integer(data_type), intent(in), optional :: dtype
  !> Input argument: `rank`.
  integer, intent(in), optional :: rank
  !> Input argument: `context`.
  character(len=*), intent(in) :: context
  integer :: nbytes

  if (present(dtype)) then
    if (var%dtype /= dtype) error stop trim(context)//" Unexpected variable type."
  end if
  if (.not. allocated(var%dims)) error stop &
    & trim(context)//" Variable dimensions are not allocated."
  if (present(rank)) then
    if (rank > 1 .and. size(var%dims) /= rank) then
      error stop trim(context)//" Unexpected variable rank."
    end if
  end if

  if (size(var) /= var%len) error stop &
    & trim(context)//" Dimension product differs from length."

  nbytes = buffer_size(var%dtype, var%len, context)
  if (allocated(var%buffer)) then
    if (associated(var%ptr)) error stop trim(context)// &
      & " Variable has both owned and borrowed buffers."
    if (size(var%buffer, kind=int64) < int(nbytes, int64)) then
      error stop trim(context)//" Variable buffer is too small."
    end if
  else
    if (nbytes > 0) then
      if (.not. associated(var%ptr)) then
        error stop trim(context)//" Variable buffer is not associated."
      end if
      if (size(var%ptr, kind=int64) < int(nbytes, int64)) then
        error stop trim(context)//" Variable buffer is too small."
      end if
    end if
  end if
end subroutine validate_var

!> Validate capacity of a pointer-backed raw byte buffer.
module subroutine validate_buffer(buffer, bytes, name, context)
  !> Input argument: `buffer`.
  integer(int8), pointer, contiguous, intent(in) :: buffer(:)
  !> Input argument: `bytes`.
  integer(int64), intent(in) :: bytes
  !> Input argument: `name`.
  character(len=*), intent(in) :: name
  !> Input argument: `context`.
  character(len=*), intent(in) :: context

  if (bytes == 0) return
  if (.not. associated(buffer)) then
    error stop trim(context)//" "//name//" buffer is not associated."
  end if
  if (size(buffer, kind=int64) < bytes) then
    error stop trim(context)//" "//name//" buffer is too small."
  end if
end subroutine validate_buffer

!> Return the C address of an attribute's active byte storage.
module function get_att_buffer_cptr(att) result(cptr)
  !> Input argument: `att`.
  type(attribute_type), target, intent(in) :: att
  !> Return value: `cptr`.
  type(c_ptr) :: cptr

  call validate(att, context="[get_att_buffer_cptr]")
  if (att%len == 0) then
    cptr = c_null_ptr
    return
  end if
  if (allocated(att%buffer)) then
    cptr = c_loc(att%buffer(1))
  else
    cptr = c_loc(att%ptr(1))
  end if
end function get_att_buffer_cptr

!> Return the C address of a variable's active byte storage.
module function get_var_buffer_cptr(var) result(cptr)
  !> Input argument: `var`.
  type(variable_type), target, intent(in) :: var
  !> Return value: `cptr`.
  type(c_ptr) :: cptr

  call validate(var, context="[get_var_buffer_cptr]")
  if (var%len == 0) then
    cptr = c_null_ptr
    return
  end if
  if (allocated(var%buffer)) then
    cptr = c_loc(var%buffer(1))
  else
    cptr = c_loc(var%ptr(1))
  end if
end function get_var_buffer_cptr

end submodule nc4f_data_struct_access
