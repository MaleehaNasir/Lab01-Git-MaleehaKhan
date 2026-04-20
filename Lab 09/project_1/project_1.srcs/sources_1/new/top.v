`timescale 1ns / 1ps
//
// Lab 9 Top-Level: Control Path FPGA Implementation
// Basys 3 (Artix-7)
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
//   BTNL  = reset
//   SW[0] = reset override
//   FSM advances automatically every 1 second
//
module top(
    input        clk,
    input        btnl,
    input  [15:0] sw,
    output [15:0] led
);

    // ----------------------------------------------------------------
    // Reset
    // ----------------------------------------------------------------
    wire rst = btnl | sw[0];

    // ----------------------------------------------------------------
    // 1-second tick generator (100 MHz clock -> 1 Hz)
    // ----------------------------------------------------------------
    reg [26:0] timer;
    reg        tick;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            timer <= 27'd0;
            tick  <= 1'b0;
        end else if (timer == 27'd99_999_999) begin
            timer <= 27'd0;
            tick  <= 1'b1;
        end else begin
            timer <= timer + 1'b1;
            tick  <= 1'b0;
        end
    end

    // ----------------------------------------------------------------
    // FSM state register - advances on each 1-second tick
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
        else if (tick) begin
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

    // ----------------------------------------------------------------
    // leds module - stores control signals and drives LEDs
    // ----------------------------------------------------------------
    wire [31:0] leds_readData;

    leds leds_inst (
        .clk        (clk),
        .rst        (rst),
        .btns       (16'b0),
        .writeData  ({16'b0, 1'b0, state, alucontrol, aluop,
                      branch, memtoreg, memwrite, memread,
                      alusrc, regwrite}),
        .writeEnable(1'b1),
        .readEnable (1'b1),
        .memAddress (30'b0),
        .switches   (sw),
        .readData   (leds_readData)
    );

    // ----------------------------------------------------------------
    // switches module - captures switch state each clock cycle
    // ----------------------------------------------------------------
    wire [31:0] sw_readData;

    switches sw_inst (
        .clk        (clk),
        .rst        (rst),
        .btns       (16'b0),
        .switches   (sw),
        .readEnable (1'b1),
        .writeData  (32'b0),
        .writeEnable(1'b0),
        .readData   (sw_readData)
    );

    // ----------------------------------------------------------------
    // LED output - control signals via leds module
    // ----------------------------------------------------------------
    assign led = leds_readData[15:0];

endmodule