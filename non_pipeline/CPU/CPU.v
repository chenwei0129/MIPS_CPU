/*
`include "../def.v"
`include "PC.v"
`include "regfile.v"
`include "ALU.v"
`include "adder.v"
`include "sign_extend.v"
`include "MUX_5.v"
`include "MUX_32.v"
`include "control.v"
`include "ALUcontrol.v"
*/
`timescale 1ns/100ps

module CPU(clk, rst_n, ins, read_data, pc_o, MemWrite, MemRead, result, read_data2);

  input clk;
  input rst_n;
  input [`WIDTH - 1:0] ins;//from I_memory
  input [`WIDTH - 1:0] read_data;//from D_memory
  
  output [`ADDRWIDTH - 1:0] pc_o;//to I_memory
  output MemWrite;//to D_memory
  output MemRead;//to D_memory
  output [`WIDTH - 1:0] result;//to D_memory
  output [`WIDTH - 1:0] read_data2;//to D_memory
  
  wire [`ADDRWIDTH - 1:0] pc_i;
  wire [`R_WIDTH - 1:0] write_reg;
  wire [`WIDTH - 1:0] write_data;
  wire [`WIDTH - 1:0] read_data1;
  wire [`WIDTH - 1:0] source2;
  wire [`ALUCONTROL_WIDTH - 1:0] ALU_control;
  wire [`WIDTH - 1:0] extend_o;
  wire [7:0] pc_0;
  wire [7:0] pc_1;
  wire [`ALUOp_WIDTH - 1:0] ALUOp;
  
  PC PC(.clk   (clk),
        .rst_n (rst_n),
		.pc_i  (pc_i),
		.pc_o  (pc_o));

  regfile regfile(.clk       (clk),
                  .rst_n     (rst_n),
				  .regwrite  (RegWrite),
				  .read_reg1 (ins[`RS]),
				  .read_reg2 (ins[`RT]),
				  .write_reg (write_reg),
				  .write_data(write_data),
				  .read_data1(read_data1),
				  .read_data2(read_data2));

  ALU ALU(.src1       (read_data1),
          .src2       (source2),
		  .ALU_control(ALU_control),
		  .zero       (zero),
		  .result     (result));

  adder adder0(.src1  (pc_o[7:0]),
               .src2  (8'd1),
			   .result(pc_0));

  adder adder1(.src1  (pc_0),
               .src2  (extend_o[7:0]),
			   .result(pc_1));

  sign_extend sign_extend(.in (ins[`CONS_ADDR]),
                          .out(extend_o));

  MUX_5 MUX0(.a(ins[`RT]),
             .b(ins[`RD]),
		     .s(RegDst),
		     .o(write_reg));

  MUX_32 MUX1(.a(read_data2),
              .b(extend_o),
		      .s(ALUsrc),
		      .o(source2));

  MUX_32 MUX2(.a({24'b0, pc_0}),
              .b({24'b0, pc_1}),
		      .s(and_branch),
		      .o(pc_i));

  MUX_32 MUX3(.a(result),
              .b(read_data),
		      .s(MemtoReg),
		      .o(write_data));

  control control(.clk     (clk),
                  .opcode  (ins[`OP]),
                  .rst_n   (rst_n),
				  .RegDst  (RegDst),
				  .Branch  (Branch),
				  .MemRead (MemRead),
				  .MemtoReg(MemtoReg),
				  .ALUOp   (ALUOp),
				  .MemWrite(MemWrite),
				  .ALUsrc  (ALUsrc),
				  .RegWrite(RegWrite));

  ALUcontrol ALUcontrol(.func       (ins[`FUNC]),
                        .ALUOp      (ALUOp),
				        .ALU_control(ALU_control));

  and(and_branch, Branch, zero);

endmodule
