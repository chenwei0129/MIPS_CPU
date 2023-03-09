`timescale 1ns/100ps
module MUX3_32(a, b, c, s, o);

  input [31:0] a;
  input [31:0] b;
  input [31:0] c;
  input [1:0] s;
  
  output [31:0] o;
  
  reg [31:0] o;
  
  always@(*)begin
    case(s)
      2'b00:  o = a;
	  2'b01:  o = b;
      2'b10:  o = c;
	  default:o = 32'b0;
    endcase	
  end
  
endmodule