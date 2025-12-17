#!/usr/bin/env bash

# Usage: ./fix-format.sh /path/to/project
set -euo pipefail

ROOT="${1:-.}"

# If fprettify exists, run it over *.inc, *.f90, *.fypp
if command -v fprettify >/dev/null 2>&1; then
  echo "fprettify detected. Formatting sources..."
  find "$ROOT" -type f \( -name "*.inc" -o -name "*.f90" -o -name "*.fypp" \) -print0 | while IFS= read -r -d '' f; do
    fprettify --indent=2 \
      --disable-indent-mod \
      --strict-indent \
      "$f"
  done
else
  echo "fprettify not found. Skipping formatting step."
fi

# 1) implicit none(type, external) -> implicit none (type, external)
# 2) write (formatted) -> write(formatted)
# 3) ( .and. ) -> (.and.)
# 4) Indent lines starting with "module procedure :: write_frmt_*" by 2 spaces

find "$ROOT" -type f \( -name "*.f90" -o -name "*.fypp" \) -print0 | while IFS= read -r -d '' f; do
  sed -i'' \
    -e 's/implicit none(type, external)/implicit none (type, external)/g' \
    -e 's/write (formatted)/write(formatted)/g' \
    -e 's/( \.and\. )/(\.and\.)/g' \
    -e 's/module procedure :: write_frmt_/  module procedure :: write_frmt_/g' \
    -e 's/$ (/$(/g' \
    -e 's/xp ${O}$yp/xp ${O}$ yp/g' \
    -e 's/xp ${O}$y/xp ${O}$ y/g' \
    -e 's/x ${O}$yp/x ${O}$ yp/g' \
    "$f"
done

echo "Format finished."