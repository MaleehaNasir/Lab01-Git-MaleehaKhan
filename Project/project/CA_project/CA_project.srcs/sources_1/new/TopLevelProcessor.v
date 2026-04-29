`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/28/2026 03:56:46 PM
// Design Name: 
// Module Name: TopLevelProcessor
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
module TopLevelProcessor(
    input clk,
    input reset,
    input [15:0] switches_in,
    output [15:0] leds_out,    
    output [31:0] PC_out,
    output [31:0] ALU_out
);

wire [31:0] PC;
wire [31:0] next_PC;
wire [31:0] upd_PC;       
wire [31:0] branch_tar; 

wire [31:0] instruction;
wire [6:0]  opcode  = instruction[6:0];
wire [4:0]  rd      = instruction[11:7];
wire [2:0]  funct3  = instruction[14:12];
wire [4:0]  rs1     = instruction[19:15];
wire [4:0]  rs2     = instruction[24:20];
wire [6:0]  funct7  = instruction[31:25];
wire regwrite, alusrc, memread, memwrite, memtoreg, branch;
wire [1:0] aluop;
wire [31:0] readData1, readData2;
wire [31:0] imm;
wire [31:0] ALU_B;         
wire [3:0]  alucontrol;
wire [31:0] ALUResult;
wire zero;
wire less;
wire jump;
wire jalr;
wire PCSrc;
wire lui = (opcode == 7'b0110111);

//assign PCSrc = branch & zero;
wire branch_taken;
assign branch_taken = branch & (
    (funct3 == 3'b000 &&  zero) | //beq
    (funct3 == 3'b001 && ~zero) | //bne
    (funct3 == 3'b100 &&  less) | //blt
    (funct3 == 3'b101 && ~less)); //bge
assign PCSrc = branch_taken | jump | jalr;
wire dataMemRead, dataMemWrite, LEDWrite, SwitchReadEnable;
wire [31:0] dataMemReadData;
wire [31:0] switchReadData;
wire [31:0] ledReadData;
wire [31:0] memReadData = SwitchReadEnable ? switchReadData : dataMemReadData;
wire [31:0] writeBackData;


ProgramCounter pc_reg(
    .clk(clk),
    .reset(reset),
    .next_PC(next_PC),
    .PC(PC)
);
instructionMemory instr_mem (
    .instAddress(PC),
    .instruction(instruction)
);
pcAdder pc_plus4 (
    .PC(PC),
    .upd_PC(upd_PC)
);
immGen imm_gen (
    .instruction(instruction),
    .imm(imm)
);
branchAdder branch_adder (
    .PC(PC),
    .imm(imm),
    .branch_tar(branch_tar)
);
 
wire [31:0] jump_target;
assign jump_target = jalr ? {ALUResult[31:1], 1'b0} : branch_tar;
 
MUX pc_mux (
    .in0(upd_PC),
    .in1(jump_target),
    .select(PCSrc),
    .out(next_PC)
);
MainControl control_unit (
    .opcode(opcode),
    .regwrite(regwrite),
    .alusrc(alusrc),
    .memread(memread),
    .memwrite(memwrite),
    .memtoreg(memtoreg),
    .branch(branch),
    .jump(jump),
    .jalr(jalr),
    .aluop(aluop)
);
RegisterFile register_file (
    .clk(clk),
    .rst(reset),
    .WriteEnable(regwrite),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .WriteData(writeBackData),
    .readdata1(readData1),
    .readdata2(readData2)
);
 
MUX alu_src_mux (
    .in0(readData2),
    .in1(imm),
    .select(alusrc),
    .out(ALU_B)
);
 
alu_control alu_control_unit (
    .ALUOp(aluop),
    .funct3(funct3),
    .funct7_5(funct7[6]),    // funct7[6] = instruction[31:25] bit6 = instruction[30] = actual funct7 bit5
    .ALUControl(alucontrol)
);
 
ALU_module alu (
    .A(readData1),
    .B(ALU_B),
    .ALUControl(alucontrol),
    .ALUResult(ALUResult),
    .zero(zero),
    .less(less)
);
 
address_decoder addr_decoder (
    .address(ALUResult[9:0]),
    .dataMemRead(dataMemRead),
    .dataMemWrite(dataMemWrite),
    .LEDWrite(LEDWrite),
    .SwitchReadEnable(SwitchReadEnable)
);
 
data_memory_mod data_memory (
    .clk(clk),
    .memWrite(memwrite & dataMemWrite),
    .address(ALUResult[9:0]),
    .writeData(readData2),
    .readData(dataMemReadData)
);
 
switches sw_inst (
    .clk(clk),
    .rst(reset),
    .btns(16'b0),
    .switches(switches_in),
    .readEnable(SwitchReadEnable),
    .writeData(32'b0),
    .writeEnable(1'b0),
    .readData(switchReadData)
);
 
leds led_inst (
    .clk(clk),
    .rst(reset),
    .btns(16'b0),
    .writeData(readData2),
    .writeEnable(memwrite & LEDWrite),
    .readEnable(1'b0),
    .memAddress(30'b0),
    .switches(switches_in),
    .readData(ledReadData)
);
 
 
assign writeBackData =
    (lui)            ? imm :
    (memtoreg)        ? memReadData :
    (jump || jalr)    ? upd_PC :
                        ALUResult;
 
 
assign PC_out  = PC;
assign ALU_out = lui ? imm : ALUResult;
assign leds_out = ledReadData[15:0];
 
endmodule
