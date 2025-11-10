interface operator(.att.)
  module procedure :: new_attribute_int8
  module procedure :: new_attribute_int8_scalar
  module procedure :: new_attribute_int16
  module procedure :: new_attribute_int16_scalar
  module procedure :: new_attribute_int32
  module procedure :: new_attribute_int32_scalar
  module procedure :: new_attribute_int64
  module procedure :: new_attribute_int64_scalar
  module procedure :: new_attribute_real32
  module procedure :: new_attribute_real32_scalar
  module procedure :: new_attribute_real64
  module procedure :: new_attribute_real64_scalar
  module procedure :: new_attribute_character
end interface operator(.att.)

interface
  module function new_attribute_int8(name, values) result(att)
    character(len=*), intent(in) :: name
    integer(int8), intent(in) :: values(:)
    type(attribute_type), target :: att
  end function new_attribute_int8

  module function new_attribute_int8_scalar(name, value) result(att)
    character(len=*), intent(in) :: name
    integer(int8), intent(in) :: value
    type(attribute_type), target :: att
  end function new_attribute_int8_scalar

  module function new_attribute_int16(name, values) result(att)
    character(len=*), intent(in) :: name
    integer(int16), intent(in) :: values(:)
    type(attribute_type), target :: att
  end function new_attribute_int16

  module function new_attribute_int16_scalar(name, value) result(att)
    character(len=*), intent(in) :: name
    integer(int16), intent(in) :: value
    type(attribute_type), target :: att
  end function new_attribute_int16_scalar

  module function new_attribute_int32(name, values) result(att)
    character(len=*), intent(in) :: name
    integer(int32), intent(in) :: values(:)
    type(attribute_type), target :: att
  end function new_attribute_int32

  module function new_attribute_int32_scalar(name, value) result(att)
    character(len=*), intent(in) :: name
    integer(int32), intent(in) :: value
    type(attribute_type), target :: att
  end function new_attribute_int32_scalar

  module function new_attribute_int64(name, values) result(att)
    character(len=*), intent(in) :: name
    integer(int64), intent(in) :: values(:)
    type(attribute_type), target :: att
  end function new_attribute_int64

  module function new_attribute_int64_scalar(name, value) result(att)
    character(len=*), intent(in) :: name
    integer(int64), intent(in) :: value
    type(attribute_type), target :: att
  end function new_attribute_int64_scalar

  module function new_attribute_real32(name, values) result(att)
    character(len=*), intent(in) :: name
    real(real32), intent(in) :: values(:)
    type(attribute_type), target :: att
  end function new_attribute_real32

  module function new_attribute_real32_scalar(name, value) result(att)
    character(len=*), intent(in) :: name
    real(real32), intent(in) :: value
    type(attribute_type), target :: att
  end function new_attribute_real32_scalar

  module function new_attribute_real64(name, values) result(att)
    character(len=*), intent(in) :: name
    real(real64), intent(in) :: values(:)
    type(attribute_type), target :: att
  end function new_attribute_real64

  module function new_attribute_real64_scalar(name, value) result(att)
    character(len=*), intent(in) :: name
    real(real64), intent(in) :: value
    type(attribute_type), target :: att
  end function new_attribute_real64_scalar

  module function new_attribute_character(name, value) result(att)
    character(len=*), intent(in) :: name
    character(len=*), intent(in) :: value
    type(attribute_type), target :: att
  end function new_attribute_character
end interface