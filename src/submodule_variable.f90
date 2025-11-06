submodule(module_netcdf) submodule_variable
implicit none
contains

module impure elemental function get_variable(nc, name, exist) result(var)
  type(netcdf_type), intent(in) :: nc
  character(len=*), intent(in) :: name
  logical, intent(out), optional :: exist
  type(variable_type) :: var

  var = get_variable_(nc%id, name, exist)
end function get_variable

impure elemental function get_variable_(ncid, name, exist) result(var)
  integer(c_int), intent(in) :: ncid
  character(len=*), intent(in) :: name
  logical, intent(out) :: exist
  type(variable_type), target :: var
  integer(int64) :: buffer_size

  var = inquire_variable_(ncid, name, exist)
  zero_size_var: if (var%length == 0) then
    if (allocated(var%buffer)) deallocate (var%buffer)
    return
  end if zero_size_var

  select case (var%data_type)
  case (NC_INT)
    buffer_size = var%length*storage_size(1_c_int)/8
  case (NC_FLOAT)
    buffer_size = var%length*storage_size(1.0_c_float)/8
  case default
    error stop "[get_variable_] Unsupported type."
  end select

  if (reallocation_required(var%buffer, buffer_size)) &
    & allocate (var%buffer(buffer_size))
  call handle_error(nc_get_var(ncid, var%id, c_loc(var%buffer(1))), &
    & "[get_variable_] Invalid variable.")
end function get_variable_

module impure elemental function inquire_variable(nc, name, exist) result(var)
  type(netcdf_type), intent(in) :: nc
  character(len=*), intent(in) :: name
  logical, intent(out), optional :: exist
  type(variable_type) :: var

  var = inquire_variable_(nc%id, name, exist)
end function inquire_variable

impure elemental function inquire_variable_(ncid, name, exist) result(var)
  integer(c_int), intent(in) :: ncid
  character(len=*), intent(in) :: name
  logical, intent(out), optional :: exist
  type(variable_type) :: var
  integer(c_int) :: stat
  integer :: i

  var%name = trim(adjustl(name))
  stat = nc_inq_varid(ncid, cstr(var%name), var%id)
  if (present(exist)) then
    exist = stat == NC_NOERR
    if (.not. exist) return
  else
    call handle_error(stat)
  end if

  call handle_error(nc_inq_vartype(ncid, var%id, var%data_type))
  var%attributes = get_attributes_(ncid, var%id)
  var%dimensions = inquire_dimensions_(ncid, var%id)
  var%length = 1
  do i = 1, size(var%dimensions)
    var%length = var%length * var%dimensions(i)%length
  end do
end function inquire_variable_

end submodule submodule_variable