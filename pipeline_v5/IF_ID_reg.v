`timescale 1ns/100ps
module IF_ID_reg(clk_i, rst_n_i, keep_d, next_addr_d, ins_d, flush_d, sign_extention_d,
                 next_addr_q, ins_q, sign_extention_q);

  input clk_i;
  input rst_n_i;
  input keep_d;
  input [`ADDRWIDTH - 1:0] next_addr_d;
  input [`WIDTH - 1:0] ins_d;
  input flush_d;
  input [`ADDRWIDTH - 1:0] sign_extention_d;
  
  output reg [`ADDRWIDTH - 1:0] next_addr_q;
  output reg [`WIDTH - 1:0] ins_q;
  output reg [`ADDRWIDTH - 1:0] sign_extention_q;
  
  always@(negedge clk_i or negedge rst_n_i)begin
    if(~rst_n_i)begin
      next_addr_q <= `ADDRWIDTH'b0;
	  ins_q <= {`OP_WIDTH'b000000, 26'b0};//no op code
	  sign_extention_q <= `ADDRWIDTH'd0;
    end
	else if(keep_d)begin
	  next_addr_q <= next_addr_q;
	  ins_q <= ins_q;
	  sign_extention_q <= sign_extention_q;
	end
	else if(flush_d)begin
      next_addr_q <= `ADDRWIDTH'b0;
	  ins_q <= {`OP_WIDTH'b000000, 26'b0};//no op code
	  sign_extention_q <= sign_extention_d;
    end
	else begin
	  next_addr_q <= next_addr_d;
	  ins_q <= ins_d;
	  sign_extention_q <= sign_extention_d;
	end
  end

endmodule