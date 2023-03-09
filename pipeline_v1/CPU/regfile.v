`timescale 1ns/100ps
module regfile(clk_i, rst_n_i, regwrite_d, read_reg1_d, read_reg2_d, write_reg_d, write_data_d, read_data1_q, read_data2_q);

  input clk_i;
  input rst_n_i;
  input regwrite_d;
  input [`R_WIDTH - 1:0] read_reg1_d;
  input [`R_WIDTH - 1:0] read_reg2_d;
  input [`R_WIDTH - 1:0] write_reg_d;
  input [`WIDTH - 1:0] write_data_d;
  
  output reg [`WIDTH - 1:0] read_data1_q;
  output reg [`WIDTH - 1:0] read_data2_q;
  
  reg [`WIDTH - 1:0] REGFILE [0:`REGSIZE - 1];

  always@(posedge clk_i or negedge rst_n_i)begin
    if(~rst_n_i)
	    REGFILE[0] <= `WIDTH'b0;
	else if(regwrite_d)
	  REGFILE[write_reg_d] <= write_data_d;
  end

  always@(*)begin
	read_data1_q = REGFILE[read_reg1_d];
	read_data2_q = REGFILE[read_reg2_d];
  end

endmodule
