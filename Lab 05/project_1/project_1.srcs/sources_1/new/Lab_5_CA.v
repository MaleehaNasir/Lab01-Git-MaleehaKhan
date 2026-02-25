`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/19/2026 09:43:05 AM
// Design Name: 
// Module Name: fsm_counter
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


module fsm_counter(
    input clk,
    input reset,
    input tick, //clock divider
    input [15:0] switch_value,
    output reg [15:0] count,
    output reg [15:0] leds
    );
    
    parameter COUNT =1'b0;
    parameter WAIT = 1'b1;
        
    reg state;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state<= WAIT;
            count <= 0;
            leds<=0;
        end
        else begin
            case (state)
                WAIT: begin
                    if(switch_value !=0) begin
                        count<=switch_value;   //768
                        leds<=switch_value;
                        state<=COUNT;
                    end
                end
                COUNT: begin
                    if (tick) begin
                        if (count > 0) begin
                            count <= count - 1;
                            leds <= count - 1;
                        end 
                        else begin
                            state <= WAIT;
                            leds <= 0;
                        end
                    end
                end
            endcase
        end
    end
     
endmodule
