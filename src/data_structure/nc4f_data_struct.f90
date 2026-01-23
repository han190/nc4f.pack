module nc4f_data_struct

use, intrinsic :: iso_fortran_env, only: &
  & int8, int16, int32, int64, real32, real64
use, intrinsic :: iso_c_binding, only: c_char, c_ptr, c_loc, c_f_pointer
implicit none (type, external)

public :: netcdf_type, variable_type, attribute_type, dimension_type
public :: size, shape, sum, extract, data_array
public :: allocate_variable, allocate_attribute
public :: MAX_CHAR_LEN

public :: operator(+), operator(-), operator(*), operator(/), operator(**)
public :: operator(.att.), operator(.dim.), operator(.and.)
public :: operator(==), operator(/=)
public :: write(formatted)
private

integer, parameter :: MAX_CHAR_LEN = 1024
integer(int8), parameter :: BYTE = 0_int8
integer(int32), parameter :: INVALID_INT32 = -2147483647_int32
integer(int64), parameter :: INVALID_INT64 = -9223372036854775807_int64

enum, bind(c)
  enumerator :: NAT_TYPE = 0
  enumerator :: BYTE_TYPE = 1
  enumerator :: CHAR_TYPE = 2
  enumerator :: SHORT_TYPE = 3
  enumerator :: INT_TYPE = 4
  enumerator :: FLOAT_TYPE = 5
  enumerator :: DOUBLE_TYPE = 6
  enumerator :: UBYTE_TYPE = 7
  enumerator :: USHORT_TYPE = 8
  enumerator :: UINT_TYPE = 9
  enumerator :: INT64_TYPE = 10
  enumerator :: UINT64_TYPE = 11
  enumerator :: STRING_TYPE = 12
end enum
integer, parameter :: data_type = kind(NAT_TYPE)

!> NetCDF root group.
type :: netcdf_type
  integer :: id = INVALID_INT32
  character(len=:), allocatable :: filename
  integer :: mode
  type(attribute_type), allocatable :: atts(:)
  type(dimension_type), allocatable :: dims(:)
end type netcdf_type

!> NetCDF variable type.
type :: variable_type
  integer :: id = INVALID_INT32
  character(len=:), allocatable :: name
  integer(data_type) :: dtype = NAT_TYPE
  integer(int64) :: len = INVALID_INT64
  type(dimension_type), allocatable :: dims(:)
  type(attribute_type), allocatable :: atts(:)
  integer(int8), allocatable :: buffer(:)
end type variable_type

!> NetCDF attribute type.
type :: attribute_type
  integer :: id = INVALID_INT32
  character(len=:), allocatable :: name
  integer(data_type) :: dtype = NAT_TYPE
  integer(int64) :: len = INVALID_INT64
  integer(int8), allocatable :: buffer(:)
end type attribute_type

!> NetCDF dimension type.
type :: dimension_type
  integer :: id = INVALID_INT32
  character(len=:), allocatable :: name
  integer(int64) :: len = INVALID_INT64
  logical :: is_unlim = .false.
end type dimension_type

!> NetCDF dimension argument type.
type :: dimension_argument_type
  integer(int64) :: len = INVALID_INT64
  logical :: is_unlim = .false.
end type dimension_argument_type

!> Dimension type constructor.
interface operator(.dim.)
  module procedure :: new_dim_len_int32
  module procedure :: new_dim_len_int64
  module procedure :: new_dim_args
end interface operator(.dim.)

!> Dimension argument constructor.
interface operator(.and.)
  module procedure :: new_dim_arg_int32
  module procedure :: new_dim_arg_int64
end interface operator(.and.)

!> Overloading equal.
interface operator(==)
  module procedure :: eq_dim
  module procedure :: eq_att
  module procedure :: eq_var
end interface operator(==)

!> Overloading not equal.
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

interface allocate_attribute
  module procedure :: alloc_att_buf
  module procedure :: alloc_att_meta
  module procedure :: alloc_att_mold
end interface allocate_attribute

interface allocate_variable
  module procedure :: alloc_var_buf
  module procedure :: alloc_var_meta
  module procedure :: alloc_var_mold
end interface allocate_variable

