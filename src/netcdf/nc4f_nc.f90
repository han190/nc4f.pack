module nc4f_nc

use, intrinsic :: iso_fortran_env, only: &
  & int8, int16, int32, int64, real32, real64
use, intrinsic :: iso_c_binding
use, non_intrinsic :: nc4f_c_interface
use, non_intrinsic :: nc4f_ds
implicit none (type, external)

public :: &
  & open_netcdf, close_netcdf, to_netcdf, &
  & inquire_dimensions, inquire_variable, &
  & get_attribute, get_variable, get_group, &
  & delete_attribute, rename_attribute, rename_variable, rename_group, &
    rename_dimension, &
  & inquire_subgroups, inquire_group, operator(.exists.)
private

interface rename_dimension
  module procedure :: rename_dim_nc_dim, rename_dim_nc_grp
end interface rename_dimension

interface delete_attribute
  module procedure :: del_att_nc_var, del_att_nc_grp
end interface delete_attribute

interface rename_attribute
  module procedure :: rename_att_nc_var, rename_att_nc_grp
end interface rename_attribute

interface rename_group
  module procedure :: rename_grp_nc_grp, rename_grp_nc_par
end interface rename_group

interface rename_variable
  module procedure :: rename_var_nc_var, rename_var_nc_grp
end interface rename_variable

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
  module subroutine rename_dim_nc_dim(grp, dim, new_name, update_file, err)
    !! Rename a locally defined file dimension and only the supplied dimension object.
    class(group_type), intent(in) :: grp
    !! Defining open group when update_file is true; its caches are not synchronized.
    type(dimension_type), intent(inout) :: dim
    !! Dimension whose old name selects the file target; its cached ID is not trusted.
    character(len=*), intent(in) :: new_name
    !! Replacement local name; trailing padding is ignored.
    logical, intent(in), optional :: update_file
    !! Whether to update the file as well as dim; defaults to false.
    type(error_type), intent(out), optional :: err
    !! Receives status; failures terminate execution when omitted.
  end subroutine rename_dim_nc_dim

  module subroutine rename_dim_nc_grp(grp, old_name, new_name, update_file, err)
    !! Rename a local file dimension and synchronize only direct loaded dimension references.
    class(group_type), intent(inout) :: grp
    !! Defining group; descendant caches and independent snapshots are unchanged.
    character(len=*), intent(in) :: old_name, new_name
    !! old_name: Local dimension to find. new_name: Replacement local name.
    logical, intent(in) :: update_file
    !! Whether to update the file; required to distinguish the model-only overload.
    type(error_type), intent(out), optional :: err
    !! Receives status; failures terminate execution when omitted.
  end subroutine rename_dim_nc_grp

  module subroutine rename_grp_nc_grp(parent, grp, new_name, update_file, err)
    !! Rename the supplied child, optionally updating its name in an open file.
    class(group_type), intent(in) :: parent
    !! Open parent group used to locate the supplied child for a file update.
    class(group_type), intent(inout) :: grp
    !! Non-root group whose local name is changed.
    character(len=*), intent(in) :: new_name
    !! Replacement local name; trailing Fortran blank padding is removed.
    logical, intent(in), optional :: update_file
    !! Whether to update the open NetCDF file as well as the model (default false).
    type(error_type), intent(out), optional :: err
    !! Receives the status and diagnostic; failures stop execution when omitted.
  end subroutine rename_grp_nc_grp

  module subroutine rename_grp_nc_par(parent, old_name, new_name, update_file, err)
    !! Rename a direct child by name; update a matching cached child if present.
    class(group_type), intent(inout) :: parent
    !! Parent providing the file context and any cached direct children to update.
    character(len=*), intent(in) :: old_name, new_name
    !! old_name: Existing local name to locate.
    !! new_name: Replacement local name; trailing Fortran blank padding is removed.
    logical, intent(in) :: update_file
    !! Whether to update the open NetCDF file as well as the model.
    type(error_type), intent(out), optional :: err
    !! Receives the status and diagnostic; failures stop execution when omitted.
  end subroutine rename_grp_nc_par

  module subroutine rename_var_nc_var(grp, var, new_name, update_file, err)
    !! Rename the supplied variable, optionally updating its name in the file.
    !! grp%vars and other copies are not synchronized; the old name selects the target.
    class(group_type), intent(in) :: grp
    !! Open group containing the supplied variable when a file update is requested.
    type(variable_type), intent(inout) :: var
    !! Variable whose local name is changed; its metadata and storage are preserved.
    character(len=*), intent(in) :: new_name
    !! Replacement local name; trailing Fortran blank padding is removed.
    logical, intent(in), optional :: update_file
    !! Whether to update the open NetCDF file as well as the model (default false).
    type(error_type), intent(out), optional :: err
    !! Receives the status and diagnostic; failures stop execution when omitted.
  end subroutine rename_var_nc_var

  module subroutine rename_var_nc_grp(grp, old_name, new_name, update_file, err)
    !! Rename a file variable and its matching grp%vars entry, if loaded.
    !! update_file is required to distinguish this from the model-only overload.
    class(group_type), intent(inout) :: grp
    !! Group whose direct variable collection contains the name to change.
    character(len=*), intent(in) :: old_name, new_name
    !! old_name: Existing local name to locate.
    !! new_name: Replacement local name; trailing Fortran blank padding is removed.
    logical, intent(in) :: update_file
    !! Whether to update the open NetCDF file as well as the model.
    type(error_type), intent(out), optional :: err
    !! Receives the status and diagnostic; failures stop execution when omitted.
  end subroutine rename_var_nc_grp

  module subroutine del_att_nc_var(grp, var, name, update_file, err)
    !! Delete a variable attribute in the model and optionally in its open NetCDF group.
    !! Independent copies, including grp%vars, are not synchronized.
    class(group_type), intent(in) :: grp
    !! Open containing group, used only when updating the file.
    type(variable_type), intent(inout) :: var
    !! Variable whose supplied attribute cache is updated after successful deletion.
    character(len=*), intent(in) :: name
    !! Local attribute name; trailing Fortran padding is ignored.
    logical, intent(in), optional :: update_file
    !! Whether to delete from the file too; defaults to false.
    type(error_type), intent(out), optional :: err
    !! Receives status and diagnostic; failures stop execution when omitted.
  end subroutine del_att_nc_var

  module subroutine del_att_nc_grp(grp, name, update_file, err)
    !! Delete a group/global attribute in the model and optionally in the open file.
    class(group_type), intent(inout) :: grp
    !! Group whose supplied attribute cache is updated after successful deletion.
    character(len=*), intent(in) :: name
    !! Local attribute name; trailing Fortran padding is ignored.
    logical, intent(in) :: update_file
    !! Whether to delete from the file too; required to distinguish model-only calls.
    type(error_type), intent(out), optional :: err
    !! Receives status and diagnostic; failures stop execution when omitted.
  end subroutine del_att_nc_grp

  module subroutine rename_att_nc_var(grp, var, old_name, new_name, &
      update_file, err)
    !! Rename a variable attribute; optionally update the file and supplied
    !! cache.
    !! Other variable copies, including grp%vars, are not synchronized.
    class(group_type), intent(in) :: grp
    !! Open group containing the supplied variable when a file update is requested.
    type(variable_type), intent(inout) :: var
    !! Variable whose matching attribute is renamed; its data and own name are preserved.
    character(len=*), intent(in) :: old_name, new_name
    !! old_name: Existing local name to locate.
    !! new_name: Replacement local name; trailing Fortran blank padding is removed.
    logical, intent(in), optional :: update_file
    !! Whether to update the open NetCDF file as well as the model (default false).
    type(error_type), intent(out), optional :: err
    !! Receives the status and diagnostic; failures stop execution when omitted.
  end subroutine rename_att_nc_var

  module subroutine rename_att_nc_grp(grp, old_name, new_name, update_file, err)
    !! Rename a group/global attribute in the file and any matching cached entry.
    !! update_file is required to distinguish this from the model-only overload.
    class(group_type), intent(inout) :: grp
    !! Group whose matching global attribute is renamed.
    character(len=*), intent(in) :: old_name, new_name
    !! old_name: Existing local name to locate.
    !! new_name: Replacement local name; trailing Fortran blank padding is removed.
    logical, intent(in) :: update_file
    !! Whether to update the open NetCDF file as well as the model.
    type(error_type), intent(out), optional :: err
    !! Receives the status and diagnostic; failures stop execution when omitted.
  end subroutine rename_att_nc_grp

  module function get_group(parent, name, err) result(group)
    !! Return a direct child group by name.
    class(group_type), intent(in) :: parent
    !! Open parent group whose direct children are queried.
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
    !! Open parent group whose direct children are queried.
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
    !! inq_dims: Whether to populate the cached dimensions.
    !! inq_atts: Whether to populate the cached group attributes.
    !! inq_vars: Whether to populate the cached variable metadata.
    !! inq_grps: Whether to populate the cached child groups.
    logical, intent(in), optional :: recur
    !! Whether to apply the requested inquiries recursively to descendants.
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

  module function netcdf_err(status, context) result(err)
    !! Construct an `error_type` from a NetCDF C status and optional context.
    integer(c_int), intent(in) :: status
    !! Status code returned by a NetCDF C call.
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
    !! C character string whose first NUL marks the end of the converted text.
    character(len=:), allocatable :: fstr
    !! Fortran allocatable result string.
  end function c2fstr

  pure module function f2cstr(fstr) result(cstr)
    !! Convert a Fortran string to a NUL-terminated C string.
    character(len=*), intent(in) :: fstr
    !! Fortran string whose trailing blanks are removed before appending NUL.
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
    !! Open destination root group in which the source tree is serialized.
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
    !! Open destination root group in which the source tree is serialized.
    type(group_type), target, intent(in) :: grps(:)
    !! Source child-group trees to write below the destination root.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Attributes to process or attach.
    type(error_type), intent(out) :: err
    !! Error object updated if the operation fails.
  end subroutine serialize_grps
end interface

end module nc4f_nc
