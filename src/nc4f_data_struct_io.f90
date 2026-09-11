submodule(nc4f_data_struct) nc4f_data_struct_io
implicit none (type, external)
contains

!> Write a `variable_type` in list-directed (Fortran `DT`) format.
module subroutine write_frmt_var(var, unit, iotype, v_list, iostat, iomsg)
  !> Variable object to format and write.
  class(variable_type), intent(in) :: var
  !> Output unit number.
  integer, intent(in) :: unit
  !> I/O type string (e.g. 'LISTDIRECTED' or 'DT').
  character(len=*), intent(in) :: iotype
  !> Optional list descriptor (passed by the formatted write interface).
  integer, intent(in) :: v_list(:)
  !> I/O status returned (0 for success).
  integer, intent(out) :: iostat
  !> I/O message buffer (in/out).
  character(len=*), intent(inout) :: iomsg
  integer :: i, n
  character(len=MAX_CHAR_LEN) :: title, dims, ndims, fmt, type_kind

  associate (v_list_ => v_list, iomsg_ => iomsg)
  end associate

  iostat = 999
  if (iotype == 'LISTDIRECTED' .or. iotype == 'DT') then
    call type_kind_str(var%dtype, type_kind)
    write (title, "(a, '::', a)") trim(type_kind), var%name

    n = size(var%dims)
    if (n > 1) then
      write (ndims, "(i0)") n - 1
      fmt = "(1x, '(', "//trim(ndims)//"(DT, ',', 1x), DT, ')')"
    else if (n == 1) then
      write (ndims, "(i0)") n
      fmt = "(1x, '(', DT, ')')"
    else if (n == 0) then
      error stop "[write_frmt_var] Invalid dimension."
    end if
    write (dims, fmt) (var%dims(i), i=1, n)
    write (unit, "(a)") trim(title)//trim(dims)
    if (allocated(var%atts)) then
      if (size(var%atts) > 0) &
        & write (unit, "(/, *(4x, DT))") var%atts
    end if
    iostat = 0
  end if
end subroutine write_frmt_var

!> Write an `attribute_type` in list-directed (Fortran `DT`) format.
module subroutine write_frmt_att(att, unit, iotype, v_list, iostat, iomsg)
  !> Attribute object to format and write.
  class(attribute_type), intent(in) :: att
  !> Output unit number.
  integer, intent(in) :: unit
  !> I/O type string (e.g. 'LISTDIRECTED' or 'DT').
  character(len=*), intent(in) :: iotype
  !> Optional list descriptor (passed by the formatted write interface).
  integer, intent(in) :: v_list(:)
  !> I/O status returned (0 for success).
  integer, intent(out) :: iostat
  !> I/O message buffer (in/out).
  character(len=*), intent(inout) :: iomsg
  character(len=MAX_CHAR_LEN) :: type_kind, fmt

  associate (v_list_ => v_list, iomsg_ => iomsg)
  end associate

  iostat = 999
  if (iotype == 'LISTDIRECTED' .or. iotype == 'DT') then
    call type_kind_str(att%dtype, type_kind)
    select case (att%dtype)
    case (FLOAT_TYPE, DOUBLE_TYPE)
      fmt = "(a, '::', a, 1x, '=', *(1x, g0.6))"
    case (BYTE_TYPE, SHORT_TYPE, INT_TYPE, INT64_TYPE)
      fmt = "(a, '::', a, 1x, '=', *(1x, i0))"
    case (CHAR_TYPE)
      fmt = "(4(g0), 1x, '=', 1x, *(a))"
    end select

    select case (att%dtype)
    case (FLOAT_TYPE)
      block
        real(real32), pointer :: ptr(:)
        call extract(att, ptr)
        write (unit, fmt) trim(type_kind), att%name, ptr
      end block
    case (DOUBLE_TYPE)
      block
        real(real64), pointer :: ptr(:)
        call extract(att, ptr)
        write (unit, fmt) trim(type_kind), att%name, ptr
      end block
    case (BYTE_TYPE)
      block
        integer(int8), pointer :: ptr(:)
        call extract(att, ptr)
        write (unit, fmt) trim(type_kind), att%name, ptr
      end block
    case (SHORT_TYPE)
      block
        integer(int16), pointer :: ptr(:)
        call extract(att, ptr)
        write (unit, fmt) trim(type_kind), att%name, ptr
      end block
    case (INT_TYPE)
      block
        integer(int32), pointer :: ptr(:)
        call extract(att, ptr)
        write (unit, fmt) trim(type_kind), att%name, ptr
      end block
    case (INT64_TYPE)
      block
        integer(int64), pointer :: ptr(:)
        call extract(att, ptr)
        write (unit, fmt) trim(type_kind), att%name, ptr
      end block
    case (CHAR_TYPE)
      block
        character, pointer :: ptr(:)
        call extract(att, ptr)
        write (unit, fmt) 'character(len=', att%len, ')::', att%name, ptr
      end block
    case default
      error stop "[write_frmt_att] Invalid attribute type."
    end select
    iostat = 0
  end if
