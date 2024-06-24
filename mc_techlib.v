`default_nettype none

module \$dff (CLK, D, Q);
	parameter WIDTH = 1;
	parameter CLK_POLARITY = 1'b1;

	input wire CLK;
	input wire [WIDTH-1:0] D;
	output wire [WIDTH-1:0] Q;

	wire _TECHMAP_FAIL_ = WIDTH < 1;

	function integer min;
		input integer a, b;
		begin
			if (a < b) min = a;
			else min = b;
		end
	endfunction

	wire _clk;

	genvar i;
	generate
		if (CLK_POLARITY) begin
			assign _clk = CLK;
		end else begin
			assign _clk = ~CLK;
		end

		for (i = 0; i <= WIDTH/29; i++) begin
			MC_DFF29 #(
				.WIDTH(min(WIDTH - (29 * i), 29)),
			) dff (
				.CLK(_clk),
				.D(D[29 * i +: min(WIDTH - (29 * i), 29)]),
				.Q(Q[29 * i +: min(WIDTH - (29 * i), 29)])
			);
		end
	endgenerate
endmodule

module \$adff (CLK, ARST, D, Q);
	parameter WIDTH = 1;
	parameter CLK_POLARITY = 1'b1;
	parameter ARST_POLARITY = 1'b1;
	parameter ARST_VALUE = {WIDTH{1'b0}};

	input wire CLK, ARST;
	input wire [WIDTH-1:0] D;
	output wire [WIDTH-1:0] Q;

	wire _TECHMAP_FAIL_ = WIDTH < 1;

	function integer min;
		input integer a, b;
		begin
			if (a < b) min = a;
			else min = b;
		end
	endfunction

	wire _clk, _arst;

	genvar i;
	generate
		if (CLK_POLARITY) begin
			assign _clk = CLK;
		end else begin
			assign _clk = ~CLK;
		end
		if (ARST_POLARITY) begin
			assign _arst = ARST;
		end else begin
			assign _arst = ~ARST;
		end

		for (i = 0; i <= WIDTH/29; i++) begin
			MC_ADFF29 #(
				.WIDTH(min(WIDTH - (29 * i), 29)),
				.ARST_VALUE(ARST_VALUE)
			) dff (
				.CLK(_clk),
				.ARST(_arst),
				.D(D[29 * i +: min(WIDTH - (29 * i), 29)]),
				.Q(Q[29 * i +: min(WIDTH - (29 * i), 29)])
			);
		end
	endgenerate
endmodule

module \$sdff (CLK, SRST, D, Q);
	parameter WIDTH = 1;
	parameter CLK_POLARITY = 1'b1;
	parameter SRST_POLARITY = 1'b1;
	parameter SRST_VALUE = {WIDTH{1'b0}};

	input wire CLK, SRST;
	input wire [WIDTH-1:0] D;
	output wire [WIDTH-1:0] Q;

	wire _srst;

	generate
		if (SRST_POLARITY) begin
			assign _srst = SRST;
		end else begin
			assign _srst = ~SRST;
		end
	endgenerate

	\$dff #(
		.WIDTH(WIDTH),
		.CLK_POLARITY(CLK_POLARITY)
	) dff (
		.CLK(CLK),
		.D(_srst ? SRST_VALUE : D),
		.Q(Q)
	);
endmodule

module \$sdffe (CLK, SRST, EN, D, Q);
	parameter WIDTH = 1;
	parameter CLK_POLARITY = 1'b1;
	parameter SRST_POLARITY = 1'b1;
	parameter SRST_VALUE = {WIDTH{1'b0}};
	parameter EN_POLARITY = 1'b1;

	input wire CLK, SRST, EN;
	input wire [WIDTH-1:0] D;
	output wire [WIDTH-1:0] Q;

	wire _en;

	generate
		if (EN_POLARITY) begin
			assign _en = EN;
		end else begin
			assign _en = ~EN;
		end
	endgenerate

	\$sdff #(
		.WIDTH(WIDTH),
		.CLK_POLARITY(CLK_POLARITY),
		.SRST_POLARITY(SRST_POLARITY),
		.SRST_VALUE(SRST_VALUE)
	) sdff (
		.CLK(CLK),
		.SRST(SRST),
		.D(_en ? D : Q),
		.Q(Q)
	);
endmodule

module \$adffe (CLK, ARST, EN, D, Q);
	parameter WIDTH = 1;
	parameter CLK_POLARITY = 1'b1;
	parameter ARST_POLARITY = 1'b1;
	parameter ARST_VALUE = {WIDTH{1'b0}};
	parameter EN_POLARITY = 1'b1;

	input wire CLK, ARST, EN;
	input wire [WIDTH-1:0] D;
	output wire [WIDTH-1:0] Q;

	wire _en;

	generate
		if (EN_POLARITY) begin
			assign _en = EN;
		end else begin
			assign _en = ~EN;
		end
	endgenerate

	\$adff #(
		.WIDTH(WIDTH),
		.CLK_POLARITY(CLK_POLARITY),
		.ARST_POLARITY(ARST_POLARITY),
		.ARST_VALUE(ARST_VALUE)
	) adff (
		.CLK(CLK),
		.ARST(ARST),
		.D(_en ? D : Q),
		.Q(Q)
	);
endmodule
