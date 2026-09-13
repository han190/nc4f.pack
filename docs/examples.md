# Examples

These four examples are intended to be read as a progression. Together they
exercise the public `nc4f` façade: the in-memory data model, construction and
copy controls, formatted output, file I/O, metadata inquiry, group traversal,
hyperslabs, and recoverable errors.

All examples start with:

```fortran
use, non_intrinsic :: nc4f
implicit none (type, external)
```

## 1. Create a small dataset

This example constructs an unlimited dimension, attributes, and a variable in
memory, then combines them into a root group. It demonstrates the concise
`.dim.`, `.and.`, and `.att.` constructors, writes ncdump-like formatted
output, and serializes the group as a new NetCDF file. The named `vars` array
also makes the lifetime of the shallowly retained variable explicit.

```fortran
program create_dataset
  use, non_intrinsic :: nc4f
  implicit none (type, external)

  type(variable_type) :: vars(1)
  type(group_type) :: root
  real :: values(3) = [1.0, 2.0, 3.0]

  vars(1) = datarray("temperature", values, ["time".dim.(3 .and. .true.)], &
    & atts=["units".att."K"])
  root = dataset("/", vars, atts=["title".att."Example dataset"])

  if (vars(1) == vars(1)) write (*, *) root
  if (vars(1) /= vars(1)) error stop "unexpected unequal variables"
  call to_netcdf("example.nc", root)
end program create_dataset
```

## 2. Read, inspect, compute, and write

This example opens a file for modification, reads two compatible
one-dimensional variables, adds them with `sum`, and uses `initialize` to
prepare a writable result with matching metadata and storage. `extract`
exposes typed source and output values, while `shape` and `size` inspect the
materialized object. Finally, the result is written to the open file and the
file is closed.

```fortran
program compute_variables
  use, non_intrinsic :: nc4f
  implicit none (type, external)

  type(netcdf_type) :: nc
  type(variable_type) :: inputs(2), total, output
  real, pointer :: total_values(:), output_values(:)

  nc = open_dataset("input.nc", "a")
  inputs = get_variable(nc, [character(len=2) :: "P", "PB"])
  total = sum(inputs)

  call initialize(output, mold=total)
  output%name = "mean_pressure"
  call extract(total, total_values)
  call extract(output, output_values)
  output_values = 0.5 * total_values
  print *, shape(output), size(output)

  call put_variable(nc, output)
  call close_dataset(nc)
end program compute_variables
```

## 3. Inspect a grouped file and edit metadata

This example traverses a first-level group and materializes its recursive
metadata description. It distinguishes group-local dimensions from a
variable's dimensions, reads both global and variable attributes, then writes
new attributes back to the file. It is the main example for NetCDF-4 groups.

```fortran
program inspect_groups
  use, non_intrinsic :: nc4f
  implicit none (type, external)

  type(netcdf_type) :: nc
  type(group_type) :: atmosphere, description
  type(group_type), allocatable :: children(:)
  type(dimension_type), allocatable :: dims(:)
  type(dimension_type), allocatable :: variable_dims(:)
  type(variable_type) :: temperature
  type(attribute_type) :: title, units
  type(attribute_type), allocatable :: global_atts(:)
  type(attribute_type), allocatable :: variable_atts(:)

  nc = open_dataset("grouped.nc", "a")
  atmosphere = get_group(nc, "atmosphere")
  children = inquire_groups(atmosphere)
  description = inquire_group(atmosphere, inq_dims=.true., inq_atts=.true., &
    & inq_vars=.true., inq_grps=.true., recursive=.true.)

  dims = inquire_dimensions(atmosphere)
  temperature = inquire_variable(atmosphere, "temperature")
  variable_dims = inquire_dimensions(atmosphere, temperature)
  title = get_attribute(nc, "title")
  units = get_attribute(atmosphere, temperature, "units")
  global_atts = get_attribute(nc)
  variable_atts = get_attribute(atmosphere, temperature)

  temperature%atts = ["long_name".att."Air temperature"]
  nc%atts = ["history".att."updated by nc4f"]
  call put_attribute(atmosphere, temperature)
  call put_attribute(nc)
  call close_dataset(nc)
end program inspect_groups
```

## 4. Hyperslabs, shallow buffers, and recoverable errors

This example reads a one-dimensional hyperslab using Fortran's one-based
indices, replaces it with a shallow `datarray` view over a named `target`
array, and writes it back to the same region. Passing `error=` keeps failures
recoverable; `.exists.` and the re-exported NetCDF status constants make the
result easy to inspect. The target array must remain alive until all uses of
the shallow variable have completed.

```fortran
program hyperslab_and_errors
  use, non_intrinsic :: nc4f
  implicit none (type, external)

  type(netcdf_type) :: nc
  type(error_type) :: error
  type(variable_type) :: slab
  real, target :: values(10)

  nc = open_dataset("input.nc", "a", error=error)
  if (.exists. error) then
    if (error%code == NC_ENOTFOUND) print *, "A requested NetCDF object was not found."
    error stop error%message
  end if

  slab = get_variable(nc, "temperature", start=[1], count=[10], error=error)
  if (.exists. error) error stop error%message

  values = 273.15
  slab = datarray("temperature", values, ["time".dim.10], deep=.false.)
  call put_variable(nc, slab, start=[1], count=[10], error=error)
  if (.exists. error) error stop error%message
  call close_dataset(nc, error)
end program hyperslab_and_errors
```

`to_netcdf` also accepts an array of variables or an array of child groups.
The first example uses the group form; replace `root` with `vars` for a
variable-array file, or with a named `group_type` array for a file whose root
contains those groups as direct children.
