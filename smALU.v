module smALU (reelA, reelB, reelC, jackpot, pairWin);

	input wire [7:0] reelA, reelB, reelC;
	output reg jackpot, pairWin;
	
	wire eqAB, eqBC, eqAC;
	
	// Instantiate comparators
	genericComparator #(8) ABcomp(reelA, reelB, , ,eqAB);
	genericComparator #(8) BCcomp(reelB, reelC, , ,eqBC);
	genericComparator #(8) ACcomp(reelA, reelC, , ,eqAC);
	
	always @(*)
		begin
			// Check for jackpot
			if (eqAB && eqBC)
			begin 
				jackpot = 1'b1;
				pairWin = 1'b0;
			end
			// Check for Pair wins
			else if (eqAB || eqBC || eqAC)
			begin
				jackpot = 1'b0;
				pairWin = 1'b1;
			end
			// Else Loss
			else
			begin
				jackpot = 1'b0;
				pairWin = 1'b0;
			end
		end
		
endmodule
