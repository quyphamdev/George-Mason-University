SetActiveLib -work
comp -include "$DSN\compile\lc3b_bd.vhd" 
comp -include "$DSN\src\TestBench\lc3b_bd_TB.vhd" 
asim TESTBENCH_FOR_lc3b_bd 
wave 
wave -noreg CLK
wave -noreg RESET_L
wave -noreg START_H
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$DSN\src\TestBench\lc3b_bd_TB_tim_cfg.vhd" 
# asim TIMING_FOR_lc3b_bd 
