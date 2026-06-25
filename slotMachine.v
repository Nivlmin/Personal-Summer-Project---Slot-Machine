// Slot Machine Project - Melvin Huynh - Summer - Fall 2026
//
// Overview: I wanted to create a slot machine in verilog to apply my digital logic skills
// and also to learn about CPUs

module slotMachine(clk, reset, coin_in, setSeed, jackpot, pairWin, systemState, hexA, hexB, hexC);

	input wire clk, reset, coin_in;
	input wire [7:0] setSeed;
	output wire jackpot, pairWin;
	output wire[1:0] systemState;
	output wire[6:0] hexA, hexB, hexC;

	// Internal Connecting Wires for Datapath and Control
	wire clearGameCon, spinACon, spinBCon, spinCCon, gameStartCon, jackpotCon, pairWinCon;

	// Instantiate Datapath
	smDataPath datapath(clk, reset, coin_in, clearGameCon, spinACon, spinBCon, spinCCon, gameStartCon, jackpotCon, pairWinCon, setSeed, hexA, hexB, hexC);

	// Instantiate Control Path
	smControlPath control(clk, reset, gameStartCon, jackpotCon, pairWinCon, spinACon, spinBCon, spinCCon, clearGameCon, systemState);
	
	assign jackpot = jackpotCon;
	assign pairWin = pairWinCon;

endmodule
