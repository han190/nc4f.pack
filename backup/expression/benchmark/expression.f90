program benchmark_expression
  !! Compare NC4F with extracted arrays and direct source arrays.
  use, intrinsic :: iso_fortran_env, only: int64, real64
  use, non_intrinsic :: nc4f, only: variable_type, expression_type, &
    & datarray, evaluate, extract, operator(.dim.), operator(+), &
    & operator(*), operator(/), sqrt
  implicit none (type, external)

  type(variable_type), target :: a, b, c, result
  type(expression_type) :: expr
  real(real64), allocatable, target :: x(:,:), y(:,:), z(:,:)
  real(real64), allocatable :: direct(:,:)
  real(real64), pointer :: ax(:,:), bx(:,:), cx(:,:), actual(:,:)
  integer(int64) :: tick0, tick1, rate
  integer(int64) :: nc_ticks, extract_ticks, raw_ticks
  integer(int64) :: expr_tick, extr_tick, raw_tick
  integer :: exponent, extent, repetitions, case_id, iteration, i, j
  integer :: op_count
  real(real64) :: expr_ms, extr_ms, raw_ms
  real(real64) :: nc_checksum, extract_checksum, raw_checksum
  real(real64) :: expr_ratio_sum, extr_ratio_sum
  logical :: valid_ratio
  character(len=32) :: arg
  character(len=9) :: expr_ratio, extr_ratio

  repetitions = 3
  if (command_argument_count() > 0) then
    call get_command_argument(1, arg)
    read (arg, *) repetitions
  end if
  if (repetitions < 1) error stop "Repetitions must be positive."
  call system_clock(count_rate=rate)

  write (*, "(a8,1x,a4,3(1x,a12),2(1x,a9),1x,a18)") &
    & "extent", "OP", "EXPR (ms)", "EXTR (ms)", &
    & "RAW (ms)", "EXPR/RAW", "EXTR/RAW", "checksum"
  do exponent = 1, 13
    extent = 2**exponent
    allocate (x(extent, extent), y(extent, extent), &
      & z(extent, extent), direct(extent, extent))
    do concurrent (j=1:extent, i=1:extent)
      x(i, j) = 1.0_real64 + &
        & real(mod(i + 17*j, 97), real64)/97.0_real64
    end do
    y = 2.0_real64
    z = 0.5_real64
    a = datarray("a", x, ["x".dim.extent, "y".dim.extent], &
      & deep=.false.)
    b = datarray("b", y, ["x".dim.extent, "y".dim.extent], &
      & deep=.false.)
    c = datarray("c", z, ["x".dim.extent, "y".dim.extent], &
      & deep=.false.)
    do case_id = 1, 3
      nc_ticks = 0_int64
      extract_ticks = 0_int64
      raw_ticks = 0_int64
      expr_ratio_sum = 0.0_real64
      extr_ratio_sum = 0.0_real64
      valid_ratio = .true.
      select case (case_id)
      case (1)
        op_count = 2
        expr = a*(b+c)
      case (2)
        op_count = 8
        expr = (a*(b+c))/(a+1.0_real64) + sqrt(b*c) + c
      case (3)
        op_count = 32
        expr = ((a*(b+c))/(a+1.0_real64) + sqrt(b*c) + c) + &
          & ((a+b)*(b+c) + (a+c)*(a+b)) + &
          & (((a*b+c)/(b+1.0_real64))*sqrt(a+c)) + &
          & ((a+c)*(b+c) + (a+b)*(a+c))
      case default
        error stop "Unknown expression."
      end select

      call evaluate(expr, result)
      call extract(a, ax)
      call extract(b, bx)
      call extract(c, cx)
      call direct_kernel(case_id, ax, bx, cx, direct)
      call direct_kernel(case_id, x, y, z, direct)
      nc_checksum = 0.0_real64
      extract_checksum = 0.0_real64
      raw_checksum = 0.0_real64

      do iteration = 1, repetitions
        call update_input(iteration)
        call system_clock(tick0)
        call evaluate(expr, result)
        call system_clock(tick1)
        expr_tick = tick1 - tick0
        nc_ticks = nc_ticks + expr_tick
        call extract(result, actual)
        nc_checksum = nc_checksum + sum(actual)

        call system_clock(tick0)
        call extract(a, ax)
        call extract(b, bx)
        call extract(c, cx)
        call direct_kernel(case_id, ax, bx, cx, direct)
        call system_clock(tick1)
        extr_tick = tick1 - tick0
        extract_ticks = extract_ticks + extr_tick
        extract_checksum = extract_checksum + sum(direct)

        call system_clock(tick0)
        call direct_kernel(case_id, x, y, z, direct)
        call system_clock(tick1)
        raw_tick = tick1 - tick0
        raw_ticks = raw_ticks + raw_tick
        raw_checksum = raw_checksum + sum(direct)
        if (raw_tick == 0_int64) then
          valid_ratio = .false.
        else
          expr_ratio_sum = expr_ratio_sum + &
            & real(expr_tick, real64)/real(raw_tick, real64)
          extr_ratio_sum = extr_ratio_sum + &
            & real(extr_tick, real64)/real(raw_tick, real64)
        end if
      end do

      call extract(result, actual)
      if (any(abs(actual-direct) > &
        & 1.0e-12_real64*max(1.0_real64, abs(direct)))) then
        error stop "NC4F and direct results differ."
      end if
      if (abs(nc_checksum-extract_checksum) > &
        & 1.0e-12_real64*max(1.0_real64, abs(extract_checksum))) then
        error stop "NC4F and extracted checksums differ."
      end if
      if (abs(nc_checksum-raw_checksum) > &
        & 1.0e-12_real64*max(1.0_real64, abs(raw_checksum))) then
        error stop "NC4F and raw checksums differ."
      end if
      expr_ms = milliseconds_per_call(nc_ticks)
      extr_ms = milliseconds_per_call(extract_ticks)
      raw_ms = milliseconds_per_call(raw_ticks)
      expr_ratio = ratio_text(expr_ratio_sum, valid_ratio)
      extr_ratio = ratio_text(extr_ratio_sum, valid_ratio)
      write (*, "(i8,1x,i4,3(1x,es12.4),2(1x,a9),1x,es18.10)") &
        & extent, op_count, expr_ms, extr_ms, raw_ms, &
        & expr_ratio, extr_ratio, nc_checksum
    end do
    deallocate (x, y, z, direct)
  end do

