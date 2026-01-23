submodule(nc4f_data_struct) nc4f_data_struct_arith
implicit none (type, external)
contains

!> Element-wise operator `+` for two `variable_type` values.
module function add_vars(x, y) result(res)
  !> Left operand variable.
  type(variable_type), target, intent(in) :: x, y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res

  if (any(x%dims /= y%dims)) &
    & error stop "[add_vars] Unequal dims."
  if (x%dtype /= y%dtype) &
    & error stop "[add_vars] Unequal data type."

  call allocate_variable(res, mold=x)
  select case (x%dtype)
  case (BYTE_TYPE)
    block
      !> Typed pointer view for operands and result.
      integer(int8), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp + yp
    end block
  case (SHORT_TYPE)
    block
      !> Typed pointer view for operands and result.
      integer(int16), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp + yp
    end block
  case (INT_TYPE)
    block
      !> Typed pointer view for operands and result.
      integer(int32), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp + yp
    end block
  case (INT64_TYPE)
    block
      !> Typed pointer view for operands and result.
      integer(int64), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp + yp
    end block
  case (FLOAT_TYPE)
    block
      !> Typed pointer view for operands and result.
      real(real32), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp + yp
    end block
  case (DOUBLE_TYPE)
    block
      !> Typed pointer view for operands and result.
      real(real64), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp + yp
    end block
  end select
end function add_vars

!> Operator `+` between a `variable_type` and a scalar `integer`.
module function add_var_int8(x, y) result(res)
  !> Variable left operand.
  type(variable_type), target, intent(in) :: x
  !> Scalar right operand of type `integer` kind `int8`.
  integer(int8), intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  integer(int8), pointer :: xp(:), resp(:)

  if (x%dtype /= BYTE_TYPE) error stop &
    & "[add_var_int8] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp + y
end function add_var_int8

!> Operator `+` between a scalar `integer` and a `variable_type`.
module function add_int8_var(x, y) result(res)
  !> Scalar left operand of type `integer` kind `int8`.
  integer(int8), intent(in) :: x
  !> Variable right operand.
  type(variable_type), target, intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  integer(int8), pointer :: yp(:), resp(:)

  if (y%dtype /= BYTE_TYPE) error stop &
    & "[add_var_int8] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x + yp
end function add_int8_var

!> Operator `+` between a `variable_type` and a scalar `integer`.
module function add_var_int16(x, y) result(res)
  !> Variable left operand.
  type(variable_type), target, intent(in) :: x
  !> Scalar right operand of type `integer` kind `int16`.
  integer(int16), intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  integer(int16), pointer :: xp(:), resp(:)

  if (x%dtype /= SHORT_TYPE) error stop &
    & "[add_var_int16] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp + y
end function add_var_int16

!> Operator `+` between a scalar `integer` and a `variable_type`.
module function add_int16_var(x, y) result(res)
  !> Scalar left operand of type `integer` kind `int16`.
  integer(int16), intent(in) :: x
  !> Variable right operand.
  type(variable_type), target, intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  integer(int16), pointer :: yp(:), resp(:)

  if (y%dtype /= SHORT_TYPE) error stop &
    & "[add_var_int16] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x + yp
end function add_int16_var

!> Operator `+` between a `variable_type` and a scalar `integer`.
module function add_var_int32(x, y) result(res)
  !> Variable left operand.
  type(variable_type), target, intent(in) :: x
  !> Scalar right operand of type `integer` kind `int32`.
  integer(int32), intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  integer(int32), pointer :: xp(:), resp(:)

  if (x%dtype /= INT_TYPE) error stop &
    & "[add_var_int32] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp + y
end function add_var_int32

!> Operator `+` between a scalar `integer` and a `variable_type`.
module function add_int32_var(x, y) result(res)
  !> Scalar left operand of type `integer` kind `int32`.
  integer(int32), intent(in) :: x
  !> Variable right operand.
  type(variable_type), target, intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  integer(int32), pointer :: yp(:), resp(:)

  if (y%dtype /= INT_TYPE) error stop &
    & "[add_var_int32] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x + yp
end function add_int32_var

!> Operator `+` between a `variable_type` and a scalar `integer`.
module function add_var_int64(x, y) result(res)
  !> Variable left operand.
  type(variable_type), target, intent(in) :: x
  !> Scalar right operand of type `integer` kind `int64`.
  integer(int64), intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  integer(int64), pointer :: xp(:), resp(:)

  if (x%dtype /= INT64_TYPE) error stop &
    & "[add_var_int64] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp + y
