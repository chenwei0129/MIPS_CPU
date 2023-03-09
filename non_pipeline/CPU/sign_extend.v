`timescale 1ns/100ps
module sign_extend(in, out);

  input [`CONS_ADDR_WIDTH - 1:0] in;
  
  output [`WIDTH - 1:0] out;
  
  assign out = (in[15])?{`CONS_ADDR_WIDTH'b1111111111111111, in}
                       :{`CONS_ADDR_WIDTH'b0000000000000000, in};

endmodule
