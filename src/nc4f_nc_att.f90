submodule(nc4f_nc) nc4f_nc_att
implicit none (type, external)
contains

!> Read a global attribute by name and return it.
module impure elemental function get_att_nc(nc, name) result(att)
  type(netcdf_type), intent(in) :: nc
  character(len=*), intent(in) :: name
  type(attribute_type) :: att
  type(error_type) :: error

  att = get_att_(nc%id, NC_GLOBAL, clip(name), error)
  if (handle_error(error)) return
end function get_att_nc

!> Read a global attribute without stopping on a NetCDF failure.
module function get_att_nc_error(nc, name, error) result(att)
  type(netcdf_type), intent(in) :: nc
  character(len=*), intent(in) :: name
  type(error_type), intent(out) :: error
  type(attribute_type) :: att

  att = get_att_(nc%id, NC_GLOBAL, clip(name), error)
end function get_att_nc_error

!> Return all global attributes for a dataset.
module function get_atts_nc(nc, error) result(atts)
  type(netcdf_type), intent(in) :: nc
  type(error_type), optional, intent(out) :: error
  type(attribute_type), allocatable :: atts(:)
  type(error_type) :: operation_error

  atts = get_atts_(nc%id, NC_GLOBAL, operation_error)
  if (present(error)) then
    error = operation_error
  else if (handle_error(operation_error)) then
    return
  end if
end function get_atts_nc

!> Read a named attribute attached to a variable and return it.
module function get_att_var(nc, var, name) result(att)
  type(netcdf_type), intent(in) :: nc
  type(variable_type), intent(in) :: var
  character(len=*), intent(in) :: name
  type(attribute_type) :: att
  type(error_type) :: error

  att = get_att_(nc%id, var%id, name, error)
  if (handle_error(error)) return
end function get_att_var

!> Read a variable attribute without stopping on a NetCDF failure.
module function get_att_var_error(nc, var, name, error) result(att)
  type(netcdf_type), intent(in) :: nc
  type(variable_type), intent(in) :: var
  character(len=*), intent(in) :: name
  type(error_type), intent(out) :: error
  type(attribute_type) :: att

  att = get_att_(nc%id, var%id, name, error)
end function get_att_var_error

!> Return all attributes attached to a variable.
module function get_atts_var(nc, var, error) result(atts)
  type(netcdf_type), intent(in) :: nc
  type(variable_type), intent(in) :: var
  type(error_type), optional, intent(out) :: error
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
  integer(c_int), intent(in) :: ncid
  integer(c_int), intent(in) :: varid
  type(error_type), intent(out) :: error
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
  if (is_failed(error)) return

  allocate (atts(natts))
  !> For the NetCDF C library, attribute IDs start from 0.
  do i = 0, natts - 1
    stat = nc_inq_attname(ncid, varid, i, name)
    error = make_netcdf_error(stat, "[get_atts] Attribute name.")
    if (is_failed(error)) return
    atts(i + 1) = get_att_(ncid, varid, c2fstr(name), error)
    if (is_failed(error)) return
  end do
end function get_atts_

!> Helper that reads a single attribute given C `ncid`, `varid`, and name.
function get_att_(ncid, varid, name, error) result(att)
  integer(c_int), intent(in) :: ncid
  integer(c_int), intent(in) :: varid
  character(len=*), intent(in) :: name
  type(error_type), intent(out) :: error
  type(attribute_type), target :: att
  integer(c_int) :: dtype, stat
  integer(c_size_t) :: len
  character(len=:), allocatable :: context

  error = error_type()
  att%name = clip(name)
  context = "[get_att] Invalid attribute: "//att%name//"."
  stat = nc_inq_att(ncid, varid, f2cstr(att%name), xtypep=dtype, lenp=len)
  error = make_netcdf_error(stat, context)
  if (is_failed(error)) return
  att%len = len
  att%dtype = dtype

  zero_size_attr: if (att%len == 0) then
    call validate_buffer(att, "[get_att]")
    if (allocated(att%buffer)) deallocate (att%buffer)
    return
  end if zero_size_attr

  call allocate_memory(att)
  call validate_buffer(att, "[get_att]")
  stat = nc_get_att(ncid, varid, f2cstr(att%name), c_loc(att%buffer(1)))
  error = make_netcdf_error(stat, context)
