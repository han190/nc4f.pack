# Functions and Subroutines

This page documents the public procedures re-exported by `nc4f`. Optional
`err` arguments receive an `error_type`; when omitted, an operation failure
follows the library's fail-fast policy. See [Exposed NC
Constants](exposed-nc-constants.md) for constants used with `error_type`.


## `ERROR_MSG` -- Format an Operation Result

| Synopsis |
|:--|
| <span class="ind3">`TEXT = ERROR_MSG(ERR)`</span> |

| Class |
|:--|
| <span class="ind3">Pure function.</span> |

| Description |
|:--|
| <span class="ind3">Return `[fname] msg` on failure or `No error` on success, without printing. Failure fields must be allocated and nonblank; malformed failures cause `error stop`.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`ERR`</span><span>`class(error_type), INTENT(in)`</span></span><br><span class="ind6">Operation result to validate and format.</span> |

| Result |
|:--|
| <span class="grid"><span>`TEXT`</span><span>`character(len=:), allocatable`</span></span><br><span class="ind6">Complete diagnostic, with trailing field padding removed.</span> |

```fortran
if (.exists. err) print '(a)', error_msg(err)
```

## `CLOSE_NETCDF` -- Close a NetCDF File

| Synopsis |
|:--|
| <span class="ind3">`CALL CLOSE_NETCDF(NC[, ERR])`</span> |

| Class |
|:--|
| <span class="ind3">Subroutine.</span> |

| Description |
|:--|
| <span class="ind3">Close an open dataset and release its allocated model metadata.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`NC`</span><span>`type(netcdf_type), INTENT(inout)`</span></span><br><span class="ind6">Open dataset to close.</span> |
| <span class="grid"><span>`ERR`</span><span>`type(error_type), OPTIONAL, INTENT(out)`</span></span><br><span class="ind6">Receives an operation error.</span> |

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
| <span class="ind3">`VAR = DATARRAY(NAME, VALUES, DIMS[, ATTS, DEEP])`</span> |

| Class |
|:--|
| <span class="ind3">Generic function.</span> |

| Description |
|:--|
| <span class="ind3">Construct a `variable_type` from a rank-one through rank-fifteen numeric or character array. `DIMS` are in Fortran order. `DEEP=.true.` (the default) copies `VALUES` into owned storage; `DEEP=.false.` borrows a simply contiguous, named target array. Shallow character arrays are unsupported.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`NAME`</span><span>`character(len=*), INTENT(in)`</span></span><br><span class="ind6">Variable name.</span> |
| <span class="grid"><span>`VALUES`</span><span>`TYPE(INTEGER(INT8, INT16, INT32, INT64), REAL(REAL32, REAL64), CHARACTER), RANK(1:15), INTENT(IN)`</span></span><br><span class="ind6">Values to copy or borrow.</span> |
| <span class="grid"><span>`DIMS`</span><span>`type(dimension_type), DIMENSION(:), INTENT(in)`</span></span><br><span class="ind6">Dimensions matching the array shape.</span> |
| <span class="grid"><span>`ATTS`</span><span>`type(attribute_type), DIMENSION(:), OPTIONAL, INTENT(in)`</span></span><br><span class="ind6">Variable attributes.</span> |
| <span class="grid"><span>`DEEP`</span><span>`logical, OPTIONAL, INTENT(in)`</span></span><br><span class="ind6">Choose owned (`.true.`) or borrowed (`.false.`) storage.</span> |

| Return |
|:--|
| <span class="grid"><span>`VAR`</span><span>`type(variable_type)`</span></span><br><span class="ind6">Constructed variable.</span> |

:::{list-table}
:class: example-table
:header-rows: 1

*
  - Example
*
  -
    ```fortran
    program main

      use, non_intrinsic :: nc4f
      implicit none (type, external)

      type(dimension_type) :: lon, lat, tme
      type(variable_type) :: var
      logical, parameter :: UNLIMITED = .true.
      real, allocatable, target :: values(:, :, :)
      integer :: nlon, nlat, ntme, i, j, k

      nlon = 360
      nlat = 181
      ntme = 24

      allocate (values(ntme, nlat, nlon))
      do concurrent (i = 1:ntme, j = 1:nlat, k = 1:nlon)
        values(i, j, k) = 0. !> Dummy values
      end do

      var = datarray("temperature", values,                 &
        dims=["time" .dim. (ntme .and. UNLIMITED),          &
              "latitude" .dim. nlat,                        &
              "longitude" .dim. nlon],                      &
        atts=["units" .att. "K",                            &
              "description" .att. "Temperature in Kelvin",  &
              "missing value" .att. -1],                    &
        deep=.false.)

      print *, var
      call to_netcdf("var.nc", var)

    end program main
    ```
