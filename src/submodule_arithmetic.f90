submodule(module_netcdf) submodule_arithmetic
implicit none (type, external)
contains

module function add_vars(x, y) result(res)
  type(variable_type), target, intent(in) :: x, y
  type(variable_type), target :: res

  if (any(x%dims /= y%dims)) &
    & error stop "[add_vars] Unequal dims."
  if (x%dtype /= y%dtype) &
    & error stop "[add_vars] Unequal data type."

  call allocate_variable(res, mold=x)
  select case (x%dtype)
  case (NC_BYTE)
    block
      integer(int8), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp + yp
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp + yp
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp + yp
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp + yp
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp + yp
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp + yp
    end block
  end select
end function add_vars

module function add_var_int8(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  integer(int8), intent(in) :: y
  type(variable_type), target :: res
  integer(int8), pointer :: xp(:), resp(:)

  if (x%dtype /= NC_BYTE) error stop &
    & "[add_var_int8] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp + y
end function add_var_int8

module function add_int8_var(x, y) result(res)
  integer(int8), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res
  integer(int8), pointer :: yp(:), resp(:)

  if (y%dtype /= NC_BYTE) error stop &
    & "[add_var_int8] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x + yp
end function add_int8_var

module function add_var_int16(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  integer(int16), intent(in) :: y
  type(variable_type), target :: res
  integer(int16), pointer :: xp(:), resp(:)

  if (x%dtype /= NC_SHORT) error stop &
    & "[add_var_int16] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp + y
end function add_var_int16

module function add_int16_var(x, y) result(res)
  integer(int16), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res
  integer(int16), pointer :: yp(:), resp(:)

  if (y%dtype /= NC_SHORT) error stop &
    & "[add_var_int16] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x + yp
end function add_int16_var

module function add_var_int32(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  integer(int32), intent(in) :: y
  type(variable_type), target :: res
  integer(int32), pointer :: xp(:), resp(:)

  if (x%dtype /= NC_INT) error stop &
    & "[add_var_int32] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp + y
end function add_var_int32

module function add_int32_var(x, y) result(res)
  integer(int32), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res
  integer(int32), pointer :: yp(:), resp(:)

  if (y%dtype /= NC_INT) error stop &
    & "[add_var_int32] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x + yp
end function add_int32_var

module function add_var_int64(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  integer(int64), intent(in) :: y
  type(variable_type), target :: res
  integer(int64), pointer :: xp(:), resp(:)

  if (x%dtype /= NC_INT64) error stop &
    & "[add_var_int64] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp + y
end function add_var_int64

module function add_int64_var(x, y) result(res)
  integer(int64), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res
  integer(int64), pointer :: yp(:), resp(:)

  if (y%dtype /= NC_INT64) error stop &
    & "[add_var_int64] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x + yp
end function add_int64_var

module function add_var_real32(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  real(real32), intent(in) :: y
  type(variable_type), target :: res
  real(real32), pointer :: xp(:), resp(:)

  if (x%dtype /= NC_FLOAT) error stop &
    & "[add_var_real32] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp + y
end function add_var_real32

module function add_real32_var(x, y) result(res)
  real(real32), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res
  real(real32), pointer :: yp(:), resp(:)

  if (y%dtype /= NC_FLOAT) error stop &
    & "[add_var_real32] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x + yp
end function add_real32_var

module function add_var_real64(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  real(real64), intent(in) :: y
  type(variable_type), target :: res
  real(real64), pointer :: xp(:), resp(:)

  if (x%dtype /= NC_DOUBLE) error stop &
    & "[add_var_real64] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp + y
end function add_var_real64

module function add_real64_var(x, y) result(res)
  real(real64), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res
  real(real64), pointer :: yp(:), resp(:)

  if (y%dtype /= NC_DOUBLE) error stop &
    & "[add_var_real64] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x + yp
end function add_real64_var

module function sub_vars(x, y) result(res)
  type(variable_type), target, intent(in) :: x, y
  type(variable_type), target :: res

  if (any(x%dims /= y%dims)) &
    & error stop "[add_vars] Unequal dims."
  if (x%dtype /= y%dtype) &
    & error stop "[add_vars] Unequal data type."

  call allocate_variable(res, mold=x)
  select case (x%dtype)
  case (NC_BYTE)
    block
      integer(int8), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp - yp
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp - yp
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp - yp
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp - yp
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp - yp
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp - yp
    end block
  end select
end function sub_vars

module function sub_var_int8(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  integer(int8), intent(in) :: y
  type(variable_type), target :: res
  integer(int8), pointer :: xp(:), resp(:)

  if (x%dtype /= NC_BYTE) error stop &
    & "[sub_var_int8] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp - y
end function sub_var_int8

module function sub_int8_var(x, y) result(res)
  integer(int8), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res
  integer(int8), pointer :: yp(:), resp(:)

  if (y%dtype /= NC_BYTE) error stop &
    & "[sub_var_int8] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x - yp
end function sub_int8_var

module function sub_var_int16(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  integer(int16), intent(in) :: y
  type(variable_type), target :: res
  integer(int16), pointer :: xp(:), resp(:)

  if (x%dtype /= NC_SHORT) error stop &
    & "[sub_var_int16] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp - y
end function sub_var_int16

module function sub_int16_var(x, y) result(res)
  integer(int16), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res
  integer(int16), pointer :: yp(:), resp(:)

  if (y%dtype /= NC_SHORT) error stop &
    & "[sub_var_int16] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x - yp
end function sub_int16_var

module function sub_var_int32(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  integer(int32), intent(in) :: y
  type(variable_type), target :: res
  integer(int32), pointer :: xp(:), resp(:)

  if (x%dtype /= NC_INT) error stop &
    & "[sub_var_int32] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp - y
end function sub_var_int32

module function sub_int32_var(x, y) result(res)
  integer(int32), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res
  integer(int32), pointer :: yp(:), resp(:)

  if (y%dtype /= NC_INT) error stop &
    & "[sub_var_int32] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x - yp
end function sub_int32_var

module function sub_var_int64(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  integer(int64), intent(in) :: y
  type(variable_type), target :: res
  integer(int64), pointer :: xp(:), resp(:)

  if (x%dtype /= NC_INT64) error stop &
    & "[sub_var_int64] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp - y
end function sub_var_int64

module function sub_int64_var(x, y) result(res)
  integer(int64), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res
  integer(int64), pointer :: yp(:), resp(:)

  if (y%dtype /= NC_INT64) error stop &
    & "[sub_var_int64] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x - yp
end function sub_int64_var

module function sub_var_real32(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  real(real32), intent(in) :: y
  type(variable_type), target :: res
  real(real32), pointer :: xp(:), resp(:)

  if (x%dtype /= NC_FLOAT) error stop &
    & "[sub_var_real32] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp - y
end function sub_var_real32

module function sub_real32_var(x, y) result(res)
  real(real32), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res
  real(real32), pointer :: yp(:), resp(:)

  if (y%dtype /= NC_FLOAT) error stop &
    & "[sub_var_real32] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x - yp
end function sub_real32_var

module function sub_var_real64(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  real(real64), intent(in) :: y
  type(variable_type), target :: res
  real(real64), pointer :: xp(:), resp(:)

  if (x%dtype /= NC_DOUBLE) error stop &
    & "[sub_var_real64] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp - y
end function sub_var_real64

module function sub_real64_var(x, y) result(res)
  real(real64), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res
  real(real64), pointer :: yp(:), resp(:)

  if (y%dtype /= NC_DOUBLE) error stop &
    & "[sub_var_real64] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x - yp
end function sub_real64_var

module function mul_vars(x, y) result(res)
  type(variable_type), target, intent(in) :: x, y
  type(variable_type), target :: res

  if (any(x%dims /= y%dims)) &
    & error stop "[add_vars] Unequal dims."
  if (x%dtype /= y%dtype) &
    & error stop "[add_vars] Unequal data type."

  call allocate_variable(res, mold=x)
  select case (x%dtype)
  case (NC_BYTE)
    block
      integer(int8), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp * yp
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp * yp
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp * yp
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp * yp
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp * yp
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp * yp
    end block
  end select
end function mul_vars

module function mul_var_int8(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  integer(int8), intent(in) :: y
  type(variable_type), target :: res
  integer(int8), pointer :: xp(:), resp(:)

  if (x%dtype /= NC_BYTE) error stop &
    & "[mul_var_int8] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp * y
end function mul_var_int8

module function mul_int8_var(x, y) result(res)
  integer(int8), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res
  integer(int8), pointer :: yp(:), resp(:)

  if (y%dtype /= NC_BYTE) error stop &
    & "[mul_var_int8] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x * yp
end function mul_int8_var

module function mul_var_int16(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  integer(int16), intent(in) :: y
  type(variable_type), target :: res
  integer(int16), pointer :: xp(:), resp(:)

  if (x%dtype /= NC_SHORT) error stop &
    & "[mul_var_int16] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp * y
end function mul_var_int16

module function mul_int16_var(x, y) result(res)
  integer(int16), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res
  integer(int16), pointer :: yp(:), resp(:)

  if (y%dtype /= NC_SHORT) error stop &
    & "[mul_var_int16] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x * yp
end function mul_int16_var

module function mul_var_int32(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  integer(int32), intent(in) :: y
  type(variable_type), target :: res
  integer(int32), pointer :: xp(:), resp(:)

  if (x%dtype /= NC_INT) error stop &
    & "[mul_var_int32] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp * y
end function mul_var_int32

module function mul_int32_var(x, y) result(res)
  integer(int32), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res
  integer(int32), pointer :: yp(:), resp(:)

  if (y%dtype /= NC_INT) error stop &
    & "[mul_var_int32] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x * yp
end function mul_int32_var

module function mul_var_int64(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  integer(int64), intent(in) :: y
  type(variable_type), target :: res
  integer(int64), pointer :: xp(:), resp(:)

  if (x%dtype /= NC_INT64) error stop &
    & "[mul_var_int64] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp * y
end function mul_var_int64

module function mul_int64_var(x, y) result(res)
  integer(int64), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res
  integer(int64), pointer :: yp(:), resp(:)

  if (y%dtype /= NC_INT64) error stop &
    & "[mul_var_int64] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x * yp
end function mul_int64_var

module function mul_var_real32(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  real(real32), intent(in) :: y
  type(variable_type), target :: res
  real(real32), pointer :: xp(:), resp(:)

  if (x%dtype /= NC_FLOAT) error stop &
    & "[mul_var_real32] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp * y
end function mul_var_real32

module function mul_real32_var(x, y) result(res)
  real(real32), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res
  real(real32), pointer :: yp(:), resp(:)

  if (y%dtype /= NC_FLOAT) error stop &
    & "[mul_var_real32] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x * yp
end function mul_real32_var

module function mul_var_real64(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  real(real64), intent(in) :: y
  type(variable_type), target :: res
  real(real64), pointer :: xp(:), resp(:)

  if (x%dtype /= NC_DOUBLE) error stop &
    & "[mul_var_real64] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp * y
end function mul_var_real64

module function mul_real64_var(x, y) result(res)
  real(real64), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res
  real(real64), pointer :: yp(:), resp(:)

  if (y%dtype /= NC_DOUBLE) error stop &
    & "[mul_var_real64] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x * yp
end function mul_real64_var

module function div_vars(x, y) result(res)
  type(variable_type), target, intent(in) :: x, y
  type(variable_type), target :: res

  if (any(x%dims /= y%dims)) &
    & error stop "[add_vars] Unequal dims."
  if (x%dtype /= y%dtype) &
    & error stop "[add_vars] Unequal data type."

  call allocate_variable(res, mold=x)
  select case (x%dtype)
  case (NC_BYTE)
    block
      integer(int8), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp / yp
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp / yp
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp / yp
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp / yp
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp / yp
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp / yp
    end block
  end select
end function div_vars

module function div_var_int8(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  integer(int8), intent(in) :: y
  type(variable_type), target :: res
  integer(int8), pointer :: xp(:), resp(:)

  if (x%dtype /= NC_BYTE) error stop &
    & "[div_var_int8] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp / y
end function div_var_int8

module function div_int8_var(x, y) result(res)
  integer(int8), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res
  integer(int8), pointer :: yp(:), resp(:)

  if (y%dtype /= NC_BYTE) error stop &
    & "[div_var_int8] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x / yp
end function div_int8_var

module function div_var_int16(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  integer(int16), intent(in) :: y
  type(variable_type), target :: res
  integer(int16), pointer :: xp(:), resp(:)

  if (x%dtype /= NC_SHORT) error stop &
    & "[div_var_int16] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp / y
end function div_var_int16

module function div_int16_var(x, y) result(res)
  integer(int16), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res
  integer(int16), pointer :: yp(:), resp(:)

  if (y%dtype /= NC_SHORT) error stop &
    & "[div_var_int16] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x / yp
end function div_int16_var

module function div_var_int32(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  integer(int32), intent(in) :: y
  type(variable_type), target :: res
  integer(int32), pointer :: xp(:), resp(:)

  if (x%dtype /= NC_INT) error stop &
    & "[div_var_int32] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp / y
end function div_var_int32

module function div_int32_var(x, y) result(res)
  integer(int32), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res
  integer(int32), pointer :: yp(:), resp(:)

  if (y%dtype /= NC_INT) error stop &
    & "[div_var_int32] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x / yp
end function div_int32_var

module function div_var_int64(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  integer(int64), intent(in) :: y
  type(variable_type), target :: res
  integer(int64), pointer :: xp(:), resp(:)

  if (x%dtype /= NC_INT64) error stop &
    & "[div_var_int64] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp / y
end function div_var_int64

module function div_int64_var(x, y) result(res)
  integer(int64), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res
  integer(int64), pointer :: yp(:), resp(:)

  if (y%dtype /= NC_INT64) error stop &
    & "[div_var_int64] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x / yp
end function div_int64_var

module function div_var_real32(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  real(real32), intent(in) :: y
  type(variable_type), target :: res
  real(real32), pointer :: xp(:), resp(:)

  if (x%dtype /= NC_FLOAT) error stop &
    & "[div_var_real32] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp / y
end function div_var_real32

module function div_real32_var(x, y) result(res)
  real(real32), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res
  real(real32), pointer :: yp(:), resp(:)

  if (y%dtype /= NC_FLOAT) error stop &
    & "[div_var_real32] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x / yp
end function div_real32_var

module function div_var_real64(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  real(real64), intent(in) :: y
  type(variable_type), target :: res
  real(real64), pointer :: xp(:), resp(:)

  if (x%dtype /= NC_DOUBLE) error stop &
    & "[div_var_real64] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp / y
end function div_var_real64

module function div_real64_var(x, y) result(res)
  real(real64), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res
  real(real64), pointer :: yp(:), resp(:)

  if (y%dtype /= NC_DOUBLE) error stop &
    & "[div_var_real64] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x / yp
end function div_real64_var

module function pow_vars(x, y) result(res)
  type(variable_type), target, intent(in) :: x, y
  type(variable_type), target :: res

  if (any(x%dims /= y%dims)) &
    & error stop "[add_vars] Unequal dims."
  if (x%dtype /= y%dtype) &
    & error stop "[add_vars] Unequal data type."

  call allocate_variable(res, mold=x)
  select case (x%dtype)
  case (NC_BYTE)
    block
      integer(int8), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp ** yp
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp ** yp
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp ** yp
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp ** yp
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp ** yp
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp ** yp
    end block
  end select
end function pow_vars

module function pow_var_int8(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  integer(int8), intent(in) :: y
  type(variable_type), target :: res
  integer(int8), pointer :: xp(:), resp(:)

  if (x%dtype /= NC_BYTE) error stop &
    & "[pow_var_int8] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp ** y
end function pow_var_int8

module function pow_int8_var(x, y) result(res)
  integer(int8), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res
  integer(int8), pointer :: yp(:), resp(:)

  if (y%dtype /= NC_BYTE) error stop &
    & "[pow_var_int8] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x ** yp
end function pow_int8_var

module function pow_var_int16(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  integer(int16), intent(in) :: y
  type(variable_type), target :: res
  integer(int16), pointer :: xp(:), resp(:)

  if (x%dtype /= NC_SHORT) error stop &
    & "[pow_var_int16] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp ** y
end function pow_var_int16

module function pow_int16_var(x, y) result(res)
  integer(int16), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res
  integer(int16), pointer :: yp(:), resp(:)

  if (y%dtype /= NC_SHORT) error stop &
    & "[pow_var_int16] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x ** yp
end function pow_int16_var

module function pow_var_int32(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  integer(int32), intent(in) :: y
  type(variable_type), target :: res
  integer(int32), pointer :: xp(:), resp(:)

  if (x%dtype /= NC_INT) error stop &
    & "[pow_var_int32] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp ** y
end function pow_var_int32

module function pow_int32_var(x, y) result(res)
  integer(int32), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res
  integer(int32), pointer :: yp(:), resp(:)

  if (y%dtype /= NC_INT) error stop &
    & "[pow_var_int32] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x ** yp
end function pow_int32_var

module function pow_var_int64(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  integer(int64), intent(in) :: y
  type(variable_type), target :: res
  integer(int64), pointer :: xp(:), resp(:)

  if (x%dtype /= NC_INT64) error stop &
    & "[pow_var_int64] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp ** y
end function pow_var_int64

module function pow_int64_var(x, y) result(res)
  integer(int64), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res
  integer(int64), pointer :: yp(:), resp(:)

  if (y%dtype /= NC_INT64) error stop &
    & "[pow_var_int64] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x ** yp
end function pow_int64_var

module function pow_var_real32(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  real(real32), intent(in) :: y
  type(variable_type), target :: res
  real(real32), pointer :: xp(:), resp(:)

  if (x%dtype /= NC_FLOAT) error stop &
    & "[pow_var_real32] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp ** y
end function pow_var_real32

module function pow_real32_var(x, y) result(res)
  real(real32), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res
  real(real32), pointer :: yp(:), resp(:)

  if (y%dtype /= NC_FLOAT) error stop &
    & "[pow_var_real32] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x ** yp
end function pow_real32_var

module function pow_var_real64(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  real(real64), intent(in) :: y
  type(variable_type), target :: res
  real(real64), pointer :: xp(:), resp(:)

  if (x%dtype /= NC_DOUBLE) error stop &
    & "[pow_var_real64] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp ** y
end function pow_var_real64

module function pow_real64_var(x, y) result(res)
  real(real64), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res
  real(real64), pointer :: yp(:), resp(:)

  if (y%dtype /= NC_DOUBLE) error stop &
    & "[pow_var_real64] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x ** yp
end function pow_real64_var


module function sum_vars(vars) result(s)
  type(variable_type), intent(in) :: vars(:)
  type(variable_type) :: s
  integer :: i, n

  !> Assuming vars share same dimensions and type.
  n = size(vars)
  select case (n)
  case (1)
    s = vars(1)
  case (2:)
    do i = 2, n
      if (any(vars(1)%dims /= vars(i)%dims)) &
        & error stop "[sum_vars] Invalid dims."
      if (vars(1)%dtype /= vars(i)%dtype) &
        & error stop "[sum_vars] Invalid type."
    end do

    call allocate_variable(s, mold=vars(1))
    select case (s%dtype)
    case (NC_BYTE)
      block
        integer(int8), pointer :: s_ptr(:), v_ptr(:)

        call extract(s, s_ptr)
        s_ptr = 0
        do i = 1, n
          call extract(vars(i), v_ptr)
          s_ptr = s_ptr + v_ptr
        end do
      end block
    case (NC_SHORT)
      block
        integer(int16), pointer :: s_ptr(:), v_ptr(:)

        call extract(s, s_ptr)
        s_ptr = 0
        do i = 1, n
          call extract(vars(i), v_ptr)
          s_ptr = s_ptr + v_ptr
        end do
      end block
    case (NC_INT)
      block
        integer(int32), pointer :: s_ptr(:), v_ptr(:)

        call extract(s, s_ptr)
        s_ptr = 0
        do i = 1, n
          call extract(vars(i), v_ptr)
          s_ptr = s_ptr + v_ptr
        end do
      end block
    case (NC_INT64)
      block
        integer(int64), pointer :: s_ptr(:), v_ptr(:)

        call extract(s, s_ptr)
        s_ptr = 0
        do i = 1, n
          call extract(vars(i), v_ptr)
          s_ptr = s_ptr + v_ptr
        end do
      end block
    case (NC_FLOAT)
      block
        real(real32), pointer :: s_ptr(:), v_ptr(:)

        call extract(s, s_ptr)
        s_ptr = 0
        do i = 1, n
          call extract(vars(i), v_ptr)
          s_ptr = s_ptr + v_ptr
        end do
      end block
    case (NC_DOUBLE)
      block
        real(real64), pointer :: s_ptr(:), v_ptr(:)

        call extract(s, s_ptr)
        s_ptr = 0
        do i = 1, n
          call extract(vars(i), v_ptr)
          s_ptr = s_ptr + v_ptr
        end do
      end block
    case default
      error stop "[sum_vars] Invalid type."
    end select
  case default
    error stop "[sum_vars] Invalid size."
  end select
end function sum_vars

end submodule submodule_arithmetic
