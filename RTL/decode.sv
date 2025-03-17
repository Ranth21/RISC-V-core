`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/16/2025 02:53:12 PM
// Design Name: 
// Module Name: decode
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


module decode(
    input  logic [31:0] instruction,
    output logic [6:0]  opcode,
    output logic [4:0]  rd,
    output logic [2:0]  funct3,
    output logic [4:0]  rs1,
    output logic [4:0]  rs2,
    output logic [6:0]  funct7,
    // Immediate outputs for different instruction formats:
    output logic [31:0] imm_I,  // I-type: [31:20]
    output logic [31:0] imm_S,  // S-type: {instruction[31:25], instruction[11:7]}
    output logic [31:0] imm_B,  // B-type: {instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0}
    output logic [31:0] imm_U,  // U-type: {instruction[31:12], 12'b0}
    output logic [31:0] imm_J   // J-type: {instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0}
);

    // Common fields for all instruction types:
    assign opcode = instruction[6:0];
    assign rd     = instruction[11:7];
    assign funct3 = instruction[14:12];
    assign rs1    = instruction[19:15];
    assign rs2    = instruction[24:20];
    assign funct7 = instruction[31:25];

    // Immediate generation:
    // I-type immediate: sign extend bits [31:20]
    assign imm_I = {{20{instruction[31]}}, instruction[31:20]};
    
    // S-type immediate: bits [31:25] concatenated with bits [11:7]
    assign imm_S = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
    
    // B-type immediate: {imm[12], imm[10:5], imm[4:1], imm[11], 0}
    assign imm_B = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};
    
    // U-type immediate: upper 20 bits of instruction, lower 12 bits are 0
    assign imm_U = {instruction[31:12], 12'b0};
    
    // J-type immediate: {imm[20], imm[10:1], imm[11], imm[19:12], 0}
    assign imm_J = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0};

endmodule