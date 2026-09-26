!> Attribute construction and equality for the direct v2 data model.
submodule(nc4f_data_struct) nc4f_data_struct_att
implicit none (type, external)
contains

!> Initialize an attribute from a name and existing value metadata.
module subroutine init_att_mold(att, name, mold, deep)
  !> Input/output argument: `att`.
  type(attribute_type), intent(inout) :: att
  !> Name for the new attribute.
  character(len=*), intent(in) :: name
  !> Input argument: `mold`.
  type(attribute_type), target, intent(in) :: mold
  !> Whether to allocate an owning data buffer or borrow the mold's storage.
  logical, intent(in), optional :: deep
  logical :: deep_copy

  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  call init_att_(att, name, mold%dtype, mold%len, deep_copy)
  if (.not. deep_copy .and. mold%len > 0) then
    if (allocated(mold%buffer)) then
      att%ptr => mold%buffer
    else if (associated(mold%ptr)) then
      att%ptr => mold%ptr
    else
      error stop "[init_att_mold] Mold has no storage."
    end if
  end if
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
