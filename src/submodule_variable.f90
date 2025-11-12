submodule(module_netcdf) submodule_variable
implicit none (type, external)
contains

module impure elemental function get_var(nc, name, exist) result(var)
  type(netcdf_type), intent(in) :: nc
  character(len=*), intent(in) :: name
  logical, intent(out), optional :: exist
  type(variable_type) :: var

  var = get_var_(nc%id, name, exist)
end function get_var

impure elemental function get_var_(ncid, name, exist) result(var)
  integer(c_int), intent(in) :: ncid
  character(len=*), intent(in) :: name
  logical, intent(out) :: exist
  type(variable_type), target :: var

  var = inq_var_(ncid, name, exist)
  zero_size_var: if (var%len == 0) then
    if (allocated(var%buffer)) deallocate (var%buffer)
    return
  end if zero_size_var

  call allocate_buffer(var)
  call handle_error(nc_get_var(ncid, var%id, c_loc(var%buffer(1))), &
    & "[get_var_] Invalid variable.")
end function get_var_

module impure elemental function inq_var(nc, name, exist) result(var)
  type(netcdf_type), intent(in) :: nc
  character(len=*), intent(in) :: name
  logical, intent(out), optional :: exist
  type(variable_type) :: var

  var = inq_var_(nc%id, name, exist)
end function inq_var

impure elemental function inq_var_(ncid, name, exist) result(var)
  integer(c_int), intent(in) :: ncid
  character(len=*), intent(in) :: name
  logical, intent(out), optional :: exist
  type(variable_type) :: var
  integer(c_int) :: stat
  integer :: i
  logical :: atts_exist

  var%name = trim(adjustl(name))
  stat = nc_inq_varid(ncid, f2cstr(var%name), var%id)
  if (present(exist)) then
    exist = stat == NC_NOERR
    if (.not. exist) return
  end if
  call handle_error(stat)

  call handle_error(nc_inq_vartype(ncid, var%id, var%dtype))
  var%atts = get_atts_(ncid, var%id, atts_exist)
  if (.not. atts_exist .and. allocated(var%atts)) deallocate(var%atts)
  var%dims = inq_dims_(ncid, var%id)
  var%len = 1
  do i = 1, size(var%dims)
    var%len = var%len*var%dims(i)%len
  end do
end function inq_var_

module impure elemental subroutine put_var(nc, var)
  type(netcdf_type), intent(in) :: nc
  type(variable_type), target, intent(in) :: var
  type(variable_type) :: tmp

  tmp = def_var_(nc, var)
  if (allocated(var%atts)) call put_att_var(nc, tmp)
  call handle_error(nc_put_var(nc%id, tmp%id, c_loc(var%buffer(1))))
end subroutine put_var

impure elemental function def_var_(nc, var) result(new_var)
  type(netcdf_type), intent(in) :: nc
  type(variable_type), target, intent(in) :: var
  type(variable_type) :: new_var
  integer(c_int) :: varid
  integer(c_int), allocatable :: new_dimids(:)
  type(dimension_type), allocatable :: new_dims(:)
  integer :: n, i, j

  n = size(var%dims)
  allocate (new_dims(n), new_dimids(n))
  new_dims = define_dimension(nc, var%dims)
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

pure module function get_size(var, dim) result(n)
  type(variable_type), intent(in) :: var
  integer, intent(in), optional :: dim
  integer(int64) :: n
  integer :: dim_, i

  if (.not. allocated(var%dims)) &
    & error stop "[get_size] Invalid dims."

  if (present(dim)) then
    dim_ = dim
  else
    dim_ = 0
  end if

  n = 1
  select case (dim_)
  case (0)
    do i = 1, size(var%dims)
      n = n*var%dims(i)%len
    end do
  case (1:)
    i = size(var%dims) - dim_ + 1
    n = var%dims(i)%len
  case default
    error stop "[get_size] Invalid dim."
  end select
end function get_size

pure module function get_shape(var) result(n)
  type(variable_type), intent(in) :: var
  integer(int64), allocatable :: n(:)
  integer :: ndims, i

  if (.not. allocated(var%dims)) &
    & error stop "[get_size] Invalid dims."
  ndims = size(var%dims)
  if (.not. allocated(n)) then
    allocate (n(ndims))
  else if (size(n) /= ndims) then
    deallocate (n)
    allocate (n(ndims))
  end if

  do i = 1, ndims
    n(i) = var%dims(i)%len
  end do
end function get_shape

pure module subroutine allocate_buffer_var(var)
  type(variable_type), intent(inout) :: var
  integer(int64) :: buffer_size

  !> Assuming var%dtype and var%len is properly initialized.
  buffer_size = get_buffer_size(var%dtype, var%len)
  if (allocation_required(var%buffer, buffer_size)) then
    if (allocated(var%buffer)) deallocate (var%buffer)
    allocate (var%buffer(buffer_size))
  end if
end subroutine allocate_buffer_var

end submodule submodule_variable
