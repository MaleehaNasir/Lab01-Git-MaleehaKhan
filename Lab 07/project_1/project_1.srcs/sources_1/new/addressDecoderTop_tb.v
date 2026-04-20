`timescale 1ns / 1ps

module addressDecoderTop_tb;

    // ?? DUT ports ????????????????????????????????????????????????????????????
    reg         clk, rst;
    reg  [15:0] sw;
    reg  [3:0]  btn;
    wire [15:0] led;

    // ?? Instantiate DUT ??????????????????????????????????????????????????????
    addressDecoderTop dut (
        .clk(clk),
        .rst(rst),
        .sw (sw),
        .btn(btn),
        .led(led)
    );

    // ?? Clock ????????????????????????????????????????????????????????????????
    initial clk = 0;
    always #5 clk = ~clk;

    // ?? press_btn task ???????????????????????????????????????????????????????
    task press_btn;
        input [3:0] b;
        begin
            @(negedge clk);
            btn = b;
            repeat(5) @(posedge clk);
            @(negedge clk);
            btn = 4'b0000;
            repeat(8) @(posedge clk);  // extra cycles for CAPTURE state
        end
    endtask

    // ?? Pass/fail counters ???????????????????????????????????????????????????
    integer pass = 0, fail = 0;

    initial begin
        // ---------- Initialise ----------
        rst = 1;
        btn = 4'b0000;
        sw  = 16'h0000;
        repeat(4) @(posedge clk);
        rst = 0;
        repeat(2) @(posedge clk);

        $display("========== TEST START ==========");

        // =====================================================================
        // TEST A: LED write
        // btn[1] with sw=0x55AA ? LEDs must show 0x55AA
        // =====================================================================
        $display("\n-- Test A: LED write --");
        sw = 16'h55AA;
        press_btn(4'b0010);
        #2;
        if (led === 16'h55AA) begin
            $display("PASS: LEDs = 0x%04X", led);
            pass = pass + 1;
        end else begin
            $display("FAIL: LEDs expected 0x55AA, got 0x%04X", led);
            fail = fail + 1;
        end

        // =====================================================================
        // TEST B: Data Memory write isolation from LEDs
        // =====================================================================
        $display("\n-- Test B: Data Memory write isolation from LEDs --");
        sw = 16'hF0F0;
        press_btn(4'b0010);   // write to LEDs
        #2;
        sw = 16'h0F0F;
        press_btn(4'b0001);   // write to data memory
        #2;
        if (led === 16'hF0F0) begin
            $display("PASS: LEDs unchanged after Data Memory write, still 0x%04X", led);
            pass = pass + 1;
        end else begin
            $display("FAIL: LEDs changed to 0x%04X, expected 0xF0F0", led);
            fail = fail + 1;
        end

        // =====================================================================
        // TEST C: LED value persists when switches change
        // =====================================================================
        $display("\n-- Test C: LED value persists after switch change --");
        sw = 16'hABCD;
        press_btn(4'b0010);
        #2;
        sw = 16'h1234;
        repeat(4) @(posedge clk);
        #2;
        if (led === 16'hABCD) begin
            $display("PASS: LEDs held 0xABCD after switch change");
            pass = pass + 1;
        end else begin
            $display("FAIL: LEDs = 0x%04X, expected 0xABCD", led);
            fail = fail + 1;
        end

        // =====================================================================
        // TEST D: Region isolation both ways
        // =====================================================================
        $display("\n-- Test D: Region isolation --");
        sw = 16'hDEAD;
        press_btn(4'b0001);   // write to data memory
        #2;
        sw = 16'hBEEF;
        press_btn(4'b0010);   // write to LEDs
        #2;
        if (led === 16'hBEEF) begin
            $display("PASS: LEDs = 0x%04X (correct region)", led);
            pass = pass + 1;
        end else begin
            $display("FAIL: LEDs = 0x%04X, expected 0xBEEF", led);
            fail = fail + 1;
        end

        // =====================================================================
        // TEST E: Reset clears LEDs
        // =====================================================================
        $display("\n-- Test E: Reset clears LEDs --");
        sw = 16'hFFFF;
        press_btn(4'b0010);
        #2;
        @(negedge clk);
        rst = 1;
        repeat(3) @(posedge clk);
        rst = 0;
        repeat(2) @(posedge clk);
        #2;
        if (led === 16'h0000) begin
            $display("PASS: LEDs cleared after reset");
            pass = pass + 1;
        end else begin
            $display("FAIL: LEDs = 0x%04X after reset", led);
            fail = fail + 1;
        end

        // =====================================================================
        // TEST F: LED works after reset
        // =====================================================================
        $display("\n-- Test F: LED write works after reset --");
        sw = 16'h1111;
        press_btn(4'b0010);
        #2;
        if (led === 16'h1111) begin
            $display("PASS: LEDs = 0x%04X after reset recovery", led);
            pass = pass + 1;
        end else begin
            $display("FAIL: LEDs = 0x%04X, expected 0x1111", led);
            fail = fail + 1;
        end

        // =====================================================================
        // TEST G: Data Memory write then read back
        // Write 0x1234 to data memory, then read it back via btn[2]
        // LEDs must show 0x1234
        // =====================================================================
        $display("\n-- Test G: Data Memory write then read back --");
        sw = 16'h1234;
        press_btn(4'b0001);   // btn[0] write to data memory
        #2;
        sw = 16'h0000;        // change switches so we know read came from memory
        press_btn(4'b0100);   // btn[2] read from data memory
        #2;
        if (led === 16'h1234) begin
            $display("PASS: Data Memory read back 0x%04X correctly", led);
            pass = pass + 1;
        end else begin
            $display("FAIL: Data Memory read returned 0x%04X, expected 0x1234", led);
            fail = fail + 1;
        end

        // =====================================================================
        // TEST H: Data Memory holds value across multiple operations
        // Write to memory, do other operations, read back - must still match
        // =====================================================================
        $display("\n-- Test H: Data Memory holds value across other operations --");
        sw = 16'hCAFE;
        press_btn(4'b0001);   // write 0xCAFE to data memory
        #2;
        sw = 16'hAAAA;
        press_btn(4'b0010);   // write something else to LEDs
        #2;
        sw = 16'hBBBB;
        press_btn(4'b0010);   // write again to LEDs
        #2;
        press_btn(4'b0100);   // now read back data memory
        #2;
        if (led === 16'hCAFE) begin
            $display("PASS: Data Memory still holds 0x%04X after other writes", led);
            pass = pass + 1;
        end else begin
            $display("FAIL: Data Memory returned 0x%04X, expected 0xCAFE", led);
            fail = fail + 1;
        end

        // =====================================================================
        // TEST I: Switch read
        // Set switches to 0x5A5A, press btn[3], LEDs must show 0x5A5A
        // =====================================================================
        $display("\n-- Test I: Switch read --");
        sw = 16'h5A5A;
        press_btn(4'b1000);   // btn[3] read from switches
        #2;
        if (led === 16'h5A5A) begin
            $display("PASS: Switch read returned 0x%04X", led);
            pass = pass + 1;
        end else begin
            $display("FAIL: Switch read returned 0x%04X, expected 0x5A5A", led);
            fail = fail + 1;
        end

        // =====================================================================
        // TEST J: Switch read updates when switches change
        // =====================================================================
        $display("\n-- Test J: Switch read updates with new switch value --");
        sw = 16'hF00F;
        press_btn(4'b1000);   // btn[3] read from switches
        #2;
        if (led === 16'hF00F) begin
            $display("PASS: Updated switch read returned 0x%04X", led);
            pass = pass + 1;
        end else begin
            $display("FAIL: Switch read returned 0x%04X, expected 0xF00F", led);
            fail = fail + 1;
        end

        // =====================================================================
        // TEST K: Switch read does not affect data memory
        // Write to data memory, read switches, read memory back - must match
        // =====================================================================
        $display("\n-- Test K: Switch read does not affect data memory --");
        sw = 16'h9999;
        press_btn(4'b0001);   // write 0x9999 to data memory
        #2;
        sw = 16'h1111;
        press_btn(4'b1000);   // read switches (shows 0x1111 on LEDs)
        #2;
        press_btn(4'b0100);   // read data memory back
        #2;
        if (led === 16'h9999) begin
            $display("PASS: Data Memory unaffected by switch read, returned 0x%04X", led);
            pass = pass + 1;
        end else begin
            $display("FAIL: Data Memory returned 0x%04X, expected 0x9999", led);
            fail = fail + 1;
        end

        // ?? Summary ??????????????????????????????????????????????????????????
        $display("\n========== RESULTS: %0d PASSED, %0d FAILED ==========", pass, fail);
        $finish;
    end

    // ?? Waveform dump ????????????????????????????????????????????????????????
    initial begin
        $dumpfile("addressDecoderTop_tb.vcd");
        $dumpvars(0, addressDecoderTop_tb);
    end

endmodule