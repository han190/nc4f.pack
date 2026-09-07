submodule(nc4f_data_struct) nc4f_data_struct_arith

implicit none (type, external)

contains

module function sum_vars(vars) result(s)
  type(variable_type), intent(in) :: vars(:)
  type(variable_type) :: s
  integer :: i
  integer(int64) :: j, n

  n = size(vars, kind=int64)
  if (n < 1) error stop "[sum_vars] Invalid size."

  do i = 2, int(n)
    if (any(vars(1)%dims /= vars(i)%dims)) &
      & error stop "[sum_vars] Invalid dims."
    if (vars(1)%dtype /= vars(i)%dtype) &
      & error stop "[sum_vars] Invalid type."
  end do

  call allocate_memory(s, mold=vars(1))
  if (s%len == 0) return

  select case (s%dtype)
  case (BYTE_TYPE)
    block
      integer(int8), pointer :: s_ptr(:), v_ptr(:)

      call extract(s, s_ptr)
      call extract(vars(1), v_ptr)
      do concurrent (j=1:s%len)
        s_ptr(j) = v_ptr(j)
      end do
      do i = 2, int(n)
        call extract(vars(i), v_ptr)
        do concurrent (j=1:s%len)
          s_ptr(j) = s_ptr(j) + v_ptr(j)
        end do
      end do
    end block
  case (SHORT_TYPE)
    block
      integer(int16), pointer :: s_ptr(:), v_ptr(:)

      call extract(s, s_ptr)
      call extract(vars(1), v_ptr)
      do concurrent (j=1:s%len)
        s_ptr(j) = v_ptr(j)
      end do
      do i = 2, int(n)
        call extract(vars(i), v_ptr)
        do concurrent (j=1:s%len)
          s_ptr(j) = s_ptr(j) + v_ptr(j)
        end do
      end do
    end block
  case (INT_TYPE)
    block
      integer(int32), pointer :: s_ptr(:), v_ptr(:)

      call extract(s, s_ptr)
      call extract(vars(1), v_ptr)
      do concurrent (j=1:s%len)
        s_ptr(j) = v_ptr(j)
      end do
      do i = 2, int(n)
        call extract(vars(i), v_ptr)
        do concurrent (j=1:s%len)
          s_ptr(j) = s_ptr(j) + v_ptr(j)
        end do
      end do
    end block
  case (INT64_TYPE)
    block
      integer(int64), pointer :: s_ptr(:), v_ptr(:)

      call extract(s, s_ptr)
      call extract(vars(1), v_ptr)
      do concurrent (j=1:s%len)
        s_ptr(j) = v_ptr(j)
      end do
      do i = 2, int(n)
        call extract(vars(i), v_ptr)
        do concurrent (j=1:s%len)
          s_ptr(j) = s_ptr(j) + v_ptr(j)
        end do
      end do
    end block
  case (FLOAT_TYPE)
    block
      real(real32), pointer :: s_ptr(:), v_ptr(:)

      call extract(s, s_ptr)
      call extract(vars(1), v_ptr)
      do concurrent (j=1:s%len)
        s_ptr(j) = v_ptr(j)
      end do
      do i = 2, int(n)
        call extract(vars(i), v_ptr)
        do concurrent (j=1:s%len)
          s_ptr(j) = s_ptr(j) + v_ptr(j)
        end do
      end do
    end block
  case (DOUBLE_TYPE)
    block
      real(real64), pointer :: s_ptr(:), v_ptr(:)

      call extract(s, s_ptr)
      call extract(vars(1), v_ptr)
      do concurrent (j=1:s%len)
        s_ptr(j) = v_ptr(j)
      end do
      do i = 2, int(n)
        call extract(vars(i), v_ptr)
        do concurrent (j=1:s%len)
          s_ptr(j) = s_ptr(j) + v_ptr(j)
        end do
      end do
    end block
  case default
    error stop "[sum_vars] Invalid type."
  end select
end function sum_vars

end submodule nc4f_data_struct_arith
