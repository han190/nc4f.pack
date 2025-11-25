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
  integer :: i, ndim
  character(len=MAX_CHAR_LEN) :: title_str, dim_str, ndim_str, fmt

  associate (v_list_ => v_list, iomsg_ => iomsg)
  end associate

  iostat = 999
  if (iotype == 'LISTDIRECTED' .or. iotype == 'DT') then
    fmt = "(2a)"
    select case (var%dtype)
    case (NC_FLOAT)
      title_str = 'real(real32)::'//var%name
    case (NC_DOUBLE)
      title_str = 'real(real64)::'//var%name
    case (NC_BYTE)
      title_str = 'integer(int8)::'//var%name
    case (NC_SHORT)
      title_str = 'integer(int16)::'//var%name
    case (NC_INT)
      title_str = 'integer(int32)::'//var%name
    case (NC_INT64)
      title_str = 'integer(int64)::'//var%name
    case (NC_CHAR)
      title_str = 'character(len=*)::'//var%name
    case default
      error stop "[write_frmt_var] Unsupported type."
    end select

    ndim = size(var%dims)
    if (ndim > 1) then
      write (ndim_str, "(i0)") ndim - 1
      fmt = "(1x, '(', "//trim(ndim_str)//"(DT, ',', 1x), DT, ')')"
    else if (ndim == 1) then
      write (ndim_str, "(i0)") ndim
      fmt = "(1x, '(', DT, ')')"
    else if (ndim == 0) then
      error stop "[write_frmt_var] Invalid dimension."
    end if
    write (dim_str, fmt) (var%dims(i), i=1, ndim)
    write (unit, "(a)") trim(title_str)//trim(dim_str)
    if (allocated(var%atts)) &
      & write (unit, "(/, *(4x, DT, /))") var%atts
    iostat = 0
  end if
end subroutine write_frmt_var

module subroutine write_frmt_att(att, unit, iotype, v_list, iostat, iomsg)
  class(attribute_type), target, intent(in) :: att
  integer, intent(in) :: unit
  character(len=*), intent(in) :: iotype
  integer, intent(in) :: v_list(:)
  integer, intent(out) :: iostat
  character(len=*), intent(inout) :: iomsg
  type(c_ptr) :: ptr
  character(len=28), parameter :: &
    & fmt_real = "(2(a), 1x, '=', *(1x, g0.6))", &
    & fmt_int = "(2(a), 1x, '=', *(1x, i0))"

  associate (v_list_ => v_list, iomsg_ => iomsg)
  end associate

  iostat = 999
  ptr = c_loc(att%buffer(1))

  if (iotype == 'LISTDIRECTED' .or. iotype == 'DT') then
    select case (att%dtype)
    case (NC_FLOAT)
      block
        real(real32), pointer :: fptr(:)
        call c_f_pointer(ptr, fptr, [att%len])
        write (unit, fmt_real) 'real(real32)::', att%name, fptr
      end block
    case (NC_DOUBLE)
      block
        real(real64), pointer :: fptr(:)
        call c_f_pointer(ptr, fptr, [att%len])
        write (unit, fmt_real) 'real(real64)::', att%name, fptr
      end block
    case (NC_BYTE)
      block
        integer(int8), pointer :: fptr(:)
        call c_f_pointer(ptr, fptr, [att%len])
        write (unit, fmt_int) 'integer(int8)::', att%name, fptr
      end block
    case (NC_SHORT)
      block
        integer(int16), pointer :: fptr(:)
        call c_f_pointer(ptr, fptr, [att%len])
        write (unit, fmt_int) 'integer(int16)::', att%name, fptr
      end block
    case (NC_INT)
      block
        integer(int32), pointer :: fptr(:)
        call c_f_pointer(ptr, fptr, [att%len])
        write (unit, fmt_int) 'integer(int32)::', att%name, fptr
      end block
    case (NC_INT64)
      block
        integer(int64), pointer :: fptr(:)
        call c_f_pointer(ptr, fptr, [att%len])
        write (unit, fmt_int) 'integer(int64)::', att%name, fptr
      end block
    case (NC_CHAR)
      block
        character(kind=c_char), pointer :: fptr(:)
        call c_f_pointer(ptr, fptr, [att%len])
        write (unit, "(4(g0), 1x, '=', 1x, *(a))") &
          & 'character(len=', att%len, ')::', att%name, fptr
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

end submodule submodule_io