:::

## `DATASET` -- Construct a Group

| Synopsis |
|:--|
| <span class="ind3">`GRP = DATASET(NAME[, ATTS, DEEP])`</span><br><span class="ind3">`GRP = DATASET(NAME, VARS[, ATTS, DEEP])`</span><br><span class="ind3">`GRP = DATASET(NAME, GRPS[, ATTS, DEEP])`</span><br><span class="ind3">`GRP = DATASET(NAME, VARS, GRPS[, ATTS, DEEP])`</span> |

| Class |
|:--|
| <span class="ind3">Generic function.</span> |

| Description |
|:--|
| <span class="ind3">Construct a `group_type` from a name and optional variables, child groups, and attributes. `DEEP=.false.` (the default) shares referenced model storage; `DEEP=.true.` recursively clones it.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`NAME`</span><span>`character(len=*), INTENT(in)`</span></span><br><span class="ind6">Group name.</span> |
| <span class="grid"><span>`VARS`</span><span>`type(variable_type), DIMENSION(:), INTENT(in)`</span></span><br><span class="ind6">Variables to attach to the group.</span> |
| <span class="grid"><span>`GRPS`</span><span>`type(group_type), DIMENSION(:), INTENT(in)`</span></span><br><span class="ind6">Child groups to attach to the group.</span> |
| <span class="grid"><span>`ATTS`</span><span>`type(attribute_type), DIMENSION(:), OPTIONAL, INTENT(in)`</span></span><br><span class="ind6">Attributes to attach to the group.</span> |
| <span class="grid"><span>`DEEP`</span><span>`logical, OPTIONAL, INTENT(in)`</span></span><br><span class="ind6">Clone supplied model components when true.</span> |

| Return |
|:--|
| <span class="grid"><span>`GRP`</span><span>`type(group_type)`</span></span><br><span class="ind6">Constructed group.</span> |

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
| <span class="ind3">`CALL EXTRACT(ATT, VALUES)`</span><br><span class="ind3">`CALL EXTRACT(VAR, VALUES)`</span> |

| Class |
|:--|
| <span class="ind3">Generic subroutine.</span> |

| Description |
|:--|
| <span class="ind3">Associate a typed Fortran pointer with an attribute or variable's active byte storage. The pointer's type and rank must match the stored NetCDF data and remains valid only while the source storage remains valid.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`ATT`</span><span>`type(attribute_type), TARGET, INTENT(in)`</span></span><br><span class="ind6">Attribute supplying storage.</span> |
| <span class="grid"><span>`VAR`</span><span>`type(variable_type), TARGET, INTENT(in)`</span></span><br><span class="ind6">Variable supplying storage.</span> |
| <span class="grid"><span>`VALUES`</span><span>`TYPE(INTEGER(INT8, INT16, INT32, INT64), REAL(REAL32, REAL64), CHARACTER), RANK(0:15), POINTER, INTENT(OUT)`</span></span><br><span class="ind6">Type- and rank-compatible pointer receiving the association.</span> |

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
| <span class="ind3">`ATT = GET_ATTRIBUTE(GRP, NAME[, ERR])`</span><br><span class="ind3">`ATTS = GET_ATTRIBUTE(GRP[, ERR])`</span><br><span class="ind3">`ATT = GET_ATTRIBUTE(GRP, VAR, NAME[, ERR])`</span><br><span class="ind3">`ATTS = GET_ATTRIBUTE(GRP, VAR[, ERR])`</span> |

| Class |
|:--|
| <span class="ind3">Generic function.</span> |

| Description |
|:--|
| <span class="ind3">Read one named global or variable attribute, or all attributes attached to a group or variable.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`GRP`</span><span>`class(group_type), INTENT(in)`</span></span><br><span class="ind6">Containing group.</span> |
| <span class="grid"><span>`VAR`</span><span>`type(variable_type), OPTIONAL, INTENT(in)`</span></span><br><span class="ind6">Variable whose attributes to read.</span> |
| <span class="grid"><span>`NAME`</span><span>`character(len=*), OPTIONAL, INTENT(in)`</span></span><br><span class="ind6">Name of one attribute to read.</span> |
| <span class="grid"><span>`ERR`</span><span>`type(error_type), OPTIONAL, INTENT(out)`</span></span><br><span class="ind6">Receives an operation error.</span> |

| Return |
|:--|
| <span class="grid"><span>`ATT`</span><span>`type(attribute_type)`</span></span><br><span class="ind6">Requested attribute.</span><br><span class="grid"><span>`ATTS`</span><span>`type(attribute_type), allocatable`</span></span><br><span class="ind6">Attributes attached to the requested group or variable.</span> |

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
| <span class="ind3">`CHILD = GET_GROUP(PARENT, NAME[, ERR])`</span> |

