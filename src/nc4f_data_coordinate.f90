submodule(nc4f_data) nc4f_data_coordinate
!! Validate and inspect owned numeric coordinate arrays.
implicit none (type, external)
contains

pure module subroutine validate_coordinate(coord, err)
  type(coordinate_type), intent(in) :: coord
  type(error_type), intent(out) :: err
  integer(int64) :: count
  integer :: i, bytes

  err = error_type()
  if (.not. allocated(coord%name) .or. &
    & .not. allocated(coord%dims) .or. &
    & .not. allocated(coord%buffer)) then
    err = error_type(INVALID, "coordinate", "Incomplete coordinate.")
    return
  end if
  if (len_trim(coord%name) == 0) then
    err = error_type(INVALID, "coordinate", "Blank coordinate name.")
    return
  end if
  select case (coord%dtype)
  case (BYTE_TYPE, SHORT_TYPE, INT_TYPE, INT64_TYPE, &
    & FLOAT_TYPE, DOUBLE_TYPE)
  case default
    err = error_type(INVALID, "coordinate", &
      & "Coordinates require numeric data.")
    return
  end select
  count = 1_int64
  do i = 1, size(coord%dims)
    if (.not. allocated(coord%dims(i)%name)) then
      err = error_type(INVALID, "coordinate", "Unnamed dimension.")
      return
    end if
    if (coord%dims(i)%len < 0) then
      err = error_type(INVALID, "coordinate", "Negative dimension length.")
      return
    end if
    if (coord%dims(i)%len > 0) then
      if (count > huge(count)/coord%dims(i)%len) then
        err = error_type(INVALID, "coordinate", &
          & "Dimension product overflow.")
        return
      end if
    end if
    count = count*coord%dims(i)%len
  end do
  if (count /= coord%len) then
    err = error_type(INVALID, "coordinate", &
      & "Coordinate shape differs from element count.")
    return
  end if
  call compute_buffer_size(coord%dtype, coord%len, bytes, err)
  if (.exists. err) return
  if (size(coord%buffer, kind=int64) /= int(bytes, int64)) then
    err = error_type(INVALID, "coordinate", &
      & "Coordinate buffer size differs.")
  end if
end subroutine validate_coordinate

pure elemental module function eq_coord(a, b) result(equal)
  type(coordinate_type), intent(in) :: a, b
  logical :: equal

  equal = a%dtype == b%dtype .and. a%len == b%len
  if (.not. equal) return
  equal = allocated(a%name) .eqv. allocated(b%name)
  if (.not. equal) return
  if (allocated(a%name)) then
    equal = a%name == b%name
    if (.not. equal) return
  end if
  equal = allocated(a%dims) .eqv. allocated(b%dims)
  if (.not. equal) return
  if (allocated(a%dims)) then
    equal = size(a%dims) == size(b%dims)
    if (.not. equal) return
    equal = all(a%dims == b%dims)
    if (.not. equal) return
  end if
  equal = allocated(a%atts) .eqv. allocated(b%atts)
  if (.not. equal) return
  if (allocated(a%atts)) then
    equal = size(a%atts) == size(b%atts)
    if (.not. equal) return
    equal = all(a%atts == b%atts)
    if (.not. equal) return
  end if
  equal = allocated(a%buffer) .eqv. allocated(b%buffer)
  if (.not. equal) return
  if (allocated(a%buffer)) then
    equal = size(a%buffer) == size(b%buffer)
    if (equal) equal = all(a%buffer == b%buffer)
  end if
end function eq_coord

pure elemental module function neq_coord(a, b) result(unequal)
  type(coordinate_type), intent(in) :: a, b
  logical :: unequal

  unequal = .not. eq_coord(a, b)
end function neq_coord

pure module subroutine validate_coordinate_for_var(coords, var, err)
  !! Require unique names and ordered dimension subsets.
  type(coordinate_type), intent(in) :: coords(:)
  type(variable_type), intent(in) :: var
  type(error_type), intent(out) :: err
  integer :: i, j, axis

  err = error_type()
  if (.not. allocated(var%dims)) then
    err = error_type(INVALID, "coordinate", &
      & "Variable dimensions are absent.")
    return
  end if
  do i = 1, size(coords)
    call validate_coordinate(coords(i), err)
    if (.exists. err) return
    do j = 1, i - 1
      if (coords(i)%name == coords(j)%name) then
        err = error_type(INVALID, "coordinate", &
          & "Duplicate coordinate name.")
        return
      end if
    end do
    axis = 1
    do j = 1, size(coords(i)%dims)
      do while (axis <= size(var%dims))
        if (coords(i)%dims(j) == var%dims(axis)) exit
        axis = axis + 1
      end do
      if (axis > size(var%dims)) then
        err = error_type(INVALID, "coordinate", &
          & "Coordinate dimensions must be an ordered subset.")
        return
      end if
      axis = axis + 1
    end do
  end do
