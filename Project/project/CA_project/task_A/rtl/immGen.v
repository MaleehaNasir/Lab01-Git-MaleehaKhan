`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/28/2026 03:34:57 PM
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
    input  wire [31:0] instruction,
    output reg  [31:0] imm
);
    wire [6:0] opcode = instruction[6:0];

    always @(*) begin
        case (opcode)
            7'b0010011,       // I-type: ADDI, ANDI, ORI, XORI, SRLI, SLLI
            7'b0000011,       // LOAD: LW, LH, LB
            7'b1100111:       // JALR
                imm = {{20{instruction[31]}}, instruction[31:20]};
 
            7'b0100011:       // S-type: SW, SH, SB
                imm = {{20{instruction[31]}},
                        instruction[31:25],
                        instruction[11:7]};
 
            7'b1100011:       // B-type: BEQ, BNE, BLT, BGE
                imm = {{19{instruction[31]}},
                        instruction[31],
                        instruction[7],
                        instruction[30:25],
                        instruction[11:8],
                        1'b0};
 
            7'b1101111:       // J-type: JAL
                imm = {{11{instruction[31]}},
                        instruction[31],
                        instruction[19:12],
                        instruction[20],
                        instruction[30:21],
                        1'b0};
            
            7'b0110111:  // u type: LUI
                imm= {instruction[31:12], 12'b0};
 
            default: imm = 32'b0;
        endcase
    end
endmodule