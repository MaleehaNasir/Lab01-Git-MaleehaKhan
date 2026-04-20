`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/26/2026 09:57:46 AM
// Design Name: 
// Module Name: ALUControl
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


module ALUControl(

    input wire [1:0] aluop,
    input [2:0] funct3,
    input wire [6:0] funct7,
    output reg [3:0] alucontrol 
    );
    
    always @(*) begin
        
        alucontrol=4'b0000;//default is add
        
        case(aluop)
            2'b00:  alucontrol=4'b0000;
            
            2'b01:  alucontrol=4'b0001;
            
            2'b10: begin
                case(funct3)
                    3'b000: begin
                    alucontrol=funct7[5]?4'b0001:4'b0000;
                    end
                    
                    3'b001: alucontrol=4'b0010; //sll
                    3'b101:alucontrol=4'b0011;//srl
                    3'b110:alucontrol=4'b0100;//or
                    3'b111:alucontrol=4'b0101;//and
                    3'b100:alucontrol=4'b0110;
                    
                    default:
                    alucontrol=4'b0000;
                endcase                     
            end
            
            2'b11: alucontrol=4'b0000; //add bec only addi required
           
        endcase
    
    end
    
endmodule
