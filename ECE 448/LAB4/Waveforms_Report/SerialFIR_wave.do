onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /serialfirfilter_tb/clk
add wave -noupdate -format Logic /serialfirfilter_tb/reset
add wave -noupdate -format Logic /serialfirfilter_tb/samp_i
add wave -noupdate -format Literal /serialfirfilter_tb/data_i
add wave -noupdate -format Logic /serialfirfilter_tb/samp_o
add wave -noupdate -format Analog-Step -height 300 /serialfirfilter_tb/data_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
configure wave -namecolwidth 180
configure wave -valuecolwidth 68
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
WaveRestoreZoom {103546025 ps} {183661993 ps}
