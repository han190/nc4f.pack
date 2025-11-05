module module_netcdf

use, intrinsic :: iso_fortran_env, only: int8, int32, int64, real32, real64
use, intrinsic :: iso_c_binding
use, non_intrinsic :: module_c_interface
implicit none (type, external)

public :: netcdf_type
public :: attribute_type
public :: dimension_type
public :: get_attribute
public :: get_attributes
public :: get_dimensions
public :: open_dataset
public :: write(formatted)
public :: operator(.att.)
public :: operator(.dim.)
public :: operator(.and.)
private

type :: netcdf_type
  character(len=:), allocatable :: filename
  integer(c_int) :: id, mode
  type(attribute_type), allocatable :: attributes(:)
  type(dimension_type), allocatable :: dimensions(:)
end type netcdf_type

type :: variable_type
  integer(c_int) :: id = -1
  integer(int32) :: data_type = -1
  character(len=:), allocatable :: name
  type(dimension_pointer_type), allocatable :: dimensions(:)
  type(attribute_type), allocatable :: attributes(:)
  integer(int8), allocatable :: buffer(:)
end type variable_type

type :: attribute_type
  character(len=:), allocatable :: name
  integer(int32) :: data_type = 0
  integer(int64) :: length = 0
  integer(int8), allocatable :: buffer(:)
end type attribute_type

type :: dimension_type
  integer(c_int) :: id
  character(len=:), allocatable :: name
  integer(int64) :: length = -1
  logical :: is_unlimited = .false.
end type dimension_type

type :: dimension_argument_type
  integer :: length = -1
  logical :: is_unlimited = .false.
end type dimension_argument_type

type :: dimension_pointer_type
  type(dimension_type), pointer :: dimension_pointer => null()
end type dimension_pointer_type

interface write(formatted)
  module procedure :: write_formatted_attribute
  module procedure :: write_formatted_dimension
end interface write(formatted)

interface get_attributes
  module procedure :: get_attributes_global
end interface get_attributes

interface get_dimensions
  module procedure :: get_dimensions_global
end interface get_dimensions

interface operator(.att.)
  module procedure :: new_attribute_int32
  module procedure :: new_attribute_arr_int32
  module procedure :: new_attribute_real32
  module procedure :: new_attribute_arr_real32
  module procedure :: new_attribute_character
end interface operator(.att.)

interface operator(.dim.)
  module procedure :: new_dimension_length
  module procedure :: new_dimension_arguments
end interface operator(.dim.)

interface operator(.and.)
  module procedure :: new_dimension_argument
end interface operator(.and.)

interface
  !> submodule_attribute.f90
  pure module function new_attribute_int32(name, value) result(att)
    character(len=*), intent(in) :: name
    integer, intent(in) :: value
    type(attribute_type) :: att
  end function new_attribute_int32

  pure module function new_attribute_arr_int32(name, values) result(att)
    character(len=*), intent(in) :: name
    integer, intent(in) :: values(:)
    type(attribute_type) :: att
  end function new_attribute_arr_int32

  pure module function new_attribute_real32(name, value) result(att)
    character(len=*), intent(in) :: name
    real, intent(in) :: value
    type(attribute_type) :: att
  end function new_attribute_real32

  pure module function new_attribute_arr_real32(name, values) result(att)
    character(len=*), intent(in) :: name
    real, intent(in) :: values(:)
    type(attribute_type) :: att
  end function new_attribute_arr_real32

  pure module function new_attribute_character(name, value) result(att)
    character(len=*), intent(in) :: name, value
    type(attribute_type) :: att
  end function new_attribute_character

  impure elemental module function get_attribute(nc, name) result(att)
    type(netcdf_type), intent(in) :: nc
    character(len=*), intent(in) :: name
    type(attribute_type) :: att
  end function get_attribute

  module function get_attributes_global(nc) result(atts)
    type(netcdf_type), intent(in) :: nc
    type(attribute_type), allocatable :: atts(:)
  end function get_attributes_global

  !> submodule_dataset.f90
  module function open_dataset(filename, mode, &
    & inquire_attribute) result(nc)
    character(len=*), intent(in) :: filename
    character(len=*), intent(in) :: mode
    logical, intent(in), optional :: inquire_attribute
    type(netcdf_type) :: nc
  end function open_dataset

  !> submodule_dimension.f90
  module elemental function new_dimension_argument(length, is_unlimited) result(arg)
    integer, intent(in) :: length
    logical, intent(in) :: is_unlimited
    type(dimension_argument_type) :: arg
  end function new_dimension_argument

  module elemental function new_dimension_length(name, length) result(dim)
    character(len=*), intent(in) :: name
    integer, intent(in) :: length
    type(dimension_type) :: dim
  end function new_dimension_length

  module elemental function new_dimension_arguments(name, args) result(dim)
    character(len=*), intent(in) :: name
    type(dimension_argument_type), intent(in) :: args
    type(dimension_type) :: dim
  end function new_dimension_arguments

  module function get_dimensions_global(nc) result(dims)
    type(netcdf_type), intent(in) :: nc
    type(dimension_type), allocatable :: dims(:)
  end function get_dimensions_global

  module function get_dimensions_(ncid) result(dims)
    integer(c_int), intent(in) :: ncid
    type(dimension_type), allocatable :: dims(:)
  end function get_dimensions_

  !> submodule_io.f90
  module subroutine write_formatted_attribute(att, unit, iotype, v_list, iostat, iomsg)
    class(attribute_type), intent(in) :: att
    integer, intent(in) :: unit
    character(len=*), intent(in) :: iotype
    integer, intent(in) :: v_list(:)
    integer, intent(out) :: iostat
    character(len=*), intent(inout) :: iomsg
  end subroutine write_formatted_attribute

  module subroutine write_formatted_dimension(dim, unit, iotype, v_list, iostat, iomsg)
    class(dimension_type), intent(in) :: dim
    integer, intent(in) :: unit
    character(len=*), intent(in) :: iotype
    integer, intent(in) :: v_list(:)
    integer, intent(out) :: iostat
    character(len=*), intent(inout) :: iomsg
  end subroutine write_formatted_dimension

  !> submodule_utility.f90
  impure elemental module subroutine handle_error(status, error_message)
    integer(c_int), intent(in) :: status
    character(*), intent(in), optional :: error_message
  end subroutine handle_error

  pure module function fstr(cstring) result(string)
    character(kind=c_char, len=*), intent(in) :: cstring
    character(len=:), allocatable :: string
  end function fstr

  pure module function cstr(string) result(cstring)
    character(len=*), intent(in) :: string
    character(kind=c_char, len=:), allocatable :: cstring
  end function cstr
  
  logical module function reallocation_required(buffer, buf_size)
    integer(int8), allocatable, intent(inout) :: buffer(:)
    integer(int64), intent(in) :: buf_size
  end function reallocation_required
end interface

end module module_netcdf