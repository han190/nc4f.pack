submodule(nc4f_nc) nc4f_nc_attribute
implicit none (type, external)
contains

impure elemental module function get_att_grp(nc, name, err) result(att)
  !! Read a global attribute by name and return it.
  class(group_type), intent(in) :: nc
  !! Dataset or group containing the global attribute.
  character(len=*), intent(in) :: name
  !! Name of the global attribute to read.
  type(error_type), intent(out), optional :: err
  !! Optional operation error. When absent, failures stop the program.
  type(attribute_type) :: att
  !! Returned attribute object.
  type(error_type) :: op_err

  att = get_att_(nc%id, NC_GLOBAL, clip(name), op_err)
  if (present(err)) then
    err = op_err
  else if (handle_err(op_err)) then
    return
  end if
end function get_att_grp

module function get_atts_grp(nc, err) result(atts)
  !! Return all global attributes for a dataset.
  class(group_type), intent(in) :: nc
  !! Open NetCDF dataset handle.
  type(error_type), optional, intent(out) :: err
  !! Error object updated if the operation fails.
  type(attribute_type), allocatable :: atts(:)
  !! Retrieved attributes.
  type(error_type) :: op_err

  atts = get_atts_(nc%id, NC_GLOBAL, op_err)
  if (present(err)) then
    err = op_err
  else if (handle_err(op_err)) then
    return
  end if
end function get_atts_grp

module function get_att_var(nc, var, name, err) result(att)
  !! Read a named attribute attached to a variable and return it.
  class(group_type), intent(in) :: nc
  !! Dataset or group containing the variable.
  type(variable_type), intent(in) :: var
  !! Variable whose attribute is read.
  character(len=*), intent(in) :: name
  !! Name of the attribute to read.
  type(error_type), intent(out), optional :: err
  !! Optional operation error. When absent, failures stop the program.
  type(attribute_type) :: att
  !! Returned attribute object.
  type(error_type) :: op_err

  att = get_att_(nc%id, var%id, name, op_err)
  if (present(err)) then
    err = op_err
  else if (handle_err(op_err)) then
    return
  end if
end function get_att_var

module function get_atts_var(nc, var, err) result(atts)
  !! Return all attributes attached to a variable.
  class(group_type), intent(in) :: nc
  !! Open NetCDF dataset handle.
  type(variable_type), intent(in) :: var
  !! Variable to process.
  type(error_type), optional, intent(out) :: err
  !! Error object updated if the operation fails.
  type(attribute_type), allocatable :: atts(:)
  !! Retrieved attributes.
  type(error_type) :: op_err

  atts = get_atts_(nc%id, var%id, op_err)
  if (present(err)) then
    err = op_err
  else if (handle_err(op_err)) then
    return
  end if
end function get_atts_var

function get_atts_(ncid, varid, err) result(atts)
  !! Helper that returns attributes for a C `ncid` and `varid`.
  integer(c_int), intent(in) :: ncid
  !! Identifier of the open NetCDF file or group.
  integer(c_int), intent(in) :: varid
  !! Identifier of the target NetCDF variable.
  type(error_type), intent(out) :: err
  !! Error object updated if the operation fails.
  type(attribute_type), allocatable :: atts(:)
  !! Retrieved attributes.
  integer(c_int) :: natts, i, stat
  character(kind=c_char, len=NC_MAX_NAME + 1) :: name

  err = error_type()
  if (varid == NC_GLOBAL) then
    stat = nc_inq_natts(ncid, natts)
  else
    stat = nc_inq_varnatts(ncid, varid, natts)
  end if
  err = netcdf_err(stat, "[get_atts] Attribute count.")
  if (has_err(err)) return

  allocate (atts(natts))
  do i = 0, natts - 1
    !! For the NetCDF C library, attribute IDs start from 0.
    stat = nc_inq_attname(ncid, varid, i, name)
    err = netcdf_err(stat, "[get_atts] Attribute name.")
    if (has_err(err)) return
    atts(i + 1) = get_att_(ncid, varid, c2fstr(name), err)
    if (has_err(err)) return
  end do
