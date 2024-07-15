`default_nettype none

// used to test techmapping to MC_A?DFF31

module counters (clk, reset, en, en_acount, acount, en_scount, scount);
	parameter W = 48;
	localparam RST_VALUE = {{(W/2){1'b1}}, {((W+1)/2){1'b0}}};

	input logic clk, reset, en;
	output logic [W-1:0] en_acount, acount, en_scount, scount;

	always_ff @(posedge clk or posedge reset) begin
		if (reset) en_acount <= RST_VALUE;
		else if (en) en_acount <= en_acount + 1'b1;
	end

	always_ff @(posedge clk or posedge reset) begin
		if (reset) acount <= RST_VALUE;
		else acount <= acount + 1'b1;
	end

	always_ff @(posedge clk) begin
		if (reset) en_scount <= RST_VALUE;
		else if (en) en_scount <= en_scount + 1'b1;
	end

	always_ff @(posedge clk) begin
		if (reset) scount <= RST_VALUE;
		else scount <= scount + 1'b1;
	end
endmodule
