module bilinearInterpolator
// TODO: parameterize with your own (parameterized) IP multiplier;
// ^algorithm is fairly simple (find 8x8 partial products, bitshift
// left by the relative magnitude of each term, add shifted partial products)
(
		input  logic        Clk, En,
		input  logic [15:0] interpSamples[2],
		input  logic [15:0] antiInterpSamples[2],
		input  logic [19:0] sampleInterp,
		input  logic [31:0] tableInterp,
		output logic [63:0] interpedOut
);
	// storage for intermediate variables
	reg   [36:0] interpedSamps[2];
	reg   [64:0] res;
	
	reg   [19:0] sampleAntiInterp;
	reg   [31:0] tableAntiInterp;
	
	assign sampleAntiInterp = ~sampleInterp;
	assign tableAntiInterp = ~tableInterp;
	assign interpedOut = res[64:1];
	
	mult16x20Add2_ip sampleInterpolator[0:1]
	(
		.dataa_0(interpSamples),
		.datab_0(sampleInterp),
		.dataa_1(antiInterpSamples),
		.datab_1(sampleAntiInterp),
		.clock0(Clk),
		.ena0(En),
		.result(interpedSamps)
	);
	
	mult32x32Add2_ip tableInterpolator (
		.dataa_0(interpedSamps[0][36:5]),
		.datab_0(tableInterp),
		.dataa_1(interpedSamps[1][36:5]),
		.datab_1(tableAntiInterp),
		.clock0(Clk),
		.ena0(En),
		.result(res)
	);
	
endmodule
		
		