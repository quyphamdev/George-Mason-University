SetActiveLib -work
comp -include "$DSN\src\alu.vhd" 
comp -include "$DSN\src\TestBench\alu_TB.vhd" 
asim TESTBENCH_FOR_alu 
wave 
wave -noreg ALU_OP
wave -noreg A
wave -noreg B
wave -noreg Result
wave -noreg Zero
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$DSN\src\TestBench\alu_TB_tim_cfg.vhd" 
# asim TIMING_FOR_alu 
