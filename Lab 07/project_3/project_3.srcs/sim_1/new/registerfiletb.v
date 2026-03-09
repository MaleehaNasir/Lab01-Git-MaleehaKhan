`timescale 1ns / 1ps

module registerfiletb();

    reg clk;
    reg reset;
    reg [4:0] readAddr1;
    reg [4:0] readAddr2;
    wire [31:0] readData1;
    wire [31:0] readData2;
    reg [4:0] writeAddr;
    reg [31:0] writeData;
    reg writeEnable;
    
    RegisterFile rf (
        .clk(clk),
        .rst(reset),
        .rs1(readAddr1),
        .readData1(readData1),
        .rs2(readAddr2),
        .readData2(readData2),
        .rd(writeAddr),
        .WriteData(writeData),
        .WriteEnable(writeEnable)
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        reset = 1;
        writeEnable = 0;
        readAddr1 = 0;
        readAddr2 = 0;
        writeAddr = 0;
        writeData = 0;
        
        #10 reset = 0;
        #10;
        
        // Test 1: Write and Read
        writeAddr = 5;
        writeData = 32'hDEADBEEF;
        writeEnable = 1;
        #10;
        writeEnable = 0;
        readAddr1 = 5;
        #5;
        
        // Test 2: x0 Protection
        writeAddr = 0;
        writeData = 32'hFFFFFFFF;
        writeEnable = 1;
        #10;
        writeEnable = 0;
        readAddr1 = 0;
        #5;
        
        // Test 3: Simultaneous reads
        writeAddr = 1;
        writeData = 32'h10101010;
        writeEnable = 1;
        #10;
        writeAddr = 2;
        writeData = 32'h01010101;
        #10;
        writeEnable = 0;
        readAddr1 = 1;
        readAddr2 = 2;
        #5;
        
        // Test 4: Overwrite
        writeAddr = 3;
        writeData = 32'hAAAAAAAA;
        writeEnable = 1;
        #10;
        writeAddr = 3;
        writeData = 32'h55555555;
        #10;
        writeEnable = 0;
        readAddr1 = 3;
        #5;
        
        // Test 5: Reset
        reset = 1;
        #10;
        reset = 0;
        #10;
        readAddr1 = 3;
        #5;
        
        #100 $finish;
    end
    

endmodule