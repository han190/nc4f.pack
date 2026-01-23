module nc4f_nc

use, intrinsic :: iso_fortran_env, only: &
  & int8, int16, int32, int64, real32, real64
use, intrinsic :: iso_c_binding
use, non_intrinsic :: nc4f_c_interface
use, non_intrinsic :: nc4f_data_struct
implicit none (type, external)

public :: &
  open_dataset, close_dataset, to_netcdf, &
  inquire_dimensions, inquire_variable, &
  get_attribute, get_variable, &
  put_attribute, put_variable
private

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

interface to_netcdf
  module procedure :: to_netcdf_var
  module procedure :: to_netcdf_vars
end interface to_netcdf

interface
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
  module function open_dataset(filename, mode, inq_dims, inq_atts, exist) result(nc)
    !> Path to the dataset file.
    character(len=*), intent(in) :: filename
    !> Mode to open the file in: 'r' for read, 'w' for write.
    character(len=*), intent(in), optional :: mode
    !> When true, inquire dimensions after opening the file.
    logical, intent(in), optional :: inq_dims
    !> When true, inquire global attributes after opening the file.
    logical, intent(in), optional :: inq_atts
    !> Check if file exists (only valid when mode is 'r').
    logical, intent(out), optional :: exist
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
end interface

end module nc4f_nc
