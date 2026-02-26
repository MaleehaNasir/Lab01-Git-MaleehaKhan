`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2026 10:02:03 AM
// Design Name: 
// Module Name: testbench_task2
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


module testbench_task2();
    reg [31:0] A;
    reg [31:0]B;
    reg [3:0] ALUControl;
    wire[31:0] ALUResult;
    wire zero;
    
    ALU_module alu(A,B, ALUControl, ALUResult, zero);
    
    initial begin
        A = 32'd5;
        B = 32'd3;
        ALUControl = 4'b0000;
        #10;
        
        A = 32'd10;
        B = 32'd3;
        ALUControl = 4'b0001;
        #10;
        
        A = 32'd2;
        B = 32'd3;
        ALUControl = 4'b0010;
        #10;
        
        A = 32'd2;
        B = 32'd3;
        ALUControl = 4'b0011;
        #10;
        
        A = 32'hAAAAAAAA;
        B = 32'h55555555;
        ALUControl = 4'b0100;
        #10;
        
        A = 32'd1;
        B = 32'd4;  // Shift by 4
        ALUControl = 4'b0101;
        #10;
        
        A = 32'h00001000;
        B = 32'd4;  // Shift by 4
        ALUControl = 4'b0110;
        #10;
        
        A = 32'd5;
        B = 32'd5;
        ALUControl = 4'b0001;  // SUB
        #10;
   $finish;
    end  
endmodule
