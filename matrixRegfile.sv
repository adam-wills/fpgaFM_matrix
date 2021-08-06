module matrixRegfile
#(
      parameter DW,  // DATAWIDTH    
		          RW,  // ROWWIDTH
					 CW   // COLUMNWIDTH 
)
(
      input  logic          clk,
	   input  logic          wren   [0:RW-1][0:CW-1],
		input  logic [DW-1:0] wr_data[0:RW-1][0:CW-1],
		output logic [DW-1:0] rd_data[0:RW-1][0:CW-1]
);
	
   reg   [DW-1:0]  regfile[0:RW-1][0:CW-1];
   genvar i;
	int j;
	
   generate
      for (i = 0; i < NW; i = i+1) begin
         for (j = 0; j < RW; j = j+1) begin
               always @ (posedge clk) begin
                  if (wren[i][j]) begin
                     regfile[i][j] = wr_data[i][j];
                  end
                  rd_data[i][j] = regfile[i][j];
               end
			end
      end
	endgenerate
	
endmodule

	