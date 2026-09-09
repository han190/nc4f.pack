# Contributing

Use a feature branch and include a focused test for each behavioral change.

Before opening a pull request, regenerate source after changing `fypp/` templates,
then run:

```sh
fpm test --profile debug --flag "$(pkg-config --cflags --libs netcdf)"
fortitude check
```

Generated `.f90` and `.inc` files in `src/` are committed alongside their Fypp
templates. Keep each pair in sync.
