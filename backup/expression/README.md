# Archived expression layer

This directory preserves the deferred arithmetic implementation, its fypp
templates and generated interfaces, dedicated tests, benchmark, and example.
It is excluded from the active fpm, Make, and CMake builds while NC4F focuses
on its in-memory NetCDF model and I/O.

The expression-related declarations were removed from `src/nc4f_data.f90`
and `src/nc4f.f90`. Restoring these files alone is insufficient; restore the
matching parent-module interfaces, build entries, and test-suite entries from
Git history when revisiting this feature.
