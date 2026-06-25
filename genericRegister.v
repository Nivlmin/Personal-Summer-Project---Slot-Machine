module genericRegister(D, clk, reset, C, Q);

	parameter n = 8; // 8 Bit but a placeholder
	
	input wire [n-1:0] D;
	input wire		clk, reset, C; // C = Control Signal (1 = load, 0 = hold)
	output reg [n-1:0] Q;
	
	always @(posedge clk or negedge reset)
	begin
		if (reset == 1'b0)
			begin
				Q <= 0;
			end
			else if (C == 1'b1)
			begin
				Q <= D;
			end
	end
	
	endmodule
	
