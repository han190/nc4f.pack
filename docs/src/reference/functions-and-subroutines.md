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
| <span class="ind3">Close an open dataset and release its allocated model metadata. For diskless datasets, `"a"`/`"w"` (or `"append"`/`"write"`) request persistence to disk on close; `"an"`/`"wn"` (or `"append_temp"`/`"write_temp"`) discard the in-memory contents. Close errors, including persistence failures, follow the usual `ERR` convention.</span> |

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
| <span class="ind3">`CALL EXTRACT(ATT, VALUES)`</span><br><span class="ind3">`CALL EXTRACT(VAR, VALUES)`</span><br><span class="ind3">`CALL EXTRACT(COORD, VALUES)`</span> |

| Class |
|:--|
| <span class="ind3">Generic subroutine.</span> |

| Description |
|:--|
| <span class="ind3">Associate a typed Fortran pointer with an attribute, variable, or coordinate's storage without copying numeric values. The pointer's numeric kind must match the stored NetCDF data. For variables and numeric coordinates, a rank-one pointer covers all elements in Fortran order; pointers of rank two through fifteen must match the source rank and receive its dimension shape. Empty storage returns a null pointer. Keep the source storage alive and unchanged in allocation while using the view; do not deallocate the borrowed target. Scalar character attribute extraction returns an allocated string copy.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`ATT`</span><span>`type(attribute_type), TARGET, INTENT(in)`</span></span><br><span class="ind6">Attribute supplying storage.</span> |
| <span class="grid"><span>`VAR`</span><span>`type(variable_type), TARGET, INTENT(in)`</span></span><br><span class="ind6">Variable supplying storage.</span> |
| <span class="grid"><span>`COORD`</span><span>`type(coordinate_type), TARGET, INTENT(in)`</span></span><br><span class="ind6">Numeric coordinate supplying storage.</span> |
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

## `NAMEOF` -- Get an Object Name

| Synopsis |
|:--|
| <span class="ind3">`NAME = NAMEOF(OBJECT)`</span> |

| Class |
|:--|
| <span class="ind3">Pure generic function.</span> |

| Description |
|:--|
| <span class="ind3">Return the in-memory name of an attribute, dimension, variable, group, or open NetCDF root. An object without an allocated name returns an empty string. No file inquiry is performed.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`OBJECT`</span><span>`type(attribute_type)`, `type(dimension_type)`, `type(variable_type)`, or `class(group_type)`, `INTENT(in)`</span></span><br><span class="ind6">Named model object; `netcdf_type` is accepted through `group_type` inheritance.</span> |

| Result |
|:--|
| <span class="grid"><span>`NAME`</span><span>`character(len=:), allocatable`</span></span><br><span class="ind6">Name value, or an allocated empty string when no name is assigned.</span> |

```fortran
print '(a)', nameof(var)
```

## `TYPEOF` -- Get an Object's Data Type

| Synopsis |
|:--|
| <span class="ind3">`DTYPE = TYPEOF(OBJECT)`</span> |

| Class |
|:--|
| <span class="ind3">Elemental generic function.</span> |

| Description |
|:--|
| <span class="ind3">Return the in-memory NetCDF external data type code of a variable or attribute. No file inquiry or type conversion is performed.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`OBJECT`</span><span>`type(variable_type)` or `type(attribute_type), INTENT(in)`</span></span><br><span class="ind6">Variable or attribute whose data type is requested; arrays are accepted element-wise.</span> |

| Result |
|:--|
| <span class="grid"><span>`DTYPE`</span><span>`integer(data_type)`</span></span><br><span class="ind6">The object's `DTYPE` component, such as `NC_FLOAT` or `NC_CHAR`.</span> |

```fortran
if (typeof(var) == NC_FLOAT) print '(a)', "floating-point variable"
```

(open_netcdf--open-a-netcdf-file)=
## `OPEN_NETCDF` -- Open a NetCDF File

| Synopsis |
|:--|
| <span class="ind3">`NC = OPEN_NETCDF(FILE[, MODE, DISKLESS, ERR])`</span> |

