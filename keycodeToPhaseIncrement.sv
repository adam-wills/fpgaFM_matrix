module keycodeToPhaseIncrement
#(
      parameter NUMREADS = 4
)
(
      input  logic                clk,
		input  logic [0:NUMREADS-1] rden,
      input  logic [2:0]          octave,
		input  logic [7:0]          keycodes[0:NUMREADS-1],
      output logic [31:0]         phase_increments[0:NUMREADS-1]
);

   reg [31:0] data_reg[NUMREADS];
   reg [31:0] indexToPhaseIncrement[0:127]
   reg [5:0]  keycodeToIndex[0:63];
	
	logic [6:0] midiNN[NUMREADS];
	logic [5:0] midiNNBase[NUMREADS];
	
   initial begin
		readmemb("./inferredMem/keycodeToMIDIBase.txt", keycodeToIndex);
	end
	
	initial begin
		readmemh("./inferredMem/midiNNtoPI.txt", indexToPhaseIncrement);
	end
	
   genvar i;
	generate
		for (i = 0; i < NUMREADS; i = i+1) begin
			always @ (posedge clk) begin
				midiNNBase[i] <= keycodeToIndex[keycode[i]];
				if (rden[i] && midiNNBase[i])
						data_reg[i] <= indexToPhaseIncrement[midiNN[i]];
			end
			assign midiNN[i] = midiNNBase[i] + octave*12;
			assign phase_increments[i] = data_reg[i];
		end
	endgenerate
	
	
endmodule
