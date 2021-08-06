module MIDItoTableIndex
#(
      parameter NUMREADS = 4
)
(
      input  logic        clk,
		input  logic [6:0]  midi_notenums[0:NUMREADS-1],
      output logic [6:0]  table_indices[0:NUMREADS-1]
);

   reg [6:0] data_reg[0:NUMREADS-1];
   reg [6:0] indexToTableIndices[0:127]

	initial begin
		readmemh("./inferredMem/tableInterps.txt", indexToTableInterps);
	end
	
   genvar i;
	generate
		for (i = 0; i < NUMREADS; i = i+1) begin
			always_ff @ (posedge clk)
					data_reg[i] <= indexToTableIndices[midi_notenums[i]];
			
			assign table_indices[i] = data_reg[i];
		end
	endgenerate
	
	
endmodule
