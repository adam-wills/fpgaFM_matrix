module formattedMultAdd
#(
      parameter DW = 16,
                VOICE_AW = 4
)
(
      input  logic clk, enable,
      input  logic [DW-1:0]       routing_weights[0:1][0:3],
      input  logic [DW-1:0]       routing_values [(2**VOICE_AW)-1:0],
      input  logic [VOICE_AW-1:0] routing_indices[0:1][0:3],
      output logic [DW-1:0]       routing_target[0:3]
);
	
   logic [DW-1:0]     voice_values0[0:3];
   logic [DW-1:0]     voice_values1[0:3];
	logic [DW-1:0]     weights0     [0:3];
	logic [DW-1:0]     weights1     [0:3];

   reg   [(2*DW)-1:0] res[0:3];
   
	
   mult32x32Add2_ip multAdd[0:3]
   (
        .clock0(clk),
		  .ena0(enable),
		  .dataa_0(weights0),
		  .dataa_1(voice_values0),
		  .datab_0(weights1),
		  .datab_1(voices_values1),
		  .result(res)
   );
	
   genvar i;
	generate
      for (i = 0; i < 4; i = i+1) begin : formatted_mult_add
         assign weights0[i] = routing_weights[0][i];
		   assign weights1[i] = routing_weights[1][i];
         assign voice_values0[i] = routing_values[routing_indices[0][i]];
		   assign voice_values1[i] = routing_values[routing_indices[1][i]];
         assign routing_target[i] = res[i][2*DW:DW+1];
      end
   endgenerate
	
endmodule
