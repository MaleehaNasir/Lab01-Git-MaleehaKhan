`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/29/2026 05:05:02 AM
// Design Name: 
// Module Name: toplevelprocessor_task_a
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

module toplevelprocessor_task_a();

    reg         clk;
    reg         reset;
    reg  [15:0] switches_in;
    wire [15:0] leds_out;
    wire [31:0] PC_out;
    wire [31:0] ALU_out;

    TopLevelProcessor #(
        .MEM_FILE("instructions_task_a.mem")
    ) dut (
        .clk        (clk),
        .reset      (reset),
        .switches_in(switches_in),
        .leds_out   (leds_out),
        .PC_out     (PC_out),
        .ALU_out    (ALU_out)
    );

    // 10 ns clock (100 MHz)
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // --- Apply reset ---
        reset       = 1;
        switches_in = 16'h0000;
        repeat(8) @(posedge clk);
        reset = 0;
        $display("[%0t ns] Reset released. Switches=0, waiting...", $time);

        // --- Poll with switches=0: LEDs should stay 0 ---
        repeat(200) @(posedge clk);
        $display("[%0t ns] After 200 cycles with sw=0: LEDs=%04h (expect 0000)", $time, leds_out);

        // --- Set switches to 5, countdown should start ---
        switches_in = 16'h0005;
        $display("[%0t ns] Switches set to 5. Expecting countdown 5->0 on LEDs.", $time);
        repeat(30000) @(posedge clk);
        $display("[%0t ns] After countdown: LEDs=%04h (expect 0000 when done)", $time, leds_out);

        // --- Return switches to 0, wait ---
        switches_in = 16'h0000;
        repeat(300) @(posedge clk);
        $display("[%0t ns] sw=0 again, waiting.", $time);

        // --- Second countdown from 3 ---
        switches_in = 16'h0003;
        $display("[%0t ns] Switches set to 3. Expecting countdown 3->0.", $time);
        repeat(15000) @(posedge clk);
        $display("[%0t ns] After second countdown: LEDs=%04h (expect 0000)", $time, leds_out);

        switches_in = 16'h0000;
        repeat(300) @(posedge clk);

        // --- Test mid-countdown reset ---
        switches_in = 16'h000A;  // 10
        $display("[%0t ns] Countdown from 10 started, will reset mid-way.", $time);
        repeat(8000) @(posedge clk);
        $display("[%0t ns] Asserting reset mid-countdown, LEDs before=%04h", $time, leds_out);
        reset = 1;
        repeat(4) @(posedge clk);
        reset = 0;
        switches_in = 16'h0000;
        repeat(100) @(posedge clk);
        $display("[%0t ns] After reset: LEDs=%04h (expect 0000)", $time, leds_out);

        $display("[%0t ns] === Simulation complete ===", $time);
        $finish;
    end

    // Print every LED change so we can see the countdown in waveforms/log
    always @(leds_out)
        $display("[%0t ns] LED change: %04h  PC=%08h  ALU=%08h", $time, leds_out, PC_out, ALU_out);

endmodule
