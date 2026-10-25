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

integer, parameter :: MAX_CHAR_LEN = 1024
!! Fixed scratch length for operation-context diagnostics.

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

interface operator(.exists.)
  !! Return whether an error result represents a failed operation.
  module procedure :: has_err
end interface operator(.exists.)

interface initialize
  !! Allocate a fresh byte buffer for metadata read from the C API.
  module procedure :: initialize_att
  module procedure :: initialize_var
end interface initialize

interface
  module function get_group(parent, name, err) result(group)
    !! Return a direct child group by name.
    class(group_type), intent(in) :: parent
    !! Data or metadata used by this operation.
    character(len=*), intent(in) :: name
    !! Name used to identify the NetCDF object.
    type(error_type), intent(out), optional :: err
    !! Error object updated if the operation fails.
    type(group_type) :: group
    !! Retrieved or newly defined group.
  end function get_group

  module function inquire_subgroups(parent, err) result(grps)
    !! Return direct child groups with IDs and names populated.
    class(group_type), intent(in) :: parent
    !! Data or metadata used by this operation.
    type(error_type), intent(out), optional :: err
    !! Error object updated if the operation fails.
    type(group_type), allocatable :: grps(:)
    !! Retrieved child groups.
  end function inquire_subgroups

  recursive module subroutine inquire_group(group, &
    & inq_dims, inq_atts, inq_vars, inq_grps, recur, err)
    !! Materialize selected metadata for a group.
    class(group_type), intent(inout) :: group
    !! Dataset group to process.
    logical, intent(in), optional :: inq_dims, inq_atts, inq_vars, inq_grps
    !! Data or metadata used by this operation.
    logical, intent(in), optional :: recur
    !! Data or metadata used by this operation.
    type(error_type), intent(out), optional :: err
    !! Error object updated if the operation fails.
  end subroutine inquire_group

  impure elemental module function get_att_grp(nc, name, err) result(att)
    !! Read a global attribute by name and return it.
    class(group_type), intent(in) :: nc
    !! High-level `netcdf_type` representing the open file.
    character(len=*), intent(in) :: name
    !! Name of the global attribute to read.
    type(error_type), intent(out), optional :: err
    !! Optional operation error. When absent, failures stop the program.
    type(attribute_type) :: att
    !! Returned attribute object.
  end function get_att_grp

  module function get_atts_grp(nc, err) result(atts)
    !! Return all global attributes for a dataset.
    class(group_type), intent(in) :: nc
    !! High-level `netcdf_type` representing the open file.
    type(error_type), optional, intent(out) :: err
    !! Optional error result. When absent, failures stop the program.
    type(attribute_type), allocatable :: atts(:)
    !! Allocatable array of attributes for the dataset.
  end function get_atts_grp

  module function get_att_var(nc, var, name, err) result(att)
    !! Read a named attribute attached to a variable and return it.
    class(group_type), intent(in) :: nc
    !! High-level `netcdf_type` representing the open file.
    type(variable_type), intent(in) :: var
    !! Variable whose attribute will be read.
    character(len=*), intent(in) :: name
    !! Name of the attribute to read.
    type(error_type), intent(out), optional :: err
    !! Optional operation error. When absent, failures stop the program.
    type(attribute_type) :: att
    !! Returned attribute object.
  end function get_att_var

  module function get_atts_var(nc, var, err) result(atts)
    !! Return all attributes attached to a variable.
    class(group_type), intent(in) :: nc
    !! High-level `netcdf_type` representing the open file.
    type(variable_type), intent(in) :: var
    !! Variable whose attributes will be returned.
    type(error_type), optional, intent(out) :: err
    !! Optional error result. When absent, failures stop the program.
    type(attribute_type), allocatable :: atts(:)
    !! Allocatable array of attributes for the variable.
  end function get_atts_var

  logical elemental module function eq_att(x, y)
    !! Return true when two `attribute_type` values are identical.
    type(attribute_type), intent(in) :: x
    !! Left-hand attribute to compare.
    type(attribute_type), intent(in) :: y
    !! Right-hand attribute to compare.
  end function eq_att

  logical elemental module function neq_att(x, y)
    !! Return true when two `attribute_type` values differ.
    type(attribute_type), intent(in) :: x
    !! Left-hand attribute to compare.
    type(attribute_type), intent(in) :: y
    !! Right-hand attribute to compare.
  end function neq_att

  module function open_netcdf(file, mode, err) result(nc)
    !! Open or create a dataset and return a `netcdf_type` handle.
    character(len=*), intent(in) :: file
    !! Path to the dataset file.
    character(len=*), intent(in), optional :: mode
    !! Mode to open the file: 'r' for read, 'w' to recreate, or 'a' for
    !! read/write access to an existing dataset.
    type(error_type), intent(out), optional :: err
    !! Optional error result. When absent, failures stop the program.
    type(netcdf_type) :: nc
    !! Returned `netcdf_type` describing the opened dataset.
  end function open_netcdf

  module subroutine close_netcdf(nc, err)
    !! Close a dataset and free associated allocatables.
    type(netcdf_type), intent(inout) :: nc
    !! `netcdf_type` representing the open dataset to close.
    type(error_type), intent(out), optional :: err
    !! Optional error result. When absent, failures stop the program.
  end subroutine close_netcdf

  module subroutine to_netcdf_var(file, vars, atts, err)
    !! Create a netCDF file from one variable or a rank-one variable array.
    character(len=*), intent(in) :: file
    !! Output file to create.
    type(variable_type), intent(in) :: vars(..)
    !! Variable or array of variables to write into the file.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional array of global attributes to attach to the dataset.
    type(error_type), intent(out), optional :: err
    !! Optional error result. When absent, failures stop the program.
  end subroutine to_netcdf_var

  module subroutine to_netcdf_grp(file, grp, atts, err)
    !! Create a netCDF file from one group or a rank-one group array.
    character(len=*), intent(in) :: file
    !! Output file to create.
    type(group_type), intent(in) :: grp(..)
    !! A scalar is written as the root (its name is ignored); an array is
    !! written as direct children of an otherwise empty root.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional root attributes. For a scalar, entries with names already
    !! present in `grp%atts` replace those attributes.
    type(error_type), intent(out), optional :: err
    !! Optional error result. When absent, failures stop the program.
  end subroutine to_netcdf_grp

  module function inq_dims_grp(nc, err) result(dims)
    !! Inquire all dimensions for the top-level group of a netCDF file.
    class(group_type), intent(in) :: nc
    !! High-level `netcdf_type` representing the open file.
    type(error_type), intent(out), optional :: err
    !! Optional error result. When absent, failures stop the program.
    type(dimension_type), allocatable :: dims(:)
    !! Allocatable array of `dimension_type` in Fortran order.
  end function inq_dims_grp

  module function inq_dims_var(nc, var, err) result(dims)
    !! Inquire the dimensions attached to a variable.
    class(group_type), intent(in) :: nc
    !! High-level `netcdf_type` for the file.
    type(variable_type), intent(in) :: var
    !! `variable_type` describing the variable.
    type(error_type), intent(out), optional :: err
    !! Optional error result. When absent, failures stop the program.
    type(dimension_type), allocatable :: dims(:)
    !! Allocatable array of `dimension_type` for that variable.
  end function inq_dims_var


  logical impure module function handle_err(err) result(has_failed)
    !! submodule_utility.f90
    !! Apply the library's fail-fast policy to a completed error result.
    type(error_type), intent(in) :: err
    !! Completed result of an nc4f operation.
  end function handle_err

  module function netcdf_err(status, context) result(err)
    !! Construct an `error_type` from a NetCDF C status and optional context.
    integer(c_int), intent(in) :: status
    !! Data or metadata used by this operation.
    character(*), intent(in), optional :: context
    !! Context included in a validation or error message.
    type(error_type) :: err
    !! Result produced by this operation.
  end function netcdf_err

  logical elemental module function has_err(err) result(is_err)
    !! Return true when `err` represents a failed operation.
    type(error_type), intent(in) :: err
    !! Completed result of an nc4f operation.
  end function has_err

  pure module function clip(string) result(clipped)
    !! Trim left and right space of a character variable.
    character(len=*), intent(in) :: string
    !! The input string.
    character(len=:), allocatable :: clipped
    !! The output string.
  end function clip

  pure module function c2fstr(cstr) result(fstr)
    !! Convert a NUL-terminated C string to a Fortran allocatable string.
    character(kind=c_char, len=*), intent(in) :: cstr
    !! C-style NUL-terminated string to convert.
    character(len=:), allocatable :: fstr
    !! Fortran allocatable result string.
  end function c2fstr

  pure module function f2cstr(fstr) result(cstr)
    !! Convert a Fortran string to a NUL-terminated C string.
    character(len=*), intent(in) :: fstr
    !! Fortran string to convert.
    character(kind=c_char, len=:), allocatable :: cstr
    !! NUL-terminated C string result.
  end function f2cstr

  pure module subroutine initialize_att(att)
    !! Allocate a fresh byte buffer for an attribute read from a NetCDF file.
    type(attribute_type), intent(inout) :: att
    !! Attribute to process.
  end subroutine initialize_att

  pure module subroutine initialize_var(var)
    !! Allocate a fresh byte buffer for a variable read from a NetCDF file.
    type(variable_type), intent(inout) :: var
    !! Variable to process.
  end subroutine initialize_var


  module function get_variable(nc, name, start, count, stride, err) result(var)
    !! submodule_variable.f90
    !! Read a variable's data from a netCDF dataset into a `variable_type`.
    class(group_type), intent(in) :: nc
    !! High-level `netcdf_type` representing the open file.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer, intent(in), optional :: start(:)
    !! Optional one-based Fortran-order hyperslab start indices.
    integer, intent(in), optional :: count(:)
    !! Optional hyperslab lengths.
    integer, intent(in), optional :: stride(:)
    !! Optional hyperslab strides.
    type(error_type), intent(out), optional :: err
    !! Optional operation error. When absent, failures stop the program.
    type(variable_type), target :: var
    !! Variable object that will contain metadata and the data buffer.
  end function get_variable

  impure elemental module function inquire_variable(nc, name, err) result(var)
    !! Inquire a variable's metadata without reading its data buffer.
    class(group_type), intent(in) :: nc
    !! High-level `netcdf_type` representing the open file.
    character(len=*), intent(in) :: name
    !! Name of the variable to inquire.
    type(error_type), intent(out), optional :: err
    !! Optional operation error. When absent, failures stop the program.
    type(variable_type) :: var
    !! Variable object containing metadata (name, type, dims, atts, len).
  end function inquire_variable

  module function def_dim(nc, dim, err) result(new_dim)
    !! Define or resolve one dimension while serializing an in-memory model.
    class(group_type), intent(in) :: nc
    !! Dataset or group that owns the dimension.
    type(dimension_type), intent(in) :: dim
    !! Dimension metadata to define or resolve.
    type(error_type), intent(out) :: err
    !! Operation error.
    type(dimension_type) :: new_dim
    !! Dimension metadata with its NetCDF identifier.
  end function def_dim

  module function def_var(nc, var, err) result(new_var)
    !! Define variable metadata without transferring its data buffer.
    class(group_type), intent(in) :: nc
    !! Open NetCDF dataset handle.
    type(variable_type), intent(in) :: var
    !! Variable to process.
    type(error_type), intent(out) :: err
    !! Error object updated if the operation fails.
    type(variable_type) :: new_var
    !! Result produced by this operation.
  end function def_var

  module subroutine put_var(nc, var, err)
    !! Write one complete variable while serializing an in-memory model.
    class(group_type), intent(in) :: nc
    !! Open dataset or group.
    type(variable_type), target, intent(in) :: var
    !! Variable whose metadata and data are written.
    type(error_type), intent(out) :: err
    !! Operation error.
  end subroutine put_var

  module subroutine put_vara(nc, var, start, count, err)
    !! Write one Fortran-order hyperslab while serializing an in-memory model.
    class(group_type), intent(in) :: nc
    !! Open dataset or group.
    type(variable_type), target, intent(in) :: var
    !! Data buffer whose dimensions equal `count`.
    integer, intent(in) :: start(:)
    !! One-based Fortran-order start indices.
    integer, intent(in) :: count(:)
    !! Fortran-order edge lengths to write.
    type(error_type), intent(out) :: err
    !! Operation error.
  end subroutine put_vara

  module subroutine put_att_var(nc, var, err)
    !! Write all attributes belonging to one variable during serialization.
    class(group_type), intent(in) :: nc
    !! Open dataset or group.
    type(variable_type), target, intent(in) :: var
    !! Variable whose attributes are written.
    type(error_type), intent(out) :: err
    !! Operation error.
  end subroutine put_att_var

  module subroutine put_att_grp(nc, err)
    !! Write all global attributes belonging to one group during serialization.
    class(group_type), target, intent(in) :: nc
    !! Open dataset or group whose global attributes are written.
    type(error_type), intent(out) :: err
    !! Operation error.
  end subroutine put_att_grp

  module subroutine serialize_grp(root, grp, atts, err)
    !! Serialize one in-memory group as an existing file root.
    class(group_type), intent(in) :: root
    !! Data or metadata used by this operation.
    type(group_type), intent(in) :: grp
    !! Dataset group to process.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Attributes to process or attach.
    type(error_type), intent(out) :: err
    !! Error object updated if the operation fails.
  end subroutine serialize_grp

  module subroutine serialize_grps(root, grps, atts, err)
    !! Serialize in-memory groups as direct children of an existing file root.
    class(group_type), intent(in) :: root
    !! Data or metadata used by this operation.
    type(group_type), target, intent(in) :: grps(:)
    !! Data or metadata used by this operation.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Attributes to process or attach.
    type(error_type), intent(out) :: err
    !! Error object updated if the operation fails.
  end subroutine serialize_grps
end interface

end module nc4f_nc
