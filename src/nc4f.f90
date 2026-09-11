module nc4f

use :: nc4f_data_struct, only: &
  netcdf_type, group_type, variable_type, attribute_type, dimension_type, error_type, &
  initialize, extract, data_array, data_set, size, shape, sum, failed, found, &
  NC_NOERR, NC_EBADID, NC_EINVAL, NC_EINVALCOORDS, NC_ENOTFOUND, &
  NC_ENOTVAR, NC_ENOTATT, NC_EBADDIM, NC_EEDGE, NC_EBADGRPID, NC_ENOGRP, &
  operator(.att.), operator(.dim.), operator(.and.), &
  operator(==), operator(/=), write(formatted)

use :: nc4f_nc, only: &
  open_dataset, close_dataset, to_netcdf, to_netcdf_grp, to_netcdf_grps, &
  inquire_dimensions, inquire_variable, &
  get_attribute, get_variable, &
  put_attribute, put_variable, &
  get_group, inquire_groups, inquire_group

end module
