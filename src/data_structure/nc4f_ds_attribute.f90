submodule(nc4f_ds) nc4f_ds_attribute
!! Attribute construction, deletion, renaming, and equality for the direct v2
!! data model.
implicit none (type, external)
contains

pure module subroutine del_att_var(var, name, err)
  !! Remove a named attribute from the supplied model without accessing a file.
  type(variable_type), intent(inout) :: var
  !! Owner whose attribute collection is reduced, preserving survivor order and storage.
  character(len=*), intent(in) :: name
  !! Local attribute name; trailing Fortran padding is ignored.
  type(error_type), intent(out), optional :: err
  !! Receives status and diagnostic; failures stop execution when omitted.
  type(error_type) :: op_err

  call del_atts_(var%atts, name, op_err)
  call return_err(op_err, err)
end subroutine del_att_var

pure module subroutine del_att_grp(grp, name, err)
  !! Remove a named attribute from the supplied model without accessing a file.
  class(group_type), intent(inout) :: grp
  !! Owner whose attribute collection is reduced, preserving survivor order and storage.
  character(len=*), intent(in) :: name
  !! Local attribute name; trailing Fortran padding is ignored.
  type(error_type), intent(out), optional :: err
  !! Receives status and diagnostic; failures stop execution when omitted.
  type(error_type) :: op_err

  call del_atts_(grp%atts, name, op_err)
  call return_err(op_err, err)
end subroutine del_att_grp

pure subroutine del_atts_(atts, name, err)
  !! Remove one matching entry, moving owned storage and retaining borrowed pointers.
  type(attribute_type), allocatable, intent(inout) :: atts(:)
  !! Collection to reduce; deleting its last entry leaves an allocated empty array.
  character(len=*), intent(in) :: name
  !! Local name of the attribute to remove.
  type(error_type), intent(out) :: err
  !! Receives validation or allocation failure; the collection is unchanged on failure.
  type(attribute_type), allocatable :: kept(:)
  integer :: i, j, pos, matches, stat

  call check_nc_name(name, err, "[delete_attribute]")
  if (err%code /= NC_NOERR) return
  matches = 0
  pos = 0
  if (allocated(atts)) then
    do i = lbound(atts, 1), ubound(atts, 1)
      if (.not. allocated(atts(i)%name)) cycle
      if (atts(i)%name /= trim(name)) cycle
      matches = matches + 1
      pos = i
    end do
  end if
  if (matches == 0) then
    err = error_type(NC_ENOTATT, "[delete_attribute] Attribute not found: "//trim(name))
    return
  else if (matches > 1) then
    err = error_type(NC_EINVAL, "[delete_attribute] Ambiguous duplicate attribute: "//trim(name))
    return
  end if
  allocate (kept(size(atts) - 1), stat=stat)
  if (stat /= 0) then
    err = error_type(NC_ENOMEM, "[delete_attribute] Cannot allocate reduced attribute collection.")
    return
  end if
  j = 0
  do i = lbound(atts, 1), ubound(atts, 1)
    if (i == pos) cycle
    j = j + 1
    kept(j)%id = atts(i)%id
    kept(j)%dtype = atts(i)%dtype
    kept(j)%len = atts(i)%len
    call move_alloc(atts(i)%name, kept(j)%name)
    call move_alloc(atts(i)%buffer, kept(j)%buffer)
    kept(j)%ptr => atts(i)%ptr
  end do
  call move_alloc(kept, atts)
end subroutine del_atts_

pure module subroutine rename_att_att(att, new_name, err)
  !! Rename an independent attribute in memory; no file is accessed.
  type(attribute_type), intent(inout) :: att
  !! Attribute whose local name is changed.
  character(len=*), intent(in) :: new_name
  !! Replacement local name; trailing Fortran blank padding is removed.
  type(error_type), intent(out), optional :: err
  !! Receives the status and diagnostic; failures stop execution when omitted.
  type(error_type) :: op_err
  character(len=:), allocatable :: name

  call check_nc_name(new_name, op_err, "[rename_attribute]")
  if (op_err%code == NC_NOERR) then
    name = trim(new_name)
    call move_alloc(name, att%name)
  end if
  call return_err(op_err, err)
end subroutine rename_att_att

pure module subroutine rename_att_var(var, old_name, new_name, err)
  !! Rename a variable attribute in memory, preserving its value and storage.
  type(variable_type), intent(inout) :: var
  !! Variable whose matching attribute is renamed; its data and own name are preserved.
  character(len=*), intent(in) :: old_name, new_name
  !! old_name: Existing local name to locate.
  !! new_name: Replacement local name; trailing Fortran blank padding is removed.
  type(error_type), intent(out), optional :: err
  !! Receives the status and diagnostic; failures stop execution when omitted.
  type(error_type) :: op_err

  call rename_atts_(var%atts, old_name, new_name, op_err)
  call return_err(op_err, err)
end subroutine rename_att_var

pure module subroutine rename_att_grp(grp, old_name, new_name, err)
  !! Rename a group/global attribute in memory, without accessing a file.
  class(group_type), intent(inout) :: grp
  !! Group whose matching global attribute is renamed.
  character(len=*), intent(in) :: old_name, new_name
  !! old_name: Existing local name to locate.
  !! new_name: Replacement local name; trailing Fortran blank padding is removed.
  type(error_type), intent(out), optional :: err
  !! Receives the status and diagnostic; failures stop execution when omitted.
  type(error_type) :: op_err

  call rename_atts_(grp%atts, old_name, new_name, op_err)
  call return_err(op_err, err)
end subroutine rename_att_grp

pure subroutine rename_atts_(atts, old_name, new_name, err)
  !! Rename one array entry without copying or changing attribute storage.
  type(attribute_type), allocatable, intent(inout) :: atts(:)
  !! Attribute collection whose matching entry is renamed.
  character(len=*), intent(in) :: old_name, new_name
  !! old_name: Existing local name to locate.
  !! new_name: Replacement local name; trailing Fortran blank padding is removed.
  type(error_type), intent(out) :: err
  !! Receives the operation status and diagnostic message.
  integer :: i, pos

  call check_nc_name(old_name, err, "[rename_attribute]")
  if (err%code /= NC_NOERR) return
  call check_nc_name(new_name, err, "[rename_attribute]")
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
  !! Source metadata and storage to copy or borrow according to DEEP.
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
  !! x: Left-hand value to compare.
  !! y: Right-hand value to compare.

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
  !! x: Left-hand value to compare.
  !! y: Right-hand value to compare.

  is_equal = .not. eq_att(x, y)
end function neq_att

end submodule nc4f_ds_attribute
