# Expression evaluation benchmark

Build a release library and compile the standalone benchmark with the same
compiler. For GNU Fortran:

```sh
cmake -S . -B build/benchmark -DCMAKE_Fortran_COMPILER=gfortran \
  -DCMAKE_BUILD_TYPE=Release -DNC4F_BUILD_TESTS=OFF \
  -DNC4F_REGENERATE_SOURCES=ON
cmake --build build/benchmark --parallel 4
gfortran -O3 -fcoarray=single \
  -Ibuild/benchmark/modules/nc4f -Ibuild/benchmark/modules/c_interface \
  benchmark/expression.f90 benchmark/intrinsic_fused.f90 \
  build/benchmark/libnc4f.a \
  build/benchmark/libnc4f_c_interface.a $(pkg-config --libs netcdf) \
  -o build/benchmark/expression
./build/benchmark/expression 1024 5
```

The optional arguments are the square matrix extent and repetition count.
The program measures wall time per evaluation after a warm-up and prints a
checksum. It covers real64 fused arithmetic, a deeper arithmetic/unary tree,
a unary expression, a balanced tree requiring two scratch buffers, and int32
fused arithmetic. Two intrinsic-array cases
measure the same real64 `D = A*(B+C)`: one reuses a preallocated destination;
the other allocates a staged destination on each evaluation, like NC4F.
Intrinsic results are compared element by element against NC4F. The balanced
tree is also checked against intrinsic-array arithmetic with a relative
tolerance of `1e-12`.

Inputs use borrowed contiguous buffers; expression construction (including
typed leaf binding) and input
initialization are outside the timer. Tree validation, output allocation,
evaluation, and result replacement are timed.

The intrinsic kernel is a separate compilation unit. Compile without link-time
optimization (LTO) so the caller cannot eliminate identical repeated calls.

Use identical compilers, optimization settings, dimensions, and repetition
counts when comparing revisions. Check checksums as well as timings. The
`DO CONCURRENT` kernels do not guarantee SIMD or multithreaded execution;
compiler options and implementation determine the execution strategy.

For Flang host parallelization, use a separate build directory with
`-DCMAKE_Fortran_COMPILER=flang` and
`-DCMAKE_Fortran_FLAGS="-fopenmp -fdo-concurrent-to-openmp=host"`.
Compile the benchmark with `flang -O3 -fopenmp` against that build's modules
and libraries. Set `OMP_NUM_THREADS` to control the host thread count.

The block evaluator currently uses 1024-element blocks and up to 32 logical
lanes. Each lane reuses its scratch bank across its assigned blocks. The number
of scratch buffers per lane comes from expression liveness, rather than a
fixed reservation or one buffer per operation. Simple expressions such as
`A*(B+C)` reuse the output block and require no additional scratch buffers.
