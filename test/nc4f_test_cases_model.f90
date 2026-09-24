!> Public data-model integration checks.
submodule(nc4f_test_cases) nc4f_test_cases_model

use, intrinsic :: iso_c_binding, only: c_associated, c_loc
use, intrinsic :: iso_fortran_env, only: int64, real32
implicit none (type, external)

contains

!> Execute `data_model`.
module subroutine data_model(passed)
  !> Input/output argument: `passed`.
  logical, intent(inout) :: passed
  type(attribute_type) :: atts(1), cloned_att
  type(dimension_type) :: dim
  type(group_type) :: attrs_only, child, deep_grp, empty, group_only, grp, &
    & leaf, restored_child
  type(group_type) :: child_grps(1), leaf_grps(1)
  type(netcdf_type) :: nc, nc_copy
  type(variable_type) :: borrowed_var, cloned_var, owned_var, restored_var, &
    & sum_var, vars(1)
  type(error_type) :: err
  real(real32), allocatable, target :: values(:, :)
  real(real32), pointer :: extracted(:, :), sum_values(:)
  real, pointer :: restored_values(:)
  integer(int64), allocatable :: extents(:)
  character(len=256) :: iomsg, line
  integer :: iostat, unit
  logical :: netcdf_found

  passed = .false.
  dim%name = "sample"
  dim%len = 3
  nc%filename = "model.nc"
  nc_copy = nc
  if (dim%len /= 3 .or. nc%filename /= "model.nc" .or. &
    & nc_copy%filename /= "model.nc") return

  atts(1) = "units".att."K"
  vars(1) = datarray("temperature", [273.0, 274.0], ["x".dim.2], atts=atts)
  allocate (values(2, 2), source=reshape([ &
    & 1.0_real32, 2.0_real32, 3.0_real32, 4.0_real32], [2, 2]))
  owned_var = datarray("owned", values, ["x".dim.2, "y".dim.2], deep=.true.)
  borrowed_var = datarray("borrowed", values, &
    & ["x".dim.2, "y".dim.2], deep=.false.)
  if (.not. allocated(owned_var%buffer) .or. associated(owned_var%ptr)) return
  if (allocated(borrowed_var%buffer) .or. .not. associated(borrowed_var%ptr)) return
  if (.not. c_associated(c_loc(borrowed_var%ptr(1)), &
    & c_loc(values(1, 1)))) return
  if (.not. is_contiguous(owned_var%buffer) .or. &
    & .not. is_contiguous(borrowed_var%ptr)) return
  call extract(borrowed_var, extracted)
  if (.not. c_associated(c_loc(extracted(1, 1)), c_loc(values(1, 1)))) return

  empty = dataset("empty")
  attrs_only = dataset("attrs", atts=[atts(1)])
  leaf = dataset("leaf", [vars(1)])
  leaf_grps(1) = leaf
  child = dataset("child", [vars(1)], leaf_grps, [atts(1)])
  child_grps(1) = child
  group_only = dataset("groups", child_grps, [atts(1)])
  grp = dataset("root", [vars(1)], child_grps, [atts(1)])
  deep_grp = dataset("deep", [borrowed_var], child_grps, [atts(1)], deep=.true.)
  if (.not. allocated(deep_grp%vars(1)%buffer) .or. &
    & associated(deep_grp%vars(1)%ptr)) return
  if (.not. associated(grp%grps(1)%grps, child%grps)) return
  if (.not. allocated(grp%vars(1)%buffer) .or. &
    & associated(grp%vars(1)%ptr)) return
  if (associated(deep_grp%grps(1)%grps, child%grps)) return

  dim = "time".dim. (0 .and. .true.)
  if (.not. dim%is_unlim .or. dim%len /= 0) return
  call initialize(cloned_att, "copied_units", mold=atts(1))
  if (cloned_att%name /= "copied_units" .or. &
    & cloned_att%dtype /= atts(1)%dtype .or. cloned_att%len /= atts(1)%len) return
  if (.not. allocated(cloned_att%buffer) .or. associated(cloned_att%ptr)) return
  call initialize(cloned_var, "copied_temperature", vars(1), deep=.false.)
  if (cloned_var%name /= "copied_temperature" .or. &
    & cloned_var%dtype /= vars(1)%dtype .or. cloned_var%len /= vars(1)%len .or. &
    & .not. all(cloned_var%dims == vars(1)%dims) .or. &
    & allocated(cloned_var%atts) .or. allocated(cloned_var%buffer) .or. &
    & associated(cloned_var%ptr)) return
  call initialize(cloned_var, "copied_temperature", vars(1), atts=atts)
  if (.not. allocated(cloned_var%atts) .or. &
    & .not. all(cloned_var%atts == atts) .or. .not. allocated(cloned_var%buffer)) return
  if (.not. (owned_var == owned_var) .or. owned_var == borrowed_var) return
  if (size(owned_var) /= 4 .or. size(owned_var, 1) /= 2) return
  extents = shape(owned_var)
  if (any(extents /= [2_int64, 2_int64])) return
  sum_var = sum([vars(1), vars(1)])
  call extract(sum_var, sum_values)
  if (any(abs(sum_values - [546.0_real32, 548.0_real32]) > &
    & epsilon(1.0_real32))) return

  err%code = NC_ENOTFOUND
  if (.not. .exists.err) return
  err = error_type()
  open (newunit=unit, status="scratch", action="readwrite", &
    & form="formatted", iostat=iostat, iomsg=iomsg)
  if (iostat /= 0) return
  write (unit, *, iostat=iostat, iomsg=iomsg) err
  if (iostat /= 0) return
  write (unit, *, iostat=iostat, iomsg=iomsg) grp
  if (iostat /= 0) return
  write (unit, *, iostat=iostat, iomsg=iomsg) nc
  if (iostat /= 0) return
  rewind (unit)
  read (unit, "(a)", iostat=iostat, iomsg=iomsg) line
  if (iostat /= 0 .or. index(line, "NetCDF status (0)") == 0) return
  read (unit, "(a)", iostat=iostat, iomsg=iomsg) line
  if (iostat /= 0 .or. index(line, "group: root {") == 0) return
  netcdf_found = .false.
  do
    read (unit, "(a)", iostat=iostat, iomsg=iomsg) line
    if (iostat /= 0) exit
    if (index(line, "netcdf model {") == 0) cycle
    netcdf_found = .true.
    exit
  end do
  close (unit)
  if (.not. netcdf_found) return

  call to_netcdf(TEST_RESULTS_DIR//"data_model.nc", grp, err=err)
  if (err%code /= NC_NOERR) return
  nc = open_netcdf(TEST_RESULTS_DIR//"data_model.nc", err=err)
  if (err%code /= NC_NOERR) return
  call inquire_group(nc, inq_dims=.true., inq_atts=.true., &
    & inq_vars=.true., inq_subgrps=.true., recursive=.true., err=err)
  if (err%code /= NC_NOERR) return
  restored_child = get_group(nc, "child", err)
  if (err%code /= NC_NOERR) return
  restored_var = get_variable(nc, "temperature", err=err)
  if (err%code /= NC_NOERR) return
  call extract(restored_var, restored_values)
  if (size(nc%vars) /= 1 .or. size(nc%atts) /= 1 .or. &
    & .not. associated(nc%grps) .or. size(nc%grps) /= 1 .or. &
    & restored_child%name /= "child" .or. &
    & any(abs(restored_values - [273.0, 274.0]) > epsilon(1.0))) then
    call close_netcdf(nc)
    return
  end if
  call close_netcdf(nc, err)
  if (err%code /= NC_NOERR) return
  passed = .true.
end subroutine data_model

end submodule nc4f_test_cases_model
