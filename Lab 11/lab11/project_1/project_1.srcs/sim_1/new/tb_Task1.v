`timescale 1ns / 1ps

module tb_Task1;

    reg        clk;
    reg        reset;
    reg        PCSrc;
    reg [31:0] inst;

    wire [31:0] PC;
    wire [31:0] upd_PC;
    wire [31:0] imm;
    wire [31:0] branch_target;
    wire [31:0] next_PC;


    ProgramCounter uPC (
        .clk     (clk),
        .reset   (reset),
        .next_PC (next_PC),
        .PC      (PC)
    );

    pcAdder uPCAdder (
        .PC       (PC),
        .upd_PC (upd_PC)
    );

    immGen uImmGen (
        .inst (inst),
        .imm  (imm)
    );

    branchAdder uBranchAdder (
        .PC            (PC),
        .imm           (imm),
        .branch_tar (branch_target)
    );

    MUX uMux (
        .in0 (upd_PC),
        .in1 (branch_target),
        .select (PCSrc),
        .out (next_PC)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $monitor("[%0t ns] PC=%0d | PC+4=%0d | imm=%0d | branch_target=%0d | next_PC=%0d | PCSrc=%0b",
                 $time, PC, upd_PC, $signed(imm), branch_target, next_PC, PCSrc);
    end

    initial begin
        reset = 1;
        PCSrc = 0;
        inst  = 32'b0;

        @(posedge clk); #1;
        reset = 0;
        $display("\n[%0t ns] Reset released - PC should be 0", $time);
        $display("\n--- TEST 1: Sequential PC (PCSrc=0) ---");
        PCSrc = 0;
        inst  = 32'b0;

        repeat(5) begin
            @(posedge clk); #1;
            $display("  PC=%0d | PC+4=%0d | next_PC=%0d", PC, upd_PC, next_PC);
        end

        $display("\n--- TEST 2: Branch taken (PCSrc=1) - BEQ 32'h00000463, imm=8 ---");
        inst  = 32'h00000463;
        PCSrc = 1;

        repeat(3) begin
            @(posedge clk); #1;
            $display("  PC=%0d | imm=%0d | branch_target=%0d | next_PC=%0d",
                     PC, $signed(imm), branch_target, next_PC);
        end

        $display("\n--- TEST 3: immGen I-type - ADDI x1,x0,-5  (32'hFFB00093) ---");
        PCSrc = 0;
        inst  = 32'hFFB00093;

        @(posedge clk); #1;
        $display("  PC=%0d | I-type imm (expected -5) = %0d", PC, $signed(imm));
        if ($signed(imm) === -5)
            $display("  [PASS] immGen I-type correct");
        else
            $display("  [FAIL] immGen I-type WRONG - got %0d", $signed(imm));

        $display("\n--- TEST 4: immGen S-type - SW x1,-4(x0)  (32'hFE102E23) ---");
        inst = 32'hFE102E23;

        @(posedge clk); #1;
        $display("  PC=%0d | S-type imm (expected -4) = %0d", PC, $signed(imm));
        if ($signed(imm) === -4)
            $display("  [PASS] immGen S-type correct");
        else
            $display("  [FAIL] immGen S-type WRONG - got %0d", $signed(imm));

        $display("\n--- All tests complete ---");
        #20;
        $finish;
    end

endmodule