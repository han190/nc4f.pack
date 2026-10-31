# Procedure dependency forest and purity audit

Audit date: 2026-10-30. This is a snapshot of the Fortran sources, including the
uncommitted attribute/variable/group renaming work.

## Scope and method

The inventory contains **815 procedure entries**: **441 Fortran implementations**,
**371 C binding declarations**, and **3 interface-only declarations**. It covers
`src/`, `test/`, and `example/`, including every generated rank/kind specialization
and the `.inc` interfaces. Matching module declarations and implementations count
once. Fypp templates are represented by their generated procedures. Main programs
and compiler-generated support routines are not functions/subroutines and are not
counted. Calls made by main programs do not create additional forest nodes.

Calls were extracted from gfortran's `-fsyntax-only -fdump-fortran-original` output
after building the modules. This resolves generic overloads and defined operators
to their specific procedures. The test runner's registered procedure-pointer targets
and defined formatted-I/O calls were added by inspecting the source and compiler
TRANSFER operands. Ordinary intrinsic calls are omitted from the forest; relevant
intrinsic restrictions are recorded as reasons below. C implementations are outside
this repository and are terminal boundaries, not presumed side-effect-free.

Traversal follows each root through its dependencies. Purity requires both an
eligible body and pure callees, so eligibility is propagated back from the leaves;
recursive components are reviewed together. The actual dependency structure is a
graph: the forest below expands each entry once, marks shared references, and marks
back edges as cycles. Unused procedures are included as independent roots.

## Standard and changes

