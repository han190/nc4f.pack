module nc4f_nc

use, intrinsic :: iso_fortran_env, only: &
  & int8, int16, int32, int64, real32, real64
use, intrinsic :: iso_c_binding
use, non_intrinsic :: nc4f_c_interface
use, non_intrinsic :: nc4f_data_struct
implicit none (type, external)

public :: &
  open_netcdf, close_netcdf, to_netcdf, &
  inquire_dimensions, inquire_variable, &
  get_attribute, get_variable, &
  put_attribute, put_variable, &
  get_group, inquire_subgroups, inquire_group, operator(.exists.)
private

!> Fixed scratch length for operation-context diagnostics.
integer, parameter :: MAX_CHAR_LEN = 1024

interface get_variable
  module procedure :: get_var !> Impure Elemental
  module procedure :: get_var_err
  module procedure :: get_vara
end interface get_variable

interface put_variable
  module procedure :: put_var !> Impure Elemental
  module procedure :: put_var_err
  module procedure :: put_vara
end interface put_variable

interface inquire_variable
  module procedure :: inq_var !> Impure Elemental
  module procedure :: inq_var_err
end interface inquire_variable

interface get_attribute
  module procedure :: get_atts_grp
  module procedure :: get_att_grp !> Impure Elemental
  module procedure :: get_att_grp_err
  module procedure :: get_atts_var
  module procedure :: get_att_var !> Impure Elemental
  module procedure :: get_att_var_err
end interface get_attribute

interface put_attribute
  module procedure :: put_att_grp !> Impure Elemental
  module procedure :: put_att_grp_err
  module procedure :: put_att_var !> Impure Elemental
  module procedure :: put_att_var_err
end interface put_attribute

interface inquire_dimensions
  module procedure :: inq_dims_grp
  module procedure :: inq_dims_var
end interface inquire_dimensions

interface get_group
  module procedure :: get_grp
end interface get_group

interface inquire_subgroups
  module procedure :: inq_subgrps
end interface inquire_subgroups

interface inquire_group
  module procedure :: inq_grp
end interface inquire_group

