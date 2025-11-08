submodule(module_netcdf) submodule_arithmetic
implicit none
contains

module function add_vars(x, y) result(res)
  type(variable_type), target, intent(in) :: x, y
  type(variable_type), target :: res

  if (any(x%dimensions /= y%dimensions)) &
    & error stop "[add_vars] Unequal dimensions."
  if (x%data_type /= y%data_type) &
    & error stop "[add_vars] Unequal data type."

  res%name = x%name
  res%data_type = x%data_type
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: xp(:), yp(:), resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      call extract(y, yp)
      resp = xp + yp
      nullify (xp, yp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: xp(:), yp(:), resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      call extract(y, yp)
      resp = xp + yp
      nullify (xp, yp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: xp(:), yp(:), resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      call extract(y, yp)
      resp = xp + yp
      nullify (xp, yp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: xp(:), yp(:), resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      call extract(y, yp)
      resp = xp + yp
      nullify (xp, yp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: xp(:), yp(:), resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      call extract(y, yp)
      resp = xp + yp
      nullify (xp, yp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: xp(:), yp(:), resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      call extract(y, yp)
      resp = xp + yp
      nullify (xp, yp, resp)
    end block
  end select
end function add_vars

module function add_var_int8(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  integer(int8), intent(in) :: y
  type(variable_type), target :: res

  res%name = x%name
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: xp(:)
      integer(int8), pointer :: resp(:)

      res%data_type = NC_BYTE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp + y
      nullify (xp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: xp(:)
      integer(int16), pointer :: resp(:)

      res%data_type = NC_SHORT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp + y
      nullify (xp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: xp(:)
      integer(int32), pointer :: resp(:)

      res%data_type = NC_INT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp + y
      nullify (xp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: xp(:)
      integer(int64), pointer :: resp(:)

      res%data_type = NC_INT64
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp + y
      nullify (xp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: xp(:)
      real(real32), pointer :: resp(:)

      res%data_type = NC_FLOAT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp + y
      nullify (xp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp + y
      nullify (xp, resp)
    end block
  end select
end function add_var_int8

module function add_int8_var(x, y) result(res)
  integer(int8), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res

  res%name = y%name
  res%length = y%length
  res%dimensions = y%dimensions
  res%attributes = y%attributes

  select case (y%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: yp(:)
      integer(int8), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x + yp
      nullify (yp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: yp(:)
      integer(int16), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x + yp
      nullify (yp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: yp(:)
      integer(int32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x + yp
      nullify (yp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: yp(:)
      integer(int64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x + yp
      nullify (yp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: yp(:)
      real(real32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x + yp
      nullify (yp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x + yp
      nullify (yp, resp)
    end block
  end select
end function add_int8_var

module function add_var_int16(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  integer(int16), intent(in) :: y
  type(variable_type), target :: res

  res%name = x%name
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: xp(:)
      integer(int16), pointer :: resp(:)

      res%data_type = NC_SHORT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp + y
      nullify (xp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: xp(:)
      integer(int16), pointer :: resp(:)

      res%data_type = NC_SHORT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp + y
      nullify (xp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: xp(:)
      integer(int32), pointer :: resp(:)

      res%data_type = NC_INT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp + y
      nullify (xp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: xp(:)
      integer(int64), pointer :: resp(:)

      res%data_type = NC_INT64
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp + y
      nullify (xp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: xp(:)
      real(real32), pointer :: resp(:)

      res%data_type = NC_FLOAT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp + y
      nullify (xp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp + y
      nullify (xp, resp)
    end block
  end select
end function add_var_int16

module function add_int16_var(x, y) result(res)
  integer(int16), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res

  res%name = y%name
  res%length = y%length
  res%dimensions = y%dimensions
  res%attributes = y%attributes

  select case (y%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: yp(:)
      integer(int16), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x + yp
      nullify (yp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: yp(:)
      integer(int16), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x + yp
      nullify (yp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: yp(:)
      integer(int32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x + yp
      nullify (yp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: yp(:)
      integer(int64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x + yp
      nullify (yp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: yp(:)
      real(real32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x + yp
      nullify (yp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x + yp
      nullify (yp, resp)
    end block
  end select
end function add_int16_var

module function add_var_int32(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  integer(int32), intent(in) :: y
  type(variable_type), target :: res

  res%name = x%name
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: xp(:)
      integer(int32), pointer :: resp(:)

      res%data_type = NC_INT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp + y
      nullify (xp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: xp(:)
      integer(int32), pointer :: resp(:)

      res%data_type = NC_INT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp + y
      nullify (xp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: xp(:)
      integer(int32), pointer :: resp(:)

      res%data_type = NC_INT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp + y
      nullify (xp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: xp(:)
      integer(int64), pointer :: resp(:)

      res%data_type = NC_INT64
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp + y
      nullify (xp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: xp(:)
      real(real32), pointer :: resp(:)

      res%data_type = NC_FLOAT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp + y
      nullify (xp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp + y
      nullify (xp, resp)
    end block
  end select
end function add_var_int32

module function add_int32_var(x, y) result(res)
  integer(int32), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res

  res%name = y%name
  res%length = y%length
  res%dimensions = y%dimensions
  res%attributes = y%attributes

  select case (y%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: yp(:)
      integer(int32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x + yp
      nullify (yp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: yp(:)
      integer(int32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x + yp
      nullify (yp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: yp(:)
      integer(int32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x + yp
      nullify (yp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: yp(:)
      integer(int64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x + yp
      nullify (yp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: yp(:)
      real(real32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x + yp
      nullify (yp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x + yp
      nullify (yp, resp)
    end block
  end select
end function add_int32_var

module function add_var_int64(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  integer(int64), intent(in) :: y
  type(variable_type), target :: res

  res%name = x%name
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: xp(:)
      integer(int64), pointer :: resp(:)

      res%data_type = NC_INT64
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp + y
      nullify (xp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: xp(:)
      integer(int64), pointer :: resp(:)

      res%data_type = NC_INT64
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp + y
      nullify (xp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: xp(:)
      integer(int64), pointer :: resp(:)

      res%data_type = NC_INT64
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp + y
      nullify (xp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: xp(:)
      integer(int64), pointer :: resp(:)

      res%data_type = NC_INT64
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp + y
      nullify (xp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp
      resp = resp + y
      nullify (xp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp + y
      nullify (xp, resp)
    end block
  end select
end function add_var_int64

module function add_int64_var(x, y) result(res)
  integer(int64), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res

  res%name = y%name
  res%length = y%length
  res%dimensions = y%dimensions
  res%attributes = y%attributes

  select case (y%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: yp(:)
      integer(int64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x + yp
      nullify (yp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: yp(:)
      integer(int64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x + yp
      nullify (yp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: yp(:)
      integer(int64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x + yp
      nullify (yp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: yp(:)
      integer(int64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x + yp
      nullify (yp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x
      resp = resp + yp
      nullify (yp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x + yp
      nullify (yp, resp)
    end block
  end select
end function add_int64_var

module function add_var_real32(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  real(real32), intent(in) :: y
  type(variable_type), target :: res

  res%name = x%name
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: xp(:)
      real(real32), pointer :: resp(:)

      res%data_type = NC_FLOAT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp + y
      nullify (xp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: xp(:)
      real(real32), pointer :: resp(:)

      res%data_type = NC_FLOAT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp + y
      nullify (xp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: xp(:)
      real(real32), pointer :: resp(:)

      res%data_type = NC_FLOAT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp + y
      nullify (xp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp
      resp = resp + y
      nullify (xp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: xp(:)
      real(real32), pointer :: resp(:)

      res%data_type = NC_FLOAT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp + y
      nullify (xp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp + y
      nullify (xp, resp)
    end block
  end select
end function add_var_real32

module function add_real32_var(x, y) result(res)
  real(real32), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res

  res%name = y%name
  res%length = y%length
  res%dimensions = y%dimensions
  res%attributes = y%attributes

  select case (y%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: yp(:)
      real(real32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x + yp
      nullify (yp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: yp(:)
      real(real32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x + yp
      nullify (yp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: yp(:)
      real(real32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x + yp
      nullify (yp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x
      resp = resp + yp
      nullify (yp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: yp(:)
      real(real32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x + yp
      nullify (yp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x + yp
      nullify (yp, resp)
    end block
  end select
end function add_real32_var

module function add_var_real64(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  real(real64), intent(in) :: y
  type(variable_type), target :: res

  res%name = x%name
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp + y
      nullify (xp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp + y
      nullify (xp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp + y
      nullify (xp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp + y
      nullify (xp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp + y
      nullify (xp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp + y
      nullify (xp, resp)
    end block
  end select
end function add_var_real64

module function add_real64_var(x, y) result(res)
  real(real64), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res

  res%name = y%name
  res%length = y%length
  res%dimensions = y%dimensions
  res%attributes = y%attributes

  select case (y%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x + yp
      nullify (yp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x + yp
      nullify (yp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x + yp
      nullify (yp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x + yp
      nullify (yp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x + yp
      nullify (yp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x + yp
      nullify (yp, resp)
    end block
  end select
end function add_real64_var

module function sub_vars(x, y) result(res)
  type(variable_type), target, intent(in) :: x, y
  type(variable_type), target :: res

  if (any(x%dimensions /= y%dimensions)) &
    & error stop "[add_vars] Unequal dimensions."
  if (x%data_type /= y%data_type) &
    & error stop "[add_vars] Unequal data type."

  res%name = x%name
  res%data_type = x%data_type
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: xp(:), yp(:), resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      call extract(y, yp)
      resp = xp - yp
      nullify (xp, yp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: xp(:), yp(:), resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      call extract(y, yp)
      resp = xp - yp
      nullify (xp, yp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: xp(:), yp(:), resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      call extract(y, yp)
      resp = xp - yp
      nullify (xp, yp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: xp(:), yp(:), resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      call extract(y, yp)
      resp = xp - yp
      nullify (xp, yp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: xp(:), yp(:), resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      call extract(y, yp)
      resp = xp - yp
      nullify (xp, yp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: xp(:), yp(:), resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      call extract(y, yp)
      resp = xp - yp
      nullify (xp, yp, resp)
    end block
  end select
end function sub_vars

module function sub_var_int8(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  integer(int8), intent(in) :: y
  type(variable_type), target :: res

  res%name = x%name
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: xp(:)
      integer(int8), pointer :: resp(:)

      res%data_type = NC_BYTE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp - y
      nullify (xp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: xp(:)
      integer(int16), pointer :: resp(:)

      res%data_type = NC_SHORT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp - y
      nullify (xp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: xp(:)
      integer(int32), pointer :: resp(:)

      res%data_type = NC_INT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp - y
      nullify (xp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: xp(:)
      integer(int64), pointer :: resp(:)

      res%data_type = NC_INT64
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp - y
      nullify (xp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: xp(:)
      real(real32), pointer :: resp(:)

      res%data_type = NC_FLOAT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp - y
      nullify (xp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp - y
      nullify (xp, resp)
    end block
  end select
end function sub_var_int8

module function sub_int8_var(x, y) result(res)
  integer(int8), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res

  res%name = y%name
  res%length = y%length
  res%dimensions = y%dimensions
  res%attributes = y%attributes

  select case (y%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: yp(:)
      integer(int8), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x - yp
      nullify (yp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: yp(:)
      integer(int16), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x - yp
      nullify (yp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: yp(:)
      integer(int32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x - yp
      nullify (yp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: yp(:)
      integer(int64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x - yp
      nullify (yp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: yp(:)
      real(real32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x - yp
      nullify (yp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x - yp
      nullify (yp, resp)
    end block
  end select
end function sub_int8_var

module function sub_var_int16(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  integer(int16), intent(in) :: y
  type(variable_type), target :: res

  res%name = x%name
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: xp(:)
      integer(int16), pointer :: resp(:)

      res%data_type = NC_SHORT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp - y
      nullify (xp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: xp(:)
      integer(int16), pointer :: resp(:)

      res%data_type = NC_SHORT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp - y
      nullify (xp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: xp(:)
      integer(int32), pointer :: resp(:)

      res%data_type = NC_INT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp - y
      nullify (xp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: xp(:)
      integer(int64), pointer :: resp(:)

      res%data_type = NC_INT64
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp - y
      nullify (xp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: xp(:)
      real(real32), pointer :: resp(:)

      res%data_type = NC_FLOAT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp - y
      nullify (xp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp - y
      nullify (xp, resp)
    end block
  end select
end function sub_var_int16

module function sub_int16_var(x, y) result(res)
  integer(int16), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res

  res%name = y%name
  res%length = y%length
  res%dimensions = y%dimensions
  res%attributes = y%attributes

  select case (y%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: yp(:)
      integer(int16), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x - yp
      nullify (yp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: yp(:)
      integer(int16), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x - yp
      nullify (yp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: yp(:)
      integer(int32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x - yp
      nullify (yp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: yp(:)
      integer(int64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x - yp
      nullify (yp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: yp(:)
      real(real32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x - yp
      nullify (yp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x - yp
      nullify (yp, resp)
    end block
  end select
end function sub_int16_var

module function sub_var_int32(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  integer(int32), intent(in) :: y
  type(variable_type), target :: res

  res%name = x%name
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: xp(:)
      integer(int32), pointer :: resp(:)

      res%data_type = NC_INT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp - y
      nullify (xp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: xp(:)
      integer(int32), pointer :: resp(:)

      res%data_type = NC_INT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp - y
      nullify (xp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: xp(:)
      integer(int32), pointer :: resp(:)

      res%data_type = NC_INT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp - y
      nullify (xp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: xp(:)
      integer(int64), pointer :: resp(:)

      res%data_type = NC_INT64
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp - y
      nullify (xp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: xp(:)
      real(real32), pointer :: resp(:)

      res%data_type = NC_FLOAT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp - y
      nullify (xp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp - y
      nullify (xp, resp)
    end block
  end select
end function sub_var_int32

module function sub_int32_var(x, y) result(res)
  integer(int32), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res

  res%name = y%name
  res%length = y%length
  res%dimensions = y%dimensions
  res%attributes = y%attributes

  select case (y%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: yp(:)
      integer(int32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x - yp
      nullify (yp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: yp(:)
      integer(int32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x - yp
      nullify (yp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: yp(:)
      integer(int32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x - yp
      nullify (yp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: yp(:)
      integer(int64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x - yp
      nullify (yp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: yp(:)
      real(real32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x - yp
      nullify (yp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x - yp
      nullify (yp, resp)
    end block
  end select
end function sub_int32_var

module function sub_var_int64(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  integer(int64), intent(in) :: y
  type(variable_type), target :: res

  res%name = x%name
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: xp(:)
      integer(int64), pointer :: resp(:)

      res%data_type = NC_INT64
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp - y
      nullify (xp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: xp(:)
      integer(int64), pointer :: resp(:)

      res%data_type = NC_INT64
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp - y
      nullify (xp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: xp(:)
      integer(int64), pointer :: resp(:)

      res%data_type = NC_INT64
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp - y
      nullify (xp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: xp(:)
      integer(int64), pointer :: resp(:)

      res%data_type = NC_INT64
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp - y
      nullify (xp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp
      resp = resp - y
      nullify (xp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp - y
      nullify (xp, resp)
    end block
  end select
end function sub_var_int64

module function sub_int64_var(x, y) result(res)
  integer(int64), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res

  res%name = y%name
  res%length = y%length
  res%dimensions = y%dimensions
  res%attributes = y%attributes

  select case (y%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: yp(:)
      integer(int64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x - yp
      nullify (yp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: yp(:)
      integer(int64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x - yp
      nullify (yp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: yp(:)
      integer(int64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x - yp
      nullify (yp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: yp(:)
      integer(int64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x - yp
      nullify (yp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x
      resp = resp - yp
      nullify (yp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x - yp
      nullify (yp, resp)
    end block
  end select
end function sub_int64_var

module function sub_var_real32(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  real(real32), intent(in) :: y
  type(variable_type), target :: res

  res%name = x%name
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: xp(:)
      real(real32), pointer :: resp(:)

      res%data_type = NC_FLOAT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp - y
      nullify (xp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: xp(:)
      real(real32), pointer :: resp(:)

      res%data_type = NC_FLOAT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp - y
      nullify (xp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: xp(:)
      real(real32), pointer :: resp(:)

      res%data_type = NC_FLOAT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp - y
      nullify (xp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp
      resp = resp - y
      nullify (xp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: xp(:)
      real(real32), pointer :: resp(:)

      res%data_type = NC_FLOAT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp - y
      nullify (xp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp - y
      nullify (xp, resp)
    end block
  end select
end function sub_var_real32

module function sub_real32_var(x, y) result(res)
  real(real32), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res

  res%name = y%name
  res%length = y%length
  res%dimensions = y%dimensions
  res%attributes = y%attributes

  select case (y%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: yp(:)
      real(real32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x - yp
      nullify (yp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: yp(:)
      real(real32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x - yp
      nullify (yp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: yp(:)
      real(real32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x - yp
      nullify (yp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x
      resp = resp - yp
      nullify (yp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: yp(:)
      real(real32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x - yp
      nullify (yp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x - yp
      nullify (yp, resp)
    end block
  end select
end function sub_real32_var

module function sub_var_real64(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  real(real64), intent(in) :: y
  type(variable_type), target :: res

  res%name = x%name
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp - y
      nullify (xp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp - y
      nullify (xp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp - y
      nullify (xp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp - y
      nullify (xp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp - y
      nullify (xp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp - y
      nullify (xp, resp)
    end block
  end select
end function sub_var_real64

module function sub_real64_var(x, y) result(res)
  real(real64), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res

  res%name = y%name
  res%length = y%length
  res%dimensions = y%dimensions
  res%attributes = y%attributes

  select case (y%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x - yp
      nullify (yp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x - yp
      nullify (yp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x - yp
      nullify (yp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x - yp
      nullify (yp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x - yp
      nullify (yp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x - yp
      nullify (yp, resp)
    end block
  end select
end function sub_real64_var

module function mul_vars(x, y) result(res)
  type(variable_type), target, intent(in) :: x, y
  type(variable_type), target :: res

  if (any(x%dimensions /= y%dimensions)) &
    & error stop "[add_vars] Unequal dimensions."
  if (x%data_type /= y%data_type) &
    & error stop "[add_vars] Unequal data type."

  res%name = x%name
  res%data_type = x%data_type
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: xp(:), yp(:), resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      call extract(y, yp)
      resp = xp * yp
      nullify (xp, yp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: xp(:), yp(:), resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      call extract(y, yp)
      resp = xp * yp
      nullify (xp, yp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: xp(:), yp(:), resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      call extract(y, yp)
      resp = xp * yp
      nullify (xp, yp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: xp(:), yp(:), resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      call extract(y, yp)
      resp = xp * yp
      nullify (xp, yp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: xp(:), yp(:), resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      call extract(y, yp)
      resp = xp * yp
      nullify (xp, yp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: xp(:), yp(:), resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      call extract(y, yp)
      resp = xp * yp
      nullify (xp, yp, resp)
    end block
  end select
end function mul_vars

module function mul_var_int8(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  integer(int8), intent(in) :: y
  type(variable_type), target :: res

  res%name = x%name
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: xp(:)
      integer(int8), pointer :: resp(:)

      res%data_type = NC_BYTE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp * y
      nullify (xp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: xp(:)
      integer(int16), pointer :: resp(:)

      res%data_type = NC_SHORT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp * y
      nullify (xp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: xp(:)
      integer(int32), pointer :: resp(:)

      res%data_type = NC_INT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp * y
      nullify (xp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: xp(:)
      integer(int64), pointer :: resp(:)

      res%data_type = NC_INT64
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp * y
      nullify (xp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: xp(:)
      real(real32), pointer :: resp(:)

      res%data_type = NC_FLOAT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp * y
      nullify (xp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp * y
      nullify (xp, resp)
    end block
  end select
end function mul_var_int8

module function mul_int8_var(x, y) result(res)
  integer(int8), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res

  res%name = y%name
  res%length = y%length
  res%dimensions = y%dimensions
  res%attributes = y%attributes

  select case (y%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: yp(:)
      integer(int8), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x * yp
      nullify (yp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: yp(:)
      integer(int16), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x * yp
      nullify (yp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: yp(:)
      integer(int32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x * yp
      nullify (yp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: yp(:)
      integer(int64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x * yp
      nullify (yp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: yp(:)
      real(real32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x * yp
      nullify (yp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x * yp
      nullify (yp, resp)
    end block
  end select
end function mul_int8_var

module function mul_var_int16(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  integer(int16), intent(in) :: y
  type(variable_type), target :: res

  res%name = x%name
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: xp(:)
      integer(int16), pointer :: resp(:)

      res%data_type = NC_SHORT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp * y
      nullify (xp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: xp(:)
      integer(int16), pointer :: resp(:)

      res%data_type = NC_SHORT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp * y
      nullify (xp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: xp(:)
      integer(int32), pointer :: resp(:)

      res%data_type = NC_INT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp * y
      nullify (xp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: xp(:)
      integer(int64), pointer :: resp(:)

      res%data_type = NC_INT64
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp * y
      nullify (xp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: xp(:)
      real(real32), pointer :: resp(:)

      res%data_type = NC_FLOAT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp * y
      nullify (xp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp * y
      nullify (xp, resp)
    end block
  end select
end function mul_var_int16

module function mul_int16_var(x, y) result(res)
  integer(int16), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res

  res%name = y%name
  res%length = y%length
  res%dimensions = y%dimensions
  res%attributes = y%attributes

  select case (y%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: yp(:)
      integer(int16), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x * yp
      nullify (yp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: yp(:)
      integer(int16), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x * yp
      nullify (yp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: yp(:)
      integer(int32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x * yp
      nullify (yp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: yp(:)
      integer(int64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x * yp
      nullify (yp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: yp(:)
      real(real32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x * yp
      nullify (yp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x * yp
      nullify (yp, resp)
    end block
  end select
end function mul_int16_var

module function mul_var_int32(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  integer(int32), intent(in) :: y
  type(variable_type), target :: res

  res%name = x%name
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: xp(:)
      integer(int32), pointer :: resp(:)

      res%data_type = NC_INT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp * y
      nullify (xp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: xp(:)
      integer(int32), pointer :: resp(:)

      res%data_type = NC_INT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp * y
      nullify (xp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: xp(:)
      integer(int32), pointer :: resp(:)

      res%data_type = NC_INT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp * y
      nullify (xp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: xp(:)
      integer(int64), pointer :: resp(:)

      res%data_type = NC_INT64
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp * y
      nullify (xp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: xp(:)
      real(real32), pointer :: resp(:)

      res%data_type = NC_FLOAT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp * y
      nullify (xp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp * y
      nullify (xp, resp)
    end block
  end select
end function mul_var_int32

module function mul_int32_var(x, y) result(res)
  integer(int32), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res

  res%name = y%name
  res%length = y%length
  res%dimensions = y%dimensions
  res%attributes = y%attributes

  select case (y%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: yp(:)
      integer(int32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x * yp
      nullify (yp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: yp(:)
      integer(int32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x * yp
      nullify (yp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: yp(:)
      integer(int32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x * yp
      nullify (yp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: yp(:)
      integer(int64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x * yp
      nullify (yp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: yp(:)
      real(real32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x * yp
      nullify (yp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x * yp
      nullify (yp, resp)
    end block
  end select
end function mul_int32_var

module function mul_var_int64(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  integer(int64), intent(in) :: y
  type(variable_type), target :: res

  res%name = x%name
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: xp(:)
      integer(int64), pointer :: resp(:)

      res%data_type = NC_INT64
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp * y
      nullify (xp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: xp(:)
      integer(int64), pointer :: resp(:)

      res%data_type = NC_INT64
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp * y
      nullify (xp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: xp(:)
      integer(int64), pointer :: resp(:)

      res%data_type = NC_INT64
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp * y
      nullify (xp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: xp(:)
      integer(int64), pointer :: resp(:)

      res%data_type = NC_INT64
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp * y
      nullify (xp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp
      resp = resp * y
      nullify (xp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp * y
      nullify (xp, resp)
    end block
  end select
end function mul_var_int64

module function mul_int64_var(x, y) result(res)
  integer(int64), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res

  res%name = y%name
  res%length = y%length
  res%dimensions = y%dimensions
  res%attributes = y%attributes

  select case (y%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: yp(:)
      integer(int64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x * yp
      nullify (yp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: yp(:)
      integer(int64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x * yp
      nullify (yp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: yp(:)
      integer(int64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x * yp
      nullify (yp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: yp(:)
      integer(int64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x * yp
      nullify (yp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x
      resp = resp * yp
      nullify (yp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x * yp
      nullify (yp, resp)
    end block
  end select
end function mul_int64_var

module function mul_var_real32(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  real(real32), intent(in) :: y
  type(variable_type), target :: res

  res%name = x%name
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: xp(:)
      real(real32), pointer :: resp(:)

      res%data_type = NC_FLOAT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp * y
      nullify (xp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: xp(:)
      real(real32), pointer :: resp(:)

      res%data_type = NC_FLOAT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp * y
      nullify (xp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: xp(:)
      real(real32), pointer :: resp(:)

      res%data_type = NC_FLOAT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp * y
      nullify (xp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp
      resp = resp * y
      nullify (xp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: xp(:)
      real(real32), pointer :: resp(:)

      res%data_type = NC_FLOAT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp * y
      nullify (xp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp * y
      nullify (xp, resp)
    end block
  end select
end function mul_var_real32

module function mul_real32_var(x, y) result(res)
  real(real32), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res

  res%name = y%name
  res%length = y%length
  res%dimensions = y%dimensions
  res%attributes = y%attributes

  select case (y%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: yp(:)
      real(real32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x * yp
      nullify (yp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: yp(:)
      real(real32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x * yp
      nullify (yp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: yp(:)
      real(real32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x * yp
      nullify (yp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x
      resp = resp * yp
      nullify (yp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: yp(:)
      real(real32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x * yp
      nullify (yp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x * yp
      nullify (yp, resp)
    end block
  end select
end function mul_real32_var

module function mul_var_real64(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  real(real64), intent(in) :: y
  type(variable_type), target :: res

  res%name = x%name
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp * y
      nullify (xp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp * y
      nullify (xp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp * y
      nullify (xp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp * y
      nullify (xp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp * y
      nullify (xp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp * y
      nullify (xp, resp)
    end block
  end select
end function mul_var_real64

module function mul_real64_var(x, y) result(res)
  real(real64), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res

  res%name = y%name
  res%length = y%length
  res%dimensions = y%dimensions
  res%attributes = y%attributes

  select case (y%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x * yp
      nullify (yp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x * yp
      nullify (yp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x * yp
      nullify (yp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x * yp
      nullify (yp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x * yp
      nullify (yp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x * yp
      nullify (yp, resp)
    end block
  end select
end function mul_real64_var

module function div_vars(x, y) result(res)
  type(variable_type), target, intent(in) :: x, y
  type(variable_type), target :: res

  if (any(x%dimensions /= y%dimensions)) &
    & error stop "[add_vars] Unequal dimensions."
  if (x%data_type /= y%data_type) &
    & error stop "[add_vars] Unequal data type."

  res%name = x%name
  res%data_type = x%data_type
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: xp(:), yp(:), resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      call extract(y, yp)
      resp = xp / yp
      nullify (xp, yp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: xp(:), yp(:), resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      call extract(y, yp)
      resp = xp / yp
      nullify (xp, yp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: xp(:), yp(:), resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      call extract(y, yp)
      resp = xp / yp
      nullify (xp, yp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: xp(:), yp(:), resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      call extract(y, yp)
      resp = xp / yp
      nullify (xp, yp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: xp(:), yp(:), resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      call extract(y, yp)
      resp = xp / yp
      nullify (xp, yp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: xp(:), yp(:), resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      call extract(y, yp)
      resp = xp / yp
      nullify (xp, yp, resp)
    end block
  end select
end function div_vars

module function div_var_int8(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  integer(int8), intent(in) :: y
  type(variable_type), target :: res

  res%name = x%name
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: xp(:)
      integer(int8), pointer :: resp(:)

      res%data_type = NC_BYTE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp / y
      nullify (xp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: xp(:)
      integer(int16), pointer :: resp(:)

      res%data_type = NC_SHORT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp / y
      nullify (xp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: xp(:)
      integer(int32), pointer :: resp(:)

      res%data_type = NC_INT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp / y
      nullify (xp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: xp(:)
      integer(int64), pointer :: resp(:)

      res%data_type = NC_INT64
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp / y
      nullify (xp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: xp(:)
      real(real32), pointer :: resp(:)

      res%data_type = NC_FLOAT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp / y
      nullify (xp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp / y
      nullify (xp, resp)
    end block
  end select
end function div_var_int8

module function div_int8_var(x, y) result(res)
  integer(int8), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res

  res%name = y%name
  res%length = y%length
  res%dimensions = y%dimensions
  res%attributes = y%attributes

  select case (y%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: yp(:)
      integer(int8), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x / yp
      nullify (yp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: yp(:)
      integer(int16), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x / yp
      nullify (yp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: yp(:)
      integer(int32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x / yp
      nullify (yp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: yp(:)
      integer(int64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x / yp
      nullify (yp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: yp(:)
      real(real32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x / yp
      nullify (yp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x / yp
      nullify (yp, resp)
    end block
  end select
end function div_int8_var

module function div_var_int16(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  integer(int16), intent(in) :: y
  type(variable_type), target :: res

  res%name = x%name
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: xp(:)
      integer(int16), pointer :: resp(:)

      res%data_type = NC_SHORT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp / y
      nullify (xp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: xp(:)
      integer(int16), pointer :: resp(:)

      res%data_type = NC_SHORT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp / y
      nullify (xp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: xp(:)
      integer(int32), pointer :: resp(:)

      res%data_type = NC_INT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp / y
      nullify (xp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: xp(:)
      integer(int64), pointer :: resp(:)

      res%data_type = NC_INT64
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp / y
      nullify (xp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: xp(:)
      real(real32), pointer :: resp(:)

      res%data_type = NC_FLOAT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp / y
      nullify (xp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp / y
      nullify (xp, resp)
    end block
  end select
end function div_var_int16

module function div_int16_var(x, y) result(res)
  integer(int16), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res

  res%name = y%name
  res%length = y%length
  res%dimensions = y%dimensions
  res%attributes = y%attributes

  select case (y%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: yp(:)
      integer(int16), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x / yp
      nullify (yp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: yp(:)
      integer(int16), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x / yp
      nullify (yp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: yp(:)
      integer(int32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x / yp
      nullify (yp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: yp(:)
      integer(int64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x / yp
      nullify (yp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: yp(:)
      real(real32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x / yp
      nullify (yp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x / yp
      nullify (yp, resp)
    end block
  end select
end function div_int16_var

module function div_var_int32(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  integer(int32), intent(in) :: y
  type(variable_type), target :: res

  res%name = x%name
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: xp(:)
      integer(int32), pointer :: resp(:)

      res%data_type = NC_INT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp / y
      nullify (xp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: xp(:)
      integer(int32), pointer :: resp(:)

      res%data_type = NC_INT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp / y
      nullify (xp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: xp(:)
      integer(int32), pointer :: resp(:)

      res%data_type = NC_INT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp / y
      nullify (xp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: xp(:)
      integer(int64), pointer :: resp(:)

      res%data_type = NC_INT64
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp / y
      nullify (xp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: xp(:)
      real(real32), pointer :: resp(:)

      res%data_type = NC_FLOAT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp / y
      nullify (xp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp / y
      nullify (xp, resp)
    end block
  end select
end function div_var_int32

module function div_int32_var(x, y) result(res)
  integer(int32), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res

  res%name = y%name
  res%length = y%length
  res%dimensions = y%dimensions
  res%attributes = y%attributes

  select case (y%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: yp(:)
      integer(int32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x / yp
      nullify (yp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: yp(:)
      integer(int32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x / yp
      nullify (yp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: yp(:)
      integer(int32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x / yp
      nullify (yp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: yp(:)
      integer(int64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x / yp
      nullify (yp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: yp(:)
      real(real32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x / yp
      nullify (yp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x / yp
      nullify (yp, resp)
    end block
  end select
end function div_int32_var

module function div_var_int64(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  integer(int64), intent(in) :: y
  type(variable_type), target :: res

  res%name = x%name
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: xp(:)
      integer(int64), pointer :: resp(:)

      res%data_type = NC_INT64
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp / y
      nullify (xp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: xp(:)
      integer(int64), pointer :: resp(:)

      res%data_type = NC_INT64
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp / y
      nullify (xp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: xp(:)
      integer(int64), pointer :: resp(:)

      res%data_type = NC_INT64
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp / y
      nullify (xp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: xp(:)
      integer(int64), pointer :: resp(:)

      res%data_type = NC_INT64
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp / y
      nullify (xp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp
      resp = resp / y
      nullify (xp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp / y
      nullify (xp, resp)
    end block
  end select
end function div_var_int64

module function div_int64_var(x, y) result(res)
  integer(int64), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res

  res%name = y%name
  res%length = y%length
  res%dimensions = y%dimensions
  res%attributes = y%attributes

  select case (y%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: yp(:)
      integer(int64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x / yp
      nullify (yp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: yp(:)
      integer(int64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x / yp
      nullify (yp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: yp(:)
      integer(int64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x / yp
      nullify (yp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: yp(:)
      integer(int64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x / yp
      nullify (yp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x
      resp = resp / yp
      nullify (yp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x / yp
      nullify (yp, resp)
    end block
  end select
end function div_int64_var

module function div_var_real32(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  real(real32), intent(in) :: y
  type(variable_type), target :: res

  res%name = x%name
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: xp(:)
      real(real32), pointer :: resp(:)

      res%data_type = NC_FLOAT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp / y
      nullify (xp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: xp(:)
      real(real32), pointer :: resp(:)

      res%data_type = NC_FLOAT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp / y
      nullify (xp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: xp(:)
      real(real32), pointer :: resp(:)

      res%data_type = NC_FLOAT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp / y
      nullify (xp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp
      resp = resp / y
      nullify (xp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: xp(:)
      real(real32), pointer :: resp(:)

      res%data_type = NC_FLOAT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp / y
      nullify (xp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp / y
      nullify (xp, resp)
    end block
  end select
end function div_var_real32

module function div_real32_var(x, y) result(res)
  real(real32), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res

  res%name = y%name
  res%length = y%length
  res%dimensions = y%dimensions
  res%attributes = y%attributes

  select case (y%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: yp(:)
      real(real32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x / yp
      nullify (yp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: yp(:)
      real(real32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x / yp
      nullify (yp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: yp(:)
      real(real32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x / yp
      nullify (yp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x
      resp = resp / yp
      nullify (yp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: yp(:)
      real(real32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x / yp
      nullify (yp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x / yp
      nullify (yp, resp)
    end block
  end select
end function div_real32_var

module function div_var_real64(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  real(real64), intent(in) :: y
  type(variable_type), target :: res

  res%name = x%name
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp / y
      nullify (xp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp / y
      nullify (xp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp / y
      nullify (xp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp / y
      nullify (xp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp / y
      nullify (xp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp / y
      nullify (xp, resp)
    end block
  end select
end function div_var_real64

module function div_real64_var(x, y) result(res)
  real(real64), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res

  res%name = y%name
  res%length = y%length
  res%dimensions = y%dimensions
  res%attributes = y%attributes

  select case (y%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x / yp
      nullify (yp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x / yp
      nullify (yp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x / yp
      nullify (yp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x / yp
      nullify (yp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x / yp
      nullify (yp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x / yp
      nullify (yp, resp)
    end block
  end select
end function div_real64_var

module function pow_vars(x, y) result(res)
  type(variable_type), target, intent(in) :: x, y
  type(variable_type), target :: res

  if (any(x%dimensions /= y%dimensions)) &
    & error stop "[add_vars] Unequal dimensions."
  if (x%data_type /= y%data_type) &
    & error stop "[add_vars] Unequal data type."

  res%name = x%name
  res%data_type = x%data_type
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: xp(:), yp(:), resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      call extract(y, yp)
      resp = xp ** yp
      nullify (xp, yp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: xp(:), yp(:), resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      call extract(y, yp)
      resp = xp ** yp
      nullify (xp, yp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: xp(:), yp(:), resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      call extract(y, yp)
      resp = xp ** yp
      nullify (xp, yp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: xp(:), yp(:), resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      call extract(y, yp)
      resp = xp ** yp
      nullify (xp, yp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: xp(:), yp(:), resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      call extract(y, yp)
      resp = xp ** yp
      nullify (xp, yp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: xp(:), yp(:), resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      call extract(y, yp)
      resp = xp ** yp
      nullify (xp, yp, resp)
    end block
  end select
end function pow_vars

module function pow_var_int8(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  integer(int8), intent(in) :: y
  type(variable_type), target :: res

  res%name = x%name
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: xp(:)
      integer(int8), pointer :: resp(:)

      res%data_type = NC_BYTE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp ** y
      nullify (xp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: xp(:)
      integer(int16), pointer :: resp(:)

      res%data_type = NC_SHORT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp ** y
      nullify (xp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: xp(:)
      integer(int32), pointer :: resp(:)

      res%data_type = NC_INT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp ** y
      nullify (xp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: xp(:)
      integer(int64), pointer :: resp(:)

      res%data_type = NC_INT64
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp ** y
      nullify (xp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: xp(:)
      real(real32), pointer :: resp(:)

      res%data_type = NC_FLOAT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp ** y
      nullify (xp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp ** y
      nullify (xp, resp)
    end block
  end select
end function pow_var_int8

module function pow_int8_var(x, y) result(res)
  integer(int8), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res

  res%name = y%name
  res%length = y%length
  res%dimensions = y%dimensions
  res%attributes = y%attributes

  select case (y%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: yp(:)
      integer(int8), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x ** yp
      nullify (yp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: yp(:)
      integer(int16), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x ** yp
      nullify (yp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: yp(:)
      integer(int32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x ** yp
      nullify (yp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: yp(:)
      integer(int64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x ** yp
      nullify (yp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: yp(:)
      real(real32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x ** yp
      nullify (yp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x ** yp
      nullify (yp, resp)
    end block
  end select
end function pow_int8_var

module function pow_var_int16(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  integer(int16), intent(in) :: y
  type(variable_type), target :: res

  res%name = x%name
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: xp(:)
      integer(int16), pointer :: resp(:)

      res%data_type = NC_SHORT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp ** y
      nullify (xp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: xp(:)
      integer(int16), pointer :: resp(:)

      res%data_type = NC_SHORT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp ** y
      nullify (xp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: xp(:)
      integer(int32), pointer :: resp(:)

      res%data_type = NC_INT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp ** y
      nullify (xp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: xp(:)
      integer(int64), pointer :: resp(:)

      res%data_type = NC_INT64
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp ** y
      nullify (xp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: xp(:)
      real(real32), pointer :: resp(:)

      res%data_type = NC_FLOAT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp ** y
      nullify (xp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp ** y
      nullify (xp, resp)
    end block
  end select
end function pow_var_int16

module function pow_int16_var(x, y) result(res)
  integer(int16), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res

  res%name = y%name
  res%length = y%length
  res%dimensions = y%dimensions
  res%attributes = y%attributes

  select case (y%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: yp(:)
      integer(int16), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x ** yp
      nullify (yp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: yp(:)
      integer(int16), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x ** yp
      nullify (yp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: yp(:)
      integer(int32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x ** yp
      nullify (yp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: yp(:)
      integer(int64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x ** yp
      nullify (yp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: yp(:)
      real(real32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x ** yp
      nullify (yp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x ** yp
      nullify (yp, resp)
    end block
  end select
end function pow_int16_var

module function pow_var_int32(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  integer(int32), intent(in) :: y
  type(variable_type), target :: res

  res%name = x%name
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: xp(:)
      integer(int32), pointer :: resp(:)

      res%data_type = NC_INT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp ** y
      nullify (xp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: xp(:)
      integer(int32), pointer :: resp(:)

      res%data_type = NC_INT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp ** y
      nullify (xp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: xp(:)
      integer(int32), pointer :: resp(:)

      res%data_type = NC_INT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp ** y
      nullify (xp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: xp(:)
      integer(int64), pointer :: resp(:)

      res%data_type = NC_INT64
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp ** y
      nullify (xp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: xp(:)
      real(real32), pointer :: resp(:)

      res%data_type = NC_FLOAT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp ** y
      nullify (xp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp ** y
      nullify (xp, resp)
    end block
  end select
end function pow_var_int32

module function pow_int32_var(x, y) result(res)
  integer(int32), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res

  res%name = y%name
  res%length = y%length
  res%dimensions = y%dimensions
  res%attributes = y%attributes

  select case (y%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: yp(:)
      integer(int32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x ** yp
      nullify (yp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: yp(:)
      integer(int32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x ** yp
      nullify (yp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: yp(:)
      integer(int32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x ** yp
      nullify (yp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: yp(:)
      integer(int64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x ** yp
      nullify (yp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: yp(:)
      real(real32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x ** yp
      nullify (yp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x ** yp
      nullify (yp, resp)
    end block
  end select
end function pow_int32_var

module function pow_var_int64(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  integer(int64), intent(in) :: y
  type(variable_type), target :: res

  res%name = x%name
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: xp(:)
      integer(int64), pointer :: resp(:)

      res%data_type = NC_INT64
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp ** y
      nullify (xp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: xp(:)
      integer(int64), pointer :: resp(:)

      res%data_type = NC_INT64
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp ** y
      nullify (xp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: xp(:)
      integer(int64), pointer :: resp(:)

      res%data_type = NC_INT64
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp ** y
      nullify (xp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: xp(:)
      integer(int64), pointer :: resp(:)

      res%data_type = NC_INT64
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp ** y
      nullify (xp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp
      resp = resp ** y
      nullify (xp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp ** y
      nullify (xp, resp)
    end block
  end select
end function pow_var_int64

module function pow_int64_var(x, y) result(res)
  integer(int64), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res

  res%name = y%name
  res%length = y%length
  res%dimensions = y%dimensions
  res%attributes = y%attributes

  select case (y%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: yp(:)
      integer(int64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x ** yp
      nullify (yp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: yp(:)
      integer(int64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x ** yp
      nullify (yp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: yp(:)
      integer(int64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x ** yp
      nullify (yp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: yp(:)
      integer(int64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x ** yp
      nullify (yp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x
      resp = resp ** yp
      nullify (yp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x ** yp
      nullify (yp, resp)
    end block
  end select
end function pow_int64_var

module function pow_var_real32(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  real(real32), intent(in) :: y
  type(variable_type), target :: res

  res%name = x%name
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: xp(:)
      real(real32), pointer :: resp(:)

      res%data_type = NC_FLOAT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp ** y
      nullify (xp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: xp(:)
      real(real32), pointer :: resp(:)

      res%data_type = NC_FLOAT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp ** y
      nullify (xp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: xp(:)
      real(real32), pointer :: resp(:)

      res%data_type = NC_FLOAT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp ** y
      nullify (xp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp
      resp = resp ** y
      nullify (xp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: xp(:)
      real(real32), pointer :: resp(:)

      res%data_type = NC_FLOAT
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp ** y
      nullify (xp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp ** y
      nullify (xp, resp)
    end block
  end select
end function pow_var_real32

module function pow_real32_var(x, y) result(res)
  real(real32), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res

  res%name = y%name
  res%length = y%length
  res%dimensions = y%dimensions
  res%attributes = y%attributes

  select case (y%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: yp(:)
      real(real32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x ** yp
      nullify (yp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: yp(:)
      real(real32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x ** yp
      nullify (yp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: yp(:)
      real(real32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x ** yp
      nullify (yp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x
      resp = resp ** yp
      nullify (yp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: yp(:)
      real(real32), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x ** yp
      nullify (yp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x ** yp
      nullify (yp, resp)
    end block
  end select
end function pow_real32_var

module function pow_var_real64(x, y) result(res)
  type(variable_type), target, intent(in) :: x
  real(real64), intent(in) :: y
  type(variable_type), target :: res

  res%name = x%name
  res%length = x%length
  res%dimensions = x%dimensions
  res%attributes = x%attributes

  select case (x%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp ** y
      nullify (xp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp ** y
      nullify (xp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp ** y
      nullify (xp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp ** y
      nullify (xp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp ** y
      nullify (xp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: xp(:)
      real(real64), pointer :: resp(:)

      res%data_type = NC_DOUBLE
      call allocate_buffer(res)
      call extract(res, resp)
      call extract(x, xp)
      resp = xp ** y
      nullify (xp, resp)
    end block
  end select
end function pow_var_real64

module function pow_real64_var(x, y) result(res)
  real(real64), intent(in) :: x
  type(variable_type), target, intent(in) :: y
  type(variable_type), target :: res

  res%name = y%name
  res%length = y%length
  res%dimensions = y%dimensions
  res%attributes = y%attributes

  select case (y%data_type)
  case (NC_BYTE)
    block
      integer(int8), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x ** yp
      nullify (yp, resp)
    end block
  case (NC_SHORT)
    block
      integer(int16), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x ** yp
      nullify (yp, resp)
    end block
  case (NC_INT)
    block
      integer(int32), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x ** yp
      nullify (yp, resp)
    end block
  case (NC_INT64)
    block
      integer(int64), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x ** yp
      nullify (yp, resp)
    end block
  case (NC_FLOAT)
    block
      real(real32), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x ** yp
      nullify (yp, resp)
    end block
  case (NC_DOUBLE)
    block
      real(real64), pointer :: yp(:)
      real(real64), pointer :: resp(:)

      call allocate_buffer(res)
      call extract(res, resp)
      call extract(y, yp)
      resp = x ** yp
      nullify (yp, resp)
    end block
  end select
end function pow_real64_var

module function sum_vars(vars) result(s)
  type(variable_type), intent(in) :: vars(:)
  type(variable_type) :: s
  integer :: i

  select case (size(vars))
  case (1)
    s = vars(1)
  case (2)
    s = vars(1) + vars(2)
  case (3:)
    s = vars(1)
    do i = 2, size(vars)
      s = s + vars(i)
    end do
  case default
    error stop "[sum_vars] Invalid size."
  end select
end function sum_vars

end submodule submodule_arithmetic
