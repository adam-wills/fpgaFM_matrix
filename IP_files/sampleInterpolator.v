module sampleInterpolator 
(
		input  logic        Clk, Reset, En,
		input  logic [15:0] samps[2],
		input  logic [19:0] interp,
		output logic [31:0] interpedSamps
		
);

	logic [19:0] antiInterp;
	reg   [36:0] res;
	
	assign antiInterp = ~interp;
	assign interpedSamps = res[36:5];
	
	
	mult16x20Add2_ip	sampleInterp 
	(
		.dataa_0(samps[0]),
		.datab_0(interp),
		.dataa_1(samps[1]),
		.datab_1(antiInterp),
		.clock0(Clk),
		.ena0(En),
		.result(res)
	);
	
endmodule