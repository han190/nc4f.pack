interface operator(+)
  module procedure :: add_vars
  module procedure :: add_var_real32
  module procedure :: add_real32_var
  module procedure :: add_var_real64
  module procedure :: add_real64_var
  module procedure :: add_var_int32
  module procedure :: add_int32_var
  module procedure :: add_var_int64
  module procedure :: add_int64_var
end interface operator(+)

interface operator(-)
  module procedure :: sub_vars
  module procedure :: sub_var_real32
  module procedure :: sub_real32_var
  module procedure :: sub_var_real64
  module procedure :: sub_real64_var
  module procedure :: sub_var_int32
  module procedure :: sub_int32_var
  module procedure :: sub_var_int64
  module procedure :: sub_int64_var
end interface operator(-)

interface operator(*)
  module procedure :: mul_vars
  module procedure :: mul_var_real32
  module procedure :: mul_real32_var
  module procedure :: mul_var_real64
  module procedure :: mul_real64_var
  module procedure :: mul_var_int32
  module procedure :: mul_int32_var
  module procedure :: mul_var_int64
  module procedure :: mul_int64_var
end interface operator(*)

interface operator(/)
  module procedure :: div_vars
  module procedure :: div_var_real32
  module procedure :: div_real32_var
  module procedure :: div_var_real64
  module procedure :: div_real64_var
  module procedure :: div_var_int32
  module procedure :: div_int32_var
  module procedure :: div_var_int64
  module procedure :: div_int64_var
end interface operator(/)

interface operator(**)
  module procedure :: pow_vars
  module procedure :: pow_var_real32
  module procedure :: pow_real32_var
  module procedure :: pow_var_real64
  module procedure :: pow_real64_var
  module procedure :: pow_var_int32
  module procedure :: pow_int32_var
  module procedure :: pow_var_int64
  module procedure :: pow_int64_var
end interface operator(**)

interface sum
  module procedure :: sum_vars
end interface sum