An `elemental` function **or subroutine** is pure unless explicitly declared
`impure elemental`. Thus `pure elemental` is redundant, but removing `impure`
would change the procedure's contract. See the public
[Fortran 2023 working draft, sections 15.7 and 15.9.1](https://j3-fortran.org/doc/year/23/23-007r1.pdf).
The same elemental default applies in Fortran 2018. This change introduces no
Fortran 2023-only purity features.

The initial purity audit added `pure` to these five existing implementations:

| Procedure | Reason it qualifies |
| --- | --- |
| `new_att_character` | Calls pure `init_att`; writes only its result buffer. Both Fypp declaration and implementation were updated. |
| `collect_dims_` | Reads variable metadata and builds local/result arrays; error termination is permitted. |
| `render_dims` | Calls pure `append` and `render_dim`; builds text in local storage. |
| `extensive_attributes` | Test fixture uses pure attribute constructors, including the newly pure character constructor. |
| `chk_rename` | Test assertion reads its inputs and uses only `ERROR STOP` on failure. |

Removed redundant `pure` from `eq_att`, `neq_att`, and `has_err`, in both their
module declarations and implementations. All remain pure by virtue of `elemental`.
The existing `impure elemental` procedures retain that attribute.

Group renaming subsequently added the pure model procedures `rename_grp_grp`,
`rename_grp_par`, and `rename_grps_`, plus pure test helpers `rename_grp_pure` and
`chk_grp`. The three file-layer helpers remain impure through their NetCDF calls.
The pure parent overload updates an `intent(inout)` child tree; shared pointer
aliases observe the mutation, which does not prevent that subroutine from being pure.

There are now **78 pure Fortran implementations**, including implicit elemental
purity. The other **363 implementations** retain their existing impure interfaces.
The initial purity-only changes did not alter algorithms, pointer ownership,
error behavior, or public generic signatures. The subsequent group-renaming work
adds the four documented `rename_group` overloads. The existing `c_strlen` binding remains declared pure; the other 370 C
bindings retain their existing impure interfaces. An external binding's lack of a
local implementation is not evidence that it can safely be declared pure.

## Reasons for retaining impurity

These are restrictions on the current implementations, not claims that the
algorithms could never be rewritten to be pure.

| Tag | Restriction |
| --- | --- |
| `DEP` | Calls another impure procedure; follow the children to the blocking leaf. |
| `EXT` | External C implementation has no audited purity contract here; bindings include file, library-state, allocation, output-pointer, and diagnostic operations. |
| `ADDR` | `C_LOC` is applied to an `intent(in)` dummy or its component. |
| `ALIAS` | Pointer assignment targets an `intent(in)` dummy's storage, even when the resulting pointer is only used for reading. |
| `PTRARG` | An `intent(in)` object's pointer component is passed to a pointer dummy. |
| `COPY` | Intrinsic assignment copies a derived value with pointer components from `intent(in)` input. |
| `C_PTR` | Calls the impure `C_F_POINTER` intrinsic module subroutine. |
| `IO` | External-unit I/O or `PRINT`. Internal character-file formatting can be pure. |
| `ENV` | Calls environment/process intrinsics such as `execute_command_line` or `get_command_argument`. |
| `STOP` | Normal `STOP` is forbidden in a pure procedure. `ERROR STOP` is allowed under Fortran 2018. |
| `CALLBACK` | The callback interface accepts impure tests. |

In particular, `clone_att`/`clone_var` cannot merely lose `impure`: their calls to
`clone_` pass `src%ptr` to a pointer dummy. A separate temporary compiler probe
confirmed rejection. Their callers therefore also remain impure. Similarly,
`init_var_` copies pointer-bearing attributes and keeps both numeric and character
variable constructors impure. `render_att_value` creates a local pointer alias to
input storage, which blocks the enclosing attribute/group renderers; `render_dims`
has no such operation and can be pure independently.

The private `nc4f_nc::eq_att` and `nc4f_nc::neq_att` declarations have no corresponding
implementations in that module. They are retained and listed separately from the
implemented `nc4f_ds` procedures. The third interface-only entry is the test
callback signature `test_proc`.

## Error termination under optimization

`handle_err` remains pure, but is a subroutine invoked with `CALL`. Its former
logical-function form was used in a final conditional whose two paths both
returned. Gfortran's release optimization removed that function reference,
allowing file errors to return normally when `ERR` was omitted. Explicit
subroutine calls preserve the intended error termination without relying on
an otherwise unused function result. All file-layer wrappers use this form.

## Validation

- All 41 tests pass with gfortran and Flang.
- Both compilers check the new purity declarations and their call sites.
- Existing pure rename callers continue to compile; the newly pure
  `extensive_attributes` fixture also checks character-constructor purity through
  the public `.att.` operator.
- Every implemented procedure was inventoried; every remaining impure implementation
  has a local restriction or a dependency path to an impure boundary.

## Forest

`P` means explicitly pure; `E` means implicitly pure elemental; `I` means impure;
`X` means a C binding boundary; `D` means an interface-only declaration.
Each expanded node includes its source location. `=> shared` refers to an entry
expanded elsewhere; `=> cycle` is a recursive back edge. Tags describe local
restrictions; `DEP` means the restriction is in a dependency. Intrinsic-only leaves
can still have local restrictions such as `ALIAS`, `ADDR`, or `STOP`.

### Source inventory

| Source | Entries | Pure contracts |
| --- | ---: | ---: |
| [example/mandelbrot.f90](../example/mandelbrot.f90) | 2 | 2 |
| [src/c_interface/nc4f_c_interface.f90](../src/c_interface/nc4f_c_interface.f90) | 4 | 1 |
| [src/c_interface/nc4f_c_interface_attribute.inc](../src/c_interface/nc4f_c_interface_attribute.inc) | 36 | 0 |
| [src/c_interface/nc4f_c_interface_dataset.inc](../src/c_interface/nc4f_c_interface_dataset.inc) | 110 | 0 |
| [src/c_interface/nc4f_c_interface_dimension.inc](../src/c_interface/nc4f_c_interface_dimension.inc) | 13 | 0 |
| [src/c_interface/nc4f_c_interface_group.inc](../src/c_interface/nc4f_c_interface_group.inc) | 10 | 0 |
| [src/c_interface/nc4f_c_interface_io.inc](../src/c_interface/nc4f_c_interface_io.inc) | 127 | 0 |
| [src/c_interface/nc4f_c_interface_variable.inc](../src/c_interface/nc4f_c_interface_variable.inc) | 71 | 0 |
| [src/data_structure/nc4f_ds_access.f90](../src/data_structure/nc4f_ds_access.f90) | 6 | 3 |
| [src/data_structure/nc4f_ds_arithmetic.f90](../src/data_structure/nc4f_ds_arithmetic.f90) | 1 | 0 |
| [src/data_structure/nc4f_ds_attribute.f90](../src/data_structure/nc4f_ds_attribute.f90) | 7 | 6 |
| [src/data_structure/nc4f_ds_attribute_constructor.f90](../src/data_structure/nc4f_ds_attribute_constructor.f90) | 13 | 13 |
| [src/data_structure/nc4f_ds_clone.f90](../src/data_structure/nc4f_ds_clone.f90) | 5 | 1 |
| [src/data_structure/nc4f_ds_dimension.f90](../src/data_structure/nc4f_ds_dimension.f90) | 7 | 7 |
| [src/data_structure/nc4f_ds_extract.f90](../src/data_structure/nc4f_ds_extract.f90) | 120 | 1 |
| [src/data_structure/nc4f_ds_group.f90](../src/data_structure/nc4f_ds_group.f90) | 14 | 7 |
| [src/data_structure/nc4f_ds_io.f90](../src/data_structure/nc4f_ds_io.f90) | 27 | 13 |
| [src/data_structure/nc4f_ds_utility.f90](../src/data_structure/nc4f_ds_utility.f90) | 2 | 2 |
| [src/data_structure/nc4f_ds_variable.f90](../src/data_structure/nc4f_ds_variable.f90) | 8 | 7 |
| [src/data_structure/nc4f_ds_variable_constructor.f90](../src/data_structure/nc4f_ds_variable_constructor.f90) | 105 | 0 |
| [src/netcdf/nc4f_nc.f90](../src/netcdf/nc4f_nc.f90) | 2 | 2 |
| [src/netcdf/nc4f_nc_attribute.f90](../src/netcdf/nc4f_nc_attribute.f90) | 12 | 0 |
| [src/netcdf/nc4f_nc_dataset.f90](../src/netcdf/nc4f_nc_dataset.f90) | 6 | 0 |
| [src/netcdf/nc4f_nc_dimension.f90](../src/netcdf/nc4f_nc_dimension.f90) | 4 | 0 |
| [src/netcdf/nc4f_nc_error.f90](../src/netcdf/nc4f_nc_error.f90) | 4 | 2 |
| [src/netcdf/nc4f_nc_group.f90](../src/netcdf/nc4f_nc_group.f90) | 16 | 1 |
| [src/netcdf/nc4f_nc_utility.f90](../src/netcdf/nc4f_nc_utility.f90) | 5 | 5 |
| [src/netcdf/nc4f_nc_variable.f90](../src/netcdf/nc4f_nc_variable.f90) | 11 | 0 |
| [test/nc4f_test.f90](../test/nc4f_test.f90) | 8 | 0 |
| [test/nc4f_test_c_bindings.f90](../test/nc4f_test_c_bindings.f90) | 8 | 0 |
| [test/nc4f_test_cases_basic.f90](../test/nc4f_test_cases_basic.f90) | 6 | 0 |
| [test/nc4f_test_cases_copy.f90](../test/nc4f_test_cases_copy.f90) | 4 | 0 |
| [test/nc4f_test_cases_data.f90](../test/nc4f_test_cases_data.f90) | 17 | 3 |
| [test/nc4f_test_cases_errors.f90](../test/nc4f_test_cases_errors.f90) | 2 | 0 |
| [test/nc4f_test_cases_group.f90](../test/nc4f_test_cases_group.f90) | 2 | 0 |
| [test/nc4f_test_cases_io.f90](../test/nc4f_test_cases_io.f90) | 2 | 0 |
| [test/nc4f_test_cases_model.f90](../test/nc4f_test_cases_model.f90) | 1 | 0 |
| [test/nc4f_test_cases_rename.f90](../test/nc4f_test_cases_rename.f90) | 9 | 3 |
| [test/nc4f_test_cases_rename_group.f90](../test/nc4f_test_cases_rename_group.f90) | 5 | 2 |
| [test/nc4f_test_module.f90](../test/nc4f_test_module.f90) | 3 | 0 |

### Expanded trees

```text
arange [P] @ example/mandelbrot.f90:50

neq_att [E] @ src/data_structure/nc4f_ds_attribute.f90:153
└── eq_att [E] @ src/data_structure/nc4f_ds_attribute.f90:109
    └── validate_att [P] @ src/data_structure/nc4f_ds_access.f90:6
        └── validate_ [P] @ src/data_structure/nc4f_ds_access.f90:51
            └── buffer_size [P] @ src/data_structure/nc4f_ds_group.f90:324

new_dim_arg_int64 [E] @ src/data_structure/nc4f_ds_dimension.f90:18

new_dim_len_int64 [E] @ src/data_structure/nc4f_ds_dimension.f90:44

neq_dim [E] @ src/data_structure/nc4f_ds_dimension.f90:83
└── eq_dim [E] @ src/data_structure/nc4f_ds_dimension.f90:71

extract_att_int8_vector [I] @ src/data_structure/nc4f_ds_extract.f90:5 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_att [I] @ src/data_structure/nc4f_ds_access.f90:98 | DEP
│   ├── buffer2cptr_ [I] @ src/data_structure/nc4f_ds_access.f90:120 | ADDR: C_LOC receives storage from an INTENT(IN) dummy
│   └── validate_att [P] => shared
└── validate_att [P] => shared

extract_att_int8_scalar [I] @ src/data_structure/nc4f_ds_extract.f90:23 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_att [I] => shared
└── validate_att [P] => shared

extract_att_int16_vector [I] @ src/data_structure/nc4f_ds_extract.f90:39 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_att [I] => shared
└── validate_att [P] => shared

extract_att_int16_scalar [I] @ src/data_structure/nc4f_ds_extract.f90:57 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_att [I] => shared
└── validate_att [P] => shared

extract_att_int32_vector [I] @ src/data_structure/nc4f_ds_extract.f90:73 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_att [I] => shared
└── validate_att [P] => shared

extract_att_int32_scalar [I] @ src/data_structure/nc4f_ds_extract.f90:91 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_att [I] => shared
└── validate_att [P] => shared

extract_att_int64_vector [I] @ src/data_structure/nc4f_ds_extract.f90:107 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_att [I] => shared
└── validate_att [P] => shared

extract_att_int64_scalar [I] @ src/data_structure/nc4f_ds_extract.f90:125 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_att [I] => shared
└── validate_att [P] => shared

extract_att_real32_scalar [I] @ src/data_structure/nc4f_ds_extract.f90:159 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_att [I] => shared
└── validate_att [P] => shared

extract_att_real64_vector [I] @ src/data_structure/nc4f_ds_extract.f90:175 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_att [I] => shared
└── validate_att [P] => shared

extract_att_real64_scalar [I] @ src/data_structure/nc4f_ds_extract.f90:193 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_att [I] => shared
└── validate_att [P] => shared

extract_var_int8_2d [I] @ src/data_structure/nc4f_ds_extract.f90:266 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] @ src/data_structure/nc4f_ds_access.f90:109 | DEP
│   ├── buffer2cptr_ [I] => shared
│   └── validate_var [P] @ src/data_structure/nc4f_ds_access.f90:22
│       ├── get_size [P] @ src/data_structure/nc4f_ds_variable.f90:104
│       └── validate_ [P] => shared
├── get_shape [P] @ src/data_structure/nc4f_ds_variable.f90:140
└── validate_var [P] => shared

extract_var_int8_3d [I] @ src/data_structure/nc4f_ds_extract.f90:285 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int8_4d [I] @ src/data_structure/nc4f_ds_extract.f90:304 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int8_5d [I] @ src/data_structure/nc4f_ds_extract.f90:323 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int8_6d [I] @ src/data_structure/nc4f_ds_extract.f90:342 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int8_7d [I] @ src/data_structure/nc4f_ds_extract.f90:361 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int8_8d [I] @ src/data_structure/nc4f_ds_extract.f90:380 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int8_9d [I] @ src/data_structure/nc4f_ds_extract.f90:399 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int8_10d [I] @ src/data_structure/nc4f_ds_extract.f90:418 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int8_11d [I] @ src/data_structure/nc4f_ds_extract.f90:437 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int8_12d [I] @ src/data_structure/nc4f_ds_extract.f90:456 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int8_13d [I] @ src/data_structure/nc4f_ds_extract.f90:475 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int8_14d [I] @ src/data_structure/nc4f_ds_extract.f90:494 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int8_15d [I] @ src/data_structure/nc4f_ds_extract.f90:513 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int16_2d [I] @ src/data_structure/nc4f_ds_extract.f90:551 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int16_4d [I] @ src/data_structure/nc4f_ds_extract.f90:589 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int16_5d [I] @ src/data_structure/nc4f_ds_extract.f90:608 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int16_6d [I] @ src/data_structure/nc4f_ds_extract.f90:627 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int16_7d [I] @ src/data_structure/nc4f_ds_extract.f90:646 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int16_8d [I] @ src/data_structure/nc4f_ds_extract.f90:665 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int16_9d [I] @ src/data_structure/nc4f_ds_extract.f90:684 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int16_10d [I] @ src/data_structure/nc4f_ds_extract.f90:703 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int16_11d [I] @ src/data_structure/nc4f_ds_extract.f90:722 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int16_12d [I] @ src/data_structure/nc4f_ds_extract.f90:741 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int16_13d [I] @ src/data_structure/nc4f_ds_extract.f90:760 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int16_14d [I] @ src/data_structure/nc4f_ds_extract.f90:779 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int16_15d [I] @ src/data_structure/nc4f_ds_extract.f90:798 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int32_3d [I] @ src/data_structure/nc4f_ds_extract.f90:855 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int32_4d [I] @ src/data_structure/nc4f_ds_extract.f90:874 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int32_5d [I] @ src/data_structure/nc4f_ds_extract.f90:893 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int32_6d [I] @ src/data_structure/nc4f_ds_extract.f90:912 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int32_7d [I] @ src/data_structure/nc4f_ds_extract.f90:931 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int32_8d [I] @ src/data_structure/nc4f_ds_extract.f90:950 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int32_9d [I] @ src/data_structure/nc4f_ds_extract.f90:969 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int32_10d [I] @ src/data_structure/nc4f_ds_extract.f90:988 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int32_11d [I] @ src/data_structure/nc4f_ds_extract.f90:1007 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int32_12d [I] @ src/data_structure/nc4f_ds_extract.f90:1026 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int32_13d [I] @ src/data_structure/nc4f_ds_extract.f90:1045 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int32_14d [I] @ src/data_structure/nc4f_ds_extract.f90:1064 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int32_15d [I] @ src/data_structure/nc4f_ds_extract.f90:1083 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int64_2d [I] @ src/data_structure/nc4f_ds_extract.f90:1121 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int64_3d [I] @ src/data_structure/nc4f_ds_extract.f90:1140 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int64_4d [I] @ src/data_structure/nc4f_ds_extract.f90:1159 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int64_5d [I] @ src/data_structure/nc4f_ds_extract.f90:1178 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int64_6d [I] @ src/data_structure/nc4f_ds_extract.f90:1197 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int64_7d [I] @ src/data_structure/nc4f_ds_extract.f90:1216 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int64_8d [I] @ src/data_structure/nc4f_ds_extract.f90:1235 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int64_9d [I] @ src/data_structure/nc4f_ds_extract.f90:1254 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int64_10d [I] @ src/data_structure/nc4f_ds_extract.f90:1273 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int64_11d [I] @ src/data_structure/nc4f_ds_extract.f90:1292 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int64_12d [I] @ src/data_structure/nc4f_ds_extract.f90:1311 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int64_13d [I] @ src/data_structure/nc4f_ds_extract.f90:1330 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int64_14d [I] @ src/data_structure/nc4f_ds_extract.f90:1349 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_int64_15d [I] @ src/data_structure/nc4f_ds_extract.f90:1368 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_real32_4d [I] @ src/data_structure/nc4f_ds_extract.f90:1444 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_real32_5d [I] @ src/data_structure/nc4f_ds_extract.f90:1463 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_real32_6d [I] @ src/data_structure/nc4f_ds_extract.f90:1482 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_real32_7d [I] @ src/data_structure/nc4f_ds_extract.f90:1501 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_real32_8d [I] @ src/data_structure/nc4f_ds_extract.f90:1520 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_real32_9d [I] @ src/data_structure/nc4f_ds_extract.f90:1539 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_real32_10d [I] @ src/data_structure/nc4f_ds_extract.f90:1558 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_real32_11d [I] @ src/data_structure/nc4f_ds_extract.f90:1577 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_real32_12d [I] @ src/data_structure/nc4f_ds_extract.f90:1596 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_real32_13d [I] @ src/data_structure/nc4f_ds_extract.f90:1615 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_real32_14d [I] @ src/data_structure/nc4f_ds_extract.f90:1634 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_real32_15d [I] @ src/data_structure/nc4f_ds_extract.f90:1653 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_real64_3d [I] @ src/data_structure/nc4f_ds_extract.f90:1710 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_real64_5d [I] @ src/data_structure/nc4f_ds_extract.f90:1748 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_real64_6d [I] @ src/data_structure/nc4f_ds_extract.f90:1767 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_real64_7d [I] @ src/data_structure/nc4f_ds_extract.f90:1786 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_real64_8d [I] @ src/data_structure/nc4f_ds_extract.f90:1805 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_real64_9d [I] @ src/data_structure/nc4f_ds_extract.f90:1824 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_real64_10d [I] @ src/data_structure/nc4f_ds_extract.f90:1843 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_real64_11d [I] @ src/data_structure/nc4f_ds_extract.f90:1862 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_real64_12d [I] @ src/data_structure/nc4f_ds_extract.f90:1881 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_real64_13d [I] @ src/data_structure/nc4f_ds_extract.f90:1900 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_real64_14d [I] @ src/data_structure/nc4f_ds_extract.f90:1919 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_real64_15d [I] @ src/data_structure/nc4f_ds_extract.f90:1938 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_char_1d [I] @ src/data_structure/nc4f_ds_extract.f90:1957 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
└── validate_var [P] => shared

extract_var_char_3d [I] @ src/data_structure/nc4f_ds_extract.f90:1995 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_char_4d [I] @ src/data_structure/nc4f_ds_extract.f90:2014 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_char_5d [I] @ src/data_structure/nc4f_ds_extract.f90:2033 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_char_6d [I] @ src/data_structure/nc4f_ds_extract.f90:2052 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_char_7d [I] @ src/data_structure/nc4f_ds_extract.f90:2071 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_char_8d [I] @ src/data_structure/nc4f_ds_extract.f90:2090 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_char_9d [I] @ src/data_structure/nc4f_ds_extract.f90:2109 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_char_10d [I] @ src/data_structure/nc4f_ds_extract.f90:2128 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_char_11d [I] @ src/data_structure/nc4f_ds_extract.f90:2147 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_char_12d [I] @ src/data_structure/nc4f_ds_extract.f90:2166 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_char_13d [I] @ src/data_structure/nc4f_ds_extract.f90:2185 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_char_14d [I] @ src/data_structure/nc4f_ds_extract.f90:2204 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

extract_var_char_15d [I] @ src/data_structure/nc4f_ds_extract.f90:2223 | C_PTR: calls impure C_F_POINTER
├── buffer2cptr_var [I] => shared
├── get_shape [P] => shared
└── validate_var [P] => shared

dtype2kind [P] @ src/data_structure/nc4f_ds_extract.f90:2242

init_var [I] @ src/data_structure/nc4f_ds_group.f90:124 | DEP
└── init_var_ [I] @ src/data_structure/nc4f_ds_group.f90:142 | COPY: intrinsic assignment copies pointer-bearing INTENT(IN) attributes
    ├── buffer_size [P] => shared
    └── get_size [P] => shared

write_frmt_dim [I] @ src/data_structure/nc4f_ds_io.f90:6 | IO: external-unit formatted WRITE

write_frmt_att [I] @ src/data_structure/nc4f_ds_io.f90:36 | IO: external-unit formatted WRITE
├── render_att_value [I] @ src/data_structure/nc4f_ds_io.f90:420 | ALIAS: local bytes pointer targets an INTENT(IN) component
│   ├── render_char_values [P] @ src/data_structure/nc4f_ds_io.f90:484
│   ├── render_int16_values [P] @ src/data_structure/nc4f_ds_io.f90:550
│   ├── render_int32_values [P] @ src/data_structure/nc4f_ds_io.f90:567
│   ├── render_int64_values [P] @ src/data_structure/nc4f_ds_io.f90:584
│   ├── render_int8_values [P] @ src/data_structure/nc4f_ds_io.f90:533
│   ├── render_real32_values [P] @ src/data_structure/nc4f_ds_io.f90:601
│   │   └── trim_trailing_zeros [P] @ src/data_structure/nc4f_ds_io.f90:635
│   ├── render_real64_values [P] @ src/data_structure/nc4f_ds_io.f90:618
│   │   └── trim_trailing_zeros [P] => shared
│   └── validate_att [P] => shared
└── type_name [P] @ src/data_structure/nc4f_ds_io.f90:710

neq_var [E] @ src/data_structure/nc4f_ds_variable.f90:221
└── eq_var [E] @ src/data_structure/nc4f_ds_variable.f90:159
    ├── eq_att [E] => shared
    ├── eq_dim [E] => shared
    └── validate_var [P] => shared

new_var_int8_2d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:40 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int8_3d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:75 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int8_4d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:110 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int8_5d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:145 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int8_6d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:180 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int8_7d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:215 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int8_8d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:250 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int8_9d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:285 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int8_10d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:320 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int8_11d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:355 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int8_12d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:390 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int8_13d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:425 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int8_14d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:460 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int8_15d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:495 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int16_1d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:530 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int16_3d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:600 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int16_4d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:635 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int16_5d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:670 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int16_6d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:705 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int16_7d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:740 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int16_8d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:775 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int16_9d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:810 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int16_10d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:845 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int16_11d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:880 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int16_12d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:915 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int16_13d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:950 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int16_14d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:985 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int16_15d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:1020 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int32_4d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:1160 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int32_5d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:1195 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int32_6d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:1230 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int32_7d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:1265 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int32_8d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:1300 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int32_9d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:1335 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int32_10d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:1370 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int32_11d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:1405 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int32_12d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:1440 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int32_13d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:1475 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int32_14d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:1510 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int32_15d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:1545 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int64_1d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:1580 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int64_2d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:1615 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int64_3d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:1650 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int64_5d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:1720 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int64_6d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:1755 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int64_7d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:1790 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int64_8d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:1825 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int64_9d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:1860 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int64_10d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:1895 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int64_11d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:1930 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int64_12d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:1965 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int64_13d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:2000 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int64_14d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:2035 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_int64_15d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:2070 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_real32_3d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:2175 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_real32_4d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:2210 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_real32_6d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:2280 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_real32_8d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:2350 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_real32_9d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:2385 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_real32_10d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:2420 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_real32_11d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:2455 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_real32_12d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:2490 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_real32_13d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:2525 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_real32_14d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:2560 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_real32_15d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:2595 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_real64_1d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:2630 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_real64_3d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:2700 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_real64_4d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:2735 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_real64_5d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:2770 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_real64_7d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:2840 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_real64_8d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:2875 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_real64_9d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:2910 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_real64_10d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:2945 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_real64_11d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:2980 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_real64_12d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:3015 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_real64_13d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:3050 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_real64_14d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:3085 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_real64_15d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:3120 | C_PTR: calls impure C_F_POINTER
├── buffer_size [P] => shared
└── init_var_ [I] => shared

new_var_char_3d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:3201 | DEP
└── init_var_ [I] => shared

new_var_char_4d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:3224 | DEP
└── init_var_ [I] => shared

new_var_char_5d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:3247 | DEP
└── init_var_ [I] => shared

new_var_char_6d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:3270 | DEP
└── init_var_ [I] => shared

new_var_char_7d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:3293 | DEP
└── init_var_ [I] => shared

new_var_char_8d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:3316 | DEP
└── init_var_ [I] => shared

new_var_char_9d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:3339 | DEP
└── init_var_ [I] => shared

new_var_char_10d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:3362 | DEP
└── init_var_ [I] => shared

new_var_char_11d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:3385 | DEP
└── init_var_ [I] => shared

new_var_char_12d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:3408 | DEP
└── init_var_ [I] => shared

new_var_char_13d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:3431 | DEP
└── init_var_ [I] => shared

new_var_char_14d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:3454 | DEP
└── init_var_ [I] => shared

new_var_char_15d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:3477 | DEP
└── init_var_ [I] => shared

nc4f_nc::eq_att [D,E] @ src/netcdf/nc4f_nc.f90:201 | DECL: interface only; no local implementation

nc4f_nc::neq_att [D,E] @ src/netcdf/nc4f_nc.f90:209 | DECL: interface only; no local implementation

invalid_model_grp_rename [I] @ test/nc4f_test.f90:81 | STOP: normal STOP statement
└── rename_grp_grp [P] @ src/data_structure/nc4f_ds_group.f90:6
    ├── chk_nc_name [P] @ src/data_structure/nc4f_ds_utility.f90:6
    └── return_err [P] @ src/data_structure/nc4f_ds_utility.f90:67

invalid_file_grp_rename [I] @ test/nc4f_test.f90:87 | STOP: normal STOP statement
└── rename_grp_nc_par [I] @ src/netcdf/nc4f_nc_group.f90:40 | DEP
    ├── handle_err [P] @ src/netcdf/nc4f_nc_error.f90:13
    │   └── has_err [E] @ src/netcdf/nc4f_nc_error.f90:5
    ├── has_err [E] => shared
    ├── rename_grp_nc_ [I] @ src/netcdf/nc4f_nc_group.f90:85 | DEP
    │   ├── f2cstr [P] @ src/netcdf/nc4f_nc_utility.f90:54
    │   ├── has_err [E] => shared
    │   ├── nc_inq_ncid [X,I] @ src/c_interface/nc4f_c_interface_group.inc:24 | EXT: external C implementation; no audited PURE contract
    │   ├── nc_rename_grp [X,I] @ src/c_interface/nc4f_c_interface_group.inc:135 | EXT: external C implementation; no audited PURE contract
    │   ├── netcdf_err [I] @ src/netcdf/nc4f_nc_error.f90:28 | DEP
    │   │   └── netcdf_msg [I] @ src/netcdf/nc4f_nc_error.f90:48 | C_PTR: calls impure C_F_POINTER
    │   │       ├── c_strlen [X,P] @ src/c_interface/nc4f_c_interface.f90:472 | EXT-PURE: existing strlen purity contract
    │   │       ├── clip [P] @ src/netcdf/nc4f_nc_utility.f90:29
    │   │       └── nc_strerror [X,I] @ src/c_interface/nc4f_c_interface.f90:481 | EXT: external C implementation; no audited PURE contract
    │   └── rename_grp_grp [P] => shared
    └── rename_grp_par [P] @ src/data_structure/nc4f_ds_group.f90:32
        ├── chk_nc_name [P] => shared
        ├── rename_grps_ [P] @ src/data_structure/nc4f_ds_group.f90:51
        │   └── rename_grp_grp [P] => shared
        └── return_err [P] => shared

invalid_model_var_rename [I] @ test/nc4f_test.f90:93 | STOP: normal STOP statement
└── rename_var_var [P] @ src/data_structure/nc4f_ds_variable.f90:6
    ├── chk_nc_name [P] => shared
    └── return_err [P] => shared

invalid_file_var_rename [I] @ test/nc4f_test.f90:100 | STOP: normal STOP statement
└── rename_var_nc_grp [I] @ src/netcdf/nc4f_nc_variable.f90:36 | DEP
    ├── handle_err [P] => shared
    ├── has_err [E] => shared
    ├── rename_var_grp [P] @ src/data_structure/nc4f_ds_variable.f90:21
    │   ├── rename_vars_ [P] @ src/data_structure/nc4f_ds_variable.f90:31
    │   │   ├── chk_nc_name [P] => shared
    │   │   └── rename_var_var [P] => shared
    │   └── return_err [P] => shared
    └── rename_var_nc_ [I] @ src/netcdf/nc4f_nc_variable.f90:79 | DEP
        ├── f2cstr [P] => shared
        ├── has_err [E] => shared
        ├── nc_inq_varid [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:79 | EXT: external C implementation; no audited PURE contract
        ├── nc_rename_var [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:235 | EXT: external C implementation; no audited PURE contract
        ├── netcdf_err [I] => shared
        └── rename_var_var [P] => shared

invalid_model_rename [I] @ test/nc4f_test.f90:107 | STOP: normal STOP statement
├── new_att_int32_scalar [E] @ src/data_structure/nc4f_ds_attribute_constructor.f90:72
│   └── new_att_int32 [P] @ src/data_structure/nc4f_ds_attribute_constructor.f90:59
│       └── init_att [E] @ src/data_structure/nc4f_ds_group.f90:85
│           └── init_att_ [E] @ src/data_structure/nc4f_ds_group.f90:99
│               └── buffer_size [P] => shared
└── rename_att_att [P] @ src/data_structure/nc4f_ds_attribute.f90:6
    ├── chk_nc_name [P] => shared
    └── return_err [P] => shared

invalid_file_rename [I] @ test/nc4f_test.f90:115 | STOP: normal STOP statement
└── rename_att_nc_grp [I] @ src/netcdf/nc4f_nc_attribute.f90:40 | DEP
    ├── handle_err [P] => shared
    ├── rename_att_grp [P] @ src/data_structure/nc4f_ds_attribute.f90:31
    │   ├── rename_atts_ [P] @ src/data_structure/nc4f_ds_attribute.f90:41
    │   │   ├── chk_nc_name [P] => shared
    │   │   └── rename_att_att [P] => shared
    │   └── return_err [P] => shared
    └── rename_att_nc_ [I] @ src/netcdf/nc4f_nc_attribute.f90:59 | DEP
        ├── f2cstr [P] => shared
        ├── has_err [E] => shared
        ├── nc_inq_attid [X,I] @ src/c_interface/nc4f_c_interface_attribute.inc:134 | EXT: external C implementation; no audited PURE contract
        ├── nc_rename_att [X,I] @ src/c_interface/nc4f_c_interface_attribute.inc:214 | EXT: external C implementation; no audited PURE contract
        ├── netcdf_err [I] => shared
        └── rename_att_grp [P] => shared

invalid_noncontiguous_shallow_constructor [I] @ test/nc4f_test.f90:122 | DEP
├── new_dim_len_int32 [E] @ src/data_structure/nc4f_ds_dimension.f90:31
└── new_var_real32_2d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:2140 | C_PTR: calls impure C_F_POINTER
    ├── buffer_size [P] => shared
    └── init_var_ [I] => shared

invalid_character_shallow_constructor [I] @ test/nc4f_test.f90:133 | DEP
├── new_dim_len_int32 [E] => shared
└── new_var_char_1d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:3155 | DEP
    └── init_var_ [I] => shared

nc4f_test_module::test_proc [D,I] @ test/nc4f_test_module.f90:16 | CALLBACK: interface must accept impure tests

setup_test_results [I] @ test/nc4f_test_module.f90:25 | ENV: process/environment intrinsic

run_tests [I] @ test/nc4f_test_module.f90:34 | IO/CALLBACK: PRINT and impure procedure-pointer calls
├── buffer_edges [I] @ test/nc4f_test_cases_basic.f90:190 | DEP
│   ├── close_netcdf [I] @ src/netcdf/nc4f_nc_dataset.f90:84 | DEP
│   │   ├── close_netcdf_ [I] @ src/netcdf/nc4f_nc_dataset.f90:100 | DEP
│   │   │   ├── has_err [E] => shared
│   │   │   ├── nc_close [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:60 | EXT: external C implementation; no audited PURE contract
│   │   │   └── netcdf_err [I] => shared
│   │   └── handle_err [P] => shared
│   ├── extract_att_char_scalar [I] @ src/data_structure/nc4f_ds_extract.f90:227 | DEP
│   │   ├── extract_att_char_vector [I] @ src/data_structure/nc4f_ds_extract.f90:209 | C_PTR: calls impure C_F_POINTER
│   │   │   ├── buffer2cptr_att [I] => shared
│   │   │   └── validate_att [P] => shared
│   │   └── validate_att [P] => shared
│   ├── extract_var_real32_1d [I] @ src/data_structure/nc4f_ds_extract.f90:1387 | C_PTR: calls impure C_F_POINTER
│   │   ├── buffer2cptr_var [I] => shared
│   │   └── validate_var [P] => shared
│   ├── get_variable [I] @ src/netcdf/nc4f_nc_variable.f90:102 | DEP
│   │   ├── get_var_ [I] @ src/netcdf/nc4f_nc_variable.f90:128 | DEP
│   │   │   ├── buffer2cptr_var [I] => shared
│   │   │   ├── get_size [P] => shared
│   │   │   ├── has_err [E] => shared
│   │   │   ├── initialize_var [P] @ src/netcdf/nc4f_nc_utility.f90:17
│   │   │   │   └── buffer_size [P] => shared
│   │   │   ├── inq_var_ [I] @ src/netcdf/nc4f_nc_variable.f90:276 | DEP
│   │   │   │   ├── clip [P] => shared
│   │   │   │   ├── f2cstr [P] => shared
│   │   │   │   ├── get_atts_var [I] @ src/netcdf/nc4f_nc_attribute.f90:160 | DEP
│   │   │   │   │   ├── get_atts_ [I] @ src/netcdf/nc4f_nc_attribute.f90:180 | DEP
│   │   │   │   │   │   ├── c2fstr [P] @ src/netcdf/nc4f_nc_utility.f90:39
│   │   │   │   │   │   ├── get_att_ [I] @ src/netcdf/nc4f_nc_attribute.f90:213 | DEP
│   │   │   │   │   │   │   ├── buffer2cptr_att [I] => shared
│   │   │   │   │   │   │   ├── clip [P] => shared
│   │   │   │   │   │   │   ├── f2cstr [P] => shared
│   │   │   │   │   │   │   ├── has_err [E] => shared
│   │   │   │   │   │   │   ├── initialize_att [P] @ src/netcdf/nc4f_nc_utility.f90:5
│   │   │   │   │   │   │   │   └── buffer_size [P] => shared
│   │   │   │   │   │   │   ├── nc_get_att [X,I] @ src/c_interface/nc4f_c_interface_attribute.inc:37 | EXT: external C implementation; no audited PURE contract
│   │   │   │   │   │   │   ├── nc_inq_att [X,I] @ src/c_interface/nc4f_c_interface_attribute.inc:4 | EXT: external C implementation; no audited PURE contract
│   │   │   │   │   │   │   ├── netcdf_err [I] => shared
│   │   │   │   │   │   │   └── validate_att [P] => shared
│   │   │   │   │   │   ├── has_err [E] => shared
│   │   │   │   │   │   ├── nc_inq_attname [X,I] @ src/c_interface/nc4f_c_interface_attribute.inc:78 | EXT: external C implementation; no audited PURE contract
│   │   │   │   │   │   ├── nc_inq_natts [X,I] @ src/c_interface/nc4f_c_interface_attribute.inc:63 | EXT: external C implementation; no audited PURE contract
│   │   │   │   │   │   ├── nc_inq_varnatts [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:62 | EXT: external C implementation; no audited PURE contract
│   │   │   │   │   │   └── netcdf_err [I] => shared
│   │   │   │   │   └── handle_err [P] => shared
│   │   │   │   ├── get_size [P] => shared
│   │   │   │   ├── has_err [E] => shared
│   │   │   │   ├── inq_dims_var [I] @ src/netcdf/nc4f_nc_dimension.f90:23 | DEP
│   │   │   │   │   ├── handle_err [P] => shared
│   │   │   │   │   └── inq_dims_ [I] @ src/netcdf/nc4f_nc_dimension.f90:43 | DEP
│   │   │   │   │       ├── c2fstr [P] => shared
│   │   │   │   │       ├── clip [P] => shared
│   │   │   │   │       ├── has_err [E] => shared
│   │   │   │   │       ├── nc_inq_dimids [X,I] @ src/c_interface/nc4f_c_interface_dimension.inc:21 | EXT: external C implementation; no audited PURE contract
│   │   │   │   │       ├── nc_inq_dimlen [X,I] @ src/c_interface/nc4f_c_interface_dimension.inc:4 | EXT: external C implementation; no audited PURE contract
│   │   │   │   │       ├── nc_inq_dimname [X,I] @ src/c_interface/nc4f_c_interface_dimension.inc:56 | EXT: external C implementation; no audited PURE contract
│   │   │   │   │       ├── nc_inq_unlimdims [X,I] @ src/c_interface/nc4f_c_interface_dimension.inc:92 | EXT: external C implementation; no audited PURE contract
│   │   │   │   │       ├── nc_inq_vardimid [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:113 | EXT: external C implementation; no audited PURE contract
│   │   │   │   │       ├── nc_inq_varndims [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:130 | EXT: external C implementation; no audited PURE contract
│   │   │   │   │       └── netcdf_err [I] => shared
│   │   │   │   ├── inq_vartype_ [I] @ src/netcdf/nc4f_nc_variable.f90:304 | DEP
│   │   │   │   │   ├── nc_inq_vartype [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:96 | EXT: external C implementation; no audited PURE contract
│   │   │   │   │   └── netcdf_err [I] => shared
│   │   │   │   ├── nc_inq_varid [X,I] => shared
│   │   │   │   └── netcdf_err [I] => shared
│   │   │   ├── nc_get_vars [X,I] @ src/c_interface/nc4f_c_interface_io.inc:25 | EXT: external C implementation; no audited PURE contract
│   │   │   ├── netcdf_err [I] => shared
│   │   │   └── validate_var [P] => shared
│   │   └── handle_err [P] => shared
│   ├── inquire_group [I] @ src/netcdf/nc4f_nc_group.f90:145 | DEP
│   │   ├── get_atts_grp [I] @ src/netcdf/nc4f_nc_attribute.f90:120 | DEP
│   │   │   ├── get_atts_ [I] => shared
│   │   │   └── handle_err [P] => shared
│   │   ├── handle_err [P] => shared
│   │   ├── has_err [E] => shared
│   │   ├── inq_dims_grp [I] @ src/netcdf/nc4f_nc_dimension.f90:5 | DEP
│   │   │   ├── handle_err [P] => shared
│   │   │   └── inq_dims_ [I] => shared
│   │   ├── inq_grps_ [I] @ src/netcdf/nc4f_nc_group.f90:418 | DEP
│   │   │   ├── c2fstr [P] => shared
│   │   │   ├── clip [P] => shared
│   │   │   ├── has_err [E] => shared
│   │   │   ├── nc_inq_grpname [X,I] @ src/c_interface/nc4f_c_interface_group.inc:57 | EXT: external C implementation; no audited PURE contract
│   │   │   ├── nc_inq_grps [X,I] @ src/c_interface/nc4f_c_interface_group.inc:41 | EXT: external C implementation; no audited PURE contract
│   │   │   └── netcdf_err [I] => shared
│   │   ├── inq_vars_ [I] @ src/netcdf/nc4f_nc_group.f90:450 | DEP
│   │   │   ├── c2fstr [P] => shared
│   │   │   ├── has_err [E] => shared
│   │   │   ├── inquire_variable [I] @ src/netcdf/nc4f_nc_variable.f90:256 | DEP
│   │   │   │   ├── handle_err [P] => shared
│   │   │   │   └── inq_var_ [I] => shared
│   │   │   ├── nc_inq_varids [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:4 | EXT: external C implementation; no audited PURE contract
│   │   │   ├── nc_inq_varname [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:20 | EXT: external C implementation; no audited PURE contract
│   │   │   └── netcdf_err [I] => shared
│   │   ├── inquire_group [I] => cycle
│   │   └── requested [E] @ src/netcdf/nc4f_nc_group.f90:482
│   ├── new_att_character [P] @ src/data_structure/nc4f_ds_attribute_constructor.f90:168
│   │   └── init_att [E] => shared
│   ├── new_dim_len_int32 [E] => shared
│   ├── new_var_real32_1d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:2105 | C_PTR: calls impure C_F_POINTER
│   │   ├── buffer_size [P] => shared
│   │   └── init_var_ [I] => shared
│   ├── open_netcdf [I] @ src/netcdf/nc4f_nc_dataset.f90:5 | DEP
│   │   ├── handle_err [P] => shared
│   │   └── open_netcdf_ [I] @ src/netcdf/nc4f_nc_dataset.f90:26 | DEP
│   │       ├── clip [P] => shared
│   │       ├── f2cstr [P] => shared
│   │       ├── has_err [E] => shared
│   │       ├── nc_create [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:28 | EXT: external C implementation; no audited PURE contract
│   │       ├── nc_open [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:4 | EXT: external C implementation; no audited PURE contract
│   │       └── netcdf_err [I] => shared
│   └── to_netcdf_var [I] @ src/netcdf/nc4f_nc_dataset.f90:118 | DEP
│       ├── close_netcdf_ [I] => shared
│       ├── handle_err [P] => shared
│       ├── has_err [E] => shared
│       ├── open_netcdf_ [I] => shared
│       ├── put_att_grp [I] @ src/netcdf/nc4f_nc_attribute.f90:261 | DEP
│       │   └── put_atts_ [I] @ src/netcdf/nc4f_nc_attribute.f90:271 | DEP
│       │       ├── buffer2cptr_att [I] => shared
│       │       ├── f2cstr [P] => shared
│       │       ├── has_err [E] => shared
│       │       ├── nc_put_att [X,I] @ src/c_interface/nc4f_c_interface_attribute.inc:108 | EXT: external C implementation; no audited PURE contract
│       │       ├── netcdf_err [I] => shared
│       │       └── validate_att [P] => shared
│       └── put_var [I] @ src/netcdf/nc4f_nc_variable.f90:414 | DEP
│           ├── buffer2cptr_var [I] => shared
│           ├── def_var [I] @ src/netcdf/nc4f_nc_variable.f90:456 | DEP
│           │   ├── def_dim [I] @ src/netcdf/nc4f_nc_dimension.f90:111 | DEP
│           │   │   ├── f2cstr [P] => shared
│           │   │   ├── has_err [E] => shared
│           │   │   ├── nc_def_dim [X,I] @ src/c_interface/nc4f_c_interface_dimension.inc:107 | EXT: external C implementation; no audited PURE contract
│           │   │   ├── nc_inq_dimid [X,I] @ src/c_interface/nc4f_c_interface_dimension.inc:39 | EXT: external C implementation; no audited PURE contract
│           │   │   └── netcdf_err [I] => shared
│           │   ├── f2cstr [P] => shared
│           │   ├── has_err [E] => shared
│           │   ├── nc_def_var [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:147 | EXT: external C implementation; no audited PURE contract
│           │   └── netcdf_err [I] => shared
│           ├── has_err [E] => shared
│           ├── nc_put_vara [X,I] @ src/c_interface/nc4f_c_interface_io.inc:68 | EXT: external C implementation; no audited PURE contract
│           ├── netcdf_err [I] => shared
│           ├── put_att_var [I] @ src/netcdf/nc4f_nc_attribute.f90:249 | DEP
│           │   └── put_atts_ [I] => shared
│           └── validate_var [P] => shared
├── c_bindings_formats [I] @ test/nc4f_test_c_bindings.f90:148 | DEP
│   ├── check [I] @ test/nc4f_test_c_bindings.f90:21 | IO: PRINT statement
│   ├── nc_abort [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:119 | EXT: external C implementation; no audited PURE contract
│   ├── nc_close [X,I] => shared
│   ├── nc_create [X,I] => shared
│   ├── nc_def_dim [X,I] => shared
│   ├── nc_def_var [X,I] => shared
│   ├── nc_enddef [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:94 | EXT: external C implementation; no audited PURE contract
│   ├── nc_get_att_text [X,I] @ src/c_interface/nc4f_c_interface_attribute.inc:592 | EXT: external C implementation; no audited PURE contract
│   ├── nc_get_var_float [X,I] @ src/c_interface/nc4f_c_interface_io.inc:907 | EXT: external C implementation; no audited PURE contract
│   ├── nc_get_var_int [X,I] @ src/c_interface/nc4f_c_interface_io.inc:448 | EXT: external C implementation; no audited PURE contract
│   ├── nc_get_vara_longlong [X,I] @ src/c_interface/nc4f_c_interface_io.inc:773 | EXT: external C implementation; no audited PURE contract
│   ├── nc_inq_format [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:178 | EXT: external C implementation; no audited PURE contract
│   ├── nc_inq_ndims [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:152 | EXT: external C implementation; no audited PURE contract
│   ├── nc_inq_nvars [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:165 | EXT: external C implementation; no audited PURE contract
│   ├── nc_open [X,I] => shared
│   ├── nc_put_att_text [X,I] @ src/c_interface/nc4f_c_interface_attribute.inc:613 | EXT: external C implementation; no audited PURE contract
│   ├── nc_put_var_int [X,I] @ src/c_interface/nc4f_c_interface_io.inc:523 | EXT: external C implementation; no audited PURE contract
│   ├── nc_put_vara_longlong [X,I] @ src/c_interface/nc4f_c_interface_io.inc:849 | EXT: external C implementation; no audited PURE contract
│   ├── nc_redef [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:80 | EXT: external C implementation; no audited PURE contract
│   ├── nc_sync [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:107 | EXT: external C implementation; no audited PURE contract
│   └── require [I] @ test/nc4f_test_c_bindings.f90:29 | IO: PRINT statement
├── c_bindings_legacy_aux [I] @ test/nc4f_test_c_bindings.f90:453 | DEP
│   ├── c_free [X,I] @ src/c_interface/nc4f_c_interface.f90:490 | EXT: external C implementation; no audited PURE contract
│   ├── c_strlen [X,P] => shared
│   ├── check [I] => shared
│   ├── nc_close [X,I] => shared
│   ├── nc_get_var_int [X,I] => shared
│   ├── nc_open_mem [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:628 | EXT: external C implementation; no audited PURE contract
│   ├── nc_rc_get [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:603 | EXT: external C implementation; no audited PURE contract
│   ├── nc_rc_set [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:614 | EXT: external C implementation; no audited PURE contract
│   ├── ncaux_plugin_path_clear [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:792 | EXT: external C implementation; no audited PURE contract
│   ├── ncaux_plugin_path_parse [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:759 | EXT: external C implementation; no audited PURE contract
│   ├── ncaux_plugin_path_tostring [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:775 | EXT: external C implementation; no audited PURE contract
│   ├── ncaux_readfile [X,I] @ src/c_interface/nc4f_c_interface_io.inc:2990 | EXT: external C implementation; no audited PURE contract
│   ├── ncclose [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:549 | EXT: external C implementation; no audited PURE contract
│   ├── nccreate [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:459 | EXT: external C implementation; no audited PURE contract
│   ├── ncdimdef [X,I] @ src/c_interface/nc4f_c_interface_dimension.inc:176 | EXT: external C implementation; no audited PURE contract
│   ├── ncendef [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:513 | EXT: external C implementation; no audited PURE contract
│   ├── ncvardef [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:1105 | EXT: external C implementation; no audited PURE contract
│   ├── ncvarget [X,I] @ src/c_interface/nc4f_c_interface_io.inc:2712 | EXT: external C implementation; no audited PURE contract
│   ├── ncvarput [X,I] @ src/c_interface/nc4f_c_interface_io.inc:2690 | EXT: external C implementation; no audited PURE contract
│   └── require [I] => shared
├── c_bindings_memory_mapped [I] @ test/nc4f_test_c_bindings.f90:389 | DEP
│   ├── c_free [X,I] => shared
│   ├── check [I] => shared
│   ├── nc_close [X,I] => shared
│   ├── nc_close_memio [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:687 | EXT: external C implementation; no audited PURE contract
│   ├── nc_create [X,I] => shared
│   ├── nc_create_mem [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:649 | EXT: external C implementation; no audited PURE contract
│   ├── nc_def_dim [X,I] => shared
│   ├── nc_def_var [X,I] => shared
│   ├── nc_def_var_deflate [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:316 | EXT: external C implementation; no audited PURE contract
│   ├── nc_def_var_quantize [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:1002 | EXT: external C implementation; no audited PURE contract
│   ├── nc_enddef [X,I] => shared
│   ├── nc_get_var1_double [X,I] @ src/c_interface/nc4f_c_interface_io.inc:1915 | EXT: external C implementation; no audited PURE contract
│   ├── nc_get_var_int [X,I] => shared
│   ├── nc_get_varm_int [X,I] @ src/c_interface/nc4f_c_interface_io.inc:2215 | EXT: external C implementation; no audited PURE contract
│   ├── nc_inq_var_deflate [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:340 | EXT: external C implementation; no audited PURE contract
│   ├── nc_inq_var_quantize [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:1021 | EXT: external C implementation; no audited PURE contract
│   ├── nc_open_mem [X,I] => shared
│   ├── nc_open_memio [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:667 | EXT: external C implementation; no audited PURE contract
│   ├── nc_put_var1_double [X,I] @ src/c_interface/nc4f_c_interface_io.inc:1896 | EXT: external C implementation; no audited PURE contract
│   ├── nc_put_var_int [X,I] => shared
│   ├── nc_put_varm_int [X,I] @ src/c_interface/nc4f_c_interface_io.inc:2186 | EXT: external C implementation; no audited PURE contract
│   └── require [I] => shared
├── c_bindings_storage [I] @ test/nc4f_test_c_bindings.f90:37 | DEP
│   ├── c_strlen [X,P] => shared
│   ├── check [I] => shared
│   ├── nc_close [X,I] => shared
│   ├── nc_copy_att [X,I] @ src/c_interface/nc4f_c_interface_attribute.inc:191 | EXT: external C implementation; no audited PURE contract
│   ├── nc_create [X,I] => shared
│   ├── nc_def_dim [X,I] => shared
│   ├── nc_def_grp [X,I] @ src/c_interface/nc4f_c_interface_group.inc:4 | EXT: external C implementation; no audited PURE contract
│   ├── nc_def_var [X,I] => shared
│   ├── nc_def_var_chunking [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:273 | EXT: external C implementation; no audited PURE contract
│   ├── nc_def_var_deflate [X,I] => shared
│   ├── nc_def_var_endian [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:399 | EXT: external C implementation; no audited PURE contract
│   ├── nc_def_var_fill [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:436 | EXT: external C implementation; no audited PURE contract
│   ├── nc_def_var_fletcher32 [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:362 | EXT: external C implementation; no audited PURE contract
│   ├── nc_del_att [X,I] @ src/c_interface/nc4f_c_interface_attribute.inc:236 | EXT: external C implementation; no audited PURE contract
│   ├── nc_enddef [X,I] => shared
│   ├── nc_get_att_double [X,I] @ src/c_interface/nc4f_c_interface_attribute.inc:544 | EXT: external C implementation; no audited PURE contract
│   ├── nc_get_chunk_cache [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:256 | EXT: external C implementation; no audited PURE contract
│   ├── nc_get_var_chunk_cache [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:212 | EXT: external C implementation; no audited PURE contract
│   ├── nc_get_var_double [X,I] @ src/c_interface/nc4f_c_interface_io.inc:1060 | EXT: external C implementation; no audited PURE contract
│   ├── nc_get_vara [X,I] @ src/c_interface/nc4f_c_interface_io.inc:87 | EXT: external C implementation; no audited PURE contract
│   ├── nc_get_vars_int [X,I] @ src/c_interface/nc4f_c_interface_io.inc:493 | EXT: external C implementation; no audited PURE contract
│   ├── nc_inq [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:132 | EXT: external C implementation; no audited PURE contract
│   ├── nc_inq_att [X,I] => shared
│   ├── nc_inq_attid [X,I] => shared
│   ├── nc_inq_atttype [X,I] @ src/c_interface/nc4f_c_interface_attribute.inc:153 | EXT: external C implementation; no audited PURE contract
│   ├── nc_inq_dim [X,I] @ src/c_interface/nc4f_c_interface_dimension.inc:136 | EXT: external C implementation; no audited PURE contract
│   ├── nc_inq_format [X,I] => shared
│   ├── nc_inq_format_extended [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:191 | EXT: external C implementation; no audited PURE contract
│   ├── nc_inq_grpname_len [X,I] @ src/c_interface/nc4f_c_interface_group.inc:122 | EXT: external C implementation; no audited PURE contract
│   ├── nc_inq_libvers [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:73 | EXT: external C implementation; no audited PURE contract
│   ├── nc_inq_path [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:206 | EXT: external C implementation; no audited PURE contract
│   ├── nc_inq_type [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:255 | EXT: external C implementation; no audited PURE contract
│   ├── nc_inq_var_chunking [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:296 | EXT: external C implementation; no audited PURE contract
│   ├── nc_inq_var_deflate [X,I] => shared
│   ├── nc_inq_var_endian [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:419 | EXT: external C implementation; no audited PURE contract
│   ├── nc_inq_var_fill [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:458 | EXT: external C implementation; no audited PURE contract
│   ├── nc_inq_var_fletcher32 [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:382 | EXT: external C implementation; no audited PURE contract
│   ├── nc_inq_varid [X,I] => shared
│   ├── nc_open [X,I] => shared
│   ├── nc_put_att_double [X,I] @ src/c_interface/nc4f_c_interface_attribute.inc:566 | EXT: external C implementation; no audited PURE contract
│   ├── nc_put_vars_int [X,I] @ src/c_interface/nc4f_c_interface_io.inc:570 | EXT: external C implementation; no audited PURE contract
│   ├── nc_rename_att [X,I] => shared
│   ├── nc_rename_dim [X,I] @ src/c_interface/nc4f_c_interface_dimension.inc:154 | EXT: external C implementation; no audited PURE contract
│   ├── nc_rename_grp [X,I] => shared
│   ├── nc_rename_var [X,I] => shared
│   ├── nc_set_chunk_cache [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:240 | EXT: external C implementation; no audited PURE contract
│   ├── nc_set_fill [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:222 | EXT: external C implementation; no audited PURE contract
│   ├── nc_set_var_chunk_cache [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:188 | EXT: external C implementation; no audited PURE contract
│   ├── nc_sync [X,I] => shared
│   └── require [I] => shared
├── c_bindings_strings [I] @ test/nc4f_test_c_bindings.f90:220 | C_PTR: calls impure C_F_POINTER
│   ├── c_strlen [X,P] => shared
│   ├── check [I] => shared
│   ├── nc_close [X,I] => shared
│   ├── nc_create [X,I] => shared
│   ├── nc_def_dim [X,I] => shared
│   ├── nc_def_var [X,I] => shared
│   ├── nc_def_var_fill [X,I] => shared
│   ├── nc_free_string [X,I] @ src/c_interface/nc4f_c_interface_io.inc:1513 | EXT: external C implementation; no audited PURE contract
│   ├── nc_get_att_string [X,I] @ src/c_interface/nc4f_c_interface_attribute.inc:636 | EXT: external C implementation; no audited PURE contract
│   ├── nc_get_var_string [X,I] @ src/c_interface/nc4f_c_interface_io.inc:1360 | EXT: external C implementation; no audited PURE contract
│   ├── nc_get_var_text [X,I] @ src/c_interface/nc4f_c_interface_io.inc:1213 | EXT: external C implementation; no audited PURE contract
│   ├── nc_get_vara_string [X,I] @ src/c_interface/nc4f_c_interface_io.inc:1379 | EXT: external C implementation; no audited PURE contract
│   ├── nc_get_vars_string [X,I] @ src/c_interface/nc4f_c_interface_io.inc:1405 | EXT: external C implementation; no audited PURE contract
│   ├── nc_inq_attlen [X,I] @ src/c_interface/nc4f_c_interface_attribute.inc:172 | EXT: external C implementation; no audited PURE contract
│   ├── nc_inq_var_fill [X,I] => shared
│   ├── nc_open [X,I] => shared
│   ├── nc_put_att_string [X,I] @ src/c_interface/nc4f_c_interface_attribute.inc:658 | EXT: external C implementation; no audited PURE contract
│   ├── nc_put_var_string [X,I] @ src/c_interface/nc4f_c_interface_io.inc:1435 | EXT: external C implementation; no audited PURE contract
│   ├── nc_put_var_text [X,I] @ src/c_interface/nc4f_c_interface_io.inc:1285 | EXT: external C implementation; no audited PURE contract
│   ├── nc_put_vara_string [X,I] @ src/c_interface/nc4f_c_interface_io.inc:1455 | EXT: external C implementation; no audited PURE contract
│   ├── nc_put_vars_string [X,I] @ src/c_interface/nc4f_c_interface_io.inc:1482 | EXT: external C implementation; no audited PURE contract
│   └── require [I] => shared
├── c_bindings_user_types [I] @ test/nc4f_test_c_bindings.f90:292 | C_PTR: calls impure C_F_POINTER
│   ├── c_strlen [X,P] => shared
│   ├── check [I] => shared
│   ├── nc_close [X,I] => shared
│   ├── nc_copy_data_all [X,I] @ src/c_interface/nc4f_c_interface_io.inc:2630 | EXT: external C implementation; no audited PURE contract
│   ├── nc_create [X,I] => shared
│   ├── nc_def_compound [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:516 | EXT: external C implementation; no audited PURE contract
│   ├── nc_def_enum [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:869 | EXT: external C implementation; no audited PURE contract
│   ├── nc_def_opaque [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:966 | EXT: external C implementation; no audited PURE contract
│   ├── nc_def_var [X,I] => shared
│   ├── nc_def_vlen [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:804 | EXT: external C implementation; no audited PURE contract
│   ├── nc_enddef [X,I] => shared
│   ├── nc_get_var [X,I] @ src/c_interface/nc4f_c_interface_io.inc:4 | EXT: external C implementation; no audited PURE contract
│   ├── nc_get_vlen_element [X,I] @ src/c_interface/nc4f_c_interface_io.inc:1551 | EXT: external C implementation; no audited PURE contract
│   ├── nc_inq_compound_field [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:666 | EXT: external C implementation; no audited PURE contract
│   ├── nc_inq_compound_fieldindex [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:712 | EXT: external C implementation; no audited PURE contract
│   ├── nc_inq_enum_ident [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:948 | EXT: external C implementation; no audited PURE contract
│   ├── nc_inq_type_equal [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:495 | EXT: external C implementation; no audited PURE contract
│   ├── nc_inq_typeid [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:581 | EXT: external C implementation; no audited PURE contract
│   ├── nc_inq_typeids [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:479 | EXT: external C implementation; no audited PURE contract
│   ├── nc_inq_user_type [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:843 | EXT: external C implementation; no audited PURE contract
│   ├── nc_insert_array_compound [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:555 | EXT: external C implementation; no audited PURE contract
│   ├── nc_insert_compound [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:534 | EXT: external C implementation; no audited PURE contract
│   ├── nc_insert_enum [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:887 | EXT: external C implementation; no audited PURE contract
│   ├── nc_open [X,I] => shared
│   ├── nc_put_var [X,I] @ src/c_interface/nc4f_c_interface_io.inc:46 | EXT: external C implementation; no audited PURE contract
│   ├── nc_put_vlen_element [X,I] @ src/c_interface/nc4f_c_interface_io.inc:1529 | EXT: external C implementation; no audited PURE contract
│   ├── nc_reclaim_data [X,I] @ src/c_interface/nc4f_c_interface_io.inc:2568 | EXT: external C implementation; no audited PURE contract
│   ├── nc_reclaim_data_all [X,I] @ src/c_interface/nc4f_c_interface_io.inc:2588 | EXT: external C implementation; no audited PURE contract
│   ├── ncaux_copy_data [X,I] @ src/c_interface/nc4f_c_interface_io.inc:2925 | EXT: external C implementation; no audited PURE contract
│   ├── ncaux_reclaim_data [X,I] @ src/c_interface/nc4f_c_interface_io.inc:2885 | EXT: external C implementation; no audited PURE contract
│   └── require [I] => shared
├── cami_initial_read [I] @ test/nc4f_test_cases_data.f90:537 | DEP
│   ├── close_netcdf [I] => shared
│   ├── extract_att_char_scalar [I] => shared
│   ├── extract_var_real64_4d [I] @ src/data_structure/nc4f_ds_extract.f90:1729 | C_PTR: calls impure C_F_POINTER
│   │   ├── buffer2cptr_var [I] => shared
│   │   ├── get_shape [P] => shared
│   │   └── validate_var [P] => shared
│   ├── get_att_grp [I] @ src/netcdf/nc4f_nc_attribute.f90:100 | DEP
│   │   ├── clip [P] => shared
│   │   ├── get_att_ [I] => shared
│   │   └── handle_err [P] => shared
│   ├── get_att_var [I] @ src/netcdf/nc4f_nc_attribute.f90:138 | DEP
│   │   ├── get_att_ [I] => shared
│   │   └── handle_err [P] => shared
│   ├── get_variable [I] => shared
│   ├── has_dim [P] @ test/nc4f_test_cases_data.f90:721
│   ├── inquire_group [I] => shared
│   ├── inquire_subgroups [I] @ src/netcdf/nc4f_nc_group.f90:127 | DEP
│   │   ├── handle_err [P] => shared
│   │   └── inq_grps_ [I] => shared
│   ├── open_netcdf [I] => shared
│   └── starts_with [P] @ test/nc4f_test_cases_data.f90:745
├── character_variables [I] @ test/nc4f_test_cases_basic.f90:55 | DEP
│   ├── close_netcdf [I] => shared
│   ├── eq_dim [E] => shared
│   ├── extract_var_char_2d [I] @ src/data_structure/nc4f_ds_extract.f90:1976 | C_PTR: calls impure C_F_POINTER
│   │   ├── buffer2cptr_var [I] => shared
│   │   ├── get_shape [P] => shared
│   │   └── validate_var [P] => shared
│   ├── get_variable [I] => shared
│   ├── new_dim_len_int32 [E] => shared
│   ├── new_var_char_2d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:3178 | DEP
│   │   └── init_var_ [I] => shared
│   ├── open_netcdf [I] => shared
│   └── to_netcdf_var [I] => shared
├── copy_semantics [I] @ test/nc4f_test_cases_copy.f90:10 | DEP
│   ├── check_invalid_shallow_inputs [I] @ test/nc4f_test_cases_copy.f90:173 | ENV: process/environment intrinsic
│   ├── check_scoped_owned_value [I] @ test/nc4f_test_cases_copy.f90:148 | DEP
│   │   ├── extract_var_real32_1d [I] => shared
│   │   └── new_scoped_owned_var [I] @ test/nc4f_test_cases_copy.f90:163 | DEP
│   │       ├── new_dim_len_int32 [E] => shared
│   │       └── new_var_real32_1d [I] => shared
│   ├── extract_att_real32_vector [I] @ src/data_structure/nc4f_ds_extract.f90:141 | C_PTR: calls impure C_F_POINTER
│   │   ├── buffer2cptr_att [I] => shared
│   │   └── validate_att [P] => shared
│   ├── extract_var_real32_1d [I] => shared
│   ├── extract_var_real32_2d [I] @ src/data_structure/nc4f_ds_extract.f90:1406 | C_PTR: calls impure C_F_POINTER
│   │   ├── buffer2cptr_var [I] => shared
│   │   ├── get_shape [P] => shared
│   │   └── validate_var [P] => shared
│   ├── new_att_real32 [P] @ src/data_structure/nc4f_ds_attribute_constructor.f90:113
│   │   └── init_att [E] => shared
│   ├── new_dataset_all [I] @ src/data_structure/nc4f_ds_group.f90:218 | DEP
│   │   └── new_dataset_ [I] @ src/data_structure/nc4f_ds_group.f90:235 | COPY: intrinsic assignment copies pointer-bearing INTENT(IN) children
│   │       ├── clone_att [I] @ src/data_structure/nc4f_ds_clone.f90:64 | PTRARG: INTENT(IN) src%ptr is passed to a POINTER dummy
│   │       │   ├── clone_ [P] @ src/data_structure/nc4f_ds_clone.f90:80
│   │       │   └── validate_att [P] => shared
│   │       ├── clone_grp [I] @ src/data_structure/nc4f_ds_clone.f90:6 | DEP
│   │       │   └── clone_grp_ [I] @ src/data_structure/nc4f_ds_clone.f90:16 | DEP
│   │       │       ├── clone_att [I] => shared
│   │       │       ├── clone_grp_ [I] => cycle
│   │       │       └── clone_var [I] @ src/data_structure/nc4f_ds_clone.f90:43 | PTRARG: INTENT(IN) src%ptr is passed to a POINTER dummy
│   │       │           ├── clone_ [P] => shared
│   │       │           ├── clone_att [I] => shared
│   │       │           └── validate_var [P] => shared
│   │       ├── clone_var [I] => shared
│   │       └── collect_dims_ [P] @ src/data_structure/nc4f_ds_group.f90:281
│   ├── new_dataset_empty [I] @ src/data_structure/nc4f_ds_group.f90:175 | DEP
│   │   └── new_dataset_ [I] => shared
│   ├── new_dataset_grps [I] @ src/data_structure/nc4f_ds_group.f90:203 | DEP
│   │   └── new_dataset_ [I] => shared
│   ├── new_dataset_vars [I] @ src/data_structure/nc4f_ds_group.f90:188 | DEP
│   │   └── new_dataset_ [I] => shared
│   ├── new_dim_arg_int32 [E] @ src/data_structure/nc4f_ds_dimension.f90:5
│   ├── new_dim_args [E] @ src/data_structure/nc4f_ds_dimension.f90:57
│   ├── new_dim_len_int32 [E] => shared
│   ├── new_var_real32_1d [I] => shared
│   └── new_var_real32_2d [I] => shared
├── creation_policy [I] @ test/nc4f_test_cases_errors.f90:7 | DEP
│   ├── close_netcdf [I] => shared
│   ├── new_dim_len_int32 [E] => shared
│   ├── new_var_real32_1d [I] => shared
│   ├── open_netcdf [I] => shared
│   └── to_netcdf_var [I] => shared
├── data_model [I] @ test/nc4f_test_cases_model.f90:10 | DEP
│   ├── close_netcdf [I] => shared
│   ├── eq_att [E] => shared
│   ├── eq_dim [E] => shared
│   ├── eq_var [E] => shared
│   ├── extract_var_real32_1d [I] => shared
│   ├── extract_var_real32_2d [I] => shared
│   ├── get_group [I] @ src/netcdf/nc4f_nc_group.f90:107 | DEP
│   │   ├── get_grp_ [I] @ src/netcdf/nc4f_nc_group.f90:401 | DEP
│   │   │   ├── clip [P] => shared
│   │   │   ├── f2cstr [P] => shared
│   │   │   ├── nc_inq_ncid [X,I] => shared
│   │   │   └── netcdf_err [I] => shared
│   │   └── handle_err [P] => shared
│   ├── get_shape [P] => shared
│   ├── get_size [P] => shared
│   ├── get_variable [I] => shared
│   ├── has_err [E] => shared
│   ├── init_att_mold [I] @ src/data_structure/nc4f_ds_attribute.f90:82 | ALIAS: pointer assignment targets an INTENT(IN) mold component
│   │   └── init_att_ [E] => shared
│   ├── init_var_mold [I] @ src/data_structure/nc4f_ds_variable.f90:71 | ALIAS: pointer assignment targets an INTENT(IN) mold component
│   │   └── init_var_ [I] => shared
│   ├── inquire_group [I] => shared
│   ├── new_att_character [P] => shared
│   ├── new_dataset_all [I] => shared
│   ├── new_dataset_empty [I] => shared
│   ├── new_dataset_grps [I] => shared
│   ├── new_dataset_vars [I] => shared
│   ├── new_dim_arg_int32 [E] => shared
│   ├── new_dim_args [E] => shared
│   ├── new_dim_len_int32 [E] => shared
│   ├── new_var_real32_1d [I] => shared
│   ├── new_var_real32_2d [I] => shared
│   ├── open_netcdf [I] => shared
│   ├── sum_vars [I] @ src/data_structure/nc4f_ds_arithmetic.f90:6 | DEP
│   │   ├── clone_var [I] => shared
│   │   ├── eq_dim [E] => shared
│   │   ├── extract_var_int16_1d [I] @ src/data_structure/nc4f_ds_extract.f90:532 | C_PTR: calls impure C_F_POINTER
│   │   │   ├── buffer2cptr_var [I] => shared
│   │   │   └── validate_var [P] => shared
│   │   ├── extract_var_int32_1d [I] @ src/data_structure/nc4f_ds_extract.f90:817 | C_PTR: calls impure C_F_POINTER
│   │   │   ├── buffer2cptr_var [I] => shared
│   │   │   └── validate_var [P] => shared
│   │   ├── extract_var_int64_1d [I] @ src/data_structure/nc4f_ds_extract.f90:1102 | C_PTR: calls impure C_F_POINTER
│   │   │   ├── buffer2cptr_var [I] => shared
│   │   │   └── validate_var [P] => shared
│   │   ├── extract_var_int8_1d [I] @ src/data_structure/nc4f_ds_extract.f90:247 | C_PTR: calls impure C_F_POINTER
│   │   │   ├── buffer2cptr_var [I] => shared
│   │   │   └── validate_var [P] => shared
│   │   ├── extract_var_real32_1d [I] => shared
│   │   └── extract_var_real64_1d [I] @ src/data_structure/nc4f_ds_extract.f90:1672 | C_PTR: calls impure C_F_POINTER
│   │       ├── buffer2cptr_var [I] => shared
│   │       └── validate_var [P] => shared
│   ├── to_netcdf_grp [I] @ src/netcdf/nc4f_nc_dataset.f90:166 | DEP
│   │   ├── close_netcdf_ [I] => shared
│   │   ├── handle_err [P] => shared
│   │   ├── has_err [E] => shared
│   │   ├── open_netcdf_ [I] => shared
│   │   ├── serialize_grp [I] @ src/netcdf/nc4f_nc_group.f90:202 | DEP
│   │   │   ├── define_grp_tree_ [I] @ src/netcdf/nc4f_nc_group.f90:273 | DEP
│   │   │   │   ├── def_dim [I] => shared
│   │   │   │   ├── def_grp_ [I] @ src/netcdf/nc4f_nc_group.f90:384 | DEP
│   │   │   │   │   ├── clip [P] => shared
│   │   │   │   │   ├── f2cstr [P] => shared
│   │   │   │   │   ├── nc_def_grp [X,I] => shared
│   │   │   │   │   └── netcdf_err [I] => shared
│   │   │   │   ├── def_var [I] => shared
│   │   │   │   ├── define_grp_tree_ [I] => cycle
│   │   │   │   ├── has_err [E] => shared
│   │   │   │   ├── put_att_var [I] => shared
│   │   │   │   └── write_grp_atts_ [I] @ src/netcdf/nc4f_nc_group.f90:327 | DEP
│   │   │   │       └── put_att_grp [I] => shared
│   │   │   ├── has_err [E] => shared
│   │   │   ├── write_grp_atts_ [I] => shared
│   │   │   └── write_grp_tree_data_ [I] @ src/netcdf/nc4f_nc_group.f90:342 | DEP
│   │   │       ├── get_grp_ [I] => shared
│   │   │       ├── has_err [E] => shared
│   │   │       ├── put_vara [I] @ src/netcdf/nc4f_nc_variable.f90:325 | DEP
│   │   │       │   ├── buffer2cptr_var [I] => shared
│   │   │       │   ├── has_err [E] => shared
│   │   │       │   ├── inq_var_ [I] => shared
│   │   │       │   ├── nc_put_vara [X,I] => shared
│   │   │       │   ├── netcdf_err [I] => shared
│   │   │       │   └── validate_var [P] => shared
│   │   │       └── write_grp_tree_data_ [I] => cycle
│   │   └── serialize_grps [I] @ src/netcdf/nc4f_nc_group.f90:222 | DEP
│   │       ├── def_grp_ [I] => shared
│   │       ├── define_grp_tree_ [I] => shared
│   │       ├── get_grp_ [I] => shared
│   │       ├── has_err [E] => shared
│   │       ├── write_grp_atts_ [I] => shared
│   │       └── write_grp_tree_data_ [I] => shared
│   ├── write_frmt_err [I] @ src/data_structure/nc4f_ds_io.f90:135 | IO: external-unit formatted WRITE
│   ├── write_frmt_grp [I] @ src/data_structure/nc4f_ds_io.f90:87 | IO: external-unit formatted WRITE
│   │   └── render_grp [I] @ src/data_structure/nc4f_ds_io.f90:170 | DEP
│   │       └── render_grp_ [I] @ src/data_structure/nc4f_ds_io.f90:204 | DEP
│   │           ├── append [P] @ src/data_structure/nc4f_ds_io.f90:333
│   │           ├── render_atts [I] @ src/data_structure/nc4f_ds_io.f90:302 | DEP
│   │           │   ├── append [P] => shared
│   │           │   └── render_att [I] @ src/data_structure/nc4f_ds_io.f90:406 | DEP
│   │           │       ├── render_att_value [I] => shared
│   │           │       └── type_name [P] => shared
│   │           ├── render_dims [P] @ src/data_structure/nc4f_ds_io.f90:240
│   │           │   ├── append [P] => shared
│   │           │   └── render_dim [P] @ src/data_structure/nc4f_ds_io.f90:386
│   │           ├── render_grp [I] => cycle
│   │           └── render_vars [I] @ src/data_structure/nc4f_ds_io.f90:271 | DEP
│   │               ├── append [P] => shared
│   │               └── render_var [I] @ src/data_structure/nc4f_ds_io.f90:678 | DEP
│   │                   ├── render_att [I] => shared
│   │                   └── type_name [P] => shared
│   └── write_frmt_netcdf [I] @ src/data_structure/nc4f_ds_io.f90:111 | IO: external-unit formatted WRITE
│       └── render_netcdf [I] @ src/data_structure/nc4f_ds_io.f90:189 | DEP
│           ├── filename_stem [P] @ src/data_structure/nc4f_ds_io.f90:361
│           └── render_grp_ [I] => shared
├── echam_spectral_read [I] @ test/nc4f_test_cases_data.f90:659 | DEP
│   ├── close_netcdf [I] => shared
│   ├── extract_att_char_scalar [I] => shared
│   ├── extract_var_real32_3d [I] @ src/data_structure/nc4f_ds_extract.f90:1425 | C_PTR: calls impure C_F_POINTER
│   │   ├── buffer2cptr_var [I] => shared
│   │   ├── get_shape [P] => shared
│   │   └── validate_var [P] => shared
│   ├── get_att_grp [I] => shared
│   ├── get_att_var [I] => shared
│   ├── get_variable [I] => shared
│   ├── has_dim [P] => shared
│   ├── inquire_group [I] => shared
│   ├── inquire_subgroups [I] => shared
│   ├── open_netcdf [I] => shared
│   └── starts_with [P] => shared
├── ecmwf_era40_read [I] @ test/nc4f_test_cases_data.f90:267 | DEP
│   ├── close_netcdf [I] => shared
│   ├── extract_att_char_scalar [I] => shared
│   ├── extract_var_int16_3d [I] @ src/data_structure/nc4f_ds_extract.f90:570 | C_PTR: calls impure C_F_POINTER
│   │   ├── buffer2cptr_var [I] => shared
│   │   ├── get_shape [P] => shared
│   │   └── validate_var [P] => shared
│   ├── extract_var_real32_1d [I] => shared
│   ├── get_att_grp [I] => shared
│   ├── get_att_var [I] => shared
│   ├── get_variable [I] => shared
│   ├── inquire_group [I] => shared
│   └── open_netcdf [I] => shared
├── elemental_reads [I] @ test/nc4f_test_cases_basic.f90:88 | DEP
│   ├── close_netcdf [I] => shared
│   ├── eq_dim [E] => shared
│   ├── get_variable [I] => shared
│   ├── inquire_variable [I] => shared
│   ├── new_dim_len_int32 [E] => shared
│   ├── new_var_int32_1d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:1055 | C_PTR: calls impure C_F_POINTER
│   │   ├── buffer_size [P] => shared
│   │   └── init_var_ [I] => shared
│   ├── open_netcdf [I] => shared
│   └── to_netcdf_var [I] => shared
├── error_handling [I] @ test/nc4f_test_cases_errors.f90:41 | DEP
│   ├── close_netcdf [I] => shared
│   ├── get_att_grp [I] => shared
│   ├── get_att_var [I] => shared
│   ├── get_variable [I] => shared
│   ├── has_err [E] => shared
│   ├── inquire_variable [I] => shared
│   ├── new_att_character [P] => shared
│   ├── new_dim_len_int32 [E] => shared
│   ├── new_var_real32_1d [I] => shared
│   ├── open_netcdf [I] => shared
│   ├── to_netcdf_var [I] => shared
│   └── write_frmt_err [I] => shared
├── extensive_rd [I] @ test/nc4f_test_cases_data.f90:128 | DEP
│   ├── close_netcdf [I] => shared
│   ├── eq_att [E] => shared
│   ├── eq_dim [E] => shared
│   ├── eq_var [E] => shared
│   ├── extensive_attributes [P] @ test/nc4f_test_cases_data.f90:805
│   │   ├── new_att_character [P] => shared
│   │   ├── new_att_int32_scalar [E] => shared
│   │   └── new_att_real64_scalar [E] @ src/data_structure/nc4f_ds_attribute_constructor.f90:153
│   │       └── new_att_real64 [P] @ src/data_structure/nc4f_ds_attribute_constructor.f90:140
│   │           └── init_att [E] => shared
│   ├── extensive_variables [I] @ test/nc4f_test_cases_data.f90:755 | DEP
│   │   ├── new_att_character [P] => shared
│   │   ├── new_att_int16_scalar [E] @ src/data_structure/nc4f_ds_attribute_constructor.f90:45
│   │   │   └── new_att_int16 [P] @ src/data_structure/nc4f_ds_attribute_constructor.f90:32
│   │   │       └── init_att [E] => shared
│   │   ├── new_att_int32_scalar [E] => shared
│   │   ├── new_att_int64_scalar [E] @ src/data_structure/nc4f_ds_attribute_constructor.f90:99
│   │   │   └── new_att_int64 [P] @ src/data_structure/nc4f_ds_attribute_constructor.f90:86
│   │   │       └── init_att [E] => shared
│   │   ├── new_att_int8_scalar [E] @ src/data_structure/nc4f_ds_attribute_constructor.f90:18
│   │   │   └── new_att_int8 [P] @ src/data_structure/nc4f_ds_attribute_constructor.f90:5
│   │   │       └── init_att [E] => shared
│   │   ├── new_att_real32_scalar [E] @ src/data_structure/nc4f_ds_attribute_constructor.f90:126
│   │   │   └── new_att_real32 [P] => shared
│   │   ├── new_att_real64_scalar [E] => shared
│   │   ├── new_dim_len_int32 [E] => shared
│   │   ├── new_var_int16_2d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:565 | C_PTR: calls impure C_F_POINTER
│   │   │   ├── buffer_size [P] => shared
│   │   │   └── init_var_ [I] => shared
│   │   ├── new_var_int32_3d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:1125 | C_PTR: calls impure C_F_POINTER
│   │   │   ├── buffer_size [P] => shared
│   │   │   └── init_var_ [I] => shared
│   │   ├── new_var_int64_4d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:1685 | C_PTR: calls impure C_F_POINTER
│   │   │   ├── buffer_size [P] => shared
│   │   │   └── init_var_ [I] => shared
│   │   ├── new_var_int8_1d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:5 | C_PTR: calls impure C_F_POINTER
│   │   │   ├── buffer_size [P] => shared
│   │   │   └── init_var_ [I] => shared
│   │   ├── new_var_real32_5d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:2245 | C_PTR: calls impure C_F_POINTER
│   │   │   ├── buffer_size [P] => shared
│   │   │   └── init_var_ [I] => shared
│   │   ├── new_var_real32_7d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:2315 | C_PTR: calls impure C_F_POINTER
│   │   │   ├── buffer_size [P] => shared
│   │   │   └── init_var_ [I] => shared
│   │   └── new_var_real64_6d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:2805 | C_PTR: calls impure C_F_POINTER
│   │       ├── buffer_size [P] => shared
│   │       └── init_var_ [I] => shared
│   ├── get_variable [I] => shared
│   ├── inquire_group [I] => shared
│   └── open_netcdf [I] => shared
├── extensive_wr [I] @ test/nc4f_test_cases_data.f90:112 | DEP
│   ├── extensive_attributes [P] => shared
│   ├── extensive_variables [I] => shared
│   └── to_netcdf_var [I] => shared
├── group_model [I] @ test/nc4f_test_cases_group.f90:7 | DEP
│   ├── new_att_character [P] => shared
│   ├── new_att_real32 [P] => shared
│   ├── new_att_real64 [P] => shared
│   ├── new_dataset_all [I] => shared
│   ├── new_dataset_grps [I] => shared
│   ├── new_dataset_vars [I] => shared
│   ├── new_dim_len_int32 [E] => shared
│   ├── new_var_real32_1d [I] => shared
│   └── write_frmt_grp [I] => shared
├── group_write [I] @ test/nc4f_test_cases_group.f90:104 | DEP
│   ├── close_netcdf [I] => shared
│   ├── extract_var_real32_1d [I] => shared
│   ├── get_att_grp [I] => shared
│   ├── get_group [I] => shared
│   ├── get_variable [I] => shared
│   ├── inquire_group [I] => shared
│   ├── inquire_subgroups [I] => shared
│   ├── new_att_character [P] => shared
│   ├── new_dataset_all [I] => shared
│   ├── new_dataset_empty [I] => shared
│   ├── new_dataset_grps [I] => shared
│   ├── new_dataset_vars [I] => shared
│   ├── new_dim_len_int32 [E] => shared
│   ├── new_var_real32_1d [I] => shared
│   ├── open_netcdf [I] => shared
│   └── to_netcdf_grp [I] => shared
├── hyperslab_reads [I] @ test/nc4f_test_cases_basic.f90:138 | DEP
│   ├── close_netcdf [I] => shared
│   ├── eq_dim [E] => shared
│   ├── extract_var_int32_2d [I] @ src/data_structure/nc4f_ds_extract.f90:836 | C_PTR: calls impure C_F_POINTER
│   │   ├── buffer2cptr_var [I] => shared
│   │   ├── get_shape [P] => shared
│   │   └── validate_var [P] => shared
│   ├── get_variable [I] => shared
│   ├── new_dim_len_int32 [E] => shared
│   ├── new_var_int32_2d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:1090 | C_PTR: calls impure C_F_POINTER
│   │   ├── buffer_size [P] => shared
│   │   └── init_var_ [I] => shared
│   ├── open_netcdf [I] => shared
│   └── to_netcdf_var [I] => shared
├── nasa_cosp_read [I] @ test/nc4f_test_cases_data.f90:176 | DEP
│   ├── close_netcdf [I] => shared
│   ├── extract_att_char_scalar [I] => shared
│   ├── extract_var_real64_1d [I] => shared
│   ├── get_att_grp [I] => shared
│   ├── get_att_var [I] => shared
│   ├── get_group [I] => shared
│   ├── get_variable [I] => shared
│   ├── inquire_group [I] => shared
│   ├── inquire_subgroups [I] => shared
│   ├── open_netcdf [I] => shared
│   └── write_frmt_netcdf [I] => shared
├── rename_att_errors [I] @ test/nc4f_test_cases_rename.f90:166 | ENV: process/environment intrinsic
│   ├── chk_rename [P] @ test/nc4f_test_cases_rename.f90:503
│   ├── close_netcdf [I] => shared
│   ├── eq_att [E] => shared
│   ├── get_att_grp [I] => shared
│   ├── get_atts_grp [I] => shared
│   ├── new_att_int32_scalar [E] => shared
│   ├── new_dim_len_int32 [E] => shared
│   ├── new_var_real32_1d [I] => shared
│   ├── open_netcdf [I] => shared
│   ├── rename_att_att [P] => shared
│   ├── rename_att_grp [P] => shared
│   ├── rename_att_nc_grp [I] => shared
│   ├── rename_att_nc_var [I] @ src/netcdf/nc4f_nc_attribute.f90:5 | DEP
│   │   ├── f2cstr [P] => shared
│   │   ├── handle_err [P] => shared
│   │   ├── has_err [E] => shared
│   │   ├── nc_inq_varid [X,I] => shared
│   │   ├── netcdf_err [I] => shared
│   │   ├── rename_att_nc_ [I] => shared
│   │   ├── rename_att_var [P] @ src/data_structure/nc4f_ds_attribute.f90:21
│   │   │   ├── rename_atts_ [P] => shared
│   │   │   └── return_err [P] => shared
│   │   └── rename_var_var [P] => shared
│   ├── rename_att_var [P] => shared
│   └── to_netcdf_var [I] => shared
├── rename_att_file [I] @ test/nc4f_test_cases_rename.f90:84 | DEP
│   ├── buffer2cptr_att [I] => shared
│   ├── chk_rename [P] => shared
│   ├── close_netcdf [I] => shared
│   ├── eq_att [E] => shared
│   ├── get_att_grp [I] => shared
│   ├── get_att_var [I] => shared
│   ├── get_atts_grp [I] => shared
│   ├── get_group [I] => shared
│   ├── get_variable [I] => shared
│   ├── new_att_character [P] => shared
│   ├── new_att_int32_scalar [E] => shared
│   ├── new_dataset_all [I] => shared
│   ├── new_dataset_vars [I] => shared
│   ├── new_dim_len_int32 [E] => shared
│   ├── new_var_real32_1d [I] => shared
│   ├── open_netcdf [I] => shared
│   ├── rename_att_nc_grp [I] => shared
│   ├── rename_att_nc_var [I] => shared
│   ├── rename_att_var [P] => shared
│   └── to_netcdf_grp [I] => shared
├── rename_att_model [I] @ test/nc4f_test_cases_rename.f90:8 | DEP
│   ├── buffer2cptr_att [I] => shared
│   ├── chk_rename [P] => shared
│   ├── eq_att [E] => shared
│   ├── init_att_mold [I] => shared
│   ├── new_att_character [P] => shared
│   ├── new_att_int32 [P] => shared
│   ├── new_dim_len_int32 [E] => shared
│   ├── new_var_real32_1d [I] => shared
│   ├── rename_att_att [P] => shared
│   ├── rename_att_grp [P] => shared
│   ├── rename_att_nc_grp [I] => shared
│   ├── rename_att_nc_var [I] => shared
│   ├── rename_att_var [P] => shared
│   └── rename_pure_model [P] @ test/nc4f_test_cases_rename.f90:71
│       ├── rename_att_att [P] => shared
│       ├── rename_att_grp [P] => shared
│       └── rename_att_var [P] => shared
├── rename_grp_errors [I] @ test/nc4f_test_cases_rename_group.f90:176 | ENV: process/environment intrinsic
│   ├── chk_grp [P] @ test/nc4f_test_cases_rename_group.f90:274
│   ├── close_netcdf [I] => shared
│   ├── get_group [I] => shared
│   ├── new_att_int32_scalar [E] => shared
│   ├── open_netcdf [I] => shared
│   ├── rename_att_att [P] => shared
│   ├── rename_grp_grp [P] => shared
│   ├── rename_grp_nc_grp [I] @ src/netcdf/nc4f_nc_group.f90:5 | DEP
│   │   ├── handle_err [P] => shared
│   │   ├── has_err [E] => shared
│   │   ├── rename_grp_grp [P] => shared
│   │   └── rename_grp_nc_ [I] => shared
│   ├── rename_grp_nc_par [I] => shared
│   └── to_netcdf_grp [I] => shared
├── rename_grp_file [I] @ test/nc4f_test_cases_rename_group.f90:92 | DEP
│   ├── buffer2cptr_var [I] => shared
│   ├── chk_grp [P] => shared
│   ├── close_netcdf [I] => shared
│   ├── eq_att [E] => shared
│   ├── eq_var [E] => shared
│   ├── get_att_grp [I] => shared
│   ├── get_group [I] => shared
│   ├── get_variable [I] => shared
│   ├── new_att_character [P] => shared
│   ├── new_dataset_vars [I] => shared
│   ├── new_dim_len_int32 [E] => shared
│   ├── new_var_real32_1d [I] => shared
│   ├── open_netcdf [I] => shared
│   ├── rename_grp_nc_grp [I] => shared
│   ├── rename_grp_nc_par [I] => shared
│   └── to_netcdf_grp [I] => shared
├── rename_grp_model [I] @ test/nc4f_test_cases_rename_group.f90:7 | DEP
│   ├── buffer2cptr_var [I] => shared
│   ├── chk_grp [P] => shared
│   ├── new_att_character [P] => shared
│   ├── new_dataset_vars [I] => shared
│   ├── new_dim_len_int32 [E] => shared
│   ├── new_var_real32_1d [I] => shared
│   ├── rename_grp_grp [P] => shared
│   ├── rename_grp_nc_grp [I] => shared
│   ├── rename_grp_nc_par [I] => shared
│   ├── rename_grp_par [P] => shared
│   └── rename_grp_pure [P] @ test/nc4f_test_cases_rename_group.f90:85
│       ├── rename_grp_grp [P] => shared
│       └── rename_grp_par [P] => shared
├── rename_var_errors [I] @ test/nc4f_test_cases_rename.f90:401 | ENV: process/environment intrinsic
│   ├── chk_rename [P] => shared
│   ├── close_netcdf [I] => shared
│   ├── eq_var [E] => shared
│   ├── get_variable [I] => shared
│   ├── new_att_character [P] => shared
│   ├── new_att_int32_scalar [E] => shared
│   ├── new_dataset_grps [I] => shared
│   ├── new_dataset_vars [I] => shared
│   ├── new_dim_len_int32 [E] => shared
│   ├── new_var_real32_1d [I] => shared
│   ├── open_netcdf [I] => shared
│   ├── rename_att_att [P] => shared
│   ├── rename_var_grp [P] => shared
│   ├── rename_var_nc_grp [I] => shared
│   ├── rename_var_nc_var [I] @ src/netcdf/nc4f_nc_variable.f90:5 | DEP
│   │   ├── handle_err [P] => shared
│   │   ├── has_err [E] => shared
│   │   ├── rename_var_nc_ [I] => shared
│   │   └── rename_var_var [P] => shared
│   ├── rename_var_var [P] => shared
│   └── to_netcdf_grp [I] => shared
├── rename_var_file [I] @ test/nc4f_test_cases_rename.f90:329 | DEP
│   ├── buffer2cptr_var [I] => shared
│   ├── chk_rename [P] => shared
│   ├── close_netcdf [I] => shared
│   ├── eq_var [E] => shared
│   ├── get_group [I] => shared
│   ├── get_variable [I] => shared
│   ├── inquire_variable [I] => shared
│   ├── new_att_character [P] => shared
│   ├── new_dataset_all [I] => shared
│   ├── new_dataset_vars [I] => shared
│   ├── new_dim_len_int32 [E] => shared
│   ├── new_var_real32_1d [I] => shared
│   ├── open_netcdf [I] => shared
│   ├── rename_var_grp [P] => shared
│   ├── rename_var_nc_grp [I] => shared
│   ├── rename_var_nc_var [I] => shared
│   └── to_netcdf_grp [I] => shared
├── rename_var_model [I] @ test/nc4f_test_cases_rename.f90:258 | DEP
│   ├── buffer2cptr_var [I] => shared
│   ├── chk_rename [P] => shared
│   ├── eq_att [E] => shared
│   ├── eq_var [E] => shared
│   ├── init_var_mold [I] => shared
│   ├── new_att_character [P] => shared
│   ├── new_dataset_all [I] => shared
│   ├── new_dataset_vars [I] => shared
│   ├── new_dim_len_int32 [E] => shared
│   ├── new_var_real32_1d [I] => shared
│   ├── rename_var_grp [P] => shared
│   ├── rename_var_nc_grp [I] => shared
│   ├── rename_var_nc_var [I] => shared
│   ├── rename_var_pure [P] @ test/nc4f_test_cases_rename.f90:320
│   │   ├── rename_var_grp [P] => shared
│   │   └── rename_var_var [P] => shared
│   └── rename_var_var [P] => shared
├── sample_uddtio [I] @ test/nc4f_test_cases_data.f90:406 | DEP
│   └── render_sample_uddtio_ [I] @ test/nc4f_test_cases_data.f90:451 | DEP
│       ├── close_netcdf [I] => shared
│       ├── has_err [E] => shared
│       ├── inquire_group [I] => shared
│       ├── open_netcdf [I] => shared
│       └── write_frmt_netcdf [I] => shared
├── sfc_pres_temp_rd [I] @ test/nc4f_test_cases_data.f90:67 | DEP
│   ├── close_netcdf [I] => shared
│   ├── eq_att [E] => shared
│   ├── eq_dim [E] => shared
│   ├── extract_att_char_scalar [I] => shared
│   ├── get_variable [I] => shared
│   ├── has_err [E] => shared
│   ├── inquire_variable [I] => shared
│   ├── new_att_character [P] => shared
│   ├── new_dim_len_int32 [E] => shared
│   └── open_netcdf [I] => shared
├── sfc_pres_temp_wr [I] @ test/nc4f_test_cases_data.f90:31 | DEP
│   ├── new_att_character [P] => shared
│   ├── new_dim_len_int32 [E] => shared
│   ├── new_var_real32_1d [I] => shared
│   ├── new_var_real32_2d [I] => shared
│   └── to_netcdf_var [I] => shared
├── simple_rd [I] @ test/nc4f_test_cases_basic.f90:26 | DEP
│   ├── close_netcdf [I] => shared
│   ├── eq_dim [E] => shared
│   ├── has_err [E] => shared
│   ├── inquire_variable [I] => shared
│   ├── new_dim_len_int32 [E] => shared
│   ├── open_netcdf [I] => shared
│   └── write_frmt_var [I] @ src/data_structure/nc4f_ds_io.f90:63 | IO: external-unit formatted WRITE
│       └── render_var [I] => shared
├── simple_wr [I] @ test/nc4f_test_cases_basic.f90:7 | DEP
│   ├── new_dim_len_int32 [E] => shared
│   ├── new_var_real32_2d [I] => shared
│   ├── to_netcdf_var [I] => shared
│   └── write_frmt_var [I] => shared
├── sresa1b_ccsm3_read [I] @ test/nc4f_test_cases_data.f90:345 | DEP
│   ├── close_netcdf [I] => shared
│   ├── extract_att_char_scalar [I] => shared
│   ├── extract_var_real32_3d [I] => shared
│   ├── get_att_grp [I] => shared
│   ├── get_att_var [I] => shared
│   ├── get_variable [I] => shared
│   ├── has_dim [P] => shared
│   ├── inquire_group [I] => shared
│   ├── inquire_subgroups [I] => shared
│   ├── open_netcdf [I] => shared
│   └── starts_with [P] => shared
├── sum_vars_test [I] @ test/nc4f_test_cases_data.f90:7 | DEP
│   ├── eq_dim [E] => shared
│   ├── extract_var_real64_2d [I] @ src/data_structure/nc4f_ds_extract.f90:1691 | C_PTR: calls impure C_F_POINTER
│   │   ├── buffer2cptr_var [I] => shared
│   │   ├── get_shape [P] => shared
│   │   └── validate_var [P] => shared
│   ├── new_dim_len_int32 [E] => shared
│   ├── new_var_real64_2d [I] @ src/data_structure/nc4f_ds_variable_constructor.f90:2665 | C_PTR: calls impure C_F_POINTER
│   │   ├── buffer_size [P] => shared
│   │   └── init_var_ [I] => shared
│   └── sum_vars [I] => shared
├── tos_o1_read [I] @ test/nc4f_test_cases_data.f90:601 | DEP
│   ├── close_netcdf [I] => shared
│   ├── extract_att_char_scalar [I] => shared
│   ├── extract_var_real32_3d [I] => shared
│   ├── get_att_grp [I] => shared
│   ├── get_att_var [I] => shared
│   ├── get_variable [I] => shared
│   ├── has_dim [P] => shared
│   ├── inquire_group [I] => shared
│   ├── inquire_subgroups [I] => shared
│   └── open_netcdf [I] => shared
├── unlimited_dims [I] @ test/nc4f_test_cases_io.f90:29 | DEP
│   ├── close_netcdf [I] => shared
│   ├── eq_dim [E] => shared
│   ├── get_variable [I] => shared
│   ├── new_dim_len_int32 [E] => shared
│   ├── new_var_int32_2d [I] => shared
│   ├── open_netcdf [I] => shared
│   └── to_netcdf_var [I] => shared
└── unlimited_wr [I] @ test/nc4f_test_cases_io.f90:7 | DEP
    ├── close_netcdf [I] => shared
    ├── eq_dim [E] => shared
    ├── extract_var_int32_2d [I] => shared
    ├── get_variable [I] => shared
    ├── new_dim_len_int32 [E] => shared
    ├── new_var_int32_2d [I] => shared
    ├── open_netcdf [I] => shared
    └── to_netcdf_var [I] => shared

c_malloc [X,I] @ src/c_interface/nc4f_c_interface.f90:498 | EXT: external C implementation; no audited PURE contract

nc_get_att_schar [X,I] @ src/c_interface/nc4f_c_interface_attribute.inc:256 | EXT: external C implementation; no audited PURE contract

nc_put_att_schar [X,I] @ src/c_interface/nc4f_c_interface_attribute.inc:278 | EXT: external C implementation; no audited PURE contract

nc_get_att_short [X,I] @ src/c_interface/nc4f_c_interface_attribute.inc:304 | EXT: external C implementation; no audited PURE contract

nc_put_att_short [X,I] @ src/c_interface/nc4f_c_interface_attribute.inc:326 | EXT: external C implementation; no audited PURE contract

nc_get_att_int [X,I] @ src/c_interface/nc4f_c_interface_attribute.inc:352 | EXT: external C implementation; no audited PURE contract

nc_put_att_int [X,I] @ src/c_interface/nc4f_c_interface_attribute.inc:374 | EXT: external C implementation; no audited PURE contract

nc_get_att_long [X,I] @ src/c_interface/nc4f_c_interface_attribute.inc:400 | EXT: external C implementation; no audited PURE contract

nc_put_att_long [X,I] @ src/c_interface/nc4f_c_interface_attribute.inc:422 | EXT: external C implementation; no audited PURE contract

nc_get_att_longlong [X,I] @ src/c_interface/nc4f_c_interface_attribute.inc:448 | EXT: external C implementation; no audited PURE contract

nc_put_att_longlong [X,I] @ src/c_interface/nc4f_c_interface_attribute.inc:470 | EXT: external C implementation; no audited PURE contract

nc_get_att_float [X,I] @ src/c_interface/nc4f_c_interface_attribute.inc:496 | EXT: external C implementation; no audited PURE contract

nc_put_att_float [X,I] @ src/c_interface/nc4f_c_interface_attribute.inc:518 | EXT: external C implementation; no audited PURE contract

ncattput [X,I] @ src/c_interface/nc4f_c_interface_attribute.inc:684 | EXT: external C implementation; no audited PURE contract

ncattinq [X,I] @ src/c_interface/nc4f_c_interface_attribute.inc:707 | EXT: external C implementation; no audited PURE contract

ncattget [X,I] @ src/c_interface/nc4f_c_interface_attribute.inc:727 | EXT: external C implementation; no audited PURE contract

ncattcopy [X,I] @ src/c_interface/nc4f_c_interface_attribute.inc:745 | EXT: external C implementation; no audited PURE contract

ncattname [X,I] @ src/c_interface/nc4f_c_interface_attribute.inc:765 | EXT: external C implementation; no audited PURE contract

ncattrename [X,I] @ src/c_interface/nc4f_c_interface_attribute.inc:783 | EXT: external C implementation; no audited PURE contract

ncattdel [X,I] @ src/c_interface/nc4f_c_interface_attribute.inc:801 | EXT: external C implementation; no audited PURE contract

nc_def_user_format [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:273 | EXT: external C implementation; no audited PURE contract

nc_inq_user_format [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:292 | EXT: external C implementation; no audited PURE contract

nc_set_alignment [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:309 | EXT: external C implementation; no audited PURE contract

nc_get_alignment [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:323 | EXT: external C implementation; no audited PURE contract

nc_set_meta_block_size [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:337 | EXT: external C implementation; no audited PURE contract

nc_get_meta_block_size [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:349 | EXT: external C implementation; no audited PURE contract

nc__create [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:361 | EXT: external C implementation; no audited PURE contract

nc__open [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:382 | EXT: external C implementation; no audited PURE contract

nc_set_default_format [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:400 | EXT: external C implementation; no audited PURE contract

nc__enddef [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:414 | EXT: external C implementation; no audited PURE contract

nc_show_metadata [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:435 | EXT: external C implementation; no audited PURE contract

nc_delete [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:447 | EXT: external C implementation; no audited PURE contract

ncopen [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:473 | EXT: external C implementation; no audited PURE contract

ncsetfill [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:487 | EXT: external C implementation; no audited PURE contract

ncredef [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:501 | EXT: external C implementation; no audited PURE contract

ncsync [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:525 | EXT: external C implementation; no audited PURE contract

ncabort [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:537 | EXT: external C implementation; no audited PURE contract

ncinquire [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:561 | EXT: external C implementation; no audited PURE contract

nc_initialize [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:581 | EXT: external C implementation; no audited PURE contract

nc_finalize [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:592 | EXT: external C implementation; no audited PURE contract

nc_plugin_path_ndirs [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:702 | EXT: external C implementation; no audited PURE contract

nc_plugin_path_get [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:714 | EXT: external C implementation; no audited PURE contract

nc_plugin_path_set [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:728 | EXT: external C implementation; no audited PURE contract

ncaux_plugin_path_parsen [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:740 | EXT: external C implementation; no audited PURE contract

ncaux_plugin_path_reclaim [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:804 | EXT: external C implementation; no audited PURE contract

ncaux_plugin_path_append [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:817 | EXT: external C implementation; no audited PURE contract

ncaux_plugin_path_prepend [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:831 | EXT: external C implementation; no audited PURE contract

ncaux_plugin_path_stringlen [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:845 | EXT: external C implementation; no audited PURE contract

ncaux_plugin_path_stringget [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:853 | EXT: external C implementation; no audited PURE contract

ncaux_plugin_path_stringset [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:867 | EXT: external C implementation; no audited PURE contract

ncaux_parse_provenance [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:881 | EXT: external C implementation; no audited PURE contract

nc_ro_create [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:896 | EXT: external C implementation; no audited PURE contract

nc_ro_redef [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:925 | EXT: external C implementation; no audited PURE contract

nc_ro__enddef [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:938 | EXT: external C implementation; no audited PURE contract

nc_ro_sync [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:960 | EXT: external C implementation; no audited PURE contract

nc_ro_def_var_fill [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:973 | EXT: external C implementation; no audited PURE contract

nc_ro_rename_att [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:992 | EXT: external C implementation; no audited PURE contract

nc_ro_del_att [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:1011 | EXT: external C implementation; no audited PURE contract

nc_ro_put_att [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:1028 | EXT: external C implementation; no audited PURE contract

nc_ro_def_var [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:1054 | EXT: external C implementation; no audited PURE contract

nc_ro_rename_var [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:1078 | EXT: external C implementation; no audited PURE contract

nc_ro_put_vara [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:1095 | EXT: external C implementation; no audited PURE contract

nc_ro_def_dim [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:1119 | EXT: external C implementation; no audited PURE contract

nc_ro_rename_dim [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:1138 | EXT: external C implementation; no audited PURE contract

nc_ro_set_fill [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:1155 | EXT: external C implementation; no audited PURE contract

nc_notnc4_def_grp [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:1172 | EXT: external C implementation; no audited PURE contract

nc_notnc4_rename_grp [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:1189 | EXT: external C implementation; no audited PURE contract

nc_notnc4_def_compound [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:1204 | EXT: external C implementation; no audited PURE contract

nc_notnc4_insert_compound [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:1223 | EXT: external C implementation; no audited PURE contract

nc_notnc4_insert_array_compound [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:1244 | EXT: external C implementation; no audited PURE contract

nc_notnc4_inq_typeid [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:1271 | EXT: external C implementation; no audited PURE contract

nc_notnc4_inq_compound_field [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:1288 | EXT: external C implementation; no audited PURE contract

nc_notnc4_inq_compound_fieldindex [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:1317 | EXT: external C implementation; no audited PURE contract

nc_notnc4_def_vlen [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:1337 | EXT: external C implementation; no audited PURE contract

nc_notnc4_put_vlen_element [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:1356 | EXT: external C implementation; no audited PURE contract

nc_notnc4_get_vlen_element [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:1377 | EXT: external C implementation; no audited PURE contract

nc_notnc4_def_enum [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:1398 | EXT: external C implementation; no audited PURE contract

nc_notnc4_insert_enum [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:1417 | EXT: external C implementation; no audited PURE contract

nc_notnc4_inq_enum_member [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:1436 | EXT: external C implementation; no audited PURE contract

nc_notnc4_inq_enum_ident [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:1457 | EXT: external C implementation; no audited PURE contract

nc_notnc4_def_opaque [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:1476 | EXT: external C implementation; no audited PURE contract

nc_notnc4_def_var_deflate [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:1495 | EXT: external C implementation; no audited PURE contract

nc_notnc4_def_var_fletcher32 [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:1516 | EXT: external C implementation; no audited PURE contract

nc_notnc4_def_var_chunking [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:1533 | EXT: external C implementation; no audited PURE contract

nc_notnc4_def_var_endian [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:1552 | EXT: external C implementation; no audited PURE contract

nc_notnc4_set_var_chunk_cache [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:1569 | EXT: external C implementation; no audited PURE contract

nc_notnc4_get_var_chunk_cache [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:1591 | EXT: external C implementation; no audited PURE contract

nc_notnc4_inq_ncid [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:1613 | EXT: external C implementation; no audited PURE contract

nc_notnc4_inq_grps [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:1630 | EXT: external C implementation; no audited PURE contract

nc_notnc4_inq_grpname [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:1647 | EXT: external C implementation; no audited PURE contract

nc_notnc4_inq_grpname_full [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:1662 | EXT: external C implementation; no audited PURE contract

nc_notnc4_inq_grp_parent [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:1679 | EXT: external C implementation; no audited PURE contract

nc_notnc4_inq_grp_full_ncid [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:1694 | EXT: external C implementation; no audited PURE contract

nc_notnc4_inq_varids [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:1711 | EXT: external C implementation; no audited PURE contract

nc_notnc4_inq_dimids [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:1728 | EXT: external C implementation; no audited PURE contract

nc_notnc4_inq_typeids [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:1747 | EXT: external C implementation; no audited PURE contract

nc_notnc4_inq_user_type [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:1764 | EXT: external C implementation; no audited PURE contract

nc_notnc4_def_var_quantize [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:1790 | EXT: external C implementation; no audited PURE contract

nc_notnc4_inq_var_quantize [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:1809 | EXT: external C implementation; no audited PURE contract

nc_notnc3_get_varm [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:1828 | EXT: external C implementation; no audited PURE contract

nc_notnc3_put_varm [X,I] @ src/c_interface/nc4f_c_interface_dataset.inc:1858 | EXT: external C implementation; no audited PURE contract

nc_inq_unlimdim [X,I] @ src/c_interface/nc4f_c_interface_dimension.inc:77 | EXT: external C implementation; no audited PURE contract

ncdimid [X,I] @ src/c_interface/nc4f_c_interface_dimension.inc:192 | EXT: external C implementation; no audited PURE contract

ncdiminq [X,I] @ src/c_interface/nc4f_c_interface_dimension.inc:206 | EXT: external C implementation; no audited PURE contract

ncdimrename [X,I] @ src/c_interface/nc4f_c_interface_dimension.inc:224 | EXT: external C implementation; no audited PURE contract

nc_inq_grpname_full [X,I] @ src/c_interface/nc4f_c_interface_group.inc:70 | EXT: external C implementation; no audited PURE contract

nc_inq_grp_parent [X,I] @ src/c_interface/nc4f_c_interface_group.inc:88 | EXT: external C implementation; no audited PURE contract

nc_inq_grp_full_ncid [X,I] @ src/c_interface/nc4f_c_interface_group.inc:103 | EXT: external C implementation; no audited PURE contract

nc_inq_grp_ncid [X,I] @ src/c_interface/nc4f_c_interface_group.inc:154 | EXT: external C implementation; no audited PURE contract

nc_put_vars [X,I] @ src/c_interface/nc4f_c_interface_io.inc:112 | EXT: external C implementation; no audited PURE contract

nc_get_var_schar [X,I] @ src/c_interface/nc4f_c_interface_io.inc:142 | EXT: external C implementation; no audited PURE contract

nc_get_vara_schar [X,I] @ src/c_interface/nc4f_c_interface_io.inc:161 | EXT: external C implementation; no audited PURE contract

nc_get_vars_schar [X,I] @ src/c_interface/nc4f_c_interface_io.inc:187 | EXT: external C implementation; no audited PURE contract

nc_put_var_schar [X,I] @ src/c_interface/nc4f_c_interface_io.inc:217 | EXT: external C implementation; no audited PURE contract

nc_put_vara_schar [X,I] @ src/c_interface/nc4f_c_interface_io.inc:237 | EXT: external C implementation; no audited PURE contract

nc_put_vars_schar [X,I] @ src/c_interface/nc4f_c_interface_io.inc:264 | EXT: external C implementation; no audited PURE contract

nc_get_var_short [X,I] @ src/c_interface/nc4f_c_interface_io.inc:295 | EXT: external C implementation; no audited PURE contract

nc_get_vara_short [X,I] @ src/c_interface/nc4f_c_interface_io.inc:314 | EXT: external C implementation; no audited PURE contract

nc_get_vars_short [X,I] @ src/c_interface/nc4f_c_interface_io.inc:340 | EXT: external C implementation; no audited PURE contract

nc_put_var_short [X,I] @ src/c_interface/nc4f_c_interface_io.inc:370 | EXT: external C implementation; no audited PURE contract

nc_put_vara_short [X,I] @ src/c_interface/nc4f_c_interface_io.inc:390 | EXT: external C implementation; no audited PURE contract

nc_put_vars_short [X,I] @ src/c_interface/nc4f_c_interface_io.inc:417 | EXT: external C implementation; no audited PURE contract

nc_get_vara_int [X,I] @ src/c_interface/nc4f_c_interface_io.inc:467 | EXT: external C implementation; no audited PURE contract

nc_put_vara_int [X,I] @ src/c_interface/nc4f_c_interface_io.inc:543 | EXT: external C implementation; no audited PURE contract

nc_get_var_long [X,I] @ src/c_interface/nc4f_c_interface_io.inc:601 | EXT: external C implementation; no audited PURE contract

nc_get_vara_long [X,I] @ src/c_interface/nc4f_c_interface_io.inc:620 | EXT: external C implementation; no audited PURE contract

nc_get_vars_long [X,I] @ src/c_interface/nc4f_c_interface_io.inc:646 | EXT: external C implementation; no audited PURE contract

nc_put_var_long [X,I] @ src/c_interface/nc4f_c_interface_io.inc:676 | EXT: external C implementation; no audited PURE contract

nc_put_vara_long [X,I] @ src/c_interface/nc4f_c_interface_io.inc:696 | EXT: external C implementation; no audited PURE contract

nc_put_vars_long [X,I] @ src/c_interface/nc4f_c_interface_io.inc:723 | EXT: external C implementation; no audited PURE contract

nc_get_var_longlong [X,I] @ src/c_interface/nc4f_c_interface_io.inc:754 | EXT: external C implementation; no audited PURE contract

nc_get_vars_longlong [X,I] @ src/c_interface/nc4f_c_interface_io.inc:799 | EXT: external C implementation; no audited PURE contract

nc_put_var_longlong [X,I] @ src/c_interface/nc4f_c_interface_io.inc:829 | EXT: external C implementation; no audited PURE contract

nc_put_vars_longlong [X,I] @ src/c_interface/nc4f_c_interface_io.inc:876 | EXT: external C implementation; no audited PURE contract

nc_get_vara_float [X,I] @ src/c_interface/nc4f_c_interface_io.inc:926 | EXT: external C implementation; no audited PURE contract

nc_get_vars_float [X,I] @ src/c_interface/nc4f_c_interface_io.inc:952 | EXT: external C implementation; no audited PURE contract

nc_put_var_float [X,I] @ src/c_interface/nc4f_c_interface_io.inc:982 | EXT: external C implementation; no audited PURE contract

nc_put_vara_float [X,I] @ src/c_interface/nc4f_c_interface_io.inc:1002 | EXT: external C implementation; no audited PURE contract

nc_put_vars_float [X,I] @ src/c_interface/nc4f_c_interface_io.inc:1029 | EXT: external C implementation; no audited PURE contract

nc_get_vara_double [X,I] @ src/c_interface/nc4f_c_interface_io.inc:1079 | EXT: external C implementation; no audited PURE contract

nc_get_vars_double [X,I] @ src/c_interface/nc4f_c_interface_io.inc:1105 | EXT: external C implementation; no audited PURE contract

nc_put_var_double [X,I] @ src/c_interface/nc4f_c_interface_io.inc:1135 | EXT: external C implementation; no audited PURE contract

nc_put_vara_double [X,I] @ src/c_interface/nc4f_c_interface_io.inc:1155 | EXT: external C implementation; no audited PURE contract

nc_put_vars_double [X,I] @ src/c_interface/nc4f_c_interface_io.inc:1182 | EXT: external C implementation; no audited PURE contract

nc_get_vara_text [X,I] @ src/c_interface/nc4f_c_interface_io.inc:1231 | EXT: external C implementation; no audited PURE contract

nc_get_vars_text [X,I] @ src/c_interface/nc4f_c_interface_io.inc:1256 | EXT: external C implementation; no audited PURE contract

nc_put_vara_text [X,I] @ src/c_interface/nc4f_c_interface_io.inc:1304 | EXT: external C implementation; no audited PURE contract

nc_put_vars_text [X,I] @ src/c_interface/nc4f_c_interface_io.inc:1330 | EXT: external C implementation; no audited PURE contract

nc_put_var1 [X,I] @ src/c_interface/nc4f_c_interface_io.inc:1572 | EXT: external C implementation; no audited PURE contract

nc_get_var1 [X,I] @ src/c_interface/nc4f_c_interface_io.inc:1591 | EXT: external C implementation; no audited PURE contract

nc_put_varm [X,I] @ src/c_interface/nc4f_c_interface_io.inc:1610 | EXT: external C implementation; no audited PURE contract

nc_get_varm [X,I] @ src/c_interface/nc4f_c_interface_io.inc:1639 | EXT: external C implementation; no audited PURE contract

nc_put_var1_text [X,I] @ src/c_interface/nc4f_c_interface_io.inc:1668 | EXT: external C implementation; no audited PURE contract

nc_get_var1_text [X,I] @ src/c_interface/nc4f_c_interface_io.inc:1687 | EXT: external C implementation; no audited PURE contract

nc_put_var1_schar [X,I] @ src/c_interface/nc4f_c_interface_io.inc:1706 | EXT: external C implementation; no audited PURE contract

nc_get_var1_schar [X,I] @ src/c_interface/nc4f_c_interface_io.inc:1725 | EXT: external C implementation; no audited PURE contract

nc_put_var1_short [X,I] @ src/c_interface/nc4f_c_interface_io.inc:1744 | EXT: external C implementation; no audited PURE contract

nc_get_var1_short [X,I] @ src/c_interface/nc4f_c_interface_io.inc:1763 | EXT: external C implementation; no audited PURE contract

nc_put_var1_int [X,I] @ src/c_interface/nc4f_c_interface_io.inc:1782 | EXT: external C implementation; no audited PURE contract

nc_get_var1_int [X,I] @ src/c_interface/nc4f_c_interface_io.inc:1801 | EXT: external C implementation; no audited PURE contract

nc_put_var1_long [X,I] @ src/c_interface/nc4f_c_interface_io.inc:1820 | EXT: external C implementation; no audited PURE contract

nc_get_var1_long [X,I] @ src/c_interface/nc4f_c_interface_io.inc:1839 | EXT: external C implementation; no audited PURE contract

nc_put_var1_float [X,I] @ src/c_interface/nc4f_c_interface_io.inc:1858 | EXT: external C implementation; no audited PURE contract

nc_get_var1_float [X,I] @ src/c_interface/nc4f_c_interface_io.inc:1877 | EXT: external C implementation; no audited PURE contract

nc_put_var1_longlong [X,I] @ src/c_interface/nc4f_c_interface_io.inc:1934 | EXT: external C implementation; no audited PURE contract

nc_get_var1_longlong [X,I] @ src/c_interface/nc4f_c_interface_io.inc:1953 | EXT: external C implementation; no audited PURE contract

nc_put_var1_string [X,I] @ src/c_interface/nc4f_c_interface_io.inc:1972 | EXT: external C implementation; no audited PURE contract

nc_get_var1_string [X,I] @ src/c_interface/nc4f_c_interface_io.inc:1992 | EXT: external C implementation; no audited PURE contract

nc_put_varm_text [X,I] @ src/c_interface/nc4f_c_interface_io.inc:2012 | EXT: external C implementation; no audited PURE contract

nc_get_varm_text [X,I] @ src/c_interface/nc4f_c_interface_io.inc:2041 | EXT: external C implementation; no audited PURE contract

nc_put_varm_schar [X,I] @ src/c_interface/nc4f_c_interface_io.inc:2070 | EXT: external C implementation; no audited PURE contract

nc_get_varm_schar [X,I] @ src/c_interface/nc4f_c_interface_io.inc:2099 | EXT: external C implementation; no audited PURE contract

nc_put_varm_short [X,I] @ src/c_interface/nc4f_c_interface_io.inc:2128 | EXT: external C implementation; no audited PURE contract

nc_get_varm_short [X,I] @ src/c_interface/nc4f_c_interface_io.inc:2157 | EXT: external C implementation; no audited PURE contract

nc_put_varm_long [X,I] @ src/c_interface/nc4f_c_interface_io.inc:2244 | EXT: external C implementation; no audited PURE contract

nc_get_varm_long [X,I] @ src/c_interface/nc4f_c_interface_io.inc:2273 | EXT: external C implementation; no audited PURE contract

nc_put_varm_float [X,I] @ src/c_interface/nc4f_c_interface_io.inc:2302 | EXT: external C implementation; no audited PURE contract

nc_get_varm_float [X,I] @ src/c_interface/nc4f_c_interface_io.inc:2331 | EXT: external C implementation; no audited PURE contract

nc_put_varm_double [X,I] @ src/c_interface/nc4f_c_interface_io.inc:2360 | EXT: external C implementation; no audited PURE contract

nc_get_varm_double [X,I] @ src/c_interface/nc4f_c_interface_io.inc:2389 | EXT: external C implementation; no audited PURE contract

nc_put_varm_longlong [X,I] @ src/c_interface/nc4f_c_interface_io.inc:2418 | EXT: external C implementation; no audited PURE contract

nc_get_varm_longlong [X,I] @ src/c_interface/nc4f_c_interface_io.inc:2448 | EXT: external C implementation; no audited PURE contract

nc_put_varm_string [X,I] @ src/c_interface/nc4f_c_interface_io.inc:2478 | EXT: external C implementation; no audited PURE contract

nc_get_varm_string [X,I] @ src/c_interface/nc4f_c_interface_io.inc:2508 | EXT: external C implementation; no audited PURE contract

nc_free_vlens [X,I] @ src/c_interface/nc4f_c_interface_io.inc:2538 | EXT: external C implementation; no audited PURE contract

nc_free_vlen [X,I] @ src/c_interface/nc4f_c_interface_io.inc:2554 | EXT: external C implementation; no audited PURE contract

nc_copy_data [X,I] @ src/c_interface/nc4f_c_interface_io.inc:2608 | EXT: external C implementation; no audited PURE contract

ncvarput1 [X,I] @ src/c_interface/nc4f_c_interface_io.inc:2652 | EXT: external C implementation; no audited PURE contract

ncvarget1 [X,I] @ src/c_interface/nc4f_c_interface_io.inc:2671 | EXT: external C implementation; no audited PURE contract

ncvarputs [X,I] @ src/c_interface/nc4f_c_interface_io.inc:2733 | EXT: external C implementation; no audited PURE contract

ncvargets [X,I] @ src/c_interface/nc4f_c_interface_io.inc:2757 | EXT: external C implementation; no audited PURE contract

ncvarputg [X,I] @ src/c_interface/nc4f_c_interface_io.inc:2781 | EXT: external C implementation; no audited PURE contract

ncvargetg [X,I] @ src/c_interface/nc4f_c_interface_io.inc:2808 | EXT: external C implementation; no audited PURE contract

ncrecinq [X,I] @ src/c_interface/nc4f_c_interface_io.inc:2835 | EXT: external C implementation; no audited PURE contract

ncrecget [X,I] @ src/c_interface/nc4f_c_interface_io.inc:2853 | EXT: external C implementation; no audited PURE contract

ncrecput [X,I] @ src/c_interface/nc4f_c_interface_io.inc:2869 | EXT: external C implementation; no audited PURE contract

ncaux_reclaim_data_all [X,I] @ src/c_interface/nc4f_c_interface_io.inc:2905 | EXT: external C implementation; no audited PURE contract

ncaux_copy_data_all [X,I] @ src/c_interface/nc4f_c_interface_io.inc:2947 | EXT: external C implementation; no audited PURE contract

ncaux_dump_data [X,I] @ src/c_interface/nc4f_c_interface_io.inc:2969 | EXT: external C implementation; no audited PURE contract

ncaux_writefile [X,I] @ src/c_interface/nc4f_c_interface_io.inc:3007 | EXT: external C implementation; no audited PURE contract

nc_inq_var [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:36 | EXT: external C implementation; no audited PURE contract

nc_inq_compound [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:597 | EXT: external C implementation; no audited PURE contract

nc_inq_compound_name [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:618 | EXT: external C implementation; no audited PURE contract

nc_inq_compound_size [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:634 | EXT: external C implementation; no audited PURE contract

nc_inq_compound_nfields [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:650 | EXT: external C implementation; no audited PURE contract

nc_inq_compound_fieldname [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:694 | EXT: external C implementation; no audited PURE contract

nc_inq_compound_fieldoffset [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:730 | EXT: external C implementation; no audited PURE contract

nc_inq_compound_fieldtype [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:748 | EXT: external C implementation; no audited PURE contract

nc_inq_compound_fieldndims [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:767 | EXT: external C implementation; no audited PURE contract

nc_inq_compound_fielddim_sizes [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:785 | EXT: external C implementation; no audited PURE contract

nc_inq_vlen [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:822 | EXT: external C implementation; no audited PURE contract

nc_inq_enum [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:905 | EXT: external C implementation; no audited PURE contract

nc_inq_enum_member [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:928 | EXT: external C implementation; no audited PURE contract

nc_inq_opaque [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:984 | EXT: external C implementation; no audited PURE contract

nc_def_var_szip [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:1039 | EXT: external C implementation; no audited PURE contract

nc_inq_var_szip [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:1057 | EXT: external C implementation; no audited PURE contract

nc_copy_var [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:1075 | EXT: external C implementation; no audited PURE contract

nctypelen [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:1093 | EXT: external C implementation; no audited PURE contract

ncvarid [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:1125 | EXT: external C implementation; no audited PURE contract

ncvarinq [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:1139 | EXT: external C implementation; no audited PURE contract

ncvarrename [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:1164 | EXT: external C implementation; no audited PURE contract

nc_def_var_bzip2 [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:1180 | EXT: external C implementation; no audited PURE contract

nc_inq_var_bzip2 [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:1196 | EXT: external C implementation; no audited PURE contract

nc_def_var_zstandard [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:1214 | EXT: external C implementation; no audited PURE contract

nc_inq_var_zstandard [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:1230 | EXT: external C implementation; no audited PURE contract

ncaux_inq_any_type [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:1248 | EXT: external C implementation; no audited PURE contract

ncaux_type_alignment [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:1274 | EXT: external C implementation; no audited PURE contract

ncaux_class_alignment [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:1290 | EXT: external C implementation; no audited PURE contract

ncaux_begin_compound [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:1304 | EXT: external C implementation; no audited PURE contract

ncaux_end_compound [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:1322 | EXT: external C implementation; no audited PURE contract

ncaux_abort_compound [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:1336 | EXT: external C implementation; no audited PURE contract

ncaux_add_field [X,I] @ src/c_interface/nc4f_c_interface_variable.inc:1348 | EXT: external C implementation; no audited PURE contract

mandelbrot [E] @ example/mandelbrot.f90:71
└── mandelbrot [E] => cycle
```

## Attribute deletion follow-up

The inventory above predates `delete_attribute`. Its new dependency paths are:

```text
del_att_var / del_att_grp [pure]
  del_atts_ [pure]
    chk_nc_name [pure]
  return_err [pure]
del_att_nc_var / del_att_nc_grp [impure]
  delete_attribute model overload [pure, when update_file is false]
  del_att_nc_ [impure]
    del_att_grp [pure, validates and reduces staged names]
    nc_del_att [impure C boundary]
    netcdf_err [impure]
  handle_err [pure]
```

`del_att_nc_var` also calls `rename_var_var` for pure variable-name validation,
`nc_inq_varid` to resolve the file variable, and `netcdf_err`. Both file wrappers
and their helper remain impure even when a particular invocation avoids file I/O.
The model routines move allocatable buffers and associate pointers from their
`intent(inout)` collections; they do not modify borrowed targets. The tests include
a pure caller (`del_pure`) of both public model overloads and a pure assertion
helper (`chk_del`). The two fail-fast test entry points remain impure because they
also use ordinary `STOP` to detect unexpected success.

## Shared optional-error handling follow-up

`return_err` now serves all 23 NetCDF wrappers that previously duplicated
`present(err)` branching and called `handle_err`. It remains pure and uses an
explicit `CALL`, preserving termination under release optimization. It also
retains the former `handle_err` fallback diagnostic when an error has no allocated
message. `handle_err` and its interface have been removed; references to it in
the historical forest above now resolve to `return_err`.

The helper is exported from the lower-level `nc4f_ds` module for use by
`nc4f_nc`, but remains private in both `nc4f_nc` and the high-level `nc4f` module.
Mandatory-error helpers still return errors to their callers, and constructors
and validation routines with unconditional contract checks keep their existing
termination behavior. No Fypp-generated optional-error wrappers need changing.

## Dimension renaming follow-up

The three new model overloads (`rename_dim_dim`, `rename_dim_var`, and
`rename_dim_grp`) are pure. They use the pure `chk_nc_name`, `return_err`, and
`rename_dims_` helpers. Collections are staged as dimension metadata only;
prepared names are committed through `move_alloc` without copying variable data.

The file overloads (`rename_dim_nc_dim`, `rename_dim_nc_grp`) remain impure through
`find_dim_nc_` (dimension inquiries) and `put_dim_name_` (`nc_rename_dim` and
`netcdf_err`). Their metadata staging and commit helpers (`stage_dim_grp_`,
`commit_dim_grp_`) are pure. The tests exercise all three public model overloads
from `pure_dim_calls`; their assertion helper `chk_dim` is pure as well.

## Structured error diagnostics follow-up

`error_type` now separates `fname` and `msg`. Its checked constructor
`make_err`, validator `check_err`, and public formatter `error_msg` are pure.
`return_err` validates both returned and terminating failures; the latter
uses `error_msg` for the `error stop` text. `write_frmt_err` uses the same
formatter but remains impure because it performs external I/O.

`netcdf_err` now takes `(status, fname, context)` with optional context and
constructs errors through the checked constructor. It and `netcdf_msg` remain
impure because they retrieve diagnostics from the NetCDF C library. The old
missing-message fallback described above is superseded by explicit rejection
of malformed failures. Default success results still need no allocated fields.
