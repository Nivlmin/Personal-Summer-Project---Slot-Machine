module slotMachine_tb();

    reg clk, reset, coin_in;
    reg [7:0] test_seed;

    wire jackpot, pairWin;
    wire [1:0] systemState;
    wire [6:0] hexA, hexB, hexC;
	 
	 // Test Slot Machine
    slotMachine uut(clk, reset, coin_in, test_seed, jackpot, pairWin, systemState, hexA, hexB, hexC);

    // Clock Generator Loop
    always begin
        #5 clk = ~clk;
    end

    initial begin
        // For EDA Playground to draw graphical Timing Diagram waves
        $dumpfile("dump.vcd");
        $dumpvars(0, slotMachine_tb);

        // Initial State & Reset
        clk = 0;
        reset = 0;      // Put system into Reset
        coin_in = 0;
        test_seed = 8'h00;
        #20;            
        
        // Spin Test 1: Seed '8'hA5'
        test_seed = 8'hA5; // Set first random starting seed
        reset = 0;         // Keep reset low momentarily to latch it
        #10;
        reset = 1;         // System goes to IDLE state
        #20;

        // Insert Coin for Spin 1
        coin_in = 1;    
        #10;            
        coin_in = 0;    
        
        #1100; // Wait for Spin 1 sequence to finish completely

        // Spin Test 2: Seed '8'h2D' 
        #50;               // Let the system rest briefly in IDLE
        test_seed = 8'h2D; 
        reset = 0;        
        #20;
        reset = 1;       
        #20;

        // Insert Coin for Spin 2
        coin_in = 1;    
        #10;            
        coin_in = 0;    
        
        #1200; 

        $finish;
    end

endmodule