contains

  subroutine update_input(iteration)
    !! Change one input value so each repetition has distinct work.
    integer, intent(in) :: iteration
    !! One-based repetition number.

    x(1, 1) = 1.0_real64 + &
      & real(iteration, real64)*1.0e-6_real64
  end subroutine update_input

  real(real64) function milliseconds_per_call(ticks) result(milliseconds)
    !! Average elapsed milliseconds across repetitions of one expression.
    integer(int64), intent(in) :: ticks
    !! Sum of timed ticks for one expression and path.

    milliseconds = 1000.0_real64*real(ticks, real64)/ &
      & real(rate, real64)/real(repetitions, real64)
  end function milliseconds_per_call

  function ratio_text(ratio_sum, valid) result(rendered)
    !! Format the mean of per-repetition ratios or an unavailable value.
    real(real64), intent(in) :: ratio_sum
    !! Sum of ratios across repetitions of one expression.
    logical, intent(in) :: valid
    !! False when any RAW repetition had zero elapsed clock ticks.
    character(len=9) :: rendered

    if (.not. valid) then
      rendered = repeat(" ", 6)//"N/A"
    else
      write (rendered, "(f9.2)") &
        & ratio_sum/real(repetitions, real64)
    end if
  end function ratio_text

  subroutine direct_kernel(which, u, v, w, output)
    !! Calculate one expression using ordinary Fortran array syntax.
    integer, intent(in) :: which
    !! Expression identifier in the outer benchmark loop.
    real(real64), intent(in) :: u(:,:), v(:,:), w(:,:)
    !! Conformable input arrays, extracted or passed directly.
    real(real64), intent(out) :: output(:,:)
    !! Preallocated result array.

    select case (which)
    case (1)
      output = u*(v+w)
    case (2)
      output = (u*(v+w))/(u+1.0_real64) + sqrt(v*w) + w
    case (3)
      output = ((u*(v+w))/(u+1.0_real64) + sqrt(v*w) + w) + &
        & ((u+v)*(v+w) + (u+w)*(u+v)) + &
        & (((u*v+w)/(v+1.0_real64))*sqrt(u+w)) + &
        & ((u+w)*(v+w) + (u+v)*(u+w))
    case default
      error stop "Unknown expression."
    end select
  end subroutine direct_kernel
end program benchmark_expression
