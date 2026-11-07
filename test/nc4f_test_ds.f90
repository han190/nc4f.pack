module nc4f_test_ds
use, non_intrinsic :: testdrive, only: unittest_type
implicit none (type, external)
private
public :: collect_ds_arithmetic, collect_ds_attribute
public :: collect_ds_attribute_constructor, collect_ds_clone
public :: collect_ds_dimension, collect_ds_extract
public :: collect_ds_group, collect_ds_io
public :: collect_ds_utility, collect_ds_validate
public :: collect_ds_variable, collect_ds_variable_constructor

interface
  module subroutine collect_ds_arithmetic(tests)
    type(unittest_type), allocatable, intent(out) :: tests(:)
  end subroutine collect_ds_arithmetic

  module subroutine collect_ds_attribute(tests)
    type(unittest_type), allocatable, intent(out) :: tests(:)
  end subroutine collect_ds_attribute

  module subroutine collect_ds_attribute_constructor(tests)
    type(unittest_type), allocatable, intent(out) :: tests(:)
  end subroutine collect_ds_attribute_constructor

  module subroutine collect_ds_clone(tests)
    type(unittest_type), allocatable, intent(out) :: tests(:)
  end subroutine collect_ds_clone

  module subroutine collect_ds_dimension(tests)
    type(unittest_type), allocatable, intent(out) :: tests(:)
  end subroutine collect_ds_dimension

  module subroutine collect_ds_extract(tests)
    type(unittest_type), allocatable, intent(out) :: tests(:)
  end subroutine collect_ds_extract

  module subroutine collect_ds_group(tests)
    type(unittest_type), allocatable, intent(out) :: tests(:)
  end subroutine collect_ds_group

  module subroutine collect_ds_io(tests)
    type(unittest_type), allocatable, intent(out) :: tests(:)
  end subroutine collect_ds_io

  module subroutine collect_ds_utility(tests)
    type(unittest_type), allocatable, intent(out) :: tests(:)
  end subroutine collect_ds_utility

  module subroutine collect_ds_validate(tests)
    type(unittest_type), allocatable, intent(out) :: tests(:)
  end subroutine collect_ds_validate

  module subroutine collect_ds_variable(tests)
    type(unittest_type), allocatable, intent(out) :: tests(:)
  end subroutine collect_ds_variable

  module subroutine collect_ds_variable_constructor(tests)
    type(unittest_type), allocatable, intent(out) :: tests(:)
  end subroutine collect_ds_variable_constructor
end interface

end module nc4f_test_ds
