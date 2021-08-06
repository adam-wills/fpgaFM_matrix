module dualReadRegfile
#(
		parameter DW = 16,
		          AW = 12
)
(
		input  logic          clk, wren, rden
		input  logic [AW-1:0] w_addr, r_addr1, r_addr0,
		input  logic [DW-1:0] w_data,
		output logic [DW-1:0] r_data[2];
);

	logic [DW-1:0] array_reg[0:2**AW-1];
	logic [DW-1:0] data_reg [2];
	
	always_ff @ (posedge clk) begin
		if (wren)
			array_reg[w_addr] <= w_data;
		if(rden)
		data_reg[0] <= array_reg[r_addr0];
		data_reg[1] <= array_reg[r_addr1];
	end
	
	assign r_data[0] = data_reg[0];
	assign r_data[1] = data_reg[1];
	
endmodule
