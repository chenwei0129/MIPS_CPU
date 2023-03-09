`timescale 1ns/100ps
module hazard_detection_unit(id_rs_i, id_rt_i, ex_rt_i, ex_rd_i, mem_rd_i, ex_mem_read_i, ex_reg_write_i, mem_reg_write_i, branch_i,
                             pc_keep_o, if_id_keep_o, id_ex_zero_o);

  input [`R_WIDTH - 1:0] id_rs_i;
  input [`R_WIDTH - 1:0] id_rt_i;
  input [`R_WIDTH - 1:0] ex_rt_i;
  input [`R_WIDTH - 1:0] ex_rd_i;
  input [`R_WIDTH - 1:0] mem_rd_i;
  input ex_mem_read_i;
  input ex_reg_write_i;
  input mem_reg_write_i;
  input branch_i;
  
  output pc_keep_o;
  output if_id_keep_o;
  output id_ex_zero_o;

  reg pc_keep_o;
  reg if_id_keep_o;
  reg id_ex_zero_o;

  always@(*)begin
    if((ex_mem_read_i && ((ex_rt_i==id_rs_i) || (ex_rt_i==id_rt_i))) ||                     //load use hazard
	   (ex_reg_write_i && ((ex_rd_i==id_rs_i) || (ex_rd_i==id_rt_i)) && branch_i) ||        //first branch
	   (mem_reg_write_i && ((mem_rd_i==id_rs_i) || (mem_rd_i==id_rt_i)) && branch_i))begin  //second branch
	  //stall a bubble
	  pc_keep_o = 1'b1;
	  if_id_keep_o = 1'b1;
	  id_ex_zero_o = 1'b1;
	end
	else begin
	  pc_keep_o = 1'b0;
	  if_id_keep_o = 1'b0;
	  id_ex_zero_o = 1'b0;
	end
  end
endmodule
