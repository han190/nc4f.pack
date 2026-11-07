module nc4f_test_nc
use, non_intrinsic :: testdrive, only: unittest_type
implicit none (type, external)
private
public :: collect_nc_attribute, collect_nc_dataset
public :: collect_nc_dimension, collect_nc_error
public :: collect_nc_group, collect_nc_utility
public :: collect_nc_variable, collect_real_data

interface
  module subroutine collect_nc_attribute(tests)
    type(unittest_type), allocatable, intent(out) :: tests(:)
  end subroutine collect_nc_attribute

  module subroutine collect_nc_dataset(tests)
    type(unittest_type), allocatable, intent(out) :: tests(:)
  end subroutine collect_nc_dataset

  module subroutine collect_nc_dimension(tests)
    type(unittest_type), allocatable, intent(out) :: tests(:)
  end subroutine collect_nc_dimension

  module subroutine collect_nc_error(tests)
    type(unittest_type), allocatable, intent(out) :: tests(:)
  end subroutine collect_nc_error

  module subroutine collect_nc_group(tests)
    type(unittest_type), allocatable, intent(out) :: tests(:)
  end subroutine collect_nc_group

  module subroutine collect_nc_utility(tests)
    type(unittest_type), allocatable, intent(out) :: tests(:)
  end subroutine collect_nc_utility

  module subroutine collect_nc_variable(tests)
    type(unittest_type), allocatable, intent(out) :: tests(:)
  end subroutine collect_nc_variable

  module subroutine collect_real_data(tests)
    type(unittest_type), allocatable, intent(out) :: tests(:)
  end subroutine collect_real_data
end interface

end module nc4f_test_nc