interface write(formatted)
  module procedure :: write_frmt_var
  module procedure :: write_frmt_att
  module procedure :: write_frmt_dim
end interface write(formatted)

interface
  !> Initialize `att` from an attribute mold, allocating its buffer.
  module pure subroutine alloc_att_mold(att, mold)
    !> Attribute to allocate and initialize.
    type(attribute_type), intent(inout) :: att
    !> Mold attribute providing metadata to copy.
    type(attribute_type), intent(in) :: mold
  end subroutine alloc_att_mold

  !> Initialize attribute metadata and allocate its buffer.
  module pure subroutine alloc_att_meta(att, name, dtype, len)
    !> Attribute to initialize.
    type(attribute_type), intent(inout) :: att
    !> Name to assign to the attribute.
    character(len=*), intent(in) :: name
    !> NetCDF data type code (NC_* constant) for the attribute.
    integer(int32), intent(in) :: dtype
    !> Number of elements for the attribute.
    integer(int64), intent(in) :: len
  end subroutine alloc_att_meta

  !> Allocate or resize the attribute's data buffer based on its type.
  module pure subroutine alloc_att_buf(att)
    !> Attribute whose buffer will be allocated or resized.
    type(attribute_type), intent(inout) :: att
  end subroutine alloc_att_buf

  !> Return true when two `attribute_type` values are identical.
  module elemental logical function eq_att(x, y) result(res)
    !> Left-hand attribute to compare.
    type(attribute_type), intent(in) :: x
    !> Right-hand attribute to compare.
    type(attribute_type), intent(in) :: y
  end function eq_att

  !> Return true when two `attribute_type` values differ.
  module elemental logical function neq_att(x, y) result(res)
    !> Left-hand attribute to compare.
    type(attribute_type), intent(in) :: x
    !> Right-hand attribute to compare.
    type(attribute_type), intent(in) :: y
  end function neq_att

  !> Construct a `dimension_argument_type` from a 64-bit length and a
  !> logical indicating whether the dimension is unlimited.
  module elemental function new_dim_arg_int64(len, is_unlim) result(arg)
    !> Length of the dimension (int64).
    integer(int64), intent(in) :: len
    !> True if the dimension is unlimited.
    logical, intent(in) :: is_unlim
    !> A dimension argument.
    type(dimension_argument_type) :: arg
  end function new_dim_arg_int64

  !> Construct a `dimension_argument_type` from a 32-bit length and a
  !> logical indicating whether the dimension is unlimited.
  module elemental function new_dim_arg_int32(len, is_unlim) result(arg)
    !> Length of the dimension (int32).
    integer(int32), intent(in) :: len
    !> True if the dimension is unlimited.
    logical, intent(in) :: is_unlim
    !> A dimension argument.
    type(dimension_argument_type) :: arg
  end function new_dim_arg_int32

  !> Create a `dimension_type` given a name and a 64-bit length.
  module elemental function new_dim_len_int64(name, len) result(dim)
    !> Dimension name (will be trimmed).
    character(len=*), intent(in) :: name
    !> Length of the dimension (int64).
    integer(int64), intent(in) :: len
    !> Result dimension.
    type(dimension_type) :: dim
  end function new_dim_len_int64

  !> Create a `dimension_type` given a name and a 32-bit length.
  module elemental function new_dim_len_int32(name, len) result(dim)
    !> Dimension name (will be trimmed).
    character(len=*), intent(in) :: name
    !> Length of the dimension (int32).
    integer(int32), intent(in) :: len
    !> Result dimension.
    type(dimension_type) :: dim
  end function new_dim_len_int32

  !> Create a `dimension_type` from a name and a `dimension_argument_type`.
  module elemental function new_dim_args(name, args) result(dim)
    !> Dimension name.
    character(len=*), intent(in) :: name
    !> `dimension_argument_type` containing length and unlimited flag.
    type(dimension_argument_type), intent(in) :: args
    type(dimension_type) :: dim
  end function new_dim_args

  !> Compare two `dimension_type` values for equality (name, length, and
  !> unlimited flag).
  module elemental logical function eq_dim(x, y)
    !> Left-hand `dimension_type` to compare.
    type(dimension_type), intent(in) :: x
    !> Right-hand `dimension_type` to compare.
    type(dimension_type), intent(in) :: y
  end function eq_dim

  !> Test whether two `dimension_type` values are different.
  module elemental logical function neq_dim(x, y)
    !> Left-hand `dimension_type` to compare.
    type(dimension_type), intent(in) :: x
    !> Right-hand `dimension_type` to compare.
    type(dimension_type), intent(in) :: y
  end function neq_dim

  !> Return the number of elements for the whole variable or a single dim.
  module pure function get_size(var, dim) result(n)
    !> Variable object to inspect.
    type(variable_type), intent(in) :: var
    !> Optional 1-based dimension index. If absent, return total size.
    integer, optional, intent(in) :: dim
    !> Number of elements returned (int64).
    integer(int64) :: n
  end function get_size

  !> Return the shape (lengths) of the variable's dimensions.
  module pure function get_shape(var) result(n)
    !> Variable object to inspect.
    type(variable_type), intent(in) :: var
    !> Allocatable array of dimension lengths returned (int64 each).
    integer(int64), allocatable :: n(:)
  end function get_shape

  !> Allocate a variable `var` using metadata from `mold`.
  module pure subroutine alloc_var_mold(var, mold)
    !> Variable to allocate and initialize.
    type(variable_type), intent(inout) :: var
    !> Mold containing metadata to copy into `var`.
    type(variable_type), intent(in) :: mold
  end subroutine alloc_var_mold

  !> Allocate variable metadata and prepare its data buffer.
  module pure subroutine alloc_var_meta(var, name, dtype, len, dims, atts)
    !> Variable to initialize and allocate.
    type(variable_type), intent(inout) :: var
    !> Name to assign to the variable.
    character(len=*), intent(in) :: name
    !> NetCDF data type code (NC_* constant) for the variable.
    integer(int32), intent(in) :: dtype
    !> Total number of elements for the variable.
    integer(int64), intent(in) :: len
    !> Array of dimensions describing the variable's shape.
    type(dimension_type), intent(in) :: dims(:)
    !> Optional array of attributes to copy into the variable.
    type(attribute_type), optional, intent(in) :: atts(:)
  end subroutine alloc_var_meta

  !> Allocate or resize the variable's data buffer according to its type.
  module pure subroutine alloc_var_buf(var)
    !> Variable whose data buffer will be allocated or resized.
    type(variable_type), intent(inout) :: var
  end subroutine alloc_var_buf

  !> Compare two `variable_type` values for deep equality of metadata and
  !> contents. Returns true when name, type, length, dims, attributes and
  !> buffer contents are equal.
  module elemental logical function eq_var(x, y) result(res)
    !> Left-hand variable to compare.
    type(variable_type), intent(in) :: x
    !> Right-hand variable to compare.
    type(variable_type), intent(in) :: y
  end function eq_var

  !> Return true when two `variable_type` values differ.
  module elemental logical function neq_var(x, y) result(res)
    !> Left-hand variable to compare.
    type(variable_type), intent(in) :: x
    !> Right-hand variable to compare.
    type(variable_type), intent(in) :: y
  end function neq_var

  !> Check whether re-allocation of a buffer is required.
  !> This compares the current buffer size with the requested target size.
  module pure logical function allocation_required(buffer, bsize)
    !> Buffer array to check.
    integer(int8), allocatable, intent(in) :: buffer(:)
    !> Target buffer size required.
    integer(int64), intent(in) :: bsize
  end function allocation_required

  !> Compute the buffer size in bytes for a given netCDF data type and
  !> number of elements.
  module elemental function get_buffer_size(dtype, len) result(buffer_size)
    !> NetCDF data type code (NC_* constants).
    integer(data_type), intent(in) :: dtype
    !> Number of elements of the given type.
    integer(int64), intent(in) :: len
    !> Result buffer size.
    integer(int64) :: buffer_size
  end function get_buffer_size

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
  end subroutine write_frmt_dim
end interface

include "nc4f_data_struct_arith.inc"
include "nc4f_data_struct_att_ctor.inc"
include "nc4f_data_struct_extract.inc"
include "nc4f_data_struct_var_ctor.inc"

end module nc4f_data_struct