| Class |
|:--|
| <span class="ind3">Function.</span> |

| Description |
|:--|
| <span class="ind3">Open or create a NetCDF dataset. `MODE` defaults to `"r"`; `DISKLESS` defaults to `.false.`. Diskless access keeps the NetCDF file representation in RAM, with persistence selected by the mode.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`FILE`</span><span>`character(len=*), INTENT(in)`</span></span><br><span class="ind6">Path of the dataset to open or create.</span> |
| <span class="grid"><span>`MODE`</span><span>`character(len=*), OPTIONAL, INTENT(in)`</span></span><br><span class="ind6">Requested file access mode.</span> |
| <span class="grid"><span>`DISKLESS`</span><span>`logical, OPTIONAL, INTENT(in)`</span></span><br><span class="ind6">Whether to use a RAM-backed dataset. Defaults to `.false.`.</span> |
| <span class="grid"><span>`ERR`</span><span>`type(error_type), OPTIONAL, INTENT(out)`</span></span><br><span class="ind6">Receives an operation error.</span> |

| Return |
|:--|
| <span class="grid"><span>`NC`</span><span>`type(netcdf_type)`</span></span><br><span class="ind6">Opened or created NetCDF dataset.</span> |

| Mode & Diskless Options |
|:--|
| <span class="grid"><span>`OPT 1`</span><span>`MODE="read", DISKLESS=.FALSE.`</span></span><br><span class="ind6">Read an existing disk-backed file.</span> |
| <span class="grid"><span>`OPT 2`</span><span>`MODE="append", DISKLESS=.FALSE.`</span></span><br><span class="ind6">Modify an existing disk-backed file.</span> |
| <span class="grid"><span>`OPT 3`</span><span>`MODE="write", DISKLESS=.FALSE.`</span></span><br><span class="ind6">Create or overwrite a disk-backed NetCDF-4 file.</span> |
| <span class="grid"><span>`OPT 4`</span><span>`MODE="read", DISKLESS=.TRUE.`</span></span><br><span class="ind6">Read an existing file loaded into RAM.</span> |
| <span class="grid"><span>`OPT 5`</span><span>`MODE="append", DISKLESS=.TRUE.`</span></span><br><span class="ind6">Modify an existing dataset in RAM; save on close.</span> |
| <span class="grid"><span>`OPT 6`</span><span>`MODE="append_temp", DISKLESS=.TRUE.`</span></span><br><span class="ind6">Modify an existing dataset in RAM; discard changes on close.</span> |
| <span class="grid"><span>`OPT 7`</span><span>`MODE="write", DISKLESS=.TRUE.`</span></span><br><span class="ind6">Create a NetCDF-4 dataset in RAM; save on close, replacing any existing file.</span> |
| <span class="grid"><span>`OPT 8`</span><span>`MODE="write_temp", DISKLESS=.TRUE.`</span></span><br><span class="ind6">Create a temporary NetCDF-4 dataset in RAM; discard on close, leaving any existing file unchanged.</span> |

| Mode Aliases |
|:--|
| <span class="grid"><span>`R`</span><span>`READ (OPT 1,4)`</span> |
| <span class="grid"><span>`A`</span><span>`APPEND (OPT 2,5)`</span> |
| <span class="grid"><span>`W`</span><span>`WRITE (OPT 3,7)`</span> |
| <span class="grid"><span>`AN`</span><span>`APPEND_TEMP (OPT 6)`</span> |
| <span class="grid"><span>`WN`</span><span>`WRITE_TEMP (OPT 8)`</span> |

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

## `SET_STORAGE` -- Configure a Variable in Memory

| Synopsis |
|:--|
| <span class="ind3">`CALL SET_STORAGE(VAR[, CHUNKS, DEFLATE_LEVEL, SHUFFLE, FLETCHER32, ENDIAN, NO_FILL, FILL_VALUE, ERR])`</span> |

| Class |
|:--|
| <span class="ind3">Subroutine.</span> |

