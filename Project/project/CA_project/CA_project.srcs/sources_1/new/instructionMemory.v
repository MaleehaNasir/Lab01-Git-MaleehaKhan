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
reg [31:0] memory [0:255];
integer i;

initial begin
    for (i = 0; i < 256; i = i + 1)
        memory[i] = 32'h00000013; // NOP
    $readmemh("instructions_task_c.mem", memory);
end

always @(*) begin
    instruction = memory[instAddress[31:2]];
end

endmodule