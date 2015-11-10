onerror {quit -f}
vlib work
vlog -work work Mips.vo
vlog -work work Mips.vt
vsim -novopt -c -t 1ps -L cycloneii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.hazard_detection_vlg_vec_tst
vcd file -direction Mips.msim.vcd
vcd add -internal hazard_detection_vlg_vec_tst/*
vcd add -internal hazard_detection_vlg_vec_tst/i1/*
add wave /*
run -all
