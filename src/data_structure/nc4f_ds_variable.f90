submodule(nc4f_ds) nc4f_ds_variable
!! Variable construction, renaming, inquiry, and equality for the direct v2 data model.
implicit none (type, external)
contains

pure module subroutine rename_var_var(var, new_name, err)
  !! Rename an independent variable in memory; preserve its metadata and storage.
  type(variable_type), intent(inout) :: var
  !! Variable whose local name is changed; its metadata and storage are preserved.
  character(len=*), intent(in) :: new_name
  !! Replacement local name; trailing Fortran blank padding is removed.
  type(error_type), intent(out), optional :: err
  !! Receives the status and diagnostic; failures stop execution when omitted.
  type(error_type) :: op_err
  character(len=:), allocatable :: name

  call check_nc_name(new_name, op_err, "rename_variable")
  if (op_err%code == NC_NOERR) then
    name = trim(new_name)
    call move_alloc(name, var%name)
  end if
  call return_err(op_err, err)
end subroutine rename_var_var

pure module subroutine rename_var_grp(grp, old_name, new_name, err)
  !! Rename a direct member of grp%vars in memory, without accessing a file.
  class(group_type), intent(inout) :: grp
  !! Group whose direct variable collection contains the name to change.
  character(len=*), intent(in) :: old_name, new_name
  !! old_name: Existing local name to locate.
  !! new_name: Replacement local name; trailing Fortran blank padding is removed.
  type(error_type), intent(out), optional :: err
  !! Receives the status and diagnostic; failures stop execution when omitted.
  type(error_type) :: op_err

  call rename_vars_(grp%vars, old_name, new_name, op_err)
  call return_err(op_err, err)
end subroutine rename_var_grp

