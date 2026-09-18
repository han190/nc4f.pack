!> Constructors and group composition for the direct data model.
submodule(nc4f_data_struct) nc4f_data_struct_grp
implicit none (type, external)
contains

!> Initialize an owning attribute buffer.
module subroutine init_att(att, name, dtype, len)
  !> Input/output argument: `att`.
  type(attribute_type), intent(inout) :: att
  !> Input argument: `name`.
  character(len=*), intent(in) :: name
  !> Input argument: `dtype`.
  integer(data_type), intent(in) :: dtype
  !> Input argument: `len`.
  integer(int64), intent(in) :: len

  if (len < 0) error stop "[init_att] Negative attribute length."
  if (allocated(att%buffer)) deallocate (att%buffer)
  nullify (att%ptr)
  att%name = trim(name)
  att%dtype = dtype
  att%len = len
  allocate (att%buffer(buffer_size(dtype, len)))
end subroutine init_att

!> Initialize variable metadata and, for a deep value, an owning buffer.
module subroutine init_var(var, name, dtype, len, dims, atts, deep)
  !> Input/output argument: `var`.
  type(variable_type), intent(inout) :: var
  !> Input argument: `name`.
  character(len=*), intent(in) :: name
  !> Input argument: `dtype`.
  integer(data_type), intent(in) :: dtype
  !> Input argument: `len`.
  integer(int64), intent(in) :: len
  !> Input argument: `dims`.
  type(dimension_type), intent(in) :: dims(:)
  !> Input argument: `atts`.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Input argument: `deep`.
  logical, intent(in), optional :: deep
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
end subroutine init_var

!> Compute `new_dataset_empty`.
module function new_dataset_empty(name, atts, deep) result(grp)
  !> Input argument: `name`.
  character(len=*), intent(in) :: name
  !> Input argument: `atts`.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Input argument: `deep`.
  logical, intent(in), optional :: deep
  !> Return value: `grp`.
  type(group_type) :: grp
  call new_dataset_(grp, name, atts=atts, deep=deep)
end function new_dataset_empty

!> Compute `new_dataset_vars`.
module function new_dataset_vars(name, vars, atts, deep) result(grp)
  !> Input argument: `name`.
  character(len=*), intent(in) :: name
  !> Input argument: `vars`.
  type(variable_type), intent(in) :: vars(:)
  !> Input argument: `atts`.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Input argument: `deep`.
  logical, intent(in), optional :: deep
  !> Return value: `grp`.
  type(group_type) :: grp
  call new_dataset_(grp, name, vars=vars, atts=atts, deep=deep)
end function new_dataset_vars

!> Compute `new_dataset_grps`.
module function new_dataset_grps(name, grps, atts, deep) result(grp)
  !> Input argument: `name`.
  character(len=*), intent(in) :: name
  !> Input argument: `grps`.
  type(group_type), intent(in) :: grps(:)
  !> Input argument: `atts`.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Input argument: `deep`.
  logical, intent(in), optional :: deep
  !> Return value: `grp`.
  type(group_type) :: grp
  call new_dataset_(grp, name, grps=grps, atts=atts, deep=deep)
end function new_dataset_grps

!> Compute `new_dataset_all`.
module function new_dataset_all(name, vars, grps, atts, deep) result(grp)
  !> Input argument: `name`.
  character(len=*), intent(in) :: name
  !> Input argument: `vars`.
  type(variable_type), intent(in) :: vars(:)
  !> Input argument: `grps`.
  type(group_type), intent(in) :: grps(:)
  !> Input argument: `atts`.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Input argument: `deep`.
  logical, intent(in), optional :: deep
  !> Return value: `grp`.
  type(group_type) :: grp
  call new_dataset_(grp, name, vars, grps, atts, deep)
end function new_dataset_all

!> Populate a group with intrinsic or explicit deep child copies.
module subroutine new_dataset_(grp, name, vars, grps, atts, deep)
  !> Output argument: `grp`.
  type(group_type), intent(out) :: grp
  !> Input argument: `name`.
  character(len=*), intent(in) :: name
  !> Input argument: `vars`.
  type(variable_type), intent(in), optional :: vars(:)
  !> Input argument: `grps`.
  type(group_type), intent(in), optional :: grps(:)
  !> Input argument: `atts`.
  type(attribute_type), intent(in), optional :: atts(:)
  !> Input argument: `deep`.
  logical, intent(in), optional :: deep
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

!> Collect unique variable dimensions in first-seen order.
!>
!> Dimensions sharing a name must have matching length and unlimited status.
function collect_dims_(vars) result(dims)
  !> Input argument: `vars`.
  type(variable_type), intent(in) :: vars(:)
  !> Return value: `dims`.
  type(dimension_type), allocatable :: dims(:)
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

!> Compute `buffer_size`.
pure module function buffer_size(dtype, len, context) result(nbytes)
  !> Input argument: `dtype`.
  integer(data_type), intent(in) :: dtype
  !> Input argument: `len`.
  integer(int64), intent(in) :: len
  !> Input argument: `context`.
  character(len=*), intent(in), optional :: context
  !> Return value: `nbytes`.
  integer :: nbytes
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

end submodule nc4f_data_struct_grp
