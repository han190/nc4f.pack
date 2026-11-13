module nc4f_data

use, intrinsic :: iso_fortran_env, only: &
  & int8, int16, int32, int64, real32, real64
use, intrinsic :: iso_c_binding, only: &
  & c_f_pointer, c_int, c_loc, c_null_ptr, c_ptr
implicit none (type, external)

public :: attribute_type, dimension_type, error_type, delete_attribute, &
  & group_type, netcdf_type, variable_type, coordinate_type, &
  & abstract_variable_type, expression_type, &
  & coordinate_at, coordinate_index, evaluate, &
  & initialize, nameof, typeof, &
  & storage_type, set_storage, datarray, dataset, extract, &
  & rename_attribute, rename_variable, rename_group, rename_dimension, &
  & operator(.att.), operator(.and.), operator(.dim.), operator(.exists.), &
  & operator(==), operator(/=), operator(+), operator(-), &
  & operator(*), operator(/), operator(**), assignment(=), &
  & abs, sqrt, exp, log, log10, sin, cos, tan, &
  & asin, acos, atan, sinh, cosh, tanh, asinh, acosh, atanh, &
  & erf, erfc, erfc_scaled, gamma, log_gamma, &
  & bessel_j0, bessel_j1, bessel_y0, bessel_y1, &
  & dim, sign, mod, modulo, atan2, hypot, &
  & shape, size, sum, buffer_size, buffer2cptr, &
  & validate, error_msg, return_err, has_err, compute_buffer_size, compute_size
private

integer(int32), parameter :: INVALID_INT32 = -2147483647_int32
integer(int64), parameter :: INVALID_INT64 = -9223372036854775807_int64

enum, bind(c)
  !! Operations represented by nodes in a deferred expression.
  enumerator :: OP_INVALID = -1
  enumerator :: OP_LEAF = 0
  enumerator :: OP_ADD = 1
  enumerator :: OP_SUB = 2
  enumerator :: OP_MUL = 3
  enumerator :: OP_DIV = 4
  enumerator :: OP_POW = 5
  enumerator :: OP_INT32_POW = 6
  enumerator :: OP_INT64_POW = 7
  enumerator :: OP_REAL32_POW = 8
  enumerator :: OP_REAL64_POW = 9
  enumerator :: OP_INT8_POW = 10
  enumerator :: OP_INT16_POW = 11
  enumerator :: OP_SCALAR_INT8 = 12
  enumerator :: OP_SCALAR_INT16 = 13
  enumerator :: OP_SCALAR_INT32 = 14
  enumerator :: OP_SCALAR_INT64 = 15
  enumerator :: OP_SCALAR_REAL32 = 16
  enumerator :: OP_SCALAR_REAL64 = 17
  enumerator :: OP_ABS = 18
  enumerator :: OP_SQRT = 19
  enumerator :: OP_EXP = 20
  enumerator :: OP_LOG = 21
  enumerator :: OP_LOG10 = 22
  enumerator :: OP_SIN = 23
  enumerator :: OP_COS = 24
  enumerator :: OP_TAN = 25
  enumerator :: OP_ASIN = 26
  enumerator :: OP_ACOS = 27
  enumerator :: OP_ATAN = 28
  enumerator :: OP_SINH = 29
  enumerator :: OP_COSH = 30
  enumerator :: OP_TANH = 31
  enumerator :: OP_ASINH = 32
  enumerator :: OP_ACOSH = 33
  enumerator :: OP_ATANH = 34
  enumerator :: OP_ERF = 35
  enumerator :: OP_ERFC = 36
  enumerator :: OP_ERFC_SCALED = 37
  enumerator :: OP_GAMMA = 38
  enumerator :: OP_LOG_GAMMA = 39
  enumerator :: OP_BESSEL_J0 = 40
  enumerator :: OP_BESSEL_J1 = 41
  enumerator :: OP_BESSEL_Y0 = 42
  enumerator :: OP_BESSEL_Y1 = 43
  enumerator :: OP_DIM = 44
  enumerator :: OP_SIGN = 45
  enumerator :: OP_MOD = 46
  enumerator :: OP_MODULO = 47
  enumerator :: OP_ATAN2 = 48
  enumerator :: OP_HYPOT = 49
end enum
integer, parameter :: operation_kind = kind(OP_INVALID)

enum, bind(c)
  !! Preserve the current NetCDF status values without importing the C binding.
  !! These names and values are private to the in-memory model.
  enumerator :: NO_ERROR = 0
  enumerator :: BADID = -33
  enumerator :: INVALID = -36
  enumerator :: INVALID_COORDS = -40
  enumerator :: NAME_IN_USE = -42
  enumerator :: NO_ATTRIBUTE = -43
  enumerator :: BAD_DIMENSION = -46
  enumerator :: NO_VARIABLE = -49
  enumerator :: MAX_NAME = -53
  enumerator :: EDGE = -57
  enumerator :: BAD_NAME = -59
  enumerator :: NO_MEMORY = -61
  enumerator :: NOT_FOUND = -90
  enumerator :: BAD_GROUP_ID = -116
  enumerator :: NO_GROUP = -125
end enum
integer, parameter :: error_code = kind(NO_ERROR)

enum, bind(c)
  enumerator :: MODE_READ_ONLY = 0
  enumerator :: ENDIAN_NATIVE = 0
  enumerator :: ENDIAN_LITTLE = 1
  enumerator :: ENDIAN_BIG = 2
end enum
integer(c_int), parameter :: MAX_NAME_LENGTH = 256_c_int

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

