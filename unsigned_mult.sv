module unsigned_mult
(
      input  logic clk,
      input  logic [7:0] a, 
      input  logic [7:0] b,
      output logic [15:0] dout
);
							

	reg [7:0] a_reg;
	reg [7:0] b_reg;							
	reg [15:0] mult_out;

	assign mult_out = a_reg * b_reg;
								
	always_ff @ (posedge clk)
	begin
		 a_reg <= a;
		 b_reg <= b;
		 dout <= mult_out;
		 
	end

endmodule
