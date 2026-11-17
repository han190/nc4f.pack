interface extract
  module procedure :: extract_val_int8_1d
  module procedure :: extract_val_int8_2d
  module procedure :: extract_val_int8_3d
  module procedure :: extract_val_int8_4d
  module procedure :: extract_val_int8_5d
  module procedure :: extract_val_int8_6d
  module procedure :: extract_val_int8_7d
  module procedure :: extract_val_int8_8d
  module procedure :: extract_val_int8_9d
  module procedure :: extract_val_int8_10d
  module procedure :: extract_val_int8_11d
  module procedure :: extract_val_int8_12d
  module procedure :: extract_val_int8_13d
  module procedure :: extract_val_int8_14d
  module procedure :: extract_val_int8_15d
  module procedure :: extract_val_int16_1d
  module procedure :: extract_val_int16_2d
  module procedure :: extract_val_int16_3d
  module procedure :: extract_val_int16_4d
  module procedure :: extract_val_int16_5d
  module procedure :: extract_val_int16_6d
  module procedure :: extract_val_int16_7d
  module procedure :: extract_val_int16_8d
  module procedure :: extract_val_int16_9d
  module procedure :: extract_val_int16_10d
  module procedure :: extract_val_int16_11d
  module procedure :: extract_val_int16_12d
  module procedure :: extract_val_int16_13d
  module procedure :: extract_val_int16_14d
  module procedure :: extract_val_int16_15d
  module procedure :: extract_val_int32_1d
  module procedure :: extract_val_int32_2d
  module procedure :: extract_val_int32_3d
  module procedure :: extract_val_int32_4d
  module procedure :: extract_val_int32_5d
  module procedure :: extract_val_int32_6d
  module procedure :: extract_val_int32_7d
  module procedure :: extract_val_int32_8d
  module procedure :: extract_val_int32_9d
  module procedure :: extract_val_int32_10d
  module procedure :: extract_val_int32_11d
  module procedure :: extract_val_int32_12d
  module procedure :: extract_val_int32_13d
  module procedure :: extract_val_int32_14d
  module procedure :: extract_val_int32_15d
  module procedure :: extract_val_int64_1d
  module procedure :: extract_val_int64_2d
  module procedure :: extract_val_int64_3d
  module procedure :: extract_val_int64_4d
  module procedure :: extract_val_int64_5d
  module procedure :: extract_val_int64_6d
  module procedure :: extract_val_int64_7d
  module procedure :: extract_val_int64_8d
  module procedure :: extract_val_int64_9d
  module procedure :: extract_val_int64_10d
  module procedure :: extract_val_int64_11d
  module procedure :: extract_val_int64_12d
  module procedure :: extract_val_int64_13d
  module procedure :: extract_val_int64_14d
  module procedure :: extract_val_int64_15d
  module procedure :: extract_val_real32_1d
  module procedure :: extract_val_real32_2d
  module procedure :: extract_val_real32_3d
  module procedure :: extract_val_real32_4d
  module procedure :: extract_val_real32_5d
  module procedure :: extract_val_real32_6d
  module procedure :: extract_val_real32_7d
  module procedure :: extract_val_real32_8d
  module procedure :: extract_val_real32_9d
  module procedure :: extract_val_real32_10d
  module procedure :: extract_val_real32_11d
  module procedure :: extract_val_real32_12d
  module procedure :: extract_val_real32_13d
  module procedure :: extract_val_real32_14d
  module procedure :: extract_val_real32_15d
  module procedure :: extract_val_real64_1d
  module procedure :: extract_val_real64_2d
  module procedure :: extract_val_real64_3d
  module procedure :: extract_val_real64_4d
  module procedure :: extract_val_real64_5d
  module procedure :: extract_val_real64_6d
  module procedure :: extract_val_real64_7d
  module procedure :: extract_val_real64_8d
  module procedure :: extract_val_real64_9d
  module procedure :: extract_val_real64_10d
  module procedure :: extract_val_real64_11d
  module procedure :: extract_val_real64_12d
  module procedure :: extract_val_real64_13d
  module procedure :: extract_val_real64_14d
  module procedure :: extract_val_real64_15d
end interface extract

