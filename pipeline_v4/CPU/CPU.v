`timescale 1ns/100ps
/*
`include "def.v"
`include "PC.v"
`include "adder.v"
`include "MUX_32.v"
`include "MUX_pc.v"
`include "IF_ID_reg.v"
`include "regfile.v"
`include "sign_extend.v"
`include "compare.v"
`include "MUX_8.v"
`include "controller.v"
`include "hazard_detection_unit.v"
`include "ID_EX_reg.v"
`include "MUX4_32.v"
`include "ALU.v"
`include "ALUcontrol.v"
`include "MUX_5.v"
`include "forwarding_unit.v"
`include "EX_MEM_reg.v"
`include "MEM_WB_reg.v"
*/
module CPU(clk_i, rst_n_i, ins_i, pc_o, data_from_mem_i, MEM_ctrl_o, mem_write_addr_o, mem_write_data_o);

  input clk_i;
  input rst_n_i;
  input [`WIDTH - 1:0] ins_i;
  input [`WIDTH - 1:0] data_from_mem_i;
  
  output [`ADDRWIDTH - 1:0] pc_o;//to I_memory
  output [`MEM_CTRL_WIDTH - 1:0] MEM_ctrl_o;//to D_memory(write, read)
  output [`WIDTH - 1:0] mem_write_addr_o;//to D_memory(address)
  output [`WIDTH - 1:0] mem_write_data_o;//to D_memory(write data)
  
  wire pc_keep;
  wire [`ADDRWIDTH - 1:0] correct_pc;
  wire [`ADDRWIDTH - 1:0] predict_pc;
  wire [`ADDRWIDTH - 1:0] new_pc;
  wire [`ADDRWIDTH - 1:0] next_addr_mem;
  wire [`ADDRWIDTH - 1:0] branch_addr;
  wire predic_incorrect;
  wire equal;
  wire IF_ID_keep;
  wire [`ADDRWIDTH - 1:0] IF_ID_addr;
  wire [`WIDTH - 1:0] IF_ID_ins;
  wire [`WB_CTRL_WIDTH - 1:0] EX_ctrl_WB;
  wire [`WB_CTRL_WIDTH - 1:0] MEM_ctrl_WB;
  wire [`WB_CTRL_WIDTH - 1:0] WB_ctrl_WB;
  wire [`R_WIDTH - 1:0] reg_write;
  wire [`WIDTH - 1:0] write_reg_data;
  wire [`WIDTH - 1:0] read_data1;
  wire [`WIDTH - 1:0] read_data2;
  wire [`ADDRWIDTH - 1:0] sign_extention_i;
  wire [`ADDRWIDTH - 1:0] sign_extention_o;
  wire [`ALL_CTRL_WIDTH - 1:0] all_ctrl;
  wire ID_EX_zero_ctrl;
  wire [`ALL_CTRL_WIDTH - 1:0] new_all_ctrl;
  wire [`R_WIDTH - 1:0] EX_rt;
  wire [`R_WIDTH - 1:0] EX_rd_new;
  wire [`EX_CTRL_WIDTH - 1:0] EX_ctrl;
  wire [`WIDTH - 1:0] EX_data_1;
  wire [`WIDTH - 1:0] EX_data_2;
  wire [`ADDRWIDTH - 1:0] EX_extention;
  wire [`R_WIDTH - 1:0] EX_rd;
  wire [`FORWARD_WIDTH - 1:0] forwardA;
  wire [`FORWARD_WIDTH - 1:0] forwardB;
  wire [`WIDTH - 1:0] after_forwardA;
  wire [`WIDTH - 1:0] after_forwardB;
  wire [`WIDTH - 1:0] ALU_src2_new;
  wire [`ALUCONTROL_WIDTH - 1:0] alu_control;
  wire [`WIDTH - 1:0] ALU_result;
  wire [`R_WIDTH - 1:0] MEM_rd;
  wire [`MEM_CTRL_WIDTH - 1:0] MEM_ctrl;
  wire [`WIDTH - 1:0] WB_data;
  wire [`WIDTH - 1:0] WB_result;
  
  ///////////////IF stage///////////////
  PC PC(.clk_i  (clk_i),
        .rst_n_i(rst_n_i),
		.keep_i (pc_keep),
		.pc_i   (new_pc),
		.pc_o   (pc_o));
  
  adder adder0(.src1_i  (pc_o),
               .src2_i  (`ADDRWIDTH'd1),
			   .result_o(next_addr_mem));

  MUX_32 MUX0(.a(next_addr_mem),//0 predic correctly
              .b(IF_ID_addr),//1 predic incorrectly
			  .s(predic_incorrect),
			  .o(correct_pc));
  
  sign_extend sign_extend(.in_i (ins_i[`CONS_ADDR]),
                          .out_o(sign_extention_i));
    
  adder adder1(.src1_i  (next_addr_mem),
               .src2_i  (sign_extention_i),
		       .result_o(predict_pc));
  
  MUX_pc MUX7(.a(correct_pc),
              .b(predict_pc),//predic branch
			  .c({next_addr_mem[31:28], 2'b00, ins_i[25:0]}),//jump
			  .s(ins_i[`OP]),
			  .o(new_pc));
  
  ///////////////ID stage///////////////
  IF_ID_reg IF_ID_reg(.clk_i           (clk_i),
                      .rst_n_i         (rst_n_i),
					  .keep_d          (IF_ID_keep),
					  .next_addr_d     (next_addr_mem),
					  .ins_d           (ins_i),
					  .flush_d         (predic_incorrect),
					  .sign_extention_d(sign_extention_i),
                      .next_addr_q     (IF_ID_addr),
					  .ins_q           (IF_ID_ins),
					  .sign_extention_q(sign_extention_o));
  
  regfile regfile(.clk_i       (clk_i),
                  .rst_n_i     (rst_n_i),
				  .write_d     (WB_ctrl_WB[1]),
				  .read_addr1_d(IF_ID_ins[`RS]),
				  .read_addr2_d(IF_ID_ins[`RT]),
				  .write_addr_d(reg_write),
				  .write_data_d(write_reg_data),
				  .read_data1_q(read_data1),
				  .read_data2_q(read_data2));

  MUX4_32 MUX2(.a(read_data1),
               .b(ALU_result),
			   .c(mem_write_addr_o),
			   .d(data_from_mem_i),
			   .s(forwardA),
			   .o(after_forwardA));
  
  MUX4_32 MUX3(.a(read_data2),
               .b(ALU_result),
			   .c(mem_write_addr_o),
			   .d(data_from_mem_i),
			   .s(forwardB),
			   .o(after_forwardB));
  
  compare compare(.data1_i(after_forwardA),
                  .data2_i(after_forwardB),
				  .equal_o(equal));
  
  MUX_8 MUX1(.a(all_ctrl),
             .b(`ALL_CTRL_WIDTH'b0),
			 .s(ID_EX_zero_ctrl),
			 .o(new_all_ctrl));

  controller controller(.opcode_i        (IF_ID_ins[`OP]),
						.equal_i         (equal),
						.predic_incorrect(predic_incorrect),
						.all_ctrl_o      (all_ctrl));

  hazard_detection_unit hazard_detection_unit(.ID_rs_i      (IF_ID_ins[`RS]),
                                              .ID_rt_i      (IF_ID_ins[`RT]),
											  .EX_rt_i      (EX_rt),
											  .EX_mem_read_i(MEM_ctrl[0]),
                                              .pc_keep_o    (pc_keep),
											  .IF_ID_keep_o (IF_ID_keep),
											  .ID_EX_zero_o (ID_EX_zero_ctrl));
  ///////////////EX stage///////////////
  ID_EX_reg ID_EX_reg(.clk_i     (clk_i),
                      .rst_n_i   (rst_n_i),
					  .WB_ctrl_d (new_all_ctrl[7:6]),
					  .MEM_ctrl_d(new_all_ctrl[5:4]),
					  .EX_ctrl_d (new_all_ctrl[3:0]),
					  .data1_d   (after_forwardA),
					  .data2_d   (after_forwardB),
					  .extended_d(sign_extention_o),
					  .rt_d      (IF_ID_ins[`RT]),
					  .rd_d      (IF_ID_ins[`RD]),
                      .WB_ctrl_q (EX_ctrl_WB),
					  .MEM_ctrl_q(MEM_ctrl),
					  .EX_ctrl_q (EX_ctrl),
					  .data1_q   (EX_data_1),
					  .data2_q   (EX_data_2),
					  .extended_q(EX_extention),
					  .rt_q      (EX_rt),
					  .rd_q      (EX_rd));
  
  MUX_32 MUX4(.a(EX_data_2),
              .b(EX_extention),
			  .s(EX_ctrl[3]),
			  .o(ALU_src2_new));

  ALU ALU(.src1_i       (EX_data_1),
          .src2_i       (ALU_src2_new),
		  .ALU_control_i(alu_control),
		  .result_o     (ALU_result));

  ALUcontrol ALUcontrol(.func_i       (EX_extention[5:0]),
                        .ALUOp_i      (EX_ctrl[2:1]),
						.ALU_control_o(alu_control));

  MUX_5 MUX5(.a(EX_rt),
             .b(EX_rd),
			 .s(EX_ctrl[0]),
			 .o(EX_rd_new));

  forwarding_unit forwarding_unit(.MEM_rd_i       (MEM_rd),
                                  .EX_rd_i        (EX_rd_new),
								  .ID_rs_i        (IF_ID_ins[`RS]),
								  .ID_rt_i        (IF_ID_ins[`RT]),
								  .MEM_reg_write_i(MEM_ctrl_WB[1]),
								  .EX_reg_write_i (EX_ctrl_WB[1]),
								  .MEM_mem_read_i (MEM_ctrl_o[0]),
								  .forwardingA_o  (forwardA),
								  .forwardingB_o  (forwardB));
  ///////////////MEM stage///////////////
  EX_MEM_reg EX_MEM_reg(.clk_i     (clk_i),
                        .rst_n_i   (rst_n_i),
						.MEM_ctrl_d(MEM_ctrl),
						.WB_ctrl_d (EX_ctrl_WB),
						.result_d  (ALU_result),
						.src2_d    (EX_data_2),
						.rd_d      (EX_rd_new),
                        .MEM_ctrl_q(MEM_ctrl_o),
						.WB_ctrl_q (MEM_ctrl_WB),
						.result_q  (mem_write_addr_o),
						.src2_q    (mem_write_data_o),
						.rd_q      (MEM_rd));
  
  ///////////////WB stage///////////////
  MEM_WB_reg MEM_WB_reg(.clk_i      (clk_i),
                        .rst_n_i    (rst_n_i),
                        .WB_ctrl_d  (MEM_ctrl_WB),
						.read_data_d(data_from_mem_i),
						.result_d   (mem_write_addr_o),
						.rd_d       (MEM_rd),
                        .WB_ctrl_q  (WB_ctrl_WB),
						.read_data_q(WB_data),
						.result_q   (WB_result),
						.rd_q       (reg_write));

  MUX_32 MUX6(.a(WB_data),
              .b(WB_result),
			  .s(WB_ctrl_WB[0]),
			  .o(write_reg_data));

endmodule
