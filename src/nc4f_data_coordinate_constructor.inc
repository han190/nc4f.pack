interface coordinate_type
  module procedure :: new_coord_int8_1d
  module procedure :: new_coord_int8_2d
  module procedure :: new_coord_int8_3d
  module procedure :: new_coord_int8_4d
  module procedure :: new_coord_int8_5d
  module procedure :: new_coord_int8_6d
  module procedure :: new_coord_int8_7d
  module procedure :: new_coord_int8_8d
  module procedure :: new_coord_int8_9d
  module procedure :: new_coord_int8_10d
  module procedure :: new_coord_int8_11d
  module procedure :: new_coord_int8_12d
  module procedure :: new_coord_int8_13d
  module procedure :: new_coord_int8_14d
  module procedure :: new_coord_int8_15d
  module procedure :: new_coord_int16_1d
  module procedure :: new_coord_int16_2d
  module procedure :: new_coord_int16_3d
  module procedure :: new_coord_int16_4d
  module procedure :: new_coord_int16_5d
  module procedure :: new_coord_int16_6d
  module procedure :: new_coord_int16_7d
  module procedure :: new_coord_int16_8d
  module procedure :: new_coord_int16_9d
  module procedure :: new_coord_int16_10d
  module procedure :: new_coord_int16_11d
  module procedure :: new_coord_int16_12d
  module procedure :: new_coord_int16_13d
  module procedure :: new_coord_int16_14d
  module procedure :: new_coord_int16_15d
  module procedure :: new_coord_int32_1d
  module procedure :: new_coord_int32_2d
  module procedure :: new_coord_int32_3d
  module procedure :: new_coord_int32_4d
  module procedure :: new_coord_int32_5d
  module procedure :: new_coord_int32_6d
  module procedure :: new_coord_int32_7d
  module procedure :: new_coord_int32_8d
  module procedure :: new_coord_int32_9d
  module procedure :: new_coord_int32_10d
  module procedure :: new_coord_int32_11d
  module procedure :: new_coord_int32_12d
  module procedure :: new_coord_int32_13d
  module procedure :: new_coord_int32_14d
  module procedure :: new_coord_int32_15d
  module procedure :: new_coord_int64_1d
  module procedure :: new_coord_int64_2d
  module procedure :: new_coord_int64_3d
  module procedure :: new_coord_int64_4d
  module procedure :: new_coord_int64_5d
  module procedure :: new_coord_int64_6d
  module procedure :: new_coord_int64_7d
  module procedure :: new_coord_int64_8d
  module procedure :: new_coord_int64_9d
  module procedure :: new_coord_int64_10d
  module procedure :: new_coord_int64_11d
  module procedure :: new_coord_int64_12d
  module procedure :: new_coord_int64_13d
  module procedure :: new_coord_int64_14d
  module procedure :: new_coord_int64_15d
  module procedure :: new_coord_real32_1d
  module procedure :: new_coord_real32_2d
  module procedure :: new_coord_real32_3d
  module procedure :: new_coord_real32_4d
  module procedure :: new_coord_real32_5d
  module procedure :: new_coord_real32_6d
  module procedure :: new_coord_real32_7d
  module procedure :: new_coord_real32_8d
  module procedure :: new_coord_real32_9d
  module procedure :: new_coord_real32_10d
  module procedure :: new_coord_real32_11d
  module procedure :: new_coord_real32_12d
  module procedure :: new_coord_real32_13d
  module procedure :: new_coord_real32_14d
  module procedure :: new_coord_real32_15d
  module procedure :: new_coord_real64_1d
  module procedure :: new_coord_real64_2d
  module procedure :: new_coord_real64_3d
  module procedure :: new_coord_real64_4d
  module procedure :: new_coord_real64_5d
  module procedure :: new_coord_real64_6d
  module procedure :: new_coord_real64_7d
  module procedure :: new_coord_real64_8d
  module procedure :: new_coord_real64_9d
  module procedure :: new_coord_real64_10d
  module procedure :: new_coord_real64_11d
  module procedure :: new_coord_real64_12d
  module procedure :: new_coord_real64_13d
  module procedure :: new_coord_real64_14d
  module procedure :: new_coord_real64_15d
end interface coordinate_type

