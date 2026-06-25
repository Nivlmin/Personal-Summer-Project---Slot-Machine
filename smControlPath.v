module smControlPath(clk, reset, gameStart, jackpot, pairWin, spinA, spinB, spinC, clearGame, stateOut);

	input wire clk, reset, gameStart, jackpot, pairWin;
	output reg spinA, spinB, spinC, clearGame;
	output reg [1:0] stateOut;

	// States
	parameter IDLE = 2'b00; // Waiting for coin/gameStart
	parameter SPINNING = 2'b01;
	parameter SCORING = 2'b10; // Freeze Reels and evaluate
	
	reg [1:0] currentState, nextState;
	
	// Timer to let reels roll for a brief duration after spin
	reg [7:0] timer;
	
	// State Register + Timer
	always @(posedge clk or negedge reset)
	begin
		if (reset == 1'b0)
		begin
			currentState <= IDLE;
			timer <= 0;
		end
		else
		begin
			currentState <= nextState;
			if (currentState == SPINNING)
				timer <= timer + 1;
			else
				timer <= 0;
		end
	end

	// Next State Logic
	always @(*)
	begin
		case (currentState)
			IDLE:
			begin
				if (gameStart == 1'b1) nextState = SPINNING;
				else nextState = IDLE;
			end
			
			SPINNING:
			begin
				if (timer == 8'd100) nextState = SCORING;
				else nextState = SPINNING;
			end
			
			SCORING:
			begin
				if (gameStart == 1'b0) nextState = IDLE;
				else nextState = SCORING;
			end
			
			default: nextState = IDLE;
			
		endcase
	end
	
	// Output Logic
	always @(*)
	begin
		spinA = 1'b0;
		spinB = 1'b0;
		spinC = 1'b0;
		clearGame = 1'b0;
		stateOut = currentState;
		
		case (currentState)
			IDLE: 
			begin
			// Nothing besides waiting for coin
			end
			
			SPINNING:
			begin
				// Spin all 3 reel registers
				spinA = 1'b1;
				spinB = 1'b1;
				spinC = 1'b1;
			end
			
			SCORING:
			begin
				// Turn on clearGame so gameStart goes back to 0
				clearGame = 1'b1;
			end
		endcase
	end
	
endmodule
