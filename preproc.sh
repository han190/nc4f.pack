#!/usr/bin/env bash

PREPROC_DIR="fypp"
SRC_DIR="src"

COMPONENTS=(
  arithmetic
  extract
  variable_constructor
  attribute_constructor
)

for name in "${COMPONENTS[@]}"; do
  infile="$PREPROC_DIR/interface_${name}.fypp"
  outfile="$SRC_DIR/interface_${name}.inc"
  echo "$infile -> $outfile"
  fypp $infile > $outfile

  infile="$PREPROC_DIR/submodule_${name}.fypp"
  outfile="$SRC_DIR/submodule_${name}.f90"
  echo "$infile -> $outfile"
  fypp $infile > $outfile
done

exit 0