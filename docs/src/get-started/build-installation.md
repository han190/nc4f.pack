# Build and Installation

`NC4F` requires a modern Fortran compiler and the NetCDF C library. 
The NetCDF Fortran library is not required. The tested Fortran compilers are:
- gfortran >= 15
- llvm flang >= 23

## Build and test with fpm

From a checkout of this repository, build and run the test suite with:

```sh
fpm test --compiler gfortran --profile debug --flag "$(pkg-config --cflags --libs netcdf)"
```

Generated NetCDF test artifacts are written to `build/test-results/`.

## Use NC4F as an fpm dependency

Add `NC4F` to the consuming package's `fpm.toml`, then link the NetCDF C
library in that package:

```toml
[dependencies]
nc4f = { git = "https://github.com/han190/nc4f.pack.git" }

[build]
link = ["netcdf"]
```

Your application can then import the public façade with:

```fortran
use, non_intrinsic :: nc4f
```

## Build from Make with fypp

The Make build regenerates constructors, extraction routines, and coordinate
accessors from the `fypp/` templates. Install
[fypp](https://fypp.readthedocs.io/en/stable/fypp.html) before building when
you intend to edit or regenerate those templates.

```sh
git clone https://github.com/han190/nc4f.pack.git
cd nc4f.pack
python -m pip install fypp
make library
make test
```

Use `make preprocess` to regenerate sources without compiling. Edit
`fypp/nc4f_data_coordinate.fypp` for coordinate access; its generated
`src/*.f90` files are tracked alongside the templates. Public
coordinate interface declarations remain in `src/nc4f_data.f90`.

`make library` creates `build/makefile_<compiler>_<profile>/ncpack.a`;
`make test` builds and runs the test executable. Set `PROFILE=release` for
optimized compiler flags.

## Build with CMake

CMake 3.24 or newer, a C compiler, a supported Fortran compiler, and `pkg-config`
are required. CMake discovers the NetCDF C library through `netcdf.pc`; set
`PKG_CONFIG_PATH` if NetCDF is installed in a nonstandard location.

```sh
cmake -S . -B build/cmake -DCMAKE_Fortran_COMPILER=gfortran -DCMAKE_BUILD_TYPE=Release
cmake --build build/cmake --parallel
./scripts/download_test_data.sh
ctest --test-dir build/cmake --output-on-failure
```

Use `-DCMAKE_Fortran_COMPILER=flang` (or `flang-new`, depending on the installation)
for LLVM Flang, in a separate build directory.
Use `-DCMAKE_BUILD_TYPE=Debug` for debugging; GNU builds additionally
enable bounds checks and warnings in that configuration.

### Intel Fortran on Linux

Install the [Intel Fortran compiler](https://www.intel.com/content/www/us/en/developer/tools/oneapi/fortran-compiler-download.html)
and initialize the oneAPI environment before using `ifx`. For a default system
installation:

```sh
source /opt/intel/oneapi/setvars.sh
./scripts/download_test_data.sh
make FC=ifx PROFILE=debug test
make FC=ifx PROFILE=release test

cmake -S . -B build/cmake-ifx -DCMAKE_Fortran_COMPILER=ifx -DCMAKE_BUILD_TYPE=Debug
cmake --build build/cmake-ifx --parallel
ctest --test-dir build/cmake-ifx --output-on-failure
```

Use a separate CMake build directory with `-DCMAKE_BUILD_TYPE=Release` for
an optimized Intel build. Both build systems use these Intel flags:

| Configuration | Flags |
|:--|:--|
| Both | `-standard-semantics -fp-model precise` |
| Debug | `-O0 -g -warn all -check bounds -traceback` |
| Release | `-O3` |

Make uses `-module` to place Intel module files in the compiler/profile build
directory. CMake manages the module output option automatically.

### Build targets and options

The build creates `libnc4f.a` and `libnc4f_c_interface.a`. To build only the C
bindings, without compiling the high-level library:

```sh
cmake --build build/cmake --target nc4f_c_interface
```

Compiler module files are under `build/cmake/modules/`. The regression suite
runs from the repository root, reads fixtures from `data/`, and writes outputs
to `build/test-results/`, matching the Make and fpm builds. Fixture downloads
are explicit; CMake does not download them during configuration or compilation.

| Option | Default | Purpose |
|:--|:--|:--|
| `NC4F_BUILD_TESTS` | `ON` for a standalone build; `OFF` as a subproject | Build and register the regression suite with CTest. |
| `NC4F_BUILD_EXAMPLES` | `OFF` | Build the examples and provide the `run-examples` target. |
| `NC4F_REGENERATE_SOURCES` | `OFF` | Require fypp and regenerate all templated sources and interfaces in the build directory. |

For example, to build and run all examples:

```sh
cmake -S . -B build/cmake -DNC4F_BUILD_EXAMPLES=ON
cmake --build build/cmake --target run-examples
```

The target runs the writer before the reader and places generated files under
`build/cmake/examples/`.

### Install and use from another CMake project

```sh
cmake --install build/cmake --prefix /path/to/nc4f-install
```

In the consuming project's `CMakeLists.txt`:

```cmake
cmake_minimum_required(VERSION 3.24)
project(my_application LANGUAGES Fortran)
find_package(nc4f CONFIG REQUIRED)
add_executable(my_application main.f90)
target_link_libraries(my_application PRIVATE nc4f::nc4f)
```

Configure the application with `-DCMAKE_PREFIX_PATH=/path/to/nc4f-install`.
The imported target supplies module include paths and the NetCDF C dependency.
Use `nc4f::c_interface` to link only the low-level bindings. Build the library and
consumer with compatible Fortran compilers; installed module files are stored
under a directory containing the compiler name and version.

For a vendored checkout, `add_subdirectory(path/to/nc4f)` provides the same two
targets without installation. Tests and examples are disabled by default when
NC4F is included as a subproject.

## Build the documentation

Install the documentation dependencies and generate the Sphinx Book Theme
site from the repository root:

```sh
python -m pip install -r requirements-docs.txt
python -m sphinx -b html -c docs docs/src docs/pages
```

Open `docs/pages/index.html` in a browser.

## Publish with GitHub Pages

The `Deploy documentation` workflow builds the Sphinx site from `docs/src` and
deploys the generated `docs/pages` artifact whenever documentation changes are
pushed to `main`. In the repository's **Settings → Pages**, select **GitHub
Actions** as the publishing source.
