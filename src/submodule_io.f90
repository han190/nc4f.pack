submodule(module_netcdf) submodule_io
implicit none
contains

module subroutine write_formatted_variable(var, unit, iotype, v_list, iostat, iomsg)
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
    select case (var%data_type)
    case (NC_FLOAT)
      write (title_str, fmt) 'real(real32)::', var%name
    case (NC_DOUBLE)
      write (title_str, fmt) 'real(real64)::', var%name
    case (NC_INT)
      write (title_str, fmt) 'integer(int32)::', var%name
    case (NC_INT64)
      write (title_str, fmt) 'integer(int64)::', var%name
    case (NC_CHAR)
      write (title_str, fmt) 'character(len=*)::',var%name
    case default
      error stop "[write_formatted_variable] Unsupported type."
    end select

    ndim = size(var%dimensions)
    if (ndim > 1) then
      write (ndim_str, "(i0)") ndim - 1
      fmt = "(1x, '(', "//trim(ndim_str)//"(DT, ',', 1x), DT, ')')"
    else if (ndim == 1) then
      write (ndim_str, "(i0)") ndim
      fmt = "(1x, '(', DT, ')')"
    else if (ndim == 0) then
      error stop "[write_formatted_variable] Invalid dimension."
    end if
    write (dim_str, fmt) (var%dimensions(ndim - i + 1), i=1, ndim)
    write (unit, "(a)") trim(title_str)//trim(dim_str)
    if (allocated(var%attributes)) &
      & write (unit, "(/, *(4x, DT, /))") var%attributes
    iostat = 0
  end if
end subroutine write_formatted_variable

module subroutine write_formatted_attribute(att, unit, iotype, v_list, iostat, iomsg)
  class(attribute_type), target, intent(in) :: att
  integer, intent(in) :: unit
  character(len=*), intent(in) :: iotype
  integer, intent(in) :: v_list(:)
  integer, intent(out) :: iostat
  character(len=*), intent(inout) :: iomsg
  integer :: kind_num
  type(c_ptr) :: ptr

  associate (v_list_ => v_list, iomsg_ => iomsg)
  end associate

  iostat = 999
  ptr = c_loc(att%buffer(1))

  if (iotype == 'LISTDIRECTED' .or. iotype == 'DT') then
    select case (att%data_type)
    case (NC_INT)
      block
      integer(int32), pointer :: fptr(:) => null()
      call c_f_pointer(ptr, fptr, [att%length])
      write (unit, "(2(a), 1x, '=', *(1x, i0))") &
        & 'integer(int32)::', att%name, fptr
      nullify (fptr)
      end block
    case (NC_INT64)
      block
      integer(int64), pointer :: fptr(:) => null()
      call c_f_pointer(ptr, fptr, [att%length])
      write (unit, "(2(a), 1x, '=', *(1x, i0))") &
        & 'integer(int64)::', att%name, fptr
      nullify (fptr)
      end block
    case (NC_FLOAT)
      block
      real(real32), pointer :: fptr(:) => null()
      call c_f_pointer(ptr, fptr, [att%length])
      write (unit, "(2(a), 1x, '=', *(1x, g0.6))") &
        & 'real(real32)::', att%name, fptr
      nullify (fptr)
      end block
    case (NC_DOUBLE)
      block
      real(real64), pointer :: fptr(:) => null()
      call c_f_pointer(ptr, fptr, [att%length])
      write (unit, "(2(a), 1x, '=', *(1x, g0.6))") &
        & 'real(real64)::', att%name, fptr
      nullify (fptr)
      end block
    case (NC_CHAR)
      block
      character(kind=c_char), pointer :: fptr(:) => null()
      call c_f_pointer(ptr, fptr, [att%length])
      write (unit, "(4(g0), 1x, '=', 1x, *(a))") &
        & 'character(len=', att%length, ')::', att%name, fptr
      nullify (fptr)
      end block
    case default
      error stop "[write_formatted_attribute] Invalid attribute type."
    end select
    iostat = 0
  end if
end subroutine write_formatted_attribute

module subroutine write_formatted_dimension(dim, unit, iotype, v_list, iostat, iomsg)
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
    if (dim%is_unlimited) then
      fmt = "(a, '(unlimited):', i0)"
    else
      fmt = "(a, ':', i0)"
    end if
    write (unit, fmt) dim%name, dim%length
    iostat = 0
  end if
end subroutine write_formatted_dimension

end submodule submodule_io
