SRC_DIR := src
FYPP_DIR := fypp
TEST_DIR := test
PROFILE ?= debug
ifeq ($(origin FC), default)
  FC := gfortran
endif
COMPILER_NAME := $(notdir $(FC))
BUILD_DIR := build/makefile_$(COMPILER_NAME)
LIB := $(BUILD_DIR)/ncpack.a
TEST_TARGET := $(BUILD_DIR)/test
NC_CFLAGS := $(shell pkg-config --cflags netcdf)
NC_LIBS := $(shell pkg-config --libs netcdf)

ifneq (,$(findstring gfortran,$(notdir $(FC))))
	ifeq ($(PROFILE),release)
		FFLAGS ?= -O3 -funroll-loops -Wimplicit-interface -fPIC -fmax-errors=1 \
			-fcoarray=single -J$(BUILD_DIR) -I$(SRC_DIR) $(NC_CFLAGS)
	else ifeq ($(PROFILE),debug)
		FFLAGS ?= -O0 -g -Wall -Wextra -fPIC -fmax-errors=1 -fcheck=bounds \
			-fcheck=array-temps -fbacktrace -fcoarray=single \
			-J$(BUILD_DIR) -I$(SRC_DIR) $(NC_CFLAGS)
	endif
else ifneq (,$(findstring flang,$(notdir $(FC))))
	ifeq ($(PROFILE),release)
		FFLAGS ?= -O3 -funroll-loops -fimplicit-none -fPIC \
			-J$(BUILD_DIR) -I$(SRC_DIR) $(NC_CFLAGS)
	else ifeq ($(PROFILE),debug)
		FFLAGS ?= -O0 -g -funroll-loops -fimplicit-none -fPIC \
			-J$(BUILD_DIR) -I$(SRC_DIR) $(NC_CFLAGS)
	endif
endif

LINK_FFLAGS := $(filter-out -J$(BUILD_DIR),$(FFLAGS))

FYPP_INC = \
	$(FYPP_DIR)/nc4f_ds_attribute_constructor_inc.fypp \
	$(FYPP_DIR)/nc4f_ds_extract_inc.fypp \
	$(FYPP_DIR)/nc4f_ds_variable_constructor_inc.fypp

SRC_INC = \
	$(SRC_DIR)/nc4f_ds_attribute_constructor.inc \
	$(SRC_DIR)/nc4f_ds_extract.inc \
	$(SRC_DIR)/nc4f_ds_variable_constructor.inc

FYPP_F90 = \
	$(FYPP_DIR)/nc4f_ds_attribute_constructor.fypp \
	$(FYPP_DIR)/nc4f_ds_extract.fypp \
	$(FYPP_DIR)/nc4f_ds_variable_constructor.fypp

SRC_F90 = \
	$(SRC_DIR)/nc4f_ds_attribute_constructor.f90 \
	$(SRC_DIR)/nc4f_ds_extract.f90 \
	$(SRC_DIR)/nc4f_ds_variable_constructor.f90

SRC = \
  $(SRC_DIR)/nc4f_c_interface.f90 \
	$(SRC_DIR)/nc4f_ds.f90 \
	$(SRC_DIR)/nc4f_ds_access.f90 \
	$(SRC_DIR)/nc4f_ds_arithmetic.f90 \
	$(SRC_DIR)/nc4f_ds_attribute.f90 \
	$(SRC_DIR)/nc4f_ds_attribute_constructor.f90 \
	$(SRC_DIR)/nc4f_ds_clone.f90 \
	$(SRC_DIR)/nc4f_ds_dimension.f90 \
	$(SRC_DIR)/nc4f_ds_extract.f90 \
	$(SRC_DIR)/nc4f_ds_group.f90 \
	$(SRC_DIR)/nc4f_ds_io.f90 \
	$(SRC_DIR)/nc4f_ds_variable_constructor.f90 \
	$(SRC_DIR)/nc4f_ds_variable.f90 \
	$(SRC_DIR)/nc4f_nc.f90 \
	$(SRC_DIR)/nc4f_nc_attribute.f90 \
	$(SRC_DIR)/nc4f_nc_dataset.f90 \
	$(SRC_DIR)/nc4f_nc_dimension.f90 \
	$(SRC_DIR)/nc4f_nc_error.f90 \
	$(SRC_DIR)/nc4f_nc_group.f90 \
	$(SRC_DIR)/nc4f_nc_utility.f90 \
	$(SRC_DIR)/nc4f_nc_variable.f90 \
	$(SRC_DIR)/nc4f.f90

