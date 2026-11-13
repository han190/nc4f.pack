submodule(nc4f_data) nc4f_data_coordinate_constructor
implicit none (type, external)
contains

module function new_coord_int8_1d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int8), intent(in) :: values(:)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = BYTE_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(BYTE_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int8_1d

module function new_coord_int8_2d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int8), intent(in) :: values(:, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = BYTE_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(BYTE_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int8_2d

module function new_coord_int8_3d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int8), intent(in) :: values(:, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = BYTE_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(BYTE_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int8_3d

module function new_coord_int8_4d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int8), intent(in) :: values(:, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = BYTE_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(BYTE_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int8_4d

module function new_coord_int8_5d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int8), intent(in) :: values(:, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = BYTE_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(BYTE_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int8_5d

module function new_coord_int8_6d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int8), intent(in) :: values(:, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = BYTE_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(BYTE_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int8_6d

module function new_coord_int8_7d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int8), intent(in) :: values(:, :, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = BYTE_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(BYTE_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int8_7d

module function new_coord_int8_8d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int8), intent(in) :: values(:, :, :, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = BYTE_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(BYTE_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int8_8d

module function new_coord_int8_9d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int8), intent(in) :: values(:, :, :, :, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = BYTE_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(BYTE_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int8_9d

module function new_coord_int8_10d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int8), intent(in) :: values(:, :, :, :, :, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = BYTE_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(BYTE_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int8_10d

module function new_coord_int8_11d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int8), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = BYTE_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(BYTE_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int8_11d

module function new_coord_int8_12d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int8), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = BYTE_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(BYTE_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int8_12d

module function new_coord_int8_13d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int8), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, &
    & :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = BYTE_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(BYTE_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int8_13d

module function new_coord_int8_14d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int8), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, &
    & :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = BYTE_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(BYTE_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int8_14d

module function new_coord_int8_15d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int8), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, &
    & :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = BYTE_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(BYTE_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int8_15d

module function new_coord_int16_1d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int16), intent(in) :: values(:)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = SHORT_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(SHORT_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int16_1d

module function new_coord_int16_2d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int16), intent(in) :: values(:, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = SHORT_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(SHORT_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int16_2d

module function new_coord_int16_3d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int16), intent(in) :: values(:, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = SHORT_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(SHORT_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int16_3d

module function new_coord_int16_4d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int16), intent(in) :: values(:, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = SHORT_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(SHORT_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int16_4d

module function new_coord_int16_5d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int16), intent(in) :: values(:, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = SHORT_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(SHORT_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int16_5d

module function new_coord_int16_6d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int16), intent(in) :: values(:, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = SHORT_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(SHORT_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int16_6d

module function new_coord_int16_7d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int16), intent(in) :: values(:, :, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = SHORT_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(SHORT_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int16_7d

module function new_coord_int16_8d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int16), intent(in) :: values(:, :, :, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = SHORT_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(SHORT_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int16_8d

module function new_coord_int16_9d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int16), intent(in) :: values(:, :, :, :, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = SHORT_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(SHORT_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int16_9d

module function new_coord_int16_10d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int16), intent(in) :: values(:, :, :, :, :, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = SHORT_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(SHORT_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int16_10d

module function new_coord_int16_11d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int16), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = SHORT_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(SHORT_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int16_11d

module function new_coord_int16_12d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int16), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = SHORT_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(SHORT_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int16_12d

module function new_coord_int16_13d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int16), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, &
    & :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = SHORT_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(SHORT_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int16_13d

module function new_coord_int16_14d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int16), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, &
    & :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = SHORT_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(SHORT_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int16_14d

module function new_coord_int16_15d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int16), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, &
    & :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = SHORT_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(SHORT_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int16_15d

module function new_coord_int32_1d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int32), intent(in) :: values(:)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = INT_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(INT_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int32_1d

module function new_coord_int32_2d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int32), intent(in) :: values(:, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = INT_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(INT_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int32_2d

module function new_coord_int32_3d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int32), intent(in) :: values(:, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = INT_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(INT_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int32_3d

module function new_coord_int32_4d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int32), intent(in) :: values(:, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = INT_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(INT_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int32_4d

module function new_coord_int32_5d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int32), intent(in) :: values(:, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = INT_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(INT_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int32_5d

module function new_coord_int32_6d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int32), intent(in) :: values(:, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = INT_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(INT_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int32_6d

module function new_coord_int32_7d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int32), intent(in) :: values(:, :, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = INT_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(INT_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int32_7d

module function new_coord_int32_8d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int32), intent(in) :: values(:, :, :, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = INT_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(INT_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int32_8d

module function new_coord_int32_9d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int32), intent(in) :: values(:, :, :, :, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = INT_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(INT_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int32_9d

module function new_coord_int32_10d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int32), intent(in) :: values(:, :, :, :, :, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = INT_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(INT_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int32_10d

module function new_coord_int32_11d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int32), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = INT_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(INT_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int32_11d

module function new_coord_int32_12d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int32), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = INT_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(INT_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int32_12d

module function new_coord_int32_13d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int32), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, &
    & :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = INT_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(INT_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int32_13d

module function new_coord_int32_14d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int32), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, &
    & :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = INT_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(INT_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int32_14d

module function new_coord_int32_15d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int32), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, &
    & :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = INT_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(INT_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int32_15d

module function new_coord_int64_1d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int64), intent(in) :: values(:)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = INT64_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(INT64_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int64_1d

module function new_coord_int64_2d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int64), intent(in) :: values(:, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = INT64_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(INT64_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int64_2d

module function new_coord_int64_3d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int64), intent(in) :: values(:, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = INT64_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(INT64_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int64_3d

module function new_coord_int64_4d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int64), intent(in) :: values(:, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = INT64_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(INT64_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int64_4d

module function new_coord_int64_5d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int64), intent(in) :: values(:, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = INT64_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(INT64_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int64_5d

module function new_coord_int64_6d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int64), intent(in) :: values(:, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = INT64_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(INT64_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int64_6d

module function new_coord_int64_7d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int64), intent(in) :: values(:, :, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = INT64_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(INT64_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int64_7d

module function new_coord_int64_8d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int64), intent(in) :: values(:, :, :, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = INT64_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(INT64_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int64_8d

module function new_coord_int64_9d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int64), intent(in) :: values(:, :, :, :, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = INT64_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(INT64_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int64_9d

module function new_coord_int64_10d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int64), intent(in) :: values(:, :, :, :, :, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = INT64_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(INT64_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int64_10d

module function new_coord_int64_11d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int64), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = INT64_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(INT64_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int64_11d

module function new_coord_int64_12d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int64), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = INT64_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(INT64_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int64_12d

module function new_coord_int64_13d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int64), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, &
    & :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = INT64_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(INT64_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int64_13d

module function new_coord_int64_14d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int64), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, &
    & :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = INT64_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(INT64_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int64_14d

module function new_coord_int64_15d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  integer(int64), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, &
    & :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = INT64_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(INT64_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_int64_15d

module function new_coord_real32_1d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  real(real32), intent(in) :: values(:)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = FLOAT_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(FLOAT_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_real32_1d

module function new_coord_real32_2d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  real(real32), intent(in) :: values(:, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = FLOAT_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(FLOAT_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_real32_2d

module function new_coord_real32_3d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  real(real32), intent(in) :: values(:, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = FLOAT_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(FLOAT_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_real32_3d

module function new_coord_real32_4d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  real(real32), intent(in) :: values(:, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = FLOAT_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(FLOAT_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_real32_4d

module function new_coord_real32_5d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  real(real32), intent(in) :: values(:, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = FLOAT_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(FLOAT_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_real32_5d

module function new_coord_real32_6d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  real(real32), intent(in) :: values(:, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = FLOAT_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(FLOAT_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_real32_6d

module function new_coord_real32_7d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  real(real32), intent(in) :: values(:, :, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = FLOAT_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(FLOAT_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_real32_7d

module function new_coord_real32_8d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  real(real32), intent(in) :: values(:, :, :, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = FLOAT_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(FLOAT_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_real32_8d

module function new_coord_real32_9d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  real(real32), intent(in) :: values(:, :, :, :, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = FLOAT_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(FLOAT_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_real32_9d

module function new_coord_real32_10d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  real(real32), intent(in) :: values(:, :, :, :, :, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = FLOAT_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(FLOAT_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_real32_10d

module function new_coord_real32_11d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  real(real32), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = FLOAT_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(FLOAT_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_real32_11d

module function new_coord_real32_12d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  real(real32), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = FLOAT_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(FLOAT_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_real32_12d

module function new_coord_real32_13d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  real(real32), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, &
    & :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = FLOAT_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(FLOAT_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_real32_13d

module function new_coord_real32_14d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  real(real32), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, &
    & :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = FLOAT_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(FLOAT_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_real32_14d

module function new_coord_real32_15d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  real(real32), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, &
    & :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = FLOAT_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(FLOAT_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_real32_15d

module function new_coord_real64_1d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  real(real64), intent(in) :: values(:)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = DOUBLE_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(DOUBLE_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_real64_1d

module function new_coord_real64_2d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  real(real64), intent(in) :: values(:, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = DOUBLE_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(DOUBLE_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_real64_2d

module function new_coord_real64_3d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  real(real64), intent(in) :: values(:, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = DOUBLE_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(DOUBLE_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_real64_3d

module function new_coord_real64_4d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  real(real64), intent(in) :: values(:, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = DOUBLE_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(DOUBLE_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_real64_4d

module function new_coord_real64_5d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  real(real64), intent(in) :: values(:, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = DOUBLE_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(DOUBLE_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_real64_5d

module function new_coord_real64_6d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  real(real64), intent(in) :: values(:, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = DOUBLE_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(DOUBLE_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_real64_6d

module function new_coord_real64_7d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  real(real64), intent(in) :: values(:, :, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = DOUBLE_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(DOUBLE_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_real64_7d

module function new_coord_real64_8d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  real(real64), intent(in) :: values(:, :, :, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = DOUBLE_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(DOUBLE_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_real64_8d

module function new_coord_real64_9d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  real(real64), intent(in) :: values(:, :, :, :, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = DOUBLE_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(DOUBLE_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_real64_9d

module function new_coord_real64_10d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  real(real64), intent(in) :: values(:, :, :, :, :, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = DOUBLE_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(DOUBLE_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_real64_10d

module function new_coord_real64_11d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  real(real64), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = DOUBLE_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(DOUBLE_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_real64_11d

module function new_coord_real64_12d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  real(real64), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = DOUBLE_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(DOUBLE_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_real64_12d

module function new_coord_real64_13d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  real(real64), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, &
    & :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = DOUBLE_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(DOUBLE_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_real64_13d

module function new_coord_real64_14d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  real(real64), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, &
    & :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = DOUBLE_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(DOUBLE_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_real64_14d

module function new_coord_real64_15d(name, values, dims, atts) result(coord)
  !! Construct one owned numeric coordinate array.
  character(len=*), intent(in) :: name
  real(real64), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, &
    & :, :, :, :, :)
  type(dimension_type), intent(in) :: dims(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(coordinate_type) :: coord
  type(error_type) :: err

  coord%name = trim(name)
  coord%dtype = DOUBLE_TYPE
  coord%len = size(values, kind=int64)
  coord%dims = dims
  if (present(atts)) coord%atts = atts
  coord%buffer = transfer(values, 0_int8, &
    & buffer_size(DOUBLE_TYPE, coord%len))
  call validate_coordinate(coord, err)
  call return_err(err)
end function new_coord_real64_15d

end submodule nc4f_data_coordinate_constructor
