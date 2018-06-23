SetActiveLib -work
comp -include "$DSN\src\PipelineComboArrayMultiplier.vhd" 
comp -include "$DSN\src\TestBench\pipelinecomboarraymultiplier_TB.vhd" 
asim TESTBENCH_FOR_pipelinecomboarraymultiplier 
wave 
wave -noreg a
wave -noreg x
wave -noreg CLK
wave -noreg p
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$DSN\src\TestBench\pipelinecomboarraymultiplier_TB_tim_cfg.vhd" 
# asim TIMING_FOR_pipelinecomboarraymultiplier 
