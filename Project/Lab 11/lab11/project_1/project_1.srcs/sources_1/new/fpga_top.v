module fpga_top(
    input        clk,
    input        btnL,
    input  [15:0] sw,
    output [15:0] led
);
    wire [31:0] PC_out;
    wire [31:0] ALU_out;
    wire [15:0] leds_out;

    TopLevelProcessor processor (
        .clk(clk),
        .reset(btnL),
        .switches_in(sw),
        .leds_out(leds_out),
        .PC_out(PC_out),
        .ALU_out(ALU_out)
    );

    assign led = leds_out;

endmodule