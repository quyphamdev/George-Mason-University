SetActiveLib -work
comp -include "$DSN\src\ParallelFIRFilter.vhd" 
comp -include "$DSN\src\TestBench\parallelfirfilter_TB.vhd" 
asim TESTBENCH_FOR_parallelfirfilter 
wave 
wave -noreg CLK
wave -noreg reset
wave -noreg samp_i
wave -noreg data_i
wave -noreg samp_o
wave -noreg data_o
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$DSN\src\TestBench\parallelfirfilter_TB_tim_cfg.vhd" 
# asim TIMING_FOR_parallelfirfilter 
