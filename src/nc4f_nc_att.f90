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
  type(error_type) :: error

  att = get_att_(nc%id, NC_GLOBAL, clip(name), error)
  if (handle_error(error)) return
end function get_att_grp

!> Read a global attribute without stopping on a NetCDF failure.
module function get_att_grp_error(nc, name, error) result(att)
  !> Input argument(s): `nc`.
  class(group_type), intent(in) :: nc
  !> Input argument(s): `name`.
  character(len=*), intent(in) :: name
  !> Output argument(s): `error`.
  type(error_type), intent(out) :: error
  !> Return value: `att`.
  type(attribute_type) :: att

  att = get_att_(nc%id, NC_GLOBAL, clip(name), error)
end function get_att_grp_error

!> Return all global attributes for a dataset.
module function get_atts_grp(nc, error) result(atts)
  !> Input argument(s): `nc`.
  class(group_type), intent(in) :: nc
  !> Output argument(s): `error`.
  type(error_type), optional, intent(out) :: error
  !> Return value: `atts`.
  type(attribute_type), allocatable :: atts(:)
  type(error_type) :: operation_error

  atts = get_atts_(nc%id, NC_GLOBAL, operation_error)
  if (present(error)) then
    error = operation_error
  else if (handle_error(operation_error)) then
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
  type(error_type) :: error

  att = get_att_(nc%id, var%id, name, error)
  if (handle_error(error)) return
end function get_att_var

!> Read a variable attribute without stopping on a NetCDF failure.
module function get_att_var_error(nc, var, name, error) result(att)
  !> Input argument(s): `nc`.
  class(group_type), intent(in) :: nc
  !> Input argument(s): `var`.
  type(variable_type), intent(in) :: var
  !> Input argument(s): `name`.
  character(len=*), intent(in) :: name
  !> Output argument(s): `error`.
  type(error_type), intent(out) :: error
  !> Return value: `att`.
  type(attribute_type) :: att

  att = get_att_(nc%id, var%id, name, error)
end function get_att_var_error

!> Return all attributes attached to a variable.
module function get_atts_var(nc, var, error) result(atts)
  !> Input argument(s): `nc`.
  class(group_type), intent(in) :: nc
  !> Input argument(s): `var`.
  type(variable_type), intent(in) :: var
  !> Output argument(s): `error`.
  type(error_type), optional, intent(out) :: error
  !> Return value: `atts`.
  type(attribute_type), allocatable :: atts(:)
  type(error_type) :: operation_error

  atts = get_atts_(nc%id, var%id, operation_error)
  if (present(error)) then
    error = operation_error
  else if (handle_error(operation_error)) then
    return
  end if
end function get_atts_var

!> Helper that returns attributes for a C `ncid` and `varid`.
function get_atts_(ncid, varid, error) result(atts)
  !> Input argument(s): `ncid`.
  integer(c_int), intent(in) :: ncid
  !> Input argument(s): `varid`.
  integer(c_int), intent(in) :: varid
  !> Output argument(s): `error`.
  type(error_type), intent(out) :: error
  !> Return value: `atts`.
  type(attribute_type), allocatable :: atts(:)
  integer(c_int) :: natts, i, stat
  character(kind=c_char, len=NC_MAX_NAME + 1) :: name

  error = error_type()
  if (varid == NC_GLOBAL) then
    stat = nc_inq_natts(ncid, natts)
  else
    stat = nc_inq_varnatts(ncid, varid, natts)
  end if
  error = make_netcdf_error(stat, "[get_atts] Attribute count.")
  if (has_error(error)) return

  allocate (atts(natts))
  !> For the NetCDF C library, attribute IDs start from 0.
  do i = 0, natts - 1
    stat = nc_inq_attname(ncid, varid, i, name)
    error = make_netcdf_error(stat, "[get_atts] Attribute name.")
    if (has_error(error)) return
    atts(i + 1) = get_att_(ncid, varid, c2fstr(name), error)
    if (has_error(error)) return
  end do
end function get_atts_

