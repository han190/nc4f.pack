#!/usr/bin/env bash
# Download the externally maintained NetCDF fixtures used by integration tests.
# Files are intentionally not tracked in Git; their SHA-256 hashes make each
# test run reproducible and detect an upstream replacement.

set -euo pipefail

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
data_dir=$(dirname -- "$script_dir")/data

download() {
  local url=$1
  local filename=$2
  local expected_sha256=$3
  local destination=$data_dir/$filename
  local temporary=$destination.download
  local actual_sha256

  if [[ -f $destination ]]; then
    actual_sha256=$(shasum -a 256 "$destination" | awk '{print $1}')
    if [[ $actual_sha256 == "$expected_sha256" ]]; then
      printf '[data] verified %s\n' "$filename"
      return
    fi
    printf '[data] replacing %s with an expected version\n' "$filename"
  else
    printf '[data] downloading %s\n' "$filename"
  fi

  rm -f "$temporary"
  curl --fail --location --retry 3 --output "$temporary" "$url"
  actual_sha256=$(shasum -a 256 "$temporary" | awk '{print $1}')
  if [[ $actual_sha256 != "$expected_sha256" ]]; then
    printf '[data] checksum mismatch for %s\n' "$filename" >&2
    rm -f "$temporary"
    exit 1
  fi
  mv "$temporary" "$destination"
  printf '[data] verified %s\n' "$filename"
}

mkdir -p "$data_dir"

download \
  'https://atmosphere-imager.gsfc.nasa.gov/sites/default/files/ModAtmo/CLDPROPCOSP_M3_MODIS_Aqua.A2014032.011.2020112203433.nc' \
  'CLDPROPCOSP_M3_MODIS_Aqua.A2014032.011.2020112203433.nc' \
  'd0642ea96b4c5753ebc26f027c390f2964f700cde6084d658f6ce944d510ddf5'
download \
  'https://archive.unidata.ucar.edu/software/netcdf/examples/ECMWF_ERA-40_subset.nc' \
  'ECMWF_ERA-40_subset.nc' \
  'f5d5bb82811e74179894a87e439acbb952eb692181570b97bcfbc9f61aa18890'
