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
var = get_variable(nc, "data")
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
