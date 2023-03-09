`timescale 1ns/100ps
module MEM_WB_reg(clk_i, rst_n_i,
                  WB_ctrl_d, read_data_d, result_d, rd_d,
                  WB_ctrl_q, read_data_q, result_q, rd_q);

  input clk_i;
  input rst_n_i;

  input [`WB_CTRL_WIDTH - 1:0] WB_ctrl_d;
  input [`WIDTH - 1:0] read_data_d;
  input [`WIDTH - 1:0] result_d;
  input [`R_WIDTH - 1:0] rd_d;

  output reg [`WB_CTRL_WIDTH - 1:0] WB_ctrl_q;
  output reg [`WIDTH - 1:0] read_data_q;
  output reg [`WIDTH - 1:0] result_q;
  output reg [`R_WIDTH - 1:0] rd_q;

  always@(negedge clk_i or negedge rst_n_i)begin
    if(~rst_n_i)begin
	  WB_ctrl_q <= `WB_CTRL_WIDTH'b0;
	  read_data_q <= `WIDTH'b0;
	  result_q <= `WIDTH'b0;
	  rd_q <= `R_WIDTH'b0;
	end
	else begin
	  WB_ctrl_q <= WB_ctrl_d;
	  read_data_q <= read_data_d;
	  result_q <= result_d;
	  rd_q <= rd_d;
	end
  end

endmodule
