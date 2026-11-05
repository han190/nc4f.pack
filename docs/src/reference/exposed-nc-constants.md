# Exposed NC Constants

`NC4F` re-exports the following NetCDF C status constants for comparisons with
`error%code`:

| Constant name (Value) | Description |
|:--|:--|
| `NC_NOERR (0)` | No error. |
| `NC_EBADID (-33)` | Invalid NetCDF ID. |
| `NC_EPERM (-37)` | Read-only dataset or denied write access. |
| `NC_EBADTYPE (-45)` | Unsupported or invalid NetCDF type. |
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

## Variable types

`DEFINE_VARIABLE` accepts these type constants exported by `nc4f`:

| Constant | Data representation |
|:--|:--|
| `NC_BYTE` | Signed 8-bit integer |
| `NC_CHAR` | Character bytes (not NetCDF `STRING`) |
| `NC_SHORT` | Signed 16-bit integer |
| `NC_INT` | Signed 32-bit integer |
| `NC_INT64` | Signed 64-bit integer |
| `NC_FLOAT` | 32-bit floating point |
| `NC_DOUBLE` | 64-bit floating point |

The source `variable_type` passed to `PUT_VARIABLE` must have the same type as
its destination. Other C constants remain available from `nc4f_c_interface`.

## Endianness

`SET_STORAGE` accepts `NC_ENDIAN_NATIVE`, `NC_ENDIAN_LITTLE`, and
`NC_ENDIAN_BIG`, all exported by `nc4f`.
