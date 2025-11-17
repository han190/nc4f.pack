submodule(module_netcdf) submodule_attribute
implicit none (type, external)
contains

impure elemental module function get_att_nc(nc, name) result(att)
  type(netcdf_type), intent(in) :: nc
  character(len=*), intent(in) :: name
  type(attribute_type) :: att

  att = get_att_(nc%id, NC_GLOBAL, f2cstr(trim(adjustl(name))))
end function get_att_nc

module function get_atts_nc(nc) result(atts)
  type(netcdf_type), intent(in) :: nc
  type(attribute_type), allocatable :: atts(:)
  atts = get_atts_(nc%id, NC_GLOBAL)
end function get_atts_nc

module function get_atts_(ncid, varid, exist) result(atts)
  integer(c_int), intent(in) :: ncid, varid
  logical, intent(inout), optional :: exist
  type(attribute_type), allocatable :: atts(:)
  integer(c_int) :: natts, i
  character(kind=c_char, len=100) :: name
  integer(c_int) :: stat

  if (varid == NC_GLOBAL) then
    stat = nc_inq_natts(ncid, natts)
  else
    stat = nc_inq_varnatts(ncid, varid, natts)
  end if

  if (present(exist)) then
    exist = stat == NC_NOERR
    if (.not. exist) return
  end if
  call handle_error(stat)

  if (.not. allocated(atts)) then
    allocate (atts(natts))
  else if (size(atts) < natts) then
    deallocate (atts)
    allocate (atts(natts))
  end if

  do i = 0, natts - 1
    call handle_error(nc_inq_attname(ncid, varid, i, name))
    atts(i + 1) = get_att_(ncid, varid, c2fstr(name))
  end do
end function get_atts_

impure elemental function get_att_(ncid, varid, name) result(att)
  integer(c_int), intent(in) :: ncid, varid
  character(len=*), intent(in) :: name
  type(attribute_type), target :: att
  integer(c_int) :: dtype
  integer(c_size_t) :: len

  att%name = trim(adjustl(name))
  call handle_error(nc_inq_att(ncid, varid, &
    & f2cstr(att%name), xtypep=dtype, lenp=len), &
    & "[get_att_] Invalid attribute: "//att%name//".")
  att%len = len
  att%dtype = dtype

  zero_size_attr: if (att%len == 0) then
    if (allocated(att%buffer)) deallocate (att%buffer)
    return
  end if zero_size_attr

  call allocate_buffer_att(att)
  call handle_error(nc_get_att(ncid, varid, &
    & f2cstr(att%name), c_loc(att%buffer(1))), &
    & "[get_att_] Invalid attribute.")
end function get_att_

module impure elemental subroutine put_att_var(nc, var)
  type(netcdf_type), intent(in) :: nc
  type(variable_type), target, intent(in) :: var
  integer :: i

  do i = 1, size(var%atts)
    associate (att => var%atts(i))
      call handle_error(nc_put_att(nc%id, var%id, f2cstr(att%name), &
        & att%dtype, att%len, c_loc(att%buffer(1))), &
        & "[put_att_] Invalid attribute.")
    end associate
  end do
end subroutine put_att_var

module impure elemental subroutine put_att_nc(nc)
  type(netcdf_type), target, intent(in) :: nc
  integer(int64) :: i

  if (.not. allocated(nc%atts)) return
  do i = 1, size(nc%atts, kind=int64)
    associate (att => nc%atts(i))
      call handle_error(nc_put_att(nc%id, NC_GLOBAL, f2cstr(att%name), &
        & att%dtype, att%len, c_loc(att%buffer(1))), &
        & "[put_att_] Invalid attribute.")
    end associate
  end do
end subroutine put_att_nc

pure module subroutine allocate_buffer_att(att)
  type(attribute_type), intent(inout) :: att
  integer(int64) :: buffer_size

  !> Assuming att%dtype and att%len is properly initialized.
  buffer_size = get_buffer_size(att%dtype, att%len)
  if (allocation_required(att%buffer, buffer_size)) then
    if (allocated(att%buffer)) deallocate (att%buffer)
    allocate (att%buffer(buffer_size))
  end if
end subroutine allocate_buffer_att

module elemental logical function eq_att(x, y)
  type(attribute_type), intent(in) :: x, y

  eq_att = x%name == y%name .and. &
    & x%dtype == y%dtype .and. &
    & x%len == y%len .and. &
    & all(x%buffer == y%buffer)
end function eq_att

module elemental logical function neq_att(x, y)
  type(attribute_type), intent(in) :: x, y

  neq_att = x%name /= y%name .or. &
    & x%dtype /= y%dtype .or. &
    & x%len /= y%len .or. &
    & any(x%buffer /= y%buffer)
end function neq_att

end submodule submodule_attribute
