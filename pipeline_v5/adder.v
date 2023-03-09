`timescale 1ns/100ps
module adder(src1_i, src2_i, result_o);

  input [`ADDRWIDTH - 1:0] src1_i;
  input [`ADDRWIDTH - 1:0] src2_i;
  
  output [`ADDRWIDTH - 1:0] result_o;
  
  assign result_o = src1_i + src2_i;

endmodule
