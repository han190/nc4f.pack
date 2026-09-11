submodule(nc4f_data_struct) nc4f_data_struct_grp
implicit none (type, external)
contains

!> Construct a group from local arrays, attributes, and direct child groups.
module function new_data_set(name, arrays, grps, atts) result(group)
  character(len=*), intent(in) :: name
  type(variable_type), intent(in), optional :: arrays(:)
  type(group_type), intent(in), optional :: grps(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(group_type) :: group

  group%name = trim(name)
  if (present(arrays)) call new_data_set_(group, arrays)
  if (present(atts)) group%atts = atts
  if (present(grps)) group%grps = grps
end function new_data_set

!> Populate a group from local arrays and infer its unique local dimensions.
subroutine new_data_set_(grp, arrs)
  type(group_type), intent(inout) :: grp
  type(variable_type), intent(in) :: arrs(:)
  type(dimension_type), allocatable :: dimensions(:)
  integer :: i, j, k, n, ndims
  logical :: has_name

  grp%vars = arrs
  ndims = 0
  do i = 1, size(arrs)
    if (allocated(arrs(i)%dims)) ndims = ndims + size(arrs(i)%dims)
  end do
  allocate (dimensions(ndims))

  n = 0
  do i = 1, size(arrs)
    if (.not. allocated(arrs(i)%dims)) cycle
    do j = 1, size(arrs(i)%dims)
      has_name = .false.
      do k = 1, n
        if (dimensions(k)%name == arrs(i)%dims(j)%name) then
          has_name = .true.
          if (dimensions(k) /= arrs(i)%dims(j)) error stop &
            & "[data_set] Conflicting definitions for one dimension name."
          exit
        end if
      end do
      if (.not. has_name) then
        n = n + 1
        dimensions(n) = arrs(i)%dims(j)
      end if
    end do
  end do
  grp%dims = dimensions(:n)
end subroutine new_data_set_

end submodule nc4f_data_struct_grp
