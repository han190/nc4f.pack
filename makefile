SRC_DIR := src
FYPP_DIR := fypp
BUILD_DIR := build/makefile
TEST_DIR := test
LIB := $(BUILD_DIR)/ncpack.a
TEST_TARGET := $(BUILD_DIR)/test
PROFILE ?= debug
FC := gfortran
NCFLAGS := $(shell pkg-config --cflags --libs netcdf)

ifeq ($(FC),gfortran)
	ifeq ($(PROFILE),release)
		FFLAGS ?= -O3 -funroll-loops -Wimplicit-interface -fPIC -fmax-errors=1 \
			-fcoarray=single -J$(BUILD_DIR) -I$(SRC_DIR) $(NCFLAGS)
	else ifeq ($(PROFILE),debug)
		FFLAGS ?= -O0 -g -Wall -Wextra -fPIC -fmax-errors=1 -fcheck=bounds \
			-fcheck=array-temps -fbacktrace -fcoarray=single \
			-J$(BUILD_DIR) -I$(SRC_DIR) $(NCFLAGS)
	endif
else ifeq ($(FC),flang)
	ifeq ($(PROFILE),release)
		FFLAGS ?= -O3 -funroll-loops -fimplicit-none -fPIC \
			-J$(BUILD_DIR) -I$(SRC_DIR) $(NCFLAGS)
	else ifeq ($(PROFILE),debug)
		FFLAGS ?= -O0 -g -funroll-loops -fimplicit-none -fPIC \
			-J$(BUILD_DIR) -I$(SRC_DIR) $(NCFLAGS)
	endif
endif

C_INTERFACE_DIR := $(SRC_DIR)/c_interface
DATA_STRUCTURE_DIR := $(SRC_DIR)/data_structure
NETCDF_DIR := $(SRC_DIR)/netcdf

FYPP_FILESTEMS = \
	nc4f_data_struct_arith \
	nc4f_data_struct_att_ctor \
	nc4f_data_struct_extract \
	nc4f_data_struct_var_ctor
FYPP_INC := $(addprefix $(FYPP_DIR)/, \
	$(addsuffix _inc.fypp, $(FYPP_FILESTEMS)))
FYPP_F90 := $(addprefix $(FYPP_DIR)/, \
	$(addsuffix .fypp, $(FYPP_FILESTEMS)))
SRC_INC := $(patsubst $(FYPP_DIR)/%_inc.fypp, \
	$(DATA_STRUCTURE_DIR)/%.inc,$(FYPP_INC))
SRC_F90 := $(patsubst $(FYPP_DIR)/%.fypp, \
	$(DATA_STRUCTURE_DIR)/%.f90,$(FYPP_F90))

SRC = \
  $(C_INTERFACE_DIR)/nc4f_c_interface.f90 \
	$(DATA_STRUCTURE_DIR)/nc4f_data_struct.f90 \
	$(DATA_STRUCTURE_DIR)/nc4f_data_struct_arith.f90 \
	$(DATA_STRUCTURE_DIR)/nc4f_data_struct_att_ctor.f90 \
	$(DATA_STRUCTURE_DIR)/nc4f_data_struct_att.f90 \
	$(DATA_STRUCTURE_DIR)/nc4f_data_struct_dim.f90 \
	$(DATA_STRUCTURE_DIR)/nc4f_data_struct_extract.f90 \
	$(DATA_STRUCTURE_DIR)/nc4f_data_struct_io.f90 \
	$(DATA_STRUCTURE_DIR)/nc4f_data_struct_util.f90 \
	$(DATA_STRUCTURE_DIR)/nc4f_data_struct_var_ctor.f90 \
	$(DATA_STRUCTURE_DIR)/nc4f_data_struct_var.f90 \
	$(NETCDF_DIR)/nc4f_nc.f90 \
	$(NETCDF_DIR)/nc4f_nc_att.f90 \
	$(NETCDF_DIR)/nc4f_nc_dataset.f90 \
	$(NETCDF_DIR)/nc4f_nc_dim.f90 \
	$(NETCDF_DIR)/nc4f_nc_util.f90 \
	$(NETCDF_DIR)/nc4f_nc_var.f90 \
	$(SRC_DIR)/nc4f.90

