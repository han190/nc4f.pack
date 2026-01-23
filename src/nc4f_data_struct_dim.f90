submodule(nc4f_data_struct) nc4f_data_struct_dim
implicit none (type, external)
contains

!> Construct a `dimension_argument_type` from a 64-bit length and a
!> logical indicating whether the dimension is unlimited.
module elemental function new_dim_arg_int64(len, is_unlim) result(arg)
  !> Length of the dimension (int64).
  integer(int64), intent(in) :: len
  !> True if the dimension is unlimited.
  logical, intent(in) :: is_unlim
  !> A dimension argument.
  type(dimension_argument_type) :: arg

  arg%len = len
  arg%is_unlim = is_unlim
end function new_dim_arg_int64

!> Construct a `dimension_argument_type` from a 32-bit length and a
!> logical indicating whether the dimension is unlimited.
module elemental function new_dim_arg_int32(len, is_unlim) result(arg)
  !> Length of the dimension (int32).
  integer(int32), intent(in) :: len
  !> True if the dimension is unlimited.
  logical, intent(in) :: is_unlim
  !> A dimension argument.
  type(dimension_argument_type) :: arg

  arg%len = len
  arg%is_unlim = is_unlim
end function new_dim_arg_int32

!> Create a `dimension_type` given a name and a 64-bit length.
module elemental function new_dim_len_int64(name, len) result(dim)
  !> Dimension name (will be trimmed).
  character(len=*), intent(in) :: name
  !> Length of the dimension (int64).
  integer(int64), intent(in) :: len
  !> Result dimension.
  type(dimension_type) :: dim

  dim%name = name
  dim%len = len
  dim%is_unlim = .false.
end function new_dim_len_int64

!> Create a `dimension_type` given a name and a 32-bit length.
module elemental function new_dim_len_int32(name, len) result(dim)
  !> Dimension name (will be trimmed).
  character(len=*), intent(in) :: name
  !> Length of the dimension (int32).
  integer(int32), intent(in) :: len
  !> Result dimension.
  type(dimension_type) :: dim

  dim%name = name
  dim%len = len
  dim%is_unlim = .false.
end function new_dim_len_int32

!> Create a `dimension_type` from a name and a `dimension_argument_type`.
module elemental function new_dim_args(name, args) result(dim)
  !> Dimension name.
  character(len=*), intent(in) :: name
  !> `dimension_argument_type` containing length and unlimited flag.
  type(dimension_argument_type), intent(in) :: args
  !> Result dimension.
  type(dimension_type) :: dim

  dim%name = name
  dim%len = args%len
  dim%is_unlim = args%is_unlim
end function new_dim_args

!> Compare two `dimension_type` values for equality
!> (name, length, and unlimited flag).
module elemental logical function eq_dim(x, y)
  !> Left-hand `dimension_type` to compare.
  type(dimension_type), intent(in) :: x
  !> Right-hand `dimension_type` to compare.
  type(dimension_type), intent(in) :: y

  eq_dim = (x%is_unlim .eqv. y%is_unlim) .and. &
    & (x%len == y%len) .and. (x%name == y%name)
end function eq_dim

!> Test whether two `dimension_type` values are different.
module elemental logical function neq_dim(x, y)
  !> Left-hand `dimension_type` to compare.
  type(dimension_type), intent(in) :: x
  !> Right-hand `dimension_type` to compare.
  type(dimension_type), intent(in) :: y

  neq_dim = (x%is_unlim .neqv. y%is_unlim) .or. &
    & (x%len /= y%len) .or. (x%name /= y%name)
end function neq_dim

end submodule nc4f_data_struct_dim
