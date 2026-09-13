# Build and Installation

`nc4f` requires a modern Fortran compiler, the NetCDF C headers and library,
and `pkg-config`. The NetCDF Fortran library is not required.

## Build and test with fpm

From a checkout of this repository, build and run the test suite with:

```sh
fpm test --profile debug --flag "$(pkg-config --cflags --libs netcdf)"
```

Generated NetCDF test artifacts are written to `build/test-results/`.

## Use nc4f as an fpm dependency

Add `nc4f` to the consuming package's `fpm.toml`, then link the NetCDF C
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

The Make build regenerates the constructor and extraction source files from
the `fypp/` templates. Install `fypp` before building when you intend to edit
or regenerate those templates.

```sh
git clone https://github.com/han190/nc4f.pack.git
cd nc4f.pack
python -m pip install fypp
make library
make test
```

`make library` creates `build/makefile/ncpack.a`; `make test` builds and runs
the test executable. Set `PROFILE=release` for optimized compiler flags.

## Build the documentation

Install the documentation dependencies and generate the Sphinx Book Theme
site from the repository root:

```sh
python -m pip install -r requirements-docs.txt
python -m sphinx -b html docs build/sphinx
```

Open `build/sphinx/index.html` in a browser.
