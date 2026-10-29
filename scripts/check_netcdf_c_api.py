#!/usr/bin/env python3
"""Audit serial NetCDF coverage, C ABI declarations, constants, and linkability.

Run from any directory with pkg-config, a C compiler, and the baseline NetCDF
headers/library installed. This does not require MPI or execute NetCDF I/O.
"""

import json
import os
from pathlib import Path
import re
import shlex
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "src" / "c_interface"


def pkg_config(*args):
    return subprocess.check_output(["pkg-config", *args, "netcdf"], text=True).strip()


def declarations(text):
    text = re.sub(r"/\*.*?\*/", "", text, flags=re.S)
    pattern = r"\bEXTERNL\s+(int|void|char\s*\*|const\s+char\s*\*)\s*(\w+)\s*\((.*?)\)\s*;"
    return {m[2]: (m[1], m[3]) for m in re.finditer(pattern, text, re.S)}


def main():
    manifest = json.loads((ROOT / "scripts/netcdf_c_api.json").read_text())
    include = Path(pkg_config("--variable=includedir"))
    api = {}
    for header in manifest["headers"]:
        api.update(declarations((include / header).read_text()))
    excluded = {name for group in manifest["exclusion_groups"].values() for name in group}
    expected = set(api) - excluded
    # Catch new unsigned APIs even when their entry points have not yet been
    # added to the explicit exclusion manifest. size_t remains c_size_t.
    unsigned = {name for name, prototype in api.items()
                if re.search(r"\bunsigned\b|\bNC_H5_Filterspec\b", " ".join(prototype))}
    assert unsigned <= set(manifest["exclusion_groups"]["unsigned"]), "Unclassified unsigned API"
    text = "\n".join(p.read_text() for p in sorted(SOURCE.glob("nc4f_c_interface*")))
    bound = {}
    pattern = r"^[ \t]*(function|subroutine) (\w+)\((.*?)\)(.*?)^[ \t]*end \1 \2"
    for match in re.finditer(pattern, text, re.M | re.S | re.I):
        kind, name, args, body = match.groups()
        binding = re.search(r'bind\(c,\s*name="(\w+)"\)', body, re.I)
        assert binding, name
        assert name not in bound, f"Duplicate Fortran procedure: {name}"
        bound[name] = binding[1]
        if name not in expected:
            continue
        prototype = api[name]
        assert binding[1] == manifest["aliases"].get(name, name), name
        result, cargs = prototype
        fargs = [a.strip() for a in args.split(",") if a.strip()]
        cargs = [a.strip() for a in cargs.split(",") if a.strip() not in ("void", "")]
        assert len(fargs) == len(cargs), (name, fargs, cargs)
        for arg, carg in zip(fargs, cargs):
            declaration = re.search(
                r"^\s*(integer\(c_\w+\)|real\(c_\w+\)|type\(c_ptr\)|character\(kind=c_char\))"
                r"([^\n]*?)::\s*" + arg + r"(\(\*\))?\s*$", body, re.M | re.I
            )
            assert declaration, (name, arg)
            ftype, attrs, array = declaration.groups()
            depth = carg.count("*") + ("[]" in carg)
            if ftype == "type(c_ptr)":
                assert depth >= (1 if "value" in attrs else 2), (name, arg, carg)
            elif ftype.startswith("character"):
                assert "char" in carg, (name, arg, carg)
                assert ("value" in attrs) == (depth == 0), (name, arg, carg)
                assert depth == 0 or array, (name, arg, carg)
            else:
                compatible = {
                    "integer(c_int)": ["int", "nc_type"], "integer(c_size_t)": ["size_t"],
                    "integer(c_long)": ["long"], "integer(c_long_long)": ["long long"],
                    "integer(c_int64_t)": ["int64_t"], "real(c_float)": ["float"],
                    "real(c_double)": ["double"],
                }[ftype]
                ctype = re.sub(r"\bconst\b", "", carg.split("*")[0]).strip()
                if depth == 0 and ctype not in compatible:
                    ctype = ctype.rsplit(" ", 1)[0]
                assert ctype in compatible, (name, arg, carg, ftype)
                assert ("value" in attrs) == (depth == 0), (name, arg, carg)
        assert (kind == "subroutine") == (result == "void"), name
        if result != "void":
            expected_result = "type(c_ptr)" if "*" in result else "integer(c_int)"
            assert expected_result + " :: " + name in body, name
    missing = sorted(expected - set(bound))
    assert not missing, f"Missing serial APIs: {missing}"
    assert not excluded & set(bound), "Excluded API was added"
    assert not any(symbol.startswith("nc4f_") for symbol in bound.values()), "C bridge binding remains"

    csource = [f'#include <{header}>' for header in manifest["headers"]]
    constants = re.findall(r"^integer\(c_int\), parameter :: (\w+) = (.*)$", text, re.M)
    for name, value in constants:
        value = re.sub(r"int\(z'([\da-fA-F]+)', kind=c_int\)", lambda m: "0x" + m[1], value)
        value = value.replace("_c_int", "")
        csource.append(f'_Static_assert({name} == ({value}), "{name}");')
    # Volatile storage retains relocations for every function, including ones
    # not exercised by the representative runtime tests.
    csource += ["static void (*volatile symbols[])(void) = {"]
    csource += [f"    (void (*)(void)){bound[name]}," for name in sorted(expected)]
    csource += ["};", "int main(void) { return symbols[0] == 0; }"]
    with tempfile.TemporaryDirectory(prefix="nc4f-api-") as directory:
        probe = Path(directory) / "audit.c"
        executable = Path(directory) / "audit"
        probe.write_text("\n".join(csource) + "\n")
        command = shlex.split(os.environ.get("CC", "cc")) + [
            "-std=c11", "-Wall", "-Wextra", "-Werror",
            *shlex.split(pkg_config("--cflags")), str(probe),
            *shlex.split(pkg_config("--libs")), "-o", str(executable),
        ]
        subprocess.run(command, check=True)
        subprocess.run([str(executable)], check=True)
    serial = set(api) - set(manifest["exclusion_groups"]["parallel"])
    print(f"NetCDF {pkg_config('--modversion')}: {len(expected)}/{len(serial)} serial API declarations covered "
          f"({len(expected) / len(serial):.1%}); all retained declarations passed.")
    print(f"ABI checks, {len(constants)} integer constants, and all linked entry points passed.")
    print("No C adapters; unsigned, parallel, and adapter-dependent APIs are explicitly excluded.")


if __name__ == "__main__":
    main()
