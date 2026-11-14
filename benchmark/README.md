# Expression evaluation benchmark

Run all square extents from `2^1` through `2^13` with fpm:

```sh
fpm run --example expression-benchmark \
  --profile macos-homebrew-release -- 3
```

Save the benchmark output and plot all three timing paths:

```sh
fpm run --example expression-benchmark \
  --profile macos-homebrew-release -- 3 > benchmark/expression.txt
python3 benchmark/plot_expression.py benchmark/expression.txt
```

The plot is saved as `benchmark/expression.svg`. It uses extent on a base-2
horizontal axis and time in units of `10^-3 ms` on a vertical axis that is
linear through zero and logarithmic above 1 unit. A zero timing is shown at
zero; it means the benchmark clock did not resolve that measurement.
The shared vertical axis ends at `10^5` in these units; larger measurements
are clipped from the figure.
Three side-by-side panels show OP = 2, 8, and 32. Each panel uses white-filled
circles: red for RAW, green for EXTR, and blue for EXPR. The panels share both
axes for direct comparison.
The plotting script requires Matplotlib.

The optional argument is the number of repetitions per expression and extent;
it defaults to 3. The benchmark evaluates these real64 expressions:

- `a*(b+c)` (OP = 2)
- `(a*(b+c))/(a+1.0_real64) + sqrt(b*c) + c` (OP = 8)
- `((a*(b+c))/(a+1.0_real64) + sqrt(b*c) + c)`
  `+ ((a+b)*(b+c) + (a+c)*(a+b))`
  `+ (((a*b+c)/(b+1.0_real64))*sqrt(a+c))`
  `+ ((a+c)*(b+c) + (a+b)*(a+c))` (OP = 32)

`OP` counts arithmetic operations and `sqrt` calls per element as written;
repeated subexpressions count each time they appear. One aligned row is printed
for each extent and OP count. Each row averages milliseconds per evaluation
across repetitions of that expression. The three timing paths are: `EXPR`
uses NC4F expressions, `EXTR` uses `EXTRACT` followed by direct array
calculation, and `RAW` calculates directly from `x`, `y`, and `z`.
`EXPR/RAW` and `EXTR/RAW` both use raw-array time as the baseline. The last
column is the accumulated NC4F checksum. All paths use the same inputs.
Each ratio is the arithmetic mean of the per-repetition path/RAW ratios for
that expression. If any RAW repetition measures zero clock ticks, both ratio
columns display `N/A` for that row.
The timer excludes input initialization, expression construction, warm-up,
and the full-array checksum after each repetition. Checksums make every result
observable and are compared across all three paths. Final arrays are also
compared element by element.

At extent 8192, each real64 array occupies about 0.5 GiB. The three inputs,
direct output, and NC4F result alone require about 2.5 GiB; expression
temporaries and runtime overhead require more. Allow ample memory and time.
Run with the same compiler, profile, and repetition count when comparing
changes.
