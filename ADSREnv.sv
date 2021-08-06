module ADSRenv
(
	input  logic        Clk, Reset, Trig, noteOff,
	input  logic [31:0] aStep, dStep, sLevel, sTime, rStep,
	output logic [15:0] env,
	output logic        ADSRIdle
);
	// consts
	localparam MAX = 32'h8000_0000;
	localparam BYPASS = 32'hffff_ffff;
	localparam ZERO = 32'h0000_0000;
	
	// define state type
	typedef enum {idle, start, attack, decay, sustain, rel} state_type;
	
	// internal variables
	state_type stateReg, stateNext;
	logic [31:0] aReg, tReg, aNext, tNext, nTmp, env_i;
	logic        fsmIdle;
	
	// state transition
	always_ff @(posedge Clk)
		if (Reset) begin
			stateReg <= idle;
			aReg <= 32'h0;
			tReg <= 32'h0;
			nTmp <= 32'h0;
		end
		else begin
			stateReg <= stateNext;
			aReg <= aNext;
			tReg <= tNext;
		end
	
	// next-state and datapath logic
	always_comb begin
		stateNext = stateReg;
		aNext = aReg;
		tNext = tReg;
		unique case (stateReg)
			idle : 
			begin
				nTmp = ZERO;
				aNext = ZERO;
				tNext = ZERO;
				//fsmIdle = 1'b1;
				if (Trig)
					stateNext = start;
					
				else
					stateNext = idle;
			end
			
			start :
			begin
				nTmp = ZERO;
				stateNext = attack;
				aNext = ZERO;
				tNext = ZERO;
			end
			
			attack :
			begin
			tNext = ZERO;
				if (Trig) begin
					stateNext = start;
					aNext = ZERO;
					nTmp = ZERO;
				end
				else begin
					nTmp = aReg + aStep;
					if (nTmp < MAX) begin
						aNext = nTmp;
						stateNext = attack;
					end
					else begin
						stateNext = decay;
						aNext = MAX;
						nTmp = MAX;
					end
				end
			end
			
			decay :
			begin
				if (Trig) begin
					stateNext = start;
					aNext = ZERO;
					tNext = ZERO;
					nTmp = ZERO;
				end
				else begin
					nTmp = aReg - dStep;
					if (nTmp > sLevel) begin
						stateNext = decay;
						aNext = nTmp;
						tNext = ZERO;
					end
					else begin
						stateNext = sustain;
						aNext = sLevel;
						tNext = 32'h0;
						nTmp = sLevel;
					end
				end
			end
			
			sustain :
			begin
				if (Trig) begin
					stateNext = start;
					aNext = ZERO;
					tNext = ZERO;
					nTmp = ZERO;
				end
				else begin
					if (noteOff) begin
						stateNext = rel;
						aNext = sLevel;
						tNext = 32'h0;
						
						nTmp = ZERO;
					end
					else begin
						aNext = sLevel;
						if (tReg < sTime) begin
							stateNext = sustain;
							tNext = tNext + 1;
							nTmp = sLevel;
						end
						else begin
							stateNext = rel;
							tNext = ZERO;
							nTmp = sLevel;
						end
					end
				end
			end
			
			default :
			begin
			tNext = ZERO;
			nTmp = ZERO;
				if (Trig) begin
					stateNext = start;
					aNext = ZERO;/// nah
					nTmp = ZERO;
					
				end
				else begin
					if (aReg > rStep)
						aNext = aReg - rStep;
					else begin
						stateNext = idle;
						aNext = ZERO;
					end
				end
			end
		endcase
	end
	
	assign ADSRIdle = fsmIdle;
	assign env_i = (aStep == BYPASS) ? MAX :
	               (aStep == ZERO) ? 32'h0 : aReg;
						
	assign env = env_i[30:15];
endmodule
		