end subroutine write_frmt_att

!> Write a `dimension_type` in list-directed (Fortran `DT`) format.
module subroutine write_frmt_dim(dim, unit, iotype, v_list, iostat, iomsg)
  !> Dimension object to format and write.
  class(dimension_type), intent(in) :: dim
  !> Output unit number.
  integer, intent(in) :: unit
  !> I/O type string (e.g. 'LISTDIRECTED' or 'DT').
  character(len=*), intent(in) :: iotype
  !> Optional list descriptor (passed by the formatted write interface).
  integer, intent(in) :: v_list(:)
  !> I/O status returned (0 for success).
  integer, intent(out) :: iostat
  !> I/O message buffer (in/out).
  character(len=*), intent(inout) :: iomsg
  !> Temporary format buffer.
  character(len=MAX_CHAR_LEN) :: fmt

  associate (v_list_ => v_list, iomsg_ => iomsg)
  end associate

  iostat = 999
  if (iotype == 'LISTDIRECTED' .or. iotype == 'DT') then
    if (dim%is_unlim) then
      fmt = "(a, '(unlimited):', i0)"
    else
      fmt = "(a, ':', i0)"
    end if
    write (unit, fmt) dim%name, dim%len
    iostat = 0
  end if
end subroutine write_frmt_dim

!> Write a group hierarchy in a compact ncdump-like layout.
module subroutine write_frmt_grp(grp, unit, iotype, v_list, iostat, iomsg)
  class(group_type), intent(in) :: grp
  integer, intent(in) :: unit
  character(len=*), intent(in) :: iotype
  integer, intent(in) :: v_list(:)
  integer, intent(out) :: iostat
  character(len=*), intent(inout) :: iomsg

  associate (v_list_ => v_list, iomsg_ => iomsg)
  end associate

  iostat = 999
  if (iotype == "LISTDIRECTED" .or. iotype == "DT") then
    call write_grp_(grp, unit, 0)
    iostat = 0
  end if
end subroutine write_frmt_grp

