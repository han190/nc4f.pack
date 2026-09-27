# NC4F

`NC4F` is a modern Fortran interface to the NetCDF C library. It provides a
small in-memory model for NetCDF dimensions, attributes, variables, and groups. 
The library calls the NetCDF C API directly, thus the NetCDF
Fortran library is not required.

This repository is not intended to replace the NetCDF Fortran library or
well-established wrappers such as [nc4fortran](https://github.com/geospace-code/nc4fortran)
and [neasy-f](https://github.com/PlasmaFAIR/neasy-f). Instead, it experiments with an 
[xarray](https://xarray.dev/)-like programming style in modern Fortran that:

- provide constructors such as [DATARRAY](reference/functions-and-subroutines.md#datarray-construct-a-variable) and [DATASET](reference/functions-and-subroutines.md#dataset-construct-a-group) to conveniently form
  the data structures required for NetCDF variables and groups, along with
  dimensions and attributes;
- output these data structures through the unified `TO_NETCDF` pipeline;
- read NetCDF files with `OPEN_NETCDF` and `GET_VARIABLE`;
- extract intrinsic Fortran data structures from these models through the
  unified `EXTRACT` interface.

Additionally, this library implements user-defined derived-type I/O procedures
that allow users to output NetCDF metadata in a format similar to `ncdump -h`.

Give it a try if you are interested!

```{toctree}
:caption: Get Started
:maxdepth: 1

get-started/build-installation
get-started/first-program
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