end function add_var_int64

!> Operator `+` between a scalar `integer` and a `variable_type`.
module function add_int64_var(x, y) result(res)
  !> Scalar left operand of type `integer` kind `int64`.
  integer(int64), intent(in) :: x
  !> Variable right operand.
  type(variable_type), target, intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  integer(int64), pointer :: yp(:), resp(:)

  if (y%dtype /= INT64_TYPE) error stop &
    & "[add_var_int64] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x + yp
end function add_int64_var

!> Operator `+` between a `variable_type` and a scalar `real`.
module function add_var_real32(x, y) result(res)
  !> Variable left operand.
  type(variable_type), target, intent(in) :: x
  !> Scalar right operand of type `real` kind `real32`.
  real(real32), intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  real(real32), pointer :: xp(:), resp(:)

  if (x%dtype /= FLOAT_TYPE) error stop &
    & "[add_var_real32] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp + y
end function add_var_real32

!> Operator `+` between a scalar `real` and a `variable_type`.
module function add_real32_var(x, y) result(res)
  !> Scalar left operand of type `real` kind `real32`.
  real(real32), intent(in) :: x
  !> Variable right operand.
  type(variable_type), target, intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  real(real32), pointer :: yp(:), resp(:)

  if (y%dtype /= FLOAT_TYPE) error stop &
    & "[add_var_real32] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x + yp
end function add_real32_var

!> Operator `+` between a `variable_type` and a scalar `real`.
module function add_var_real64(x, y) result(res)
  !> Variable left operand.
  type(variable_type), target, intent(in) :: x
  !> Scalar right operand of type `real` kind `real64`.
  real(real64), intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  real(real64), pointer :: xp(:), resp(:)

  if (x%dtype /= DOUBLE_TYPE) error stop &
    & "[add_var_real64] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp + y
end function add_var_real64

!> Operator `+` between a scalar `real` and a `variable_type`.
module function add_real64_var(x, y) result(res)
  !> Scalar left operand of type `real` kind `real64`.
  real(real64), intent(in) :: x
  !> Variable right operand.
  type(variable_type), target, intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  real(real64), pointer :: yp(:), resp(:)

  if (y%dtype /= DOUBLE_TYPE) error stop &
    & "[add_var_real64] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x + yp
end function add_real64_var

!> Element-wise operator `-` for two `variable_type` values.
module function sub_vars(x, y) result(res)
  !> Left operand variable.
  type(variable_type), target, intent(in) :: x, y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res

  if (any(x%dims /= y%dims)) &
    & error stop "[add_vars] Unequal dims."
  if (x%dtype /= y%dtype) &
    & error stop "[add_vars] Unequal data type."

  call allocate_variable(res, mold=x)
  select case (x%dtype)
  case (BYTE_TYPE)
    block
      !> Typed pointer view for operands and result.
      integer(int8), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp - yp
    end block
  case (SHORT_TYPE)
    block
      !> Typed pointer view for operands and result.
      integer(int16), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp - yp
    end block
  case (INT_TYPE)
    block
      !> Typed pointer view for operands and result.
      integer(int32), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp - yp
    end block
  case (INT64_TYPE)
    block
      !> Typed pointer view for operands and result.
      integer(int64), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp - yp
    end block
  case (FLOAT_TYPE)
    block
      !> Typed pointer view for operands and result.
      real(real32), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp - yp
    end block
  case (DOUBLE_TYPE)
    block
      !> Typed pointer view for operands and result.
      real(real64), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp - yp
    end block
  end select
end function sub_vars

!> Operator `-` between a `variable_type` and a scalar `integer`.
module function sub_var_int8(x, y) result(res)
  !> Variable left operand.
  type(variable_type), target, intent(in) :: x
  !> Scalar right operand of type `integer` kind `int8`.
  integer(int8), intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  integer(int8), pointer :: xp(:), resp(:)

  if (x%dtype /= BYTE_TYPE) error stop &
    & "[sub_var_int8] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp - y
end function sub_var_int8

!> Operator `-` between a scalar `integer` and a `variable_type`.
module function sub_int8_var(x, y) result(res)
  !> Scalar left operand of type `integer` kind `int8`.
  integer(int8), intent(in) :: x
  !> Variable right operand.
  type(variable_type), target, intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  integer(int8), pointer :: yp(:), resp(:)

  if (y%dtype /= BYTE_TYPE) error stop &
    & "[sub_var_int8] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x - yp
end function sub_int8_var

