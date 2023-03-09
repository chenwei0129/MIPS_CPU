`timescale 1ns/100ps
module if_id_reg(clk_i, rst_n_i, if_id_keep_d, next_addr_d, ins_d, flush_d,
                 next_addr_q, ins_q);

  input clk_i;
  input rst_n_i;
  input if_id_keep_d;
  input [`ADDRWIDTH - 1:0] next_addr_d;
  input [`WIDTH - 1:0] ins_d;
  input flush_d;
  
  output reg [`ADDRWIDTH - 1:0] next_addr_q;
  output reg [`WIDTH - 1:0] ins_q;
  
  always@(negedge clk_i or negedge rst_n_i)begin
    if(~rst_n_i)begin
      next_addr_q <= `ADDRWIDTH'b0;
	  ins_q <= {`OP_WIDTH'b000000, 26'b0};//no op code
    end
	else if(if_id_keep_d)begin
	  next_addr_q <= next_addr_q;
	  ins_q <= ins_q;
	end
	else if(flush_d)begin
      next_addr_q <= `ADDRWIDTH'b0;
	  ins_q <= {`OP_WIDTH'b000000, 26'b0};//no op code
    end
	else begin
	  next_addr_q <= next_addr_d;
	  ins_q <= ins_d;
	end
  end

endmodule