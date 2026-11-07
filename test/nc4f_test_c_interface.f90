module nc4f_test_c_interface
use, non_intrinsic :: testdrive, only: unittest_type
implicit none (type, external)
private
public :: collect_c_interface_attribute, collect_c_interface_dataset
public :: collect_c_interface_dimension, collect_c_interface_error
public :: collect_c_interface_group, collect_c_interface_io
public :: collect_c_interface_utility, collect_c_interface_variable

interface
  module subroutine collect_c_interface_attribute(tests)
    type(unittest_type), allocatable, intent(out) :: tests(:)
  end subroutine collect_c_interface_attribute

  module subroutine collect_c_interface_dataset(tests)
    type(unittest_type), allocatable, intent(out) :: tests(:)
  end subroutine collect_c_interface_dataset

  module subroutine collect_c_interface_dimension(tests)
    type(unittest_type), allocatable, intent(out) :: tests(:)
  end subroutine collect_c_interface_dimension

  module subroutine collect_c_interface_error(tests)
    type(unittest_type), allocatable, intent(out) :: tests(:)
  end subroutine collect_c_interface_error

  module subroutine collect_c_interface_group(tests)
    type(unittest_type), allocatable, intent(out) :: tests(:)
  end subroutine collect_c_interface_group

  module subroutine collect_c_interface_io(tests)
    type(unittest_type), allocatable, intent(out) :: tests(:)
  end subroutine collect_c_interface_io

  module subroutine collect_c_interface_utility(tests)
    type(unittest_type), allocatable, intent(out) :: tests(:)
  end subroutine collect_c_interface_utility

  module subroutine collect_c_interface_variable(tests)
    type(unittest_type), allocatable, intent(out) :: tests(:)
  end subroutine collect_c_interface_variable
end interface

end module nc4f_test_c_interface
