submodule(nc4f_nc) nc4f_nc_var
implicit none (type, external)
contains

!> Read a variable's data from a netCDF dataset into a `variable_type`.
module impure elemental function get_var(nc, name, exist) result(var)
  !> High-level `netcdf_type` representing the open file.
  type(netcdf_type), intent(in) :: nc
  !> Name of the variable to read.
  character(len=*), intent(in) :: name
  !> Optional output flag set to true if the variable exists.
  logical, optional, intent(out) :: exist
  !> Variable object that will contain metadata and the data buffer.
  type(variable_type), target :: var
  !> C pointer to pass to the C API for reading raw data.
  type(c_ptr) :: cptr
  !> Temporary message buffer used for error reporting.
  character(len=MAX_CHAR_LEN) :: msg
  logical :: var_exist

  var = inq_var(nc, name, var_exist)
  if (present(exist)) then
    if (.not. var_exist) return
  else if (.not. var_exist) then
    error stop "[get_var] Variable "//name//"does not exist."
  end if

  zero_size_var: if (var%len == 0) then
    call validate_buffer(var, "[get_var]")
    if (allocated(var%buffer)) deallocate (var%buffer)
    return
  end if zero_size_var

  call allocate_memory(var)
  call validate_buffer(var, "[get_var]")
  cptr = c_loc(var%buffer(1))
  write (msg, "('[get_var] Invalid variable:', 1x, a)") name
  call handle_error(nc_get_var(nc%id, var%id, cptr), msg)
end function get_var

!> Inquire a variable's metadata without reading its data buffer.
module impure elemental function inq_var(nc, name, exist) result(var)
  !> High-level `netcdf_type` representing the open file.
  type(netcdf_type), intent(in) :: nc
  !> Name of the variable to inquire.
  character(len=*), intent(in) :: name
  !> Optional output flag set to true if the variable exists.
  logical, optional, intent(out) :: exist
  !> Variable object containing metadata (name, type, dims, atts, len).
  type(variable_type) :: var
  !> Internal flag set when attributes are present for the variable.
  logical :: atts_exist
  var%name = clip(name)
  var%id = inq_varid(nc%id, var%name, exist)
  if (.not. exist) return
  var%dtype = inq_vartype(nc%id, var%id)
  var%atts = get_atts_var(nc, var, atts_exist)
  if (.not. atts_exist .and. allocated(var%atts)) deallocate (var%atts)
  var%dims = inq_dims_var(nc, var)
  var%len = checked_dim_count(var%dims, "[inq_var]")
end function inq_var

!> Inquire the netCDF data type of a variable given `ncid` and `varid`.
impure elemental function inq_vartype(ncid, varid) result(vartype)
  !> C `ncid` for the dataset or group.
  integer(c_int), intent(in) :: ncid, varid
  !> Returned netCDF data type code (NC_* constant).
  integer(c_int) :: vartype
  !> Temporary message and format buffer used for error reporting.
  character(len=MAX_CHAR_LEN) :: msg, fmt

  fmt = "('[inq_vartype]', 2(1x, a, 1x, i0))"
  write (msg, fmt) "NCID", ncid, "VARID", varid
  call handle_error(nc_inq_vartype(ncid, varid, vartype), msg)
end function inq_vartype

!> Inquire the C `varid` for a variable name in a dataset.
impure elemental function inq_varid(ncid, name, exist) result(varid)
  !> C `ncid` for the dataset or group.
  integer(c_int), intent(in) :: ncid
  !> Name of the variable to lookup.
  character(len=*), intent(in) :: name
  !> Optional output flag set to true if the variable exists.
  logical, optional, intent(out) :: exist
  !> Returned C `varid` for the variable.
  integer(c_int) :: varid
  !> Status code returned by the C inquiry call.
  integer(c_int) :: stat
  !> Temporary message buffer used for error reporting.
  character(len=MAX_CHAR_LEN) :: msg

  stat = nc_inq_varid(ncid, f2cstr(name), varid)
  if (present(exist)) then
    exist = stat == NC_NOERR
    if (.not. exist) return
  end if

  write (msg, "('[inq_varid]', 1x, a)") name
  call handle_error(stat, msg)
end function inq_varid

!> Write a variable's data and metadata to a netCDF dataset.
module impure elemental subroutine put_var(nc, var)
  !> High-level `netcdf_type` representing the open file.
  type(netcdf_type), intent(in) :: nc
  !> Variable object containing metadata and a data buffer to write.
  type(variable_type), target, intent(in) :: var
  !> Temporary variable object used for definition and writing.
  type(variable_type) :: tmp

  call validate_buffer(var, "[put_var]")
  tmp = def_var_(nc, var)
  if (allocated(var%atts)) call put_att_var(nc, tmp)
  if (var%len > 0) &
    & call handle_error(nc_put_var(nc%id, tmp%id, c_loc(var%buffer(1))))
end subroutine put_var

!> Define a variable in the netCDF file and return its `variable_type`.
impure elemental function def_var_(nc, var) result(new_var)
  !> High-level `netcdf_type` representing the open file.
  type(netcdf_type), intent(in) :: nc
  !> Variable template describing the variable to define.
  type(variable_type), target, intent(in) :: var
  !> Returned `variable_type` representing the defined variable.
  type(variable_type) :: new_var
  !> Returned C `varid` assigned by the C API.
  integer(c_int) :: varid
  !> Array of C dimension ids used for the new variable (reversed order).
  integer(c_int), allocatable :: new_dimids(:)
  !> Array of `dimension_type` used to create the variable.
  type(dimension_type), allocatable :: new_dims(:)
  !> Number of dimensions and loop indices.
  integer :: n, i, j

  n = size(var%dims)
  allocate (new_dims(n), new_dimids(n))
  new_dims = def_dim(nc, var%dims)
  !> Reverse dimension since we use C APIs.
  do i = 1, n
    j = n - i + 1
    new_dimids(j) = new_dims(i)%id
  end do

  call handle_error(nc_def_var(nc%id, f2cstr(var%name), &
    & var%dtype, size(new_dims), new_dimids, varid))
  new_var%id = varid
  if (allocated(var%atts)) new_var%atts = var%atts
end function def_var_

end submodule nc4f_nc_var
