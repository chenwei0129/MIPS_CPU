`timescale 1ns/100ps
module MUX_5(a, b, s, o);

  input [4:0] a;
  input [4:0] b;
  input s;
  
  output [4:0] o;
  
  assign o = (s)?b:a;

endmodule
