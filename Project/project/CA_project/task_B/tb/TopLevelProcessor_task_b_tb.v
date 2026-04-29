`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/29/2026 05:48:24 AM
// Design Name: 
// Module Name: TopLevelProcessor_task_b_tb
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
module TopLevelProcessor_task_b_tb();

    reg clk;
    reg reset;
    reg [15:0] switches_in;

    wire [15:0] leds_out;
    wire [31:0] PC_out;
    wire [31:0] ALU_out;

    TopLevelProcessor #(
        .MEM_FILE("instructions_task_b.mem")
    ) dut (
        .clk(clk),
        .reset(reset),
        .switches_in(switches_in),
        .leds_out(leds_out),
        .PC_out(PC_out),
        .ALU_out(ALU_out)
    );

    // 100 MHz clock: 10 ns period
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        reset = 1;
        switches_in = 16'h0000;

        repeat (4) @(posedge clk);
        reset = 0;

        // Give the Task B program enough cycles to run
        repeat (40) @(posedge clk);

        if (leds_out !== 16'h0007) begin
            $error("Task B failed: expected LEDs=0007, got %04h. PC=%08h ALU=%08h",
                   leds_out, PC_out, ALU_out);
        end
        else begin
            $display("Task B passed: SLT, BGE, and LUI program produced LEDs=%04h", leds_out);
        end

        $finish;
    end

endmodule
