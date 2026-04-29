`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/29/2026 09:48:38 PM
// Design Name: 
// Module Name: fpga_top_task_c
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

module fpga_top_task_c(
    input        clk,
    input        btnL,
    input  [15:0] sw,
    output [15:0] led,
    output reg [6:0] seg,
    output reg [3:0] an
);

    wire [31:0] PC_out;
    wire [31:0] ALU_out;
    wire [15:0] leds_out;

    reg [26:0] cpu_clk_div = 0;

    always @(posedge clk or posedge btnL) begin
        if (btnL)
            cpu_clk_div <= 0;
        else
            cpu_clk_div <= cpu_clk_div + 1;
    end

    TopLevelProcessor processor (
        .clk(cpu_clk_div[26]),
        .reset(btnL),
        .switches_in(sw),
        .leds_out(leds_out),
        .PC_out(PC_out),
        .ALU_out(ALU_out)
    );

    assign led = sw[15] ? leds_out : ALU_out[15:0];

    reg [16:0] refresh_cnt = 0;
    always @(posedge clk)
        refresh_cnt <= refresh_cnt + 1;

    wire [1:0] digit_sel = refresh_cnt[16:15];
    reg [3:0] digit_val;

    always @(*) begin
        case (digit_sel)
            2'b00: begin an = 4'b1110; digit_val = ALU_out[19:16]; end
            2'b01: begin an = 4'b1101; digit_val = ALU_out[23:20]; end
            2'b10: begin an = 4'b1011; digit_val = ALU_out[27:24]; end
            2'b11: begin an = 4'b0111; digit_val = ALU_out[31:28]; end
        endcase
    end

    always @(*) begin
        case (digit_val)
            4'h0: seg = 7'b1000000;
            4'h1: seg = 7'b1111001;
            4'h2: seg = 7'b0100100;
            4'h3: seg = 7'b0110000;
            4'h4: seg = 7'b0011001;
            4'h5: seg = 7'b0010010;
            4'h6: seg = 7'b0000010;
            4'h7: seg = 7'b1111000;
            4'h8: seg = 7'b0000000;
            4'h9: seg = 7'b0010000;
            4'hA: seg = 7'b0001000;
            4'hB: seg = 7'b0000011;
            4'hC: seg = 7'b1000110;
            4'hD: seg = 7'b0100001;
            4'hE: seg = 7'b0000110;
            4'hF: seg = 7'b0001110;
            default: seg = 7'b1111111;
        endcase
    end

endmodule
