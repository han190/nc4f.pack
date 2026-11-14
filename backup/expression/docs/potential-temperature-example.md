## Potential temperature on a latitude-longitude grid

This example writes synthetic temperature, pressure, and coordinate variables
to `potential_temperature.nc`. It reopens the file, reads both fields, computes
potential temperature with a deferred expression, and appends the result.
The constant reference pressure divides directly by the pressure variable.
The coordinate units and standard names follow the
[CF Conventions](https://cfconventions.org/cf-conventions/cf-conventions.html).

```{literalinclude} ../../../example/potential_temperature.f90
:language: fortran
```