| Description |
|:--|
| <span class="ind3">Allocate or update a variable's optional in-memory `STORAGE` component. Omitted arguments retain their previous values. Invalid settings leave the component unchanged.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`VAR`</span><span>`type(variable_type), INTENT(inout)`</span></span><br><span class="ind6">Variable whose storage settings are updated.</span> |
| <span class="grid"><span>`CHUNKS`</span><span>`integer(int64), DIMENSION(:), OPTIONAL, INTENT(in)`</span></span><br><span class="ind6">Positive chunk lengths matching the variable rank, in Fortran dimension order.</span> |
| <span class="grid"><span>`DEFLATE_LEVEL`</span><span>`integer, OPTIONAL, INTENT(in)`</span></span><br><span class="ind6">Compression level from 0 through 9.</span> |
| <span class="grid"><span>`SHUFFLE`</span><span>`logical, OPTIONAL, INTENT(in)`</span></span><br><span class="ind6">Enable or disable the shuffle filter.</span> |
| <span class="grid"><span>`FLETCHER32`</span><span>`logical, OPTIONAL, INTENT(in)`</span></span><br><span class="ind6">Enable or disable Fletcher32 checksums.</span> |
| <span class="grid"><span>`ENDIAN`</span><span>`integer, OPTIONAL, INTENT(in)`</span></span><br><span class="ind6">`NC_ENDIAN_NATIVE`, `NC_ENDIAN_LITTLE`, or `NC_ENDIAN_BIG`.</span> |
| <span class="grid"><span>`NO_FILL`</span><span>`logical, OPTIONAL, INTENT(in)`</span></span><br><span class="ind6">Disable or enable filling of unwritten values.</span> |
| <span class="grid"><span>`FILL_VALUE`</span><span>`type(attribute_type), OPTIONAL, INTENT(in)`</span></span><br><span class="ind6">Scalar value matching the variable type; conflicts with `NO_FILL=.true.`.</span> |
| <span class="grid"><span>`ERR`</span><span>`type(error_type), OPTIONAL, INTENT(out)`</span></span><br><span class="ind6">Receives an operation error. When omitted, failures terminate execution.</span> |

| Notes |
|:--|
| <span class="ind3">This call changes only the in-memory variable. `DEFINE_VARIABLE` or `TO_NETCDF` applies the settings when creating a file variable. `PUT_VARIABLE` does not change existing file storage settings.</span> |

:::{list-table}
:class: example-table
:header-rows: 1

*
  - Example
*
  -
    ```fortran
    use, intrinsic :: iso_fortran_env, only: int64
    use, non_intrinsic :: nc4f
    implicit none (type, external)

    type(variable_type) :: var
    type(error_type) :: err

    var = datarray("temperature", reshape([1.0, 2.0, 3.0, 4.0], [2, 2]), &
      & ["x".dim.2, "y".dim.2])
    call set_storage(var, chunks=[2_int64, 2_int64], &
      & deflate_level=4, shuffle=.true., err=err)
    call to_netcdf("output.nc", var, err=err)
    ```
:::

## `DEFINE_VARIABLE` -- Define a Variable Without Data

| Synopsis |
|:--|
| <span class="ind3">`CALL DEFINE_VARIABLE(NC, VAR[, ERR])`</span> |
| <span class="ind3">`CALL DEFINE_VARIABLE(NC, NAME, DTYPE, DIMS[, ATTS, STORAGE, ERR])`</span> |

| Class |
|:--|
| <span class="ind3">Generic subroutine.</span> |

