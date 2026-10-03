program write_netcdf_example
  use, non_intrinsic :: nc4f
  implicit none (type, external)

  real :: values(3) = [1.0, 2.0, 3.0]
  type(variable_type) :: temperature

  temperature = datarray("temperature", values, ["time".dim.3])
  call to_netcdf("example.nc", temperature)
end program write_netcdf_example
