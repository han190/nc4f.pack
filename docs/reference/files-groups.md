# Files and Groups

## Open, close, and create files

`open_dataset(filename [, mode] [, inq_dims] [, inq_atts] [, error])` returns
a `netcdf_type`. Modes are `"r"` (default, read-only), `"w"` (recreate), and
`"a"` (read/write). `close_dataset(nc [, error])` releases the open handle.

`to_netcdf` creates a new file from a variable, variable array, group, or
group array:

```fortran
call to_netcdf(filename, var [, atts] [, error])
call to_netcdf(filename, vars [, atts] [, error])
call to_netcdf(filename, grp [, atts] [, error])
call to_netcdf(filename, grps [, atts] [, error])
```

## Dimensions and variables

`inquire_dimensions(nc [, var] [, error])` returns local group dimensions or
the dimensions attached to `var`.

`get_variable(nc, name [, start, count] [, error])` materializes values and
metadata. The hyperslab form uses one-based `start` indices and Fortran-order
edge lengths. `inquire_variable(nc, name [, error])` returns metadata only.
`put_variable(nc, var [, start, count] [, error])` writes a materialized
variable or hyperslab.

## Attributes

`get_attribute` reads one or all global or variable attributes:

```fortran
att  = get_attribute(nc, name [, error])
atts = get_attribute(nc [, error])
att  = get_attribute(nc, var, name [, error])
atts = get_attribute(nc, var [, error])
```

`put_attribute(nc [, var] [, error])` writes `nc%atts` or `var%atts`.

## Groups

`get_group(parent, name [, error])` returns a direct child. `inquire_groups`
returns direct child handles. `inquire_group` materializes selected local
metadata and can recurse through descendants:

```fortran
description = inquire_group(group, inq_dims=.true., inq_atts=.true., &
  & inq_vars=.true., inq_grps=.true., recursive=.true.)
```
