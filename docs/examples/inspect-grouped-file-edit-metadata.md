# Inspect a Grouped File's Metadata

Traverse a direct child group, materialize a recursive metadata description,
and inspect dimensions and attributes.

```fortran
type(netcdf_type) :: nc
type(group_type) :: atmosphere
type(variable_type) :: temperature
type(attribute_type) :: title, units
type(dimension_type), allocatable :: dims(:), variable_dims(:)

nc = open_netcdf("grouped.nc", "r")
atmosphere = get_group(nc, "atmosphere")
call inquire_group(atmosphere, inq_dims=.true., inq_atts=.true., &
  & inq_vars=.true., inq_subgrps=.true., recursive=.true.)
dims = inquire_dimensions(atmosphere)
temperature = inquire_variable(atmosphere, "temperature")
variable_dims = inquire_dimensions(atmosphere, temperature)
title = get_attribute(nc, "title")
units = get_attribute(atmosphere, temperature, "units")
call close_netcdf(nc)
```