pure subroutine rename_vars_(vars, old_name, new_name, err)
  !! Rename one direct member without copying data or following child groups.
  type(variable_type), allocatable, intent(inout) :: vars(:)
  !! Direct variable collection whose matching entry is renamed.
  character(len=*), intent(in) :: old_name, new_name
  !! old_name: Existing local name to locate.
  !! new_name: Replacement local name; trailing Fortran blank padding is removed.
  type(error_type), intent(out) :: err
  !! Receives the operation status and diagnostic message.
  integer :: i, pos, lo

  call check_nc_name(old_name, err, "rename_variable")
  if (err%code /= NC_NOERR) return
  call check_nc_name(new_name, err, "rename_variable")
  if (err%code /= NC_NOERR) return
  pos = 0
  lo = 1
  if (allocated(vars)) then
    lo = lbound(vars, 1)
    do i = 1, size(vars)
      if (.not. allocated(vars(lo + i - 1)%name)) cycle
      if (vars(lo + i - 1)%name /= trim(old_name)) cycle
      if (pos /= 0) then
        err = error_type(NC_EINVAL, "rename_variable", &
          & "Ambiguous duplicate variable: "//trim(old_name))
        return
      end if
      pos = i
    end do
  end if
  if (pos == 0) then
    err = error_type(NC_ENOTVAR, "rename_variable", &
      & "Variable not found: "//trim(old_name))
    return
  end if
  do i = 1, size(vars)
    if (i == pos .or. .not. allocated(vars(lo + i - 1)%name)) cycle
    if (vars(lo + i - 1)%name == trim(new_name)) then
      err = error_type(NC_ENAMEINUSE, "rename_variable", &
        & "Variable name already in use: "//trim(new_name))
      return
    end if
  end do
  if (trim(old_name) == trim(new_name)) return
  call rename_var_var(vars(lo + pos - 1), new_name, err)
end subroutine rename_vars_

module subroutine init_var_mold(var, name, mold, atts, deep)
  !! Initialize a variable from a name and existing shape/type metadata.
  type(variable_type), intent(inout) :: var
  !! Variable to process.
  character(len=*), intent(in) :: name
  !! Name for the new variable.
  type(variable_type), target, intent(in) :: mold
  !! Source metadata and storage to copy or borrow according to DEEP.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Optional attributes for the new variable.
  logical, intent(in), optional :: deep
  !! Whether to allocate an owning data buffer or borrow the mold's storage.
  logical :: deep_copy

  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (present(atts)) then
    call init_var_(var, name, mold%dtype, mold%len, mold%dims, atts, deep_copy)
  else
    if (allocated(var%atts)) deallocate (var%atts)
    call init_var_(var, name, mold%dtype, mold%len, mold%dims, deep=deep_copy)
  end if
  if (.not. deep_copy .and. mold%len > 0) then
    if (allocated(mold%buffer)) then
      var%ptr => mold%buffer
    else if (associated(mold%ptr)) then
      var%ptr => mold%ptr
    else
      error stop "[init_var_mold] Mold has no storage."
    end if
  end if
end subroutine init_var_mold

pure module function get_size(var, dim) result(n)
  !! Return the element count of a variable or one of its dimensions.
  type(variable_type), intent(in) :: var
  !! Variable to process.
  integer, intent(in), optional :: dim
  !! Dimension to process.
  integer(int64) :: n
  !! Result produced by this operation.
  integer :: dim_, i

  if (.not. allocated(var%dims)) error stop &
    & "[size] Variable dimensions are not allocated."
  dim_ = 0
  if (present(dim)) dim_ = dim

  select case (dim_)
  case (0)
    n = 1_int64
    do i = 1, size(var%dims)
      if (var%dims(i)%len < 0) error stop "[size] Negative dimension length."
      if (var%dims(i)%len /= 0) then
        if (n > huge(n)/var%dims(i)%len) then
          error stop "[size] Dimension product overflow."
        end if
      end if
      n = n*var%dims(i)%len
    end do
  case (1:)
    if (dim_ > size(var%dims)) error stop "[size] Invalid dimension index."
    n = var%dims(size(var%dims) - dim_ + 1)%len
    if (n < 0) error stop "[size] Negative dimension length."
  case default
    error stop "[size] Invalid dimension index."
  end select
end function get_size

pure module function get_shape(var) result(extents)
  !! Return variable dimension lengths in their stored Fortran order.
  type(variable_type), intent(in) :: var
  !! Variable to process.
  integer, allocatable :: extents(:)
  !! Result produced by this operation.
  integer :: i

  if (.not. allocated(var%dims)) error stop &
    & "[shape] Variable dimensions are not allocated."
  allocate (extents(size(var%dims)))
  do i = 1, size(var%dims)
    if (var%dims(i)%len > int(huge(extents(i)), int64)) then
      error stop "[shape] Dimension length exceeds default integer range."
    end if
    extents(i) = int(var%dims(i)%len)
  end do
end function get_shape

logical elemental module function eq_var(x, y) result(is_equal)
  !! Return true when two variables have identical metadata and byte values.
  type(variable_type), intent(in) :: x, y
  !! x: Left-hand value to compare.
  !! y: Right-hand value to compare.

  call validate(x, context="[eq_var]")
  call validate(y, context="[eq_var]")
  is_equal = x%dtype == y%dtype .and. x%len == y%len
  if (.not. is_equal) return

  is_equal = allocated(x%name) .eqv. allocated(y%name)
  if (.not. is_equal) return
  if (allocated(x%name)) then
    is_equal = x%name == y%name
    if (.not. is_equal) return
  end if

  is_equal = allocated(x%dims) .eqv. allocated(y%dims)
  if (.not. is_equal) return
  if (allocated(x%dims)) then
    is_equal = size(x%dims) == size(y%dims)
    if (.not. is_equal) return
    is_equal = all(x%dims == y%dims)
    if (.not. is_equal) return
  end if

  is_equal = allocated(x%atts) .eqv. allocated(y%atts)
  if (.not. is_equal) return
  if (allocated(x%atts)) then
    is_equal = size(x%atts) == size(y%atts)
    if (.not. is_equal) return
    is_equal = all(x%atts == y%atts)
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
end function eq_var

logical elemental module function neq_var(x, y) result(is_equal)
  !! Return true when two variables differ.
  type(variable_type), intent(in) :: x, y
  !! x: Left-hand value to compare.
  !! y: Right-hand value to compare.

  is_equal = .not. eq_var(x, y)
end function neq_var

end submodule nc4f_ds_variable
