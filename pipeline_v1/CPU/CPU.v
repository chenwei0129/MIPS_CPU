`timescale 1ns/100ps
/*
`include "def.v"
`include "PC.v"
`include "CLA_adder.v"
`include "adder.v"
`include "MUX_32.v"
`include "if_id_reg.v"
`include "regfile.v"
`include "sign_extend.v"
`include "compare.v"
`include "MUX_8.v"
`include "controller.v"
`include "hazard_detection_unit.v"
`include "id_ex_reg.v"
`include "MUX3_32.v"
`include "ALU.v"
`include "ALUcontrol.v"
`include "MUX_5.v"
`include "forwarding_unit.v"
`include "ex_mem_reg.v"
`include "mem_wb_reg.v"
*/
module CPU(clk_i, rst_n_i, ins_i, pc_o, data_from_mem_i, mem_ctrl_1_o, result_o, src2_o);

  input clk_i;
  input rst_n_i;
  input [`WIDTH - 1:0] ins_i;
  input [`WIDTH - 1:0] data_from_mem_i;
  
  output [`ADDRWIDTH - 1:0] pc_o;
  output [`MEM_CTRL_WIDTH - 1:0] mem_ctrl_1_o;
  output [`WIDTH - 1:0] result_o;
  output [`WIDTH - 1:0] src2_o;
  
  wire pc_keep;
  wire [`ADDRWIDTH - 1:0] new_pc;
  wire [`MEM_ADDR_WIDTH - 1:0] next_addr;
  wire [`MEM_ADDR_WIDTH - 1:0] branch_addr;
  wire branch_or_not;
  wire equal;
  wire branch;
  wire if_id_keep;
  wire [`ADDRWIDTH - 1:0] if_id_addr;
  wire [`WIDTH - 1:0] ins;
  wire [`WB_CTRL_WIDTH - 1:0] wb_ctrl;
  wire [`WB_CTRL_WIDTH - 1:0] wb_ctrl_1;
  wire [`WB_CTRL_WIDTH - 1:0] wb_ctrl_2;
  wire [`R_WIDTH - 1:0] write_reg;
  wire [`WIDTH - 1:0] write_data;
  wire [`WIDTH - 1:0] read_data1;
  wire [`WIDTH - 1:0] read_data2;
  wire [`ADDRWIDTH - 1:0] sign_extention;
  wire [`ALL_CTRL_WIDTH - 1:0] all_ctrl;
  wire id_ex_zero;
  wire [`ALL_CTRL_WIDTH - 1:0] new_all_ctrl;
  wire [`R_WIDTH - 1:0] ex_rt;
  wire [`R_WIDTH - 1:0] ex_rd_new;
  wire [`EX_CTRL_WIDTH - 1:0] ex_ctrl;
  wire [`WIDTH - 1:0] ex_data_1;
  wire [`WIDTH - 1:0] ex_data_2;
  wire [`ADDRWIDTH - 1:0] ex_extention;
  wire [`R_WIDTH - 1:0] ex_rs;
  wire [`R_WIDTH - 1:0] ex_rd;
  wire [`FORWARD_WIDTH - 1:0] forwardA;
  wire [`FORWARD_WIDTH - 1:0] forwardB;
  wire [`WIDTH - 1:0] ALU_src1;
  wire [`WIDTH - 1:0] ALU_src2;
  wire [`WIDTH - 1:0] ALU_src2_new;
  wire [`ALUCONTROL_WIDTH - 1:0] alu_control;
  wire [`WIDTH - 1:0] ALU_result;
  wire [`R_WIDTH - 1:0] mem_rd;
  wire [`MEM_CTRL_WIDTH - 1:0] mem_ctrl;
  wire [`MEM_CTRL_WIDTH - 1:0] mem_ctrl_1;
  wire [`WIDTH - 1:0] wb_data;
  wire [`WIDTH - 1:0] wb_result;
  wire [`WIDTH - 1:0] result_o;
  wire [`WIDTH - 1:0] src2_o;
  
  ///////////////IF stage///////////////
  PC PC(.clk_i  (clk_i),
        .rst_n_i(rst_n_i),
		.keep_i (pc_keep),
		.pc_i   (new_pc),
		.pc_o   (pc_o));
  
  adder adder0(.src1_i  (pc_o[6:0]),
               .src2_i  (`MEM_ADDR_WIDTH'd1),
			   .result_o(next_addr));

  MUX_32 MUX0(.a({25'd0, next_addr}),
              .b({25'd0, branch_addr}),
			  .s(branch_or_not),
			  .o(new_pc));
  ///////////////ID stage///////////////
  if_id_reg if_id_reg(.clk_i       (clk_i),
                      .rst_n_i     (rst_n_i),
					  .if_id_keep_d(if_id_keep),
					  .next_addr_d ({25'd0, next_addr}),
					  .ins_d       (ins_i),
					  .flush_d     (branch_or_not),
                      .next_addr_q (if_id_addr),
					  .ins_q       (ins));
  
  regfile regfile(.clk_i       (clk_i),
                  .rst_n_i     (rst_n_i),
				  .regwrite_d  (wb_ctrl_2[1]),
				  .read_reg1_d (ins[`RS]),
				  .read_reg2_d (ins[`RT]),
				  .write_reg_d (write_reg),
				  .write_data_d(write_data),
				  .read_data1_q(read_data1),
				  .read_data2_q(read_data2));

  sign_extend sign_extend(.in_i (ins[`CONS_ADDR]),
                          .out_o(sign_extention));
  
  compare compare(.data1_i(read_data1),
                  .data2_i(read_data2),
				  .equal_o(equal));

  adder adder1(.src1_i  (sign_extention[6:0]),
               .src2_i  (if_id_addr[6:0]),
			   .result_o(branch_addr));

  MUX_8 MUX1(.a(all_ctrl),
             .b(`ALL_CTRL_WIDTH'b0),
			 .s(id_ex_zero),
			 .o(new_all_ctrl));

  controller controller(.rst_n_i        (rst_n_i),
                        .opcode_i       (ins[`OP]),
						.equal_i        (equal),
                        .Branch_o       (branch),
						.branch_or_not_o(branch_or_not),
						.all_ctrl_o     (all_ctrl));

  hazard_detection_unit hazard_detection_unit(.id_rs_i        (ins[`RS]),
                                              .id_rt_i        (ins[`RT]),
											  .ex_rt_i        (ex_rt),
											  .ex_rd_i        (ex_rd_new),
											  .mem_rd_i       (mem_rd),
											  .ex_mem_read_i  (mem_ctrl[0]),
											  .ex_reg_write_i (wb_ctrl[1]),
											  .mem_reg_write_i(wb_ctrl_1[1]),
											  .branch_i       (branch),
                                              .pc_keep_o      (pc_keep),
											  .if_id_keep_o   (if_id_keep),
											  .id_ex_zero_o   (id_ex_zero));
  ///////////////EX stage///////////////
  id_ex_reg id_ex_reg(.clk_i     (clk_i),
                      .rst_n_i   (rst_n_i),
					  .wb_ctrl_d (new_all_ctrl[7:6]),
					  .mem_ctrl_d(new_all_ctrl[5:4]),
					  .ex_ctrl_d (new_all_ctrl[3:0]),
					  .data1_d   (read_data1),
					  .data2_d   (read_data2),
					  .extended_d(sign_extention),
					  .rs_d      (ins[`RS]),
					  .rt_d      (ins[`RT]),
					  .rd_d      (ins[`RD]),
                      .wb_ctrl_q (wb_ctrl),
					  .mem_ctrl_q(mem_ctrl),
					  .ex_ctrl_q (ex_ctrl),
					  .data1_q   (ex_data_1),
					  .data2_q   (ex_data_2),
					  .extended_q(ex_extention),
					  .rs_q      (ex_rs),
					  .rt_q      (ex_rt),
					  .rd_q      (ex_rd));

  MUX3_32 MUX2(.a(ex_data_1),
               .b(write_data),
			   .c(result_o),
			   .s(forwardA),
			   .o(ALU_src1));

  MUX3_32 MUX3(.a(ex_data_2),
               .b(write_data),
			   .c(result_o),
			   .s(forwardB),
			   .o(ALU_src2));

  MUX_32 MUX4(.a(ALU_src2),
              .b(ex_extention),
			  .s(ex_ctrl[3]),
			  .o(ALU_src2_new));

  ALU ALU(.src1_i       (ALU_src1),
          .src2_i       (ALU_src2_new),
		  .ALU_control_i(alu_control),
		  .result_o     (ALU_result));

  ALUcontrol ALUcontrol(.func_i       (ex_extention[5:0]),
                        .ALUOp_i      (ex_ctrl[2:1]),
						.ALU_control_o(alu_control));

  MUX_5 MUX5(.a(ex_rt),
             .b(ex_rd),
			 .s(ex_ctrl[0]),
			 .o(ex_rd_new));

  forwarding_unit forwarding_unit(.mem_rd_i       (mem_rd),
                                  .wb_rd_i        (write_reg),
								  .ex_rs_i        (ex_rs),
								  .ex_rt_i        (ex_rt),
								  .mem_reg_write_i(wb_ctrl_1[1]),
								  .wb_reg_write_i (wb_ctrl_2[1]),
								  .forwardingA_o  (forwardA),
								  .forwardingB_o  (forwardB));
  ///////////////MEM stage///////////////
  ex_mem_reg ex_mem_reg(.clk_i     (clk_i),
                        .rst_n_i   (rst_n_i),
						.mem_ctrl_d(mem_ctrl),
						.wb_ctrl_d (wb_ctrl),
						.result_d  (ALU_result),
						.src_d     (ALU_src2),
						.rd_d      (ex_rd_new),
                        .mem_ctrl_q(mem_ctrl_1_o),
						.wb_ctrl_q (wb_ctrl_1),
						.result_q  (result_o),
						.src_q     (src2_o),
						.rd_q      (mem_rd));
  
  ///////////////WB stage///////////////
  mem_wb_reg mem_wb_reg(.clk_i      (clk_i),
                        .rst_n_i    (rst_n_i),
                        .wb_ctrl_d  (wb_ctrl_1),
						.read_data_d(data_from_mem_i),
						.result_d   (result_o),
						.rd_d       (mem_rd),
                        .wb_ctrl_q  (wb_ctrl_2),
						.read_data_q(wb_data),
						.result_q   (wb_result),
						.rd_q       (write_reg));

  MUX_32 MUX6(.a(wb_data),
              .b(wb_result),
			  .s(wb_ctrl_2[0]),
			  .o(write_data));

endmodule
