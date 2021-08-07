module MIDItoPhaseIncrement
#(
      parameter NUMREADS = 4
)
(
      input  logic        clk,
      input  logic [6:0]  midi_notenums[0:NUMREADS-1],
      output logic [31:0] phase_increments[0:NUMREADS-1]
);

   reg [31:0] data_reg[0:NUMREADS-1];
   reg [31:0] indexToPhaseIncrement[0:127]

   initial begin
      readmemh("./inferredMem/midiNNtoPI.txt", indexToPhaseIncrement);
   end
	
   genvar i;
      generate
         for (i = 0; i < NUMREADS; i = i+1) begin
            always_ff @ (posedge clk)
               data_reg[i] <= indexToPhaseIncrement[midi_notenums[i]];
			
             assign phase_increments[i] = data_reg[i];
            end
      endgenerate
	
endmodule
