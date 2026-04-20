`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2026 11:39:15 AM
// Design Name: 
// Module Name: immGen
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


module immGen(
    input [31:0] inst,
    output reg [31:0] imm
    );
    
    always @(*) begin
        case(inst[6:0]) //opcode
        //i-type
             7'b0000011,   // lw
             7'b0010011:   // addi, etc.
                imm={{20{inst[31]}}, inst[31:20]};
        //s-type
            7'b0100011: 
                imm={{20{inst[31]}}, inst[31:25], inst[11:7]};
        //b-type
            7'b1100011:   // beq, bne, etc.
                imm = {{19{inst[31]}}, inst[31], inst[7],
                       inst[30:25], inst[11:8], 1'b0};
            default:
                imm = 32'b0;
        endcase
    end

endmodule
