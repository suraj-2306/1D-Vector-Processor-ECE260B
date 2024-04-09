// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac_col (free_clk, gated_clk, reset, out, q_in, q_out, i_inst, fifo_wr, o_inst, o_weight_zero);

parameter bw = 8;
parameter bw_psum = 2*bw+6;
parameter pr = 8;
parameter col_id = 0;

output signed [bw_psum-1:0] out;
input  signed [pr*bw-1:0] q_in;
output signed [pr*bw-1:0] q_out;
input  free_clk, reset;
input gated_clk;
input  [1:0] i_inst; // [1]: execute, [0]: load 
output [1:0] o_inst; // [1]: execute, [0]: load 
output fifo_wr;
output   o_weight_zero;
reg    load_ready_q;
reg    [3:0] cnt_q;
reg    [1:0] inst_q;
reg    [1:0] inst_2q;
reg   signed [pr*bw-1:0] query_q;
reg   signed [pr*bw-1:0] key_q;
wire  signed [bw_psum-1:0] psum;

//Alpha: Pipelining
reg [1:0] inst_3q;
reg [1:0] inst_4q;
reg [1:0] inst_5q;

assign o_inst = inst_q;
assign fifo_wr = inst_5q[1];
assign q_out  = query_q;
assign out = psum;

initial $display("%m");

mac_8in #(.bw(bw), .bw_psum(bw_psum), .pr(pr)) mac_16in_instance (
        .a(query_q), 
        .b(key_q),
	.out(psum),
	//.clk(free_clk),
	.clk(gated_clk),
	.reset(reset)
); 
reg o_weight_assigned;
reg o_weight_assigned_d;
reg o_weight_assigned_dd;
reg o_weight_zero_t;

assign o_weight_zero = o_weight_assigned_dd ? o_weight_zero_t : 0;


/*
always @ (posedge free_clk) begin
  if (reset) begin
    cnt_q <= 0;
    load_ready_q <= 1;
    inst_q <= 0;
    inst_2q <= 0;
    inst_3q <= 0;
    o_weight_zero <= 0;
  end
  else begin
    inst_q <= i_inst;
    inst_2q <= inst_q;
    inst_3q <= inst_2q;
    if (inst_q[0]) begin
       query_q <= q_in;
       if (cnt_q == 9-col_id)begin
         cnt_q <= 0;
         key_q <= q_in;
         load_ready_q <= 0;
	 if(q_in == 0) begin
		o_weight_zero <= 1'b1;
	 end
       end
       else if (load_ready_q)
         cnt_q <= cnt_q + 1;
    end
    else if(inst_q[1]) begin
      //out     <= psum;
      query_q <= q_in;
    end
  end
end
*/
always @ (posedge gated_clk) begin
  if (reset) begin
    cnt_q <= 0;
    load_ready_q <= 1;
    //inst_q <= 0;
    //inst_2q <= 0;
    //inst_3q <= 0;
    o_weight_zero_t <= 0;
    o_weight_assigned <= 1'b0;
  end
  else begin
    //inst_q <= i_inst;
    //inst_2q <= inst_q;
    //inst_3q <= inst_2q;
    if (inst_q[0]) begin
       //query_q <= q_in;
       if (cnt_q == 9-col_id)begin
         cnt_q <= 0;
         key_q <= q_in;
         load_ready_q <= 0;
         if(q_in == 0) begin
          o_weight_zero_t <= 1'b1;
          o_weight_assigned <= 1'b1;
		//o_weight_assigned_d <= o_weight_assigned;
		//o_weight_assigned_dd <= o_weight_assigned_d;
         end
       end
       else if (load_ready_q)
         cnt_q <= cnt_q + 1;
    end
    //else if(inst_q[1]) begin
    //  //out     <= psum;
    //  query_q <= q_in;
    //end
  end
end

always @ (posedge free_clk) begin
	if(reset) begin
		inst_q <= 0;
		inst_2q <= 0;
		inst_3q <= 0;
		inst_4q <= 0;
		inst_5q <= 0;
		query_q <= 0;
		o_weight_assigned_d <= 0;
		o_weight_assigned_dd <= 0;
	end
  	else begin
  	  	inst_q <= i_inst;
  	  	inst_2q <= inst_q;
  	  	inst_3q <= inst_2q;
  	  	inst_4q <= inst_3q;
  	  	inst_5q <= inst_4q;
        o_weight_assigned_d <= o_weight_assigned;
        o_weight_assigned_dd <= o_weight_assigned_d;
    		if (inst_q[0]) begin
			query_q <= q_in;
		end
		if(inst_q[1] && !inst_q[0] ) begin
			query_q <= q_in;
		end
	end
end

endmodule
