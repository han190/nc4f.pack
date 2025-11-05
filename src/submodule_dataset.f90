submodule(module_netcdf) submodule_dataset
implicit none
contains

module function open_dataset(filename, mode, &
  & inquire_attribute) result(nc)
  character(len=*), intent(in) :: filename
  character(len=*), intent(in) :: mode
  logical, intent(in), optional :: inquire_attribute
  type(netcdf_type) :: nc
  logical :: inq_att

  select case (mode)
  case ("r", "read")
    nc%filename = trim(adjustl(filename))
    call handle_error(nc_open(cstr(nc%filename), NC_NOWRITE, nc%id), &
      & "[open_dataset] File not found.")
    nc%mode = NC_NOWRITE
  case default
    error stop "[open_dataset] Invalid mode."
  end select

  nc%dimensions = get_dimensions_global(nc)
  if (present(inquire_attribute)) then
    inq_att = inquire_attribute
  else
    inq_att = .false.
  end if
  if (inq_att) nc%attributes = get_attributes_global(nc)
end function open_dataset

end submodule submodule_dataset