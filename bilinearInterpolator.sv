module bilinearInterpolator

(
		input  logic clk,
		input  logic ena,
		input  logic [15:0] interp_samples[2],
		input  logic [15:0] antiInterp_samples[2],
		input  logic [15:0] sample_interp,
		input  logic [15:0] table_interp,
		output logic [31:0] dout
);

	// storage for intermediate variables
	reg   [32:0] interpedSamps[2];
	reg   [32:0] res;
	reg   [15:0] sampleAntiInterp;
	reg   [15:0] tableAntiInterp;
	
	
	unsigned_mult16_add2 sampleInterpolator[0:1]
	(
		.clk(clk),
		.ena(ena),
		.dataa_0(antiInterp_samples),
		.datab_0(sample_interp),
		.dataa_1(interp_samples),
		.datab_1(sampleAntiInterp),
		.result(interpedSamps)
	);
	
	unsigned_mult16_add2 tableInterpolator 
	(
		.clk(clk),
		.ena(ena),
		.dataa_0(interpedSamps[0][32:17]),
		.datab_0(table_interp),
		.dataa_1(interpedSamps[1][32:17]),
		.datab_1(tableAntiInterp),
		.result(res)
	);
	
	assign sampleAntiInterp = ~sample_interp;
	assign tableAntiInterp = ~table_interp;
	assign dout = res[32:1];
	
endmodule
		
		