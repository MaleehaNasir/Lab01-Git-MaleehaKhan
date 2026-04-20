`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/26/2026 10:44:05 AM
// Design Name: 
// Module Name: testbench
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


module testbench();
    reg [6:0] opcode;
    wire regwrite, alusrc, memread, memwrite, memtoreg, branch;
    wire [1:0] aluop;
    reg [1:0] aluop_in;
    reg [2:0] funct3;
    reg[6:0] funct7;
    wire[3:0]alucontrol;
    
    MainControl main(.opcode(opcode), .regwrite(regwrite), .alusrc(alusrc), .memread(memread),
                     .memwrite(memwrite), .memtoreg(memtoreg), .branch(branch), .aluop(aluop));
    
    ALUControl ac(.aluop(aluop_in), .funct3(funct3), .funct7(funct7), .alucontrol(alucontrol));
    
    initial begin 
    
    //rtype
    opcode=7'b0110011; #10;
     
    //addi
    opcode = 7'b0010011; #10;
    
    //load
    opcode = 7'b0000011; #10;
    
    //s type
    opcode = 7'b0100011; #10;
    
    //beq
    opcode = 7'b1100011; #10;
    
    // ALU Control - Load/Store (ADD)
        aluop_in = 2'b00; funct3 = 3'b000; funct7 = 7'b0000000; #10;

        // ALU Control - BEQ (SUB)
        aluop_in = 2'b01; funct3 = 3'b000; funct7 = 7'b0000000; #10;

        // ALU Control - ADD
        aluop_in = 2'b10; funct3 = 3'b000; funct7 = 7'b0000000; #10;

        // ALU Control - SUB
        aluop_in = 2'b10; funct3 = 3'b000; funct7 = 7'b0100000; #10;

        // ALU Control - SLL
        aluop_in = 2'b10; funct3 = 3'b001; funct7 = 7'b0000000; #10;

        // ALU Control - SRL
        aluop_in = 2'b10; funct3 = 3'b101; funct7 = 7'b0000000; #10;

        // ALU Control - OR
        aluop_in = 2'b10; funct3 = 3'b110; funct7 = 7'b0000000; #10;

        // ALU Control - AND
        aluop_in = 2'b10; funct3 = 3'b111; funct7 = 7'b0000000; #10;

        // ALU Control - XOR
        aluop_in = 2'b10; funct3 = 3'b100; funct7 = 7'b0000000; #10;

        // ALU Control - ADDI
        aluop_in = 2'b11; funct3 = 3'b000; funct7 = 7'b0000000; #10;


    
    end
    
                     

    
    
    
    
endmodule
