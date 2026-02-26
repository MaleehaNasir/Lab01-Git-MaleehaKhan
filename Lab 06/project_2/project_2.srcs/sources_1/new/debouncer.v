`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/19/2026 10:21:59 AM
// Design Name: 
// Module Name: debouncer
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


module debouncer(
    input clk,
    input pbin,
    output reg pbout
    );
    reg [19:0] counter=0;
    reg sync_0=0;
    reg sync_1 = 0;

    always @(posedge clk) begin
        sync_0 <= pbin;
        sync_1 <= sync_0;
    end

    always @(posedge clk) begin
        if(pbout==sync_1)
            counter <= 0;
        else begin
            counter <= counter + 1;
            if (counter == 20'hFFFFF) begin
                pbout   <= sync_1;
                counter <= 0;
            end
        end
    end


endmodule
