module nc4f_ds

use, intrinsic :: iso_fortran_env, only: &
  & int8, int16, int32, int64, real32, real64
use, intrinsic :: iso_c_binding, only: &
  & c_f_pointer, c_int, c_loc, c_null_ptr, c_ptr
use, non_intrinsic :: nc4f_c_interface, only: &
  & NC_EBADID, NC_EBADDIM, NC_EBADGRPID, NC_EEDGE, NC_EINVAL, NC_EINVALCOORDS, &
  & NC_ENOGRP, NC_ENOTATT, NC_ENOTFOUND, NC_ENOTVAR, NC_NOERR, NC_NOWRITE, &
  & NC_EBADNAME, NC_EMAXNAME, NC_ENAMEINUSE, NC_MAX_NAME
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
public :: rename_attribute, rename_variable, rename_group, NC_EBADNAME, NC_EMAXNAME, NC_ENAMEINUSE
private

integer(int32), parameter :: INVALID_INT32 = -2147483647_int32
integer(int64), parameter :: INVALID_INT64 = -9223372036854775807_int64

type :: error_type
  !! Result of an nc4f operation that was allowed to return normally on error.
  !!
  !! A zero `code` denotes success. On failure, `msg` contains an nc4f
  !! diagnostic and `code` preserves the originating NetCDF status.
  integer(c_int) :: code = NC_NOERR
  character(len=:), allocatable :: msg
contains
  procedure, private :: write_frmt_err
  generic, public :: write(formatted) => write_frmt_err
end type error_type

enum, bind(c)
  !! Type constant used for NetCDF external data types.
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

type :: dimension_type
  !! NetCDF dimension metadata remains a small value object.
  integer(c_int) :: id = INVALID_INT32
  character(len=:), allocatable :: name
  integer(int64) :: len = INVALID_INT64
  logical :: is_unlim = .false.
contains
  procedure, private :: write_frmt_dim
  generic, public :: write(formatted) => write_frmt_dim
end type dimension_type

type :: dimension_argument_type
  !! Arguments used to construct an unlimited dimension with `.and.`.
  integer(int64) :: len = INVALID_INT64
  logical :: is_unlim = .false.
end type dimension_argument_type

type :: attribute_type
  !! NetCDF attribute metadata and values.
  !!
  !! `buffer` owns copied data, while `ptr` borrows contiguous caller storage.
  !!
  !! Exactly one backing store is present for a nonempty value: either
  !! `buffer` is allocated or `ptr` is associated.  The allocatable component
  !! gives copied values normal Fortran lifetime management; the pointer is
  !! reserved exclusively for caller-owned storage.
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

type :: variable_type
  !! NetCDF variable metadata, dimensions, attributes, and values.
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

type :: group_type
  !! NetCDF group metadata.
  !!
  !! Child groups are pointer-backed so intrinsic assignment shares the child
  !! tree instead of recursively copying it.
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

type, extends(group_type) :: netcdf_type
  !! An open NetCDF file: a root-group value plus file-specific state.
  character(len=:), allocatable :: file
  integer(c_int) :: mode = NC_NOWRITE
contains
  procedure, private :: write_frmt_grp => write_frmt_netcdf
end type netcdf_type

include "nc4f_ds_attribute_constructor.inc"
include "nc4f_ds_variable_constructor.inc"
include "nc4f_ds_extract.inc"

interface rename_attribute
  module procedure :: rename_att_att, rename_att_var, rename_att_grp
end interface rename_attribute

interface rename_group
  module procedure :: rename_grp_grp, rename_grp_par
end interface rename_group

interface rename_variable
  module procedure :: rename_var_var, rename_var_grp
