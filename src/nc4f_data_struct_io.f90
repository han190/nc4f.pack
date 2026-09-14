!> ncdump-like formatted output for the direct v2 data model.
submodule(nc4f_data_struct) nc4f_data_struct_io

implicit none (type, external)

contains

!> Execute `write_frmt_dim`.
module subroutine write_frmt_dim(dim, unit, iotype, v_list, iostat, iomsg)
  !> Input argument: `dim`.
  class(dimension_type), intent(in) :: dim
  !> Input argument: `unit`.
  integer, intent(in) :: unit
  !> Input argument: `iotype`.
  character(len=*), intent(in) :: iotype
  !> Input argument: `v_list`.
  integer, intent(in) :: v_list(:)
  !> Output argument: `iostat`.
  integer, intent(out) :: iostat
  !> Input/output argument: `iomsg`.
  character(len=*), intent(inout) :: iomsg

  associate (ignored_v_list => v_list)
  end associate
  iostat = 1
  if (iotype /= "LISTDIRECTED" .and. iotype /= "DT") return
  if (dim%is_unlim) then
    associate (fmt => "(a, ' = UNLIMITED ; // (', i0, ' currently)')")
      write (unit, fmt, iostat=iostat, iomsg=iomsg) dim%name, dim%len
    end associate
  else
    associate (fmt => "(a, ' = ', i0, ' ;')")
      write (unit, fmt, iostat=iostat, iomsg=iomsg) dim%name, dim%len
    end associate
  end if
end subroutine write_frmt_dim

!> Execute `write_frmt_att`.
module subroutine write_frmt_att(att, unit, iotype, v_list, iostat, iomsg)
  !> Input argument: `att`.
  class(attribute_type), intent(in) :: att
  !> Input argument: `unit`.
  integer, intent(in) :: unit
  !> Input argument: `iotype`.
  character(len=*), intent(in) :: iotype
  !> Input argument: `v_list`.
  integer, intent(in) :: v_list(:)
  !> Output argument: `iostat`.
  integer, intent(out) :: iostat
  !> Input/output argument: `iomsg`.
  character(len=*), intent(inout) :: iomsg
  character(len=16) :: dtype
  character(len=:), allocatable :: value

  associate (ignored_v_list => v_list)
  end associate
  iostat = 1
  if (iotype /= "LISTDIRECTED" .and. iotype /= "DT") return
  call type_name_(att%dtype, dtype)
  value = render_att_value_(att)
  write (unit, "(a, ' = ', a, ' ;')", iostat=iostat, iomsg=iomsg) &
    & trim(dtype)//":"//att%name, value
end subroutine write_frmt_att

!> Execute `write_frmt_var`.
module subroutine write_frmt_var(var, unit, iotype, v_list, iostat, iomsg)
  !> Input argument: `var`.
  class(variable_type), intent(in) :: var
  !> Input argument: `unit`.
  integer, intent(in) :: unit
  !> Input argument: `iotype`.
  character(len=*), intent(in) :: iotype
  !> Input argument: `v_list`.
  integer, intent(in) :: v_list(:)
  !> Output argument: `iostat`.
  integer, intent(out) :: iostat
  !> Input/output argument: `iomsg`.
  character(len=*), intent(inout) :: iomsg
  character(len=:), allocatable :: text

  associate (ignored_v_list => v_list)
  end associate
  iostat = 1
  if (iotype /= "LISTDIRECTED" .and. iotype /= "DT") return
  text = render_var_(var, "")
  write (unit, "(a)", iostat=iostat, iomsg=iomsg) text
end subroutine write_frmt_var

