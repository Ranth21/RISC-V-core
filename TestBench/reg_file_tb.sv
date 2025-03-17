module tb_register_file;
    // Testbench signals
    logic       clk;
    logic       reset;
    logic         wr_en;
    logic[4:0]  wr_addr;
    logic[31:0] wr_data;
    logic[4:0]  rd_addr1;
    logic[4:0]  rd_addr2;
    logic[31:0] rd_data1;
    logic  [31:0] rd_data2;
    
    // Instantiate the register file
    reg_file uut (
        .clk(clk),
        .reset(reset),
        .wr_en(wr_en),
        .wr_addr(wr_addr),
        .wr_data(wr_data),
        .rd_addr1(rd_addr1),
        .rd_addr2(rd_addr2),
        .rd_data1(rd_data1),
        .rd_data2(rd_data2)
    );
    
    // Clock generation
    always #5 clk = ~clk;
    
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        wr_en = 0;
        wr_addr = 0;
        wr_data = 0;
        rd_addr1 = 0;
        rd_addr2 = 0;
        
        // Hold reset for a few cycles
        #15;
        reset = 0;
        
        // Test 1: Write to register 5 and read it back
        #10;
        wr_en = 1;
        wr_addr = 5'd5;
        wr_data = 32'hDEADBEEF;
        #10;  // Wait for one clock cycle
        
        wr_en = 0;
        rd_addr1 = 5'd5;
        #10;
        $display("Register 5: Expected 0xDEADBEEF, Got: 0x%h", rd_data1);
        
        // Test 2: Attempt to write to register 0 (should remain 0)
        #10;
        wr_en = 1;
        wr_addr = 5'd0;
        wr_data = 32'h12345678;
        #10;
        wr_en = 0;
        rd_addr1 = 5'd0;
        #10;
        $display("Register 0: Expected 0x00000000, Got: 0x%h", rd_data1);
        
        // Test 3: Write and read a second register concurrently
        #10;
        wr_en = 1;
        wr_addr = 5'd10;
        wr_data = 32'hCAFEBABE;
        #10;
        wr_en = 0;
        rd_addr1 = 5'd5;   // Should still be 0xDEADBEEF
        rd_addr2 = 5'd10;  // Should be 0xCAFEBABE
        #10;
        $display("Register 5: Expected 0xDEADBEEF, Got: 0x%h", rd_data1);
        $display("Register 10: Expected 0xCAFEBABE, Got: 0x%h", rd_data2);
        
        #20;
        $finish;
    end
endmodule
