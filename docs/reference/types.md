# Data Types, Constructions and Extractions

## Basic Types

This library implements the [data structures](https://docs.unidata.ucar.edu/netcdf-c/4.10.0/netcdf_data_model.html)
described on the NetCDF website. Its basic types include the following components:
  * `dimension_type`: name, length, and if the dimension is unlimited;
  * `attribute_type`: name and a 1D generic (integer, float, character, ...) array;
  * `variable_type`: name, dimensions, attributes, and an ND generic (integer, float, character, ...) array;
  * `group_type`: name, dimensions, attributes, variables and nested groups;
  * `netcdf_type`: the root group that also contains metadata like filename and I/O mode;
  * `error_type`: this is a library specific type for handling errors.

## Supported NetCDF Types

The currently supported and unsupported [NetCDF types](https://docs.unidata.ucar.edu/nug/current/md_types.html) are:
- &#x2611; Supported: `CHAR`, `BYTE`, `SHORT`, `INT`, `INT64`, `FLOAT`, `DOUBLE`
- &#x2612; Unsupported: `UNSIGNED BYTE`, `UNSIGNED SHORT`, `UNSIGNED INT`, `UNSIGNED INT64`, `STRING`

## Constructions

This library provides operators and generic functions that (hopefully) simplifies the 
construction of these derived types. Let's go through them one by one.

### `dimension_type`

In NetCDF there are two kinds of dimensions: limited and unlimited. For
limited dimensions we can construct them through `.dim.`,

```fortran
type(dimension_type) :: longitude, latitude

longitude = "longitude" .dim. 361
latitude = "latitude" .dim. 181
```

To specify if the dimension is limited/unlimited, we need the operator `.and.` and a logical variable,

```fortran
logical, parameter :: UNLIMITED = .true.
logical, parameter :: LIMITED = .false.
type(dimension_type) :: time_unlim, time_slice

time_unlim = "time_unlim" .dim. (24 .and. UNLIMITED)
time_slice = "time_slice" .dim. (24 .and. LIMITED)
```

### `attribute_type`

Attribute type variables are constructed through the operator `.att.`. The first argument has to be string and the second argument is generic.

```fortran
type(attribute_type), allocatable :: atts(:)

atts = ["units" .att. "Kelvin", &
        "description" .att. "Sea Surface Temperature", &
        "mean" .att. 293, &
        "stdv" .att. 5.23]
```

### `variable_type`

The main constructor of `variable_type` is `datarray`. You will need at least a name, an array and a dimension array to form a data array.
For example, let's say we would like to create a 3D geospatial variable 

```fortran
type(dimension_type) :: lon, lat, tme
type(variable_type) :: var
logical, parameter :: UNLIMITED = .true.
real, allocatable, target :: values(:, :, :)
integer :: nlon, nlat, nt, i, j, k

nlon = 360
nlat = 181
nt = 24

allocate (values(nt, nlat, nlon))
do concurrent (i = 1:nt, j = 1:nlat, k = 1:nlon)
  values(i, j, k) = 0. !> Dummy values
end do

lon = "longitude" .dim. nlon
lat = "latitude" .dim. nlat
tme = "time" .dim. (nt .and. UNLIMITED)
var = datarray("dummy variable", values, [tme, lat, lon])

print *, var ! Yes, you can use UDDTIO to print the metadata. Try it.
```

In this way the `values` are copied to the owned, allocatable `var%buffer`.
If the array `values` is big, you can avoid the copy by using a contiguous
caller-owned target:

```fortran
var = datarray("dummy variable", values, [tme, lat, lon], deep=.false.)
```

Then `var%ptr` is associated with `values` while `var%buffer` remains
unallocated. This is efficient, but `values` must be a simply contiguous,
named target and remain alive for as long as the variable is used; do not pass
an expression, array constructor, or noncontiguous section. Also, you can
attach attributes as well:

```fortran
var = datarray("dummy variable", values, [tme, lat, lon], &
  & atts=["units" .att. "K", "critical" .att. 273.15] deep=.false.)
```

### `group_type`

Describes a NetCDF group. `dims`, `atts`, and `vars` are local collections;
`grps` is a pointer-backed array of direct children. A child may use
dimensions inherited from an ancestor without declaring them locally.

### `netcdf_type`

Extends `group_type` for an open file with the `filename` and `mode`
components.

```fortran
type(netcdf_type) :: nc
nc = open_dataset("input.nc", "r")
call close_dataset(nc)
```