end function get_att_

!> Write all attributes of a variable to the dataset.
!> This elemental overload preserves the existing array-variable API.
module impure elemental subroutine put_att_var(nc, var)
  type(netcdf_type), intent(in) :: nc
  type(variable_type), target, intent(in) :: var
  type(error_type) :: error

  call put_att_var_(nc, var, error)
  if (handle_error(error)) return
end subroutine put_att_var

!> Write variable attributes without stopping on a NetCDF failure.
module subroutine put_att_var_error(nc, var, error)
  type(netcdf_type), intent(in) :: nc
  type(variable_type), target, intent(in) :: var
  type(error_type), intent(out) :: error

  call put_att_var_(nc, var, error)
end subroutine put_att_var_error

!> Scalar implementation shared by the fail-fast and error-aware overloads.
subroutine put_att_var_(nc, var, error)
  type(netcdf_type), intent(in) :: nc
  type(variable_type), target, intent(in) :: var
  type(error_type), intent(out) :: error
  integer :: i
  integer(c_int) :: stat
  type(c_ptr) :: cptr
  character(len=:), allocatable :: context

  error = error_type()
  if (.not. allocated(var%atts)) return
  do i = 1, size(var%atts)
    associate (att => var%atts(i))
      call validate_buffer(att, "[put_att_var]")
      if (att%len == 0) then
        cptr = c_null_ptr
      else
        cptr = c_loc(att%buffer(1))
      end if
      context = "[put_att] Invalid attribute: "//att%name//"."
      stat = nc_put_att(nc%id, var%id, f2cstr(att%name), &
        & att%dtype, att%len, cptr)
      error = make_netcdf_error(stat, context)
      if (is_failed(error)) return
    end associate
  end do
end subroutine put_att_var_

!> Write all global attributes of the dataset to the file.
!> This elemental overload preserves the existing scalar API.
module impure elemental subroutine put_att_nc(nc)
  type(netcdf_type), target, intent(in) :: nc
  type(error_type) :: error

  call put_att_nc_(nc, error)
  if (handle_error(error)) return
end subroutine put_att_nc

!> Write global attributes without stopping on a NetCDF failure.
module subroutine put_att_nc_error(nc, error)
  type(netcdf_type), target, intent(in) :: nc
  type(error_type), intent(out) :: error

  call put_att_nc_(nc, error)
end subroutine put_att_nc_error

!> Scalar implementation shared by the fail-fast and error-aware overloads.
subroutine put_att_nc_(nc, error)
  type(netcdf_type), target, intent(in) :: nc
  type(error_type), intent(out) :: error
  integer(int64) :: i
  integer(c_int) :: stat
  type(c_ptr) :: cptr
  character(len=:), allocatable :: context

  error = error_type()
  if (.not. allocated(nc%atts)) return
  do i = 1, size(nc%atts, kind=int64)
    associate (att => nc%atts(i))
      call validate_buffer(att, "[put_att_nc]")
      if (att%len == 0) then
        cptr = c_null_ptr
      else
        cptr = c_loc(att%buffer(1))
      end if
      context = "[put_att] Invalid attribute: "//att%name//"."
      stat = nc_put_att(nc%id, NC_GLOBAL, f2cstr(att%name), &
        & att%dtype, att%len, cptr)
      error = make_netcdf_error(stat, context)
      if (is_failed(error)) return
    end associate
  end do
end subroutine put_att_nc_

end submodule nc4f_nc_att
