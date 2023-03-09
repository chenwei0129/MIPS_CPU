`timescale 1ns/100ps
module controller(rst_n_i, opcode_i, equal_i, Branch_o, branch_or_not_o, all_ctrl_o);

  input rst_n_i;
  input [`OP_WIDTH - 1:0] opcode_i;
  input equal_i;
  
  output reg Branch_o;
  output branch_or_not_o;
  output [`ALL_CTRL_WIDTH - 1:0] all_ctrl_o;
  
  reg RegWrite;
  reg MemtoReg;
  reg MemWrite;
  reg MemRead;
  reg ALUsrc;
  reg [`ALUOp_WIDTH - 1:0] ALUOp;
  reg RegDst;
  
  assign branch_or_not_o = equal_i & Branch_o;
  
  assign all_ctrl_o = {RegWrite,
                       MemtoReg,
					   MemWrite,
					   MemRead,
					   ALUsrc,
					   ALUOp,
					   RegDst};
  
  always@(*)begin
    Branch_o = (~rst_n_i)?1'b0:
	           (opcode_i==6'b000100)?1'b1:
			   1'b0;
	
	RegWrite = (opcode_i==6'b000000)?1'b1://R
	           (opcode_i==6'b100011)?1'b1://LW
			   (opcode_i==6'b001000)?1'b1://ADDI
			   1'b0;//SW,BR
	
	MemtoReg = (opcode_i==6'b000000)?1'b1://R
	           (opcode_i==6'b100011)?1'b0://LW
			   (opcode_i==6'b001000)?1'b1://ADDI
			   1'b0;//SW,BR(don't care)
	
	MemWrite = (opcode_i==6'b101011)?1'b1://SW
			   1'b0;//other
    
	MemRead = (opcode_i==6'b100011)?1'b1://LW
	          1'b0;//other
	
	ALUsrc = (opcode_i==6'b000000)?1'b0://R
	         (opcode_i==6'b100011)?1'b1://LW
			 (opcode_i==6'b101011)?1'b1://SW
			 (opcode_i==6'b001000)?1'b1://ADDI
			 1'b0;//BR(don't care)
	
    ALUOp = (opcode_i==6'b000000)?`ALUOp_WIDTH'b10://R
	        (opcode_i==6'b100011)?`ALUOp_WIDTH'b00://LW
			(opcode_i==6'b101011)?`ALUOp_WIDTH'b00://SW
			(opcode_i==6'b001000)?`ALUOp_WIDTH'b00://ADDI
			(opcode_i==6'b000100)?`ALUOp_WIDTH'b01://BR
			`ALUOp_WIDTH'b11;
			
	RegDst = (opcode_i==6'b000000)?1'b1://R
	         (opcode_i==6'b100011)?1'b0://LW
			 (opcode_i==6'b001000)?1'b0://ADDI
			 1'b0;//SW,BR(don't care)
  end

endmodule
