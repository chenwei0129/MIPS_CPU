`timescale 1ns/100ps
`include "def.v"
module D_memory(clk_i, rst_ni, mem_write_d, mem_read_d, addr_d, write_data_d, RAM_busy_o, read_data_q);

  parameter RST  = 1'b0,
            BUSY = 1'b1;

  input clk_i;
  input rst_ni;
  input mem_write_d;
  input mem_read_d;
  input [`ADDRWIDTH - 1:0] addr_d;
  input [`WIDTH - 1:0] write_data_d;
  
  output reg RAM_busy_o;
  output reg [`WIDTH - 1:0] read_data_q;
  
  reg [`WIDTH - 1:0] MEMORY [0:`MEMSIZE - 1];
  reg [7:0] counter;
  reg state;
  reg n_state;
  
  always@(posedge clk_i or rst_ni)begin
    if(~rst_ni)
	  state = RST;
	else
	  state = n_state;
  end
  
  always@(posedge clk_i or rst_ni)begin
    if(~rst_ni)
	  counter = 8'b0;
	else if(n_state==BUSY)
	  counter = counter + 8'd1;
	else if(n_state==RST)
	  counter = 8'd0;
  end
  
  always@(*)begin
    case(state)
	  RST:begin
	    RAM_busy_o = (mem_read_d || mem_write_d)?1'b1:1'b0;
		n_state = (mem_read_d || mem_write_d)?BUSY:RST;
	  end
	  BUSY:begin
	    RAM_busy_o = (counter==`RAM_DELAY)?1'b0:1'b1;
		n_state = (counter==`RAM_DELAY)?RST:BUSY;
	  end
	endcase
  end

  always@(posedge clk_i)begin
    if(mem_write_d && counter==`RAM_DELAY)
	  MEMORY[addr_d] <= write_data_d;
  end

  always@(posedge clk_i)begin
    if(mem_read_d && counter==`RAM_DELAY)
      read_data_q = MEMORY[addr_d];
	else
	  read_data_q = `WIDTH'bz;
  end

endmodule
