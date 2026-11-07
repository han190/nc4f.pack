submodule(nc4f_test_ds) nc4f_test_ds_validate
use, non_intrinsic :: testdrive, only: check, error_type, new_unittest, &
  & unittest_type
use, non_intrinsic :: nc4f, only: dimension_type, &
  & model_error_type => error_type, rename_dimension, &
  & operator(.dim.), NC_EBADNAME
implicit none (type, external)

contains

module subroutine collect_ds_validate(tests)
  type(unittest_type), allocatable, intent(out) :: tests(:)

  tests = [new_unittest("name validation on rename", test_name)]
end subroutine collect_ds_validate

subroutine test_name(error)
  type(error_type), allocatable, intent(out) :: error
  type(dimension_type) :: dim
  type(model_error_type) :: err

  dim = "valid" .dim. 2
  call rename_dimension(dim, "", err)
  call check(error, err%code == NC_EBADNAME .and. &
    & dim%name == "valid", "Invalid name changed the dimension")
end subroutine test_name

end submodule nc4f_test_ds_validate
