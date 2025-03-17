`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/16/2025 10:35:02 AM
// Design Name: 
// Module Name: PC
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


module PC(
input logic        clk,reset,
input logic  [31:0]next_pc,
input logic        pc_en,
output logic [31:0]pc
    );
    
    
always_ff@(posedge clk) begin
    if(reset) begin
        pc <= 32'b0;
    end
    else if (pc_en) begin
        pc <= next_pc;
    end


end
endmodule
