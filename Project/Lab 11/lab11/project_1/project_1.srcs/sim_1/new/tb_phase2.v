`timescale 1ns / 1ps

module tb_phase2;

    reg clk, reset;

    // instantiate processor
    TopLevelProcessor uut (
        .clk(clk),
        .reset(reset),
        .PC_out(),
        .ALU_out()
    );

    // 10ns clock
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        #20;
        reset = 0;

        // run enough cycles for all instructions to complete
        // 13 instructions, give plenty of headroom
        #500;

        // -----------------------------------------------
        // Check results using hierarchical access
        // -----------------------------------------------

        // BNE test - x3 should be 10, NOT 99
        if (uut.register_file.regs[3] == 32'd10)
            $display("PASS: BNE - x3 = 10 (branch taken correctly)");
        else if (uut.register_file.regs[3] == 32'd99)
            $display("FAIL: BNE - x3 = 99 (branch NOT taken, BNE broken)");
        else
            $display("FAIL: BNE - x3 = %0d (unexpected)", uut.register_file.regs[3]);

        // BLT test - x5 should be 20, NOT 99
        if (uut.register_file.regs[5] == 32'd20)
            $display("PASS: BLT - x5 = 20 (branch taken correctly)");
        else if (uut.register_file.regs[5] == 32'd99)
            $display("FAIL: BLT - x5 = 99 (branch NOT taken, BLT broken)");
        else
            $display("FAIL: BLT - x5 = %0d (unexpected)", uut.register_file.regs[5]);

        // JAL test - x7 should be 30 (skipped instruction was 99)
        if (uut.register_file.regs[7] == 32'd30)
            $display("PASS: JAL - x7 = 30 (jump taken correctly)");
        else if (uut.register_file.regs[7] == 32'd99)
            $display("FAIL: JAL - x7 = 99 (jump NOT taken, JAL broken)");
        else
            $display("FAIL: JAL - x7 = %0d (unexpected)", uut.register_file.regs[7]);

        // JAL return address test - x6 should be 40 (PC+4 after JAL at PC=36)
        if (uut.register_file.regs[6] == 32'd40)
            $display("PASS: JAL return addr - x6 = 40 (PC+4 written correctly)");
        else
            $display("FAIL: JAL return addr - x6 = %0d (expected 40)", uut.register_file.regs[6]);

        $display("----------------------------------------");
        $display("Simulation complete");
        $finish;
    end

endmodule