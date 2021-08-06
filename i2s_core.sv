module i2s_core
#(
		parameter DW = 32
)
(
		input  logic          FCLK, SCLK, LRCLK, Reset,
		input  logic [DW-1:0] i2sDin,
		output logic          sampReq, readEn, sampGenEn,
		output logic          streamOutL, streamOutR
);
	
	
	// shiftreg & shiftreg fsm declarations
	logic          prevLRCLK = 1'b0;
	logic          shiftLChannel, loadR, loadL, shiftRChannel;
	logic          shiftOutL, shiftOutR;
	logic [1:0]    actionState;
	logic [DW-1:0] shiftDinL, shiftDinR;
	logic [DW-1:0] dOutReg;
	
	// dual-clock fifo declarations
	logic [DW-1:0] fifoDout = {DW{1'b0}};
	logic [DW-1:0] fifoDin = {DW{1'b0}};
	logic          sampReq = 1'b0;
	logic          sampFull = 1'b0;
	logic          i2sReq = 1'b1;
	logic          i2sEmpty = 1'b1;
	logic	         i2sFull = 1'b0;
	logic	         sampEmpty = 1'b1;
	logic [7:0] 	i2sUsedw = 8'b0;
	logic [7:0]		sampUsedw = 8'b0; // depth of FIFO is 256;
	logic 			i2sHalfEmpty, sampHalfFull, En;

	// this is somewhat halfassed
	assign sampHalfFull = ~sampUsedw[7];
	assign i2sHalfEmpty = ~i2sUsedw[7];
	assign sampGenEn = (sampHalfFull | sampEmpty | i2sEmpty | i2sHalfEmpty) & (~i2sFull) & (~sampFull));
	assign fifoDin = i2sDin;
	
	// sampReq clearly == readEn...
	// toggle sampleRequest appropriately to coordinate sample generation with FIFO buffer fullness
	always_ff @ (posedge FCLK) begin
		if (Reset) 
			sampReq <= 1'b0;
			readEn <= 1'b0;
		else begin
			if (sampGenEn) begin
				if (sampReq == 1'b1) begin
					sampReq <= 1'b0;
					readEn <= 1'b0;
				end
				else begin
					sampReq <= 1'b1;				
					readEn <= 1'b1;
				end
			end
			else if (sampFull) begin
				sampReq <= 1'b0;
				readEn <= 1'b0;
			end
		end
	end
	
	// always draw a sample from the buffer if it isnt empty
	always_ff @ (posedge LRCLK) begin
		if (~i2sEmpty)  begin
			if (i2sReq == 1'b0)  begin
				i2sReq <= 1'b1;
				shiftDinR <= fifoDout;
				shiftDinL <= fifoDout;
			end
			else
				i2sReq <= 1'b0;
		end
	end
	
	onChipFIFO onChipFIFO_inst
	(
			.aclr(Reset),
			.data(fifoDin),
			.rdclk(LRCLK),
			.rdreq(i2sReq),
			.wrclk(FCLK),
			.wrreq(sampReq),
			.q(fifoDout),
			.rdempty(i2sEmpty),
			.rdfull(i2sFull),
			.rdusedw(i2sUsedw),
			.wrempty(sampEmpty),
			.wrfull(sampFull),
			.wrusedw(sampUsedw) 
	);
	
	// Shift registers to shift out individual bits of each sample at the rate of SCLK = 64*LRCLK
	shiftreg_N #(DW)  shiftregL
	(
			.Clk(SCLK),
			.Reset(Reset),
			.Enable(1'b1),
			.Shift_In(1'b0),
			.Load(loadL),
			.Shift_En(shiftLChannel),
			.D(shiftDinL),
			.Shift_Out(streamOutL),
			.Data_Out()
	);
													  
	shiftreg_N #(DW) shiftregR
	(
			.Clk(SCLK),
			.Reset(Reset),
			.Enable(1'b1),
			.Shift_In(1'b0),
			.Load(loadR),
			.Shift_En(shiftRChannel),
			.D(shiftDinR),
			.Shift_Out(streamOutR),
			.Data_Out()
	);

	
		// State machine to determine shift-register behavior
	always_ff @ (posedge SCLK) 
	begin
		actionState <= {prevLRCLK,LRCLK};
		prevLRCLK <= LRCLK;
	end

	always_comb 
	begin
		case (actionState)
			// LRCLK = prevLRCLK = 1'b0 <=> no clock transition, left 
			// channel active => keep shifting left channel
			2'b00 :
			begin
				shiftLChannel = 1'b1;
				loadL = 1'b0;
				loadR = 1'b0;
				shiftRChannel = 1'b0;
			end
			// prevLRCLK = 1'b0, LRCLK = 1'b1 <=> clock transition from 
			// left channel to right => load right channel
			2'b01 :
			begin
				shiftLChannel = 1'b0;
				loadL = 1'b0;
				loadR = 1'b1;
				shiftRChannel = 1'b0;
			end
			// clock transition right to left => load left channel
			2'b10 :
			begin
				shiftLChannel = 1'b0;
				loadL = 1'b1;
				loadR = 1'b0;
				shiftRChannel = 1'b0;
			end
			// no clock transition, active right channel => shift right channel
			2'b11 :
			begin
				shiftLChannel = 1'b0;
				loadL = 1'b0;
				loadR = 1'b0;
				shiftRChannel = 1'b1;
			end
			default :
				begin
				shiftLChannel = 1'b0;
				loadL = 1'b0;
				loadR = 1'b0;
				shiftRChannel = 1'b0;
				end
		endcase
	end
	
	//assign EnR = (~i2sEmpty || shiftRChannel || loadR);
	//assign EnL = (~i2sEmpty || shiftLChannel || loadL);
	
endmodule
