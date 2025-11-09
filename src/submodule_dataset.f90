submodule(module_netcdf) submodule_dataset
implicit none (type, external)
contains

module function open_dataset(filename, mode, inquire_dimension, inquire_attribute) result(nc)
  character(len=*), intent(in) :: filename
  character(len=*), intent(in) :: mode
  logical, intent(in), optional :: inquire_dimension
  logical, intent(in), optional :: inquire_attribute
  type(netcdf_type) :: nc

  select case (mode)
  case ("r", "read")
    nc%filename = trim(adjustl(filename))
    call handle_error(nc_open(f2cstr(nc%filename), NC_NOWRITE, nc%id), &
      & "[open_dataset] File not found.")
    nc%mode = NC_NOWRITE

    if (optval(.false., inquire_dimension)) &
      & nc%dimensions = inquire_dimensions_global(nc)
    if (optval(.false., inquire_attribute)) &
      & nc%attributes = get_attributes_global(nc)
  case ("w", "write")
    nc%filename = trim(adjustl(filename))
    call handle_error(nc_create(f2cstr(nc%filename), NC_NETCDF4, nc%id), &
      & "[open_dataset] Could not create file.")
    nc%mode = NC_NETCDF4

    if (allocated(nc%attributes)) deallocate (nc%attributes)
    if (allocated(nc%dimensions)) deallocate (nc%dimensions)
  case default
    error stop "[open_dataset] Invalid mode."
  end select
end function open_dataset

elemental logical function optval(default, opt) result(val)
  logical, intent(in) :: default
  logical, intent(in), optional :: opt

  if (present(opt)) then
    val = opt
  else
    val = default
  end if
end function optval

module subroutine close_dataset(nc)
  type(netcdf_type), intent(inout) :: nc
  call handle_error(nc_close(nc%id))
  if (allocated(nc%attributes)) deallocate (nc%attributes)
  if (allocated(nc%dimensions)) deallocate (nc%dimensions)
end subroutine close_dataset

module subroutine to_netcdf_vars(filename, vars, atts)
  character(len=*), intent(in) :: filename
  type(variable_type), intent(in) :: vars(:)
  type(attribute_type), intent(in), optional :: atts(:)
  type(netcdf_type) :: nc

  nc = open_dataset(filename, "w")
  call put_variable(nc, vars)
  if (present(atts)) then
    nc%attributes = atts
    call put_attribute(nc)
  end if
  call close_dataset(nc)
end subroutine to_netcdf_vars

module subroutine to_netcdf_var(filename, var, atts)
  character(len=*), intent(in) :: filename
  type(variable_type), intent(in) :: var
  type(attribute_type), intent(in), optional :: atts(:)
  type(netcdf_type) :: nc

  nc = open_dataset(filename, "w")
  call put_variable(nc, var)
  if (present(atts)) then
    nc%attributes = atts
    call put_attribute(nc)
  end if
  call close_dataset(nc)
end subroutine to_netcdf_var

end submodule submodule_dataset
