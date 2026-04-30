`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/29/2026 09:56:29 PM
// Design Name: 
// Module Name: TopLevelProcessor_task_c_tb
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

module TopLevelProcessor_task_c_tb();

    reg clk;
    reg reset;
    reg [15:0] switches_in;

    wire [15:0] leds_out;
    wire [31:0] PC_out;
    wire [31:0] ALU_out;

    TopLevelProcessor dut (
        .clk(clk),
        .reset(reset),
        .switches_in(switches_in),
        .leds_out(leds_out),
        .PC_out(PC_out),
        .ALU_out(ALU_out)
    );

    // Register debug 
        wire [31:0] array_pointer      = dut.register_file.regs[5];   // t0
        wire [31:0] array_write_value  = dut.register_file.regs[6];   // t1
        wire [31:0] loaded_array_value = dut.register_file.regs[7];   // t2
        wire [31:0] sum                = dut.register_file.regs[8];   // s0
        wire [31:0] loop_index         = dut.register_file.regs[9];   // s1
        wire [31:0] array_length       = dut.register_file.regs[18];  // s2
        wire [31:0] slt_result         = dut.register_file.regs[28];  // t3
        wire [31:0] lui_result         = dut.register_file.regs[29];  // t4
        wire [31:0] led_address        = dut.register_file.regs[30];  // t5
    // Data memory debug
     wire [31:0] array_0 = dut.data_memory.memory[0];
        wire [31:0] array_1 = dut.data_memory.memory[4];
        wire [31:0] array_2 = dut.data_memory.memory[8];
        wire [31:0] array_3 = dut.data_memory.memory[12];
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        reset = 1;
        switches_in = 16'h0000;

        repeat (4) @(posedge clk);
        reset = 0;

        repeat (100) @(posedge clk);

        if (leds_out !== 16'h0014) begin
            $error("Task C failed: expected LEDs=0014, got %04h. PC=%08h ALU=%08h",
                   leds_out, PC_out, ALU_out);
        end
        else begin
            $display("Task C passed: array sum [2,4,6,8] = %04h", leds_out);
        end

        $finish;
    end

    always @(leds_out) begin
        $display("[%0t ns] LEDs=%04h PC=%08h ALU=%08h",
                 $time, leds_out, PC_out, ALU_out);
    end

endmodule