| Class |
|:--|
| <span class="ind3">Function.</span> |

| Description |
|:--|
| <span class="ind3">Return a direct child group by local name.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`PARENT`</span><span>`class(group_type), INTENT(in)`</span></span><br><span class="ind6">Containing group.</span> |
| <span class="grid"><span>`NAME`</span><span>`character(len=*), INTENT(in)`</span></span><br><span class="ind6">Name of a direct child group.</span> |
| <span class="grid"><span>`ERR`</span><span>`type(error_type), OPTIONAL, INTENT(out)`</span></span><br><span class="ind6">Receives an operation error.</span> |

| Return |
|:--|
| <span class="grid"><span>`CHILD`</span><span>`type(group_type)`</span></span><br><span class="ind6">Matching direct child group.</span> |

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
| <span class="ind3">`VAR = GET_VARIABLE(GRP, NAME[, START, COUNT, STRIDE, ERR])`</span> |

| Class |
|:--|
| <span class="ind3">Function.</span> |

| Description |
|:--|
| <span class="ind3">Read variable metadata and values. `START`, `COUNT`, and `STRIDE` are one-based and in Fortran order. Omitting all reads the complete variable.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`GRP`</span><span>`class(group_type), INTENT(in)`</span></span><br><span class="ind6">Containing group.</span> |
| <span class="grid"><span>`NAME`</span><span>`character(len=*), INTENT(in)`</span></span><br><span class="ind6">Name of the variable to read.</span> |
| <span class="grid"><span>`START`</span><span>`integer, DIMENSION(:), OPTIONAL, INTENT(in)`</span></span><br><span class="ind6">One-based start index for each dimension.</span> |
| <span class="grid"><span>`COUNT`</span><span>`integer, DIMENSION(:), OPTIONAL, INTENT(in)`</span></span><br><span class="ind6">Number of values to read in each dimension.</span> |
| <span class="grid"><span>`STRIDE`</span><span>`integer, DIMENSION(:), OPTIONAL, INTENT(in)`</span></span><br><span class="ind6">Step between values in each dimension.</span> |
| <span class="grid"><span>`ERR`</span><span>`type(error_type), OPTIONAL, INTENT(out)`</span></span><br><span class="ind6">Receives an operation error.</span> |

| Return |
|:--|
| <span class="grid"><span>`VAR`</span><span>`type(variable_type)`</span></span><br><span class="ind6">Requested variable and its selected data.</span> |

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
| <span class="ind3">`CALL INITIALIZE(ATT, NAME, DTYPE, LEN)`</span><br><span class="ind3">`CALL INITIALIZE(ATT, NAME, MOLD[, DEEP])`</span><br><span class="ind3">`CALL INITIALIZE(VAR, NAME, DTYPE, LEN, DIMS[, ATTS])`</span><br><span class="ind3">`CALL INITIALIZE(VAR, NAME, MOLD[, ATTS, DEEP])`</span> |

| Class |
|:--|
| <span class="ind3">Generic subroutine.</span> |

| Description |
|:--|
| <span class="ind3">Initialize a writable attribute or variable when values will be supplied later. From-scratch forms always allocate owned storage. Mold forms use the mold's metadata and default to fresh owned storage; `DEEP=.false.` borrows the mold's active storage.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`ATT`</span><span>`type(attribute_type), INTENT(inout)`</span></span><br><span class="ind6">Attribute to initialize.</span> |
| <span class="grid"><span>`VAR`</span><span>`type(variable_type), INTENT(inout)`</span></span><br><span class="ind6">Variable to initialize.</span> |
| <span class="grid"><span>`NAME`</span><span>`character(len=*), INTENT(in)`</span></span><br><span class="ind6">Name for the initialized object.</span> |
| <span class="grid"><span>`DTYPE`</span><span>`integer(data_type), INTENT(in)`</span></span><br><span class="ind6">NetCDF data type for from-scratch initialization.</span> |
| <span class="grid"><span>`LEN`</span><span>`integer(int64), INTENT(in)`</span></span><br><span class="ind6">Element count for from-scratch initialization.</span> |
| <span class="grid"><span>`DIMS`</span><span>`type(dimension_type), DIMENSION(:), INTENT(in)`</span></span><br><span class="ind6">Dimensions for a from-scratch variable.</span> |
| <span class="grid"><span>`MOLD`</span><span>`type(attribute_type) or type(variable_type), INTENT(in)`</span></span><br><span class="ind6">Object supplying metadata and, optionally, storage.</span> |
| <span class="grid"><span>`ATTS`</span><span>`type(attribute_type), DIMENSION(:), OPTIONAL, INTENT(in)`</span></span><br><span class="ind6">Attributes to attach to an initialized variable.</span> |
| <span class="grid"><span>`DEEP`</span><span>`logical, OPTIONAL, INTENT(in)`</span></span><br><span class="ind6">Allocate fresh mold storage when true, or borrow it when false.</span> |

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
| <span class="ind3">`DIMS = INQUIRE_DIMENSIONS(GRP[, ERR])`</span><br><span class="ind3">`DIMS = INQUIRE_DIMENSIONS(GRP, VAR[, ERR])`</span> |

