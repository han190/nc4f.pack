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
  !> Create an `attribute_type` from an array of `integer` of kind `int8`.
  module function new_att_int8(name, values) result(att)
    !> Attribute name to assign (will be trimmed).
    character(len=*), intent(in) :: name
    !> Values to store in the attribute (1D array of `integer` of kind `int8`).
    integer(int8), intent(in) :: values(:)
    !> Resulting attribute object containing metadata and buffer.
    type(attribute_type) :: att
  end function new_att_int8

  !> Create a scalar `attribute_type` from a single `integer` value.
  module function new_att_int8_scalar(name, value) result(att)
    !> Attribute name to assign (will be trimmed).
    character(len=*), intent(in) :: name
    !> Scalar value to store in the attribute.
    integer(int8), intent(in) :: value
    !> Resulting attribute object containing metadata and buffer.
    type(attribute_type) :: att
  end function new_att_int8_scalar

  !> Create an `attribute_type` from an array of `integer` of kind `int16`.
  module function new_att_int16(name, values) result(att)
    !> Attribute name to assign (will be trimmed).
    character(len=*), intent(in) :: name
    !> Values to store in the attribute (1D array of `integer` of kind `int16`).
    integer(int16), intent(in) :: values(:)
    !> Resulting attribute object containing metadata and buffer.
    type(attribute_type) :: att
  end function new_att_int16

  !> Create a scalar `attribute_type` from a single `integer` value.
  module function new_att_int16_scalar(name, value) result(att)
    !> Attribute name to assign (will be trimmed).
    character(len=*), intent(in) :: name
    !> Scalar value to store in the attribute.
    integer(int16), intent(in) :: value
    !> Resulting attribute object containing metadata and buffer.
    type(attribute_type) :: att
  end function new_att_int16_scalar

  !> Create an `attribute_type` from an array of `integer` of kind `int32`.
  module function new_att_int32(name, values) result(att)
    !> Attribute name to assign (will be trimmed).
    character(len=*), intent(in) :: name
    !> Values to store in the attribute (1D array of `integer` of kind `int32`).
    integer(int32), intent(in) :: values(:)
    !> Resulting attribute object containing metadata and buffer.
    type(attribute_type) :: att
  end function new_att_int32

  !> Create a scalar `attribute_type` from a single `integer` value.
  module function new_att_int32_scalar(name, value) result(att)
    !> Attribute name to assign (will be trimmed).
    character(len=*), intent(in) :: name
    !> Scalar value to store in the attribute.
    integer(int32), intent(in) :: value
    !> Resulting attribute object containing metadata and buffer.
    type(attribute_type) :: att
  end function new_att_int32_scalar

  !> Create an `attribute_type` from an array of `integer` of kind `int64`.
  module function new_att_int64(name, values) result(att)
    !> Attribute name to assign (will be trimmed).
    character(len=*), intent(in) :: name
    !> Values to store in the attribute (1D array of `integer` of kind `int64`).
    integer(int64), intent(in) :: values(:)
    !> Resulting attribute object containing metadata and buffer.
    type(attribute_type) :: att
  end function new_att_int64

  !> Create a scalar `attribute_type` from a single `integer` value.
  module function new_att_int64_scalar(name, value) result(att)
    !> Attribute name to assign (will be trimmed).
    character(len=*), intent(in) :: name
    !> Scalar value to store in the attribute.
    integer(int64), intent(in) :: value
    !> Resulting attribute object containing metadata and buffer.
    type(attribute_type) :: att
  end function new_att_int64_scalar

  !> Create an `attribute_type` from an array of `real` of kind `real32`.
  module function new_att_real32(name, values) result(att)
    !> Attribute name to assign (will be trimmed).
    character(len=*), intent(in) :: name
    !> Values to store in the attribute (1D array of `real` of kind `real32`).
    real(real32), intent(in) :: values(:)
    !> Resulting attribute object containing metadata and buffer.
    type(attribute_type) :: att
  end function new_att_real32

  !> Create a scalar `attribute_type` from a single `real` value.
  module function new_att_real32_scalar(name, value) result(att)
    !> Attribute name to assign (will be trimmed).
    character(len=*), intent(in) :: name
    !> Scalar value to store in the attribute.
    real(real32), intent(in) :: value
    !> Resulting attribute object containing metadata and buffer.
    type(attribute_type) :: att
  end function new_att_real32_scalar

  !> Create an `attribute_type` from an array of `real` of kind `real64`.
  module function new_att_real64(name, values) result(att)
    !> Attribute name to assign (will be trimmed).
    character(len=*), intent(in) :: name
    !> Values to store in the attribute (1D array of `real` of kind `real64`).
    real(real64), intent(in) :: values(:)
    !> Resulting attribute object containing metadata and buffer.
    type(attribute_type) :: att
  end function new_att_real64

  !> Create a scalar `attribute_type` from a single `real` value.
  module function new_att_real64_scalar(name, value) result(att)
    !> Attribute name to assign (will be trimmed).
    character(len=*), intent(in) :: name
    !> Scalar value to store in the attribute.
    real(real64), intent(in) :: value
    !> Resulting attribute object containing metadata and buffer.
    type(attribute_type) :: att
  end function new_att_real64_scalar

  !> Create an `attribute_type` containing character data from a
  !> Fortran string.
  module function new_att_character(name, value) result(att)
    !> Attribute name to assign (will be trimmed).
    character(len=*), intent(in) :: name
    !> Character value to store in the attribute.
    character(len=*), intent(in) :: value
    !> Resulting attribute containing character buffer (NC_CHAR type).
    type(attribute_type), target :: att
  end function new_att_character
end interface
