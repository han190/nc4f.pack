submodule(nc4f_data_struct) nc4f_data_struct_att_ctor
implicit none (type, external)
contains

!> Create an `attribute_type` from an array of `integer` of kind `int8`.
module function new_att_int8(name, values) result(att)
  !> Input argument: `name`.
  character(len=*), intent(in) :: name
  !> Input argument: `values`.
  integer(int8), intent(in) :: values(:)
  !> Return value: `att`.
  type(attribute_type) :: att

  call init_att(att, name, BYTE_TYPE, size(values, kind=int64))
  if (size(values) > 0) att%buffer = transfer(values, 0_int8, size(att%buffer))
end function new_att_int8

!> Create a scalar `attribute_type` from a `integer` value.
module function new_att_int8_scalar(name, value) result(att)
  !> Input argument: `name`.
  character(len=*), intent(in) :: name
  !> Input argument: `value`.
  integer(int8), intent(in) :: value
  !> Return value: `att`.
  type(attribute_type) :: att
  integer(int8) :: tmp(1)

  tmp(1) = value
  att = new_att_int8(name, tmp)
end function new_att_int8_scalar

!> Create an `attribute_type` from an array of `integer` of kind `int16`.
module function new_att_int16(name, values) result(att)
  !> Input argument: `name`.
  character(len=*), intent(in) :: name
  !> Input argument: `values`.
  integer(int16), intent(in) :: values(:)
  !> Return value: `att`.
  type(attribute_type) :: att

  call init_att(att, name, SHORT_TYPE, size(values, kind=int64))
  if (size(values) > 0) att%buffer = transfer(values, 0_int8, size(att%buffer))
end function new_att_int16

!> Create a scalar `attribute_type` from a `integer` value.
module function new_att_int16_scalar(name, value) result(att)
  !> Input argument: `name`.
  character(len=*), intent(in) :: name
  !> Input argument: `value`.
  integer(int16), intent(in) :: value
  !> Return value: `att`.
  type(attribute_type) :: att
  integer(int16) :: tmp(1)

  tmp(1) = value
  att = new_att_int16(name, tmp)
end function new_att_int16_scalar

!> Create an `attribute_type` from an array of `integer` of kind `int32`.
module function new_att_int32(name, values) result(att)
  !> Input argument: `name`.
  character(len=*), intent(in) :: name
  !> Input argument: `values`.
  integer(int32), intent(in) :: values(:)
  !> Return value: `att`.
  type(attribute_type) :: att

  call init_att(att, name, INT_TYPE, size(values, kind=int64))
  if (size(values) > 0) att%buffer = transfer(values, 0_int8, size(att%buffer))
end function new_att_int32

!> Create a scalar `attribute_type` from a `integer` value.
module function new_att_int32_scalar(name, value) result(att)
  !> Input argument: `name`.
  character(len=*), intent(in) :: name
  !> Input argument: `value`.
  integer(int32), intent(in) :: value
  !> Return value: `att`.
  type(attribute_type) :: att
  integer(int32) :: tmp(1)

  tmp(1) = value
  att = new_att_int32(name, tmp)
end function new_att_int32_scalar

!> Create an `attribute_type` from an array of `integer` of kind `int64`.
module function new_att_int64(name, values) result(att)
  !> Input argument: `name`.
  character(len=*), intent(in) :: name
  !> Input argument: `values`.
  integer(int64), intent(in) :: values(:)
  !> Return value: `att`.
  type(attribute_type) :: att

  call init_att(att, name, INT64_TYPE, size(values, kind=int64))
  if (size(values) > 0) att%buffer = transfer(values, 0_int8, size(att%buffer))
end function new_att_int64

!> Create a scalar `attribute_type` from a `integer` value.
module function new_att_int64_scalar(name, value) result(att)
  !> Input argument: `name`.
  character(len=*), intent(in) :: name
  !> Input argument: `value`.
  integer(int64), intent(in) :: value
  !> Return value: `att`.
  type(attribute_type) :: att
  integer(int64) :: tmp(1)

  tmp(1) = value
  att = new_att_int64(name, tmp)
end function new_att_int64_scalar

!> Create an `attribute_type` from an array of `real` of kind `real32`.
module function new_att_real32(name, values) result(att)
  !> Input argument: `name`.
  character(len=*), intent(in) :: name
  !> Input argument: `values`.
  real(real32), intent(in) :: values(:)
  !> Return value: `att`.
  type(attribute_type) :: att

  call init_att(att, name, FLOAT_TYPE, size(values, kind=int64))
  if (size(values) > 0) att%buffer = transfer(values, 0_int8, size(att%buffer))
end function new_att_real32

!> Create a scalar `attribute_type` from a `real` value.
module function new_att_real32_scalar(name, value) result(att)
  !> Input argument: `name`.
  character(len=*), intent(in) :: name
  !> Input argument: `value`.
  real(real32), intent(in) :: value
  !> Return value: `att`.
  type(attribute_type) :: att
  real(real32) :: tmp(1)

  tmp(1) = value
  att = new_att_real32(name, tmp)
end function new_att_real32_scalar

!> Create an `attribute_type` from an array of `real` of kind `real64`.
module function new_att_real64(name, values) result(att)
  !> Input argument: `name`.
  character(len=*), intent(in) :: name
  !> Input argument: `values`.
  real(real64), intent(in) :: values(:)
  !> Return value: `att`.
  type(attribute_type) :: att

  call init_att(att, name, DOUBLE_TYPE, size(values, kind=int64))
  if (size(values) > 0) att%buffer = transfer(values, 0_int8, size(att%buffer))
end function new_att_real64

!> Create a scalar `attribute_type` from a `real` value.
module function new_att_real64_scalar(name, value) result(att)
  !> Input argument: `name`.
  character(len=*), intent(in) :: name
  !> Input argument: `value`.
  real(real64), intent(in) :: value
  !> Return value: `att`.
  type(attribute_type) :: att
  real(real64) :: tmp(1)

  tmp(1) = value
  att = new_att_real64(name, tmp)
end function new_att_real64_scalar


!> Create an `attribute_type` containing character data.
module function new_att_character(name, value) result(att)
  !> Input argument: `name`.
  character(len=*), intent(in) :: name
  !> Input argument: `value`.
  character(len=*), intent(in) :: value
  !> Return value: `att`.
  type(attribute_type) :: att

  call init_att(att, name, CHAR_TYPE, len(value, kind=int64))
  if (len(value) > 0) att%buffer = transfer(value, 0_int8, size(att%buffer))
end function new_att_character

end submodule nc4f_data_struct_att_ctor
