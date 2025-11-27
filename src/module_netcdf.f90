module module_netcdf

use, intrinsic :: iso_fortran_env, only: int8, int16, int32, int64, real32, real64
use, intrinsic :: iso_c_binding
use, non_intrinsic :: module_c_interface
implicit none (type, external)

!> Types
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
public :: allocate_variable
public :: allocate_attribute
public :: to_netcdf
private

!> Constants
integer, parameter :: MAX_CHAR_LEN = 1024
integer(int8), parameter :: BYTE = 0_int8
integer(int32), parameter :: INVALID_INT32 = -2147483647_int32
integer(int64), parameter :: INVALID_INT64 = -9223372036854775807_int64

type :: netcdf_type
  integer(c_int), private :: id = INVALID_INT32
  character(len=:), allocatable :: filename
  integer(c_int) :: mode
  type(attribute_type), allocatable :: atts(:)
  type(dimension_type), allocatable :: dims(:)
end type netcdf_type

type :: variable_type
  integer(c_int), private :: id = INVALID_INT32
  character(len=:), allocatable :: name
  integer(int32) :: dtype = INVALID_INT32
  integer(int64) :: len = INVALID_INT64
  type(dimension_type), allocatable :: dims(:)
  type(attribute_type), allocatable :: atts(:)
  integer(int8), allocatable :: buffer(:)
end type variable_type

type :: attribute_type
  integer(c_int), private :: id = INVALID_INT32
  character(len=:), allocatable :: name
  integer(int32) :: dtype = INVALID_INT32
  integer(int64) :: len = INVALID_INT64
  integer(int8), allocatable :: buffer(:)
end type attribute_type

type :: dimension_type
  integer(c_int), private :: id = INVALID_INT32
  character(len=:), allocatable :: name
  integer(int64) :: len = INVALID_INT64
  logical :: is_unlim = .false.
end type dimension_type

type :: dimension_argument_type
  integer(int64) :: len = INVALID_INT64
  logical :: is_unlim = .false.
end type dimension_argument_type

interface write(formatted)
  module procedure :: write_frmt_var
  module procedure :: write_frmt_att
  module procedure :: write_frmt_dim
end interface write(formatted)

interface get_variable
  module procedure :: get_var
end interface get_variable

interface put_variable
  module procedure :: put_var
end interface put_variable

interface inquire_variable
  module procedure :: inq_var
end interface inquire_variable

interface get_attribute
  module procedure :: get_atts_nc
  module procedure :: get_att_nc
end interface get_attribute

interface put_attribute
  module procedure :: put_att_nc
  module procedure :: put_att_var
end interface put_attribute

interface inquire_dimensions
  module procedure :: inq_dims_nc
end interface inquire_dimensions

interface operator(.dim.)
  module procedure :: new_dim_len_int32
  module procedure :: new_dim_len_int64
  module procedure :: new_dim_args
end interface operator(.dim.)

interface operator(.and.)
  module procedure :: new_dim_arg_int32
  module procedure :: new_dim_arg_int64
end interface operator(.and.)

interface operator(==)
  module procedure :: eq_dim
  module procedure :: eq_att
  module procedure :: eq_var
end interface operator(==)

interface operator(/=)
  module procedure :: neq_dim
  module procedure :: neq_att
  module procedure :: neq_var
end interface operator(/=)

interface size
  module procedure :: get_size
end interface size

interface shape
  module procedure :: get_shape
end interface shape

interface allocate_variable
  module procedure :: allocate_var_meta
  module procedure :: allocate_var_mold
end interface allocate_variable

interface allocate_attribute
  module procedure :: allocate_att_meta
  module procedure :: allocate_att_mold
end interface allocate_attribute

interface allocate_buffer
  module procedure :: allocate_buffer_att
  module procedure :: allocate_buffer_var
end interface allocate_buffer

interface to_netcdf
  module procedure :: to_netcdf_var
  module procedure :: to_netcdf_vars
end interface to_netcdf

