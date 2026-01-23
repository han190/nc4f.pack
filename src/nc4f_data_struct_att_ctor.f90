submodule(nc4f_data_struct) nc4f_data_struct_att_ctor
implicit none (type, external)
contains

!> Create an `attribute_type` from an array of `integer` of kind `int8`.
module function new_att_int8(name, values) result(att)
  !> Attribute name to assign (will be trimmed).
  character(len=*), intent(in) :: name
  !> Values to store in the attribute (1D array of `integer` of kind `int8`).
  integer(int8), intent(in) :: values(:)
  !> Resulting attribute object containing metadata and buffer.
  type(attribute_type) :: att
  !> Pointer view into the attribute buffer for efficient copy.
  integer(int8), pointer :: ptr(:)

  call allocate_attribute(att, name, BYTE_TYPE, size(values, kind=int64))
  call extract(att, ptr)
  ptr = values
end function new_att_int8

!> Create a scalar `attribute_type` from a single `integer` value.
module function new_att_int8_scalar(name, value) result(att)
  !> Attribute name to assign (will be trimmed).
  character(len=*), intent(in) :: name
  !> Scalar value to store in the attribute.
  integer(int8), intent(in) :: value
  !> Resulting attribute object containing metadata and buffer.
  type(attribute_type) :: att
  !> Temporary 1-element array used to forward to the array constructor.
  integer(int8) :: tmp(1)

  tmp(1) = value
  att = new_att_int8(name, tmp)
end function new_att_int8_scalar

!> Create an `attribute_type` from an array of `integer` of kind `int16`.
module function new_att_int16(name, values) result(att)
  !> Attribute name to assign (will be trimmed).
  character(len=*), intent(in) :: name
  !> Values to store in the attribute (1D array of `integer` of kind `int16`).
  integer(int16), intent(in) :: values(:)
  !> Resulting attribute object containing metadata and buffer.
  type(attribute_type) :: att
  !> Pointer view into the attribute buffer for efficient copy.
  integer(int16), pointer :: ptr(:)

  call allocate_attribute(att, name, SHORT_TYPE, size(values, kind=int64))
  call extract(att, ptr)
  ptr = values
end function new_att_int16

!> Create a scalar `attribute_type` from a single `integer` value.
module function new_att_int16_scalar(name, value) result(att)
  !> Attribute name to assign (will be trimmed).
  character(len=*), intent(in) :: name
  !> Scalar value to store in the attribute.
  integer(int16), intent(in) :: value
  !> Resulting attribute object containing metadata and buffer.
  type(attribute_type) :: att
  !> Temporary 1-element array used to forward to the array constructor.
  integer(int16) :: tmp(1)

  tmp(1) = value
  att = new_att_int16(name, tmp)
end function new_att_int16_scalar

!> Create an `attribute_type` from an array of `integer` of kind `int32`.
module function new_att_int32(name, values) result(att)
  !> Attribute name to assign (will be trimmed).
  character(len=*), intent(in) :: name
  !> Values to store in the attribute (1D array of `integer` of kind `int32`).
  integer(int32), intent(in) :: values(:)
  !> Resulting attribute object containing metadata and buffer.
  type(attribute_type) :: att
  !> Pointer view into the attribute buffer for efficient copy.
  integer(int32), pointer :: ptr(:)

  call allocate_attribute(att, name, INT_TYPE, size(values, kind=int64))
  call extract(att, ptr)
  ptr = values
end function new_att_int32

!> Create a scalar `attribute_type` from a single `integer` value.
module function new_att_int32_scalar(name, value) result(att)
  !> Attribute name to assign (will be trimmed).
  character(len=*), intent(in) :: name
  !> Scalar value to store in the attribute.
  integer(int32), intent(in) :: value
  !> Resulting attribute object containing metadata and buffer.
  type(attribute_type) :: att
  !> Temporary 1-element array used to forward to the array constructor.
  integer(int32) :: tmp(1)

  tmp(1) = value
  att = new_att_int32(name, tmp)
end function new_att_int32_scalar

!> Create an `attribute_type` from an array of `integer` of kind `int64`.
module function new_att_int64(name, values) result(att)
  !> Attribute name to assign (will be trimmed).
  character(len=*), intent(in) :: name
  !> Values to store in the attribute (1D array of `integer` of kind `int64`).
  integer(int64), intent(in) :: values(:)
  !> Resulting attribute object containing metadata and buffer.
  type(attribute_type) :: att
  !> Pointer view into the attribute buffer for efficient copy.
  integer(int64), pointer :: ptr(:)

  call allocate_attribute(att, name, INT64_TYPE, size(values, kind=int64))
  call extract(att, ptr)
  ptr = values
