# NC4F

`NC4F` is a modern Fortran interface to the NetCDF C library. It provides a
small in-memory model for NetCDF dimensions, attributes, variables, and groups.
The library calls the NetCDF C API directly, thus the NetCDF Fortran library is
not required.

## What NC4F Can Do

The main purpose of this library is to experiment the feasibility of
an [xarray](https://xarray.dev/)-like programming style in modern Fortran that:

- provide constructors such as `DATARRAY` and `DATASET` to conveniently form
  the data structures required for NetCDF variables and groups;
  ```
  type(variable_type) :: da
  real, allocatable :: values(:,:)
  da = datarray("temp", values, &
    & dims=["latitude".dim.721,"longitude".dim.1440], &
    & atts=["units".att."K","long_name".att."Temperature in Kelvin"])
  ```
- output these data structures through `TO_NETCDF`;
  ```
  type(variable_type) :: da
  call to_netcdf("output.nc", da)
  ```
- read NetCDF files with `OPEN_NETCDF` and `GET_VARIABLE`;
  ```
  type(netcdf_type) :: nc
  type(variable_type) :: var
  nc = open_netcdf("input.nc", "r")
  var = get_variable(nc, "var_name")
  ```
- extract intrinsic Fortran data structures from these models through `EXTRACT`;
  ```
  type(variable_type) :: var
  real, pointer :: vals(:,:)
  call extract(var, vars)
  ```
- additionally, this library implements user-defined derived-type I/O procedures
  that allow users to output NetCDF metadata in a format similar to `ncdump -h`.
  ```
  type(netcdf_type) :: nc
  nc = open_netcdf("input.nc", "r")
  print *, nc
  ```

## What NC4F Cannot Do

NC4F is not intended to replace the well-established [NetCDF Fortran library](https://docs.unidata.ucar.edu/netcdf-fortran/current/) or wrappers such as [nc4fortran](https://github.com/geospace-code/nc4fortran) and
[neasy-f](https://github.com/PlasmaFAIR/neasy-f). NC4F is intentionally designed to focus on a small subset of the NetCDF data
model. It does NOT currently support:

- classic NetCDF format;
- user-defined types, the NetCDF `STRING` type and unsigned primitive types;
- NetCDF-4 storage controls, such as chunking, compression,
  shuffle/checksum filters, endianness, and custom fill values;
- parallel, in-memory, or diskless I/O;
- advanced variable access, such as mapped or multi-slab I/O and strided writes;
  or metadata mutation operations, such as renaming or deleting dimensions,
  variables, groups, and attributes.

## Build and Installation

NC4F requires a modern Fortran compiler, the NetCDF C library,
and `pkg-config`.

### Build and test with fpm

From a checkout of this repository, build and run the test suite with:

```sh
fpm test --profile debug --flag "$(pkg-config --cflags --libs netcdf)"
```

Generated NetCDF test artifacts are written to `build/test-results/`.

### Use NC4F as an fpm dependency

Add `nc4f` to the consuming package's `fpm.toml`, then link the NetCDF C
library in that package:

```toml
[dependencies]
nc4f = { git = "https://github.com/han190/nc4f.pack.git" }

[build]
link = ["netcdf"]
```

## Simple Examples

### Write a NetCDF file

Create a variable from a Fortran array, then write it as a new file:

```fortran
program main
  use, non_intrinsic :: nc4f
  implicit none (type, external)

  real :: values(3) = [1.0, 2.0, 3.0]
  type(variable_type) :: temp

  temp = datarray("temperature", values, ["time".dim.3])
  call to_netcdf("example.nc", temp)
end program main
```

### Read a NetCDF file

Open a file, materialize a variable, extract a typed pointer, and close the
file when it is no longer needed:

```fortran
program main
  use, non_intrinsic :: nc4f
  implicit none (type, external)

  type(netcdf_type) :: nc
  type(variable_type) :: temp
  real, pointer :: values(:)

  nc = open_netcdf("example.nc", "r")
  temp = get_variable(nc, "temperature")
  call extract(temp, values)
  call close_netcdf(nc)
end program main
```
