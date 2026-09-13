# API reference

This page documents every item exported by the public `nc4f` façade:

```fortran
use, non_intrinsic :: nc4f
```

The API uses generic names extensively. The signatures below describe the
supported overload families; generated kind- and rank-specific procedures are
not part of the user-facing vocabulary.

## Types

### `error_type`

Result returned through optional `error=` arguments.

| Component | Meaning |
| --- | --- |
| `code` | NetCDF status; `NC_NOERR` denotes success. |
| `message` | Allocatable diagnostic message for a failure. |

Use `.exists. error` to test whether `code` is not `NC_NOERR`.

```fortran
type(error_type) :: error

nc = open_dataset("input.nc", "r", error=error)
if (.exists. error) print '(a)', error%message
```

### `dimension_type`

Describes a NetCDF dimension.

| Component | Meaning |
| --- | --- |
| `id` | NetCDF dimension ID; assigned by inquiry or definition. |
| `name` | Dimension name. |
| `len` | Current length. |
| `is_unlim` | True for an unlimited dimension. |

```fortran
type(dimension_type) :: longitude

longitude = "longitude".dim.360
```

### `attribute_type`

Describes a global or variable attribute.

| Component | Meaning |
| --- | --- |
| `id` | NetCDF attribute ID. |
| `name` | Attribute name. |
| `dtype` | NetCDF external type code. |
| `len` | Number of elements. |
| `buffer` | Pointer-backed raw byte values. Prefer `extract` to access them. |

```fortran
type(attribute_type) :: units

units = "units".att."K"
```

### `variable_type`

Describes a NetCDF variable and, when materialized, its values.

| Component | Meaning |
| --- | --- |
| `id` | NetCDF variable ID. |
| `name` | Variable name. |
| `dtype` | NetCDF external type code. |
| `len` | Total number of elements. |
| `dims` | Allocatable dimensions in Fortran dimension order. |
| `atts` | Allocatable variable attributes. |
| `buffer` | Pointer-backed raw byte values. Prefer `extract` to access them. |

```fortran
real :: values(2) = [280.0, 281.0]
type(variable_type) :: temperature

temperature = datarray("temperature", values, ["time".dim.2])
```

### `group_type`

Describes a NetCDF group. `dims`, `atts`, and `vars` are the objects local to
the group. `grps` is a pointer-backed array of direct child groups. Dimensions
may be absent in a child group even when its variables use dimensions inherited
from an ancestor.

| Component | Meaning |
| --- | --- |
| `id` | NetCDF group ID. |
| `name` | Group name; `/` conventionally denotes a root group. |
| `dims`, `atts`, `vars` | Local dimensions, global attributes, and variables. |
| `grps` | Pointer-backed direct child groups. |

```fortran
type(group_type) :: atmosphere
type(variable_type) :: vars(1)

vars(1) = datarray("temperature", [280.0], ["time".dim.1])
atmosphere = dataset("atmosphere", vars)
```

### `netcdf_type`

Extends `group_type` for an open file.

| Additional component | Meaning |
| --- | --- |
| `filename` | Open file path. |
| `mode` | NetCDF open mode. |

```fortran
type(netcdf_type) :: nc

nc = open_dataset("input.nc", "r")
call close_dataset(nc)
```

## NetCDF status constants

The following NetCDF C status constants are re-exported: `NC_NOERR`,
`NC_EBADID`, `NC_EBADDIM`, `NC_EBADGRPID`, `NC_EEDGE`, `NC_EINVAL`,
`NC_EINVALCOORDS`, `NC_ENOGRP`, `NC_ENOTATT`, `NC_ENOTFOUND`, and
`NC_ENOTVAR`. They are primarily useful for comparing `error%code`.

```fortran
if (error%code == NC_ENOTVAR) print *, "Variable does not exist."
if (error%code == NC_NOERR) print *, "Operation succeeded."
```

## Data construction and access

### `datarray(name, values, dims [, atts] [, deep])`

Constructs a `variable_type` from a rank 1–15 Fortran array. Supported value
types are `integer(int8)`, `integer(int16)`, `integer(int32)`,
`integer(int64)`, `real(real32)`, `real(real64)`, and `character`.

- `name` is the variable name.
- `values` supplies the values and determines the NetCDF type.
- `dims` is a `dimension_type` array in Fortran order.
- `atts` optionally supplies variable attributes.
- `deep` defaults to `.true.`. Numeric `deep=.false.` creates a borrowed
  buffer view and requires `values` to be a contiguous `target` array with a
  lifetime that exceeds the returned variable. Shallow character input is not
  supported.

```fortran
real, target :: pressure_values(2, 3)
type(variable_type) :: pressure

pressure = datarray("pressure", pressure_values, ["x".dim.2, "y".dim.3])
```

### `dataset`

Builds a `group_type` from a name and optional attributes, variables, and
child groups. These overloads are available:

