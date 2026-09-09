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

!> Map a netCDF type code (NC_*) to a human-readable Fortran type-kind string.
pure subroutine type_kind_str(dtype, str)
  !> NetCDF type code to map.
  integer(data_type), intent(in) :: dtype
  !> Output string describing the Fortran type-kind.
  character(len=*), intent(out) :: str

  select case (dtype)
  case (FLOAT_TYPE)
    str = 'real(real32)'
  case (DOUBLE_TYPE)
    str = 'real(real64)'
  case (BYTE_TYPE)
    str = 'integer(int8)'
  case (SHORT_TYPE)
    str = 'integer(int16)'
  case (INT_TYPE)
    str = 'integer(int32)'
  case (INT64_TYPE)
    str = 'integer(int64)'
  case (CHAR_TYPE)
    str = 'character(len=*)'
  case default
    error stop "[type_kind_str] Unsupported type."
  end select
end subroutine type_kind_str

end submodule nc4f_data_struct_io
