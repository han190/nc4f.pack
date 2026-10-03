# Derived Types

This library implements the [data structures](https://docs.unidata.ucar.edu/netcdf-c/4.10.0/netcdf_data_model.html)
described by the NetCDF data model.

## `DIMENSION_TYPE` -- NetCDF Dimension

| Component |
|:--|
| <span class="grid"><span>`ID`</span><span>`integer(c_int)`</span></span><br><span class="ind6">NetCDF dimension identifier.</span> |
| <span class="grid"><span>`NAME`</span><span>`character(len=:), allocatable`</span></span><br><span class="ind6">Dimension name.</span> |
| <span class="grid"><span>`LEN`</span><span>`integer(int64)`</span></span><br><span class="ind6">Dimension length.</span> |
| <span class="grid"><span>`IS_UNLIM`</span><span>`logical`</span></span><br><span class="ind6">Whether the dimension is unlimited.</span> |

## `ATTRIBUTE_TYPE` -- NetCDF Attribute

| Component |
|:--|
| <span class="grid"><span>`ID`</span><span>`integer(c_int)`</span></span><br><span class="ind6">NetCDF attribute identifier.</span> |
| <span class="grid"><span>`NAME`</span><span>`character(len=:), allocatable`</span></span><br><span class="ind6">Attribute name.</span> |
| <span class="grid"><span>`DTYPE`</span><span>`integer(data_type)`</span></span><br><span class="ind6">NetCDF external data type.</span> |
| <span class="grid"><span>`LEN`</span><span>`integer(int64)`</span></span><br><span class="ind6">Number of stored values.</span> |
| <span class="grid"><span>`BUFFER`</span><span>`integer(int8), allocatable`</span></span><br><span class="ind6">Owned byte storage for copied values.</span> |
| <span class="grid"><span>`PTR`</span><span>`integer(int8), contiguous, pointer`</span></span><br><span class="ind6">Borrowed byte storage for contiguous caller-owned values.</span> |

## `VARIABLE_TYPE` -- NetCDF Variable

| Component |
|:--|
| <span class="grid"><span>`ID`</span><span>`integer(c_int)`</span></span><br><span class="ind6">NetCDF variable identifier.</span> |
| <span class="grid"><span>`NAME`</span><span>`character(len=:), allocatable`</span></span><br><span class="ind6">Variable name.</span> |
| <span class="grid"><span>`DTYPE`</span><span>`integer(data_type)`</span></span><br><span class="ind6">NetCDF external data type.</span> |
| <span class="grid"><span>`LEN`</span><span>`integer(int64)`</span></span><br><span class="ind6">Total number of stored values.</span> |
| <span class="grid"><span>`DIMS`</span><span>`type(dimension_type), allocatable`</span></span><br><span class="ind6">Dimensions in Fortran order.</span> |
| <span class="grid"><span>`ATTS`</span><span>`type(attribute_type), allocatable`</span></span><br><span class="ind6">Attributes attached to the variable.</span> |
| <span class="grid"><span>`BUFFER`</span><span>`integer(int8), allocatable`</span></span><br><span class="ind6">Owned byte storage for copied values.</span> |
| <span class="grid"><span>`PTR`</span><span>`integer(int8), contiguous, pointer`</span></span><br><span class="ind6">Borrowed byte storage for contiguous caller-owned values.</span> |

## `GROUP_TYPE` -- NetCDF Group

| Component |
|:--|
| <span class="grid"><span>`ID`</span><span>`integer(c_int)`</span></span><br><span class="ind6">NetCDF group identifier.</span> |
| <span class="grid"><span>`NAME`</span><span>`character(len=:), allocatable`</span></span><br><span class="ind6">Group name.</span> |
| <span class="grid"><span>`DIMS`</span><span>`type(dimension_type), allocatable`</span></span><br><span class="ind6">Dimensions defined by the group.</span> |
| <span class="grid"><span>`ATTS`</span><span>`type(attribute_type), allocatable`</span></span><br><span class="ind6">Attributes attached to the group.</span> |
| <span class="grid"><span>`VARS`</span><span>`type(variable_type), allocatable`</span></span><br><span class="ind6">Variables defined by the group.</span> |
| <span class="grid"><span>`GRPS`</span><span>`type(group_type), pointer`</span></span><br><span class="ind6">Child groups, shared through pointer association.</span> |

## `NETCDF_TYPE` -- NetCDF Root Group

| Extends |
|:--|
| <span class="ind3">`GROUP_TYPE`</span> |

| Component |
|:--|
| <span class="grid"><span>`FILE`</span><span>`character(len=:), allocatable`</span></span><br><span class="ind6">Path of the open NetCDF file.</span> |
| <span class="grid"><span>`MODE`</span><span>`integer(c_int)`</span></span><br><span class="ind6">NetCDF file access mode.</span> |

## `ERROR_TYPE` -- Operation Error Result

| Component |
|:--|
| <span class="grid"><span>`CODE`</span><span>`integer(c_int)`</span></span><br><span class="ind6">NetCDF status code; zero indicates success.</span> |
| <span class="grid"><span>`MSG`</span><span>`character(len=:), allocatable`</span></span><br><span class="ind6">Diagnostic message for a failed operation.</span> |

## Supported NetCDF Types

The currently supported and unsupported [NetCDF types](https://docs.unidata.ucar.edu/nug/current/md_types.html) are:
- &#x2611; Supported: `CHAR`, `BYTE`, `SHORT`, `INT`, `INT64`, `FLOAT`, `DOUBLE`
- &#x2612; Unsupported: `UNSIGNED BYTE`, `UNSIGNED SHORT`, `UNSIGNED INT`, `UNSIGNED INT64`, `STRING`

<!-- ## Constructions

This library provides operators and generic functions that simplifies the 
construction of these derived types. Let's go through them one by one.

### Dimension type

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
Internally a `dimension_argument_type` is formed by `(24 .and. UNLIMITED)`, this type is then passed to construct the `dimension_type`.

### Attribute type

Attribute type variables are constructed through the operator `.att.`. The first argument has to be a string and the second argument is generic.

```fortran
type(attribute_type), allocatable

atts = ["units" .att. "Kelvin", &
        "description" .att. "Sea Surface Temperature", &
        "mean" .att. 293, &
        "stdv" .att. 5.23]
```

### Variable type

#### Construct a variable through `datarray`

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
named target and remain alive for as long as the variable is used. Also, you can
attach attributes as well:

```fortran
var = datarray("dummy variable", values, [tme, lat, lon], &
  & atts=["units".att."K", "critical".att.273.15], deep=.false.)
```

#### Construct a variable through `initialize`

This library also provides `initialize` if you only know the skeleton of the data array but do not know the actual values that needs to be filled in yet.
One can initialize a `variable_type` by explicitly providing all metadata required. Please refer to [Functions and Subroutines](functions-and-subroutines.md) for more details.

### Group and NetCDF type

The group type is a nested structure, since by [design](https://docs.unidata.ucar.edu/netcdf-c/4.10.0/netcdf_data_model.html) a group may have a subgroup. 
Every NetCDF4 file contains at least one group. This is sometimes referred to as the [root group](https://unidata.github.io/netcdf4-python/). -->
