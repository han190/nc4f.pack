program read_netcdf_example
  use, non_intrinsic :: nc4f
  implicit none (type, external)

  type(netcdf_type) :: nc
  type(variable_type) :: temperature
  real, pointer :: values(:)

  nc = open_netcdf("example.nc", "r")
  temperature = get_variable(nc, "temperature")
  call extract(temperature, values)
  call close_netcdf(nc)

  print *, values
end program read_netcdf_example
