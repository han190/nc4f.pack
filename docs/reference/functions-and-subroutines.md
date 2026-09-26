# Functions and Subroutines

This page documents the public procedures re-exported by `nc4f`. Optional
`err` arguments receive an `error_type`; when omitted, an operation failure
follows the library's fail-fast policy. See [Exposed NC
Constants](exposed-nc-constants.md) for constants used with `error_type`.


## `CLOSE_NETCDF` -- Close a NetCDF File

| Synopsis |
|:--|
| <span class="ind4">`CALL CLOSE_NETCDF(NC[, ERR])`</span> |

| Class |
|:--|
| <span class="ind4">Subroutine.</span> |

| Description |
|:--|
| <span class="ind4">Close an open dataset and release its allocated model metadata.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`NC`</span><span>`type(netcdf_type), INTENT(inout)`</span></span><br><span class="ind8">Open dataset to close.</span> |
| <span class="grid"><span>`ERR`</span><span>`type(error_type), OPTIONAL, INTENT(out)`</span></span><br><span class="ind8">Receives an operation error.</span> |

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
    
    type(netcdf_type) :: nc

    nc = open_netcdf("input.nc")
    call close_netcdf(nc)
    ```
:::

## `DATARRAY` -- Construct a Variable

| Synopsis |
|:--|
| <span class="ind4">`VAR = DATARRAY(NAME, VALUES, DIMS[, ATTS, DEEP])`</span> |

| Class |
|:--|
| <span class="ind4">Generic function.</span> |

| Description |
|:--|
| <span class="ind4">Construct a `variable_type` from a rank-one through rank-fifteen numeric or character array. `DIMS` are in Fortran order. `DEEP=.true.` (the default) copies `VALUES` into owned storage; `DEEP=.false.` borrows a simply contiguous, named target array. Shallow character arrays are unsupported.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`NAME`</span><span>`character(len=*), INTENT(in)`</span></span><br><span class="ind8">Variable name.</span> |
| <span class="grid"><span>`VALUES`</span><span>`GENERIC, RANK(1:15), INTENT(IN)`</span></span><br><span class="ind8">Values to copy or borrow.</span> |
| <span class="grid"><span>`DIMS`</span><span>`type(dimension_type), DIMENSION(:), INTENT(in)`</span></span><br><span class="ind8">Dimensions matching the array shape.</span> |
| <span class="grid"><span>`ATTS`</span><span>`type(attribute_type), DIMENSION(:), OPTIONAL, INTENT(in)`</span></span><br><span class="ind8">Variable attributes.</span> |
| <span class="grid"><span>`DEEP`</span><span>`logical, OPTIONAL, INTENT(in)`</span></span><br><span class="ind8">Choose owned (`.true.`) or borrowed (`.false.`) storage.</span> |

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
    type(variable_type) :: var
    real, target :: values(3) = [273.15, 274.15, 275.15]

    time = "time" .dim. 3
    var = datarray("temperature", values, [time], &
      & atts=["units".att."K"])
    ```
:::

## `DATASET` -- Construct a Group

| Synopsis |
|:--|
| <span class="ind4">`GRP = DATASET(NAME[, ATTS, DEEP])`</span><br><span class="ind4">`GRP = DATASET(NAME, VARS[, ATTS, DEEP])`</span><br><span class="ind4">`GRP = DATASET(NAME, GRPS[, ATTS, DEEP])`</span><br><span class="ind4">`GRP = DATASET(NAME, VARS, GRPS[, ATTS, DEEP])`</span> |

| Class |
|:--|
| <span class="ind4">Generic function.</span> |