!> Helper that reads a single attribute given C `ncid`, `varid`, and name.
function get_att_(ncid, varid, name, error) result(att)
  !> Input argument(s): `ncid`.
  integer(c_int), intent(in) :: ncid
  !> Input argument(s): `varid`.
  integer(c_int), intent(in) :: varid
  !> Input argument(s): `name`.
  character(len=*), intent(in) :: name
  !> Output argument(s): `error`.
  type(error_type), intent(out) :: error
  !> Return value: `att`.
  type(attribute_type), target :: att
  integer(c_int) :: dtype, stat
  integer(c_size_t) :: len
  character(len=:), allocatable :: context

  error = error_type()
  att%name = clip(name)
  context = "[get_att] Invalid attribute: "//att%name//"."
  stat = nc_inq_att(ncid, varid, f2cstr(att%name), xtypep=dtype, lenp=len)
  error = make_netcdf_error(stat, context)
  if (has_error(error)) return
  att%len = len
  att%dtype = dtype

  zero_size_attr: if (att%len == 0) then
    call validate_att_buffer(att, "[get_att]")
    if (associated(att%buffer)) nullify (att%buffer)
    return
  end if zero_size_attr

  call initialize(att)
  call validate_att_buffer(att, "[get_att]")
  stat = nc_get_att(ncid, varid, f2cstr(att%name), c_loc(att%buffer(1)))
  error = make_netcdf_error(stat, context)
end function get_att_

!> Write all attributes of a variable to the dataset.
!> This elemental overload preserves the existing array-variable API.
module impure elemental subroutine put_att_var(nc, var)
  !> Input argument(s): `nc`.
  class(group_type), intent(in) :: nc
  !> Input argument(s): `var`.
  type(variable_type), target, intent(in) :: var
  type(error_type) :: error

  call put_att_var_(nc, var, error)
  if (handle_error(error)) return
end subroutine put_att_var

!> Write variable attributes without stopping on a NetCDF failure.
module subroutine put_att_var_error(nc, var, error)
  !> Input argument(s): `nc`.
  class(group_type), intent(in) :: nc
  !> Input argument(s): `var`.
  type(variable_type), target, intent(in) :: var
  !> Output argument(s): `error`.
  type(error_type), intent(out) :: error

  call put_att_var_(nc, var, error)
end subroutine put_att_var_error

!> Scalar implementation shared by the fail-fast and error-aware overloads.
subroutine put_att_var_(nc, var, error)
  !> Input argument(s): `nc`.
  class(group_type), intent(in) :: nc
  !> Input argument(s): `var`.
  type(variable_type), target, intent(in) :: var
  !> Output argument(s): `error`.
  type(error_type), intent(out) :: error
  integer :: i
  integer(c_int) :: stat
  type(c_ptr) :: cptr
  character(len=:), allocatable :: context

  error = error_type()
  if (.not. allocated(var%atts)) return
  do i = 1, size(var%atts)
    associate (att => var%atts(i))
      call validate_att_buffer(att, "[put_att_var]")
      if (att%len == 0) then
        cptr = c_null_ptr
      else
        cptr = c_loc(att%buffer(1))
      end if
      context = "[put_att] Invalid attribute: "//att%name//"."
      stat = nc_put_att(nc%id, var%id, f2cstr(att%name), &
        & att%dtype, att%len, cptr)
      error = make_netcdf_error(stat, context)
      if (has_error(error)) return
    end associate
  end do
end subroutine put_att_var_

!> Write all global attributes of the dataset to the file.
!> This elemental overload preserves the existing scalar API.
module impure elemental subroutine put_att_grp(nc)
  !> Input argument(s): `nc`.
  class(group_type), target, intent(in) :: nc
  type(error_type) :: error

  call put_att_grp_(nc, error)
  if (handle_error(error)) return
end subroutine put_att_grp

!> Write global attributes without stopping on a NetCDF failure.
module subroutine put_att_grp_error(nc, error)
  !> Input argument(s): `nc`.
  class(group_type), target, intent(in) :: nc
  !> Output argument(s): `error`.
  type(error_type), intent(out) :: error

  call put_att_grp_(nc, error)
end subroutine put_att_grp_error

!> Scalar implementation shared by the fail-fast and error-aware overloads.
subroutine put_att_grp_(nc, error)
  !> Input argument(s): `nc`.
  class(group_type), target, intent(in) :: nc
  !> Output argument(s): `error`.
  type(error_type), intent(out) :: error
  integer(int64) :: i
  integer(c_int) :: stat
  type(c_ptr) :: cptr
  character(len=:), allocatable :: context

  error = error_type()
  if (.not. allocated(nc%atts)) return
  do i = 1, size(nc%atts, kind=int64)
    associate (att => nc%atts(i))
      call validate_att_buffer(att, "[put_att_grp]")
      if (att%len == 0) then
        cptr = c_null_ptr
      else
        cptr = c_loc(att%buffer(1))
      end if
      context = "[put_att] Invalid attribute: "//att%name//"."
      stat = nc_put_att(nc%id, NC_GLOBAL, f2cstr(att%name), &
        & att%dtype, att%len, cptr)
      error = make_netcdf_error(stat, context)
      if (has_error(error)) return
    end associate
  end do
end subroutine put_att_grp_

end submodule nc4f_nc_att
