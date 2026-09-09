module nc4f

use :: nc4f_data_struct, only: &
  netcdf_type, variable_type, attribute_type, dimension_type, error_type, &
  allocate_memory, extract, data_array, size, shape, sum, is_failed, not_found, &
  NC_NOERR, NC_EBADID, NC_EINVAL, NC_EINVALCOORDS, NC_ENOTFOUND, &
  NC_ENOTVAR, NC_ENOTATT, NC_EBADDIM, NC_EEDGE, &
  operator(.att.), operator(.dim.), operator(.and.), &
  operator(==), operator(/=), write(formatted)

use :: nc4f_nc, only: &
  open_dataset, close_dataset, to_netcdf, &
  inquire_dimensions, inquire_variable, &
  get_attribute, get_variable, &
  put_attribute, put_variable

end module
