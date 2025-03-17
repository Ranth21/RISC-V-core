`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/16/2025 01:23:10 PM
// Design Name: 
// Module Name: fetch
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


module fetch (
    input logic clk,
    input logic reset,
    input logic [31:0] pc,
    output logic [31:0] ft_ins
    );
   
localparam DEPTH = 256;
localparam addr_width =$clog2(DEPTH);

logic [addr_width -1:0] imem_addr;
assign imem_addr = pc[addr_width +1:2];

mem #(
    .DEPTH(DEPTH)
    )
    imem_inst(
.clk(clk),
.wr_en(1'b0),
.addr_pt(imem_addr),
.wr_data(32'b0),
.rd_data(ft_ins)
);

endmodule