interface to_netcdf
  module procedure :: to_netcdf_var
  module procedure :: to_netcdf_grp
  module procedure :: to_netcdf_grps
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
  module function get_grp(parent, name, err) result(group)
    class(group_type), intent(in) :: parent
    character(len=*), intent(in) :: name
    type(error_type), intent(out), optional :: err
    type(group_type) :: group
  end function get_grp

  !> Return direct child groups with IDs and names populated.
  module function inq_subgrps(parent, err) result(grps)
    class(group_type), intent(in) :: parent
    type(error_type), intent(out), optional :: err
    type(group_type), allocatable :: grps(:)
  end function inq_subgrps

  !> Materialize selected metadata for a group.
  module recursive subroutine inq_grp(group, inq_dims, inq_atts, inq_vars, &
    & inq_subgrps, recursive, err)
    class(group_type), intent(inout) :: group
    logical, intent(in), optional :: inq_dims, inq_atts, inq_vars, inq_subgrps
    logical, intent(in), optional :: recursive
    type(error_type), intent(out), optional :: err
  end subroutine inq_grp

  !> Read a global attribute by name and return it.
  module impure elemental function get_att_grp(nc, name) result(att)
    !> High-level `netcdf_type` representing the open file.
    class(group_type), intent(in) :: nc
    !> Name of the global attribute to read.
    character(len=*), intent(in) :: name
    !> Returned attribute object.
    type(attribute_type) :: att
  end function get_att_grp

  !> Read a global attribute by name without stopping on a NetCDF failure.
  module function get_att_grp_err(nc, name, err) result(att)
    !> Input argument(s): `nc`.
    class(group_type), intent(in) :: nc
    !> Input argument(s): `name`.
    character(len=*), intent(in) :: name
    !> Output argument(s): `err`.
    type(error_type), intent(out) :: err
    type(attribute_type) :: att
  end function get_att_grp_err

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
  module function get_att_var(nc, var, name) result(att)
    !> High-level `netcdf_type` representing the open file.
    class(group_type), intent(in) :: nc
    !> Variable whose attribute will be read.
    type(variable_type), intent(in) :: var
    !> Name of the attribute to read.
    character(len=*), intent(in) :: name
    !> Returned attribute object.
    type(attribute_type) :: att
  end function get_att_var

  !> Read a variable attribute by name without stopping on a NetCDF failure.
  module function get_att_var_err(nc, var, name, err) result(att)
    !> Input argument(s): `nc`.
    class(group_type), intent(in) :: nc
    !> Input argument(s): `var`.
    type(variable_type), intent(in) :: var
    !> Input argument(s): `name`.
    character(len=*), intent(in) :: name
    !> Output argument(s): `err`.
    type(error_type), intent(out) :: err
    type(attribute_type) :: att
  end function get_att_var_err

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

  !> Write all attributes of a variable to the dataset.
  module impure elemental subroutine put_att_var(nc, var)
    !> High-level `netcdf_type` representing the open file.
    class(group_type), intent(in) :: nc
    !> Variable whose attributes will be written to the file.
    type(variable_type), target, intent(in) :: var
  end subroutine put_att_var

  !> Write all attributes of a variable without stopping on a NetCDF failure.
  module subroutine put_att_var_err(nc, var, err)
    !> Input argument(s): `nc`.
    class(group_type), intent(in) :: nc
    !> Input argument(s): `var`.
    type(variable_type), target, intent(in) :: var
    !> Output argument(s): `err`.
    type(error_type), intent(out) :: err
  end subroutine put_att_var_err

  !> Write all global attributes of the dataset to the file.
  module impure elemental subroutine put_att_grp(nc)
    !> High-level `netcdf_type` representing the open file.
    class(group_type), target, intent(in) :: nc
  end subroutine put_att_grp

  !> Write all global attributes without stopping on a NetCDF failure.
  module subroutine put_att_grp_err(nc, err)
    !> Input argument(s): `nc`.
    class(group_type), target, intent(in) :: nc
    !> Output argument(s): `err`.
    type(error_type), intent(out) :: err
  end subroutine put_att_grp_err

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
  module function open_netcdf(filename, mode, err) result(nc)
    !> Path to the dataset file.
    character(len=*), intent(in) :: filename
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
  module subroutine to_netcdf_var(filename, vars, atts, err)
    !> Output filename to create.
    character(len=*), intent(in) :: filename
    !> Variable or array of variables to write into the file.
    type(variable_type), intent(in) :: vars(..)
    !> Optional array of global attributes to attach to the dataset.
    type(attribute_type), intent(in), optional :: atts(:)
    !> Optional error result. When absent, failures stop the program.
    type(error_type), intent(out), optional :: err
  end subroutine to_netcdf_var

  !> Create a netCDF file whose root group has `grp`'s contents.
  module subroutine to_netcdf_grp(filename, grp, atts, err)
    !> Output filename to create.
    character(len=*), intent(in) :: filename
    !> In-memory group whose dimensions, attributes, variables, and child
    !> groups are written as the file's root group. Its name is not written,
    !> because a NetCDF file root is always named `/`.
    type(group_type), intent(in) :: grp
    !> Optional additional global attributes for the file root. Entries with
    !> names already present in `grp%atts` replace those root attributes.
    type(attribute_type), intent(in), optional :: atts(:)
    !> Optional error result. When absent, failures stop the program.
    type(error_type), intent(out), optional :: err
  end subroutine to_netcdf_grp

  !> Create a netCDF file with `grps` as direct children of a new root group.
  module subroutine to_netcdf_grps(filename, grps, atts, err)
    !> Output filename to create.
    character(len=*), intent(in) :: filename
    !> In-memory groups to write below a newly created, otherwise empty root
    !> group. No first-level group may be named `/`.
    type(group_type), intent(in) :: grps(:)
    !> Optional global attributes for the otherwise empty file root.
    type(attribute_type), intent(in), optional :: atts(:)
    !> Optional error result. When absent, failures stop the program.
    type(error_type), intent(out), optional :: err
  end subroutine to_netcdf_grps

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

  !> Define a dimension in the netCDF file if it does not already exist.
  module impure elemental function def_dim(nc, dim) result(new_dim)
    !> High-level `netcdf_type` for the file.
    class(group_type), intent(in) :: nc
    !> `dimension_type` describing the desired dimension (name, len,
    !> is_unlim).
    type(dimension_type), intent(in) :: dim
    !> The `dimension_type` of the existing or newly-created dimension
    !> (including the assigned `id`). This routine is `impure` because it
    !> may modify the underlying file state.
    type(dimension_type) :: new_dim
  end function def_dim

  !> Define a dimension without stopping on a NetCDF failure.
  module function def_dim_err(nc, dim, err) result(new_dim)
    !> Input argument(s): `nc`.
    class(group_type), intent(in) :: nc
    !> Input argument(s): `dim`.
    type(dimension_type), intent(in) :: dim
    !> Output argument(s): `err`.
    type(error_type), intent(out) :: err
    type(dimension_type) :: new_dim
  end function def_dim_err

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
  module impure elemental function get_var(nc, name) result(var)
    !> High-level `netcdf_type` representing the open file.
    class(group_type), intent(in) :: nc
    !> Name of the variable to read.
    character(len=*), intent(in) :: name
    !> Variable object that will contain metadata and the data buffer.
    type(variable_type), target :: var
  end function get_var

  !> Read a scalar-named variable without stopping on a NetCDF failure.
  module function get_var_err(nc, name, err) result(var)
    !> Input argument(s): `nc`.
    class(group_type), intent(in) :: nc
    !> Input argument(s): `name`.
    character(len=*), intent(in) :: name
    !> Output argument(s): `err`.
    type(error_type), intent(out) :: err
    type(variable_type), target :: var
  end function get_var_err

  !> Read a contiguous Fortran-order hyperslab into a `variable_type`.
  module function get_vara(nc, name, start, count, err) result(var)
    !> High-level `netcdf_type` representing the open file.
    class(group_type), intent(in) :: nc
    !> Name of the variable to read.
    character(len=*), intent(in) :: name
    !> One-based start indices in the variable's Fortran dimension order.
    integer, intent(in) :: start(:)
    !> Number of elements to read along each Fortran-order dimension.
    integer, intent(in) :: count(:)
    !> Optional error result. When absent, failures stop the program.
    type(error_type), intent(out), optional :: err
    !> Materialized variable containing the selected data.
    type(variable_type), target :: var
  end function get_vara

  !> Inquire a variable's metadata without reading its data buffer.
  module impure elemental function inq_var(nc, name) result(var)
    !> High-level `netcdf_type` representing the open file.
    class(group_type), intent(in) :: nc
    !> Name of the variable to inquire.
    character(len=*), intent(in) :: name
    !> Variable object containing metadata (name, type, dims, atts, len).
    type(variable_type) :: var
  end function inq_var

  !> Inquire a scalar-named variable without stopping on a NetCDF failure.
  module function inq_var_err(nc, name, err) result(var)
    !> Input argument(s): `nc`.
    class(group_type), intent(in) :: nc
    !> Input argument(s): `name`.
    character(len=*), intent(in) :: name
    !> Output argument(s): `err`.
    type(error_type), intent(out) :: err
    type(variable_type) :: var
  end function inq_var_err

  !> Write a variable's data and metadata to a netCDF dataset.
  module impure elemental subroutine put_var(nc, var)
    !> High-level `netcdf_type` representing the open file.
    class(group_type), intent(in) :: nc
    !> Variable object containing metadata and a data buffer to write.
    type(variable_type), target, intent(in) :: var
  end subroutine put_var

  !> Write a scalar variable without stopping on a NetCDF failure.
  module subroutine put_var_err(nc, var, err)
    !> Input argument(s): `nc`.
    class(group_type), intent(in) :: nc
    !> Input argument(s): `var`.
    type(variable_type), target, intent(in) :: var
    !> Output argument(s): `err`.
    type(error_type), intent(out) :: err
  end subroutine put_var_err

  !> Define variable metadata without transferring its data buffer.
  module function def_var_(nc, var, err) result(new_var)
    class(group_type), intent(in) :: nc
    type(variable_type), intent(in) :: var
    type(error_type), intent(out) :: err
    type(variable_type) :: new_var
  end function def_var_

  !> Serialize one in-memory group as an existing file root.
  module subroutine serialize_grp_(root, grp, atts, err)
    class(group_type), intent(in) :: root
    type(group_type), intent(in) :: grp
    type(attribute_type), intent(in), optional :: atts(:)
    type(error_type), intent(out) :: err
  end subroutine serialize_grp_

  !> Serialize in-memory groups as direct children of an existing file root.
  module subroutine serialize_grps_(root, grps, atts, err)
    class(group_type), intent(in) :: root
    type(group_type), target, intent(in) :: grps(:)
    type(attribute_type), intent(in), optional :: atts(:)
    type(error_type), intent(out) :: err
  end subroutine serialize_grps_

  !> Write `var` into an existing variable at a Fortran-order hyperslab.
  module subroutine put_vara(nc, var, start, count, err)
    !> Open dataset in append (`"a"`) or read/write mode.
    class(group_type), intent(in) :: nc
    !> Data buffer whose dimensions must equal `count`.
    type(variable_type), target, intent(in) :: var
    !> One-based Fortran-order start indices.
    integer, intent(in) :: start(:)
    !> Fortran-order edge lengths to write.
    integer, intent(in) :: count(:)
    !> Optional error result. When absent, failures stop the program.
    type(error_type), intent(out), optional :: err
  end subroutine put_vara
end interface

end module nc4f_nc
