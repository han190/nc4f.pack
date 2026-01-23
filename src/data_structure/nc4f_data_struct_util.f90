submodule(nc4f_data_struct) nc4f_data_struct_util
implicit none (type, external)
contains

!> Check whether re-allocation of a buffer is required.
!> This compares the current buffer size with the requested target size.
module pure logical function allocation_required(buffer, bsize)
  !> Buffer array to check.
  integer(int8), allocatable, intent(in) :: buffer(:)
  !> Target buffer size required.
  integer(int64), intent(in) :: bsize

  allocation_required = .false.
  if (.not. allocated(buffer)) then
    allocation_required = .true.
  else if (size(buffer) < bsize) then
    allocation_required = .true.
  end if
end function allocation_required

!> Compute the buffer size in bytes for a given netCDF data type and
!> number of elements.
module elemental function get_buffer_size(dtype, len) result(buffer_size)
  !> NetCDF data type code (NC_* constants).
  integer(data_type), intent(in) :: dtype
  !> Number of elements of the given type.
  integer(int64), intent(in) :: len
  !> Result buffer size.
  integer(int64) :: buffer_size
  character(len=MAX_CHAR_LEN) :: data_name
  integer(int64) :: st_size

  select case (dtype)
  case (BYTE_TYPE, CHAR_TYPE)
    st_size = storage_size(0_int8, kind=int64)
  case (SHORT_TYPE)
    st_size = storage_size(0_int16, kind=int64)
  case (INT_TYPE)
    st_size = storage_size(0_int32, kind=int64)
  case (INT64_TYPE)
    st_size = storage_size(0_int64, kind=int64)
  case (FLOAT_TYPE)
    st_size = storage_size(0.0_real32, kind=int64)
  case (DOUBLE_TYPE)
    st_size = storage_size(0.0_real64, kind=int64)
  case default
    write (data_name, "(i0)") dtype
    error stop "[get_buffer_size] Unsupported type."// &
      & " Data type: "//trim(data_name)//"."
  end select
  buffer_size = len*st_size/8
end function get_buffer_size

end submodule nc4f_data_struct_util
