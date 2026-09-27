module nc4f_nc

use, intrinsic :: iso_fortran_env, only: &
  & int8, int16, int32, int64, real32, real64
use, intrinsic :: iso_c_binding
use, non_intrinsic :: nc4f_c_interface
use, non_intrinsic :: nc4f_ds
implicit none (type, external)

public :: &
  open_netcdf, close_netcdf, to_netcdf, &
  inquire_dimensions, inquire_variable, &
  get_attribute, get_variable, &
  get_group, inquire_subgroups, inquire_group, operator(.exists.)
private

!> Fixed scratch length for operation-context diagnostics.
integer, parameter :: MAX_CHAR_LEN = 1024

interface get_attribute
  module procedure :: get_atts_grp
  module procedure :: get_att_grp !> Impure Elemental
  module procedure :: get_atts_var
  module procedure :: get_att_var !> Impure Elemental
end interface get_attribute

interface inquire_dimensions
  module procedure :: inq_dims_grp
  module procedure :: inq_dims_var
end interface inquire_dimensions

interface to_netcdf
  module procedure :: to_netcdf_var
  module procedure :: to_netcdf_grp
end interface to_netcdf

!> Return whether an error result represents a failed operation.
interface operator(.exists.)
  module procedure :: has_err
end interface operator(.exists.)

!> Allocate a fresh byte buffer for metadata read from the C API.
interface initialize
  module procedure :: initialize_att
  module procedure :: initialize_var
end interface initialize

