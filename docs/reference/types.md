# Types

The public `nc4f` façade exposes these data-model types.

## `error_type`

Returned through optional `error=` arguments. `code` is a NetCDF status;
`message` is an allocatable diagnostic for failures. Use `.exists. error` to
test whether `code` is not `NC_NOERR`.

## `dimension_type`

Describes a NetCDF dimension: `id`, `name`, current `len`, and the `is_unlim`
flag.

```fortran
type(dimension_type) :: longitude
longitude = "longitude".dim.360
```

## `attribute_type`

Describes a global or variable attribute: `id`, `name`, external `dtype`,
element `len`, and a pointer-backed byte `buffer`. Prefer `extract` to access
the values.

```fortran
type(attribute_type) :: units
units = "units".att."K"
```

## `variable_type`

Describes a NetCDF variable and, when materialized, its values. Its public
components are `id`, `name`, `dtype`, `len`, allocatable `dims` and `atts`,
and a pointer-backed byte `buffer`.

## `group_type`

Describes a NetCDF group. `dims`, `atts`, and `vars` are local collections;
`grps` is a pointer-backed array of direct children. A child may use
dimensions inherited from an ancestor without declaring them locally.

## `netcdf_type`

Extends `group_type` for an open file with the `filename` and `mode`
components.

```fortran
type(netcdf_type) :: nc
nc = open_dataset("input.nc", "r")
call close_dataset(nc)
```
