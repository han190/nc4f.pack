submodule(nc4f_data_struct) nc4f_data_struct_att
implicit none (type, external)
contains

!> Initialize `att` from an attribute mold, allocating its buffer.
module pure subroutine alloc_att_mold(att, mold)
  !> Attribute to allocate and initialize.
  type(attribute_type), intent(inout) :: att
  !> Mold attribute providing metadata to copy.
  type(attribute_type), intent(in) :: mold

  call alloc_att_meta(att, mold%name, mold%dtype, mold%len)
end subroutine alloc_att_mold

!> Initialize attribute metadata and allocate its buffer.
module pure subroutine alloc_att_meta(att, name, dtype, len)
  !> Attribute to initialize.
  type(attribute_type), intent(inout) :: att
  !> Name to assign to the attribute.
  character(len=*), intent(in) :: name
  !> NetCDF data type code (NC_* constant) for the attribute.
  integer(int32), intent(in) :: dtype
  !> Number of elements for the attribute.
  integer(int64), intent(in) :: len

  att%name = name
  att%dtype = dtype
  att%len = len
  call alloc_att_buf(att)
end subroutine alloc_att_meta

!> Allocate or resize the attribute's data buffer based on its type.
module pure subroutine alloc_att_buf(att)
  !> Attribute whose buffer will be allocated or resized.
  type(attribute_type), intent(inout) :: att
  !> Calculated buffer size in bytes.
  integer(int64) :: buffer_size

  !> Assume that `att%dtype` and `att%len` are properly initialized.
  buffer_size = get_buffer_size(att%dtype, att%len)
  if (allocation_required(att%buffer, buffer_size)) then
    if (allocated(att%buffer)) deallocate (att%buffer)
    allocate (att%buffer(buffer_size))
  end if
end subroutine alloc_att_buf

!> Return true when two `attribute_type` values are identical.
module elemental logical function eq_att(x, y) result(res)
  !> Left-hand attribute to compare.
  type(attribute_type), intent(in) :: x
  !> Right-hand attribute to compare.
  type(attribute_type), intent(in) :: y

  res = x%name == y%name .and. x%dtype == y%dtype .and. &
    & x%len == y%len .and. all(x%buffer == y%buffer)
end function eq_att

!> Return true when two `attribute_type` values differ.
module elemental logical function neq_att(x, y) result(res)
  !> Left-hand attribute to compare.
  type(attribute_type), intent(in) :: x
  !> Right-hand attribute to compare.
  type(attribute_type), intent(in) :: y

  res = x%name /= y%name .or. x%dtype /= y%dtype .or. &
    & x%len /= y%len .or. any(x%buffer /= y%buffer)
end function neq_att

end submodule nc4f_data_struct_att
