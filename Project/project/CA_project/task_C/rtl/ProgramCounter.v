`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2026 10:57:33 AM
// Design Name: 
// Module Name: ProgramCounter
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


module ProgramCounter(
    input [31:0]next_PC,
    input clk,
    input reset,
    output reg [31:0] PC
    );
    
//    wire [31:0]next_count;
    
    always @(posedge clk or posedge reset) begin
        if(reset) 
            PC <= 0;
        else 
            PC <= next_PC;
    end
endmodule
