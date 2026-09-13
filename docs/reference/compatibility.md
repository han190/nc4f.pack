# Compatibility

| Component | Beta support | Validation |
|:--|:--|:--|
| NetCDF C library with NetCDF-4 support | Required | Integration tests link through `pkg-config` |
| gfortran 14 | Supported | Ubuntu CI, debug and release |
| flang-new 18 | Supported beta target | Ubuntu CI, release |
| Fortran 2018 submodules | Required | Core implementation |
| Linux | Supported | Ubuntu CI |
| macOS and other POSIX systems | Expected where requirements are present | Not a release gate yet |

`nc4f` calls the NetCDF C API and does not require the NetCDF Fortran library.