```fortran
grp = dataset(name [, atts] [, deep])
grp = dataset(name, vars [, atts] [, deep])
grp = dataset(name, grps [, atts] [, deep])
grp = dataset(name, vars, grps [, atts] [, deep])
```

`deep` defaults to `.false.`. A shallow dataset shares variable buffers and
child-group trees; `deep=.true.` recursively clones them. Use named arrays
for `vars` and `grps` when their storage must have an explicit lifetime.

```fortran
type(variable_type) :: vars(2)
type(group_type) :: root

vars(1) = datarray("pressure", [100000.0], ["time".dim.1])
vars(2) = datarray("temperature", [280.0], ["time".dim.1])
root = dataset("/", vars, deep=.true.)
```

### `extract(source, pointer)`

Maps a source buffer to a typed Fortran pointer.

- For an `attribute_type`, numeric scalar and vector extraction is supported
  for the same integer and real kinds as `datarray`. Character attributes can
  be extracted as a scalar string or a character vector.
- For a `variable_type`, extraction supports those numeric kinds and
  single-character values at ranks 1–15. The pointer rank and element type
  must match the variable.

The returned pointer aliases the source buffer; do not deallocate it. It is
invalid once the source buffer is released or a borrowed source array expires.

```fortran
real, pointer :: values(:)

call extract(temperature, values)
print *, values(1)
```

### `initialize`

Initializes metadata and owned storage for an existing object.

```fortran
call initialize(att, name, dtype, len)
call initialize(att, mold)
call initialize(var, name, dtype, len, dims [, atts] [, deep])
call initialize(var, mold)
```

Use the mold forms to create output storage compatible with an existing
attribute or variable. `dtype` is the library's NetCDF data-type code, and
`dims` is in Fortran order.

```fortran
type(variable_type) :: output
real, pointer :: values(:)

call initialize(output, mold=temperature)
call extract(output, values)
values = 273.15
```

### `shape(var)` and `size(var [, dim])`

`shape` returns an allocatable default-integer array containing a
`variable_type`'s extents in Fortran order. `size` returns the total length as
`integer(int64)`, or the length of one-based dimension `dim`.

```fortran
integer, allocatable :: extents(:)
integer(int64) :: elements, columns

extents = shape(temperature)
elements = size(temperature)
columns = size(temperature, dim=2)
```

### `sum(vars)`

Returns the element-wise sum of an array of compatible materialized
`variable_type` objects. Variables must have compatible type and shape.

```fortran
type(variable_type) :: parts(2), total

parts = get_variable(nc, [character(len=2) :: "P", "PB"])
total = sum(parts)
```

## Dimension, attribute, and variable notation

### `.dim.` and `.and.`

Create dimensions concisely:

```fortran
type(dimension_type) :: time, latitude

time = "time".dim.(24 .and. .true.)
latitude = "lat".dim.181
```

`"name".dim.length` creates a fixed-size dimension. The right side can also
be `length .and. is_unlim` to set `is_unlim` explicitly. `length` accepts
`integer(int32)` and `integer(int64)`.

### `.att.`

Creates an `attribute_type` from an attribute name and a scalar or vector:

```fortran
type(attribute_type) :: units, valid_range

units = "units".att."K"
valid_range = "valid_range".att.[180.0, 330.0]
```

Supported numeric kinds are `int8`, `int16`, `int32`, `int64`, `real32`, and
`real64`; character input is a scalar string.

### `==` and `/=`

Elemental comparisons are defined for `dimension_type`, `attribute_type`, and
`variable_type`. They compare the objects' metadata and represented values.

```fortran
if ("x".dim.10 == "x".dim.10) print *, "same dimension"
if (temperature /= get_variable(nc, "temperature")) print *, "values changed"
```

### `write (formatted)`

Formatted derived-type I/O is defined for `dimension_type`, `attribute_type`,
`variable_type`, `group_type`, and `error_type`.

```fortran
write (*, *) grp
```

Groups are rendered recursively in an ncdump-like order: group name,
dimensions, variables, global attributes, then child groups.

## Files and groups

### `open_dataset(filename [, mode] [, inq_dims] [, inq_atts] [, error])`

Opens or creates a dataset and returns `netcdf_type`.

- `mode="r"` opens read-only (default).
- `mode="w"` recreates a file for writing.
- `mode="a"` opens an existing file for read/write access.
- `inq_dims` and `inq_atts` request eager root metadata inquiry.
- `error` receives an `error_type`; without it, failures are fail-fast.

```fortran
type(netcdf_type) :: nc

nc = open_dataset("analysis.nc", mode="a", inq_dims=.true., inq_atts=.true.)
```

### `close_dataset(nc [, error])`

Closes an open `netcdf_type`. Always close a file before its handle goes out of
scope or before reopening the same path for output.

```fortran
type(error_type) :: error

call close_dataset(nc, error)
if (.exists. error) print '(a)', error%message
```

