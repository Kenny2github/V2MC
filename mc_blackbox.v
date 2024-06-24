`default_nettype none

// CLK: positive-edge
// tech mapping converts negedge to posedge with an inverter
(* blackbox *)
module MC_DFF29 (CLK, D, Q);
	parameter WIDTH = 1;

	input wire CLK;
	input wire [WIDTH-1:0] D;
	output wire [WIDTH-1:0] Q;
endmodule

// CLK: positive-edge
// ARST: active-high
// ARST_VALUE: any arbitrary bit pattern of correct WIDTH
// tech mapping converts from negedge and active-low with inverters
(* blackbox *)
module MC_ADFF29 (CLK, ARST, D, Q);
	parameter WIDTH = 1;
	parameter ARST_VALUE = {WIDTH{1'b0}};

	input wire CLK, ARST;
	input wire [WIDTH-1:0] D;
	output wire [WIDTH-1:0] Q;
endmodule
