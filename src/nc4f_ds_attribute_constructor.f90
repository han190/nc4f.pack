submodule(nc4f_ds) nc4f_ds_attribute_constructor
implicit none (type, external)
contains

pure module function new_att_int8(name, values) result(att)
  !! Create an `attribute_type` from an array of `integer` of kind `int8`.
  character(len=*), intent(in) :: name
  !! Name used to identify the NetCDF object.
  integer(int8), intent(in) :: values(:)
  !! Values used to populate the attribute.
  type(attribute_type) :: att
  !! Constructed attribute containing the supplied values.

  call init_att(att, name, BYTE_TYPE, size(values, kind=int64))
  if (size(values) > 0) att%buffer = transfer(values, 0_int8, size(att%buffer))
end function new_att_int8

elemental module function new_att_int8_scalar(name, value) result(att)
  !! Create a scalar `attribute_type` from a `integer` value.
  character(len=*), intent(in) :: name
  !! Name used to identify the NetCDF object.
  integer(int8), intent(in) :: value
  !! Scalar value stored in the attribute.
  type(attribute_type) :: att
  !! Constructed single-value attribute.
  integer(int8) :: tmp(1)

  tmp(1) = value
  att = new_att_int8(name, tmp)
end function new_att_int8_scalar

pure module function new_att_int16(name, values) result(att)
  !! Create an `attribute_type` from an array of `integer` of kind `int16`.
  character(len=*), intent(in) :: name
  !! Name used to identify the NetCDF object.
  integer(int16), intent(in) :: values(:)
  !! Values used to populate the attribute.
  type(attribute_type) :: att
  !! Constructed attribute containing the supplied values.

  call init_att(att, name, SHORT_TYPE, size(values, kind=int64))
  if (size(values) > 0) att%buffer = transfer(values, 0_int8, size(att%buffer))
end function new_att_int16

elemental module function new_att_int16_scalar(name, value) result(att)
  !! Create a scalar `attribute_type` from a `integer` value.
  character(len=*), intent(in) :: name
  !! Name used to identify the NetCDF object.
  integer(int16), intent(in) :: value
  !! Scalar value stored in the attribute.
  type(attribute_type) :: att
  !! Constructed single-value attribute.
  integer(int16) :: tmp(1)

  tmp(1) = value
  att = new_att_int16(name, tmp)
end function new_att_int16_scalar

pure module function new_att_int32(name, values) result(att)
  !! Create an `attribute_type` from an array of `integer` of kind `int32`.
  character(len=*), intent(in) :: name
  !! Name used to identify the NetCDF object.
  integer(int32), intent(in) :: values(:)
  !! Values used to populate the attribute.
  type(attribute_type) :: att
  !! Constructed attribute containing the supplied values.

  call init_att(att, name, INT_TYPE, size(values, kind=int64))
  if (size(values) > 0) att%buffer = transfer(values, 0_int8, size(att%buffer))
end function new_att_int32

elemental module function new_att_int32_scalar(name, value) result(att)
  !! Create a scalar `attribute_type` from a `integer` value.
  character(len=*), intent(in) :: name
  !! Name used to identify the NetCDF object.
  integer(int32), intent(in) :: value
  !! Scalar value stored in the attribute.
  type(attribute_type) :: att
  !! Constructed single-value attribute.
  integer(int32) :: tmp(1)

  tmp(1) = value
  att = new_att_int32(name, tmp)
end function new_att_int32_scalar

pure module function new_att_int64(name, values) result(att)
  !! Create an `attribute_type` from an array of `integer` of kind `int64`.
  character(len=*), intent(in) :: name
  !! Name used to identify the NetCDF object.
  integer(int64), intent(in) :: values(:)
  !! Values used to populate the attribute.
  type(attribute_type) :: att
  !! Constructed attribute containing the supplied values.

  call init_att(att, name, INT64_TYPE, size(values, kind=int64))
  if (size(values) > 0) att%buffer = transfer(values, 0_int8, size(att%buffer))
end function new_att_int64

elemental module function new_att_int64_scalar(name, value) result(att)
  !! Create a scalar `attribute_type` from a `integer` value.
  character(len=*), intent(in) :: name
  !! Name used to identify the NetCDF object.
  integer(int64), intent(in) :: value
  !! Scalar value stored in the attribute.
  type(attribute_type) :: att
  !! Constructed single-value attribute.
  integer(int64) :: tmp(1)

  tmp(1) = value
  att = new_att_int64(name, tmp)
end function new_att_int64_scalar

pure module function new_att_real32(name, values) result(att)
  !! Create an `attribute_type` from an array of `real` of kind `real32`.
  character(len=*), intent(in) :: name
  !! Name used to identify the NetCDF object.
  real(real32), intent(in) :: values(:)
  !! Values used to populate the attribute.
  type(attribute_type) :: att
  !! Constructed attribute containing the supplied values.

  call init_att(att, name, FLOAT_TYPE, size(values, kind=int64))
  if (size(values) > 0) att%buffer = transfer(values, 0_int8, size(att%buffer))
end function new_att_real32

elemental module function new_att_real32_scalar(name, value) result(att)
  !! Create a scalar `attribute_type` from a `real` value.
  character(len=*), intent(in) :: name
  !! Name used to identify the NetCDF object.
  real(real32), intent(in) :: value
  !! Scalar value stored in the attribute.
  type(attribute_type) :: att
  !! Constructed single-value attribute.
  real(real32) :: tmp(1)

  tmp(1) = value
  att = new_att_real32(name, tmp)
end function new_att_real32_scalar

pure module function new_att_real64(name, values) result(att)
  !! Create an `attribute_type` from an array of `real` of kind `real64`.
  character(len=*), intent(in) :: name
  !! Name used to identify the NetCDF object.
  real(real64), intent(in) :: values(:)
  !! Values used to populate the attribute.
  type(attribute_type) :: att
  !! Constructed attribute containing the supplied values.

  call init_att(att, name, DOUBLE_TYPE, size(values, kind=int64))
  if (size(values) > 0) att%buffer = transfer(values, 0_int8, size(att%buffer))
end function new_att_real64

elemental module function new_att_real64_scalar(name, value) result(att)
  !! Create a scalar `attribute_type` from a `real` value.
  character(len=*), intent(in) :: name
  !! Name used to identify the NetCDF object.
  real(real64), intent(in) :: value
  !! Scalar value stored in the attribute.
  type(attribute_type) :: att
  !! Constructed single-value attribute.
  real(real64) :: tmp(1)

  tmp(1) = value
  att = new_att_real64(name, tmp)
end function new_att_real64_scalar


module function new_att_character(name, value) result(att)
  !! Create an `attribute_type` containing character data.
  character(len=*), intent(in) :: name
  !! Name used to identify the NetCDF object.
  character(len=*), intent(in) :: value
  !! Character data stored in the attribute.
  type(attribute_type) :: att
  !! Constructed attribute containing the character data.

  call init_att(att, name, CHAR_TYPE, len(value, kind=int64))
  if (len(value) > 0) att%buffer = transfer(value, 0_int8, size(att%buffer))
end function new_att_character

end submodule nc4f_ds_attribute_constructor
