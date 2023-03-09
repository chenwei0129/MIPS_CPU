`timescale 1ns/100ps
module PC(clk_i, rst_n_i, stall_i, keep_i, pc_i, pc_o);

  input clk_i;
  input rst_n_i;
  input stall_i;
  input keep_i;
  input [`ADDRWIDTH - 1:0] pc_i;
  
  output reg [`ADDRWIDTH - 1:0] pc_o;
  
  always@(negedge clk_i)begin
    if(~rst_n_i)begin
	  pc_o <= `ADDRWIDTH'b0;
    end
    else if(keep_i || stall_i)begin
      pc_o <= pc_o;
    end
    else begin
      pc_o <= pc_i;
    end	
  end

endmodule