!> Operator `-` between a `variable_type` and a scalar `integer`.
module function sub_var_int16(x, y) result(res)
  !> Variable left operand.
  type(variable_type), target, intent(in) :: x
  !> Scalar right operand of type `integer` kind `int16`.
  integer(int16), intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  integer(int16), pointer :: xp(:), resp(:)

  if (x%dtype /= SHORT_TYPE) error stop &
    & "[sub_var_int16] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp - y
end function sub_var_int16

!> Operator `-` between a scalar `integer` and a `variable_type`.
module function sub_int16_var(x, y) result(res)
  !> Scalar left operand of type `integer` kind `int16`.
  integer(int16), intent(in) :: x
  !> Variable right operand.
  type(variable_type), target, intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  integer(int16), pointer :: yp(:), resp(:)

  if (y%dtype /= SHORT_TYPE) error stop &
    & "[sub_var_int16] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x - yp
end function sub_int16_var

!> Operator `-` between a `variable_type` and a scalar `integer`.
module function sub_var_int32(x, y) result(res)
  !> Variable left operand.
  type(variable_type), target, intent(in) :: x
  !> Scalar right operand of type `integer` kind `int32`.
  integer(int32), intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  integer(int32), pointer :: xp(:), resp(:)

  if (x%dtype /= INT_TYPE) error stop &
    & "[sub_var_int32] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp - y
end function sub_var_int32

!> Operator `-` between a scalar `integer` and a `variable_type`.
module function sub_int32_var(x, y) result(res)
  !> Scalar left operand of type `integer` kind `int32`.
  integer(int32), intent(in) :: x
  !> Variable right operand.
  type(variable_type), target, intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  integer(int32), pointer :: yp(:), resp(:)

  if (y%dtype /= INT_TYPE) error stop &
    & "[sub_var_int32] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x - yp
end function sub_int32_var

!> Operator `-` between a `variable_type` and a scalar `integer`.
module function sub_var_int64(x, y) result(res)
  !> Variable left operand.
  type(variable_type), target, intent(in) :: x
  !> Scalar right operand of type `integer` kind `int64`.
  integer(int64), intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  integer(int64), pointer :: xp(:), resp(:)

  if (x%dtype /= INT64_TYPE) error stop &
    & "[sub_var_int64] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp - y
end function sub_var_int64

!> Operator `-` between a scalar `integer` and a `variable_type`.
module function sub_int64_var(x, y) result(res)
  !> Scalar left operand of type `integer` kind `int64`.
  integer(int64), intent(in) :: x
  !> Variable right operand.
  type(variable_type), target, intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  integer(int64), pointer :: yp(:), resp(:)

  if (y%dtype /= INT64_TYPE) error stop &
    & "[sub_var_int64] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x - yp
end function sub_int64_var

!> Operator `-` between a `variable_type` and a scalar `real`.
module function sub_var_real32(x, y) result(res)
  !> Variable left operand.
  type(variable_type), target, intent(in) :: x
  !> Scalar right operand of type `real` kind `real32`.
  real(real32), intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  real(real32), pointer :: xp(:), resp(:)

  if (x%dtype /= FLOAT_TYPE) error stop &
    & "[sub_var_real32] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp - y
end function sub_var_real32

!> Operator `-` between a scalar `real` and a `variable_type`.
module function sub_real32_var(x, y) result(res)
  !> Scalar left operand of type `real` kind `real32`.
  real(real32), intent(in) :: x
  !> Variable right operand.
  type(variable_type), target, intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  real(real32), pointer :: yp(:), resp(:)

  if (y%dtype /= FLOAT_TYPE) error stop &
    & "[sub_var_real32] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x - yp
end function sub_real32_var

!> Operator `-` between a `variable_type` and a scalar `real`.
module function sub_var_real64(x, y) result(res)
  !> Variable left operand.
  type(variable_type), target, intent(in) :: x
  !> Scalar right operand of type `real` kind `real64`.
  real(real64), intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  real(real64), pointer :: xp(:), resp(:)

  if (x%dtype /= DOUBLE_TYPE) error stop &
    & "[sub_var_real64] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp - y
end function sub_var_real64

!> Operator `-` between a scalar `real` and a `variable_type`.
module function sub_real64_var(x, y) result(res)
  !> Scalar left operand of type `real` kind `real64`.
  real(real64), intent(in) :: x
  !> Variable right operand.
  type(variable_type), target, intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  real(real64), pointer :: yp(:), resp(:)

  if (y%dtype /= DOUBLE_TYPE) error stop &
    & "[sub_var_real64] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x - yp
