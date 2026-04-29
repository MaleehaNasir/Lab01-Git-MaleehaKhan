`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/28/2026 03:37:24 PM
// Design Name: 
// Module Name: branchAdder
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

module branchAdder(
    input  [31:0] PC,
    input  [31:0] imm,
    output [31:0] branch_tar
);
    assign branch_tar = PC + imm;
endmodule