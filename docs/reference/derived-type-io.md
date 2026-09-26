# User-Defined Derived-Type I/O

## `WRITE(FORMATTED)` -- Render Model Objects

| Synopsis |
|:--|
| <span class="ind4">`WRITE(UNIT, FMT[, IOSTAT, IOMSG]) OBJECT`</span> |

| Class |
|:--|
| <span class="ind4">Defined formatted output.</span> |

| Description |
|:--|
| <span class="ind4">Write an `error_type`, `dimension_type`, `attribute_type`, `variable_type`, `group_type`, or `netcdf_type`. List-directed output (`FMT=*`) and the `DT` edit descriptor are supported. Model objects render in an ncdump-like representation; `error_type` renders its NetCDF status and, when available, diagnostic message.</span> |

| Arguments |
|:--|
| <span class="grid"><span>`UNIT`</span><span>`INTEGER, INTENT(IN)`</span></span><br><span class="ind8">Connected formatted I/O unit.</span> |
| <span class="grid"><span>`FMT`</span><span>`CHARACTER(LEN=*), INTENT(IN)`</span></span><br><span class="ind8">`*` for list-directed output or a format containing `DT`.</span> |
| <span class="grid"><span>`OBJECT`</span><span>`TYPE(ERROR_TYPE), TYPE(DIMENSION_TYPE), TYPE(ATTRIBUTE_TYPE), TYPE(VARIABLE_TYPE), TYPE(GROUP_TYPE), OR TYPE(NETCDF_TYPE), INTENT(IN)`</span></span><br><span class="ind8">Object to render.</span> |
| <span class="grid"><span>`IOSTAT`</span><span>`INTEGER, OPTIONAL, INTENT(OUT)`</span></span><br><span class="ind8">Receives the formatted I/O status.</span> |
| <span class="grid"><span>`IOMSG`</span><span>`CHARACTER(LEN=*), OPTIONAL, INTENT(INOUT)`</span></span><br><span class="ind8">Receives an I/O diagnostic when the write fails.</span> |

:::{list-table}
:class: example-table
:header-rows: 1

*
  - Example
*
  -
    ```fortran
    use, non_intrinsic :: nc4f
    implicit none (type, external)

    integer :: file_unit, iostat
    character(len=256) :: iomsg
    type(dimension_type) :: time

    time = "time" .dim. 24
    open (newunit=file_unit, file="model.txt", status="replace", &
      & action="write", form="formatted", iostat=iostat, iomsg=iomsg)
    if (iostat == 0) write (file_unit, "(dt)", iostat=iostat, iomsg=iomsg) time
    close (file_unit)
    ```
:::