| Class |
|:--|
| <span class="ind3">Generic function.</span> |

| Description |
|:--|
| <span class="ind3">Return an allocatable array of a group's dimensions or the dimensions attached to a variable, ordered for Fortran use.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`GRP`</span><span>`class(group_type), INTENT(in)`</span></span><br><span class="ind6">Dataset or group to inspect.</span> |
| <span class="grid"><span>`VAR`</span><span>`type(variable_type), OPTIONAL, INTENT(in)`</span></span><br><span class="ind6">Variable whose dimensions to return.</span> |
| <span class="grid"><span>`ERR`</span><span>`type(error_type), OPTIONAL, INTENT(out)`</span></span><br><span class="ind6">Receives an operation error.</span> |

| Return |
|:--|
| <span class="grid"><span>`DIMS`</span><span>`type(dimension_type), allocatable`</span></span><br><span class="ind6">Dimensions attached to the requested group or variable.</span> |

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
| <span class="ind3">`CALL INQUIRE_GROUP(GRP[, INQ_DIMS, INQ_ATTS, INQ_VARS, INQ_GRPS, RECUR, ERR])`</span> |

| Class |
|:--|
| <span class="ind3">Subroutine.</span> |

| Description |
|:--|
| <span class="ind3">Materialize selected local metadata in place. The `INQ_*` flags default to `.true.`; `RECUR` defaults to `.false.` and, when true, recursively materializes child groups.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`GRP`</span><span>`class(group_type), INTENT(inout)`</span></span><br><span class="ind6">Group receiving materialized metadata.</span> |
| <span class="grid"><span>`INQ_DIMS`</span><span>`logical, OPTIONAL, INTENT(in)`</span></span><br><span class="ind6">Whether to inquire dimensions.</span> |
| <span class="grid"><span>`INQ_ATTS`</span><span>`logical, OPTIONAL, INTENT(in)`</span></span><br><span class="ind6">Whether to inquire attributes.</span> |
| <span class="grid"><span>`INQ_VARS`</span><span>`logical, OPTIONAL, INTENT(in)`</span></span><br><span class="ind6">Whether to inquire variables.</span> |
| <span class="grid"><span>`INQ_GRPS`</span><span>`logical, OPTIONAL, INTENT(in)`</span></span><br><span class="ind6">Whether to inquire direct child groups.</span> |
| <span class="grid"><span>`RECUR`</span><span>`logical, OPTIONAL, INTENT(in)`</span></span><br><span class="ind6">Whether to recurse into child groups.</span> |
| <span class="grid"><span>`ERR`</span><span>`type(error_type), OPTIONAL, INTENT(out)`</span></span><br><span class="ind6">Receives an operation error.</span> |

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
      & inq_vars=.true., inq_grps=.true., recur=.true.)
    ```
:::

## `INQUIRE_SUBGROUPS` -- List Child Groups

| Synopsis |
|:--|
| <span class="ind3">`CHILDREN = INQUIRE_SUBGROUPS(PARENT[, ERR])`</span> |

| Class |
|:--|
| <span class="ind3">Function.</span> |

| Description |
|:--|
| <span class="ind3">Return an allocatable array of direct child groups with identifiers and names populated.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`PARENT`</span><span>`class(group_type), INTENT(in)`</span></span><br><span class="ind6">Group to inspect.</span> |
| <span class="grid"><span>`ERR`</span><span>`type(error_type), OPTIONAL, INTENT(out)`</span></span><br><span class="ind6">Receives an operation error.</span> |

| Return |
|:--|
| <span class="grid"><span>`CHILDREN`</span><span>`type(group_type), allocatable`</span></span><br><span class="ind6">Direct child groups with populated identifiers and names.</span> |

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
| <span class="ind3">`VAR = INQUIRE_VARIABLE(GRP, NAME[, ERR])`</span> |

| Class |
|:--|
| <span class="ind3">Function.</span> |

| Description |
|:--|
| <span class="ind3">Return a variable's metadata, including dimensions and attributes, without reading its data buffer.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`GRP`</span><span>`class(group_type), INTENT(in)`</span></span><br><span class="ind6">Containing group.</span> |
| <span class="grid"><span>`NAME`</span><span>`character(len=*), INTENT(in)`</span></span><br><span class="ind6">Name of the variable to inspect.</span> |
| <span class="grid"><span>`ERR`</span><span>`type(error_type), OPTIONAL, INTENT(out)`</span></span><br><span class="ind6">Receives an operation error.</span> |

| Return |
|:--|
| <span class="grid"><span>`VAR`</span><span>`type(variable_type)`</span></span><br><span class="ind6">Requested variable metadata.</span> |

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
| <span class="ind3">`NC = OPEN_NETCDF(FILE[, MODE, ERR])`</span> |

| Class |
|:--|
| <span class="ind3">Function.</span> |

| Description |
|:--|
| <span class="ind3">Open or create a NetCDF dataset. `MODE` accepts `"r"`/`"read"` (default), `"w"`/`"write"`/`"replace"`, and `"a"`/`"append"`/`"rw"`.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`FILE`</span><span>`character(len=*), INTENT(in)`</span></span><br><span class="ind6">Path of the dataset to open or create.</span> |
| <span class="grid"><span>`MODE`</span><span>`character(len=*), OPTIONAL, INTENT(in)`</span></span><br><span class="ind6">Requested file access mode.</span> |
| <span class="grid"><span>`ERR`</span><span>`type(error_type), OPTIONAL, INTENT(out)`</span></span><br><span class="ind6">Receives an operation error.</span> |

| Return |
|:--|
| <span class="grid"><span>`NC`</span><span>`type(netcdf_type)`</span></span><br><span class="ind6">Opened or created NetCDF dataset.</span> |

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

## `RENAME_ATTRIBUTE` -- Rename an Attribute

| Synopsis |
|:--|
| <span class="ind3">`CALL RENAME_ATTRIBUTE(ATT, NEW_NAME[, ERR])`</span> |
| <span class="ind3">`CALL RENAME_ATTRIBUTE(VAR, OLD_NAME, NEW_NAME[, ERR])`</span> |
| <span class="ind3">`CALL RENAME_ATTRIBUTE(GRP, OLD_NAME, NEW_NAME[, ERR])`</span> |
| <span class="ind3">`CALL RENAME_ATTRIBUTE(GRP, VAR, OLD_NAME, NEW_NAME[, UPDATE_FILE, ERR])`</span> |
| <span class="ind3">`CALL RENAME_ATTRIBUTE(GRP, OLD_NAME, NEW_NAME, UPDATE_FILE[, ERR])`</span> |

| Class |
|:--|
| <span class="ind3">Generic subroutine.</span> |

| Description |
|:--|
| <span class="ind3">The first three forms are pure, in-memory attribute renames that preserve all other data, while the last two are impure and optionally update a file via UPDATE_FILE, which defaults to .false. for the variable form and is required for the group form; GRP also accepts netcdf_type, and standalone attributes have no collection for collision checks.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`ATT`</span><span>`type(attribute_type), INTENT(inout)`</span></span><br><span class="ind6">Independent attribute to rename.</span> |
| <span class="grid"><span>`VAR`</span><span>`type(variable_type), INTENT(inout)`</span></span><br><span class="ind6">Variable whose attribute is renamed.</span> |
| <span class="grid"><span>`GRP`</span><span>`class(group_type)`</span></span><br><span class="ind6">Group/global attribute owner (`INTENT(inout)`), or file context for `VAR` (`INTENT(in)`).</span> |
| <span class="grid"><span>`OLD_NAME`</span><span>`character(len=*), INTENT(in)`</span></span><br><span class="ind6">Existing attribute name.</span> |
| <span class="grid"><span>`NEW_NAME`</span><span>`character(len=*), INTENT(in)`</span></span><br><span class="ind6">Replacement attribute name.</span> |
| <span class="grid"><span>`UPDATE_FILE`</span><span>`logical, INTENT(in)`</span></span><br><span class="ind6">Explicitly request a file update when true.</span> |
| <span class="grid"><span>`ERR`</span><span>`type(error_type), OPTIONAL, INTENT(out)`</span></span><br><span class="ind6">Receives the error; failure stops execution when omitted.</span> |

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
    type(variable_type) :: var

    var = datarray("temperature", [273.15], ["point".dim.1], &
      & atts=["longname".att."Temperature"])
    call rename_attribute(var, "longname", "long_name")
    call to_netcdf("temperature.nc", var, atts=["title".att."Example"])

    nc = open_netcdf("temperature.nc", "a")
    var = inquire_variable(nc, "temperature")
    call rename_attribute(nc, var, "long_name", "description", update_file=.true.)
    call rename_attribute(nc, "title", "heading", update_file=.true.)
    call close_netcdf(nc)
    ```
