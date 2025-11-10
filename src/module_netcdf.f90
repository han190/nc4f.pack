module module_netcdf

use, intrinsic :: iso_fortran_env, only: int8, int16, int32, int64, real32, real64
use, intrinsic :: iso_c_binding
use, non_intrinsic :: module_c_interface
implicit none (type, external)

public :: netcdf_type
public :: variable_type
public :: attribute_type
public :: dimension_type
!> Get functions
public :: get_attribute
public :: get_variable
!> Put functions
public :: put_attribute
public :: put_variable
!> Inquire functions
public :: inquire_dimensions
public :: inquire_variable
!> Extract functions
public :: extract
!> I/O
public :: open_dataset
public :: close_dataset
public :: data_array
!> Overrided intrinsic
public :: write(formatted)
public :: operator(.att.)
public :: operator(.dim.)
public :: operator(.and.)
public :: operator(==)
public :: operator(/=)
public :: operator(+)
public :: operator(-)
public :: operator(*)
public :: operator(/)
public :: operator(**)
public :: size
public :: shape
public :: sum
public :: allocate_buffer
public :: to_netcdf
private

type :: netcdf_type
  integer(c_int), private :: id = -1
  character(len=:), allocatable :: filename
  integer(c_int) :: mode
  type(attribute_type), allocatable :: attributes(:)
  type(dimension_type), allocatable :: dimensions(:)
end type netcdf_type

type :: variable_type
  integer(c_int), private :: id = -1
  character(len=:), allocatable :: name
  integer(int32) :: data_type = -1
  integer(int64) :: length = -1
  type(dimension_type), allocatable :: dimensions(:)
  type(attribute_type), allocatable :: attributes(:)
  integer(int8), allocatable :: buffer(:)
end type variable_type

type :: attribute_type
  integer(c_int), private :: id = -1
  character(len=:), allocatable :: name
  integer(int32) :: data_type = -1
  integer(int64) :: length = -1
  integer(int8), allocatable :: buffer(:)
end type attribute_type

type :: dimension_type
  integer(c_int), private :: id = -1
  character(len=:), allocatable :: name
  integer(int64) :: length = -1
  logical :: is_unlimited = .false.
end type dimension_type

type :: dimension_argument_type
  integer(int64) :: length = -1
  logical :: is_unlimited = .false.
end type dimension_argument_type

interface write(formatted)
  module procedure :: write_formatted_variable
  module procedure :: write_formatted_attribute
  module procedure :: write_formatted_dimension
end interface write(formatted)

interface get_attribute
  module procedure :: get_attributes_global
  module procedure :: get_attribute_name
end interface get_attribute

interface put_attribute
  module procedure :: put_attribute_global
  module procedure :: put_attribute_variable
end interface put_attribute

interface inquire_dimensions
  module procedure :: inquire_dimensions_global
end interface inquire_dimensions

interface operator(.dim.)
  module procedure :: new_dimension_length_int32
  module procedure :: new_dimension_length_int64
  module procedure :: new_dimension_arguments
end interface operator(.dim.)

interface operator(.and.)
  module procedure :: new_dimension_argument_int32
  module procedure :: new_dimension_argument_int64
end interface operator(.and.)

interface operator(==)
  module procedure :: equal_dimension
end interface operator(==)

interface operator(/=)
  module procedure :: unequal_dimension
end interface operator(/=)

interface size
  module procedure :: get_size
end interface size

interface shape
  module procedure :: get_shape
end interface shape

interface allocate_buffer
  module procedure :: allocate_buffer_attribute
  module procedure :: allocate_buffer_variable
end interface allocate_buffer

interface to_netcdf
  module procedure :: to_netcdf_var
  module procedure :: to_netcdf_vars
end interface to_netcdf

!> Constants
integer, parameter :: MAX_CHAR_LEN = 1024
integer(int8), parameter :: BYTE = 0_int8

