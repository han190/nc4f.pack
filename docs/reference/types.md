# Derived Types

## Basic Types

This library implements the [data structures](https://docs.unidata.ucar.edu/netcdf-c/4.10.0/netcdf_data_model.html)
described on the NetCDF website. The basic types are:
  * _Dimension type_: name, length, and if the dimension is unlimited;
    ```fortran
    type :: dimension_type
      integer(c_int) :: id
      character(len=:), allocatable :: name
      integer(int64) :: len
      logical :: is_unlim
    end type dimension_type
    ```
  * _Attribute type_: name and a 1D generic (integer, float, character, ...) array;
    ```fortran
    type :: attribute_type
      integer(c_int) :: id
      character(len=:), allocatable :: name
      integer(data_type) :: dtype
      integer(int64) :: len
      integer(int8), allocatable :: buffer(:)
      integer(int8), contiguous, pointer :: ptr(:)
    end type attribute_type
    ```
  * _Variable type_: name, dimensions, attributes, and an ND generic (integer, float, character, ...) array;
    ```fortran
    type :: variable_type
      integer(c_int) :: id
      character(len=:), allocatable :: name
      integer(data_type) :: dtype
      integer(int64) :: len
      type(dimension_type), allocatable :: dims(:)
      type(attribute_type), allocatable :: atts(:)
      integer(int8), allocatable :: buffer(:)
      integer(int8), contiguous, pointer :: ptr(:)
    end type variable_type
    ```
  * _Group type_: name, dimensions, attributes, variables and nested groups;
    ```fortran
    type :: group_type
      integer(c_int) :: id
      character(len=:), allocatable :: name
      type(dimension_type), allocatable :: dims(:)
      type(attribute_type), allocatable :: atts(:)
      type(variable_type), allocatable :: vars(:)
      type(group_type), pointer :: grps(:)
    end type group_type
    ```
  * _NetCDF type_: the root group that also contains metadata like file and I/O mode;
    ```fortran
    type, extends(group_type) :: netcdf_type
      character(len=:), allocatable :: file
      integer(c_int) :: mode
    end type netcdf_type
    ```
  * _Error type_: this is a library specific type for handling errors.
    ```fortran
    type error_type
      integer(c_int) :: code
      character(len=:), allocatable :: msg
    end type error_type
    ```

## Supported NetCDF Types

The currently supported and unsupported [NetCDF types](https://docs.unidata.ucar.edu/nug/current/md_types.html) are:
- &#x2611; Supported: `CHAR`, `BYTE`, `SHORT`, `INT`, `INT64`, `FLOAT`, `DOUBLE`
- &#x2612; Unsupported: `UNSIGNED BYTE`, `UNSIGNED SHORT`, `UNSIGNED INT`, `UNSIGNED INT64`, `STRING`

## Constructions

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
type(attribute_type), allocatable :: atts(:)

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
Every NetCDF4 file contains at least one group. This is sometimes referred to as the [root group](https://unidata.github.io/netcdf4-python/).
