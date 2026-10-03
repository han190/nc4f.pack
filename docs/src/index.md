# NC4F

`NC4F` is a modern Fortran interface to the NetCDF C library. It provides a
small in-memory model for NetCDF dimensions, attributes, variables, and groups.
The library calls the NetCDF C API directly, thus the NetCDF Fortran library is
not required.

## What NC4F Can Do

The main purpose of this library is to experiment the feasibility of
an [xarray](https://xarray.dev/)-like programming style in modern Fortran that write and read through some unified functions. For example:

- Build a [NetCDF data model](https://docs.unidata.ucar.edu/netcdf-c/4.10.0/netcdf_data_model.html) with `DATARRAY` and `DATASET`;
- Write a data model to a NetCDF file with `TO_NETCDF`;
- Open a NetCDF file and retrieve variables with `OPEN_NETCDF` and `GET_VARIABLE`;
- Extract intrinsic Fortran data from an attribute or variable with `EXTRACT`;

## A First Program

Here is a taste of how you can use this library:

```fortran
program main

use, non_intrinsic :: nc4f
implicit none (type, external)

real, parameter :: temperature(3) = [289.4, 290.1, 288.7]
real, pointer :: temperature_vals(:)
type(netcdf_type) :: nc
type(variable_type) :: temperature_write, temperature_read

temperature_write = datarray( &
  & "temperature", temperature, dims=["station".dim.3], &
  & atts=["units".att."K", "long_name".att."Near-surface air temperature"])
call to_netcdf("temperature.nc", temperature_write)

nc = open_netcdf("temperature.nc", "r")
temperature_read = get_variable(nc, "temperature")
call close_netcdf(nc)
call extract(temperature_read, temperature_vals)

print *, temperature_read
print *, temperature_vals

end program main
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

## Documentation

```{toctree}
:caption: Get Started
:maxdepth: 1

get-started/build-installation
get-started/examples
```

```{toctree}
:caption: API Reference
:maxdepth: 1

reference/types
reference/exposed-nc-constants
reference/functions-and-subroutines
reference/operators
reference/derived-type-io
```

```{toctree}
:caption: Project
:maxdepth: 1

license
```
