`timescale 1ns / 1ps

module tb_led_test;

reg clk, reset;
wire [15:0] leds_out;
wire [31:0] PC_out, ALU_out;

TopLevelProcessor uut (
    .clk(clk),
    .reset(reset),
    .switches_in(16'b0),
    .leds_out(leds_out),
    .PC_out(PC_out),
    .ALU_out(ALU_out)
);

always #5 clk = ~clk;

initial begin
    clk = 0; reset = 1;
    #20; reset = 0;
    #200;
    $display("PC      = %0d", PC_out);
    $display("LEDs    = %b", leds_out);
    $display("x10     = %0h", uut.register_file.regs[10]);
    $display("x11     = %0h", uut.register_file.regs[11]);
    $finish;
end

endmodule