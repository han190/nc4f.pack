submodule(nc4f_data_struct) nc4f_data_struct_var
implicit none (type, external)
contains

!> Return the number of elements for the whole variable or a single dim.
module pure function get_size(var, dim) result(n)
  !> Variable object to inspect.
  type(variable_type), intent(in) :: var
  !> Optional 1-based dimension index. If absent, return total size.
  integer, optional, intent(in) :: dim
  !> Number of elements returned (int64).
  integer(int64) :: n
  !> Local normalized dimension index and loop index.
  integer :: dim_, i

  if (.not. allocated(var%dims)) &
    & error stop "[get_size] Invalid dims."

  if (present(dim)) then
    dim_ = dim
  else
    dim_ = 0
  end if

  n = 1
  select case (dim_)
  case (0)
    do i = 1, size(var%dims)
      n = n*var%dims(i)%len
    end do
  case (1:)
    i = size(var%dims) - dim_ + 1
    n = var%dims(i)%len
  case default
    error stop "[get_size] Invalid dim."
  end select
end function get_size

!> Return the shape (lengths) of the variable's dimensions.
module pure function get_shape(var) result(n)
  !> Variable object to inspect.
  type(variable_type), intent(in) :: var
  !> Allocatable array of dimension lengths returned (int64 each).
  integer(int64), allocatable :: n(:)
  !> Number of dimensions and loop index.
  integer :: ndims, i

  if (.not. allocated(var%dims)) &
    & error stop "[get_size] Invalid dims."
  ndims = size(var%dims)
  if (.not. allocated(n)) then
    allocate (n(ndims))
  else if (size(n) /= ndims) then
    deallocate (n)
    allocate (n(ndims))
  end if

  do i = 1, ndims
    n(i) = var%dims(i)%len
  end do
end function get_shape

!> Allocate a variable `var` using metadata from `mold`.
module pure subroutine alloc_var_mold(var, mold)
  !> Variable to allocate and initialize.
  type(variable_type), intent(inout) :: var
  !> Mold containing metadata to copy into `var`.
  type(variable_type), intent(in) :: mold

  if (allocated(mold%atts)) then
    call alloc_var_meta(var, mold%name, &
      & mold%dtype, mold%len, mold%dims, mold%atts)
  else
    call alloc_var_meta(var, mold%name, &
      & mold%dtype, mold%len, mold%dims)
  end if
end subroutine alloc_var_mold

!> Allocate variable metadata and prepare its data buffer.
module pure subroutine alloc_var_meta(var, name, dtype, len, dims, atts)
  !> Variable to initialize and allocate.
  type(variable_type), intent(inout) :: var
  !> Name to assign to the variable.
  character(len=*), intent(in) :: name
  !> NetCDF data type code (NC_* constant) for the variable.
  integer(int32), intent(in) :: dtype
  !> Total number of elements for the variable.
  integer(int64), intent(in) :: len
  !> Array of dimensions describing the variable's shape.
  type(dimension_type), intent(in) :: dims(:)
  !> Optional array of attributes to copy into the variable.
  type(attribute_type), optional, intent(in) :: atts(:)

  var%name = name
  var%dtype = dtype
  var%len = len
  var%dims = dims
  if (present(atts)) var%atts = atts
  call alloc_var_buf(var)
end subroutine alloc_var_meta

!> Allocate or resize the variable's data buffer according to its type.
module pure subroutine alloc_var_buf(var)
  !> Variable whose data buffer will be allocated or resized.
  type(variable_type), intent(inout) :: var
  !> Calculated buffer size in bytes.
  integer(int64) :: buffer_size

  !> Assuming var%dtype and var%len is properly initialized.
  buffer_size = get_buffer_size(var%dtype, var%len)
  if (allocation_required(var%buffer, buffer_size)) then
    if (allocated(var%buffer)) deallocate (var%buffer)
    allocate (var%buffer(buffer_size))
  end if
end subroutine alloc_var_buf

!> Compare two `variable_type` values for deep equality of metadata and
!> contents. Returns true when name, type, length, dims, attributes and
!> buffer contents are equal.
module elemental logical function eq_var(x, y) result(res)
  !> Left-hand variable to compare.
  type(variable_type), intent(in) :: x
  !> Right-hand variable to compare.
  type(variable_type), intent(in) :: y
  !> Internal flags for allocation checks.
  logical :: is_alloc(2)

  res = (x%name == y%name) .and. &
    & (x%dtype == y%dtype) .and. (x%len == y%len)
  if (.not. res) return

  is_alloc(1) = allocated(x%dims)
  is_alloc(2) = allocated(y%dims)

  if (all(is_alloc)) then
    res = all(x%dims == y%dims)
  else
    res = .false.
  end if
  if (.not. res) return

  is_alloc(1) = allocated(x%atts)
  is_alloc(2) = allocated(y%atts)

  if (all(is_alloc)) then
    res = all(x%atts == y%atts)
  else if (.not. any(is_alloc)) then
    res = .true.
  else
    res = .false.
  end if
  if (.not. res) return

  res = all(x%buffer == y%buffer)
end function eq_var

!> Return true when two `variable_type` values differ.
module elemental logical function neq_var(x, y) result(res)
  !> Left-hand variable to compare.
  type(variable_type), intent(in) :: x
  !> Right-hand variable to compare.
  type(variable_type), intent(in) :: y

  res = .not. eq_var(x, y)
end function neq_var

end submodule nc4f_data_struct_var
