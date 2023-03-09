`timescale 1ns/100ps
module control(clk, opcode, rst_n, RegDst,Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUsrc, RegWrite);
 
  input clk;
  input [`OP_WIDTH - 1:0] opcode;
  input rst_n;
  
  output RegDst;
  output Branch;
  output MemRead;
  output MemtoReg;
  output reg [`ALUOp_WIDTH - 1:0] ALUOp;
  output MemWrite;
  output ALUsrc;
  output RegWrite;
  
  wire op_ALUsrc = (opcode==6'b000001 || opcode==6'b000010 || opcode==6'b000100);
  wire op_reg_write = (opcode==6'b000000 || opcode==6'b000001 || opcode==6'b000100);
  
  assign RegDst = (opcode==6'b000000)?1'b1:1'b0;
  assign Branch = (opcode==6'b000011)?1'b1:1'b0;
  assign MemRead = (opcode==6'b000001)?1'b1:1'b0;
  assign MemtoReg = (opcode==6'b000001)?1'b1:1'b0;
  assign MemWrite = (opcode==6'b000010)?1'b1:1'B0;
  assign ALUsrc = (op_ALUsrc)?1'b1:1'b0;
  assign RegWrite = (op_reg_write)?1'b1:1'b0;
  
  always@(*)begin
    ALUOp = (opcode==6'b000000)?`ALUOp_WIDTH'b10://R
	        (opcode==6'b000001)?`ALUOp_WIDTH'b00://LW
			(opcode==6'b000010)?`ALUOp_WIDTH'b00://SW
			(opcode==6'b000100)?`ALUOp_WIDTH'b00://ADDI
			(opcode==6'b000011)?`ALUOp_WIDTH'b01://BR
			`ALUOp_WIDTH'b11;
	
  end

endmodule
