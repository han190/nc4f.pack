submodule(module_netcdf) submodule_dimension
implicit none
contains

module elemental function new_dimension_argument_int64(length, is_unlimited) result(arg)
  integer(int64), intent(in) :: length
  logical, intent(in) :: is_unlimited
  type(dimension_argument_type) :: arg

  arg%length = length
  arg%is_unlimited = is_unlimited
end function new_dimension_argument_int64

module elemental function new_dimension_argument_int32(length, is_unlimited) result(arg)
  integer(int32), intent(in) :: length
  logical, intent(in) :: is_unlimited
  type(dimension_argument_type) :: arg

  arg%length = length
  arg%is_unlimited = is_unlimited
end function new_dimension_argument_int32

module elemental function new_dimension_length_int64(name, length) result(dim)
  character(len=*), intent(in) :: name
  integer(int64), intent(in) :: length
  type(dimension_type) :: dim

  dim%name = trim(adjustl(name))
  dim%length = length
  dim%is_unlimited = .false.
end function new_dimension_length_int64

module elemental function new_dimension_length_int32(name, length) result(dim)
  character(len=*), intent(in) :: name
  integer(int32), intent(in) :: length
  type(dimension_type) :: dim

  dim%name = trim(adjustl(name))
  dim%length = length
  dim%is_unlimited = .false.
end function new_dimension_length_int32

module elemental function new_dimension_arguments(name, args) result(dim)
  character(len=*), intent(in) :: name
  type(dimension_argument_type), intent(in) :: args
  type(dimension_type) :: dim

  dim%name = trim(adjustl(name))
  dim%length = args%length
  dim%is_unlimited = args%is_unlimited
end function new_dimension_arguments

module function inquire_dimensions_global(nc) result(dims)
  type(netcdf_type), intent(in) :: nc
  type(dimension_type), allocatable :: dims(:)

  dims = inquire_dimensions_(nc%id)
end function inquire_dimensions_global

module function inquire_dimensions_(ncid, varid) result(dims)
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
    call handle_error(nc_inq_dimlen(ncid, dimids(i), dims(j)%length))
    dims(j)%name = trim(adjustl(c2fstr(dim_name)))
    dims(j)%is_unlimited = dimids(i) == unlimdimidp
    if (dims(j)%is_unlimited) nunlim = nunlim + 1
  end do
  if (nunlim > 1) error stop &
    & "[inquire_dimensions_] Too many unlimited dimensions."
end function inquire_dimensions_

impure elemental module function define_dimension(nc, dim) result(new_dim)
  type(netcdf_type), intent(in) :: nc
  type(dimension_type), intent(in) :: dim
  type(dimension_type) :: new_dim
  integer(c_int) :: stat, dimid
  integer(c_size_t) :: length

  stat = nc_inq_dimid(nc%id, f2cstr(dim%name), dimid)
  dimension_exists: if (stat == NC_NOERR) then
    new_dim = dimension_type(dimid, dim%name, &
      & dim%length, dim%is_unlimited)
    return
  end if dimension_exists

  length = merge(NC_UNLIMITED, dim%length, dim%is_unlimited)
  call handle_error(nc_def_dim( &
    & nc%id, f2cstr(dim%name), dim%length, dimid), &
    & "[define_dimension] Dimension: "//trim(dim%name)//".")
  new_dim = dimension_type(dimid, dim%name, dim%length, dim%is_unlimited)
end function define_dimension

elemental module logical function equal_dimension(x, y)
  type(dimension_type), intent(in) :: x, y

  equal_dimension = x%is_unlimited .eqv. y%is_unlimited .and. &
    & x%length == y%length .and. x%name == y%name
end function equal_dimension

elemental module logical function unequal_dimension(x, y)
  type(dimension_type), intent(in) :: x, y

  unequal_dimension = x%is_unlimited .neqv. y%is_unlimited .or. &
    & x%length /= y%length .or. x%name /= y%name
end function unequal_dimension

end submodule submodule_dimension
