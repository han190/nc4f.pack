# Files and Groups

## Open, close, and create files

`open_netcdf(filename [, mode] [, err])` returns
a `netcdf_type`. Modes are `"r"` (default, read-only), `"w"` (recreate), and
`"a"` (read/write). `close_netcdf(nc [, err])` releases the open handle.

`to_netcdf` creates a new file from a variable, variable array, group, or
group array:

```fortran
call to_netcdf(filename, var [, atts] [, err])
call to_netcdf(filename, vars [, atts] [, err])
call to_netcdf(filename, grp [, atts] [, err])
call to_netcdf(filename, grps [, atts] [, err])
```

## Dimensions and variables

`inquire_dimensions(nc [, var] [, err])` returns local group dimensions or
the dimensions attached to `var`.

`get_variable(nc, name [, start, count] [, err])` materializes values and
metadata. The hyperslab form uses one-based `start` indices and Fortran-order
edge lengths. `inquire_variable(nc, name [, err])` returns metadata only.
`put_variable(nc, var [, start, count] [, err])` writes a materialized
variable or hyperslab.

## Attributes

`get_attribute` reads one or all global or variable attributes:

```fortran
att  = get_attribute(nc, name [, err])
atts = get_attribute(nc [, err])
att  = get_attribute(nc, var, name [, err])
atts = get_attribute(nc, var [, err])
```

`put_attribute(nc [, var] [, err])` writes `nc%atts` or `var%atts`.

## Groups

`get_group(parent, name [, err])` returns a direct child. `inquire_subgroups`
returns direct child handles. `inquire_group` materializes selected local
metadata in place. Dimensions, attributes, variables, and direct subgroups
are materialized by default; recursive descent remains opt-in:

```fortran
call inquire_group(group, recursive=.true.)

call inquire_group(nc)
```
