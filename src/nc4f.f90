module nc4f

use :: nc4f_data_struct, only: &
  netcdf_type, variable_type, attribute_type, dimension_type, &
  allocate_variable, allocate_attribute, extract, &
  data_array, size, shape, sum, &
  operator(+), operator(-), operator(*), operator(/), operator(**), &
  operator(.att.), operator(.dim.), operator(.and.), &
  operator(==), operator(/=), write(formatted)

use :: nc4f_nc, only: &
  open_dataset, close_dataset, to_netcdf, &
  inquire_dimensions, inquire_variable, &
  get_attribute, get_variable, &
  put_attribute, put_variable

end module
