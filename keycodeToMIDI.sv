module keycodeToMIDI
#(
      parameter NUMREADS = 4
)
(
      input  logic        clk,
		input  logic        rden[0:NUMREADS-1],
      input  logic [2:0]  octave,
		input  logic [7:0]  keycodes[0:NUMREADS-1],
      output logic [6:0]  midi_notenums[0:NUMREADS-1]
);

   reg [6:0]  data_reg[NUMREADS];
   reg [5:0]  keycodeToMidiNNBase[0:63];
	
	logic [6:0] midiNN[NUMREADS];
	logic [5:0] midiNNBase[NUMREADS];
	
   initial begin
		readmemb("./inferredMem/keycodeToMIDIBase.txt", keycodeToIndex);
	end
	
	
   genvar i;
	generate
		for (i = 0; i < NUMREADS; i = i+1) begin : keycode_to_midi
			always @ (posedge clk) begin
				midiNNBase[i] <= keycodeToMidiNNBase[keycode[i]];
				if (rden[i]) begin
				   if (keycodeToIndex[keycode[i]] != 0)
						data_reg[i] <= midiNN[i];
				end
			end
			assign midiNN[i] = midiNNBase[i] + octave*12;
			assign midi_notenums[i] = data_reg[i];
		end
	endgenerate
	
endmodule
