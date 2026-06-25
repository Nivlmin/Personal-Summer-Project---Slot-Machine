module smALU (reelA, reelB, reelC, jackpot, pairWin);

	input wire [7:0] reelA, reelB, reelC;
	output reg jackpot, pairWin;
	
	wire eqAB, eqBC, eqAC;
	
	// Instantiate comparators
	// Had to incoporate bus truncation to work around the 8 bit LFSR/ALU with the 4 bit hexToSevenSeg
	genericComparator #(4) ABcomp(reelA[3:0], reelB[3:0], , ,eqAB);
	genericComparator #(4) BCcomp(reelB[3:0], reelC[3:0], , ,eqBC);
	genericComparator #(4) ACcomp(reelA[3:0], reelC[3:0], , ,eqAC);
	
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