| Description |
|:--|
| <span class="ind3">Define a variable and its initial attributes in an open writable dataset or subgroup without allocating a variable-sized data buffer. Create missing dimensions and reuse compatible visible dimensions, including inherited dimensions. An existing variable name returns `NC_ENAMEINUSE`.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`NC`</span><span>`class(group_type), INTENT(in)`</span></span><br><span class="ind6">Open writable dataset (`netcdf_type`) or subgroup.</span> |
| <span class="grid"><span>`VAR`</span><span>`type(variable_type), INTENT(in)`</span></span><br><span class="ind6">Source schema supplying the name, type, dimensions, and initial attributes. Its name and dimensions must be allocated; an empty dimension array defines a scalar. Attributes may be unallocated. Data storage, element count, and cached IDs are ignored; data is neither copied nor written, and the source remains unchanged.</span> |
| <span class="grid"><span>`NAME`</span><span>`character(len=*), INTENT(in)`</span></span><br><span class="ind6">Local variable name. Trailing Fortran blank padding is ignored.</span> |
| <span class="grid"><span>`DTYPE`</span><span>`integer(c_int), INTENT(in)`</span></span><br><span class="ind6">Supported NetCDF primitive type constant, such as `NC_FLOAT` or `NC_INT`.</span> |
| <span class="grid"><span>`DIMS`</span><span>`type(dimension_type), DIMENSION(:), INTENT(in)`</span></span><br><span class="ind6">Destination dimensions in Fortran order. An empty array defines a scalar.</span> |
| <span class="grid"><span>`ATTS`</span><span>`type(attribute_type), DIMENSION(:), OPTIONAL, INTENT(in)`</span></span><br><span class="ind6">Initial variable attributes, written before data.</span> |
| <span class="grid"><span>`STORAGE`</span><span>`type(storage_type), OPTIONAL, INTENT(in)`</span></span><br><span class="ind6">Per-variable storage settings for the explicit schema form.</span> |
| <span class="grid"><span>`ERR`</span><span>`type(error_type), OPTIONAL, INTENT(out)`</span></span><br><span class="ind6">Receives an operation error. When omitted, failures terminate execution.</span> |

| Schema Rules |
|:--|
| <span class="ind3">Both forms follow the same rules. The explicit arguments supply the corresponding `VAR` components described below; `ERR` is optional in both forms.</span> |
| <span class="ind3">`VAR%NAME` is a local variable name; trailing Fortran blank padding is ignored. `VAR%DTYPE` must be a supported NetCDF primitive [type constant](exposed-nc-constants.md), such as `NC_FLOAT` or `NC_INT`.</span> |
| <span class="ind3">`VAR%DIMS` lists destination dimensions in Fortran order. Fixed lengths must be positive; existing fixed lengths and unlimited status must agree. Existing unlimited dimensions retain their current file length, while new unlimited dimensions start empty regardless of the supplied length.</span> |
| <span class="ind3">`VAR%ATTS` supplies initial attributes, written before data. `_FillValue`, when supplied, must contain exactly one value of the variable's type.</span> |

