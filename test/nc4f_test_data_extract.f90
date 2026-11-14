submodule(nc4f_test_data) nc4f_test_data_extract
use, intrinsic :: iso_fortran_env, only: int8, int16, int32, int64, real32, real64
use, non_intrinsic :: testdrive, only: check, error_type, new_unittest, &
  & unittest_type
use, non_intrinsic :: nc4f, only: attribute_type, variable_type, coordinate_type, &
  & datarray, extract, operator(.att.), operator(.dim.)
implicit none (type, external)

contains

module subroutine collect_data_extract(tests)
  type(unittest_type), allocatable, intent(out) :: tests(:)

  tests = [ &
    & new_unittest("extract attribute values", test_attribute), &
    & new_unittest("extract variable shape and values", test_variable), &
    & new_unittest("extract coordinate views", test_coordinate) &
    & ]
end subroutine collect_data_extract

subroutine test_attribute(error)
  type(error_type), allocatable, intent(out) :: error
  type(attribute_type) :: att
  integer(int32), pointer :: values(:)

  att = "levels" .att. [100_int32, 200_int32]
  call extract(att, values)
  call check(error, associated(values), "Attribute extraction failed")
  if (allocated(error)) return
  call check(error, all(values == [100_int32, 200_int32]), &
    & "Extracted attribute values differ")
end subroutine test_attribute

subroutine test_variable(error)
  type(error_type), allocatable, intent(out) :: error
  type(variable_type) :: var
  real(real32), pointer :: values(:, :)

  var = datarray("temperature", reshape([1.0_real32, 2.0_real32, &
    & 3.0_real32, 4.0_real32], [2, 2]), &
    & ["x" .dim. 2, "y" .dim. 2])
  call extract(var, values)
  call check(error, associated(values), "Variable extraction failed")
  if (allocated(error)) return
  call check(error, all(shape(values) == [2, 2]) .and. &
    & all(values == reshape([1.0_real32, 2.0_real32, &
    & 3.0_real32, 4.0_real32], [2, 2])), &
    & "Extracted variable values differ")
end subroutine test_variable

