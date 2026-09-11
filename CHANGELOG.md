# Changelog

## 0.1.0-beta.2 (package version 0.1.0)

- Added recursive `group_type` and the `data_set` constructor for composing
  in-memory groups from local `data_array` values, attributes, and child groups.
- Added the public group inquiry APIs: `get_group`, `inquire_groups`, and
  `inquire_group`.
- Added `to_netcdf_grp` and `to_netcdf_grps` for recursively serializing an
  in-memory group as a file root or an array of groups as root children.

## 0.1.0-beta.1 (package version 0.1.0)

- Added `NC_CHAR` variable construction, extraction, and round-trip coverage.
- Added append/read-write dataset modes and hyperslab variable writes.
- Reorganized integration tests into focused Fortran submodules.
- Added pull-request CI for debug/release gfortran and release flang builds.

## Prior releases

Historical changes before the beta release are recorded in the Git history.
