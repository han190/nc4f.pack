!> Deep-cloning helpers for the direct data model.
submodule(nc4f_data_struct) nc4f_data_struct_clone

implicit none (type, external)

contains

!> Execute `clone_att_`.
module subroutine clone_att_(src, dest)
  !> Input argument: `src`.
  type(attribute_type), intent(in) :: src
  !> Output argument: `dest`.
  type(attribute_type), intent(out) :: dest
  dest%id = src%id
  dest%name = src%name
  dest%dtype = src%dtype
  dest%len = src%len
  if (associated(src%buffer)) then
    allocate (dest%buffer(size(src%buffer)))
    dest%buffer = src%buffer
  end if
end subroutine clone_att_

!> Execute `clone_var_`.
module subroutine clone_var_(src, dest)
  !> Input argument: `src`.
  type(variable_type), intent(in) :: src
  !> Output argument: `dest`.
  type(variable_type), intent(out) :: dest
  integer :: i
  dest%id = src%id
  dest%name = src%name
  dest%dtype = src%dtype
  dest%len = src%len
  if (allocated(src%dims)) dest%dims = src%dims
  if (associated(src%buffer)) then
    allocate (dest%buffer(size(src%buffer)))
    dest%buffer = src%buffer
  end if
  if (allocated(src%atts)) then
    allocate (dest%atts(size(src%atts)))
    do i = 1, size(src%atts)
      call clone_att_(src%atts(i), dest%atts(i))
    end do
  end if
end subroutine clone_var_

!> Execute `clone_grp_`.
recursive module subroutine clone_grp_(src, dest)
  !> Input argument: `src`.
  type(group_type), intent(in) :: src
  !> Output argument: `dest`.
  type(group_type), intent(out) :: dest
  integer :: i
  dest%id = src%id
  dest%name = src%name
  if (allocated(src%dims)) dest%dims = src%dims
  if (allocated(src%atts)) then
    allocate (dest%atts(size(src%atts)))
    do i = 1, size(src%atts)
      call clone_att_(src%atts(i), dest%atts(i))
    end do
  end if
  if (allocated(src%vars)) then
    allocate (dest%vars(size(src%vars)))
    do i = 1, size(src%vars)
      call clone_var_(src%vars(i), dest%vars(i))
    end do
  end if
  if (associated(src%grps)) then
    allocate (dest%grps(size(src%grps)))
    do i = 1, size(src%grps)
      call clone_grp_(src%grps(i), dest%grps(i))
    end do
  end if
end subroutine clone_grp_

end submodule nc4f_data_struct_clone
