// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac_8in (out, a, b, clk, reset);

parameter bw = 8;
parameter bw_psum = 2*bw+6;
parameter pr = 64; // parallel factor: number of inputs = 64

input clk;
input reset;

output [bw_psum-1:0] out;
input  [pr*bw-1:0] a;
input  [pr*bw-1:0] b;

reg [2*bw-1:0] product_pipeline_register[0:7];
reg [bw_psum-1:0] sum4_pipeline_register[0:1];
reg [bw_psum-1:0] out_pipeline_register;

wire		[bw_psum-1:0]	sum4_0	;
wire		[bw_psum-1:0]	sum4_1	;
wire		[bw_psum-1:0]	sum8	;


wire		[2*bw-1:0]	product0	;
wire		[2*bw-1:0]	product1	;
wire		[2*bw-1:0]	product2	;
wire		[2*bw-1:0]	product3	;
wire		[2*bw-1:0]	product4	;
wire		[2*bw-1:0]	product5	;
wire		[2*bw-1:0]	product6	;
wire		[2*bw-1:0]	product7	;


genvar i;



wire [bw-1:0] check_a0 = b[bw*   1       -1:bw*  0       ];
wire [bw-1:0] check_a1 = b[bw*   2       -1:bw*  1       ];
wire [bw-1:0] check_a2 = b[bw*   3       -1:bw*  2       ];
wire [bw-1:0] check_a3 = b[bw*   4       -1:bw*  3       ];
wire [bw-1:0] check_a4 = b[bw*   5       -1:bw*  4       ];
wire [bw-1:0] check_a5 = b[bw*   6       -1:bw*  5       ];
wire [bw-1:0] check_a6 = b[bw*   7       -1:bw*  6       ];
wire [bw-1:0] check_a7 = b[bw*   8       -1:bw*  7       ];


assign	product0	=	{{(bw){a[bw*	1	-1]}},	a[bw*	1	-1:bw*	0	]}	*	{{(bw){b[bw*	1	-1]}},	b[bw*	1	-1:	bw*	0	]};
assign	product1	=	{{(bw){a[bw*	2	-1]}},	a[bw*	2	-1:bw*	1	]}	*	{{(bw){b[bw*	2	-1]}},	b[bw*	2	-1:	bw*	1	]};
assign	product2	=	{{(bw){a[bw*	3	-1]}},	a[bw*	3	-1:bw*	2	]}	*	{{(bw){b[bw*	3	-1]}},	b[bw*	3	-1:	bw*	2	]};
assign	product3	=	{{(bw){a[bw*	4	-1]}},	a[bw*	4	-1:bw*	3	]}	*	{{(bw){b[bw*	4	-1]}},	b[bw*	4	-1:	bw*	3	]};
assign	product4	=	{{(bw){a[bw*	5	-1]}},	a[bw*	5	-1:bw*	4	]}	*	{{(bw){b[bw*	5	-1]}},	b[bw*	5	-1:	bw*	4	]};
assign	product5	=	{{(bw){a[bw*	6	-1]}},	a[bw*	6	-1:bw*	5	]}	*	{{(bw){b[bw*	6	-1]}},	b[bw*	6	-1:	bw*	5	]};
assign	product6	=	{{(bw){a[bw*	7	-1]}},	a[bw*	7	-1:bw*	6	]}	*	{{(bw){b[bw*	7	-1]}},	b[bw*	7	-1:	bw*	6	]};
assign	product7	=	{{(bw){a[bw*	8	-1]}},	a[bw*	8	-1:bw*	7	]}	*	{{(bw){b[bw*	8	-1]}},	b[bw*	8	-1:	bw*	7	]};

assign sum4_0 = 
		{{(4){product_pipeline_register[0][2*bw-1]}},product_pipeline_register[0]	}
	+	{{(4){product_pipeline_register[1][2*bw-1]}},product_pipeline_register[1]	}
	+	{{(4){product_pipeline_register[2][2*bw-1]}},product_pipeline_register[2]	}
	+	{{(4){product_pipeline_register[3][2*bw-1]}},product_pipeline_register[3]	};

assign sum4_1 = 
		{{(4){product_pipeline_register[4][2*bw-1]}},product_pipeline_register[4]	}
	+	{{(4){product_pipeline_register[5][2*bw-1]}},product_pipeline_register[5]	}
	+	{{(4){product_pipeline_register[6][2*bw-1]}},product_pipeline_register[6]	}
	+	{{(4){product_pipeline_register[7][2*bw-1]}},product_pipeline_register[7]	};

assign sum8 = sum4_pipeline_register[0] + sum4_pipeline_register[1];

//Alpha: Pipelining in MAC PE
always @(posedge clk) begin
	if(reset) begin
		product_pipeline_register[0] <= 0;
		product_pipeline_register[1] <= 0;
		product_pipeline_register[2] <= 0;
		product_pipeline_register[3] <= 0;
		product_pipeline_register[4] <= 0;
		product_pipeline_register[5] <= 0;
		product_pipeline_register[6] <= 0;
		product_pipeline_register[7] <= 0;
	end
	else begin
		product_pipeline_register[0] <= product0;
		product_pipeline_register[1] <= product1;
		product_pipeline_register[2] <= product2;
		product_pipeline_register[3] <= product3;
		product_pipeline_register[4] <= product4;
		product_pipeline_register[5] <= product5;
		product_pipeline_register[6] <= product6;
		product_pipeline_register[7] <= product7;
	end
end

always @(posedge clk) begin
	if(reset) begin
		sum4_pipeline_register[0] <= 0;
		sum4_pipeline_register[1] <= 0;
	end
	else begin
		sum4_pipeline_register[0] <= sum4_0;
		sum4_pipeline_register[1] <= sum4_1;
	end
end

always @(posedge clk) begin
	if(reset) begin
		out_pipeline_register <= 0;
	end
	else begin
		out_pipeline_register <= sum8;
	end
end

assign out = out_pipeline_register;
//assign out = 
//                {{(4){product_pipeline_register[0][2*bw-1]}},product_pipeline_register[0]	}
//	+	{{(4){product_pipeline_register[1][2*bw-1]}},product_pipeline_register[1]	}
//	+	{{(4){product_pipeline_register[2][2*bw-1]}},product_pipeline_register[2]	}
//	+	{{(4){product_pipeline_register[3][2*bw-1]}},product_pipeline_register[3]	}
//	+	{{(4){product_pipeline_register[4][2*bw-1]}},product_pipeline_register[4]	}
//	+	{{(4){product_pipeline_register[5][2*bw-1]}},product_pipeline_register[5]	}
//	+	{{(4){product_pipeline_register[6][2*bw-1]}},product_pipeline_register[6]	}
//	+	{{(4){product_pipeline_register[7][2*bw-1]}},product_pipeline_register[7]	};

endmodule
