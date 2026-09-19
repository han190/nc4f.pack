# Error Handling

Most operational APIs accept an optional `err` argument. When it is present,
an operation returns normally and places failure status and text in an
`error_type`; otherwise the library uses its fail-fast policy.

`.exists. err` is true exactly when `err%code /= NC_NOERR`.

```fortran
type(error_type) :: err

nc = open_netcdf("missing.nc", "r", err=err)
if (.exists. err) then
  print '(a)', err%message
  error stop "NetCDF operation failed"
end if
```

See [Constants](constants.md) for the re-exported NetCDF status codes.
