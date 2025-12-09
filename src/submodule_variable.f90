submodule(module_netcdf) submodule_variable
implicit none (type, external)
contains

module impure elemental function get_var(nc, name, exist) result(var)
  type(netcdf_type), intent(in) :: nc
  character(len=*), intent(in) :: name
  logical, optional, intent(out) :: exist
  type(variable_type), target :: var
  type(c_ptr) :: cptr

  var = inq_var(nc, name, exist)
  zero_size_var: if (var%len == 0) then
    if (allocated(var%buffer)) deallocate (var%buffer)
    return
  end if zero_size_var

  call allocate_buffer(var)
  cptr = c_loc(var%buffer(1))
  associate (err_msg => "[get_var] Invalid variable: "//name)
    call handle_error(nc_get_var(nc%id, var%id, cptr), err_msg)
  end associate
end function get_var

module impure elemental function inq_var(nc, name, exist) result(var)
  type(netcdf_type), intent(in) :: nc
  character(len=*), intent(in) :: name
  logical, optional, intent(out) :: exist
  type(variable_type) :: var
  logical :: atts_exist
  integer :: i

  var%name = trim(adjustl(name))
  var%id = inq_varid(nc%id, var%name, exist)
  var%dtype = inq_vartype(nc%id, var%id)
  var%atts = get_atts_var(nc, var, atts_exist)
  if (.not. atts_exist .and. allocated(var%atts)) deallocate (var%atts)
  var%dims = inq_dims_var(nc, var)
  var%len = 1
  do i = 1, size(var%dims)
    var%len = var%len*var%dims(i)%len
  end do
end function inq_var

impure elemental function inq_vartype(ncid, varid) result(vartype)
  integer(c_int), intent(in) :: ncid, varid
  integer(c_int) :: vartype

  call handle_error(nc_inq_vartype(ncid, varid, vartype))
end function inq_vartype

impure elemental function inq_varid(ncid, name, exist) result(varid)
  integer(c_int), intent(in) :: ncid
  character(len=*), intent(in) :: name
  logical, optional, intent(out) :: exist
  integer(c_int) :: varid
  integer(c_int) :: stat

  stat = nc_inq_varid(ncid, f2cstr(name), varid)
  if (present(exist)) then
    exist = stat == NC_NOERR
    if (.not. exist) return
  end if
  call handle_error(stat)
end function inq_varid

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

module pure function get_size(var, dim) result(n)
  type(variable_type), intent(in) :: var
  integer, optional, intent(in) :: dim
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

module pure function get_shape(var) result(n)
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

module pure subroutine allocate_var_mold(var, mold)
  type(variable_type), intent(inout) :: var
  type(variable_type), intent(in) :: mold

  if (allocated(mold%atts)) then
    call allocate_var_meta(var, mold%name, &
      & mold%dtype, mold%len, mold%dims, mold%atts)
  else
    call allocate_var_meta(var, mold%name, &
      & mold%dtype, mold%len, mold%dims)
  end if
end subroutine allocate_var_mold

module pure subroutine allocate_var_meta(var, name, dtype, len, dims, atts)
  type(variable_type), intent(inout) :: var
  character(len=*), intent(in) :: name
  integer(int32), intent(in) :: dtype
  integer(int64), intent(in) :: len
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), optional, intent(in) :: atts(:)

  var%name = name
  var%dtype = dtype
  var%len = len
  var%dims = dims
  if (present(atts)) var%atts = atts
  call allocate_buffer_var(var)
end subroutine allocate_var_meta

module pure subroutine allocate_buffer_var(var)
  type(variable_type), intent(inout) :: var
  integer(int64) :: buffer_size

  !> Assuming var%dtype and var%len is properly initialized.
  buffer_size = get_buffer_size(var%dtype, var%len)
  if (allocation_required(var%buffer, buffer_size)) then
    if (allocated(var%buffer)) deallocate (var%buffer)
    allocate (var%buffer(buffer_size))
  end if
end subroutine allocate_buffer_var

module elemental logical function eq_var(x, y)
  type(variable_type), intent(in) :: x, y
  logical :: is_alloc(2)

  eq_var = (x%name == y%name) .and. &
    & (x%dtype == y%dtype) .and. (x%len == y%len)
  if (.not. eq_var) return

  is_alloc(1) = allocated(x%dims)
  is_alloc(2) = allocated(y%dims)

  if (all(is_alloc)) then
    eq_var = all(x%dims == y%dims)
  else
    eq_var = .false.
  end if
  if (.not. eq_var) return

  is_alloc(1) = allocated(x%atts)
  is_alloc(2) = allocated(y%atts)

  if (all(is_alloc)) then
    eq_var = all(x%atts == y%atts)
  else if (.not. any(is_alloc)) then
    eq_var = .true.
  else
    eq_var = .false.
  end if
  if (.not. eq_var) return

  eq_var = all(x%buffer == y%buffer)
end function eq_var

module elemental logical function neq_var(x, y)
  type(variable_type), intent(in) :: x, y

  neq_var = .not. eq_var(x, y)
end function neq_var

end submodule submodule_variable
