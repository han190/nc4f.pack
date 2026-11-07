cmake_minimum_required(VERSION 3.24)
project(nc4f VERSION 0.1.0 LANGUAGES C Fortran)

include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

option(NC4F_BUILD_TESTS "Build the NC4F regression suite" ${PROJECT_IS_TOP_LEVEL})
option(NC4F_BUILD_EXAMPLES "Build the NC4F examples" OFF)
option(NC4F_REGENERATE_SOURCES "Regenerate tracked Fortran sources with fypp" OFF)

find_package(PkgConfig REQUIRED)
pkg_check_modules(NC4F_NETCDF REQUIRED IMPORTED_TARGET GLOBAL netcdf)

# Keep compiler-generated modules separate from sources and from other targets.
set(nc4f_module_dir "${CMAKE_CURRENT_BINARY_DIR}/modules/nc4f")
set(nc4f_c_module_dir "${CMAKE_CURRENT_BINARY_DIR}/modules/c_interface")
set(nc4f_install_module_dir
    "${CMAKE_INSTALL_INCLUDEDIR}/nc4f/${CMAKE_Fortran_COMPILER_ID}-${CMAKE_Fortran_COMPILER_VERSION}")
file(MAKE_DIRECTORY "${nc4f_module_dir}" "${nc4f_c_module_dir}")

function(nc4f_compile_options target)
  if(CMAKE_Fortran_COMPILER_ID STREQUAL "GNU")
    # Match test-drive's default coarray mode when compiling test modules.
    # Gfortran 15 cannot reread a re-exported test-drive type otherwise.
    if(NOT target STREQUAL "nc4f_tests")
      target_compile_options(${target} PRIVATE -fcoarray=single)
    endif()
    target_compile_options(${target} PRIVATE
      "$<$<CONFIG:Debug>:-Wall;-Wextra;-fcheck=bounds;-fcheck=array-temps;-fbacktrace>")
  elseif(CMAKE_Fortran_COMPILER_ID STREQUAL "IntelLLVM" AND UNIX)
    target_compile_options(${target} PRIVATE -standard-semantics
      "SHELL:-fp-model precise"
      "$<$<CONFIG:Debug>:-O0;-g;-traceback>"
      "$<$<CONFIG:Debug>:SHELL:-warn all>"
      "$<$<CONFIG:Debug>:SHELL:-check bounds>"
      "$<$<CONFIG:Release>:-O3>")
  endif()
endfunction()

# This target can be built independently of the high-level data model.
add_library(nc4f_c_interface STATIC src/nc4f_c_interface.f90)
add_library(nc4f::c_interface ALIAS nc4f_c_interface)
set_target_properties(nc4f_c_interface PROPERTIES
  EXPORT_NAME c_interface
  Fortran_MODULE_DIRECTORY "${nc4f_c_module_dir}"
  POSITION_INDEPENDENT_CODE ON)
target_include_directories(nc4f_c_interface
  PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/src"
  PUBLIC "$<BUILD_INTERFACE:${nc4f_c_module_dir}>"
         "$<INSTALL_INTERFACE:${nc4f_install_module_dir}>")
target_link_libraries(nc4f_c_interface PUBLIC PkgConfig::NC4F_NETCDF)
nc4f_compile_options(nc4f_c_interface)

set(nc4f_generated_names
  nc4f_ds_attribute_constructor
  nc4f_ds_variable_constructor
  nc4f_ds_extract)
set(nc4f_data_dir "${CMAKE_CURRENT_SOURCE_DIR}/src")
set(nc4f_data_module "${nc4f_data_dir}/nc4f_ds.f90")
set(nc4f_generated_sources)

if(NC4F_REGENERATE_SOURCES)
  find_program(NC4F_FYPP_EXECUTABLE NAMES fypp REQUIRED)
  set(nc4f_generated_dir "${CMAKE_CURRENT_BINARY_DIR}/generated")
  file(MAKE_DIRECTORY "${nc4f_generated_dir}")
  # Fortran INCLUDE searches beside the source first. Copy the parent module
  # so it includes the generated interfaces instead of the tracked copies.
  set(nc4f_data_module "${nc4f_generated_dir}/nc4f_ds.f90")
  configure_file("${nc4f_data_dir}/nc4f_ds.f90" "${nc4f_data_module}" COPYONLY)
  foreach(name IN LISTS nc4f_generated_names)
    foreach(extension IN ITEMS f90 inc)
      if(extension STREQUAL "inc")
        set(template "${name}_inc.fypp")
      else()
        set(template "${name}.fypp")
      endif()
      set(output "${nc4f_generated_dir}/${name}.${extension}")
      add_custom_command(OUTPUT "${output}"
        COMMAND "${NC4F_FYPP_EXECUTABLE}"
                "${CMAKE_CURRENT_SOURCE_DIR}/fypp/${template}" "${output}"
        DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/fypp/${template}"
                "${CMAKE_CURRENT_SOURCE_DIR}/fypp/common.fypp"
        COMMENT "Generating ${name}.${extension}"
        VERBATIM)
      list(APPEND nc4f_generated_sources "${output}")
    endforeach()
  endforeach()
  add_custom_target(nc4f_generate DEPENDS ${nc4f_generated_sources})
