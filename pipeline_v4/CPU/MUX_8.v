`timescale 1ns/100ps
module MUX_8(a, b, s, o);

  input [7:0] a;
  input [7:0] b;
  input s;
  
  output [7:0] o;
  
  assign o = (s)?b:a;

endmodule
