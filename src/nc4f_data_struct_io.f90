!> ncdump-like formatted output for the direct v2 data model.
submodule(nc4f_data_struct) nc4f_data_struct_io

implicit none (type, external)

contains

module subroutine write_frmt_dim(dim, unit, iotype, v_list, iostat, iomsg)
  class(dimension_type), intent(in) :: dim
  integer, intent(in) :: unit
  character(len=*), intent(in) :: iotype
  integer, intent(in) :: v_list(:)
  integer, intent(out) :: iostat
  character(len=*), intent(inout) :: iomsg

  associate (ignored_v_list => v_list)
  end associate
  iostat = 1
  if (iotype /= "LISTDIRECTED" .and. iotype /= "DT") return
  if (dim%is_unlim) then
    write (unit, "(a, ' = UNLIMITED ; // (', i0, ' currently)')", iostat=iostat, iomsg=iomsg) &
      & dim%name, dim%len
  else
    write (unit, "(a, ' = ', i0, ' ;')", iostat=iostat, iomsg=iomsg) dim%name, dim%len
  end if
end subroutine write_frmt_dim

module subroutine write_frmt_att(att, unit, iotype, v_list, iostat, iomsg)
  class(attribute_type), intent(in) :: att
  integer, intent(in) :: unit
  character(len=*), intent(in) :: iotype
  integer, intent(in) :: v_list(:)
  integer, intent(out) :: iostat
  character(len=*), intent(inout) :: iomsg
  character(len=16) :: dtype

  associate (ignored_v_list => v_list)
  end associate
  iostat = 1
  if (iotype /= "LISTDIRECTED" .and. iotype /= "DT") return
  call type_name_(att%dtype, dtype)
  write (unit, "(a, ' ', a, ' ;')", iostat=iostat, iomsg=iomsg) trim(dtype)//" ::", att%name
end subroutine write_frmt_att

module subroutine write_frmt_var(var, unit, iotype, v_list, iostat, iomsg)
  class(variable_type), intent(in) :: var
  integer, intent(in) :: unit
  character(len=*), intent(in) :: iotype
  integer, intent(in) :: v_list(:)
  integer, intent(out) :: iostat
  character(len=*), intent(inout) :: iomsg
  character(len=16) :: dtype
  character(len=:), allocatable :: dims
  integer :: i

  associate (ignored_v_list => v_list)
  end associate
  iostat = 1
  if (iotype /= "LISTDIRECTED" .and. iotype /= "DT") return
  call type_name_(var%dtype, dtype)
  dims = ""
  if (allocated(var%dims)) then
    if (size(var%dims) > 0) then
      dims = "("
      do i = 1, size(var%dims)
        if (i > 1) dims = dims//", "
        dims = dims//trim(var%dims(i)%name)
      end do
      dims = dims//")"
    end if
  end if
  write (unit, "(a, 1x, a, a, ' ;')", iostat=iostat, iomsg=iomsg) trim(dtype), var%name, dims
end subroutine write_frmt_var

module subroutine write_frmt_grp(grp, unit, iotype, v_list, iostat, iomsg)
  class(group_type), intent(in) :: grp
  integer, intent(in) :: unit
  character(len=*), intent(in) :: iotype
  integer, intent(in) :: v_list(:)
  integer, intent(out) :: iostat
  character(len=*), intent(inout) :: iomsg
  character(len=:), allocatable :: text

  associate (ignored_v_list => v_list)
  end associate
  iostat = 1
  if (iotype /= "LISTDIRECTED" .and. iotype /= "DT") return
  text = render_grp_(grp, 0)
  write (unit, "(a)", iostat=iostat, iomsg=iomsg) text
end subroutine write_frmt_grp

!> Write an operation result in formatted derived-type I/O.
module subroutine write_frmt_error(error, unit, iotype, v_list, iostat, iomsg)
  class(error_type), intent(in) :: error
  integer, intent(in) :: unit
  character(len=*), intent(in) :: iotype
  integer, intent(in) :: v_list(:)
  integer, intent(out) :: iostat
  character(len=*), intent(inout) :: iomsg

  associate (ignored_v_list => v_list)
  end associate
  iostat = 1
  if (iotype /= "LISTDIRECTED" .and. iotype /= "DT") return
  if (error%code == NC_NOERR) then
    write (unit, "('NetCDF status (', i0, ')')", iostat=iostat, iomsg=iomsg) error%code
  else if (allocated(error%message)) then
    write (unit, "('NetCDF error (', i0, '): ', a)", iostat=iostat, iomsg=iomsg) &
      & error%code, trim(error%message)
  else
    write (unit, "('NetCDF status (', i0, ')')", iostat=iostat, iomsg=iomsg) error%code
  end if
end subroutine write_frmt_error