subroutine test_coordinate(error)
  type(error_type), allocatable, intent(out) :: error
  type(coordinate_type), target :: coord

  block
    integer(int8), pointer :: flat(:), grid(:, :)
    integer(int8) :: empty(0, 2)

    coord = coordinate_type("xy", reshape([1_int8, 2_int8, 3_int8, 4_int8], [2, 2]), &
      & ["x".dim.2, "y".dim.2])
    call extract(coord, flat)
    call extract(coord, grid)
    call check(error, associated(flat) .and. associated(grid), &
      & "int8 coordinate views are not associated")
    if (allocated(error)) return
    call check(error, size(flat) == 4 .and. all(shape(grid) == [2, 2]), &
      & "int8 coordinate view shapes differ")
    if (allocated(error)) return
    call check(error, all(flat == [1_int8, 2_int8, 3_int8, 4_int8]) .and. &
      & all(reshape(grid, [4]) == flat), "int8 coordinate values differ")
    if (allocated(error)) return
    grid(2, 1) = 9_int8
    call check(error, flat(2) == 9_int8, "int8 views do not share storage")
    if (allocated(error)) return
    nullify (flat, grid)
    call extract(coord, flat)
    call check(error, flat(2) == 9_int8, "int8 coordinate storage was copied")
    if (allocated(error)) return
    coord = coordinate_type("empty", empty, ["x".dim.0, "y".dim.2])
    call extract(coord, flat)
    call extract(coord, grid)
    call check(error, .not. associated(flat) .and. .not. associated(grid), &
      & "Empty int8 coordinate views are not null")
    if (allocated(error)) return
  end block

  block
    integer(int16), pointer :: flat(:), grid(:, :)
    integer(int16) :: empty(0, 2)

    coord = coordinate_type("xy", reshape([1_int16, 2_int16, 3_int16, 4_int16], [2, 2]), &
      & ["x".dim.2, "y".dim.2])
    call extract(coord, flat)
    call extract(coord, grid)
    call check(error, associated(flat) .and. associated(grid), &
      & "int16 coordinate views are not associated")
    if (allocated(error)) return
    call check(error, size(flat) == 4 .and. all(shape(grid) == [2, 2]), &
      & "int16 coordinate view shapes differ")
    if (allocated(error)) return
    call check(error, all(flat == [1_int16, 2_int16, 3_int16, 4_int16]) .and. &
      & all(reshape(grid, [4]) == flat), "int16 coordinate values differ")
    if (allocated(error)) return
    grid(2, 1) = 9_int16
    call check(error, flat(2) == 9_int16, "int16 views do not share storage")
    if (allocated(error)) return
    nullify (flat, grid)
    call extract(coord, flat)
    call check(error, flat(2) == 9_int16, "int16 coordinate storage was copied")
    if (allocated(error)) return
    coord = coordinate_type("empty", empty, ["x".dim.0, "y".dim.2])
    call extract(coord, flat)
    call extract(coord, grid)
    call check(error, .not. associated(flat) .and. .not. associated(grid), &
      & "Empty int16 coordinate views are not null")
    if (allocated(error)) return
  end block

  block
    integer(int32), pointer :: flat(:), grid(:, :)
    integer(int32) :: empty(0, 2)

    coord = coordinate_type("xy", reshape([1_int32, 2_int32, 3_int32, 4_int32], [2, 2]), &
      & ["x".dim.2, "y".dim.2])
    call extract(coord, flat)
    call extract(coord, grid)
    call check(error, associated(flat) .and. associated(grid), &
      & "int32 coordinate views are not associated")
    if (allocated(error)) return
    call check(error, size(flat) == 4 .and. all(shape(grid) == [2, 2]), &
      & "int32 coordinate view shapes differ")
    if (allocated(error)) return
    call check(error, all(flat == [1_int32, 2_int32, 3_int32, 4_int32]) .and. &
      & all(reshape(grid, [4]) == flat), "int32 coordinate values differ")
    if (allocated(error)) return
    grid(2, 1) = 9_int32
    call check(error, flat(2) == 9_int32, "int32 views do not share storage")
    if (allocated(error)) return
    nullify (flat, grid)
    call extract(coord, flat)
    call check(error, flat(2) == 9_int32, "int32 coordinate storage was copied")
    if (allocated(error)) return
    coord = coordinate_type("empty", empty, ["x".dim.0, "y".dim.2])
    call extract(coord, flat)
    call extract(coord, grid)
    call check(error, .not. associated(flat) .and. .not. associated(grid), &
      & "Empty int32 coordinate views are not null")
    if (allocated(error)) return
  end block

  block
    integer(int64), pointer :: flat(:), grid(:, :)
    integer(int64) :: empty(0, 2)

    coord = coordinate_type("xy", reshape([1_int64, 2_int64, 3_int64, 4_int64], [2, 2]), &
      & ["x".dim.2, "y".dim.2])
    call extract(coord, flat)
    call extract(coord, grid)
    call check(error, associated(flat) .and. associated(grid), &
      & "int64 coordinate views are not associated")
    if (allocated(error)) return
    call check(error, size(flat) == 4 .and. all(shape(grid) == [2, 2]), &
      & "int64 coordinate view shapes differ")
    if (allocated(error)) return
    call check(error, all(flat == [1_int64, 2_int64, 3_int64, 4_int64]) .and. &
      & all(reshape(grid, [4]) == flat), "int64 coordinate values differ")
    if (allocated(error)) return
    grid(2, 1) = 9_int64
    call check(error, flat(2) == 9_int64, "int64 views do not share storage")
    if (allocated(error)) return
    nullify (flat, grid)
    call extract(coord, flat)
    call check(error, flat(2) == 9_int64, "int64 coordinate storage was copied")
    if (allocated(error)) return
    coord = coordinate_type("empty", empty, ["x".dim.0, "y".dim.2])
    call extract(coord, flat)
    call extract(coord, grid)
    call check(error, .not. associated(flat) .and. .not. associated(grid), &
      & "Empty int64 coordinate views are not null")
    if (allocated(error)) return
  end block

  block
    real(real32), pointer :: flat(:), grid(:, :)
    real(real32) :: empty(0, 2)

    coord = coordinate_type("xy", reshape([1.0_real32, 2.0_real32, 3.0_real32, 4.0_real32], [2, 2]), &
      & ["x".dim.2, "y".dim.2])
    call extract(coord, flat)
    call extract(coord, grid)
    call check(error, associated(flat) .and. associated(grid), &
      & "real32 coordinate views are not associated")
    if (allocated(error)) return
    call check(error, size(flat) == 4 .and. all(shape(grid) == [2, 2]), &
      & "real32 coordinate view shapes differ")
    if (allocated(error)) return
    call check(error, all(flat == [1.0_real32, 2.0_real32, 3.0_real32, 4.0_real32]) .and. &
      & all(reshape(grid, [4]) == flat), "real32 coordinate values differ")
    if (allocated(error)) return
    grid(2, 1) = 9.0_real32
    call check(error, flat(2) == 9.0_real32, "real32 views do not share storage")
    if (allocated(error)) return
    nullify (flat, grid)
    call extract(coord, flat)
    call check(error, flat(2) == 9.0_real32, "real32 coordinate storage was copied")
    if (allocated(error)) return
    coord = coordinate_type("empty", empty, ["x".dim.0, "y".dim.2])
    call extract(coord, flat)
    call extract(coord, grid)
    call check(error, .not. associated(flat) .and. .not. associated(grid), &
      & "Empty real32 coordinate views are not null")
    if (allocated(error)) return
  end block

  block
    real(real64), pointer :: flat(:), grid(:, :)
    real(real64) :: empty(0, 2)

    coord = coordinate_type("xy", reshape([1.0_real64, 2.0_real64, 3.0_real64, 4.0_real64], [2, 2]), &
      & ["x".dim.2, "y".dim.2])
    call extract(coord, flat)
    call extract(coord, grid)
    call check(error, associated(flat) .and. associated(grid), &
      & "real64 coordinate views are not associated")
    if (allocated(error)) return
    call check(error, size(flat) == 4 .and. all(shape(grid) == [2, 2]), &
      & "real64 coordinate view shapes differ")
    if (allocated(error)) return
    call check(error, all(flat == [1.0_real64, 2.0_real64, 3.0_real64, 4.0_real64]) .and. &
      & all(reshape(grid, [4]) == flat), "real64 coordinate values differ")
    if (allocated(error)) return
    grid(2, 1) = 9.0_real64
    call check(error, flat(2) == 9.0_real64, "real64 views do not share storage")
    if (allocated(error)) return
    nullify (flat, grid)
    call extract(coord, flat)
    call check(error, flat(2) == 9.0_real64, "real64 coordinate storage was copied")
    if (allocated(error)) return
    coord = coordinate_type("empty", empty, ["x".dim.0, "y".dim.2])
    call extract(coord, flat)
    call extract(coord, grid)
    call check(error, .not. associated(flat) .and. .not. associated(grid), &
      & "Empty real64 coordinate views are not null")
    if (allocated(error)) return
  end block

end subroutine test_coordinate

end submodule nc4f_test_data_extract
