# Error Handling

Most operational APIs accept an optional `error` argument. When it is present,
an operation returns normally and places failure status and text in an
`error_type`; otherwise the library uses its fail-fast policy.

`.exists. error` is true exactly when `error%code /= NC_NOERR`.

```fortran
type(error_type) :: error

nc = open_dataset("missing.nc", "r", error=error)
if (.exists. error) then
  print '(a)', error%msg
  error stop "NetCDF operation failed"
end if
```

See [Constants](constants.md) for the re-exported NetCDF status codes.
