submodule(module_netcdf) submodule_attribute_constructor
implicit none (type, external)
contains

module function new_att_int8(name, values) result(att)
  character(len=*), intent(in) :: name
  integer(int8), intent(in) :: values(:)
  type(attribute_type) :: att
  integer(int8), pointer :: ptr(:)

  call allocate_attribute(att, name, NC_BYTE, size(values, kind=int64))
  call extract(att, ptr)
  ptr = values
end function new_att_int8

module function new_att_int8_scalar(name, value) result(att)
  character(len=*), intent(in) :: name
  integer(int8), intent(in) :: value
  type(attribute_type) :: att
  integer(int8) :: tmp(1)

  tmp(1) = value
  att = new_att_int8(name, tmp)
end function new_att_int8_scalar

module function new_att_int16(name, values) result(att)
  character(len=*), intent(in) :: name
  integer(int16), intent(in) :: values(:)
  type(attribute_type) :: att
  integer(int16), pointer :: ptr(:)

  call allocate_attribute(att, name, NC_SHORT, size(values, kind=int64))
  call extract(att, ptr)
  ptr = values
end function new_att_int16

module function new_att_int16_scalar(name, value) result(att)
  character(len=*), intent(in) :: name
  integer(int16), intent(in) :: value
  type(attribute_type) :: att
  integer(int16) :: tmp(1)

  tmp(1) = value
  att = new_att_int16(name, tmp)
end function new_att_int16_scalar

module function new_att_int32(name, values) result(att)
  character(len=*), intent(in) :: name
  integer(int32), intent(in) :: values(:)
  type(attribute_type) :: att
  integer(int32), pointer :: ptr(:)

  call allocate_attribute(att, name, NC_INT, size(values, kind=int64))
  call extract(att, ptr)
  ptr = values
end function new_att_int32

module function new_att_int32_scalar(name, value) result(att)
  character(len=*), intent(in) :: name
  integer(int32), intent(in) :: value
  type(attribute_type) :: att
  integer(int32) :: tmp(1)

  tmp(1) = value
  att = new_att_int32(name, tmp)
end function new_att_int32_scalar

module function new_att_int64(name, values) result(att)
  character(len=*), intent(in) :: name
  integer(int64), intent(in) :: values(:)
  type(attribute_type) :: att
  integer(int64), pointer :: ptr(:)

  call allocate_attribute(att, name, NC_INT64, size(values, kind=int64))
  call extract(att, ptr)
  ptr = values
end function new_att_int64

module function new_att_int64_scalar(name, value) result(att)
  character(len=*), intent(in) :: name
  integer(int64), intent(in) :: value
  type(attribute_type) :: att
  integer(int64) :: tmp(1)

  tmp(1) = value
  att = new_att_int64(name, tmp)
end function new_att_int64_scalar

module function new_att_real32(name, values) result(att)
  character(len=*), intent(in) :: name
  real(real32), intent(in) :: values(:)
  type(attribute_type) :: att
  real(real32), pointer :: ptr(:)

  call allocate_attribute(att, name, NC_FLOAT, size(values, kind=int64))
  call extract(att, ptr)
  ptr = values
end function new_att_real32

module function new_att_real32_scalar(name, value) result(att)
  character(len=*), intent(in) :: name
  real(real32), intent(in) :: value
  type(attribute_type) :: att
  real(real32) :: tmp(1)

  tmp(1) = value
  att = new_att_real32(name, tmp)
end function new_att_real32_scalar

module function new_att_real64(name, values) result(att)
  character(len=*), intent(in) :: name
  real(real64), intent(in) :: values(:)
  type(attribute_type) :: att
  real(real64), pointer :: ptr(:)

  call allocate_attribute(att, name, NC_DOUBLE, size(values, kind=int64))
  call extract(att, ptr)
  ptr = values
end function new_att_real64

module function new_att_real64_scalar(name, value) result(att)
  character(len=*), intent(in) :: name
  real(real64), intent(in) :: value
  type(attribute_type) :: att
  real(real64) :: tmp(1)

  tmp(1) = value
  att = new_att_real64(name, tmp)
end function new_att_real64_scalar

module function new_att_character(name, value) result(att)
  character(len=*), intent(in) :: name, value
  type(attribute_type), target :: att
  character(kind=c_char), pointer :: fptr(:)
  type(c_ptr) :: cptr
  integer(int64) :: i

  call allocate_attribute(att, name, NC_CHAR, len(value, kind=int64))
  cptr = c_loc(att%buffer(1))
  call c_f_pointer(cptr, fptr, [att%len])
  do i = 1, att%len
    fptr(i) = value(i:i)
  end do
end function new_att_character

end submodule submodule_attribute_constructor