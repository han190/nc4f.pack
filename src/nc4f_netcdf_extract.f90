submodule(nc4f_netcdf) nc4f_netcdf_extract
implicit none (type, external)
contains

subroutine prepare_extract_(nc, name, expected_rank, varid, &
  & starts, counts, strides, err, start, count, stride)
  !! Resolve a variable and an optional hyperslab without loading attributes,
  !! storage settings, or values. Return selection vectors in NetCDF-C order.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer, intent(in) :: expected_rank
  !! Rank required by the selected extraction procedure.
  integer(c_int), intent(out) :: varid
  !! Variable identifier used by the typed NetCDF-C reader.
  integer(c_size_t), intent(out) :: starts(:)
  !! Zero-based selection starts in NetCDF-C dimension order.
  integer(c_size_t), intent(out) :: counts(:)
  !! Selected element counts in NetCDF-C dimension order; zeroed on failure.
  integer(c_ptrdiff_t), intent(out) :: strides(:)
  !! Positive selection strides in NetCDF-C dimension order.
  type(error_type), intent(out) :: err
  !! Inquiry or invalid selection error.
  integer, intent(in), optional :: start(:)
  !! One-based starting indices in Fortran dimension order.
  integer, intent(in), optional :: count(:)
  !! Selected lengths in Fortran order; requires start.
  integer, intent(in), optional :: stride(:)
  !! Positive spacing in Fortran order; requires start and count.
  integer(c_int), allocatable :: dimids(:)
  integer(c_int) :: rank, stat
  integer :: i, j
  integer(c_size_t) :: first, step, length

  counts = 0_c_size_t
  err = error_type()
  stat = nc_inq_varid(nc%id, f2cstr(name), varid)
  err = netcdf_err(stat, "extract", name)
  if (has_err(err)) return
  stat = nc_inq_varndims(nc%id, varid, rank)
  err = netcdf_err(stat, "extract", name)
  if (has_err(err)) return
  if (rank /= expected_rank) then
    err = error_type(NC_EINVAL, "extract", &
      & "Variable "//trim(name)//" has the wrong rank.")
    return
  end if
  allocate (dimids(rank))
  stat = nc_inq_vardimid(nc%id, varid, dimids)
  err = netcdf_err(stat, "extract", name)
  if (has_err(err)) return
  do i = 1, rank
    stat = nc_inq_dimlen(nc%id, dimids(i), counts(i))
    err = netcdf_err(stat, "extract", name)
    if (has_err(err)) return
  end do
  starts = 0_c_size_t
  strides = 1_c_ptrdiff_t
  if (present(count) .and. .not. present(start) .or. present(stride) .and. ( &
    & .not. present(start) .or. .not. present(count))) then
    err = error_type(NC_EINVAL, "extract", &
      & "count requires start; stride requires start and count.")
    return
  end if
  if (present(start)) then
    if (size(start) /= rank) then
      err = error_type(NC_EINVAL, "extract", &
        & "start must have one entry per dimension.")
      return
    end if
  end if
  if (present(count)) then
    if (size(count) /= rank) then
      err = error_type(NC_EINVAL, "extract", &
        & "count must have one entry per dimension.")
      return
    end if
  end if
  if (present(stride)) then
    if (size(stride) /= rank) then
      err = error_type(NC_EINVAL, "extract", &
        & "stride must have one entry per dimension.")
      return
    end if
  end if
  if (.not. present(start)) return
  do i = 1, rank
    j = rank - i + 1
    if (start(j) < 1) then
      err = error_type(NC_EINVALCOORDS, "extract", &
        & "start indices must be positive.")
      return
    end if
    first = int(start(j), c_size_t)
    step = 1_c_size_t
    if (present(stride)) then
      if (stride(j) < 1) then
        err = error_type(NC_EINVAL, "extract", &
          & "stride entries must be positive.")
        return
      end if
      step = int(stride(j), c_size_t)
    end if
    if (first > counts(i)) then
      err = error_type(NC_EEDGE, "extract", &
        & "Requested hyperslab exceeds a dimension bound.")
      return
    end if
    length = counts(i) - first + 1_c_size_t
    if (present(count)) then
      if (count(j) < 1) then
        err = error_type(NC_EINVAL, "extract", &
          & "count entries must be positive.")
        return
      end if
      length = int(count(j), c_size_t)
    end if
    if (length - 1_c_size_t > (counts(i) - first) / step) then
      err = error_type(NC_EEDGE, "extract", &
        & "Requested hyperslab exceeds a dimension bound.")
      return
    end if
    starts(i) = first - 1_c_size_t
    counts(i) = length
    strides(i) = int(step, c_ptrdiff_t)
  end do
end subroutine prepare_extract_

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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(1), counts(1)
  integer(c_ptrdiff_t), target :: strides(1)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 1, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(1:1:-1))) then
    deallocate (val)
    allocate (val(counts(1)))
  end if
  stat = nc_get_vars_schar(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(2), counts(2)
  integer(c_ptrdiff_t), target :: strides(2)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 2, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(2:1:-1))) then
    deallocate (val)
    allocate (val(counts(2), counts(1)))
  end if
  stat = nc_get_vars_schar(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(3), counts(3)
  integer(c_ptrdiff_t), target :: strides(3)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 3, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(3), counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(3:1:-1))) then
    deallocate (val)
    allocate (val(counts(3), counts(2), counts(1)))
  end if
  stat = nc_get_vars_schar(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(4), counts(4)
  integer(c_ptrdiff_t), target :: strides(4)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 4, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(4), counts(3), counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(4:1:-1))) then
    deallocate (val)
    allocate (val(counts(4), counts(3), counts(2), counts(1)))
  end if
  stat = nc_get_vars_schar(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(5), counts(5)
  integer(c_ptrdiff_t), target :: strides(5)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 5, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(5), counts(4), counts(3), counts(2), &
    & counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(5:1:-1))) then
    deallocate (val)
    allocate (val(counts(5), counts(4), counts(3), counts(2), &
    & counts(1)))
  end if
  stat = nc_get_vars_schar(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(6), counts(6)
  integer(c_ptrdiff_t), target :: strides(6)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 6, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(6), counts(5), counts(4), counts(3), &
    & counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(6:1:-1))) then
    deallocate (val)
    allocate (val(counts(6), counts(5), counts(4), counts(3), &
    & counts(2), counts(1)))
  end if
  stat = nc_get_vars_schar(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(7), counts(7)
  integer(c_ptrdiff_t), target :: strides(7)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 7, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(7), counts(6), counts(5), counts(4), &
    & counts(3), counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(7:1:-1))) then
    deallocate (val)
    allocate (val(counts(7), counts(6), counts(5), counts(4), &
    & counts(3), counts(2), counts(1)))
  end if
  stat = nc_get_vars_schar(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(8), counts(8)
  integer(c_ptrdiff_t), target :: strides(8)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 8, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(8), counts(7), counts(6), counts(5), &
    & counts(4), counts(3), counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(8:1:-1))) then
    deallocate (val)
    allocate (val(counts(8), counts(7), counts(6), counts(5), &
    & counts(4), counts(3), counts(2), counts(1)))
  end if
  stat = nc_get_vars_schar(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(9), counts(9)
  integer(c_ptrdiff_t), target :: strides(9)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 9, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(9), counts(8), counts(7), counts(6), &
    & counts(5), counts(4), counts(3), counts(2), &
    & counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(9:1:-1))) then
    deallocate (val)
    allocate (val(counts(9), counts(8), counts(7), counts(6), &
    & counts(5), counts(4), counts(3), counts(2), &
    & counts(1)))
  end if
  stat = nc_get_vars_schar(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(10), counts(10)
  integer(c_ptrdiff_t), target :: strides(10)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 10, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(10), counts(9), counts(8), counts(7), &
    & counts(6), counts(5), counts(4), counts(3), &
    & counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(10:1:-1))) then
    deallocate (val)
    allocate (val(counts(10), counts(9), counts(8), counts(7), &
    & counts(6), counts(5), counts(4), counts(3), &
    & counts(2), counts(1)))
  end if
  stat = nc_get_vars_schar(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(11), counts(11)
  integer(c_ptrdiff_t), target :: strides(11)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 11, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(11), counts(10), counts(9), counts(8), &
    & counts(7), counts(6), counts(5), counts(4), &
    & counts(3), counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(11:1:-1))) then
    deallocate (val)
    allocate (val(counts(11), counts(10), counts(9), counts(8), &
    & counts(7), counts(6), counts(5), counts(4), &
    & counts(3), counts(2), counts(1)))
  end if
  stat = nc_get_vars_schar(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(12), counts(12)
  integer(c_ptrdiff_t), target :: strides(12)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 12, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(12), counts(11), counts(10), counts(9), &
    & counts(8), counts(7), counts(6), counts(5), &
    & counts(4), counts(3), counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(12:1:-1))) then
    deallocate (val)
    allocate (val(counts(12), counts(11), counts(10), counts(9), &
    & counts(8), counts(7), counts(6), counts(5), &
    & counts(4), counts(3), counts(2), counts(1)))
  end if
  stat = nc_get_vars_schar(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(13), counts(13)
  integer(c_ptrdiff_t), target :: strides(13)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 13, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(13), counts(12), counts(11), counts(10), &
    & counts(9), counts(8), counts(7), counts(6), &
    & counts(5), counts(4), counts(3), counts(2), &
    & counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(13:1:-1))) then
    deallocate (val)
    allocate (val(counts(13), counts(12), counts(11), counts(10), &
    & counts(9), counts(8), counts(7), counts(6), &
    & counts(5), counts(4), counts(3), counts(2), &
    & counts(1)))
  end if
  stat = nc_get_vars_schar(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(14), counts(14)
  integer(c_ptrdiff_t), target :: strides(14)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 14, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(14), counts(13), counts(12), counts(11), &
    & counts(10), counts(9), counts(8), counts(7), &
    & counts(6), counts(5), counts(4), counts(3), &
    & counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(14:1:-1))) then
    deallocate (val)
    allocate (val(counts(14), counts(13), counts(12), counts(11), &
    & counts(10), counts(9), counts(8), counts(7), &
    & counts(6), counts(5), counts(4), counts(3), &
    & counts(2), counts(1)))
  end if
  stat = nc_get_vars_schar(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(15), counts(15)
  integer(c_ptrdiff_t), target :: strides(15)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 15, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(15), counts(14), counts(13), counts(12), &
    & counts(11), counts(10), counts(9), counts(8), &
    & counts(7), counts(6), counts(5), counts(4), &
    & counts(3), counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(15:1:-1))) then
    deallocate (val)
    allocate (val(counts(15), counts(14), counts(13), counts(12), &
    & counts(11), counts(10), counts(9), counts(8), &
    & counts(7), counts(6), counts(5), counts(4), &
    & counts(3), counts(2), counts(1)))
  end if
  stat = nc_get_vars_schar(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(1), counts(1)
  integer(c_ptrdiff_t), target :: strides(1)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 1, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(1:1:-1))) then
    deallocate (val)
    allocate (val(counts(1)))
  end if
  stat = nc_get_vars_short(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(2), counts(2)
  integer(c_ptrdiff_t), target :: strides(2)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 2, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(2:1:-1))) then
    deallocate (val)
    allocate (val(counts(2), counts(1)))
  end if
  stat = nc_get_vars_short(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(3), counts(3)
  integer(c_ptrdiff_t), target :: strides(3)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 3, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(3), counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(3:1:-1))) then
    deallocate (val)
    allocate (val(counts(3), counts(2), counts(1)))
  end if
  stat = nc_get_vars_short(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(4), counts(4)
  integer(c_ptrdiff_t), target :: strides(4)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 4, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(4), counts(3), counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(4:1:-1))) then
    deallocate (val)
    allocate (val(counts(4), counts(3), counts(2), counts(1)))
  end if
  stat = nc_get_vars_short(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(5), counts(5)
  integer(c_ptrdiff_t), target :: strides(5)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 5, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(5), counts(4), counts(3), counts(2), &
    & counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(5:1:-1))) then
    deallocate (val)
    allocate (val(counts(5), counts(4), counts(3), counts(2), &
    & counts(1)))
  end if
  stat = nc_get_vars_short(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(6), counts(6)
  integer(c_ptrdiff_t), target :: strides(6)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 6, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(6), counts(5), counts(4), counts(3), &
    & counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(6:1:-1))) then
    deallocate (val)
    allocate (val(counts(6), counts(5), counts(4), counts(3), &
    & counts(2), counts(1)))
  end if
  stat = nc_get_vars_short(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(7), counts(7)
  integer(c_ptrdiff_t), target :: strides(7)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 7, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(7), counts(6), counts(5), counts(4), &
    & counts(3), counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(7:1:-1))) then
    deallocate (val)
    allocate (val(counts(7), counts(6), counts(5), counts(4), &
    & counts(3), counts(2), counts(1)))
  end if
  stat = nc_get_vars_short(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(8), counts(8)
  integer(c_ptrdiff_t), target :: strides(8)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 8, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(8), counts(7), counts(6), counts(5), &
    & counts(4), counts(3), counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(8:1:-1))) then
    deallocate (val)
    allocate (val(counts(8), counts(7), counts(6), counts(5), &
    & counts(4), counts(3), counts(2), counts(1)))
  end if
  stat = nc_get_vars_short(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(9), counts(9)
  integer(c_ptrdiff_t), target :: strides(9)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 9, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(9), counts(8), counts(7), counts(6), &
    & counts(5), counts(4), counts(3), counts(2), &
    & counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(9:1:-1))) then
    deallocate (val)
    allocate (val(counts(9), counts(8), counts(7), counts(6), &
    & counts(5), counts(4), counts(3), counts(2), &
    & counts(1)))
  end if
  stat = nc_get_vars_short(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(10), counts(10)
  integer(c_ptrdiff_t), target :: strides(10)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 10, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(10), counts(9), counts(8), counts(7), &
    & counts(6), counts(5), counts(4), counts(3), &
    & counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(10:1:-1))) then
    deallocate (val)
    allocate (val(counts(10), counts(9), counts(8), counts(7), &
    & counts(6), counts(5), counts(4), counts(3), &
    & counts(2), counts(1)))
  end if
  stat = nc_get_vars_short(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(11), counts(11)
  integer(c_ptrdiff_t), target :: strides(11)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 11, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(11), counts(10), counts(9), counts(8), &
    & counts(7), counts(6), counts(5), counts(4), &
    & counts(3), counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(11:1:-1))) then
    deallocate (val)
    allocate (val(counts(11), counts(10), counts(9), counts(8), &
    & counts(7), counts(6), counts(5), counts(4), &
    & counts(3), counts(2), counts(1)))
  end if
  stat = nc_get_vars_short(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(12), counts(12)
  integer(c_ptrdiff_t), target :: strides(12)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 12, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(12), counts(11), counts(10), counts(9), &
    & counts(8), counts(7), counts(6), counts(5), &
    & counts(4), counts(3), counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(12:1:-1))) then
    deallocate (val)
    allocate (val(counts(12), counts(11), counts(10), counts(9), &
    & counts(8), counts(7), counts(6), counts(5), &
    & counts(4), counts(3), counts(2), counts(1)))
  end if
  stat = nc_get_vars_short(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(13), counts(13)
  integer(c_ptrdiff_t), target :: strides(13)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 13, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(13), counts(12), counts(11), counts(10), &
    & counts(9), counts(8), counts(7), counts(6), &
    & counts(5), counts(4), counts(3), counts(2), &
    & counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(13:1:-1))) then
    deallocate (val)
    allocate (val(counts(13), counts(12), counts(11), counts(10), &
    & counts(9), counts(8), counts(7), counts(6), &
    & counts(5), counts(4), counts(3), counts(2), &
    & counts(1)))
  end if
  stat = nc_get_vars_short(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(14), counts(14)
  integer(c_ptrdiff_t), target :: strides(14)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 14, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(14), counts(13), counts(12), counts(11), &
    & counts(10), counts(9), counts(8), counts(7), &
    & counts(6), counts(5), counts(4), counts(3), &
    & counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(14:1:-1))) then
    deallocate (val)
    allocate (val(counts(14), counts(13), counts(12), counts(11), &
    & counts(10), counts(9), counts(8), counts(7), &
    & counts(6), counts(5), counts(4), counts(3), &
    & counts(2), counts(1)))
  end if
  stat = nc_get_vars_short(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(15), counts(15)
  integer(c_ptrdiff_t), target :: strides(15)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 15, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(15), counts(14), counts(13), counts(12), &
    & counts(11), counts(10), counts(9), counts(8), &
    & counts(7), counts(6), counts(5), counts(4), &
    & counts(3), counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(15:1:-1))) then
    deallocate (val)
    allocate (val(counts(15), counts(14), counts(13), counts(12), &
    & counts(11), counts(10), counts(9), counts(8), &
    & counts(7), counts(6), counts(5), counts(4), &
    & counts(3), counts(2), counts(1)))
  end if
  stat = nc_get_vars_short(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(1), counts(1)
  integer(c_ptrdiff_t), target :: strides(1)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 1, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(1:1:-1))) then
    deallocate (val)
    allocate (val(counts(1)))
  end if
  stat = nc_get_vars_int(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(2), counts(2)
  integer(c_ptrdiff_t), target :: strides(2)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 2, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(2:1:-1))) then
    deallocate (val)
    allocate (val(counts(2), counts(1)))
  end if
  stat = nc_get_vars_int(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(3), counts(3)
  integer(c_ptrdiff_t), target :: strides(3)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 3, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(3), counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(3:1:-1))) then
    deallocate (val)
    allocate (val(counts(3), counts(2), counts(1)))
  end if
  stat = nc_get_vars_int(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(4), counts(4)
  integer(c_ptrdiff_t), target :: strides(4)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 4, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(4), counts(3), counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(4:1:-1))) then
    deallocate (val)
    allocate (val(counts(4), counts(3), counts(2), counts(1)))
  end if
  stat = nc_get_vars_int(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(5), counts(5)
  integer(c_ptrdiff_t), target :: strides(5)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 5, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(5), counts(4), counts(3), counts(2), &
    & counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(5:1:-1))) then
    deallocate (val)
    allocate (val(counts(5), counts(4), counts(3), counts(2), &
    & counts(1)))
  end if
  stat = nc_get_vars_int(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(6), counts(6)
  integer(c_ptrdiff_t), target :: strides(6)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 6, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(6), counts(5), counts(4), counts(3), &
    & counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(6:1:-1))) then
    deallocate (val)
    allocate (val(counts(6), counts(5), counts(4), counts(3), &
    & counts(2), counts(1)))
  end if
  stat = nc_get_vars_int(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(7), counts(7)
  integer(c_ptrdiff_t), target :: strides(7)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 7, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(7), counts(6), counts(5), counts(4), &
    & counts(3), counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(7:1:-1))) then
    deallocate (val)
    allocate (val(counts(7), counts(6), counts(5), counts(4), &
    & counts(3), counts(2), counts(1)))
  end if
  stat = nc_get_vars_int(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(8), counts(8)
  integer(c_ptrdiff_t), target :: strides(8)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 8, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(8), counts(7), counts(6), counts(5), &
    & counts(4), counts(3), counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(8:1:-1))) then
    deallocate (val)
    allocate (val(counts(8), counts(7), counts(6), counts(5), &
    & counts(4), counts(3), counts(2), counts(1)))
  end if
  stat = nc_get_vars_int(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(9), counts(9)
  integer(c_ptrdiff_t), target :: strides(9)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 9, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(9), counts(8), counts(7), counts(6), &
    & counts(5), counts(4), counts(3), counts(2), &
    & counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(9:1:-1))) then
    deallocate (val)
    allocate (val(counts(9), counts(8), counts(7), counts(6), &
    & counts(5), counts(4), counts(3), counts(2), &
    & counts(1)))
  end if
  stat = nc_get_vars_int(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(10), counts(10)
  integer(c_ptrdiff_t), target :: strides(10)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 10, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(10), counts(9), counts(8), counts(7), &
    & counts(6), counts(5), counts(4), counts(3), &
    & counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(10:1:-1))) then
    deallocate (val)
    allocate (val(counts(10), counts(9), counts(8), counts(7), &
    & counts(6), counts(5), counts(4), counts(3), &
    & counts(2), counts(1)))
  end if
  stat = nc_get_vars_int(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(11), counts(11)
  integer(c_ptrdiff_t), target :: strides(11)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 11, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(11), counts(10), counts(9), counts(8), &
    & counts(7), counts(6), counts(5), counts(4), &
    & counts(3), counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(11:1:-1))) then
    deallocate (val)
    allocate (val(counts(11), counts(10), counts(9), counts(8), &
    & counts(7), counts(6), counts(5), counts(4), &
    & counts(3), counts(2), counts(1)))
  end if
  stat = nc_get_vars_int(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(12), counts(12)
  integer(c_ptrdiff_t), target :: strides(12)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 12, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(12), counts(11), counts(10), counts(9), &
    & counts(8), counts(7), counts(6), counts(5), &
    & counts(4), counts(3), counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(12:1:-1))) then
    deallocate (val)
    allocate (val(counts(12), counts(11), counts(10), counts(9), &
    & counts(8), counts(7), counts(6), counts(5), &
    & counts(4), counts(3), counts(2), counts(1)))
  end if
  stat = nc_get_vars_int(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(13), counts(13)
  integer(c_ptrdiff_t), target :: strides(13)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 13, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(13), counts(12), counts(11), counts(10), &
    & counts(9), counts(8), counts(7), counts(6), &
    & counts(5), counts(4), counts(3), counts(2), &
    & counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(13:1:-1))) then
    deallocate (val)
    allocate (val(counts(13), counts(12), counts(11), counts(10), &
    & counts(9), counts(8), counts(7), counts(6), &
    & counts(5), counts(4), counts(3), counts(2), &
    & counts(1)))
  end if
  stat = nc_get_vars_int(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(14), counts(14)
  integer(c_ptrdiff_t), target :: strides(14)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 14, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(14), counts(13), counts(12), counts(11), &
    & counts(10), counts(9), counts(8), counts(7), &
    & counts(6), counts(5), counts(4), counts(3), &
    & counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(14:1:-1))) then
    deallocate (val)
    allocate (val(counts(14), counts(13), counts(12), counts(11), &
    & counts(10), counts(9), counts(8), counts(7), &
    & counts(6), counts(5), counts(4), counts(3), &
    & counts(2), counts(1)))
  end if
  stat = nc_get_vars_int(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(15), counts(15)
  integer(c_ptrdiff_t), target :: strides(15)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 15, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(15), counts(14), counts(13), counts(12), &
    & counts(11), counts(10), counts(9), counts(8), &
    & counts(7), counts(6), counts(5), counts(4), &
    & counts(3), counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(15:1:-1))) then
    deallocate (val)
    allocate (val(counts(15), counts(14), counts(13), counts(12), &
    & counts(11), counts(10), counts(9), counts(8), &
    & counts(7), counts(6), counts(5), counts(4), &
    & counts(3), counts(2), counts(1)))
  end if
  stat = nc_get_vars_int(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(1), counts(1)
  integer(c_ptrdiff_t), target :: strides(1)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 1, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(1:1:-1))) then
    deallocate (val)
    allocate (val(counts(1)))
  end if
  stat = nc_get_vars_longlong(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(2), counts(2)
  integer(c_ptrdiff_t), target :: strides(2)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 2, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(2:1:-1))) then
    deallocate (val)
    allocate (val(counts(2), counts(1)))
  end if
  stat = nc_get_vars_longlong(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(3), counts(3)
  integer(c_ptrdiff_t), target :: strides(3)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 3, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(3), counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(3:1:-1))) then
    deallocate (val)
    allocate (val(counts(3), counts(2), counts(1)))
  end if
  stat = nc_get_vars_longlong(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(4), counts(4)
  integer(c_ptrdiff_t), target :: strides(4)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 4, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(4), counts(3), counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(4:1:-1))) then
    deallocate (val)
    allocate (val(counts(4), counts(3), counts(2), counts(1)))
  end if
  stat = nc_get_vars_longlong(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(5), counts(5)
  integer(c_ptrdiff_t), target :: strides(5)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 5, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(5), counts(4), counts(3), counts(2), &
    & counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(5:1:-1))) then
    deallocate (val)
    allocate (val(counts(5), counts(4), counts(3), counts(2), &
    & counts(1)))
  end if
  stat = nc_get_vars_longlong(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(6), counts(6)
  integer(c_ptrdiff_t), target :: strides(6)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 6, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(6), counts(5), counts(4), counts(3), &
    & counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(6:1:-1))) then
    deallocate (val)
    allocate (val(counts(6), counts(5), counts(4), counts(3), &
    & counts(2), counts(1)))
  end if
  stat = nc_get_vars_longlong(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(7), counts(7)
  integer(c_ptrdiff_t), target :: strides(7)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 7, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(7), counts(6), counts(5), counts(4), &
    & counts(3), counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(7:1:-1))) then
    deallocate (val)
    allocate (val(counts(7), counts(6), counts(5), counts(4), &
    & counts(3), counts(2), counts(1)))
  end if
  stat = nc_get_vars_longlong(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(8), counts(8)
  integer(c_ptrdiff_t), target :: strides(8)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 8, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(8), counts(7), counts(6), counts(5), &
    & counts(4), counts(3), counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(8:1:-1))) then
    deallocate (val)
    allocate (val(counts(8), counts(7), counts(6), counts(5), &
    & counts(4), counts(3), counts(2), counts(1)))
  end if
  stat = nc_get_vars_longlong(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(9), counts(9)
  integer(c_ptrdiff_t), target :: strides(9)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 9, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(9), counts(8), counts(7), counts(6), &
    & counts(5), counts(4), counts(3), counts(2), &
    & counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(9:1:-1))) then
    deallocate (val)
    allocate (val(counts(9), counts(8), counts(7), counts(6), &
    & counts(5), counts(4), counts(3), counts(2), &
    & counts(1)))
  end if
  stat = nc_get_vars_longlong(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(10), counts(10)
  integer(c_ptrdiff_t), target :: strides(10)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 10, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(10), counts(9), counts(8), counts(7), &
    & counts(6), counts(5), counts(4), counts(3), &
    & counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(10:1:-1))) then
    deallocate (val)
    allocate (val(counts(10), counts(9), counts(8), counts(7), &
    & counts(6), counts(5), counts(4), counts(3), &
    & counts(2), counts(1)))
  end if
  stat = nc_get_vars_longlong(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(11), counts(11)
  integer(c_ptrdiff_t), target :: strides(11)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 11, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(11), counts(10), counts(9), counts(8), &
    & counts(7), counts(6), counts(5), counts(4), &
    & counts(3), counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(11:1:-1))) then
    deallocate (val)
    allocate (val(counts(11), counts(10), counts(9), counts(8), &
    & counts(7), counts(6), counts(5), counts(4), &
    & counts(3), counts(2), counts(1)))
  end if
  stat = nc_get_vars_longlong(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(12), counts(12)
  integer(c_ptrdiff_t), target :: strides(12)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 12, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(12), counts(11), counts(10), counts(9), &
    & counts(8), counts(7), counts(6), counts(5), &
    & counts(4), counts(3), counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(12:1:-1))) then
    deallocate (val)
    allocate (val(counts(12), counts(11), counts(10), counts(9), &
    & counts(8), counts(7), counts(6), counts(5), &
    & counts(4), counts(3), counts(2), counts(1)))
  end if
  stat = nc_get_vars_longlong(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(13), counts(13)
  integer(c_ptrdiff_t), target :: strides(13)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 13, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(13), counts(12), counts(11), counts(10), &
    & counts(9), counts(8), counts(7), counts(6), &
    & counts(5), counts(4), counts(3), counts(2), &
    & counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(13:1:-1))) then
    deallocate (val)
    allocate (val(counts(13), counts(12), counts(11), counts(10), &
    & counts(9), counts(8), counts(7), counts(6), &
    & counts(5), counts(4), counts(3), counts(2), &
    & counts(1)))
  end if
  stat = nc_get_vars_longlong(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(14), counts(14)
  integer(c_ptrdiff_t), target :: strides(14)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 14, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(14), counts(13), counts(12), counts(11), &
    & counts(10), counts(9), counts(8), counts(7), &
    & counts(6), counts(5), counts(4), counts(3), &
    & counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(14:1:-1))) then
    deallocate (val)
    allocate (val(counts(14), counts(13), counts(12), counts(11), &
    & counts(10), counts(9), counts(8), counts(7), &
    & counts(6), counts(5), counts(4), counts(3), &
    & counts(2), counts(1)))
  end if
  stat = nc_get_vars_longlong(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(15), counts(15)
  integer(c_ptrdiff_t), target :: strides(15)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 15, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(15), counts(14), counts(13), counts(12), &
    & counts(11), counts(10), counts(9), counts(8), &
    & counts(7), counts(6), counts(5), counts(4), &
    & counts(3), counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(15:1:-1))) then
    deallocate (val)
    allocate (val(counts(15), counts(14), counts(13), counts(12), &
    & counts(11), counts(10), counts(9), counts(8), &
    & counts(7), counts(6), counts(5), counts(4), &
    & counts(3), counts(2), counts(1)))
  end if
  stat = nc_get_vars_longlong(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(1), counts(1)
  integer(c_ptrdiff_t), target :: strides(1)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 1, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(1:1:-1))) then
    deallocate (val)
    allocate (val(counts(1)))
  end if
  stat = nc_get_vars_float(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(2), counts(2)
  integer(c_ptrdiff_t), target :: strides(2)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 2, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(2:1:-1))) then
    deallocate (val)
    allocate (val(counts(2), counts(1)))
  end if
  stat = nc_get_vars_float(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(3), counts(3)
  integer(c_ptrdiff_t), target :: strides(3)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 3, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(3), counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(3:1:-1))) then
    deallocate (val)
    allocate (val(counts(3), counts(2), counts(1)))
  end if
  stat = nc_get_vars_float(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(4), counts(4)
  integer(c_ptrdiff_t), target :: strides(4)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 4, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(4), counts(3), counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(4:1:-1))) then
    deallocate (val)
    allocate (val(counts(4), counts(3), counts(2), counts(1)))
  end if
  stat = nc_get_vars_float(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(5), counts(5)
  integer(c_ptrdiff_t), target :: strides(5)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 5, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(5), counts(4), counts(3), counts(2), &
    & counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(5:1:-1))) then
    deallocate (val)
    allocate (val(counts(5), counts(4), counts(3), counts(2), &
    & counts(1)))
  end if
  stat = nc_get_vars_float(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(6), counts(6)
  integer(c_ptrdiff_t), target :: strides(6)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 6, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(6), counts(5), counts(4), counts(3), &
    & counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(6:1:-1))) then
    deallocate (val)
    allocate (val(counts(6), counts(5), counts(4), counts(3), &
    & counts(2), counts(1)))
  end if
  stat = nc_get_vars_float(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(7), counts(7)
  integer(c_ptrdiff_t), target :: strides(7)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 7, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(7), counts(6), counts(5), counts(4), &
    & counts(3), counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(7:1:-1))) then
    deallocate (val)
    allocate (val(counts(7), counts(6), counts(5), counts(4), &
    & counts(3), counts(2), counts(1)))
  end if
  stat = nc_get_vars_float(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(8), counts(8)
  integer(c_ptrdiff_t), target :: strides(8)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 8, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(8), counts(7), counts(6), counts(5), &
    & counts(4), counts(3), counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(8:1:-1))) then
    deallocate (val)
    allocate (val(counts(8), counts(7), counts(6), counts(5), &
    & counts(4), counts(3), counts(2), counts(1)))
  end if
  stat = nc_get_vars_float(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(9), counts(9)
  integer(c_ptrdiff_t), target :: strides(9)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 9, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(9), counts(8), counts(7), counts(6), &
    & counts(5), counts(4), counts(3), counts(2), &
    & counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(9:1:-1))) then
    deallocate (val)
    allocate (val(counts(9), counts(8), counts(7), counts(6), &
    & counts(5), counts(4), counts(3), counts(2), &
    & counts(1)))
  end if
  stat = nc_get_vars_float(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(10), counts(10)
  integer(c_ptrdiff_t), target :: strides(10)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 10, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(10), counts(9), counts(8), counts(7), &
    & counts(6), counts(5), counts(4), counts(3), &
    & counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(10:1:-1))) then
    deallocate (val)
    allocate (val(counts(10), counts(9), counts(8), counts(7), &
    & counts(6), counts(5), counts(4), counts(3), &
    & counts(2), counts(1)))
  end if
  stat = nc_get_vars_float(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(11), counts(11)
  integer(c_ptrdiff_t), target :: strides(11)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 11, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(11), counts(10), counts(9), counts(8), &
    & counts(7), counts(6), counts(5), counts(4), &
    & counts(3), counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(11:1:-1))) then
    deallocate (val)
    allocate (val(counts(11), counts(10), counts(9), counts(8), &
    & counts(7), counts(6), counts(5), counts(4), &
    & counts(3), counts(2), counts(1)))
  end if
  stat = nc_get_vars_float(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(12), counts(12)
  integer(c_ptrdiff_t), target :: strides(12)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 12, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(12), counts(11), counts(10), counts(9), &
    & counts(8), counts(7), counts(6), counts(5), &
    & counts(4), counts(3), counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(12:1:-1))) then
    deallocate (val)
    allocate (val(counts(12), counts(11), counts(10), counts(9), &
    & counts(8), counts(7), counts(6), counts(5), &
    & counts(4), counts(3), counts(2), counts(1)))
  end if
  stat = nc_get_vars_float(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(13), counts(13)
  integer(c_ptrdiff_t), target :: strides(13)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 13, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(13), counts(12), counts(11), counts(10), &
    & counts(9), counts(8), counts(7), counts(6), &
    & counts(5), counts(4), counts(3), counts(2), &
    & counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(13:1:-1))) then
    deallocate (val)
    allocate (val(counts(13), counts(12), counts(11), counts(10), &
    & counts(9), counts(8), counts(7), counts(6), &
    & counts(5), counts(4), counts(3), counts(2), &
    & counts(1)))
  end if
  stat = nc_get_vars_float(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(14), counts(14)
  integer(c_ptrdiff_t), target :: strides(14)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 14, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(14), counts(13), counts(12), counts(11), &
    & counts(10), counts(9), counts(8), counts(7), &
    & counts(6), counts(5), counts(4), counts(3), &
    & counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(14:1:-1))) then
    deallocate (val)
    allocate (val(counts(14), counts(13), counts(12), counts(11), &
    & counts(10), counts(9), counts(8), counts(7), &
    & counts(6), counts(5), counts(4), counts(3), &
    & counts(2), counts(1)))
  end if
  stat = nc_get_vars_float(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(15), counts(15)
  integer(c_ptrdiff_t), target :: strides(15)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 15, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(15), counts(14), counts(13), counts(12), &
    & counts(11), counts(10), counts(9), counts(8), &
    & counts(7), counts(6), counts(5), counts(4), &
    & counts(3), counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(15:1:-1))) then
    deallocate (val)
    allocate (val(counts(15), counts(14), counts(13), counts(12), &
    & counts(11), counts(10), counts(9), counts(8), &
    & counts(7), counts(6), counts(5), counts(4), &
    & counts(3), counts(2), counts(1)))
  end if
  stat = nc_get_vars_float(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(1), counts(1)
  integer(c_ptrdiff_t), target :: strides(1)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 1, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(1:1:-1))) then
    deallocate (val)
    allocate (val(counts(1)))
  end if
  stat = nc_get_vars_double(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(2), counts(2)
  integer(c_ptrdiff_t), target :: strides(2)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 2, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(2:1:-1))) then
    deallocate (val)
    allocate (val(counts(2), counts(1)))
  end if
  stat = nc_get_vars_double(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(3), counts(3)
  integer(c_ptrdiff_t), target :: strides(3)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 3, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(3), counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(3:1:-1))) then
    deallocate (val)
    allocate (val(counts(3), counts(2), counts(1)))
  end if
  stat = nc_get_vars_double(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(4), counts(4)
  integer(c_ptrdiff_t), target :: strides(4)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 4, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(4), counts(3), counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(4:1:-1))) then
    deallocate (val)
    allocate (val(counts(4), counts(3), counts(2), counts(1)))
  end if
  stat = nc_get_vars_double(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(5), counts(5)
  integer(c_ptrdiff_t), target :: strides(5)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 5, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(5), counts(4), counts(3), counts(2), &
    & counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(5:1:-1))) then
    deallocate (val)
    allocate (val(counts(5), counts(4), counts(3), counts(2), &
    & counts(1)))
  end if
  stat = nc_get_vars_double(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(6), counts(6)
  integer(c_ptrdiff_t), target :: strides(6)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 6, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(6), counts(5), counts(4), counts(3), &
    & counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(6:1:-1))) then
    deallocate (val)
    allocate (val(counts(6), counts(5), counts(4), counts(3), &
    & counts(2), counts(1)))
  end if
  stat = nc_get_vars_double(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(7), counts(7)
  integer(c_ptrdiff_t), target :: strides(7)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 7, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(7), counts(6), counts(5), counts(4), &
    & counts(3), counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(7:1:-1))) then
    deallocate (val)
    allocate (val(counts(7), counts(6), counts(5), counts(4), &
    & counts(3), counts(2), counts(1)))
  end if
  stat = nc_get_vars_double(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(8), counts(8)
  integer(c_ptrdiff_t), target :: strides(8)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 8, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(8), counts(7), counts(6), counts(5), &
    & counts(4), counts(3), counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(8:1:-1))) then
    deallocate (val)
    allocate (val(counts(8), counts(7), counts(6), counts(5), &
    & counts(4), counts(3), counts(2), counts(1)))
  end if
  stat = nc_get_vars_double(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(9), counts(9)
  integer(c_ptrdiff_t), target :: strides(9)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 9, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(9), counts(8), counts(7), counts(6), &
    & counts(5), counts(4), counts(3), counts(2), &
    & counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(9:1:-1))) then
    deallocate (val)
    allocate (val(counts(9), counts(8), counts(7), counts(6), &
    & counts(5), counts(4), counts(3), counts(2), &
    & counts(1)))
  end if
  stat = nc_get_vars_double(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(10), counts(10)
  integer(c_ptrdiff_t), target :: strides(10)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 10, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(10), counts(9), counts(8), counts(7), &
    & counts(6), counts(5), counts(4), counts(3), &
    & counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(10:1:-1))) then
    deallocate (val)
    allocate (val(counts(10), counts(9), counts(8), counts(7), &
    & counts(6), counts(5), counts(4), counts(3), &
    & counts(2), counts(1)))
  end if
  stat = nc_get_vars_double(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(11), counts(11)
  integer(c_ptrdiff_t), target :: strides(11)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 11, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(11), counts(10), counts(9), counts(8), &
    & counts(7), counts(6), counts(5), counts(4), &
    & counts(3), counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(11:1:-1))) then
    deallocate (val)
    allocate (val(counts(11), counts(10), counts(9), counts(8), &
    & counts(7), counts(6), counts(5), counts(4), &
    & counts(3), counts(2), counts(1)))
  end if
  stat = nc_get_vars_double(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(12), counts(12)
  integer(c_ptrdiff_t), target :: strides(12)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 12, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(12), counts(11), counts(10), counts(9), &
    & counts(8), counts(7), counts(6), counts(5), &
    & counts(4), counts(3), counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(12:1:-1))) then
    deallocate (val)
    allocate (val(counts(12), counts(11), counts(10), counts(9), &
    & counts(8), counts(7), counts(6), counts(5), &
    & counts(4), counts(3), counts(2), counts(1)))
  end if
  stat = nc_get_vars_double(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(13), counts(13)
  integer(c_ptrdiff_t), target :: strides(13)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 13, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(13), counts(12), counts(11), counts(10), &
    & counts(9), counts(8), counts(7), counts(6), &
    & counts(5), counts(4), counts(3), counts(2), &
    & counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(13:1:-1))) then
    deallocate (val)
    allocate (val(counts(13), counts(12), counts(11), counts(10), &
    & counts(9), counts(8), counts(7), counts(6), &
    & counts(5), counts(4), counts(3), counts(2), &
    & counts(1)))
  end if
  stat = nc_get_vars_double(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(14), counts(14)
  integer(c_ptrdiff_t), target :: strides(14)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 14, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(14), counts(13), counts(12), counts(11), &
    & counts(10), counts(9), counts(8), counts(7), &
    & counts(6), counts(5), counts(4), counts(3), &
    & counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(14:1:-1))) then
    deallocate (val)
    allocate (val(counts(14), counts(13), counts(12), counts(11), &
    & counts(10), counts(9), counts(8), counts(7), &
    & counts(6), counts(5), counts(4), counts(3), &
    & counts(2), counts(1)))
  end if
  stat = nc_get_vars_double(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
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
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(15), counts(15)
  integer(c_ptrdiff_t), target :: strides(15)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 15, varid, &
    & starts, counts, strides, op_err, start, count, stride)
  if (has_err(op_err) .or. any(counts == 0_c_size_t)) then
    call return_err(op_err, err)
    return
  end if
  if (.not. allocated(val)) then
    allocate (val(counts(15), counts(14), counts(13), counts(12), &
    & counts(11), counts(10), counts(9), counts(8), &
    & counts(7), counts(6), counts(5), counts(4), &
    & counts(3), counts(2), counts(1)))
  else if (any(shape(val, kind=c_size_t) /= counts(15:1:-1))) then
    deallocate (val)
    allocate (val(counts(15), counts(14), counts(13), counts(12), &
    & counts(11), counts(10), counts(9), counts(8), &
    & counts(7), counts(6), counts(5), counts(4), &
    & counts(3), counts(2), counts(1)))
  end if
  stat = nc_get_vars_double(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(strides(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_real64_15d


end submodule nc4f_netcdf_extract
