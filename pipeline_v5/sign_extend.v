`timescale 1ns/100ps
module sign_extend(in_i, out_o);

  input [`CONS_ADDR_WIDTH - 1:0] in_i;
  
  output [`WIDTH - 1:0] out_o;
  
  assign out_o = (in_i[15])?{`CONS_ADDR_WIDTH'b1111111111111111, in_i}
                           :{`CONS_ADDR_WIDTH'b0000000000000000, in_i};

endmodule
