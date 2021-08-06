module shiftreg_N 
#(
		parameter D_WIDTH = 32
)
(
		input  logic                Clk, Reset, Enable, Shift_In, Load, Shift_En,
		input  logic [D_WIDTH-1:0]  D,
		output logic                Shift_Out,
		output logic [D_WIDTH-1:0]  Data_Out
);
				  
	 //logic [D_WIDTH-1:0] data_reg;
	 
    always_ff @ (posedge Clk)
    begin
	 	 if (Reset) //notice, this is a sycnrhonous reset, which is recommended on the FPGA
			  //data_reg <= {D_WIDTH{1'b0}};
			  Data_Out <= {D_WIDTH{1'b0}};
		 else if (Load) begin
			  if (Enable)
				   //data_reg <= D;
					Data_Out <= D;
			  else
				   //data_reg <= Data_Out;
					Data_Out <= Data_Out;
		 end
		 else if (Shift_En) begin
			  if (Enable)
				   //data_reg <= { data_reg[D_WIDTH-2:0], Shift_In };
					Data_Out <= {Data_Out[D_WIDTH-1:0], Shift_In};
			  else
				   Data_Out <= Data_Out;
	    end
    end
	 // when shiftregs are disabled, continuously reading Shift_Out will stream 0's;
	 // ensures I2S always receives information
    assign Shift_Out = Enable? Data_Out[D_WIDTH-1] : 1'b0;
	 //assign Data_Out = data_reg;

endmodule
