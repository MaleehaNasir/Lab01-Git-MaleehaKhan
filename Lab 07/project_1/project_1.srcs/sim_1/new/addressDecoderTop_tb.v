`timescale 1ns / 1ps
module addressDecoderTop_tb;

    // ?? DUT ports ????????????????????????????????????????????????????????????
    reg         clk, rst;
    reg  [31:0] address;
    reg         readEnable, writeEnable;
    reg  [31:0] writeData;
    reg  [15:0] switches;
    wire [31:0] readData;
    wire [15:0] leds;

    // ?? Instantiate DUT ??????????????????????????????????????????????????????
    addressDecoderTop dut (
        .clk        (clk),
        .rst        (rst),
        .address    (address),
        .readEnable (readEnable),
        .writeEnable(writeEnable),
        .writeData  (writeData),
        .switches   (switches),
        .readData   (readData),
        .leds       (leds)
    );

    // ?? Clock ????????????????????????????????????????????????????????????????
    initial clk = 0;
    always #5 clk = ~clk;

    // ?? Pass/fail counters ???????????????????????????????????????????????????
    integer pass = 0, fail = 0;

    initial begin


        // ---------- Initialise ----------
        rst         = 1;
        address     = 0;
        readEnable  = 0;
        writeEnable = 0;
        writeData   = 0;
        switches    = 0;
        @(posedge clk); @(posedge clk);
        rst = 0;
        @(posedge clk); @(posedge clk);

        $display("========== TEST START ==========");

        // =====================================================================
        // TEST 1: Write to Data Memory
        // address=50  ?  address[9:8]=00  ?  dataMemWrite=1
        // decoder enables data memory only, stores 0xDEADBEEF at word 50
        // no readData to check here - write has no return value
        // =====================================================================
        $display("\n-- Test 1: Write to Data Memory --");
        @(negedge clk);
        address     = 32'd50;
        writeData   = 32'hDEADBEEF;
        writeEnable = 1;
        readEnable  = 0;
        @(posedge clk); #1;
        writeEnable = 0;
        @(posedge clk); @(posedge clk);
        $display("INFO: Wrote 0xDEADBEEF to Data Memory at address 50");
        $display("INFO: address[9:8] = 00 ? dataMemWrite asserted, LEDWrite=0, SwitchReadEnable=0");

        // =====================================================================
        // TEST 2: Read from Data Memory
        // address=50  ?  address[9:8]=00  ?  dataMemRead=1
        // readData should return 0xDEADBEEF written in Test 1
        // =====================================================================
        $display("\n-- Test 2: Read from Data Memory --");
        @(negedge clk);
        address     = 32'd50;
        readEnable  = 1;
        writeEnable = 0;
        @(posedge clk); #1;
        readEnable  = 0;
        @(posedge clk); @(posedge clk);
        #2;
        if (readData === 32'hDEADBEEF) begin
            $display("PASS: readData = 0x%08X (correct)", readData);
            pass = pass + 1;
        end else begin
            $display("FAIL: readData = 0x%08X, expected 0xDEADBEEF", readData);
            fail = fail + 1;
        end

        // =====================================================================
        // TEST 3: Read from Switches
        // switches=0xF0F0, address=512  ?  address[9:8]=10  ?  SwitchReadEnable=1
        // readData should return 0x0000F0F0
        // =====================================================================
        $display("\n-- Test 3: Read from Switches --");
        @(negedge clk);
        switches    = 16'hF0F0;
        address     = 32'd512;
        readEnable  = 1;
        writeEnable = 0;
        @(posedge clk); #1;
        readEnable  = 0;
        @(posedge clk); @(posedge clk);
        #2;
        if (readData === 32'h0000F0F0) begin
            $display("PASS: readData = 0x%08X (correct)", readData);
            pass = pass + 1;
        end else begin
            $display("FAIL: readData = 0x%08X, expected 0x0000F0F0", readData);
            fail = fail + 1;
        end

        // =====================================================================
        // TEST 4: Write to LEDs
        // address=256  ?  address[9:8]=01  ?  LEDWrite=1
        // leds output should show 0xABCD after write
        // =====================================================================
        $display("\n-- Test 4: Write to LEDs --");
        @(negedge clk);
        address     = 32'd256;
        writeData   = 32'h0000ABCD;
        writeEnable = 1;
        readEnable  = 0;
        @(posedge clk); #1;
        writeEnable = 0;
        @(posedge clk); @(posedge clk); // extra cycles for leds module to update
        #2;
        if (leds === 16'hABCD) begin
            $display("PASS: leds = 0x%04X (correct)", leds);
            pass = pass + 1;
        end else begin
            $display("FAIL: leds = 0x%04X, expected 0xABCD", leds);
            fail = fail + 1;
        end

        // ?? Summary ??????????????????????????????????????????????????????????
        @(posedge clk); @(posedge clk);
        $display("\n========== RESULTS: %0d PASSED, %0d FAILED ==========", pass, fail);
        $finish;
    end

endmodule