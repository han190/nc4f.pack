program benchmark_expression
  !! Compile against a release library; arguments: matrix extent, repetitions.
  use, intrinsic :: iso_fortran_env, only: int32, int64, real64
  use nc4f, only: variable_type, expression_type, datarray, evaluate, extract, &
    & operator(.dim.), operator(+), operator(*), operator(/), operator(**), sqrt
  implicit none (type, external)
  interface
    subroutine intrinsic_fused(a, b, c, d)
      !! Reference intrinsic-array kernel compiled separately from the caller.
      import :: real64
      real(real64), contiguous, intent(in) :: a(:,:), b(:,:), c(:,:)
      !! A is the multiplier; B and C are addends. Shapes must match.
      real(real64), contiguous, intent(out) :: d(:,:)
      !! Nonaliasing preallocated destination with matching dimensions.
    end subroutine intrinsic_fused
  end interface

  type(variable_type), target :: a, b, c
  type(variable_type), target :: result
  type(expression_type) :: expr
  real(real64), allocatable, target :: x(:,:), y(:,:), z(:,:)
  integer(int32), allocatable, target :: ix(:,:), iy(:,:), iz(:,:)
  integer :: extent, repetitions, i
  character(len=32) :: arg

  extent = 1024
  repetitions = 3
  if (command_argument_count() > 0) then
    call get_command_argument(1, arg)
    read(arg, *) extent
  end if
  if (command_argument_count() > 1) then
    call get_command_argument(2, arg)
    read(arg, *) repetitions
  end if
  if (extent < 1 .or. repetitions < 1) error stop 'Arguments must be positive.'
  allocate(x(extent,extent), y(extent,extent), z(extent,extent))
  x = reshape([(1.0_real64 + real(mod(i, 97), real64)/97, &
    & i=1,size(x))], shape(x))
  y = 2.0_real64*x
  z = 0.5_real64*x
  a = datarray('a', x, ['x'.dim.extent, 'y'.dim.extent], deep=.false.)
  b = datarray('b', y, ['x'.dim.extent, 'y'.dim.extent], deep=.false.)
  c = datarray('c', z, ['x'.dim.extent, 'y'.dim.extent], deep=.false.)
  expr = a*(b+c)
  call measure('real64 fused', expr)
  call measure_intrinsic(.false.)
  call measure_intrinsic(.true.)
  expr = (a*(b+c))/(a+1.0_real64) + sqrt(b*c)
  call measure('real64 nested', expr)
  expr = sqrt(a+1.0_real64)
  call measure('real64 unary', expr)
  expr = (a+b)*(b+c) + (a+c)*(a+b)
  call measure('real64 balanced', expr, (x+y)*(y+z)+(x+z)*(x+y))

  allocate(ix(extent,extent), iy(extent,extent), iz(extent,extent))
  ix = 2; iy = 3; iz = 4
  a = datarray('a', ix, ['x'.dim.extent, 'y'.dim.extent], deep=.false.)
  b = datarray('b', iy, ['x'.dim.extent, 'y'.dim.extent], deep=.false.)
  c = datarray('c', iz, ['x'.dim.extent, 'y'.dim.extent], deep=.false.)
  expr = a*(b+c)
  call measure('int32 fused', expr)
contains
  subroutine measure_intrinsic(staged)
    !! Time intrinsic-array evaluation and check it against the NC4F result.
    logical, intent(in) :: staged
    !! True allocates output per repetition; false reuses the initial output.
    real(real64), allocatable :: output(:,:), temporary(:,:)
    real(real64), pointer :: nc_values(:,:)
    integer(int64) :: tick0, tick1, rate
    integer :: repeat
    character(len=32) :: label

    allocate(output(extent,extent))
    call intrinsic_fused(x, y, z, output)
    call system_clock(tick0, rate)
    do repeat = 1, repetitions
      if (staged) then
        allocate(temporary(extent,extent))
        call intrinsic_fused(x, y, z, temporary)
        call move_alloc(temporary, output)
      else
        call intrinsic_fused(x, y, z, output)
      end if
    end do
    call system_clock(tick1)
    call extract(result, nc_values)
    if (.not. all(output == nc_values)) error stop 'Intrinsic/NC4F results differ.'
    label = 'intrinsic real64 preallocated'
    if (staged) label = 'intrinsic real64 staged'
    write(*,'(a,": ",f10.6," s/evaluation; checksum ",es24.16)') &
      & trim(label), real(tick1-tick0,real64)/real(rate,real64)/repetitions, sum(output)
  end subroutine measure_intrinsic

  subroutine measure(label, expression, expected)
    !! Time repeated NC4F evaluation after warm-up and report a checksum.
    character(len=*), intent(in) :: label
    !! Printed case name; int32 fused selects integer checksum extraction.
    type(expression_type), intent(in) :: expression
    !! Prebuilt tree with live operand storage, evaluated on every repetition.
    real(real64), intent(in), optional :: expected(:,:)
    !! Optional real64 reference matrix checked outside the timed region.
    real(real64), pointer :: reals(:), matrix(:,:)
    integer(int32), pointer :: integers(:)
    integer(int64) :: tick0, tick1, rate
    real(real64) :: checksum
    integer :: repeat

    call evaluate(expression, result) ! Warm up outside the measurement.
    call system_clock(tick0, rate)
    do repeat = 1, repetitions
      call evaluate(expression, result)
    end do
    call system_clock(tick1)
    if (label == 'int32 fused') then
      call extract(result, integers)
      checksum = real(sum(int(integers, int64)), real64)
    else
      call extract(result, reals)
      checksum = sum(reals)
    end if
    if (present(expected)) then
      call extract(result, matrix)
      if (any(abs(matrix-expected) > 1.0e-12_real64*max(1.0_real64, abs(expected)))) &
        & error stop 'Balanced expression differs from intrinsic arrays.'
    end if
    write(*,'(a,": ",f10.6," s/evaluation; checksum ",es24.16)') &
      & label, real(tick1-tick0,real64)/real(rate,real64)/repetitions, checksum
  end subroutine measure
end program benchmark_expression