interface
  module function new_coord_int8_1d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-1 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int8), intent(in) :: values(:)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int8_1d

  module function new_coord_int8_2d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-2 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int8), intent(in) :: values(:, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int8_2d

  module function new_coord_int8_3d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-3 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int8), intent(in) :: values(:, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int8_3d

  module function new_coord_int8_4d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-4 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int8), intent(in) :: values(:, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int8_4d

  module function new_coord_int8_5d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-5 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int8), intent(in) :: values(:, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int8_5d

  module function new_coord_int8_6d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-6 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int8), intent(in) :: values(:, :, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int8_6d

  module function new_coord_int8_7d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-7 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int8), intent(in) :: values(:, :, :, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int8_7d

  module function new_coord_int8_8d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-8 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int8), intent(in) :: values(:, :, :, :, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int8_8d

  module function new_coord_int8_9d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-9 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int8), intent(in) :: values(:, :, :, :, :, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int8_9d

  module function new_coord_int8_10d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-10 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int8), intent(in) :: values(:, :, :, :, :, :, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int8_10d

  module function new_coord_int8_11d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-11 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int8), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int8_11d

  module function new_coord_int8_12d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-12 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int8), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int8_12d

  module function new_coord_int8_13d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-13 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int8), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, &
      & :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int8_13d

  module function new_coord_int8_14d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-14 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int8), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, &
      & :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int8_14d

  module function new_coord_int8_15d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-15 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int8), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, &
      & :, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int8_15d

  module function new_coord_int16_1d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-1 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int16), intent(in) :: values(:)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int16_1d

  module function new_coord_int16_2d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-2 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int16), intent(in) :: values(:, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int16_2d

  module function new_coord_int16_3d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-3 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int16), intent(in) :: values(:, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int16_3d

  module function new_coord_int16_4d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-4 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int16), intent(in) :: values(:, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int16_4d

  module function new_coord_int16_5d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-5 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int16), intent(in) :: values(:, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int16_5d

  module function new_coord_int16_6d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-6 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int16), intent(in) :: values(:, :, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int16_6d

  module function new_coord_int16_7d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-7 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int16), intent(in) :: values(:, :, :, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int16_7d

  module function new_coord_int16_8d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-8 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int16), intent(in) :: values(:, :, :, :, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int16_8d

  module function new_coord_int16_9d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-9 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int16), intent(in) :: values(:, :, :, :, :, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int16_9d

  module function new_coord_int16_10d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-10 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int16), intent(in) :: values(:, :, :, :, :, :, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int16_10d

  module function new_coord_int16_11d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-11 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int16), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int16_11d

  module function new_coord_int16_12d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-12 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int16), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int16_12d

  module function new_coord_int16_13d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-13 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int16), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, &
      & :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int16_13d

  module function new_coord_int16_14d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-14 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int16), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, &
      & :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int16_14d

  module function new_coord_int16_15d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-15 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int16), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, &
      & :, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int16_15d

  module function new_coord_int32_1d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-1 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int32), intent(in) :: values(:)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int32_1d

  module function new_coord_int32_2d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-2 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int32), intent(in) :: values(:, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int32_2d

  module function new_coord_int32_3d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-3 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int32), intent(in) :: values(:, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int32_3d

  module function new_coord_int32_4d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-4 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int32), intent(in) :: values(:, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int32_4d

  module function new_coord_int32_5d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-5 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int32), intent(in) :: values(:, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int32_5d

  module function new_coord_int32_6d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-6 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int32), intent(in) :: values(:, :, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int32_6d

  module function new_coord_int32_7d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-7 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int32), intent(in) :: values(:, :, :, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int32_7d

  module function new_coord_int32_8d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-8 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int32), intent(in) :: values(:, :, :, :, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int32_8d

  module function new_coord_int32_9d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-9 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int32), intent(in) :: values(:, :, :, :, :, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int32_9d

  module function new_coord_int32_10d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-10 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int32), intent(in) :: values(:, :, :, :, :, :, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int32_10d

  module function new_coord_int32_11d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-11 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int32), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int32_11d

  module function new_coord_int32_12d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-12 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int32), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int32_12d

  module function new_coord_int32_13d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-13 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int32), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, &
      & :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int32_13d

  module function new_coord_int32_14d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-14 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int32), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, &
      & :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int32_14d

  module function new_coord_int32_15d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-15 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int32), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, &
      & :, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int32_15d

  module function new_coord_int64_1d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-1 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int64), intent(in) :: values(:)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int64_1d

  module function new_coord_int64_2d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-2 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int64), intent(in) :: values(:, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int64_2d

  module function new_coord_int64_3d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-3 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int64), intent(in) :: values(:, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int64_3d

  module function new_coord_int64_4d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-4 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int64), intent(in) :: values(:, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int64_4d

  module function new_coord_int64_5d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-5 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int64), intent(in) :: values(:, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int64_5d

  module function new_coord_int64_6d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-6 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int64), intent(in) :: values(:, :, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int64_6d

  module function new_coord_int64_7d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-7 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int64), intent(in) :: values(:, :, :, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int64_7d

  module function new_coord_int64_8d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-8 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int64), intent(in) :: values(:, :, :, :, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int64_8d

  module function new_coord_int64_9d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-9 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int64), intent(in) :: values(:, :, :, :, :, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int64_9d

  module function new_coord_int64_10d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-10 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int64), intent(in) :: values(:, :, :, :, :, :, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int64_10d

  module function new_coord_int64_11d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-11 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int64), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int64_11d

  module function new_coord_int64_12d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-12 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int64), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int64_12d

  module function new_coord_int64_13d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-13 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int64), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, &
      & :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int64_13d

  module function new_coord_int64_14d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-14 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int64), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, &
      & :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int64_14d

  module function new_coord_int64_15d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-15 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    integer(int64), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, &
      & :, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_int64_15d

  module function new_coord_real32_1d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-1 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    real(real32), intent(in) :: values(:)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_real32_1d

  module function new_coord_real32_2d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-2 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    real(real32), intent(in) :: values(:, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_real32_2d

  module function new_coord_real32_3d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-3 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    real(real32), intent(in) :: values(:, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_real32_3d

  module function new_coord_real32_4d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-4 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    real(real32), intent(in) :: values(:, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_real32_4d

  module function new_coord_real32_5d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-5 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    real(real32), intent(in) :: values(:, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_real32_5d

  module function new_coord_real32_6d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-6 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    real(real32), intent(in) :: values(:, :, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_real32_6d

  module function new_coord_real32_7d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-7 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    real(real32), intent(in) :: values(:, :, :, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_real32_7d

  module function new_coord_real32_8d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-8 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    real(real32), intent(in) :: values(:, :, :, :, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_real32_8d

  module function new_coord_real32_9d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-9 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    real(real32), intent(in) :: values(:, :, :, :, :, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_real32_9d

  module function new_coord_real32_10d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-10 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    real(real32), intent(in) :: values(:, :, :, :, :, :, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_real32_10d

  module function new_coord_real32_11d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-11 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    real(real32), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_real32_11d

  module function new_coord_real32_12d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-12 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    real(real32), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_real32_12d

  module function new_coord_real32_13d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-13 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    real(real32), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, &
      & :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_real32_13d

  module function new_coord_real32_14d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-14 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    real(real32), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, &
      & :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_real32_14d

  module function new_coord_real32_15d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-15 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    real(real32), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, &
      & :, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_real32_15d

  module function new_coord_real64_1d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-1 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    real(real64), intent(in) :: values(:)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_real64_1d

  module function new_coord_real64_2d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-2 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    real(real64), intent(in) :: values(:, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_real64_2d

  module function new_coord_real64_3d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-3 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    real(real64), intent(in) :: values(:, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_real64_3d

  module function new_coord_real64_4d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-4 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    real(real64), intent(in) :: values(:, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_real64_4d

  module function new_coord_real64_5d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-5 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    real(real64), intent(in) :: values(:, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_real64_5d

  module function new_coord_real64_6d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-6 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    real(real64), intent(in) :: values(:, :, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_real64_6d

  module function new_coord_real64_7d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-7 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    real(real64), intent(in) :: values(:, :, :, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_real64_7d

  module function new_coord_real64_8d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-8 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    real(real64), intent(in) :: values(:, :, :, :, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_real64_8d

  module function new_coord_real64_9d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-9 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    real(real64), intent(in) :: values(:, :, :, :, :, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_real64_9d

  module function new_coord_real64_10d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-10 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    real(real64), intent(in) :: values(:, :, :, :, :, :, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_real64_10d

  module function new_coord_real64_11d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-11 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    real(real64), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_real64_11d

  module function new_coord_real64_12d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-12 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    real(real64), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_real64_12d

  module function new_coord_real64_13d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-13 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    real(real64), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, &
      & :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_real64_13d

  module function new_coord_real64_14d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-14 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    real(real64), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, &
      & :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_real64_14d

  module function new_coord_real64_15d(name, values, dims, atts) &
    & result(coord)
    !! Construct an owned rank-15 numeric coordinate array.
    character(len=*), intent(in) :: name
    !! Name used to identify the coordinate.
    real(real64), intent(in) :: values(:, :, :, :, :, :, :, :, :, :, &
      & :, :, :, :, :)
    !! Numeric values stored in Fortran array order.
    type(dimension_type), intent(in) :: dims(:)
    !! Dimensions describing the shape and order of values.
    type(attribute_type), intent(in), optional :: atts(:)
    !! Optional metadata attached to the coordinate.
    type(coordinate_type) :: coord
  end function new_coord_real64_15d
end interface
