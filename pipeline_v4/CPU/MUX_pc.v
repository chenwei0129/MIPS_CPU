`timescale 1ns/100ps
module MUX_pc(a, b, c, s, o);

  input [31:0] a;
  input [31:0] b;
  input [31:0] c;
  input [5:0] s;
  
  output [31:0] o;
  
  assign o = (s==6'b000100)?b:
             (s==6'b000010)?c:
			 a;

endmodule
