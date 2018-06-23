SetActiveLib -work
comp -include "Z:\ECE448\ece448lab3\multiplier\src\comboarraymulcell.vhd" 
comp -include "$DSN\src\TestBench\comboarraymulcell_TB.vhd" 
asim TESTBENCH_FOR_comboarraymulcell 
wave 
wave -noreg sin
wave -noreg am
wave -noreg cin
wave -noreg xn
wave -noreg sout
wave -noreg cout
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$DSN\src\TestBench\comboarraymulcell_TB_tim_cfg.vhd" 
# asim TIMING_FOR_comboarraymulcell 
