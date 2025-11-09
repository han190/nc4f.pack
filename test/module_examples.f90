module module_examples
use, non_intrinsic :: module_netcdf
implicit none (type, external)

contains

subroutine simple_wr(passed)
  logical, intent(inout) :: passed
  !> Example: simple_wr
  type(variable_type) :: var
  integer, parameter :: nx = 47, ny = 83
  real :: values(nx, ny)
  integer :: x, y

  do concurrent(y=1:ny, x=1:nx)
    values(x, y) = sqrt((x - 0.5*nx)**2 + (y - 0.5*ny)**2)
  end do
  var = data_array("data", values, ["x".dim.nx, "y".dim.ny])
  call to_netcdf("simple_wr.nc", var)
  passed = .true.
end subroutine simple_wr

subroutine simple_rd(passed)
  logical, intent(inout) :: passed
  !> Example: simple_rd
  type(netcdf_type) :: nc
  type(variable_type) :: var
  integer, parameter :: nx = 47, ny = 83
  logical :: exist

  nc = open_dataset("simple_wr.nc", "r")
  var = inquire_variable(nc, "data", exist)
  passed = &
    var%dimensions(1)%name == "x" .and. &
    var%dimensions(1)%length == nx .and. &
    var%dimensions(2)%name == "y" .and. &
    var%dimensions(2)%length == ny
  call close_dataset(nc)
end subroutine simple_rd

end module module_examples