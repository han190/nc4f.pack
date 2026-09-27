# Exposed NC Constants

`NC4F` re-exports the following NetCDF C status constants for comparisons with
`error%code`:

| Constant name (Value) | Description |
|:--|:--|
| `NC_NOERR (0)` | No error. |
| `NC_EBADID (-33)` | Invalid NetCDF ID. |
| `NC_EINVAL (-36)` | Invalid argument. |
| `NC_EINVALCOORDS (-40)` | Index exceeds a dimension bound. |
| `NC_ENOTATT (-43)` | Attribute not found. |
| `NC_EBADDIM (-46)` | Invalid dimension ID. |
| `NC_ENOTVAR (-49)` | Invalid variable ID. |
| `NC_EEDGE (-57)` | Start plus count exceeds a dimension bound. |
| `NC_ENOTFOUND (-90)` | Object not found. |
| `NC_EBADGRPID (-116)` | Invalid group ID. |
| `NC_ENOGRP (-125)` | Group not found. |
