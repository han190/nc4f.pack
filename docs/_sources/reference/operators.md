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

    if (.exists. error) print *, error%msg
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
