submodule(nc4f_test_netcdf) nc4f_test_netcdf_variable
use, intrinsic :: iso_fortran_env, only: int64, real32
use, intrinsic :: iso_c_binding, only: c_associated, c_loc, c_ptr
use, non_intrinsic :: testdrive, only: check, &
  & test_error_type => error_type, new_unittest, unittest_type
use, non_intrinsic :: nc4f, only: netcdf_type, variable_type, &
  & model_error_type => error_type, datarray, define_variable, &
  & put_variable, get_variable, inquire_variable, rename_variable, &
  & extract, nameof, &
  & operator(.dim.), operator(.att.), &
  & NC_FLOAT, NC_NOERR, NC_EINVAL, NC_ENOTVAR
use, non_intrinsic :: nc4f_test_utility, only: open_temp, close_temp
implicit none (type, external)

contains

module subroutine collect_netcdf_variable(tests)
  type(unittest_type), allocatable, intent(out) :: tests(:)

  tests = [ &
    & new_unittest("define and inquire variable", test_definition), &
    & new_unittest("put and get variable", test_values), &
    & new_unittest("extract file values", test_extract_values), &
    & new_unittest("rename file variable", test_rename) &
    & ]
end subroutine collect_netcdf_variable

subroutine test_definition(error)
  type(test_error_type), allocatable, intent(out) :: error
  type(netcdf_type) :: nc
  type(variable_type) :: schema, found
  type(model_error_type) :: err

  call open_temp(error, nc)
  if (allocated(error)) return
  call define_variable(nc, "raw", NC_FLOAT, ["x" .dim. 2], err=err)
  call check(error, err%code == NC_NOERR, &
    & "Raw define_variable overload failed")
  if (.not. allocated(error)) then
    schema = datarray("object", [1.0_real32, 2.0_real32], &
      & ["x" .dim. 2])
    call define_variable(nc, schema, err)
    call check(error, err%code == NC_NOERR, &
      & "Object define_variable overload failed")
  end if
  if (.not. allocated(error)) then
    found = inquire_variable(nc, "object", err)
    call check(error, err%code == NC_NOERR .and. &
      & nameof(found) == "object", "inquire_variable failed")
  end if
  call close_temp(error, nc)
end subroutine test_definition

subroutine test_values(error)
  type(test_error_type), allocatable, intent(out) :: error
  type(netcdf_type) :: nc
  type(variable_type) :: source, actual
  type(model_error_type) :: err
  real(real32), pointer :: values(:)

  call open_temp(error, nc)
  if (allocated(error)) return
  source = datarray("v", [1.0_real32, 2.0_real32], &
    & ["x" .dim. 2])
  call define_variable(nc, source, err)
  call check(error, err%code == NC_NOERR, &
    & "Variable setup failed")
  if (.not. allocated(error)) then
    call put_variable(nc, source, err=err)
    call check(error, err%code == NC_NOERR, &
      & "put_variable failed")
  end if
  if (.not. allocated(error)) then
    actual = get_variable(nc, "v", err=err)
    call check(error, err%code == NC_NOERR, &
      & "get_variable failed")
  end if
  if (.not. allocated(error)) then
    call extract(actual, values)
    call check(error, associated(values), &
      & "Read variable has no values")
  end if
  if (.not. allocated(error)) then
    call check(error, all(values == [1.0_real32, 2.0_real32]), &
      & "Read variable values differ")
  end if
  call close_temp(error, nc)
end subroutine test_values

