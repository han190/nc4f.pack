module nc4f_data_struct

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
  character(len=:), allocatable :: filename
  integer(c_int) :: mode = NC_NOWRITE
contains
  procedure, private :: write_frmt_grp => write_frmt_netcdf
end type netcdf_type

include "nc4f_data_struct_att_ctor.inc"
include "nc4f_data_struct_var_ctor.inc"
include "nc4f_data_struct_extract.inc"

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
  module subroutine init_att(att, name, dtype, len)
    type(attribute_type), intent(inout) :: att
    character(len=*), intent(in) :: name
    integer(data_type), intent(in) :: dtype
    integer(int64), intent(in) :: len
  end subroutine init_att

  module subroutine init_var(var, name, dtype, len, dims, atts, deep)
    type(variable_type), intent(inout) :: var
    character(len=*), intent(in) :: name
    integer(data_type), intent(in) :: dtype
    integer(int64), intent(in) :: len
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in), optional :: atts(:)
    logical, intent(in), optional :: deep
  end subroutine init_var

  module subroutine init_att_mold(att, mold)
    type(attribute_type), intent(inout) :: att
    type(attribute_type), intent(in) :: mold
  end subroutine init_att_mold

  module subroutine init_var_mold(var, mold)
    type(variable_type), intent(inout) :: var
    type(variable_type), intent(in) :: mold
  end subroutine init_var_mold

  module function new_dataset_empty(name, atts, deep) result(grp)
    character(len=*), intent(in) :: name
    type(attribute_type), intent(in), optional :: atts(:)
    logical, intent(in), optional :: deep
    type(group_type) :: grp
  end function new_dataset_empty

  module function new_dataset_vars(name, vars, atts, deep) result(grp)
    character(len=*), intent(in) :: name
    type(variable_type), intent(in) :: vars(:)
    type(attribute_type), intent(in), optional :: atts(:)
    logical, intent(in), optional :: deep
    type(group_type) :: grp
  end function new_dataset_vars

  module function new_dataset_grps(name, grps, atts, deep) result(grp)
    character(len=*), intent(in) :: name
    type(group_type), intent(in) :: grps(:)
    type(attribute_type), intent(in), optional :: atts(:)
    logical, intent(in), optional :: deep
    type(group_type) :: grp
  end function new_dataset_grps

  module function new_dataset_all(name, vars, grps, atts, deep) result(grp)
    character(len=*), intent(in) :: name
    type(variable_type), intent(in) :: vars(:)
    type(group_type), intent(in) :: grps(:)
    type(attribute_type), intent(in), optional :: atts(:)
    logical, intent(in), optional :: deep
    type(group_type) :: grp
  end function new_dataset_all

  module subroutine new_dataset_(grp, name, vars, grps, atts, deep)
    type(group_type), intent(out) :: grp
    character(len=*), intent(in) :: name
    type(variable_type), intent(in), optional :: vars(:)
    type(group_type), intent(in), optional :: grps(:)
    type(attribute_type), intent(in), optional :: atts(:)
    logical, intent(in), optional :: deep
  end subroutine new_dataset_

  module impure elemental subroutine clone_att(src, dest)
    type(attribute_type), intent(in) :: src
    type(attribute_type), intent(out) :: dest
  end subroutine clone_att

  module impure elemental subroutine clone_var(src, dest)
    type(variable_type), intent(in) :: src
    type(variable_type), intent(out) :: dest
  end subroutine clone_var

  module impure elemental subroutine clone_grp(src, dest)
    type(group_type), intent(in) :: src
    type(group_type), intent(out) :: dest
  end subroutine clone_grp

  module pure subroutine validate_att(att, dtype, context)
    type(attribute_type), intent(in) :: att
    integer(data_type), intent(in), optional :: dtype
    character(len=*), intent(in) :: context
  end subroutine validate_att

  module pure subroutine validate_var(var, dtype, rank, context)
    type(variable_type), intent(in) :: var
    integer(data_type), intent(in), optional :: dtype
    integer, intent(in), optional :: rank
    character(len=*), intent(in) :: context
  end subroutine validate_var

  module function buffer2cptr_att(att) result(cptr)
    type(attribute_type), target, intent(in) :: att
    type(c_ptr) :: cptr
  end function buffer2cptr_att

  module function buffer2cptr_var(var) result(cptr)
    type(variable_type), target, intent(in) :: var
    type(c_ptr) :: cptr
  end function buffer2cptr_var

  module subroutine write_frmt_att(att, unit, iotype, v_list, iostat, iomsg)
    class(attribute_type), intent(in) :: att
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

  module subroutine write_frmt_var(var, unit, iotype, v_list, iostat, iomsg)
    class(variable_type), intent(in) :: var
    integer, intent(in) :: unit
    character(len=*), intent(in) :: iotype
    integer, intent(in) :: v_list(:)
    integer, intent(out) :: iostat
    character(len=*), intent(inout) :: iomsg
  end subroutine write_frmt_var

  module subroutine write_frmt_grp(grp, unit, iotype, v_list, iostat, iomsg)
    class(group_type), intent(in) :: grp
    integer, intent(in) :: unit
    character(len=*), intent(in) :: iotype
    integer, intent(in) :: v_list(:)
    integer, intent(out) :: iostat
    character(len=*), intent(inout) :: iomsg
  end subroutine write_frmt_grp

  module subroutine write_frmt_netcdf(grp, unit, iotype, v_list, iostat, iomsg)
    class(netcdf_type), intent(in) :: grp
    integer, intent(in) :: unit
    character(len=*), intent(in) :: iotype
    integer, intent(in) :: v_list(:)
    integer, intent(out) :: iostat
    character(len=*), intent(inout) :: iomsg
  end subroutine write_frmt_netcdf

  module subroutine write_frmt_err(err, unit, iotype, v_list, iostat, iomsg)
    class(error_type), intent(in) :: err
    integer, intent(in) :: unit
    character(len=*), intent(in) :: iotype
    integer, intent(in) :: v_list(:)
    integer, intent(out) :: iostat
    character(len=*), intent(inout) :: iomsg
  end subroutine write_frmt_err

  module elemental function new_dim_len_int32(name, len) result(dim)
    character(len=*), intent(in) :: name
    integer(int32), intent(in) :: len
    type(dimension_type) :: dim
  end function new_dim_len_int32

  module elemental function new_dim_len_int64(name, len) result(dim)
    character(len=*), intent(in) :: name
    integer(int64), intent(in) :: len
    type(dimension_type) :: dim
  end function new_dim_len_int64

  module elemental function new_dim_arg_int32(len, is_unlim) result(arg)
    integer(int32), intent(in) :: len
    logical, intent(in) :: is_unlim
    type(dimension_argument_type) :: arg
  end function new_dim_arg_int32

  module elemental function new_dim_arg_int64(len, is_unlim) result(arg)
    integer(int64), intent(in) :: len
    logical, intent(in) :: is_unlim
    type(dimension_argument_type) :: arg
  end function new_dim_arg_int64

  module elemental function new_dim_args(name, args) result(dim)
    character(len=*), intent(in) :: name
    type(dimension_argument_type), intent(in) :: args
    type(dimension_type) :: dim
  end function new_dim_args

  module elemental logical function eq_dim(x, y)
    type(dimension_type), intent(in) :: x, y
  end function eq_dim

  module elemental logical function neq_dim(x, y)
    type(dimension_type), intent(in) :: x, y
  end function neq_dim

  module elemental logical function eq_att(x, y) result(is_equal)
    type(attribute_type), intent(in) :: x, y
  end function eq_att

  module elemental logical function neq_att(x, y) result(is_equal)
    type(attribute_type), intent(in) :: x, y
  end function neq_att

  module elemental logical function eq_var(x, y) result(is_equal)
    type(variable_type), intent(in) :: x, y
  end function eq_var

  module elemental logical function neq_var(x, y) result(is_equal)
    type(variable_type), intent(in) :: x, y
  end function neq_var

  module pure function get_size(var, dim) result(n)
    type(variable_type), intent(in) :: var
    integer, intent(in), optional :: dim
    integer(int64) :: n
  end function get_size

  module pure function get_shape(var) result(extents)
    type(variable_type), intent(in) :: var
    integer, allocatable :: extents(:)
  end function get_shape

  module function sum_vars(vars) result(total)
    type(variable_type), intent(in) :: vars(:)
    type(variable_type) :: total
  end function sum_vars

  module pure function buffer_size(dtype, len, context) result(nbytes)
    integer(data_type), intent(in) :: dtype
    integer(int64), intent(in) :: len
    character(len=*), intent(in), optional :: context
    integer :: nbytes
  end function buffer_size
end interface

end module nc4f_data_struct
