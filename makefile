SRC_DIR := src
FYPP_DIR := fypp
BUILD_DIR := build
TEST_DIR := test
LIB := $(BUILD_DIR)/ncpack.a
PROFILE ?= release
FC := gfortran
NCFLAGS := $(shell pkg-config --cflags --libs netcdf-fortran)

ifeq ($(PROFILE),release)
  FFLAGS ?= -O3 -march=native -ffast-math -funroll-loops \
		-J$(BUILD_DIR) -I$(SRC_DIR) $(NCFLAGS)
else ifeq ($(PROFILE),debug)
  FFLAGS ?= -O0 -g -fbacktrace -Wall -Wextra \
		-J$(BUILD_DIR) -I$(SRC_DIR) $(NCFLAGS)
else
  $(warning Unknown PROFILE '$(PROFILE)'; using release settings)
  FFLAGS ?= -O3 -J$(BUILD_DIR) -I$(SRC_DIR) $(NCFLAGS)
endif

FYPP_INC_FILES := \
  $(FYPP_DIR)/interface_arithmetic.fypp \
  $(FYPP_DIR)/interface_extract.fypp \
  $(FYPP_DIR)/interface_variable_constructor.fypp \
  $(FYPP_DIR)/interface_attribute_constructor.fypp

FYPP_F90_FILES := \
	$(FYPP_DIR)/submodule_arithmetic.fypp \
	$(FYPP_DIR)/submodule_attribute_constructor.fypp \
	$(FYPP_DIR)/submodule_extract.fypp \
	$(FYPP_DIR)/submodule_variable_constructor.fypp

INC_FILES := \
  $(SRC_DIR)/interface_arithmetic.inc \
  $(SRC_DIR)/interface_extract.inc \
  $(SRC_DIR)/interface_variable_constructor.inc \
  $(SRC_DIR)/interface_attribute_constructor.inc

F90_FILES := \
	$(SRC_DIR)/submodule_arithmetic.f90 \
	$(SRC_DIR)/submodule_attribute_constructor.f90 \
	$(SRC_DIR)/submodule_extract.f90 \
	$(SRC_DIR)/submodule_variable_constructor.f90

SRC_FILES := \
	$(SRC_DIR)/interface_arithmetic.inc	\
 	$(SRC_DIR)/interface_attribute_constructor.inc	\
	$(SRC_DIR)/interface_extract.inc	\
	$(SRC_DIR)/interface_variable_constructor.inc	\
 	$(SRC_DIR)/module_c_interface.f90	\
	$(SRC_DIR)/module_netcdf.f90	\
 	$(SRC_DIR)/submodule_arithmetic.f90	\
 	$(SRC_DIR)/submodule_attribute_constructor.f90	\
 	$(SRC_DIR)/submodule_attribute.f90	\
 	$(SRC_DIR)/submodule_dataset.f90	\
 	$(SRC_DIR)/submodule_dimension.f90	\
	$(SRC_DIR)/submodule_extract.f90	\
 	$(SRC_DIR)/submodule_io.f90	\
 	$(SRC_DIR)/submodule_utility.f90	\
	$(SRC_DIR)/submodule_variable_constructor.f90	\
 	$(SRC_DIR)/submodule_variable.f90

TEST_FILES := \
	$(TEST_DIR)/module_examples.f90 \
	$(TEST_DIR)/module_test.f90

OBJ_FILES := $(patsubst $(SRC_DIR)/%.f90,$(BUILD_DIR)/%.o,$(SRC_FILES))
TEST_OBJ_FILES := $(patsubst $(TEST_DIR)/%.f90,$(BUILD_DIR)/%.o,$(TEST_FILES))

.PHONY: all prepare preprocess build library test clean 

test: library $(TEST_OBJ_FILES)
library: build
	$(AR) rcs $(LIB) $(OBJ_FILES)
build: preprocess $(OBJ_FILES)
preprocess: prepare $(INC_FILES) $(F90_FILES)
prepare:
	mkdir -p $(BUILD_DIR)

$(SRC_DIR)/%.inc: $(FYPP_DIR)/%.fypp
	fypp $< > $@

$(SRC_DIR)/%.f90: $(FYPP_DIR)/%.fypp
	fypp $< > $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.f90
	$(FC) -c $(FFLAGS) $< -o $@

$(BUILD_DIR)/%.o: $(TEST_DIR)/%.f90 $(LIB)
	$(FC) -c $(FFLAGS) $< -o $@ -L$(LIB)

clean:
	$(RM) $(INC_FILES) $(F90_FILES)
	$(RM) -r $(BUILD_DIR)/