| Description |
|:--|
| <span class="ind4">Construct a `group_type` from a name and optional variables, child groups, and attributes. `DEEP=.false.` (the default) shares referenced model storage; `DEEP=.true.` recursively clones it.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`NAME`</span><span>`character(len=*), INTENT(in)`</span></span><br><span class="ind8">Group name.</span> |
| <span class="grid"><span>`VARS`</span><span>`type(variable_type), DIMENSION(:), INTENT(in)`</span></span><br><span class="ind8">Variables to attach to the group.</span> |
| <span class="grid"><span>`GRPS`</span><span>`type(group_type), DIMENSION(:), INTENT(in)`</span></span><br><span class="ind8">Child groups to attach to the group.</span> |
| <span class="grid"><span>`ATTS`</span><span>`type(attribute_type), DIMENSION(:), OPTIONAL, INTENT(in)`</span></span><br><span class="ind8">Attributes to attach to the group.</span> |
| <span class="grid"><span>`DEEP`</span><span>`logical, OPTIONAL, INTENT(in)`</span></span><br><span class="ind8">Clone supplied model components when true.</span> |

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
    
    type(dimension_type) :: point
    type(variable_type) :: var
    type(group_type) :: root
    real, target :: values(1) = [273.15]

    point = "point" .dim. 1
    var = datarray("temperature", values, [point])
    root = dataset("/", [var], atts=["title".att."Example dataset"])
    ```
:::

## `EXTRACT` -- Access Model Data

| Synopsis |
|:--|
| <span class="ind4">`CALL EXTRACT(ATT, VALUES)`</span><br><span class="ind4">`CALL EXTRACT(VAR, VALUES)`</span> |

| Class |
|:--|
| <span class="ind4">Generic subroutine.</span> |

| Description |
|:--|
| <span class="ind4">Associate a typed Fortran pointer with an attribute or variable's active byte storage. The pointer's type and rank must match the stored NetCDF data and remains valid only while the source storage remains valid.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`ATT`</span><span>`type(attribute_type), TARGET, INTENT(in)`</span></span><br><span class="ind8">Attribute supplying storage.</span> |
| <span class="grid"><span>`VAR`</span><span>`type(variable_type), TARGET, INTENT(in)`</span></span><br><span class="ind8">Variable supplying storage.</span> |
| <span class="grid"><span>`VALUES`</span><span>`GENERIC, POINTER, INTENT(OUT)`</span></span><br><span class="ind8">Type- and rank-compatible pointer receiving the association.</span> |

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
    
    type(dimension_type) :: point
    type(variable_type) :: var
    real, pointer :: values(:)
    real, target :: source(1) = [273.15]

    point = "point" .dim. 1
    var = datarray("temperature", source, [point])
    call extract(var, values)
    values = values + 273.15
    ```
:::

## `GET_ATTRIBUTE` -- Read Attributes

| Synopsis |
|:--|
| <span class="ind4">`ATT = GET_ATTRIBUTE(GRP, NAME[, ERR])`</span><br><span class="ind4">`ATTS = GET_ATTRIBUTE(GRP[, ERR])`</span><br><span class="ind4">`ATT = GET_ATTRIBUTE(GRP, VAR, NAME[, ERR])`</span><br><span class="ind4">`ATTS = GET_ATTRIBUTE(GRP, VAR[, ERR])`</span> |

| Class |
|:--|
| <span class="ind4">Generic function.</span> |

