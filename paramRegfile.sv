module paramRegfile
#(
      parameter NUMOSCS   = 12,
		          NUMPARAMS = 24
)
(
      input  logic        clk,
		input  logic        rden[NUMOSCS][NUMPARAMS],
		input  logic        wren[NUMOSCS][NUMPARAMS],
		input  logic [31:0] read_data[NUMOSCS][NUMPARAMS],
		output logic [31:0] write_data[NUMOSCS][NUMPARAMS]
);

   reg [31:0] data_reg[NUMOSCS][NUMPARAMS];
	
   genvar i;
   int j;
   generate
      for (i = 0; i < NUMOSCS; i = i+1) begin
			for (j = 0; j < NUMPARAMS; j= j+1) begin
				always @ (posedge clk) begin
				   if (rden[i][j])
						read_data[i][j] = data_reg[i][j];
					if (wren[i][j])
						data_reg[i][j] = write_data[i][j];
				end
			end
      end
   endgenerate
	
endmodule

	