:::

## `DELETE_ATTRIBUTE` -- Delete an Attribute

| Synopsis |
|:--|
| <span class="ind3">`CALL DELETE_ATTRIBUTE(VAR, NAME[, ERR])`</span> |
| <span class="ind3">`CALL DELETE_ATTRIBUTE(GRP, NAME[, ERR])`</span> |
| <span class="ind3">`CALL DELETE_ATTRIBUTE(GRP, VAR, NAME[, UPDATE_FILE, ERR])`</span> |
| <span class="ind3">`CALL DELETE_ATTRIBUTE(GRP, NAME, UPDATE_FILE[, ERR])`</span> |

| Class |
|:--|
| <span class="ind3">Generic subroutine.</span> |

| Description |
|:--|
| <span class="ind3">Remove a variable or group attribute using pure model-only forms or impure file-capable forms controlled by `UPDATE_FILE`, which defaults to `.false.` for the variable form and is required for the group form; `GRP` also accepts `netcdf_type`, and standalone attributes cannot be reset.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`VAR`</span><span>`type(variable_type), INTENT(inout)`</span></span><br><span class="ind6">Variable whose attribute is deleted, or the variable context for `GRP`.</span> |
| <span class="grid"><span>`GRP`</span><span>`class(group_type)`</span></span><br><span class="ind6">Group/global attribute owner (`INTENT(inout)`), or file context for `VAR` (`INTENT(in)`).</span> |
| <span class="grid"><span>`NAME`</span><span>`character(len=*), INTENT(in)`</span></span><br><span class="ind6">Name of the attribute to delete.</span> |
| <span class="grid"><span>`UPDATE_FILE`</span><span>`logical, INTENT(in)`</span></span><br><span class="ind6">Explicitly request a file update when true.</span> |
| <span class="grid"><span>`ERR`</span><span>`type(error_type), OPTIONAL, INTENT(out)`</span></span><br><span class="ind6">Receives the error; failure stops execution when omitted.</span> |

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
    type(variable_type) :: var

    var = datarray("temperature", [273.15], ["point".dim.1], &
      & atts=["comment".att."Draft"])
    call delete_attribute(var, "comment")

    nc = open_netcdf("temperature.nc", "a")
    var = get_variable(nc, "temperature")
    call delete_attribute(nc, var, "comment", update_file=.true.)
    call delete_attribute(nc, "history", update_file=.true.)
    call close_netcdf(nc)
    ```
:::

## `RENAME_DIMENSION` -- Rename a Dimension

| Synopsis |
|:--|
| <span class="ind3">`CALL RENAME_DIMENSION(DIM, NEW_NAME[, ERR])`</span> |
| <span class="ind3">`CALL RENAME_DIMENSION(VAR, OLD_NAME, NEW_NAME[, ERR])`</span> |
| <span class="ind3">`CALL RENAME_DIMENSION(GRP, OLD_NAME, NEW_NAME[, ERR])`</span> |
| <span class="ind3">`CALL RENAME_DIMENSION(GRP, DIM, NEW_NAME[, UPDATE_FILE, ERR])`</span> |
| <span class="ind3">`CALL RENAME_DIMENSION(GRP, OLD_NAME, NEW_NAME, UPDATE_FILE[, ERR])`</span> |

| Class |
|:--|
| <span class="ind3">Generic subroutine.</span> |

| Description |
|:--|
| <span class="ind3">Rename a standalone dimension, matching variable dimensions, or a group's local dimension and direct variable references using pure model-only forms or impure file-capable forms controlled by `UPDATE_FILE`, which defaults to `.false.` for the dimension-object form and is required for the group/name form; `GRP` also accepts `netcdf_type`.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`DIM`</span><span>`type(dimension_type), INTENT(inout)`</span></span><br><span class="ind6">Dimension whose name is changed, or the dimension context for `GRP`.</span> |
| <span class="grid"><span>`VAR`</span><span>`type(variable_type), INTENT(inout)`</span></span><br><span class="ind6">Variable whose matching dimensions are renamed.</span> |
| <span class="grid"><span>`GRP`</span><span>`class(group_type)`</span></span><br><span class="ind6">Dimension owner (`INTENT(inout)`), or file context for `DIM` (`INTENT(in)`).</span> |
| <span class="grid"><span>`OLD_NAME`</span><span>`character(len=*), INTENT(in)`</span></span><br><span class="ind6">Existing dimension name.</span> |
| <span class="grid"><span>`NEW_NAME`</span><span>`character(len=*), INTENT(in)`</span></span><br><span class="ind6">Replacement dimension name.</span> |
| <span class="grid"><span>`UPDATE_FILE`</span><span>`logical, INTENT(in)`</span></span><br><span class="ind6">Explicitly request a file update when true.</span> |
| <span class="grid"><span>`ERR`</span><span>`type(error_type), OPTIONAL, INTENT(out)`</span></span><br><span class="ind6">Receives the error; failure stops execution when omitted.</span> |

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
    type(variable_type) :: var

    var = datarray("temperature", [273.15], ["x".dim.1])
    call rename_dimension(var, "x", "point")
    call to_netcdf("temperature.nc", var)

    nc = open_netcdf("temperature.nc", "a")
    call inquire_group(nc)
    call rename_dimension(nc, "point", "station", update_file=.true.)
    call close_netcdf(nc)
    ```