end interface rename_variable

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
  pure module subroutine rename_grp_grp(grp, new_name, err)
    !! Rename a non-root group in memory, preserving its contents and child aliases.
    class(group_type), intent(inout) :: grp
    character(len=*), intent(in) :: new_name
    type(error_type), intent(out), optional :: err
  end subroutine rename_grp_grp

  pure module subroutine rename_grp_par(parent, old_name, new_name, err)
    !! Rename one direct child in parent%grps without accessing a file.
    class(group_type), intent(inout) :: parent
    character(len=*), intent(in) :: old_name, new_name
    type(error_type), intent(out), optional :: err
  end subroutine rename_grp_par

  pure module subroutine chk_nc_name(name, err, context)
    !! Shared NetCDF name validation, private to the data-model module/submodules.
    character(len=*), intent(in) :: name
    type(error_type), intent(out) :: err
    character(len=*), intent(in), optional :: context
  end subroutine chk_nc_name

  pure module subroutine ret_ds_err(op_err, err)
    !! Apply the optional-error convention for data-model operations.
    type(error_type), intent(in) :: op_err
    type(error_type), intent(out), optional :: err
  end subroutine ret_ds_err

  pure module subroutine rename_var_var(var, new_name, err)
    !! Rename an independent variable in memory; preserve its metadata and storage.
    type(variable_type), intent(inout) :: var
    character(len=*), intent(in) :: new_name
    type(error_type), intent(out), optional :: err
  end subroutine rename_var_var

  pure module subroutine rename_var_grp(grp, old_name, new_name, err)
    !! Rename a direct member of grp%vars in memory, without accessing a file.
    class(group_type), intent(inout) :: grp
    character(len=*), intent(in) :: old_name, new_name
    type(error_type), intent(out), optional :: err
  end subroutine rename_var_grp

  pure module subroutine rename_att_att(att, new_name, err)
    !! Rename an independent attribute in memory; no file is accessed.
    type(attribute_type), intent(inout) :: att
    character(len=*), intent(in) :: new_name
    type(error_type), intent(out), optional :: err
  end subroutine rename_att_att

  pure module subroutine rename_att_var(var, old_name, new_name, err)
    !! Rename a variable attribute in memory, preserving its value and storage.
    type(variable_type), intent(inout) :: var
    character(len=*), intent(in) :: old_name, new_name
    type(error_type), intent(out), optional :: err
  end subroutine rename_att_var

  pure module subroutine rename_att_grp(grp, old_name, new_name, err)
    !! Rename a group/global attribute in memory, without accessing a file.
    class(group_type), intent(inout) :: grp
    character(len=*), intent(in) :: old_name, new_name
    type(error_type), intent(out), optional :: err
  end subroutine rename_att_grp

  elemental module subroutine init_att(att, name, dtype, len)
    !! Initialize a dataset object.
    type(attribute_type), intent(inout) :: att
    !! Attribute to process.
    character(len=*), intent(in) :: name
    !! Name used to identify the NetCDF object.
    integer(data_type), intent(in) :: dtype
    !! Data or metadata used by this operation.
    integer(int64), intent(in) :: len
    !! Data or metadata used by this operation.
  end subroutine init_att

  module subroutine init_var(var, name, dtype, len, dims, atts)
    !! Initialize a dataset object.
    type(variable_type), intent(inout) :: var
    !! Variable to process.
    character(len=*), intent(in) :: name
    !! Name used to identify the NetCDF object.
    integer(data_type), intent(in) :: dtype
    !! Data or metadata used by this operation.
    integer(int64), intent(in) :: len
    !! Data or metadata used by this operation.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the variable shape.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Attributes to process or attach.
  end subroutine init_var

  elemental module subroutine init_att_(att, name, dtype, len, deep)
    !! Initialize a dataset object.
    type(attribute_type), intent(inout) :: att
    !! Attribute to process.
    character(len=*), intent(in) :: name
    !! Name used to identify the NetCDF object.
    integer(data_type), intent(in) :: dtype
    !! Data or metadata used by this operation.
    integer(int64), intent(in) :: len
    !! Data or metadata used by this operation.
    logical, intent(in), optional :: deep
    !! Whether to make an owned deep copy of the data.
  end subroutine init_att_

  module subroutine init_var_(var, name, dtype, len, dims, atts, deep)
    !! Initialize a dataset object.
    type(variable_type), intent(inout) :: var
    !! Variable to process.
    character(len=*), intent(in) :: name
    !! Name used to identify the NetCDF object.
    integer(data_type), intent(in) :: dtype
    !! Data or metadata used by this operation.
    integer(int64), intent(in) :: len
    !! Data or metadata used by this operation.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the variable shape.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Attributes to process or attach.
    logical, intent(in), optional :: deep
    !! Whether to make an owned deep copy of the data.
  end subroutine init_var_

  module subroutine init_att_mold(att, name, mold, deep)
    !! Initialize a dataset object.
    type(attribute_type), intent(inout) :: att
    !! Attribute to process.
    character(len=*), intent(in) :: name
    !! Name used to identify the NetCDF object.
    type(attribute_type), target, intent(in) :: mold
    !! Data or metadata used by this operation.
    logical, intent(in), optional :: deep
    !! Whether to make an owned deep copy of the data.
  end subroutine init_att_mold

  module subroutine init_var_mold(var, name, mold, atts, deep)
    !! Initialize a dataset object.
    type(variable_type), intent(inout) :: var
    !! Variable to process.
    character(len=*), intent(in) :: name
    !! Name used to identify the NetCDF object.
    type(variable_type), target, intent(in) :: mold
    !! Data or metadata used by this operation.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Attributes to process or attach.
    logical, intent(in), optional :: deep
    !! Whether to make an owned deep copy of the data.
  end subroutine init_var_mold

  module function new_dataset_empty(name, atts, deep) result(grp)
    !! Construct a dataset object from the supplied metadata and data.
    character(len=*), intent(in) :: name
    !! Name used to identify the NetCDF object.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Attributes to process or attach.
    logical, intent(in), optional :: deep
    !! Whether to make an owned deep copy of the data.
    type(group_type) :: grp
    !! Result produced by this operation.
  end function new_dataset_empty

  module function new_dataset_vars(name, vars, atts, deep) result(grp)
    !! Construct a dataset object from the supplied metadata and data.
    character(len=*), intent(in) :: name
    !! Name used to identify the NetCDF object.
    type(variable_type), intent(in) :: vars(:)
    !! Variables to process or add to the dataset.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Attributes to process or attach.
    logical, intent(in), optional :: deep
    !! Whether to make an owned deep copy of the data.
    type(group_type) :: grp
    !! Result produced by this operation.
  end function new_dataset_vars

  module function new_dataset_grps(name, grps, atts, deep) result(grp)
    !! Construct a dataset object from the supplied metadata and data.
    character(len=*), intent(in) :: name
    !! Name used to identify the NetCDF object.
    type(group_type), intent(in) :: grps(:)
    !! Data or metadata used by this operation.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Attributes to process or attach.
    logical, intent(in), optional :: deep
    !! Whether to make an owned deep copy of the data.
    type(group_type) :: grp
    !! Result produced by this operation.
  end function new_dataset_grps

  module function new_dataset_all(name, vars, grps, atts, deep) result(grp)
    !! Construct a dataset object from the supplied metadata and data.
    character(len=*), intent(in) :: name
    !! Name used to identify the NetCDF object.
    type(variable_type), intent(in) :: vars(:)
    !! Variables to process or add to the dataset.
    type(group_type), intent(in) :: grps(:)
    !! Data or metadata used by this operation.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Attributes to process or attach.
    logical, intent(in), optional :: deep
    !! Whether to make an owned deep copy of the data.
    type(group_type) :: grp
    !! Result produced by this operation.
  end function new_dataset_all

  module subroutine new_dataset_(grp, name, vars, grps, atts, deep)
    !! Construct a dataset object from the supplied metadata and data.
    type(group_type), intent(out) :: grp
    !! Dataset group to process.
    character(len=*), intent(in) :: name
    !! Name used to identify the NetCDF object.
    type(variable_type), intent(in), optional :: vars(:)
    !! Variables to process or add to the dataset.
    type(group_type), intent(in), optional :: grps(:)
    !! Data or metadata used by this operation.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Attributes to process or attach.
    logical, intent(in), optional :: deep
    !! Whether to make an owned deep copy of the data.
  end subroutine new_dataset_

  impure elemental module subroutine clone_att(src, dest)
    !! Clone a dataset object and its data.
    type(attribute_type), intent(in) :: src
    !! Source object or group to read from.
    type(attribute_type), intent(out) :: dest
    !! Destination object or group to update.
  end subroutine clone_att

  impure elemental module subroutine clone_var(src, dest)
    !! Clone a dataset object and its data.
    type(variable_type), intent(in) :: src
    !! Source object or group to read from.
    type(variable_type), intent(out) :: dest
    !! Destination object or group to update.
  end subroutine clone_var

  impure elemental module subroutine clone_grp(src, dest)
    !! Clone a dataset object and its data.
    type(group_type), intent(in) :: src
    !! Source object or group to read from.
    type(group_type), intent(out) :: dest
    !! Destination object or group to update.
  end subroutine clone_grp

  pure module subroutine validate_att(att, dtype, context)
    !! Validate dataset buffer metadata before access.
    type(attribute_type), intent(in) :: att
    !! Attribute to process.
    integer(data_type), intent(in), optional :: dtype
    !! Data or metadata used by this operation.
    character(len=*), intent(in) :: context
    !! Data or metadata used by this operation.
  end subroutine validate_att

  pure module subroutine validate_var(var, dtype, rank, context)
    !! Validate dataset buffer metadata before access.
    type(variable_type), intent(in) :: var
    !! Variable to process.
    integer(data_type), intent(in), optional :: dtype
    !! Data or metadata used by this operation.
    integer, intent(in), optional :: rank
    !! Data or metadata used by this operation.
    character(len=*), intent(in) :: context
    !! Data or metadata used by this operation.
  end subroutine validate_var

  module function buffer2cptr_att(att) result(cptr)
    !! Perform the buffer2cptr_att operation.
    type(attribute_type), target, intent(in) :: att
    !! Attribute to process.
    type(c_ptr) :: cptr
    !! Result produced by this operation.
  end function buffer2cptr_att

  module function buffer2cptr_var(var) result(cptr)
    !! Perform the buffer2cptr_var operation.
    type(variable_type), target, intent(in) :: var
    !! Variable to process.
    type(c_ptr) :: cptr
    !! Result produced by this operation.
  end function buffer2cptr_var

  module subroutine write_frmt_att(att, unit, iotype, v_list, iostat, iomsg)
    !! Write supplied data or metadata to a NetCDF object.
    class(attribute_type), intent(in) :: att
    !! Attribute to process.
    integer, intent(in) :: unit
    !! Data or metadata used by this operation.
    character(len=*), intent(in) :: iotype
    !! Data or metadata used by this operation.
    integer, intent(in) :: v_list(:)
    !! Data or metadata used by this operation.
    integer, intent(out) :: iostat
    !! Data or metadata used by this operation.
    character(len=*), intent(inout) :: iomsg
    !! Data or metadata used by this operation.
  end subroutine write_frmt_att

  module subroutine write_frmt_dim(dim, unit, iotype, v_list, iostat, iomsg)
    !! Write supplied data or metadata to a NetCDF object.
    class(dimension_type), intent(in) :: dim
    !! Dimension to process.
    integer, intent(in) :: unit
    !! Data or metadata used by this operation.
    character(len=*), intent(in) :: iotype
    !! Data or metadata used by this operation.
    integer, intent(in) :: v_list(:)
    !! Data or metadata used by this operation.
    integer, intent(out) :: iostat
    !! Data or metadata used by this operation.
    character(len=*), intent(inout) :: iomsg
    !! Data or metadata used by this operation.
  end subroutine write_frmt_dim

  module subroutine write_frmt_var(var, unit, iotype, v_list, iostat, iomsg)
    !! Write supplied data or metadata to a NetCDF object.
    class(variable_type), intent(in) :: var
    !! Variable to process.
    integer, intent(in) :: unit
    !! Data or metadata used by this operation.
    character(len=*), intent(in) :: iotype
    !! Data or metadata used by this operation.
    integer, intent(in) :: v_list(:)
    !! Data or metadata used by this operation.
    integer, intent(out) :: iostat
    !! Data or metadata used by this operation.
    character(len=*), intent(inout) :: iomsg
    !! Data or metadata used by this operation.
  end subroutine write_frmt_var

  module subroutine write_frmt_grp(grp, unit, iotype, v_list, iostat, iomsg)
    !! Write supplied data or metadata to a NetCDF object.
    class(group_type), intent(in) :: grp
    !! Dataset group to process.
    integer, intent(in) :: unit
    !! Data or metadata used by this operation.
    character(len=*), intent(in) :: iotype
    !! Data or metadata used by this operation.
    integer, intent(in) :: v_list(:)
    !! Data or metadata used by this operation.
    integer, intent(out) :: iostat
    !! Data or metadata used by this operation.
    character(len=*), intent(inout) :: iomsg
    !! Data or metadata used by this operation.
  end subroutine write_frmt_grp

  module subroutine write_frmt_netcdf(grp, unit, iotype, v_list, iostat, iomsg)
    !! Write supplied data or metadata to a NetCDF object.
    class(netcdf_type), intent(in) :: grp
    !! Dataset group to process.
    integer, intent(in) :: unit
    !! Data or metadata used by this operation.
    character(len=*), intent(in) :: iotype
    !! Data or metadata used by this operation.
    integer, intent(in) :: v_list(:)
    !! Data or metadata used by this operation.
    integer, intent(out) :: iostat
    !! Data or metadata used by this operation.
    character(len=*), intent(inout) :: iomsg
    !! Data or metadata used by this operation.
  end subroutine write_frmt_netcdf

  module subroutine write_frmt_err(err, unit, iotype, v_list, iostat, iomsg)
    !! Write supplied data or metadata to a NetCDF object.
    class(error_type), intent(in) :: err
    !! Error object updated if the operation fails.
    integer, intent(in) :: unit
    !! Data or metadata used by this operation.
    character(len=*), intent(in) :: iotype
    !! Data or metadata used by this operation.
    integer, intent(in) :: v_list(:)
    !! Data or metadata used by this operation.
    integer, intent(out) :: iostat
    !! Data or metadata used by this operation.
    character(len=*), intent(inout) :: iomsg
    !! Data or metadata used by this operation.
  end subroutine write_frmt_err

  elemental module function new_dim_len_int32(name, len) result(dim)
    !! Construct a dataset object from the supplied metadata and data.
    character(len=*), intent(in) :: name
    !! Name used to identify the NetCDF object.
    integer(int32), intent(in) :: len
    !! Data or metadata used by this operation.
    type(dimension_type) :: dim
    !! Result produced by this operation.
  end function new_dim_len_int32

  elemental module function new_dim_len_int64(name, len) result(dim)
    !! Construct a dataset object from the supplied metadata and data.
    character(len=*), intent(in) :: name
    !! Name used to identify the NetCDF object.
    integer(int64), intent(in) :: len
    !! Data or metadata used by this operation.
    type(dimension_type) :: dim
    !! Result produced by this operation.
  end function new_dim_len_int64

  elemental module function new_dim_arg_int32(len, is_unlim) result(arg)
    !! Construct a dataset object from the supplied metadata and data.
    integer(int32), intent(in) :: len
    !! Data or metadata used by this operation.
    logical, intent(in) :: is_unlim
    !! Data or metadata used by this operation.
    type(dimension_argument_type) :: arg
    !! Result produced by this operation.
  end function new_dim_arg_int32

  elemental module function new_dim_arg_int64(len, is_unlim) result(arg)
    !! Construct a dataset object from the supplied metadata and data.
    integer(int64), intent(in) :: len
    !! Data or metadata used by this operation.
    logical, intent(in) :: is_unlim
    !! Data or metadata used by this operation.
    type(dimension_argument_type) :: arg
    !! Result produced by this operation.
  end function new_dim_arg_int64

  elemental module function new_dim_args(name, args) result(dim)
    !! Construct a dataset object from the supplied metadata and data.
    character(len=*), intent(in) :: name
    !! Name used to identify the NetCDF object.
    type(dimension_argument_type), intent(in) :: args
    !! Data or metadata used by this operation.
    type(dimension_type) :: dim
    !! Result produced by this operation.
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

  pure module function get_size(var, dim) result(n)
    !! Query and return requested NetCDF metadata.
    type(variable_type), intent(in) :: var
    !! Variable to process.
    integer, intent(in), optional :: dim
    !! Dimension to process.
    integer(int64) :: n
    !! Result produced by this operation.
  end function get_size

  pure module function get_shape(var) result(extents)
    !! Query and return requested NetCDF metadata.
    type(variable_type), intent(in) :: var
    !! Variable to process.
    integer, allocatable :: extents(:)
    !! Result produced by this operation.
  end function get_shape

  module function sum_vars(vars) result(total)
    !! Perform the sum_vars operation.
    type(variable_type), intent(in) :: vars(:)
    !! Variables to process or add to the dataset.
    type(variable_type) :: total
    !! Result produced by this operation.
  end function sum_vars

  pure module function buffer_size(dtype, len, context) result(nbytes)
    !! Perform the buffer_size operation.
    integer(data_type), intent(in) :: dtype
    !! Data or metadata used by this operation.
    integer(int64), intent(in) :: len
    !! Data or metadata used by this operation.
    character(len=*), intent(in), optional :: context
    !! Data or metadata used by this operation.
    integer :: nbytes
    !! Result produced by this operation.
  end function buffer_size
end interface

end module nc4f_ds
