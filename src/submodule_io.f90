submodule(module_netcdf) submodule_io
implicit none (type, external)
contains

module subroutine write_frmt_var(var, unit, iotype, v_list, iostat, iomsg)
  class(variable_type), intent(in) :: var
  integer, intent(in) :: unit
  character(len=*), intent(in) :: iotype
  integer, intent(in) :: v_list(:)
  integer, intent(out) :: iostat
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
    if (allocated(var%atts) .and. size(var%atts) > 0) &
      & write (unit, "(/, *(4x, DT))") var%atts
    iostat = 0
  end if
end subroutine write_frmt_var

module subroutine write_frmt_att(att, unit, iotype, v_list, iostat, iomsg)
  class(attribute_type), intent(in) :: att
  integer, intent(in) :: unit
  character(len=*), intent(in) :: iotype
  integer, intent(in) :: v_list(:)
  integer, intent(out) :: iostat
  character(len=*), intent(inout) :: iomsg
  character(len=MAX_CHAR_LEN) :: type_kind, fmt

  associate (v_list_ => v_list, iomsg_ => iomsg)
  end associate

  iostat = 999
  if (iotype == 'LISTDIRECTED' .or. iotype == 'DT') then
    call type_kind_str(att%dtype, type_kind)
    select case (att%dtype)
    case (NC_FLOAT, NC_DOUBLE)
      fmt = "(a, '::', a, 1x, '=', *(1x, g0.6))"
    case (NC_BYTE, NC_SHORT, NC_INT, NC_INT64)
      fmt = "(a, '::', a, 1x, '=', *(1x, i0))"
    case (NC_CHAR)
      fmt = "(4(g0), 1x, '=', 1x, *(a))"
    end select

    select case (att%dtype)
    case (NC_FLOAT)
      block
        real(real32), pointer :: ptr(:)
        call extract(att, ptr)
        write (unit, fmt) trim(type_kind), att%name, ptr
      end block
    case (NC_DOUBLE)
      block
        real(real64), pointer :: ptr(:)
        call extract(att, ptr)
        write (unit, fmt) trim(type_kind), att%name, ptr
      end block
    case (NC_BYTE)
      block
        integer(int8), pointer :: ptr(:)
        call extract(att, ptr)
        write (unit, fmt) trim(type_kind), att%name, ptr
      end block
    case (NC_SHORT)
      block
        integer(int16), pointer :: ptr(:)
        call extract(att, ptr)
        write (unit, fmt) trim(type_kind), att%name, ptr
      end block
    case (NC_INT)
      block
        integer(int32), pointer :: ptr(:)
        call extract(att, ptr)
        write (unit, fmt) trim(type_kind), att%name, ptr
      end block
    case (NC_INT64)
      block
        integer(int64), pointer :: ptr(:)
        call extract(att, ptr)
        write (unit, fmt) trim(type_kind), att%name, ptr
      end block
    case (NC_CHAR)
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

module subroutine write_frmt_dim(dim, unit, iotype, v_list, iostat, iomsg)
  class(dimension_type), intent(in) :: dim
  integer, intent(in) :: unit
  character(len=*), intent(in) :: iotype
  integer, intent(in) :: v_list(:)
  integer, intent(out) :: iostat
  character(len=*), intent(inout) :: iomsg
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

pure subroutine type_kind_str(nc_type, str)
  integer, intent(in) :: nc_type
  character(len=*), intent(out) :: str

  select case (nc_type)
  case (NC_FLOAT)
    str = 'real(real32)'
  case (NC_DOUBLE)
    str = 'real(real64)'
  case (NC_BYTE)
    str = 'integer(int8)'
  case (NC_SHORT)
    str = 'integer(int16)'
  case (NC_INT)
    str = 'integer(int32)'
  case (NC_INT64)
    str = 'integer(int64)'
  case (NC_CHAR)
    str = 'character(len=*)'
  case default
    error stop "[type_kind_str] Invalid NC type."
  end select
end subroutine type_kind_str

end submodule submodule_io
