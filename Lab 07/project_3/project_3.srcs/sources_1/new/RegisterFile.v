`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/05/2026 09:08:32 AM
// Design Name: 
// Module Name: RegisterFile
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


module RegisterFile(
    input clk, rst, WriteEnable, 
    input [4:0] rs1, rs2, rd,
    input [31:0] WriteData,
    output [31:0] readData1, readData2 
    );
    
    reg[31:0] regs [31:0];
    initial begin
        regs[0] = 32'h00000000; 
        regs[1] = 32'h10101010;
        regs[2] = 32'h01010101;  
    end
    
    always @ (posedge clk) begin
        if (WriteEnable == 1 && rd != 5'b0) regs[rd] <= WriteData; 
    end 
    
    assign readData1=regs[rs1];
    assign readData2=regs[rs2];    
    
    
        
endmodule
