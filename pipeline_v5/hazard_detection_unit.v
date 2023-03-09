`timescale 1ns/100ps
module hazard_detection_unit(ID_rs_i, ID_rt_i, EX_rt_i, EX_mem_read_i,
                             pc_keep_o, IF_ID_keep_o, ID_EX_zero_o);

  input [`R_WIDTH - 1:0] ID_rs_i;
  input [`R_WIDTH - 1:0] ID_rt_i;
  input [`R_WIDTH - 1:0] EX_rt_i;
  input EX_mem_read_i;
  
  output reg pc_keep_o;
  output reg IF_ID_keep_o;
  output reg ID_EX_zero_o;

  always@(*)begin
    if((EX_mem_read_i && ((EX_rt_i==ID_rs_i) || (EX_rt_i==ID_rt_i))))begin
	  //stall a bubble
	  pc_keep_o = 1'b1;
	  IF_ID_keep_o = 1'b1;
	  ID_EX_zero_o = 1'b1;
	end
	else begin
	  pc_keep_o = 1'b0;
	  IF_ID_keep_o = 1'b0;
	  ID_EX_zero_o = 1'b0;
	end
  end
endmodule
