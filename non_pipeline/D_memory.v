`timescale 1ns/100ps
module D_memory(clk, memory_write, memory_read, addr, write_data, read_data);

  input clk;
  input memory_write;
  input memory_read;
  input [`ADDRWIDTH - 1:0] addr;
  input [`WIDTH - 1:0] write_data;
  
  output [`WIDTH - 1:0] read_data;
  
  reg [`WIDTH - 1:0] read_data;
  reg [`WIDTH - 1:0] MEMORY [0:`MEMSIZE - 1];

  always@(negedge clk)begin
    if(memory_write)
	  MEMORY[addr] <= write_data;
  end

  always@(*)begin
    read_data = (memory_read)?MEMORY[addr]:`WIDTH'bz;
  end

endmodule