end function sub_real64_var

!> Element-wise operator `*` for two `variable_type` values.
module function mul_vars(x, y) result(res)
  !> Left operand variable.
  type(variable_type), target, intent(in) :: x, y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res

  if (any(x%dims /= y%dims)) &
    & error stop "[add_vars] Unequal dims."
  if (x%dtype /= y%dtype) &
    & error stop "[add_vars] Unequal data type."

  call allocate_variable(res, mold=x)
  select case (x%dtype)
  case (BYTE_TYPE)
    block
      !> Typed pointer view for operands and result.
      integer(int8), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp*yp
    end block
  case (SHORT_TYPE)
    block
      !> Typed pointer view for operands and result.
      integer(int16), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp*yp
    end block
  case (INT_TYPE)
    block
      !> Typed pointer view for operands and result.
      integer(int32), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp*yp
    end block
  case (INT64_TYPE)
    block
      !> Typed pointer view for operands and result.
      integer(int64), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp*yp
    end block
  case (FLOAT_TYPE)
    block
      !> Typed pointer view for operands and result.
      real(real32), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp*yp
    end block
  case (DOUBLE_TYPE)
    block
      !> Typed pointer view for operands and result.
      real(real64), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp*yp
    end block
  end select
end function mul_vars

!> Operator `*` between a `variable_type` and a scalar `integer`.
module function mul_var_int8(x, y) result(res)
  !> Variable left operand.
  type(variable_type), target, intent(in) :: x
  !> Scalar right operand of type `integer` kind `int8`.
  integer(int8), intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  integer(int8), pointer :: xp(:), resp(:)

  if (x%dtype /= BYTE_TYPE) error stop &
    & "[mul_var_int8] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp*y
end function mul_var_int8

!> Operator `*` between a scalar `integer` and a `variable_type`.
module function mul_int8_var(x, y) result(res)
  !> Scalar left operand of type `integer` kind `int8`.
  integer(int8), intent(in) :: x
  !> Variable right operand.
  type(variable_type), target, intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  integer(int8), pointer :: yp(:), resp(:)

  if (y%dtype /= BYTE_TYPE) error stop &
    & "[mul_var_int8] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x*yp
end function mul_int8_var

!> Operator `*` between a `variable_type` and a scalar `integer`.
module function mul_var_int16(x, y) result(res)
  !> Variable left operand.
  type(variable_type), target, intent(in) :: x
  !> Scalar right operand of type `integer` kind `int16`.
  integer(int16), intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  integer(int16), pointer :: xp(:), resp(:)

  if (x%dtype /= SHORT_TYPE) error stop &
    & "[mul_var_int16] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp*y
end function mul_var_int16

!> Operator `*` between a scalar `integer` and a `variable_type`.
module function mul_int16_var(x, y) result(res)
  !> Scalar left operand of type `integer` kind `int16`.
  integer(int16), intent(in) :: x
  !> Variable right operand.
  type(variable_type), target, intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  integer(int16), pointer :: yp(:), resp(:)

  if (y%dtype /= SHORT_TYPE) error stop &
    & "[mul_var_int16] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x*yp
end function mul_int16_var

!> Operator `*` between a `variable_type` and a scalar `integer`.
module function mul_var_int32(x, y) result(res)
  !> Variable left operand.
  type(variable_type), target, intent(in) :: x
  !> Scalar right operand of type `integer` kind `int32`.
  integer(int32), intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  integer(int32), pointer :: xp(:), resp(:)

  if (x%dtype /= INT_TYPE) error stop &
    & "[mul_var_int32] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp*y
end function mul_var_int32

!> Operator `*` between a scalar `integer` and a `variable_type`.
module function mul_int32_var(x, y) result(res)
  !> Scalar left operand of type `integer` kind `int32`.
  integer(int32), intent(in) :: x
  !> Variable right operand.
  type(variable_type), target, intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  integer(int32), pointer :: yp(:), resp(:)

  if (y%dtype /= INT_TYPE) error stop &
    & "[mul_var_int32] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x*yp
end function mul_int32_var

!> Operator `*` between a `variable_type` and a scalar `integer`.
module function mul_var_int64(x, y) result(res)
  !> Variable left operand.
  type(variable_type), target, intent(in) :: x
  !> Scalar right operand of type `integer` kind `int64`.
  integer(int64), intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  integer(int64), pointer :: xp(:), resp(:)

  if (x%dtype /= INT64_TYPE) error stop &
    & "[mul_var_int64] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp*y
