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
  integer :: length = -1
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

interface data_array
  module procedure :: new_variable_int32
  module procedure :: new_variable_real32
end interface data_array

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

!> Constants
integer, parameter :: MAX_CHAR_LEN = 1024
integer(int8), parameter :: BYTE = 0_int8

interface
  !> submodule_attribute.f90
  module function new_attribute_arr_int32(name, values) result(att)
    character(len=*), intent(in) :: name
    integer(int32), intent(in) :: values(:)
    type(attribute_type), target :: att
  end function new_attribute_arr_int32

  module function new_attribute_int32(name, value) result(att)
    character(len=*), intent(in) :: name
    integer(int32), intent(in) :: value
    type(attribute_type) :: att
  end function new_attribute_int32

  module function new_attribute_arr_int64(name, values) result(att)
    character(len=*), intent(in) :: name
    integer(int64), intent(in) :: values(:)
    type(attribute_type), target :: att
  end function new_attribute_arr_int64

  module function new_attribute_int64(name, value) result(att)
    character(len=*), intent(in) :: name
    integer(int64), intent(in) :: value
    type(attribute_type) :: att
  end function new_attribute_int64

  module function new_attribute_arr_real32(name, values) result(att)
    character(len=*), intent(in) :: name
    real(real32), intent(in) :: values(:)
    type(attribute_type), target :: att
  end function new_attribute_arr_real32

  module function new_attribute_real32(name, value) result(att)
    character(len=*), intent(in) :: name
    real(real32), intent(in) :: value
    type(attribute_type) :: att
  end function new_attribute_real32

  module function new_attribute_arr_real64(name, values) result(att)
    character(len=*), intent(in) :: name
    real(real64), intent(in) :: values(:)
    type(attribute_type), target :: att
  end function new_attribute_arr_real64

  module function new_attribute_real64(name, value) result(att)
    character(len=*), intent(in) :: name
    real(real64), intent(in) :: value
    type(attribute_type) :: att
  end function new_attribute_real64

  module function new_attribute_character(name, value) result(att)
    character(len=*), intent(in) :: name
    character(len=*), intent(in) :: value
    type(attribute_type), target :: att
  end function new_attribute_character

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

  module impure elemental subroutine put_attribute_global(nc, att)
    type(netcdf_type), intent(in) :: nc
    type(attribute_type), target, intent(in) :: att
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

  !> submodule_dimension.f90
  module elemental function new_dimension_argument(length, is_unlimited) result(arg)
    integer(int64), intent(in) :: length
    logical, intent(in) :: is_unlimited
    type(dimension_argument_type) :: arg
  end function new_dimension_argument

  module elemental function new_dimension_length(name, length) result(dim)
    character(len=*), intent(in) :: name
    integer(int64), intent(in) :: length
    type(dimension_type) :: dim
  end function new_dimension_length

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
  module function new_variable_real32(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    real(real32), intent(in) :: values(:)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in), optional :: atts(:)
    type(variable_type) :: var
  end function new_variable_real32

  module function new_variable_int32(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int32), intent(in) :: values(:)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in), optional :: atts(:)
    type(variable_type) :: var
  end function new_variable_int32

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

interface operator(+)
  module procedure :: add_vars
  module procedure :: add_var_real32
  module procedure :: add_real32_var
  module procedure :: add_var_real64
  module procedure :: add_real64_var
  module procedure :: add_var_int32
  module procedure :: add_int32_var
  module procedure :: add_var_int64
  module procedure :: add_int64_var
end interface operator(+)

interface operator(-)
  module procedure :: sub_vars
  module procedure :: sub_var_real32
  module procedure :: sub_real32_var
  module procedure :: sub_var_real64
  module procedure :: sub_real64_var
  module procedure :: sub_var_int32
  module procedure :: sub_int32_var
  module procedure :: sub_var_int64
  module procedure :: sub_int64_var
end interface operator(-)

interface operator(*)
  module procedure :: mul_vars
  module procedure :: mul_var_real32
  module procedure :: mul_real32_var
  module procedure :: mul_var_real64
  module procedure :: mul_real64_var
  module procedure :: mul_var_int32
  module procedure :: mul_int32_var
  module procedure :: mul_var_int64
  module procedure :: mul_int64_var
