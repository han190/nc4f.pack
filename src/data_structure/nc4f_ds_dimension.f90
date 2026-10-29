submodule(nc4f_ds) nc4f_ds_dimension
implicit none (type, external)
contains

elemental module function new_dim_arg_int32(len, is_unlim) result(arg)
  !! Construct unlimited-dimension arguments from a 32-bit length.
  integer(int32), intent(in) :: len
  !! Length of the dimension or attribute.
  logical, intent(in) :: is_unlim
  !! Whether the dimension is unlimited.
  type(dimension_argument_type) :: arg
  !! Result produced by this operation.

  arg%len = int(len, int64)
  arg%is_unlim = is_unlim
end function new_dim_arg_int32

elemental module function new_dim_arg_int64(len, is_unlim) result(arg)
  !! Construct unlimited-dimension arguments from a 64-bit length.
  integer(int64), intent(in) :: len
  !! Length of the dimension or attribute.
  logical, intent(in) :: is_unlim
  !! Whether the dimension is unlimited.
  type(dimension_argument_type) :: arg
  !! Result produced by this operation.

  arg%len = len
  arg%is_unlim = is_unlim
end function new_dim_arg_int64

elemental module function new_dim_len_int32(name, len) result(dim)
  !! Construct a dimension from a 32-bit length.
  character(len=*), intent(in) :: name
  !! Name used to identify the NetCDF object.
  integer(int32), intent(in) :: len
  !! Length of the dimension or attribute.
  type(dimension_type) :: dim
  !! Result produced by this operation.

  dim%name = trim(name)
  dim%len = int(len, int64)
end function new_dim_len_int32

elemental module function new_dim_len_int64(name, len) result(dim)
  !! Construct a dimension from a 64-bit length.
  character(len=*), intent(in) :: name
  !! Name used to identify the NetCDF object.
  integer(int64), intent(in) :: len
  !! Length of the dimension or attribute.
  type(dimension_type) :: dim
  !! Result produced by this operation.

  dim%name = trim(name)
  dim%len = len
end function new_dim_len_int64

elemental module function new_dim_args(name, args) result(dim)
  !! Construct a dimension with an explicit unlimited flag.
  character(len=*), intent(in) :: name
  !! Name used to identify the NetCDF object.
  type(dimension_argument_type), intent(in) :: args
  !! Data or metadata used by this operation.
  type(dimension_type) :: dim
  !! Result produced by this operation.

  dim%name = trim(name)
  dim%len = args%len
  dim%is_unlim = args%is_unlim
end function new_dim_args

logical elemental module function eq_dim(x, y)
  !! Return true when two dimensions have identical metadata.
  type(dimension_type), intent(in) :: x, y
  !! Dataset objects or values used by this operation.

  eq_dim = x%len == y%len .and. x%is_unlim .eqv. y%is_unlim
  if (eq_dim) then
    eq_dim = allocated(x%name) .eqv. allocated(y%name)
    if (eq_dim .and. allocated(x%name)) eq_dim = x%name == y%name
  end if
end function eq_dim

logical elemental module function neq_dim(x, y)
  !! Return true when two dimensions have different metadata.
  type(dimension_type), intent(in) :: x, y
  !! Dataset objects or values used by this operation.

  neq_dim = .not. eq_dim(x, y)
end function neq_dim

end submodule nc4f_ds_dimension
