submodule(module_netcdf) submodule_variable
implicit none
integer(int8), parameter :: BYTE = 0_int8
contains

module function new_variable_real32(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  real(real32), intent(in) :: values(:)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type) :: var
  integer(int64) :: buffer_size

  if (size(values) == 0) error stop &
    & "[new_variable_real32] Invalid values."  
  var%name = name
  var%data_type = NC_FLOAT
  var%length = size(values, kind=int64)
  var%buffer = transfer(values, BYTE, &
    & get_buffer_size(var%data_type, var%length))
  var%dimensions = dims
  if (present(atts)) var%attributes = atts
end function new_variable_real32

module function new_variable_int32(name, values, dims, atts) result(var)
  character(len=*), intent(in) :: name
  integer(int32), intent(in) :: values(:)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(variable_type) :: var
  integer(int64) :: buffer_size

  if (size(values) == 0) error stop &
    & "[new_variable_int32] Invalid values."  
  var%name = name
  var%data_type = NC_INT
  var%length = size(values, kind=int64)
  var%buffer = transfer(values, BYTE, &
    & get_buffer_size(var%data_type, var%length))
  var%dimensions = dims
  if (present(atts)) var%attributes = atts
end function new_variable_int32

module impure elemental function get_variable(nc, name, exist) result(var)
  type(netcdf_type), intent(in) :: nc
  character(len=*), intent(in) :: name
  logical, intent(out), optional :: exist
  type(variable_type) :: var

  var = get_variable_(nc%id, name, exist)
end function get_variable

impure elemental function get_variable_(ncid, name, exist) result(var)
  integer(c_int), intent(in) :: ncid
  character(len=*), intent(in) :: name
  logical, intent(out) :: exist
  type(variable_type), target :: var
  integer(int64) :: buffer_size

  var = inquire_variable_(ncid, name, exist)
  zero_size_var: if (var%length == 0) then
    if (allocated(var%buffer)) deallocate (var%buffer)
    return
  end if zero_size_var

  buffer_size = get_buffer_size(var%data_type, var%length)
  if (reallocation_required(var%buffer, buffer_size)) &
    & allocate (var%buffer(buffer_size))
  call handle_error(nc_get_var(ncid, var%id, c_loc(var%buffer(1))), &
    & "[get_variable_] Invalid variable.")
end function get_variable_

module impure elemental function inquire_variable(nc, name, exist) result(var)
  type(netcdf_type), intent(in) :: nc
  character(len=*), intent(in) :: name
  logical, intent(out), optional :: exist
  type(variable_type) :: var

  var = inquire_variable_(nc%id, name, exist)
end function inquire_variable

impure elemental function inquire_variable_(ncid, name, exist) result(var)
  integer(c_int), intent(in) :: ncid
  character(len=*), intent(in) :: name
  logical, intent(out), optional :: exist
  type(variable_type) :: var
  integer(c_int) :: stat
  integer :: i

  var%name = trim(adjustl(name))
  stat = nc_inq_varid(ncid, f2cstr(var%name), var%id)
  if (present(exist)) then
    exist = stat == NC_NOERR
    if (.not. exist) return
  else
    call handle_error(stat)
  end if

  call handle_error(nc_inq_vartype(ncid, var%id, var%data_type))
  var%attributes = get_attributes_(ncid, var%id)
  var%dimensions = inquire_dimensions_(ncid, var%id)
  var%length = 1
  do i = 1, size(var%dimensions)
    var%length = var%length * var%dimensions(i)%length
  end do
end function inquire_variable_

module impure elemental subroutine put_variable(nc, var)
  type(netcdf_type), intent(in) :: nc
  type(variable_type), target, intent(in) :: var
  type(variable_type) :: tmp

  tmp = define_variable(nc, var)
  call put_attribute_variable(nc, tmp)
  call handle_error(nc_put_var(nc%id, tmp%id, c_loc(var%buffer(1))))
end subroutine put_variable

impure elemental function define_variable(nc, var) result(new_var)
  type(netcdf_type), intent(in) :: nc
  type(variable_type), target, intent(in) :: var
  type(variable_type) :: new_var
  integer(c_int) :: varid
  integer(c_int), allocatable :: new_dimids(:)
  type(dimension_type), allocatable :: new_dims(:)
  integer :: n, i

  n = size(var%dimensions)
  allocate (new_dims(n), new_dimids(n))
  new_dims = define_dimension(nc, var%dimensions)
  do i = 1, n
    new_dimids(i) = new_dims(i)%id
  end do

  call handle_error(nc_def_var(nc%id, f2cstr(var%name), &
    & var%data_type, size(new_dims), new_dimids, varid))

  !> Since we only need variable ID and attributes,
  !> we only copy these two.
  new_var%attributes = var%attributes
  new_var%id = varid
end function define_variable

pure module function get_size(var, dim) result(n)
  type(variable_type), intent(in) :: var
  integer, intent(in), optional :: dim
  integer(int64) :: n
  integer :: dim_, i

  if (.not. allocated(var%dimensions)) &
    & error stop "[get_size] Invalid dimensions."

  if (present(dim)) then
    dim_ = dim
  else
    dim_ = 0
  end if

  n = 1
  select case (dim_)
  case (0)
    do i = 1, size(var%dimensions)
      n = n * var%dimensions(i)%length
    end do
  case (1:)
    i = size(var%dimensions) - dim_ + 1
    n = var%dimensions(i)%length
  case default
    error stop "[get_size] Invalid dim."
  end select
end function get_size

pure module function get_shape(var) result(n)
  type(variable_type), intent(in) :: var
  integer(int64), allocatable :: n(:)
  integer :: ndims, i

  if (.not. allocated(var%dimensions)) &
    & error stop "[get_size] Invalid dimensions."
  ndims = size(var%dimensions)
  if (.not. allocated(n)) then
    allocate (n(ndims))
  else if (size(n) /= ndims) then
    deallocate (n)
    allocate (n(ndims))
  end if

  do i = 1, ndims
    n(ndims - i + 1) = var%dimensions(i)%length
  end do
end function get_shape

end submodule submodule_variable