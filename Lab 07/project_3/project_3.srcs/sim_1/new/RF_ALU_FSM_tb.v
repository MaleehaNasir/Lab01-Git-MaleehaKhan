`timescale 1ns / 1ps

module RF_ALU_FSM_tb;

    // Clock and reset
    reg clk;
    reg reset;
    
    // RegisterFile signals
    reg [4:0] rf_readAddr1;
    reg [4:0] rf_readAddr2;
    wire [31:0] rf_readData1;
    wire [31:0] rf_readData2;
    reg [4:0] rf_writeAddr;
    reg [31:0] rf_writeData;
    reg rf_writeEnable;
    
    // ALU signals
    reg [31:0] alu_A;
    reg [31:0] alu_B;
    reg [3:0] alu_op;
    wire [31:0] alu_result;
    wire alu_zero;
    
    // FSM states
    parameter IDLE           = 5'd0;
    parameter INIT_X1        = 5'd1;
    parameter INIT_X2        = 5'd2;
    parameter INIT_X3        = 5'd3;
    parameter TEST_ADD       = 5'd4;
    parameter TEST_SUB       = 5'd5;
    parameter TEST_AND       = 5'd6;
    parameter TEST_OR        = 5'd7;
    parameter TEST_XOR       = 5'd8;
    parameter TEST_SLL       = 5'd9;
    parameter TEST_SRL       = 5'd10;
    parameter TEST_BEQ       = 5'd11;
    parameter READ_AFTER_WRITE = 5'd12;
    parameter DONE           = 5'd13;
    
    // ALU operation codes
    parameter ADD = 4'b0000;
    parameter SUB = 4'b0001;
    parameter AND = 4'b0010;
    parameter OR  = 4'b0011;
    parameter XOR = 4'b0100;
    parameter SLL = 4'b0101;
    parameter SRL = 4'b0110;
    
    reg [4:0] state;
    reg [4:0] next_state;
    
    // Instantiate RegisterFile
    RegisterFile rf (
        .clk(clk),
        .rst(reset),
        .rs1(rf_readAddr1),
        .readData1(rf_readData1),
        .rs2(rf_readAddr2),
        .readData2(rf_readData2),
        .rd(rf_writeAddr),
        .WriteData(rf_writeData),
        .WriteEnable(rf_writeEnable)
    );
    
    // Instantiate ALU
    ALU alu (
        .A(alu_A),
        .B(alu_B),
        .ALUControl(alu_op),
        .ALUResult(alu_result),
        .zero(alu_zero)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // FSM state register (sequential)
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end
    
    // FSM control logic (combinational)
    always @(*) begin
        // Default values
        rf_readAddr1 = 5'b0;
        rf_readAddr2 = 5'b0;
        rf_writeAddr = 5'b0;
        rf_writeData = 32'h0;
        rf_writeEnable = 1'b0;
        alu_A = 32'h0;
        alu_B = 32'h0;
        alu_op = 4'h0;
        
        case (state)
            
            IDLE: begin
                next_state = INIT_X1;
            end
            
            // Initialize registers with known values
            INIT_X1: begin
                rf_writeAddr = 5'd1;
                rf_writeData = 32'h10101010;
                rf_writeEnable = 1'b1;
                next_state = INIT_X2;
            end
            
            INIT_X2: begin
                rf_writeAddr = 5'd2;
                rf_writeData = 32'h01010101;
                rf_writeEnable = 1'b1;
                next_state = INIT_X3;
            end
            
            INIT_X3: begin
                rf_writeAddr = 5'd3;
                rf_writeData = 32'h00000005;
                rf_writeEnable = 1'b1;
                next_state = TEST_ADD;
            end
            
            // Test ALU operations
            TEST_ADD: begin
                rf_readAddr1 = 5'd1;
                rf_readAddr2 = 5'd2;
                alu_A = rf_readData1;
                alu_B = rf_readData2;
                alu_op = ADD;
                rf_writeAddr = 5'd4;
                rf_writeData = alu_result;
                rf_writeEnable = 1'b1;
                next_state = TEST_SUB;
            end
            
            TEST_SUB: begin
                rf_readAddr1 = 5'd1;
                rf_readAddr2 = 5'd2;
                alu_A = rf_readData1;
                alu_B = rf_readData2;
                alu_op = SUB;
                rf_writeAddr = 5'd5;
                rf_writeData = alu_result;
                rf_writeEnable = 1'b1;
                next_state = TEST_AND;
            end
            
            TEST_AND: begin
                rf_readAddr1 = 5'd1;
                rf_readAddr2 = 5'd2;
                alu_A = rf_readData1;
                alu_B = rf_readData2;
                alu_op = AND;
                rf_writeAddr = 5'd6;
                rf_writeData = alu_result;
                rf_writeEnable = 1'b1;
                next_state = TEST_OR;
            end
            
            TEST_OR: begin
                rf_readAddr1 = 5'd1;
                rf_readAddr2 = 5'd2;
                alu_A = rf_readData1;
                alu_B = rf_readData2;
                alu_op = OR;
                rf_writeAddr = 5'd7;
                rf_writeData = alu_result;
                rf_writeEnable = 1'b1;
                next_state = TEST_XOR;
            end
            
            TEST_XOR: begin
                rf_readAddr1 = 5'd1;
                rf_readAddr2 = 5'd2;
                alu_A = rf_readData1;
                alu_B = rf_readData2;
                alu_op = XOR;
                rf_writeAddr = 5'd8;
                rf_writeData = alu_result;
                rf_writeEnable = 1'b1;
                next_state = TEST_SLL;
            end
            
            TEST_SLL: begin
                rf_readAddr1 = 5'd1;
                rf_readAddr2 = 5'd3;
                alu_A = rf_readData1;
                alu_B = rf_readData2;
                alu_op = SLL;
                rf_writeAddr = 5'd9;
                rf_writeData = alu_result;
                rf_writeEnable = 1'b1;
                next_state = TEST_SRL;
            end
            
            TEST_SRL: begin
                rf_readAddr1 = 5'd1;
                rf_readAddr2 = 5'd3;
                alu_A = rf_readData1;
                alu_B = rf_readData2;
                alu_op = SRL;
                rf_writeAddr = 5'd10;
                rf_writeData = alu_result;
                rf_writeEnable = 1'b1;
                next_state = TEST_BEQ;
            end
            
            // Conditional write based on ALU Zero flag
            TEST_BEQ: begin
                rf_readAddr1 = 5'd1;
                rf_readAddr2 = 5'd1;
                alu_A = rf_readData1;
                alu_B = rf_readData2;
                alu_op = SUB;
                
                if (alu_zero) begin
                    rf_writeAddr = 5'd11;
                    rf_writeData = 32'h00000001;
                end else begin
                    rf_writeAddr = 5'd11;
                    rf_writeData = 32'h00000000;
                end
                rf_writeEnable = 1'b1;
                next_state = READ_AFTER_WRITE;
            end
            
            // Read-after-write test
            READ_AFTER_WRITE: begin
                rf_writeAddr = 5'd12;
                rf_writeData = 32'hCAFEBABE;
                rf_writeEnable = 1'b1;
                next_state = DONE;
            end
            
            DONE: begin
                next_state = DONE;
            end
            
            default: begin
                next_state = IDLE;
            end
        endcase
    end
    
    // Test sequence
    initial begin
        reset = 1;
        #10 reset = 0;
        #10;
        
        // Run FSM through all states
        #300;
        
        $finish;
    end
    
    // Generate waveforms
    initial begin
        $dumpfile("RF_ALU_FSM_tb.vcd");
        $dumpvars(0, RF_ALU_FSM_tb);
    end

endmodule