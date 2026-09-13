!> Public facade for the v2 package while its operational APIs are ported.
module nc4f

use, non_intrinsic :: nc4f_data_struct, only: &
  attribute_type, dimension_type, error_type, group_type, netcdf_type, variable_type, &
  NC_EBADID, NC_EBADDIM, NC_EBADGRPID, NC_EEDGE, NC_EINVAL, NC_EINVALCOORDS, NC_ENOGRP, &
  NC_ENOTATT, NC_ENOTFOUND, NC_ENOTVAR, NC_NOERR, &
  datarray, dataset, extract, initialize, operator(.att.), operator(.and.), operator(.dim.), &
  operator(==), operator(/=), shape, size, sum, write(formatted)
use, non_intrinsic :: nc4f_nc
implicit none (type, external)

public :: attribute_type, dimension_type, error_type, group_type, netcdf_type, variable_type
public :: NC_EBADID, NC_EBADDIM, NC_EBADGRPID, NC_EEDGE, NC_EINVAL, NC_EINVALCOORDS, NC_ENOGRP, &
  & NC_ENOTATT, NC_ENOTFOUND, NC_ENOTVAR, NC_NOERR
public :: datarray, dataset, extract, initialize, operator(.att.), operator(.and.), operator(.dim.), &
  operator(==), operator(/=), shape, size, sum, write(formatted)

end module nc4f
