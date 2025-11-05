submodule(module_netcdf) submodule_io
implicit none
contains

!> UDDTIO for attribute_type
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
        integer :: i

        tmp = transfer(att%buffer, 'a', att%length)
        do i = 1, att%length
          string(i:i) = tmp(i)
        end do

        write (unit, "(4(g0), 1x, '=', 1x, a)") &
          & 'character(len=', att%length, &
          & ')::', att%name, trim(adjustl(string))
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
