// Copyright 2007 Altera Corporation. All rights reserved.  
// Altera products are protected under numerous U.S. and foreign patents, 
// maskwork rights, copyrights and other intellectual property laws.  
//
// This reference design file, and your use thereof, is subject to and governed
// by the terms and conditions of the applicable Altera Reference Design 
// License Agreement (either as signed by you or found at www.altera.com).  By
// using this reference design file, you indicate your acceptance of such terms
// and conditions between you and Altera Corporation.  In the event that you do
// not agree with such terms and conditions, you may not use the reference 
// design file and please promptly destroy any copies you have made.
//
// This reference design file is being provided on an "as-is" basis and as an 
// accommodation and therefore all warranties, representations or guarantees of 
// any kind (whether express, implied or statutory) including, without 
// limitation, warranties of merchantability, non-infringement, or fitness for
// a particular purpose, are specifically disclaimed.  By making this reference
// design file available, Altera expressly does not recommend, suggest or 
// require that this reference design file be used in combination with any 
// other product not provided by Altera.
/////////////////////////////////////////////////////////////////////////////

// baeckler - 06-16-2006
// EDITS: wills - 08/01/2021
// (1 cell per bit)

module cntr_modulus
#(
      parameter WIDTH = 2,
		          MODVAL = 4
)
(
      input  logic Clk, Enable, Reset, sClear,
      output reg   [WIDTH-1:0] q
);

wire maxed = (q == MODVAL-1) /* synthesis keep */;

always @(posedge Clk) begin
	if (Reset) q <= 0;
	else begin
		if (Enable) begin
			if (sClear) q <= 0;
			else q <= (maxed ? 0 : q) + (maxed ? 0 : 1'b1);
		end
		else
			q <= q;
	end
end

endmodule
