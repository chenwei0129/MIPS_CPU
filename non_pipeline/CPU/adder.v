`timescale 1ns/100ps
module adder(src1, src2, result);

  input [7:0] src1;
  input [7:0] src2;
  
  output [7:0] result;
  
  assign result = src1 + src2;

endmodule
