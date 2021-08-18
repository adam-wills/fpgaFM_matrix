//todo: get this goin

module directDigitalOscillator
#(
		parameter P_WIDTH = 32, // phasor precision
		          D_WIDTH = 16, // width of sample data
		          A_WIDTH = 12  // width of sample address
)
(
		input  logic                   Clk, Reset, En,             
		input  logic [P_WIDTH-1:0]     fCarrier, fOffset,
		input  logic [P_WIDTH-1:0]     phaseOffset,
		input  logic [15:0]     env,
		input  logic [15:0]     tableInterp,
		input  logic [15:0]     samplesInterp[2],
		input  logic [15:0]     samplesAnti[2],
		output logic [A_WIDTH-1:0]     addrOut,
		output logic [31:0] sigOut,
		output logic                   readEn
);
	
	localparam I_WIDTH = P_WIDTH-A_WIDTH; // interpolation width
	localparam OUT_IDX = 80-(2*D_WIDTH);
	
	logic                   readEn_reg;
	logic [I_WIDTH-1:0]     sampleInterp_reg;
	logic [P_WIDTH-1:0]     tableInterp_reg;
	logic [A_WIDTH-1:0]     addr_reg, addr_next;
	logic [15:0]     samplesInterp_reg[2];
	logic [15:0]     samplesAnti_reg[2];
	logic [31:0]            interpedOut; // TODO: parameterized bilinear interp
	logic [31:0]            envelopedSig;
	logic [31:0] sig_next;
	logic [31:0] sig_reg;
	
	
			
	phasor #(.DW(P_WIDTH), .AW(A_WIDTH)) phaseOsc
	(
		.Clk(Clk),
		.Reset(Reset),
		.Enable(En),
		.phaseIncrement(fCarrier),
		.fmInput(fOffset),
		.phaseOffset(phaseOffset),
		.interp(sampleInterp_reg),
		.wavetableAddr(addr_next)
	);
	
	bilinearInterpolator blInterp
	(
		.Clk(Clk),
		.En(En),
		.interpSamples(samplesInterp_reg),
		.antiInterpSamples(samplesAnti_reg),
		.sampleInterp(sampleInterp_reg),
		.tableInterp(tableInterp_reg),
		.interpedOut(interpedOut)`
	);
	
	mult16x64 envelopeMult
	(
		.clken(En),
		.clock(Clk),
		.dataa(env),
		.datab(interpedOut),
		.result(envelopedSig)
	);
	
	always_ff @ (posedge Clk) begin
		if (Reset) begin
			sig_reg <= {(2*D_WIDTH){1'b0}};
			addr_reg <= {(A_WIDTH){1'b0}};
			readEn_reg <= 1'b0;
		end
		else begin
			if (En) begin
				sig_reg <= sig_next;
				addr_reg <= addr_next;
				readEn_reg <= 1'b1;
			end
			else begin
				sig_reg <= {(2*D_WIDTH){1'b0}};
				addr_reg <= addr_reg;
				readEn_reg <= 1'b0;
			end
		end
	end
	
	always_ff @ (negedge Clk) begin
		readEn_reg <= 1'b0;
		if (En) begin
			samplesInterp_reg <= samplesInterp;
			samplesAnti_reg <= samplesAnti;
			tableInterp_reg <= tableInterp;
		end
		else begin
			samplesInterp_reg <= samplesInterp_reg;
			samplesAnti_reg <= samplesAnti_reg;
			tableInterp_reg <= tableInterp_reg;
		end
	end
	
	assign sigOut = sig_reg;
	assign addrOut = addr_reg;
	assign readEn = readEn_reg;
	assign sig_next = envelopedSig[79:OUT_IDX];

endmodule	