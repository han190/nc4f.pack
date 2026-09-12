!> Error-result predicates for the direct v2 data model.
submodule(nc4f_data_struct) nc4f_data_struct_util

implicit none (type, external)

contains

!> Return false when an error reports that a requested object is absent.
module pure elemental logical function found_error(error) result(is_present)
  type(error_type), intent(in) :: error
  integer(c_int), parameter :: ENOENT = 2_c_int

  select case (error%code)
  case (ENOENT, NC_ENOTFOUND, NC_ENOTVAR, NC_ENOTATT, NC_EBADDIM, NC_ENOGRP)
    is_present = .false.
  case default
    is_present = .true.
  end select
end function found_error

end submodule nc4f_data_struct_util