type :: error_type
  !! Result of an nc4f operation that was allowed to return normally on error.
  integer(error_code) :: code = NO_ERROR
  !! NetCDF status code; zero denotes success.
  character(len=:), allocatable :: fname
  !! Operation name; required and nonblank on failure.
  character(len=:), allocatable :: msg
  !! Diagnostic text; required and nonblank on failure.
contains
  procedure, private :: write_frmt_err
  generic, public :: write(formatted) => write_frmt_err
end type error_type

interface error_type
  module procedure :: initialize_err
end interface error_type

type :: dimension_type
  !! NetCDF dimension metadata remains a small value object.
  integer(c_int) :: id = INVALID_INT32
  !! NetCDF dimension identifier; the initial value marks an unassigned
  !! dimension.
  character(len=:), allocatable :: name
  !! Local dimension name.
  integer(int64) :: len = INVALID_INT64
  !! Dimension length in elements; the initial value marks an unknown length.
  logical :: is_unlim = .false.
  !! Whether the dimension may grow when records are written.
contains
  procedure, private :: write_frmt_dim
  generic, public :: write(formatted) => write_frmt_dim
end type dimension_type

type :: dimension_argument_type
  !! Arguments used to construct an unlimited dimension with `.and.`.
  integer(int64) :: len = INVALID_INT64
  !! Dimension length supplied to the `.dim.` constructor.
  logical :: is_unlim = .false.
  !! Whether the constructed dimension is unlimited.
end type dimension_argument_type

type :: attribute_type
  !! NetCDF attribute metadata and values.
  integer(c_int) :: id = INVALID_INT32
  !! NetCDF attribute identifier; the initial value marks an unassigned
  !! attribute.
  character(len=:), allocatable :: name
  !! Local attribute name.
  integer(data_type) :: dtype = NAT_TYPE
  !! NetCDF external data-type code; NAT_TYPE marks an unspecified type.
  integer(int64) :: len = INVALID_INT64
  !! Number of attribute elements; the initial value marks an unknown length.
  integer(int8), allocatable :: buffer(:)
  !! Owned bytes of a copied value.
  integer(int8), contiguous, pointer :: ptr(:) => null()
  !! Borrowed contiguous value bytes; the caller retains ownership and lifetime.
contains
  procedure, private :: write_frmt_att
  generic, public :: write(formatted) => write_frmt_att
end type attribute_type

type :: storage_type
  !! Requested or inquired per-variable NetCDF storage settings. Negative flags
  !! mean that the setting was not requested.
  integer(int64), allocatable :: chunks(:)
  !! Chunk lengths in Fortran dimension order, when chunking is requested.
  integer(c_int) :: deflate_level = -1
  !! Compression level from 0 through 9; negative means unspecified.
  integer(c_int) :: shuffle = -1
  !! Shuffle filter flag; negative means unspecified.
  integer(c_int) :: fletcher32 = -1
  !! Fletcher32 checksum flag; negative means unspecified.
  integer(c_int) :: endian = -1
  !! NetCDF byte-order setting; negative means unspecified.
  integer(c_int) :: no_fill = -1
  !! No-fill flag; negative means unspecified.
  type(attribute_type), allocatable :: fill_value
  !! Scalar `_FillValue` attribute used for uninitialized elements, when
  !! supplied.
end type storage_type

type, abstract :: abstract_variable_type
  !! Shared metadata and owned storage for variables and coordinate mappings.
  character(len=:), allocatable :: name
  integer(data_type) :: dtype = NAT_TYPE
  integer(int64) :: len = INVALID_INT64
  !! Number of locations indexed by dims.
  type(dimension_type), allocatable :: dims(:)
  type(attribute_type), allocatable :: atts(:)
  integer(int8), allocatable :: buffer(:)
end type abstract_variable_type

type, extends(abstract_variable_type) :: coordinate_type
  !! One owned numeric coordinate array over its dims.
end type coordinate_type

type, extends(abstract_variable_type) :: variable_type
  !! NetCDF variable metadata, dimensions, attributes, and values.
  integer(c_int) :: id = INVALID_INT32
  !! NetCDF variable identifier; the initial value marks an unassigned variable.
  type(storage_type), allocatable :: storage
  !! Optional per-variable chunking, filters, byte order, and fill settings.
  integer(int8), contiguous, pointer :: ptr(:) => null()
  !! Borrowed contiguous data bytes; the caller retains ownership and lifetime.
  type(coordinate_type), allocatable :: coords(:)
  !! Optional owned mappings over ordered subsets of this variable's dims.
contains
  procedure, private :: write_frmt_var
  generic, public :: write(formatted) => write_frmt_var
end type variable_type

type :: expression_type
  !! Deferred arithmetic on variables with matching ordered dimensions.
  !! Every referenced variable and borrowed target must remain alive. Values
  !! may change before evaluation; storage must not be replaced or released.
  private
  integer(operation_kind) :: operation = OP_INVALID
  !! Integer exponent or scalar operand, selected by `operation`.
  integer(int64) :: exp_int = 1_int64
  !! Real exponent or scalar operand, selected by `operation`.
  real(real64) :: exp_real = 1.0_real64
  type(variable_type), pointer :: leaf => null()
  type(expression_type), allocatable :: left, right
end type expression_type

type :: group_type
  !! NetCDF group metadata.
  integer(c_int) :: id = INVALID_INT32
  !! NetCDF group identifier; the initial value marks an unassigned group.
  character(len=:), allocatable :: name
  !! Local group name.
  type(dimension_type), allocatable :: dims(:)
  !! Dimensions defined in this group.
  type(attribute_type), allocatable :: atts(:)
  !! Group-level attributes.
  type(variable_type), allocatable :: vars(:)
  !! Variables directly contained in this group.
  type(group_type), pointer :: grps(:) => null()
  !! Child groups; pointer assignment may share the child tree.
