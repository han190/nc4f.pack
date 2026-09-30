!> Variable construction, inquiry, and equality for the direct v2 data model.
submodule(nc4f_ds) nc4f_ds_variable
implicit none (type, external)
contains

!> Initialize a variable from a name and existing shape/type metadata.
module subroutine init_var_mold(var, name, mold, atts, deep)
  !> Variable to process.
  type(variable_type), intent(inout) :: var
  !> Name for the new variable.
  character(len=*), intent(in) :: name
  !> Data or metadata used by this operation.
  type(variable_type), target, intent(in) :: mold
  !> Optional attributes for the new variable.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Whether to allocate an owning data buffer or borrow the mold's storage.
  logical, intent(in), optional :: deep
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

!> Return the element count of a variable or one of its dimensions.
pure module function get_size(var, dim) result(n)
  !> Variable to process.
  type(variable_type), intent(in) :: var
  !> Dimension to process.
  integer, intent(in), optional :: dim
  !> Result produced by this operation.
  integer(int64) :: n
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

!> Return variable dimension lengths in their stored Fortran order.
pure module function get_shape(var) result(extents)
  !> Variable to process.
  type(variable_type), intent(in) :: var
  !> Result produced by this operation.
  integer, allocatable :: extents(:)
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

!> Return true when two variables have identical metadata and byte values.
logical elemental module function eq_var(x, y) result(is_equal)
  !> Dataset objects or values used by this operation.
  type(variable_type), intent(in) :: x, y

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

!> Return true when two variables differ.
logical elemental module function neq_var(x, y) result(is_equal)
  !> Dataset objects or values used by this operation.
  type(variable_type), intent(in) :: x, y

  is_equal = .not. eq_var(x, y)
end function neq_var

end submodule nc4f_ds_variable
