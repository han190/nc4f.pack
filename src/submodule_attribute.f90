submodule(module_netcdf) submodule_attribute
implicit none
contains

module function new_attribute_arr_int32(name, values) result(att)
  character(len=*), intent(in) :: name
  integer(int32), intent(in) :: values(:)
  type(attribute_type), target :: att
  integer(c_int), pointer :: ptr(:)

  call new_attribute_(att, name, NC_INT, size(values, kind=int64))
  call allocate_buffer(att)
  call extract(att, ptr)
  ptr = values
  nullify (ptr)
end function new_attribute_arr_int32

module function new_attribute_int32(name, value) result(att)
  character(len=*), intent(in) :: name
  integer(int32), intent(in) :: value
  type(attribute_type) :: att

  att = new_attribute_arr_int32(name, [value])
end function new_attribute_int32

module function new_attribute_arr_int64(name, values) result(att)
  character(len=*), intent(in) :: name
  integer(int64), intent(in) :: values(:)
  type(attribute_type), target :: att
  integer(c_int64_t), pointer :: ptr(:)

  call new_attribute_(att, name, NC_INT64, size(values, kind=int64))
  call allocate_buffer(att)
  call extract(att, ptr)
  ptr = values
  nullify (ptr)
end function new_attribute_arr_int64

module function new_attribute_int64(name, value) result(att)
  character(len=*), intent(in) :: name
  integer(int64), intent(in) :: value
  type(attribute_type) :: att

  att = new_attribute_arr_int64(name, [value])
end function new_attribute_int64

module function new_attribute_arr_real32(name, values) result(att)
  character(len=*), intent(in) :: name
  real(real32), intent(in) :: values(:)
  type(attribute_type), target :: att
  real(c_float), pointer :: ptr(:)

  call new_attribute_(att, name, NC_FLOAT, size(values, kind=int64))
  call allocate_buffer(att)
  call extract(att, ptr)
  ptr = values
  nullify (ptr)
end function new_attribute_arr_real32

module function new_attribute_real32(name, value) result(att)
  character(len=*), intent(in) :: name
  real(real32), intent(in) :: value
  type(attribute_type) :: att

  att = new_attribute_arr_real32(name, [value])
end function new_attribute_real32

module function new_attribute_arr_real64(name, values) result(att)
  character(len=*), intent(in) :: name
  real(real64), intent(in) :: values(:)
  type(attribute_type), target :: att
  real(c_double), pointer :: ptr(:)

  call new_attribute_(att, name, NC_DOUBLE, size(values, kind=int64))
  call allocate_buffer(att)
  call extract(att, ptr)
  ptr = values
  nullify (ptr)
end function new_attribute_arr_real64

module function new_attribute_real64(name, value) result(att)
  character(len=*), intent(in) :: name
  real(real64), intent(in) :: value
  type(attribute_type) :: att

  att = new_attribute_arr_real64(name, [value])
end function new_attribute_real64

module function new_attribute_character(name, value) result(att)
  character(len=*), intent(in) :: name
  character(len=*), intent(in) :: value
  type(attribute_type), target :: att
  character(kind=c_char), pointer :: fptr(:)
  type(c_ptr) :: cptr
  integer(int64) :: i

  call new_attribute_(att, name, NC_CHAR, len(value, kind=int64))
  call allocate_buffer(att)
  cptr = c_loc(att%buffer(1))
  call c_f_pointer(cptr, fptr, [att%length])
  do i = 1, att%length
    fptr(i) = value(i:i)
  end do
  nullify (fptr)
end function new_attribute_character

pure subroutine new_attribute_(att, name, data_type, length)
  type(attribute_type), intent(inout) :: att
  character(len=*), intent(in) :: name
  integer(int32), intent(in) :: data_type
  integer(int64), intent(in) :: length

  att%name = trim(adjustl(name))
  att%data_type = data_type
  att%length = length
end subroutine new_attribute_

impure elemental module function get_attribute_name(nc, name) result(att)
  type(netcdf_type), intent(in) :: nc
  character(len=*), intent(in) :: name
  type(attribute_type) :: att

  att = get_attribute_(nc%id, NC_GLOBAL, f2cstr(trim(adjustl(name))))
