# Read, Inspect, Compute, and Write

Open a file for modification, read compatible variables, calculate their sum,
and use a mold to initialize writable output with matching metadata.

```fortran
type(netcdf_type) :: nc
type(variable_type) :: inputs(2), total, output
real, pointer :: total_values(:), output_values(:)

nc = open_netcdf("input.nc", "a")
inputs = get_variable(nc, [character(len=2) :: "P", "PB"])
total = sum(inputs)
call initialize(output, mold=total)
output%name = "mean_pressure"
call extract(total, total_values)
call extract(output, output_values)
output_values = 0.5 * total_values
print *, shape(output), size(output)
call put_variable(nc, output)
call close_netcdf(nc)
```
