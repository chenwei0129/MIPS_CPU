`timescale 1ns/100ps
module regfile(clk, rst_n, regwrite, read_reg1, read_reg2, write_reg, write_data, read_data1, read_data2);

  input clk;
  input rst_n;
  input regwrite;
  input [`R_WIDTH - 1:0] read_reg1;
  input [`R_WIDTH - 1:0] read_reg2;
  input [`R_WIDTH - 1:0] write_reg;
  input [`WIDTH - 1:0] write_data;
  
  output reg [`WIDTH - 1:0] read_data1;
  output reg [`WIDTH - 1:0] read_data2;
  
  reg [`WIDTH - 1:0] REGFILE [0:`REGSIZE - 1];

  always@(posedge clk)begin
    if(~rst_n)
	    REGFILE[0] <= `WIDTH'b0;
	else if(regwrite)
	  REGFILE[write_reg] <= write_data;
  end

  always@(*)begin
	read_data1 = REGFILE[read_reg1];
	read_data2 = REGFILE[read_reg2];
  end

endmodule
