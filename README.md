# Personal-Summer-Project---Slot-Machine

Open sourced Slot Machine that I personally designed through thorough research and after taking a class in Digital Logic.

This project is a 2 month personal engineering project focusing on utilzing the skills I learned in Digital Logic, background + passion about CPUs and Computer Engineering, and a self-learning journey through designing and verifcations of a CPU.

## The 2 Month Engineering Lifecycle
* Week 1 & 2 - Research & Core Architecture: Learned about the functionability and architecture of a CPU + getting a Quartus license to write in Verilog.

* Week 3 & 4 - Drawing the Datapath and creating a Finite State Machine (FSM)
[Summer Personal Project - Slot Machine CPU.pdf](https://github.com/user-attachments/files/29329295/Summer.Personal.Project.-.Slot.Machine.CPU.pdf)

* Week 5 & 6 - Coding the CPU in Verilog: My teacher previously had generic building blocks that we can instantiate from, so being used to that I made my own generic building blocks and instantiated them and learned to build multiple modules and work up (Datapath and Control -> Slot Machine)

* Week 7 & 8 - Debugging, Verification through a testbench, and GitHub: Addressed critical bugs with the slow machine, had to learn how to create a testbench and how to verify it with EDA playground, then creating a GitHub to talk about my project.

## Engineering Challenges Encountered & Solutions
### 1. The Display Vulnerability 
Problem: The random number engine (LFSR) were 8-bits, while the displays (HexToSevenSeg) were 4-bits. This means that we have numbers going up to 255 fitting into a maximum number of 15 which is not possible. An analogy for this is fitting the Sun into the Earth (not possible obv). I didn't want to change the amount of combinations I had since 255 is less predictable than 15. This also affected the ALU as it is also 8-bit and is used to calculate if the values match to declare it a jackpot, pair win, or loss.

Bug: 8-bit lines routed to 4-bit displays only showing the lower 4 bits. A scenario would be the user seeing 'A A A' and thinking they won but the ALU would mark it as a loss cause the top 4 bits would not be matching.

Solution (Bus Truncation): I solved this by implementing intentional bus truncation at the module interfaces. The core registers continue to run at full 8-bit complexity. However, right at the inputs of the `hexToSevenSeg` decoders and the `smALU` comparators, the buses are sliced down to the lower nibble `[3:0]`. This guarantees that what the player physically sees on the board is 100% identical to what the internal arithmetic logic calculates.

### 2. The LFSR Zero-Seed Trap
Problem: Upon system reset, hardware registers clear their internal memory states to `0` (`8'h00`). Because an LFSR operates on an XOR gate feedback loop, a starting seed of all zeros results in `0 ^ 0 = 0`, permanently trapping the random number generator in a frozen loop.

Solution (Seed Latch through a Mux): I designed a combinational bypass loop directly inside the top datapath:
  ```verilog
  always @(*) begin
      if (reelA_out == 8'h00) mux_lfsr = setSeed;
      else                    mux_lfsr = lfsr_bus;
  end
  ```
This block instantly catches the reset zero-state, cuts off the stuck feedback loop, and force-feeds a custom, variable 8-bit starting seed number directly from the testbench. On the very next clock edge, the registers update, the zero condition automatically becomes false, and the normal running random bus smoothly takes over the game.

## Simulation & Verification Results
The timing correctness of this complete processor layout was thoroughly verified on **EDA Playground** using the **Icarus Verilog** compiler and visualized using the **EPWave** diagram graph tool.

By writing a custom simulation testbench, I successfully executed a **dual-seed testing verification** by injecting two different hexadecimal values back-to-back across the simulation timeline:
* **Spin 1 (Seed `8'hA5`):** Wakes up the system cleanly, shuffles the cascaded registers independently, and safely halts on reel values `7 6 5` (A clear loss).
* **Spin 2 (Seed `8'h3C`):** Resets the system, loads the new seed, and successfully halts the independent reels on `4 8 4`, immediately capturing the match and forcing the **`pairWin`** flag to lock high at `1`.
<img width="2463" height="225" alt="slotMachine CPU Timing Diagram" src="https://github.com/user-attachments/assets/ea8d2eed-1348-4b4e-9aac-876a85afab15" />

## How to Set-up & Run
You can easily execute this complete project file in an open-source simulator:

1. Open a workspace on [EDA Playground](https://edaplayground.com).
2. Change the left sidebar language dropdown to **SystemVerilog/Verilog**.
3. Under **Tools & Simulators**, select **`Icarus Verilog 12.0`**.
4. Check the box labeled **`Open EPWave after run`** to generate the timing graphs.
5. Place the testbench code inside the `testbench.sv` tab and the hardware modules inside the `design.sv` tab.
6. Click the blue **Run** button at the top.
7. Go to **Generate Signals** on the top left and click on **slotMachine.tb** and append all of the signals.

## Engineering Skills learned
* **Hardware Design:** Learned how to write Verilog code, route digital wires, and organize hardware modules.
* **Processor Architecture:** Mastered how to split a chip into a "brain" (control path) and "muscles" (datapath).
* **Simulation and Debugging:** Built testbenches to generate clocks, simulated player inputs, and used timing waveforms to find and fix bugs.

## Closure + What's Next
Sticking with this project over the summer transformed abstract digital concepts into a deeply rewarding design experience. Overcoming these hardware limitations and debugging behavioral loops has solidified my foundational skills and provided the perfect springboard for my next major computer engineering milestone: designing a functional single-cycle **RISC-V CPU**.
