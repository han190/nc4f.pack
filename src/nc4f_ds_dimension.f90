submodule(nc4f_ds) nc4f_ds_dimension
implicit none (type, external)
contains

!> Construct unlimited-dimension arguments from a 32-bit length.
module elemental function new_dim_arg_int32(len, is_unlim) result(arg)
  !> Length of the dimension or attribute.
  integer(int32), intent(in) :: len
  !> Whether the dimension is unlimited.
  logical, intent(in) :: is_unlim
  !> Result produced by this operation.
  type(dimension_argument_type) :: arg

  arg%len = int(len, int64)
  arg%is_unlim = is_unlim
end function new_dim_arg_int32

!> Construct unlimited-dimension arguments from a 64-bit length.
module elemental function new_dim_arg_int64(len, is_unlim) result(arg)
  !> Length of the dimension or attribute.
  integer(int64), intent(in) :: len
  !> Whether the dimension is unlimited.
  logical, intent(in) :: is_unlim
  !> Result produced by this operation.
  type(dimension_argument_type) :: arg

  arg%len = len
  arg%is_unlim = is_unlim
end function new_dim_arg_int64

!> Construct a dimension from a 32-bit length.
module elemental function new_dim_len_int32(name, len) result(dim)
  !> Name used to identify the NetCDF object.
  character(len=*), intent(in) :: name
  !> Length of the dimension or attribute.
  integer(int32), intent(in) :: len
  !> Result produced by this operation.
  type(dimension_type) :: dim

  dim%name = trim(name)
  dim%len = int(len, int64)
end function new_dim_len_int32

!> Construct a dimension from a 64-bit length.
module elemental function new_dim_len_int64(name, len) result(dim)
  !> Name used to identify the NetCDF object.
  character(len=*), intent(in) :: name
  !> Length of the dimension or attribute.
  integer(int64), intent(in) :: len
  !> Result produced by this operation.
  type(dimension_type) :: dim

  dim%name = trim(name)
  dim%len = len
end function new_dim_len_int64

!> Construct a dimension with an explicit unlimited flag.
module elemental function new_dim_args(name, args) result(dim)
  !> Name used to identify the NetCDF object.
  character(len=*), intent(in) :: name
  !> Data or metadata used by this operation.
  type(dimension_argument_type), intent(in) :: args
  !> Result produced by this operation.
  type(dimension_type) :: dim

  dim%name = trim(name)
  dim%len = args%len
  dim%is_unlim = args%is_unlim
end function new_dim_args

!> Return true when two dimensions have identical metadata.
module elemental logical function eq_dim(x, y)
  !> Dataset objects or values used by this operation.
  type(dimension_type), intent(in) :: x, y

  eq_dim = x%len == y%len .and. x%is_unlim .eqv. y%is_unlim
  if (eq_dim) then
    eq_dim = allocated(x%name) .eqv. allocated(y%name)
    if (eq_dim .and. allocated(x%name)) eq_dim = x%name == y%name
  end if
end function eq_dim

!> Return true when two dimensions have different metadata.
module elemental logical function neq_dim(x, y)
  !> Dataset objects or values used by this operation.
  type(dimension_type), intent(in) :: x, y

  neq_dim = .not. eq_dim(x, y)
end function neq_dim

end submodule nc4f_ds_dimension
