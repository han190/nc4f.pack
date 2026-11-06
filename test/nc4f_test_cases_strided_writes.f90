submodule(nc4f_test_cases) nc4f_test_cases_strided_writes
implicit none (type, external)
contains

module subroutine storage_controls(passed)
  logical, intent(inout) :: passed
  character(*), parameter :: file = TEST_RESULTS_DIR//"storage-controls.nc"
  character(*), parameter :: fill_file = TEST_RESULTS_DIR//"storage-fill.nc"
  character(*), &
    & parameter :: fill_copy = TEST_RESULTS_DIR//"storage-fill-copy.nc"
  character(*), parameter :: raw_file = TEST_RESULTS_DIR//"storage-raw.nc"
  type(variable_type) :: var, found, invalid
  type(storage_type) :: explicit_storage
  type(netcdf_type) :: nc
  type(error_type) :: err
  real, pointer :: values(:,:)
  integer :: i

  passed = .false.
  var = datarray("samples", reshape([(real(i), i=1,12)], [3,4]), &
    & ["x".dim.3, "time".dim.4])
  call set_storage(var, chunks=[3_int64, 2_int64], deflate_level=3, &
    & shuffle=.true., fletcher32=.true., endian=NC_ENDIAN_LITTLE, err=err)
  if (.exists. err) return
  call set_storage(var, no_fill=.true., err=err)
  if (.exists. err) return
  if (.not. allocated(var%storage)) return
  if (var%storage%deflate_level /= 3 .or. var%storage%shuffle /= 1) return
  call to_netcdf(file, var, err=err)
  if (.exists. err) return
  nc = open_netcdf(file, err=err)
  if (.exists. err) return
  found = get_variable(nc, "samples", err=err)
  if (.exists. err) return
  if (.not. allocated(found%storage)) return
  if (.not. allocated(found%storage%chunks)) return
  if (any(found%storage%chunks /= [3_int64, 2_int64])) return
  if (found%storage%deflate_level /= 3 .or. found%storage%shuffle /= 1 .or. &
    & found%storage%fletcher32 /= 1 .or. found%storage%endian /= &
    & NC_ENDIAN_LITTLE .or. &
    & found%storage%no_fill /= 1) return
  call extract(found, values)
  if (any(values /= reshape([(real(i), i=1,12)], [3,4]))) return
  call close_netcdf(nc)

  invalid = var
  call set_storage(invalid, chunks=[0_int64, 2_int64], err=err)
  if (.not. .exists. err) return
  if (any(invalid%storage%chunks /= [3_int64, 2_int64])) return
  call set_storage(invalid, deflate_level=10, err=err)
  if (.not. .exists. err) return
  if (invalid%storage%deflate_level /= 3) return
  var = datarray("filled", [1.0, 2.0], ["x".dim.2])
  call set_storage(var, fill_value="_FillValue".att.(-99.0), err=err)
  if (.exists. err) return
  call to_netcdf(fill_file, var, err=err)
  if (.exists. err) return
  nc = open_netcdf(fill_file, err=err)
  if (.exists. err) return
  found = get_variable(nc, "filled", err=err)
  if (.exists. err) return
  if (.not. allocated(found%storage)) return
  if (.not. allocated(found%storage%fill_value)) return
  if (found%storage%fill_value /= ("_FillValue".att.(-99.0))) return
  call close_netcdf(nc)
  call to_netcdf(fill_copy, found, err=err)
  if (.exists. err) return
  explicit_storage%deflate_level = 2
  nc = open_netcdf(raw_file, "w", err=err)
  if (.exists. err) return
  call define_variable(nc, "raw", NC_FLOAT, ["x".dim.3], &
    & storage=explicit_storage, err=err)
  if (.exists. err) return
  found = inquire_variable(nc, "raw", err=err)
  if (.exists. err) return
  if (.not. allocated(found%storage)) return
  if (found%storage%deflate_level /= 2) return
  call close_netcdf(nc)
  passed = .true.
end subroutine storage_controls

module subroutine strided_writes(passed)
  !! Verify explicit definition, strided updates, and incremental timestep
  !! writes together.
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
  passed = all(abs(values - [11.0, 10.0, 21.0, 20.0, 31.0, &
    & 30.0]) < epsilon(1.0))
  result = get_variable(nc, "history")
  call extract(result, history)
  passed = passed .and. all(shape(history) == [6, 3])
  passed = passed .and. result%dims(2)%is_unlim
  if (passed) then
    do step = 1, 3
      passed = passed .and. all(abs(history(:, &
        & step) - real(step)) < epsilon(1.0))
    end do
  end if
  call close_netcdf(nc)
end subroutine strided_writes

end submodule nc4f_test_cases_strided_writes