else()
  set(nc4f_generated_dir "${nc4f_data_dir}")
  foreach(name IN LISTS nc4f_generated_names)
    list(APPEND nc4f_generated_sources "${nc4f_data_dir}/${name}.f90")
  endforeach()
endif()

add_library(nc4f STATIC
  src/nc4f.f90
  "${nc4f_data_module}"
  ${nc4f_generated_sources}
  src/nc4f_ds_arithmetic.f90
  src/nc4f_ds_attribute.f90
  src/nc4f_ds_clone.f90
  src/nc4f_ds_dimension.f90
  src/nc4f_ds_group.f90
  src/nc4f_ds_io.f90
  src/nc4f_ds_utility.f90
  src/nc4f_ds_validate.f90
  src/nc4f_ds_variable.f90
  src/nc4f_nc.f90
  src/nc4f_nc_attribute.f90
  src/nc4f_nc_dataset.f90
  src/nc4f_nc_dimension.f90
  src/nc4f_nc_error.f90
  src/nc4f_nc_group.f90
  src/nc4f_nc_utility.f90
  src/nc4f_nc_variable.f90)
add_library(nc4f::nc4f ALIAS nc4f)
set_target_properties(nc4f PROPERTIES
  Fortran_MODULE_DIRECTORY "${nc4f_module_dir}"
  POSITION_INDEPENDENT_CODE ON)
target_include_directories(nc4f
  PRIVATE "${nc4f_generated_dir}"
  PUBLIC "$<BUILD_INTERFACE:${nc4f_module_dir}>"
         "$<INSTALL_INTERFACE:${nc4f_install_module_dir}>")
target_link_libraries(nc4f PUBLIC nc4f::c_interface)
nc4f_compile_options(nc4f)
if(NC4F_REGENERATE_SOURCES)
  add_dependencies(nc4f nc4f_generate)
endif()

if(NC4F_BUILD_TESTS)
  enable_testing()
  find_package(test-drive 0.6.1 CONFIG QUIET)
  if(NOT TARGET test-drive::test-drive)
    include(FetchContent)
    set(TESTDRIVE_BUILD_TESTING OFF)
    # LLVM Flang can detect XDP but lack complex real128 ABS at link time.
    if(CMAKE_Fortran_COMPILER_ID STREQUAL "LLVMFlang")
      set(TESTDRIVE_WITH_XDP OFF)
    endif()
    FetchContent_Declare(test-drive
      GIT_REPOSITORY https://github.com/fortran-lang/test-drive.git
      GIT_TAG v0.6.1)
    FetchContent_MakeAvailable(test-drive)
    if(TARGET test-drive AND NOT TARGET test-drive::test-drive)
      add_library(test-drive::test-drive ALIAS test-drive)
    endif()
  endif()
  add_executable(nc4f_tests
    test/nc4f_test.f90
    test/nc4f_test_c_interface.f90
    test/nc4f_test_c_interface_dimension.f90
    test/nc4f_test_c_interface_error.f90
    test/nc4f_test_c_interface_group.f90
    test/nc4f_test_c_interface_attribute.f90
    test/nc4f_test_c_interface_dataset.f90
    test/nc4f_test_c_interface_io.f90
    test/nc4f_test_c_interface_variable.f90
    test/nc4f_test_c_interface_utility.f90
    test/nc4f_test_utility.f90
    test/nc4f_test_ds.f90
    test/nc4f_test_ds_arithmetic.f90
    test/nc4f_test_ds_attribute.f90
    test/nc4f_test_ds_attribute_constructor.f90
    test/nc4f_test_ds_clone.f90
    test/nc4f_test_ds_dimension.f90
    test/nc4f_test_ds_extract.f90
    test/nc4f_test_ds_group.f90
    test/nc4f_test_ds_io.f90
    test/nc4f_test_ds_utility.f90
    test/nc4f_test_ds_validate.f90
    test/nc4f_test_ds_variable.f90
    test/nc4f_test_ds_variable_constructor.f90
    test/nc4f_test_nc.f90
    test/nc4f_test_nc_attribute.f90
    test/nc4f_test_nc_dataset.f90
    test/nc4f_test_nc_dimension.f90
    test/nc4f_test_nc_error.f90
    test/nc4f_test_nc_group.f90
    test/nc4f_test_nc_utility.f90
    test/nc4f_test_nc_variable.f90
    test/nc4f_test_real_data.f90)
  set(nc4f_test_module_dir
    "${CMAKE_CURRENT_BINARY_DIR}/modules/tests")
  file(MAKE_DIRECTORY "${nc4f_test_module_dir}")
  set_target_properties(nc4f_tests PROPERTIES
    Fortran_MODULE_DIRECTORY "${nc4f_test_module_dir}")
  target_include_directories(nc4f_tests PRIVATE
    "${nc4f_test_module_dir}")
  target_link_libraries(nc4f_tests PRIVATE
    nc4f::nc4f test-drive::test-drive)
  nc4f_compile_options(nc4f_tests)
  foreach(suite IN ITEMS c_interface_attribute c_interface_dataset
      c_interface_dimension c_interface_error c_interface_group
      c_interface_io c_interface_utility c_interface_variable
      ds_arithmetic ds_attribute ds_attribute_constructor ds_clone
      ds_dimension ds_extract ds_group ds_io ds_utility ds_validate
      ds_variable ds_variable_constructor nc_attribute nc_dataset
      nc_dimension nc_error nc_group nc_utility nc_variable real_data)
    add_test(NAME "nc4f.${suite}" COMMAND nc4f_tests "${suite}")
  endforeach()
  set_tests_properties(nc4f.real_data PROPERTIES
    WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}")
