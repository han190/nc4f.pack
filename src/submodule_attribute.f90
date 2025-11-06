submodule(module_netcdf) submodule_attribute
implicit none
integer(int8), parameter :: BYTE = 0_int8
contains

pure module function new_attribute_int32(name, value) result(att)
  character(len=*), intent(in) :: name
  integer, intent(in) :: value
  type(attribute_type) :: att

  call new_attribute_(att, name, NC_INT, 1_int64)
  att%buffer = transfer(value, BYTE, att%length*storage_size(value)/8)
end function new_attribute_int32

pure module function new_attribute_arr_int32(name, values) result(att)
  character(len=*), intent(in) :: name
  integer, intent(in) :: values(:)
  type(attribute_type) :: att

  call new_attribute_(att, name, NC_INT, size(values, kind=int64))
  att%buffer = transfer(values, BYTE, att%length*storage_size(values)/8)
end function new_attribute_arr_int32

pure module function new_attribute_real32(name, value) result(att)
  character(len=*), intent(in) :: name
  real, intent(in) :: value
  type(attribute_type) :: att

  call new_attribute_(att, name, NC_FLOAT, 1_int64)
  att%buffer = transfer(value, BYTE, att%length*storage_size(value)/8)
end function new_attribute_real32

pure module function new_attribute_arr_real32(name, values) result(att)
  character(len=*), intent(in) :: name
  real, intent(in) :: values(:)
  type(attribute_type) :: att

  call new_attribute_(att, name, NC_FLOAT, size(values, kind=int64))
  att%buffer = transfer(values, BYTE, att%length*storage_size(values)/8)
end function new_attribute_arr_real32

pure module function new_attribute_character(name, value) result(att)
  character(len=*), intent(in) :: name, value
  type(attribute_type) :: att

  call new_attribute_(att, name, NC_CHAR, len(value, kind=int64))
  att%buffer = transfer(value, BYTE, att%length)
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
  if (reallocation_required(att%buffer, buffer_size)) &
    & allocate (att%buffer(buffer_size))
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

module impure elemental subroutine put_attribute_global(nc, att)
  type(netcdf_type), intent(in) :: nc
  type(attribute_type), target, intent(in) :: att

  call handle_error(nc_put_att(nc%id, NC_GLOBAL, f2cstr(att%name), &
    & att%data_type, att%length, c_loc(att%buffer(1))), &
    & "[put_attribute_] Invalid attribute.")
end subroutine put_attribute_global

end submodule submodule_attribute
