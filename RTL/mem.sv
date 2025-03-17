`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/16/2025 11:10:28 AM
// Design Name: 
// Module Name: mem
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


module mem #(
parameter DEPTH = 256,
parameter WIDTH = $clog2(DEPTH)
)(
input logic clk,
input logic wr_en,
input logic [WIDTH-1:0] addr_pt,
input logic [31:0] wr_data,
output logic [31:0] rd_data
    );

logic [31:0] mem [0:DEPTH-1];

always_ff@(posedge clk)begin
    if(wr_en) begin
        mem[addr_pt] <= wr_data;
    end
end

always_comb begin
    rd_data = mem[addr_pt];
end 
    
endmodule