end subroutine validate_coordinate_for_var

pure module function coordinate_index(coords, name) result(index)
  type(coordinate_type), intent(in) :: coords(:)
  character(len=*), intent(in) :: name
  integer :: index, i

  index = 0
  do i = 1, size(coords)
    if (.not. allocated(coords(i)%name)) cycle
    if (coords(i)%name == name) then
      index = i
      return
    end if
  end do
end function coordinate_index

pure subroutine coordinate_byte_offset(coord, indices, dtype, pos, err)
  type(coordinate_type), intent(in) :: coord
  integer, intent(in) :: indices(:)
  integer(data_type), intent(in) :: dtype
  integer(int64), intent(out) :: pos
  type(error_type), intent(out) :: err
  integer(int64) :: location, stride
  integer :: i

  call validate_coordinate(coord, err)
  pos = 0
  if (.exists. err) return
  if (coord%dtype /= dtype .or. size(indices) /= size(coord%dims)) then
    err = error_type(INVALID, "coordinate_at", &
      & "Coordinate type or rank differs.")
    return
  end if
  location = 0
  stride = 1
  do i = 1, size(indices)
    if (indices(i) < 1 .or. indices(i) > coord%dims(i)%len) then
      err = error_type(INVALID_COORDS, "coordinate_at", &
        & "Index exceeds coordinate bounds.")
      return
    end if
    location = location + (indices(i) - 1)*stride
    stride = stride*coord%dims(i)%len
  end do
  pos = location*buffer_size(dtype, 1_int64) + 1
end subroutine coordinate_byte_offset

module subroutine coordinate_at_int8(coord, indices, value, err)
  type(coordinate_type), target, intent(in) :: coord
  integer, intent(in) :: indices(:)
  integer(int8), intent(out) :: value
  type(error_type), intent(out), optional :: err
  type(error_type) :: op_err
  integer(int64) :: pos

  call coordinate_byte_offset(coord, indices, BYTE_TYPE, pos, op_err)
  if (.exists. op_err) then
    call return_err(op_err, err)
    return
  end if
  value = transfer(coord%buffer(pos:pos + 1 - 1), 0_int8)
  call return_err(op_err, err)
end subroutine coordinate_at_int8

module subroutine extract_coord_int8(coord, ptr)
  type(coordinate_type), target, intent(in) :: coord
  integer(int8), pointer, intent(out) :: ptr(:)
  type(error_type) :: err
  type(c_ptr) :: cptr

  call validate_coordinate(coord, err)
  call return_err(err)
  if (coord%dtype /= BYTE_TYPE) error stop &
    & "[extract] Coordinate kind differs."
  if (coord%len == 0) then
    nullify (ptr)
    return
  end if
  cptr = c_loc(coord%buffer(1))
  call c_f_pointer(cptr, ptr, [int(coord%len)])
end subroutine extract_coord_int8

module subroutine coordinate_at_int16(coord, indices, value, err)
  type(coordinate_type), target, intent(in) :: coord
  integer, intent(in) :: indices(:)
  integer(int16), intent(out) :: value
  type(error_type), intent(out), optional :: err
  type(error_type) :: op_err
  integer(int64) :: pos

  call coordinate_byte_offset(coord, indices, SHORT_TYPE, pos, op_err)
  if (.exists. op_err) then
    call return_err(op_err, err)
    return
  end if
  value = transfer(coord%buffer(pos:pos + 2 - 1), 0_int16)
  call return_err(op_err, err)
end subroutine coordinate_at_int16

module subroutine extract_coord_int16(coord, ptr)
  type(coordinate_type), target, intent(in) :: coord
  integer(int16), pointer, intent(out) :: ptr(:)
  type(error_type) :: err
  type(c_ptr) :: cptr

  call validate_coordinate(coord, err)
  call return_err(err)
  if (coord%dtype /= SHORT_TYPE) error stop &
    & "[extract] Coordinate kind differs."
  if (coord%len == 0) then
    nullify (ptr)
    return
  end if
  cptr = c_loc(coord%buffer(1))
  call c_f_pointer(cptr, ptr, [int(coord%len)])
end subroutine extract_coord_int16

module subroutine coordinate_at_int32(coord, indices, value, err)
  type(coordinate_type), target, intent(in) :: coord
  integer, intent(in) :: indices(:)
  integer(int32), intent(out) :: value
  type(error_type), intent(out), optional :: err
  type(error_type) :: op_err
  integer(int64) :: pos

  call coordinate_byte_offset(coord, indices, INT_TYPE, pos, op_err)
  if (.exists. op_err) then
    call return_err(op_err, err)
    return
  end if
  value = transfer(coord%buffer(pos:pos + 4 - 1), 0_int32)
  call return_err(op_err, err)
