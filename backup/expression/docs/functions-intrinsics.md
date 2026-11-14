## Unary Elementwise Intrinsics -- Build a Deferred Expression

`abs`, `sqrt`, `exp`, `log`, `log10`, `sin`, `cos`, `tan`, `asin`, `acos`,
`atan`, `sinh`, `cosh`, `tanh`, `asinh`, `acosh`, `atanh`, `erf`, `erfc`,
`erfc_scaled`, `gamma`, `log_gamma`, `bessel_j0`, `bessel_j1`, `bessel_y0`,
and `bessel_y1` accept a `variable_type` or `expression_type` and return
an `expression_type`. The intrinsic scalar forms remain available. `abs`
accepts the supported integer and real kinds; the others require `real32`
or `real64`. Evaluated results keep the operand's type and ordered dimensions.
Trigonometric arguments and inverse results use radians. Numerical domains
and exceptions follow the Fortran intrinsic backend and compiler/runtime
settings; they are not returned as NC4F errors by `evaluate`. Type, dimension,
coordinate, and storage validation happens before numerical evaluation.

```fortran
type(variable_type), target :: theta
type(variable_type) :: result
real :: scale

result = scale * cos(theta)
```

The expression borrows `theta`, so it must remain alive until evaluation.
See [Arithmetic Operators](operators.md)
for the shared expression lifetime and error rules.

