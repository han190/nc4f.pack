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

  if (present(inquire_attribute)) then
    inq_att = inquire_attribute
  else
    inq_att = .false.
  end if

  select case (mode)
  case ("r", "read")
    nc%filename = trim(adjustl(filename))
    call handle_error(nc_open(f2cstr(nc%filename), NC_NOWRITE, nc%id), &
      & "[open_dataset] File not found.")
    nc%mode = NC_NOWRITE
  case ("w", "write")
    nc%filename = trim(adjustl(filename))
    call handle_error(nc_create(f2cstr(nc%filename), NC_NETCDF4, nc%id), &
      & "[open_dataset] Could not create file.")
    nc%mode = NC_NETCDF4
  case default
    error stop "[open_dataset] Invalid mode."
  end select

  nc%dimensions = inquire_dimensions_global(nc)
  if (inq_att) nc%attributes = get_attributes_global(nc)
end function open_dataset

module subroutine close_dataset(nc)
  type(netcdf_type), intent(inout) :: nc
  call handle_error(nc_close(nc%id))
  if (allocated(nc%attributes)) deallocate (nc%attributes)
  if (allocated(nc%dimensions)) deallocate (nc%dimensions)
end subroutine close_dataset

end submodule submodule_dataset