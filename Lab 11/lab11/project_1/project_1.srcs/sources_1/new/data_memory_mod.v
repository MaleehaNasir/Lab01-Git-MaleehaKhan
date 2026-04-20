`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 03/12/2026 09:36:51 AM
// Design Name:
// Module Name: data_memory_mod
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
module data_memory_mod(
input clk, memWrite,
input [9:0] address,
input [31:0] writeData,
output [31:0] readData
);
    reg [31:0] memory [0:511];
    always @(posedge clk) begin
        if (memWrite) memory[address[7:0]]<=writeData;
    end
     assign readData=memory[address[7:0]];
endmodule