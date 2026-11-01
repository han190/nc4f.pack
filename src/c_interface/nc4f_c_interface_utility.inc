pure function c_strlen(str) bind(c, name="strlen") result(length)
  !! Return the length of a NUL-terminated C string.
  import :: c_ptr, c_size_t
  type(c_ptr), value :: str
  !! Pointer to a live NUL-terminated C string; must not be c_null_ptr.
  integer(c_size_t) :: length
  !! Number of bytes before the first NUL, excluding the terminator.
end function c_strlen

subroutine c_free(memory) bind(c, name="free")
  !! Release a C allocation, such as nc_rc_get() or an unlocked memory-file
  !! image. Never pass a Fortran allocation or a borrowed pointer. c_null_ptr is
  !! allowed.
  import :: c_ptr
  type(c_ptr), value :: memory
  !! C-allocated address to release.
end subroutine c_free

function c_malloc(size) bind(c, name="malloc")
  !! Allocate C-owned storage for APIs that may resize or free the input buffer.
  import :: c_ptr, c_size_t
  integer(c_size_t), value :: size
  !! Requested allocation size in bytes.
  type(c_ptr) :: c_malloc
  !! Allocated address, or c_null_ptr on allocation failure; release with
  !! c_free().
end function c_malloc