| Description |
|:--|
| <span class="ind4">Read one named global or variable attribute, or all attributes attached to a group or variable.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`GRP`</span><span>`class(group_type), INTENT(in)`</span></span><br><span class="ind8">Containing group.</span> |
| <span class="grid"><span>`VAR`</span><span>`type(variable_type), OPTIONAL, INTENT(in)`</span></span><br><span class="ind8">Variable whose attributes to read.</span> |
| <span class="grid"><span>`NAME`</span><span>`character(len=*), OPTIONAL, INTENT(in)`</span></span><br><span class="ind8">Name of one attribute to read.</span> |
| <span class="grid"><span>`ERR`</span><span>`type(error_type), OPTIONAL, INTENT(out)`</span></span><br><span class="ind8">Receives an operation error.</span> |

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
    
    type(netcdf_type) :: nc
    type(group_type) :: atmosphere
    type(variable_type) :: temperature
    type(attribute_type) :: title, units

    nc = open_netcdf("input.nc")
    atmosphere = get_group(nc, "atmosphere")
    temperature = inquire_variable(atmosphere, "temperature")
    title = get_attribute(nc, "title")
    units = get_attribute(atmosphere, temperature, "units")
    ```
:::

## `GET_GROUP` -- Get a Child Group

| Synopsis |
|:--|
| <span class="ind4">`CHILD = GET_GROUP(PARENT, NAME[, ERR])`</span> |

| Class |
|:--|
| <span class="ind4">Function.</span> |

| Description |
|:--|
| <span class="ind4">Return a direct child group by local name.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`PARENT`</span><span>`class(group_type), INTENT(in)`</span></span><br><span class="ind8">Containing group.</span> |
| <span class="grid"><span>`NAME`</span><span>`character(len=*), INTENT(in)`</span></span><br><span class="ind8">Name of a direct child group.</span> |
| <span class="grid"><span>`ERR`</span><span>`type(error_type), OPTIONAL, INTENT(out)`</span></span><br><span class="ind8">Receives an operation error.</span> |

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
    
    type(netcdf_type) :: nc
    type(group_type) :: atmosphere

    nc = open_netcdf("input.nc")
    atmosphere = get_group(nc, "atmosphere")
    ```
:::

## `GET_VARIABLE` -- Read a Variable

| Synopsis |
|:--|
| <span class="ind4">`VAR = GET_VARIABLE(GRP, NAME[, START, COUNT, STRIDE, ERR])`</span> |

| Class |
|:--|
| <span class="ind4">Function.</span> |

| Description |
|:--|
| <span class="ind4">Read variable metadata and values. `START`, `COUNT`, and `STRIDE` are one-based and in Fortran order. Omitting all reads the complete variable.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`GRP`</span><span>`class(group_type), INTENT(in)`</span></span><br><span class="ind8">Containing group.</span> |
| <span class="grid"><span>`NAME`</span><span>`character(len=*), INTENT(in)`</span></span><br><span class="ind8">Name of the variable to read.</span> |
| <span class="grid"><span>`START`</span><span>`integer, DIMENSION(:), OPTIONAL, INTENT(in)`</span></span><br><span class="ind8">One-based start index for each dimension.</span> |
| <span class="grid"><span>`COUNT`</span><span>`integer, DIMENSION(:), OPTIONAL, INTENT(in)`</span></span><br><span class="ind8">Number of values to read in each dimension.</span> |
| <span class="grid"><span>`STRIDE`</span><span>`integer, DIMENSION(:), OPTIONAL, INTENT(in)`</span></span><br><span class="ind8">Step between values in each dimension.</span> |
| <span class="grid"><span>`ERR`</span><span>`type(error_type), OPTIONAL, INTENT(out)`</span></span><br><span class="ind8">Receives an operation error.</span> |

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
    
    type(netcdf_type) :: nc
    type(variable_type) :: pressure, slice

    nc = open_netcdf("input.nc")
    pressure = get_variable(nc, "P")
    slice = get_variable(nc, "temperature", start=[1, 1], count=[12, 1])
    ```
:::

## `INITIALIZE` -- Allocate Model Storage

| Synopsis |
|:--|
| <span class="ind4">`CALL INITIALIZE(ATT, NAME, DTYPE, LEN)`</span><br><span class="ind4">`CALL INITIALIZE(ATT, NAME, MOLD[, DEEP])`</span><br><span class="ind4">`CALL INITIALIZE(VAR, NAME, DTYPE, LEN, DIMS[, ATTS])`</span><br><span class="ind4">`CALL INITIALIZE(VAR, NAME, MOLD[, ATTS, DEEP])`</span> |

| Class |
|:--|
| <span class="ind4">Generic subroutine.</span> |

| Description |
|:--|
| <span class="ind4">Initialize a writable attribute or variable when values will be supplied later. From-scratch forms always allocate owned storage. Mold forms use the mold's metadata and default to fresh owned storage; `DEEP=.false.` borrows the mold's active storage.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`ATT`</span><span>`type(attribute_type), INTENT(inout)`</span></span><br><span class="ind8">Attribute to initialize.</span> |
| <span class="grid"><span>`VAR`</span><span>`type(variable_type), INTENT(inout)`</span></span><br><span class="ind8">Variable to initialize.</span> |
| <span class="grid"><span>`NAME`</span><span>`character(len=*), INTENT(in)`</span></span><br><span class="ind8">Name for the initialized object.</span> |
| <span class="grid"><span>`DTYPE`</span><span>`integer(data_type), INTENT(in)`</span></span><br><span class="ind8">NetCDF data type for from-scratch initialization.</span> |
| <span class="grid"><span>`LEN`</span><span>`integer(int64), INTENT(in)`</span></span><br><span class="ind8">Element count for from-scratch initialization.</span> |
| <span class="grid"><span>`DIMS`</span><span>`type(dimension_type), DIMENSION(:), INTENT(in)`</span></span><br><span class="ind8">Dimensions for a from-scratch variable.</span> |
| <span class="grid"><span>`MOLD`</span><span>`type(attribute_type) or type(variable_type), INTENT(in)`</span></span><br><span class="ind8">Object supplying metadata and, optionally, storage.</span> |
| <span class="grid"><span>`ATTS`</span><span>`type(attribute_type), DIMENSION(:), OPTIONAL, INTENT(in)`</span></span><br><span class="ind8">Attributes to attach to an initialized variable.</span> |
| <span class="grid"><span>`DEEP`</span><span>`logical, OPTIONAL, INTENT(in)`</span></span><br><span class="ind8">Allocate fresh mold storage when true, or borrow it when false.</span> |

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
    
    type(variable_type) :: total, output
    real, pointer :: total_values(:), output_values(:)

    call initialize(output, "mean_pressure", mold=total)
    call extract(output, output_values)
    output_values = 0.5 * total_values
    ```
