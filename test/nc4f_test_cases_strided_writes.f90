submodule(nc4f_test_cases) nc4f_test_cases_strided_writes
implicit none (type, external)
contains

module subroutine strided_writes(passed)
  !! Verify explicit definition, strided updates, and incremental timestep writes together.
  logical, intent(inout) :: passed
  !! Set true when reopened temperature values and all appended timesteps match.
  character(*), parameter :: file = TEST_RESULTS_DIR//"strided-writes.nc"

  type(netcdf_type) :: nc
  type(variable_type) :: patch, result
  real, pointer :: values(:), history(:, :)
  real :: timestep(6, 1)
  integer :: step

  passed = .false.
  nc = open_netcdf(file, "w")
  ! Define the full destination without allocating six initial values.
  call define_variable(nc, &
    & variable_type(name="temperature", dtype=NC_FLOAT, &
    & dims=["station".dim.6], &
    & atts=["units".att."K", "_FillValue".att.0.0]))
  patch = datarray("temperature", [10.0, 20.0, 30.0], ["station".dim.3])
  call put_variable(nc, patch, start=[2], count=[3], stride=[2])

  ! Define an unlimited dimension and append one timestep at a time.
  call define_variable(nc, &
    & variable_type(name="history", dtype=NC_FLOAT, &
    & dims=["station".dim.6, "time".dim.(0 .and. .true.)]))
  do step = 1, 3
    timestep = real(step)
    patch = datarray("history", timestep, ["station".dim.6, "time".dim.1])
    call put_variable(nc, patch, start=[1, step])
  end do
  call close_netcdf(nc)

  ! The path-based wrapper updates an existing selection and closes the file.
  patch = datarray("temperature", [11.0, 21.0, 31.0], ["station".dim.3])
  call to_netcdf(file, patch, mode="a", start=[1], stride=[2])
  nc = open_netcdf(file)
  result = get_variable(nc, "temperature")
  call extract(result, values)
  passed = all(abs(values - [11.0, 10.0, 21.0, 20.0, 31.0, 30.0]) < epsilon(1.0))
  result = get_variable(nc, "history")
  call extract(result, history)
  passed = passed .and. all(shape(history) == [6, 3])
  passed = passed .and. result%dims(2)%is_unlim
  if (passed) then
    do step = 1, 3
      passed = passed .and. all(abs(history(:, step) - real(step)) < epsilon(1.0))
    end do
  end if
  call close_netcdf(nc)
end subroutine strided_writes

end submodule nc4f_test_cases_strided_writes