### `to_netcdf(filename, object [, atts] [, error])`

Creates a NetCDF file from one of these public generic forms:

```fortran
call to_netcdf(filename, var [, atts] [, error])
call to_netcdf(filename, vars [, atts] [, error])
call to_netcdf(filename, grp [, atts] [, error])
call to_netcdf(filename, grps [, atts] [, error])
```

For a `group_type`, its contents are written as the file root; the group's
name is not written because the NetCDF root is `/`. For a `group_type` array,
each entry becomes a direct child of a new root; none may be named `/`.
`atts`, when supplied, adds or replaces root attributes.

```fortran
call to_netcdf("atmosphere.nc", root, ["title".att."Example dataset"])
```

### `inquire_dimensions(nc [, var] [, error])`

Returns an allocatable array of `dimension_type` values.

```fortran
dims = inquire_dimensions(nc [, error])
dims = inquire_dimensions(nc, var [, error])
```

The first form returns dimensions local to the group or root. The second
returns the dimensions associated with `var`.

```fortran
type(dimension_type), allocatable :: dims(:)

dims = inquire_dimensions(nc)
dims = inquire_dimensions(nc, temperature)
```

### `get_variable(nc, name [, start, count] [, error])`

Reads values and metadata into a `variable_type`.

```fortran
var = get_variable(nc, name)
var = get_variable(nc, name, error)
var = get_variable(nc, name, start, count [, error])
```

The whole-variable form is impure elemental and may be used with arrays of
group handles and names. The hyperslab form uses one-based `start` indices and
edge lengths in Fortran order.

```fortran
temperature = get_variable(nc, "temperature", start=[1, 1], count=[10, 5])
```

### `inquire_variable(nc, name [, error])`

Returns a `variable_type` containing metadata without reading its values. The
no-error form is impure elemental.

```fortran
type(variable_type) :: metadata

metadata = inquire_variable(nc, "temperature")
print *, metadata%len
```

### `put_variable(nc, var [, start, count] [, error])`

Writes a materialized variable to an open writable group.

```fortran
call put_variable(nc, var)
call put_variable(nc, var, error)
call put_variable(nc, var, start, count [, error])
```

The hyperslab form writes `var` into the indicated one-based Fortran-order
region of an existing variable. Its shape must equal `count`.

```fortran
call put_variable(nc, temperature)
call put_variable(nc, temperature, start=[1, 1], count=[10, 5])
```

### `get_attribute`

Reads one or all attributes from a group or a variable:

```fortran
att  = get_attribute(nc, name [, error])
atts = get_attribute(nc [, error])
att  = get_attribute(nc, var, name [, error])
atts = get_attribute(nc, var [, error])
```

The first two forms operate on group-global attributes. The latter two operate
on attributes attached to `var`.

```fortran
type(attribute_type) :: units
type(attribute_type), allocatable :: global_atts(:)

units = get_attribute(nc, temperature, "units")
global_atts = get_attribute(nc)
```

### `put_attribute(nc [, var] [, error])`

Writes attributes already present in an in-memory object:

```fortran
call put_attribute(nc [, error])
call put_attribute(nc, var [, error])
```

The first form writes `nc%atts` as group-global attributes. The second writes
`var%atts` to the corresponding variable.

```fortran
nc%atts = ["history".att."created by nc4f"]
call put_attribute(nc)
call put_attribute(nc, temperature)
```

### `get_group(parent, name [, error])`

Returns the direct child named `name`. `parent` may be a `netcdf_type` root or
any `group_type` whose ID refers to an open NetCDF group.

```fortran
type(group_type) :: atmosphere

atmosphere = get_group(nc, "atmosphere")
```

### `inquire_groups(parent [, error])`

Returns an allocatable array of a group's direct children with IDs and names
populated. It does not materialize their dimensions, attributes, variables, or
descendants.

```fortran
type(group_type), allocatable :: children(:)

children = inquire_groups(nc)
```

### `inquire_group(group [, inq_dims] [, inq_atts] [, inq_vars] [, inq_grps] [, recursive] [, error])`

Returns a selected metadata description of `group`.

- `inq_dims`, `inq_atts`, `inq_vars`, and `inq_grps` select which local
  collections to populate.
- `recursive=.true.` recursively applies the selected inquiries to child
  groups. It has effect only when `inq_grps=.true.`.
- `error` opts into error-returning behavior.

```fortran
type(group_type) :: description

description = inquire_group(atmosphere, inq_dims=.true., inq_atts=.true., &
  & inq_vars=.true., inq_grps=.true., recursive=.true.)
```

## Error operator

### `.exists.`

`.exists. error` is true exactly when `error%code /= NC_NOERR`. It is the
public, readable way to branch on an operation failure.

```fortran
if (.exists. error) then
  print '(a)', error%message
  error stop "NetCDF operation failed"
end if
```