| Notes |
|:--|
| <span class="ind3">Source objects and loaded caches remain unchanged. Use `INQUIRE_VARIABLE`, `INQUIRE_DIMENSIONS`, or `GET_VARIABLE` to obtain fresh metadata or data. Closing a dataset invalidates its handle; callers must also treat copied handles and subgroup snapshots as closed.</span> |
| <span class="ind3">Validation precedes mutation where possible, but later failures can leave created metadata. The operation does not provide rollback. Storage settings are applied after variable creation and before attributes or data; chunking, compression, checksum, and endianness require NetCDF-4 format.</span> |

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
    type(error_type) :: err

    nc = open_netcdf("output.nc", "w")
    var%name = "pressure"
    var%dtype = NC_FLOAT
    var%dims = ["station".dim.6]
    var%atts = ["units".att."Pa"]
    call define_variable(nc, var, err=err)
    if (.exists. err) error stop error_msg(err)

    call define_variable(nc, "temperature", NC_FLOAT, ["station".dim.6], &
      & atts=["units".att."K"], err=err)
    if (.exists. err) error stop error_msg(err)
    call close_netcdf(nc)
    ```
:::

## `PUT_VARIABLE` -- Write Data to an Existing Variable

| Synopsis |
|:--|
| <span class="ind3">`CALL PUT_VARIABLE(NC, VAR[, START, COUNT, STRIDE, ERR])`</span> |

| Class |
|:--|
| <span class="ind3">Subroutine.</span> |

| Description |
|:--|
| <span class="ind3">Write data to an existing variable in an open writable dataset or subgroup, optionally selecting destination indices. Resolve the destination by name and inquire its IDs and metadata from the file. Preserve existing attributes and schema; this procedure does not create dimensions or variables.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`NC`</span><span>`class(group_type), INTENT(in)`</span></span><br><span class="ind6">Open writable dataset (`netcdf_type`) or subgroup.</span> |
| <span class="grid"><span>`VAR`</span><span>`type(variable_type), TARGET, INTENT(in)`</span></span><br><span class="ind6">Source variable whose name selects the destination and whose storage supplies the data. Its type, rank, and ordered dimension names must match the destination, and its shape must equal `COUNT`. Source dimension lengths describe the patch; source unlimited flags do not override the destination's flags. Source attributes are not written.</span> |
| <span class="grid"><span>`START`</span><span>`integer, DIMENSION(:), OPTIONAL, INTENT(in)`</span></span><br><span class="ind6">Positive one-based destination indices in Fortran dimension order. Defaults to ones.</span> |
| <span class="grid"><span>`COUNT`</span><span>`integer, DIMENSION(:), OPTIONAL, INTENT(in)`</span></span><br><span class="ind6">Number of source values along each dimension in Fortran order. Defaults to the source shape.</span> |
| <span class="grid"><span>`STRIDE`</span><span>`integer, DIMENSION(:), OPTIONAL, INTENT(in)`</span></span><br><span class="ind6">Positive spacing between destination indices in Fortran dimension order. Defaults to ones.</span> |
| <span class="grid"><span>`ERR`</span><span>`type(error_type), OPTIONAL, INTENT(out)`</span></span><br><span class="ind6">Receives an operation error. When omitted, failures terminate execution.</span> |

| Selection Rules |
|:--|
| <span class="ind3">Selection arguments may be supplied independently. Each supplied vector must have one entry per destination dimension. There is no implicit type conversion, broadcasting, or mapping of noncontiguous memory.</span> |
| <span class="ind3">Fixed dimensions cannot grow. Unlimited dimensions grow to include the last selected index. Unselected values remain unchanged; new unwritten areas follow the file's fill settings.</span> |
| <span class="ind3">Empty whole-variable writes are accepted; explicit selections require positive counts. For a scalar, omit selection arguments or provide empty vectors. A scalar source can be constructed with `datarray("scalar", [value], [dimension_type ::])`.</span> |

| Notes |
|:--|
| <span class="ind3">Source objects and loaded caches remain unchanged. Use `INQUIRE_VARIABLE`, `INQUIRE_DIMENSIONS`, or `GET_VARIABLE` to obtain fresh metadata or data. Closing a dataset invalidates its handle; callers must also treat copied handles and subgroup snapshots as closed.</span> |
| <span class="ind3">Validation precedes mutation where possible, but later failures can leave partially written data. The operation does not provide rollback.</span> |

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
    type(variable_type) :: patch

    nc = open_netcdf("output.nc", "w")
    call define_variable(nc, &
      & variable_type(name="temperature", dtype=NC_FLOAT, dims=["station".dim.6]))
    patch = datarray("temperature", [10., 20., 30.], ["station".dim.3])
    call put_variable(nc, patch, start=[2], count=[3], stride=[2])
    call close_netcdf(nc)
    ```
:::

## `TO_NETCDF` -- Create a File or Update Variables

| Synopsis |
|:--|
| <span class="ind3">`CALL TO_NETCDF(FILE, VARS[, ATTS, ERR, MODE, START, COUNT, STRIDE])`</span> |
| <span class="ind3">`CALL TO_NETCDF(FILE, GRP[, ATTS, ERR, MODE, START, COUNT, STRIDE])`</span> |

| Class |
|:--|
| <span class="ind3">Generic subroutine.</span> |

