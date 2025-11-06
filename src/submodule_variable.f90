submodule(module_netcdf) submodule_variable
implicit none
contains

module impure elemental function inquire_variable(nc, name, exist) result(var)
  type(netcdf_type), intent(in) :: nc
  character(len=*), intent(in) :: name
  logical, intent(out), optional :: exist
  type(variable_type) :: var

  var = inquire_variable_(nc%id, var%id, name, exist)
end function inquire_variable

impure elemental function inquire_variable_(ncid, varid, name, exist) result(var)
  integer(c_int), intent(in) :: ncid
  integer(c_int), intent(inout) :: varid
  character(len=*), intent(in) :: name
  logical, intent(out), optional :: exist
  type(variable_type) :: var
  integer(c_int) :: stat

  var%name = trim(adjustl(name))
  stat = nc_inq_varid(ncid, cstr(var%name), varid)
  if (present(exist)) then
    exist = stat == NC_NOERR
    if (.not. exist) return
  else
    call handle_error(stat)
  end if

  call handle_error(nc_inq_vartype(ncid, varid, var%data_type))
  var%attributes = get_attributes_(ncid, varid)
  var%dimensions = inquire_dimensions_(ncid, varid)
end function inquire_variable_

end submodule submodule_variable