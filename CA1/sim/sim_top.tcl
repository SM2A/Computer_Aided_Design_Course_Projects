	alias clc ".main clear"
	
	clc
	exec vlib work
	vmap work work
	
	set TB					"auto_testbench"
	set hdl_path			"../src/hdl"
	
	set run_time			"-all"

#============================ Add verilog files  ===============================
# Pleas add other module here	
	vlog 	+acc -source  +define+SIM -O0	$hdl_path/fibonacci.v
	vlog 	+acc -source  +define+SIM -O0	$hdl_path/requirements.v
	vlog 	+acc -source  +define+SIM -O0	./tb/$TB.v

#================================ simulation ====================================

	vsim	-voptargs=+acc -debugDB $TB


#======================= adding signals to wave window ==========================


	add wave -hex -group 	 	{TB}				sim:/$TB/*
	add wave -hex -group 	 	{top}				sim:/$TB/test/*	
	add wave -hex -group -r		{all}				sim:/$TB/*

#=========================== Configure wave signals =============================
	
	configure wave -signalnamewidth 2
    

#====================================== run =====================================

	run $run_time 
	