module nc4f

use, non_intrinsic :: nc4f_data
use, non_intrinsic :: nc4f_netcdf
use, non_intrinsic :: nc4f_c_interface
implicit none (type, external)

public :: netcdf_type, group_type
public :: variable_type, dimension_type, attribute_type, expression_type
public :: storage_type, error_type

public :: NC_EBADID, NC_EBADDIM, NC_EBADGRPID, NC_EEDGE, NC_EBADTYPE, NC_EPERM
public :: NC_EINVAL, NC_EINVALCOORDS, NC_ENOGRP, NC_ENOTATT, NC_ENOTFOUND
public :: NC_ENOTVAR, NC_NOERR, NC_EBADNAME, NC_EMAXNAME, NC_ENAMEINUSE
public :: NC_ENDIAN_NATIVE, NC_ENDIAN_LITTLE, NC_ENDIAN_BIG
public :: NC_BYTE, NC_CHAR, NC_SHORT, NC_INT, NC_INT64, NC_FLOAT, NC_DOUBLE

public :: datarray, dataset, extract, initialize, set_storage
public :: evaluate
public :: abs, sqrt, exp, log, log10, sin, cos, tan
public :: asin, acos, atan, sinh, cosh, tanh, asinh, acosh, atanh
public :: erf, erfc, erfc_scaled, gamma, log_gamma
public :: bessel_j0, bessel_j1, bessel_y0, bessel_y1
public :: nameof, typeof, shape, size, sum
public :: operator(.att.), operator(.and.), operator(.dim.), operator(.exists.)
public :: operator(==), operator(/=), operator(+), operator(-), &
  & operator(*), operator(/), operator(**), assignment(=)

public :: open_netcdf, close_netcdf, to_netcdf, define_variable, put_variable
public :: inquire_dimensions, inquire_variable, inquire_subgroups, inquire_group
public :: rename_attribute, rename_variable, rename_group, rename_dimension
public :: get_attribute, get_variable, get_group, delete_attribute, error_msg
private

end module nc4f
