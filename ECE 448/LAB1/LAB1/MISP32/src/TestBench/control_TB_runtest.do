SetActiveLib -work
comp -include "$DSN\src\Control.vhd" 
comp -include "$DSN\src\TestBench\control_TB.vhd" 
asim TESTBENCH_FOR_control 
wave 
wave -noreg opcode
wave -noreg Funct
wave -noreg SignExt
wave -noreg ALUSrc
wave -noreg RegWrite
wave -noreg RegDst
wave -noreg ALU_OP
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$DSN\src\TestBench\control_TB_tim_cfg.vhd" 
# asim TIMING_FOR_control 
