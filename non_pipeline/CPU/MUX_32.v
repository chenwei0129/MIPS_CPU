`timescale 1ns/100ps
module MUX_32(a, b, s, o);

  input [`WIDTH - 1:0] a;
  input [`WIDTH - 1:0] b;
  input s;
  
  output [`WIDTH - 1:0] o;
  
  assign o = (s)?b:a;

endmodule
