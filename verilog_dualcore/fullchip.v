// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module fullchip (clk, mem_in_core0, mem_in_core1, inst, reset, out);

parameter col = 8;
parameter bw = 8;
parameter bw_psum = 2*bw+4;
parameter pr = 16;

input  clk; 
input  [pr*bw-1:0] mem_in_core0; 
input  [pr*bw-1:0] mem_in_core1; 
input  [18:0] inst; 
input  reset;
output [2*col*bw_psum-1:0] out;


wire core1_to_core0_fifo_rd;
wire [bw_psum+3:0] core1_to_core0_sum_in;
wire [bw_psum+3:0] core0_to_core1_sum_out;

wire core0_to_core1_fifo_rd;
wire [bw_psum+3:0] core0_to_core1_sum_in;
wire [bw_psum+3:0] core1_to_core0_sum_out;

//FIXME discuss when to keep 1, working for a simple case with always 1
assign core1_to_core0_fifo_rd = 'b1;
//assign core1_to_core0_sum_in = 'b1;

//FIXME discuss when to keep 1, working for a simple case with always 1
assign core0_to_core1_fifo_rd = 'b1;
//assign core0_to_core1_sum_in = 'b1;

core #(.bw(bw), .bw_psum(bw_psum), .col(col), .pr(pr)) core_instance0 (
      .reset(reset), 
      .clk(clk), 
      .mem_in(mem_in_core0), 
      .inst(inst),
      .sum_in(core1_to_core0_sum_in),
      .out(out[col*bw_psum-1:0]),
      .sfp_sum_fifo_rd(core1_to_core0_fifo_rd),
      .sum_out(core0_to_core1_sum_out)
);

core #(.bw(bw), .bw_psum(bw_psum), .col(col), .pr(pr)) core_instance1 (
      .reset(reset), 
      .clk(clk), 
      .mem_in(mem_in_core1), 
      .inst(inst),
      .sum_in(core0_to_core1_sum_out),
      .out(out[2*col*bw_psum-1:col*bw_psum]),
      .sfp_sum_fifo_rd(core0_to_core1_fifo_rd),
      .sum_out(core1_to_core0_sum_in)
);

endmodule
