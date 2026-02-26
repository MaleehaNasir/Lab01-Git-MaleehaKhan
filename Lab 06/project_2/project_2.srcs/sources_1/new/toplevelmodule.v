`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2026 10:56:10 AM
// Design Name: 
// Module Name: toplevelmodule
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


module toplevelmodule(
    input clk, 
    input reset,
    input [15:0] switches_in,
    input [15:0] leds_out
    );
    wire [31:0] switchess;
    switches s1(.clk(clk), .rst(reset), .btns())
endmodule
