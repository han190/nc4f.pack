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

`get_variable(nc, name [, start] [, count] [, stride] [, err])` materializes
values and metadata. Hyperslab indices are one-based and in Fortran dimension
order. Supplying `start` alone reads from each start index to the end;
supplying `start` and `count` uses unit strides. A selected result's dimensions
are its materialized `count` values.
`inquire_variable(nc, name [, err])` returns metadata only.

## Attributes

`get_attribute` reads one or all global or variable attributes:

```fortran
att  = get_attribute(nc, name [, err])
atts = get_attribute(nc [, err])
att  = get_attribute(nc, var, name [, err])
atts = get_attribute(nc, var [, err])
```

## Groups

`get_group(parent, name [, err])` returns a direct child. `inquire_subgroups`
returns direct child handles. `inquire_group` materializes selected local
metadata in place. Dimensions, attributes, variables, and direct subgroups
are materialized by default; recursive descent remains opt-in:

```fortran
call inquire_group(group, recursive=.true.)

call inquire_group(nc)
```
