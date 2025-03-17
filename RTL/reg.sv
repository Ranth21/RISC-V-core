`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SRR
// Engineer: Revanth SAnkepalle
// 
// Create Date: 03/14/2025 09:36:51 AM
// Design Name: GPU_reg_file
// Module Name: reg_file
// Project Name: GPU_core
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


module reg_file( 

    input logic clk, reset,                    //clk, reset
    input logic wr_en,//rd_en,             // write and read enable
    input logic [4:0] wr_addr,           // write address
    input logic [31:0] wr_data,          // write data
    input logic [4:0] rd_addr1,          // read address1(rs1)
    input logic [4:0] rd_addr2,          //read address2(rs2)
    output logic [31:0] rd_data1,        //rs1 data
    output logic [31:0] rd_data2         // rs2 data

    );
    
    logic [31:0]reg_s [31:0];
    integer i;
    
    //asyncronous read
    assign rd_data1 = (rd_addr1 ==0)? 32'b0 : reg_s[rd_addr1];
    assign rd_data2 = (rd_addr2 ==0)? 32'b0 : reg_s[rd_addr2];
    
    //synchronous write
    always_ff@(posedge clk) begin
        if (reset) begin
            for (i=0; i<32;i =i+1) begin
                reg_s[i] <= 32'b0;
            end
        end
        else begin
            if (wr_en &&(wr_addr != 0)) begin           // write when only wr_en and write address is not zero
                reg_s[wr_addr] <= wr_data;
            end
        end
    end   
endmodule
