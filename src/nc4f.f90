module nc4f

use, non_intrinsic :: nc4f_ds
use, non_intrinsic :: nc4f_nc
use, non_intrinsic :: nc4f_c_interface
implicit none (type, external)

public :: &
  & attribute_type, dimension_type, error_type, &
  & group_type, netcdf_type, variable_type, storage_type
public :: &
  & NC_EBADID, NC_EBADDIM, NC_EBADGRPID, NC_EEDGE, NC_EBADTYPE, NC_EPERM, &
  & NC_EINVAL, NC_EINVALCOORDS, NC_ENOGRP, NC_ENOTATT, NC_ENOTFOUND, &
  & NC_ENOTVAR, NC_NOERR, NC_EBADNAME, NC_EMAXNAME, NC_ENAMEINUSE
public :: NC_BYTE, NC_CHAR, NC_SHORT, NC_INT, NC_INT64, NC_FLOAT, NC_DOUBLE
public :: NC_ENDIAN_NATIVE, NC_ENDIAN_LITTLE, NC_ENDIAN_BIG
public :: &
  & datarray, dataset, extract, initialize, set_storage, shape, size, sum, &
  & operator(.att.), operator(.and.), operator(.dim.), operator(.exists.), &
  & operator(==), operator(/=)
public :: &
  & open_netcdf, close_netcdf, to_netcdf, define_variable, put_variable, &
  & inquire_dimensions, inquire_variable, inquire_subgroups, inquire_group, &
  & rename_attribute, rename_variable, rename_group, rename_dimension, &
  & get_attribute, get_variable, get_group, delete_attribute, error_msg
private

end module nc4f
