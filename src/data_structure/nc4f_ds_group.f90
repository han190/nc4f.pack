submodule(nc4f_ds) nc4f_ds_group
!! Constructors and group composition for the direct data model.
implicit none (type, external)
contains

pure module subroutine rename_grp_grp(grp, new_name, err)
  !! Rename an independent non-root group without changing its child tree.
  class(group_type), intent(inout) :: grp
  character(len=*), intent(in) :: new_name
  type(error_type), intent(out), optional :: err
  type(error_type) :: op_err
  character(len=:), allocatable :: name

  select type (grp)
  class is (netcdf_type)
    op_err = error_type(NC_EBADGRPID, "[rename_group] Cannot rename the root group.")
  class default
    if (allocated(grp%name)) then
      if (grp%name == "/") then
        op_err = error_type(NC_EBADGRPID, "[rename_group] Cannot rename the root group.")
      end if
    end if
  end select
  if (op_err%code == NC_NOERR) call chk_nc_name(new_name, op_err, "[rename_group]")
  if (op_err%code == NC_NOERR) then
    name = trim(new_name)
    call move_alloc(name, grp%name)
  end if
  call ret_ds_err(op_err, err)
end subroutine rename_grp_grp

pure module subroutine rename_grp_par(parent, old_name, new_name, err)
  !! Rename one direct child; aliases to parent%grps observe the same change.
  class(group_type), intent(inout) :: parent
  character(len=*), intent(in) :: old_name, new_name
  type(error_type), intent(out), optional :: err
  type(error_type) :: op_err

  call chk_nc_name(old_name, op_err, "[rename_group]")
  if (op_err%code == NC_NOERR) call chk_nc_name(new_name, op_err, "[rename_group]")
  if (op_err%code == NC_NOERR) then
    if (associated(parent%grps)) then
      call rename_grps_(parent%grps, old_name, new_name, op_err)
    else
      op_err = error_type(NC_ENOGRP, "[rename_group] Group not found: "//trim(old_name))
    end if
  end if
  call ret_ds_err(op_err, err)
end subroutine rename_grp_par

pure subroutine rename_grps_(grps, old_name, new_name, err)
  !! Assumed-shape indexing also supports pointer arrays with nonunit lower bounds.
  type(group_type), intent(inout) :: grps(:)
  character(len=*), intent(in) :: old_name, new_name
  type(error_type), intent(out) :: err
  integer :: i, pos

  err = error_type()
  pos = 0
  do i = 1, size(grps)
    if (.not. allocated(grps(i)%name)) cycle
    if (grps(i)%name /= trim(old_name)) cycle
    if (pos /= 0) then
      err = error_type(NC_EINVAL, "[rename_group] Ambiguous duplicate group: "//trim(old_name))
      return
    end if
    pos = i
  end do
  if (pos == 0) then
    err = error_type(NC_ENOGRP, "[rename_group] Group not found: "//trim(old_name))
    return
  end if
  do i = 1, size(grps)
    if (i == pos .or. .not. allocated(grps(i)%name)) cycle
    if (grps(i)%name == trim(new_name)) then
      err = error_type(NC_ENAMEINUSE, "[rename_group] Group name already in use: "//trim(new_name))
      return
    end if
  end do
  if (trim(old_name) == trim(new_name)) return
  call rename_grp_grp(grps(pos), new_name, err)
end subroutine rename_grps_


elemental module subroutine init_att(att, name, dtype, len)
  !! Initialize an owning attribute buffer.
  type(attribute_type), intent(inout) :: att
  !! Attribute to process.
  character(len=*), intent(in) :: name
  !! Name used to identify the NetCDF object.
  integer(data_type), intent(in) :: dtype
  !! Data or metadata used by this operation.
  integer(int64), intent(in) :: len
  !! Data or metadata used by this operation.

  call init_att_(att, name, dtype, len, deep=.true.)
end subroutine init_att

elemental module subroutine init_att_(att, name, dtype, len, deep)
  !! Initialize attribute metadata and optionally allocate an owning buffer.
  type(attribute_type), intent(inout) :: att
  !! Attribute to process.
  character(len=*), intent(in) :: name
  !! Name used to identify the NetCDF object.
  integer(data_type), intent(in) :: dtype
  !! Dataset data type code to validate or translate.
  integer(int64), intent(in) :: len
  !! Length of the dimension or attribute.
  logical, intent(in), optional :: deep
  !! Whether to allocate an owning data buffer.
  logical :: deep_copy

  if (len < 0) error stop "[init_att] Negative attribute length."
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (allocated(att%buffer)) deallocate (att%buffer)
  nullify (att%ptr)
  att%name = trim(name)
  att%dtype = dtype
  att%len = len
  if (deep_copy) allocate (att%buffer(buffer_size(dtype, len)))
end subroutine init_att_

module subroutine init_var(var, name, dtype, len, dims, atts)
  !! Initialize variable metadata and an owning buffer.
  type(variable_type), intent(inout) :: var
  !! Variable to process.
  character(len=*), intent(in) :: name
  !! Name used to identify the NetCDF object.
  integer(data_type), intent(in) :: dtype
  !! Data or metadata used by this operation.
  integer(int64), intent(in) :: len
  !! Data or metadata used by this operation.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable shape.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Attributes to process or attach.

  call init_var_(var, name, dtype, len, dims, atts, deep=.true.)
end subroutine init_var

module subroutine init_var_(var, name, dtype, len, dims, atts, deep)
  !! Initialize variable metadata and optionally allocate an owning buffer.
  type(variable_type), intent(inout) :: var
  !! Variable to process.
  character(len=*), intent(in) :: name
  !! Name used to identify the NetCDF object.
  integer(data_type), intent(in) :: dtype
  !! Dataset data type code to validate or translate.
  integer(int64), intent(in) :: len
  !! Length of the dimension or attribute.
  type(dimension_type), intent(in) :: dims(:)
  !! Dimensions describing the variable shape.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Attributes to process or attach.
  logical, intent(in), optional :: deep
  !! Whether to make an owned deep copy of the data.
  logical :: deep_copy

  if (len < 0) error stop "[init_var] Negative variable length."
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  if (allocated(var%buffer)) deallocate (var%buffer)
  nullify (var%ptr)
  var%name = trim(name)
  var%dtype = dtype
  var%dims = dims
  if (size(var) /= len) error stop &
    & "[init_var] Dimension product differs from variable length."
  var%len = len
  if (present(atts)) var%atts = atts
  if (deep_copy) allocate (var%buffer(buffer_size(dtype, len)))
end subroutine init_var_

module function new_dataset_empty(name, atts, deep) result(grp)
  !! Compute `new_dataset_empty`.
  character(len=*), intent(in) :: name
  !! Name used to identify the NetCDF object.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Attributes to process or attach.
  logical, intent(in), optional :: deep
  !! Whether to make an owned deep copy of the data.
  type(group_type) :: grp
  !! Result produced by this operation.
  call new_dataset_(grp, name, atts=atts, deep=deep)
end function new_dataset_empty

module function new_dataset_vars(name, vars, atts, deep) result(grp)
  !! Compute `new_dataset_vars`.
  character(len=*), intent(in) :: name
  !! Name used to identify the NetCDF object.
  type(variable_type), intent(in) :: vars(:)
  !! Variables to process or add to the dataset.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Attributes to process or attach.
  logical, intent(in), optional :: deep
  !! Whether to make an owned deep copy of the data.
  type(group_type) :: grp
  !! Result produced by this operation.
  call new_dataset_(grp, name, vars=vars, atts=atts, deep=deep)
end function new_dataset_vars

module function new_dataset_grps(name, grps, atts, deep) result(grp)
  !! Compute `new_dataset_grps`.
  character(len=*), intent(in) :: name
  !! Name used to identify the NetCDF object.
  type(group_type), intent(in) :: grps(:)
  !! Data or metadata used by this operation.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Attributes to process or attach.
  logical, intent(in), optional :: deep
  !! Whether to make an owned deep copy of the data.
  type(group_type) :: grp
  !! Result produced by this operation.
  call new_dataset_(grp, name, grps=grps, atts=atts, deep=deep)
end function new_dataset_grps

module function new_dataset_all(name, vars, grps, atts, deep) result(grp)
  !! Compute `new_dataset_all`.
  character(len=*), intent(in) :: name
  !! Name used to identify the NetCDF object.
  type(variable_type), intent(in) :: vars(:)
  !! Variables to process or add to the dataset.
  type(group_type), intent(in) :: grps(:)
  !! Data or metadata used by this operation.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Attributes to process or attach.
  logical, intent(in), optional :: deep
  !! Whether to make an owned deep copy of the data.
  type(group_type) :: grp
  !! Result produced by this operation.
  call new_dataset_(grp, name, vars, grps, atts, deep)
end function new_dataset_all

module subroutine new_dataset_(grp, name, vars, grps, atts, deep)
  !! Populate a group with intrinsic or explicit deep child copies.
  type(group_type), intent(out) :: grp
  !! Data or metadata used by this operation.
  character(len=*), intent(in) :: name
  !! Name used to identify the NetCDF object.
  type(variable_type), intent(in), optional :: vars(:)
  !! Variables to process or add to the dataset.
  type(group_type), intent(in), optional :: grps(:)
  !! Data or metadata used by this operation.
  type(attribute_type), intent(in), optional :: atts(:)
  !! Attributes to process or attach.
  logical, intent(in), optional :: deep
  !! Whether to make an owned deep copy of the data.
  logical :: deep_copy

  deep_copy = .false.
  if (present(deep)) deep_copy = deep
  grp%name = trim(name)
  if (present(atts)) then
    allocate (grp%atts(size(atts)))
    if (deep_copy) then
      call clone_att(atts, grp%atts)
    else
      grp%atts = atts
    end if
  end if
  if (present(vars)) then
    allocate (grp%vars(size(vars)))
    if (deep_copy) then
      call clone_var(vars, grp%vars)
    else
      grp%vars = vars
    end if
    grp%dims = collect_dims_(vars)
  end if
  if (present(grps)) then
    allocate (grp%grps(size(grps)))
    if (deep_copy) then
      call clone_grp(grps, grp%grps)
    else
      grp%grps = grps
    end if
  end if
end subroutine new_dataset_

pure function collect_dims_(vars) result(dims)
  !! Collect unique variable dimensions in first-seen order.
  !!
  !! Dimensions sharing a name must have matching length and unlimited status.
  type(variable_type), intent(in) :: vars(:)
  !! Variables to process or add to the dataset.
  type(dimension_type), allocatable :: dims(:)
  !! Result produced by this operation.
  type(dimension_type), allocatable :: collected(:)
  integer :: i, j, k, n, ndims
  logical :: has_name

  ndims = 0
  do i = 1, size(vars)
    if (allocated(vars(i)%dims)) ndims = ndims + size(vars(i)%dims)
  end do
  allocate (collected(ndims))

  n = 0
  do i = 1, size(vars)
    if (.not. allocated(vars(i)%dims)) cycle
    do j = 1, size(vars(i)%dims)
      has_name = .false.
      do k = 1, n
        if (collected(k)%name == vars(i)%dims(j)%name) then
          has_name = .true.
          if (collected(k)%len /= vars(i)%dims(j)%len .or. &
            & collected(k)%is_unlim .neqv. vars(i)%dims(j)%is_unlim) then
            error stop "[dataset] Conflicting"// &
              & " definitions for one dimension name."
          end if
          exit
        end if
      end do
      if (.not. has_name) then
        n = n + 1
        collected(n) = vars(i)%dims(j)
      end if
    end do
  end do
  dims = collected(:n)
end function collect_dims_

pure module function buffer_size(dtype, len, context) result(nbytes)
  !! Compute `buffer_size`.
  integer(data_type), intent(in) :: dtype
  !! Dataset data type code to validate or translate.
  integer(int64), intent(in) :: len
  !! Length of the dimension or attribute.
  character(len=*), intent(in), optional :: context
  !! Context included in a validation or error message.
  integer :: nbytes
  !! Result produced by this operation.
  integer(int64) :: item_bytes

  if (len < 0) then
    if (present(context)) then
      error stop trim(context)//" Negative element count."
    else
      error stop "[buffer_size] Negative element count."
    end if
  end if
  select case (dtype)
  case (BYTE_TYPE, CHAR_TYPE)
    item_bytes = 1
  case (SHORT_TYPE)
    item_bytes = storage_size(0_int16)/storage_size(0_int8)
  case (INT_TYPE, FLOAT_TYPE)
    item_bytes = storage_size(0_int32)/storage_size(0_int8)
  case (INT64_TYPE, DOUBLE_TYPE)
    item_bytes = storage_size(0_int64)/storage_size(0_int8)
  case default
    if (present(context)) then
      error stop trim(context)//" Unsupported NetCDF data type."
    else
      error stop "[buffer_size] Unsupported NetCDF data type."
    end if
  end select
  if (len > int(huge(nbytes), int64)/item_bytes) then
    if (present(context)) then
      error stop trim(context)//" Byte-size overflow."
    else
      error stop "[buffer_size] Byte-size overflow."
    end if
  end if
  nbytes = int(len*item_bytes)
end function buffer_size

end submodule nc4f_ds_group
