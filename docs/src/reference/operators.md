# Overloaded Operators

## `OPERATOR(.AND.)` -- Specify Dimension Extent

| Synopsis |
|:--|
| <span class="ind3">`ARGS = LEN .AND. IS_UNLIM`</span> |

| Class |
|:--|
| <span class="ind3">Generic elemental function.</span> |

| Description |
|:--|
| <span class="ind3">Create a dimension argument that combines an extent with its unlimited status. Use the result as the right operand of `.DIM.`.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`LEN`</span><span>`INTEGER(INT32) OR INTEGER(INT64), INTENT(IN)`</span></span><br><span class="ind6">Dimension extent.</span> |
| <span class="grid"><span>`IS_UNLIM`</span><span>`LOGICAL, INTENT(IN)`</span></span><br><span class="ind6">Whether the dimension is unlimited.</span> |

| Return |
|:--|
| <span class="grid"><span>`ARGS`</span><span>`type(dimension_argument_type)`</span></span><br><span class="ind6">Dimension extent and unlimited status for use with `.DIM.`.</span> |

:::{list-table}
:class: example-table
:header-rows: 1

*
  - Example
*
  -
    ```fortran
    use, non_intrinsic :: nc4f
    implicit none (type, external)
    
    type(dimension_type) :: time
    integer :: length
    logical :: is_unlimited

    length = 24
    is_unlimited = .true.
    time = "time" .dim. (length .and. is_unlimited)
    ```
:::

## `OPERATOR(.ATT.)` -- Construct an Attribute

| Synopsis |
|:--|
| <span class="ind3">`ATT = NAME .ATT. VALUE`</span> |

| Class |
|:--|
| <span class="ind3">Generic function.</span> |

| Description |
|:--|
| <span class="ind3">Construct an `attribute_type` from a name and a scalar or rank-one supported NetCDF value.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`NAME`</span><span>`CHARACTER(LEN=*), INTENT(IN)`</span></span><br><span class="ind6">Attribute name.</span> |
| <span class="grid"><span>`VALUE`</span><span>`TYPE(INTEGER(INT8, INT16, INT32, INT64), REAL(REAL32, REAL64), CHARACTER), RANK(0:1), INTENT(IN)`</span></span><br><span class="ind6">Supported numeric scalar or vector, or a character scalar.</span> |

| Return |
|:--|
| <span class="grid"><span>`ATT`</span><span>`type(attribute_type)`</span></span><br><span class="ind6">Constructed attribute.</span> |

:::{list-table}
:class: example-table
:header-rows: 1

*
  - Example
*
  -
    ```fortran
    use, non_intrinsic :: nc4f
    implicit none (type, external)
    
    type(attribute_type) :: units
    character(len=*), parameter :: unit_name = "K"

    units = "units" .att. unit_name
    ```
:::

## `OPERATOR(.DIM.)` -- Construct a Dimension

| Synopsis |
|:--|
| <span class="ind3">`DIM = NAME .DIM. LEN`</span><br><span class="ind3">`DIM = NAME .DIM. ARGS`</span> |

| Class |
|:--|
| <span class="ind3">Generic elemental function.</span> |

| Description |
|:--|
| <span class="ind3">Construct a limited dimension from an extent, or a limited or unlimited dimension from an argument created by `.AND.`.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`NAME`</span><span>`CHARACTER(LEN=*), INTENT(IN)`</span></span><br><span class="ind6">Dimension name.</span> |
| <span class="grid"><span>`LEN`</span><span>`INTEGER(INT32) OR INTEGER(INT64), INTENT(IN)`</span></span><br><span class="ind6">Extent of a limited dimension.</span> |
| <span class="grid"><span>`ARGS`</span><span>`TYPE(DIMENSION_ARGUMENT_TYPE), INTENT(IN)`</span></span><br><span class="ind6">Extent and unlimited status created by `.AND.`.</span> |

| Return |
|:--|
| <span class="grid"><span>`DIM`</span><span>`type(dimension_type)`</span></span><br><span class="ind6">Constructed limited or unlimited dimension.</span> |

