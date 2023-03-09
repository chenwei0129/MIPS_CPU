`timescale 1ns/100ps
module MUX4_32(a, b, c, d, s, o);

  input [31:0] a;
  input [31:0] b;
  input [31:0] c;
  input [31:0] d;
  input [2:0] s;
  
  output [31:0] o;
  
  reg [31:0] o;
  
  always@(*)begin
    case(s)
      3'b000:  o = a;
	  3'b001:  o = b;
      3'b010:  o = c;
      3'b011:  o = d;
	  default:o = 32'b0;
    endcase	
  end
  
endmodule
