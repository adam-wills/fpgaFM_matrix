module clockDivider_AW
#(
		parameter AW = 2
)
(
		input  logic Clk0, Reset,
		output logic Clk1
);

	reg[AW-1:0] ctr = 0;
	
	always_ff @ (posedge Clk0) begin
		if (Reset)
			ctr <= 0;
		else 
			ctr <= ctr+1;
	end
	
	assign Clk1 = ctr[(AW-1)];
	
endmodule
