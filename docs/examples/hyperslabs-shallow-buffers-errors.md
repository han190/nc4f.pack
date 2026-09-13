# Hyperslabs, Shallow Buffers, and Recoverable Errors

Read a hyperslab using one-based indices, replace it with a shallow view over
a named `target` array, and write it back. An `error=` argument keeps failure
handling recoverable. Keep `values` alive until all uses of `slab` complete.

```fortran
type(netcdf_type) :: nc
type(error_type) :: error
type(variable_type) :: slab
real, target :: values(10)

nc = open_dataset("input.nc", "a", error=error)
if (.exists. error) error stop error%message
slab = get_variable(nc, "temperature", start=[1], count=[10], error=error)
if (.exists. error) error stop error%message
values = 273.15
slab = datarray("temperature", values, ["time".dim.10], deep=.false.)
call put_variable(nc, slab, start=[1], count=[10], error=error)
if (.exists. error) error stop error%message
call close_dataset(nc, error)
```
