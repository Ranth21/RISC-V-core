`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/16/2025 03:24:33 PM
// Design Name: 
// Module Name: control_u
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
module control_unit(
    input  logic [6:0] opcode,
    input  logic [2:0] funct3,
    input  logic [6:0] funct7,
    output logic [3:0] alu_op,  // 4-bit ALU control
    output logic       alu_src, // 0: register, 1: immediate
    output logic       rf_we,   // Register file write enable
    output logic       mem_re,  // Memory read enable
    output logic       mem_we,  // Memory write enable
    output logic [1:0] pc_src,  // PC source: 00=PC+4, 01=branch, 10=jump
    output logic [2:0] imm_sel  // Immediate selection: 000=I, 001=S, 010=B, 011=U, 100=J
);

    // Default assignments for control signals
    always_comb begin
        alu_op  = 4'b0000;
        alu_src = 0;
        rf_we   = 0;
        mem_re  = 0;
        mem_we  = 0;
        pc_src  = 2'b00;
        imm_sel = 3'b000;
        
        case (opcode)
            // R-type instructions (e.g., ADD, SUB, MUL)
            7'b0110011: begin
                alu_src = 0;   // Second operand from register
                rf_we   = 1;   // Write result to register file
                imm_sel = 3'bxxx; // Not used for R-type
                
                // Use funct3 and funct7 to determine ALU operation
                if (funct3 == 3'b000) begin
                    if (funct7 == 7'b0000000)
                        alu_op = 4'b0000; // ADD
                    else if (funct7 == 7'b0100000)
                        alu_op = 4'b0001; // SUB
                    else if (funct7 == 7'b0000001)
                        alu_op = 4'b0010; // MUL (example encoding)
                    else
                        alu_op = 4'b0000;
                end
                // Additional R-type instructions can be added here
            end

            // I-type arithmetic (e.g., ADDI)
            7'b0010011: begin
                alu_src = 1;   // Use immediate
                rf_we   = 1;
                alu_op  = 4'b0000; // ADD operation for ADDI
                imm_sel = 3'b000;  // I-type immediate
            end

            // Load Word (LW) - I-type
            7'b0000011: begin
                alu_src = 1;   // Immediate for effective address
                rf_we   = 1;   // Write loaded data to register
                mem_re  = 1;   // Enable memory read
                alu_op  = 4'b0000; // ADD for effective address
                imm_sel = 3'b000;  // I-type immediate
            end

            // Store Word (SW) - S-type
            7'b0100011: begin
                alu_src = 1;   // Immediate for effective address
                rf_we   = 0;   // No register write
                mem_we  = 1;   // Enable memory write
                alu_op  = 4'b0000; // ADD for effective address
                imm_sel = 3'b001;  // S-type immediate
            end

            // Branch instructions (e.g., BEQ) - B-type
            7'b1100011: begin
                alu_src = 0;   // Compare two registers
                rf_we   = 0;
                alu_op  = 4'b0001; // SUB to compare registers
                pc_src  = 2'b01;   // Use branch target if condition met
                imm_sel = 3'b010;  // B-type immediate
            end

            // Jump and Link (JAL) - J-type
            7'b1101111: begin
                rf_we   = 1;   // Write PC+4 to destination register
                pc_src  = 2'b10; // Jump target
                imm_sel = 3'b100; // J-type immediate
                // alu_src and alu_op are don't care for JAL
            end

            // Jump and Link Register (JALR) - I-type
            7'b1100111: begin
                alu_src = 1;   // Use immediate for effective address calculation
                rf_we   = 1;
                alu_op  = 4'b0000; // ADD for calculating jump address
                pc_src  = 2'b10;
                imm_sel = 3'b000;  // I-type immediate
            end

            // LUI - U-type
            7'b0110111: begin
                rf_we   = 1;
                pc_src  = 2'b00;
                imm_sel = 3'b011;  // U-type immediate
                // alu_src and alu_op are not used
            end

            default: begin
                // For unsupported opcodes, leave control signals at default (NOP)
                alu_op  = 4'b0000;
                alu_src = 0;
                rf_we   = 0;
                mem_re  = 0;
                mem_we  = 0;
                pc_src  = 2'b00;
                imm_sel = 3'b000;
            end
        endcase
    end

endmodule
