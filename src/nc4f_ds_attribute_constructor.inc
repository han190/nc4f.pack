interface operator(.att.)
  module procedure :: new_att_int8
  module procedure :: new_att_int8_scalar
  module procedure :: new_att_int16
  module procedure :: new_att_int16_scalar
  module procedure :: new_att_int32
  module procedure :: new_att_int32_scalar
  module procedure :: new_att_int64
  module procedure :: new_att_int64_scalar
  module procedure :: new_att_real32
  module procedure :: new_att_real32_scalar
  module procedure :: new_att_real64
  module procedure :: new_att_real64_scalar
  module procedure :: new_att_character
end interface operator(.att.)

interface
  pure module function new_att_int8(name, values) result(att)
    !! Create an `attribute_type` from an array of `integer` of kind `int8`.
    character(len=*), intent(in) :: name
    !! Attribute name.
    integer(int8), intent(in) :: values(:)
    !! Attribute values.
    type(attribute_type) :: att
    !! Returned Attribute.
  end function new_att_int8

  elemental module function new_att_int8_scalar(name, value) result(att)
    !! Create a scalar `attribute_type` from a `integer` value.
    character(len=*), intent(in) :: name
    !! Attribute name.
    integer(int8), intent(in) :: value
    !! Attribute value.
    type(attribute_type) :: att
    !! Returned Attribute.
  end function new_att_int8_scalar

  pure module function new_att_int16(name, values) result(att)
    !! Create an `attribute_type` from an array of `integer` of kind `int16`.
    character(len=*), intent(in) :: name
    !! Attribute name.
    integer(int16), intent(in) :: values(:)
    !! Attribute values.
    type(attribute_type) :: att
    !! Returned Attribute.
  end function new_att_int16

  elemental module function new_att_int16_scalar(name, value) result(att)
    !! Create a scalar `attribute_type` from a `integer` value.
    character(len=*), intent(in) :: name
    !! Attribute name.
    integer(int16), intent(in) :: value
    !! Attribute value.
    type(attribute_type) :: att
    !! Returned Attribute.
  end function new_att_int16_scalar

  pure module function new_att_int32(name, values) result(att)
    !! Create an `attribute_type` from an array of `integer` of kind `int32`.
    character(len=*), intent(in) :: name
    !! Attribute name.
    integer(int32), intent(in) :: values(:)
    !! Attribute values.
    type(attribute_type) :: att
    !! Returned Attribute.
  end function new_att_int32

  elemental module function new_att_int32_scalar(name, value) result(att)
    !! Create a scalar `attribute_type` from a `integer` value.
    character(len=*), intent(in) :: name
    !! Attribute name.
    integer(int32), intent(in) :: value
    !! Attribute value.
    type(attribute_type) :: att
    !! Returned Attribute.
  end function new_att_int32_scalar

  pure module function new_att_int64(name, values) result(att)
    !! Create an `attribute_type` from an array of `integer` of kind `int64`.
    character(len=*), intent(in) :: name
    !! Attribute name.
    integer(int64), intent(in) :: values(:)
    !! Attribute values.
    type(attribute_type) :: att
    !! Returned Attribute.
  end function new_att_int64

  elemental module function new_att_int64_scalar(name, value) result(att)
    !! Create a scalar `attribute_type` from a `integer` value.
    character(len=*), intent(in) :: name
    !! Attribute name.
    integer(int64), intent(in) :: value
    !! Attribute value.
    type(attribute_type) :: att
    !! Returned Attribute.
  end function new_att_int64_scalar

  pure module function new_att_real32(name, values) result(att)
    !! Create an `attribute_type` from an array of `real` of kind `real32`.
    character(len=*), intent(in) :: name
    !! Attribute name.
    real(real32), intent(in) :: values(:)
    !! Attribute values.
    type(attribute_type) :: att
    !! Returned Attribute.
  end function new_att_real32

  elemental module function new_att_real32_scalar(name, value) result(att)
    !! Create a scalar `attribute_type` from a `real` value.
    character(len=*), intent(in) :: name
    !! Attribute name.
    real(real32), intent(in) :: value
    !! Attribute value.
    type(attribute_type) :: att
    !! Returned Attribute.
  end function new_att_real32_scalar

  pure module function new_att_real64(name, values) result(att)
    !! Create an `attribute_type` from an array of `real` of kind `real64`.
    character(len=*), intent(in) :: name
    !! Attribute name.
    real(real64), intent(in) :: values(:)
    !! Attribute values.
    type(attribute_type) :: att
    !! Returned Attribute.
  end function new_att_real64

  elemental module function new_att_real64_scalar(name, value) result(att)
    !! Create a scalar `attribute_type` from a `real` value.
    character(len=*), intent(in) :: name
    !! Attribute name.
    real(real64), intent(in) :: value
    !! Attribute value.
    type(attribute_type) :: att
    !! Returned Attribute.
  end function new_att_real64_scalar

  module function new_att_character(name, value) result(att)
    !! Create an `attribute_type` containing character data.
    character(len=*), intent(in) :: name
    !! Attribute name.
    character(len=*), intent(in) :: value
    !! Attribute value (character).
    type(attribute_type), target :: att
    !! Returned Attribute.
  end function new_att_character
end interface
