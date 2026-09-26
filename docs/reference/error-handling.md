# Error Handling

Most operational APIs accept an optional `err` argument. When it is present,
an operation returns normally and places failure status and text in an
`error_type`; otherwise the library uses its fail-fast policy.

`.exists. err` is true exactly when `err%code /= NC_NOERR`.

```fortran
type(error_type) :: err

nc = open_netcdf("missing.nc", "r", err=err)
if (.exists. err) then
  print *, err
  error stop "NetCDF operation failed"
end if
```

## Exposed constants

`nc4f` re-exports the following NetCDF C status constants for comparisons with
`error%code`:

| Constant name | Value | Description |
|:--|:--|:--|
| `NC_NOERR` | 0 | No error. |
| `NC_EBADID` | -33 | Invalid NetCDF ID. |
| `NC_EINVAL` | -36 | Invalid argument. |
| `NC_EINVALCOORDS` | -40 | Index exceeds a dimension bound. |
| `NC_ENOTATT` | -43 | Attribute not found. |
| `NC_EBADDIM` | -46 | Invalid dimension ID. |
| `NC_ENOTVAR` | -49 | Invalid variable ID. |
| `NC_EEDGE` | -57 | Start plus count exceeds a dimension bound. |
| `NC_ENOTFOUND` | -90 | Object not found. |
| `NC_EBADGRPID` | -116 | Invalid group ID. |
| `NC_ENOGRP` | -125 | Group not found. |
