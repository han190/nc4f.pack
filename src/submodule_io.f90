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
  character(len=1024) :: title_str, dim_str, ndim_str, fmt

  associate (v_list_ => v_list, iomsg_ => iomsg)
  end associate

  iostat = 999
  if (iotype == 'LISTDIRECTED' .or. iotype == 'DT') then
    select case (var%data_type)
    case (NC_FLOAT)
      write (title_str, "('real ::', 1x, a)") var%name
    case (NC_INT)
      write (title_str, "('integer ::', 1x, a)") var%name
    case (NC_CHAR)
      write (title_str, "('character ::', 1x, a)") var%name
    case default
      error stop "[write_formatted_variable] Unsupported type."
    end select

    ndim = size(var%dimensions)
    if (ndim > 1) then
      write (ndim_str, "(i0)") ndim - 1
      fmt = "('(', "//trim(ndim_str)//"(DT, ',', 1x), DT, ')')"
    else if (ndim == 1) then
      write (ndim_str, "(i0)") ndim
      fmt = "('(', DT, ')')"
    else if (ndim == 0) then
      error stop "[write_formatted_variable] Invalid dimension."
    end if
    write (dim_str, trim(adjustl(fmt))) (var%dimensions(i), i=1, ndim)
    write (unit, "(a)") trim(title_str)//trim(dim_str)
    if (allocated(var%attributes)) &
      & write (unit, "(/, *(4x, DT, /))") var%attributes
    iostat = 0
  end if
end subroutine write_formatted_variable

module subroutine write_formatted_attribute(att, unit, iotype, v_list, iostat, iomsg)
  class(attribute_type), intent(in) :: att
  integer, intent(in) :: unit
  character(len=*), intent(in) :: iotype
  integer, intent(in) :: v_list(:)
  integer, intent(out) :: iostat
  character(len=*), intent(inout) :: iomsg

  associate (v_list_ => v_list, iomsg_ => iomsg)
  end associate

  iostat = 999
  if (iotype == 'LISTDIRECTED' .or. iotype == 'DT') then
    select case (att%data_type)
    case (NC_INT)
      write (unit, "(2(a), 1x, '=', *(1x, i0))") &
        & 'integer::', att%name, &
        & transfer(att%buffer, 1, att%length)
    case (NC_FLOAT)
      write (unit, "(2(a), 1x, '=', *(1x, g0.6))") &
        & 'real::', att%name, &
        & transfer(att%buffer, 1.0, att%length)
    case (NC_CHAR)
      block
        character :: tmp(att%length)
        character(len=att%length) :: string
        integer(int64) :: i

        tmp = transfer(att%buffer, 'a', att%length)
        do i = 1, att%length
          string(i:i) = tmp(i)
        end do

        write (unit, "(4(g0), 1x, '=', 1x, a)") &
          & 'character(len=', att%length, ')::', &
          & att%name, trim(adjustl(string))
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
  character(len=1024) :: fmt

  associate (v_list_ => v_list, iomsg_ => iomsg)
  end associate

  iostat = 999
  if (iotype == 'LISTDIRECTED' .or. iotype == 'DT') then
    if (dim%is_unlimited) then
      fmt = "(a, '(unlimited):', i0)"
    else
      fmt = "(a, ':', i0)"
    end if
    write (unit, trim(adjustl(fmt))) dim%name, dim%length
    iostat = 0
  end if
end subroutine write_formatted_dimension

end submodule submodule_io
