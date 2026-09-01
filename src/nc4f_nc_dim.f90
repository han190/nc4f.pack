submodule(nc4f_nc) nc4f_nc_dim
implicit none (type, external)
contains

!> Inquire all dimensions for the top-level group of a netCDF file.
module function inq_dims_nc(nc) result(dims)
  !> High-level `netcdf_type` representing the open file.
  type(netcdf_type), intent(in) :: nc
  !> Allocatable array of `dimension_type` in Fortran order.
  type(dimension_type), allocatable :: dims(:)

  dims = inq_dims_(nc%id)
end function inq_dims_nc

!> Inquire the dimensions attached to a variable.
module function inq_dims_var(nc, var) result(dims)
  !> High-level `netcdf_type` for the file.
  type(netcdf_type), intent(in) :: nc
  !> `variable_type` describing the variable.
  type(variable_type), intent(in) :: var
  !> Allocatable array of `dimension_type` for that variable.
  type(dimension_type), allocatable :: dims(:)

  dims = inq_dims_(nc%id, var%id)
end function inq_dims_var

!> Low-level helper to inquire dimensions from a netCDF `ncid` or an
!> optional `varid`.
function inq_dims_(ncid, varid) result(dims)
  !> C `ncid` for the dataset or group.
  integer(c_int), intent(in) :: ncid
  !> Optional C `varid` for a variable. If present, return that
  !> variable's dimensions.
  integer(c_int), optional, intent(in) :: varid
  !> Allocatable array of `dimension_type` in Fortran ordering
  !> (reversed relative to the C API ordering).
  type(dimension_type), allocatable :: dims(:)
  integer(c_int), allocatable, target :: dimids(:)
  character(len=NC_MAX_NAME + 1, kind=c_char) :: dim_name
  integer(c_int) :: i, j, unlimdimidp, nunlim, ndims
  integer(c_int), parameter :: include_parents = 0_c_int

  if (present(varid)) then
    call handle_error(nc_inq_varndims(ncid, varid, ndims))
    allocate (dimids(ndims))
    if (ndims > 0) &
      & call handle_error(nc_inq_vardimid(ncid, varid, dimids))
  else
    call handle_error(nc_inq_dimids( &
      & ncid, ndims, c_null_ptr, include_parents))
    allocate (dimids(ndims))
    if (ndims > 0) call handle_error(nc_inq_dimids( &
      & ncid, ndims, c_loc(dimids(1)), include_parents))
  end if
  call handle_error(nc_inq_unlimdim(ncid, unlimdimidp))

  if (.not. allocated(dims)) then
    allocate (dims(ndims))
  else if (size(dims) < ndims) then
    deallocate (dims)
    allocate (dims(ndims))
  end if

  !> Since this module uses the C API, the dimension order is reversed
  !> when read into a Fortran program.
  nunlim = 0
  do i = 1, ndims
    j = ndims - i + 1
    dims(j)%id = dimids(i)
    call handle_error(nc_inq_dimname(ncid, dimids(i), dim_name))
    call handle_error(nc_inq_dimlen(ncid, dimids(i), dims(j)%len))
    dims(j)%name = clip(c2fstr(dim_name))
    dims(j)%is_unlim = dimids(i) == unlimdimidp
    if (dims(j)%is_unlim) nunlim = nunlim + 1
  end do
  if (nunlim > 1) error stop &
    & "[inq_dims_] Too many unlimited dims."
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
  integer(c_int) :: stat, dimid
  integer(c_size_t) :: len

  stat = nc_inq_dimid(nc%id, f2cstr(dim%name), dimid)
  dimension_exists: if (stat == NC_NOERR) then
    new_dim = dimension_type(dimid, dim%name, &
      & dim%len, dim%is_unlim)
    return
  end if dimension_exists

  len = merge(NC_UNLIMITED, dim%len, dim%is_unlim)
  call handle_error(nc_def_dim( &
    & nc%id, f2cstr(dim%name), len, dimid), &
    & "[def_dim] Dimension: "//trim(dim%name)//".")
  new_dim = dimension_type(dimid, dim%name, dim%len, dim%is_unlim)
end function def_dim

end submodule nc4f_nc_dim
