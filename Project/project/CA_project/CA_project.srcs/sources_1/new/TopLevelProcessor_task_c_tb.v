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
    wire [31:0] x5_t0  = dut.register_file.regs[5];   // t0: array pointer
    wire [31:0] x6_t1  = dut.register_file.regs[6];   // t1: array init value
    wire [31:0] x7_t2  = dut.register_file.regs[7];   // t2: loaded array value
    wire [31:0] x8_s0  = dut.register_file.regs[8];   // s0: sum
    wire [31:0] x9_s1  = dut.register_file.regs[9];   // s1: loop index i
    wire [31:0] x18_s2 = dut.register_file.regs[18];  // s2: length
    wire [31:0] x28_t3 = dut.register_file.regs[28];  // t3: slt result
    wire [31:0] x29_t4 = dut.register_file.regs[29];  // t4: lui result
    wire [31:0] x30_t5 = dut.register_file.regs[30];  // t5: LED address

    // Data memory debug
    wire [31:0] mem_0  = dut.data_memory.memory[0];
    wire [31:0] mem_4  = dut.data_memory.memory[4];
    wire [31:0] mem_8  = dut.data_memory.memory[8];
    wire [31:0] mem_12 = dut.data_memory.memory[12];

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
