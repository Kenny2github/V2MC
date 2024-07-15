`default_nettype none
// 100ms = 1 redstone tick
// 50ms = 1 game tick, but the integer can only be 1, 10, or 100
`timescale 100ms/10ms

// CLK: positive-edge
// tech mapping converts negedge to posedge with an inverter
module MC_DFF31 (CLK, D, Q);
	parameter WIDTH = 1;

	input wire CLK;
	input wire [WIDTH-1:0] D;
	output reg [WIDTH-1:0] Q;

	always @(posedge CLK) begin
		Q <= D;
	end
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
	output reg [WIDTH-1:0] Q;

	always @(posedge CLK or posedge ARST) begin
		if (ARST) begin
			Q <= ARST_VALUE;
		end else begin
			Q <= D;
		end
	end
endmodule

module MC_UAND16 (A, Y);
	parameter WIDTH = 2;

	input wire [WIDTH-1:0] A;
	output wire Y;

	assign Y = &A;
endmodule

module MC_UNOR16 (A, Y);
	parameter WIDTH = 2;

	input wire [WIDTH-1:0] A;
	output wire Y;

	assign Y = !A;
endmodule

module MC_UOR16 (A, Y);
	parameter WIDTH = 2;

	input wire [WIDTH-1:0] A;
	output wire Y;

	assign Y = |A;
endmodule

module MC_UXOR2 (A, Y);
	input wire [1:0] A;
	output wire Y;

	assign Y = ^A;
endmodule

module MC_UXOR4 (A, Y);
	parameter WIDTH = 3;

	input wire [WIDTH-1:0] A;
	output wire Y;

	assign Y = ^A;
endmodule

module MC_UXOR8 (A, Y);
	parameter WIDTH = 5;

	input wire [WIDTH-1:0] A;
	output wire Y;

	assign Y = ^A;
endmodule

module MC_UXOR16 (A, Y);
	parameter WIDTH = 7;

	input wire [WIDTH-1:0] A;
	output wire Y;

	assign Y = ^A;
endmodule
