program mandelbrot_example

  use, intrinsic :: iso_fortran_env, only: real64
  use, non_intrinsic :: nc4f
  implicit none (type, external)

  real(real64), parameter :: REAL_MIN = -2.0
  real(real64), parameter :: REAL_MAX = 1.0
  real(real64), parameter :: IMAG_MIN = -1.5
  real(real64), parameter :: IMAG_MAX = 1.5
  real(real64), parameter :: STEP = 0.003
  integer, parameter :: NREAL = nint((REAL_MAX - REAL_MIN) / STEP) + 1
  integer, parameter :: NIMAG = nint((IMAG_MAX - IMAG_MIN) / STEP) + 1

  integer :: imag_idx, real_idx
  real(real64), allocatable :: imag_axis(:), real_axis(:)
  integer, allocatable :: values(:, :)
  type(dimension_type) :: imag_dim, real_dim
  type(variable_type) :: vars(3)
  complex(kind=real64) :: z

  real_axis = [(REAL_MIN + STEP * (real_idx - 1), real_idx = 1, NREAL)]
  imag_axis = [(IMAG_MIN + STEP * (imag_idx - 1), imag_idx = 1, NIMAG)]

  allocate (values(NREAL, NIMAG))
  do concurrent (imag_idx = 1:NIMAG, real_idx = 1:NREAL) local(z) shared(values)
    z = cmplx(real_axis(real_idx), imag_axis(imag_idx), kind=real64)
    values(real_idx, imag_idx) = int(mandelbrot(z))
  end do

  real_dim = "real".dim.size(real_axis)
  imag_dim = "imaginary".dim.size(imag_axis)

  vars(1) = datarray("real", real_axis, [real_dim])
  vars(2) = datarray("imaginary", imag_axis, [imag_dim])
  vars(3) = datarray("count", values, [imag_dim, real_dim], atts=[ &
    & "long_name".att."Log10 of Mandelbrot escape iteration count", &
    & "coordinates".att."real imaginary", "units".att."dimensionless"])
  call to_netcdf("mandelbrot.nc", vars, atts=["title".att."Mandelbrot Set"])

contains

  !> Perform the mandelbrot operation.
  recursive elemental function mandelbrot(z, zp, niter, niter_max) result(val)
    !> Data or metadata used by this operation.
    complex(kind=real64), intent(in) :: z
    !> Data or metadata used by this operation.
    complex(kind=real64), intent(in), optional :: zp
    !> Data or metadata used by this operation.
    integer, intent(in), optional :: niter
    !> Data or metadata used by this operation.
    integer, intent(in), optional :: niter_max
    !> Result produced by this operation.
    complex(kind=real64) :: val
    complex(kind=real64) :: a
    integer :: n, n_max

    if (present(zp)) then
      a = zp
    else
      a = cmplx(0.0, 0.0)
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
      val = cmplx(real(n), 0.0)
    else
      val = mandelbrot(z, a * a + z, n + 1, n_max)
    end if
  end function mandelbrot

end program mandelbrot_example