recursive function render_grp_(grp, depth) result(text)
  class(group_type), intent(in) :: grp
  integer, intent(in) :: depth
  character(len=:), allocatable :: text
  character(len=:), allocatable :: indent, name
  integer :: i

  indent = repeat(" ", 2 * depth)
  name = "/"
  if (allocated(grp%name)) name = grp%name
  text = indent//"group: "//trim(name)//" {"//new_line('a')

  if (allocated(grp%dims)) then
    if (size(grp%dims) > 0) then
      text = text//indent//"  dimensions:"//new_line('a')
      do i = 1, size(grp%dims)
        text = text//render_dim_(grp%dims(i), indent//"    ")//new_line('a')
      end do
    end if
  end if
  if (allocated(grp%vars)) then
    if (size(grp%vars) > 0) then
      text = text//indent//"  variables:"//new_line('a')
      do i = 1, size(grp%vars)
        text = text//render_var_(grp%vars(i), indent//"    ")//new_line('a')
      end do
    end if
  end if
  if (allocated(grp%atts)) then
    if (size(grp%atts) > 0) then
      text = text//indent//"  // global attributes:"//new_line('a')
      do i = 1, size(grp%atts)
        text = text//render_att_(grp%atts(i), indent//"    ")//new_line('a')
      end do
    end if
  end if
  if (associated(grp%grps)) then
    if (size(grp%grps) > 0) then
      text = text//indent//"  groups:"//new_line('a')
      do i = 1, size(grp%grps)
        text = text//render_grp_(grp%grps(i), depth + 1)//new_line('a')
      end do
    end if
  end if
  text = text//indent//"}"
end function render_grp_

function render_dim_(dim, indent) result(line)
  type(dimension_type), intent(in) :: dim
  character(len=*), intent(in) :: indent
  character(len=:), allocatable :: line
  character(len=64) :: len_text

  write (len_text, "(i0)") dim%len
  if (dim%is_unlim) then
    line = indent//dim%name//" = UNLIMITED ; // ("//trim(len_text)//" currently)"
  else
    line = indent//dim%name//" = "//trim(len_text)//" ;"
  end if
end function render_dim_

function render_att_(att, indent) result(line)
  type(attribute_type), intent(in) :: att
  character(len=*), intent(in) :: indent
  character(len=:), allocatable :: line
  character(len=16) :: dtype

  call type_name_(att%dtype, dtype)
  line = indent//trim(dtype)//" :: "//att%name//" ;"
end function render_att_

function render_var_(var, indent) result(line)
  type(variable_type), intent(in) :: var
  character(len=*), intent(in) :: indent
  character(len=:), allocatable :: line
  character(len=16) :: dtype
  character(len=:), allocatable :: dims
  integer :: i

  call type_name_(var%dtype, dtype)
  dims = ""
  if (allocated(var%dims)) then
    if (size(var%dims) > 0) then
      dims = "("
      do i = 1, size(var%dims)
        if (i > 1) dims = dims//", "
        dims = dims//trim(var%dims(i)%name)
      end do
      dims = dims//")"
    end if
  end if
  line = indent//trim(dtype)//" "//var%name//dims//" ;"
end function render_var_

subroutine write_dim_(dim, unit, indent, iostat, iomsg)
  type(dimension_type), intent(in) :: dim
  integer, intent(in) :: unit
  character(len=*), intent(in) :: indent
  integer, intent(out) :: iostat
  character(len=*), intent(inout) :: iomsg

  if (dim%is_unlim) then
    write (unit, "(a, a, ' = UNLIMITED ; // (', i0, ' currently)')", iostat=iostat, iomsg=iomsg) &
      & indent, dim%name, dim%len
  else
    write (unit, "(a, a, ' = ', i0, ' ;')", iostat=iostat, iomsg=iomsg) indent, dim%name, dim%len
  end if
end subroutine write_dim_

subroutine write_var_(var, unit, indent, iostat, iomsg)
  type(variable_type), intent(in) :: var
  integer, intent(in) :: unit
  character(len=*), intent(in) :: indent
  integer, intent(out) :: iostat
  character(len=*), intent(inout) :: iomsg
  character(len=16) :: dtype
  character(len=:), allocatable :: dims
  integer :: i

  call type_name_(var%dtype, dtype)
  dims = ""
  if (allocated(var%dims)) then
    if (size(var%dims) > 0) then
      dims = "("
      do i = 1, size(var%dims)
        if (i > 1) dims = dims//", "
        dims = dims//trim(var%dims(i)%name)
      end do
      dims = dims//")"
    end if
  end if
  write (unit, "(a, a, 1x, a, a, ' ;')", iostat=iostat, iomsg=iomsg) &
    & indent, trim(dtype), var%name, dims
end subroutine write_var_

subroutine type_name_(dtype, name)
  integer(data_type), intent(in) :: dtype
  character(len=*), intent(out) :: name

  select case (dtype)
  case (BYTE_TYPE)
    name = "byte"
  case (CHAR_TYPE)
    name = "char"
  case (SHORT_TYPE)
    name = "short"
  case (INT_TYPE)
    name = "int"
  case (INT64_TYPE)
    name = "int64"
  case (FLOAT_TYPE)
    name = "float"
  case (DOUBLE_TYPE)
    name = "double"
  case default
    name = "unknown"
  end select
end subroutine type_name_

end submodule nc4f_data_struct_io
