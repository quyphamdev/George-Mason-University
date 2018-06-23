SetActiveLib -work
comp -include "$DSN\src\SerialFIRFilter.vhd" 
comp -include "$DSN\src\TestBench\serialfirfilter_TB.vhd" 
asim TESTBENCH_FOR_serialfirfilter 
wave 
wave -noreg CLK
wave -noreg Reset
wave -noreg samp_i
wave -noreg data_i
wave -noreg samp_o
wave -noreg data_o
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$DSN\src\TestBench\serialfirfilter_TB_tim_cfg.vhd" 
# asim TIMING_FOR_serialfirfilter 
