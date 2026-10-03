program temperature_example

  use, non_intrinsic :: nc4f
  implicit none (type, external)

  real, parameter :: temperature(3) = [289.4, 290.1, 288.7]
  real, pointer :: temperature_vals(:)
  type(netcdf_type) :: nc
  type(variable_type) :: temperature_write, temperature_read

  temperature_write = datarray( &
    & "temperature", temperature, dims=["station".dim.3], &
    & atts=["units".att."K", "long_name".att."Near-surface air temperature"])
  call to_netcdf("temperature.nc", temperature_write)

  nc = open_netcdf("temperature.nc", "r")
  temperature_read = get_variable(nc, "temperature")
  call close_netcdf(nc)
  call extract(temperature_read, temperature_vals)

  print *, temperature_read
  print *, temperature_vals

end program temperature_example
