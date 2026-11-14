program benchmark_netcdf_io
  !! Compare equivalent NC4F and netcdf-fortran workflows.
  use, intrinsic :: iso_fortran_env, only: int64, real32, real64
  use, non_intrinsic :: nc4f, only: coordinate_type, dimension_type, &
    & variable_type, netcdf_type, datarray, extract, get_variable, initialize, &
    & open_netcdf, close_netcdf, to_netcdf, &
    & operator(.att.), operator(.dim.)
  use, non_intrinsic :: netcdf, only: nf90_noerr, nf90_strerror, &
    & nf90_create, nf90_open, nf90_close, nf90_def_dim, nf90_def_var, &
    & nf90_put_att, nf90_enddef, nf90_put_var, nf90_inq_varid, &
    & nf90_get_var, nf90_redef, nf90_clobber, nf90_netcdf4, &
    & nf90_write, nf90_nowrite, nf90_float, nf90_inq_dimid
  implicit none (type, external)

  real(real32), parameter :: p0 = 100000.0_real32
  real(real32), parameter :: gas_r = 287.05_real32
  real(real32), parameter :: cp = 1004.0_real32
  real(real32), parameter :: pi = acos(-1.0_real32)
  character(len=*), parameter :: nc4f_file = "benchmark_nc4f.nc"
  character(len=*), parameter :: nf90_file = "benchmark_nf90.nc"
  integer, parameter :: phases = 4
  integer :: n, exponent, repeats, run, i, j
  integer(int64) :: rate, tick0, tick1
  real(real64) :: nc4f_time(phases), nf90_time(phases)
  real(real32), allocatable :: lon_values(:,:), lat_values(:,:)
  real(real32), allocatable :: tmp_values(:,:), pre_values(:,:)
  real(real32) :: checksum_nc4f, checksum_nf90
  character(len=32) :: arg

  repeats = 3
  if (command_argument_count() >= 1) then
    call get_command_argument(1, arg)
    read (arg, *) repeats
  end if
  if (repeats < 1) error stop "Repetitions must be positive."
  call system_clock(count_rate=rate)
  if (rate <= 0_int64) error stop "SYSTEM_CLOCK is unavailable."

  do exponent = 1, 13
    n = 2**exponent
    allocate (lon_values(n,n), lat_values(n,n), &
      & tmp_values(n,n), pre_values(n,n))
    do concurrent (j=1:n, i=1:n)
      lon_values(i,j) = -180.0_real32 + &
        & 360.0_real32*real(i-1,real32)/real(n,real32)
      lat_values(i,j) = -90.0_real32 + &
        & 180.0_real32*real(j-1,real32)/real(max(1,n-1),real32)
      tmp_values(i,j) = 273.15_real32 + &
        & 4.0_real32*sin(2.0_real32*lon_values(i,j)*pi/180.0_real32) &
        & *cos(lat_values(i,j)*pi/180.0_real32)
      pre_values(i,j) = p0 + &
        & 600.0_real32*cos(3.0_real32*lon_values(i,j)*pi/180.0_real32) &
        & *cos(lat_values(i,j)*pi/180.0_real32)
    end do
    nc4f_time = 0.0_real64
    nf90_time = 0.0_real64

    do run = 1, repeats
      if (mod(run+exponent,2) == 0) then
        call run_nc4f(n)
        call run_nf90(n)
      else
        call run_nf90(n)
        call run_nc4f(n)
      end if
      if (abs(checksum_nc4f-checksum_nf90) > &
        & 1.0e-5_real32*max(1.0_real32,abs(checksum_nf90))) then
        error stop "NC4F and netcdf-fortran results differ."
      end if
    end do

    write (*,"(/,a,i0,a,i0,a,i0)") &
      & "Grid: ", n, " x ", n, "; repetitions: ", repeats
    write (*,"(a18,2(1x,a12),1x,a12)") &
      & "Phase", "NC4F (ms)", "NF90 (ms)", "NC4F/NF90"
    call report("create + write", 1)
    call report("open + read", 2)
    call report("calculate", 3)
    call report("append theta", 4)
    call report("total", 0)
    deallocate (lon_values, lat_values, tmp_values, pre_values)
  end do

