!> Constructors and group composition for the direct data model.
submodule(nc4f_data_struct) nc4f_data_struct_grp

implicit none (type, external)

contains

!> Initialize an owning attribute buffer.
module subroutine init_att(att, name, dtype, len)
  type(attribute_type), intent(inout) :: att
  character(len=*), intent(in) :: name
  integer(data_type), intent(in) :: dtype
  integer(int64), intent(in) :: len

  if (len < 0) error stop "[init_att] Negative attribute length."
  nullify (att%buffer)
  att%name = trim(name)
  att%dtype = dtype
  att%len = len
  allocate (att%buffer(buffer_size(dtype, len)))
end subroutine init_att

!> Initialize variable metadata and, for a deep value, an owning buffer.
module subroutine init_var(var, name, dtype, len, dims, atts, deep)
  type(variable_type), intent(inout) :: var
  character(len=*), intent(in) :: name
  integer(data_type), intent(in) :: dtype
  integer(int64), intent(in) :: len
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  logical, intent(in), optional :: deep
  logical :: deep_copy

  if (len < 0) error stop "[init_var] Negative variable length."
  deep_copy = .true.
  if (present(deep)) deep_copy = deep
  nullify (var%buffer)
  var%name = trim(name)
  var%dtype = dtype
  var%dims = dims
  if (size(var) /= len) error stop "[init_var] Dimension product differs from variable length."
  var%len = len
  if (present(atts)) var%atts = atts
  if (deep_copy) allocate (var%buffer(buffer_size(dtype, len)))
end subroutine init_var

module function new_dataset_empty(name, atts, deep) result(grp)
  character(len=*), intent(in) :: name
  type(attribute_type), intent(in), optional :: atts(:)
  logical, intent(in), optional :: deep
  type(group_type) :: grp
  call new_dataset_(grp, name, atts=atts, deep=deep)
end function new_dataset_empty

module function new_dataset_vars(name, vars, atts, deep) result(grp)
  character(len=*), intent(in) :: name
  type(variable_type), intent(in) :: vars(:)
  type(attribute_type), intent(in), optional :: atts(:)
  logical, intent(in), optional :: deep
  type(group_type) :: grp
  call new_dataset_(grp, name, vars=vars, atts=atts, deep=deep)
end function new_dataset_vars

module function new_dataset_grps(name, grps, atts, deep) result(grp)
  character(len=*), intent(in) :: name
  type(group_type), intent(in) :: grps(:)
  type(attribute_type), intent(in), optional :: atts(:)
  logical, intent(in), optional :: deep
  type(group_type) :: grp
  call new_dataset_(grp, name, grps=grps, atts=atts, deep=deep)
end function new_dataset_grps

module function new_dataset_all(name, vars, grps, atts, deep) result(grp)
  character(len=*), intent(in) :: name
  type(variable_type), intent(in) :: vars(:)
  type(group_type), intent(in) :: grps(:)
  type(attribute_type), intent(in), optional :: atts(:)
  logical, intent(in), optional :: deep
  type(group_type) :: grp
  call new_dataset_(grp, name, vars, grps, atts, deep)
end function new_dataset_all

!> Populate a group with shallow or deep child values.
module subroutine new_dataset_(grp, name, vars, grps, atts, deep)
  type(group_type), intent(out) :: grp
  character(len=*), intent(in) :: name
  type(variable_type), intent(in), optional :: vars(:)
  type(group_type), intent(in), optional :: grps(:)
  type(attribute_type), intent(in), optional :: atts(:)
  logical, intent(in), optional :: deep
  type(dimension_type), allocatable :: dims(:)
  integer :: i, j, k, n, ndims
  logical :: deep_copy, has_name

  deep_copy = .false.
  if (present(deep)) deep_copy = deep
  grp%name = trim(name)
  if (present(atts)) then
    allocate (grp%atts(size(atts)))
    if (deep_copy) then
      do i = 1, size(atts)
        call clone_att_(atts(i), grp%atts(i))
      end do
    else
      grp%atts = atts
    end if
  end if
  if (present(vars)) then
    allocate (grp%vars(size(vars)))
    if (deep_copy) then
      do i = 1, size(vars)
        call clone_var_(vars(i), grp%vars(i))
      end do
    else
      grp%vars = vars
    end if
    ndims = 0
    do i = 1, size(vars)
      if (allocated(vars(i)%dims)) ndims = ndims + size(vars(i)%dims)
    end do
    allocate (dims(ndims))
    n = 0
    do i = 1, size(vars)
      do j = 1, size(vars(i)%dims)
        has_name = .false.
        do k = 1, n
          if (dims(k)%name == vars(i)%dims(j)%name) then
            has_name = .true.
            if (dims(k)%len /= vars(i)%dims(j)%len .or. &
              & dims(k)%is_unlim .neqv. vars(i)%dims(j)%is_unlim) then
              error stop "[dataset] Conflicting definitions for one dimension name."
            end if
            exit
          end if
        end do
        if (.not. has_name) then
          n = n + 1
          dims(n) = vars(i)%dims(j)
        end if
      end do
    end do
    grp%dims = dims(:n)
  end if
  if (present(grps)) then
    allocate (grp%grps(size(grps)))
    if (deep_copy) then
      do i = 1, size(grps)
        call clone_grp_(grps(i), grp%grps(i))
      end do
    else
      grp%grps = grps
    end if
  end if
end subroutine new_dataset_

module function buffer_size(dtype, len, context) result(nbytes)
  integer(data_type), intent(in) :: dtype
  integer(int64), intent(in) :: len
  character(len=*), intent(in), optional :: context
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
    item_bytes = storage_size(0_int16) / storage_size(0_int8)
  case (INT_TYPE, FLOAT_TYPE)
    item_bytes = storage_size(0_int32) / storage_size(0_int8)
  case (INT64_TYPE, DOUBLE_TYPE)
    item_bytes = storage_size(0_int64) / storage_size(0_int8)
  case default
    if (present(context)) then
      error stop trim(context)//" Unsupported NetCDF data type."
    else
      error stop "[buffer_size] Unsupported NetCDF data type."
    end if
  end select
  if (len > int(huge(nbytes), int64) / item_bytes) then
    if (present(context)) then
      error stop trim(context)//" Byte-size overflow."
    else
      error stop "[buffer_size] Byte-size overflow."
    end if
  end if
  nbytes = int(len * item_bytes)
end function buffer_size

end submodule nc4f_data_struct_grp
