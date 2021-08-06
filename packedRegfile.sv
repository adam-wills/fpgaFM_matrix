module packedRegfile
#(
      parameter DW,      
		          ROWWIDTH,  
					 COLWIDTH,   
					 NUMREADS    
)
(
      input  logic clk, 
		input  logic rden[0:NUMREADS-1],
	   input  logic wren[0:NUMREADS-1],
		input  int   row_rd_addr[0:NUMREADS-1],
		input  int   col_rd_addr[0:NUMREADS-1],
		input  int   row_wr_addr[0:NUMREADS-1],
		input  int   col_wr_addr[0:NUMREADS-1],
		input  logic [DW-1:0]     wr_data [0:NUMREADS-1],
		output logic [DW-1:0]     rd_data [0:NUMREADS-1]
);
	
   reg   [DW-1:0][0:ROWWIDTH-1][0:COLWIDTH-1] regfile[0:NUMREADS-1];
   reg   [DW-1:0] data_reg[0:NUMREADS-1];
   genvar i;
	
   generate
      for (i = 0; i < NUMREADS; i = i+1) begin
         always @ (posedge clk) begin
            if (wren[i])
               regfile[i][row_wr_addr][col_wr_addr] = wr_data[i];
				if (rden[i])
               data_reg[i] = regfile[i][row_rd_addr][col_rd_addr];
         end
			assign rd_data[i] = data_reg[i];
      end
	endgenerate
	
endmodule

	