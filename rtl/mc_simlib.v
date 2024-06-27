`default_nettype none
// 100ms = 1 redstone tick
// 50ms = 1 game tick, but the integer can only be 1, 10, or 100
// delays measured from MC implementation
`timescale 100ms/10ms

// CLK: positive-edge
// tech mapping converts negedge to posedge with an inverter
module MC_DFF31 (CLK, D, Q);
	parameter WIDTH = 1;

	input wire CLK;
	input wire [WIDTH-1:0] D;
	output wire [WIDTH-1:0] Q;

	wire [WIDTH-1:0] _cell_d;
	reg [WIDTH-1:0] _cell_q;

	// D port input to single cell input delay
	assign #6 _cell_d = D;

	always @(posedge CLK) begin
		// CLK port input to single cell clock capture delay
		#5 _cell_q <= _cell_d;
	end

	// single cell output to Q port output delay
	assign #2 Q = _cell_q;
endmodule

// CLK: positive-edge
// ARST: active-high
// ARST_VALUE: any arbitrary bit pattern of correct WIDTH
// tech mapping converts from negedge and active-low with inverters
module MC_ADFF31 (CLK, ARST, D, Q);
	parameter WIDTH = 1;
	parameter ARST_VALUE = {WIDTH{1'b0}};

	input wire CLK, ARST;
	input wire [WIDTH-1:0] D;
	output wire [WIDTH-1:0] Q;

	wire [WIDTH-1:0] _cell_d;
	reg [WIDTH-1:0] _cell_q;

	// D port input to single cell input delay
	assign #6 _cell_d = D;

	always @(posedge CLK or posedge ARST) begin
		if (ARST) begin
			// ARST port input to single cell reset delay
			#7 _cell_q <= ARST_VALUE;
		end else begin
			// CLK port input to single cell clock capture delay
			#10 _cell_q <= D;
		end
	end

	// single cell output to Q port output delay
	assign #1 Q = _cell_q;
endmodule