:::

## `RENAME_VARIABLE` -- Rename a Variable

| Synopsis |
|:--|
| <span class="ind3">`CALL RENAME_VARIABLE(VAR, NEW_NAME[, ERR])`</span> |
| <span class="ind3">`CALL RENAME_VARIABLE(GRP, OLD_NAME, NEW_NAME[, ERR])`</span> |
| <span class="ind3">`CALL RENAME_VARIABLE(GRP, VAR, NEW_NAME[, UPDATE_FILE, ERR])`</span> |
| <span class="ind3">`CALL RENAME_VARIABLE(GRP, OLD_NAME, NEW_NAME, UPDATE_FILE[, ERR])`</span> |

| Class |
|:--|
| <span class="ind3">Generic subroutine.</span> |

| Description |
|:--|
| <span class="ind3">Rename a standalone variable or a direct member of a group using pure model-only forms or impure file-capable forms controlled by `UPDATE_FILE`, which defaults to `.false.` for the variable-object form and is required for the group/name form; `GRP` also accepts `netcdf_type`.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`VAR`</span><span>`type(variable_type), INTENT(inout)`</span></span><br><span class="ind6">Variable whose name is changed.</span> |
| <span class="grid"><span>`GRP`</span><span>`class(group_type)`</span></span><br><span class="ind6">Owner of the variable collection (`INTENT(inout)`), or file context for a supplied `VAR` (`INTENT(in)`).</span> |
| <span class="grid"><span>`OLD_NAME`</span><span>`character(len=*), INTENT(in)`</span></span><br><span class="ind6">Existing direct variable name. The object overload uses `VAR%name` instead.</span> |
| <span class="grid"><span>`NEW_NAME`</span><span>`character(len=*), INTENT(in)`</span></span><br><span class="ind6">Replacement variable name.</span> |
| <span class="grid"><span>`UPDATE_FILE`</span><span>`logical, INTENT(in)`</span></span><br><span class="ind6">Request a file update when true.</span> |
| <span class="grid"><span>`ERR`</span><span>`type(error_type), OPTIONAL, INTENT(out)`</span></span><br><span class="ind6">Receives the error; failure stops execution when omitted.</span> |

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
    type(variable_type) :: var

    var = datarray("temp", [273.15], ["point".dim.1])
    call rename_variable(var, "temperature")
    call to_netcdf("temperature.nc", var)

    nc = open_netcdf("temperature.nc", "a")
    var = inquire_variable(nc, "temperature")
    call rename_variable(nc, var, "air_temperature", update_file=.true.)
    call rename_variable(nc, "air_temperature", "temperature", update_file=.true.)
    call close_netcdf(nc)
    ```
:::

## `RENAME_GROUP` -- Rename a Group

| Synopsis |
|:--|
| <span class="ind3">`CALL RENAME_GROUP(GRP, NEW_NAME[, ERR])`</span> |
| <span class="ind3">`CALL RENAME_GROUP(PARENT, OLD_NAME, NEW_NAME[, ERR])`</span> |
| <span class="ind3">`CALL RENAME_GROUP(PARENT, GRP, NEW_NAME[, UPDATE_FILE, ERR])`</span> |
| <span class="ind3">`CALL RENAME_GROUP(PARENT, OLD_NAME, NEW_NAME, UPDATE_FILE[, ERR])`</span> |

| Class |
|:--|
| <span class="ind3">Generic subroutine.</span> |

| Description |
|:--|
| <span class="ind3">Rename a non-root group or a direct child of a parent using pure model-only forms or impure file-capable forms controlled by `UPDATE_FILE`, which defaults to `.false.` for the supplied-object form and is required for the parent/name form.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`GRP`</span><span>`class(group_type), INTENT(inout)`</span></span><br><span class="ind6">Non-root group whose name is changed.</span> |
| <span class="grid"><span>`PARENT`</span><span>`class(group_type)`</span></span><br><span class="ind6">Owner of the child collection (`INTENT(inout)`), or file context for a supplied `GRP` (`INTENT(in)`).</span> |
| <span class="grid"><span>`OLD_NAME`</span><span>`character(len=*), INTENT(in)`</span></span><br><span class="ind6">Existing direct child name; the object overload uses `GRP%name`.</span> |
| <span class="grid"><span>`NEW_NAME`</span><span>`character(len=*), INTENT(in)`</span></span><br><span class="ind6">Replacement local group name.</span> |
| <span class="grid"><span>`UPDATE_FILE`</span><span>`logical, INTENT(in)`</span></span><br><span class="ind6">Request a file update when true.</span> |
| <span class="grid"><span>`ERR`</span><span>`type(error_type), OPTIONAL, INTENT(out)`</span></span><br><span class="ind6">Receives the error; failure stops execution when omitted.</span> |

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
    type(group_type) :: root, child
    type(group_type), target :: children(1)

    children(1) = dataset("observations")
    root%name = "/"
    root%grps => children
    call rename_group(root, "observations", "measurements")
    call to_netcdf("groups.nc", root)

    nc = open_netcdf("groups.nc", "a")
    child = get_group(nc, "measurements")
    call rename_group(nc, child, "samples", update_file=.true.)
    call rename_group(nc, "samples", "observations", update_file=.true.)
    call close_netcdf(nc)
    ```
