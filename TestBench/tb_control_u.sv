`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/16/2025 03:27:44 PM
// Design Name: 
// Module Name: tb_control_u
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

module tb_control_unit;
    // Declare inputs to the control unit
    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;
    
    // Declare outputs from the control unit
    logic [3:0] alu_op;
    logic       alu_src;
    logic       rf_we;
    logic       mem_re;
    logic       mem_we;
    logic [1:0] pc_src;
    logic [2:0] imm_sel;
    
    // Instantiate the control unit
    control_unit uut (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .alu_op(alu_op),
        .alu_src(alu_src),
        .rf_we(rf_we),
        .mem_re(mem_re),
        .mem_we(mem_we),
        .pc_src(pc_src),
        .imm_sel(imm_sel)
    );
    
    initial begin
        // Test 1: R-type ADD
        // opcode = 0110011, funct3 = 000, funct7 = 0000000
        opcode  = 7'b0110011;
        funct3  = 3'b000;
        funct7  = 7'b0000000;
        #10;
        $display("Test 1: R-type ADD");
        $display("  alu_op = %b, alu_src = %b, rf_we = %b, pc_src = %b, imm_sel = %b", 
                 alu_op, alu_src, rf_we, pc_src, imm_sel);
        
        // Test 2: R-type SUB
        // opcode = 0110011, funct3 = 000, funct7 = 0100000
        opcode  = 7'b0110011;
        funct3  = 3'b000;
        funct7  = 7'b0100000;
        #10;
        $display("Test 2: R-type SUB");
        $display("  alu_op = %b, alu_src = %b, rf_we = %b, pc_src = %b, imm_sel = %b", 
                 alu_op, alu_src, rf_we, pc_src, imm_sel);
        
        // Test 3: I-type ADDI
        // opcode = 0010011, funct3 = 000 (funct7 not used)
        opcode  = 7'b0010011;
        funct3  = 3'b000;
        funct7  = 7'bxxxxxxx;
        #10;
        $display("Test 3: I-type ADDI");
        $display("  alu_op = %b, alu_src = %b, rf_we = %b, pc_src = %b, imm_sel = %b", 
                 alu_op, alu_src, rf_we, pc_src, imm_sel);
        
        // Test 4: Load Word (LW)
        // opcode = 0000011, funct3 = 010
        opcode  = 7'b0000011;
        funct3  = 3'b010;
        funct7  = 7'bxxxxxxx;
        #10;
        $display("Test 4: LW");
        $display("  alu_op = %b, alu_src = %b, rf_we = %b, mem_re = %b, pc_src = %b, imm_sel = %b", 
                 alu_op, alu_src, rf_we, mem_re, pc_src, imm_sel);
        
        // Test 5: Store Word (SW)
        // opcode = 0100011, funct3 = 010
        opcode  = 7'b0100011;
        funct3  = 3'b010;
        funct7  = 7'bxxxxxxx;
        #10;
        $display("Test 5: SW");
        $display("  alu_op = %b, alu_src = %b, rf_we = %b, mem_we = %b, pc_src = %b, imm_sel = %b", 
                 alu_op, alu_src, rf_we, mem_we, pc_src, imm_sel);
        
        // Test 6: Branch BEQ
        // opcode = 1100011, funct3 = 000
        opcode  = 7'b1100011;
        funct3  = 3'b000;
        funct7  = 7'bxxxxxxx;
        #10;
        $display("Test 6: BEQ");
        $display("  alu_op = %b, alu_src = %b, rf_we = %b, pc_src = %b, imm_sel = %b", 
                 alu_op, alu_src, rf_we, pc_src, imm_sel);
        
        // Test 7: JAL
        // opcode = 1101111
        opcode  = 7'b1101111;
        funct3  = 3'bxxx;
        funct7  = 7'bxxxxxxx;
        #10;
        $display("Test 7: JAL");
        $display("  rf_we = %b, pc_src = %b, imm_sel = %b", 
                 rf_we, pc_src, imm_sel);
        
        // Test 8: JALR
        // opcode = 1100111, funct3 = 000
        opcode  = 7'b1100111;
        funct3  = 3'b000;
        funct7  = 7'bxxxxxxx;
        #10;
        $display("Test 8: JALR");
        $display("  alu_op = %b, alu_src = %b, rf_we = %b, pc_src = %b, imm_sel = %b", 
                 alu_op, alu_src, rf_we, pc_src, imm_sel);
        
        // Test 9: LUI
        // opcode = 0110111
        opcode  = 7'b0110111;
        funct3  = 3'bxxx;
        funct7  = 7'bxxxxxxx;
        #10;
        $display("Test 9: LUI");
        $display("  rf_we = %b, imm_sel = %b", rf_we, imm_sel);
        
        #20;
        $finish;
    end
endmodule
