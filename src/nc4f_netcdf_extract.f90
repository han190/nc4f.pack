submodule(nc4f_netcdf) nc4f_netcdf_extract
implicit none (type, external)
contains

subroutine prepare_extract_(nc, name, expected_rank, varid, counts, err)
  !! Resolve a variable and its C-order shape without loading its metadata.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer, intent(in) :: expected_rank
  !! Rank required by the selected extraction procedure.
  integer(c_int), intent(out) :: varid
  !! NetCDF-C variable identifier.
  integer(c_size_t), intent(out) :: counts(:)
  !! Dimension lengths in NetCDF-C order.
  type(error_type), intent(out) :: err
  !! Inquiry or rank error.
  integer(c_int), allocatable :: dimids(:)
  integer(c_int) :: rank, stat
  integer :: i

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
end subroutine prepare_extract_

module subroutine extract_val_int8_1d(nc, name, val, err)
  !! Read stored variable values directly into a int8 rank-1 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int8), allocatable, target, intent(inout) :: &
    & val(:)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(1), counts(1)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 1, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_schar(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int8_1d

module subroutine extract_val_int8_2d(nc, name, val, err)
  !! Read stored variable values directly into a int8 rank-2 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int8), allocatable, target, intent(inout) :: &
    & val(:, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(2), counts(2)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 2, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_schar(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int8_2d

module subroutine extract_val_int8_3d(nc, name, val, err)
  !! Read stored variable values directly into a int8 rank-3 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int8), allocatable, target, intent(inout) :: &
    & val(:, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(3), counts(3)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 3, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_schar(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int8_3d

module subroutine extract_val_int8_4d(nc, name, val, err)
  !! Read stored variable values directly into a int8 rank-4 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int8), allocatable, target, intent(inout) :: &
    & val(:, :, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(4), counts(4)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 4, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_schar(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int8_4d

module subroutine extract_val_int8_5d(nc, name, val, err)
  !! Read stored variable values directly into a int8 rank-5 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int8), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(5), counts(5)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 5, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_schar(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int8_5d

module subroutine extract_val_int8_6d(nc, name, val, err)
  !! Read stored variable values directly into a int8 rank-6 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int8), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(6), counts(6)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 6, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_schar(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int8_6d

module subroutine extract_val_int8_7d(nc, name, val, err)
  !! Read stored variable values directly into a int8 rank-7 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int8), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(7), counts(7)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 7, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_schar(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int8_7d

module subroutine extract_val_int8_8d(nc, name, val, err)
  !! Read stored variable values directly into a int8 rank-8 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int8), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(8), counts(8)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 8, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_schar(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int8_8d

module subroutine extract_val_int8_9d(nc, name, val, err)
  !! Read stored variable values directly into a int8 rank-9 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int8), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(9), counts(9)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 9, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_schar(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int8_9d

module subroutine extract_val_int8_10d(nc, name, val, err)
  !! Read stored variable values directly into a int8 rank-10 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int8), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :, :, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(10), counts(10)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 10, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_schar(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int8_10d

module subroutine extract_val_int8_11d(nc, name, val, err)
  !! Read stored variable values directly into a int8 rank-11 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int8), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :, :, :, :, &
    & :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(11), counts(11)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 11, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_schar(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int8_11d

module subroutine extract_val_int8_12d(nc, name, val, err)
  !! Read stored variable values directly into a int8 rank-12 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int8), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :, :, :, :, &
    & :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(12), counts(12)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 12, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_schar(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int8_12d

module subroutine extract_val_int8_13d(nc, name, val, err)
  !! Read stored variable values directly into a int8 rank-13 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int8), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :, :, :, :, &
    & :, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(13), counts(13)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 13, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_schar(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int8_13d

module subroutine extract_val_int8_14d(nc, name, val, err)
  !! Read stored variable values directly into a int8 rank-14 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int8), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :, :, :, :, &
    & :, :, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(14), counts(14)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 14, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_schar(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int8_14d

module subroutine extract_val_int8_15d(nc, name, val, err)
  !! Read stored variable values directly into a int8 rank-15 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int8), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :, :, :, :, &
    & :, :, :, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(15), counts(15)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 15, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_schar(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int8_15d

module subroutine extract_val_int16_1d(nc, name, val, err)
  !! Read stored variable values directly into a int16 rank-1 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int16), allocatable, target, intent(inout) :: &
    & val(:)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(1), counts(1)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 1, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_short(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int16_1d

module subroutine extract_val_int16_2d(nc, name, val, err)
  !! Read stored variable values directly into a int16 rank-2 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int16), allocatable, target, intent(inout) :: &
    & val(:, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(2), counts(2)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 2, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_short(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int16_2d

module subroutine extract_val_int16_3d(nc, name, val, err)
  !! Read stored variable values directly into a int16 rank-3 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int16), allocatable, target, intent(inout) :: &
    & val(:, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(3), counts(3)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 3, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_short(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int16_3d

module subroutine extract_val_int16_4d(nc, name, val, err)
  !! Read stored variable values directly into a int16 rank-4 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int16), allocatable, target, intent(inout) :: &
    & val(:, :, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(4), counts(4)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 4, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_short(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int16_4d

module subroutine extract_val_int16_5d(nc, name, val, err)
  !! Read stored variable values directly into a int16 rank-5 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int16), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(5), counts(5)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 5, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_short(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int16_5d

module subroutine extract_val_int16_6d(nc, name, val, err)
  !! Read stored variable values directly into a int16 rank-6 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int16), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(6), counts(6)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 6, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_short(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int16_6d

module subroutine extract_val_int16_7d(nc, name, val, err)
  !! Read stored variable values directly into a int16 rank-7 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int16), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(7), counts(7)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 7, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_short(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int16_7d

module subroutine extract_val_int16_8d(nc, name, val, err)
  !! Read stored variable values directly into a int16 rank-8 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int16), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(8), counts(8)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 8, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_short(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int16_8d

module subroutine extract_val_int16_9d(nc, name, val, err)
  !! Read stored variable values directly into a int16 rank-9 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int16), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(9), counts(9)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 9, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_short(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int16_9d

module subroutine extract_val_int16_10d(nc, name, val, err)
  !! Read stored variable values directly into a int16 rank-10 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int16), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :, :, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(10), counts(10)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 10, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_short(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int16_10d

module subroutine extract_val_int16_11d(nc, name, val, err)
  !! Read stored variable values directly into a int16 rank-11 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int16), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :, :, :, :, &
    & :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(11), counts(11)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 11, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_short(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int16_11d

module subroutine extract_val_int16_12d(nc, name, val, err)
  !! Read stored variable values directly into a int16 rank-12 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int16), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :, :, :, :, &
    & :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(12), counts(12)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 12, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_short(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int16_12d

module subroutine extract_val_int16_13d(nc, name, val, err)
  !! Read stored variable values directly into a int16 rank-13 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int16), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :, :, :, :, &
    & :, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(13), counts(13)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 13, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_short(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int16_13d

module subroutine extract_val_int16_14d(nc, name, val, err)
  !! Read stored variable values directly into a int16 rank-14 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int16), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :, :, :, :, &
    & :, :, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(14), counts(14)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 14, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_short(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int16_14d

module subroutine extract_val_int16_15d(nc, name, val, err)
  !! Read stored variable values directly into a int16 rank-15 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int16), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :, :, :, :, &
    & :, :, :, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(15), counts(15)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 15, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_short(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int16_15d

module subroutine extract_val_int32_1d(nc, name, val, err)
  !! Read stored variable values directly into a int32 rank-1 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int32), allocatable, target, intent(inout) :: &
    & val(:)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(1), counts(1)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 1, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_int(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int32_1d

module subroutine extract_val_int32_2d(nc, name, val, err)
  !! Read stored variable values directly into a int32 rank-2 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int32), allocatable, target, intent(inout) :: &
    & val(:, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(2), counts(2)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 2, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_int(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int32_2d

module subroutine extract_val_int32_3d(nc, name, val, err)
  !! Read stored variable values directly into a int32 rank-3 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int32), allocatable, target, intent(inout) :: &
    & val(:, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(3), counts(3)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 3, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_int(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int32_3d

module subroutine extract_val_int32_4d(nc, name, val, err)
  !! Read stored variable values directly into a int32 rank-4 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int32), allocatable, target, intent(inout) :: &
    & val(:, :, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(4), counts(4)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 4, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_int(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int32_4d

module subroutine extract_val_int32_5d(nc, name, val, err)
  !! Read stored variable values directly into a int32 rank-5 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int32), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(5), counts(5)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 5, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_int(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int32_5d

module subroutine extract_val_int32_6d(nc, name, val, err)
  !! Read stored variable values directly into a int32 rank-6 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int32), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(6), counts(6)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 6, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_int(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int32_6d

module subroutine extract_val_int32_7d(nc, name, val, err)
  !! Read stored variable values directly into a int32 rank-7 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int32), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(7), counts(7)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 7, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_int(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int32_7d

module subroutine extract_val_int32_8d(nc, name, val, err)
  !! Read stored variable values directly into a int32 rank-8 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int32), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(8), counts(8)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 8, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_int(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int32_8d

module subroutine extract_val_int32_9d(nc, name, val, err)
  !! Read stored variable values directly into a int32 rank-9 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int32), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(9), counts(9)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 9, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_int(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int32_9d

module subroutine extract_val_int32_10d(nc, name, val, err)
  !! Read stored variable values directly into a int32 rank-10 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int32), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :, :, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(10), counts(10)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 10, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_int(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int32_10d

module subroutine extract_val_int32_11d(nc, name, val, err)
  !! Read stored variable values directly into a int32 rank-11 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int32), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :, :, :, :, &
    & :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(11), counts(11)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 11, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_int(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int32_11d

module subroutine extract_val_int32_12d(nc, name, val, err)
  !! Read stored variable values directly into a int32 rank-12 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int32), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :, :, :, :, &
    & :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(12), counts(12)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 12, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_int(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int32_12d

module subroutine extract_val_int32_13d(nc, name, val, err)
  !! Read stored variable values directly into a int32 rank-13 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int32), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :, :, :, :, &
    & :, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(13), counts(13)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 13, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_int(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int32_13d

module subroutine extract_val_int32_14d(nc, name, val, err)
  !! Read stored variable values directly into a int32 rank-14 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int32), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :, :, :, :, &
    & :, :, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(14), counts(14)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 14, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_int(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int32_14d

module subroutine extract_val_int32_15d(nc, name, val, err)
  !! Read stored variable values directly into a int32 rank-15 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int32), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :, :, :, :, &
    & :, :, :, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(15), counts(15)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 15, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_int(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int32_15d

module subroutine extract_val_int64_1d(nc, name, val, err)
  !! Read stored variable values directly into a int64 rank-1 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int64), allocatable, target, intent(inout) :: &
    & val(:)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(1), counts(1)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 1, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_longlong(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int64_1d

module subroutine extract_val_int64_2d(nc, name, val, err)
  !! Read stored variable values directly into a int64 rank-2 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int64), allocatable, target, intent(inout) :: &
    & val(:, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(2), counts(2)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 2, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_longlong(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int64_2d

module subroutine extract_val_int64_3d(nc, name, val, err)
  !! Read stored variable values directly into a int64 rank-3 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int64), allocatable, target, intent(inout) :: &
    & val(:, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(3), counts(3)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 3, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_longlong(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int64_3d

module subroutine extract_val_int64_4d(nc, name, val, err)
  !! Read stored variable values directly into a int64 rank-4 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int64), allocatable, target, intent(inout) :: &
    & val(:, :, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(4), counts(4)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 4, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_longlong(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int64_4d

module subroutine extract_val_int64_5d(nc, name, val, err)
  !! Read stored variable values directly into a int64 rank-5 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int64), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(5), counts(5)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 5, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_longlong(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int64_5d

module subroutine extract_val_int64_6d(nc, name, val, err)
  !! Read stored variable values directly into a int64 rank-6 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int64), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(6), counts(6)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 6, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_longlong(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int64_6d

module subroutine extract_val_int64_7d(nc, name, val, err)
  !! Read stored variable values directly into a int64 rank-7 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int64), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(7), counts(7)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 7, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_longlong(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int64_7d

module subroutine extract_val_int64_8d(nc, name, val, err)
  !! Read stored variable values directly into a int64 rank-8 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int64), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(8), counts(8)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 8, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_longlong(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int64_8d

module subroutine extract_val_int64_9d(nc, name, val, err)
  !! Read stored variable values directly into a int64 rank-9 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int64), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(9), counts(9)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 9, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_longlong(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int64_9d

module subroutine extract_val_int64_10d(nc, name, val, err)
  !! Read stored variable values directly into a int64 rank-10 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int64), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :, :, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(10), counts(10)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 10, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_longlong(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int64_10d

module subroutine extract_val_int64_11d(nc, name, val, err)
  !! Read stored variable values directly into a int64 rank-11 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int64), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :, :, :, :, &
    & :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(11), counts(11)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 11, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_longlong(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int64_11d

module subroutine extract_val_int64_12d(nc, name, val, err)
  !! Read stored variable values directly into a int64 rank-12 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int64), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :, :, :, :, &
    & :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(12), counts(12)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 12, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_longlong(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int64_12d

module subroutine extract_val_int64_13d(nc, name, val, err)
  !! Read stored variable values directly into a int64 rank-13 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int64), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :, :, :, :, &
    & :, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(13), counts(13)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 13, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_longlong(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int64_13d

module subroutine extract_val_int64_14d(nc, name, val, err)
  !! Read stored variable values directly into a int64 rank-14 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int64), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :, :, :, :, &
    & :, :, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(14), counts(14)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 14, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_longlong(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int64_14d

module subroutine extract_val_int64_15d(nc, name, val, err)
  !! Read stored variable values directly into a int64 rank-15 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  integer(int64), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :, :, :, :, &
    & :, :, :, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(15), counts(15)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 15, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_longlong(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_int64_15d

module subroutine extract_val_real32_1d(nc, name, val, err)
  !! Read stored variable values directly into a real32 rank-1 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  real(real32), allocatable, target, intent(inout) :: &
    & val(:)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(1), counts(1)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 1, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_float(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_real32_1d

module subroutine extract_val_real32_2d(nc, name, val, err)
  !! Read stored variable values directly into a real32 rank-2 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  real(real32), allocatable, target, intent(inout) :: &
    & val(:, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(2), counts(2)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 2, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_float(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_real32_2d

module subroutine extract_val_real32_3d(nc, name, val, err)
  !! Read stored variable values directly into a real32 rank-3 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  real(real32), allocatable, target, intent(inout) :: &
    & val(:, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(3), counts(3)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 3, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_float(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_real32_3d

module subroutine extract_val_real32_4d(nc, name, val, err)
  !! Read stored variable values directly into a real32 rank-4 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  real(real32), allocatable, target, intent(inout) :: &
    & val(:, :, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(4), counts(4)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 4, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_float(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_real32_4d

module subroutine extract_val_real32_5d(nc, name, val, err)
  !! Read stored variable values directly into a real32 rank-5 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  real(real32), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(5), counts(5)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 5, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_float(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_real32_5d

module subroutine extract_val_real32_6d(nc, name, val, err)
  !! Read stored variable values directly into a real32 rank-6 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  real(real32), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(6), counts(6)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 6, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_float(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_real32_6d

module subroutine extract_val_real32_7d(nc, name, val, err)
  !! Read stored variable values directly into a real32 rank-7 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  real(real32), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(7), counts(7)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 7, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_float(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_real32_7d

module subroutine extract_val_real32_8d(nc, name, val, err)
  !! Read stored variable values directly into a real32 rank-8 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  real(real32), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(8), counts(8)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 8, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_float(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_real32_8d

module subroutine extract_val_real32_9d(nc, name, val, err)
  !! Read stored variable values directly into a real32 rank-9 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  real(real32), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(9), counts(9)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 9, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_float(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_real32_9d

module subroutine extract_val_real32_10d(nc, name, val, err)
  !! Read stored variable values directly into a real32 rank-10 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  real(real32), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :, :, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(10), counts(10)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 10, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_float(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_real32_10d

module subroutine extract_val_real32_11d(nc, name, val, err)
  !! Read stored variable values directly into a real32 rank-11 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  real(real32), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :, :, :, :, &
    & :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(11), counts(11)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 11, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_float(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_real32_11d

module subroutine extract_val_real32_12d(nc, name, val, err)
  !! Read stored variable values directly into a real32 rank-12 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  real(real32), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :, :, :, :, &
    & :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(12), counts(12)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 12, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_float(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_real32_12d

module subroutine extract_val_real32_13d(nc, name, val, err)
  !! Read stored variable values directly into a real32 rank-13 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  real(real32), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :, :, :, :, &
    & :, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(13), counts(13)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 13, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_float(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_real32_13d

module subroutine extract_val_real32_14d(nc, name, val, err)
  !! Read stored variable values directly into a real32 rank-14 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  real(real32), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :, :, :, :, &
    & :, :, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(14), counts(14)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 14, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_float(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_real32_14d

module subroutine extract_val_real32_15d(nc, name, val, err)
  !! Read stored variable values directly into a real32 rank-15 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  real(real32), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :, :, :, :, &
    & :, :, :, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(15), counts(15)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 15, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_float(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_real32_15d

module subroutine extract_val_real64_1d(nc, name, val, err)
  !! Read stored variable values directly into a real64 rank-1 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  real(real64), allocatable, target, intent(inout) :: &
    & val(:)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(1), counts(1)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 1, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_double(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_real64_1d

module subroutine extract_val_real64_2d(nc, name, val, err)
  !! Read stored variable values directly into a real64 rank-2 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  real(real64), allocatable, target, intent(inout) :: &
    & val(:, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(2), counts(2)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 2, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_double(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_real64_2d

module subroutine extract_val_real64_3d(nc, name, val, err)
  !! Read stored variable values directly into a real64 rank-3 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  real(real64), allocatable, target, intent(inout) :: &
    & val(:, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(3), counts(3)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 3, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_double(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_real64_3d

module subroutine extract_val_real64_4d(nc, name, val, err)
  !! Read stored variable values directly into a real64 rank-4 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  real(real64), allocatable, target, intent(inout) :: &
    & val(:, :, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(4), counts(4)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 4, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_double(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_real64_4d

module subroutine extract_val_real64_5d(nc, name, val, err)
  !! Read stored variable values directly into a real64 rank-5 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  real(real64), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(5), counts(5)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 5, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_double(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_real64_5d

module subroutine extract_val_real64_6d(nc, name, val, err)
  !! Read stored variable values directly into a real64 rank-6 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  real(real64), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(6), counts(6)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 6, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_double(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_real64_6d

module subroutine extract_val_real64_7d(nc, name, val, err)
  !! Read stored variable values directly into a real64 rank-7 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  real(real64), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(7), counts(7)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 7, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_double(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_real64_7d

module subroutine extract_val_real64_8d(nc, name, val, err)
  !! Read stored variable values directly into a real64 rank-8 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  real(real64), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(8), counts(8)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 8, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_double(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_real64_8d

module subroutine extract_val_real64_9d(nc, name, val, err)
  !! Read stored variable values directly into a real64 rank-9 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  real(real64), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(9), counts(9)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 9, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_double(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_real64_9d

module subroutine extract_val_real64_10d(nc, name, val, err)
  !! Read stored variable values directly into a real64 rank-10 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  real(real64), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :, :, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(10), counts(10)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 10, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_double(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_real64_10d

module subroutine extract_val_real64_11d(nc, name, val, err)
  !! Read stored variable values directly into a real64 rank-11 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  real(real64), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :, :, :, :, &
    & :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(11), counts(11)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 11, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_double(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_real64_11d

module subroutine extract_val_real64_12d(nc, name, val, err)
  !! Read stored variable values directly into a real64 rank-12 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  real(real64), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :, :, :, :, &
    & :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(12), counts(12)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 12, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_double(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_real64_12d

module subroutine extract_val_real64_13d(nc, name, val, err)
  !! Read stored variable values directly into a real64 rank-13 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  real(real64), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :, :, :, :, &
    & :, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(13), counts(13)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 13, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_double(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_real64_13d

module subroutine extract_val_real64_14d(nc, name, val, err)
  !! Read stored variable values directly into a real64 rank-14 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  real(real64), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :, :, :, :, &
    & :, :, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(14), counts(14)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 14, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_double(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_real64_14d

module subroutine extract_val_real64_15d(nc, name, val, err)
  !! Read stored variable values directly into a real64 rank-15 array.
  class(group_type), intent(in) :: nc
  !! Open dataset or group containing the variable.
  character(len=*), intent(in) :: name
  !! Name of the variable to read.
  real(real64), allocatable, target, intent(inout) :: &
    & val(:, :, :, :, :, &
    & :, :, :, :, :, &
    & :, :, :, :, :)
  !! Reused when its shape matches; allocated or resized otherwise.
  !! Empty variables leave the output unchanged.
  !! Inquiry errors preserve it; read errors deallocate it.
  type(error_type), intent(out), optional :: err
  !! Optional error result; failures stop execution when omitted.
  integer(c_int) :: varid, stat
  integer(c_size_t), target :: starts(15), counts(15)
  type(error_type) :: op_err

  call prepare_extract_(nc, name, 15, varid, counts, op_err)
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
  starts = 0_c_size_t
  stat = nc_get_vara_double(nc%id, varid, c_loc(starts(1)), &
    & c_loc(counts(1)), c_loc(val(1, 1, 1, 1, 1, 1, 1, 1, &
    & 1, 1, 1, 1, 1, 1, 1)))
  op_err = netcdf_err(stat, "extract", name)
  if (has_err(op_err)) deallocate (val)
  call return_err(op_err, err)
end subroutine extract_val_real64_15d


end submodule nc4f_netcdf_extract