interface
  !> submodule_attribute.f90
  module impure elemental function get_att_nc(nc, name) result(att)
    type(netcdf_type), intent(in) :: nc
    character(len=*), intent(in) :: name
    type(attribute_type) :: att
  end function get_att_nc

  module function get_atts_nc(nc) result(atts)
    type(netcdf_type), intent(in) :: nc
    type(attribute_type), allocatable :: atts(:)
  end function get_atts_nc

  module function get_atts_(ncid, varid, exist) result(atts)
    integer(c_int), intent(in) :: ncid, varid
    logical, intent(inout), optional :: exist
    type(attribute_type), allocatable :: atts(:)
  end function get_atts_

  module impure elemental subroutine put_att_var(nc, var)
    type(netcdf_type), intent(in) :: nc
    type(variable_type), target, intent(in) :: var
  end subroutine put_att_var

  module impure elemental subroutine put_att_nc(nc)
    type(netcdf_type), target, intent(in) :: nc
  end subroutine put_att_nc

  module pure subroutine allocate_att_mold(att, mold)
    type(attribute_type), intent(inout) :: att
    type(attribute_type), intent(in) :: mold
  end subroutine allocate_att_mold

  module pure subroutine allocate_att_meta(att, name, dtype, len)
    type(attribute_type), intent(inout) :: att
    character(len=*), intent(in) :: name
    integer(int32), intent(in) :: dtype
    integer(int64), intent(in) :: len
  end subroutine allocate_att_meta

  module pure subroutine allocate_buffer_att(att)
    type(attribute_type), intent(inout) :: att
  end subroutine allocate_buffer_att

  module elemental logical function eq_att(x, y)
    type(attribute_type), intent(in) :: x, y
  end function eq_att

  module elemental logical function neq_att(x, y)
    type(attribute_type), intent(in) :: x, y
  end function neq_att

  !> submodule_dataset.f90
  module function open_dataset(filename, mode, inq_dims, inq_atts) result(nc)
    character(len=*), intent(in) :: filename
    character(len=*), intent(in) :: mode
    logical, intent(in), optional :: inq_dims
    logical, intent(in), optional :: inq_atts
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
  module elemental function new_dim_arg_int64(len, is_unlim) result(arg)
    integer(int64), intent(in) :: len
    logical, intent(in) :: is_unlim
    type(dimension_argument_type) :: arg
  end function new_dim_arg_int64

  module elemental function new_dim_arg_int32(len, is_unlim) result(arg)
    integer(int32), intent(in) :: len
    logical, intent(in) :: is_unlim
    type(dimension_argument_type) :: arg
  end function new_dim_arg_int32

  module elemental function new_dim_len_int64(name, len) result(dim)
    character(len=*), intent(in) :: name
    integer(int64), intent(in) :: len
    type(dimension_type) :: dim
  end function new_dim_len_int64

  module elemental function new_dim_len_int32(name, len) result(dim)
    character(len=*), intent(in) :: name
    integer(int32), intent(in) :: len
    type(dimension_type) :: dim
  end function new_dim_len_int32

  module elemental function new_dim_args(name, args) result(dim)
    character(len=*), intent(in) :: name
    type(dimension_argument_type), intent(in) :: args
    type(dimension_type) :: dim
  end function new_dim_args

  module function inq_dims_nc(nc) result(dims)
    type(netcdf_type), intent(in) :: nc
    type(dimension_type), allocatable :: dims(:)
  end function inq_dims_nc

  module function inq_dims_(ncid, varid) result(dims)
    integer(c_int), intent(in) :: ncid
    integer(c_int), intent(in), optional :: varid
    type(dimension_type), allocatable :: dims(:)
  end function inq_dims_

  module impure elemental function def_dim(nc, dim) result(new_dim)
    type(netcdf_type), intent(in) :: nc
    type(dimension_type), intent(in) :: dim
    type(dimension_type) :: new_dim
  end function def_dim

  module elemental logical function eq_dim(x, y)
    type(dimension_type), intent(in) :: x, y
  end function eq_dim

  module elemental logical function neq_dim(x, y)
    type(dimension_type), intent(in) :: x, y
  end function neq_dim

  !> submodule_io.f90
  module subroutine write_frmt_var(var, unit, iotype, v_list, iostat, iomsg)
    class(variable_type), intent(in) :: var
    integer, intent(in) :: unit
    character(len=*), intent(in) :: iotype
    integer, intent(in) :: v_list(:)
    integer, intent(out) :: iostat
    character(len=*), intent(inout) :: iomsg
  end subroutine write_frmt_var

  module subroutine write_frmt_att(att, unit, iotype, v_list, iostat, iomsg)
    class(attribute_type), target, intent(in) :: att
    integer, intent(in) :: unit
    character(len=*), intent(in) :: iotype
    integer, intent(in) :: v_list(:)
    integer, intent(out) :: iostat
    character(len=*), intent(inout) :: iomsg
  end subroutine write_frmt_att

  module subroutine write_frmt_dim(dim, unit, iotype, v_list, iostat, iomsg)
    class(dimension_type), intent(in) :: dim
    integer, intent(in) :: unit
    character(len=*), intent(in) :: iotype
    integer, intent(in) :: v_list(:)
    integer, intent(out) :: iostat
    character(len=*), intent(inout) :: iomsg
  end subroutine write_frmt_dim

  !> submodule_utility.f90
  module impure elemental subroutine handle_error(status, error_message)
    integer(c_int), intent(in) :: status
    character(*), intent(in), optional :: error_message
  end subroutine handle_error

  pure module function c2fstr(cstr) result(fstr)
    character(kind=c_char, len=*), intent(in) :: cstr
    character(len=:), allocatable :: fstr
  end function c2fstr

  pure module function f2cstr(fstr) result(cstr)
    character(len=*), intent(in) :: fstr
    character(kind=c_char, len=:), allocatable :: cstr
  end function f2cstr

  module pure logical function allocation_required(buffer, bsize)
    integer(int8), allocatable, intent(in) :: buffer(:)
    integer(int64), intent(in) :: bsize
  end function allocation_required

  module elemental function get_buffer_size(dtype, len) result(buffer_size)
    integer(int32), intent(in) :: dtype
    integer(int64), intent(in) :: len
    integer(int64) :: buffer_size
  end function get_buffer_size

  !> submodule_variable.f90
  module impure elemental function get_var(nc, name, exist) result(var)
    type(netcdf_type), intent(in) :: nc
    character(len=*), intent(in) :: name
    logical, intent(out), optional :: exist
    type(variable_type) :: var
  end function get_var

  module impure elemental function inq_var(nc, name, exist) result(var)
    type(netcdf_type), intent(in) :: nc
    character(len=*), intent(in) :: name
    logical, intent(out), optional :: exist
    type(variable_type) :: var
  end function inq_var

  module impure elemental subroutine put_var(nc, var)
    type(netcdf_type), intent(in) :: nc
    type(variable_type), target, intent(in) :: var
  end subroutine put_var

  module pure function get_size(var, dim) result(n)
    type(variable_type), intent(in) :: var
    integer, intent(in), optional :: dim
    integer(int64) :: n
  end function get_size

  module pure function get_shape(var) result(n)
    type(variable_type), intent(in) :: var
    integer(int64), allocatable :: n(:)
  end function get_shape

  module pure subroutine allocate_var_mold(var, mold)
    type(variable_type), intent(inout) :: var
    type(variable_type), intent(in) :: mold
  end subroutine allocate_var_mold

  module pure subroutine allocate_var_meta(var, name, dtype, len, dims, atts)
    type(variable_type), intent(inout) :: var
    character(len=*), intent(in) :: name
    integer(int32), intent(in) :: dtype
    integer(int64), intent(in) :: len
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in), optional :: atts(:)
  end subroutine allocate_var_meta

  module pure subroutine allocate_buffer_var(var)
    type(variable_type), intent(inout) :: var
  end subroutine allocate_buffer_var

  module elemental logical function eq_var(x, y)
    type(variable_type), intent(in) :: x, y
  end function eq_var

  module elemental logical function neq_var(x, y)
    type(variable_type), intent(in) :: x, y
  end function neq_var
end interface

include "interface_arithmetic.inc"
include "interface_extract.inc"
include "interface_variable_constructor.inc"
include "interface_attribute_constructor.inc"

end module module_netcdf