program main

use :: module_netcdf
implicit none

integer, parameter :: nx = 47, ny = 83
real :: values(nx, ny)
integer :: x, y
type(variable_type) :: var

!> Dummy data.
do concurrent(y=1:ny, x=1:nx)
  values(x, y) = sqrt(real((x - nx/2)**2 + (y - ny/2)**2))
end do
var = data_array("data", values, ["x".dim.nx, "y".dim.ny])
print "(dt)", var
call to_netcdf("test_wr.nc", var)

end program main
