`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/16/2025 03:36:35 PM
// Design Name: 
// Module Name: tb_top_level
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_core;
   // Clock and reset
   logic clk;
   logic reset;
   
   // Instantiate the top-level core module
   core dut(
      .clk(clk),
      .reset(reset)
   );
   
   // Clock generation: 10 ns period (5 ns high, 5 ns low)
   initial begin
      clk = 0;
      forever #5 clk = ~clk;
   end
   
   // Preload program instructions and data memory, then check results
   initial begin
      // Assert reset
      reset = 1;
      #20;
      reset = 0;
      
      // Preload Instruction Memory (using hierarchical reference to fetch module's memory)
      // Test Case 1: I-type ADDI (two tests)
      dut.fetch_inst.imem_inst.mem[0]  = 32'h00A00093; // ADDI x1, x0, 10  -> x1 = 10
      dut.fetch_inst.imem_inst.mem[1]  = 32'h01400113; // ADDI x2, x0, 20  -> x2 = 20
      
      // Test Case 2: R-type ADD (two tests)
      dut.fetch_inst.imem_inst.mem[2]  = 32'h002081B3; // ADD x3, x1, x2   -> x3 = 10+20 = 30
      dut.fetch_inst.imem_inst.mem[3]  = 32'h00110133; // ADD x4, x1, x1   -> x4 = 10+10 = 20
      
      // Test Case 3: R-type SUB (two tests)
      dut.fetch_inst.imem_inst.mem[4]  = 32'h40A10133; // SUB x5, x2, x1   -> x5 = 20-10 = 10
      dut.fetch_inst.imem_inst.mem[5]  = 32'h40A10233; // SUB x6, x2, x2   -> x6 = 20-20 = 0
      
      // Test Case 4: R-type MUL (two tests; using funct7=0000001 for MUL)
      dut.fetch_inst.imem_inst.mem[6]  = 32'h202081B3; // MUL x7, x1, x2   -> x7 = 10*20 = 200
      dut.fetch_inst.imem_inst.mem[7]  = 32'h201101B3; // MUL x8, x1, x1   -> x8 = 10*10 = 100
      
      // Test Case 5: SW and LW (two tests)
      dut.fetch_inst.imem_inst.mem[8]  = 32'h00312023; // SW x3, 0(x0)    -> store x3 (30) at memory[0]
      dut.fetch_inst.imem_inst.mem[9]  = 32'h00000483; // LW x9, 0(x0)    -> load memory[0] into x9 (should be 30)
      dut.fetch_inst.imem_inst.mem[10] = 32'h00412123; // SW x4, 4(x0)    -> store x4 (20) at memory[1] (addr=4)
      dut.fetch_inst.imem_inst.mem[11] = 32'h00400503; // LW x10, 4(x0)   -> load memory[1] into x10 (should be 20)
      
      // Test Case 6: BEQ (two tests)
      // Test 6a: Branch taken (BEQ x1, x1, offset=8) -> should branch over next two instructions
      dut.fetch_inst.imem_inst.mem[12] = 32'h00810063; // BEQ x1, x1, 8
      dut.fetch_inst.imem_inst.mem[13] = 32'h06300093; // ADDI x11, x0, 99 (should be skipped)
      dut.fetch_inst.imem_inst.mem[14] = 32'h00B00093; // ADDI x11, x0, 11 (should be skipped)
      dut.fetch_inst.imem_inst.mem[15] = 32'h06F00093; // ADDI x11, x0, 111 (branch target -> x11 = 111)
      // Test 6b: Branch not taken (BEQ x1, x2, offset=8) -> next instruction executes
      dut.fetch_inst.imem_inst.mem[16] = 32'h00810163; // BEQ x1, x2, 8 (not taken, as x1 != x2)
      dut.fetch_inst.imem_inst.mem[17] = 32'h0DE00093; // ADDI x12, x0, 222 -> x12 = 222
      
      // Test Case 7: JAL (two tests)
      dut.fetch_inst.imem_inst.mem[18] = 32'h01000B6F; // JAL x13, 16 -> x13 gets PC+4 from here
      dut.fetch_inst.imem_inst.mem[19] = 32'h02000B6F; // JAL x13, 32 -> second test for JAL
      
      // Test Case 8: JALR (two tests)
      dut.fetch_inst.imem_inst.mem[20] = 32'h00406267; // JALR x14, 4(x1) -> x14 = x1+4; target from x1
      dut.fetch_inst.imem_inst.mem[21] = 32'h00806267; // JALR x14, 8(x1) -> second test for JALR
      
      // Test Case 9: LUI (two tests)
      dut.fetch_inst.imem_inst.mem[22] = 32'h123450B7; // LUI x15, 0x12345 -> x15 = 0x12345000
      dut.fetch_inst.imem_inst.mem[23] = 32'h678900B7; // LUI x15, 0x67890 -> x15 = 0x67890000
      
      // Test Case 10: Illegal instruction test
      dut.fetch_inst.imem_inst.mem[24] = 32'hFFFFFFFF; // Illegal opcode
      
      // Fill remaining instruction memory with NOP (ADDI x0,x0,0)
      for (int i = 25; i < 256; i++) begin
         dut.fetch_inst.imem_inst.mem[i] = 32'h00000013;
      end
      
      // Preload Data Memory with zeros for deterministic behavior
      for (int i = 0; i < 256; i++) begin
         dut.data_mem_inst.mem[i] = 32'h00000000;
      end
      
      // Run simulation for enough time for the program to execute
      #2000;
      
      // Display final Register File contents (hierarchical access)
      $display("Final Register File Contents:");
      for (int i = 0; i < 32; i++) begin
         $display("x%0d = %h", i, dut.regfile_inst.reg_s[i]);
      end
      
      // Display selected Data Memory locations to verify SW/LW operations
      $display("Data Memory[0] = %h", dut.data_mem_inst.mem[0]); // Should hold 30 (from x3)
      $display("Data Memory[1] = %h", dut.data_mem_inst.mem[1]); // Should hold 20 (from x4)
      
      $finish;
   end

endmodule