interface
  !> submodule_attribute.f90
  impure elemental module function get_attribute_name(nc, name) result(att)
    type(netcdf_type), intent(in) :: nc
    character(len=*), intent(in) :: name
    type(attribute_type) :: att
  end function get_attribute_name

  module function get_attributes_global(nc) result(atts)
    type(netcdf_type), intent(in) :: nc
    type(attribute_type), allocatable :: atts(:)
  end function get_attributes_global

  module function get_attributes_(ncid, varid) result(atts)
    integer(c_int), intent(in) :: ncid, varid
    type(attribute_type), allocatable :: atts(:)
  end function get_attributes_

  module impure elemental subroutine put_attribute_variable(nc, var)
    type(netcdf_type), intent(in) :: nc
    type(variable_type), target, intent(in) :: var
  end subroutine put_attribute_variable

  module impure elemental subroutine put_attribute_global(nc)
    type(netcdf_type), target, intent(in) :: nc
  end subroutine put_attribute_global

  pure module subroutine allocate_buffer_attribute(att)
    type(attribute_type), intent(inout) :: att
  end subroutine allocate_buffer_attribute

  !> submodule_dataset.f90
  module function open_dataset(filename, mode, inquire_dimension, inquire_attribute) result(nc)
    character(len=*), intent(in) :: filename
    character(len=*), intent(in) :: mode
    logical, intent(in), optional :: inquire_dimension
    logical, intent(in), optional :: inquire_attribute
    type(netcdf_type) :: nc
  end function open_dataset

  module subroutine close_dataset(nc)
    type(netcdf_type), intent(inout) :: nc
  end subroutine close_dataset

  module subroutine to_netcdf_vars(filename, vars, atts)
    character(len=*), intent(in) :: filename
    type(variable_type), intent(in) :: vars(:)
    type(attribute_type), intent(in), optional :: atts(:)
  end subroutine to_netcdf_vars

  module subroutine to_netcdf_var(filename, var, atts)
    character(len=*), intent(in) :: filename
    type(variable_type), intent(in) :: var
    type(attribute_type), intent(in), optional :: atts(:)
  end subroutine to_netcdf_var

  !> submodule_dimension.f90
  module elemental function new_dimension_argument_int64(length, is_unlimited) result(arg)
    integer(int64), intent(in) :: length
    logical, intent(in) :: is_unlimited
    type(dimension_argument_type) :: arg
  end function new_dimension_argument_int64

  module elemental function new_dimension_argument_int32(length, is_unlimited) result(arg)
    integer(int32), intent(in) :: length
    logical, intent(in) :: is_unlimited
    type(dimension_argument_type) :: arg
  end function new_dimension_argument_int32

  module elemental function new_dimension_length_int64(name, length) result(dim)
    character(len=*), intent(in) :: name
    integer(int64), intent(in) :: length
    type(dimension_type) :: dim
  end function new_dimension_length_int64

  module elemental function new_dimension_length_int32(name, length) result(dim)
    character(len=*), intent(in) :: name
    integer(int32), intent(in) :: length
    type(dimension_type) :: dim
  end function new_dimension_length_int32

  module elemental function new_dimension_arguments(name, args) result(dim)
    character(len=*), intent(in) :: name
    type(dimension_argument_type), intent(in) :: args
    type(dimension_type) :: dim
  end function new_dimension_arguments

  module function inquire_dimensions_global(nc) result(dims)
    type(netcdf_type), intent(in) :: nc
    type(dimension_type), allocatable :: dims(:)
  end function inquire_dimensions_global

  module function inquire_dimensions_(ncid, varid) result(dims)
    integer(c_int), intent(in) :: ncid
    integer(c_int), intent(in), optional :: varid
    type(dimension_type), allocatable :: dims(:)
  end function inquire_dimensions_

  impure elemental module function define_dimension(nc, dim) result(new_dim)
    type(netcdf_type), intent(in) :: nc
    type(dimension_type), intent(in) :: dim
    type(dimension_type) :: new_dim
  end function define_dimension

  elemental module logical function equal_dimension(x, y)
    type(dimension_type), intent(in) :: x, y
  end function equal_dimension

  elemental module logical function unequal_dimension(x, y)
    type(dimension_type), intent(in) :: x, y
  end function unequal_dimension

  !> submodule_io.f90
  module subroutine write_formatted_variable(var, unit, iotype, v_list, iostat, iomsg)
    class(variable_type), intent(in) :: var
    integer, intent(in) :: unit
    character(len=*), intent(in) :: iotype
    integer, intent(in) :: v_list(:)
    integer, intent(out) :: iostat
    character(len=*), intent(inout) :: iomsg
  end subroutine write_formatted_variable

  module subroutine write_formatted_attribute(att, unit, iotype, v_list, iostat, iomsg)
    class(attribute_type), target, intent(in) :: att
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

  pure module function c2fstr(f2cstring) result(string)
    character(kind=c_char, len=*), intent(in) :: f2cstring
    character(len=:), allocatable :: string
  end function c2fstr

  pure module function f2cstr(string) result(f2cstring)
    character(len=*), intent(in) :: string
    character(kind=c_char, len=:), allocatable :: f2cstring
  end function f2cstr

  pure logical module function allocation_required(buffer, buf_size)
    integer(int8), allocatable, intent(in) :: buffer(:)
    integer(int64), intent(in) :: buf_size
  end function allocation_required

  module elemental function get_buffer_size(data_type, length) result(buffer_size)
    integer(int32), intent(in) :: data_type
    integer(int64), intent(in) :: length
    integer(int64) :: buffer_size
  end function get_buffer_size

  !> submodule_variable.f90
  module impure elemental function get_variable(nc, name, exist) result(var)
    type(netcdf_type), intent(in) :: nc
    character(len=*), intent(in) :: name
    logical, intent(out), optional :: exist
    type(variable_type) :: var
  end function get_variable

  module impure elemental function inquire_variable(nc, name, exist) result(var)
    type(netcdf_type), intent(in) :: nc
    character(len=*), intent(in) :: name
    logical, intent(out), optional :: exist
    type(variable_type) :: var
  end function inquire_variable

  module impure elemental subroutine put_variable(nc, var)
    type(netcdf_type), intent(in) :: nc
    type(variable_type), target, intent(in) :: var
  end subroutine put_variable

  pure module function get_size(var, dim) result(n)
    type(variable_type), intent(in) :: var
    integer, intent(in), optional :: dim
    integer(int64) :: n
  end function get_size

  pure module function get_shape(var) result(n)
    type(variable_type), intent(in) :: var
    integer(int64), allocatable :: n(:)
  end function get_shape

  pure module subroutine allocate_buffer_variable(var)
    type(variable_type), intent(inout) :: var
  end subroutine allocate_buffer_variable
end interface

include "interface_arithmetic.inc"
include "interface_extract.inc"
include "interface_variable_constructor.inc"
include "interface_attribute_constructor.inc"

end module module_netcdf