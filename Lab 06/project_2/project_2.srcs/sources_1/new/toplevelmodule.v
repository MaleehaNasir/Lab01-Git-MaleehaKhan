`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2026 10:56:10 AM
// Design Name: 
// Module Name: toplevelmodule
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


module toplevelmodule(
    input clk, 
    input reset,
    input [15:0] switches_in,
    output [15:0] leds_out
    );
    
    wire [31:0] op_A=32'h10101010;
    wire [31:0] op_B=32'h01010101;
    
    
    wire [31:0] switchess;
    switches s1(.clk(clk), .rst(reset), .btns(16'b0), .switches(switches_in), .readEnable(1'b1), .writeData(32'b0), .writeEnable(1'b0), .readData(switchess) );
    //alucontrol fot lower 4 switches
    wire [3:0] control;
    assign control = switchess[3:0];
    
    wire op_clean;
    debouncer u1(.clk(clk), .pbin(switches_in[4]), .pbout(op_clean) );
    
    wire [31:0] result;
    wire zero_flag;
    ALU_module u2(.A(op_A), .B(op_B), .ALUControl(control), .ALUResult(result), .zero(zero_flag) );
    
    wire [31:0] ledss;
    leds l1(.clk(clk), .rst(reset), .btns(16'b0), .writeData(result),.writeEnable(1'b1),.readEnable(1'b0), .memAddress(30'b0), .switches(16'b0), .readData(ledss) );
//    wire display=switchess[4];
//    wire [15:0] display_data = (display) ? ledss[31:16] : ledss[15:0];

    assign leds_out = (op_clean)? ledss[31:16] : ledss[15:0];
endmodule