end subroutine coordinate_at_int32

module subroutine extract_coord_int32(coord, ptr)
  type(coordinate_type), target, intent(in) :: coord
  integer(int32), pointer, intent(out) :: ptr(:)
  type(error_type) :: err
  type(c_ptr) :: cptr

  call validate_coordinate(coord, err)
  call return_err(err)
  if (coord%dtype /= INT_TYPE) error stop &
    & "[extract] Coordinate kind differs."
  if (coord%len == 0) then
    nullify (ptr)
    return
  end if
  cptr = c_loc(coord%buffer(1))
  call c_f_pointer(cptr, ptr, [int(coord%len)])
end subroutine extract_coord_int32

module subroutine coordinate_at_int64(coord, indices, value, err)
  type(coordinate_type), target, intent(in) :: coord
  integer, intent(in) :: indices(:)
  integer(int64), intent(out) :: value
  type(error_type), intent(out), optional :: err
  type(error_type) :: op_err
  integer(int64) :: pos

  call coordinate_byte_offset(coord, indices, INT64_TYPE, pos, op_err)
  if (.exists. op_err) then
    call return_err(op_err, err)
    return
  end if
  value = transfer(coord%buffer(pos:pos + 8 - 1), 0_int64)
  call return_err(op_err, err)
end subroutine coordinate_at_int64

module subroutine extract_coord_int64(coord, ptr)
  type(coordinate_type), target, intent(in) :: coord
  integer(int64), pointer, intent(out) :: ptr(:)
  type(error_type) :: err
  type(c_ptr) :: cptr

  call validate_coordinate(coord, err)
  call return_err(err)
  if (coord%dtype /= INT64_TYPE) error stop &
    & "[extract] Coordinate kind differs."
  if (coord%len == 0) then
    nullify (ptr)
    return
  end if
  cptr = c_loc(coord%buffer(1))
  call c_f_pointer(cptr, ptr, [int(coord%len)])
end subroutine extract_coord_int64

module subroutine coordinate_at_real32(coord, indices, value, err)
  type(coordinate_type), target, intent(in) :: coord
  integer, intent(in) :: indices(:)
  real(real32), intent(out) :: value
  type(error_type), intent(out), optional :: err
  type(error_type) :: op_err
  integer(int64) :: pos

  call coordinate_byte_offset(coord, indices, FLOAT_TYPE, pos, op_err)
  if (.exists. op_err) then
    call return_err(op_err, err)
    return
  end if
  value = transfer(coord%buffer(pos:pos + 4 - 1), 0.0_real32)
  call return_err(op_err, err)
end subroutine coordinate_at_real32

module subroutine extract_coord_real32(coord, ptr)
  type(coordinate_type), target, intent(in) :: coord
  real(real32), pointer, intent(out) :: ptr(:)
  type(error_type) :: err
  type(c_ptr) :: cptr

  call validate_coordinate(coord, err)
  call return_err(err)
  if (coord%dtype /= FLOAT_TYPE) error stop &
    & "[extract] Coordinate kind differs."
  if (coord%len == 0) then
    nullify (ptr)
    return
  end if
  cptr = c_loc(coord%buffer(1))
  call c_f_pointer(cptr, ptr, [int(coord%len)])
end subroutine extract_coord_real32

module subroutine coordinate_at_real64(coord, indices, value, err)
  type(coordinate_type), target, intent(in) :: coord
  integer, intent(in) :: indices(:)
  real(real64), intent(out) :: value
  type(error_type), intent(out), optional :: err
  type(error_type) :: op_err
  integer(int64) :: pos

  call coordinate_byte_offset(coord, indices, DOUBLE_TYPE, pos, op_err)
  if (.exists. op_err) then
    call return_err(op_err, err)
    return
  end if
  value = transfer(coord%buffer(pos:pos + 8 - 1), 0.0_real64)
  call return_err(op_err, err)
end subroutine coordinate_at_real64

module subroutine extract_coord_real64(coord, ptr)
  type(coordinate_type), target, intent(in) :: coord
  real(real64), pointer, intent(out) :: ptr(:)
  type(error_type) :: err
  type(c_ptr) :: cptr

  call validate_coordinate(coord, err)
  call return_err(err)
  if (coord%dtype /= DOUBLE_TYPE) error stop &
    & "[extract] Coordinate kind differs."
  if (coord%len == 0) then
    nullify (ptr)
    return
  end if
  cptr = c_loc(coord%buffer(1))
  call c_f_pointer(cptr, ptr, [int(coord%len)])
end subroutine extract_coord_real64

end submodule nc4f_data_coordinate