:::

## `INQUIRE_DIMENSIONS` -- Get Dimensions

| Synopsis |
|:--|
| <span class="ind4">`DIMS = INQUIRE_DIMENSIONS(GRP[, ERR])`</span><br><span class="ind4">`DIMS = INQUIRE_DIMENSIONS(GRP, VAR[, ERR])`</span> |

| Class |
|:--|
| <span class="ind4">Generic function.</span> |

| Description |
|:--|
| <span class="ind4">Return an allocatable array of a group's dimensions or the dimensions attached to a variable, ordered for Fortran use.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`GRP`</span><span>`class(group_type), INTENT(in)`</span></span><br><span class="ind8">Dataset or group to inspect.</span> |
| <span class="grid"><span>`VAR`</span><span>`type(variable_type), OPTIONAL, INTENT(in)`</span></span><br><span class="ind8">Variable whose dimensions to return.</span> |
| <span class="grid"><span>`ERR`</span><span>`type(error_type), OPTIONAL, INTENT(out)`</span></span><br><span class="ind8">Receives an operation error.</span> |

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
    
    type(netcdf_type) :: nc
    type(variable_type) :: temperature
    type(dimension_type), allocatable :: dims(:), variable_dims(:)

    nc = open_netcdf("input.nc")
    temperature = inquire_variable(nc, "temperature")
    dims = inquire_dimensions(nc)
    variable_dims = inquire_dimensions(nc, temperature)
    ```
:::

## `INQUIRE_GROUP` -- Materialize Group Metadata

| Synopsis |
|:--|
| <span class="ind4">`CALL INQUIRE_GROUP(GRP[, INQ_DIMS, INQ_ATTS, INQ_VARS, INQ_SUBGRPS, RECURSIVE, ERR])`</span> |

| Class |
|:--|
| <span class="ind4">Subroutine.</span> |

| Description |
|:--|
| <span class="ind4">Materialize selected local metadata in place. The `INQ_*` flags default to `.true.`; `RECURSIVE` defaults to `.false.` and, when true, recursively materializes child groups.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`GRP`</span><span>`class(group_type), INTENT(inout)`</span></span><br><span class="ind8">Group receiving materialized metadata.</span> |
| <span class="grid"><span>`INQ_DIMS`</span><span>`logical, OPTIONAL, INTENT(in)`</span></span><br><span class="ind8">Whether to inquire dimensions.</span> |
| <span class="grid"><span>`INQ_ATTS`</span><span>`logical, OPTIONAL, INTENT(in)`</span></span><br><span class="ind8">Whether to inquire attributes.</span> |
| <span class="grid"><span>`INQ_VARS`</span><span>`logical, OPTIONAL, INTENT(in)`</span></span><br><span class="ind8">Whether to inquire variables.</span> |
| <span class="grid"><span>`INQ_SUBGRPS`</span><span>`logical, OPTIONAL, INTENT(in)`</span></span><br><span class="ind8">Whether to inquire direct child groups.</span> |
| <span class="grid"><span>`RECURSIVE`</span><span>`logical, OPTIONAL, INTENT(in)`</span></span><br><span class="ind8">Whether to recurse into child groups.</span> |
| <span class="grid"><span>`ERR`</span><span>`type(error_type), OPTIONAL, INTENT(out)`</span></span><br><span class="ind8">Receives an operation error.</span> |

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
    
    type(group_type) :: atmosphere

    call inquire_group(atmosphere, inq_dims=.true., inq_atts=.true., &
      & inq_vars=.true., inq_subgrps=.true., recursive=.true.)
    ```