contains
  procedure, private :: write_frmt_grp
  generic, public :: write(formatted) => write_frmt_grp
end type group_type

type, extends(group_type) :: netcdf_type
  !! An open NetCDF file: a root-group value plus file-specific state.
  character(len=:), allocatable :: file
  !! Path of the open NetCDF file.
  integer(c_int) :: mode = MODE_READ_ONLY
  !! File access mode; defaults to read-only.
contains
  procedure, private :: write_frmt_grp => write_frmt_netcdf
end type netcdf_type

include "nc4f_data_attribute_constructor.inc"
include "nc4f_data_variable_constructor.inc"
include "nc4f_data_extract.inc"
include "nc4f_data_arithmetic.inc"
include "nc4f_data_intrinsic.inc"

interface rename_dimension
  module procedure :: rename_dim_dim, rename_dim_var, rename_dim_grp
end interface rename_dimension

interface delete_attribute
  module procedure :: del_att_var, del_att_grp
end interface delete_attribute

interface rename_attribute
  module procedure :: rename_att_att, rename_att_var, rename_att_grp
end interface rename_attribute

interface rename_group
  module procedure :: rename_grp_grp, rename_grp_par
end interface rename_group

interface rename_variable
  module procedure :: rename_var_var, rename_var_grp
end interface rename_variable

interface assignment(=)
  module procedure :: assign_expr
end interface assignment(=)

interface operator(.exists.)
  module procedure :: has_err
end interface operator(.exists.)

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
  module procedure :: eq_coord
end interface operator(==)

interface operator(/=)
  module procedure :: neq_att
  module procedure :: neq_dim
  module procedure :: neq_var
  module procedure :: neq_coord
end interface operator(/=)

interface size
  module procedure :: get_size
end interface size

interface shape
  module procedure :: get_shape
end interface shape

interface nameof
  module procedure :: nameof_att, nameof_dim, nameof_var, nameof_grp
end interface nameof

interface typeof
  module procedure :: typeof_att, typeof_var
end interface typeof

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
  module procedure :: validate_coordinate
  module procedure :: validate_nc_name
end interface validate

interface dataset
  module procedure :: new_dataset_empty
  module procedure :: new_dataset_vars
  module procedure :: new_dataset_grps
  module procedure :: new_dataset_all
end interface dataset

include "nc4f_data_coordinate_constructor.inc"

interface coordinate_at
  module procedure :: coordinate_at_int8, coordinate_at_int16, &
    & coordinate_at_int32, coordinate_at_int64, &
    & coordinate_at_real32, coordinate_at_real64
end interface coordinate_at

interface
  pure module subroutine validate_coordinate(coord, err)
    type(coordinate_type), intent(in) :: coord
    type(error_type), intent(out) :: err
  end subroutine validate_coordinate

  pure elemental module function eq_coord(a, b) result(equal)
    type(coordinate_type), intent(in) :: a, b
    logical :: equal
  end function eq_coord

  pure elemental module function neq_coord(a, b) result(unequal)
    type(coordinate_type), intent(in) :: a, b
    logical :: unequal
  end function neq_coord

  pure module subroutine validate_coordinate_for_var(coords, var, err)
    type(coordinate_type), intent(in) :: coords(:)
    type(variable_type), intent(in) :: var
    type(error_type), intent(out) :: err
  end subroutine validate_coordinate_for_var

  pure module function coordinate_index(coords, name) result(index)
    type(coordinate_type), intent(in) :: coords(:)
    character(len=*), intent(in) :: name
    integer :: index
  end function coordinate_index

  module subroutine coordinate_at_int8(coord, indices, value, err)
    type(coordinate_type), target, intent(in) :: coord
    integer, intent(in) :: indices(:)
    integer(int8), intent(out) :: value
    type(error_type), intent(out), optional :: err
  end subroutine coordinate_at_int8

  module subroutine coordinate_at_int16(coord, indices, value, err)
    type(coordinate_type), target, intent(in) :: coord
    integer, intent(in) :: indices(:)
    integer(int16), intent(out) :: value
    type(error_type), intent(out), optional :: err
  end subroutine coordinate_at_int16

  module subroutine coordinate_at_int32(coord, indices, value, err)
    type(coordinate_type), target, intent(in) :: coord
    integer, intent(in) :: indices(:)
    integer(int32), intent(out) :: value
    type(error_type), intent(out), optional :: err
  end subroutine coordinate_at_int32

  module subroutine coordinate_at_int64(coord, indices, value, err)
    type(coordinate_type), target, intent(in) :: coord
    integer, intent(in) :: indices(:)
    integer(int64), intent(out) :: value
    type(error_type), intent(out), optional :: err
  end subroutine coordinate_at_int64

  module subroutine coordinate_at_real32(coord, indices, value, err)
    type(coordinate_type), target, intent(in) :: coord
    integer, intent(in) :: indices(:)
    real(real32), intent(out) :: value
    type(error_type), intent(out), optional :: err
  end subroutine coordinate_at_real32

  module subroutine coordinate_at_real64(coord, indices, value, err)
    type(coordinate_type), target, intent(in) :: coord
    integer, intent(in) :: indices(:)
    real(real64), intent(out) :: value
    type(error_type), intent(out), optional :: err
  end subroutine coordinate_at_real64

  module subroutine extract_coord_int8(coord, ptr)
    type(coordinate_type), target, intent(in) :: coord
    integer(int8), pointer, intent(out) :: ptr(:)
  end subroutine extract_coord_int8

  module subroutine extract_coord_int16(coord, ptr)
    type(coordinate_type), target, intent(in) :: coord
    integer(int16), pointer, intent(out) :: ptr(:)
  end subroutine extract_coord_int16

  module subroutine extract_coord_int32(coord, ptr)
    type(coordinate_type), target, intent(in) :: coord
    integer(int32), pointer, intent(out) :: ptr(:)
  end subroutine extract_coord_int32

  module subroutine extract_coord_int64(coord, ptr)
    type(coordinate_type), target, intent(in) :: coord
    integer(int64), pointer, intent(out) :: ptr(:)
  end subroutine extract_coord_int64

  module subroutine extract_coord_real32(coord, ptr)
    type(coordinate_type), target, intent(in) :: coord
    real(real32), pointer, intent(out) :: ptr(:)
  end subroutine extract_coord_real32

  module subroutine extract_coord_real64(coord, ptr)
    type(coordinate_type), target, intent(in) :: coord
    real(real64), pointer, intent(out) :: ptr(:)
  end subroutine extract_coord_real64
