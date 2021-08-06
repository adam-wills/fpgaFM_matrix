module FMSM (
				 input  logic	Clk, Reset, Continue,
				 output logic  run, load_waves, load_enables, load_weights
				 );

	enum logic [2:0] {Halted, 
							Play, 
							Load_waveforms, 
							Load_fm_enables,
							Load_fm_weights} State, Next_state;
							
		
	always_ff @ (posedge Clk)
	begin
		if (Reset) 
			State <= Halted;
		else 
			State <= Next_state;
	end
   
	
	always_comb
	begin 
		// Default next state is staying at current state
		Next_state = State;
		
		//===================================
		// Default controls signal values
		//===================================
		
							 
		run = 1'b1;
		load_waves = 1'b0;
		load_enables = 1'b0;
		load_weights = 1'b0;
	
		// Assign next state
		unique case (State)
		
			Halted :
			begin
				if (~Continue) 
					Next_state = Play;
				else
					Next_state = Halted;
			end
			
			//Press and hold continue
			Play :
			begin
				if (Continue)
					Next_state = Load_waveforms;
				else
					Next_state = Play;
			end
			
			// while holding continue, flip SW[9:6] <-> osc[0:3] 
			// (select which osc waveform(s) to change);
			// flip SW[1:0] to desired waveform for chosen oscs
			Load_waveforms :
			begin
				if (~Continue)
					Next_state = Load_fm_enables;
				else
					Next_state = Load_waveforms;
			end
			
			// Release continue;
			// flip SW[9:6] <-> osc[0:3] to select which osc(s)'
			// FM weights you wish to change
			// flip SW[5:2] to select which weights you're loading for the chosen osc(s)
			Load_fm_enables :
			begin
				if (Continue)
					Next_state = Load_fm_weights;
				else
					Next_state = Load_fm_enables;
			end
			
			// while holding continue, flip SW[7:0] to set desired weight
			// release continue -> weight(s) set
			Load_fm_weights :
			begin
				if (~Continue)
					Next_state = Play;
				else
					Next_state = Load_fm_weights;
			end

			default : ;

		endcase
		
		// Assign control signals based on current state
		case (State)
			Halted :
			begin
				run = 1'b0;
				load_waves = 1'b0;
				load_enables = 1'b0;
				load_weights = 1'b0;
			end
			
			Play :
			begin
				run = 1'b1;
				load_waves = 1'b0;
				load_enables = 1'b0;
				load_weights = 1'b0;
				
			end
			
			Load_waveforms :
			begin
				run = 1'b1;
				load_waves = 1'b1;
				load_enables = 1'b0;
				load_weights = 1'b0;
			end
			
			Load_fm_enables :
			begin
				run = 1'b1;
				load_waves = 1'b0;
				load_enables = 1'b1;
				load_weights = 1'b0;
			end
			
			Load_fm_weights :
			begin
				run = 1'b1;
				load_waves = 1'b0;
				load_enables = 1'b0;
				load_weights = 1'b1;
			end
		endcase
	end
endmodule

		