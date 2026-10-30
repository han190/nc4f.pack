# Exposed NC Constants

`NC4F` re-exports the following NetCDF C status constants for comparisons with
`error%code`:

| Constant name (Value) | Description |
|:--|:--|
| `NC_NOERR (0)` | No error. |
| `NC_EBADID (-33)` | Invalid NetCDF ID. |
| `NC_EINVAL (-36)` | Invalid argument. |
| `NC_EINVALCOORDS (-40)` | Index exceeds a dimension bound. |
| `NC_ENAMEINUSE (-42)` | Name already in use in the target collection. |
| `NC_ENOTATT (-43)` | Attribute not found. |
| `NC_EBADDIM (-46)` | Invalid dimension ID. |
| `NC_ENOTVAR (-49)` | Variable not found or invalid variable ID. |
| `NC_EMAXNAME (-53)` | Name exceeds the NetCDF name-length limit. |
| `NC_EEDGE (-57)` | Start plus count exceeds a dimension bound. |
| `NC_EBADNAME (-59)` | Invalid NetCDF name. |
| `NC_ENOTFOUND (-90)` | Object not found. |
| `NC_EBADGRPID (-116)` | Invalid group ID, or an attempt to rename a known root group. |
| `NC_ENOGRP (-125)` | Group not found. |