interface
  module subroutine extract_val_int8_1d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int8 rank-1 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int8), allocatable, target, intent(inout) :: &
      & val(:)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int8_1d

  module subroutine extract_val_int8_2d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int8 rank-2 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int8), allocatable, target, intent(inout) :: &
      & val(:, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int8_2d

  module subroutine extract_val_int8_3d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int8 rank-3 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int8), allocatable, target, intent(inout) :: &
      & val(:, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int8_3d

  module subroutine extract_val_int8_4d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int8 rank-4 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int8), allocatable, target, intent(inout) :: &
      & val(:, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int8_4d

  module subroutine extract_val_int8_5d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int8 rank-5 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int8), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int8_5d

  module subroutine extract_val_int8_6d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int8 rank-6 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int8), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int8_6d

  module subroutine extract_val_int8_7d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int8 rank-7 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int8), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int8_7d

  module subroutine extract_val_int8_8d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int8 rank-8 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int8), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int8_8d

  module subroutine extract_val_int8_9d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int8 rank-9 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int8), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int8_9d

  module subroutine extract_val_int8_10d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int8 rank-10 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int8), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int8_10d

  module subroutine extract_val_int8_11d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int8 rank-11 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int8), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int8_11d

  module subroutine extract_val_int8_12d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int8 rank-12 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int8), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int8_12d

  module subroutine extract_val_int8_13d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int8 rank-13 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int8), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int8_13d

  module subroutine extract_val_int8_14d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int8 rank-14 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int8), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :, :, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int8_14d

  module subroutine extract_val_int8_15d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int8 rank-15 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int8), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :, :, :, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int8_15d

  module subroutine extract_val_int16_1d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int16 rank-1 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int16), allocatable, target, intent(inout) :: &
      & val(:)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int16_1d

  module subroutine extract_val_int16_2d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int16 rank-2 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int16), allocatable, target, intent(inout) :: &
      & val(:, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int16_2d

  module subroutine extract_val_int16_3d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int16 rank-3 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int16), allocatable, target, intent(inout) :: &
      & val(:, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int16_3d

  module subroutine extract_val_int16_4d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int16 rank-4 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int16), allocatable, target, intent(inout) :: &
      & val(:, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int16_4d

  module subroutine extract_val_int16_5d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int16 rank-5 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int16), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int16_5d

  module subroutine extract_val_int16_6d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int16 rank-6 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int16), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int16_6d

  module subroutine extract_val_int16_7d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int16 rank-7 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int16), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int16_7d

  module subroutine extract_val_int16_8d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int16 rank-8 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int16), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int16_8d

  module subroutine extract_val_int16_9d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int16 rank-9 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int16), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int16_9d

  module subroutine extract_val_int16_10d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int16 rank-10 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int16), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int16_10d

  module subroutine extract_val_int16_11d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int16 rank-11 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int16), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int16_11d

  module subroutine extract_val_int16_12d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int16 rank-12 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int16), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int16_12d

  module subroutine extract_val_int16_13d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int16 rank-13 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int16), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int16_13d

  module subroutine extract_val_int16_14d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int16 rank-14 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int16), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :, :, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int16_14d

  module subroutine extract_val_int16_15d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int16 rank-15 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int16), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :, :, :, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int16_15d

  module subroutine extract_val_int32_1d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int32 rank-1 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int32), allocatable, target, intent(inout) :: &
      & val(:)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int32_1d

  module subroutine extract_val_int32_2d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int32 rank-2 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int32), allocatable, target, intent(inout) :: &
      & val(:, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int32_2d

  module subroutine extract_val_int32_3d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int32 rank-3 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int32), allocatable, target, intent(inout) :: &
      & val(:, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int32_3d

  module subroutine extract_val_int32_4d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int32 rank-4 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int32), allocatable, target, intent(inout) :: &
      & val(:, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int32_4d

  module subroutine extract_val_int32_5d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int32 rank-5 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int32), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int32_5d

  module subroutine extract_val_int32_6d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int32 rank-6 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int32), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int32_6d

  module subroutine extract_val_int32_7d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int32 rank-7 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int32), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int32_7d

  module subroutine extract_val_int32_8d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int32 rank-8 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int32), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int32_8d

  module subroutine extract_val_int32_9d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int32 rank-9 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int32), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int32_9d

  module subroutine extract_val_int32_10d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int32 rank-10 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int32), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int32_10d

  module subroutine extract_val_int32_11d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int32 rank-11 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int32), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int32_11d

  module subroutine extract_val_int32_12d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int32 rank-12 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int32), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int32_12d

  module subroutine extract_val_int32_13d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int32 rank-13 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int32), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int32_13d

  module subroutine extract_val_int32_14d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int32 rank-14 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int32), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :, :, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int32_14d

  module subroutine extract_val_int32_15d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int32 rank-15 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int32), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :, :, :, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int32_15d

  module subroutine extract_val_int64_1d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int64 rank-1 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int64), allocatable, target, intent(inout) :: &
      & val(:)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int64_1d

  module subroutine extract_val_int64_2d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int64 rank-2 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int64), allocatable, target, intent(inout) :: &
      & val(:, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int64_2d

  module subroutine extract_val_int64_3d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int64 rank-3 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int64), allocatable, target, intent(inout) :: &
      & val(:, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int64_3d

  module subroutine extract_val_int64_4d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int64 rank-4 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int64), allocatable, target, intent(inout) :: &
      & val(:, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int64_4d

  module subroutine extract_val_int64_5d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int64 rank-5 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int64), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int64_5d

  module subroutine extract_val_int64_6d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int64 rank-6 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int64), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int64_6d

  module subroutine extract_val_int64_7d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int64 rank-7 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int64), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int64_7d

  module subroutine extract_val_int64_8d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int64 rank-8 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int64), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int64_8d

  module subroutine extract_val_int64_9d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int64 rank-9 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int64), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int64_9d

  module subroutine extract_val_int64_10d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int64 rank-10 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int64), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int64_10d

  module subroutine extract_val_int64_11d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int64 rank-11 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int64), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int64_11d

  module subroutine extract_val_int64_12d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int64 rank-12 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int64), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int64_12d

  module subroutine extract_val_int64_13d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int64 rank-13 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int64), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int64_13d

  module subroutine extract_val_int64_14d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int64 rank-14 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int64), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :, :, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int64_14d

  module subroutine extract_val_int64_15d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a int64 rank-15 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    integer(int64), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :, :, :, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_int64_15d

  module subroutine extract_val_real32_1d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a real32 rank-1 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    real(real32), allocatable, target, intent(inout) :: &
      & val(:)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_real32_1d

  module subroutine extract_val_real32_2d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a real32 rank-2 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    real(real32), allocatable, target, intent(inout) :: &
      & val(:, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_real32_2d

  module subroutine extract_val_real32_3d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a real32 rank-3 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    real(real32), allocatable, target, intent(inout) :: &
      & val(:, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_real32_3d

  module subroutine extract_val_real32_4d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a real32 rank-4 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    real(real32), allocatable, target, intent(inout) :: &
      & val(:, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_real32_4d

  module subroutine extract_val_real32_5d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a real32 rank-5 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    real(real32), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_real32_5d

  module subroutine extract_val_real32_6d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a real32 rank-6 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    real(real32), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_real32_6d

  module subroutine extract_val_real32_7d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a real32 rank-7 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    real(real32), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_real32_7d

  module subroutine extract_val_real32_8d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a real32 rank-8 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    real(real32), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_real32_8d

  module subroutine extract_val_real32_9d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a real32 rank-9 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    real(real32), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_real32_9d

  module subroutine extract_val_real32_10d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a real32 rank-10 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    real(real32), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_real32_10d

  module subroutine extract_val_real32_11d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a real32 rank-11 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    real(real32), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_real32_11d

  module subroutine extract_val_real32_12d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a real32 rank-12 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    real(real32), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_real32_12d

  module subroutine extract_val_real32_13d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a real32 rank-13 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    real(real32), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_real32_13d

  module subroutine extract_val_real32_14d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a real32 rank-14 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    real(real32), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :, :, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_real32_14d

  module subroutine extract_val_real32_15d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a real32 rank-15 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    real(real32), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :, :, :, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_real32_15d

  module subroutine extract_val_real64_1d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a real64 rank-1 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    real(real64), allocatable, target, intent(inout) :: &
      & val(:)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_real64_1d

  module subroutine extract_val_real64_2d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a real64 rank-2 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    real(real64), allocatable, target, intent(inout) :: &
      & val(:, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_real64_2d

  module subroutine extract_val_real64_3d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a real64 rank-3 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    real(real64), allocatable, target, intent(inout) :: &
      & val(:, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_real64_3d

  module subroutine extract_val_real64_4d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a real64 rank-4 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    real(real64), allocatable, target, intent(inout) :: &
      & val(:, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_real64_4d

  module subroutine extract_val_real64_5d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a real64 rank-5 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    real(real64), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_real64_5d

  module subroutine extract_val_real64_6d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a real64 rank-6 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    real(real64), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_real64_6d

  module subroutine extract_val_real64_7d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a real64 rank-7 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    real(real64), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_real64_7d

  module subroutine extract_val_real64_8d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a real64 rank-8 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    real(real64), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_real64_8d

  module subroutine extract_val_real64_9d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a real64 rank-9 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    real(real64), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_real64_9d

  module subroutine extract_val_real64_10d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a real64 rank-10 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    real(real64), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_real64_10d

  module subroutine extract_val_real64_11d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a real64 rank-11 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    real(real64), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_real64_11d

  module subroutine extract_val_real64_12d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a real64 rank-12 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    real(real64), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_real64_12d

  module subroutine extract_val_real64_13d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a real64 rank-13 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    real(real64), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_real64_13d

  module subroutine extract_val_real64_14d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a real64 rank-14 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    real(real64), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :, :, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_real64_14d

  module subroutine extract_val_real64_15d(nc, name, val, err, &
    & start, count, stride)
    !! Read stored values into a real64 rank-15 array without a variable_type.
    !! NetCDF-C converts numeric types; packing attributes are not applied.
    class(group_type), intent(in) :: nc
    !! Open dataset or group containing the variable.
    character(len=*), intent(in) :: name
    !! Name of the variable to read.
    real(real64), allocatable, target, intent(inout) :: &
      & val(:, :, :, :, :, :, :, :, :, :, :, :, :, :, :)
    !! Output reused when its shape matches or resized otherwise. Empty reads
    !! and inquiry errors preserve it; a failed value read deallocates it.
    type(error_type), intent(out), optional :: err
    !! Optional error result; failures stop execution when omitted.
    integer, intent(in), optional :: start(:)
    !! One-based starting indices in Fortran order; alone reads to the end.
    integer, intent(in), optional :: count(:)
    !! Selected lengths in Fortran order; requires start.
    integer, intent(in), optional :: stride(:)
    !! Positive spacing in Fortran order; requires start and count.
  end subroutine extract_val_real64_15d

end interface
