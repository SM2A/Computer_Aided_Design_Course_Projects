	alias clc ".main clear"
	
	clc
	exec vlib work
	vmap work work
	
	set TB					"test_bench"
	set hdl_path			"../src/hdl"
	
	set run_time			"-all"

#============================ Add verilog files  ===============================
# Pleas add other module here	
	vlog 	+acc -source  +define+SIM -O0	$hdl_path/Controller_Components.v
	vlog 	+acc -source  +define+SIM -O0	$hdl_path/Controller.v
	vlog 	+acc -source  +define+SIM -O0	$hdl_path/DataPath_Components.v
	vlog 	+acc -source  +define+SIM -O0	$hdl_path/DataPath.v
	vlog 	+acc -source  +define+SIM -O0	$hdl_path/Memory.v
	vlog 	+acc -source  +define+SIM -O0	$hdl_path/MLP.v
	vlog 	+acc -source  +define+SIM -O0	$hdl_path/Neuron_Components.v
	vlog 	+acc -source  +define+SIM -O0	$hdl_path/Neuron_Controller.v
	vlog 	+acc -source  +define+SIM -O0	$hdl_path/Neuron_DatePath.v
	vlog 	+acc -source  +define+SIM -O0	$hdl_path/Neurons.v
	vlog 	+acc -source  +define+SIM -O0	$hdl_path/SingleNeuron.v
	vlog 	+acc -source  +define+SIM -O0	$hdl_path/SingleNeuronTB.v
	vlog 	+acc -source  +define+SIM -O0	./tb/$TB.v

#================================ simulation ====================================

	vsim	-voptargs=+acc -debugDB $TB


#======================= adding signals to wave window ==========================


	add wave -unsigned -group 	 	{TB}				sim:/$TB/*
	add wave -unsigned -group 	 	{top}				sim:/$TB/test/*	
	add wave -unsigned -group -r	{all}				sim:/$TB/*

#=========================== Configure wave signals =============================
	
	configure wave -signalnamewidth 2
    

#====================================== run =====================================

	run $run_time 
	