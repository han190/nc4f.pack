subroutine intrinsic_fused(a, b, c, d)
  !! Compute the elementwise reference D = A*(B+C) in one intrinsic expression.
  !! Keep this kernel in a separate compilation unit without LTO so the timed
  !! caller cannot collapse identical repetitions into a single evaluation.
  use, intrinsic :: iso_fortran_env, only: real64
  implicit none (type, external)
  real(real64), contiguous, intent(in) :: a(:,:), b(:,:), c(:,:)
  !! A is the multiplier; B and C are addends. Inputs must be conformable.
  real(real64), contiguous, intent(out) :: d(:,:)
  !! Preallocated destination matching the input shape; must not alias inputs.

  d = a*(b+c)
end subroutine intrinsic_fused
