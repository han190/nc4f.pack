## `SUM` -- Add Compatible Variables

| Synopsis |
|:--|
| <span class="ind3">`TOTAL = SUM(VARS)`</span> |

| Class |
|:--|
| <span class="ind3">Function.</span> |

| Description |
|:--|
| <span class="ind3">Return the element-wise sum of a rank-one array of compatible, materialized variables. The result uses the first variable's metadata.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`VARS`</span><span>`type(variable_type), DIMENSION(:), INTENT(in)`</span></span><br><span class="ind6">Compatible variables with materialized data.</span> |

| Return |
|:--|
| <span class="grid"><span>`TOTAL`</span><span>`type(variable_type)`</span></span><br><span class="ind6">Element-wise sum with the first variable's metadata.</span> |

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
    
    type(variable_type) :: pressure, base_pressure, total

    total = sum([pressure, base_pressure])
    ```
:::

