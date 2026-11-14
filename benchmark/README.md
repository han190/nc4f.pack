# NetCDF I/O benchmark

`benchmark.f90` performs the same potential-temperature workflow with NC4F
and with the NetCDF Fortran API. Both paths write two-dimensional longitude,
latitude, temperature, and pressure; reopen and read them; calculate
`theta = T * (P0 / P) ** (R / Cp)` through pointers; and append `theta` with
its attributes and CF `coordinates` reference.
The NetCDF Fortran path reads lon and lat once for temperature and again for
pressure, matching NC4F's per-variable coordinate reads.

The benchmark reports mean milliseconds for four phases and their total:
create/write, open/read, calculate, and append. The calculate phase includes
constructing the result variable for NC4F and allocating its array for the
NetCDF Fortran path. Input array generation is outside the timed phases.
Each repetition overwrites its own two output files. A checksum compares the
two calculated fields.

The optional build requires `netcdf-fortran` with a pkg-config package in
addition to NC4F's usual dependencies. Build and run with Make:

```sh
make PROFILE=release benchmark
./build/makefile_gfortran_release/benchmark 3 | tee benchmark/benchmark.txt
python3 benchmark/plot_benchmark.py benchmark/benchmark.txt
```

The benchmark tests square grids with `west_east = south_north = 2^k` for
`k = 1, ..., 13`. The optional argument is the repetition count, which
defaults to 3. Run from a writable directory; the program creates
`benchmark_nc4f.nc` and `benchmark_nf90.nc` there. The largest grids need
substantial memory and disk space.

The plotting script requires Matplotlib. It saves a four-panel SVG to
`benchmark/benchmark.svg` by default; pass a second path to choose another
output file. Each panel shows one phase against grid size, with NC4F in blue
and netcdf-fortran in red. The vertical symlog scale keeps both near-zero
and large timings visible.

CMake also supports an optional `NC4F_BUILD_BENCHMARK=ON` target named
`nc4f_benchmark`. Its configuration requires the `netcdf-fortran` pkg-config
package.
