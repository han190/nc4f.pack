# Data Construction and Access

## `datarray(name, values, dims [, atts] [, deep])`

Constructs a `variable_type` from a rank 1–15 Fortran array. Supported values
are `integer(int8)`, `integer(int16)`, `integer(int32)`, `integer(int64)`,
`real(real32)`, `real(real64)`, and `character`.

`deep` defaults to `.true.`. Numeric `deep=.false.` borrows a contiguous
`target` array, which must outlive the returned variable. Character input is
always copied.

## `dataset`

Builds a `group_type` from a name and optional variables, child groups,
attributes, and copy policy:

```fortran
grp = dataset(name [, atts] [, deep])
grp = dataset(name, vars [, atts] [, deep])
grp = dataset(name, grps [, atts] [, deep])
grp = dataset(name, vars, grps [, atts] [, deep])
```

`deep` defaults to `.false.`. A deep dataset recursively clones buffers and
descendants; a shallow one shares them.

## `extract(source, pointer)`

Maps an attribute or materialized variable byte buffer to a correctly typed
Fortran pointer. The pointer aliases the source buffer; do not deallocate it,
and do not retain it after the source buffer is released.

## `initialize`

Initializes metadata and owned storage for an existing attribute or variable.
The mold forms create storage compatible with an existing object.

```fortran
call initialize(att, name, dtype, len)
call initialize(att, mold)
call initialize(var, name, dtype, len, dims [, atts] [, deep])
call initialize(var, mold)
```

## `shape`, `size`, and `sum`

`shape(var)` returns Fortran-order extents. `size(var [, dim])` returns an
`integer(int64)` element count or one-based dimension length. `sum(vars)`
returns the element-wise sum of compatible materialized variables.
