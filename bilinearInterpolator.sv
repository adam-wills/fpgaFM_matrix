module bilinearInterpolator
// TODO: parameterize with your own (parameterized) IP multiplier;
// ^algorithm is fairly simple (find 8x8 partial products, bitshift
// left by the relative magnitude of each term, add shifted partial products)
(
		input  logic        Clk, En,
		input  logic [15:0] interp_samples[2],
		input  logic [15:0] antiInterp_samples[2],
		input  logic [19:0] sample_interp,
		input  logic [31:0] table_interp,
		output logic [63:0] interped_out
);
	// storage for intermediate variables
	reg   [36:0] interpedSamps[2];
	reg   [64:0] res;
	
	reg   [19:0] sampleAntiInterp;
	reg   [31:0] tableAntiInterp;
	
	assign sampleAntiInterp = ~sample_interp;
	assign tableAntiInterp = ~table_interp;
	assign interped_out = res[64:1];
	
	mult16x20Add2_ip sample_interpolator[0:1]
	(
		.dataa_0(interp_samples),
		.datab_0(sample_interp),
		.dataa_1(antiInterp_samples),
		.datab_1(sampleAntiInterp),
		.clock0(Clk),
		.ena0(En),
		.result(interpedSamps)
	);
	
	mult32x32Add2_ip table_interpolator (
		.dataa_0(interpedSamps[0][36:5]),
		.datab_0(table_interp),
		.dataa_1(interpedSamps[1][36:5]),
		.datab_1(tableAntiInterp),
		.clock0(Clk),
		.ena0(En),
		.result(res)
	);
	
endmodule
		
		