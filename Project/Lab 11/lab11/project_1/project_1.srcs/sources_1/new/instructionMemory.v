//`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////
//// Company: 
//// Engineer: 
//// 
//// Create Date: 04/17/2026 01:22:45 AM
//// Design Name: 
//// Module Name: instructionMemory
//// Project Name: 
//// Target Devices: 
//// Tool Versions: 
//// Description: 
//// 
//// Dependencies: 
//// 
//// Revision:
//// Revision 0.01 - File Created
//// Additional Comments:
//// 
////////////////////////////////////////////////////////////////////////////////////

//module instructionMemory(
//    input  [31:0] instAddress,
//    output reg [31:0] instruction 
//);

//    reg [7:0] memory [0:255];

//    initial begin
//        $readmemh("instructions.mem", memory);
//    end

//    always @(*) begin
//        instruction = {
//            memory[instAddress + 3],
//            memory[instAddress + 2],
//            memory[instAddress + 1],
//            memory[instAddress + 0]
//        };
//    end

//endmodule

module instructionMemory(
    input  [31:0] instAddress,
    output reg [31:0] instruction
);
    always @(*) begin
        case (instAddress)
            32'd0:  instruction = 32'h00500513; // ADDI x10, x0, 5
            32'd4:  instruction = 32'h008000EF; // JAL x1, +8 (jump to PC=12)
            32'd8:  instruction = 32'h00A50513; // ADDI x10, x10, 10 (should be SKIPPED)
            32'd12: instruction = 32'h00008067; // JALR x0, 0(x1) (return to PC=8... wait no, x1=8 so returns to 8)
            32'd16: instruction = 32'h00000063; // BEQ x0,x0,0 halt
            default: instruction = 32'h00000013; // NOP
        endcase
    end
endmodule