!> Execute `write_frmt_grp`.
module subroutine write_frmt_grp(grp, unit, iotype, v_list, iostat, iomsg)
  !> Input argument: `grp`.
  class(group_type), intent(in) :: grp
  !> Input argument: `unit`.
  integer, intent(in) :: unit
  !> Input argument: `iotype`.
  character(len=*), intent(in) :: iotype
  !> Input argument: `v_list`.
  integer, intent(in) :: v_list(:)
  !> Output argument: `iostat`.
  integer, intent(out) :: iostat
  !> Input/output argument: `iomsg`.
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
  !> Input argument: `error`.
  class(error_type), intent(in) :: error
  !> Input argument: `unit`.
  integer, intent(in) :: unit
  !> Input argument: `iotype`.
  character(len=*), intent(in) :: iotype
  !> Input argument: `v_list`.
  integer, intent(in) :: v_list(:)
  !> Output argument: `iostat`.
  integer, intent(out) :: iostat
  !> Input/output argument: `iomsg`.
  character(len=*), intent(inout) :: iomsg

  associate (ignored_v_list => v_list)
  end associate
  iostat = 1
  if (iotype /= "LISTDIRECTED" .and. iotype /= "DT") return
  if (error%code == NC_NOERR) then
    associate (fmt => "('NetCDF status (', i0, ')')")
      write (unit, fmt, iostat=iostat, iomsg=iomsg) error%code
    end associate
  else if (allocated(error%message)) then
    associate (fmt => "('NetCDF error (', i0, '): ', a)")
      write (unit, fmt, iostat=iostat, iomsg=iomsg) &
        & error%code, trim(error%message)
    end associate
  else
    associate (fmt => "('NetCDF status (', i0, ')')")
      write (unit, fmt, iostat=iostat, iomsg=iomsg) error%code
    end associate
  end if
end subroutine write_frmt_error

!> Compute `render_grp_`.
recursive function render_grp_(grp, depth) result(text)
  !> Input argument: `grp`.
  class(group_type), intent(in) :: grp
  !> Input argument: `depth`.
  integer, intent(in) :: depth
  !> Return value: `text`.
  character(len=:), allocatable :: text
  character(len=:), allocatable :: indent, name
  integer :: i

  indent = repeat(" ", 4*depth)
  name = "/"
  if (allocated(grp%name)) name = grp%name
  text = indent//"group: "//trim(name)//" {"//new_line('a')

  if (allocated(grp%dims)) then
    if (size(grp%dims) > 0) then
      text = text//indent//"dimensions:"//new_line('a')
      do i = 1, size(grp%dims)
        text = text//render_dim_(grp%dims(i), indent//"    ")//new_line('a')
      end do
    end if
  end if
  if (allocated(grp%vars)) then
    if (size(grp%vars) > 0) then
      text = text//indent//"variables:"//new_line('a')
      do i = 1, size(grp%vars)
        text = text//render_var_(grp%vars(i), indent//"    ")//new_line('a')
      end do
    end if
  end if
  if (allocated(grp%atts)) then
    if (size(grp%atts) > 0) then
      text = text//indent//"// global attributes:"//new_line('a')
      do i = 1, size(grp%atts)
        text = text//render_att_(grp%atts(i), indent//"    ")//new_line('a')
      end do
    end if
  end if
  if (associated(grp%grps)) then
    if (size(grp%grps) > 0) then
      text = text//indent//"groups:"//new_line('a')
      do i = 1, size(grp%grps)
        text = text//render_grp_(grp%grps(i), depth + 1)//new_line('a')
      end do
    end if
  end if
  text = text//indent//"}"
end function render_grp_

!> Compute `render_dim_`.
function render_dim_(dim, indent) result(line)
  !> Input argument: `dim`.
  type(dimension_type), intent(in) :: dim
  !> Input argument: `indent`.
  character(len=*), intent(in) :: indent
  !> Return value: `line`.
  character(len=:), allocatable :: line
  character(len=64) :: len_text

  write (len_text, "(i0)") dim%len
  if (dim%is_unlim) then
    line = indent//dim%name//" = UNLIMITED ; // ("//trim(len_text)//" currently)"
  else
    line = indent//dim%name//" = "//trim(len_text)//" ;"
  end if
end function render_dim_

