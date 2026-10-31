# NC4F Roadmap

This roadmap tracks work on limitations listed under
[What NC4F Cannot Do](README.md#what-nc4f-cannot-do). It describes work needed
in the public `nc4f` interface, beyond the existing C bindings.

Effort estimates are provisional and include API design, implementation,
documentation, and tests. Unfinished features rated **Low–medium or easier are Planned**;
the others are **Under consideration**, without an implementation commitment.
The order below is a suggested progression, not a release schedule. Classic
NetCDF format support is excluded from this assessment.

## Feature assessment

| Feature | Estimated effort | Status | Remaining work |
| --- | --- | --- | --- |
| Rename attributes | Very low | Complete | Five `rename_attribute` overloads support model editing and explicit file updates, with tests and documented cache semantics. |
| Delete attributes | Very low | Complete | Four `delete_attribute` overloads support pure model removal and explicit file deletion, preserving surviving storage and invalidating cached attribute IDs after file updates. |
| Diskless I/O | Low | Planned | Expose diskless and persistence options through `open_netcdf`; test creation, opening, and close behavior. |
| Rename variables | Low–medium | Complete | Four `rename_variable` overloads support pure model editing and explicit file updates, using the shared name checker. |
| Rename groups | Low–medium | Complete | Four `rename_group` overloads support pure model editing and explicit file updates, with root protection and shared-child-cache semantics. |
| Rename dimensions | Low–medium | Complete | Five `rename_dimension` overloads support pure model editing and explicit file updates, synchronizing direct caches and rejecting inherited file targets. |
| Strided writes | Low–medium | Planned | Extend the private hyperslab writer with stride validation and expose a public write operation. |
| NetCDF-4 storage controls | Medium | Under consideration | Represent per-variable chunking, compression, shuffle/checksum, endianness, and fill settings; apply them before data writes and support inquiry and validation. |
| Multi-slab I/O | Medium | Under consideration | Compose slab operations and define result ordering, shapes, and partial-failure behavior. |
| Mapped I/O | Medium–high | Under consideration | Reconcile memory mappings with the contiguous buffer model; validate mappings and memory bounds. |
| In-memory file images | Medium–high | Under consideration | Define ownership and lifetime rules for importing and exporting file byte buffers. |
| Unsigned primitive types | Medium–high | Under consideration | Choose portable Fortran representations and extend constructors, extraction, arithmetic, and validation, including full-range unsigned 64-bit values. |
| NetCDF `STRING` | High | Under consideration | Add an owned string-array representation with C conversion, copying, and cleanup rules. |
| User-defined types | High–very high | Under consideration | Add type descriptions and serialization; enum/opaque types are smaller starting points than compound and variable-length types. |
| Parallel I/O | Very high | Under consideration | Add MPI interoperability, parallel-enabled dependencies, collective-operation rules, and multi-process tests. |
| Delete dimensions/variables/groups from files | High; separate project | Under consideration | Design a copy-and-rewrite operation with dependency handling; these are not ordinary public C deletion operations. |

## Milestones

### 1a. Attribute renaming — Complete

- [x] Define public operations for independent, variable, and group attributes.
- [x] Define explicit file updates and synchronization of the supplied cache only.
- [x] Implement wrappers with the existing optional-error convention.
- [x] Test persistence after reopening, missing names, name conflicts, and read-only access.
- [x] Document the operations and update the README limitation.

### 1b. Attribute deletion — Complete

- [x] Define model and file deletion operations consistent with `rename_attribute`.
- [x] Implement deletion with error handling and cache synchronization.
- [x] Test persistence, missing attributes, read-only access, and unchanged state on failure.
- [x] Document the operations and update the README limitation.

### 2. Diskless I/O

- [ ] Define diskless and persistence options for `open_netcdf`.
- [ ] Apply the appropriate flags when creating or opening a dataset.
- [ ] Test data access, persistence on close, and nonpersistent operation.
- [ ] Document lifecycle behavior and update the README limitation.

### 3a. Variable renaming — Complete

- [x] Define two pure model overloads and two explicit file-update overloads.
- [x] Share pure name validation with attribute renaming.
- [x] Preserve data, dimensions, attributes, IDs, and owned/borrowed storage.
- [x] Test persistence, subgroup scope, cache behavior, coordinate variables, and errors.
- [x] Document the operations and update the README limitation.

### 3b. Group renaming — Complete

- [x] Define two pure model overloads and two explicit file-update overloads.
- [x] Reuse shared name validation and model error handling.
- [x] Reject known root objects and limit name lookup to direct children.
- [x] Preserve group contents and document shared child-array aliases and independent snapshots.
- [x] Test persistence, nested groups, stale IDs, partial caches, root protection, and errors.
- [x] Document the operations and update the README limitation.

### 3c. Dimension renaming — Complete

- [x] Define public rename operations and metadata-refresh semantics.
- [x] Synchronize direct dimension references; document explicit refresh of descendant caches.
- [x] Implement wrappers and error propagation.
- [x] Test persistence after reopening, shared dimensions, and failure cases.
- [x] Document the operations and update the README limitation.

### 4. Strided writes

- [ ] Define a public write operation for an existing variable.
- [ ] Extend the hyperslab writer with Fortran-order stride conversion and validation.
- [ ] Preserve contiguous-write behavior and support unlimited-dimension growth.
- [ ] Test multidimensional writes, untouched values, append behavior, and invalid selections.
- [ ] Document the operation and update the README limitation.

A milestone is complete when its operations are available through `use nc4f`,
the relevant tests pass, and the documentation describes the supported scope.
Completing one feature should narrow the corresponding README limitation;
it should not remove limitations for related features that remain unsupported.

## Implementation notes

- **Existing bindings are a foundation, not complete public support.** The
  C-binding tests already exercise storage controls, strings, user-defined
  types, mapped access, and in-memory file images. High-level integration still
  needs API and data-model decisions.
- **Strided writes can reuse existing code.** The private `put_vara` routine
  handles dimension reversal, type/rank checks, fixed bounds, and unlimited
  dimensions. `get_variable` already implements stride conversion.
- **Custom fill values may already work through attributes.** The serializer
  writes variable attributes before data, so a scalar, matching-type
  `_FillValue` appears usable through the existing attribute path. Verify this
  with a focused test before treating it as missing functionality.
- **Diskless I/O and file-image I/O are separate milestones.** Diskless mode
  primarily adds open/create flags; file-image support also needs explicit
  buffer ownership and lifetime rules.
- **Attribute deletion differs from object deletion.** Attribute deletion has
  a direct C API. Removing dimensions, variables, or groups from a file needs
  a separate rewrite design.

## References

- [NetCDF attribute operations](https://docs.unidata.ucar.edu/netcdf-c/current/group__attributes.html)
- [NetCDF dataset operations and storage-definition rules](https://docs.unidata.ucar.edu/netcdf-c/current/group__datasets.html)
- [NetCDF attribute conventions, including `_FillValue`](https://docs.unidata.ucar.edu/netcdf-c/current/attribute_conventions.html)
