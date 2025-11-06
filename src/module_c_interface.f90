module module_c_interface

use, intrinsic :: iso_c_binding, only: c_int, c_ptr, c_char, c_size_t, c_long
implicit none (type, external)
public

integer(c_int), parameter :: NC_NOWRITE = int(z'0000', kind=c_int)
integer(c_int), parameter :: NC_CLOBBER = int(z'0000', kind=c_int)
integer(c_int), parameter :: NC_NETCDF4 = int(z'1000', kind=c_int)

integer(c_int), parameter :: NC_NOERR = 0_c_int
integer(c_int), parameter :: NC_MAX_NAME = 256_c_int
integer(c_int), parameter :: NC_MAX_DIMS = 1024_c_int
integer(c_int), parameter :: NC_GLOBAL = -1_c_int
integer(c_long), parameter :: NC_UNLIMITED = 0_c_long

!> Data types
integer(c_int), parameter :: NC_NAT = 0_c_int
integer(c_int), parameter :: NC_BYTE = 1_c_int
integer(c_int), parameter :: NC_CHAR = 2_c_int
integer(c_int), parameter :: NC_SHORT = 3_c_int
integer(c_int), parameter :: NC_INT = 4_c_int
integer(c_int), parameter :: NC_LONG = NC_INT
integer(c_int), parameter :: NC_FLOAT = 5_c_int
integer(c_int), parameter :: NC_DOUBLE = 6_c_int
integer(c_int), parameter :: NC_UBYTE = 7_c_int ! NA
integer(c_int), parameter :: NC_USHORT = 8_c_int ! NA
integer(c_int), parameter :: NC_UINT = 9_c_int ! NA
integer(c_int), parameter :: NC_INT64 = 10_c_int
integer(c_int), parameter :: NC_UINT64 = 11_c_int ! NA
integer(c_int), parameter :: NC_STRING = 12_c_int ! NA

