submodule(nc4f_nc) nc4f_nc_dim
implicit none (type, external)
contains

!> Inquire all dimensions for the top-level group of a netCDF file.
module function inq_dims_grp(nc, err) result(dims)
  !> High-level `netcdf_type` representing the open file.
  class(group_type), intent(in) :: nc
  !> Optional error result. When absent, failures stop the program.
  type(error_type), intent(out), optional :: err
  !> Allocatable array of `dimension_type` in Fortran order.
  type(dimension_type), allocatable :: dims(:)
  type(error_type) :: op_err

  dims = inq_dims_(nc%id, err=op_err)
  if (present(err)) then
    err = op_err
  else if (handle_err(op_err)) then
    return
  end if
end function inq_dims_grp

!> Inquire the dimensions attached to a variable.
module function inq_dims_var(nc, var, err) result(dims)
  !> High-level `netcdf_type` for the file.
  class(group_type), intent(in) :: nc
  !> `variable_type` describing the variable.
  type(variable_type), intent(in) :: var
  !> Optional error result. When absent, failures stop the program.
  type(error_type), intent(out), optional :: err
  !> Allocatable array of `dimension_type` for that variable.
  type(dimension_type), allocatable :: dims(:)
  type(error_type) :: op_err

  dims = inq_dims_(nc%id, var%id, op_err)
  if (present(err)) then
    err = op_err
  else if (handle_err(op_err)) then
    return
  end if
end function inq_dims_var

!> Low-level helper to inquire dimensions from a netCDF `ncid` or an
!> optional `varid`.
function inq_dims_(ncid, varid, err) result(dims)
  !> C `ncid` for the dataset or group.
  integer(c_int), intent(in) :: ncid
  !> Optional C `varid` for a variable. If present, return that
  !> variable's dimensions.
  integer(c_int), optional, intent(in) :: varid
  !> Completed result of this operation.
  type(error_type), intent(out) :: err
  !> Allocatable array of `dimension_type` in Fortran ordering
  !> (reversed relative to the C API ordering).
  type(dimension_type), allocatable :: dims(:)
  integer(c_int), allocatable, target :: dimids(:), unlimdimids(:)
  character(len=NC_MAX_NAME + 1, kind=c_char) :: dim_name
  integer(c_int) :: i, j, nunlim, ndims, stat
  integer(c_int), parameter :: include_parents = 0_c_int

  err = error_type()
  if (present(varid)) then
    stat = nc_inq_varndims(ncid, varid, ndims)
    err = netcdf_err(stat, "[inq_dims] Variable rank.")
    if (has_err(err)) return
    allocate (dimids(ndims))
    if (ndims > 0) then
      stat = nc_inq_vardimid(ncid, varid, dimids)
      err = netcdf_err(stat, "[inq_dims] Variable dimensions.")
      if (has_err(err)) return
    end if
  else
    stat = nc_inq_dimids(ncid, ndims, c_null_ptr, include_parents)
    err = netcdf_err(stat, "[inq_dims] Dimension count.")
    if (has_err(err)) return
    allocate (dimids(ndims))
    if (ndims > 0) then
      stat = nc_inq_dimids(ncid, ndims, c_loc(dimids(1)), include_parents)
      err = netcdf_err(stat, "[inq_dims] Dimension identifiers.")
      if (has_err(err)) return
    end if
  end if
  stat = nc_inq_unlimdims(ncid, nunlim, c_null_ptr)
  err = netcdf_err(stat, "[inq_dims] Unlimited dimension count.")
  if (has_err(err)) return
  allocate (unlimdimids(nunlim))
  if (nunlim > 0) then
    stat = nc_inq_unlimdims(ncid, nunlim, c_loc(unlimdimids(1)))
    err = netcdf_err(stat, "[inq_dims] Unlimited dimension identifiers.")
    if (has_err(err)) return
  end if

  allocate (dims(ndims))

  !> Since this module uses the C API, the dimension order is reversed
  !> when read into a Fortran program.
  do i = 1, ndims
    j = ndims - i + 1
    dims(j)%id = dimids(i)
    stat = nc_inq_dimname(ncid, dimids(i), dim_name)
    err = netcdf_err(stat, "[inq_dims] Dimension name.")
    if (has_err(err)) return
    stat = nc_inq_dimlen(ncid, dimids(i), dims(j)%len)
    err = netcdf_err(stat, "[inq_dims] Dimension length.")
    if (has_err(err)) return
    dims(j)%name = clip(c2fstr(dim_name))
    dims(j)%is_unlim = any(dimids(i) == unlimdimids)
  end do
end function inq_dims_

!> Define a dimension, preserving `NC_EBADDIM` as the expected create path.
module function def_dim(nc, dim, err) result(new_dim)
  !> Input argument(s): `nc`.
  class(group_type), intent(in) :: nc
  !> Input argument(s): `dim`.
  type(dimension_type), intent(in) :: dim
  !> Output argument(s): `err`.
  type(error_type), intent(out) :: err
  !> Return value: `new_dim`.
  type(dimension_type) :: new_dim
  integer(c_int) :: stat, dimid
  integer(c_size_t) :: len
  character(len=:), allocatable :: context

  err = error_type()
  context = "[def_dim] Dimension: "//trim(dim%name)//"."
  stat = nc_inq_dimid(nc%id, f2cstr(dim%name), dimid)
  dimension_exists: if (stat == NC_NOERR) then
    new_dim = dimension_type(dimid, dim%name, dim%len, dim%is_unlim)
    return
  end if dimension_exists
  if (stat /= NC_EBADDIM) then
    err = netcdf_err(stat, context)
    return
  end if

  len = merge(NC_UNLIMITED, dim%len, dim%is_unlim)
  stat = nc_def_dim(nc%id, f2cstr(dim%name), len, dimid)
  err = netcdf_err(stat, context)
  if (has_err(err)) return
  new_dim = dimension_type(dimid, dim%name, dim%len, dim%is_unlim)
end function def_dim

end submodule nc4f_nc_dim