end function mul_var_int64

!> Operator `*` between a scalar `integer` and a `variable_type`.
module function mul_int64_var(x, y) result(res)
  !> Scalar left operand of type `integer` kind `int64`.
  integer(int64), intent(in) :: x
  !> Variable right operand.
  type(variable_type), target, intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  integer(int64), pointer :: yp(:), resp(:)

  if (y%dtype /= INT64_TYPE) error stop &
    & "[mul_var_int64] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x*yp
end function mul_int64_var

!> Operator `*` between a `variable_type` and a scalar `real`.
module function mul_var_real32(x, y) result(res)
  !> Variable left operand.
  type(variable_type), target, intent(in) :: x
  !> Scalar right operand of type `real` kind `real32`.
  real(real32), intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  real(real32), pointer :: xp(:), resp(:)

  if (x%dtype /= FLOAT_TYPE) error stop &
    & "[mul_var_real32] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp*y
end function mul_var_real32

!> Operator `*` between a scalar `real` and a `variable_type`.
module function mul_real32_var(x, y) result(res)
  !> Scalar left operand of type `real` kind `real32`.
  real(real32), intent(in) :: x
  !> Variable right operand.
  type(variable_type), target, intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  real(real32), pointer :: yp(:), resp(:)

  if (y%dtype /= FLOAT_TYPE) error stop &
    & "[mul_var_real32] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x*yp
end function mul_real32_var

!> Operator `*` between a `variable_type` and a scalar `real`.
module function mul_var_real64(x, y) result(res)
  !> Variable left operand.
  type(variable_type), target, intent(in) :: x
  !> Scalar right operand of type `real` kind `real64`.
  real(real64), intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  real(real64), pointer :: xp(:), resp(:)

  if (x%dtype /= DOUBLE_TYPE) error stop &
    & "[mul_var_real64] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp*y
end function mul_var_real64

!> Operator `*` between a scalar `real` and a `variable_type`.
module function mul_real64_var(x, y) result(res)
  !> Scalar left operand of type `real` kind `real64`.
  real(real64), intent(in) :: x
  !> Variable right operand.
  type(variable_type), target, intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  real(real64), pointer :: yp(:), resp(:)

  if (y%dtype /= DOUBLE_TYPE) error stop &
    & "[mul_var_real64] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x*yp
end function mul_real64_var

!> Element-wise operator `/` for two `variable_type` values.
module function div_vars(x, y) result(res)
  !> Left operand variable.
  type(variable_type), target, intent(in) :: x, y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res

  if (any(x%dims /= y%dims)) &
    & error stop "[add_vars] Unequal dims."
  if (x%dtype /= y%dtype) &
    & error stop "[add_vars] Unequal data type."

  call allocate_variable(res, mold=x)
  select case (x%dtype)
  case (BYTE_TYPE)
    block
      !> Typed pointer view for operands and result.
      integer(int8), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp/yp
    end block
  case (SHORT_TYPE)
    block
      !> Typed pointer view for operands and result.
      integer(int16), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp/yp
    end block
  case (INT_TYPE)
    block
      !> Typed pointer view for operands and result.
      integer(int32), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp/yp
    end block
  case (INT64_TYPE)
    block
      !> Typed pointer view for operands and result.
      integer(int64), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp/yp
    end block
  case (FLOAT_TYPE)
    block
      !> Typed pointer view for operands and result.
      real(real32), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp/yp
    end block
  case (DOUBLE_TYPE)
    block
      !> Typed pointer view for operands and result.
      real(real64), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp/yp
    end block
  end select
end function div_vars

!> Operator `/` between a `variable_type` and a scalar `integer`.
module function div_var_int8(x, y) result(res)
  !> Variable left operand.
  type(variable_type), target, intent(in) :: x
  !> Scalar right operand of type `integer` kind `int8`.
  integer(int8), intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  integer(int8), pointer :: xp(:), resp(:)

  if (x%dtype /= BYTE_TYPE) error stop &
    & "[div_var_int8] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp/y
end function div_var_int8

!> Operator `/` between a scalar `integer` and a `variable_type`.
module function div_int8_var(x, y) result(res)
  !> Scalar left operand of type `integer` kind `int8`.
  integer(int8), intent(in) :: x
  !> Variable right operand.
  type(variable_type), target, intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  integer(int8), pointer :: yp(:), resp(:)

  if (y%dtype /= BYTE_TYPE) error stop &
    & "[div_var_int8] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x/yp
