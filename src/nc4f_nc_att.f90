submodule(nc4f_nc) nc4f_nc_att
implicit none (type, external)
contains

!> Read a global attribute by name and return it.
module impure elemental function get_att_grp(nc, name) result(att)
  !> Input argument(s): `nc`.
  class(group_type), intent(in) :: nc
  !> Input argument(s): `name`.
  character(len=*), intent(in) :: name
  !> Return value: `att`.
  type(attribute_type) :: att
  type(error_type) :: err

  att = get_att_(nc%id, NC_GLOBAL, clip(name), err)
  if (handle_err(err)) return
end function get_att_grp

!> Read a global attribute without stopping on a NetCDF failure.
module function get_att_grp_err(nc, name, err) result(att)
  !> Input argument(s): `nc`.
  class(group_type), intent(in) :: nc
  !> Input argument(s): `name`.
  character(len=*), intent(in) :: name
  !> Output argument(s): `err`.
  type(error_type), intent(out) :: err
  !> Return value: `att`.
  type(attribute_type) :: att

  att = get_att_(nc%id, NC_GLOBAL, clip(name), err)
end function get_att_grp_err

!> Return all global attributes for a dataset.
module function get_atts_grp(nc, err) result(atts)
  !> Input argument(s): `nc`.
  class(group_type), intent(in) :: nc
  !> Output argument(s): `err`.
  type(error_type), optional, intent(out) :: err
  !> Return value: `atts`.
  type(attribute_type), allocatable :: atts(:)
  type(error_type) :: operation_err

  atts = get_atts_(nc%id, NC_GLOBAL, operation_err)
  if (present(err)) then
    err = operation_err
  else if (handle_err(operation_err)) then
    return
  end if
end function get_atts_grp

!> Read a named attribute attached to a variable and return it.
module function get_att_var(nc, var, name) result(att)
  !> Input argument(s): `nc`.
  class(group_type), intent(in) :: nc
  !> Input argument(s): `var`.
  type(variable_type), intent(in) :: var
  !> Input argument(s): `name`.
  character(len=*), intent(in) :: name
  !> Return value: `att`.
  type(attribute_type) :: att
  type(error_type) :: err

  att = get_att_(nc%id, var%id, name, err)
  if (handle_err(err)) return
end function get_att_var

!> Read a variable attribute without stopping on a NetCDF failure.
module function get_att_var_err(nc, var, name, err) result(att)
  !> Input argument(s): `nc`.
  class(group_type), intent(in) :: nc
  !> Input argument(s): `var`.
  type(variable_type), intent(in) :: var
  !> Input argument(s): `name`.
  character(len=*), intent(in) :: name
  !> Output argument(s): `err`.
  type(error_type), intent(out) :: err
  !> Return value: `att`.
  type(attribute_type) :: att

  att = get_att_(nc%id, var%id, name, err)
end function get_att_var_err

!> Return all attributes attached to a variable.
module function get_atts_var(nc, var, err) result(atts)
  !> Input argument(s): `nc`.
  class(group_type), intent(in) :: nc
  !> Input argument(s): `var`.
  type(variable_type), intent(in) :: var
  !> Output argument(s): `err`.
  type(error_type), optional, intent(out) :: err
  !> Return value: `atts`.
  type(attribute_type), allocatable :: atts(:)
  type(error_type) :: operation_err

  atts = get_atts_(nc%id, var%id, operation_err)
  if (present(err)) then
    err = operation_err
  else if (handle_err(operation_err)) then
    return
  end if
end function get_atts_var

!> Helper that returns attributes for a C `ncid` and `varid`.
function get_atts_(ncid, varid, err) result(atts)
  !> Input argument(s): `ncid`.
  integer(c_int), intent(in) :: ncid
  !> Input argument(s): `varid`.
  integer(c_int), intent(in) :: varid
  !> Output argument(s): `err`.
  type(error_type), intent(out) :: err
  !> Return value: `atts`.
  type(attribute_type), allocatable :: atts(:)
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
  !> For the NetCDF C library, attribute IDs start from 0.
  do i = 0, natts - 1
    stat = nc_inq_attname(ncid, varid, i, name)
    err = netcdf_err(stat, "[get_atts] Attribute name.")
    if (has_err(err)) return
    atts(i + 1) = get_att_(ncid, varid, c2fstr(name), err)
    if (has_err(err)) return
  end do
