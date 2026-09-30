# NC4F

`NC4F` is a modern Fortran interface to the NetCDF C library. It provides a
small in-memory model for NetCDF dimensions, attributes, variables, and groups.
The library calls the NetCDF C API directly, thus the NetCDF Fortran library is
not required.

## What NC4F Can Do

This repository is not intended to replace the NetCDF Fortran library or
well-established wrappers such as
[nc4fortran](https://github.com/geospace-code/nc4fortran) and
[neasy-f](https://github.com/PlasmaFAIR/neasy-f). Instead, it experiments with
an [xarray](https://xarray.dev/)-like programming style in modern Fortran that:

- provide constructors such as `DATARRAY` and `DATASET` to conveniently form
  the data structures required for NetCDF variables and groups, along with
  dimensions and attributes. For example,
  ```fortran
  type(variable_type) :: da
  real, allocatable :: values(:,:)
  da = datarray("geospatial_data", values, ["lat".dim.721,"lon".dim.1440])
  ```
- output these data structures through the unified `TO_NETCDF` pipeline;
  ```fortran
  type(variable_type) :: da
  call to_netcdf("output.nc", da)
  ```
- read NetCDF files with `OPEN_NETCDF` and `GET_VARIABLE`. For example,
  ```fortran
  type(netcdf_type) :: nc
  type(variable_type) :: var
  nc = open_netcdf("input.nc", "r")
  var = get_variable(nc, "var_name")
  ```
- extract intrinsic Fortran data structures from these models through the
  unified `EXTRACT` interface. For example,
  ```fortran
  type(variable_type) :: var
  real, pointer :: vals(:)
  call extract(var, vars)
  ```
- additionally, this library implements user-defined derived-type I/O procedures
  that allow users to output NetCDF metadata in a format similar to `ncdump -h`.
  For example,
  ```fortran
  type(variable_type) :: var
  real, allocatable :: values(:,:)
  da = datarray("geospatial_data", values, &
    & ["lat".dim.721,"lon".dim.1440], atts=["coordinates".att."lat lon"])
  print *, var
  ! float geospatial_data(lat, lon) ;
  !    char:coordinates = "lat lon" ;
  ```

## What NC4F Cannot Do

I began NC4F as a personal project, so NC4F is intentionally designed to focus on a small subset of the NetCDF data model. It does not currently support:

- user-defined types, the NetCDF `STRING` type and unsigned primitive types described in [data model](https://docs.unidata.ucar.edu/netcdf-c/4.10.0/netcdf_data_model.html);
- NetCDF-4 storage controls, including [chunking](https://docs.unidata.ucar.edu/nug/current/netcdf_perf_chunking.html), compression, shuffle/checksum filters, endianness, and custom fill values;
- parallel, in-memory, or diskless I/O;
- advanced variable access, such as mapped or multi-slab I/O and strided writes; or
- metadata mutation operations, such as renaming or deleting dimensions, variables, groups, and attributes.

Give it a try if you are interested!

## Build and Installation

`NC4F` requires a modern Fortran compiler, the NetCDF C headers and library,
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
