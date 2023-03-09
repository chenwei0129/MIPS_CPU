`timescale 1ns/100ps
module ID_EX_reg (clk_i, rst_n_i, WB_ctrl_d, MEM_ctrl_d, EX_ctrl_d, data1_d, data2_d, extended_d, rt_d, rd_d,
                  WB_ctrl_q, MEM_ctrl_q, EX_ctrl_q,  data1_q, data2_q, extended_q, rt_q, rd_q);

  input clk_i;
  input rst_n_i;
  input [`WB_CTRL_WIDTH-1:0] WB_ctrl_d;
  input [`MEM_CTRL_WIDTH-1:0] MEM_ctrl_d;
  input [`EX_CTRL_WIDTH-1:0] EX_ctrl_d;
  input [`WIDTH-1:0] data1_d;
  input [`WIDTH-1:0] data2_d;
  input [`WIDTH-1:0] extended_d;
  input [`R_WIDTH-1:0] rt_d;
  input [`R_WIDTH-1:0] rd_d;

  output reg [`WB_CTRL_WIDTH-1:0] WB_ctrl_q;
  output reg [`MEM_CTRL_WIDTH-1:0] MEM_ctrl_q;
  output reg [`EX_CTRL_WIDTH-1:0] EX_ctrl_q;
  output reg [`WIDTH-1:0] data1_q;
  output reg [`WIDTH-1:0] data2_q;
  output reg [`WIDTH-1:0] extended_q;
  output reg [`R_WIDTH-1:0] rt_q;
  output reg [`R_WIDTH-1:0] rd_q;
  
  always@(negedge clk_i or negedge rst_n_i)begin
    if(~rst_n_i)begin
	  WB_ctrl_q <= `WB_CTRL_WIDTH'b0;
      MEM_ctrl_q <= `MEM_CTRL_WIDTH'b0;
      EX_ctrl_q <= `EX_CTRL_WIDTH'b0;
      data1_q <= `WIDTH'b0;
      data2_q <= `WIDTH'b0;
      extended_q <= `WIDTH'b0;
      rt_q <= `R_WIDTH'b0;
      rd_q <= `R_WIDTH'b0;
	end
	else begin
	  WB_ctrl_q <= WB_ctrl_d;
      MEM_ctrl_q <= MEM_ctrl_d;
      EX_ctrl_q <= EX_ctrl_d;
      data1_q <= data1_d;
      data2_q <= data2_d;
      extended_q <= extended_d;
      rt_q <= rt_d;
      rd_q <= rd_d;
	end
  end

endmodule
