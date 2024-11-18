SIM=icarus
TOPLEVEL_LANG=verilog

HDL_DIR := ../hdl

# Include both Verilog files and the header file
VERILOG_SOURCES := $(wildcard $(HDL_DIR)/*.v)
# IVERILOG_INCLUDE = -I $(HDL_DIR)

TOPLEVEL = scrambler_top
MODULE = PCIe_scrambler

# Optional: Set time unit and precision (if needed)
# COCOTB_HDP_TIMEUNIT=1ps
# COCOTB_HDP_TIMEPRECISION=1ps
COCOTB_REDUCED_LOG_FMT = True

# Pass the include directory to Icarus Verilog
COMPILE_ARGS += -I$(HDL_DIR)
include $(shell cocotb-config --makefiles)/Makefile.sim
