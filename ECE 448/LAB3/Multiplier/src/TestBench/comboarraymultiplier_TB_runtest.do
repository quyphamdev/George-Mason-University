SetActiveLib -work
comp -include "Z:\ECE448\ECE448Lab3\Multiplier\src\ComboArrayMultiplier.vhd" 
comp -include "$DSN\src\TestBench\comboarraymultiplier_TB.vhd" 
asim TESTBENCH_FOR_comboarraymultiplier 
wave 
wave -noreg a
wave -noreg x
wave -noreg p
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$DSN\src\TestBench\comboarraymultiplier_TB_tim_cfg.vhd" 
# asim TIMING_FOR_comboarraymultiplier 
