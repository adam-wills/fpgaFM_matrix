
module fpgaSynth (
	clk_clk,
	i2c_serial_sda_in,
	i2c_serial_scl_in,
	i2c_serial_sda_oe,
	i2c_serial_scl_oe,
	key_external_connection_export,
	keycode_0_export,
	keycode_1_export,
	keycode_2_export,
	keycode_3_export,
	led_export,
	reset_reset_n,
	sdram_clk_clk,
	sdram_wire_addr,
	sdram_wire_ba,
	sdram_wire_cas_n,
	sdram_wire_cke,
	sdram_wire_cs_n,
	sdram_wire_dq,
	sdram_wire_dqm,
	sdram_wire_ras_n,
	sdram_wire_we_n,
	spi0_MISO,
	spi0_MOSI,
	spi0_SCLK,
	spi0_SS_n,
	switch_external_connection_export,
	usb_gpx_export,
	usb_irq_export,
	usb_rst_export,
	octave_export);	

	input		clk_clk;
	input		i2c_serial_sda_in;
	input		i2c_serial_scl_in;
	output		i2c_serial_sda_oe;
	output		i2c_serial_scl_oe;
	input	[1:0]	key_external_connection_export;
	output	[7:0]	keycode_0_export;
	output	[7:0]	keycode_1_export;
	output	[7:0]	keycode_2_export;
	output	[7:0]	keycode_3_export;
	output	[9:0]	led_export;
	input		reset_reset_n;
	output		sdram_clk_clk;
	output	[12:0]	sdram_wire_addr;
	output	[1:0]	sdram_wire_ba;
	output		sdram_wire_cas_n;
	output		sdram_wire_cke;
	output		sdram_wire_cs_n;
	inout	[15:0]	sdram_wire_dq;
	output	[1:0]	sdram_wire_dqm;
	output		sdram_wire_ras_n;
	output		sdram_wire_we_n;
	input		spi0_MISO;
	output		spi0_MOSI;
	output		spi0_SCLK;
	output		spi0_SS_n;
	input	[9:0]	switch_external_connection_export;
	input		usb_gpx_export;
	input		usb_irq_export;
	output		usb_rst_export;
	output	[2:0]	octave_export;
endmodule