:::

## `INQUIRE_SUBGROUPS` -- List Child Groups

| Synopsis |
|:--|
| <span class="ind4">`CHILDREN = INQUIRE_SUBGROUPS(PARENT[, ERR])`</span> |

| Class |
|:--|
| <span class="ind4">Function.</span> |

| Description |
|:--|
| <span class="ind4">Return an allocatable array of direct child groups with identifiers and names populated.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`PARENT`</span><span>`class(group_type), INTENT(in)`</span></span><br><span class="ind8">Group to inspect.</span> |
| <span class="grid"><span>`ERR`</span><span>`type(error_type), OPTIONAL, INTENT(out)`</span></span><br><span class="ind8">Receives an operation error.</span> |

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
    
    type(netcdf_type) :: nc
    type(group_type), allocatable :: children(:)

    nc = open_netcdf("input.nc")
    children = inquire_subgroups(nc)
    ```
:::

## `INQUIRE_VARIABLE` -- Read Variable Metadata

| Synopsis |
|:--|
| <span class="ind4">`VAR = INQUIRE_VARIABLE(GRP, NAME[, ERR])`</span> |

| Class |
|:--|
| <span class="ind4">Function.</span> |

| Description |
|:--|
| <span class="ind4">Return a variable's metadata, including dimensions and attributes, without reading its data buffer.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`GRP`</span><span>`class(group_type), INTENT(in)`</span></span><br><span class="ind8">Containing group.</span> |
| <span class="grid"><span>`NAME`</span><span>`character(len=*), INTENT(in)`</span></span><br><span class="ind8">Name of the variable to inspect.</span> |
| <span class="grid"><span>`ERR`</span><span>`type(error_type), OPTIONAL, INTENT(out)`</span></span><br><span class="ind8">Receives an operation error.</span> |

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
    
    type(group_type) :: atmosphere
    type(variable_type) :: temperature

    temperature = inquire_variable(atmosphere, "temperature")
    ```
:::

## `OPEN_NETCDF` -- Open a NetCDF File

| Synopsis |
|:--|
| <span class="ind4">`NC = OPEN_NETCDF(FILE[, MODE, ERR])`</span> |

| Class |
|:--|
| <span class="ind4">Function.</span> |

