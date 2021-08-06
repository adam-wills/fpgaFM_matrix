module fpgaFM_matrix 
(
    // Top Level Inputs/Outputs //
	
      ///////// Clocks /////////
      input     MAX10_CLK1_50, 
      input     MAX10_CLK2_50,

      ///////// KEY /////////
      input    [ 1: 0]   KEY,

      ///////// SW /////////
      input    [ 9: 0]   SW,

      ///////// LEDR /////////
      output   [ 9: 0]   LEDR,

      ///////// HEX /////////
      output   [ 7: 0]   HEX0,
      output   [ 7: 0]   HEX1,
      output   [ 7: 0]   HEX2,
      output   [ 7: 0]   HEX3,
      output   [ 7: 0]   HEX4,
      output   [ 7: 0]   HEX5,

      ///////// SDRAM /////////
      output             DRAM_CLK,
      output             DRAM_CKE,
      output   [12: 0]   DRAM_ADDR,
      output   [ 1: 0]   DRAM_BA,
      inout    [15: 0]   DRAM_DQ,
      output             DRAM_LDQM,
      output             DRAM_UDQM,
      output             DRAM_CS_N,
      output             DRAM_WE_N,
      output             DRAM_CAS_N,
      output             DRAM_RAS_N,


      ///////// ARDUINO /////////
      inout    [15: 0]   ARDUINO_IO,
      inout              ARDUINO_RESET_N

);

localparam NUMVOICES = 12;
localparam VOICEADDRWIDTH = 4;
localparam NUMOUTPUTS = 4;
localparam OUTADDRWIDTH = 2;
localparam OUTPUTWIDTH = 32+OUTADDRWIDTH;

logic Reset_h;
logic Continue_h;
// Invert active-low reset and continue buttons
assign {Continue_h} =~ (KEY[1]);
assign {Reset_h} =~ (KEY[0]);	

//=======================================================
//   Instantiate onChip-Memory Wavetables
//=======================================================
logic readEn = 1'b0;
reg   [12:0] samp_addr[NUMVOICES];

waveformROMbank ROMbank
(
	.Clk(MAX10_CLK2_50),
	.En(readEn),
	.wave(waveforms[count]),
	.octave(octaves[count]),
	.addr(samp_addr[count]),
	.data_out_interp(sampBankInterp[count][0:1]),
	.data_out_anti(sampBankAnti[count][0:1])
);
reg   [15:0] sampBankInterp[NUMVOICES][2];
reg   [15:0] sampBankAnti  [NUMVOICES][2];
reg   [15:0] samps_interp  [2][NUMVOICES];
reg   [15:0] samps_anti    [2][NUMVOICES];
genvar g;
int unsigned h;
generate
   for (g = 0; g < NUMVOICES; g = g+1) begin
      for (h = 0; h < 2; h = h+1) begin
         assign samps_interp[h][g] = sampBankInterp[g][h];
			assign samps_anti[h][g] = sampBankAnti[g][h];
      end
   end
endgenerate

//=======================================================
//   Keycode Decoding and Sample Generation
//=======================================================

