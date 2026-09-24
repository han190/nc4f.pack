# nc4f

`nc4f` is a modern Fortran interface to the NetCDF C library.

For guides, examples, and API reference material, see the [documentation]().

## Build and Installation

`nc4f` requires a modern Fortran compiler, the NetCDF C headers and library,
and `pkg-config`. The NetCDF Fortran library is not required.

### Build and test with fpm

From a checkout of this repository, build and run the test suite with:

```sh
fpm test --profile debug --flag "$(pkg-config --cflags --libs netcdf)"
```

Generated NetCDF test artifacts are written to `build/test-results/`.

### Use nc4f as an fpm dependency

Add `nc4f` to the consuming package's `fpm.toml`, then link the NetCDF C
library in that package:

```toml
[dependencies]
nc4f = { git = "https://github.com/han190/nc4f.pack.git" }

[build]
link = ["netcdf"]
```

## Examples

All examples can be imported from the model `nc4f`

```fortran
use, non_intrinsic :: nc4f
implicit none (type, external)
```

### Write a NetCDF file

Create a variable from a Fortran array, then write it as a new file:

```fortran
program write_example

  use, non_intrinsic :: nc4f
  implicit none (type, external)

  real :: values(3) = [1.0, 2.0, 3.0]
  type(variable_type) :: temp

  temp = datarray("temperature", values, ["time".dim.3])
  call to_netcdf("example.nc", temp)

end program write_example
```

### Read a NetCDF file

Open a file, materialize a variable, extract a typed pointer, and close the
file when it is no longer needed:

```fortran
program read_example

  use, non_intrinsic :: nc4f
  implicit none (type, external)

  type(netcdf_type) :: nc
  type(variable_type) :: temp
  real, pointer :: values(:)

  nc = open_netcdf("example.nc", "r")
  temp = get_variable(nc, "temperature")
  call extract(temp, values)
  call close_netcdf(nc)

end program read_example
```

### A slightly more advanced example

This pattern computes temperature from WRF pressure and potential-temperature
fields, then writes the result. Each pressure term is materialized separately
and combined as a `variable_type` array.

```fortran
program main

  use, non_intrinsic: nc4f
  implicit none (type, external)

  real, parameter :: R = 287.0, Cp = 1004.0 ! Gas constant and specific heat
  real, parameter :: THETA0 = 300.0 ! Base potential temperature
  integer, parameter :: P0 = 1000 * 100 ! Base pressure (Pa)

  type(netcdf_type) :: nc
  type(variable_type) :: inputs(3), output
  real, dimension(:, :, :, :), pointer :: P, PB, THETA, T

  !> Open a WRF output file and get variables.
  nc = open_netcdf("wrfout.nc", "r")
  inputs(1) = get_variable(nc, "P")
  inputs(2) = get_variable(nc, "PB")
  inputs(3) = get_variable(nc, "T")

  !> Extract values of variable_type variables
  call extract(inputs(1), P)
  call extract(inputs(2), PB)
  call extract(inputs(3), THETA)

  !> Allocate the output like an input variable
  call initialize(output, "temperature", mold=inputs(1), &
    & atts=["units".att."K", "P0 (Pa)".att.P0, "THETA0 (K)".att.THETA0])
  call extract(output, T)

  !> Calculate temperature in Kelvin
  T = (THETA + THETA0) * ((P + PB) / P0) ** (R / Cp)

  !> Save the variable to a new file.
  call to_netcdf("output.nc", output)
  call close_netcdf(nc)

end program main
```
