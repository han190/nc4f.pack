module nc4f_ds

use, intrinsic :: iso_fortran_env, only: &
  & int8, int16, int32, int64, real32, real64
use, intrinsic :: iso_c_binding, only: &
  & c_f_pointer, c_int, c_loc, c_null_ptr, c_ptr
use, non_intrinsic :: nc4f_c_interface, only: &
  & NC_EBADID, NC_EBADDIM, NC_EBADGRPID, NC_EEDGE, NC_EINVAL, NC_EINVALCOORDS, &
  & NC_ENOGRP, NC_ENOTATT, NC_ENOTFOUND, NC_ENOTVAR, NC_NOERR, NC_NOWRITE
implicit none (type, external)

public :: attribute_type, dimension_type, error_type, &
  & group_type, netcdf_type, variable_type
public :: NC_EBADID, NC_EBADDIM, NC_EBADGRPID, NC_EEDGE, NC_EINVAL, &
  & NC_EINVALCOORDS, NC_ENOGRP, &
  & NC_ENOTATT, NC_ENOTFOUND, NC_ENOTVAR, NC_NOERR
public :: datarray, dataset, extract, initialize, operator(.att.), &
  & operator(.and.), operator(.dim.), &
  & operator(==), operator(/=), shape, size, sum
public :: buffer_size, buffer2cptr, validate
private

integer(int32), parameter :: INVALID_INT32 = -2147483647_int32
integer(int64), parameter :: INVALID_INT64 = -9223372036854775807_int64

!> Result of an nc4f operation that was allowed to return normally on error.
!>
!> A zero `code` denotes success. On failure, `msg` contains an nc4f
!> diagnostic and `code` preserves the originating NetCDF status.
type :: error_type
  integer(c_int) :: code = NC_NOERR
  character(len=:), allocatable :: msg
contains
  procedure, private :: write_frmt_err
  generic, public :: write(formatted) => write_frmt_err
end type error_type

!> Type constant used for NetCDF external data types.
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

!> NetCDF dimension metadata remains a small value object.
type :: dimension_type
  integer(c_int) :: id = INVALID_INT32
  character(len=:), allocatable :: name
  integer(int64) :: len = INVALID_INT64
  logical :: is_unlim = .false.
contains
  procedure, private :: write_frmt_dim
  generic, public :: write(formatted) => write_frmt_dim
end type dimension_type

!> Arguments used to construct an unlimited dimension with `.and.`.
type :: dimension_argument_type
  integer(int64) :: len = INVALID_INT64
  logical :: is_unlim = .false.
end type dimension_argument_type

!> NetCDF attribute metadata and values.
!>
!> `buffer` owns copied data, while `ptr` borrows contiguous caller storage.
!>
!> Exactly one backing store is present for a nonempty value: either
!> `buffer` is allocated or `ptr` is associated.  The allocatable component
!> gives copied values normal Fortran lifetime management; the pointer is
!> reserved exclusively for caller-owned storage.
type :: attribute_type
  integer(c_int) :: id = INVALID_INT32
  character(len=:), allocatable :: name
  integer(data_type) :: dtype = NAT_TYPE
  integer(int64) :: len = INVALID_INT64
  integer(int8), allocatable :: buffer(:)
  integer(int8), contiguous, pointer :: ptr(:) => null()
contains
  procedure, private :: write_frmt_att
  generic, public :: write(formatted) => write_frmt_att
end type attribute_type

!> NetCDF variable metadata, dimensions, attributes, and values.
type :: variable_type
  integer(c_int) :: id = INVALID_INT32
  character(len=:), allocatable :: name
  integer(data_type) :: dtype = NAT_TYPE
  integer(int64) :: len = INVALID_INT64
  type(dimension_type), allocatable :: dims(:)
  type(attribute_type), allocatable :: atts(:)
  integer(int8), allocatable :: buffer(:)
  integer(int8), contiguous, pointer :: ptr(:) => null()
contains
  procedure, private :: write_frmt_var
  generic, public :: write(formatted) => write_frmt_var
end type variable_type

!> NetCDF group metadata.
!>
!> Child groups are pointer-backed so intrinsic assignment shares the child
!> tree instead of recursively copying it.
type :: group_type
  integer(c_int) :: id = INVALID_INT32
  character(len=:), allocatable :: name
  type(dimension_type), allocatable :: dims(:)
  type(attribute_type), allocatable :: atts(:)
  type(variable_type), allocatable :: vars(:)
  type(group_type), pointer :: grps(:) => null()
contains
  procedure, private :: write_frmt_grp
  generic, public :: write(formatted) => write_frmt_grp
