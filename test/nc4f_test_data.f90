module nc4f_test_data
use, non_intrinsic :: testdrive, only: unittest_type
implicit none (type, external)
private
public :: collect_data_arithmetic, collect_data_attribute
public :: collect_data_attribute_constructor
public :: collect_data_clone
public :: collect_data_dimension, collect_data_extract
public :: collect_data_expression
public :: collect_data_group, collect_data_io
public :: collect_data_utility, collect_data_validate
public :: collect_data_variable
public :: collect_data_variable_constructor

interface
  module subroutine collect_data_arithmetic(tests)
    type(unittest_type), allocatable, intent(out) :: tests(:)
  end subroutine collect_data_arithmetic

  module subroutine collect_data_attribute(tests)
    type(unittest_type), allocatable, intent(out) :: tests(:)
  end subroutine collect_data_attribute

  module subroutine collect_data_attribute_constructor(tests)
    type(unittest_type), allocatable, intent(out) :: tests(:)
  end subroutine collect_data_attribute_constructor

  module subroutine collect_data_clone(tests)
    type(unittest_type), allocatable, intent(out) :: tests(:)
  end subroutine collect_data_clone

  module subroutine collect_data_dimension(tests)
    type(unittest_type), allocatable, intent(out) :: tests(:)
  end subroutine collect_data_dimension

  module subroutine collect_data_extract(tests)
    type(unittest_type), allocatable, intent(out) :: tests(:)
  end subroutine collect_data_extract

  module subroutine collect_data_expression(tests)
    type(unittest_type), allocatable, intent(out) :: tests(:)
  end subroutine collect_data_expression

  module subroutine collect_data_group(tests)
    type(unittest_type), allocatable, intent(out) :: tests(:)
  end subroutine collect_data_group

  module subroutine collect_data_io(tests)
    type(unittest_type), allocatable, intent(out) :: tests(:)
  end subroutine collect_data_io

  module subroutine collect_data_utility(tests)
    type(unittest_type), allocatable, intent(out) :: tests(:)
  end subroutine collect_data_utility

  module subroutine collect_data_validate(tests)
    type(unittest_type), allocatable, intent(out) :: tests(:)
  end subroutine collect_data_validate

  module subroutine collect_data_variable(tests)
    type(unittest_type), allocatable, intent(out) :: tests(:)
  end subroutine collect_data_variable

  module subroutine collect_data_variable_constructor(tests)
    type(unittest_type), allocatable, intent(out) :: tests(:)
  end subroutine collect_data_variable_constructor
end interface

end module nc4f_test_data
