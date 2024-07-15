`default_nettype none

// used to test techmapping to MC_U*

module reductions (
	i_in, o_and, o_or,
	o_xor2, o_xor3, o_xor7, o_xor15, o_xor,
	o_xnor, o_bool, o_not15, o_not
);
	parameter W = 20;

	input logic [W-1:0] i_in;
	output logic o_and, o_or, o_xor2, o_xor3, o_xor7, o_xor15, o_xor,
		o_xnor, o_bool, o_not15, o_not;

	assign o_and = &i_in;
	assign o_or = |i_in;
	assign o_xor2 = ^i_in[1:0];
	assign o_xor3 = ^i_in[2:0];
	assign o_xor7 = ^i_in[6:0];
	assign o_xor15 = ^i_in[14:0];
	assign o_xor = ^i_in;
	assign o_xnor = ~^i_in;
	assign o_bool = i_in ? 1'b1 : 1'b0;
	assign o_not15 = !i_in[14:0];
	assign o_not = !i_in;
endmodule
