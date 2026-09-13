# nc4f

`nc4f` is a modern Fortran interface to the NetCDF C library. It provides a
small in-memory model for NetCDF dimensions, attributes, variables, groups,
and open files, plus routines to read, write, inspect, and compose datasets.
The library calls the NetCDF C API directly; the NetCDF Fortran library is not
required.

## Install and build

`nc4f` is an [fpm](https://fpm.fortran-lang.org/) package. NetCDF C headers
and libraries must be available through `pkg-config`.

```sh
fpm test --profile debug --flag "$(pkg-config --cflags --libs netcdf)"
```

To build this documentation site locally:

```sh
python -m pip install -r requirements-docs.txt
mkdocs serve
```

## A first program

This program constructs a variable and writes it to a new NetCDF-4 file.

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

To read it back, open the file, obtain the variable, extract a typed pointer,
and close the file.

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

## Core ideas

- `dimension_type`, `attribute_type`, `variable_type`, and `group_type`
  describe NetCDF objects. `netcdf_type` extends `group_type` with the open
  file name and mode.
- `datarray` turns a typed Fortran array into a `variable_type`; `dataset`
  assembles variables and child groups into a `group_type`.
- `get_variable` materializes variable values. `inquire_variable` obtains
  metadata only. Equivalent group and attribute APIs follow the same pattern.
- `extract` maps an attribute or variable buffer to a typed Fortran pointer.
  The pointer is valid only while its source object and its backing storage
  remain valid.

## Copying and lifetime

By default, `datarray` performs a deep copy of numeric input values. Set
`deep=.false.` only for a contiguous `target` array whose lifetime is known to
outlast every use of the returned variable. Character `datarray` values always
use a deep copy.

`dataset` defaults to `deep=.false.`: it shares variable buffers and child
group trees, while copying group-level metadata. Use `deep=.true.` to clone
buffers and descendants. Intrinsic assignment of `attribute_type` and
`variable_type` also shares their pointer-backed buffers; assignment of
`group_type` shares its pointer-backed children. Treat source storage as
owned by an enclosing allocatable or another object with an adequate lifetime.

## Errors

Routines with an optional `error` argument return normally and set it when an
operation fails. When that argument is omitted, the library follows its
fail-fast policy. Test an error result with `.exists.`:

```fortran
type(error_type) :: error

nc = open_dataset("missing.nc", "r", error=error)
if (.exists. error) print *, error%message
```

See the [API reference](api.md) for every public item exported by `use nc4f`.
