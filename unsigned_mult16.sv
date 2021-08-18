module unsigned_mult16 (
      input  logic clk,
      input  logic [15:0] dataa,
      input  logic [15:0] datab,
      output logic [31:0] dout
);
					  
reg [7:0] A_upper;
reg [7:0] A_lower;
reg [7:0] B_upper;
reg [7:0] B_lower;

reg [15:0] Aup_Bup;
reg [15:0] Aup_Blo;
reg [15:0] Alo_Bup;
reg [15:0] Alo_Blo;

reg [31:0] results;


assign results = {Aup_Bup,16'b0} + 
					  {8'b0,Aup_Blo,8'b0} +
					  {8'b0,Alo_Bup,8'b0} +
					  {16'b0,Alo_Blo};

unsigned_mult AhiBhi(.clk(clk),
							.a(A_upper),
							.b(B_upper),
							.dout(Aup_Bup));
							
unsigned_mult AhiBlo(.clk(clk),
							.a(A_upper),
							.b(B_lower),
							.dout(Aup_Blo));
							
unsigned_mult AloBhi(.clk(clk),
							.a(A_lower),
							.b(B_upper),
							.dout(Alo_Bup));
							
unsigned_mult AloBlo(.clk(clk),
							.a(A_lower),
							.b(B_lower),
							.dout(Alo_Blo));
							
always_ff @ (posedge clk)
begin
	A_upper <= dataa[15:8];
	A_lower <= dataa[7:0];
	B_upper <= datab[15:8];
	B_lower <= datab[7:0];
	
	dout <= results;
end

endmodule
