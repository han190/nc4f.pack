# Create a Small Dataset

Construct an unlimited dimension, attributes, and a variable in memory, then
combine them into a root group and serialize it. The named `vars` array makes
the lifetime of the shallowly retained variable explicit.

```fortran
program create_dataset
  use, non_intrinsic :: nc4f
  implicit none (type, external)

  type(variable_type) :: vars(1)
  type(group_type) :: root
  real :: values(3) = [1.0, 2.0, 3.0]

  vars(1) = datarray("temperature", values, ["time".dim.(3 .and. .true.)], &
    & atts=["units".att."K"])
  root = dataset("/", vars, atts=["title".att."Example dataset"])
  call to_netcdf("example.nc", root)
end program create_dataset
```