:::

## `SHAPE` -- Get Variable Extents

| Synopsis |
|:--|
| <span class="ind3">`EXTENTS = SHAPE(VAR)`</span> |

| Class |
|:--|
| <span class="ind3">Function.</span> |

| Description |
|:--|
| <span class="ind3">Return allocatable default-integer dimension extents in Fortran order.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`VAR`</span><span>`type(variable_type), INTENT(in)`</span></span><br><span class="ind6">Variable to inspect.</span> |

| Return |
|:--|
| <span class="grid"><span>`EXTENTS`</span><span>`integer, allocatable`</span></span><br><span class="ind6">Variable extents in Fortran order.</span> |

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
| <span class="ind3">`N = SIZE(VAR[, DIM])`</span> |

| Class |
|:--|
| <span class="ind3">Function.</span> |

| Description |
|:--|
| <span class="ind3">Return the total element count as `integer(int64)`, or the one-based Fortran-order length of `DIM`.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`VAR`</span><span>`type(variable_type), INTENT(in)`</span></span><br><span class="ind6">Variable to inspect.</span> |
| <span class="grid"><span>`DIM`</span><span>`integer, OPTIONAL, INTENT(in)`</span></span><br><span class="ind6">One-based Fortran-order dimension to select.</span> |

| Return |
|:--|
| <span class="grid"><span>`N`</span><span>`integer(int64)`</span></span><br><span class="ind6">Total element count or the selected dimension length.</span> |

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

