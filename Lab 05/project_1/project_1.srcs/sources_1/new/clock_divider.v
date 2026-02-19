`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/19/2026 09:50:22 AM
// Design Name: 
// Module Name: clock_divider
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


module clock_divider(
    input clk,
    input reset,
    output reg ticks
    );
    
    reg [26:0] counter;
    always @(posedge clk or posedge reset) begin
        if (reset) begin 
            counter<=0;
            ticks<=0;
        end 
        else if (counter==20 - 1) begin //for simulation 20 warna change to 100_000_000 - 1
            counter<=0;
            ticks<=1;
        end
        else begin 
            counter <= counter+1;
            ticks<=0;
        end
    end
endmodule
