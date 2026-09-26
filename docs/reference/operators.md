# Overloaded Operators

## `OPERATOR(.AND.)` -- Specify Dimension Extent

| Synopsis |
|:--|
| <span class="ind4">`ARGS = LEN .AND. IS_UNLIM`</span> |

| Class |
|:--|
| <span class="ind4">Generic elemental function.</span> |

| Description |
|:--|
| <span class="ind4">Create a dimension argument that combines an extent with its unlimited status. Use the result as the right operand of `.DIM.`.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`LEN`</span><span>`INTEGER(INT32) OR INTEGER(INT64), INTENT(IN)`</span></span><br><span class="ind8">Dimension extent.</span> |
| <span class="grid"><span>`IS_UNLIM`</span><span>`LOGICAL, INTENT(IN)`</span></span><br><span class="ind8">Whether the dimension is unlimited.</span> |

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
| <span class="ind4">`ATT = NAME .ATT. VALUE`</span> |

| Class |
|:--|
| <span class="ind4">Generic function.</span> |

| Description |
|:--|
| <span class="ind4">Construct an `attribute_type` from a name and a scalar or rank-one supported NetCDF value.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`NAME`</span><span>`CHARACTER(LEN=*), INTENT(IN)`</span></span><br><span class="ind8">Attribute name.</span> |
| <span class="grid"><span>`VALUE`</span><span>`GENERIC, RANK(0:1), INTENT(IN)`</span></span><br><span class="ind8">Supported numeric scalar or vector, or a character scalar.</span> |

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
| <span class="ind4">`DIM = NAME .DIM. LEN`</span><br><span class="ind4">`DIM = NAME .DIM. ARGS`</span> |

| Class |
|:--|
| <span class="ind4">Generic elemental function.</span> |

| Description |
|:--|
| <span class="ind4">Construct a limited dimension from an extent, or a limited or unlimited dimension from an argument created by `.AND.`.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`NAME`</span><span>`CHARACTER(LEN=*), INTENT(IN)`</span></span><br><span class="ind8">Dimension name.</span> |
| <span class="grid"><span>`LEN`</span><span>`INTEGER(INT32) OR INTEGER(INT64), INTENT(IN)`</span></span><br><span class="ind8">Extent of a limited dimension.</span> |
| <span class="grid"><span>`ARGS`</span><span>`TYPE(DIMENSION_ARGUMENT_TYPE), INTENT(IN)`</span></span><br><span class="ind8">Extent and unlimited status created by `.AND.`.</span> |

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
| <span class="ind4">`FAILED = .EXISTS. ERR`</span> |

| Class |
|:--|
| <span class="ind4">Pure elemental function.</span> |

| Description |
|:--|
| <span class="ind4">Return true when an `error_type` represents a failed operation.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`ERR`</span><span>`TYPE(ERROR_TYPE), INTENT(IN)`</span></span><br><span class="ind8">Operation result to test.</span> |

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
| <span class="ind4">`IS_DIFFERENT = X /= Y`</span> |

| Class |
|:--|
| <span class="ind4">Generic elemental function.</span> |

| Description |
|:--|
| <span class="ind4">Return true when two attributes, dimensions, or variables are not equal.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`X`</span><span>`TYPE(ATTRIBUTE_TYPE), TYPE(DIMENSION_TYPE), OR TYPE(VARIABLE_TYPE), INTENT(IN)`</span></span><br><span class="ind8">First model object.</span> |
| <span class="grid"><span>`Y`</span><span>`SAME TYPE AS X, INTENT(IN)`</span></span><br><span class="ind8">Second model object.</span> |

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
| <span class="ind4">`IS_EQUAL = X == Y`</span> |

| Class |
|:--|
| <span class="ind4">Generic elemental function.</span> |

| Description |
|:--|
| <span class="ind4">Return true when two attributes, dimensions, or variables are equal.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`X`</span><span>`TYPE(ATTRIBUTE_TYPE), TYPE(DIMENSION_TYPE), OR TYPE(VARIABLE_TYPE), INTENT(IN)`</span></span><br><span class="ind8">First model object.</span> |
| <span class="grid"><span>`Y`</span><span>`SAME TYPE AS X, INTENT(IN)`</span></span><br><span class="ind8">Second model object.</span> |

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
