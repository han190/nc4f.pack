submodule(nc4f_ds) nc4f_ds_attribute_constructor
implicit none (type, external)
contains

!> Create an `attribute_type` from an array of `integer` of kind `int8`.
module function new_att_int8(name, values) result(att)
  !> Name used to identify the NetCDF object.
  character(len=*), intent(in) :: name
  !> Values used to populate the attribute.
  integer(int8), intent(in) :: values(:)
  !> Constructed attribute containing the supplied values.
  type(attribute_type) :: att

  call init_att(att, name, BYTE_TYPE, size(values, kind=int64))
  if (size(values) > 0) att%buffer = transfer(values, 0_int8, size(att%buffer))
end function new_att_int8

!> Create a scalar `attribute_type` from a `integer` value.
module function new_att_int8_scalar(name, value) result(att)
  !> Name used to identify the NetCDF object.
  character(len=*), intent(in) :: name
  !> Scalar value stored in the attribute.
  integer(int8), intent(in) :: value
  !> Constructed single-value attribute.
  type(attribute_type) :: att
  integer(int8) :: tmp(1)

  tmp(1) = value
  att = new_att_int8(name, tmp)
end function new_att_int8_scalar

!> Create an `attribute_type` from an array of `integer` of kind `int16`.
module function new_att_int16(name, values) result(att)
  !> Name used to identify the NetCDF object.
  character(len=*), intent(in) :: name
  !> Values used to populate the attribute.
  integer(int16), intent(in) :: values(:)
  !> Constructed attribute containing the supplied values.
  type(attribute_type) :: att

  call init_att(att, name, SHORT_TYPE, size(values, kind=int64))
  if (size(values) > 0) att%buffer = transfer(values, 0_int8, size(att%buffer))
end function new_att_int16

!> Create a scalar `attribute_type` from a `integer` value.
module function new_att_int16_scalar(name, value) result(att)
  !> Name used to identify the NetCDF object.
  character(len=*), intent(in) :: name
  !> Scalar value stored in the attribute.
  integer(int16), intent(in) :: value
  !> Constructed single-value attribute.
  type(attribute_type) :: att
  integer(int16) :: tmp(1)

  tmp(1) = value
  att = new_att_int16(name, tmp)
end function new_att_int16_scalar

!> Create an `attribute_type` from an array of `integer` of kind `int32`.
module function new_att_int32(name, values) result(att)
  !> Name used to identify the NetCDF object.
  character(len=*), intent(in) :: name
  !> Values used to populate the attribute.
  integer(int32), intent(in) :: values(:)
  !> Constructed attribute containing the supplied values.
  type(attribute_type) :: att

  call init_att(att, name, INT_TYPE, size(values, kind=int64))
  if (size(values) > 0) att%buffer = transfer(values, 0_int8, size(att%buffer))
end function new_att_int32

!> Create a scalar `attribute_type` from a `integer` value.
module function new_att_int32_scalar(name, value) result(att)
  !> Name used to identify the NetCDF object.
  character(len=*), intent(in) :: name
  !> Scalar value stored in the attribute.
  integer(int32), intent(in) :: value
  !> Constructed single-value attribute.
  type(attribute_type) :: att
  integer(int32) :: tmp(1)

  tmp(1) = value
  att = new_att_int32(name, tmp)
end function new_att_int32_scalar

!> Create an `attribute_type` from an array of `integer` of kind `int64`.
module function new_att_int64(name, values) result(att)
  !> Name used to identify the NetCDF object.
  character(len=*), intent(in) :: name
  !> Values used to populate the attribute.
  integer(int64), intent(in) :: values(:)
  !> Constructed attribute containing the supplied values.
  type(attribute_type) :: att

  call init_att(att, name, INT64_TYPE, size(values, kind=int64))
  if (size(values) > 0) att%buffer = transfer(values, 0_int8, size(att%buffer))
end function new_att_int64

!> Create a scalar `attribute_type` from a `integer` value.
module function new_att_int64_scalar(name, value) result(att)
  !> Name used to identify the NetCDF object.
  character(len=*), intent(in) :: name
  !> Scalar value stored in the attribute.
  integer(int64), intent(in) :: value
  !> Constructed single-value attribute.
  type(attribute_type) :: att
  integer(int64) :: tmp(1)

  tmp(1) = value
  att = new_att_int64(name, tmp)
end function new_att_int64_scalar

!> Create an `attribute_type` from an array of `real` of kind `real32`.
module function new_att_real32(name, values) result(att)
  !> Name used to identify the NetCDF object.
  character(len=*), intent(in) :: name
  !> Values used to populate the attribute.
  real(real32), intent(in) :: values(:)
  !> Constructed attribute containing the supplied values.
  type(attribute_type) :: att

  call init_att(att, name, FLOAT_TYPE, size(values, kind=int64))
  if (size(values) > 0) att%buffer = transfer(values, 0_int8, size(att%buffer))
end function new_att_real32

!> Create a scalar `attribute_type` from a `real` value.
module function new_att_real32_scalar(name, value) result(att)
  !> Name used to identify the NetCDF object.
  character(len=*), intent(in) :: name
  !> Scalar value stored in the attribute.
  real(real32), intent(in) :: value
  !> Constructed single-value attribute.
  type(attribute_type) :: att
  real(real32) :: tmp(1)

  tmp(1) = value
  att = new_att_real32(name, tmp)
end function new_att_real32_scalar

!> Create an `attribute_type` from an array of `real` of kind `real64`.
module function new_att_real64(name, values) result(att)
  !> Name used to identify the NetCDF object.
  character(len=*), intent(in) :: name
  !> Values used to populate the attribute.
  real(real64), intent(in) :: values(:)
  !> Constructed attribute containing the supplied values.
  type(attribute_type) :: att

  call init_att(att, name, DOUBLE_TYPE, size(values, kind=int64))
  if (size(values) > 0) att%buffer = transfer(values, 0_int8, size(att%buffer))
end function new_att_real64

!> Create a scalar `attribute_type` from a `real` value.
module function new_att_real64_scalar(name, value) result(att)
  !> Name used to identify the NetCDF object.
  character(len=*), intent(in) :: name
  !> Scalar value stored in the attribute.
  real(real64), intent(in) :: value
  !> Constructed single-value attribute.
  type(attribute_type) :: att
  real(real64) :: tmp(1)

  tmp(1) = value
  att = new_att_real64(name, tmp)
end function new_att_real64_scalar


!> Create an `attribute_type` containing character data.
module function new_att_character(name, value) result(att)
  !> Name used to identify the NetCDF object.
  character(len=*), intent(in) :: name
  !> Character data stored in the attribute.
  character(len=*), intent(in) :: value
  !> Constructed attribute containing the character data.
  type(attribute_type) :: att

  call init_att(att, name, CHAR_TYPE, len(value, kind=int64))
  if (len(value) > 0) att%buffer = transfer(value, 0_int8, size(att%buffer))
end function new_att_character

end submodule nc4f_ds_attribute_constructor
