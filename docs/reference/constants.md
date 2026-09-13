# Constants

`nc4f` re-exports the following NetCDF C status constants for comparisons with
`error%code`:

`NC_NOERR`, `NC_EBADID`, `NC_EBADDIM`, `NC_EBADGRPID`, `NC_EEDGE`,
`NC_EINVAL`, `NC_EINVALCOORDS`, `NC_ENOGRP`, `NC_ENOTATT`, `NC_ENOTFOUND`,
and `NC_ENOTVAR`.

```fortran
if (error%code == NC_ENOTVAR) print *, "Variable does not exist."
if (error%code == NC_NOERR) print *, "Operation succeeded."
```
