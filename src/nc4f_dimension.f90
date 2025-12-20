submodule(nc4f) nc4f_dimension
implicit none (type, external)
contains

!> Construct a `dimension_argument_type` from a 64-bit length and a
!> logical indicating whether the dimension is unlimited.
module elemental function new_dim_arg_int64(len, is_unlim) result(arg)
  !> Length of the dimension (int64).
  integer(int64), intent(in) :: len
  !> True if the dimension is unlimited.
  logical, intent(in) :: is_unlim
  !> A dimension argument.
  type(dimension_argument_type) :: arg

  arg%len = len
  arg%is_unlim = is_unlim
end function new_dim_arg_int64

!> Construct a `dimension_argument_type` from a 32-bit length and a
!> logical indicating whether the dimension is unlimited.
module elemental function new_dim_arg_int32(len, is_unlim) result(arg)
  !> Length of the dimension (int32).
  integer(int32), intent(in) :: len
  !> True if the dimension is unlimited.
  logical, intent(in) :: is_unlim
  !> A dimension argument.
  type(dimension_argument_type) :: arg

  arg%len = len
  arg%is_unlim = is_unlim
end function new_dim_arg_int32

!> Create a `dimension_type` given a name and a 64-bit length.
module elemental function new_dim_len_int64(name, len) result(dim)
  !> Dimension name (will be trimmed).
  character(len=*), intent(in) :: name
  !> Length of the dimension (int64).
  integer(int64), intent(in) :: len
  !> Result dimension.
  type(dimension_type) :: dim

  dim%name = trim(adjustl(name))
  dim%len = len
  dim%is_unlim = .false.
end function new_dim_len_int64

!> Create a `dimension_type` given a name and a 32-bit length.
module elemental function new_dim_len_int32(name, len) result(dim)
  !> Dimension name (will be trimmed).
  character(len=*), intent(in) :: name
  !> Length of the dimension (int32).
  integer(int32), intent(in) :: len
  !> Result dimension.
  type(dimension_type) :: dim

  dim%name = trim(adjustl(name))
  dim%len = len
  dim%is_unlim = .false.
end function new_dim_len_int32

!> Create a `dimension_type` from a name and a `dimension_argument_type`.
module elemental function new_dim_args(name, args) result(dim)
  !> Dimension name.
  character(len=*), intent(in) :: name
  !> `dimension_argument_type` containing length and unlimited flag.
  type(dimension_argument_type), intent(in) :: args
  type(dimension_type) :: dim

  dim%name = trim(adjustl(name))
  dim%len = args%len
  dim%is_unlim = args%is_unlim
end function new_dim_args

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
  integer(c_int) :: dimids(NC_MAX_DIMS)
  character(len=NC_MAX_NAME, kind=c_char) :: dim_name
  integer(c_int) :: i, j, unlimdimidp, nunlim, ndims
  integer(c_int), parameter :: include_parents = 0_c_int

  if (present(varid)) then
    call handle_error(nc_inq_vardimid(ncid, varid, dimids))
    call handle_error(nc_inq_varndims(ncid, varid, ndims))
  else
    call handle_error(nc_inq_dimids( &
      & ncid, ndims, dimids, include_parents))
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
    dims(j)%name = trim(adjustl(c2fstr(dim_name)))
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
    & nc%id, f2cstr(dim%name), dim%len, dimid), &
    & "[def_dim] Dimension: "//trim(dim%name)//".")
  new_dim = dimension_type(dimid, dim%name, dim%len, dim%is_unlim)
end function def_dim

!> Compare two `dimension_type` values for equality (name, length, and
!> unlimited flag).
module elemental logical function eq_dim(x, y)
  !> Left-hand `dimension_type` to compare.
  type(dimension_type), intent(in) :: x
  !> Right-hand `dimension_type` to compare.
  type(dimension_type), intent(in) :: y

  eq_dim = (x%is_unlim .eqv. y%is_unlim) .and. &
    & (x%len == y%len) .and. (x%name == y%name)
end function eq_dim

!> Test whether two `dimension_type` values are different.
module elemental logical function neq_dim(x, y)
  !> Left-hand `dimension_type` to compare.
  type(dimension_type), intent(in) :: x
  !> Right-hand `dimension_type` to compare.
  type(dimension_type), intent(in) :: y

  neq_dim = (x%is_unlim .neqv. y%is_unlim) .or. &
    & (x%len /= y%len) .or. (x%name /= y%name)
end function neq_dim

end submodule nc4f_dimension
