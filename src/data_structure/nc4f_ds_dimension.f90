submodule(nc4f_ds) nc4f_ds_dimension
implicit none (type, external)
contains

pure module subroutine rename_dim_dim(dim, new_name, err)
  !! Rename one dimension without changing its identity, length, or unlimited flag.
  type(dimension_type), intent(inout) :: dim
  !! Standalone dimension to rename; other copies are unchanged.
  character(len=*), intent(in) :: new_name
  !! Replacement local name; trailing Fortran padding is ignored.
  type(error_type), intent(out), optional :: err
  !! Receives status; failures terminate execution when omitted.
  type(error_type) :: op_err
  character(len=:), allocatable :: name

  call check_nc_name(new_name, op_err, "rename_dimension")
  if (op_err%code == NC_NOERR) then
    name = trim(new_name)
    call move_alloc(name, dim%name)
  end if
  call return_err(op_err, err)
end subroutine rename_dim_dim

pure module subroutine rename_dim_var(var, old_name, new_name, err)
  !! Rename all matching axes in one variable, including repeated dimension references.
  type(variable_type), intent(inout) :: var
  !! Variable whose dimension names change; data and other metadata are preserved.
  character(len=*), intent(in) :: old_name, new_name
  !! old_name: Dimension to find. new_name: Replacement local name.
  type(error_type), intent(out), optional :: err
  !! Receives status; failures terminate execution when omitted.
  type(error_type) :: op_err
  type(dimension_type), allocatable :: staged(:)
  integer :: i, lo

  if (allocated(var%dims)) then
    allocate (staged(size(var%dims)))
    staged(:) = var%dims
  else
    allocate (staged(0))
  end if
  call rename_dims_(staged, old_name, new_name, op_err)
  if (op_err%code == NC_NOERR) then
    lo = lbound(var%dims, 1)
    do i = 1, size(staged)
      if (.not. allocated(staged(i)%name)) cycle
      if (staged(i)%name /= trim(new_name)) cycle
      call move_alloc(staged(i)%name, var%dims(lo + i - 1)%name)
    end do
  end if
  call return_err(op_err, err)
end subroutine rename_dim_var

