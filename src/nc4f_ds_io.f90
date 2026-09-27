!> ncdump-like formatted output for the direct v2 data model.
submodule(nc4f_ds) nc4f_ds_io
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
  call type_name(att%dtype, dtype)
  value = render_att_value(att)
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
  text = render_var(var, "")
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
  text = render_grp(grp, 0)
  write (unit, "(a)", iostat=iostat, iomsg=iomsg) text
end subroutine write_frmt_grp

!> Execute `write_frmt_netcdf`.
module subroutine write_frmt_netcdf(grp, unit, iotype, v_list, iostat, iomsg)
  !> Input argument: `grp`.
  class(netcdf_type), intent(in) :: grp
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
  text = render_netcdf(grp)
  write (unit, "(a)", iostat=iostat, iomsg=iomsg) text
end subroutine write_frmt_netcdf

!> Write an operation result in formatted derived-type I/O.
module subroutine write_frmt_err(err, unit, iotype, v_list, iostat, iomsg)
  !> Input argument: `err`.
  class(error_type), intent(in) :: err
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
  if (err%code == NC_NOERR) then
    associate (fmt => "('NetCDF status (', i0, ')')")
      write (unit, fmt, iostat=iostat, iomsg=iomsg) err%code
    end associate
  else if (allocated(err%msg)) then
    associate (fmt => "('NetCDF error (', i0, '): ', a)")
      write (unit, fmt, iostat=iostat, iomsg=iomsg) &
        & err%code, trim(err%msg)
    end associate
  else
    associate (fmt => "('NetCDF status (', i0, ')')")
      write (unit, fmt, iostat=iostat, iomsg=iomsg) err%code
    end associate
  end if
end subroutine write_frmt_err

!> Compute `render_grp`.
recursive function render_grp(grp, depth) result(text)
  !> Input argument: `grp`.
  class(group_type), intent(in) :: grp
  !> Input argument: `depth`.
  integer, intent(in) :: depth
  !> Return value: `text`.
  character(len=:), allocatable :: text
  character(len=:), allocatable :: indent, name

  indent = repeat(" ", 4*depth)
  name = "/"
  if (allocated(grp%name)) name = grp%name
  text = indent//"group: "//trim(name)//" {"//new_line("a")

  text = text//render_grp_(grp, indent, depth)
  text = text//indent//"}"
end function render_grp

!> Compute the ncdump-like representation of an open NetCDF dataset.
function render_netcdf(nc) result(text)
  !> Input argument: `nc`.
  type(netcdf_type), intent(in) :: nc
  !> Return value: `text`.
  character(len=:), allocatable :: text
  character(len=:), allocatable :: name

  name = "unnamed"
  if (allocated(nc%file)) name = filename_stem(nc%file)
  text = "netcdf "//name//" {"//new_line("a")
  text = text//render_grp_(nc, "", 0)
  text = text//"}"
end function render_netcdf