end interface

interface
  module subroutine evaluate(expr, result, err)
    !! Validate and evaluate a deferred expression into a variable.
    type(expression_type), intent(in) :: expr
    !! Expression tree whose operand values are read during evaluation.
    type(variable_type), target, intent(inout) :: result
    !! Destination replaced only after a successful evaluation.
    type(error_type), intent(out), optional :: err
    !! Receives failure details; if omitted, failures terminate execution.
  end subroutine evaluate

  module subroutine assign_expr(result, expr)
    !! Evaluate an expression through defined assignment.
    type(variable_type), target, intent(inout) :: result
    !! Destination variable for the evaluated values.
    type(expression_type), intent(in) :: expr
    !! Deferred expression to assign.
  end subroutine assign_expr

  pure module function nameof_att(att) result(name)
    !! Return the local name of an attribute, or an empty string if absent.
    type(attribute_type), intent(in) :: att
    !! Attribute whose name is requested.
    character(len=:), allocatable :: name
  end function nameof_att

  pure module function nameof_dim(dim) result(name)
    !! Return the local name of a dimension, or an empty string if absent.
    type(dimension_type), intent(in) :: dim
    !! Dimension whose name is requested.
    character(len=:), allocatable :: name
  end function nameof_dim

  pure module function nameof_var(var) result(name)
    !! Return the local name of a variable, or an empty string if absent.
    class(abstract_variable_type), intent(in) :: var
    !! Variable whose name is requested.
    character(len=:), allocatable :: name
  end function nameof_var

  pure module function nameof_grp(grp) result(name)
    !! Return the local name of a group, or an empty string if absent.
    class(group_type), intent(in) :: grp
    !! Group whose name is requested.
    character(len=:), allocatable :: name
  end function nameof_grp

  elemental module function typeof_att(att) result(dtype)
    !! Return the external data-type code of an attribute.
    type(attribute_type), intent(in) :: att
    !! Attribute whose data type is requested.
    integer(data_type) :: dtype
  end function typeof_att

  elemental module function typeof_var(var) result(dtype)
    !! Return the external data-type code of a variable.
    class(abstract_variable_type), intent(in) :: var
    !! Variable whose data type is requested.
    integer(data_type) :: dtype
  end function typeof_var

  module subroutine set_storage(var, chunks, deflate_level, shuffle, &
    & fletcher32, endian, no_fill, fill_value, err)
    !! Update selected in-memory variable storage settings after validation.
    type(variable_type), intent(inout) :: var
    !! Variable whose optional storage component is updated.
    integer(int64), intent(in), optional :: chunks(:)
    !! Positive chunk lengths in Fortran dimension order.
    integer, intent(in), optional :: deflate_level, endian
    !! Compression level (0 through 9) and NetCDF endian constant.
    logical, intent(in), optional :: shuffle, fletcher32, no_fill
    !! Optional filter and fill switches.
    type(attribute_type), intent(in), optional :: fill_value
    !! Scalar value matching the variable type.
    type(error_type), intent(out), optional :: err
    !! Receives status; failures terminate execution when omitted.
  end subroutine set_storage

  pure module subroutine rename_dim_dim(dim, new_name, err)
    !! Rename one dimension without changing its identity, length, or unlimited
    !! flag.
    type(dimension_type), intent(inout) :: dim
    !! Standalone dimension to rename; other copies are unchanged.
    character(len=*), intent(in) :: new_name
    !! Replacement local name; trailing Fortran padding is ignored.
    type(error_type), intent(out), optional :: err
    !! Receives status; failures terminate execution when omitted.
  end subroutine rename_dim_dim

  pure module subroutine rename_dim_var(var, old_name, new_name, err)
    !! Rename all matching axes in one variable, including repeated dimension
    !! references.
    type(variable_type), intent(inout) :: var
    !! Variable whose dimension names change; data and other metadata are
    !! preserved.
    character(len=*), intent(in) :: old_name, new_name
    !! old_name: Dimension to find. new_name: Replacement local name.
    type(error_type), intent(out), optional :: err
    !! Receives status; failures terminate execution when omitted.
  end subroutine rename_dim_var

  pure module subroutine rename_dim_grp(grp, old_name, new_name, err)
    !! Rename a local dimension and its direct variable references; do not
    !! traverse children.
    class(group_type), intent(inout) :: grp
    !! Group with local definitions or, if dims is unallocated, implicit
    !! variable dimensions.
    character(len=*), intent(in) :: old_name, new_name
    !! old_name: Dimension to find. new_name: Replacement local name.
    type(error_type), intent(out), optional :: err
    !! Receives status; failures terminate execution when omitted.
  end subroutine rename_dim_grp

  pure module subroutine rename_grp_grp(grp, new_name, err)
    !! Rename a non-root group in memory, preserving its contents and child
    !! aliases.
    class(group_type), intent(inout) :: grp
    !! Non-root group whose local name is changed.
    character(len=*), intent(in) :: new_name
    !! Replacement local name; trailing Fortran blank padding is removed.
    type(error_type), intent(out), optional :: err
    !! Receives the status and diagnostic; failures stop execution when omitted.
  end subroutine rename_grp_grp

  pure module subroutine rename_grp_par(parent, old_name, new_name, err)
    !! Rename one direct child in parent%grps without accessing a file.
    class(group_type), intent(inout) :: parent
    !! Parent whose matching direct child is renamed in memory.
    character(len=*), intent(in) :: old_name, new_name
    !! old_name: Existing local name to locate. new_name: Replacement local
    !! name; trailing Fortran blank padding is removed.
    type(error_type), intent(out), optional :: err
    !! Receives the status and diagnostic; failures stop execution when omitted.
  end subroutine rename_grp_par

  pure module subroutine validate_nc_name(name, context, err)
    !! Validate a NetCDF local name through the generic validate interface.
    character(len=*), intent(in) :: name
    !! NetCDF local name to validate; trailing Fortran blank padding is ignored.
    character(len=*), intent(in) :: context
    !! Operation name for diagnostics, without brackets.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when absent.
  end subroutine validate_nc_name

  logical elemental module function has_err(err) result(is_err)
    !! Return true when `err` represents a failed operation.
    type(error_type), intent(in) :: err
    !! Completed result of an nc4f operation.
  end function has_err

  pure module function initialize_err(code, fname, msg) result(err)
    !! Construct a success result or a checked failure diagnostic.
    integer(error_code), intent(in), optional :: code
    !! Operation status code; defaults to NO_ERROR.
    character(len=*), intent(in), optional :: fname
    !! Operation name, required and nonblank on failure.
    character(len=*), intent(in), optional :: msg
    !! Diagnostic text, required and nonblank on failure.
    type(error_type) :: err
    !! Constructed result with validated failure fields.
  end function initialize_err

  pure module function error_msg(err) result(text)
    !! Return "[fname] msg" for failures or "No error" for success.
    class(error_type), intent(in) :: err
    !! Result to validate and format without external I/O.
    character(len=:), allocatable :: text
    !! Complete formatted diagnostic.
  end function error_msg

  pure module subroutine return_err(op_err, err)
    !! Return an optional error or terminate, shared by model and NetCDF
    !! operations.
    type(error_type), intent(in) :: op_err
    !! Completed operation result to return or use for error termination.
    type(error_type), intent(out), optional :: err
    !! Receives the status and diagnostic; failures stop execution when omitted.
  end subroutine return_err

  pure module subroutine rename_var_var(var, new_name, err)
    !! Rename an independent variable in memory; preserve its metadata and
    !! storage.
    type(variable_type), intent(inout) :: var
    !! Variable whose local name is changed; its metadata and storage are
    !! preserved.
    character(len=*), intent(in) :: new_name
    !! Replacement local name; trailing Fortran blank padding is removed.
    type(error_type), intent(out), optional :: err
    !! Receives the status and diagnostic; failures stop execution when omitted.
  end subroutine rename_var_var

  pure module subroutine rename_var_grp(grp, old_name, new_name, err)
    !! Rename a direct member of grp%vars in memory, without accessing a file.
    class(group_type), intent(inout) :: grp
    !! Group whose direct variable collection contains the name to change.
    character(len=*), intent(in) :: old_name, new_name
    !! old_name: Existing local name to locate. new_name: Replacement local
    !! name; trailing Fortran blank padding is removed.
    type(error_type), intent(out), optional :: err
    !! Receives the status and diagnostic; failures stop execution when omitted.
  end subroutine rename_var_grp

  pure module subroutine del_att_var(var, name, err)
    !! Remove a named attribute from the supplied model without accessing a
    !! file.
    type(variable_type), intent(inout) :: var
    !! Owner whose attribute collection is reduced, preserving survivor order
    !! and storage.
    character(len=*), intent(in) :: name
    !! Local attribute name; trailing Fortran padding is ignored.
    type(error_type), intent(out), optional :: err
    !! Receives status and diagnostic; failures stop execution when omitted.
  end subroutine del_att_var

  pure module subroutine del_att_grp(grp, name, err)
    !! Remove a named attribute from the supplied model without accessing a
    !! file.
    class(group_type), intent(inout) :: grp
    !! Owner whose attribute collection is reduced, preserving survivor order
    !! and storage.
    character(len=*), intent(in) :: name
    !! Local attribute name; trailing Fortran padding is ignored.
    type(error_type), intent(out), optional :: err
    !! Receives status and diagnostic; failures stop execution when omitted.
  end subroutine del_att_grp

  pure module subroutine rename_att_att(att, new_name, err)
    !! Rename an independent attribute in memory; no file is accessed.
    type(attribute_type), intent(inout) :: att
    !! Attribute whose local name is changed.
    character(len=*), intent(in) :: new_name
    !! Replacement local name; trailing Fortran blank padding is removed.
    type(error_type), intent(out), optional :: err
    !! Receives the status and diagnostic; failures stop execution when omitted.
  end subroutine rename_att_att

  pure module subroutine rename_att_var(var, old_name, new_name, err)
    !! Rename a variable attribute in memory, preserving its value and storage.
    type(variable_type), intent(inout) :: var
    !! Variable whose matching attribute is renamed; its data and own name are
    !! preserved.
    character(len=*), intent(in) :: old_name, new_name
    !! old_name: Existing local name to locate. new_name: Replacement local
    !! name; trailing Fortran blank padding is removed.
    type(error_type), intent(out), optional :: err
    !! Receives the status and diagnostic; failures stop execution when omitted.
  end subroutine rename_att_var

  pure module subroutine rename_att_grp(grp, old_name, new_name, err)
    !! Rename a group/global attribute in memory, without accessing a file.
    class(group_type), intent(inout) :: grp
    !! Group whose matching global attribute is renamed.
    character(len=*), intent(in) :: old_name, new_name
    !! old_name: Existing local name to locate. new_name: Replacement local
    !! name; trailing Fortran blank padding is removed.
    type(error_type), intent(out), optional :: err
    !! Receives the status and diagnostic; failures stop execution when omitted.
  end subroutine rename_att_grp

  elemental module subroutine init_att(att, name, dtype, len)
    !! Initialize a dataset object.
    type(attribute_type), intent(inout) :: att
    !! Attribute to process.
    character(len=*), intent(in) :: name
    !! Name used to identify the NetCDF object.
    integer(data_type), intent(in) :: dtype
    !! NetCDF data-type code used to determine the stored element
    !! representation.
    integer(int64), intent(in) :: len
    !! Number of stored data elements.
  end subroutine init_att

  module subroutine init_var(var, name, dtype, len, dims, atts)
    !! Initialize a dataset object.
    type(variable_type), intent(inout) :: var
    !! Variable to process.
    character(len=*), intent(in) :: name
    !! Name used to identify the NetCDF object.
    integer(data_type), intent(in) :: dtype
    !! NetCDF data-type code used to determine the stored element
    !! representation.
    integer(int64), intent(in) :: len
    !! Number of stored data elements.
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
    !! NetCDF data-type code used to determine the stored element
    !! representation.
    integer(int64), intent(in) :: len
    !! Number of stored data elements.
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
    !! NetCDF data-type code used to determine the stored element
    !! representation.
    integer(int64), intent(in) :: len
    !! Number of stored data elements.
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
    !! Source metadata and storage to copy or borrow according to DEEP.
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
    !! Source metadata and storage to copy or borrow according to DEEP.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Attributes to process or attach.
    logical, intent(in), optional :: deep
    !! Whether to make an owned deep copy of the data.
  end subroutine init_var_mold

  module function new_dataset_empty(name, atts, deep) result(grp)
    !! Construct a named group with optional attributes and no child
    !! collections.
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
    !! Construct a named group from variables and optional attributes.
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
    !! Construct a named group from child groups and optional attributes.
    character(len=*), intent(in) :: name
    !! Name used to identify the NetCDF object.
    type(group_type), intent(in) :: grps(:)
    !! Child groups to include in the constructed group.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Attributes to process or attach.
    logical, intent(in), optional :: deep
    !! Whether to make an owned deep copy of the data.
    type(group_type) :: grp
    !! Result produced by this operation.
  end function new_dataset_grps

  module function new_dataset_all(name, vars, grps, atts, deep) result(grp)
    !! Construct a named group from variables, child groups, and optional
    !! attributes.
    character(len=*), intent(in) :: name
    !! Name used to identify the NetCDF object.
    type(variable_type), intent(in) :: vars(:)
    !! Variables to process or add to the dataset.
    type(group_type), intent(in) :: grps(:)
    !! Child groups to include in the constructed group.
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
    !! Child groups to include in the constructed group.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Attributes to process or attach.
    logical, intent(in), optional :: deep
    !! Whether to make an owned deep copy of the data.
  end subroutine new_dataset_

  impure elemental module subroutine clone_att(src, dest)
    !! Deep-copy attribute metadata and active bytes into owned destination
    !! storage.
    type(attribute_type), intent(in) :: src
    !! Source object or group to read from.
    type(attribute_type), intent(out) :: dest
    !! Destination object or group to update.
  end subroutine clone_att

  impure elemental module subroutine clone_var(src, dest)
    !! Deep-copy a variable, its attributes, and active bytes into owned
    !! storage.
    type(variable_type), intent(in) :: src
    !! Source object or group to read from.
    type(variable_type), intent(out) :: dest
    !! Destination object or group to update.
  end subroutine clone_var

  impure elemental module subroutine clone_grp(src, dest)
    !! Deep-copy a group and its complete descendant tree.
    type(group_type), intent(in) :: src
    !! Source object or group to read from.
    type(group_type), intent(out) :: dest
    !! Destination object or group to update.
  end subroutine clone_grp

  pure module subroutine validate_att(att, dtype, context, err)
    !! Validate dataset buffer metadata before access.
    type(attribute_type), intent(in) :: att
    !! Attribute to process.
    integer(data_type), intent(in), optional :: dtype
    !! Expected NetCDF data-type code, when supplied.
    character(len=*), intent(in) :: context
    !! Operation name for diagnostics, without brackets.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when absent.
  end subroutine validate_att

  pure module subroutine validate_var(var, dtype, rank, context, err)
    !! Validate dataset buffer metadata before access.
    type(variable_type), intent(in) :: var
    !! Variable to process.
    integer(data_type), intent(in), optional :: dtype
    !! Expected NetCDF data-type code, when supplied.
    integer, intent(in), optional :: rank
    !! Expected variable rank, when supplied.
    character(len=*), intent(in) :: context
    !! Operation name for diagnostics, without brackets.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when absent.
  end subroutine validate_var

  module function buffer2cptr_att(att) result(cptr)
    !! Return the C address of an attribute's active byte storage.
    type(attribute_type), target, intent(in) :: att
    !! Attribute to process.
    type(c_ptr) :: cptr
    !! Result produced by this operation.
  end function buffer2cptr_att

  module function buffer2cptr_var(var) result(cptr)
    !! Return the C address of a variable's active byte storage.
    type(variable_type), target, intent(in) :: var
    !! Variable to process.
    type(c_ptr) :: cptr
    !! Result produced by this operation.
  end function buffer2cptr_var

  module subroutine write_frmt_att(att, unit, iotype, v_list, iostat, iomsg)
    !! Write a formatted attribute representation to a Fortran I/O unit.
    class(attribute_type), intent(in) :: att
    !! Attribute to process.
    integer, intent(in) :: unit
    !! Fortran output unit supplied by the invoking formatted WRITE.
    character(len=*), intent(in) :: iotype
    !! Requested defined-I/O mode; LISTDIRECTED and DT are supported.
    integer, intent(in) :: v_list(:)
    !! Integer DT edit-descriptor parameters; currently ignored.
    integer, intent(out) :: iostat
    !! Receives zero on success or a nonzero I/O status on failure.
    character(len=*), intent(inout) :: iomsg
    !! Receives the diagnostic message if the underlying WRITE fails.
  end subroutine write_frmt_att

  module subroutine write_frmt_dim(dim, unit, iotype, v_list, iostat, iomsg)
    !! Write a formatted dimension representation to a Fortran I/O unit.
    class(dimension_type), intent(in) :: dim
    !! Dimension to process.
    integer, intent(in) :: unit
    !! Fortran output unit supplied by the invoking formatted WRITE.
    character(len=*), intent(in) :: iotype
    !! Requested defined-I/O mode; LISTDIRECTED and DT are supported.
    integer, intent(in) :: v_list(:)
    !! Integer DT edit-descriptor parameters; currently ignored.
    integer, intent(out) :: iostat
    !! Receives zero on success or a nonzero I/O status on failure.
    character(len=*), intent(inout) :: iomsg
    !! Receives the diagnostic message if the underlying WRITE fails.
  end subroutine write_frmt_dim

  module subroutine write_frmt_var(var, unit, iotype, v_list, iostat, iomsg)
    !! Write a formatted variable representation to a Fortran I/O unit.
    class(variable_type), intent(in) :: var
    !! Variable to process.
    integer, intent(in) :: unit
    !! Fortran output unit supplied by the invoking formatted WRITE.
    character(len=*), intent(in) :: iotype
    !! Requested defined-I/O mode; LISTDIRECTED and DT are supported.
    integer, intent(in) :: v_list(:)
    !! Integer DT edit-descriptor parameters; currently ignored.
    integer, intent(out) :: iostat
    !! Receives zero on success or a nonzero I/O status on failure.
    character(len=*), intent(inout) :: iomsg
    !! Receives the diagnostic message if the underlying WRITE fails.
  end subroutine write_frmt_var

  module subroutine write_frmt_grp(grp, unit, iotype, v_list, iostat, iomsg)
    !! Write a formatted group representation to a Fortran I/O unit.
    class(group_type), intent(in) :: grp
    !! Dataset group to process.
    integer, intent(in) :: unit
    !! Fortran output unit supplied by the invoking formatted WRITE.
    character(len=*), intent(in) :: iotype
    !! Requested defined-I/O mode; LISTDIRECTED and DT are supported.
    integer, intent(in) :: v_list(:)
    !! Integer DT edit-descriptor parameters; currently ignored.
    integer, intent(out) :: iostat
    !! Receives zero on success or a nonzero I/O status on failure.
    character(len=*), intent(inout) :: iomsg
    !! Receives the diagnostic message if the underlying WRITE fails.
  end subroutine write_frmt_grp

  module subroutine write_frmt_netcdf(grp, unit, iotype, v_list, iostat, iomsg)
    !! Write a formatted dataset representation to a Fortran I/O unit.
    class(netcdf_type), intent(in) :: grp
    !! Dataset group to process.
    integer, intent(in) :: unit
    !! Fortran output unit supplied by the invoking formatted WRITE.
    character(len=*), intent(in) :: iotype
    !! Requested defined-I/O mode; LISTDIRECTED and DT are supported.
    integer, intent(in) :: v_list(:)
    !! Integer DT edit-descriptor parameters; currently ignored.
    integer, intent(out) :: iostat
    !! Receives zero on success or a nonzero I/O status on failure.
    character(len=*), intent(inout) :: iomsg
    !! Receives the diagnostic message if the underlying WRITE fails.
  end subroutine write_frmt_netcdf

  module subroutine write_frmt_err(err, unit, iotype, v_list, iostat, iomsg)
    !! Write a formatted error result representation to a Fortran I/O unit.
    class(error_type), intent(in) :: err
    !! Result to validate and format through error_msg.
    integer, intent(in) :: unit
    !! Fortran output unit supplied by the invoking formatted WRITE.
    character(len=*), intent(in) :: iotype
    !! Requested defined-I/O mode; LISTDIRECTED and DT are supported.
    integer, intent(in) :: v_list(:)
    !! Integer DT edit-descriptor parameters; currently ignored.
    integer, intent(out) :: iostat
    !! Receives zero on success or a nonzero I/O status on failure.
    character(len=*), intent(inout) :: iomsg
    !! Receives the diagnostic message if the underlying WRITE fails.
  end subroutine write_frmt_err

  elemental module function new_dim_len_int32(name, len) result(dim)
    !! Construct a dataset object from the supplied metadata and data.
    character(len=*), intent(in) :: name
    !! Name used to identify the NetCDF object.
    integer(int32), intent(in) :: len
    !! Dimension length in elements.
    type(dimension_type) :: dim
    !! Result produced by this operation.
  end function new_dim_len_int32

  elemental module function new_dim_len_int64(name, len) result(dim)
    !! Construct a dataset object from the supplied metadata and data.
    character(len=*), intent(in) :: name
    !! Name used to identify the NetCDF object.
    integer(int64), intent(in) :: len
    !! Dimension length in elements.
    type(dimension_type) :: dim
    !! Result produced by this operation.
  end function new_dim_len_int64

  elemental module function new_dim_arg_int32(len, is_unlim) result(arg)
    !! Construct a dataset object from the supplied metadata and data.
    integer(int32), intent(in) :: len
    !! Dimension length in elements.
    logical, intent(in) :: is_unlim
    !! Whether this dimension can grow when records are written.
    type(dimension_argument_type) :: arg
    !! Result produced by this operation.
  end function new_dim_arg_int32

  elemental module function new_dim_arg_int64(len, is_unlim) result(arg)
    !! Construct a dataset object from the supplied metadata and data.
    integer(int64), intent(in) :: len
    !! Dimension length in elements.
    logical, intent(in) :: is_unlim
    !! Whether this dimension can grow when records are written.
    type(dimension_argument_type) :: arg
    !! Result produced by this operation.
  end function new_dim_arg_int64

  elemental module function new_dim_args(name, args) result(dim)
    !! Construct a dataset object from the supplied metadata and data.
    character(len=*), intent(in) :: name
    !! Name used to identify the NetCDF object.
    type(dimension_argument_type), intent(in) :: args
    !! Dimension length and unlimited flag packaged by the .and. operator.
    type(dimension_type) :: dim
    !! Result produced by this operation.
  end function new_dim_args

  logical elemental module function eq_dim(x, y)
    !! Return true when two dimensions have identical metadata.
    type(dimension_type), intent(in) :: x, y
    !! x: Left-hand value to compare. y: Right-hand value to compare.
  end function eq_dim

  logical elemental module function neq_dim(x, y)
    !! Return true when two dimensions have different metadata.
    type(dimension_type), intent(in) :: x, y
    !! x: Left-hand value to compare. y: Right-hand value to compare.
  end function neq_dim

  logical elemental module function eq_att(x, y) result(is_equal)
    !! Return true when two attributes have identical metadata and byte values.
    type(attribute_type), intent(in) :: x, y
    !! x: Left-hand value to compare. y: Right-hand value to compare.
  end function eq_att

  logical elemental module function neq_att(x, y) result(is_equal)
    !! Return true when two attributes differ.
    type(attribute_type), intent(in) :: x, y
    !! x: Left-hand value to compare. y: Right-hand value to compare.
  end function neq_att

  logical elemental module function eq_var(x, y) result(is_equal)
    !! Return true when two variables have identical metadata and byte values.
    type(variable_type), intent(in) :: x, y
    !! x: Left-hand value to compare. y: Right-hand value to compare.
  end function eq_var

  logical elemental module function neq_var(x, y) result(is_equal)
    !! Return true when two variables differ.
    type(variable_type), intent(in) :: x, y
    !! x: Left-hand value to compare. y: Right-hand value to compare.
  end function neq_var

  pure module function get_size(var, dim) result(n)
    !! Query and return requested NetCDF metadata.
    class(abstract_variable_type), intent(in) :: var
    !! Variable to process.
    integer, intent(in), optional :: dim
    !! Dimension to process.
    integer(int64) :: n
    !! Result produced by this operation.
  end function get_size

  pure module subroutine compute_size(var, n, err, dim)
    !! Return an element count or an error without terminating execution.
    class(abstract_variable_type), intent(in) :: var
    !! Variable whose total size or selected dimension is queried.
    integer(int64), intent(out) :: n
    !! Total element count or length of the selected dimension.
    type(error_type), intent(out) :: err
    !! Receives invalid-dimension or invalid-size details.
    integer, intent(in), optional :: dim
    !! One-based dimension index; when absent, query the total size.
  end subroutine compute_size

  pure module function get_shape(var) result(extents)
    !! Query and return requested NetCDF metadata.
    class(abstract_variable_type), intent(in) :: var
    !! Variable to process.
    integer, allocatable :: extents(:)
    !! Result produced by this operation.
  end function get_shape

  module function sum_vars(vars) result(total)
    !! Return the element-wise sum of compatible variables in `vars`.
    type(variable_type), intent(in) :: vars(:)
    !! Variables to process or add to the dataset.
    type(variable_type) :: total
    !! Result produced by this operation.
  end function sum_vars

  pure module subroutine compute_buffer_size(dtype, len, nbytes, err)
    !! Return a byte count or an error without terminating execution.
    integer(data_type), intent(in) :: dtype
    !! External data type used to determine bytes per element.
    integer(int64), intent(in) :: len
    !! Number of data elements.
    integer, intent(out) :: nbytes
    !! Buffer size in bytes when the calculation succeeds.
    type(error_type), intent(out) :: err
    !! Receives invalid-type or size-overflow details.
  end subroutine compute_buffer_size

  pure module function buffer_size(dtype, len) result(nbytes)
    !! Compute the byte count for a NetCDF type and element count, checking
    !! overflow.
    integer(data_type), intent(in) :: dtype
    !! NetCDF data-type code used to determine the stored element
    !! representation.
    integer(int64), intent(in) :: len
    !! Number of stored data elements.
    integer :: nbytes
    !! Result produced by this operation.
  end function buffer_size
end interface

end module nc4f_data
