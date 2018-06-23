onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /parallelfirfilter_tb/clk
add wave -noupdate -format Logic /parallelfirfilter_tb/reset
add wave -noupdate -format Logic /parallelfirfilter_tb/samp_i
add wave -noupdate -format Literal /parallelfirfilter_tb/data_i
add wave -noupdate -format Logic /parallelfirfilter_tb/samp_o
add wave -noupdate -format Analog-Step -height 300 /parallelfirfilter_tb/data_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
configure wave -namecolwidth 186
configure wave -valuecolwidth 82
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {12938805 ps} {14969909 ps}