OBJ = \
	$(BUILD_DIR)/nc4f_c_interface.o \
	$(BUILD_DIR)/nc4f_ds.o \
	$(BUILD_DIR)/nc4f_ds_access.o \
	$(BUILD_DIR)/nc4f_ds_arithmetic.o \
	$(BUILD_DIR)/nc4f_ds_attribute.o \
	$(BUILD_DIR)/nc4f_ds_attribute_constructor.o \
	$(BUILD_DIR)/nc4f_ds_clone.o \
	$(BUILD_DIR)/nc4f_ds_dimension.o \
	$(BUILD_DIR)/nc4f_ds_extract.o \
	$(BUILD_DIR)/nc4f_ds_group.o \
	$(BUILD_DIR)/nc4f_ds_io.o \
	$(BUILD_DIR)/nc4f_ds_variable_constructor.o \
	$(BUILD_DIR)/nc4f_ds_variable.o \
	$(BUILD_DIR)/nc4f_nc.o \
	$(BUILD_DIR)/nc4f_nc_attribute.o \
	$(BUILD_DIR)/nc4f_nc_dataset.o \
	$(BUILD_DIR)/nc4f_nc_dimension.o \
	$(BUILD_DIR)/nc4f_nc_error.o \
	$(BUILD_DIR)/nc4f_nc_group.o \
	$(BUILD_DIR)/nc4f_nc_utility.o \
	$(BUILD_DIR)/nc4f_nc_variable.o \
	$(BUILD_DIR)/nc4f.o

TEST_FILES = \
	nc4f_test_cases.f90 \
	nc4f_test_cases_basic.f90 \
	nc4f_test_cases_errors.f90 \
	nc4f_test_cases_group.f90 \
	nc4f_test_cases_io.f90 \
	nc4f_test_cases_data.f90 \
	nc4f_test_cases_copy.f90 \
	nc4f_test_cases_model.f90 \
	nc4f_test_module.f90 \
	nc4f_test.f90
TEST := $(addprefix $(TEST_DIR)/, $(TEST_FILES))
TEST_OBJS := $(patsubst $(TEST_DIR)/%.f90,$(BUILD_DIR)/%.o,$(TEST))

.PHONY: all prepare preprocess build library download-test-data test clean
all: prepare preprocess build library
download-test-data:
	@./scripts/download_test_data.sh
test: library $(TEST_OBJS) $(TEST_TARGET)
	@printf "\r\033[2K[test] run test: $(TEST_TARGET)\n"
	@$(TEST_TARGET)
library: build create_static_link
build: preprocess $(OBJ)
preprocess: prepare $(SRC_INC) $(SRC_F90)
prepare: create_build_dir

$(TEST_TARGET): $(TEST_OBJS) $(LIB)
	@printf "\r\033[2K[test] create executable: $(TEST_TARGET)"
	@$(FC) -o $(TEST_TARGET) $(TEST_OBJS) $(LIB) $(LINK_FFLAGS) $(NC_LIBS)

$(BUILD_DIR)/%.o: $(TEST_DIR)/%.f90
	@printf "\r\033[2K[compile] $<"
	@$(FC) -c $(FFLAGS) $< -o $@

create_static_link:
	@printf "\r\033[2K[link] create static library: $(LIB)\n"
	@$(AR) rcs $(LIB) $(OBJ)

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.f90
	@printf "\r\033[2K[compile] $<"
	@$(FC) -c $(FFLAGS) $< -o $@

$(SRC_DIR)/%.inc: $(FYPP_DIR)/%_inc.fypp
	@printf "\r\033[2K[preproc] $<"
	@fypp $< > $@

$(SRC_DIR)/%.f90: $(FYPP_DIR)/%.fypp
	@printf "\r\033[2K[preproc] $<"
	@fypp $< > $@

create_build_dir:
	@printf "\r\033[2K[prepare] create directory $(BUILD_DIR)"
	@mkdir -p $(BUILD_DIR)

clean:
	@printf "\r\033[2K[clean] remove temporary files."
	@$(RM) *.nc
	@printf "\r\033[2K[clean] remove generated source files."
	@$(RM) $(SRC_INC) $(SRC_F90)
	@printf "\r\033[2K[clean] remove directory $(BUILD_DIR)\n"
	@$(RM) -r $(BUILD_DIR)/