!> Compute `render_att_`.
function render_att_(att, indent) result(line)
  !> Input argument: `att`.
  type(attribute_type), intent(in) :: att
  !> Input argument: `indent`.
  character(len=*), intent(in) :: indent
  !> Return value: `line`.
  character(len=:), allocatable :: line
  character(len=16) :: dtype

  call type_name_(att%dtype, dtype)
  line = indent//trim(dtype)//":"//att%name//" = "//render_att_value_(att)//" ;"
end function render_att_

!> Render an attribute buffer as an ncdump-like literal.
function render_att_value_(att) result(rendered)
  !> Input argument: `att`.
  type(attribute_type), intent(in) :: att
  !> Return value: `value`.
  character(len=:), allocatable :: rendered
  character, allocatable :: chars(:)
  integer(int8), allocatable :: int8_values(:)
  integer(int16), allocatable :: int16_values(:)
  integer(int32), allocatable :: int32_values(:)
  integer(int64), allocatable :: int64_values(:)
  real(real32), allocatable :: real32_values(:)
  real(real64), allocatable :: real64_values(:)
  integer :: nbytes

  if (att%len < 0) then
    rendered = "invalid length"
    return
  end if
  if (att%len == 0) then
    if (att%dtype == CHAR_TYPE) then
      rendered = '""'
    else
      rendered = "[]"
    end if
    return
  end if
  if (.not. associated(att%buffer)) then
    rendered = "unavailable"
    return
  end if

  select case (att%dtype)
  case (BYTE_TYPE, CHAR_TYPE, SHORT_TYPE, INT_TYPE, INT64_TYPE, FLOAT_TYPE, DOUBLE_TYPE)
    nbytes = buffer_size(att%dtype, att%len, "[render_att_value]")
    if (size(att%buffer, kind=int64) < int(nbytes, int64)) then
      rendered = "unavailable"
      return
    end if
  case default
    rendered = "unsupported"
    return
  end select

  select case (att%dtype)
  case (BYTE_TYPE)
    int8_values = transfer(att%buffer, 0_int8, int(att%len))
    rendered = render_int8_values_(int8_values)
  case (CHAR_TYPE)
    chars = transfer(att%buffer, ' ', int(att%len))
    rendered = render_char_values_(chars)
  case (SHORT_TYPE)
    int16_values = transfer(att%buffer, 0_int16, int(att%len))
    rendered = render_int16_values_(int16_values)
  case (INT_TYPE)
    int32_values = transfer(att%buffer, 0_int32, int(att%len))
    rendered = render_int32_values_(int32_values)
  case (INT64_TYPE)
    int64_values = transfer(att%buffer, 0_int64, int(att%len))
    rendered = render_int64_values_(int64_values)
  case (FLOAT_TYPE)
    real32_values = transfer(att%buffer, 0.0_real32, int(att%len))
    rendered = render_real32_values_(real32_values)
  case (DOUBLE_TYPE)
    real64_values = transfer(att%buffer, 0.0_real64, int(att%len))
    rendered = render_real64_values_(real64_values)
  end select
end function render_att_value_

