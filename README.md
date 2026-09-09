# nc4f
A Fortran NetCDF4 library.

## Build and test

`nc4f` calls the NetCDF C API directly. With `fpm` and `pkg-config`, build
and run the test suite with:

```sh
fpm test --profile debug --flag "$(pkg-config --cflags --libs netcdf)"
```

Generated NetCDF test artifacts are written to `build/test-results/`.

## Quickstart
### Write to NetCDF4
Write to a NetCDF-4 file:
```simple_wr.f90
program main

  use, non_intrinsic :: nc4f
  implicit none (type, external)

  type(variable_type) :: var
  integer, parameter :: nx = 47, ny = 83
  real :: values(nx, ny)
  integer :: x, y

  !> Dummy data.
  do concurrent(y=1:ny, x=1:nx)
    values(x, y) = sqrt((x - 0.5*nx)**2 + (y - 0.5*ny)**2)
  end do

  !> Create a data array and write it to netcdf.
  var = data_array("data", values, ["x".dim.nx, "y".dim.ny])
  call to_netcdf("simple_wr.nc", var)
  
end program main
```
### Read from NetCDF4
Read from a NetCDF-4 file:
```simple_rd.f90
program main

  use, non_intrinsic :: nc4f
  implicit none (type, external)

  type(netcdf_type) :: nc
  type(variable_type) :: var
  real, pointer :: vals(:, :)

  nc = open_dataset("simple_wr.nc", "r")
  var = get_variable(nc, "data")
  call extract(var, vals)

end program main
```

Read a contiguous subset by supplying one-based `start` indices and `count`
edge lengths in Fortran (column-major) dimension order:

```fortran
var = get_variable(nc, "data", start=[4, 6], count=[3, 2])
```

The resulting `variable_type` is a materialized array with shape `[3, 2]`;
its dimensions describe the selected data rather than the source variable.

## Error handling

Calls without `error=` retain their fail-fast behavior. Pass an `error_type`
to handle a NetCDF failure in the calling program instead. A successful call
resets its error to `NC_NOERR`. `found` is false for absent files, variables,
attributes, and dimensions, while `failed` recognizes every failure.

```fortran
type(error_type) :: error
type(netcdf_type) :: nc
type(variable_type) :: var

nc = open_dataset("input.nc", "r", error=error)
if (failed(error)) then
  print *, error
  return
end if

var = get_variable(nc, "optional_name", error=error)
if (.not. found(error)) then
  ! Optional variable is absent.
else if (failed(error)) then
  print *, error
  return
end if
```

`print *, error` uses defined formatted I/O. `error%code` preserves the
underlying NetCDF status, and `error%message` carries the diagnostic. The
whole-variable `error=` overload is scalar; the existing elemental
`get_variable(nc, names)` form remains fail-fast. Iterate when individual
array elements need recoverable errors.

### A slightly more advanced example
Let’s walk through a classic workflow: computing temperature (K) from a [WRF](https://github.com/wrf-model/WRF) output file.
1. Load data from a WRF output file, which is a netcdf file.
2. Extract 4D (west-east, south-north, bottom-top, time) base pressure and perturbation pressure and then add them element-wise to obtain model pressure ($p = p_0 + \tilde{p}$).
3. Extract 4D perturbation potential temperature and add the base potential temperature (a constant $\theta_0=300$) to get potential temperature ($\theta = \theta_0 + \tilde{\theta}$).
4. Convert potential temperature to temperature through $T = \theta [(p/p_0)^{R/C_p}]$.
5. Save the output to a new netcdf file.

This library provides generic subroutine `extract` which allows you to extract
values (as pointers) from a `variable_type` or an `attribute_type`. The
whole-variable `get_variable(nc, name)` overload is _impure elemental_,
meaning you can load multiple variables into an array of `variable_type` in a
single call. The hyperslab overload accepts scalar `nc` and `name` arguments
plus `start` and `count` vectors.
```advanced.f90
program main

  use, non_intrinsic :: nc4f
  implicit none (type, external)

  !> Constants.
  real, parameter :: R = 287.0, CP = 1004.0
  real, parameter :: THETA0 = 300.0, P0 = 1000.0 * 100

  !> nc4f derived types.
  type(netcdf_type) :: nc
  type(variable_type) :: vars(2), output

  !> Pointers that points to the actual values.
  real, dimension(:), pointer :: P, THETA, T

  !> Open a NetCDF4 file.
  nc = open_dataset("wrfout_d01_2000-01-01_00_00_00", "r")
  !> Use impure elemental function `get_variable` to load all
  !> you want with a one-liner.
  vars(1) = sum(get_variable(nc, [character(len=2) :: "P", "PB"]))
  vars(2) = get_variable(nc, "T")

  !> Extract values from variables.
  call extract(vars(1), P)
  call extract(vars(2), THETA)

  !> Allocate output variable.
  call allocate_memory(output, mold=vars(1))
  call extract(output, T)

  !> Computation.
  T = (THETA + THETA0)*(P/P0)**(R/CP)
  !> Save the variable output to a new NetCDF4 file.
  call to_netcdf("output.nc", output)

end program main
```
## Currently supported types
| Data type       | Attribute | Variable  |
|:----------------|:---------:|:---------:|
| CHAR            | &#x2611;  |           |
| BYTE            | &#x2611;  | &#x2611;  |
| SHORT           | &#x2611;  | &#x2611;  |
| INT             | &#x2611;  | &#x2611;  |
| INT64           | &#x2611;  | &#x2611;  |
| FLOAT           | &#x2611;  | &#x2611;  |
| DOUBLE          | &#x2611;  | &#x2611;  |
| UNSIGNED BYTE   |           |           |
| UNSINGED SHORT  |           |           |
| UNSIGNED INT    |           |           |
| UNSIGNED INT64  |           |           |
| STRING          |           |           |

## TODOs
- [ ] `group_type` and `data_set`.
- [ ] Support `CHAR` type variable.
- [ ] Support trig functions.
