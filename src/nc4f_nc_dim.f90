submodule(nc4f_nc) nc4f_nc_dim
implicit none (type, external)
contains

!> Inquire all dimensions for the top-level group of a netCDF file.
module function inq_dims_nc(nc, error) result(dims)
  !> High-level `netcdf_type` representing the open file.
  type(netcdf_type), intent(in) :: nc
  !> Optional error result. When absent, failures stop the program.
  type(error_type), intent(out), optional :: error
  !> Allocatable array of `dimension_type` in Fortran order.
  type(dimension_type), allocatable :: dims(:)
  type(error_type) :: operation_error

  dims = inq_dims_(nc%id, error=operation_error)
  if (present(error)) then
    error = operation_error
  else if (handle_error(operation_error)) then
    return
  end if
end function inq_dims_nc

!> Inquire the dimensions attached to a variable.
module function inq_dims_var(nc, var, error) result(dims)
  !> High-level `netcdf_type` for the file.
  type(netcdf_type), intent(in) :: nc
  !> `variable_type` describing the variable.
  type(variable_type), intent(in) :: var
  !> Optional error result. When absent, failures stop the program.
  type(error_type), intent(out), optional :: error
  !> Allocatable array of `dimension_type` for that variable.
  type(dimension_type), allocatable :: dims(:)
  type(error_type) :: operation_error

  dims = inq_dims_(nc%id, var%id, operation_error)
  if (present(error)) then
    error = operation_error
  else if (handle_error(operation_error)) then
    return
  end if
end function inq_dims_var

!> Low-level helper to inquire dimensions from a netCDF `ncid` or an
!> optional `varid`.
function inq_dims_(ncid, varid, error) result(dims)
  !> C `ncid` for the dataset or group.
  integer(c_int), intent(in) :: ncid
  !> Optional C `varid` for a variable. If present, return that
  !> variable's dimensions.
  integer(c_int), optional, intent(in) :: varid
  !> Completed result of this operation.
  type(error_type), intent(out) :: error
  !> Allocatable array of `dimension_type` in Fortran ordering
  !> (reversed relative to the C API ordering).
  type(dimension_type), allocatable :: dims(:)
  integer(c_int), allocatable, target :: dimids(:)
  character(len=NC_MAX_NAME + 1, kind=c_char) :: dim_name
  integer(c_int) :: i, j, unlimdimidp, nunlim, ndims, stat
  integer(c_int), parameter :: include_parents = 0_c_int

  error = error_type()
  if (present(varid)) then
    stat = nc_inq_varndims(ncid, varid, ndims)
    error = make_netcdf_error(stat, "[inq_dims] Variable rank.")
    if (is_failed(error)) return
    allocate (dimids(ndims))
    if (ndims > 0) then
      stat = nc_inq_vardimid(ncid, varid, dimids)
      error = make_netcdf_error(stat, "[inq_dims] Variable dimensions.")
      if (is_failed(error)) return
    end if
  else
    stat = nc_inq_dimids(ncid, ndims, c_null_ptr, include_parents)
    error = make_netcdf_error(stat, "[inq_dims] Dimension count.")
    if (is_failed(error)) return
    allocate (dimids(ndims))
    if (ndims > 0) then
      stat = nc_inq_dimids(ncid, ndims, c_loc(dimids(1)), include_parents)
      error = make_netcdf_error(stat, "[inq_dims] Dimension identifiers.")
      if (is_failed(error)) return
    end if
  end if
  stat = nc_inq_unlimdim(ncid, unlimdimidp)
  error = make_netcdf_error(stat, "[inq_dims] Unlimited dimension.")
  if (is_failed(error)) return

  allocate (dims(ndims))

  !> Since this module uses the C API, the dimension order is reversed
  !> when read into a Fortran program.
  nunlim = 0
  do i = 1, ndims
    j = ndims - i + 1
    dims(j)%id = dimids(i)
    stat = nc_inq_dimname(ncid, dimids(i), dim_name)
    error = make_netcdf_error(stat, "[inq_dims] Dimension name.")
    if (is_failed(error)) return
    stat = nc_inq_dimlen(ncid, dimids(i), dims(j)%len)
    error = make_netcdf_error(stat, "[inq_dims] Dimension length.")
    if (is_failed(error)) return
    dims(j)%name = clip(c2fstr(dim_name))
    dims(j)%is_unlim = dimids(i) == unlimdimidp
    if (dims(j)%is_unlim) nunlim = nunlim + 1
  end do
  if (nunlim > 1) then
    error = error_type(NC_EINVAL, "[inq_dims] Too many unlimited dimensions.")
    return
  end if
end function inq_dims_

!> Define a dimension in the netCDF file if it does not already exist.
module impure elemental function def_dim(nc, dim) result(new_dim)
  !> High-level `netcdf_type` for the file.
  type(netcdf_type), intent(in) :: nc
  !> `dimension_type` describing the desired dimension (name, len,
  !> is_unlim).
  type(dimension_type), intent(in) :: dim
  !> The `dimension_type` of the existing or newly-created dimension
  !> (including the assigned `id`). This routine is `impure` because it
  !> may modify the underlying file state.
  type(dimension_type) :: new_dim
  type(error_type) :: error

  new_dim = def_dim_(nc, dim, error)
  if (handle_error(error)) return
end function def_dim

!> Define a dimension without stopping on a NetCDF failure.
module function def_dim_error(nc, dim, error) result(new_dim)
  type(netcdf_type), intent(in) :: nc
  type(dimension_type), intent(in) :: dim
  type(error_type), intent(out) :: error
  type(dimension_type) :: new_dim

  new_dim = def_dim_(nc, dim, error)
end function def_dim_error

!> Define a dimension, preserving `NC_EBADDIM` as the expected create path.
function def_dim_(nc, dim, error) result(new_dim)
  type(netcdf_type), intent(in) :: nc
  type(dimension_type), intent(in) :: dim
  type(error_type), intent(out) :: error
  type(dimension_type) :: new_dim
  integer(c_int) :: stat, dimid
  integer(c_size_t) :: len
  character(len=:), allocatable :: context

  error = error_type()
  context = "[def_dim] Dimension: "//trim(dim%name)//"."
  stat = nc_inq_dimid(nc%id, f2cstr(dim%name), dimid)
  dimension_exists: if (stat == NC_NOERR) then
    new_dim = dimension_type(dimid, dim%name, dim%len, dim%is_unlim)
    return
  end if dimension_exists
  if (stat /= NC_EBADDIM) then
    error = make_netcdf_error(stat, context)
    return
  end if

  len = merge(NC_UNLIMITED, dim%len, dim%is_unlim)
  stat = nc_def_dim(nc%id, f2cstr(dim%name), len, dimid)
  error = make_netcdf_error(stat, context)
  if (is_failed(error)) return
  new_dim = dimension_type(dimid, dim%name, dim%len, dim%is_unlim)
end function def_dim_

end submodule nc4f_nc_dim
