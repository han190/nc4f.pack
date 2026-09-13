!> Variable construction, inquiry, and equality for the direct v2 data model.
submodule(nc4f_data_struct) nc4f_data_struct_var

implicit none (type, external)

contains

!> Initialize an owning variable from existing variable metadata.
module subroutine init_var_mold(var, mold)
  !> Input/output argument: `var`.
  type(variable_type), intent(inout) :: var
  !> Input argument: `mold`.
  type(variable_type), intent(in) :: mold

  if (allocated(mold%atts)) then
    call init_var(var, mold%name, mold%dtype, mold%len, mold%dims, atts=mold%atts)
  else
    call init_var(var, mold%name, mold%dtype, mold%len, mold%dims)
  end if
end subroutine init_var_mold

!> Return the element count of a variable or one of its dimensions.
module pure function get_size(var, dim) result(n)
  !> Input argument: `var`.
  type(variable_type), intent(in) :: var
  !> Input argument: `dim`.
  integer, intent(in), optional :: dim
  !> Return value: `n`.
  integer(int64) :: n
  integer :: dim_, i

  if (.not. allocated(var%dims)) error stop "[size] Variable dimensions are not allocated."
  dim_ = 0
  if (present(dim)) dim_ = dim

  select case (dim_)
  case (0)
    n = 1_int64
    do i = 1, size(var%dims)
      if (var%dims(i)%len < 0) error stop "[size] Negative dimension length."
      if (var%dims(i)%len /= 0 .and. n > huge(n)/var%dims(i)%len) then
        error stop "[size] Dimension product overflow."
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
module pure function get_shape(var) result(extents)
  !> Input argument: `var`.
  type(variable_type), intent(in) :: var
  !> Return value: `extents`.
  integer, allocatable :: extents(:)
  integer :: i

  if (.not. allocated(var%dims)) error stop "[shape] Variable dimensions are not allocated."
  allocate (extents(size(var%dims)))
  do i = 1, size(var%dims)
    if (var%dims(i)%len > int(huge(extents(i)), int64)) then
      error stop "[shape] Dimension length exceeds default integer range."
    end if
    extents(i) = int(var%dims(i)%len)
  end do
end function get_shape

!> Return true when two variables have identical metadata and byte values.
module elemental logical function eq_var(x, y) result(is_equal)
  !> Input arguments: `x` and `y`.
  type(variable_type), intent(in) :: x, y

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

  is_equal = associated(x%buffer) .eqv. associated(y%buffer)
  if (.not. is_equal .or. .not. associated(x%buffer)) return
  is_equal = size(x%buffer) == size(y%buffer)
  if (is_equal) is_equal = all(x%buffer == y%buffer)
end function eq_var

!> Return true when two variables differ.
module elemental logical function neq_var(x, y) result(is_equal)
  !> Input arguments: `x` and `y`.
  type(variable_type), intent(in) :: x, y

  is_equal = .not. eq_var(x, y)
end function neq_var

end submodule nc4f_data_struct_var
