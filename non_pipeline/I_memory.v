`timescale 1ns/100ps
module I_memory(clk, addr, ins);

  input clk;
  input [`ADDRWIDTH - 1:0] addr;
  
  output [`WIDTH - 1:0] ins;
  reg [`WIDTH - 1:0] ins;
  
  reg [`WIDTH - 1:0] I_MEM [0:`MEMSIZE - 1];

  always@(*)begin
    ins = I_MEM[addr];
  end

endmodule
