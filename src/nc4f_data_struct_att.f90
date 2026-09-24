!> Attribute construction and equality for the direct v2 data model.
submodule(nc4f_data_struct) nc4f_data_struct_att
implicit none (type, external)
contains

!> Initialize an owning attribute from a name and existing value metadata.
module subroutine init_att_mold(att, name, mold)
  !> Input/output argument: `att`.
  type(attribute_type), intent(inout) :: att
  !> Name for the new attribute.
  character(len=*), intent(in) :: name
  !> Input argument: `mold`.
  type(attribute_type), intent(in) :: mold

  call init_att(att, name, mold%dtype, mold%len)
end subroutine init_att_mold

!> Return true when two attributes have identical metadata and byte values.
module elemental logical function eq_att(x, y) result(is_equal)
  !> Input arguments: `x` and `y`.
  type(attribute_type), intent(in) :: x, y

  call validate(x, context="[eq_att]")
  call validate(y, context="[eq_att]")
  is_equal = x%dtype == y%dtype .and. x%len == y%len
  if (.not. is_equal) return

  is_equal = allocated(x%name) .eqv. allocated(y%name)
  if (.not. is_equal) return
  if (allocated(x%name)) then
    is_equal = x%name == y%name
    if (.not. is_equal) return
  end if

  if (x%len == 0) return

  if (allocated(x%buffer)) then
    if (allocated(y%buffer)) then
      is_equal = size(x%buffer) == size(y%buffer)
      if (is_equal) is_equal = all(x%buffer == y%buffer)
    else if (associated(y%ptr)) then
      is_equal = size(x%buffer) == size(y%ptr)
      if (is_equal) is_equal = all(x%buffer == y%ptr)
    else
      is_equal = .false.
    end if
  else if (associated(x%ptr)) then
    if (allocated(y%buffer)) then
      is_equal = size(x%ptr) == size(y%buffer)
      if (is_equal) is_equal = all(x%ptr == y%buffer)
    else if (associated(y%ptr)) then
      is_equal = size(x%ptr) == size(y%ptr)
      if (is_equal) is_equal = all(x%ptr == y%ptr)
    else
      is_equal = .false.
    end if
  else
    is_equal = .false.
  end if
end function eq_att

!> Return true when two attributes differ.
module elemental logical function neq_att(x, y) result(is_equal)
  !> Input arguments: `x` and `y`.
  type(attribute_type), intent(in) :: x, y

  is_equal = .not. eq_att(x, y)
end function neq_att

end submodule nc4f_data_struct_att
