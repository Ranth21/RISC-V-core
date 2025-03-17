`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/16/2025 10:38:58 AM
// Design Name: 
// Module Name: tb_pc
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

module tb_pc;
  // Signal declarations
  logic        clk, reset;
  logic [31:0] next_pc;
  logic        pc_en;
  logic [31:0] pc;
    
  // Instantiate the program counter module
  PC uut(
    .clk(clk),
    .reset(reset),
    .next_pc(next_pc),  // Changed from 'nxt_pc' to 'next_pc'
    .pc_en(pc_en),
    .pc(pc)
  );
  
  // Clock generation in its own initial block
  initial begin
      clk = 0;
      forever #5 clk = ~clk;
  end
  
  // Test sequence
  initial begin
      // Initialize all signals
      reset    = 0;
      pc_en    = 0;
      next_pc  = 0;
      
      #10;
      reset = 1;
      
      #15;
      reset = 0;
      next_pc = 32'hDEADCAFE;  // Use a valid hexadecimal constant
      
      #30;
      pc_en = 1;
      
      #10;
      reset = 1;
      
      #20;
      $finish;
  end
  
endmodule