TEST_FILES = \
	nc4f_examples.f90 \
	nc4f_test_module.f90 \
	nc4f_test.f90
TEST := $(addprefix $(TEST_DIR)/, $(TEST_FILES))

OBJS = \
	$(BUILD_DIR)/nc4f_c_interface.o \
	$(BUILD_DIR)/nc4f_data_struct.o \
	$(BUILD_DIR)/nc4f_data_struct_arith.o \
	$(BUILD_DIR)/nc4f_data_struct_att_ctor.o \
	$(BUILD_DIR)/nc4f_data_struct_att.o \
	$(BUILD_DIR)/nc4f_data_struct_dim.o \
	$(BUILD_DIR)/nc4f_data_struct_extract.o \
	$(BUILD_DIR)/nc4f_data_struct_io.o \
	$(BUILD_DIR)/nc4f_data_struct_util.o \
	$(BUILD_DIR)/nc4f_data_struct_var_ctor.o \
	$(BUILD_DIR)/nc4f_data_struct_var.o \
	$(BUILD_DIR)/nc4f_nc.o \
	$(BUILD_DIR)/nc4f_nc_att.o \
	$(BUILD_DIR)/nc4f_nc_dataset.o \
	$(BUILD_DIR)/nc4f_nc_dim.o \
	$(BUILD_DIR)/nc4f_nc_util.o \
	$(BUILD_DIR)/nc4f_nc_var.o \
	$(BUILD_DIR)/nc4f.o
TEST_OBJS := $(patsubst $(TEST_DIR)/%.f90,$(BUILD_DIR)/%.o,$(TEST))

.PHONY: all prepare preprocess build library test clean 

all: prepare preprocess build library
test: $(TEST_OBJS) $(TEST_TARGET)
	@printf "\r\033[2K[test] run test: $(TEST_TARGET)\n"
	@$(TEST_TARGET)
library: build create_static_link
build: preprocess $(OBJS)
preprocess: prepare $(SRC_INC) $(SRC_F90)
prepare: create_build_dir

$(TEST_TARGET): $(TEST_OBJS)
	@printf "\r\033[2K[test] create executable: $(TEST_TARGET)"
	@$(FC) -o $(TEST_TARGET) $(TEST_OBJS) $(LIB) $(FFLAGS)

$(BUILD_DIR)/%.o: $(TEST_DIR)/%.f90
	@printf "\r\033[2K[compile] $<"
	@$(FC) -c $(FFLAGS) $< -o $@

create_static_link:
	@printf "\r\033[2K[link] create static library: $(LIB)\n"
	@$(AR) rcs $(LIB) $(OBJS)

$(BUILD_DIR)/%.o: $(C_INTERFACE_DIR)/%.f90
	@printf "\r\033[2K[compile] $<"
	@$(FC) -c $(FFLAGS) $< -o $@

$(BUILD_DIR)/%.o: $(DATA_STRUCTURE_DIR)/%.f90
	@printf "\r\033[2K[compile] $<"
	@$(FC) -c $(FFLAGS) $< -o $@

$(BUILD_DIR)/%.o: $(NETCDF_DIR)/%.f90
	@printf "\r\033[2K[compile] $<"
	@$(FC) -c $(FFLAGS) $< -o $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.f90
	@printf "\r\033[2K[compile] $<"
	@$(FC) -c $(FFLAGS) $< -o $@

$(DATA_STRUCTURE_DIR)/%.inc: $(FYPP_DIR)/%_inc.fypp
	@printf "\r\033[2K[preproc] $<"
	@fypp $< > $@

$(DATA_STRUCTURE_DIR)/%.f90: $(FYPP_DIR)/%.fypp
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