end function div_int8_var

!> Operator `/` between a `variable_type` and a scalar `integer`.
module function div_var_int16(x, y) result(res)
  !> Variable left operand.
  type(variable_type), target, intent(in) :: x
  !> Scalar right operand of type `integer` kind `int16`.
  integer(int16), intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  integer(int16), pointer :: xp(:), resp(:)

  if (x%dtype /= SHORT_TYPE) error stop &
    & "[div_var_int16] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp/y
end function div_var_int16

!> Operator `/` between a scalar `integer` and a `variable_type`.
module function div_int16_var(x, y) result(res)
  !> Scalar left operand of type `integer` kind `int16`.
  integer(int16), intent(in) :: x
  !> Variable right operand.
  type(variable_type), target, intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  integer(int16), pointer :: yp(:), resp(:)

  if (y%dtype /= SHORT_TYPE) error stop &
    & "[div_var_int16] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x/yp
end function div_int16_var

!> Operator `/` between a `variable_type` and a scalar `integer`.
module function div_var_int32(x, y) result(res)
  !> Variable left operand.
  type(variable_type), target, intent(in) :: x
  !> Scalar right operand of type `integer` kind `int32`.
  integer(int32), intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  integer(int32), pointer :: xp(:), resp(:)

  if (x%dtype /= INT_TYPE) error stop &
    & "[div_var_int32] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp/y
end function div_var_int32

!> Operator `/` between a scalar `integer` and a `variable_type`.
module function div_int32_var(x, y) result(res)
  !> Scalar left operand of type `integer` kind `int32`.
  integer(int32), intent(in) :: x
  !> Variable right operand.
  type(variable_type), target, intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  integer(int32), pointer :: yp(:), resp(:)

  if (y%dtype /= INT_TYPE) error stop &
    & "[div_var_int32] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x/yp
end function div_int32_var

!> Operator `/` between a `variable_type` and a scalar `integer`.
module function div_var_int64(x, y) result(res)
  !> Variable left operand.
  type(variable_type), target, intent(in) :: x
  !> Scalar right operand of type `integer` kind `int64`.
  integer(int64), intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  integer(int64), pointer :: xp(:), resp(:)

  if (x%dtype /= INT64_TYPE) error stop &
    & "[div_var_int64] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp/y
end function div_var_int64

!> Operator `/` between a scalar `integer` and a `variable_type`.
module function div_int64_var(x, y) result(res)
  !> Scalar left operand of type `integer` kind `int64`.
  integer(int64), intent(in) :: x
  !> Variable right operand.
  type(variable_type), target, intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  integer(int64), pointer :: yp(:), resp(:)

  if (y%dtype /= INT64_TYPE) error stop &
    & "[div_var_int64] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x/yp
end function div_int64_var

!> Operator `/` between a `variable_type` and a scalar `real`.
module function div_var_real32(x, y) result(res)
  !> Variable left operand.
  type(variable_type), target, intent(in) :: x
  !> Scalar right operand of type `real` kind `real32`.
  real(real32), intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  real(real32), pointer :: xp(:), resp(:)

  if (x%dtype /= FLOAT_TYPE) error stop &
    & "[div_var_real32] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp/y
end function div_var_real32

!> Operator `/` between a scalar `real` and a `variable_type`.
module function div_real32_var(x, y) result(res)
  !> Scalar left operand of type `real` kind `real32`.
  real(real32), intent(in) :: x
  !> Variable right operand.
  type(variable_type), target, intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  real(real32), pointer :: yp(:), resp(:)

  if (y%dtype /= FLOAT_TYPE) error stop &
    & "[div_var_real32] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x/yp
end function div_real32_var

!> Operator `/` between a `variable_type` and a scalar `real`.
module function div_var_real64(x, y) result(res)
  !> Variable left operand.
  type(variable_type), target, intent(in) :: x
  !> Scalar right operand of type `real` kind `real64`.
  real(real64), intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  real(real64), pointer :: xp(:), resp(:)

  if (x%dtype /= DOUBLE_TYPE) error stop &
    & "[div_var_real64] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp/y
end function div_var_real64

!> Operator `/` between a scalar `real` and a `variable_type`.
module function div_real64_var(x, y) result(res)
  !> Scalar left operand of type `real` kind `real64`.
  real(real64), intent(in) :: x
  !> Variable right operand.
  type(variable_type), target, intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  real(real64), pointer :: yp(:), resp(:)

  if (y%dtype /= DOUBLE_TYPE) error stop &
    & "[div_var_real64] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x/yp