pure module subroutine rename_dim_grp(grp, old_name, new_name, err)
  !! Rename a local dimension and its direct variable references; do not traverse children.
  class(group_type), intent(inout) :: grp
  !! Group with local definitions or, if dims is unallocated, implicit variable dimensions.
  character(len=*), intent(in) :: old_name, new_name
  !! old_name: Dimension to find. new_name: Replacement local name.
  type(error_type), intent(out), optional :: err
  !! Receives status; failures terminate execution when omitted.
  type(error_type) :: op_err
  type(dimension_type), allocatable :: staged(:)
  integer :: n, i, j, k, matches

  call check_nc_name(old_name, op_err, "rename_dimension")
  if (op_err%code == NC_NOERR) call check_nc_name(new_name, op_err, "rename_dimension")
  if (op_err%code /= NC_NOERR) then
    call return_err(op_err, err)
    return
  end if
  n = 0
  if (allocated(grp%dims)) then
    n = size(grp%dims)
    matches = 0
    do i = lbound(grp%dims, 1), ubound(grp%dims, 1)
      if (.not. allocated(grp%dims(i)%name)) cycle
      if (grp%dims(i)%name == trim(old_name)) matches = matches + 1
    end do
    if (matches == 0) then
      op_err = error_type(NC_EBADDIM, "rename_dimension", &
        & "Local dimension not found: "//trim(old_name))
    else if (matches > 1) then
      op_err = error_type(NC_EINVAL, "rename_dimension", &
        & "Duplicate local dimension: "//trim(old_name))
    end if
    if (op_err%code /= NC_NOERR) then
      call return_err(op_err, err)
      return
    end if
  end if
  if (allocated(grp%vars)) then
    do i = lbound(grp%vars, 1), ubound(grp%vars, 1)
      if (allocated(grp%vars(i)%dims)) n = n + size(grp%vars(i)%dims)
    end do
  end if
  allocate (staged(n))
  k = 0
  if (allocated(grp%dims)) then
    k = size(grp%dims)
    staged(:k) = grp%dims
  end if
  if (allocated(grp%vars)) then
    do i = lbound(grp%vars, 1), ubound(grp%vars, 1)
      if (.not. allocated(grp%vars(i)%dims)) cycle
      n = size(grp%vars(i)%dims)
      staged(k + 1:k + n) = grp%vars(i)%dims
      k = k + n
    end do
  end if
  call rename_dims_(staged, old_name, new_name, op_err)
  if (op_err%code == NC_NOERR) then
    k = 0
    if (allocated(grp%dims)) then
      do i = lbound(grp%dims, 1), ubound(grp%dims, 1)
        k = k + 1
        if (.not. allocated(grp%dims(i)%name)) cycle
        if (grp%dims(i)%name == trim(old_name)) call move_alloc(staged(k)%name, grp%dims(i)%name)
      end do
    end if
    if (allocated(grp%vars)) then
      do i = lbound(grp%vars, 1), ubound(grp%vars, 1)
        if (.not. allocated(grp%vars(i)%dims)) cycle
        do j = lbound(grp%vars(i)%dims, 1), ubound(grp%vars(i)%dims, 1)
          k = k + 1
          if (.not. allocated(grp%vars(i)%dims(j)%name)) cycle
          if (grp%vars(i)%dims(j)%name == trim(old_name)) &
            & call move_alloc(staged(k)%name, grp%vars(i)%dims(j)%name)
        end do
      end do
    end if
  end if
  call return_err(op_err, err)
end subroutine rename_dim_grp

pure subroutine rename_dims_(dims, old_name, new_name, err)
  !! Validate a flattened set of definitions/references, then rename all matching entries.
  type(dimension_type), intent(inout) :: dims(:)
  !! Staged dimension metadata; duplicate references must agree in length and unlimited status.
  character(len=*), intent(in) :: old_name, new_name
  !! old_name: Dimension to find. new_name: Replacement local name.
  type(error_type), intent(out) :: err
  !! Receives missing, conflicting, or invalid-name errors before any mutation.
  integer :: i, first
  integer(c_int) :: known_id

  call check_nc_name(old_name, err, "rename_dimension")
  if (err%code /= NC_NOERR) return
  call check_nc_name(new_name, err, "rename_dimension")
  if (err%code /= NC_NOERR) return
  first = 0
  known_id = -1
  do i = 1, size(dims)
    if (.not. allocated(dims(i)%name)) cycle
    if (dims(i)%name /= trim(old_name)) cycle
    if (first == 0) first = i
    if (dims(i)%id >= 0) then
      if (known_id >= 0 .and. known_id /= dims(i)%id) then
        err = error_type(NC_EINVAL, "rename_dimension", &
          & "Conflicting cached dimension identities: "//trim(old_name))
        return
      end if
      known_id = dims(i)%id
    end if
    if (dims(i)%len /= dims(first)%len .or. (dims(i)%is_unlim .neqv. dims(first)%is_unlim)) then
      err = error_type(NC_EINVAL, "rename_dimension", &
        & "Conflicting dimension metadata: "//trim(old_name))
      return
    end if
  end do
  if (first == 0) then
    err = error_type(NC_EBADDIM, "rename_dimension", &
      & "Dimension not found: "//trim(old_name))
    return
  end if
  if (trim(old_name) == trim(new_name)) return
  do i = 1, size(dims)
    if (.not. allocated(dims(i)%name)) cycle
    if (dims(i)%name == trim(new_name)) then
      err = error_type(NC_ENAMEINUSE, "rename_dimension", &
        & "Dimension name already in use: "//trim(new_name))
      return
    end if
  end do
  do i = 1, size(dims)
    if (.not. allocated(dims(i)%name)) cycle
    if (dims(i)%name == trim(old_name)) dims(i)%name = trim(new_name)
  end do
end subroutine rename_dims_

elemental module function new_dim_arg_int32(len, is_unlim) result(arg)
  !! Construct unlimited-dimension arguments from a 32-bit length.
  integer(int32), intent(in) :: len
  !! Length of the dimension or attribute.
  logical, intent(in) :: is_unlim
  !! Whether the dimension is unlimited.
  type(dimension_argument_type) :: arg
  !! Result produced by this operation.

  arg%len = int(len, int64)
  arg%is_unlim = is_unlim
end function new_dim_arg_int32

elemental module function new_dim_arg_int64(len, is_unlim) result(arg)
  !! Construct unlimited-dimension arguments from a 64-bit length.
  integer(int64), intent(in) :: len
  !! Length of the dimension or attribute.
  logical, intent(in) :: is_unlim
  !! Whether the dimension is unlimited.
  type(dimension_argument_type) :: arg
  !! Result produced by this operation.

  arg%len = len
  arg%is_unlim = is_unlim
end function new_dim_arg_int64

elemental module function new_dim_len_int32(name, len) result(dim)
  !! Construct a dimension from a 32-bit length.
  character(len=*), intent(in) :: name
  !! Name used to identify the NetCDF object.
  integer(int32), intent(in) :: len
  !! Length of the dimension or attribute.
  type(dimension_type) :: dim
  !! Result produced by this operation.

  dim%name = trim(name)
  dim%len = int(len, int64)
end function new_dim_len_int32

elemental module function new_dim_len_int64(name, len) result(dim)
  !! Construct a dimension from a 64-bit length.
  character(len=*), intent(in) :: name
  !! Name used to identify the NetCDF object.
  integer(int64), intent(in) :: len
  !! Length of the dimension or attribute.
  type(dimension_type) :: dim
  !! Result produced by this operation.

  dim%name = trim(name)
  dim%len = len
end function new_dim_len_int64

elemental module function new_dim_args(name, args) result(dim)
  !! Construct a dimension with an explicit unlimited flag.
  character(len=*), intent(in) :: name
  !! Name used to identify the NetCDF object.
  type(dimension_argument_type), intent(in) :: args
  !! Dimension length and unlimited flag packaged by the .and. operator.
  type(dimension_type) :: dim
  !! Result produced by this operation.

  dim%name = trim(name)
  dim%len = args%len
  dim%is_unlim = args%is_unlim
end function new_dim_args

logical elemental module function eq_dim(x, y)
  !! Return true when two dimensions have identical metadata.
  type(dimension_type), intent(in) :: x, y
  !! x: Left-hand value to compare.
  !! y: Right-hand value to compare.

  eq_dim = x%len == y%len .and. x%is_unlim .eqv. y%is_unlim
  if (eq_dim) then
    eq_dim = allocated(x%name) .eqv. allocated(y%name)
    if (eq_dim .and. allocated(x%name)) eq_dim = x%name == y%name
  end if
end function eq_dim

logical elemental module function neq_dim(x, y)
  !! Return true when two dimensions have different metadata.
  type(dimension_type), intent(in) :: x, y
  !! x: Left-hand value to compare.
  !! y: Right-hand value to compare.

  neq_dim = .not. eq_dim(x, y)
end function neq_dim

end submodule nc4f_ds_dimension
