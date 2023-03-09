`timescale 1ns/100ps
module D_memory(clk_i, mem_write_d, mem_read_d, addr_d, write_data_d, read_data_q);

  input clk_i;
  input mem_write_d;
  input mem_read_d;
  input [`ADDRWIDTH - 1:0] addr_d;
  input [`WIDTH - 1:0] write_data_d;
  
  output reg [`WIDTH - 1:0] read_data_q;
  
  reg [`WIDTH - 1:0] MEMORY [0:`MEMSIZE - 1];

  always@(posedge clk_i)begin
    if(mem_write_d)
	  MEMORY[addr_d] <= write_data_d;
  end

  always@(*)begin
    if(mem_read_d)
      read_data_q = MEMORY[addr_d];
	else
	  read_data_q = `WIDTH'bz;
  end

endmodule
