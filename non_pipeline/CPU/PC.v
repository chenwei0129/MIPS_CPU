`timescale 1ns/100ps
module PC(clk, rst_n, pc_i, pc_o);

  input clk;
  input rst_n;
  input [`ADDRWIDTH - 1:0] pc_i;
  
  output [`ADDRWIDTH - 1:0] pc_o;
  
  reg [`ADDRWIDTH - 1:0] pc_o;
  
  always@(posedge clk)begin
    if(~rst_n)begin
	  pc_o <= `WIDTH'b0;
    end
    else begin
      pc_o <= pc_i;
    end
  end

endmodule
