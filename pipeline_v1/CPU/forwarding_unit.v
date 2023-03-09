`timescale 1ns/100ps
module forwarding_unit(mem_rd_i, wb_rd_i, ex_rs_i, ex_rt_i, mem_reg_write_i, wb_reg_write_i, forwardingA_o, forwardingB_o);

  input [`R_WIDTH - 1:0] mem_rd_i;
  input [`R_WIDTH - 1:0] wb_rd_i;
  input [`R_WIDTH - 1:0] ex_rs_i;
  input [`R_WIDTH - 1:0] ex_rt_i;
  input mem_reg_write_i;
  input wb_reg_write_i;

  output [1:0] forwardingA_o;
  output [1:0] forwardingB_o;
  
  assign RS_ex_hazard = (mem_reg_write_i && mem_rd_i!=5'b0 && (ex_rs_i==mem_rd_i));
  assign RS_mem_hazard = (wb_reg_write_i && wb_rd_i!=5'b0 && (ex_rs_i==wb_rd_i));
  assign RT_ex_hazard = (mem_reg_write_i && mem_rd_i!=5'b0 && (ex_rt_i==mem_rd_i));
  assign RT_mem_hazard = (wb_reg_write_i && wb_rd_i!=5'b0 && (ex_rt_i==wb_rd_i));
  
  assign forwardingA_o = (RS_ex_hazard)?2'b10:
                         (RS_mem_hazard)?2'b01:
						 2'b00;
  assign forwardingB_o = (RT_ex_hazard)?2'b10:
                         (RT_mem_hazard)?2'b01:
						 2'b00;

endmodule
