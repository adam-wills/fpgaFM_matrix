module mux_intSelect
#(
      int unsigned INPUTS = 8,
		int unsigned DWIDTH = 16
)
(
      input  logic [DWIDTH-1:0] in_data[INPUTS],
      input  logic [7:0]        select,
      output logic [DWIDTH-1:0] out_data
);
   logic [DWIDTH-1:0] mux_out;
	int unsigned i;
   
	always_comb begin
		mux_out = {DWIDTH{1'b0}};
		for (i = 0; i < INPUTS; i = i+1) begin
			mux_out |= (select == i)? in_data[i] : {DWIDTH{1'b0}};
		end
	end
	
	assign out_data = mux_out;
	
endmodule