end type group_type

!> An open NetCDF file: a root-group value plus file-specific state.
type, extends(group_type) :: netcdf_type
  character(len=:), allocatable :: file
  integer(c_int) :: mode = NC_NOWRITE
contains
  procedure, private :: write_frmt_grp => write_frmt_netcdf
end type netcdf_type

include "nc4f_ds_attribute_constructor.inc"
include "nc4f_ds_variable_constructor.inc"
include "nc4f_ds_extract.inc"

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
  module procedure :: eq_att
  module procedure :: eq_dim
  module procedure :: eq_var
end interface operator(==)

interface operator(/=)
  module procedure :: neq_att
  module procedure :: neq_dim
  module procedure :: neq_var
end interface operator(/=)

interface size
  module procedure :: get_size
end interface size

interface shape
  module procedure :: get_shape
end interface shape

interface sum
  module procedure :: sum_vars
end interface sum

interface initialize
  module procedure :: init_att
  module procedure :: init_att_mold
  module procedure :: init_var
  module procedure :: init_var_mold
end interface initialize

interface buffer2cptr
  module procedure :: buffer2cptr_att
  module procedure :: buffer2cptr_var
end interface buffer2cptr

interface validate
  module procedure :: validate_att
  module procedure :: validate_var
end interface validate

interface dataset
  module procedure :: new_dataset_empty
  module procedure :: new_dataset_vars
  module procedure :: new_dataset_grps
  module procedure :: new_dataset_all
end interface dataset