end function get_atts_

function get_att_(ncid, varid, name, err) result(att)
  !! Helper that reads a single attribute given C `ncid`, `varid`, and name.
  integer(c_int), intent(in) :: ncid
  !! Identifier of the open NetCDF file or group.
  integer(c_int), intent(in) :: varid
  !! Identifier of the target NetCDF variable.
  character(len=*), intent(in) :: name
  !! Name used to identify the NetCDF object.
  type(error_type), intent(out) :: err
  !! Error object updated if the operation fails.
  type(attribute_type), target :: att
  !! Retrieved or constructed attribute.
  integer(c_int) :: dtype, stat
  integer(c_size_t) :: len
  character(len=:), allocatable :: context

  err = error_type()
  att%name = clip(name)
  context = "[get_att] Invalid attribute: "//att%name//"."
  stat = nc_inq_att(ncid, varid, f2cstr(att%name), xtypep=dtype, lenp=len)
  err = netcdf_err(stat, context)
  if (has_err(err)) return
  att%len = len
  att%dtype = dtype

  zero_size_attr: if (att%len == 0) then
    call validate(att, context="[get_att]")
    return
  end if zero_size_attr

  call initialize(att)
  call validate(att, context="[get_att]")
  stat = nc_get_att(ncid, varid, f2cstr(att%name), buffer2cptr(att))
  err = netcdf_err(stat, context)
end function get_att_

module subroutine put_att_var(nc, var, err)
  !! Scalar implementation shared by the fail-fast and error-aware overloads.
  class(group_type), intent(in) :: nc
  !! Open NetCDF dataset handle.
  type(variable_type), target, intent(in) :: var
  !! Variable to process.
  type(error_type), intent(out) :: err
  !! Error object updated if the operation fails.

  call put_atts_(nc%id, var%id, var%atts, "[put_att_var]", err)
end subroutine put_att_var

module subroutine put_att_grp(nc, err)
  !! Scalar implementation shared by the fail-fast and error-aware overloads.
  class(group_type), target, intent(in) :: nc
  !! Open NetCDF dataset handle.
  type(error_type), intent(out) :: err
  !! Error object updated if the operation fails.

  call put_atts_(nc%id, NC_GLOBAL, nc%atts, "[put_att_grp]", err)
end subroutine put_att_grp

subroutine put_atts_(ncid, varid, atts, context, err)
  !! Write an array of attributes to a variable or group using C identifiers.
  integer(c_int), intent(in) :: ncid
  !! C identifier for the dataset or group receiving the attributes.
  integer(c_int), intent(in) :: varid
  !! C identifier for the variable, or `NC_GLOBAL` for group attributes.
  type(attribute_type), target, intent(in), allocatable :: atts(:)
  !! Attributes to write. An unallocated array represents no attributes.
  character(len=*), intent(in) :: context
  !! Context used if attribute validation fails.
  type(error_type), intent(out) :: err
  !! Completed result of this operation.
  integer :: i
  integer(c_int) :: stat
  type(c_ptr) :: cptr

  err = error_type()
  if (.not. allocated(atts)) return
  do i = 1, size(atts)
    associate (att => atts(i))
      call validate(att, context=context)
      if (att%len == 0) then
        cptr = c_null_ptr
      else
        cptr = buffer2cptr(att)
      end if
      stat = nc_put_att(ncid, varid, f2cstr(att%name), &
        & att%dtype, att%len, cptr)
      associate(msg => "[put_att] Invalid attribute: "//att%name//".")
        err = netcdf_err(stat, msg)
      end associate
      if (has_err(err)) return
    end associate
  end do
end subroutine put_atts_

end submodule nc4f_nc_attribute
