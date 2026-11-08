module nc4f_test_netcdf
use, non_intrinsic :: testdrive, only: unittest_type
implicit none (type, external)
private
public :: collect_netcdf_attribute, collect_netcdf_dataset
public :: collect_netcdf_dimension, collect_netcdf_error
public :: collect_netcdf_group, collect_netcdf_utility
public :: collect_netcdf_variable, collect_real_data

interface
  module subroutine collect_netcdf_attribute(tests)
    type(unittest_type), allocatable, intent(out) :: tests(:)
  end subroutine collect_netcdf_attribute

  module subroutine collect_netcdf_dataset(tests)
    type(unittest_type), allocatable, intent(out) :: tests(:)
  end subroutine collect_netcdf_dataset

  module subroutine collect_netcdf_dimension(tests)
    type(unittest_type), allocatable, intent(out) :: tests(:)
  end subroutine collect_netcdf_dimension

  module subroutine collect_netcdf_error(tests)
    type(unittest_type), allocatable, intent(out) :: tests(:)
  end subroutine collect_netcdf_error

  module subroutine collect_netcdf_group(tests)
    type(unittest_type), allocatable, intent(out) :: tests(:)
  end subroutine collect_netcdf_group

  module subroutine collect_netcdf_utility(tests)
    type(unittest_type), allocatable, intent(out) :: tests(:)
  end subroutine collect_netcdf_utility

  module subroutine collect_netcdf_variable(tests)
    type(unittest_type), allocatable, intent(out) :: tests(:)
  end subroutine collect_netcdf_variable

  module subroutine collect_real_data(tests)
    type(unittest_type), allocatable, intent(out) :: tests(:)
  end subroutine collect_real_data
end interface

end module nc4f_test_netcdf
