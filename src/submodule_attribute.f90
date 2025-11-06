submodule(module_netcdf) submodule_attribute
implicit none
contains

module function new_attribute_arr_int32(name, values) result(att)
  character(len=*), intent(in) :: name
  integer(int32), intent(in) :: values(:)
  type(attribute_type), target :: att
  type(c_ptr) :: cptr
  integer(c_int), pointer :: fptr(:)
  integer(int64) :: buffer_size, nvals

  nvals = size(values, kind=int64)
  call new_attribute_(att, name, NC_INT, nvals)
  buffer_size = get_buffer_size(NC_INT, nvals)
  if (allocation_required(att%buffer, buffer_size)) then
    if (allocated(att%buffer)) deallocate (att%buffer)
    allocate (att%buffer(buffer_size))
  end if
  
  cptr = c_loc(att%buffer(1))
  call c_f_pointer(cptr, fptr, [nvals])
  fptr = values
  nullify (fptr)
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
  type(c_ptr) :: cptr
  integer(c_int64_t), pointer :: fptr(:)
  integer(int64) :: buffer_size, nvals

  nvals = size(values, kind=int64)
  call new_attribute_(att, name, NC_INT64, nvals)
  buffer_size = get_buffer_size(NC_INT64, nvals)
  if (allocation_required(att%buffer, buffer_size)) then
    if (allocated(att%buffer)) deallocate (att%buffer)
    allocate (att%buffer(buffer_size))
  end if
  
  cptr = c_loc(att%buffer(1))
  call c_f_pointer(cptr, fptr, [nvals])
  fptr = values
  nullify (fptr)
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
  type(c_ptr) :: cptr
  real(c_float), pointer :: fptr(:)
  integer(int64) :: buffer_size, nvals

  nvals = size(values, kind=int64)
  call new_attribute_(att, name, NC_FLOAT, nvals)
  buffer_size = get_buffer_size(NC_FLOAT, nvals)
  if (allocation_required(att%buffer, buffer_size)) then
    if (allocated(att%buffer)) deallocate (att%buffer)
    allocate (att%buffer(buffer_size))
  end if
  
  cptr = c_loc(att%buffer(1))
  call c_f_pointer(cptr, fptr, [nvals])
  fptr = values
  nullify (fptr)
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
  type(c_ptr) :: cptr
  real(c_double), pointer :: fptr(:)
  integer(int64) :: buffer_size, nvals

  nvals = size(values, kind=int64)
  call new_attribute_(att, name, NC_DOUBLE, nvals)
  buffer_size = get_buffer_size(NC_DOUBLE, nvals)
  if (allocation_required(att%buffer, buffer_size)) then
    if (allocated(att%buffer)) deallocate (att%buffer)
    allocate (att%buffer(buffer_size))
  end if
  
  cptr = c_loc(att%buffer(1))
  call c_f_pointer(cptr, fptr, [nvals])
  fptr = values
  nullify (fptr)
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
  type(c_ptr) :: cptr
  character(kind=c_char), pointer :: fptr(:)
  integer(int64) :: buffer_size, nvals, i

  nvals = len(value, kind=int64)
  call new_attribute_(att, name, NC_CHAR, nvals)
  buffer_size = get_buffer_size(NC_CHAR, nvals)
  if (allocation_required(att%buffer, buffer_size)) then
    if (allocated(att%buffer)) deallocate (att%buffer)
    allocate (att%buffer(buffer_size))
  end if
  
  cptr = c_loc(att%buffer(1))
  call c_f_pointer(cptr, fptr, [nvals])
  do i = 1, nvals
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

module impure elemental subroutine put_attribute_global(nc, att)
  type(netcdf_type), intent(in) :: nc
  type(attribute_type), target, intent(in) :: att

  call handle_error(nc_put_att(nc%id, NC_GLOBAL, f2cstr(att%name), &
    & att%data_type, att%length, c_loc(att%buffer(1))), &
    & "[put_attribute_] Invalid attribute.")
end subroutine put_attribute_global

end submodule submodule_attribute
