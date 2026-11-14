# NC4F

`NC4F` is a modern Fortran interface to the NetCDF C library. It provides a
small in-memory model for NetCDF dimensions, attributes, variables, and groups.
The library calls the NetCDF C API directly, thus the NetCDF Fortran library is
not required.

## A First Program

Here is a taste of what this library can do.

Write data to a netcdf file

```fortran
program main

  use :: nc4f
  implicit none

  real, parameter :: vals(3) = [289.4, 290.1, 288.7]
  type(variable_type) :: T

  T = datarray("T", vals, dims=["station".dim.3], &
    & atts=["units".att."K", "long_name".att."Air temperature"])
  call to_netcdf("temperature.nc", T)

end program main
```

Read data from a netcdf file
```fortran
program main

  use :: nc4f
  implicit none

  type(netcdf_type) :: nc
  type(variable_type) :: T

  nc = open_netcdf("temperature.nc", "r")
  T = get_variable(nc, "T")
  call closed_netcdf(nc)
  print *, T

end program main
```

## What NC4F Can Do

NC4F provides a small in-memory data model and experiments with an
[xarray](https://xarray.dev/)-like style for Fortran. Today it can:

- Construct dimensions, attributes, variables, and groups with `DATARRAY`,
  `DATASET`, and the `.dim.` and `.att.` operators;
- Write variables and groups with `TO_NETCDF`, or define a variable's schema
  with `DEFINE_VARIABLE` and write its values with `PUT_VARIABLE`;
- Open files with `OPEN_NETCDF`, read variables with `GET_VARIABLE`, and
  extract Fortran values with `EXTRACT`; diskless open modes are available;
- Read selected hyperslabs and write contiguous or strided selections;
- Round-trip complete numeric coordinate arrays through CF coordinate
  variables and an ordered `coordinates` attribute;
- Set NetCDF-4 chunking, compression, checksums, byte order, and fill values
  through `SET_STORAGE`;
- Rename attributes, dimensions, variables, and groups, and delete attributes
  in memory or explicitly in an open file.

## What NC4F Cannot Do

NC4F is not intended as a replacement for the established
[NetCDF Fortran library](https://docs.unidata.ucar.edu/netcdf-fortran/current/)
or wrappers such as [nc4fortran](https://github.com/geospace-code/nc4fortran)
and [neasy-f](https://github.com/PlasmaFAIR/neasy-f). Here are the limitations
of NC4F.

### NetCDF wrapper

The high-level I/O interface does not currently support:

- Parallel I/O or importing and exporting caller-owned in-memory file images;
- Creating classic NetCDF files, or reading and writing user-defined types,
  NetCDF `STRING` values, and unsigned primitive types;
- Mapped or multi-slab I/O, or deleting dimensions, variables, and groups
  from existing files;
- Coordinate-aware hyperslab reads or updates to existing coordinate-bearing
  variables.

### In-memory data model

The in-memory model does not currently provide built-in arithmetic,
mathematical expressions, automatic coordinate alignment, dimension
reordering, or unit conversion. Use `EXTRACT` to access typed Fortran arrays
for calculations, then `DATARRAY` to construct a result variable. File-backed
or distributed calculations are also not available.

The former expression implementation, tests, benchmark, and example are
preserved in `backup/expression/` for future investigation.

See [ROADMAP.md](ROADMAP.md) for planned extensions.

## Build and Installation

NC4F requires a modern Fortran compiler, the NetCDF C library,
and `pkg-config`.

### Build and test with fpm

From a checkout of this repository, build and run the test suite with:

```sh
fpm test --profile debug --flag "$(pkg-config --cflags --libs netcdf)"
```

Generated NetCDF test artifacts are written to `build/test-results/`.

### MacOS + Homebrew

If you use macos and homebrew there is a customized profile for fpm:

```sh
fpm test --profile macos-homebrew
```

### Build and test with CMake

CMake 3.24 or newer, a C compiler, and a supported Fortran compiler are required.
The default build uses the tracked generated sources; fypp is optional.

```sh
cmake -S . -B build/cmake -DCMAKE_Fortran_COMPILER=gfortran -DCMAKE_BUILD_TYPE=Release
cmake --build build/cmake --parallel
./scripts/download_test_data.sh
ctest --test-dir build/cmake --output-on-failure
```

Build the standalone C bindings with `--target nc4f_c_interface`. For installation,
examples, template regeneration, and downstream CMake usage, see
[Build and Installation](docs/src/get-started/build-installation.md#build-with-cmake).

### Use NC4F as an fpm dependency

Add `nc4f` to the consuming package's `fpm.toml`, then link the NetCDF C
library in that package:

```toml
[dependencies]
nc4f = { git = "https://github.com/han190/nc4f.pack.git" }

[build]
link = ["netcdf"]
```
