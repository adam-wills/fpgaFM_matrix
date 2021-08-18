module unsigned_mult32 (
      input  logic clk,
      input  logic [31:0] dataa,
      input  logic [31:0] datab,
      output logic [63:0] dout
);
					  
reg [15:0] A_upper;
reg [15:0] A_lower;
reg [15:0] B_upper;
reg [15:0] B_lower;

reg [31:0] Aup_Bup;
reg [31:0] Aup_Blo;
reg [31:0] Alo_Bup;
reg [31:0] Alo_Blo;

reg [63:0] results;


assign results = {Aup_Bup,32'b0} + 
					  {16'b0,Aup_Blo,16'b0} +
					  {16'b0,Alo_Bup,16'b0} +
					  {32'b0,Alo_Blo};

unsigned_mult16 AhiBhi(
		.clk(clk),
		.a(A_upper),
		.b(B_upper),
		.dout(Aup_Bup)
);
							
unsigned_mult16 AhiBlo(
		.clk(clk),
		.a(A_upper),
		.b(B_lower),
		.dout(Aup_Blo)
);
							
unsigned_mult16 AloBhi(
		.clk(clk),
		.a(A_lower),
		.b(B_upper),
		.dout(Alo_Bup)
);
			
							
unsigned_mult16 AloBlo(
		.clk(clk),
		.a(A_lower),
		.b(B_lower),
		.dout(Alo_Blo)
);
							
always_ff @ (posedge clk)
begin
	A_upper <= dataa[31:16];
	A_lower <= dataa[15:0];
	B_upper <= datab[31:16];
	B_lower <= datab[15:0];
	
	dout <= results;
end

endmodule
