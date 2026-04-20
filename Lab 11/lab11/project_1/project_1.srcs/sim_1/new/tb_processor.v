`timescale 1ns / 1ps

module tb_processor;

reg clk;
reg reset;

wire [31:0] PC_out;
wire [31:0] ALU_out;

TopLevelProcessor uut (
    .clk(clk),
    .reset(reset),
    .PC_out(PC_out),
    .ALU_out(ALU_out)
);

always #5 clk = ~clk;
initial begin
    clk = 0;
    reset = 1;
    #10;
    reset = 0;
    #200;

    $stop;
end

endmodule