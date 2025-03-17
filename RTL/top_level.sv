`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/16/2025 03:35:54 PM
// Design Name: 
// Module Name: top_level
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



module core(
    input  logic clk,
    input  logic reset
);

    // -------------------------------------------------------------------------
    // Program Counter
    // -------------------------------------------------------------------------
    logic [31:0] pc;
    logic [31:0] next_pc;
    logic        pc_en;
    
    PC pc_inst (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc_en(pc_en),
        .pc(pc)
    );

    // -------------------------------------------------------------------------
    // Instruction Fetch
    // -------------------------------------------------------------------------
    logic [31:0] instruction; // Fetched instruction
    
    fetch fetch_inst (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .ft_ins(instruction)
    );

    // -------------------------------------------------------------------------
    // Instruction Decode
    // -------------------------------------------------------------------------
    logic [6:0]  opcode;
    logic [4:0]  rd, rs1, rs2;
    logic [2:0]  funct3;
    logic [6:0]  funct7;
    logic [31:0] imm_I, imm_S, imm_B, imm_U, imm_J;
    
    decode decode_inst (
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

    // -------------------------------------------------------------------------
    // Control Unit
    // -------------------------------------------------------------------------
    logic [3:0] ctrl_alu_op;  // 4-bit ALU control signal from control unit
    logic       ctrl_alu_src; // 0: use register, 1: use immediate
    logic       ctrl_rf_we;   // Register file write enable
    logic       ctrl_mem_re;  // Memory read enable
    logic       ctrl_mem_we;  // Memory write enable
    logic [1:0] ctrl_pc_src;  // PC source selection: 00 = PC+4, 01 = branch, 10 = jump
    logic [2:0] ctrl_imm_sel; // Immediate selection: 000 = I-type, 001 = S-type, 010 = B-type, 011 = U-type, 100 = J-type
    
    control_unit ctrl_inst (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .alu_op(ctrl_alu_op),
        .alu_src(ctrl_alu_src),
        .rf_we(ctrl_rf_we),
        .mem_re(ctrl_mem_re),
        .mem_we(ctrl_mem_we),
        .pc_src(ctrl_pc_src),
        .imm_sel(ctrl_imm_sel)
    );

    // -------------------------------------------------------------------------
    // Register File
    // -------------------------------------------------------------------------
    logic [31:0] reg_rdata1, reg_rdata2;
    logic [31:0] reg_write_data;
    
    reg_file regfile_inst (
        .clk(clk),
        .reset(reset),
        .wr_en(ctrl_rf_we),
        .wr_addr(rd),
        .wr_data(reg_write_data),
        .rd_addr1(rs1),
        .rd_addr2(rs2),
        .rd_data1(reg_rdata1),
        .rd_data2(reg_rdata2)
    );

    // -------------------------------------------------------------------------
    // ALU Input Mux (select immediate or register)
    // -------------------------------------------------------------------------
    logic [31:0] alu_in2;
    always_comb begin
        if (ctrl_alu_src) begin
            case (ctrl_imm_sel)
                3'b000: alu_in2 = imm_I; // I-type
                3'b001: alu_in2 = imm_S; // S-type
                3'b010: alu_in2 = imm_B; // B-type
                3'b011: alu_in2 = imm_U; // U-type
                3'b100: alu_in2 = imm_J; // J-type
                default: alu_in2 = imm_I;
            endcase
        end else begin
            alu_in2 = reg_rdata2;
        end
    end

    // -------------------------------------------------------------------------
    // ALU
    // -------------------------------------------------------------------------
    // ALU expects a 3-bit control signal; use lower 3 bits of ctrl_alu_op.
    wire [2:0] alu_ctrl = ctrl_alu_op[2:0];
    logic [31:0] alu_result;
    logic alu_zero;
    
    ALU alu_inst (
        .rs1(reg_rdata1),
        .rs2(alu_in2),
        .op_ctrl(alu_ctrl),
        .alu_op(alu_result),
        .b_zero(alu_zero)
    );

    // -------------------------------------------------------------------------
    // Data Memory (for load/store)
    // -------------------------------------------------------------------------
    logic [31:0] data_mem_rdata;
    
    // Use lower 8 bits of ALU result as the address for data memory
    mem data_mem_inst (
        .clk(clk),
        .wr_en(ctrl_mem_we),
        .addr_pt(alu_result[7:0]),
        .wr_data(reg_rdata2),
        .rd_data(data_mem_rdata)
    );

    // -------------------------------------------------------------------------
    // Write-back Mux for Register File
    // -------------------------------------------------------------------------
    // If memory read is enabled (i.e. LW), use data memory output;
    // otherwise, use the ALU result.
    assign reg_write_data = (ctrl_mem_re) ? data_mem_rdata : alu_result;

    // -------------------------------------------------------------------------
    // PC Update Logic
    // -------------------------------------------------------------------------
    logic [31:0] pc_plus4;
    assign pc_plus4 = pc + 32'd4;
    
    always_comb begin
        case (ctrl_pc_src)
            2'b00: next_pc = pc_plus4;         // Normal sequential execution
            2'b01: next_pc = pc + imm_B;         // Branch target (B-type immediate)
            2'b10: begin                        // Jump (JAL or JALR)
                        if (ctrl_imm_sel == 3'b100)
                            next_pc = imm_J;  // J-type immediate (JAL)
                        else
                            next_pc = reg_rdata1 + imm_I; // JALR: target = rs1 + I-type immediate
                    end
            default: next_pc = pc_plus4;
        endcase
    end

    // Always enable PC update in this simple design
    assign pc_en = 1;

endmodule

