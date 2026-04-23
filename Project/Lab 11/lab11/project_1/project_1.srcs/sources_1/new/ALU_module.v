`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2026 09:43:45 AM
// Design Name: 
// Module Name: ALU_module
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


module ALU_module(
    input [31:0]A, input [31:0]B,
    input [3:0] ALUControl,
    output reg [31:0]ALUResult,
    output zero,
    output less
    );
    
    always @(*) begin
        if (ALUControl == 4'b0000) ALUResult <= A+B; //add
        else if (ALUControl == 4'b0001) ALUResult <= A-B; //sub
        else if (ALUControl == 4'b0010) ALUResult <= A<<B[4:0];//sll
        else if (ALUControl == 4'b0011) ALUResult <= A>>B[4:0]; //srl
        else if (ALUControl == 4'b0100) ALUResult <= A|B; //or
        else if (ALUControl == 4'b0101) ALUResult <= A&B; //and
        else if (ALUControl == 4'b0110) ALUResult <= A^B; //xor
        else ALUResult <= 32'b0;
        
    end
    
    assign zero = (ALUResult==0);
    assign less = ALUResult[31]; //1 if negative so less
        
endmodule