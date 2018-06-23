SetActiveLib -work
comp -include "$DSN\src\TopLevel.vhd" 
comp -include "$DSN\src\TestBench\toplevel_TB.vhd" 
asim TESTBENCH_FOR_toplevel 
wave 
wave -noreg Instruction
wave -noreg Reg_B
wave -noreg Reg_A
wave -noreg Rs_addr
wave -noreg Rt_addr
wave -noreg Rd_addr
wave -noreg Result
wave -noreg Zero
wave -noreg RegWrite
wave -noreg RegDst
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$DSN\src\TestBench\toplevel_TB_tim_cfg.vhd" 
# asim TIMING_FOR_toplevel 
