module smLFSR (inputSeed, outputRand);

	input wire [7:0] inputSeed;
	output wire [7:0] outputRand;
	
	// Seed Generation (Xor gate)
	assign outputRand[0] = inputSeed[7] ^ inputSeed[5] ^ inputSeed[4] ^ inputSeed[3];
	// Old bit 0 becomes new position 1
	assign outputRand[1] = inputSeed[0];
	// Old bit 1 moves to new position 2
	assign outputRand[2] = inputSeed[1];
	// Old bit 2 moves to new position 3
	assign outputRand[3] = inputSeed[2];
	// Old bit 3 moves to new position 4
	assign outputRand[4] = inputSeed[3];
	// Old bit 4 moves to new position 5
	assign outputRand[5] = inputSeed[4];
	// Old bit 5 moves to new position 6
	assign outputRand[6] = inputSeed[5];
	// Old bit 6 moves to new position 7
	assign outputRand[7] = inputSeed[6];
	
endmodule