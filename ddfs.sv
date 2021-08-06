module directDigitalOscillator
#(
		parameter P_WIDTH = 32, // phasor precision
		          D_WIDTH = 16, // width of sample data
		          A_WIDTH = 12  // width of sample address
)
(
		input  logic                   Clk, Reset, En, wren, rden,            
		input  logic [P_WIDTH-1:0]     f_c, f_o,
		input  logic [P_WIDTH-1:0]     ph_o,
		input  logic [D_WIDTH-1:0]     env,
		input  logic [D_WIDTH-1:0]     sample_in[2],
		input  logic [A_WIDTH-1:0]     saddr_in,
		output logic [(2*D_WIDTH)-1:0] sig_out
);
	
	localparam I_WIDTH = P_WIDTH-A_WIDTH; // interpolation width
	localparam N_SAMPLES = (2**A_WIDTH)-1;
	//localparam OUT_IDX = 80-(2*D_WIDTH);
	
	logic [I_WIDTH-1:0]     anterp_reg;
	logic [I_WIDTH-1:0]     interp_reg, interp_next;
	logic [D_WIDTH-1:0]     sample_reg[2];
	logic [A_WIDTH-1:0]     raddr_reg, raddr_next;
	logic [A_WIDTH-1:0]     waddr_reg, waddr_next;
	logic [(2*D_WIDTH)-1:0] sig_reg, sig_next;
	logic [(2*D_WIDTH):0]   interped_sample;
	
	
	
	phasor #(.DW(P_WIDTH), .AW(A_WIDTH)) phaseOsc
	(
		.Clk(Clk),
		.Reset(Reset),
		.Enable(rden),
		.phaseIncrement(f_c),
		.fmInput(f_o),
		.phaseOffset(ph_o),
		.interp(interp_next),
		.wavetableAddr(raddr_next)
	);
	
	dualReadRegfile[0:1] #(.DW(D_WIDTH), .AW(A_WIDTH)) wavetableRAM
	(
		.clk(Clk),
		.wren(wren),
		.rden(rden),
		.w_addr(saddr_in),
		.r_addr0(raddr_reg),
		.r_addr1(raddr_reg+1),
		.w_data(sample_in),
		.r_data(sample_reg)
	);

	
	always_ff @ (posedge Clk) begin
		if (Reset) begin
			sig_reg    <= 0;
			raddr_reg  <= 0;
			sample_reg <= 0;
			interp_reg <= 0;
		end
		else begin
			if (rden) begin
				sig_reg    <= sig_next;
				raddr_reg  <= raddr_next;
				interp_reg <= interp_next;
			end
			else begin
				sig_reg    <= 0;
				raddr_reg  <= raddr_reg;
				interp_reg <= 0;
			end
		end
	end
	
	assign anterp_reg = ~interp_reg;
	assign sig_out = sig_reg;
	assign interped_sample = (interp_reg*sample_reg[1])+(anterp_reg*sample_reg[0]);
	assign sig_next = env*(interped_sample[2*(D_WIDTH):D_WIDTH+1]);

endmodule	