submodule(module_netcdf) submodule_dimension
implicit none (type, external)
contains

module elemental function new_dim_arg_int64(len, is_unlim) result(arg)
  integer(int64), intent(in) :: len
  logical, intent(in) :: is_unlim
  type(dimension_argument_type) :: arg

  arg%len = len
  arg%is_unlim = is_unlim
end function new_dim_arg_int64

module elemental function new_dim_arg_int32(len, is_unlim) result(arg)
  integer(int32), intent(in) :: len
  logical, intent(in) :: is_unlim
  type(dimension_argument_type) :: arg

  arg%len = len
  arg%is_unlim = is_unlim
end function new_dim_arg_int32

module elemental function new_dim_len_int64(name, len) result(dim)
  character(len=*), intent(in) :: name
  integer(int64), intent(in) :: len
  type(dimension_type) :: dim

  dim%name = trim(adjustl(name))
  dim%len = len
  dim%is_unlim = .false.
end function new_dim_len_int64

module elemental function new_dim_len_int32(name, len) result(dim)
  character(len=*), intent(in) :: name
  integer(int32), intent(in) :: len
  type(dimension_type) :: dim

  dim%name = trim(adjustl(name))
  dim%len = len
  dim%is_unlim = .false.
end function new_dim_len_int32

module elemental function new_dim_args(name, args) result(dim)
  character(len=*), intent(in) :: name
  type(dimension_argument_type), intent(in) :: args
  type(dimension_type) :: dim

  dim%name = trim(adjustl(name))
  dim%len = args%len
  dim%is_unlim = args%is_unlim
end function new_dim_args

module function inq_dims_nc(nc) result(dims)
  type(netcdf_type), intent(in) :: nc
  type(dimension_type), allocatable :: dims(:)

  dims = inq_dims_(nc%id)
end function inq_dims_nc

module function inq_dims_(ncid, varid) result(dims)
  integer(c_int), intent(in) :: ncid
  integer(c_int), intent(in), optional :: varid
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

  !> Since we use C APIs, the dimension order should
  !> be reversed when read into a Fortran program.
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

impure elemental module function define_dimension(nc, dim) result(new_dim)
  type(netcdf_type), intent(in) :: nc
  type(dimension_type), intent(in) :: dim
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
    & "[define_dimension] Dimension: "//trim(dim%name)//".")
  new_dim = dimension_type(dimid, dim%name, dim%len, dim%is_unlim)
end function define_dimension

elemental module logical function equal_dimension(x, y)
  type(dimension_type), intent(in) :: x, y

  equal_dimension = x%is_unlim .eqv. y%is_unlim .and. &
    & x%len == y%len .and. x%name == y%name
end function equal_dimension

elemental module logical function unequal_dimension(x, y)
  type(dimension_type), intent(in) :: x, y

  unequal_dimension = x%is_unlim .neqv. y%is_unlim .or. &
    & x%len /= y%len .or. x%name /= y%name
end function unequal_dimension

end submodule submodule_dimension