endif()

if(NC4F_BUILD_EXAMPLES)
  set(nc4f_example_targets)
  set(nc4f_example_commands)
  set(nc4f_example_dir "${CMAKE_CURRENT_BINARY_DIR}/examples")
  file(MAKE_DIRECTORY "${nc4f_example_dir}")
  # read_netcdf consumes example.nc written by write_netcdf.
  foreach(name IN ITEMS write_netcdf read_netcdf mandelbrot temperature)
    set(target "nc4f_example_${name}")
    add_executable(${target} "example/${name}.f90")
    target_link_libraries(${target} PRIVATE nc4f::nc4f)
    nc4f_compile_options(${target})
    list(APPEND nc4f_example_targets ${target})
    list(APPEND nc4f_example_commands COMMAND "$<TARGET_FILE:${target}>")
  endforeach()
  add_custom_target(run-examples
    ${nc4f_example_commands}
    DEPENDS ${nc4f_example_targets}
    WORKING_DIRECTORY "${nc4f_example_dir}"
    USES_TERMINAL VERBATIM)
endif()

install(TARGETS nc4f nc4f_c_interface EXPORT nc4fTargets
  ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}")
install(DIRECTORY "${nc4f_module_dir}/" "${nc4f_c_module_dir}/"
  DESTINATION "${nc4f_install_module_dir}"
  FILES_MATCHING PATTERN "*.mod" PATTERN "*.smod")
set(nc4f_config_dir "${CMAKE_INSTALL_LIBDIR}/cmake/nc4f")
# Bracket quoting preserves CMAKE_CURRENT_LIST_DIR for the consuming project.
file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/nc4fConfig.cmake.in" [=[
@PACKAGE_INIT@

include(CMakeFindDependencyMacro)
find_dependency(PkgConfig)
pkg_check_modules(NC4F_NETCDF REQUIRED IMPORTED_TARGET GLOBAL netcdf)

include("${CMAKE_CURRENT_LIST_DIR}/nc4fTargets.cmake")
check_required_components(nc4f)
]=])
configure_package_config_file("${CMAKE_CURRENT_BINARY_DIR}/nc4fConfig.cmake.in"
  "${CMAKE_CURRENT_BINARY_DIR}/nc4fConfig.cmake"
  INSTALL_DESTINATION "${nc4f_config_dir}")
write_basic_package_version_file("${CMAKE_CURRENT_BINARY_DIR}/nc4fConfigVersion.cmake"
  VERSION "${PROJECT_VERSION}" COMPATIBILITY SameMinorVersion)
install(EXPORT nc4fTargets NAMESPACE nc4f:: DESTINATION "${nc4f_config_dir}")
install(FILES "${CMAKE_CURRENT_BINARY_DIR}/nc4fConfig.cmake"
              "${CMAKE_CURRENT_BINARY_DIR}/nc4fConfigVersion.cmake"
  DESTINATION "${nc4f_config_dir}")
install(FILES LICENSE DESTINATION "${CMAKE_INSTALL_DATADIR}/licenses/nc4f")
