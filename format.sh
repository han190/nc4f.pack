#!/usr/bin/env bash

# Usage: ./fix-format.sh /path/to/project
set -euo pipefail

ROOT="${1:-.}"

# If `fprettify` or `perl` exist, detect once and reuse the result

for cmd in fprettify perl; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "$cmd not found."
    exit 1
  fi
done

echo "Format source codes through fprettify..."
patterns=( -name "*.inc" -o -name "*.f90" -o -name "*.fypp" )
find "$ROOT" -type f \( "${patterns[@]}" \) -print0 | while IFS= read -r -d '' f; do
  fprettify --indent=2 --disable-indent-mod \
    --strict-indent "$f"
done

# 1) implicit none(type, external) -> implicit none (type, external)
# 2) write (formatted) -> write(formatted)
# 3) ( .and. ) -> (.and.)
# 4) Indent lines starting with "module procedure :: write_frmt_*" by 2 spaces

echo "Polish source codes using perl..."
patterns=( -name "*.f90" -o -name "*.fypp" )
find "$ROOT" -type f \( -name "*.f90" -o -name "*.fypp" \) -print0 | \
  while IFS= read -r -d '' f; do
  perl -i -pe '
    s/implicit none\(type, external\)/implicit none (type, external)/g;
    s/write \(formatted\)/write(formatted)/g;
    s/\( \.and\. \)/(\.and\.)/g;
    s/module procedure :: write_frmt_/  module procedure :: write_frmt_/g;
    s/\$\s*\(/\$\(/g;
    s/xp \$\{O\}\$yp/xp \$\{O\}\$ yp/g;
    s/xp \$\{O\}\$y/xp \$\{O\}\$ y/g;
    s/x \$\{O\}\$yp/x \$\{O\}\$ yp/g;
  ' "$f"
done

echo "Format finished."