`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/28/2026 03:31:47 PM
// Design Name: 
// Module Name: address_decoder
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

module address_decoder(
 input[9:0] address,
 output reg dataMemRead, dataMemWrite, LEDWrite, SwitchReadEnable
 );

     always @ (*) begin
         dataMemRead = 0;
         dataMemWrite = 0;
         LEDWrite = 0;
         SwitchReadEnable = 0;

         case (address[9:8])
            2'b00,
            2'b01: begin
                dataMemRead = 1;
                dataMemWrite = 1;
            end
            2'b10: LEDWrite = 1;
            2'b11: SwitchReadEnable = 1;
         endcase
     end
endmodule
