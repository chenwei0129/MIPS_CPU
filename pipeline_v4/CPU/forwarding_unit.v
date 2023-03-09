`timescale 1ns/100ps
module forwarding_unit(MEM_rd_i, EX_rd_i, ID_rs_i, ID_rt_i, MEM_reg_write_i, EX_reg_write_i, MEM_mem_read_i, forwardingA_o, forwardingB_o);

  input [`R_WIDTH - 1:0] MEM_rd_i;
  input [`R_WIDTH - 1:0] EX_rd_i;
  input [`R_WIDTH - 1:0] ID_rs_i;
  input [`R_WIDTH - 1:0] ID_rt_i;
  input MEM_reg_write_i;
  input EX_reg_write_i;
  input MEM_mem_read_i;

  output [2:0] forwardingA_o;
  output [2:0] forwardingB_o;
  
  assign RS_mem_hazard = (MEM_reg_write_i && MEM_rd_i!=5'b0 && (ID_rs_i==MEM_rd_i));
  assign RS_ex_hazard = (EX_reg_write_i && EX_rd_i!=5'b0 && (ID_rs_i==EX_rd_i));
  assign RS_wb_hazard = RS_mem_hazard && MEM_mem_read_i;
  assign RT_mem_hazard = (MEM_reg_write_i && MEM_rd_i!=5'b0 && (ID_rt_i==MEM_rd_i));
  assign RT_ex_hazard = (EX_reg_write_i && EX_rd_i!=5'b0 && (ID_rt_i==EX_rd_i));
  assign RT_wb_hazard = RT_mem_hazard && MEM_mem_read_i;
  
  assign forwardingA_o = (RS_ex_hazard)?3'b001:
						 (RS_wb_hazard)?3'b011:
                         (RS_mem_hazard)?3'b010:
						 3'b00;
  assign forwardingB_o = (RT_ex_hazard)?3'b001:
						 (RT_wb_hazard)?3'b011:
                         (RT_mem_hazard)?3'b010:
						 3'b00;

endmodule
