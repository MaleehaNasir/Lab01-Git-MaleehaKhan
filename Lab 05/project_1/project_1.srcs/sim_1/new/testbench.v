`timescale 1ns / 1ps

module testbench();
    reg clk, reset;
    reg [15:0] sw;
    reg tick;
    wire [15:0] led;

    fsm_counter uut ( .clk(clk), .reset(reset), .tick(tick), .switch_value(sw), .leds(led));
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        tick = 0;
        forever begin
            #50 tick = 1;
            #10 tick = 0;
        end
    end

    always @(posedge tick)
        $display("Time=%0t  LED=%0d", $time, led);

    initial begin
    //testcase 1
        reset = 1; sw = 0;
        #20 reset = 0;
        #20 sw = 16'd4;      // Start countdown from 4
        #2000;               // Wait for countdown to finish
    //testcase 2
        reset = 1; sw = 0;
        #20 reset = 0;
        #20 sw = 16'd9;      // Start countdown from 9
        #3000;               // Wait for countdown
    //testcase 3
        reset = 1; sw = 0;
        #20 reset = 0;
        #20 sw = 16'd6;      // Start from 6
        #200;                // Let it count a bit

        $display(">>> Reset pressed during countdown");
        reset = 1;           // Apply reset
        #20 reset = 0;

        #1000;               // Observe result

        //testcase 4
        reset = 1; sw = 0;
        #20 reset = 0;

        #20 sw = 16'd7;      // Start from 7
        #200;                // Let it count

        $display(">>> Changing switch to 3 during countdown");
        sw = 16'd3;          // Should be ignored

        #3000;               // Let countdown finish
        $stop;
    end

endmodule