end function div_real64_var

!> Element-wise operator `**` for two `variable_type` values.
module function pow_vars(x, y) result(res)
  !> Left operand variable.
  type(variable_type), target, intent(in) :: x, y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res

  if (any(x%dims /= y%dims)) &
    & error stop "[add_vars] Unequal dims."
  if (x%dtype /= y%dtype) &
    & error stop "[add_vars] Unequal data type."

  call allocate_variable(res, mold=x)
  select case (x%dtype)
  case (BYTE_TYPE)
    block
      !> Typed pointer view for operands and result.
      integer(int8), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp**yp
    end block
  case (SHORT_TYPE)
    block
      !> Typed pointer view for operands and result.
      integer(int16), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp**yp
    end block
  case (INT_TYPE)
    block
      !> Typed pointer view for operands and result.
      integer(int32), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp**yp
    end block
  case (INT64_TYPE)
    block
      !> Typed pointer view for operands and result.
      integer(int64), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp**yp
    end block
  case (FLOAT_TYPE)
    block
      !> Typed pointer view for operands and result.
      real(real32), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp**yp
    end block
  case (DOUBLE_TYPE)
    block
      !> Typed pointer view for operands and result.
      real(real64), pointer :: xp(:), yp(:), resp(:)

      call extract(x, xp)
      call extract(y, yp)
      call extract(res, resp)
      resp = xp**yp
    end block
  end select
end function pow_vars

!> Operator `**` between a `variable_type` and a scalar `integer`.
module function pow_var_int8(x, y) result(res)
  !> Variable left operand.
  type(variable_type), target, intent(in) :: x
  !> Scalar right operand of type `integer` kind `int8`.
  integer(int8), intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  integer(int8), pointer :: xp(:), resp(:)

  if (x%dtype /= BYTE_TYPE) error stop &
    & "[pow_var_int8] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp**y
end function pow_var_int8

!> Operator `**` between a scalar `integer` and a `variable_type`.
module function pow_int8_var(x, y) result(res)
  !> Scalar left operand of type `integer` kind `int8`.
  integer(int8), intent(in) :: x
  !> Variable right operand.
  type(variable_type), target, intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  integer(int8), pointer :: yp(:), resp(:)

  if (y%dtype /= BYTE_TYPE) error stop &
    & "[pow_var_int8] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x**yp
end function pow_int8_var

!> Operator `**` between a `variable_type` and a scalar `integer`.
module function pow_var_int16(x, y) result(res)
  !> Variable left operand.
  type(variable_type), target, intent(in) :: x
  !> Scalar right operand of type `integer` kind `int16`.
  integer(int16), intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  integer(int16), pointer :: xp(:), resp(:)

  if (x%dtype /= SHORT_TYPE) error stop &
    & "[pow_var_int16] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp**y
end function pow_var_int16

!> Operator `**` between a scalar `integer` and a `variable_type`.
module function pow_int16_var(x, y) result(res)
  !> Scalar left operand of type `integer` kind `int16`.
  integer(int16), intent(in) :: x
  !> Variable right operand.
  type(variable_type), target, intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  integer(int16), pointer :: yp(:), resp(:)

  if (y%dtype /= SHORT_TYPE) error stop &
    & "[pow_var_int16] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x**yp
end function pow_int16_var

!> Operator `**` between a `variable_type` and a scalar `integer`.
module function pow_var_int32(x, y) result(res)
  !> Variable left operand.
  type(variable_type), target, intent(in) :: x
  !> Scalar right operand of type `integer` kind `int32`.
  integer(int32), intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  integer(int32), pointer :: xp(:), resp(:)

  if (x%dtype /= INT_TYPE) error stop &
    & "[pow_var_int32] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp**y
end function pow_var_int32

!> Operator `**` between a scalar `integer` and a `variable_type`.
module function pow_int32_var(x, y) result(res)
  !> Scalar left operand of type `integer` kind `int32`.
  integer(int32), intent(in) :: x
  !> Variable right operand.
  type(variable_type), target, intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  integer(int32), pointer :: yp(:), resp(:)

  if (y%dtype /= INT_TYPE) error stop &
    & "[pow_var_int32] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x**yp
end function pow_int32_var

!> Operator `**` between a `variable_type` and a scalar `integer`.
module function pow_var_int64(x, y) result(res)
  !> Variable left operand.
  type(variable_type), target, intent(in) :: x
  !> Scalar right operand of type `integer` kind `int64`.
  integer(int64), intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  integer(int64), pointer :: xp(:), resp(:)

  if (x%dtype /= INT64_TYPE) error stop &
    & "[pow_var_int64] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp**y
