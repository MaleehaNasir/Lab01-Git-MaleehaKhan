`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2026 11:25:34 AM
// Design Name: 
// Module Name: alu_fsm
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


module alu_fsm(
    input clk,
    input reset,
    input next,
    output reg [3:0] ALUControl
    );
    reg [3:0] state;
    always @(posedge clk) begin
        if (reset) begin
            state <= 4'b0000;
        end 
        else if (next) begin
            if(state==4'b0110)
                state <= 4'b0000;
            else
                state <= state+1;
        end
    end
    always @(*) begin
        ALUControl = state;
    end
endmodule
