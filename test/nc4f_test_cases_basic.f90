submodule(nc4f_test_cases) nc4f_test_cases_basic

implicit none (type, external)

contains

!> Execute `simple_wr`.
module subroutine simple_wr(passed)
  !> Input/output argument(s): `passed`.
  logical, intent(inout) :: passed
  type(variable_type) :: var
  integer, parameter :: nx = 47, ny = 83
  real :: values(nx, ny)
  integer :: x, y
  character(len=1024) :: stdout

  do concurrent(y=1:ny, x=1:nx)
    values(x, y) = sqrt((x - 0.5*nx)**2 + (y - 0.5*ny)**2)
  end do
  var = datarray("data", values, ["x".dim.nx, "y".dim.ny])
  call to_netcdf(TEST_RESULTS_DIR//"simple_wr.nc", var)
  write (stdout, "(dt)") var
  passed = index(stdout, "float data(x, y)") > 0
end subroutine simple_wr

!> Execute `simple_rd`.
module subroutine simple_rd(passed)
  !> Input/output argument(s): `passed`.
  logical, intent(inout) :: passed
  type(netcdf_type) :: nc
  type(variable_type) :: var
  integer, parameter :: nx = 47, ny = 83
  type(error_type) :: err
  character(len=1024) :: stdout

  nc = open_netcdf(TEST_RESULTS_DIR// &
    & "file_that_does_not_exist.nc", err=err)
  passed = .exists.err
  if (.not. passed) return

  nc = open_netcdf(TEST_RESULTS_DIR//"simple_wr.nc", "r")
  var = inquire_variable(nc, "data", err)
  if ((err%code /= NC_NOERR)) then
    call close_netcdf(nc)
    passed = .false.
    return
  end if
  write (stdout, "(dt)") var
  passed = var%name == "data" .and. &
         & all(var%dims == ["x".dim.nx, "y".dim.ny]) .and. &
         & index(stdout, "float data(x, y)") > 0
  call close_netcdf(nc)
end subroutine simple_rd

!> Execute `character_variables`.
module subroutine character_variables(passed)
  !> Input/output argument(s): `passed`.
  logical, intent(inout) :: passed
  character, parameter :: values(2, 3) = &
    & reshape(["a", "b", "c", "d", "e", "f"], [2, 3])
  character, pointer :: actual_values(:, :)
  type(error_type) :: err
  type(netcdf_type) :: nc
  type(variable_type) :: actual, var

  var = datarray("letters", values, ["x".dim.2, "y".dim.3])
  call to_netcdf(TEST_RESULTS_DIR//"characters.nc", var, err=err)
  if ((err%code /= NC_NOERR)) then
    passed = .false.
    return
  end if
  nc = open_netcdf(TEST_RESULTS_DIR//"characters.nc", "r", err=err)
  if ((err%code /= NC_NOERR)) then
    passed = .false.
    return
  end if
  actual = get_variable(nc, "letters", err)
  call close_netcdf(nc)
  if ((err%code /= NC_NOERR)) then
    passed = .false.
    return
  end if
  call extract(actual, actual_values)
  passed = actual%name == var%name .and. all(actual%dims == var%dims) .and. &
    & all(actual_values == values)
end subroutine character_variables

!> Execute `buffer_edges`.
module subroutine buffer_edges(passed)
  !> Input/output argument(s): `passed`.
  logical, intent(inout) :: passed
  character(len=256) :: dim_name, att_name, var_name
  character(len=:), pointer :: text
  real, parameter :: values(2) = [1.0, 2.0]
  real, pointer :: read_values(:)
  type(attribute_type) :: empty_att
  type(variable_type) :: var
  type(netcdf_type) :: nc

  empty_att = "empty".att.""
  call extract(empty_att, text)
  passed = associated(text) .and. len(text) == 0
  if (associated(text)) nullify (text)
  if (.not. passed) return

  dim_name = repeat("d", len(dim_name) - 1)
  att_name = repeat("a", len(att_name) - 1)
  var_name = repeat("v", len(var_name) - 1)
  var = datarray(var_name, values, [dim_name.dim.2], &
    & [att_name.att."maximum-length name", "empty".att.""])
  call to_netcdf(TEST_RESULTS_DIR//"buffer_edges.nc", var)

  nc = open_netcdf(TEST_RESULTS_DIR//"buffer_edges.nc", "r")
  call inquire_group(nc)
  var = get_variable(nc, var_name)
  call extract(var, read_values)
  passed = var%name == var_name .and. &
    & nc%dims(1)%name == dim_name .and. &
    & var%dims(1)%name == dim_name .and. &
    & var%atts(1)%name == att_name .and. size(var%atts) == 2 .and. &
    & var%atts(2)%len == 0 .and. &
    & all(abs(read_values - values) <= epsilon(values))
  call close_netcdf(nc)
end subroutine buffer_edges

end submodule nc4f_test_cases_basic