end function new_att_int64

!> Create a scalar `attribute_type` from a single `integer` value.
module function new_att_int64_scalar(name, value) result(att)
  !> Attribute name to assign (will be trimmed).
  character(len=*), intent(in) :: name
  !> Scalar value to store in the attribute.
  integer(int64), intent(in) :: value
  !> Resulting attribute object containing metadata and buffer.
  type(attribute_type) :: att
  !> Temporary 1-element array used to forward to the array constructor.
  integer(int64) :: tmp(1)

  tmp(1) = value
  att = new_att_int64(name, tmp)
end function new_att_int64_scalar

!> Create an `attribute_type` from an array of `real` of kind `real32`.
module function new_att_real32(name, values) result(att)
  !> Attribute name to assign (will be trimmed).
  character(len=*), intent(in) :: name
  !> Values to store in the attribute (1D array of `real` of kind `real32`).
  real(real32), intent(in) :: values(:)
  !> Resulting attribute object containing metadata and buffer.
  type(attribute_type) :: att
  !> Pointer view into the attribute buffer for efficient copy.
  real(real32), pointer :: ptr(:)

  call allocate_attribute(att, name, FLOAT_TYPE, size(values, kind=int64))
  call extract(att, ptr)
  ptr = values
end function new_att_real32

!> Create a scalar `attribute_type` from a single `real` value.
module function new_att_real32_scalar(name, value) result(att)
  !> Attribute name to assign (will be trimmed).
  character(len=*), intent(in) :: name
  !> Scalar value to store in the attribute.
  real(real32), intent(in) :: value
  !> Resulting attribute object containing metadata and buffer.
  type(attribute_type) :: att
  !> Temporary 1-element array used to forward to the array constructor.
  real(real32) :: tmp(1)

  tmp(1) = value
  att = new_att_real32(name, tmp)
end function new_att_real32_scalar

!> Create an `attribute_type` from an array of `real` of kind `real64`.
module function new_att_real64(name, values) result(att)
  !> Attribute name to assign (will be trimmed).
  character(len=*), intent(in) :: name
  !> Values to store in the attribute (1D array of `real` of kind `real64`).
  real(real64), intent(in) :: values(:)
  !> Resulting attribute object containing metadata and buffer.
  type(attribute_type) :: att
  !> Pointer view into the attribute buffer for efficient copy.
  real(real64), pointer :: ptr(:)

  call allocate_attribute(att, name, DOUBLE_TYPE, size(values, kind=int64))
  call extract(att, ptr)
  ptr = values
end function new_att_real64

!> Create a scalar `attribute_type` from a single `real` value.
module function new_att_real64_scalar(name, value) result(att)
  !> Attribute name to assign (will be trimmed).
  character(len=*), intent(in) :: name
  !> Scalar value to store in the attribute.
  real(real64), intent(in) :: value
  !> Resulting attribute object containing metadata and buffer.
  type(attribute_type) :: att
  !> Temporary 1-element array used to forward to the array constructor.
  real(real64) :: tmp(1)

  tmp(1) = value
  att = new_att_real64(name, tmp)
end function new_att_real64_scalar

!> Create an `attribute_type` containing character data from a
!> Fortran string.
module function new_att_character(name, value) result(att)
  !> Attribute name to assign (will be trimmed).
  character(len=*), intent(in) :: name, value
  !> Resulting attribute containing character buffer (NC_CHAR type).
  type(attribute_type), target :: att
  !> Temporary C-character pointer used to populate the attribute buffer.
  character(kind=c_char), pointer :: fptr(:)
  !> C pointer for interop with the attribute buffer.
  type(c_ptr) :: cptr
  !> Loop index used when copying characters.
  integer(int64) :: i

  call allocate_attribute(att, name, CHAR_TYPE, len(value, kind=int64))
  cptr = c_loc(att%buffer(1))
  call c_f_pointer(cptr, fptr, [att%len])
  do i = 1, att%len
    fptr(i) = value(i:i)
  end do
end function new_att_character

end submodule nc4f_data_struct_att_ctor
