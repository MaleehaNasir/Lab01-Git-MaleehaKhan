`timescale 1ns / 1ps
//
// Lab 9 Top-Level: Control Path FPGA Implementation
// Basys 3 (Artix-7)
// FSM integrated directly - no separate ControlFSM module needed.
//
// FSM States:
//   S0: IDLE
//   S1: R-type  (opcode = 0110011)
//   S2: I-type  (opcode = 0010011)
//   S3: Load    (opcode = 0000011)
//   S4: Store   (opcode = 0100011)
//   S5: Branch  (opcode = 1100011)
//
// LED mapping:
//   LED[0]     = regwrite
//   LED[1]     = alusrc
//   LED[2]     = memread
//   LED[3]     = memwrite
//   LED[4]     = memtoreg
//   LED[5]     = branch
//   LED[7:6]   = aluop[1:0]
//   LED[11:8]  = alucontrol[3:0]
//   LED[14:12] = FSM state (3 bits)
//   LED[15]    = 0
//
// Controls:
//   BTNC = advance FSM (debounced)
//   BTNL = reset
//   SW[0] = reset override
//
module top(
    input        clk,
    input        btnc,
    input        btnl,
    input  [15:0] sw,
    output [15:0] led
);
    // ----------------------------------------------------------------
    // Reset
    // ----------------------------------------------------------------
    wire rst = btnl | sw[0];

    // ----------------------------------------------------------------
    // Debounce centre button
    // ----------------------------------------------------------------
    wire btn_db;
    debouncer db_btn (
        .clk   (clk),
        .pbin  (btnc),
        .pbout (btn_db)
    );

    // ----------------------------------------------------------------
    // FSM state register
    // ----------------------------------------------------------------
    localparam S0 = 3'd0,
               S1 = 3'd1,
               S2 = 3'd2,
               S3 = 3'd3,
               S4 = 3'd4,
               S5 = 3'd5;

    reg [2:0] state;

    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= S0;
        else if (btn_db) begin
            case (state)
                S0: state <= S1;
                S1: state <= S2;
                S2: state <= S3;
                S3: state <= S4;
                S4: state <= S5;
                S5: state <= S0;
                default: state <= S0;
            endcase
        end
    end

    // ----------------------------------------------------------------
    // FSM output - opcode, funct3, funct7
    // ----------------------------------------------------------------
    reg [6:0] opcode;
    reg [2:0] funct3;
    reg [6:0] funct7;

    always @(*) begin
        case (state)
            S0: begin opcode = 7'b0000000; funct3 = 3'b000; funct7 = 7'b0000000; end
            S1: begin opcode = 7'b0110011; funct3 = 3'b000; funct7 = 7'b0000000; end // R-type ADD
            S2: begin opcode = 7'b0010011; funct3 = 3'b000; funct7 = 7'b0000000; end // ADDI
            S3: begin opcode = 7'b0000011; funct3 = 3'b010; funct7 = 7'b0000000; end // LW
            S4: begin opcode = 7'b0100011; funct3 = 3'b010; funct7 = 7'b0000000; end // SW
            S5: begin opcode = 7'b1100011; funct3 = 3'b000; funct7 = 7'b0000000; end // BEQ
            default: begin opcode = 7'b0000000; funct3 = 3'b000; funct7 = 7'b0000000; end
        endcase
    end

    // ----------------------------------------------------------------
    // Main Control Unit
    // ----------------------------------------------------------------
    wire regwrite, alusrc, memread, memwrite, memtoreg, branch;
    wire [1:0] aluop;

    MainControl mc (
        .opcode  (opcode),
        .regwrite(regwrite),
        .alusrc  (alusrc),
        .memread (memread),
        .memwrite(memwrite),
        .memtoreg(memtoreg),
        .branch  (branch),
        .aluop   (aluop)
    );

    // ----------------------------------------------------------------
    // ALU Control Unit
    // ----------------------------------------------------------------
    wire [3:0] alucontrol;

    ALUControl ac (
        .aluop     (aluop),
        .funct3    (funct3),
        .funct7    (funct7),
        .alucontrol(alucontrol)
    );

    assign led[0]     = regwrite;
    assign led[1]     = alusrc;
    assign led[2]     = memread;
    assign led[3]     = memwrite;
    assign led[4]     = memtoreg;
    assign led[5]     = branch;
    assign led[7:6]   = aluop;
    assign led[11:8]  = alucontrol;
    assign led[14:12] = state;
    assign led[15]    = 1'b0;

endmodule