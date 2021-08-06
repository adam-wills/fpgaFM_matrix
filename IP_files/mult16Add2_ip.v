// megafunction wizard: %ALTMULT_ADD%
// GENERATION: STANDARD
// VERSION: WM1.0
// MODULE: ALTMULT_ADD 

// ============================================================
// File Name: mult16Add2_ip.v
// Megafunction Name(s):
// 			ALTMULT_ADD
//
// Simulation Library Files(s):
// 			altera_mf
// ============================================================
// ************************************************************
// THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
//
// 20.1.0 Build 711 06/05/2020 Patches 0.08std SJ Lite Edition
// ************************************************************


//Copyright (C) 2020  Intel Corporation. All rights reserved.
//Your use of Intel Corporation's design tools, logic functions 
//and other software and tools, and any partner logic 
//functions, and any output files from any of the foregoing 
//(including device programming or simulation files), and any 
//associated documentation or information are expressly subject 
//to the terms and conditions of the Intel Program License 
//Subscription Agreement, the Intel Quartus Prime License Agreement,
//the Intel FPGA IP License Agreement, or other applicable license
//agreement, including, without limitation, that your use is for
//the sole purpose of programming logic devices manufactured by
//Intel and sold by Intel or its authorized distributors.  Please
//refer to the applicable agreement for further details, at
//https://fpgasoftware.intel.com/eula.


// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module mult16Add2_ip (
	clock0,
	dataa_0,
	dataa_1,
	datab_0,
	datab_1,
	ena0,
	result);

	input	  clock0;
	input	[15:0]  dataa_0;
	input	[15:0]  dataa_1;
	input	[15:0]  datab_0;
	input	[15:0]  datab_1;
	input	  ena0;
	output	[32:0]  result;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_off
