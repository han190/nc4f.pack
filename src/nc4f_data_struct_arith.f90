!> Arithmetic on homogeneous variable collections.
submodule(nc4f_data_struct) nc4f_data_struct_arith
implicit none (type, external)
contains

!> Return the element-wise sum of compatible variables in `vars`.
module function sum_vars(vars) result(total)
  !> Input argument: `vars`.
  type(variable_type), intent(in) :: vars(:)
  !> Return value: `total`.
  type(variable_type) :: total
  integer :: i
  integer(int64) :: j

  if (size(vars) == 0) error stop "[sum] At least one variable is required."
  if (.not. allocated(vars(1)%dims)) error stop &
    & "[sum] Variable dimensions are not allocated."

  do i = 2, size(vars)
    if (.not. allocated(vars(i)%dims) .or. &
      & size(vars(i)%dims) /= size(vars(1)%dims)) then
      error stop "[sum] Variable dimensions are incompatible."
    end if
    if (.not. all(vars(i)%dims == vars(1)%dims)) error stop &
      & "[sum] Variable dimensions are incompatible."
    if (vars(i)%dtype /= vars(1)%dtype) error stop &
      & "[sum] Variable types are incompatible."
    if (vars(i)%len /= vars(1)%len) error stop &
      & "[sum] Variable lengths are incompatible."
  end do

  call clone_var_(vars(1), total)
  if (total%len == 0) return

  select case (total%dtype)
  case (BYTE_TYPE)
    block
      integer(int8), pointer :: total_values(:), values(:)
      call extract(total, total_values)
      do i = 2, size(vars)
        call extract(vars(i), values)
        do concurrent (j = 1:total%len)
          total_values(j) = total_values(j) + values(j)
        end do
      end do
    end block
  case (SHORT_TYPE)
    block
      integer(int16), pointer :: total_values(:), values(:)
      call extract(total, total_values)
      do i = 2, size(vars)
        call extract(vars(i), values)
        do concurrent (j = 1:total%len)
          total_values(j) = total_values(j) + values(j)
        end do
      end do
    end block
  case (INT_TYPE)
    block
      integer(int32), pointer :: total_values(:), values(:)
      call extract(total, total_values)
      do i = 2, size(vars)
        call extract(vars(i), values)
        do concurrent (j = 1:total%len)
          total_values(j) = total_values(j) + values(j)
        end do
      end do
    end block
  case (INT64_TYPE)
    block
      integer(int64), pointer :: total_values(:), values(:)
      call extract(total, total_values)
      do i = 2, size(vars)
        call extract(vars(i), values)
        do concurrent (j = 1:total%len)
          total_values(j) = total_values(j) + values(j)
        end do
      end do
    end block
  case (FLOAT_TYPE)
    block
      real(real32), pointer :: total_values(:), values(:)
      call extract(total, total_values)
      do i = 2, size(vars)
        call extract(vars(i), values)
        do concurrent (j = 1:total%len)
          total_values(j) = total_values(j) + values(j)
        end do
      end do
    end block
  case (DOUBLE_TYPE)
    block
      real(real64), pointer :: total_values(:), values(:)
      call extract(total, total_values)
      do i = 2, size(vars)
        call extract(vars(i), values)
        do concurrent (j = 1:total%len)
          total_values(j) = total_values(j) + values(j)
        end do
      end do
    end block
  case default
    error stop "[sum] Unsupported variable type."
  end select
end function sum_vars

end submodule nc4f_data_struct_arith
