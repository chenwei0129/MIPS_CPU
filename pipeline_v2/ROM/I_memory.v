`timescale 1ns/100ps
module I_memory(addr_d, read_data_q);

  input [`ADDRWIDTH - 1:0] addr_d;
  
  output reg [`WIDTH - 1:0] read_data_q;
  
  reg [`WIDTH - 1:0] MEMORY [0:`MEMSIZE - 1];

  always@(*)begin
    read_data_q = MEMORY[addr_d];
  end

endmodule
