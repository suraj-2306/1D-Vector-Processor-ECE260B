
set clock_cycle 1 
set io_delay 0.2 

set clock_port clk

create_clock -name clk -period $clock_cycle [get_ports $clock_port]

set_input_delay  $io_delay -clock $clock_port [all_inputs] 
set_output_delay $io_delay -clock $clock_port [all_outputs]

set_false_path -from [get_ports reset]
#set_multicycle_path -setup 2 -from [get_cells fifo_top_instance/fifo_instance/rd_ptr_*] -to [get_cells out_reg*]
#set_multicycle_path -setup 2 -from [get_cells sum_q_reg*] -to [get_cells out_reg*]
#set_multicycle_path -setup 2 -from [get_cells fifo_top_instance/fifo_instance/q*] -to [get_cells out_reg*]
#set_mutlicycle_path -hold 1 -from [get_cells fifo_top_instance/fifo_instance/q*] -to [get_cells out_reg*]
#set_multicycle_path -hold 1 -from [get_cells sum_q_reg*] -to [get_cells out_reg*]
#set_multicycle_path -hold 1 -from [get_cells fifo_top_instance/fifo_instance/rd_ptr_*] -to [get_cells out_reg*]