contains

  subroutine run_nc4f(n)
    !! Create, read, calculate, and append a square grid with NC4F.
    integer, intent(in) :: n
    !! Number of points along each horizontal dimension.
    integer :: m
    type(dimension_type) :: west_east, south_north
    type(coordinate_type) :: lon, lat
    type(variable_type) :: vars(3)
    type(netcdf_type) :: nc
    real(real32), pointer :: t(:,:), p(:,:), theta(:,:)

    m = n
    call system_clock(tick0)
    west_east = "west_east".dim.m
    south_north = "south_north".dim.n
    lon = coordinate_type("lon", lon_values, &
      & [west_east, south_north], &
      & atts=["units".att."degrees_east", &
      & "standard_name".att."longitude"])
    lat = coordinate_type("lat", lat_values, &
      & [west_east, south_north], &
      & atts=["units".att."degrees_north", &
      & "standard_name".att."latitude"])
    vars(1) = datarray("temperature", tmp_values, &
      & [west_east, south_north], coords=[lon,lat], &
      & atts=["units".att."K", &
      & "long_name".att."Air temperature"])
    vars(2) = datarray("pressure", pre_values, &
      & [west_east, south_north], coords=[lon,lat], &
      & atts=["units".att."Pa", &
      & "long_name".att."Air pressure"])
    call to_netcdf(nc4f_file, vars(1:2))
    call record(nc4f_time, 1)

    call system_clock(tick0)
    nc = open_netcdf(nc4f_file, "r")
    vars(1) = get_variable(nc, "temperature")
    vars(2) = get_variable(nc, "pressure")
    call close_netcdf(nc)
    call extract(vars(1), t)
    call extract(vars(2), p)
    call record(nc4f_time, 2)

    call system_clock(tick0)
    call initialize(vars(3), "theta", vars(1), atts=[ &
      & "units".att."K", "long_name".att."Potential temperature"])
    call extract(vars(3), theta)
    theta = t*(p0/p)**(gas_r/cp)
    call record(nc4f_time, 3)
    checksum_nc4f = sum(theta)

    call system_clock(tick0)
    call to_netcdf(nc4f_file, vars(3), mode="a")
    call record(nc4f_time, 4)
  end subroutine run_nc4f

  subroutine run_nf90(n)
    !! Perform the matching square-grid workflow through netcdf-fortran.
    integer, intent(in) :: n
    !! Number of points along each horizontal dimension.
    integer :: m
    integer :: ncid, dim_west, dim_south, id_lon, id_lat
    integer :: id_tmp, id_pre, id_theta
    real(real32), allocatable, target :: t_data(:,:), p_data(:,:)
    real(real32), allocatable, target :: theta_data(:,:)
    real(real32), allocatable :: lon_read(:,:), lat_read(:,:)
    real(real32), pointer :: t(:,:), p(:,:), theta(:,:)

    m = n
    call system_clock(tick0)
    call check(nf90_create(nf90_file, ior(nf90_clobber,nf90_netcdf4), &
      & ncid))
    call check(nf90_def_dim(ncid, "west_east", m, dim_west))
    call check(nf90_def_dim(ncid, "south_north", n, dim_south))
    call check(nf90_def_var(ncid, "lon", nf90_float, &
      & [dim_west,dim_south], id_lon))
    call check(nf90_def_var(ncid, "lat", nf90_float, &
      & [dim_west,dim_south], id_lat))
    call check(nf90_def_var(ncid, "temperature", nf90_float, &
      & [dim_west,dim_south], id_tmp))
    call check(nf90_def_var(ncid, "pressure", nf90_float, &
      & [dim_west,dim_south], id_pre))
    call check(nf90_put_att(ncid, id_lon, "units", "degrees_east"))
    call check(nf90_put_att(ncid, id_lon, "standard_name", "longitude"))
    call check(nf90_put_att(ncid, id_lat, "units", "degrees_north"))
    call check(nf90_put_att(ncid, id_lat, "standard_name", "latitude"))
    call check(nf90_put_att(ncid, id_tmp, "units", "K"))
    call check(nf90_put_att(ncid, id_tmp, "long_name", "Air temperature"))
    call check(nf90_put_att(ncid, id_pre, "units", "Pa"))
    call check(nf90_put_att(ncid, id_pre, "long_name", "Air pressure"))
    call check(nf90_put_att(ncid, id_tmp, "coordinates", "lon lat"))
    call check(nf90_put_att(ncid, id_pre, "coordinates", "lon lat"))
    call check(nf90_enddef(ncid))
    call check(nf90_put_var(ncid, id_lon, lon_values))
    call check(nf90_put_var(ncid, id_lat, lat_values))
    call check(nf90_put_var(ncid, id_tmp, tmp_values))
    call check(nf90_put_var(ncid, id_pre, pre_values))
    call check(nf90_close(ncid))
    call record(nf90_time, 1)

    call system_clock(tick0)
    allocate (t_data(m,n), p_data(m,n), &
      & lon_read(m,n), lat_read(m,n))
    call check(nf90_open(nf90_file, nf90_nowrite, ncid))
    call check(nf90_inq_dimid(ncid, "west_east", dim_west))
    call check(nf90_inq_dimid(ncid, "south_north", dim_south))
    call check(nf90_inq_varid(ncid, "temperature", id_tmp))
    call check(nf90_inq_varid(ncid, "pressure", id_pre))
    call check(nf90_inq_varid(ncid, "lon", id_lon))
    call check(nf90_inq_varid(ncid, "lat", id_lat))
    call check(nf90_get_var(ncid, id_tmp, t_data))
    call check(nf90_get_var(ncid, id_pre, p_data))
    call check(nf90_get_var(ncid, id_lon, lon_read))
    call check(nf90_get_var(ncid, id_lat, lat_read))
    call check(nf90_close(ncid))
    t => t_data
    p => p_data
    call record(nf90_time, 2)

    call system_clock(tick0)
    allocate (theta_data(m,n))
    theta_data = 0.0_real32
    theta => theta_data
    theta = t*(p0/p)**(gas_r/cp)
    call record(nf90_time, 3)
    checksum_nf90 = sum(theta)

    call system_clock(tick0)
    call check(nf90_open(nf90_file, nf90_write, ncid))
    call check(nf90_redef(ncid))
    call check(nf90_inq_dimid(ncid, "west_east", dim_west))
    call check(nf90_inq_dimid(ncid, "south_north", dim_south))
    call check(nf90_def_var(ncid, "theta", nf90_float, &
      & [dim_west,dim_south], id_theta))
    call check(nf90_put_att(ncid, id_theta, "units", "K"))
    call check(nf90_put_att(ncid, id_theta, &
      & "long_name", "Potential temperature"))
    call check(nf90_put_att(ncid, id_theta, "coordinates", "lon lat"))
    call check(nf90_enddef(ncid))
    call check(nf90_put_var(ncid, id_theta, theta_data))
    call check(nf90_close(ncid))
    call record(nf90_time, 4)
  end subroutine run_nf90

  subroutine check(status)
    !! Stop on a netcdf-fortran error.
    integer, intent(in) :: status
    !! Status returned by an NF90 call.
    if (status /= nf90_noerr) then
      print "(a)", trim(nf90_strerror(status))
      error stop "netcdf-fortran operation failed."
    end if
  end subroutine check

  subroutine record(times, phase)
    !! Accumulate one completed phase in milliseconds.
    real(real64), intent(inout) :: times(:)
    !! Timing totals by phase.
    integer, intent(in) :: phase
    !! Phase index to update.
    call system_clock(tick1)
    times(phase) = times(phase) + &
      & 1000.0_real64*real(tick1-tick0,real64)/real(rate,real64)
  end subroutine record

  subroutine report(label, phase)
    !! Print average phase or total timings for both interfaces.
    character(len=*), intent(in) :: label
    !! Row label.
    integer, intent(in) :: phase
    !! Phase number; zero reports the sum of all phases.
    real(real64) :: a, b
    character(len=12) :: ratio

    if (phase == 0) then
      a = sum(nc4f_time)/real(repeats,real64)
      b = sum(nf90_time)/real(repeats,real64)
    else
      a = nc4f_time(phase)/real(repeats,real64)
      b = nf90_time(phase)/real(repeats,real64)
    end if
    ratio = "N/A"
    if (b > 0.0_real64) write (ratio,"(f12.3)") a/b
    write (*,"(a18,2(1x,es12.4),1x,a12)") &
      & label, a, b, ratio
  end subroutine report
end program benchmark_netcdf_io
