# netcdf.pack
Fortran NetCDF package

## Quickstart
### Write to NetCDF4
```Fortran
program main
use, non_intrinsic :: module_netcdf
implicit none (type, external)

type(variable_type) :: var
integer, parameter :: nx = 47, ny = 83
real :: values(nx, ny)
integer :: x, y

do concurrent(y=1:ny, x=1:nx)
  values(x, y) = sqrt((x - 0.5*nx)**2 + (y - 0.5*ny)**2)
end do
var = data_array("data", values, ["x".dim.nx, "y".dim.ny])
call to_netcdf("simple_wr.nc", var)
end program main
```
### Read from NetCDF4
```Fortran
program main
use, non_intrinsic :: module_netcdf
implicit none (type, external)

type(netcdf_type) :: nc
type(variable_type) :: var

nc = open_dataset("simple_wr.nc", "r")
var = get_var(nc, "data")
end program main
```

### A slightly more advanced example
This library provides simple functions and operators like `sum` and `+`. For example, if one would like to compute temperature from a [WRF](https://github.com/wrf-model/WRF) output file. There are four steps:
1. Load file with "read" mode.
2. Extract pressure and perturbed pressure from the "wrfout" file, add them together to compute model pressure.
3. Extract perturbed temperature (a constant $T_0=300$) and add base temperature to get potential temperature.
4. Convert potential temperature to temperature through $T = \theta [(p/p_0)^{R/C_p}]$.

With this library, you can do this very intuitively,
```Fortran
program main
use, non_intrinsic :: module_netcdf
implicit none (type, external)

real, parameter :: T0 = 300.0, R = 287.0, Cp = 1004.0
integer, parameter :: p0 = 1000 * 100 ! Pa
type(netcdf_type) :: nc
type(variable_type) :: p, T

nc = open_dataset("wrfout_d01_2000-01-01_00_00_00", "r") ! Simple APIs.
p = sum(get_var(nc, [character(len=2) :: "P", "PB"])) ! Get variable and preprocess.
T = get_var(nc, "T") + T0 ! Works with multiple types.
T = T*(p/p0)**(R/Cp) ! Works with multiple operators.
print *, T ! Supports UDDTIO

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