end function get_attribute_name

module function get_attributes_global(nc) result(atts)
  type(netcdf_type), intent(in) :: nc
  type(attribute_type), allocatable :: atts(:)
  atts = get_attributes_(nc%id, NC_GLOBAL)
end function get_attributes_global

module function get_attributes_(ncid, varid) result(atts)
  integer(c_int), intent(in) :: ncid, varid
  type(attribute_type), allocatable :: atts(:)
  integer(c_int) :: natts, i
  character(kind=c_char, len=100) :: name

  if (varid == NC_GLOBAL) then
    call handle_error(nc_inq_natts(ncid, natts))
  else
    call handle_error(nc_inq_varnatts(ncid, varid, natts))
  end if

  if (natts == 0) then
    if (allocated(atts)) deallocate (atts)
    return
  end if

  if (.not. allocated(atts)) then
    allocate (atts(natts))
  else if (size(atts) < natts) then
    deallocate (atts)
    allocate (atts(natts))
  end if

  do i = 0, natts - 1
    call handle_error(nc_inq_attname(ncid, varid, i, name))
    atts(i + 1) = get_attribute_(ncid, varid, c2fstr(name))
  end do
end function get_attributes_

impure elemental function get_attribute_(ncid, varid, name) result(att)
  integer(c_int), intent(in) :: ncid, varid
  character(len=*), intent(in) :: name
  type(attribute_type), target :: att
  integer(c_int) :: data_type
  integer(c_size_t) :: length
  integer(int64) :: buffer_size

  att%name = trim(adjustl(name))
  call handle_error(nc_inq_att(ncid, varid, &
    & f2cstr(att%name), xtypep=data_type, lenp=length), &
    & "[get_attribute_] Invalid attribute: "//att%name//".")
  att%length = length
  att%data_type = data_type

  zero_size_attr: if (att%length == 0) then
    if (allocated(att%buffer)) deallocate (att%buffer)
    return
  end if zero_size_attr

  buffer_size = get_buffer_size(data_type, length)
  if (allocation_required(att%buffer, buffer_size)) then
    if (allocated(att%buffer)) deallocate (att%buffer)
    allocate (att%buffer(buffer_size))
  end if
  call handle_error(nc_get_att(ncid, varid, &
    & f2cstr(att%name), c_loc(att%buffer(1))), &
    & "[get_attribute_] Invalid attribute.")
end function get_attribute_

module impure elemental subroutine put_attribute_variable(nc, var)
  type(netcdf_type), intent(in) :: nc
  type(variable_type), target, intent(in) :: var
  integer :: i

  do i = 1, size(var%attributes)
    associate (att => var%attributes(i))
      call handle_error(nc_put_att(nc%id, var%id, f2cstr(att%name), &
        & att%data_type, att%length, c_loc(att%buffer(1))), &
        & "[put_attribute_] Invalid attribute.")
    end associate
  end do
end subroutine put_attribute_variable

module impure elemental subroutine put_attribute_global(nc)
  type(netcdf_type), intent(in) :: nc
  integer(int64) :: i

  if (.not. allocated(nc%attributes)) return
  do i = 1, size(nc%attributes, kind=int64)
    associate (att => nc%attributes(i))
      call handle_error(nc_put_att(nc%id, NC_GLOBAL, f2cstr(att%name), &
        & att%data_type, att%length, c_loc(att%buffer(1))), &
        & "[put_attribute_] Invalid attribute.")
    end associate
  end do
end subroutine put_attribute_global

pure module subroutine allocate_buffer_attribute(att)
  type(attribute_type), intent(inout) :: att
  integer(int64) :: buffer_size

  !> Assuming att%data_type and att%length is properly initialized.
  buffer_size = get_buffer_size(att%data_type, att%length)
  if (allocation_required(att%buffer, buffer_size)) then
    if (allocated(att%buffer)) deallocate (att%buffer)
    allocate (att%buffer(buffer_size))
  end if
end subroutine allocate_buffer_attribute

end submodule submodule_attribute