interface
  !> Initialize a dataset object.
  elemental module subroutine init_att(att, name, dtype, len)
    !> Attribute to process.
    type(attribute_type), intent(inout) :: att
    !> Name used to identify the NetCDF object.
    character(len=*), intent(in) :: name
    !> Data or metadata used by this operation.
    integer(data_type), intent(in) :: dtype
    !> Data or metadata used by this operation.
    integer(int64), intent(in) :: len
  end subroutine init_att

  !> Initialize a dataset object.
  module subroutine init_var(var, name, dtype, len, dims, atts)
    !> Variable to process.
    type(variable_type), intent(inout) :: var
    !> Name used to identify the NetCDF object.
    character(len=*), intent(in) :: name
    !> Data or metadata used by this operation.
    integer(data_type), intent(in) :: dtype
    !> Data or metadata used by this operation.
    integer(int64), intent(in) :: len
    !> Dimensions describing the variable shape.
    type(dimension_type), intent(in) :: dims(:)
    !> Attributes to process or attach.
    type(attribute_type), intent(in), optional :: atts(:)
  end subroutine init_var

  !> Initialize a dataset object.
  elemental module subroutine init_att_(att, name, dtype, len, deep)
    !> Attribute to process.
    type(attribute_type), intent(inout) :: att
    !> Name used to identify the NetCDF object.
    character(len=*), intent(in) :: name
    !> Data or metadata used by this operation.
    integer(data_type), intent(in) :: dtype
    !> Data or metadata used by this operation.
    integer(int64), intent(in) :: len
    !> Whether to make an owned deep copy of the data.
    logical, intent(in), optional :: deep
  end subroutine init_att_

  !> Initialize a dataset object.
  module subroutine init_var_(var, name, dtype, len, dims, atts, deep)
    !> Variable to process.
    type(variable_type), intent(inout) :: var
    !> Name used to identify the NetCDF object.
    character(len=*), intent(in) :: name
    !> Data or metadata used by this operation.
    integer(data_type), intent(in) :: dtype
    !> Data or metadata used by this operation.
    integer(int64), intent(in) :: len
    !> Dimensions describing the variable shape.
    type(dimension_type), intent(in) :: dims(:)
    !> Attributes to process or attach.
    type(attribute_type), intent(in), optional :: atts(:)
    !> Whether to make an owned deep copy of the data.
    logical, intent(in), optional :: deep
  end subroutine init_var_

  !> Initialize a dataset object.
  module subroutine init_att_mold(att, name, mold, deep)
    !> Attribute to process.
    type(attribute_type), intent(inout) :: att
    !> Name used to identify the NetCDF object.
    character(len=*), intent(in) :: name
    !> Data or metadata used by this operation.
    type(attribute_type), target, intent(in) :: mold
    !> Whether to make an owned deep copy of the data.
    logical, intent(in), optional :: deep
  end subroutine init_att_mold

  !> Initialize a dataset object.
  module subroutine init_var_mold(var, name, mold, atts, deep)
    !> Variable to process.
    type(variable_type), intent(inout) :: var
    !> Name used to identify the NetCDF object.
    character(len=*), intent(in) :: name
    !> Data or metadata used by this operation.
    type(variable_type), target, intent(in) :: mold
    !> Attributes to process or attach.
    type(attribute_type), intent(in), optional :: atts(:)
    !> Whether to make an owned deep copy of the data.
    logical, intent(in), optional :: deep
  end subroutine init_var_mold

  !> Construct a dataset object from the supplied metadata and data.
  module function new_dataset_empty(name, atts, deep) result(grp)
    !> Name used to identify the NetCDF object.
    character(len=*), intent(in) :: name
    !> Attributes to process or attach.
    type(attribute_type), intent(in), optional :: atts(:)
    !> Whether to make an owned deep copy of the data.
    logical, intent(in), optional :: deep
    !> Result produced by this operation.
    type(group_type) :: grp
  end function new_dataset_empty

  !> Construct a dataset object from the supplied metadata and data.
  module function new_dataset_vars(name, vars, atts, deep) result(grp)
    !> Name used to identify the NetCDF object.
    character(len=*), intent(in) :: name
    !> Variables to process or add to the dataset.
    type(variable_type), intent(in) :: vars(:)
    !> Attributes to process or attach.
    type(attribute_type), intent(in), optional :: atts(:)
    !> Whether to make an owned deep copy of the data.
    logical, intent(in), optional :: deep
    !> Result produced by this operation.
    type(group_type) :: grp
  end function new_dataset_vars

  !> Construct a dataset object from the supplied metadata and data.
  module function new_dataset_grps(name, grps, atts, deep) result(grp)
    !> Name used to identify the NetCDF object.
    character(len=*), intent(in) :: name
    !> Data or metadata used by this operation.
    type(group_type), intent(in) :: grps(:)
    !> Attributes to process or attach.
    type(attribute_type), intent(in), optional :: atts(:)
    !> Whether to make an owned deep copy of the data.
    logical, intent(in), optional :: deep
    !> Result produced by this operation.
    type(group_type) :: grp
  end function new_dataset_grps

  !> Construct a dataset object from the supplied metadata and data.
  module function new_dataset_all(name, vars, grps, atts, deep) result(grp)
    !> Name used to identify the NetCDF object.
    character(len=*), intent(in) :: name
    !> Variables to process or add to the dataset.
    type(variable_type), intent(in) :: vars(:)
    !> Data or metadata used by this operation.
    type(group_type), intent(in) :: grps(:)
    !> Attributes to process or attach.
    type(attribute_type), intent(in), optional :: atts(:)
    !> Whether to make an owned deep copy of the data.
    logical, intent(in), optional :: deep
    !> Result produced by this operation.
    type(group_type) :: grp
  end function new_dataset_all

  !> Construct a dataset object from the supplied metadata and data.
  module subroutine new_dataset_(grp, name, vars, grps, atts, deep)
    !> Dataset group to process.
    type(group_type), intent(out) :: grp
    !> Name used to identify the NetCDF object.
    character(len=*), intent(in) :: name
    !> Variables to process or add to the dataset.
    type(variable_type), intent(in), optional :: vars(:)
    !> Data or metadata used by this operation.
    type(group_type), intent(in), optional :: grps(:)
    !> Attributes to process or attach.
    type(attribute_type), intent(in), optional :: atts(:)
    !> Whether to make an owned deep copy of the data.
    logical, intent(in), optional :: deep
  end subroutine new_dataset_

  !> Clone a dataset object and its data.
  impure elemental module subroutine clone_att(src, dest)
    !> Source object or group to read from.
    type(attribute_type), intent(in) :: src
    !> Destination object or group to update.
    type(attribute_type), intent(out) :: dest
  end subroutine clone_att

  !> Clone a dataset object and its data.
  impure elemental module subroutine clone_var(src, dest)
    !> Source object or group to read from.
    type(variable_type), intent(in) :: src
    !> Destination object or group to update.
    type(variable_type), intent(out) :: dest
  end subroutine clone_var

  !> Clone a dataset object and its data.
  impure elemental module subroutine clone_grp(src, dest)
    !> Source object or group to read from.
    type(group_type), intent(in) :: src
    !> Destination object or group to update.
    type(group_type), intent(out) :: dest
  end subroutine clone_grp

  !> Validate dataset buffer metadata before access.
  pure module subroutine validate_att(att, dtype, context)
    !> Attribute to process.
    type(attribute_type), intent(in) :: att
    !> Data or metadata used by this operation.
    integer(data_type), intent(in), optional :: dtype
    !> Data or metadata used by this operation.
    character(len=*), intent(in) :: context
  end subroutine validate_att

  !> Validate dataset buffer metadata before access.
  pure module subroutine validate_var(var, dtype, rank, context)
    !> Variable to process.
    type(variable_type), intent(in) :: var
    !> Data or metadata used by this operation.
    integer(data_type), intent(in), optional :: dtype
    !> Data or metadata used by this operation.
    integer, intent(in), optional :: rank
    !> Data or metadata used by this operation.
    character(len=*), intent(in) :: context
  end subroutine validate_var

  !> Perform the buffer2cptr_att operation.
  module function buffer2cptr_att(att) result(cptr)
    !> Attribute to process.
    type(attribute_type), target, intent(in) :: att
    !> Result produced by this operation.
    type(c_ptr) :: cptr
  end function buffer2cptr_att

  !> Perform the buffer2cptr_var operation.
  module function buffer2cptr_var(var) result(cptr)
    !> Variable to process.
    type(variable_type), target, intent(in) :: var
    !> Result produced by this operation.
    type(c_ptr) :: cptr
  end function buffer2cptr_var

  !> Write supplied data or metadata to a NetCDF object.
  module subroutine write_frmt_att(att, unit, iotype, v_list, iostat, iomsg)
    !> Attribute to process.
    class(attribute_type), intent(in) :: att
    !> Data or metadata used by this operation.
    integer, intent(in) :: unit
    !> Data or metadata used by this operation.
    character(len=*), intent(in) :: iotype
    !> Data or metadata used by this operation.
    integer, intent(in) :: v_list(:)
    !> Data or metadata used by this operation.
    integer, intent(out) :: iostat
    !> Data or metadata used by this operation.
    character(len=*), intent(inout) :: iomsg
  end subroutine write_frmt_att

  !> Write supplied data or metadata to a NetCDF object.
  module subroutine write_frmt_dim(dim, unit, iotype, v_list, iostat, iomsg)
    !> Dimension to process.
    class(dimension_type), intent(in) :: dim
    !> Data or metadata used by this operation.
    integer, intent(in) :: unit
    !> Data or metadata used by this operation.
    character(len=*), intent(in) :: iotype
    !> Data or metadata used by this operation.
    integer, intent(in) :: v_list(:)
    !> Data or metadata used by this operation.
    integer, intent(out) :: iostat
    !> Data or metadata used by this operation.
    character(len=*), intent(inout) :: iomsg
  end subroutine write_frmt_dim

  !> Write supplied data or metadata to a NetCDF object.
  module subroutine write_frmt_var(var, unit, iotype, v_list, iostat, iomsg)
    !> Variable to process.
    class(variable_type), intent(in) :: var
    !> Data or metadata used by this operation.
    integer, intent(in) :: unit
    !> Data or metadata used by this operation.
    character(len=*), intent(in) :: iotype
    !> Data or metadata used by this operation.
    integer, intent(in) :: v_list(:)
    !> Data or metadata used by this operation.
    integer, intent(out) :: iostat
    !> Data or metadata used by this operation.
    character(len=*), intent(inout) :: iomsg
  end subroutine write_frmt_var

  !> Write supplied data or metadata to a NetCDF object.
  module subroutine write_frmt_grp(grp, unit, iotype, v_list, iostat, iomsg)
    !> Dataset group to process.
    class(group_type), intent(in) :: grp
    !> Data or metadata used by this operation.
    integer, intent(in) :: unit
    !> Data or metadata used by this operation.
    character(len=*), intent(in) :: iotype
    !> Data or metadata used by this operation.
    integer, intent(in) :: v_list(:)
    !> Data or metadata used by this operation.
    integer, intent(out) :: iostat
    !> Data or metadata used by this operation.
    character(len=*), intent(inout) :: iomsg
  end subroutine write_frmt_grp

  !> Write supplied data or metadata to a NetCDF object.
  module subroutine write_frmt_netcdf(grp, unit, iotype, v_list, iostat, iomsg)
    !> Dataset group to process.
    class(netcdf_type), intent(in) :: grp
    !> Data or metadata used by this operation.
    integer, intent(in) :: unit
    !> Data or metadata used by this operation.
    character(len=*), intent(in) :: iotype
    !> Data or metadata used by this operation.
    integer, intent(in) :: v_list(:)
    !> Data or metadata used by this operation.
    integer, intent(out) :: iostat
    !> Data or metadata used by this operation.
    character(len=*), intent(inout) :: iomsg
  end subroutine write_frmt_netcdf

  !> Write supplied data or metadata to a NetCDF object.
  module subroutine write_frmt_err(err, unit, iotype, v_list, iostat, iomsg)
    !> Error object updated if the operation fails.
    class(error_type), intent(in) :: err
    !> Data or metadata used by this operation.
    integer, intent(in) :: unit
    !> Data or metadata used by this operation.
    character(len=*), intent(in) :: iotype
    !> Data or metadata used by this operation.
    integer, intent(in) :: v_list(:)
    !> Data or metadata used by this operation.
    integer, intent(out) :: iostat
    !> Data or metadata used by this operation.
    character(len=*), intent(inout) :: iomsg
  end subroutine write_frmt_err

  !> Construct a dataset object from the supplied metadata and data.
  elemental module function new_dim_len_int32(name, len) result(dim)
    !> Name used to identify the NetCDF object.
    character(len=*), intent(in) :: name
    !> Data or metadata used by this operation.
    integer(int32), intent(in) :: len
    !> Result produced by this operation.
    type(dimension_type) :: dim
  end function new_dim_len_int32

  !> Construct a dataset object from the supplied metadata and data.
  elemental module function new_dim_len_int64(name, len) result(dim)
    !> Name used to identify the NetCDF object.
    character(len=*), intent(in) :: name
    !> Data or metadata used by this operation.
    integer(int64), intent(in) :: len
    !> Result produced by this operation.
    type(dimension_type) :: dim
  end function new_dim_len_int64

  !> Construct a dataset object from the supplied metadata and data.
  elemental module function new_dim_arg_int32(len, is_unlim) result(arg)
    !> Data or metadata used by this operation.
    integer(int32), intent(in) :: len
    !> Data or metadata used by this operation.
    logical, intent(in) :: is_unlim
    !> Result produced by this operation.
    type(dimension_argument_type) :: arg
  end function new_dim_arg_int32

  !> Construct a dataset object from the supplied metadata and data.
  elemental module function new_dim_arg_int64(len, is_unlim) result(arg)
    !> Data or metadata used by this operation.
    integer(int64), intent(in) :: len
    !> Data or metadata used by this operation.
    logical, intent(in) :: is_unlim
    !> Result produced by this operation.
    type(dimension_argument_type) :: arg
  end function new_dim_arg_int64

  !> Construct a dataset object from the supplied metadata and data.
  elemental module function new_dim_args(name, args) result(dim)
    !> Name used to identify the NetCDF object.
    character(len=*), intent(in) :: name
    !> Data or metadata used by this operation.
    type(dimension_argument_type), intent(in) :: args
    !> Result produced by this operation.
    type(dimension_type) :: dim
  end function new_dim_args

  logical elemental module function eq_dim(x, y)
    type(dimension_type), intent(in) :: x, y
  end function eq_dim

  logical elemental module function neq_dim(x, y)
    type(dimension_type), intent(in) :: x, y
  end function neq_dim

  logical elemental module function eq_att(x, y) result(is_equal)
    type(attribute_type), intent(in) :: x, y
  end function eq_att

  logical elemental module function neq_att(x, y) result(is_equal)
    type(attribute_type), intent(in) :: x, y
  end function neq_att

  logical elemental module function eq_var(x, y) result(is_equal)
    type(variable_type), intent(in) :: x, y
  end function eq_var

  logical elemental module function neq_var(x, y) result(is_equal)
    type(variable_type), intent(in) :: x, y
  end function neq_var

  !> Query and return requested NetCDF metadata.
  pure module function get_size(var, dim) result(n)
    !> Variable to process.
    type(variable_type), intent(in) :: var
    !> Dimension to process.
    integer, intent(in), optional :: dim
    !> Result produced by this operation.
    integer(int64) :: n
  end function get_size

  !> Query and return requested NetCDF metadata.
  pure module function get_shape(var) result(extents)
    !> Variable to process.
    type(variable_type), intent(in) :: var
    !> Result produced by this operation.
    integer, allocatable :: extents(:)
  end function get_shape

  !> Perform the sum_vars operation.
  module function sum_vars(vars) result(total)
    !> Variables to process or add to the dataset.
    type(variable_type), intent(in) :: vars(:)
    !> Result produced by this operation.
    type(variable_type) :: total
  end function sum_vars

  !> Perform the buffer_size operation.
  pure module function buffer_size(dtype, len, context) result(nbytes)
    !> Data or metadata used by this operation.
    integer(data_type), intent(in) :: dtype
    !> Data or metadata used by this operation.
    integer(int64), intent(in) :: len
    !> Data or metadata used by this operation.
    character(len=*), intent(in), optional :: context
    !> Result produced by this operation.
    integer :: nbytes
  end function buffer_size
end interface

end module nc4f_ds
