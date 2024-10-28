SIM=icarus
TOPLEVEL_LANG=verilog

HDL_DIR := ../hdl

VERILOG_SOURCES := $(wildcard $(HDL_DIR)/*.v)
TOPLEVEL = scrambler_top
MODULE = PCIe_scrambler

# Optional: Set time unit and precision (if needed)
# COCOTB_HDP_TIMEUNIT=1ps
# COCOTB_HDP_TIMEPRECISION=1ps
COCOTB_REDUCED_LOG_FMT = True
include $(shell cocotb-config --makefiles)/Makefile.sim
