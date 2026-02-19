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
    input [15:0] switch_value, //switches
    output reg[15:0] count
    );
    
    parameter WAIT =1'b0;
    parameter COUNT =1'b1;
    
    reg state, next_state;
    always @(posedge clk or posedge reset) begin
        if (reset)
            state<=WAIT;
        else
            state<=next_state;
    end
    
    always @(*) begin
        case(state)
            WAIT:
                if (switch_value != 0)
                    next_state = COUNT;
                else
                    next_state = WAIT;

            COUNT:
                if (count == 0)
                    next_state = WAIT;
                else
                    next_state = COUNT;

            default:
                next_state = WAIT;

        endcase
    end
    
    always @(posedge clk or posedge reset) begin
        if (reset)
            count<=0;
        else begin
            case(state)
                WAIT: 
                    count<=switch_value;
                COUNT:
                    if(tick && count>0)
                        count <= count-1;
            endcase
        end
    end
    
     
endmodule
