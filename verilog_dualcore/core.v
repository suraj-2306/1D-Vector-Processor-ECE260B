// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module core (clk,
		reset,
		inst,
		mem_in,		//For MAC Array
		sum_in,		//For SFP
		out,		//Final Output
		sfp_sum_fifo_rd,
		sum_out		//For other core's SFP
	);

parameter col = 8;
parameter bw = 8;
parameter bw_psum = 2*bw+4;
parameter pr = 8;

output [bw_psum+3:0] sum_out;
output [bw_psum*col-1:0] out;
wire   [bw_psum*col-1:0] pmem_out;
input  [pr*bw-1:0] mem_in;
input  clk;
input  [18:0] inst; 
input  reset;
input  sfp_sum_fifo_rd;
input [bw_psum+3:0] sum_in;

wire  [pr*bw-1:0] mac_in;
wire  [pr*bw-1:0] kmem_out;
wire  [pr*bw-1:0] qmem_out;
wire  [bw_psum*col-1:0] pmem_in;
wire  [bw_psum*col-1:0] fifo_out;
wire  [bw_psum*col-1:0] sfp_out;
wire  [bw_psum*col-1:0] array_out;
wire  [col-1:0] fifo_wr;
wire  ofifo_rd;
wire [3:0] qkmem_add;
wire [3:0] pmem_add;

wire  qmem_rd;
wire  qmem_wr; 
wire  kmem_rd;
wire  kmem_wr; 
wire  pmem_rd;
wire  pmem_wr; 

//SFP
wire acc;
wire div;
wire fifo_ext_rd;
wire [bw_psum+3:0] sfp_ext_sum_in;
wire [col*bw_psum-1:0] pmem_in_from_sfp;

assign ofifo_rd = inst[16];
assign qkmem_add = inst[15:12];
assign pmem_add = inst[11:8];

assign qmem_rd = inst[5];
assign qmem_wr = inst[4];
assign kmem_rd = inst[3];
assign kmem_wr = inst[2];
assign pmem_rd = inst[1];
assign pmem_wr = inst[0];

assign mac_in  = inst[6] ? kmem_out : qmem_out;
//assign pmem_in = fifo_out;
assign pmem_in = inst[18] ? pmem_in_from_sfp : fifo_out; //FIXME

//FIXME: SFP Signals temporary
assign acc = inst[17];
assign div = inst[18];
assign fifo_ext_rd = sfp_sum_fifo_rd; //FIXME: This should be from an input to core
assign sfp_ext_sum_in = sum_in; //FIXME: This should be from an input to core
assign out = pmem_out; //FIXME: Temporary for Step 1
	
mac_array #(.bw(bw), .bw_psum(bw_psum), .col(col), .pr(pr)) mac_array_instance (
        .in(mac_in), 
        .clk(clk), 
        .reset(reset), 
        .inst(inst[7:6]),     
        .fifo_wr(fifo_wr),     
	.out(array_out)
);

ofifo #(.bw(bw_psum), .col(col))  ofifo_inst (
        .reset(reset),
        .clk(clk),
        .in(array_out),
        .wr(fifo_wr),
        .rd(ofifo_rd),
        .o_valid(fifo_valid),
        .out(fifo_out)
);


sram_w16_64 #(.sram_bit(pr*bw)) qmem_instance (
        .CLK(clk),
        .D(mem_in),
        .Q(qmem_out),
        .CEN(!(qmem_rd||qmem_wr)),
        .WEN(!qmem_wr), 
        .A(qkmem_add)
);

sram_w16_64 #(.sram_bit(pr*bw)) kmem_instance (
        .CLK(clk),
        .D(mem_in),
        .Q(kmem_out),
        .CEN(!(kmem_rd||kmem_wr)),
        .WEN(!kmem_wr), 
        .A(qkmem_add)
);

sram_w16_160 #(.sram_bit(col*bw_psum)) psum_mem_instance (
        .CLK(clk),
        .D(pmem_in),
        .Q(pmem_out),
        .CEN(!(pmem_rd||pmem_wr)),
        .WEN(!pmem_wr), 
        .A(pmem_add)
);

//FIXME: Step 2
sfp_row #(.col(col), .bw(bw)) sfp_instance (
	.clk(clk),
	.acc(acc),
	.div(div),
	.fifo_ext_rd(fifo_ext_rd),
	.sum_in(sfp_ext_sum_in),
	.sum_out(sum_out),
	.sfp_in(pmem_out),
	.sfp_out(pmem_in_from_sfp)
);

  //////////// For printing purpose ////////////
  always @(posedge clk) begin
      if(pmem_wr)
         $display("[%m] Memory write to PSUM mem add %x %x ", pmem_add, pmem_in); 
      //if(qmem_wr)
      //   $display("Memory write to QMEM add %x %x ", qkmem_add, mem_in); 
      //if(kmem_wr)
      //   $display("Memory write to KMEM add %x %x ", qkmem_add, mem_in);
      //if(mac_array_instance.inst > 0)
      //   $display("MAC instruction valid: inst/mac_in %x %x ", inst[7:6], mac_in);
      //if(fifo_wr)
      //   $display("MAC write to OFIFO %x ", array_out);

  end


endmodule
