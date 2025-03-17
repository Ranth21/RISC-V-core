`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/14/2025 10:13:55 PM
// Design Name: 
// Module Name: ALU
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

module tb_ALU;
    // Testbench signals declared as logic
    logic [31:0] rs1;
    logic [31:0] rs2;
    logic [2:0]  op_ctrl;
    logic [31:0] alu_op;
    logic        b_zero;
    
    // Instantiate the ALU module
    ALU uut (
        .rs1(rs1),
        .rs2(rs2),
        .op_ctrl(op_ctrl),
        .alu_op(alu_op),
        .b_zero(b_zero)
    );
    
    initial begin
        // Test 1: Addition: 10 + 15 = 25
        rs1 = 32'd10;
        rs2 = 32'd15;
        op_ctrl = 3'b000; // 'add'
        #10;
        $display("Time: %0t, ADD: %d + %d = %d, Zero Flag: %b", $time, rs1, rs2, alu_op, b_zero);
        
        // Test 2: Subtraction: 20 - 8 = 12
        rs1 = 32'd20;
        rs2 = 32'd8;
        op_ctrl = 3'b001; // 'sub'
        #10;
        $display("Time: %0t, SUB: %d - %d = %d, Zero Flag: %b", $time, rs1, rs2, alu_op, b_zero);
        
        // Test 3: Multiplication: 7 * 6 = 42
        rs1 = 32'd7;
        rs2 = 32'd6;
        op_ctrl = 3'b011; // 'mul'
        #10;
        $display("Time: %0t, MUL: %d * %d = %d, Zero Flag: %b", $time, rs1, rs2, alu_op, b_zero);
        
        // Test 4: Division: 40 / 5 = 8
        rs1 = 32'd40;
        rs2 = 32'd5;
        op_ctrl = 3'b010; // 'div'
        #10;
        $display("Time: %0t, DIV: %d / %d = %d, Zero Flag: %b", $time, rs1, rs2, alu_op, b_zero);
        
        // Test 5: Division by Zero: 100 / 0 should yield 32'hFFFFFFFF
        rs1 = 32'd100;
        rs2 = 32'd0;
        op_ctrl = 3'b010; // 'div'
        #10;
        $display("Time: %0t, DIV by Zero: %d / %d = 0x%h, Zero Flag: %b", $time, rs1, rs2, alu_op, b_zero);
        
        // Test 6: Subtraction yielding Zero: 50 - 50 = 0 (b_zero should be 1)
        rs1 = 32'd50;
        rs2 = 32'd50;
        op_ctrl = 3'b001; // 'sub'
        #10;
        $display("Time: %0t, SUB (Zero): %d - %d = %d, Zero Flag: %b", $time, rs1, rs2, alu_op, b_zero);
        
        #10;
        $finish;
    end

endmodule