| Description |
|:--|
| <span class="ind3">Create a file from complete variables or groups, or update variables in an existing file. Open and close the file internally. Selections update a single existing variable in append mode using `PUT_VARIABLE` semantics.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`FILE`</span><span>`character(len=*), INTENT(in)`</span></span><br><span class="ind6">Path of the file to create or update. The same file must not already be open through another handle.</span> |
| <span class="grid"><span>`VARS`</span><span>`type(variable_type), DIMENSION(..), INTENT(in)`</span></span><br><span class="ind6">Scalar variable or rank-one array of variables to write. Selection arguments are accepted only for a scalar variable, not an array of length one. Existing variable attributes are preserved during updates.</span> |
| <span class="grid"><span>`GRP`</span><span>`type(group_type), DIMENSION(..), INTENT(in)`</span></span><br><span class="ind6">Scalar group or rank-one group array to write in overwrite mode. A scalar becomes the file root and its name is ignored. An array becomes direct children of a new root; no first-level group may be named `/`. Group append/merge and selection arguments are unsupported.</span> |
| <span class="grid"><span>`ATTS`</span><span>`type(attribute_type), DIMENSION(:), OPTIONAL, INTENT(in)`</span></span><br><span class="ind6">Root/global attributes to write, including explicitly supplied updates in append mode. For a scalar group, entries replace attributes with matching names in `GRP%ATTS`.</span> |
| <span class="grid"><span>`ERR`</span><span>`type(error_type), OPTIONAL, INTENT(out)`</span></span><br><span class="ind6">Receives an operation error. When omitted, failures terminate execution. Cleanup preserves the original operation error when a write fails.</span> |
| <span class="grid"><span>`MODE`</span><span>`character(len=*), OPTIONAL, INTENT(in)`</span></span><br><span class="ind6">`"w"` or `"write"` (default) creates or replaces the file; `"a"` or `"append"` updates variables in an existing file.</span> |
| <span class="grid"><span>`START`</span><span>`integer, DIMENSION(:), OPTIONAL, INTENT(in)`</span></span><br><span class="ind6">Positive one-based destination indices in Fortran dimension order. Defaults to ones. Requires a scalar variable in append mode.</span> |
| <span class="grid"><span>`COUNT`</span><span>`integer, DIMENSION(:), OPTIONAL, INTENT(in)`</span></span><br><span class="ind6">Number of source values along each dimension in Fortran order. Defaults to the source shape. Requires a scalar variable in append mode.</span> |
| <span class="grid"><span>`STRIDE`</span><span>`integer, DIMENSION(:), OPTIONAL, INTENT(in)`</span></span><br><span class="ind6">Positive spacing between destination indices in Fortran dimension order. Defaults to ones. Requires a scalar variable in append mode.</span> |

| Mode Options |
|:--|
| <span class="grid"><span>`"w"`, `"write"`</span><span>Overwrite (default).</span></span><br><span class="ind6">Create or replace the file and serialize complete variables or groups. Selections are rejected.</span> |
| <span class="grid"><span>`"a"`, `"append"`</span><span>Append.</span></span><br><span class="ind6">Require an existing file. Without a selection, define missing complete variables or write existing variables from index one using the source shape. With a selection, require an existing destination variable; create its schema first with `DEFINE_VARIABLE` if needed.</span> |

| Notes |
|:--|
| <span class="ind3">The positional arguments `FILE, VARS/GRP, ATTS, ERR` retain their order. Unsupported modes, ranks, and selection combinations are rejected before opening in overwrite mode. Selection arguments follow all `PUT_VARIABLE` rules.</span> |
| <span class="ind3">A failed operation may leave created metadata or partially written data. The operation does not provide rollback.</span> |

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

    type(variable_type) :: temperature, patch

    temperature = datarray("temperature", [0., 0., 0., 0., 0., 0.], &
      & ["station".dim.6])
    call to_netcdf("output.nc", temperature)
    patch = datarray("temperature", [11., 21., 31.], ["station".dim.3])
    call to_netcdf("output.nc", patch, mode="a", start=[1], stride=[2])
    ```
:::
