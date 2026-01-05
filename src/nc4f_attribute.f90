submodule(nc4f) nc4f_attribute
implicit none (type, external)
contains

!> Read a global attribute by name and return it.
module impure elemental function get_att_nc(nc, name) result(att)
  !> High-level `netcdf_type` representing the open file.
  type(netcdf_type), intent(in) :: nc
  !> Name of the global attribute to read.
  character(len=*), intent(in) :: name
  !> Returned attribute object.
  type(attribute_type) :: att

  att = get_att_(nc%id, NC_GLOBAL, f2cstr(clip(name)))
end function get_att_nc

!> Return all global attributes for a dataset.
module function get_atts_nc(nc, exist) result(atts)
  !> High-level `netcdf_type` representing the open file.
  type(netcdf_type), intent(in) :: nc
  !> Optional output flag set to true when attributes exist.
  logical, optional, intent(out) :: exist
  !> Allocatable array of attributes for the dataset.
  type(attribute_type), allocatable :: atts(:)

  atts = get_atts_(nc%id, NC_GLOBAL, exist)
end function get_atts_nc

!> Read a named attribute attached to a variable and return it.
module function get_att_var(nc, var, name) result(att)
  !> High-level `netcdf_type` representing the open file.
  type(netcdf_type), intent(in) :: nc
  !> Variable whose attribute will be read.
  type(variable_type), intent(in) :: var
  !> Name of the attribute to read.
  character(len=*), intent(in) :: name
  !> Returned attribute object.
  type(attribute_type) :: att

  att = get_att_(nc%id, var%id, name)
end function get_att_var

!> Return all attributes attached to a variable.
module function get_atts_var(nc, var, exist) result(atts)
  !> High-level `netcdf_type` representing the open file.
  type(netcdf_type), intent(in) :: nc
  !> Variable whose attributes will be returned.
  type(variable_type), intent(in) :: var
  !> Optional output flag set to true when attributes exist.
  logical, optional, intent(out) :: exist
  !> Allocatable array of attributes for the variable.
  type(attribute_type), allocatable :: atts(:)

  atts = get_atts_(nc%id, var%id, exist)
end function get_atts_var

!> Helper that returns attributes for a C `ncid` and `varid`.
function get_atts_(ncid, varid, exist) result(atts)
  !> C `ncid` for the dataset or group.
  integer(c_int), intent(in) :: ncid
  !> C `varid` for the variable or `NC_GLOBAL` for dataset attributes.
  integer(c_int), intent(in) :: varid
  !> Optional output flag set to true when attributes exist.
  logical, optional, intent(out) :: exist
  !> Allocatable array of attributes returned by this helper.
  type(attribute_type), allocatable :: atts(:)
  !> Number of attributes returned by the C API.
  integer(c_int) :: natts
  !> Loop index for attribute enumeration.
  integer(c_int) :: i
  !> Temporary C-style name buffer for attribute names.
  character(kind=c_char, len=MAX_CHAR_LEN) :: name
  !> Status code returned by C inquiries.
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

  !> For the NetCDF C library, attribute IDs start from 0.
  do i = 0, natts - 1
    call handle_error(nc_inq_attname(ncid, varid, i, name))
    atts(i + 1) = get_att_(ncid, varid, c2fstr(name))
  end do
end function get_atts_

!> Helper that reads a single attribute given C `ncid`, `varid` and name.
impure elemental function get_att_(ncid, varid, name) result(att)
  !> C `ncid` for the dataset or group.
  integer(c_int), intent(in) :: ncid
  !> C `varid` for the variable or `NC_GLOBAL` for dataset attributes.
  integer(c_int), intent(in) :: varid
  !> Attribute name to read.
  character(len=*), intent(in) :: name
  !> Returned attribute object. This is `target` so its buffer can be
  !> associated with C calls.
  type(attribute_type), target :: att
  !> Attribute data type returned by the C inquiry.
  integer(c_int) :: dtype
  !> Length (number of elements) of the attribute returned by the C API.
  integer(c_size_t) :: len

  att%name = clip(name)
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

!> Write all attributes of a variable to the dataset.
module impure elemental subroutine put_att_var(nc, var)
  !> High-level `netcdf_type` representing the open file.
  type(netcdf_type), intent(in) :: nc
  !> Variable whose attributes will be written to the file.
  type(variable_type), target, intent(in) :: var
  !> Loop index for iterating attributes.
  integer :: i

  do i = 1, size(var%atts)
    associate (att => var%atts(i))
      call handle_error(nc_put_att(nc%id, var%id, f2cstr(att%name), &
        & att%dtype, att%len, c_loc(att%buffer(1))), &
        & "[put_att_] Invalid attribute.")
    end associate
  end do
end subroutine put_att_var

!> Write all global attributes of the dataset to the file.
module impure elemental subroutine put_att_nc(nc)
  !> High-level `netcdf_type` representing the open file.
  type(netcdf_type), target, intent(in) :: nc
  !> Loop index for iterating dataset attributes.
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

!> Initialize `att` from an attribute mold, allocating its buffer.
module pure subroutine allocate_att_mold(att, mold)
  !> Attribute to allocate and initialize.
  type(attribute_type), intent(inout) :: att
  !> Mold attribute providing metadata to copy.
  type(attribute_type), intent(in) :: mold

  call allocate_att_meta(att, mold%name, mold%dtype, mold%len)
end subroutine allocate_att_mold

!> Initialize attribute metadata and allocate its buffer.
module pure subroutine allocate_att_meta(att, name, dtype, len)
  !> Attribute to initialize.
  type(attribute_type), intent(inout) :: att
  !> Name to assign to the attribute.
  character(len=*), intent(in) :: name
  !> NetCDF data type code (NC_* constant) for the attribute.
  integer(int32), intent(in) :: dtype
  !> Number of elements for the attribute.
  integer(int64), intent(in) :: len

  att%name = name
  att%dtype = dtype
  att%len = len
  call allocate_buffer_att(att)
end subroutine allocate_att_meta

!> Allocate or resize the attribute's data buffer based on its type.
module pure subroutine allocate_buffer_att(att)
  !> Attribute whose buffer will be allocated or resized.
  type(attribute_type), intent(inout) :: att
  !> Calculated buffer size in bytes.
  integer(int64) :: buffer_size

  !> Assume that `att%dtype` and `att%len` are properly initialized.
  buffer_size = get_buffer_size(att%dtype, att%len)
  if (allocation_required(att%buffer, buffer_size)) then
    if (allocated(att%buffer)) deallocate (att%buffer)
    allocate (att%buffer(buffer_size))
  end if
end subroutine allocate_buffer_att

!> Return true when two `attribute_type` values are identical.
module elemental logical function eq_att(x, y) result(res)
  !> Left-hand attribute to compare.
  type(attribute_type), intent(in) :: x
  !> Right-hand attribute to compare.
  type(attribute_type), intent(in) :: y

  res = x%name == y%name .and. x%dtype == y%dtype .and. &
    & x%len == y%len .and. all(x%buffer == y%buffer)
end function eq_att

!> Return true when two `attribute_type` values differ.
module elemental logical function neq_att(x, y) result(resn)
  !> Left-hand attribute to compare.
  type(attribute_type), intent(in) :: x
  !> Right-hand attribute to compare.
  type(attribute_type), intent(in) :: y

  resn = x%name /= y%name .or. x%dtype /= y%dtype .or. &
    & x%len /= y%len .or. any(x%buffer /= y%buffer)
end function neq_att

end submodule nc4f_attribute
