`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2026 01:39:50 PM
// Design Name: 
// Module Name: top_module
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


module top_module(
    input clk,       
    input rst_btn,   
    input [15:0] sw,      
    output[15:0] led      
);
    wire reset;  
    wire tick;  
    debouncer db(
        .clk(clk),
        .pbin(rst_btn),
        .pbout(reset)
    );
    clock_divider cd(
        .clk(clk),
        .reset(reset),
        .ticks(tick)
    );
    fsm_counter fsm (
        .clk(clk),
        .reset(reset),
        .tick(tick),
        .switch_value(sw),
        .leds(led)
    );

endmodule
