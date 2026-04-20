`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2026 10:27:52 PM
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
wire        zero;
wire PCSrc;
assign PCSrc = branch & zero;
wire dataMemRead, dataMemWrite, LEDWrite, SwitchReadEnable;
wire [31:0] memReadData;
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
    .inst(instruction),
    .imm(imm)
);
branchAdder branch_adder (
    .PC(PC),
    .imm(imm),
    .branch_tar(branch_tar)
);
MUX pc_mux (
    .in0(upd_PC),
    .in1(branch_tar),
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
    .readData1(readData1),
    .readData2(readData2)
);

MUX alu_src_mux (
    .in0(readData2),
    .in1(imm),
    .select(alusrc),
    .out(ALU_B)
);

ALUControl alu_control_unit (
    .aluop(aluop),
    .funct3(funct3),
    .funct7(funct7),
    .alucontrol(alucontrol)
);

ALU_module alu (
    .A(readData1),
    .B(ALU_B),
    .ALUControl(alucontrol),
    .ALUResult(ALUResult),
    .zero(zero)
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
    .readData(memReadData)
);

MUX wb_mux (
    .in0(ALUResult),
    .in1(memReadData),
    .select(memtoreg),
    .out(writeBackData)
);

assign PC_out  = PC;
assign ALU_out = ALUResult;

endmodule
