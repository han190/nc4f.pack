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

The Make build regenerates the constructor and extraction source files from
the `fypp/` templates. Install [fypp](https://fypp.readthedocs.io/en/stable/fypp.html) 
before building when you intend to edit
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
python -m sphinx -b html -c docs docs/src docs/pages
```

Open `docs/pages/index.html` in a browser.

## Publish with GitHub Pages

The `Deploy documentation` workflow builds the Sphinx site from `docs/src` and
deploys the generated `docs/pages` artifact whenever documentation changes are
pushed to `main`. In the repository's **Settings → Pages**, select **GitHub
Actions** as the publishing source.
