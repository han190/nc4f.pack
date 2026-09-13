# A First Program

All examples import the public `nc4f` façade:

```fortran
use, non_intrinsic :: nc4f
implicit none (type, external)
```

## Write a NetCDF file

Create a variable from a Fortran array, then write it as a new file:

```fortran
program write_example
  use, non_intrinsic :: nc4f
  implicit none (type, external)

  real :: values(3) = [1.0, 2.0, 3.0]
  type(variable_type) :: temperature

  temperature = datarray("temperature", values, ["time".dim.3])
  call to_netcdf("example.nc", temperature)
end program write_example
```

## Read a NetCDF file

Open a file, materialize a variable, extract a typed pointer, and close the
file when it is no longer needed:

```fortran
program read_example
  use, non_intrinsic :: nc4f
  implicit none (type, external)

  type(netcdf_type) :: nc
  type(variable_type) :: temperature
  real, pointer :: values(:)

  nc = open_dataset("example.nc", "r")
  temperature = get_variable(nc, "temperature")
  call extract(temperature, values)
  call close_dataset(nc)
end program read_example
```

## A slightly more advanced example

This pattern computes temperature from WRF pressure and potential-temperature
fields, then writes the result. `get_variable` is impure elemental for whole
variables, so the two pressure terms can be materialized in one call.

```fortran
program main
  real, parameter :: R = 287.0, Cp = 1004.0 ! Gas constant and specific heat
  real, parameter :: theta0 = 300.0 ! Base potential temperature
  real, parameter :: p0 = 1000 * 100.0 ! hPa -> Pa

  type(netcdf_type) :: nc
  type(variable_type) :: inputs(2), output
  !> A WRF output variable is usually 4-dimensional
  real, dimension(:, :, :, :), pointer :: p, theta, T

  !> Open a WRF output file and extract variables.
  nc = open_dataset("wrfout.nc", "r")
  inputs = [sum(get_variable(nc, [character(len=2) :: "P", "PB"])), &
    & get_variable(nc, "T")]

  !> Extract values of variable_type variables
  call extract(inputs(1), p)
  call extract(inputs(2), theta)

  !> Allocate the output like an input variable
  call initialize(output, mold=inputs(1))
  call extract(output, T)

  !> Calculate temperature in Kelvin
  T = (theta + theta0) * (p / p0) ** (R / Cp)

  !> Save the variable to a new file.
  call to_netcdf("output.nc", output)
  call close_dataset(nc)
end program main
```