interface
  !> Return a direct child group by name.
  module function get_group(parent, name, err) result(group)
    class(group_type), intent(in) :: parent
    character(len=*), intent(in) :: name
    type(error_type), intent(out), optional :: err
    type(group_type) :: group
  end function get_group

  !> Return direct child groups with IDs and names populated.
  module function inquire_subgroups(parent, err) result(grps)
    class(group_type), intent(in) :: parent
    type(error_type), intent(out), optional :: err
    type(group_type), allocatable :: grps(:)
  end function inquire_subgroups

  !> Materialize selected metadata for a group.
  module recursive subroutine inquire_group(group, &
    & inq_dims, inq_atts, inq_vars, inq_grps, recur, err)
    class(group_type), intent(inout) :: group
    logical, intent(in), optional :: inq_dims, inq_atts, inq_vars, inq_grps
    logical, intent(in), optional :: recur
    type(error_type), intent(out), optional :: err
  end subroutine inquire_group

  !> Read a global attribute by name and return it.
  module impure elemental function get_att_grp(nc, name, err) result(att)
    !> High-level `netcdf_type` representing the open file.
    class(group_type), intent(in) :: nc
    !> Name of the global attribute to read.
    character(len=*), intent(in) :: name
    !> Optional operation error. When absent, failures stop the program.
    type(error_type), intent(out), optional :: err
    !> Returned attribute object.
    type(attribute_type) :: att
  end function get_att_grp

  !> Return all global attributes for a dataset.
  module function get_atts_grp(nc, err) result(atts)
    !> High-level `netcdf_type` representing the open file.
    class(group_type), intent(in) :: nc
    !> Optional error result. When absent, failures stop the program.
    type(error_type), optional, intent(out) :: err
    !> Allocatable array of attributes for the dataset.
    type(attribute_type), allocatable :: atts(:)
  end function get_atts_grp

  !> Read a named attribute attached to a variable and return it.
  module function get_att_var(nc, var, name, err) result(att)
    !> High-level `netcdf_type` representing the open file.
    class(group_type), intent(in) :: nc
    !> Variable whose attribute will be read.
    type(variable_type), intent(in) :: var
    !> Name of the attribute to read.
    character(len=*), intent(in) :: name
    !> Optional operation error. When absent, failures stop the program.
    type(error_type), intent(out), optional :: err
    !> Returned attribute object.
    type(attribute_type) :: att
  end function get_att_var

  !> Return all attributes attached to a variable.
  module function get_atts_var(nc, var, err) result(atts)
    !> High-level `netcdf_type` representing the open file.
    class(group_type), intent(in) :: nc
    !> Variable whose attributes will be returned.
    type(variable_type), intent(in) :: var
    !> Optional error result. When absent, failures stop the program.
    type(error_type), optional, intent(out) :: err
    !> Allocatable array of attributes for the variable.
    type(attribute_type), allocatable :: atts(:)
  end function get_atts_var

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

  !> Open or create a dataset and return a `netcdf_type` handle.
  module function open_netcdf(file, mode, err) result(nc)
    !> Path to the dataset file.
    character(len=*), intent(in) :: file
    !> Mode to open the file: 'r' for read, 'w' to recreate, or 'a' for
    !> read/write access to an existing dataset.
    character(len=*), intent(in), optional :: mode
    !> Optional error result. When absent, failures stop the program.
    type(error_type), intent(out), optional :: err
    !> Returned `netcdf_type` describing the opened dataset.
    type(netcdf_type) :: nc
  end function open_netcdf

  !> Close a dataset and free associated allocatables.
  module subroutine close_netcdf(nc, err)
    !> `netcdf_type` representing the open dataset to close.
    type(netcdf_type), intent(inout) :: nc
    !> Optional error result. When absent, failures stop the program.
    type(error_type), intent(out), optional :: err
  end subroutine close_netcdf

  !> Create a netCDF file from one variable or a rank-one variable array.
  module subroutine to_netcdf_var(file, vars, atts, err)
    !> Output file to create.
    character(len=*), intent(in) :: file
    !> Variable or array of variables to write into the file.
    type(variable_type), intent(in) :: vars(..)
    !> Optional array of global attributes to attach to the dataset.
    type(attribute_type), intent(in), optional :: atts(:)
    !> Optional error result. When absent, failures stop the program.
    type(error_type), intent(out), optional :: err
  end subroutine to_netcdf_var

  !> Create a netCDF file from one group or a rank-one group array.
  module subroutine to_netcdf_grp(file, grp, atts, err)
    !> Output file to create.
    character(len=*), intent(in) :: file
    !> A scalar is written as the root (its name is ignored); an array is
    !> written as direct children of an otherwise empty root.
    type(group_type), intent(in) :: grp(..)
    !> Optional root attributes. For a scalar, entries with names already
    !> present in `grp%atts` replace those attributes.
    type(attribute_type), intent(in), optional :: atts(:)
    !> Optional error result. When absent, failures stop the program.
    type(error_type), intent(out), optional :: err
  end subroutine to_netcdf_grp

  !> Inquire all dimensions for the top-level group of a netCDF file.
  module function inq_dims_grp(nc, err) result(dims)
    !> High-level `netcdf_type` representing the open file.
    class(group_type), intent(in) :: nc
    !> Optional error result. When absent, failures stop the program.
    type(error_type), intent(out), optional :: err
    !> Allocatable array of `dimension_type` in Fortran order.
    type(dimension_type), allocatable :: dims(:)
  end function inq_dims_grp

  !> Inquire the dimensions attached to a variable.
  module function inq_dims_var(nc, var, err) result(dims)
    !> High-level `netcdf_type` for the file.
    class(group_type), intent(in) :: nc
    !> `variable_type` describing the variable.
    type(variable_type), intent(in) :: var
    !> Optional error result. When absent, failures stop the program.
    type(error_type), intent(out), optional :: err
    !> Allocatable array of `dimension_type` for that variable.
    type(dimension_type), allocatable :: dims(:)
  end function inq_dims_var

  !> submodule_utility.f90

  !> Apply the library's fail-fast policy to a completed error result.
  module impure logical function handle_err(err) result(has_failed)
    !> Completed result of an nc4f operation.
    type(error_type), intent(in) :: err
  end function handle_err

  !> Construct an `error_type` from a NetCDF C status and optional context.
  module function netcdf_err(status, context) result(err)
    !> Input argument(s): `status`.
    integer(c_int), intent(in) :: status
    !> Input argument(s): `context`.
    character(*), intent(in), optional :: context
    type(error_type) :: err
  end function netcdf_err

  !> Return true when `err` represents a failed operation.
  module pure elemental logical function has_err(err) result(is_err)
    !> Completed result of an nc4f operation.
    type(error_type), intent(in) :: err
  end function has_err

  !> Trim left and right space of a character variable.
  module pure function clip(string) result(clipped)
    !> The input string.
    character(len=*), intent(in) :: string
    !> The output string.
    character(len=:), allocatable :: clipped
  end function clip

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

  !> Allocate a fresh byte buffer for an attribute read from a NetCDF file.
  module subroutine initialize_att(att)
    type(attribute_type), intent(inout) :: att
  end subroutine initialize_att

  !> Allocate a fresh byte buffer for a variable read from a NetCDF file.
  module subroutine initialize_var(var)
    type(variable_type), intent(inout) :: var
  end subroutine initialize_var

  !> submodule_variable.f90

  !> Read a variable's data from a netCDF dataset into a `variable_type`.
  module function get_variable(nc, name, start, count, stride, err) result(var)
    !> High-level `netcdf_type` representing the open file.
    class(group_type), intent(in) :: nc
    !> Name of the variable to read.
    character(len=*), intent(in) :: name
    !> Optional one-based Fortran-order hyperslab start indices.
    integer, intent(in), optional :: start(:)
    !> Optional hyperslab lengths.
    integer, intent(in), optional :: count(:)
    !> Optional hyperslab strides.
    integer, intent(in), optional :: stride(:)
    !> Optional operation error. When absent, failures stop the program.
    type(error_type), intent(out), optional :: err
    !> Variable object that will contain metadata and the data buffer.
    type(variable_type), target :: var
  end function get_variable

  !> Inquire a variable's metadata without reading its data buffer.
  module impure elemental function inquire_variable(nc, name, err) result(var)
    !> High-level `netcdf_type` representing the open file.
    class(group_type), intent(in) :: nc
    !> Name of the variable to inquire.
    character(len=*), intent(in) :: name
    !> Optional operation error. When absent, failures stop the program.
    type(error_type), intent(out), optional :: err
    !> Variable object containing metadata (name, type, dims, atts, len).
    type(variable_type) :: var
  end function inquire_variable

  !> Define or resolve one dimension while serializing an in-memory model.
  module function def_dim(nc, dim, err) result(new_dim)
    !> Dataset or group that owns the dimension.
    class(group_type), intent(in) :: nc
    !> Dimension metadata to define or resolve.
    type(dimension_type), intent(in) :: dim
    !> Operation error.
    type(error_type), intent(out) :: err
    !> Dimension metadata with its NetCDF identifier.
    type(dimension_type) :: new_dim
  end function def_dim

  !> Define variable metadata without transferring its data buffer.
  module function def_var(nc, var, err) result(new_var)
    class(group_type), intent(in) :: nc
    type(variable_type), intent(in) :: var
    type(error_type), intent(out) :: err
    type(variable_type) :: new_var
  end function def_var

  !> Write one complete variable while serializing an in-memory model.
  module subroutine put_var(nc, var, err)
    !> Open dataset or group.
    class(group_type), intent(in) :: nc
    !> Variable whose metadata and data are written.
    type(variable_type), target, intent(in) :: var
    !> Operation error.
    type(error_type), intent(out) :: err
  end subroutine put_var

  !> Write one Fortran-order hyperslab while serializing an in-memory model.
  module subroutine put_vara(nc, var, start, count, err)
    !> Open dataset or group.
    class(group_type), intent(in) :: nc
    !> Data buffer whose dimensions equal `count`.
    type(variable_type), target, intent(in) :: var
    !> One-based Fortran-order start indices.
    integer, intent(in) :: start(:)
    !> Fortran-order edge lengths to write.
    integer, intent(in) :: count(:)
    !> Operation error.
    type(error_type), intent(out) :: err
  end subroutine put_vara

  !> Write all attributes belonging to one variable during serialization.
  module subroutine put_att_var(nc, var, err)
    !> Open dataset or group.
    class(group_type), intent(in) :: nc
    !> Variable whose attributes are written.
    type(variable_type), target, intent(in) :: var
    !> Operation error.
    type(error_type), intent(out) :: err
  end subroutine put_att_var

  !> Write all global attributes belonging to one group during serialization.
  module subroutine put_att_grp(nc, err)
    !> Open dataset or group whose global attributes are written.
    class(group_type), target, intent(in) :: nc
    !> Operation error.
    type(error_type), intent(out) :: err
  end subroutine put_att_grp

  !> Serialize one in-memory group as an existing file root.
  module subroutine serialize_grp(root, grp, atts, err)
    class(group_type), intent(in) :: root
    type(group_type), intent(in) :: grp
    type(attribute_type), intent(in), optional :: atts(:)
    type(error_type), intent(out) :: err
  end subroutine serialize_grp

  !> Serialize in-memory groups as direct children of an existing file root.
  module subroutine serialize_grps(root, grps, atts, err)
    class(group_type), intent(in) :: root
    type(group_type), target, intent(in) :: grps(:)
    type(attribute_type), intent(in), optional :: atts(:)
    type(error_type), intent(out) :: err
  end subroutine serialize_grps
end interface

end module nc4f_nc