end interface operator(*)

interface operator(/)
  module procedure :: div_vars
  module procedure :: div_var_real32
  module procedure :: div_real32_var
  module procedure :: div_var_real64
  module procedure :: div_real64_var
  module procedure :: div_var_int32
  module procedure :: div_int32_var
  module procedure :: div_var_int64
  module procedure :: div_int64_var
end interface operator(/)

interface operator(**)
  module procedure :: pow_vars
  module procedure :: pow_var_real32
  module procedure :: pow_real32_var
  module procedure :: pow_var_real64
  module procedure :: pow_real64_var
  module procedure :: pow_var_int32
  module procedure :: pow_int32_var
  module procedure :: pow_var_int64
  module procedure :: pow_int64_var
end interface operator(**)

interface sum
  module procedure :: sum_vars
end interface sum

interface
  module function add_vars(x, y) result(res)
    type(variable_type), target, intent(in) :: x, y
    type(variable_type), target :: res
  end function add_vars

  module function add_var_real32(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    real(real32), intent(in) :: y
    type(variable_type), target :: res
  end function add_var_real32

  module function add_real32_var(x, y) result(res)
    real(real32), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function add_real32_var

  module function add_var_real64(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    real(real64), intent(in) :: y
    type(variable_type), target :: res
  end function add_var_real64

  module function add_real64_var(x, y) result(res)
    real(real64), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function add_real64_var

  module function add_var_int32(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    integer(int32), intent(in) :: y
    type(variable_type), target :: res
  end function add_var_int32

  module function add_int32_var(x, y) result(res)
    integer(int32), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function add_int32_var

  module function add_var_int64(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    integer(int64), intent(in) :: y
    type(variable_type), target :: res
  end function add_var_int64

  module function add_int64_var(x, y) result(res)
    integer(int64), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function add_int64_var

  module function sub_vars(x, y) result(res)
    type(variable_type), target, intent(in) :: x, y
    type(variable_type), target :: res
  end function sub_vars

  module function sub_var_real32(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    real(real32), intent(in) :: y
    type(variable_type), target :: res
  end function sub_var_real32

  module function sub_real32_var(x, y) result(res)
    real(real32), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function sub_real32_var

  module function sub_var_real64(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    real(real64), intent(in) :: y
    type(variable_type), target :: res
  end function sub_var_real64

  module function sub_real64_var(x, y) result(res)
    real(real64), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function sub_real64_var

  module function sub_var_int32(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    integer(int32), intent(in) :: y
    type(variable_type), target :: res
  end function sub_var_int32

  module function sub_int32_var(x, y) result(res)
    integer(int32), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function sub_int32_var

  module function sub_var_int64(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    integer(int64), intent(in) :: y
    type(variable_type), target :: res
  end function sub_var_int64

  module function sub_int64_var(x, y) result(res)
    integer(int64), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function sub_int64_var

  module function mul_vars(x, y) result(res)
    type(variable_type), target, intent(in) :: x, y
    type(variable_type), target :: res
  end function mul_vars

  module function mul_var_real32(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    real(real32), intent(in) :: y
    type(variable_type), target :: res
  end function mul_var_real32

  module function mul_real32_var(x, y) result(res)
    real(real32), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function mul_real32_var

  module function mul_var_real64(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    real(real64), intent(in) :: y
    type(variable_type), target :: res
  end function mul_var_real64

  module function mul_real64_var(x, y) result(res)
    real(real64), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function mul_real64_var

  module function mul_var_int32(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    integer(int32), intent(in) :: y
    type(variable_type), target :: res
  end function mul_var_int32

  module function mul_int32_var(x, y) result(res)
    integer(int32), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function mul_int32_var

  module function mul_var_int64(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    integer(int64), intent(in) :: y
    type(variable_type), target :: res
  end function mul_var_int64

  module function mul_int64_var(x, y) result(res)
    integer(int64), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function mul_int64_var

  module function div_vars(x, y) result(res)
    type(variable_type), target, intent(in) :: x, y
    type(variable_type), target :: res
  end function div_vars

  module function div_var_real32(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    real(real32), intent(in) :: y
    type(variable_type), target :: res
  end function div_var_real32

  module function div_real32_var(x, y) result(res)
    real(real32), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function div_real32_var

  module function div_var_real64(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    real(real64), intent(in) :: y
    type(variable_type), target :: res
  end function div_var_real64

  module function div_real64_var(x, y) result(res)
    real(real64), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function div_real64_var

  module function div_var_int32(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    integer(int32), intent(in) :: y
    type(variable_type), target :: res
  end function div_var_int32

  module function div_int32_var(x, y) result(res)
    integer(int32), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function div_int32_var

  module function div_var_int64(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    integer(int64), intent(in) :: y
    type(variable_type), target :: res
  end function div_var_int64

  module function div_int64_var(x, y) result(res)
    integer(int64), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function div_int64_var

  module function pow_vars(x, y) result(res)
    type(variable_type), target, intent(in) :: x, y
    type(variable_type), target :: res
  end function pow_vars

  module function pow_var_real32(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    real(real32), intent(in) :: y
    type(variable_type), target :: res
  end function pow_var_real32

  module function pow_real32_var(x, y) result(res)
    real(real32), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function pow_real32_var

  module function pow_var_real64(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    real(real64), intent(in) :: y
    type(variable_type), target :: res
  end function pow_var_real64

  module function pow_real64_var(x, y) result(res)
    real(real64), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function pow_real64_var

  module function pow_var_int32(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    integer(int32), intent(in) :: y
    type(variable_type), target :: res
  end function pow_var_int32

  module function pow_int32_var(x, y) result(res)
    integer(int32), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function pow_int32_var

  module function pow_var_int64(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    integer(int64), intent(in) :: y
    type(variable_type), target :: res
  end function pow_var_int64

  module function pow_int64_var(x, y) result(res)
    integer(int64), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function pow_int64_var

  module function sum_vars(vars) result(s)
    type(variable_type), intent(in) :: vars(:)
    type(variable_type) :: s
  end function sum_vars
end interface

interface extract
  module procedure :: extract_att_real32_1d
  module procedure :: extract_att_real32_scalar
  module procedure :: extract_att_real64_1d
  module procedure :: extract_att_real64_scalar
  module procedure :: extract_att_int32_1d
  module procedure :: extract_att_int32_scalar
  module procedure :: extract_att_int64_1d
  module procedure :: extract_att_int64_scalar
  module procedure :: extract_var_real32_1d
  module procedure :: extract_var_real32_2d
  module procedure :: extract_var_real32_3d
  module procedure :: extract_var_real32_4d
  module procedure :: extract_var_real64_1d
  module procedure :: extract_var_real64_2d
  module procedure :: extract_var_real64_3d
  module procedure :: extract_var_real64_4d
  module procedure :: extract_var_int32_1d
  module procedure :: extract_var_int32_2d
  module procedure :: extract_var_int32_3d
  module procedure :: extract_var_int32_4d
  module procedure :: extract_var_int64_1d
  module procedure :: extract_var_int64_2d
  module procedure :: extract_var_int64_3d
  module procedure :: extract_var_int64_4d
end interface extract

interface
  module subroutine extract_att_real32_1d(att, ptr)
    type(attribute_type), target, intent(in) :: att
    real(real32), pointer, intent(out) :: ptr(:)
  end subroutine extract_att_real32_1d

  module subroutine extract_att_real32_scalar(att, val)
    type(attribute_type), target, intent(in) :: att
    real(real32), intent(out) :: val
  end subroutine extract_att_real32_scalar

  module subroutine extract_var_real32_1d(var, ptr)
    type(variable_type), target, intent(in) :: var
    real(real32), pointer, intent(out) :: ptr(:)
  end subroutine extract_var_real32_1d

  module subroutine extract_var_real32_2d(var, ptr)
    type(variable_type), target, intent(in) :: var
    real(real32), pointer, intent(out) :: ptr(:, :)
  end subroutine extract_var_real32_2d

  module subroutine extract_var_real32_3d(var, ptr)
    type(variable_type), target, intent(in) :: var
    real(real32), pointer, intent(out) :: ptr(:, :, :)
  end subroutine extract_var_real32_3d

  module subroutine extract_var_real32_4d(var, ptr)
    type(variable_type), target, intent(in) :: var
    real(real32), pointer, intent(out) :: ptr(:, :, :, :)
  end subroutine extract_var_real32_4d

  module subroutine extract_att_real64_1d(att, ptr)
    type(attribute_type), target, intent(in) :: att
    real(real64), pointer, intent(out) :: ptr(:)
  end subroutine extract_att_real64_1d

  module subroutine extract_att_real64_scalar(att, val)
    type(attribute_type), target, intent(in) :: att
    real(real64), intent(out) :: val
  end subroutine extract_att_real64_scalar

  module subroutine extract_var_real64_1d(var, ptr)
    type(variable_type), target, intent(in) :: var
    real(real64), pointer, intent(out) :: ptr(:)
  end subroutine extract_var_real64_1d

  module subroutine extract_var_real64_2d(var, ptr)
    type(variable_type), target, intent(in) :: var
    real(real64), pointer, intent(out) :: ptr(:, :)
  end subroutine extract_var_real64_2d

  module subroutine extract_var_real64_3d(var, ptr)
    type(variable_type), target, intent(in) :: var
    real(real64), pointer, intent(out) :: ptr(:, :, :)
  end subroutine extract_var_real64_3d

  module subroutine extract_var_real64_4d(var, ptr)
    type(variable_type), target, intent(in) :: var
    real(real64), pointer, intent(out) :: ptr(:, :, :, :)
  end subroutine extract_var_real64_4d

  module subroutine extract_att_int32_1d(att, ptr)
    type(attribute_type), target, intent(in) :: att
    integer(int32), pointer, intent(out) :: ptr(:)
  end subroutine extract_att_int32_1d

  module subroutine extract_att_int32_scalar(att, val)
    type(attribute_type), target, intent(in) :: att
    integer(int32), intent(out) :: val
  end subroutine extract_att_int32_scalar

  module subroutine extract_var_int32_1d(var, ptr)
    type(variable_type), target, intent(in) :: var
    integer(int32), pointer, intent(out) :: ptr(:)
  end subroutine extract_var_int32_1d

  module subroutine extract_var_int32_2d(var, ptr)
    type(variable_type), target, intent(in) :: var
    integer(int32), pointer, intent(out) :: ptr(:, :)
  end subroutine extract_var_int32_2d

  module subroutine extract_var_int32_3d(var, ptr)
    type(variable_type), target, intent(in) :: var
    integer(int32), pointer, intent(out) :: ptr(:, :, :)
  end subroutine extract_var_int32_3d

  module subroutine extract_var_int32_4d(var, ptr)
    type(variable_type), target, intent(in) :: var
    integer(int32), pointer, intent(out) :: ptr(:, :, :, :)
  end subroutine extract_var_int32_4d

  module subroutine extract_att_int64_1d(att, ptr)
    type(attribute_type), target, intent(in) :: att
    integer(int64), pointer, intent(out) :: ptr(:)
  end subroutine extract_att_int64_1d

  module subroutine extract_att_int64_scalar(att, val)
    type(attribute_type), target, intent(in) :: att
    integer(int64), intent(out) :: val
  end subroutine extract_att_int64_scalar

  module subroutine extract_var_int64_1d(var, ptr)
    type(variable_type), target, intent(in) :: var
    integer(int64), pointer, intent(out) :: ptr(:)
  end subroutine extract_var_int64_1d

  module subroutine extract_var_int64_2d(var, ptr)
    type(variable_type), target, intent(in) :: var
    integer(int64), pointer, intent(out) :: ptr(:, :)
  end subroutine extract_var_int64_2d

  module subroutine extract_var_int64_3d(var, ptr)
    type(variable_type), target, intent(in) :: var
    integer(int64), pointer, intent(out) :: ptr(:, :, :)
  end subroutine extract_var_int64_3d

  module subroutine extract_var_int64_4d(var, ptr)
    type(variable_type), target, intent(in) :: var
    integer(int64), pointer, intent(out) :: ptr(:, :, :, :)
  end subroutine extract_var_int64_4d
end interface

end module module_netcdf