interface
  !> Dataset
  function nc_strerror(ncerr) bind(c, name="nc_strerror")
    import :: c_int, c_ptr
    integer(c_int), value :: ncerr
    type(c_ptr) :: nc_strerror
  end function nc_strerror

  function nc_open(path, mode, ncidp) bind(c, name="nc_open")
    import :: c_char, c_int
    character(kind=c_char), dimension(*) :: path
    integer(c_int), value :: mode
    integer(c_int) :: ncidp
    integer(c_int) :: nc_open
  end function nc_open

  function nc_create(path, cmode, ncidp) bind(c, name="nc_create")
    import :: c_char, c_int
    character(kind=c_char), intent(in) :: path(*)
    integer(c_int), value :: cmode
    integer(c_int), intent(out) :: ncidp
    integer(c_int) :: nc_create
  end function nc_create

  function nc_close(ncid) bind(c, name="nc_close")
    import :: c_int
    integer(c_int), value :: ncid
    integer(c_int) :: nc_close
  end function nc_close

  !> Attribute
  function nc_inq_att(ncid, varid, name, xtypep, lenp) bind(c, name="nc_inq_att")
    import :: c_int, c_char, c_size_t
    integer(c_int), value :: ncid, varid
    character(kind=c_char), intent(in) :: name(*)
    integer(c_int), intent(out) :: xtypep
    integer(c_size_t), intent(out) :: lenp
    integer(c_int) :: nc_inq_att
  end function nc_inq_att

  function nc_get_att(ncid, varid, name, value) bind(c, name="nc_get_att")
    import :: c_int, c_char, c_ptr
    integer(c_int), value :: ncid, varid
    character(kind=c_char), intent(in) :: name(*)
    type(c_ptr), value :: value
    integer(c_int) :: nc_get_att
  end function nc_get_att

  function nc_inq_natts(ncid, nattsp) bind(c, name="nc_inq_natts")
    import :: c_int
    integer(c_int), value :: ncid
    integer(c_int), intent(out) :: nattsp
    integer(c_int) :: nc_inq_natts
  end function nc_inq_natts

  function nc_inq_var(ncid, varid, name, xtypep, ndimsp, dimidsp, nattsp) bind(c, name="nc_inq_var")
    import :: c_int, c_char
    integer(c_int), value :: ncid, varid
    character(kind=c_char), intent(out) :: name(*)
    integer(c_int), intent(out) :: xtypep
    integer(c_int), intent(out) :: ndimsp
    integer(c_int), intent(out) :: dimidsp(*)
    integer(c_int), intent(out) :: nattsp
    integer(c_int) :: nc_inq_var
  end function nc_inq_var

  function nc_inq_attname(ncid, varid, attnum, name) bind(c, name="nc_inq_attname")
    import :: c_int, c_char, c_ptr
    integer(c_int), value :: ncid, varid, attnum
    character(kind=c_char), intent(inout) :: name(*)
    integer(c_int) :: nc_inq_attname
  end function nc_inq_attname

  function nc_inq_varnatts(ncid, varid, nattsp) bind(c, name="nc_inq_varnatts")
    import :: c_int
    integer(c_int), value :: ncid, varid
    integer(c_int), intent(out) :: nattsp
    integer(c_int) :: nc_inq_varnatts
  end function nc_inq_varnatts

  function nc_put_att(ncid, varid, name, xtype, len, value) bind(c, name="nc_put_att")
    import :: c_int, c_char, c_size_t, c_ptr
    integer(c_int), value :: ncid, varid
    character(kind=c_char), intent(in) :: name(*)
    integer(c_int), value :: xtype
    integer(c_size_t), value :: len
    type(c_ptr), value :: value
    integer(c_int) :: nc_put_att
  end function nc_put_att

  function nc_inq_dimlen(ncid, dimid, lenp) bind(c, name="nc_inq_dimlen")
    import :: c_int, c_size_t
    integer(c_int), value :: ncid, dimid
    integer(c_size_t), intent(out) :: lenp
    integer(c_int) :: nc_inq_dimlen
  end function nc_inq_dimlen

  function nc_inq_dimids(ncid, ndims, dimids, include_parents) bind(c, name="nc_inq_dimids")
    import :: c_int
    integer(c_int), value :: ncid
    integer(c_int), intent(out) :: ndims, dimids(*)
    integer(c_int), value :: include_parents
    integer(c_int) :: nc_inq_dimids
  end function nc_inq_dimids

  function nc_inq_dimid(ncid, name, idp) bind(c, name="nc_inq_dimid")
    import :: c_int, c_char
    integer(c_int), value :: ncid
    character(kind=c_char), intent(in) :: name(*)
    integer(c_int), intent(out) :: idp
    integer(c_int) :: nc_inq_dimid
  end function nc_inq_dimid

  function nc_inq_dimname(ncid, dimid, name) bind(c, name="nc_inq_dimname")
    import :: c_int, c_char
    integer(c_int), value :: ncid, dimid
    character(kind=c_char), intent(out) :: name(*)
    integer(c_int) :: nc_inq_dimname
  end function nc_inq_dimname

  function nc_inq_unlimdim(ncid, unlimdimidp) bind(c, name="nc_inq_unlimdim")
    import :: c_int
    integer(c_int), value :: ncid
    integer(c_int), intent(out) :: unlimdimidp
    integer(c_int) :: nc_inq_unlimdim
  end function nc_inq_unlimdim

  function nc_def_dim(ncid, name, len, idp) bind(c, name="nc_def_dim")
    import :: c_int, c_char, c_size_t
    integer(c_int), value :: ncid
    character(kind=c_char), intent(in) :: name
    integer(c_size_t), value :: len
    integer(c_int), intent(inout) :: idp
    integer(c_int) :: nc_def_dim
  end function nc_def_dim

  function nc_inq_varid(ncid, name, varidp) bind(c, name="nc_inq_varid")
    import :: c_int, c_char
    integer(c_int), value :: ncid
    character(kind=c_char), intent(in) :: name(*)
    integer(c_int), intent(out) :: varidp
    integer(c_int) :: nc_inq_varid
  end function nc_inq_varid

  function nc_inq_vartype(ncid, varid, typep) bind(c, name="nc_inq_vartype")
    import :: c_int
    integer(c_int), value :: ncid, varid
    integer(c_int), intent(out) :: typep
    integer(c_int) :: nc_inq_vartype
  end function nc_inq_vartype

  function nc_inq_vardimid(ncid, varid, dimidsp) bind(c, name="nc_inq_vardimid")
    import :: c_int
    integer(c_int), value :: ncid, varid
    integer(c_int), intent(out) :: dimidsp(*)
    integer(c_int) :: nc_inq_vardimid
  end function nc_inq_vardimid

  function nc_inq_varndims(ncid, varid, ndimsp) bind(c, name="nc_inq_varndims")
    import :: c_int
    integer(c_int), value :: ncid, varid
    integer(c_int), intent(out) :: ndimsp
    integer(c_int) :: nc_inq_varndims
  end function nc_inq_varndims

  function nc_get_var(ncid, varid, ip) bind(c, name="nc_get_var")
    import :: c_int, c_ptr
    integer(c_int), value :: ncid, varid
    type(c_ptr), value :: ip
    integer(c_int) :: nc_get_var
  end function nc_get_var

  function nc_def_var(ncid, name, xtype, ndims, dimidsp, varidp) bind(c, name="nc_def_var")
    import :: c_int, c_char
    integer(c_int), value :: ncid
    character(kind=c_char), intent(in) :: name(*)
    integer(c_int), value :: xtype
    integer(c_int), value :: ndims
    integer(c_int), intent(in) :: dimidsp(*)
    integer(c_int), intent(out) :: varidp
    integer(c_int) :: nc_def_var
  end function nc_def_var

  function nc_put_var(ncid, varid, op) bind(c, name="nc_put_var")
    import :: c_int, c_ptr
    integer(c_int), value :: ncid, varid
    type(c_ptr), value :: op
    integer(c_int) :: nc_put_var
  end function nc_put_var
end interface

end module module_c_interface