!> Compute the contents of a group in ncdump-like formatted output.
recursive function render_grp_(grp, indent, depth) result(text)
  !> Input argument: `grp`.
  class(group_type), intent(in) :: grp
  !> Input argument: `indent`.
  character(len=*), intent(in) :: indent
  !> Input argument: `depth`.
  integer, intent(in) :: depth
  !> Return value: `text`.
  character(len=:), allocatable :: text
  character, allocatable :: buffer(:)
  integer :: i, used
  character, parameter :: nl = new_line("a")

  used = 0

  call append(buffer, used, render_dims(grp, indent))
  call append(buffer, used, render_vars(grp, indent))
  call append(buffer, used, render_atts(grp, indent))

  if (associated(grp%grps)) then
    if (size(grp%grps) > 0) then
      call append(buffer, used, indent//"groups:"//nl)
      do i = 1, size(grp%grps)
        call append(buffer, used, render_grp(grp%grps(i), depth + 1)//nl)
      end do
    end if
  end if

  if (used == 0) then
    text = ""
  else
    text = transfer(buffer(:used), repeat(" ", used))
  end if
end function render_grp_

!> Compute the dimensions section of a group in ncdump-like formatted output.
function render_dims(grp, indent) result(text)
  !> Input argument: `grp`.
  class(group_type), intent(in) :: grp
  !> Input argument: `indent`.
  character(len=*), intent(in) :: indent
  !> Return value: `text`.
  character(len=:), allocatable :: text
  character, allocatable :: buffer(:)
  integer :: i, used
  character(len=:), allocatable :: ind
  character, parameter :: nl = new_line("a")

  used = 0
  ind = indent//repeat(" ", 4)
  if (allocated(grp%dims)) then
    if (size(grp%dims) > 0) then
      call append(buffer, used, indent//"dimensions:"//nl)
      do i = 1, size(grp%dims)
        call append(buffer, used, render_dim(grp%dims(i), ind)//nl)
      end do
    end if
  end if

  if (used == 0) then
    text = ""
  else
    text = transfer(buffer(:used), repeat(" ", used))
  end if
end function render_dims

!> Compute the variables section of a group in ncdump-like formatted output.
function render_vars(grp, indent) result(text)
  !> Input argument: `grp`.
  class(group_type), intent(in) :: grp
  !> Input argument: `indent`.
  character(len=*), intent(in) :: indent
  !> Return value: `text`.
  character(len=:), allocatable :: text
  character, allocatable :: buffer(:)
  integer :: i, used
  character(len=:), allocatable :: ind
  character, parameter :: nl = new_line("a")

  used = 0
  ind = indent//repeat(" ", 4)
  if (allocated(grp%vars)) then
    if (size(grp%vars) > 0) then
      call append(buffer, used, indent//"variables:"//nl)
      do i = 1, size(grp%vars)
        call append(buffer, used, render_var(grp%vars(i), ind)//nl)
      end do
    end if
  end if

  if (used == 0) then
    text = ""
  else
    text = transfer(buffer(:used), repeat(" ", used))
  end if
end function render_vars

!> Compute the attributes section of a group in ncdump-like formatted output.
function render_atts(grp, indent) result(text)
  !> Input argument: `grp`.
  class(group_type), intent(in) :: grp
  !> Input argument: `indent`.
  character(len=*), intent(in) :: indent
  !> Return value: `text`.
  character(len=:), allocatable :: text
  character, allocatable :: buffer(:)
  integer :: i, used
  character(len=:), allocatable :: ind
  character, parameter :: nl = new_line("a")

  used = 0
  ind = indent//repeat(" ", 4)
  if (allocated(grp%atts)) then
    if (size(grp%atts) > 0) then
      call append(buffer, used, indent//"// global attributes:"//nl)
      do i = 1, size(grp%atts)
        call append(buffer, used, render_att(grp%atts(i), ind)//nl)
      end do
    end if
  end if

  if (used == 0) then
    text = ""
  else
    text = transfer(buffer(:used), repeat(" ", used))
  end if
end function render_atts

!> Append a text fragment to a dynamically grown character buffer.
subroutine append(buffer, used, fragment)
  !> Storage for the text accumulated so far.
  character, allocatable, intent(inout) :: buffer(:)
  !> Number of occupied characters in `buffer`.
  integer, intent(inout) :: used
  !> Text to append.
  character(len=*), intent(in) :: fragment
  character, allocatable :: expanded(:)
  integer :: capacity, i, needed

  if (len(fragment) == 0) return
  needed = used + len(fragment)
  if (.not. allocated(buffer)) then
    allocate (buffer(max(256, needed)))
  else if (size(buffer) < needed) then
    capacity = max(2*size(buffer), needed)
    allocate (expanded(capacity))
    if (used > 0) expanded(:used) = buffer(:used)
    call move_alloc(expanded, buffer)
  end if

  do i = 1, len(fragment)
    buffer(used + i) = fragment(i:i)
  end do
  used = needed
end subroutine append

!> Return the final path component of a file without its final extension.
function filename_stem(file) result(stem)
  !> Input argument: `file`.
  character(len=*), intent(in) :: file
  !> Return value: `stem`.
  character(len=:), allocatable :: stem
  integer :: base, extension, filename_len

  filename_len = len_trim(file)
  if (filename_len == 0) then
    stem = "unnamed"
    return
  end if
  base = scan(file(:filename_len), "/", back=.true.) + 1
  if (base > filename_len) then
    stem = "unnamed"
    return
  end if

  stem = file(base:filename_len)
  extension = index(stem, ".", back=.true.)
  if (extension > 1) stem = stem(:extension - 1)
  if (len(stem) == 0) stem = "unnamed"
end function filename_stem

!> Compute `render_dim`.
function render_dim(dim, indent) result(line)
  !> Input argument: `dim`.
  type(dimension_type), intent(in) :: dim
  !> Input argument: `indent`.
  character(len=*), intent(in) :: indent
  !> Return value: `line`.
  character(len=:), allocatable :: line
  character(len=64) :: len_text

  write (len_text, "(i0)") dim%len
  if (dim%is_unlim) then
    associate (unlim => " = UNLIMITED ; // (")
      line = indent//dim%name//unlim//trim(len_text)//" currently)"
    end associate
  else
    line = indent//dim%name//" = "//trim(len_text)//" ;"
  end if
end function render_dim

!> Compute `render_att`.
function render_att(att, indent) result(line)
  !> Input argument: `att`.
  type(attribute_type), intent(in) :: att
  !> Input argument: `indent`.
  character(len=*), intent(in) :: indent
  !> Return value: `line`.
  character(len=:), allocatable :: line
  character(len=16) :: dtype

  call type_name(att%dtype, dtype)
  line = indent//trim(dtype)//":"//att%name//" = "//render_att_value(att)//" ;"
end function render_att

!> Render an attribute buffer as an ncdump-like literal.
function render_att_value(att) result(rendered)
  !> Input argument: `att`.
  type(attribute_type), target, intent(in) :: att
  !> Return value: `value`.
  character(len=:), allocatable :: rendered
  character, allocatable :: chars(:)
  integer(int8), allocatable :: int8_values(:)
  integer(int16), allocatable :: int16_values(:)
  integer(int32), allocatable :: int32_values(:)
  integer(int64), allocatable :: int64_values(:)
  real(real32), allocatable :: real32_values(:)
  real(real64), allocatable :: real64_values(:)
  integer(int8), pointer, contiguous :: bytes(:)
  call validate(att, context="[render_att_value]")
  if (att%len == 0) then
    if (att%dtype == CHAR_TYPE) then
      rendered = '""'
    else
      rendered = "[]"
    end if
    return
  end if
  if (allocated(att%buffer)) then
    bytes => att%buffer
  else
    bytes => att%ptr
  end if

  select case (att%dtype)
  case (BYTE_TYPE, CHAR_TYPE, SHORT_TYPE, &
    & INT_TYPE, INT64_TYPE, FLOAT_TYPE, DOUBLE_TYPE)
  case default
    rendered = "unsupported"
    return
  end select

  select case (att%dtype)
  case (BYTE_TYPE)
    int8_values = transfer(bytes, 0_int8, int(att%len))
    rendered = render_int8_values(int8_values)
  case (CHAR_TYPE)
    chars = transfer(bytes, " ", int(att%len))
    rendered = render_char_values(chars)
  case (SHORT_TYPE)
    int16_values = transfer(bytes, 0_int16, int(att%len))
    rendered = render_int16_values(int16_values)
  case (INT_TYPE)
    int32_values = transfer(bytes, 0_int32, int(att%len))
    rendered = render_int32_values(int32_values)
  case (INT64_TYPE)
    int64_values = transfer(bytes, 0_int64, int(att%len))
    rendered = render_int64_values(int64_values)
  case (FLOAT_TYPE)
    real32_values = transfer(bytes, 0.0_real32, int(att%len))
    rendered = render_real32_values(real32_values)
  case (DOUBLE_TYPE)
    real64_values = transfer(bytes, 0.0_real64, int(att%len))
    rendered = render_real64_values(real64_values)
  case default
    rendered = "unsupported"
  end select
end function render_att_value

!> Render a character attribute as a quoted string.
function render_char_values(values) result(text)
  !> Input argument: `values`.
  character, intent(in) :: values(:)
  !> Return value: `text`.
  character(len=:), allocatable :: text
  integer :: i, last, position, text_len

  last = size(values)
  do while (last > 0)
    if (values(last) /= achar(0)) exit
    last = last - 1
  end do
  text_len = 2
  do i = 1, last
    select case (values(i))
    case ('"', "\", achar(0), new_line("a"))
      text_len = text_len + 2
    case default
      text_len = text_len + 1
    end select
  end do

  allocate (character(len=text_len) :: text)
  text(1:1) = '"'
  position = 2
  do i = 1, last
    select case (values(i))
    case ('"')
      text(position:position + 1) = '\"'
      position = position + 2
    case ("\")
      text(position:position + 1) = "\\"
      position = position + 2
    case (achar(0))
      text(position:position + 1) = "\0"
      position = position + 2
    case (new_line("a"))
      text(position:position + 1) = "\n"
      position = position + 2
    case default
      text(position:position) = values(i)
      position = position + 1
    end select
  end do
  text(position:position) = '"'
end function render_char_values

!> Render integer(kind=int8) attribute values.
function render_int8_values(values) result(text)
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
end function render_int8_values

!> Render integer(kind=int16) attribute values.
function render_int16_values(values) result(text)
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
end function render_int16_values

!> Render integer(kind=int32) attribute values.
function render_int32_values(values) result(text)
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
end function render_int32_values

!> Render integer(kind=int64) attribute values.
function render_int64_values(values) result(text)
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
end function render_int64_values

!> Render real(kind=real32) attribute values.
function render_real32_values(values) result(text)
  real(real32), intent(in) :: values(:)
  character(len=:), allocatable :: text
  character(len=64) :: item
  integer :: i

  text = ""
  do i = 1, size(values)
    if (i > 1) text = text//", "
    write (item, "(g0.15)") values(i)
    text = text//trim_trailing_zeros(item)
  end do
end function render_real32_values

!> Render real(kind=real64) attribute values.
function render_real64_values(values) result(text)
  real(real64), intent(in) :: values(:)
  character(len=:), allocatable :: text
  character(len=64) :: item
  integer :: i

  text = ""
  do i = 1, size(values)
    if (i > 1) text = text//", "
    write (item, "(g0.15)") values(i)
    text = text//trim_trailing_zeros(item)
  end do
end function render_real64_values

!> Remove redundant fractional zeroes from a formatted real literal.
!>
!> An integral finite value retains one digit after its decimal point. Any
!> exponent suffix is retained without modification.
function trim_trailing_zeros(text) result(trimmed)
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
end function trim_trailing_zeros

!> Compute `render_var`.
function render_var(var, indent) result(line)
  !> Input argument: `var`.
  type(variable_type), intent(in) :: var
  !> Input argument: `indent`.
  character(len=*), intent(in) :: indent
  !> Return value: `line`.
  character(len=:), allocatable :: line
  character(len=16) :: dtype
  character(len=:), allocatable :: dims
  integer :: i

  call type_name(var%dtype, dtype)
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
      line = line//new_line("a")//render_att(var%atts(i), indent//"    ")
    end do
  end if
end function render_var

!> Execute `type_name`.
subroutine type_name(dtype, name)
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
end subroutine type_name

end submodule nc4f_ds_io
