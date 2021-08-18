module MIDItoTableInterp
#(
      parameter NUMREADS = 4
)
(
      input  logic        clk,
		input  logic [6:0]  midi_notenums[0:NUMREADS-1],
      output logic [31:0] table_interps[0:NUMREADS-1]
);

   reg [31:0] data_reg[0:NUMREADS-1];
   reg [31:0] indexToTableInterps[0:127];

	initial begin
		readmemh("./inferredMem/tableInterps.txt", indexToTableInterps);
	end
	
   genvar i;
	generate
		for (i = 0; i < NUMREADS; i = i+1) begin : midi_to_table_interp
			always_ff @ (posedge clk)
					data_reg[i] <= indexToTableInterps[midi_notenums[i]];
			
			assign table_interps[i] = data_reg[i];
		end
	endgenerate
	
	
endmodule
