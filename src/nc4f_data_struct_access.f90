!> Pointer-aware validation used by the extraction API.
submodule(nc4f_data_struct) nc4f_data_struct_access

implicit none (type, external)

contains

!> Validate an attribute before mapping its byte buffer.
module subroutine validate_att_data(att, dtype, context)
  type(attribute_type), intent(in) :: att
  integer(data_type), intent(in) :: dtype
  character(len=*), intent(in) :: context
  integer :: nbytes

  if (att%dtype /= dtype) error stop trim(context)//" Unexpected attribute type."
  if (att%len < 0) error stop trim(context)//" Negative attribute length."
  nbytes = buffer_size(att%dtype, att%len, context)
  call validate_buffer(att%buffer, int(nbytes, int64), "Attribute", context)
end subroutine validate_att_data

!> Validate a variable before mapping its byte buffer.
module subroutine validate_var_data(var, dtype, rank, context)
  type(variable_type), intent(in) :: var
  integer(data_type), intent(in) :: dtype
  integer, intent(in) :: rank
  character(len=*), intent(in) :: context
  integer :: nbytes

  if (var%dtype /= dtype) error stop trim(context)//" Unexpected variable type."
  if (.not. allocated(var%dims)) error stop trim(context)//" Variable dimensions are not allocated."
  if (rank > 1 .and. size(var%dims) /= rank) then
    error stop trim(context)//" Unexpected variable rank."
  end if

  if (size(var) /= var%len) error stop trim(context)//" Dimension product differs from length."

  nbytes = buffer_size(var%dtype, var%len, context)
  call validate_buffer(var%buffer, int(nbytes, int64), "Variable", context)
end subroutine validate_var_data

!> Validate capacity of a pointer-backed raw byte buffer.
module subroutine validate_buffer(buffer, bytes, name, context)
  integer(int8), pointer, intent(in) :: buffer(:)
  integer(int64), intent(in) :: bytes
  character(len=*), intent(in) :: name
  character(len=*), intent(in) :: context

  if (bytes == 0) return
  if (.not. associated(buffer)) then
    error stop trim(context)//" "//name//" buffer is not associated."
  end if
  if (size(buffer, kind=int64) < bytes) then
    error stop trim(context)//" "//name//" buffer is too small."
  end if
end subroutine validate_buffer

end submodule nc4f_data_struct_access