reg   [VOICEADDRWIDTH-1:0] count        = {VOICEADDRWIDTH{1'b0}};
reg   [OUTADDRWIDTH-1:0]   output_count = {OUTADDRWIDTH{1'b0}};

reg                        keycode_rden   [NUMOUTPUTS];
reg   [7:0]                keycodes       [NUMOUTPUTS];
reg   [6:0]                midi_notenums  [NUMOUTPUTS];

reg   [31:0]               phase_increments[NUMVOICES];
reg   [31:0]               fm_inputs       [NUMVOICES];
reg   [31:0]               phase_offsets   [NUMVOICES];
reg   [31:0]               table_interps   [NUMVOICES];
reg   [19:0]               samp_interps    [NUMVOICES];
reg   [6:0]                octaves         [NUMVOICES];
reg   [63:0]               interped_outputs[NUMVOICES];

logic sampReq = 1'b0;
logic sampGenEn, voiceCounterEnable;
assign voiceCounterEnable = sampReq & sampGenEn;

cntr_modulus #(.WIDTH(VOICEADDRWIDTH), .MODVAL(NUMVOICES)) voiceCounter
(
      .Clk(MAX10_CLK2_50),
		.En(voiceCounterEnable),
		.Reset(Reset_h),
		.sClear(),
		.q(count)
);

cntr_modulus #(.WIDTH(OUTADDRWIDTH), .MODVAL(NUMOUTPUTS)) outputCounter
(
      .Clk(MAX10_CLK2_50),
      .En(voiceCounterEnable),
      .Reset(Reset_h),
		.sClear(),
		.q(output_count)
);


// Convert keycodes derived from keyboard input to MIDI note numbers as determined by Wicki-Hayden
// note layout (stored as ROM)
keycodeToMIDI #(.NUMREADS(NUMOUTPUTS)) keycodeDecoder
(
      .clk(MAX10_CLK2_50),
		.rden(keycode_rden),
		.octave(octave),
		.keycodes(keycodes),
		.midi_notenums(midi_notenums)
);


// Determine the phase increment, wavetable interpolation value and wavetable index for each
// generated MIDI note through the use of dedicated ROMs
MIDItoPhaseIncrement #(.NUMREADS(NUMOUTPUTS)) phaseROM
(
      .clk(MAX10_CLK2_50),
		.midi_notenums(midi_notenums),
		.phase_increments(phase_increments[0:NUMOUTPUTS-1])
);

MIDItoTableInterp #(.NUMREADS(NUMOUTPUTS)) interpROM
(
      .clk(MAX10_CLK2_50),
		.midi_notenums(midi_notenums),
		.table_interps(table_interps[0:NUMOUTPUTS-1])
);

MIDItoTableIndex #(.NUMREADS(NUMOUTPUTS)) indexROM
(
      .clk(MAX10_CLK2_50),
		.midi_notenums(midi_notenums),
		.table_indices(octaves[0:NUMOUTPUTS-1])
);

// TODO: assign switchable source for remaining phase increments (may be either a multiple of a keycode freq or 
// a constant set using the software)


// phase accumulators to select samples from wavetable at rate determined by phase increments and fm inputs
phasor addressGenerators[0:NUMVOICES-1]
(
      .Clk(MAX10_CLK2_50),
		.Reset(Reset_h),
		.En(voiceCounterEnable),
		.phase_increment(phase_increments),
		.fm_input(fm_inputs),
		.phase_offset(phase_offsets),
		.interp(samp_interps),
		.wavetable_addr(samp_addr)
);



// perform interpolation between wavetable samples (using LSBs of phasors) and between wavetables (using calculated
// values derived from the base-2 logarithm of the ratio of the desired frequency to the sample rate)
// NOTE: Definitely unnecessary to have NUMVOICES of these when samples for each voice are determined at different times;
//       In all likelihood I will attempt to use some form of custom multiread wavetable ROM but I'll think about it later.
bilinearInterpolator sampleInterpolator[0:NUMVOICES-1]
(
      .Clk(MAX10_CLK2_50),
		.En(voiceCounterEnable),
		.interp_samples(samps_interp),
		.antiInterp_samples(samps_anti),
		.sample_interp(samp_interps),
		.table_interp(table_interps),
		.interped_out(interped_outputs)
);


/* 
// ===================================
// Heart of Synthesizer: Should allow for the frequency offset, phase offset, amplitude multiplicand and cutoff for every
// voice to be set as a linear combination of the outputs of any 2 voices. Perhaps overly ambitious/underestimating embedded mults
// =================================== 
*/
matrixRegfile #(.DW(16), .RW(2), .CW(4)) routingWeights[0:NUMVOICES-1]
(
      .clk(MAX10_CLK2_50),
		.wren(routingWeight_wrens),
		.wr_data(routingWeight_sets),
		.rd_data(routingWeight_gets)
);

matrixRegfile #(.DW(VOICEADDRWIDTH), .RW(2), .CW(4)) routingIndices[0:NUMVOICES-1]
(
      .clk(MAX10_CLK2_50),
		.wren(routingIdx_wrens),
		.wr_data(routingIdx_sets),
		.rd_data(routingIdx_gets)
);

logic [31:0]               routingWeight_sets [0:1][0:3][0:NUMVOICES-1];
logic [31:0]               routingWeight_gets [0:1][0:3][0:NUMVOICES-1];
logic [VOICEADDRWIDTH-1:0] routingIdx_sets    [0:1][0:3][0:NUMVOICES-1];
logic [VOICEADDRWIDTH-1:0] routingIdx_gets    [0:1][0:3][0:NUMVOICES-1];
logic                      routingWeight_wrens[0:1][0:3][0:NUMVOICES-1];
logic                      routingIdx_wrens   [0:1][0:3][0:NUMVOICES-1];

logic [31:0]               oscillator_inputs       [0:3][0:NUMVOICES-1];
logic [31:0]               oscillator_outputs           [0:NUMVOICES-1];

logic [OUTPUTWIDTH:0] finalOutput = {OUTPUTWIDTH{1'b0}};

formattedMultAdd #(.DW(32), .VOICE_AW(VOICEADDRWIDTH)) oscInputMultAdd[0:NUMVOICES-1]
(
      .clk(MAX10_CLK2_50),
		.enable(voiceCycleEnable),
		.routing_weights(routingWeight_gets),
		.routing_values(oscillator_outputs),
		.routing_indices(routingIdx_gets),
		.routing_target(oscillator_inputs)
);


genvar i;
int unsigned j, k;

generate
for (i = 0; i < NUMVOICES; i = i+1) begin
   always_ff @ (posedge MAX10_CLK2_50) begin
      if (Reset_h) begin
		   oscillator_outputs[i] <= 32'b0;
			
			for (j = 0; j < 4; j = j+1) begin
            oscillator_inputs[j][i] <= 32'b0;
				
				for (k = 0; k < 2; k = k+1) begin
               routingWeight_sets[k][j][i] <= 0;
               routingWeight_gets[k][j][i] <= 0;
               routingIdx_sets[k][j][i]    <= 0;
               routingIdx_gets[k][j][i]    <= 0;
               routingWeight_wrens[k][j][i]<= 0;
               routingIdx_wrens[k][j][i]   <= 0;
            end
         end
      end
	   else begin
         oscillator_outputs[i] <= interped_outputs[i][63:32];
	   end
   end
end
endgenerate

always_ff @ (posedge MAX10_CLK2_50) begin
   if (Reset_h)
      finalOutput <= {OUTPUTWIDTH{1'b0}};
end

always_ff @ (negedge MAX10_CLK2_50) begin
   if (output_count == {OUTADDRWIDTH{1'b0}})
      finalOutput <= {OUTPUTWIDTH{1'b0}};
end

// HOW TO ADD AND APROPRIATELY SEND OUTPUTS



//=======================================================
//   I2C Tristate Buffers and Declarations
//=======================================================

logic I2C_SDA_IN, I2C_SDA_OE, I2C_SCL_IN, I2C_SCL_OE;
	
// active I2C signals pull clock and data lines low
assign I2C_SDA_IN = ARDUINO_IO[14];
assign ARDUINO_IO[14] = I2C_SDA_OE ? 1'b0 : 1'bZ;  // I2C SDA tristate
	
assign I2C_SCL_IN = ARDUINO_IO[15];
assign ARDUINO_IO[15] = I2C_SCL_OE ? 1'b0 : 1'bZ;	// I2C SCL tristate


//=======================================================
//   I2S processing
//=======================================================		

logic        streamoutR, streamOutL;
logic [31:0] i2sDin;


clockDivider_AW clockDivider_2
(
		.Clk0(MAX10_CLK2_50),
		.Reset(Reset_h),
		.Clk1(MCLK)
);

i2s_core i2s_core_inst
(
		.FCLK(MAX10_CLK2_50),
		.SCLK(SCLK),
		.LRCLK(LRCLK),
		.Reset(Reset_h),
		.i2sDin(i2sDin),
		.sampReq(sampReq),
		.sampGenEn(sampGenEn),
		.readEn(readEn),
		.streamOutR(streamOutR),
		.streamOutL(streamOutL)
);
//=======================================================
//  Structural coding
//=======================================================

// I2S
logic MCLK;
reg   SCLK, LRCLK;
assign ARDUINO_IO[2] = (LRCLK) ? streamOutR : streamOutL;
assign ARDUINO_IO[3] = MCLK;
assign LRCLK = ARDUINO_IO[4];
assign SCLK =  ARDUINO_IO[5];
//assign LRCLK = ARDUINO_IO[4];
//assign SCLK = ARDUINO_IO[5];


// SPI
logic SPI0_CS_N, SPI0_SCLK, SPI0_MISO, SPI0_MOSI;
assign ARDUINO_IO[10] = SPI0_CS_N;
assign ARDUINO_IO[13] = SPI0_SCLK;
assign ARDUINO_IO[11] = SPI0_MOSI;
assign ARDUINO_IO[12] = 1'bZ;
assign SPI0_MISO = ARDUINO_IO[12];

// USB
logic USB_GPX, USB_IRQ, USB_RST;
assign ARDUINO_IO[9] = 1'bZ; 
assign USB_IRQ = ARDUINO_IO[9];
assign ARDUINO_RESET_N = USB_RST;
assign ARDUINO_IO[7] = USB_RST;//USB reset 
assign ARDUINO_IO[8] = USB_GPX;
assign USB_GPX = 1'b0;//GPX is not needed for standard USB host - set to 0 to prevent interrupt

//Assign uSD CS to '1' to prevent uSD card from interfering with USB Host (if uSD card is plugged in)
assign ARDUINO_IO[6] = 1'b1;

//HEX drivers to convert numbers to HEX output
logic [3:0] hex_num_4, hex_num_3, hex_num_1, hex_num_0; //4 bit input hex digits
logic [9:0] LEDDummy;
logic [1:0] signs;
logic [1:0] hundreds;

HexDriver hex_driver4 (hex_num_4, HEX3[6:0]);
assign HEX3[7] = 1'b1;

HexDriver hex_driver3 (hex_num_3, HEX2[6:0]);
assign HEX2[7] = 1'b1;

HexDriver hex_driver1 (hex_num_1, HEX1[6:0]);
assign HEX1[7] = 1'b1;

HexDriver hex_driver0 (hex_num_0, HEX0[6:0]);
assign HEX0[7] = 1'b1;

fpgaSynth u0
(
		.clk_clk                           (MAX10_CLK1_50),  //clk.clk
		.reset_reset_n                     (1'b1),           //reset.reset_n
		.key_external_connection_export    (KEY),            //key_external_connection.export
		.switch_external_connection_export (SW),
		.led_export                        (LEDR),
		.octave_export                     (octave),
		.table_interp_export               (),
		
		//I2C
		.i2c_serial_sda_in(I2C_SDA_IN),
		.i2c_serial_scl_in(I2C_SCL_IN),
		.i2c_serial_sda_oe(I2C_SDA_OE),
		.i2c_serial_scl_oe(I2C_SCL_OE),
		
		//SPI
		.spi0_MOSI(SPI0_MOSI),
		.spi0_MISO(SPI0_MISO),
		.spi0_SCLK(SPI0_SCLK),
		.spi0_SS_n(SPI0_SS_N),
		
		//USB
		.usb_gpx_export(USB_GPX),
		.usb_irq_export(USB_IRQ),
		.usb_rst_export(USB_RST),
		
		//KEYCODES
		.keycode_0_export(keycodes[0]),
		.keycode_1_export(keycodes[1]),
		.keycode_2_export(keycodes[2]),
		.keycode_3_export(keycodes[3]),
		
		//SDRAM
		.sdram_clk_clk(DRAM_CLK),                            //clk_sdram.clk
		.sdram_wire_addr(DRAM_ADDR),                         //sdram_wire.addr
		.sdram_wire_ba(DRAM_BA),                             //.ba
		.sdram_wire_cas_n(DRAM_CAS_N),                       //.cas_n
		.sdram_wire_cke(DRAM_CKE),                           //.cke
		.sdram_wire_cs_n(DRAM_CS_N),                         //.cs_n
		.sdram_wire_dq(DRAM_DQ),                             //.dq
		.sdram_wire_dqm({DRAM_UDQM,DRAM_LDQM}),              //.dqm
		.sdram_wire_ras_n(DRAM_RAS_N),                       //.ras_n
		.sdram_wire_we_n(DRAM_WE_N),                         //.we_n
);

endmodule