!> Recursively write one group and its direct children with indentation.
recursive subroutine write_grp_(grp, unit, depth)
  class(group_type), intent(in) :: grp
  integer, intent(in) :: unit, depth
  character(len=:), allocatable :: indent, name
  integer :: i

  indent = repeat(" ", 2*depth)
  name = "/"
  if (allocated(grp%name)) name = grp%name
  if (depth == 0) then
    write (unit, "(a, a, ' {')") indent//"group: ", trim(name)
  else
    write (unit, "(/, a, a, ' {')") indent//"group: ", trim(name)
  end if

  if (allocated(grp%dims)) then
    if (size(grp%dims) > 0) then
      write (unit, "(/, a)") indent//"  dimensions:"
      do i = 1, size(grp%dims)
        call write_dim_(grp%dims(i), unit, indent//"    ")
      end do
    end if
  end if
  if (allocated(grp%vars)) then
    if (size(grp%vars) > 0) then
      write (unit, "(/, a)") indent//"  variables:"
      do i = 1, size(grp%vars)
        call write_var_(grp%vars(i), unit, indent//"    ")
      end do
    end if
  end if
  if (allocated(grp%atts)) then
    if (size(grp%atts) > 0) then
      write (unit, "(/, a)") indent//"  // global attributes:"
      do i = 1, size(grp%atts)
        write (unit, "(/, a, dt)") indent//"    ", grp%atts(i)
      end do
    end if
  end if
  if (allocated(grp%grps)) then
    if (size(grp%grps) > 0) then
      write (unit, "(/, a)") indent//"  groups:"
      do i = 1, size(grp%grps)
        call write_grp_(grp%grps(i), unit, depth + 1)
      end do
    end if
  end if
  write (unit, "(/, a, '}')") indent
end subroutine write_grp_

!> Write a dimension in a NetCDF declaration style.
subroutine write_dim_(dim, unit, indent)
  type(dimension_type), intent(in) :: dim
  integer, intent(in) :: unit
  character(len=*), intent(in) :: indent

  if (dim%is_unlim) then
    write (unit, "(/, a, a, ' = UNLIMITED ; // (', i0, ' currently)')") &
      & indent, dim%name, dim%len
  else
    write (unit, "(/, a, a, ' = ', i0, ' ;')") indent, dim%name, dim%len
  end if
end subroutine write_dim_

!> Write a variable declaration using local Fortran-order dimension names.
subroutine write_var_(var, unit, indent)
  type(variable_type), intent(in) :: var
  integer, intent(in) :: unit
  character(len=*), intent(in) :: indent
  character(len=MAX_CHAR_LEN) :: dims, dtype
  integer :: i

  call type_kind_str(var%dtype, dtype, ncdump=.true.)
  dims = ""
  if (allocated(var%dims)) then
    if (size(var%dims) > 0) then
      dims = "("
      do i = 1, size(var%dims)
        if (i > 1) dims = trim(dims)//", "
        dims = trim(dims)//var%dims(i)%name
      end do
      dims = trim(dims)//")"
    end if
  end if
  write (unit, "(/, a, a, 1x, a, a, ' ;')") indent, trim(dtype), var%name, trim(dims)
end subroutine write_var_

!> Write an `error_type` in list-directed (Fortran `DT`) format.
module subroutine write_frmt_error(error, unit, iotype, v_list, iostat, iomsg)
  !> Input argument(s): `error`.
  class(error_type), intent(in) :: error
  !> Input argument(s): `unit`.
  integer, intent(in) :: unit
  !> Input argument(s): `iotype`.
  character(len=*), intent(in) :: iotype
  !> Input argument(s): `v_list(:)`.
  integer, intent(in) :: v_list(:)
  !> Output argument(s): `iostat`.
  integer, intent(out) :: iostat
  !> Input/output argument(s): `iomsg`.
  character(len=*), intent(inout) :: iomsg

  associate (v_list_ => v_list, iomsg_ => iomsg)
  end associate

  iostat = 999
  if (iotype == 'LISTDIRECTED' .or. iotype == 'DT') then
    if (.not. failed(error)) then
      write (unit, "('NetCDF status (', i0, ')')") error%code
    else if (allocated(error%message)) then
      write (unit, "('NetCDF error (', i0, '): ', a)") &
        & error%code, trim(error%message)
    else
      write (unit, "('NetCDF status (', i0, ')')") error%code
    end if
    iostat = 0
  end if
end subroutine write_frmt_error

!> Map a NetCDF type code to a Fortran type-kind or ncdump declaration name.
pure subroutine type_kind_str(dtype, str, ncdump)
  !> NetCDF type code to map.
  integer(data_type), intent(in) :: dtype
  !> Output string describing the requested type name.
  character(len=*), intent(out) :: str
  !> Select the NetCDF/ncdump declaration spelling instead of Fortran syntax.
  logical, intent(in), optional :: ncdump
  logical :: use_ncdump

  use_ncdump = .false.
  if (present(ncdump)) use_ncdump = ncdump

  select case (dtype)
  case (FLOAT_TYPE)
    if (use_ncdump) then
      str = 'float'
    else
      str = 'real(real32)'
    end if
  case (DOUBLE_TYPE)
    if (use_ncdump) then
      str = 'double'
    else
      str = 'real(real64)'
    end if
  case (BYTE_TYPE)
    if (use_ncdump) then
      str = 'byte'
    else
      str = 'integer(int8)'
    end if
  case (SHORT_TYPE)
    if (use_ncdump) then
      str = 'short'
    else
      str = 'integer(int16)'
    end if
  case (INT_TYPE)
    if (use_ncdump) then
      str = 'int'
    else
      str = 'integer(int32)'
    end if
  case (INT64_TYPE)
    if (use_ncdump) then
      str = 'int64'
    else
      str = 'integer(int64)'
    end if
  case (CHAR_TYPE)
    if (use_ncdump) then
      str = 'char'
    else
      str = 'character(len=*)'
    end if
  case default
    error stop "[type_kind_str] Unsupported type."
  end select
end subroutine type_kind_str

end submodule nc4f_data_struct_io