| Description |
|:--|
| <span class="ind4">Open or create a NetCDF dataset. `MODE` accepts `"r"`/`"read"` (default), `"w"`/`"write"`/`"replace"`, and `"a"`/`"append"`/`"rw"`.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`FILE`</span><span>`character(len=*), INTENT(in)`</span></span><br><span class="ind8">Path of the dataset to open or create.</span> |
| <span class="grid"><span>`MODE`</span><span>`character(len=*), OPTIONAL, INTENT(in)`</span></span><br><span class="ind8">Requested file access mode.</span> |
| <span class="grid"><span>`ERR`</span><span>`type(error_type), OPTIONAL, INTENT(out)`</span></span><br><span class="ind8">Receives an operation error.</span> |

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
    
    type(netcdf_type) :: nc

    nc = open_netcdf("input.nc", mode="r")
    ```
:::

## `SHAPE` -- Get Variable Extents

| Synopsis |
|:--|
| <span class="ind4">`EXTENTS = SHAPE(VAR)`</span> |

| Class |
|:--|
| <span class="ind4">Function.</span> |

| Description |
|:--|
| <span class="ind4">Return allocatable default-integer dimension extents in Fortran order.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`VAR`</span><span>`type(variable_type), INTENT(in)`</span></span><br><span class="ind8">Variable to inspect.</span> |

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
    
    type(variable_type) :: var
    integer, allocatable :: extents(:)

    extents = shape(var)
    ```
:::

## `SIZE` -- Get Element Count

| Synopsis |
|:--|
| <span class="ind4">`N = SIZE(VAR[, DIM])`</span> |

| Class |
|:--|
| <span class="ind4">Function.</span> |

| Description |
|:--|
| <span class="ind4">Return the total element count as `integer(int64)`, or the one-based Fortran-order length of `DIM`.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`VAR`</span><span>`type(variable_type), INTENT(in)`</span></span><br><span class="ind8">Variable to inspect.</span> |
| <span class="grid"><span>`DIM`</span><span>`integer, OPTIONAL, INTENT(in)`</span></span><br><span class="ind8">One-based Fortran-order dimension to select.</span> |

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
    
    type(variable_type) :: var
    integer(int64) :: elements

    elements = size(var)
    print *, size(var), size(var, dim=1)
    ```
:::

## `SUM` -- Add Compatible Variables

| Synopsis |
|:--|
| <span class="ind4">`TOTAL = SUM(VARS)`</span> |

| Class |
|:--|
| <span class="ind4">Function.</span> |

| Description |
|:--|
| <span class="ind4">Return the element-wise sum of a rank-one array of compatible, materialized variables. The result uses the first variable's metadata.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`VARS`</span><span>`type(variable_type), DIMENSION(:), INTENT(in)`</span></span><br><span class="ind8">Compatible variables with materialized data.</span> |

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

## `TO_NETCDF` -- Write a NetCDF File

| Synopsis |
|:--|
| <span class="ind4">`CALL TO_NETCDF(FILE, VARS[, ATTS, ERR])`</span><br><span class="ind4">`CALL TO_NETCDF(FILE, GRP[, ATTS, ERR])`</span> |

| Class |
|:--|
| <span class="ind4">Generic subroutine.</span> |

| Description |
|:--|
| <span class="ind4">Write a scalar or rank-one array of variables, or a scalar or rank-one array of groups. A scalar group becomes the file root and its name is ignored. A group array becomes direct children of a new root; no first-level group may be named `/`.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`FILE`</span><span>`character(len=*), INTENT(in)`</span></span><br><span class="ind8">Path of the output file.</span> |
| <span class="grid"><span>`VARS`</span><span>`type(variable_type), scalar or dimension(:), INTENT(in)`</span></span><br><span class="ind8">Variables to write.</span> |
| <span class="grid"><span>`GRP`</span><span>`type(group_type), scalar or dimension(:), INTENT(in)`</span></span><br><span class="ind8">Group model to write.</span> |
| <span class="grid"><span>`ATTS`</span><span>`type(attribute_type), DIMENSION(:), OPTIONAL, INTENT(in)`</span></span><br><span class="ind8">Root attributes when writing variables or groups.</span> |
| <span class="grid"><span>`ERR`</span><span>`type(error_type), OPTIONAL, INTENT(out)`</span></span><br><span class="ind8">Receives an operation error.</span> |

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
    
    type(group_type) :: root
    type(attribute_type) :: title

    title = "title" .att. "Output"
    call to_netcdf("output.nc", root, atts=[title])
    ```
:::