!> Render a character attribute as a quoted string.
function render_char_values_(values) result(text)
  !> Input argument: `values`.
  character, intent(in) :: values(:)
  !> Return value: `text`.
  character(len=:), allocatable :: text
  integer :: i, last

  last = size(values)
  do while (last > 0)
    if (values(last) /= achar(0)) exit
    last = last - 1
  end do
  text = '"'
  do i = 1, last
    select case (values(i))
    case ('"')
      text = text//'\"'
    case ('\')
      text = text//'\\'
    case (achar(0))
      text = text//'\0'
    case (new_line('a'))
      text = text//'\n'
    case default
      text = text//values(i)
    end select
  end do
  text = text//'"'
end function render_char_values_

!> Render integer(kind=int8) attribute values.
function render_int8_values_(values) result(text)
  integer(int8), intent(in) :: values(:)
  character(len=:), allocatable :: text
  character(len=64) :: item
  integer :: i

  text = ""
  do i = 1, size(values)
    if (i > 1) text = text//", "
    write (item, "(i0)") values(i)
    text = text//trim(item)
  end do
end function render_int8_values_

!> Render integer(kind=int16) attribute values.
function render_int16_values_(values) result(text)
  integer(int16), intent(in) :: values(:)
  character(len=:), allocatable :: text
  character(len=64) :: item
  integer :: i

  text = ""
  do i = 1, size(values)
    if (i > 1) text = text//", "
    write (item, "(i0)") values(i)
    text = text//trim(item)
  end do
end function render_int16_values_

!> Render integer(kind=int32) attribute values.
function render_int32_values_(values) result(text)
  integer(int32), intent(in) :: values(:)
  character(len=:), allocatable :: text
  character(len=64) :: item
  integer :: i

  text = ""
  do i = 1, size(values)
    if (i > 1) text = text//", "
    write (item, "(i0)") values(i)
    text = text//trim(item)
  end do
end function render_int32_values_

!> Render integer(kind=int64) attribute values.
function render_int64_values_(values) result(text)
  integer(int64), intent(in) :: values(:)
  character(len=:), allocatable :: text
  character(len=64) :: item
  integer :: i

  text = ""
  do i = 1, size(values)
    if (i > 1) text = text//", "
    write (item, "(i0)") values(i)
    text = text//trim(item)
  end do
end function render_int64_values_

!> Render real(kind=real32) attribute values.
function render_real32_values_(values) result(text)
  real(real32), intent(in) :: values(:)
  character(len=:), allocatable :: text
  character(len=64) :: item
  integer :: i

  text = ""
  do i = 1, size(values)
    if (i > 1) text = text//", "
    write (item, "(g0.15)") values(i)
    text = text//trim_trailing_zeros_(item)
  end do
end function render_real32_values_

!> Render real(kind=real64) attribute values.
function render_real64_values_(values) result(text)
  real(real64), intent(in) :: values(:)
  character(len=:), allocatable :: text
  character(len=64) :: item
  integer :: i

  text = ""
  do i = 1, size(values)
    if (i > 1) text = text//", "
    write (item, "(g0.15)") values(i)
    text = text//trim_trailing_zeros_(item)
  end do
end function render_real64_values_

!> Remove redundant fractional zeroes from a formatted real literal.
!>
!> An integral finite value retains one digit after its decimal point. Any
!> exponent suffix is retained without modification.
function trim_trailing_zeros_(text) result(trimmed)
  !> Input argument: `text`.
  character(len=*), intent(in) :: text
  !> Return value: `trimmed`.
  character(len=:), allocatable :: trimmed
  character(len=:), allocatable :: exponent, mantissa
  integer :: decimal_at, exponent_at, last

  trimmed = trim(text)
  exponent_at = scan(trimmed, "EeDd")
  if (exponent_at > 0) then
    mantissa = trimmed(:exponent_at - 1)
    exponent = trimmed(exponent_at:)
  else
    mantissa = trimmed
    exponent = ""
  end if

  decimal_at = index(mantissa, ".")
  if (decimal_at == 0) then
    if (len(mantissa) > 0 .and. verify(mantissa, "+-0123456789") == 0) then
      mantissa = mantissa//".0"
    end if
    trimmed = mantissa//exponent
    return
  end if

  last = len(mantissa)
  do while (last > decimal_at .and. mantissa(last:last) == "0")
    last = last - 1
  end do
  if (last == decimal_at) then
    mantissa = mantissa(:decimal_at)//"0"
  else
    mantissa = mantissa(:last)
  end if
  trimmed = mantissa//exponent
end function trim_trailing_zeros_

!> Compute `render_var_`.
function render_var_(var, indent) result(line)
  !> Input argument: `var`.
  type(variable_type), intent(in) :: var
  !> Input argument: `indent`.
  character(len=*), intent(in) :: indent
  !> Return value: `line`.
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
  if (allocated(var%atts)) then
    do i = 1, size(var%atts)
      line = line//new_line('a')//render_att_(var%atts(i), indent//"    ")
    end do
  end if
end function render_var_

!> Execute `type_name_`.
subroutine type_name_(dtype, name)
  !> Input argument: `dtype`.
  integer(data_type), intent(in) :: dtype
  !> Output argument: `name`.
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