`endif
	tri1	  clock0;
	tri0	[15:0]  dataa_0;
	tri0	[15:0]  dataa_1;
	tri0	[15:0]  datab_0;
	tri0	[15:0]  datab_1;
	tri1	  ena0;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_on
`endif

	wire [32:0] sub_wire6;
	wire [15:0] sub_wire5 = datab_1[15:0];
	wire [15:0] sub_wire2 = dataa_1[15:0];
	wire [15:0] sub_wire0 = dataa_0[15:0];
	wire [31:0] sub_wire1 = {sub_wire2, sub_wire0};
	wire [15:0] sub_wire3 = datab_0[15:0];
	wire [31:0] sub_wire4 = {sub_wire5, sub_wire3};
	wire [32:0] result = sub_wire6[32:0];

	altmult_add	ALTMULT_ADD_component (
				.clock0 (clock0),
				.dataa (sub_wire1),
				.datab (sub_wire4),
				.ena0 (ena0),
				.result (sub_wire6),
				.accum_sload (1'b0),
				.aclr0 (1'b0),
				.aclr1 (1'b0),
				.aclr2 (1'b0),
				.aclr3 (1'b0),
				.addnsub1 (1'b1),
				.addnsub1_round (1'b0),
				.addnsub3 (1'b1),
				.addnsub3_round (1'b0),
				.chainin (1'b0),
				.chainout_round (1'b0),
				.chainout_sat_overflow (),
				.chainout_saturate (1'b0),
				.clock1 (1'b1),
				.clock2 (1'b1),
				.clock3 (1'b1),
				.coefsel0 ({3{1'b0}}),
				.coefsel1 ({3{1'b0}}),
				.coefsel2 ({3{1'b0}}),
				.coefsel3 ({3{1'b0}}),
				.datac ({44{1'b0}}),
				.ena1 (1'b1),
				.ena2 (1'b1),
				.ena3 (1'b1),
				.mult01_round (1'b0),
				.mult01_saturation (1'b0),
				.mult0_is_saturated (),
				.mult1_is_saturated (),
				.mult23_round (1'b0),
				.mult23_saturation (1'b0),
				.mult2_is_saturated (),
				.mult3_is_saturated (),
				.output_round (1'b0),
				.output_saturate (1'b0),
				.overflow (),
				.rotate (1'b0),
				.scanina ({16{1'b0}}),
				.scaninb ({16{1'b0}}),
				.scanouta (),
				.scanoutb (),
				.shift_right (1'b0),
				.signa (1'b0),
				.signb (1'b0),
				.sourcea ({2{1'b0}}),
				.sourceb ({2{1'b0}}),
				.zero_chainout (1'b0),
				.zero_loopback (1'b0));
	defparam
		ALTMULT_ADD_component.addnsub_multiplier_aclr1 = "UNUSED",
		ALTMULT_ADD_component.addnsub_multiplier_pipeline_aclr1 = "UNUSED",
		ALTMULT_ADD_component.addnsub_multiplier_pipeline_register1 = "CLOCK0",
		ALTMULT_ADD_component.addnsub_multiplier_register1 = "CLOCK0",
		ALTMULT_ADD_component.dedicated_multiplier_circuitry = "YES",
		ALTMULT_ADD_component.input_aclr_a0 = "UNUSED",
		ALTMULT_ADD_component.input_aclr_a1 = "UNUSED",
		ALTMULT_ADD_component.input_aclr_b0 = "UNUSED",
		ALTMULT_ADD_component.input_aclr_b1 = "UNUSED",
		ALTMULT_ADD_component.input_register_a0 = "CLOCK0",
		ALTMULT_ADD_component.input_register_a1 = "CLOCK0",
		ALTMULT_ADD_component.input_register_b0 = "CLOCK0",
		ALTMULT_ADD_component.input_register_b1 = "CLOCK0",
		ALTMULT_ADD_component.input_source_a0 = "DATAA",
		ALTMULT_ADD_component.input_source_a1 = "DATAA",
		ALTMULT_ADD_component.input_source_b0 = "DATAB",
		ALTMULT_ADD_component.input_source_b1 = "DATAB",
		ALTMULT_ADD_component.intended_device_family = "MAX 10",
		ALTMULT_ADD_component.lpm_type = "altmult_add",
		ALTMULT_ADD_component.multiplier1_direction = "ADD",
		ALTMULT_ADD_component.multiplier_aclr0 = "UNUSED",
		ALTMULT_ADD_component.multiplier_aclr1 = "UNUSED",
		ALTMULT_ADD_component.multiplier_register0 = "CLOCK0",
		ALTMULT_ADD_component.multiplier_register1 = "CLOCK0",
		ALTMULT_ADD_component.number_of_multipliers = 2,
		ALTMULT_ADD_component.output_aclr = "UNUSED",
		ALTMULT_ADD_component.output_register = "CLOCK0",
		ALTMULT_ADD_component.port_addnsub1 = "PORT_UNUSED",
		ALTMULT_ADD_component.port_signa = "PORT_UNUSED",
		ALTMULT_ADD_component.port_signb = "PORT_UNUSED",
		ALTMULT_ADD_component.representation_a = "UNSIGNED",
		ALTMULT_ADD_component.representation_b = "UNSIGNED",
		ALTMULT_ADD_component.signed_aclr_a = "UNUSED",
		ALTMULT_ADD_component.signed_aclr_b = "UNUSED",
		ALTMULT_ADD_component.signed_pipeline_aclr_a = "UNUSED",
		ALTMULT_ADD_component.signed_pipeline_aclr_b = "UNUSED",
		ALTMULT_ADD_component.signed_pipeline_register_a = "CLOCK0",
		ALTMULT_ADD_component.signed_pipeline_register_b = "CLOCK0",
		ALTMULT_ADD_component.signed_register_a = "CLOCK0",
		ALTMULT_ADD_component.signed_register_b = "CLOCK0",
		ALTMULT_ADD_component.width_a = 16,
		ALTMULT_ADD_component.width_b = 16,
		ALTMULT_ADD_component.width_result = 33;


endmodule

// ============================================================
// CNX file retrieval info
// ============================================================
// Retrieval info: PRIVATE: ADDNSUB1_ACLR_SRC NUMERIC "3"
// Retrieval info: PRIVATE: ADDNSUB1_CLK_SRC NUMERIC "0"
// Retrieval info: PRIVATE: ADDNSUB1_PIPE_ACLR_SRC NUMERIC "3"
// Retrieval info: PRIVATE: ADDNSUB1_PIPE_CLK_SRC NUMERIC "0"
// Retrieval info: PRIVATE: ADDNSUB1_PIPE_REG STRING "1"
// Retrieval info: PRIVATE: ADDNSUB1_REG STRING "1"
// Retrieval info: PRIVATE: ADDNSUB3_ACLR_SRC NUMERIC "3"
// Retrieval info: PRIVATE: ADDNSUB3_CLK_SRC NUMERIC "0"
// Retrieval info: PRIVATE: ADDNSUB3_PIPE_ACLR_SRC NUMERIC "3"
// Retrieval info: PRIVATE: ADDNSUB3_PIPE_CLK_SRC NUMERIC "0"
// Retrieval info: PRIVATE: ADDNSUB3_PIPE_REG STRING "1"
// Retrieval info: PRIVATE: ADDNSUB3_REG STRING "1"
// Retrieval info: PRIVATE: ADD_ENABLE NUMERIC "1"
// Retrieval info: PRIVATE: ALL_REG_ACLR NUMERIC "0"
// Retrieval info: PRIVATE: A_ACLR_SRC_MULT0 NUMERIC "3"
// Retrieval info: PRIVATE: A_CLK_SRC_MULT0 NUMERIC "0"
// Retrieval info: PRIVATE: B_ACLR_SRC_MULT0 NUMERIC "3"
// Retrieval info: PRIVATE: B_CLK_SRC_MULT0 NUMERIC "0"
// Retrieval info: PRIVATE: HAS_MAC STRING "0"
// Retrieval info: PRIVATE: HAS_SAT_ROUND STRING "0"
// Retrieval info: PRIVATE: IMPL_STYLE_DEDICATED NUMERIC "1"
// Retrieval info: PRIVATE: IMPL_STYLE_DEFAULT NUMERIC "0"
// Retrieval info: PRIVATE: IMPL_STYLE_LCELL NUMERIC "0"
// Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "MAX 10"
// Retrieval info: PRIVATE: MULT_REGA0 NUMERIC "1"
// Retrieval info: PRIVATE: MULT_REGB0 NUMERIC "1"
// Retrieval info: PRIVATE: MULT_REGOUT0 NUMERIC "1"
// Retrieval info: PRIVATE: NUM_MULT STRING "2"
// Retrieval info: PRIVATE: OP1 STRING "Add"
// Retrieval info: PRIVATE: OP3 STRING "Add"
// Retrieval info: PRIVATE: OUTPUT_EXTRA_LAT NUMERIC "0"
// Retrieval info: PRIVATE: OUTPUT_REG_ACLR_SRC NUMERIC "3"
// Retrieval info: PRIVATE: OUTPUT_REG_CLK_SRC NUMERIC "0"
// Retrieval info: PRIVATE: Q_ACLR_SRC_MULT0 NUMERIC "3"
// Retrieval info: PRIVATE: Q_CLK_SRC_MULT0 NUMERIC "0"
// Retrieval info: PRIVATE: REG_OUT NUMERIC "1"
// Retrieval info: PRIVATE: RNFORMAT STRING "33"
// Retrieval info: PRIVATE: RQFORMAT STRING "Q1.15"
// Retrieval info: PRIVATE: RTS_WIDTH STRING "33"
// Retrieval info: PRIVATE: SAME_CONFIG NUMERIC "1"
// Retrieval info: PRIVATE: SAME_CONTROL_SRC_A0 NUMERIC "1"
// Retrieval info: PRIVATE: SAME_CONTROL_SRC_B0 NUMERIC "1"
// Retrieval info: PRIVATE: SCANOUTA NUMERIC "0"
// Retrieval info: PRIVATE: SCANOUTB NUMERIC "0"
// Retrieval info: PRIVATE: SHIFTOUTA_ACLR_SRC NUMERIC "3"
// Retrieval info: PRIVATE: SHIFTOUTA_CLK_SRC NUMERIC "0"
// Retrieval info: PRIVATE: SHIFTOUTA_REG STRING "0"
// Retrieval info: PRIVATE: SIGNA STRING "UNSIGNED"
// Retrieval info: PRIVATE: SIGNA_ACLR_SRC NUMERIC "3"
// Retrieval info: PRIVATE: SIGNA_CLK_SRC NUMERIC "0"
// Retrieval info: PRIVATE: SIGNA_PIPE_ACLR_SRC NUMERIC "3"
// Retrieval info: PRIVATE: SIGNA_PIPE_CLK_SRC NUMERIC "0"
// Retrieval info: PRIVATE: SIGNA_PIPE_REG STRING "1"
// Retrieval info: PRIVATE: SIGNA_REG STRING "1"
// Retrieval info: PRIVATE: SIGNB STRING "UNSIGNED"
// Retrieval info: PRIVATE: SIGNB_ACLR_SRC NUMERIC "3"
// Retrieval info: PRIVATE: SIGNB_CLK_SRC NUMERIC "0"
// Retrieval info: PRIVATE: SIGNB_PIPE_ACLR_SRC NUMERIC "3"
// Retrieval info: PRIVATE: SIGNB_PIPE_CLK_SRC NUMERIC "0"
// Retrieval info: PRIVATE: SIGNB_PIPE_REG STRING "1"
// Retrieval info: PRIVATE: SIGNB_REG STRING "1"
// Retrieval info: PRIVATE: SRCA0 STRING "Multiplier input"
// Retrieval info: PRIVATE: SRCB0 STRING "Multiplier input"
// Retrieval info: PRIVATE: SYNTH_WRAPPER_GEN_POSTFIX STRING "0"
// Retrieval info: PRIVATE: WIDTHA STRING "16"
// Retrieval info: PRIVATE: WIDTHB STRING "16"
// Retrieval info: LIBRARY: altera_mf altera_mf.altera_mf_components.all
// Retrieval info: CONSTANT: ADDNSUB_MULTIPLIER_ACLR1 STRING "UNUSED"
// Retrieval info: CONSTANT: ADDNSUB_MULTIPLIER_PIPELINE_ACLR1 STRING "UNUSED"
// Retrieval info: CONSTANT: ADDNSUB_MULTIPLIER_PIPELINE_REGISTER1 STRING "CLOCK0"
// Retrieval info: CONSTANT: ADDNSUB_MULTIPLIER_REGISTER1 STRING "CLOCK0"
// Retrieval info: CONSTANT: DEDICATED_MULTIPLIER_CIRCUITRY STRING "YES"
// Retrieval info: CONSTANT: INPUT_ACLR_A0 STRING "UNUSED"
// Retrieval info: CONSTANT: INPUT_ACLR_A1 STRING "UNUSED"
// Retrieval info: CONSTANT: INPUT_ACLR_B0 STRING "UNUSED"
// Retrieval info: CONSTANT: INPUT_ACLR_B1 STRING "UNUSED"
// Retrieval info: CONSTANT: INPUT_REGISTER_A0 STRING "CLOCK0"
// Retrieval info: CONSTANT: INPUT_REGISTER_A1 STRING "CLOCK0"
// Retrieval info: CONSTANT: INPUT_REGISTER_B0 STRING "CLOCK0"
// Retrieval info: CONSTANT: INPUT_REGISTER_B1 STRING "CLOCK0"
// Retrieval info: CONSTANT: INPUT_SOURCE_A0 STRING "DATAA"
// Retrieval info: CONSTANT: INPUT_SOURCE_A1 STRING "DATAA"
// Retrieval info: CONSTANT: INPUT_SOURCE_B0 STRING "DATAB"
// Retrieval info: CONSTANT: INPUT_SOURCE_B1 STRING "DATAB"
// Retrieval info: CONSTANT: INTENDED_DEVICE_FAMILY STRING "MAX 10"
// Retrieval info: CONSTANT: LPM_TYPE STRING "altmult_add"
// Retrieval info: CONSTANT: MULTIPLIER1_DIRECTION STRING "ADD"
// Retrieval info: CONSTANT: MULTIPLIER_ACLR0 STRING "UNUSED"
// Retrieval info: CONSTANT: MULTIPLIER_ACLR1 STRING "UNUSED"
// Retrieval info: CONSTANT: MULTIPLIER_REGISTER0 STRING "CLOCK0"
// Retrieval info: CONSTANT: MULTIPLIER_REGISTER1 STRING "CLOCK0"
// Retrieval info: CONSTANT: NUMBER_OF_MULTIPLIERS NUMERIC "2"
// Retrieval info: CONSTANT: OUTPUT_ACLR STRING "UNUSED"
// Retrieval info: CONSTANT: OUTPUT_REGISTER STRING "CLOCK0"
// Retrieval info: CONSTANT: PORT_ADDNSUB1 STRING "PORT_UNUSED"
// Retrieval info: CONSTANT: PORT_SIGNA STRING "PORT_UNUSED"
// Retrieval info: CONSTANT: PORT_SIGNB STRING "PORT_UNUSED"
// Retrieval info: CONSTANT: REPRESENTATION_A STRING "UNSIGNED"
// Retrieval info: CONSTANT: REPRESENTATION_B STRING "UNSIGNED"
// Retrieval info: CONSTANT: SIGNED_ACLR_A STRING "UNUSED"
// Retrieval info: CONSTANT: SIGNED_ACLR_B STRING "UNUSED"
// Retrieval info: CONSTANT: SIGNED_PIPELINE_ACLR_A STRING "UNUSED"
// Retrieval info: CONSTANT: SIGNED_PIPELINE_ACLR_B STRING "UNUSED"
// Retrieval info: CONSTANT: SIGNED_PIPELINE_REGISTER_A STRING "CLOCK0"
// Retrieval info: CONSTANT: SIGNED_PIPELINE_REGISTER_B STRING "CLOCK0"
// Retrieval info: CONSTANT: SIGNED_REGISTER_A STRING "CLOCK0"
// Retrieval info: CONSTANT: SIGNED_REGISTER_B STRING "CLOCK0"
// Retrieval info: CONSTANT: WIDTH_A NUMERIC "16"
// Retrieval info: CONSTANT: WIDTH_B NUMERIC "16"
// Retrieval info: CONSTANT: WIDTH_RESULT NUMERIC "33"
// Retrieval info: USED_PORT: clock0 0 0 0 0 INPUT VCC "clock0"
// Retrieval info: USED_PORT: dataa_0 0 0 16 0 INPUT GND "dataa_0[15..0]"
// Retrieval info: USED_PORT: dataa_1 0 0 16 0 INPUT GND "dataa_1[15..0]"
// Retrieval info: USED_PORT: datab_0 0 0 16 0 INPUT GND "datab_0[15..0]"
// Retrieval info: USED_PORT: datab_1 0 0 16 0 INPUT GND "datab_1[15..0]"
// Retrieval info: USED_PORT: ena0 0 0 0 0 INPUT VCC "ena0"
// Retrieval info: USED_PORT: result 0 0 33 0 OUTPUT GND "result[32..0]"
// Retrieval info: CONNECT: @clock0 0 0 0 0 clock0 0 0 0 0
// Retrieval info: CONNECT: @dataa 0 0 16 0 dataa_0 0 0 16 0
// Retrieval info: CONNECT: @dataa 0 0 16 16 dataa_1 0 0 16 0
// Retrieval info: CONNECT: @datab 0 0 16 0 datab_0 0 0 16 0
// Retrieval info: CONNECT: @datab 0 0 16 16 datab_1 0 0 16 0
// Retrieval info: CONNECT: @ena0 0 0 0 0 ena0 0 0 0 0
// Retrieval info: CONNECT: result 0 0 33 0 @result 0 0 33 0
// Retrieval info: LIB_FILE: altera_mf
