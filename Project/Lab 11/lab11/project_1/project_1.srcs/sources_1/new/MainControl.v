`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2026 11:29:27 AM
// Design Name: 
// Module Name: MainControl
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


module MainControl(
 input [6:0] opcode,
 output reg regwrite, alusrc, memread, memwrite, memtoreg, branch,jump,
 output reg [1:0] aluop
 );

 always @(*) begin
     case(opcode)
        7'b0110011:begin //RTYPE
             regwrite = 1'b1;
             alusrc=1'b0;
             memread=1'b0;
             memwrite=1'b0;
             memtoreg=1'b0;
             branch=1'b0;
             jump = 1'b0;
             aluop=2'b10;
        end
        7'b0010011: begin//ITYPE(ALU)
             regwrite = 1'b1;
             alusrc=1'b1;
             memread=1'b0;
             memwrite=1'b0;
             memtoreg=1'b0;
             branch=1'b0;
             jump = 1'b0;
             aluop=2'b11;
        end        
        7'b0000011:begin //ITYPE(LOAD)
             regwrite = 1'b1;
             alusrc=1'b1;
             memread=1'b1;
             memwrite=1'b0;
             memtoreg=1'b1;
             branch=1'b0;
             jump = 1'b0;
             aluop=2'b00;
        end
        7'b1100011:begin //SB TYPE
             regwrite = 1'b0;
             alusrc=1'b0;
             memread=1'b0;
             memwrite=1'b0;
             memtoreg=1'b0;//DC
             branch=1'b1;
             jump = 1'b0;
             aluop=2'b01;
        end
        
        7'b0100011:begin //S TYPE
             regwrite = 1'b0;
             alusrc=1'b1;
             memread=1'b0;
             memwrite=1'b1;
             memtoreg=1'b0;//DC
             branch=1'b0;
             jump = 1'b0;
             aluop=2'b00;
        end
        
        7'b1101111: begin // JAL 
            regwrite=1'b1; 
            alusrc=1'b0; 
            memread=1'b0; 
            memwrite=1'b0;
            memtoreg=1'b0; 
            branch=1'b0; 
            jump=1'b1; 
            aluop=2'b00;
        end
        
        default: begin
            regwrite = 1'b0;
             alusrc=1'b0;
             memread=1'b0;
             memwrite=1'b0;
             memtoreg=1'b0;
             branch=1'b0;
             jump = 1'b0;
             aluop=2'b00;
        end
     endcase
     end
endmodule
