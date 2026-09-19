# Hyperslabs, Shallow Buffers, and Recoverable Errors

Read a hyperslab using one-based indices, replace it with a shallow view over
a named `target` array, and write it back. An `err=` argument keeps failure
handling recoverable. Keep `values` alive until all uses of `slab` complete.

```fortran
type(netcdf_type) :: nc
type(error_type) :: err
type(variable_type) :: slab
real, target :: values(10)

nc = open_netcdf("input.nc", "a", err=err)
if (.exists. err) error stop err%message
slab = get_variable(nc, "temperature", start=[1], count=[10], err=err)
if (.exists. err) error stop err%message
values = 273.15
slab = datarray("temperature", values, ["time".dim.10], deep=.false.)
call put_variable(nc, slab, start=[1], count=[10], err=err)
if (.exists. err) error stop err%message
call close_netcdf(nc, err)
```
