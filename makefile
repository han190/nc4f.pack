.DEFAULT_GOAL := all
.DELETE_ON_ERROR:

SRC_DIR := src
C_INTERFACE_DIR := $(SRC_DIR)/c_interface
DATA_STRUCTURE_DIR := $(SRC_DIR)/data_structure
NETCDF_DIR := $(SRC_DIR)/netcdf
SOURCE_DIRS := $(SRC_DIR) $(C_INTERFACE_DIR) $(DATA_STRUCTURE_DIR) $(NETCDF_DIR)
FYPP_DIR := fypp
TEST_DIR := test
EXAMPLE_DIR := example
FYPP ?= fypp
PROFILE ?= debug
ifeq ($(origin FC), default)
  FC := gfortran
endif
COMPILER_NAME := $(notdir $(FC))
BUILD_DIR := build/makefile_$(COMPILER_NAME)_$(PROFILE)
LIB := $(BUILD_DIR)/ncpack.a
C_INTERFACE_LIB := $(BUILD_DIR)/libnc4f_c_interface.a
C_INTERFACE_OBJ := $(BUILD_DIR)/nc4f_c_interface.o
TEST_TARGET := $(BUILD_DIR)/test
EXAMPLE_BUILD_DIR := $(BUILD_DIR)/examples
# read_netcdf consumes example.nc produced by write_netcdf.
EXAMPLE_NAMES := write_netcdf read_netcdf $(filter-out write_netcdf read_netcdf,\
  $(basename $(notdir $(wildcard $(EXAMPLE_DIR)/*.f90))))
EXAMPLE_TARGETS := $(addprefix $(EXAMPLE_BUILD_DIR)/,$(EXAMPLE_NAMES))
NC_CFLAGS := $(shell pkg-config --cflags netcdf)
NC_LIBS := $(shell pkg-config --libs netcdf)
MODULE_OUTPUT_FLAG := -J$(BUILD_DIR)

ifneq (,$(findstring gfortran,$(COMPILER_NAME)))
  COMPILER_FFLAGS := -fmax-errors=1 -fcoarray=single
  DEBUG_FFLAGS := -O0 -g -Wall -Wextra -fcheck=bounds -fcheck=array-temps -fbacktrace
  RELEASE_FFLAGS := -O3 -funroll-loops -Wimplicit-interface
else ifneq (,$(findstring flang,$(COMPILER_NAME)))
  COMPILER_FFLAGS := -funroll-loops -fimplicit-none
  DEBUG_FFLAGS := -O0 -g
  RELEASE_FFLAGS := -O3
else ifneq (,$(findstring ifx,$(COMPILER_NAME)))
  COMPILER_FFLAGS := -standard-semantics -fp-model precise
  DEBUG_FFLAGS := -O0 -g -warn all -check bounds -traceback
  RELEASE_FFLAGS := -O3
  MODULE_OUTPUT_FLAG := -module $(BUILD_DIR)
endif
ifeq ($(PROFILE),debug)
  PROFILE_FFLAGS := $(DEBUG_FFLAGS)
else ifeq ($(PROFILE),release)
  PROFILE_FFLAGS := $(RELEASE_FFLAGS)
else
  $(error Unsupported PROFILE '$(PROFILE)'; choose debug or release)
endif
FFLAGS ?= -fPIC $(COMPILER_FFLAGS) $(PROFILE_FFLAGS)
MODULE_FLAGS := $(MODULE_OUTPUT_FLAG) -I$(BUILD_DIR) $(addprefix -I,$(SOURCE_DIRS)) $(NC_CFLAGS)

# All current templates generate data_structure sources; common.fypp is a helper.
FYPP_INC := $(wildcard $(FYPP_DIR)/*_inc.fypp)
FYPP_F90 := $(filter-out $(FYPP_INC) $(FYPP_DIR)/common.fypp,$(wildcard $(FYPP_DIR)/*.fypp))
SRC_INC := $(patsubst $(FYPP_DIR)/%_inc.fypp,$(DATA_STRUCTURE_DIR)/%.inc,$(FYPP_INC))
SRC_F90 := $(patsubst $(FYPP_DIR)/%.fypp,$(DATA_STRUCTURE_DIR)/%.f90,$(FYPP_F90))
C_INTERFACE_INC := $(wildcard $(C_INTERFACE_DIR)/nc4f_c_interface_*.inc)

# Include generated sources even when they have not been created yet.
SRC := $(sort $(wildcard $(addsuffix /*.f90,$(SOURCE_DIRS))) $(SRC_F90))
TEST := $(wildcard $(TEST_DIR)/*.f90)
OBJ := $(addprefix $(BUILD_DIR)/,$(notdir $(SRC:.f90=.o)))
TEST_OBJS := $(addprefix $(BUILD_DIR)/,$(notdir $(TEST:.f90=.o)))
vpath %.f90 $(SOURCE_DIRS) $(TEST_DIR)

.PHONY: all build library c-interface examples preprocess download-test-data test clean
all library: $(LIB)
build: $(OBJ)
# The archive and nc4f_c_interface.mod are emitted into BUILD_DIR.
# Consumers still need to link the upstream NetCDF C library ($(NC_LIBS)).
c-interface: $(C_INTERFACE_LIB)
examples: $(EXAMPLE_TARGETS)
	@set -e; cd $(EXAMPLE_BUILD_DIR); \
	for example in $(EXAMPLE_NAMES); do \
	  printf "[example] run example: %s\n" "$$example"; \
	  ./$$example; \
	done
preprocess: $(SRC_INC) $(SRC_F90)
download-test-data:
	@./scripts/download_test_data.sh
test: $(TEST_TARGET)
	@printf "[test] run test: $(TEST_TARGET)\n"
	@$(TEST_TARGET)

$(LIB): $(OBJ)
	@printf "[link] create static library: $@\n"
	@$(RM) $@
	@$(AR) rcs $@ $(OBJ)

$(C_INTERFACE_LIB): $(C_INTERFACE_OBJ)
	@printf "[link] create static library: $@\n"
	@$(RM) $@
	@$(AR) rcs $@ $^

$(EXAMPLE_BUILD_DIR)/%: $(EXAMPLE_DIR)/%.f90 $(LIB) makefile | $(EXAMPLE_BUILD_DIR)
	@printf "[link] create example: $@\n"
	@$(FC) $(FFLAGS) $(MODULE_FLAGS) $(LDFLAGS) -o $@ $< $(LIB) $(NC_LIBS) $(LDLIBS)

$(TEST_TARGET): $(TEST_OBJS) $(LIB)
	@printf "[link] create executable: $@\n"
	@$(FC) $(FFLAGS) $(LDFLAGS) -o $@ $(TEST_OBJS) $(LIB) $(NC_LIBS) $(LDLIBS)

$(OBJ) $(TEST_OBJS): makefile | $(BUILD_DIR)
$(BUILD_DIR)/%.o: %.f90
	@printf "[compile] $<\n"
	@$(FC) $(FFLAGS) $(MODULE_FLAGS) -c $< -o $@

# Object prerequisites enforce module/submodule order and propagate interface changes.
$(BUILD_DIR)/nc4f_c_interface.o: $(C_INTERFACE_INC)
$(BUILD_DIR)/nc4f_ds.o: $(SRC_INC) $(BUILD_DIR)/nc4f_c_interface.o
$(filter $(BUILD_DIR)/nc4f_ds_%.o,$(OBJ)): $(BUILD_DIR)/nc4f_ds.o
$(BUILD_DIR)/nc4f_nc.o: $(BUILD_DIR)/nc4f_ds.o $(BUILD_DIR)/nc4f_c_interface.o
$(filter $(BUILD_DIR)/nc4f_nc_%.o,$(OBJ)): $(BUILD_DIR)/nc4f_nc.o
$(BUILD_DIR)/nc4f.o: $(BUILD_DIR)/nc4f_ds.o $(BUILD_DIR)/nc4f_nc.o
$(BUILD_DIR)/nc4f_test_cases.o: $(BUILD_DIR)/nc4f.o
$(filter $(BUILD_DIR)/nc4f_test_cases_%.o,$(TEST_OBJS)): $(BUILD_DIR)/nc4f_test_cases.o
$(BUILD_DIR)/nc4f_test_c_bindings.o: $(BUILD_DIR)/nc4f_c_interface.o
$(BUILD_DIR)/nc4f_test.o: $(BUILD_DIR)/nc4f.o $(BUILD_DIR)/nc4f_test_module.o \
	$(BUILD_DIR)/nc4f_test_cases.o $(BUILD_DIR)/nc4f_test_c_bindings.o

# Explicit targets let vpath locate generated sources before they exist.
$(SRC_INC): $(DATA_STRUCTURE_DIR)/%.inc: $(FYPP_DIR)/%_inc.fypp $(FYPP_DIR)/common.fypp
	@printf "[preproc] $<\n"
	@mkdir -p $(@D)
	@$(FYPP) $< > $@

$(SRC_F90): $(DATA_STRUCTURE_DIR)/%.f90: $(FYPP_DIR)/%.fypp $(FYPP_DIR)/common.fypp
	@printf "[preproc] $<\n"
	@mkdir -p $(@D)
	@$(FYPP) $< > $@

$(BUILD_DIR) $(EXAMPLE_BUILD_DIR):
	@mkdir -p $@

clean:
	@printf "[clean] remove temporary and generated files\n"
	@$(RM) *.nc $(SRC_INC) $(SRC_F90)
	@$(RM) -r $(BUILD_DIR)/
