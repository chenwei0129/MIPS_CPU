`timescale 1ns/100ps
module ex_mem_reg(clk_i, rst_n_i, mem_ctrl_d, wb_ctrl_d, result_d, src_d, rd_d,
                  mem_ctrl_q, wb_ctrl_q, result_q, src_q, rd_q);

  input clk_i;
  input rst_n_i;

  input [`MEM_CTRL_WIDTH-1:0]mem_ctrl_d;
  input [`WB_CTRL_WIDTH-1:0]wb_ctrl_d;
  input [`WIDTH - 1:0] result_d;
  input [`WIDTH - 1:0] src_d;
  input [`R_WIDTH - 1:0] rd_d;

  output reg [`MEM_CTRL_WIDTH-1:0]mem_ctrl_q;
  output reg [`WB_CTRL_WIDTH-1:0]wb_ctrl_q;
  output reg [`WIDTH - 1:0] result_q;
  output reg [`WIDTH - 1:0] src_q;
  output reg [`R_WIDTH - 1:0] rd_q;
  
  always@(negedge clk_i or negedge rst_n_i)begin
    if(~rst_n_i)begin
	  mem_ctrl_q <= `MEM_CTRL_WIDTH'b0;
	  wb_ctrl_q <= `WB_CTRL_WIDTH'b0;
	  result_q <= `WIDTH'b0;
	  src_q <= `WIDTH'b0;
	  rd_q <= `R_WIDTH'b0;
	end
	else begin
	  mem_ctrl_q <= mem_ctrl_d;
	  wb_ctrl_q <= wb_ctrl_d;
	  result_q <= result_d;
	  src_q <= src_d;
	  rd_q <= rd_d;
	end
  end

endmodule