end function pow_var_int64

!> Operator `**` between a scalar `integer` and a `variable_type`.
module function pow_int64_var(x, y) result(res)
  !> Scalar left operand of type `integer` kind `int64`.
  integer(int64), intent(in) :: x
  !> Variable right operand.
  type(variable_type), target, intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  integer(int64), pointer :: yp(:), resp(:)

  if (y%dtype /= INT64_TYPE) error stop &
    & "[pow_var_int64] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x**yp
end function pow_int64_var

!> Operator `**` between a `variable_type` and a scalar `real`.
module function pow_var_real32(x, y) result(res)
  !> Variable left operand.
  type(variable_type), target, intent(in) :: x
  !> Scalar right operand of type `real` kind `real32`.
  real(real32), intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  real(real32), pointer :: xp(:), resp(:)

  if (x%dtype /= FLOAT_TYPE) error stop &
    & "[pow_var_real32] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp**y
end function pow_var_real32

!> Operator `**` between a scalar `real` and a `variable_type`.
module function pow_real32_var(x, y) result(res)
  !> Scalar left operand of type `real` kind `real32`.
  real(real32), intent(in) :: x
  !> Variable right operand.
  type(variable_type), target, intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  real(real32), pointer :: yp(:), resp(:)

  if (y%dtype /= FLOAT_TYPE) error stop &
    & "[pow_var_real32] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x**yp
end function pow_real32_var

!> Operator `**` between a `variable_type` and a scalar `real`.
module function pow_var_real64(x, y) result(res)
  !> Variable left operand.
  type(variable_type), target, intent(in) :: x
  !> Scalar right operand of type `real` kind `real64`.
  real(real64), intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  real(real64), pointer :: xp(:), resp(:)

  if (x%dtype /= DOUBLE_TYPE) error stop &
    & "[pow_var_real64] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=x)
  call extract(x, xp)
  call extract(res, resp)
  resp = xp**y
end function pow_var_real64

!> Operator `**` between a scalar `real` and a `variable_type`.
module function pow_real64_var(x, y) result(res)
  !> Scalar left operand of type `real` kind `real64`.
  real(real64), intent(in) :: x
  !> Variable right operand.
  type(variable_type), target, intent(in) :: y
  !> Resulting variable containing the element-wise result.
  type(variable_type), target :: res
  !> Pointer view of the variable's data.
  real(real64), pointer :: yp(:), resp(:)

  if (y%dtype /= DOUBLE_TYPE) error stop &
    & "[pow_var_real64] typeof(x) /= typeof(y)."

  call allocate_variable(res, mold=y)
  call extract(y, yp)
  call extract(res, resp)
  resp = x**yp
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
    case (BYTE_TYPE)
      block
        integer(int8), pointer :: s_ptr(:), v_ptr(:)

        call extract(s, s_ptr)
        s_ptr = 0
        do i = 1, n
          call extract(vars(i), v_ptr)
          s_ptr = s_ptr + v_ptr
        end do
      end block
    case (SHORT_TYPE)
      block
        integer(int16), pointer :: s_ptr(:), v_ptr(:)

        call extract(s, s_ptr)
        s_ptr = 0
        do i = 1, n
          call extract(vars(i), v_ptr)
          s_ptr = s_ptr + v_ptr
        end do
      end block
    case (INT_TYPE)
      block
        integer(int32), pointer :: s_ptr(:), v_ptr(:)

        call extract(s, s_ptr)
        s_ptr = 0
        do i = 1, n
          call extract(vars(i), v_ptr)
          s_ptr = s_ptr + v_ptr
        end do
      end block
    case (INT64_TYPE)
      block
        integer(int64), pointer :: s_ptr(:), v_ptr(:)

        call extract(s, s_ptr)
        s_ptr = 0
        do i = 1, n
          call extract(vars(i), v_ptr)
          s_ptr = s_ptr + v_ptr
        end do
      end block
    case (FLOAT_TYPE)
      block
        real(real32), pointer :: s_ptr(:), v_ptr(:)

        call extract(s, s_ptr)
        s_ptr = 0
        do i = 1, n
          call extract(vars(i), v_ptr)
          s_ptr = s_ptr + v_ptr
        end do
      end block
    case (DOUBLE_TYPE)
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

end submodule nc4f_data_struct_arith
