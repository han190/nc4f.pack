SRC_DIR := src
FYPP_DIR := fypp
BUILD_DIR := build
TEST_DIR := test
LIB := $(BUILD_DIR)/ncpack.a
TEST_TARGET := $(BUILD_DIR)/test
PROFILE ?= debug
FC := gfortran
NCFLAGS := $(shell pkg-config --cflags --libs netcdf)

ifeq ($(PROFILE),release)
  FFLAGS ?= -O3 -funroll-loops -Wimplicit-interface \
		-fPIC -fmax-errors=1 -fcoarray=single -fPIC \
		-J$(BUILD_DIR) -I$(SRC_DIR) $(NCFLAGS)
else ifeq ($(PROFILE),debug)
  FFLAGS ?= -Wall -Wextra -fPIC -fmax-errors=1 -g \
		-fcheck=bounds -fcheck=array-temps -fbacktrace -fcoarray=single \
		-J$(BUILD_DIR) -I$(SRC_DIR) $(NCFLAGS)
else
  $(warning Unknown PROFILE '$(PROFILE)'; using release settings)
  FFLAGS ?= -O3 -funroll-loops -Wimplicit-interface \
		-fPIC -fmax-errors=1 -fcoarray=single -fPIC \
		-J$(BUILD_DIR) -I$(SRC_DIR) $(NCFLAGS)
endif

FYPP_INC := $(sort $(wildcard $(FYPP_DIR)/interface_*.fypp))
FYPP_F90 := $(sort $(wildcard $(FYPP_DIR)/submodule_*.fypp))
SRC_INC := $(patsubst $(FYPP_DIR)/%.fypp,$(SRC_DIR)/%.inc,$(FYPP_INC))
SRC_F90 := $(patsubst $(FYPP_DIR)/%.fypp,$(SRC_DIR)/%.f90,$(FYPP_F90))
SRC := $(sort $(wildcard $(SRC_DIR)/*.f90) $(SRC_F90))
TEST := $(sort $(wildcard $(TEST_DIR)/*.f90))

OBJS := $(patsubst $(SRC_DIR)/%.f90,$(BUILD_DIR)/%.o,$(SRC))
TEST_OBJS := $(patsubst $(TEST_DIR)/%.f90,$(BUILD_DIR)/%.o,$(TEST))

.PHONY: all prepare preprocess build library test clean 

all: prepare preprocess build library
test: $(TEST_OBJS) $(TEST_TARGET)
	@echo "[test] run test: $(TEST_TARGET)"
	@$(TEST_TARGET)
library: build create_static_link
build: preprocess $(OBJS)
preprocess: prepare $(SRC_INC) $(SRC_F90)
prepare: create_build_dir

$(TEST_TARGET): $(TEST_OBJS)
	@echo "[test] create executable: $(TEST_TARGET)"
	@$(FC) -o $(TEST_TARGET) $(TEST_OBJS) $(LIB) $(FFLAGS)

$(BUILD_DIR)/%.o: $(TEST_DIR)/%.f90
	@echo "[compile] $<"
	@$(FC) -c $(FFLAGS) $< -o $@

create_static_link:
	@echo "[link] create static library: $(LIB)"
	@$(AR) rcs $(LIB) $(OBJS)

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.f90
	@echo "[compile] $<"
	@$(FC) -c $(FFLAGS) $< -o $@

$(SRC_DIR)/%.inc: $(FYPP_DIR)/%.fypp
	@echo "[preproc] $<"
	@fypp $< > $@

$(SRC_DIR)/%.f90: $(FYPP_DIR)/%.fypp
	@echo "[preproc] $<"
	@fypp $< > $@

create_build_dir:
	@echo "[prepare] create directory $(BUILD_DIR)"
	@mkdir -p $(BUILD_DIR)

clean:
	@echo "[clean] remove temporary files."
	@$(RM) *.nc
	@echo "[clean] remove generated source files."
	@$(RM) $(SRC_INC) $(SRC_F90)
	@echo "[clean] remove directory $(BUILD_DIR)"
	@$(RM) -r $(BUILD_DIR)/
