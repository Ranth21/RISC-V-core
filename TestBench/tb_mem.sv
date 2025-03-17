`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/16/2025 12:31:53 PM
// Design Name: 
// Module Name: tb_mem
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
module tb_mem;
  // Parameters (using the same parameters as in your memory module)
  localparam DEPTH = 256;
  localparam WIDTH = $clog2(DEPTH);

  // Testbench signals
  reg                    clk;
  reg                    wr_en;
  reg [WIDTH-1:0]        addr_pt;
  reg [31:0]             wr_data;
  wire [31:0]            rd_data;
  
  // Instantiate the memory module
  mem #(DEPTH) uut (
    .clk(clk),
    .wr_en(wr_en),
    .addr_pt(addr_pt),
    .wr_data(wr_data),
    .rd_data(rd_data)
  );
      integer i;
  // Clock generation: 10ns period (5ns high, 5ns low)
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  
  // Test sequence
  initial begin
    // Test 1: Read uninitialized memory at address 0
    wr_en   = 0;
    addr_pt = 0;
    wr_data = 32'h0; // Not used because wr_en is low
    #10;
    $display("Test 1: Uninitialized memory at addr %0d: rd_data = %h", addr_pt, rd_data);
    
    // Test 2: Write to address 0 and read back
    @(posedge clk);
    wr_en   = 1;
    addr_pt = 0;
    wr_data = 32'hDEADBEEF;
    @(posedge clk);
    wr_en   = 0;
    #1; // Allow combinational logic to settle
    $display("Test 2: After writing 0xDEADBEEF to addr %0d: rd_data = %h", addr_pt, rd_data);
    
    // Test 3: Write to highest address (DEPTH-1) and read back
    @(posedge clk);
    wr_en   = 1;
    addr_pt = DEPTH - 1; // Highest address (255 if DEPTH=256)
    wr_data = 32'hCAFEBABE;
    @(posedge clk);
    wr_en   = 0;
    #1;
    $display("Test 3: After writing 0xCAFEBABE to addr %0d: rd_data = %h", addr_pt, rd_data);
    
    // Test 4: Write multiple sequential values and read back

    for(i = 1; i < 10; i = i + 1) begin
      @(posedge clk);
      wr_en   = 1;
      addr_pt = i;
      wr_data = {16'hA5A5, i[15:0]}; // Data pattern: upper 16 bits constant, lower bits vary
      @(posedge clk);
      wr_en = 0;
      #1;
      $display("Test 4: Written/Read at addr %0d: rd_data = %h", addr_pt, rd_data);
    end
    
    // Test 5: Asynchronous read: change address without writing
    @(posedge clk);
    wr_en   = 0; // Ensure write is disabled
    addr_pt = 0;
    #1;
    $display("Test 5: Asynchronous read, addr changed to %0d: rd_data = %h", addr_pt, rd_data);
    addr_pt = 5;
    #1;
    $display("Test 5: Asynchronous read, addr changed to %0d: rd_data = %h", addr_pt, rd_data);
    addr_pt = DEPTH - 1;
    #1;
    $display("Test 5: Asynchronous read, addr changed to %0d: rd_data = %h", addr_pt, rd_data);
    
    // Test 6: Write disable test - attempt to write while wr_en is low; value should not update
    @(posedge clk);
    wr_en   = 0;
    addr_pt = 10;
    wr_data = 32'h12345678; // Attempted write (should not occur)
    @(posedge clk);
    #1;
    $display("Test 6: Write disable test at addr %0d: rd_data = %h (should be previous value)", addr_pt, rd_data);
    
    #20;
    $finish;
  end

endmodule

