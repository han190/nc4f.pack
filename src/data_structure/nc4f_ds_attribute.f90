submodule(nc4f_ds) nc4f_ds_attribute
!! Attribute construction, renaming, and equality for the direct v2 data model.
implicit none (type, external)
contains

pure module subroutine rename_att_att(att, new_name, err)
  type(attribute_type), intent(inout) :: att
  character(len=*), intent(in) :: new_name
  type(error_type), intent(out), optional :: err
  type(error_type) :: op_err
  character(len=:), allocatable :: name

  call chk_nc_name(new_name, op_err, "[rename_attribute]")
  if (op_err%code == NC_NOERR) then
    name = trim(new_name)
    call move_alloc(name, att%name)
  end if
  call ret_ds_err(op_err, err)
end subroutine rename_att_att

pure module subroutine rename_att_var(var, old_name, new_name, err)
  type(variable_type), intent(inout) :: var
  character(len=*), intent(in) :: old_name, new_name
  type(error_type), intent(out), optional :: err
  type(error_type) :: op_err

  call rename_atts_(var%atts, old_name, new_name, op_err)
  call ret_ds_err(op_err, err)
end subroutine rename_att_var

pure module subroutine rename_att_grp(grp, old_name, new_name, err)
  class(group_type), intent(inout) :: grp
  character(len=*), intent(in) :: old_name, new_name
  type(error_type), intent(out), optional :: err
  type(error_type) :: op_err

  call rename_atts_(grp%atts, old_name, new_name, op_err)
  call ret_ds_err(op_err, err)
end subroutine rename_att_grp

pure subroutine rename_atts_(atts, old_name, new_name, err)
  !! Rename one array entry without copying or changing attribute storage.
  type(attribute_type), allocatable, intent(inout) :: atts(:)
  character(len=*), intent(in) :: old_name, new_name
  type(error_type), intent(out) :: err
  integer :: i, pos

  call chk_nc_name(old_name, err, "[rename_attribute]")
  if (err%code /= NC_NOERR) return
  call chk_nc_name(new_name, err, "[rename_attribute]")
  if (err%code /= NC_NOERR) return
  pos = 0
  if (allocated(atts)) then
    do i = 1, size(atts)
      if (.not. allocated(atts(i)%name)) cycle
      if (atts(i)%name /= trim(old_name)) cycle
      if (pos /= 0) then
        err = error_type(NC_EINVAL, "[rename_attribute]"// &
          & " Ambiguous duplicate attribute: "//trim(old_name))
        return
      end if
      pos = i
    end do
  end if
  if (pos == 0) then
    err = error_type(NC_ENOTATT, "[rename_attribute]"// &
      & " Attribute not found: "//trim(old_name))
    return
  end if
  do i = 1, size(atts)
    if (i == pos .or. .not. allocated(atts(i)%name)) cycle
    if (atts(i)%name == trim(new_name)) then
      err = error_type(NC_ENAMEINUSE, "[rename_attribute]"// &
        & " Attribute name already in use: "//trim(new_name))
      return
    end if
  end do
  if (trim(old_name) == trim(new_name)) return
  call rename_att_att(atts(pos), new_name, err)
end subroutine rename_atts_

module subroutine init_att_mold(att, name, mold, deep)
  !! Initialize an attribute from a name and existing value metadata.
  !! Must remain impure: shallow construction exposes the intent(in) mold's storage.
  type(attribute_type), intent(inout) :: att
  !! Attribute to process.
  character(len=*), intent(in) :: name
  !! Name for the new attribute.
  type(attribute_type), target, intent(in) :: mold
  !! Data or metadata used by this operation.
  logical, intent(in), optional :: deep
  !! Whether to allocate an owning data buffer or borrow the mold's storage.
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

logical elemental module function eq_att(x, y) result(is_equal)
  !! Return true when two attributes have identical metadata and byte values.
  type(attribute_type), intent(in) :: x, y
  !! Dataset objects or values used by this operation.

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

logical elemental module function neq_att(x, y) result(is_equal)
  !! Return true when two attributes differ.
  type(attribute_type), intent(in) :: x, y
  !! Dataset objects or values used by this operation.

  is_equal = .not. eq_att(x, y)
end function neq_att

end submodule nc4f_ds_attribute
