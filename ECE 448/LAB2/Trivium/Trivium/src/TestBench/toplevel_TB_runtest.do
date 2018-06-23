SetActiveLib -work
comp -include "$DSN\src\TopLevel.vhd" 
comp -include "$DSN\src\TestBench\toplevel_TB.vhd" 
asim TESTBENCH_FOR_toplevel 
wave 
wave -noreg RST
wave -noreg CLK
wave -noreg Key_IV
wave -noreg Plaintext
wave -noreg Initialized
wave -noreg loading_iv
wave -noreg loading_key
wave -noreg Ciphertext
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$DSN\src\TestBench\toplevel_TB_tim_cfg.vhd" 
# asim TIMING_FOR_toplevel 
