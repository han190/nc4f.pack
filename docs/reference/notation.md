# Notation and Formatted Output

## `.dim.` and `.and.`

Create dimensions concisely. A length may be paired with an unlimited flag.

```fortran
type(dimension_type) :: time, latitude
time = "time".dim.(24 .and. .true.)
latitude = "lat".dim.181
```

## `.att.`

Creates an `attribute_type` from a name and scalar or vector value. Supported
numeric kinds are `int8`, `int16`, `int32`, `int64`, `real32`, and `real64`.

```fortran
units = "units".att."K"
valid_range = "valid_range".att.[180.0, 330.0]
```

## `==` and `/=`

Elemental comparisons are defined for dimensions, attributes, and variables.
They compare metadata and represented values.

## Formatted output

Formatted derived-type I/O is defined for dimensions, attributes, variables,
groups, and errors. Groups render recursively in an ncdump-like order.

```fortran
write (*, *) grp
```
