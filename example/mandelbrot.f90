program mandelbrot_example

  use, intrinsic :: iso_fortran_env, only: real64
  use, non_intrinsic :: nc4f
  implicit none (type, external)

  real(real64), parameter :: REAL_MIN = -2.0_real64
  real(real64), parameter :: REAL_MAX = 1.0_real64
  real(real64), parameter :: IMAG_MIN = -1.5_real64
  real(real64), parameter :: IMAG_MAX = 1.5_real64
  real(real64), parameter :: STEP = 0.003_real64

  integer :: m, n, i, j
  real(real64), allocatable :: axis_i(:), axis_r(:)
  integer, allocatable :: values(:, :)
  type(dimension_type) :: imag_dim, real_dim
  type(variable_type) :: vars(3)

  axis_r = arange(REAL_MIN, REAL_MAX, STEP)
  axis_i = arange(IMAG_MIN, IMAG_MAX, STEP)
  m = size(axis_r)
  n = size(axis_i)

  allocate (values(m, n))
  do concurrent (j = 1:n, i = 1:m) shared(values)
    values(i, j) = mandelbrot(cmplx(axis_r(i), axis_i(j), kind=real64))
  end do

  real_dim = "real".dim.m
  imag_dim = "imaginary".dim.n

  vars(1) = datarray("real", axis_r, [real_dim], atts=[ &
    & "valid_min".att.minval(axis_r), &
    & "valid_max".att.maxval(axis_r), &
    & "long_name".att."Real Axis"])
  vars(2) = datarray("imaginary", axis_i, [imag_dim], atts=[ &
    & "valid_min".att.minval(axis_i), &
    & "valid_max".att.maxval(axis_i), &
    & "long_name".att."Imaginary Axis"])
  vars(3) = datarray("count", values, [real_dim, imag_dim], atts=[ &
    & "coordinates".att."real imaginary", &
    & "units".att."dimensionless", &
    & "long_name".att."Mandelbrot escape iteration count"])

  print "(dt)", vars
  call to_netcdf("mandelbrot.nc", vars, atts=["title".att."Mandelbrot Set"])

contains

  !> Return evenly spaced values from `start` through `end`.
  pure function arange(start, end, step) result(arr)
    !> First value in the returned sequence.
    real(real64), intent(in) :: start
    !> Last value in the returned sequence.
    real(real64), intent(in) :: end
    !> Spacing between consecutive values.
    real(real64), intent(in) :: step
    !> Evenly spaced sequence including both endpoints.
    real(real64), allocatable :: arr(:)
    integer :: n, i

    n = nint((end - start) / step) + 1
    allocate (arr(n))

    do i = 1, n
      arr(i) = start + step*real(i - 1, real64)
    end do
    arr(n) = end
  end function arange

  !> Perform the mandelbrot operation.
  integer recursive elemental function mandelbrot( &
    & z, zp, niter, niter_max) result(val)
    !> Complex point whose escape iteration count is calculated.
    complex(kind=real64), intent(in) :: z
    !> Current orbit value for recursive calls.
    complex(kind=real64), intent(in), optional :: zp
    !> Number of iterations already completed.
    integer, intent(in), optional :: niter
    !> Maximum number of iterations before the point is considered bounded.
    integer, intent(in), optional :: niter_max
    complex(kind=real64) :: a
    integer :: n, n_max

    if (present(zp)) then
      a = zp
    else
      a = cmplx(0.0, 0.0, kind=real64)
    end if

    if (present(niter)) then
      n = niter
    else
      n = 0
    end if

    if (present(niter_max)) then
      n_max = niter_max
    else
      n_max = 10000
    end if

    if (n == n_max .or. abs(a) > 2.0) then
      val = n
    else
      val = mandelbrot(z, a * a + z, n + 1, n_max)
    end if
  end function mandelbrot

end program mandelbrot_example