interface
  module function add_vars(x, y) result(res)
    type(variable_type), target, intent(in) :: x, y
    type(variable_type), target :: res
  end function add_vars

  module function add_var_real32(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    real(real32), intent(in) :: y
    type(variable_type), target :: res
  end function add_var_real32

  module function add_real32_var(x, y) result(res)
    real(real32), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function add_real32_var

  module function add_var_real64(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    real(real64), intent(in) :: y
    type(variable_type), target :: res
  end function add_var_real64

  module function add_real64_var(x, y) result(res)
    real(real64), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function add_real64_var

  module function add_var_int32(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    integer(int32), intent(in) :: y
    type(variable_type), target :: res
  end function add_var_int32

  module function add_int32_var(x, y) result(res)
    integer(int32), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function add_int32_var

  module function add_var_int64(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    integer(int64), intent(in) :: y
    type(variable_type), target :: res
  end function add_var_int64

  module function add_int64_var(x, y) result(res)
    integer(int64), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function add_int64_var

  module function sub_vars(x, y) result(res)
    type(variable_type), target, intent(in) :: x, y
    type(variable_type), target :: res
  end function sub_vars

  module function sub_var_real32(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    real(real32), intent(in) :: y
    type(variable_type), target :: res
  end function sub_var_real32

  module function sub_real32_var(x, y) result(res)
    real(real32), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function sub_real32_var

  module function sub_var_real64(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    real(real64), intent(in) :: y
    type(variable_type), target :: res
  end function sub_var_real64

  module function sub_real64_var(x, y) result(res)
    real(real64), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function sub_real64_var

  module function sub_var_int32(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    integer(int32), intent(in) :: y
    type(variable_type), target :: res
  end function sub_var_int32

  module function sub_int32_var(x, y) result(res)
    integer(int32), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function sub_int32_var

  module function sub_var_int64(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    integer(int64), intent(in) :: y
    type(variable_type), target :: res
  end function sub_var_int64

  module function sub_int64_var(x, y) result(res)
    integer(int64), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function sub_int64_var

  module function mul_vars(x, y) result(res)
    type(variable_type), target, intent(in) :: x, y
    type(variable_type), target :: res
  end function mul_vars

  module function mul_var_real32(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    real(real32), intent(in) :: y
    type(variable_type), target :: res
  end function mul_var_real32

  module function mul_real32_var(x, y) result(res)
    real(real32), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function mul_real32_var

  module function mul_var_real64(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    real(real64), intent(in) :: y
    type(variable_type), target :: res
  end function mul_var_real64

  module function mul_real64_var(x, y) result(res)
    real(real64), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function mul_real64_var

  module function mul_var_int32(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    integer(int32), intent(in) :: y
    type(variable_type), target :: res
  end function mul_var_int32

  module function mul_int32_var(x, y) result(res)
    integer(int32), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function mul_int32_var

  module function mul_var_int64(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    integer(int64), intent(in) :: y
    type(variable_type), target :: res
  end function mul_var_int64

  module function mul_int64_var(x, y) result(res)
    integer(int64), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function mul_int64_var

  module function div_vars(x, y) result(res)
    type(variable_type), target, intent(in) :: x, y
    type(variable_type), target :: res
  end function div_vars

  module function div_var_real32(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    real(real32), intent(in) :: y
    type(variable_type), target :: res
  end function div_var_real32

  module function div_real32_var(x, y) result(res)
    real(real32), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function div_real32_var

  module function div_var_real64(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    real(real64), intent(in) :: y
    type(variable_type), target :: res
  end function div_var_real64

  module function div_real64_var(x, y) result(res)
    real(real64), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function div_real64_var

  module function div_var_int32(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    integer(int32), intent(in) :: y
    type(variable_type), target :: res
  end function div_var_int32

  module function div_int32_var(x, y) result(res)
    integer(int32), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function div_int32_var

  module function div_var_int64(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    integer(int64), intent(in) :: y
    type(variable_type), target :: res
  end function div_var_int64

  module function div_int64_var(x, y) result(res)
    integer(int64), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function div_int64_var

  module function pow_vars(x, y) result(res)
    type(variable_type), target, intent(in) :: x, y
    type(variable_type), target :: res
  end function pow_vars

  module function pow_var_real32(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    real(real32), intent(in) :: y
    type(variable_type), target :: res
  end function pow_var_real32

  module function pow_real32_var(x, y) result(res)
    real(real32), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function pow_real32_var

  module function pow_var_real64(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    real(real64), intent(in) :: y
    type(variable_type), target :: res
  end function pow_var_real64

  module function pow_real64_var(x, y) result(res)
    real(real64), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function pow_real64_var

  module function pow_var_int32(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    integer(int32), intent(in) :: y
    type(variable_type), target :: res
  end function pow_var_int32

  module function pow_int32_var(x, y) result(res)
    integer(int32), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function pow_int32_var

  module function pow_var_int64(x, y) result(res)
    type(variable_type), target, intent(in) :: x
    integer(int64), intent(in) :: y
    type(variable_type), target :: res
  end function pow_var_int64

  module function pow_int64_var(x, y) result(res)
    integer(int64), intent(in) :: x
    type(variable_type), target, intent(in) :: y
    type(variable_type), target :: res
  end function pow_int64_var

  module function sum_vars(vars) result(s)
    type(variable_type), intent(in) :: vars(:)
    type(variable_type) :: s
  end function sum_vars
end interface

interface extract
	module procedure :: extract_att_real32_1d
	module procedure :: extract_att_real32_scalar
	module procedure :: extract_att_real64_1d
	module procedure :: extract_att_real64_scalar
	module procedure :: extract_att_int32_1d
	module procedure :: extract_att_int32_scalar
	module procedure :: extract_att_int64_1d
	module procedure :: extract_att_int64_scalar
	module procedure :: extract_var_real32_1d
	module procedure :: extract_var_real32_2d
	module procedure :: extract_var_real32_3d
	module procedure :: extract_var_real32_4d
	module procedure :: extract_var_real64_1d
	module procedure :: extract_var_real64_2d
	module procedure :: extract_var_real64_3d
	module procedure :: extract_var_real64_4d
	module procedure :: extract_var_int32_1d
	module procedure :: extract_var_int32_2d
	module procedure :: extract_var_int32_3d
	module procedure :: extract_var_int32_4d
	module procedure :: extract_var_int64_1d
	module procedure :: extract_var_int64_2d
	module procedure :: extract_var_int64_3d
	module procedure :: extract_var_int64_4d
end interface extract

interface
	module subroutine extract_att_real32_1d(att, ptr)
		type(attribute_type), target, intent(in) :: att
		real(real32), pointer, intent(out) :: ptr(:)
	end subroutine extract_att_real32_1d

	module subroutine extract_att_real32_scalar(att, val)
		type(attribute_type), target, intent(in) :: att
		real(real32), intent(out) :: val
	end subroutine extract_att_real32_scalar

	module subroutine extract_var_real32_1d(var, ptr)
		type(variable_type), target, intent(in) :: var
		real(real32), pointer, intent(out) :: ptr(:)
	end subroutine extract_var_real32_1d

	module subroutine extract_var_real32_2d(var, ptr)
		type(variable_type), target, intent(in) :: var
		real(real32), pointer, intent(out) :: ptr(:,:)
	end subroutine extract_var_real32_2d

	module subroutine extract_var_real32_3d(var, ptr)
		type(variable_type), target, intent(in) :: var
		real(real32), pointer, intent(out) :: ptr(:,:,:)
	end subroutine extract_var_real32_3d

	module subroutine extract_var_real32_4d(var, ptr)
		type(variable_type), target, intent(in) :: var
		real(real32), pointer, intent(out) :: ptr(:,:,:,:)
	end subroutine extract_var_real32_4d

	module subroutine extract_att_real64_1d(att, ptr)
		type(attribute_type), target, intent(in) :: att
		real(real64), pointer, intent(out) :: ptr(:)
	end subroutine extract_att_real64_1d

	module subroutine extract_att_real64_scalar(att, val)
		type(attribute_type), target, intent(in) :: att
		real(real64), intent(out) :: val
	end subroutine extract_att_real64_scalar

	module subroutine extract_var_real64_1d(var, ptr)
		type(variable_type), target, intent(in) :: var
		real(real64), pointer, intent(out) :: ptr(:)
	end subroutine extract_var_real64_1d

	module subroutine extract_var_real64_2d(var, ptr)
		type(variable_type), target, intent(in) :: var
		real(real64), pointer, intent(out) :: ptr(:,:)
	end subroutine extract_var_real64_2d

	module subroutine extract_var_real64_3d(var, ptr)
		type(variable_type), target, intent(in) :: var
		real(real64), pointer, intent(out) :: ptr(:,:,:)
	end subroutine extract_var_real64_3d

	module subroutine extract_var_real64_4d(var, ptr)
		type(variable_type), target, intent(in) :: var
		real(real64), pointer, intent(out) :: ptr(:,:,:,:)
	end subroutine extract_var_real64_4d

	module subroutine extract_att_int32_1d(att, ptr)
		type(attribute_type), target, intent(in) :: att
		integer(int32), pointer, intent(out) :: ptr(:)
	end subroutine extract_att_int32_1d

	module subroutine extract_att_int32_scalar(att, val)
		type(attribute_type), target, intent(in) :: att
		integer(int32), intent(out) :: val
	end subroutine extract_att_int32_scalar

	module subroutine extract_var_int32_1d(var, ptr)
		type(variable_type), target, intent(in) :: var
		integer(int32), pointer, intent(out) :: ptr(:)
	end subroutine extract_var_int32_1d

	module subroutine extract_var_int32_2d(var, ptr)
		type(variable_type), target, intent(in) :: var
		integer(int32), pointer, intent(out) :: ptr(:,:)
	end subroutine extract_var_int32_2d

	module subroutine extract_var_int32_3d(var, ptr)
		type(variable_type), target, intent(in) :: var
		integer(int32), pointer, intent(out) :: ptr(:,:,:)
	end subroutine extract_var_int32_3d

	module subroutine extract_var_int32_4d(var, ptr)
		type(variable_type), target, intent(in) :: var
		integer(int32), pointer, intent(out) :: ptr(:,:,:,:)
	end subroutine extract_var_int32_4d

	module subroutine extract_att_int64_1d(att, ptr)
		type(attribute_type), target, intent(in) :: att
		integer(int64), pointer, intent(out) :: ptr(:)
	end subroutine extract_att_int64_1d

	module subroutine extract_att_int64_scalar(att, val)
		type(attribute_type), target, intent(in) :: att
		integer(int64), intent(out) :: val
	end subroutine extract_att_int64_scalar

	module subroutine extract_var_int64_1d(var, ptr)
		type(variable_type), target, intent(in) :: var
		integer(int64), pointer, intent(out) :: ptr(:)
	end subroutine extract_var_int64_1d

	module subroutine extract_var_int64_2d(var, ptr)
		type(variable_type), target, intent(in) :: var
		integer(int64), pointer, intent(out) :: ptr(:,:)
	end subroutine extract_var_int64_2d

	module subroutine extract_var_int64_3d(var, ptr)
		type(variable_type), target, intent(in) :: var
		integer(int64), pointer, intent(out) :: ptr(:,:,:)
	end subroutine extract_var_int64_3d

	module subroutine extract_var_int64_4d(var, ptr)
		type(variable_type), target, intent(in) :: var
		integer(int64), pointer, intent(out) :: ptr(:,:,:,:)
	end subroutine extract_var_int64_4d

end interface
interface data_array
  module procedure :: new_variable_real32_1d
  module procedure :: new_variable_real32_1d_att
  module procedure :: new_variable_real32_2d
  module procedure :: new_variable_real32_2d_att
  module procedure :: new_variable_real32_3d
  module procedure :: new_variable_real32_3d_att
  module procedure :: new_variable_real32_4d
  module procedure :: new_variable_real32_4d_att
  module procedure :: new_variable_real64_1d
  module procedure :: new_variable_real64_1d_att
  module procedure :: new_variable_real64_2d
  module procedure :: new_variable_real64_2d_att
  module procedure :: new_variable_real64_3d
  module procedure :: new_variable_real64_3d_att
  module procedure :: new_variable_real64_4d
  module procedure :: new_variable_real64_4d_att
  module procedure :: new_variable_int32_1d
  module procedure :: new_variable_int32_1d_att
  module procedure :: new_variable_int32_2d
  module procedure :: new_variable_int32_2d_att
  module procedure :: new_variable_int32_3d
  module procedure :: new_variable_int32_3d_att
  module procedure :: new_variable_int32_4d
  module procedure :: new_variable_int32_4d_att
  module procedure :: new_variable_int64_1d
  module procedure :: new_variable_int64_1d_att
  module procedure :: new_variable_int64_2d
  module procedure :: new_variable_int64_2d_att
  module procedure :: new_variable_int64_3d
  module procedure :: new_variable_int64_3d_att
  module procedure :: new_variable_int64_4d
  module procedure :: new_variable_int64_4d_att
end interface

interface
  module function new_variable_real32_1d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    real(real32), target, intent(in) :: values(:)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_real32_1d

  module function new_variable_real32_1d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    real(real32), target, intent(in) :: values(:)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_real32_1d_att

  module function new_variable_real32_2d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    real(real32), target, intent(in) :: values(:, :)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_real32_2d

  module function new_variable_real32_2d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    real(real32), target, intent(in) :: values(:, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_real32_2d_att

  module function new_variable_real32_3d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    real(real32), target, intent(in) :: values(:, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_real32_3d

  module function new_variable_real32_3d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    real(real32), target, intent(in) :: values(:, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_real32_3d_att

  module function new_variable_real32_4d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    real(real32), target, intent(in) :: values(:, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_real32_4d

  module function new_variable_real32_4d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    real(real32), target, intent(in) :: values(:, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_real32_4d_att

  module function new_variable_real64_1d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    real(real64), target, intent(in) :: values(:)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_real64_1d

  module function new_variable_real64_1d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    real(real64), target, intent(in) :: values(:)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_real64_1d_att

  module function new_variable_real64_2d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    real(real64), target, intent(in) :: values(:, :)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_real64_2d

  module function new_variable_real64_2d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    real(real64), target, intent(in) :: values(:, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_real64_2d_att

  module function new_variable_real64_3d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    real(real64), target, intent(in) :: values(:, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_real64_3d

  module function new_variable_real64_3d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    real(real64), target, intent(in) :: values(:, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_real64_3d_att

  module function new_variable_real64_4d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    real(real64), target, intent(in) :: values(:, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_real64_4d

  module function new_variable_real64_4d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    real(real64), target, intent(in) :: values(:, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_real64_4d_att

  module function new_variable_int32_1d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    integer(int32), target, intent(in) :: values(:)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_int32_1d

  module function new_variable_int32_1d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int32), target, intent(in) :: values(:)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_int32_1d_att

  module function new_variable_int32_2d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    integer(int32), target, intent(in) :: values(:, :)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_int32_2d

  module function new_variable_int32_2d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int32), target, intent(in) :: values(:, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_int32_2d_att

  module function new_variable_int32_3d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    integer(int32), target, intent(in) :: values(:, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_int32_3d

  module function new_variable_int32_3d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int32), target, intent(in) :: values(:, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_int32_3d_att

  module function new_variable_int32_4d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    integer(int32), target, intent(in) :: values(:, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_int32_4d

  module function new_variable_int32_4d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int32), target, intent(in) :: values(:, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_int32_4d_att

  module function new_variable_int64_1d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    integer(int64), target, intent(in) :: values(:)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_int64_1d

  module function new_variable_int64_1d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int64), target, intent(in) :: values(:)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_int64_1d_att

  module function new_variable_int64_2d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    integer(int64), target, intent(in) :: values(:, :)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_int64_2d

  module function new_variable_int64_2d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int64), target, intent(in) :: values(:, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_int64_2d_att

  module function new_variable_int64_3d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    integer(int64), target, intent(in) :: values(:, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_int64_3d

  module function new_variable_int64_3d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int64), target, intent(in) :: values(:, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_int64_3d_att

  module function new_variable_int64_4d(name, values, dims) result(var)
    character(len=*), intent(in) :: name
    integer(int64), target, intent(in) :: values(:, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(variable_type), target :: var
  end function new_variable_int64_4d

  module function new_variable_int64_4d_att(name, values, dims, atts) result(var)
    character(len=*), intent(in) :: name
    integer(int64), target, intent(in) :: values(:, :, :, :)
    type(dimension_type), intent(in) :: dims(:)
    type(attribute_type), intent(in) :: atts(:)
    type(variable_type), target :: var
  end function new_variable_int64_4d_att

end interface