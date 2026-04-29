`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/28/2026 03:40:50 PM
// Design Name: 
// Module Name: instructionMemory
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
//actual
module instructionMemory(
    input  [31:0] instAddress,
    output reg [31:0] instruction 
);
parameter MEM_FILE = "instructions_task_b.mem";
reg [31:0] memory [0:255];
integer i;

initial begin
    for (i = 0; i < 256; i = i + 1)
        memory[i] = 32'h00000013; // NOP
    $readmemh(MEM_FILE, memory);
end

always @(*) begin
    instruction = memory[instAddress[31:2]];
end

endmodule

//testing
//module instructionMemory(
//    input  [31:0] instAddress,
//    output reg [31:0] instruction
//);
//    always @(*) begin
//        case (instAddress)
//            32'd0:  instruction = 32'h00500513; // ADDI x10, x0, 5
//            32'd4:  instruction = 32'h008000EF; // JAL x1, +8 (jump to PC=12)
//            32'd8:  instruction = 32'h00A50513; // ADDI x10, x10, 10 (should be SKIPPED)
//            32'd12: instruction = 32'h00008067; // JALR x0, 0(x1) (return to PC=8... wait no, x1=8 so returns to 8)
//            32'd16: instruction = 32'h00000063; // BEQ x0,x0,0 halt
//            default: instruction = 32'h00000013; // NOP
//        endcase
//    end
//endmodule
