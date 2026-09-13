# Inspect a Grouped File and Edit Metadata

Traverse a direct child group, materialize a recursive metadata description,
inspect dimensions and attributes, then write updated attributes to the file.

```fortran
type(netcdf_type) :: nc
type(group_type) :: atmosphere, description
type(variable_type) :: temperature
type(attribute_type) :: title, units
type(dimension_type), allocatable :: dims(:), variable_dims(:)

nc = open_dataset("grouped.nc", "a")
atmosphere = get_group(nc, "atmosphere")
description = inquire_group(atmosphere, inq_dims=.true., inq_atts=.true., &
  & inq_vars=.true., inq_grps=.true., recursive=.true.)
dims = inquire_dimensions(atmosphere)
temperature = inquire_variable(atmosphere, "temperature")
variable_dims = inquire_dimensions(atmosphere, temperature)
title = get_attribute(nc, "title")
units = get_attribute(atmosphere, temperature, "units")
temperature%atts = ["long_name".att."Air temperature"]
nc%atts = ["history".att."updated by nc4f"]
call put_attribute(atmosphere, temperature)
call put_attribute(nc)
call close_dataset(nc)
```
