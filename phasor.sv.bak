module phasor
#(
		parameter DW = 32, // data width (precision of phasor)
		parameter AW = 12  // wavetable address width

)
(
		input  logic             Clk, Reset, Enable,
		input  logic [DW-1:0]    phaseIncrement,
		input  logic [DW-1:0]    fmInput, phaseOffset,
		output logic [DW-AW-1:0] interp,
		output logic [AW-1:0]    wavetableAddr
);
				  
	localparam IW = DW-AW; // interpolation width
	
	logic [DW-1:0] phase, phase_next, phase_addr;
	logic [DW-1:0] freq_next;
	logic [AW-1:0] addr_next;
	logic [IW-1:0] interp_next;
	
	always_ff @ (posedge Clk) begin
		if (Reset) begin
			phase <= {DW{1'b0}};
			wavetableAddr <= {AW{1'b0}};
			interp <= {IW{1'b0}};
		end
		else begin
			if (Enable) begin
			/*
				phase <= phase + phaseIncrement + fmInput;
				wavetableAddr <= phase[DW-1:IW];
				interp <= phase[IW-1:0];
			*/
				phase <= phase_next;
				wavetableAddr <= addr_next;
				interp <= interp_next;
			end
			else begin
				phase <= phase;
				wavetableAddr <= wavetableAddr;
				interp <= interp;
			end
		end
	end
	
	assign freq_next = phaseIncrement + fmInput;
	assign phase_next = phase + freq_next;
	assign phase_addr = phase + phaseOffset;
	assign addr_next = phase_addr[DW-1:IW];
	assign interp_next = phase_addr[IW-1:0];
	
endmodule

	