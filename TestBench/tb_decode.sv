`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/16/2025 03:07:10 PM
// Design Name: 
// Module Name: tb_decode
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


module tb_decode;
    // Testbench signals for decoded outputs
    logic [31:0] instruction;
    logic [6:0]  opcode;
    logic [4:0]  rd;
    logic [2:0]  funct3;
    logic [4:0]  rs1;
    logic [4:0]  rs2;
    logic [6:0]  funct7;
    logic [31:0] imm_I;
    logic [31:0] imm_S;
    logic [31:0] imm_B;
    logic [31:0] imm_U;
    logic [31:0] imm_J;
    
    // Instantiate the decode module
    decode uut (
        .instruction(instruction),
        .opcode(opcode),
        .rd(rd),
        .funct3(funct3),
        .rs1(rs1),
        .rs2(rs2),
        .funct7(funct7),
        .imm_I(imm_I),
        .imm_S(imm_S),
        .imm_B(imm_B),
        .imm_U(imm_U),
        .imm_J(imm_J)
    );
    
    // Test sequence:
    initial begin
        // Test 1: R-type Instruction: e.g., ADD x1, x2, x3
        // Format: {funct7, rs2, rs1, funct3, rd, opcode}
        // For ADD: funct7 = 7'b0000000, rs2 = 5'd3, rs1 = 5'd2, funct3 = 3'b000, rd = 5'd1, opcode = 7'b0110011
        instruction = {7'b0000000, 5'd3, 5'd2, 3'b000, 5'd1, 7'b0110011};
        #10;
        $display("Test 1: R-type ADD");
        $display("  instruction = %h", instruction);
        $display("  opcode = %b, rd = %d, funct3 = %b, rs1 = %d, rs2 = %d, funct7 = %b", opcode, rd, funct3, rs1, rs2, funct7);
        $display("  (I-type imm: %h)", imm_I);
        
        // Test 2: I-type Instruction: e.g., ADDI x1, x2, 100
        // Format: {imm[11:0], rs1, funct3, rd, opcode}
        // Let immediate = 100 (decimal) = 12'b000001100100, rs1 = 5'd2, funct3 = 3'b000, rd = 5'd1, opcode = 7'b0010011
        instruction = {12'b000001100100, 5'd2, 3'b000, 5'd1, 7'b0010011};
        #10;
        $display("Test 2: I-type ADDI");
        $display("  instruction = %h", instruction);
        $display("  opcode = %b, rd = %d, funct3 = %b, rs1 = %d, imm_I = %h", opcode, rd, funct3, rs1, imm_I);
        
        // Test 3: S-type Instruction: e.g., SW x3, 8(x2)
        // Format: {imm[11:5], rs2, rs1, funct3, imm[4:0], opcode}
        // For SW: opcode = 7'b0100011, funct3 = 3'b010.
        // Let immediate = 8 (decimal) = 12'b000000001000.
        // Split: imm[11:5] = 7'b0000000, imm[4:0] = 5'b01000, rs2 = 5'd3, rs1 = 5'd2.
        instruction = {7'b0000000, 5'd3, 5'd2, 3'b010, 5'b01000, 7'b0100011};
        #10;
        $display("Test 3: S-type SW");
        $display("  instruction = %h", instruction);
        $display("  imm_S = %h, rs1 = %d, rs2 = %d", imm_S, rs1, rs2);
        
        // Test 4: B-type Instruction: e.g., BEQ x1, x2, offset=16
        // Format: {imm[12], imm[10:5], rs2, rs1, funct3, imm[4:1], imm[11], opcode}
        // For BEQ: opcode = 7'b1100011, funct3 = 3'b000.
        // We'll encode offset = 16. For a B-type immediate, the immediate is in bits [12|10:5|4:1|11] with LSB=0.
        // For simplicity, use a known encoding: let the immediate field (after shifting) be 16.
        // One possible encoding: imm[12] = 0, imm[10:5] = 6'b000010, imm[4:1] = 4'b0001, imm[11] = 0.
        // Then instruction = {1'b0, 6'b000010, rs2= 5'd? , rs1=5'd?, funct3=3'b000, {4'b0001, 1'b0}, opcode}.
        // Here, choose rs1 = 5'd1, rs2 = 5'd2.
        instruction = {1'b0, 6'b000010, 5'd2, 5'd1, 3'b000, 5'b00010, 7'b1100011};
        #10;
        $display("Test 4: B-type BEQ (dummy encoding for offset)");
        $display("  instruction = %h", instruction);
        $display("  imm_B = %h", imm_B);
        
        // Test 5: U-type Instruction: e.g., LUI x1, 0x12345
        // Format: {imm[31:12], rd, opcode} with opcode = 7'b0110111 for LUI.
        // Let immediate (upper 20 bits) = 0x12345, rd = 5'd1.
        instruction = {20'h12345, 5'd1, 7'b0110111};
        #10;
        $display("Test 5: U-type LUI");
        $display("  instruction = %h", instruction);
        $display("  imm_U = %h, rd = %d", imm_U, rd);
        
        // Test 6: J-type Instruction: e.g., JAL x1, offset
        // Format: {imm[20], imm[10:1], imm[11], imm[19:12], rd, opcode}
        // For JAL: opcode = 7'b1101111.
        // Use a dummy encoding for an offset, e.g., let the immediate field be a small value.
        instruction = {1'b0, 10'd5, 1'b0, 8'd10, 5'd1, 7'b1101111};
        #10;
        $display("Test 6: J-type JAL");
        $display("  instruction = %h", instruction);
        $display("  imm_J = %h, rd = %d", imm_J, rd);
        
        #20;
        $finish;
    end

endmodule
