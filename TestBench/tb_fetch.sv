`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/16/2025 01:55:19 PM
// Design Name: 
// Module Name: tb_fetch
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

module tb_fetch;
    // Parameters as used in the fetch module
    localparam DEPTH = 256;
    localparam addr_width = $clog2(DEPTH);

    // Testbench signals
    logic         clk;
    logic         reset;
    logic [31:0]  pc;
    // Note: ft_ins is expected to be an output; if it is declared as input in your fetch module,
    // change its direction in the fetch module.
    logic [31:0] ft_ins;
    
    // Instantiate the fetch module
    fetch uut (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .ft_ins(ft_ins)
    );
    
    // Clock generation: 10 ns period (5 ns high, 5 ns low)
    initial begin
        clk = 1;
        forever #5 clk = ~clk;
    end
    
    // Preload the instruction memory inside the fetch module with a known pattern.
    // Here we write the index value into each memory location.
    initial begin
        integer i;
        for (i = 0; i < DEPTH; i = i + 1) begin
            uut.imem_inst.mem[i] = i;
        end
    end
    
    // Test sequence for various corner cases
    initial begin
        // Initialize signals
        reset = 1;
        pc = 32'd0;
        #10;
        reset = 0;
        
        // Test 1: PC = 0; expected memory index = 0 (0 >> 2 = 0)
        pc = 32'd0;
        #10;
        $display("Test 1: PC = %0d, Expected instr = %0d, Got = %0d", pc, 0, ft_ins);
        
        // Test 2: PC = 4; expected memory index = 1 (4 >> 2 = 1)
        pc = 32'd4;
        #10;
        $display("Test 2: PC = %0d, Expected instr = %0d, Got = %0d", pc, 1, ft_ins);
        
        // Test 3: PC = 8; expected memory index = 2
        pc = 32'd8;
        #10;
        $display("Test 3: PC = %0d, Expected instr = %0d, Got = %0d", pc, 2, ft_ins);
        
        // Test 4: PC = 12; expected memory index = 3
        pc = 32'd12;
        #10;
        $display("Test 4: PC = %0d, Expected instr = %0d, Got = %0d", pc, 3, ft_ins);
        
        // Test 5: PC = 1020; expected memory index = 255 (since 1020 >> 2 = 255)
        pc = 32'd1020;
        #10;
        $display("Test 5: PC = %0d, Expected instr = %0d, Got = %0d", pc, 255, ft_ins);
        
        // Test 6: Non-word-aligned PC: PC = 2; expected memory index = 0 (2 >> 2 = 0)
        pc = 32'd2;
        #10;
        $display("Test 6: PC = %0d (non-aligned), Expected instr = %0d, Got = %0d", pc, 0, ft_ins);
        
        // Test 7: Random PC: PC = 44; expected memory index = 44 >> 2 = 11
        pc = 32'd44;
        #10;
        $display("Test 7: PC = %0d, Expected instr = %0d, Got = %0d", pc, 11, ft_ins);
        
        #20;
        $finish;
    end

endmodule
