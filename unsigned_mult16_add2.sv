module unsigned_mult16_add2
(
      input  logic clk, 
		input  logic ena,
      input  logic [15:0] dataa_0,
      input  logic [15:0] datab_0,
      input  logic [15:0] dataa_1,
      input  logic [15:0] datab_1,
      output logic [32:0] result

);

	reg   [32:0] res;
	reg   [31:0] mult_out[0:1];
	reg   [15:0] a_reg[0:1];
	reg   [15:0] b_reg[0:1];

	logic mult_clk;

	unsigned_mult16 mults[0:1]
	(
			.clk(mult_clk),
			.dataa(a_reg),
			.datab(b_reg),
			.dout(mult_out)
	);

	always_ff @ posedge (mult_clk) begin
		a_reg    <= '{dataa_0, dataa_1};
		b_reg    <= '{datab_0, datab_1};
		
		result   <= res;
		mult_clk <= ena ? clk : 1'b0;
	end

	assign res = mult_out[0] + mult_out[1];

endmodule