:::{list-table}
:class: example-table
:header-rows: 1

*
  - Example
*
  -
    ```fortran
    use, non_intrinsic :: nc4f
    implicit none (type, external)
    
    type(dimension_type) :: latitude
    integer :: length

    length = 181
    latitude = "latitude" .dim. length
    ```
:::

## `OPERATOR(.EXISTS.)` -- Test an Error Result

Defined in `nc4f_data` alongside `error_type`, and re-exported by
`nc4f_netcdf` and `nc4f`. The public elemental function `has_err(err)` in
`nc4f_data`
provides the same test. Both forms accept scalars and arrays and may be
used in pure procedures. Use explicit code comparisons when distinguishing
specific errors or checking raw C status integers.

| Synopsis |
|:--|
| <span class="ind3">`FAILED = .EXISTS. ERR`</span> |

| Class |
|:--|
| <span class="ind3">Pure elemental function.</span> |

| Description |
|:--|
| <span class="ind3">Return true when an `error_type` represents a failed operation.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`ERR`</span><span>`TYPE(ERROR_TYPE), INTENT(IN)`</span></span><br><span class="ind6">Operation result to test.</span> |

| Return |
|:--|
| <span class="grid"><span>`FAILED`</span><span>`logical`</span></span><br><span class="ind6">True when the error result represents a failed operation.</span> |

:::{list-table}
:class: example-table
:header-rows: 1

*
  - Example
*
  -
    ```fortran
    use, non_intrinsic :: nc4f
    implicit none (type, external)
    
    type(error_type) :: error

    if (.exists. error) print *, error_msg(error)
    ```
:::

## `OPERATOR(/=)` -- Compare Model Objects

| Synopsis |
|:--|
| <span class="ind3">`IS_DIFF = X /= Y`</span> |

| Class |
|:--|
| <span class="ind3">Generic elemental function.</span> |

| Description |
|:--|
| <span class="ind3">Return true when two attributes, dimensions, or variables are not equal.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`X`</span><span>`TYPE(ATTRIBUTE_TYPE, DIMENSION_TYPE, VARIABLE_TYPE), INTENT(IN)`</span></span><br><span class="ind6">First model object.</span> |
| <span class="grid"><span>`Y`</span><span>`SAME TYPE AS X, INTENT(IN)`</span></span><br><span class="ind6">Second model object.</span> |

| Return |
|:--|
| <span class="grid"><span>`IS_DIFF`</span><span>`logical`</span></span><br><span class="ind6">True when the model objects differ.</span> |

:::{list-table}
:class: example-table
:header-rows: 1

*
  - Example
*
  -
    ```fortran
    use, non_intrinsic :: nc4f
    implicit none (type, external)
    
    type(dimension_type) :: observed, expected

    if (observed /= expected) print *, "Values differ."
    ```
:::

## `OPERATOR(==)` -- Compare Model Objects

| Synopsis |
|:--|
| <span class="ind3">`IS_EQUAL = X == Y`</span> |

| Class |
|:--|
| <span class="ind3">Generic elemental function.</span> |

| Description |
|:--|
| <span class="ind3">Return true when two attributes, dimensions, or variables are equal.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`X`</span><span>`TYPE(ATTRIBUTE_TYPE, DIMENSION_TYPE, VARIABLE_TYPE), INTENT(IN)`</span></span><br><span class="ind6">First model object.</span> |
| <span class="grid"><span>`Y`</span><span>`SAME TYPE AS X, INTENT(IN)`</span></span><br><span class="ind6">Second model object.</span> |

| Return |
|:--|
| <span class="grid"><span>`IS_EQUAL`</span><span>`logical`</span></span><br><span class="ind6">True when the model objects are equal.</span> |

:::{list-table}
:class: example-table
:header-rows: 1

*
  - Example
*
  -
    ```fortran
    use, non_intrinsic :: nc4f
    implicit none (type, external)
    
    type(dimension_type) :: reference, candidate

    if (reference == candidate) print *, "Values match."
    ```
:::

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
