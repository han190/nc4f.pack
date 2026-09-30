program mandelbrot_example

  use, non_intrinsic :: nc4f
  implicit none (type, external)

  real, parameter :: REAL_MIN = -2.0
  real, parameter :: REAL_MAX = 1.0
  real, parameter :: IMAG_MIN = -1.5
  real, parameter :: IMAG_MAX = 1.5
  real, parameter :: STEP = 0.01
  integer, parameter :: NREAL = nint((REAL_MAX - REAL_MIN) / STEP) + 1
  integer, parameter :: NIMAG = nint((IMAG_MAX - IMAG_MIN) / STEP) + 1

  integer :: imag_idx, real_idx
  real, allocatable :: imag_axis(:), real_axis(:), values(:, :)
  type(dimension_type) :: imag_dim, real_dim
  type(variable_type) :: vars(3)

  real_axis = [(REAL_MIN + STEP * (real_idx - 1), real_idx = 1, NREAL)]
  imag_axis = [(IMAG_MIN + STEP * (imag_idx - 1), imag_idx = 1, NIMAG)]

  allocate (values(NREAL, NIMAG))
  do concurrent (imag_idx = 1:NIMAG, real_idx = 1:NREAL)
    associate (z => cmplx(real_axis(real_idx), imag_axis(imag_idx)))
      values(real_idx, imag_idx) = real(mandelbrot(z))
    end associate
  end do

  real_dim = "real".dim.size(real_axis)
  imag_dim = "imaginary".dim.size(imag_axis)

  vars(1) = datarray("real", real_axis, [real_dim])
  vars(2) = datarray("imaginary", imag_axis, [imag_dim])
  vars(3) = datarray("values", values, [real_dim, imag_dim], atts=[ &
    & "description".att."Mandelbrot escape iteration count", &
    & "coordinates".att."real imaginary"])
  call to_netcdf("mandelbrot.nc", vars, atts=["title".att."Mandelbrot Set"])

contains

  !> Perform the mandelbrot operation.
  recursive elemental function mandelbrot(z, zp, niter, niter_max) result(val)
    !> Data or metadata used by this operation.
    complex, intent(in) :: z
    !> Data or metadata used by this operation.
    complex, intent(in), optional :: zp
    !> Data or metadata used by this operation.
    integer, intent(in), optional :: niter
    !> Data or metadata used by this operation.
    integer, intent(in), optional :: niter_max
    !> Result produced by this operation.
    complex :: val
    complex :: a
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
      n_max = 200
    end if

    if (n == n_max .or. abs(a) > 2.0) then
      val = cmplx(real(n), 0.0)
    else
      val = mandelbrot(z, a * a + z, n + 1, n_max)
    end if
  end function mandelbrot

end program mandelbrot_example
