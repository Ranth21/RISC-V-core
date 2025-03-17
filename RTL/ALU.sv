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


module ALU(
    input logic [31:0] rs1,
    input logic [31:0] rs2,
    input logic [2:0] op_ctrl,
    output logic [31:0] alu_op,
    output logic b_zero
      );
     
 localparam add = 3'b000;
 localparam sub = 3'b001;
 localparam mul = 3'b011;
 localparam div = 3'b010;
 
 always_comb begin
    case(op_ctrl)
        add : begin
            alu_op = rs1 + rs2;
        end
        sub : begin
            alu_op = rs1 - rs2;
        end
        mul : begin
            alu_op = rs1 * rs2;
        end
        div : begin
            if(rs2 != 0)
                alu_op = rs1 / rs2;
            else 
                alu_op = 32'hFFFFFFFF;
       end
       
       default : begin 
            alu_op = 32'b0;
       end
       endcase
       

      if (alu_op == 32'b0)
            b_zero = 1'b1;
       else 
            b_zero = 1'b0;
       end          
      
endmodule
