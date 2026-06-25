module smDataPath (clk, reset, coin_in, clearGame, spinA, spinB, spinC, gameStart, jackpot, pairWin, hexA, hexB, hexC);

	input wire clk, reset, coin_in, clearGame, spinA, spinB, spinC;
	output wire gameStart, jackpot, pairWin;
	output wire [6:0] hexA, hexB, hexC;
	
	// Internal Wires
	wire [7:0] lfsr_bus, reelA_out, reelB_out, reelC_out;
	reg gameStart_reg;
	// Game Logic
	always @(posedge clk or negedge reset)
	begin
		if (reset == 1'b0)
		begin
			gameStart_reg <= 1'b0;
		end
		else if (clearGame == 1'b1)
		begin
			gameStart_reg <= 1'b0; // Game turns of b/c of reset/pay out
		end
		else if (coin_in == 1'b1) 
		begin
			gameStart_reg <= 1'b1; // Turn on when money is inserted
		end
	end
	
	assign gameStart = gameStart_reg;
	
	// Seed/ Random Number Generation (LFSR)
	smLFSR rngMachine(reelA_out, lfsr_bus);
	
	// Three Reel Hex
	genericRegister #(8) reelRegA(lfsr_bus, clk, reset, spinA, reelA_out);
	genericRegister #(8) reelRegB(lfsr_bus, clk, reset, spinB, reelB_out);
	genericRegister #(8) reelRegC(lfsr_bus, clk, reset, spinC, reelC_out);
	
	// Slow Machine ALU
	smALU calculator(reelA_out, reelB_out, reelC_out, jackpot, pairWin);
	
	// 7 Segment Display of Reels
	hexToSevenSeg displayA(reelA_out[3:0], hexA);
	hexToSevenSeg displayB(reelB_out[3:0], hexB);
	hexToSevenSeg displayC(reelC_out[3:0], hexC);
	
endmodule
