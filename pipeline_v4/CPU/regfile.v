`timescale 1ns/100ps
module regfile(clk_i, rst_n_i, write_d, read_addr1_d, read_addr2_d, write_addr_d, write_data_d, read_data1_q, read_data2_q);

  input clk_i;
  input rst_n_i;
  input write_d;
  input [`R_WIDTH - 1:0] read_addr1_d;
  input [`R_WIDTH - 1:0] read_addr2_d;
  input [`R_WIDTH - 1:0] write_addr_d;
  input [`WIDTH - 1:0] write_data_d;
  
  output reg [`WIDTH - 1:0] read_data1_q;
  output reg [`WIDTH - 1:0] read_data2_q;
  
  reg [`WIDTH - 1:0] REGFILE [0:`REGSIZE - 1];

  always@(posedge clk_i or negedge rst_n_i)begin
    if(~rst_n_i)
	    REGFILE[0] <= `WIDTH'b0;
	else if(write_d)
	  REGFILE[write_addr_d] <= write_data_d;
  end

  always@(*)begin
	read_data1_q = REGFILE[read_addr1_d];
	read_data2_q = REGFILE[read_addr2_d];
  end

endmodule
