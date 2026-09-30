!> Deep-cloning helpers for the direct data model.
submodule(nc4f_ds) nc4f_ds_clone
implicit none(type, external)
contains

!> Execute `clone_grp`.
impure elemental module subroutine clone_grp(src, dest)
  !> Source object or group to read from.
  type(group_type), intent(in) :: src
  !> Destination object or group to update.
  type(group_type), intent(out) :: dest

  call clone_grp_(src, dest)
end subroutine clone_grp

!> Recursively clone a group tree.
recursive subroutine clone_grp_(src, dest)
  !> Source object or group to read from.
  type(group_type), intent(in) :: src
  !> Destination object or group to update.
  type(group_type), intent(out) :: dest
  integer :: i

  dest%id = src%id
  dest%name = src%name
  if (allocated(src%dims)) dest%dims = src%dims
  if (allocated(src%atts)) then
    allocate (dest%atts(size(src%atts)))
    call clone_att(src%atts, dest%atts)
  end if
  if (allocated(src%vars)) then
    allocate (dest%vars(size(src%vars)))
    call clone_var(src%vars, dest%vars)
  end if
  if (associated(src%grps)) then
    allocate (dest%grps(size(src%grps)))
    do i = 1, size(src%grps)
      call clone_grp_(src%grps(i), dest%grps(i))
    end do
  end if
end subroutine clone_grp_

!> Execute `clone_var`.
impure elemental module subroutine clone_var(src, dest)
  !> Source object or group to read from.
  type(variable_type), intent(in) :: src
  !> Destination object or group to update.
  type(variable_type), intent(out) :: dest

  call validate(src, context="[clone_var]")
  dest%id = src%id
  dest%name = src%name
  dest%dtype = src%dtype
  dest%len = src%len
  if (allocated(src%dims)) dest%dims = src%dims
  nullify (dest%ptr)
  call clone_(dest%buffer, src%buffer, src%ptr)
  if (allocated(src%atts)) then
    allocate (dest%atts(size(src%atts)))
    call clone_att(src%atts, dest%atts)
  end if
end subroutine clone_var

!> Execute `clone_att`.
impure elemental module subroutine clone_att(src, dest)
  !> Source object or group to read from.
  type(attribute_type), intent(in) :: src
  !> Destination object or group to update.
  type(attribute_type), intent(out) :: dest

  call validate(src, context="[clone_att]")
  dest%id = src%id
  dest%name = src%name
  dest%dtype = src%dtype
  dest%len = src%len
  nullify (dest%ptr)
  call clone_(dest%buffer, src%buffer, src%ptr)
end subroutine clone_att

!> Clone owned or borrowed bytes into an owned output buffer.
pure subroutine clone_(obuffer, ibuffer, iptr)
  !> Output owned byte buffer.
  integer(int8), allocatable, intent(out) :: obuffer(:)
  !> Input owned byte buffer.
  integer(int8), allocatable, intent(in) :: ibuffer(:)
  !> Input borrowed byte buffer.
  integer(int8), contiguous, pointer, intent(in) :: iptr(:)

  if (allocated(ibuffer)) then
    allocate (obuffer(size(ibuffer)))
    obuffer = ibuffer
  else if (associated(iptr)) then
    allocate (obuffer(size(iptr)))
    obuffer = iptr
  end if
end subroutine clone_

end submodule nc4f_ds_clone