end function get_atts_

!> Helper that reads a single attribute given C `ncid`, `varid`, and name.
function get_att_(ncid, varid, name, err) result(att)
  !> Input argument(s): `ncid`.
  integer(c_int), intent(in) :: ncid
  !> Input argument(s): `varid`.
  integer(c_int), intent(in) :: varid
  !> Input argument(s): `name`.
  character(len=*), intent(in) :: name
  !> Output argument(s): `err`.
  type(error_type), intent(out) :: err
  !> Return value: `att`.
  type(attribute_type), target :: att
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

!> Write all attributes of a variable to the dataset.
!> This elemental overload preserves the existing array-variable API.
module impure elemental subroutine put_att_var(nc, var)
  !> Input argument(s): `nc`.
  class(group_type), intent(in) :: nc
  !> Input argument(s): `var`.
  type(variable_type), target, intent(in) :: var
  type(error_type) :: err

  call put_att_var_(nc, var, err)
  if (handle_err(err)) return
end subroutine put_att_var

!> Write variable attributes without stopping on a NetCDF failure.
module subroutine put_att_var_err(nc, var, err)
  !> Input argument(s): `nc`.
  class(group_type), intent(in) :: nc
  !> Input argument(s): `var`.
  type(variable_type), target, intent(in) :: var
  !> Output argument(s): `err`.
  type(error_type), intent(out) :: err

  call put_att_var_(nc, var, err)
end subroutine put_att_var_err

!> Scalar implementation shared by the fail-fast and error-aware overloads.
subroutine put_att_var_(nc, var, err)
  !> Input argument(s): `nc`.
  class(group_type), intent(in) :: nc
  !> Input argument(s): `var`.
  type(variable_type), target, intent(in) :: var
  !> Output argument(s): `err`.
  type(error_type), intent(out) :: err
  integer :: i
  integer(c_int) :: stat
  type(c_ptr) :: cptr
  character(len=:), allocatable :: context

  err = error_type()
  if (.not. allocated(var%atts)) return
  do i = 1, size(var%atts)
    associate (att => var%atts(i))
      call validate(att, context="[put_att_var]")
      if (att%len == 0) then
        cptr = c_null_ptr
      else
        cptr = buffer2cptr(att)
      end if
      context = "[put_att] Invalid attribute: "//att%name//"."
      stat = nc_put_att(nc%id, var%id, f2cstr(att%name), &
        & att%dtype, att%len, cptr)
      err = netcdf_err(stat, context)
      if (has_err(err)) return
    end associate
  end do
end subroutine put_att_var_

!> Write all global attributes of the dataset to the file.
!> This elemental overload preserves the existing scalar API.
module impure elemental subroutine put_att_grp(nc)
  !> Input argument(s): `nc`.
  class(group_type), target, intent(in) :: nc
  type(error_type) :: err

  call put_att_grp_(nc, err)
  if (handle_err(err)) return
end subroutine put_att_grp

!> Write global attributes without stopping on a NetCDF failure.
module subroutine put_att_grp_err(nc, err)
  !> Input argument(s): `nc`.
  class(group_type), target, intent(in) :: nc
  !> Output argument(s): `err`.
  type(error_type), intent(out) :: err

  call put_att_grp_(nc, err)
end subroutine put_att_grp_err

!> Scalar implementation shared by the fail-fast and error-aware overloads.
subroutine put_att_grp_(nc, err)
  !> Input argument(s): `nc`.
  class(group_type), target, intent(in) :: nc
  !> Output argument(s): `err`.
  type(error_type), intent(out) :: err
  integer(int64) :: i
  integer(c_int) :: stat
  type(c_ptr) :: cptr
  character(len=:), allocatable :: context

  err = error_type()
  if (.not. allocated(nc%atts)) return
  do i = 1, size(nc%atts, kind=int64)
    associate (att => nc%atts(i))
      call validate(att, context="[put_att_grp]")
      if (att%len == 0) then
        cptr = c_null_ptr
      else
        cptr = buffer2cptr(att)
      end if
      context = "[put_att] Invalid attribute: "//att%name//"."
      stat = nc_put_att(nc%id, NC_GLOBAL, f2cstr(att%name), &
        & att%dtype, att%len, cptr)
      err = netcdf_err(stat, context)
      if (has_err(err)) return
    end associate
  end do
end subroutine put_att_grp_

end submodule nc4f_nc_att
