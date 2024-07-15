`default_nettype none

module \$dff (CLK, D, Q);
	parameter WIDTH = 1;
	parameter CLK_POLARITY = 1'b1;

	input wire CLK;
	(* force_downto *)
	input wire [WIDTH-1:0] D;
	(* force_downto *)
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

		for (i = 0; i <= WIDTH/31; i++) begin
			MC_DFF31 #(
				.WIDTH(min(WIDTH - (31 * i), 31)),
			) dff (
				.CLK(_clk),
				.D(D[31 * i +: min(WIDTH - (31 * i), 31)]),
				.Q(Q[31 * i +: min(WIDTH - (31 * i), 31)])
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
	(* force_downto *)
	input wire [WIDTH-1:0] D;
	(* force_downto *)
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

		for (i = 0; i <= WIDTH/31; i++) begin
			MC_ADFF31 #(
				.WIDTH(min(WIDTH - (31 * i), 31)),
				.ARST_VALUE(ARST_VALUE)
			) dff (
				.CLK(_clk),
				.ARST(_arst),
				.D(D[31 * i +: min(WIDTH - (31 * i), 31)]),
				.Q(Q[31 * i +: min(WIDTH - (31 * i), 31)])
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
	(* force_downto *)
	input wire [WIDTH-1:0] D;
	(* force_downto *)
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
	(* force_downto *)
	input wire [WIDTH-1:0] D;
	(* force_downto *)
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
	(* force_downto *)
	input wire [WIDTH-1:0] D;
	(* force_downto *)
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

module \$reduce_and (A, Y);
	parameter A_SIGNED = 0;
	parameter A_WIDTH = 2;
	parameter Y_WIDTH = 1;

	(* force_downto *)
	input wire [A_WIDTH-1:0] A;
	(* force_downto *)
	output wire [Y_WIDTH-1:0] Y;

	wire _TECHMAP_FAIL_ = (A_WIDTH < 1) || (Y_WIDTH < 1);
	wire [1023:0] _TECHMAP_DO_ = "opt";

	function integer min;
		input integer a, b;
		begin
			if (a < b) min = a;
			else min = b;
		end
	endfunction

	genvar i;
	generate
		if (Y_WIDTH > 1) begin
			assign Y[Y_WIDTH-1:1] = 1'b0;
		end

		if (A_WIDTH == 1) begin
			assign Y[0] = A[0];
		end else if (A_WIDTH == 2) begin
			assign Y[0] = A[0] & A[1];
		end else if (A_WIDTH <= 16) begin
			MC_UAND16 #(
				.WIDTH(A_WIDTH),
			) _TECHMAP_REPLACE_ (
				.A(A),
				.Y(Y[0])
			);
		end else begin
			wire [A_WIDTH/16:0] _collate;
			for (i = 0; i <= A_WIDTH/16; i++) begin
				\$reduce_and #(
					.A_SIGNED(0),
					.A_WIDTH(min(A_WIDTH - (16 * i), 16)),
					.Y_WIDTH(1),
				) reduce_and (
					.A(A[16 * i +: min(A_WIDTH - (16 * i), 16)]),
					.Y(_collate[i])
				);
			end
			assign Y[0] = &_collate;
		end
	endgenerate
endmodule

module \$reduce_or (A, Y);
	parameter A_SIGNED = 0;
	parameter A_WIDTH = 2;
	parameter Y_WIDTH = 1;

	(* force_downto *)
	input wire [A_WIDTH-1:0] A;
	(* force_downto *)
	output wire [Y_WIDTH-1:0] Y;

	wire _TECHMAP_FAIL_ = (A_WIDTH < 1) || (Y_WIDTH < 1);
	wire [1023:0] _TECHMAP_DO_ = "opt";

	function integer min;
		input integer a, b;
		begin
			if (a < b) min = a;
			else min = b;
		end
	endfunction

	genvar i;
	generate
		if (Y_WIDTH > 1) begin
			assign Y[Y_WIDTH-1:1] = 1'b0;
		end

		if (A_WIDTH == 1) begin
			assign Y[0] = A[0];
		end else if (A_WIDTH == 2) begin
			assign Y[0] = A[0] | A[1];
		end else if (A_WIDTH <= 16) begin
			MC_UOR16 #(
				.WIDTH(A_WIDTH),
			) _TECHMAP_REPLACE_ (
				.A(A),
				.Y(Y[0])
			);
		end else begin
			wire [A_WIDTH/16:0] _collate;
			for (i = 0; i <= A_WIDTH/16; i++) begin
				\$reduce_or #(
					.A_SIGNED(0),
					.A_WIDTH(min(A_WIDTH - (16 * i), 16)),
					.Y_WIDTH(1),
				) reduce_or (
					.A(A[16 * i +: min(A_WIDTH - (16 * i), 16)]),
					.Y(_collate[i])
				);
			end
			assign Y[0] = |_collate;
		end
	endgenerate
endmodule

module \$reduce_xor (A, Y);
	parameter A_SIGNED = 0;
	parameter A_WIDTH = 2;
	parameter Y_WIDTH = 1;

	(* force_downto *)
	input wire [A_WIDTH-1:0] A;
	(* force_downto *)
	output wire [Y_WIDTH-1:0] Y;

	wire _TECHMAP_FAIL_ = (A_WIDTH < 1) || (Y_WIDTH < 1);
	wire [1023:0] _TECHMAP_DO_ = "opt";

	function integer min;
		input integer a, b;
		begin
			if (a < b) min = a;
			else min = b;
		end
	endfunction

	genvar i;
	generate
		if (Y_WIDTH > 1) begin
			assign Y[Y_WIDTH-1:1] = 1'b0;
		end

		if (A_WIDTH == 1) begin
			assign Y[0] = A;
		end else if (A_WIDTH == 2) begin
			assign Y[0] = A[0] ^ A[1];
		end else if (A_WIDTH <= 4) begin
			MC_UXOR4 #(
				.WIDTH(A_WIDTH),
			) _TECHMAP_REPLACE_ (
				.A(A),
				.Y(Y[0])
			);
		end else if (A_WIDTH <= 8) begin
			MC_UXOR8 #(
				.WIDTH(A_WIDTH),
			) _TECHMAP_REPLACE_ (
				.A(A),
				.Y(Y[0])
			);
		end else if (A_WIDTH <= 16) begin
			MC_UXOR16 #(
				.WIDTH(A_WIDTH),
			) _TECHMAP_REPLACE_ (
				.A(A),
				.Y(Y[0])
			);
		end else begin
			wire [A_WIDTH/16:0] _collate;
			for (i = 0; i <= A_WIDTH/16; i++) begin
				\$reduce_xor #(
					.A_SIGNED(0),
					.A_WIDTH(min(A_WIDTH - (16 * i), 16)),
					.Y_WIDTH(1),
				) reduce_xor (
					.A(A[16 * i +: min(A_WIDTH - (16 * i), 16)]),
					.Y(_collate[i])
				);
			end
			assign Y[0] = ^_collate;
		end
	endgenerate
endmodule

module \$reduce_xnor (A, Y);
	parameter A_SIGNED = 0;
	parameter A_WIDTH = 2;
	parameter Y_WIDTH = 1;

	(* force_downto *)
	input wire [A_WIDTH-1:0] A;
	(* force_downto *)
	output wire [Y_WIDTH-1:0] Y;

	(* force_downto *)
	wire [Y_WIDTH-1:0] Y_n;

	wire [1023:0] _TECHMAP_DO_ = "opt";

	\$reduce_xor #(
		.A_SIGNED(0),
		.A_WIDTH(A_WIDTH),
		.Y_WIDTH(Y_WIDTH),
	) _TECHMAP_REPLACE_ (
		.A(A),
		.Y(Y_n)
	);

	generate
		if (Y_WIDTH > 1) begin
			assign Y = {Y_n[Y_WIDTH-1:1], ~Y_n[0]};
		end else begin
			assign Y = ~Y_n;
		end
	endgenerate
endmodule

module \$reduce_bool (A, Y);
	parameter A_SIGNED = 0;
	parameter A_WIDTH = 2;
	parameter Y_WIDTH = 1;

	(* force_downto *)
	input wire [A_WIDTH-1:0] A;
	(* force_downto *)
	output wire [Y_WIDTH-1:0] Y;

	wire [1023:0] _TECHMAP_DO_ = "opt";

	\$reduce_or #(
		.A_SIGNED(0),
		.A_WIDTH(A_WIDTH),
		.Y_WIDTH(Y_WIDTH),
	) _TECHMAP_REPLACE_ (
		.A(A),
		.Y(Y)
	);
endmodule

module \$logic_not (A, Y);
	parameter A_SIGNED = 0;
	parameter A_WIDTH = 2;
	parameter Y_WIDTH = 1;

	(* force_downto *)
	input wire [A_WIDTH-1:0] A;
	(* force_downto *)
	output wire [Y_WIDTH-1:0] Y;

	wire _TECHMAP_FAIL_ = (A_WIDTH < 1) || (Y_WIDTH < 1);
	wire [1023:0] _TECHMAP_DO_ = "opt";

	function integer min;
		input integer a, b;
		begin
			if (a < b) min = a;
			else min = b;
		end
	endfunction

	genvar i;
	generate
		if (Y_WIDTH > 1) begin
			assign Y[Y_WIDTH-1:1] = 1'b0;
		end

		if (A_WIDTH == 1) begin
			assign Y[0] = ~A[0];
		end else if (A_WIDTH <= 16) begin
			// note dedicated NOR cell
			MC_UNOR16 #(
				.WIDTH(A_WIDTH),
			) _TECHMAP_REPLACE_ (
				.A(A),
				.Y(Y[0])
			);
		end else begin
			wire [A_WIDTH/16:0] _collate;
			// if we need multiple cells, regular ORs are more efficient...
			for (i = 0; i <= A_WIDTH/16; i++) begin
				\$reduce_or #(
					.A_SIGNED(0),
					.A_WIDTH(min(A_WIDTH - (16 * i), 16)),
					.Y_WIDTH(1),
				) reduce_or (
					.A(A[16 * i +: min(A_WIDTH - (16 * i), 16)]),
					.Y(_collate[i])
				);
			end
			// ...and this can use NOR if it works out that way
			assign Y[0] = !_collate;
		end
	endgenerate
endmodule