## `TO_NETCDF` -- Write a NetCDF File

| Synopsis |
|:--|
| <span class="ind3">`CALL TO_NETCDF(FILE, VARS[, ATTS, ERR])`</span><br><span class="ind3">`CALL TO_NETCDF(FILE, GRP[, ATTS, ERR])`</span> |

| Class |
|:--|
| <span class="ind3">Generic subroutine.</span> |

| Description |
|:--|
| <span class="ind3">Write a scalar or rank-one array of variables, or a scalar or rank-one array of groups. A scalar group becomes the file root and its name is ignored. A group array becomes direct children of a new root; no first-level group may be named `/`.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`FILE`</span><span>`character(len=*), INTENT(in)`</span></span><br><span class="ind6">Path of the output file.</span> |
| <span class="grid"><span>`VARS`</span><span>`type(variable_type), scalar or dimension(:), INTENT(in)`</span></span><br><span class="ind6">Variables to write.</span> |
| <span class="grid"><span>`GRP`</span><span>`type(group_type), scalar or dimension(:), INTENT(in)`</span></span><br><span class="ind6">Group model to write.</span> |
| <span class="grid"><span>`ATTS`</span><span>`type(attribute_type), DIMENSION(:), OPTIONAL, INTENT(in)`</span></span><br><span class="ind6">Root attributes when writing variables or groups.</span> |
| <span class="grid"><span>`ERR`</span><span>`type(error_type), OPTIONAL, INTENT(out)`</span></span><br><span class="ind6">Receives an operation error.</span> |

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

