submodule(nc4f_nc) nc4f_nc_attribute
implicit none (type, external)
contains

module subroutine rename_att_nc_var(grp, var, old_name, new_name, update_file, err)
  !! Rename a variable attribute; optionally update the file and supplied cache.
  !! Other variable copies, including grp%vars, are not synchronized.
  class(group_type), intent(in) :: grp
  !! Open group containing the supplied variable when a file update is requested.
  type(variable_type), intent(inout) :: var
  !! Variable whose matching attribute is renamed; its data and own name are preserved.
  character(len=*), intent(in) :: old_name, new_name
  !! old_name: Existing local name to locate.
  !! new_name: Replacement local name; trailing Fortran blank padding is removed.
  logical, intent(in), optional :: update_file
  !! Whether to update the open NetCDF file as well as the model (default false).
  type(error_type), intent(out), optional :: err
  !! Receives the status and diagnostic; failures stop execution when omitted.
  type(error_type) :: op_err
  type(variable_type) :: name
  integer(c_int) :: stat, varid
  logical :: write_file

  write_file = .false.
  if (present(update_file)) write_file = update_file
  if (.not. write_file) then
    call rename_attribute(var, old_name, new_name, op_err)
  else if (.not. allocated(var%name)) then
    op_err = error_type(NC_EINVAL, "[rename_attribute] Variable must have a name.")
  else
    ! Validate before crossing the C boundary, including embedded NULs/paths.
    call rename_variable(name, var%name, op_err)
    if (.not. has_err(op_err)) then
      stat = nc_inq_varid(grp%id, f2cstr(name%name), varid)
      op_err = netcdf_err(stat, "[rename_attribute] Resolve variable: "//name%name)
      if (.not. has_err(op_err)) then
        call rename_att_nc_(grp%id, varid, var%atts, old_name, new_name, op_err)
      end if
    end if
  end if
  if (present(err)) then
    err = op_err
  else if (handle_err(op_err)) then
    return
  end if
end subroutine rename_att_nc_var

module subroutine rename_att_nc_grp(grp, old_name, new_name, update_file, err)
  !! Rename a group/global attribute in the file and any matching cached entry.
  !! update_file is required to distinguish this from the model-only overload.
  class(group_type), intent(inout) :: grp
  !! Group whose matching global attribute is renamed.
  character(len=*), intent(in) :: old_name, new_name
  !! old_name: Existing local name to locate.
  !! new_name: Replacement local name; trailing Fortran blank padding is removed.
  logical, intent(in) :: update_file
  !! Whether to update the open NetCDF file as well as the model.
  type(error_type), intent(out), optional :: err
  !! Receives the status and diagnostic; failures stop execution when omitted.
  type(error_type) :: op_err

  if (update_file) then
    call rename_att_nc_(grp%id, NC_GLOBAL, grp%atts, old_name, new_name, op_err)
  else
    call rename_attribute(grp, old_name, new_name, op_err)
  end if
  if (present(err)) then
    err = op_err
  else if (handle_err(op_err)) then
    return
  end if
end subroutine rename_att_nc_grp

subroutine rename_att_nc_(ncid, varid, atts, old_name, new_name, err)
  !! Stage only names: attribute values and borrowed buffers are never copied.
  !! An unloaded cache remains unloaded. The file is authoritative for existence.
  integer(c_int), intent(in) :: ncid, varid
  !! ncid: Open file or group identifier used by the NetCDF C API.
  !! varid: Variable identifier, or NC_GLOBAL for group attributes.
  type(attribute_type), allocatable, intent(inout) :: atts(:)
  !! Attribute collection whose matching entry is renamed.
  character(len=*), intent(in) :: old_name, new_name
  !! old_name: Existing local name to locate.
  !! new_name: Replacement local name; trailing Fortran blank padding is removed.
  type(error_type), intent(out) :: err
  !! Receives the operation status and diagnostic message.
  type(group_type) :: staged
  integer(c_int) :: stat, attid
  integer :: i, n, pos

  n = 0
  if (allocated(atts)) n = size(atts)
  allocate (staged%atts(n + 1))
  pos = 0
  do i = 1, n
    if (.not. allocated(atts(i)%name)) cycle
    staged%atts(i)%name = atts(i)%name
    if (atts(i)%name == trim(old_name)) pos = i
  end do
  if (pos == 0) then
    ! A name-only placeholder lets the model layer check syntax and collisions
    ! even when the source attribute has not been materialized.
    staged%atts(n + 1)%name = trim(old_name)
  end if
  call rename_attribute(staged, old_name, new_name, err)
  if (has_err(err)) return

  stat = nc_inq_attid(ncid, varid, f2cstr(old_name), attid)
  err = netcdf_err(stat, "[rename_attribute] Find attribute: "//trim(old_name))
  if (has_err(err)) return
  stat = nc_rename_att(ncid, varid, f2cstr(old_name), f2cstr(new_name))
  ! NetCDF-4 reports a collision for an existing attribute renamed to itself.
  ! Preserve other errors (notably read-only access), and verify existence above.
  if (trim(old_name) == trim(new_name) .and. stat == NC_ENAMEINUSE) stat = NC_NOERR
  err = netcdf_err(stat, "[rename_attribute] Rename attribute: "// &
    & trim(old_name)//" -> "//trim(new_name))
  if (has_err(err)) return
  if (pos /= 0) call move_alloc(staged%atts(pos)%name, atts(pos)%name)
end subroutine rename_att_nc_

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
