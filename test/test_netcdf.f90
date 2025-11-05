program main

use, non_intrinsic :: module_netcdf
implicit none

character(len=:), allocatable :: path
type(netcdf_type) :: nc
type(attribute_type), allocatable :: atts(:)
type(dimension_type), allocatable :: dims(:)
logical, parameter :: unlimited = .true.

path = "/Users/htang/Data/wrf/wrfout_d01_2016-08-14_12_00_00"
nc = open_dataset(path, "r")
atts = get_attributes(nc)
dims = get_dimensions(nc)
print "(dt)", atts
print *, ""
print "(dt)", dims
print *, ""

atts = [ &
	& "name" .att. "T", &
	& "description" .att. "air temperature", &
	& "units" .att. "degC", &
	& "scale_factor" .att. 1, &
	& "offset" .att. 1.0, &
	& "weights" .att. [1., 2., 3., 4.], &
	& "indices" .att. [1, 2, 3, 4] &
]
print "(dt)", atts
print *, ""

dims = [ &
	& "west_east" .dim. 800, &
	& "south_north" .dim. 800, &
	& "bottom_top" .dim. 37, &
	& "time" .dim. (10 .and. unlimited) &
]
print "(dt)", dims
print *, ""

end program main