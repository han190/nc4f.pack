## Arithmetic Operators -- Build a Deferred Expression

`+`, `-`, `*`, and `/` accept `variable_type` and `expression_type` operands,
or a numeric scalar on either side of either derived type. `**` accepts two
derived operands or a derived base with a numeric scalar exponent. Supported
scalar kinds are `int8`, `int16`, `int32`, `int64`, `real32`, and `real64`.
These operators produce a deferred expression. Assignment evaluates the tree.
Alternatively, `call evaluate(expr, result, err)` reports validation errors
without changing `result`. Binary variable and expression operands require
matching numeric types and exactly matching ordered dimensions. A numeric
scalar must have the same kind as its derived operand and applies to every
element without adding a dimension. A real scalar exponent promotes the
expression result to the wider of the base and exponent real kinds.

Expression construction validates operand storage and binds typed value and
metadata views once. Evaluation validates the tree, types, dimensions, and
coordinates, then uses that same expression tree directly. Pure numerical
routines dispatch operations once per block, exposing typed loops for compiler
vectorization. Independent block ranges execute with `DO CONCURRENT`.
Scratch buffers are sized from simultaneously live intermediates, reused
within the expression and across blocks, and kept separate for concurrent
ranges. Subexpressions do not create full-array intermediates. The compiler
determines whether execution is vectorized or parallel. Results are staged before replacing the destination, supporting a
destination that also appears among the operands.

Numerical domains and exceptions follow Fortran arithmetic, intrinsic routines,
and compiler/runtime settings. NC4F does not return `error_type` diagnostics
for division by zero, invalid intrinsic arguments, or arithmetic overflow.
Floating-point results may include NaN or infinity when supported and trapping
is disabled. Intrinsics can also issue native diagnostics or terminate execution
for invalid arguments. Callers are responsible for valid integer operations. Structural
validation errors leave the destination unchanged; runtime traps are outside
that guarantee. Unit conversion and broadcasting between array operands are
not supported.

Expression leaves borrow typed views of operand data and metadata. Declare
operands with `TARGET`, and keep their data, dimensions, coordinates, and any
target behind a borrowed `ptr` alive until evaluation completes. Numeric value
changes before evaluation are read at evaluation time. Keep operand metadata
unchanged, and do not deallocate, replace, or rebind borrowed data or metadata
allocations while an expression refers to them. Missing storage at expression
construction is recorded and reported by `evaluate`; pointers invalidated after
construction cannot be detected reliably.

```fortran
type(variable_type), target :: a, b, c
type(variable_type) :: result
type(expression_type) :: expr
type(error_type) :: err

expr = (a + b) * c**(-1)
call evaluate(expr, result, err)
if (err%code /= NC_NOERR) print *, error_msg(err)
```

Direct assignment (`result = expr`) terminates on validation failure because
Fortran defined assignment has no error-result argument. Evaluation allocates
the result buffer once and does not create full-sized intermediates.
