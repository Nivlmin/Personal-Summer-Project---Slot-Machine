module genericComparator(X, Y, G, L, EQ);

	parameter n = 8;
	
	input wire [n-1:0] X, Y;
	output reg G, L, EQ;
	
	always @(*) begin
		if (X == Y)
			begin
				EQ = 1'b1;
				L = 1'b0;
				G = 1'b0;
			end
		else if (X < Y)
			begin
				EQ = 1'b0;
				L = 1'b1;
				G = 1'b0;
			end
		else
			begin
				EQ = 1'b0;
				L = 1'b0;
				G = 1'b1;
			end
		end

endmodule