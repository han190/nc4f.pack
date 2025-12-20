module nc4f

use, intrinsic :: iso_fortran_env, only: &
  & int8, int16, int32, int64, real32, real64
use, intrinsic :: iso_c_binding
use, non_intrinsic :: nc4f_c_interface
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

!> Public APIs (IE: Impure Elemental)
interface get_variable
  module procedure :: get_var !> IE
end interface get_variable

interface put_variable
  module procedure :: put_var !> IE
end interface put_variable

interface inquire_variable
  module procedure :: inq_var !> IE
end interface inquire_variable

interface get_attribute
  module procedure :: get_atts_nc
  module procedure :: get_att_nc !> IE
  module procedure :: get_atts_var
  module procedure :: get_att_var !> IE
end interface get_attribute

interface put_attribute
  module procedure :: put_att_nc !> IE
  module procedure :: put_att_var !> IE
end interface put_attribute

interface inquire_dimensions
  module procedure :: inq_dims_nc
  module procedure :: inq_dims_var
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
  !> -----------------------
  !> submodule_attribute.f90
  !> -----------------------

  !> Read a global attribute by name and return it.
  module impure elemental function get_att_nc(nc, name) result(att)
    !> High-level `netcdf_type` representing the open file.
    type(netcdf_type), intent(in) :: nc
    !> Name of the global attribute to read.
    character(len=*), intent(in) :: name
    !> Returned attribute object.
    type(attribute_type) :: att
  end function get_att_nc

  !> Return all global attributes for a dataset.
  module function get_atts_nc(nc, exist) result(atts)
    !> High-level `netcdf_type` representing the open file.
    type(netcdf_type), intent(in) :: nc
    !> Optional output flag set to true when attributes exist.
    logical, optional, intent(out) :: exist
    !> Allocatable array of attributes for the dataset.
    type(attribute_type), allocatable :: atts(:)
  end function get_atts_nc

  !> Read a named attribute attached to a variable and return it.
  module function get_att_var(nc, var, name) result(att)
    !> High-level `netcdf_type` representing the open file.
    type(netcdf_type), intent(in) :: nc
    !> Variable whose attribute will be read.
    type(variable_type), intent(in) :: var
    !> Name of the attribute to read.
    character(len=*), intent(in) :: name
    !> Returned attribute object.
    type(attribute_type) :: att
  end function get_att_var

  !> Return all attributes attached to a variable.
  module function get_atts_var(nc, var, exist) result(atts)
    !> High-level `netcdf_type` representing the open file.
    type(netcdf_type), intent(in) :: nc
    !> Variable whose attributes will be returned.
    type(variable_type), intent(in) :: var
    !> Optional output flag set to true when attributes exist.
    logical, optional, intent(out) :: exist
    !> Allocatable array of attributes for the variable.
    type(attribute_type), allocatable :: atts(:)
  end function get_atts_var

  !> Write all attributes of a variable to the dataset.
  module impure elemental subroutine put_att_var(nc, var)
    !> High-level `netcdf_type` representing the open file.
    type(netcdf_type), intent(in) :: nc
    !> Variable whose attributes will be written to the file.
    type(variable_type), target, intent(in) :: var
  end subroutine put_att_var

  !> Write all global attributes of the dataset to the file.
  module impure elemental subroutine put_att_nc(nc)
    !> High-level `netcdf_type` representing the open file.
    type(netcdf_type), target, intent(in) :: nc
  end subroutine put_att_nc

  !> Initialize `att` from an attribute mold, allocating its buffer.
  module pure subroutine allocate_att_mold(att, mold)
    !> Attribute to allocate and initialize.
    type(attribute_type), intent(inout) :: att
    !> Mold attribute providing metadata to copy.
    type(attribute_type), intent(in) :: mold
  end subroutine allocate_att_mold

  !> Initialize attribute metadata and allocate its buffer.
  module pure subroutine allocate_att_meta(att, name, dtype, len)
    !> Attribute to initialize.
    type(attribute_type), intent(inout) :: att
    !> Name to assign to the attribute.
    character(len=*), intent(in) :: name
    !> NetCDF data type code (NC_* constant) for the attribute.
    integer(int32), intent(in) :: dtype
    !> Number of elements for the attribute.
    integer(int64), intent(in) :: len
  end subroutine allocate_att_meta

  !> Allocate or resize the attribute's data buffer based on its type.
  module pure subroutine allocate_buffer_att(att)
    !> Attribute whose buffer will be allocated or resized.
    type(attribute_type), intent(inout) :: att
  end subroutine allocate_buffer_att

  !> Return true when two `attribute_type` values are identical.
  module elemental logical function eq_att(x, y)
    !> Left-hand attribute to compare.
    type(attribute_type), intent(in) :: x
    !> Right-hand attribute to compare.
    type(attribute_type), intent(in) :: y
  end function eq_att

  !> Return true when two `attribute_type` values differ.
  module elemental logical function neq_att(x, y)
    !> Left-hand attribute to compare.
    type(attribute_type), intent(in) :: x
    !> Right-hand attribute to compare.
    type(attribute_type), intent(in) :: y
  end function neq_att

  !> ---------------------
  !> submodule_dataset.f90
  !> ---------------------

  !> Open or create a dataset and return a `netcdf_type` handle.
  module function open_dataset(filename, mode, inq_dims, inq_atts) result(nc)
    !> Path to the dataset file.
    character(len=*), intent(in) :: filename
    !> Mode to open the file in: 'r' for read, 'w' for write.
    character(len=*), intent(in) :: mode
    !> When true, inquire dimensions after opening the file.
    logical, intent(in), optional :: inq_dims
    !> When true, inquire global attributes after opening the file.
    logical, intent(in), optional :: inq_atts
    !> Returned `netcdf_type` describing the opened dataset.
    type(netcdf_type) :: nc
  end function open_dataset

  !> Close a dataset and free associated allocatables.
  module subroutine close_dataset(nc)
    !> `netcdf_type` representing the open dataset to close.
    type(netcdf_type), intent(inout) :: nc
  end subroutine close_dataset

  !> Create a netCDF file from an array of `variable_type` objects.
  module subroutine to_netcdf_vars(filename, vars, atts)
    !> Output filename to create.
    character(len=*), intent(in) :: filename
    !> Array of variables to write into the file.
    type(variable_type), intent(in) :: vars(:)
    !> Optional array of global attributes to attach to the dataset.
    type(attribute_type), intent(in), optional :: atts(:)
  end subroutine to_netcdf_vars

  !> Create a netCDF file and write a single `variable_type` object.
  module subroutine to_netcdf_var(filename, var, atts)
    !> Output filename to create.
    character(len=*), intent(in) :: filename
    !> Variable to write into the file.
    type(variable_type), intent(in) :: var
    !> Optional array of global attributes to attach to the dataset.
    type(attribute_type), intent(in), optional :: atts(:)
  end subroutine to_netcdf_var

  !> -----------------------
  !> submodule_dimension.f90
  !> -----------------------

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

  !> Inquire all dimensions for the top-level group of a netCDF file.
  module function inq_dims_nc(nc) result(dims)
    !> High-level `netcdf_type` representing the open file.
    type(netcdf_type), intent(in) :: nc
    !> Allocatable array of `dimension_type` in Fortran order.
    type(dimension_type), allocatable :: dims(:)
  end function inq_dims_nc

  !> Inquire the dimensions attached to a variable.
  module function inq_dims_var(nc, var) result(dims)
    !> High-level `netcdf_type` for the file.
    type(netcdf_type), intent(in) :: nc
    !> `variable_type` describing the variable.
    type(variable_type), intent(in) :: var
    !> Allocatable array of `dimension_type` for that variable.
    type(dimension_type), allocatable :: dims(:)
  end function inq_dims_var

  !> Define a dimension in the netCDF file if it does not already exist.
  module impure elemental function def_dim(nc, dim) result(new_dim)
    !> High-level `netcdf_type` for the file.
    type(netcdf_type), intent(in) :: nc
    !> `dimension_type` describing the desired dimension (name, len,
    !> is_unlim).
    type(dimension_type), intent(in) :: dim
    !> The `dimension_type` of the existing or newly-created dimension
    !> (including the assigned `id`). This routine is `impure` because it
    !> may modify the underlying file state.
    type(dimension_type) :: new_dim
  end function def_dim

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

  !> ----------------
  !> submodule_io.f90
  !> ----------------

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

  !> ---------------------
  !> submodule_utility.f90
  !> ---------------------

  !> Handle errors from netCDF C API calls and raise Fortran errors.
  module impure elemental subroutine handle_error(status, error_message)
    !> Status code returned by a netCDF C API call.
    integer(c_int), intent(in) :: status
    !> Optional user message to include in the error text.
    character(*), intent(in), optional :: error_message
  end subroutine handle_error

  !> Convert a NUL-terminated C string to a Fortran allocatable string.
  module pure function c2fstr(cstr) result(fstr)
    !> C-style NUL-terminated string to convert.
    character(kind=c_char, len=*), intent(in) :: cstr
    !> Fortran allocatable result string.
    character(len=:), allocatable :: fstr
  end function c2fstr

  !> Convert a Fortran string to a NUL-terminated C string.
  module pure function f2cstr(fstr) result(cstr)
    !> Fortran string to convert.
    character(len=*), intent(in) :: fstr
    !> NUL-terminated C string result.
    character(kind=c_char, len=:), allocatable :: cstr
  end function f2cstr

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
    integer(int32), intent(in) :: dtype
    !> Number of elements of the given type.
    integer(int64), intent(in) :: len
    !> Result buffer size.
    integer(int64) :: buffer_size
  end function get_buffer_size

  !> ----------------------
  !> submodule_variable.f90
  !> ----------------------

  !> Read a variable's data from a netCDF dataset into a `variable_type`.
  module impure elemental function get_var(nc, name, exist) result(var)
    !> High-level `netcdf_type` representing the open file.
    type(netcdf_type), intent(in) :: nc
    !> Name of the variable to read.
    character(len=*), intent(in) :: name
    !> Optional output flag set to true if the variable exists.
    logical, optional, intent(out) :: exist
    !> Variable object that will contain metadata and the data buffer.
    type(variable_type), target :: var
  end function get_var

  !> Inquire a variable's metadata without reading its data buffer.
  module impure elemental function inq_var(nc, name, exist) result(var)
    !> High-level `netcdf_type` representing the open file.
    type(netcdf_type), intent(in) :: nc
    !> Name of the variable to inquire.
    character(len=*), intent(in) :: name
    !> Optional output flag set to true if the variable exists.
    logical, optional, intent(out) :: exist
    !> Variable object containing metadata (name, type, dims, atts, len).
    type(variable_type) :: var
  end function inq_var

  !> Write a variable's data and metadata to a netCDF dataset.
  module impure elemental subroutine put_var(nc, var)
    !> High-level `netcdf_type` representing the open file.
    type(netcdf_type), intent(in) :: nc
    !> Variable object containing metadata and a data buffer to write.
    type(variable_type), target, intent(in) :: var
  end subroutine put_var

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
  module pure subroutine allocate_var_mold(var, mold)
    !> Variable to allocate and initialize.
    type(variable_type), intent(inout) :: var
    !> Mold containing metadata to copy into `var`.
    type(variable_type), intent(in) :: mold
  end subroutine allocate_var_mold

  !> Allocate variable metadata and prepare its data buffer.
  module pure subroutine allocate_var_meta(var, name, dtype, len, dims, atts)
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
  end subroutine allocate_var_meta

  !> Allocate or resize the variable's data buffer according to its type.
  module pure subroutine allocate_buffer_var(var)
    !> Variable whose data buffer will be allocated or resized.
    type(variable_type), intent(inout) :: var
  end subroutine allocate_buffer_var

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
end interface

include "nc4f_arithmetic.inc"
include "nc4f_extract.inc"
include "nc4f_variable_constructor.inc"
include "nc4f_attribute_constructor.inc"

end module nc4f
