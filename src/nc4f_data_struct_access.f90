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
  nbytes = buffer_size(att%dtype, att%len)
  if (nbytes == 0) return
  if (.not. associated(att%buffer)) error stop trim(context)//" Attribute buffer is not associated."
  if (size(att%buffer) < nbytes) error stop trim(context)//" Attribute buffer is too small."
end subroutine validate_att_data

!> Validate a variable before mapping its byte buffer.
module subroutine validate_var_data(var, dtype, rank, context)
  type(variable_type), intent(in) :: var
  integer(data_type), intent(in) :: dtype
  integer, intent(in) :: rank
  character(len=*), intent(in) :: context
  integer :: i, nbytes
  integer(int64) :: element_count

  if (var%dtype /= dtype) error stop trim(context)//" Unexpected variable type."
  if (.not. allocated(var%dims)) error stop trim(context)//" Variable dimensions are not allocated."
  if (rank > 1 .and. size(var%dims) /= rank) then
    error stop trim(context)//" Unexpected variable rank."
  end if

  element_count = 1_int64
  do i = 1, size(var%dims)
    if (var%dims(i)%len < 0) error stop trim(context)//" Negative dimension length."
    element_count = element_count * var%dims(i)%len
  end do
  if (element_count /= var%len) error stop trim(context)//" Dimension product differs from length."

  nbytes = buffer_size(var%dtype, var%len)
  if (nbytes == 0) return
  if (.not. associated(var%buffer)) error stop trim(context)//" Variable buffer is not associated."
  if (size(var%buffer) < nbytes) error stop trim(context)//" Variable buffer is too small."
end subroutine validate_var_data

!> Return variable extents in Fortran array order.
module function get_shape_(var) result(shape_)
  type(variable_type), intent(in) :: var
  integer, allocatable :: shape_(:)
  integer :: i, ndims

  if (.not. allocated(var%dims)) error stop "[get_shape_] Variable dimensions are not allocated."
  ndims = size(var%dims)
  allocate (shape_(ndims))
  do i = 1, ndims
    shape_(i) = int(var%dims(i)%len)
  end do
end function get_shape_

end submodule nc4f_data_struct_access
