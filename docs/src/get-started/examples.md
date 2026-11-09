# Examples

The following runnable examples are available in the repository's `example/`
directory.

## Write a NetCDF file

This example creates a one-dimensional temperature variable and writes it to
`example.nc`.

```{literalinclude} ../../../example/write_netcdf.f90
:language: fortran
```

## Read a NetCDF file

After running the write example, this program opens `example.nc`, reads the
temperature variable, and extracts its values into a Fortran pointer.

```{literalinclude} ../../../example/read_netcdf.f90
:language: fortran
```

## Temperature read/write

This example writes station air temperatures with CF-style metadata, then
reopens the file and extracts the values into a Fortran pointer.

```{literalinclude} ../../../example/temperature.f90
:language: fortran
```

## Mandelbrot set

This example constructs a two-dimensional Mandelbrot iteration-count field and
writes it, along with coordinate variables and metadata, to a NetCDF file.

```{literalinclude} ../../../example/mandelbrot.f90
:language: fortran
```

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
