`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/23/2026 05:17:21 PM
// Design Name: 
// Module Name: RegisterFile
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

module RegisterFile(    
    input  clk,
    input  rst,
    input  WriteEnable,
    input  [4:0]  rs1, rs2,
    input  [4:0]  rd,
    input  [31:0] WriteData,
    output [31:0] readdata1,
    output [31:0] readdata2
);
    reg [31:0] regs [31:0];
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
        //resetting all registers to 0
            for (i = 0; i < 32; i = i + 1)
                regs[i] <= 32'b0;
        end
        else begin
            if (WriteEnable && rd != 5'b00000)
                regs[rd] <= WriteData;
            regs[0] <= 32'b0;  // x0 always 0
        end
    end

    assign readdata1 = (rs1 == 5'b0) ? 32'b0 : regs[rs1];
    assign readdata2 = (rs2 == 5'b0) ? 32'b0 : regs[rs2];
endmodule
