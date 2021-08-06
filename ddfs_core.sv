module ddfs_core
#(
		parameter PW = 32,
		          DW = 16,
		          AW = 12
)
(
		input  logic clk,
		input  logic reset,
		input  logic clken,
		// hardware interface
		input  logic          hw_write
		input  logic [DW-1:0] hw_write_data,
		output logic          hw_read,
		output logic [AW-1:0] hw_addr,
		output logic [PW-AW-1:0] hw_interp,
		// software interface
		input  logic cs,
		input  logic sw_read,
		input  logic sw_write,
		input  logic [4:0]  sw_addr,
		input  logic [PW-1:0] sw_wr_data,
		output logic [PW-1:0] sw_rd_data,
		// external sigs
		input  logic [PW-1:0] fOffset_ext, phOffset_ext,
		input  logic [DW-1:0] env_ext,
		input  logic [31:0]   tableInt_ext,
		output logic [31:0]   sig_out
);


	logic [(2*DW)-1:0] sigOut;
	logic [31:0]       tableInt_reg, tableInt;
	logic [PW-1:0]     phase_reg, fCarrier_reg, fOffset_reg;
	logic [PW-1:0]     phaseOffset, fOffset;
	logic [DW-1:0]     env_reg, env;
	logic [3:0]        ctrl_reg;
	logic wr_en, wr_fc, wr_fo, wr_ph, wr_env, wr_ctrl;
	
	directDigitalOscillator #(.P_WIDTH(PW), .D_WIDTH(DW), .A_WIDTH(AW)) ddfs_osc
	(
		.Clk(clk),
		.Reset(reset),
		.En(clken),
		.Load(hw_write),
		.fCarrier(fCarrier_reg),
		.fOffset(fOffset),
		.phaseOffset(phaseOffset),
		.env(env),
		.sampIn(hw_write_data),
		.addrOut(hw_addr),
		.readEn(hw_read),
		.sigOut(sigOut),
		.sampInterp(hw_interp)
	);
	
	always_ff @(posedge clk)
		if (reset) begin
			fCarrier_reg <= 0;
			fOffset_reg  <= 0;
			phase_reg    <= 0;
			env_reg      <= { 2'b01,{(DW-2){1'b0}} };
			tableInt_reg <= 0;
			ctrl_reg     <= 0;
		end
		else begin
			if (wr_fc)
				fCarrier_reg <= sw_wr_data[PW-1:0];
			if (wr_fo)
				fOffset_reg  <= sw_wr_data[PW-1:0];
			if (wr_ph)
				phase_reg    <= sw_wr_data[PW-1:0];
			if (wr_env)
				env_reg      <= sw_wr_data[DW-1:0];
			if (wr_ti)
				tableInt_reg <= sw_wr_data[DW-1:0];
			if (wr_ctrl)
				ctrl_reg     <= sw_wr_data[3:0];
			if
		end
	end
	// decode
	assign wr_en   = write & cs;
	assign wr_fc   = (addr[2:0] == 3'b000) & wr_en;
	assign wr_fo   = (addr[2:0] == 3'b001) & wr_en;
	assign wr_ph   = (addr[2:0] == 3'b010) & wr_en;
	assign wr_env  = (addr[2:0] == 3'b011) & wr_en;
	assign wr_ti   = (addr[2:0] == 3'b100) & wr_en;
	assign wr_ctrl = (addr[2:0] == 3'b101) & wr_en;
	// route input
	assign env         = (ctrl_reg[0]) ? env_ext : env_reg;
	assign fOffset     = (ctrl_reg[1]) ? fOffset_ext : fOffset_reg;
	assign phaseOffset = (ctrl_reg[2]) ? phOffset_ext : phase_reg;
	assign tableInt    = (ctrl_reg[3]) ? tableInt_ext : tableInt_reg;
	// assign output
	assign sw_rd_data = {16'h0, sigOut[(2*DW)-1:DW]};
		
endmodule
