SRC_DIR := src
FYPP_DIR := fypp
BUILD_DIR := build
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

FYPP_FILESTEMS = \
	nc4f_arithmetic \
	nc4f_attribute_constructor \
	nc4f_extract \
	nc4f_variable_constructor
FYPP_INC := $(addprefix $(FYPP_DIR)/, \
	$(addsuffix _interface.fypp, $(FYPP_FILESTEMS)))
FYPP_F90 := $(addprefix $(FYPP_DIR)/, \
	$(addsuffix .fypp, $(FYPP_FILESTEMS)))
SRC_INC := $(patsubst $(FYPP_DIR)/%_interface.fypp, \
	$(SRC_DIR)/%.inc,$(FYPP_INC))
SRC_F90 := $(patsubst $(FYPP_DIR)/%.fypp, \
	$(SRC_DIR)/%.f90,$(FYPP_F90))

SRC_FILES = \
  nc4f_c_interface.f90 \
	nc4f.f90 \
	nc4f_arithmetic.f90 \
	nc4f_attribute_constructor.f90 \
	nc4f_attribute.f90 \
	nc4f_dataset.f90 \
	nc4f_dimension.f90 \
	nc4f_extract.f90 \
	nc4f_io.f90 \
	nc4f_utility.f90 \
	nc4f_variable.f90 \
	nc4f_variable_constructor.f90
SRC := $(addprefix $(SRC_DIR)/, $(SRC_FILES))

TEST_FILES = \
	nc4f_examples.f90 \
	nc4f_test_module.f90 \
	nc4f_test.f90
TEST := $(addprefix $(TEST_DIR)/, $(TEST_FILES))

OBJS := $(patsubst $(SRC_DIR)/%.f90,$(BUILD_DIR)/%.o,$(SRC))
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

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.f90
	@printf "\r\033[2K[compile] $<"
	@$(FC) -c $(FFLAGS) $< -o $@

$(SRC_DIR)/%.inc: $(FYPP_DIR)/%_interface.fypp
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
