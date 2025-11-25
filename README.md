# netcdf.pack
Fortran NetCDF package

## Quickstart
### Write to NetCDF4
Write to a NetCDF4 file:
```simple_wr.f90
program main

use, non_intrinsic :: module_netcdf
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
Read from a NetCDF4 file:
```simple_rd.f90
program main

use, non_intrinsic :: module_netcdf
implicit none (type, external)

type(netcdf_type) :: nc
type(variable_type) :: var
real, pointer :: vals(:, :)

nc = open_dataset("simple_wr.nc", "r")
var = get_variable(nc, "data")
call extract(var, vals)

end program main
```

### A slightly more advanced example
While this library provides generic `extract` that can extract the actual
values from `variable_type` and `attribute_type`, it is inconvinient and
counter-intuitive to `call extract(var, vals)` everytime you want to do some
calculations from the data you read. Thus, this library provides simple functions and operators like `sum` and `+`. For example, if one would like to compute temperature from a [WRF](https://github.com/wrf-model/WRF) output file. There are four steps:
1. Load data from a WRF output file, which is a netcdf file.
2. Extract pressure and perturbed pressure from the "wrfout" file, add them
   together to compute model pressure ($P_\text{tot} = P + \tilde{P}$).
3. Extract perturbed temperature (a constant $\theta_0=300$) and add base
   temperature to get potential temperature ($\theta = \theta_0 + \tilde{\theta}$).
4. Convert potential temperature to temperature through $T = \theta [(p/p_0)^{R/C_p}]$.

With this library, you can do this very intuitively,
```advanced.f90
program main

use, non_intrinsic :: module_netcdf
implicit none (type, external)

real, parameter :: T0 = 300.0, R = 287.0, CP = 1004.0, P0 = 1000.0 * 100
type(netcdf_type) :: nc
type(variable_type) :: P, THETA, T

nc = open_dataset("wrfout_d01_2000-01-01_00_00_00", "r")
P = sum(get_variable(nc, [character(len=2) :: "P", "PB"]))
THETA = get_variable(nc, "T") + T0
T = THETA*(P/P0)**(R/CP)
print *, T

end program main
```
Note that the function `get_variable` is `impure elemental`, so you can read multiple variables at once. The `sum` function will aggregate all variables together. 

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
