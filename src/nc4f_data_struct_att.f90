!> Attribute construction and equality for the direct v2 data model.
submodule(nc4f_data_struct) nc4f_data_struct_att

implicit none (type, external)

contains

!> Initialize an owning attribute from existing attribute metadata.
module subroutine init_att_mold(att, mold)
  type(attribute_type), intent(inout) :: att
  type(attribute_type), intent(in) :: mold

  call init_att(att, mold%name, mold%dtype, mold%len)
end subroutine init_att_mold

!> Return true when two attributes have identical metadata and byte values.
module elemental logical function eq_att(x, y) result(is_equal)
  type(attribute_type), intent(in) :: x, y

  is_equal = x%dtype == y%dtype .and. x%len == y%len
  if (.not. is_equal) return

  is_equal = allocated(x%name) .eqv. allocated(y%name)
  if (.not. is_equal) return
  if (allocated(x%name)) then
    is_equal = x%name == y%name
    if (.not. is_equal) return
  end if

  is_equal = associated(x%buffer) .eqv. associated(y%buffer)
  if (.not. is_equal .or. .not. associated(x%buffer)) return
  is_equal = size(x%buffer) == size(y%buffer)
  if (is_equal) is_equal = all(x%buffer == y%buffer)
end function eq_att

!> Return true when two attributes differ.
module elemental logical function neq_att(x, y) result(is_equal)
  type(attribute_type), intent(in) :: x, y

  is_equal = .not. eq_att(x, y)
end function neq_att

end submodule nc4f_data_struct_att