subroutine test_extract_values(error)
  !! Check direct reads, allocation reuse, resizing, and inquiry errors.
  type(test_error_type), allocatable, intent(out) :: error
  !! Test failure reported to test-drive.
  type(netcdf_type) :: nc
  type(variable_type) :: source
  type(model_error_type) :: err
  integer(int64) :: expected(2, 3, 4)
  integer(int64), allocatable, target :: values(:,:,:)
  real(real32), allocatable :: converted(:,:,:)
  real(real32), allocatable :: wrong_rank(:,:)
  type(c_ptr) :: original_address
  integer :: i

  expected = reshape([(int(i, int64), i = 1, 24)], [2, 3, 4])
  call open_temp(error, nc)
  if (allocated(error)) return
  source = datarray("values", expected, &
    & ["x" .dim. 2, "y" .dim. 3, "z" .dim. 4], &
    & atts=["scale_factor".att.0.5_real32])
  call define_variable(nc, source, err)
  call check(error, err%code == NC_NOERR, "Extract setup failed")
  if (.not. allocated(error)) then
    call put_variable(nc, source, err=err)
    call check(error, err%code == NC_NOERR, "Extract write failed")
  end if
  if (.not. allocated(error)) then
    call extract(nc, "values", values, err)
    call check(error, err%code == NC_NOERR .and. &
      & allocated(values), "Direct extraction failed")
  end if
  if (.not. allocated(error)) then
    call check(error, all(values == expected), &
      & "Direct extraction returned wrong values")
  end if
  if (.not. allocated(error)) then
    values = -1_int64
    original_address = c_loc(values(1, 1, 1))
    call extract(nc, "values", values, err)
    call check(error, err%code == NC_NOERR .and. &
      & all(values == expected), "Existing allocation was not filled")
  end if
  if (.not. allocated(error)) then
    call check(error, c_associated(original_address, &
      & c_loc(values(1, 1, 1))), &
      & "Matching extraction replaced the allocation")
  end if
  if (.not. allocated(error)) then
    deallocate (values)
    allocate (values(1, 1, 1))
    call extract(nc, "values", values, err)
    call check(error, err%code == NC_NOERR .and. &
      & all(shape(values) == [2, 3, 4]), &
      & "Direct extraction did not resize the array")
  end if
  if (.not. allocated(error)) then
    call check(error, all(values == expected), &
      & "Resized array has wrong values")
  end if
  if (.not. allocated(error)) then
    call extract(nc, "values", converted, err)
    call check(error, err%code == NC_NOERR .and. &
      & allocated(converted), "Numeric conversion failed")
  end if
  if (.not. allocated(error)) then
    call check(error, all(converted == real(expected, real32)), &
      & "Numeric conversion returned wrong values")
  end if
  if (.not. allocated(error)) then
    call extract(nc, "missing", values, err)
    call check(error, err%code == NC_ENOTVAR .and. &
      & all(values == expected), "Missing variable changed output")
  end if
  if (.not. allocated(error)) then
    call extract(nc, "values", wrong_rank, err)
    call check(error, err%code == NC_EINVAL, &
      & "Wrong-rank extraction was accepted")
  end if
  if (.not. allocated(error)) then
    call extract(nc, "values", values, err, start=[1, 2, 1], &
      & count=[2, 1, 2], stride=[1, 1, 2])
    call check(error, err%code == NC_NOERR, "Strided extraction failed")
  end if
  if (.not. allocated(error)) then
    call check(error, all(shape(values) == [2, 1, 2]), "Wrong hyperslab shape")
  end if
  if (.not. allocated(error)) then
    call check(error, all(values == expected(:, 2:2, 1:4:2)), "Wrong hyperslab values")
  end if
  if (.not. allocated(error)) then
    call extract(nc, "values", converted, start=[2, 2, 3], err=err)
    call check(error, err%code == NC_NOERR, "Start-only extraction failed")
  end if
  if (.not. allocated(error)) then
    call check(error, all(shape(converted) == [1, 2, 2]), "Wrong start-only shape")
  end if
  if (.not. allocated(error)) then
    call check(error, all(converted == real(expected(2:2, 2:3, 3:4), real32)), &
      & "Wrong start-only values")
  end if
  if (.not. allocated(error)) then
    call extract(nc, "values", values, err, start=[1, 1, 2], count=[2, 3, 2])
    call check(error, err%code == NC_NOERR, "Contiguous hyperslab failed")
  end if
  if (.not. allocated(error)) then
    call check(error, all(shape(values) == [2, 3, 2]), "Wrong contiguous shape")
  end if
  if (.not. allocated(error)) then
    call check(error, all(values == expected(:, :, 2:3)), "Wrong contiguous values")
  end if
  do i = 1, 10
    if (allocated(error)) exit
    select case (i)
    case (1)
      call extract(nc, "values", values, err, count=[1, 1, 1])
    case (2)
      call extract(nc, "values", values, err, stride=[1, 1, 1])
    case (3)
      call extract(nc, "values", values, err, start=[1, 1])
    case (4)
      call extract(nc, "values", values, err, start=[1, 1, 1], count=[1, 1])
    case (5)
      call extract(nc, "values", values, err, start=[1, 1, 1], &
        & count=[1, 1, 1], stride=[1, 1])
    case (6)
      call extract(nc, "values", values, err, start=[0, 1, 1])
    case (7)
      call extract(nc, "values", values, err, start=[1, 1, 1], count=[0, 1, 1])
    case (8)
      call extract(nc, "values", values, err, start=[1, 1, 1], &
        & count=[1, 1, 1], stride=[1, -1, 1])
    case (9)
      call extract(nc, "values", values, err, start=[3, 1, 1])
    case (10)
      call extract(nc, "values", values, err, start=[1, 1, 1], &
        & count=[2, 1, 1], stride=[huge(1), 1, 1])
    end select
    call check(error, err%code /= NC_NOERR, "Invalid hyperslab was accepted")
    if (allocated(error)) exit
    call check(error, allocated(values), "Invalid hyperslab deallocated output")
    if (allocated(error)) exit
    call check(error, all(values == expected(:, :, 2:3)), "Invalid hyperslab changed output")
  end do
  call close_temp(error, nc)
end subroutine test_extract_values

subroutine test_rename(error)
  type(test_error_type), allocatable, intent(out) :: error
  type(netcdf_type) :: nc
  type(variable_type) :: var
  type(model_error_type) :: err

  call open_temp(error, nc)
  if (allocated(error)) return
  call define_variable(nc, "old", NC_FLOAT, ["x" .dim. 1], err=err)
  call check(error, err%code == NC_NOERR, &
    & "Variable setup failed")
  if (.not. allocated(error)) then
    var = inquire_variable(nc, "old", err)
    call rename_variable(nc, var, "middle", &
      & update_file=.true., err=err)
    call check(error, err%code == NC_NOERR .and. &
      & nameof(var) == "middle", "Object variable rename failed")
  end if
  if (.not. allocated(error)) then
    call rename_variable(nc, "middle", "new", &
      & update_file=.true., err=err)
    call check(error, err%code == NC_NOERR, &
      & "Named variable rename failed")
  end if
  if (.not. allocated(error)) then
    var = inquire_variable(nc, "new", err)
    call check(error, err%code == NC_NOERR .and. &
      & nameof(var) == "new", "Renamed variable was not found")
  end if
  call close_temp(error, nc)
end subroutine test_rename

end submodule nc4f_test_netcdf_variable
